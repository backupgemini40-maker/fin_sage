import 'package:equatable/equatable.dart';
import 'package:fin_sage/core/errors/error_mapper.dart';
import 'package:fin_sage/data/models/category_model.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:fin_sage/data/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TransactionFilter { all, income, expense }

class TransactionState extends Equatable {
  const TransactionState({
    this.loading = false,
    this.items = const [],
    this.categories = const [],
    this.searchQuery = '',
    this.filter = TransactionFilter.all,
    this.error,
  });

  final bool loading;
  final List<TransactionModel> items;
  final List<CategoryModel> categories;
  final String searchQuery;
  final TransactionFilter filter;
  final String? error;

  List<TransactionModel> get filteredItems {
    final query = searchQuery.trim().toLowerCase();
    return items.where((tx) {
      final typeMatch = switch (filter) {
        TransactionFilter.all => true,
        TransactionFilter.income => tx.type == TransactionType.income,
        TransactionFilter.expense => tx.type == TransactionType.expense,
      };
      if (!typeMatch) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return tx.title.toLowerCase().contains(query);
    }).toList();
  }

  TransactionState copyWith({
    bool? loading,
    List<TransactionModel>? items,
    List<CategoryModel>? categories,
    String? searchQuery,
    TransactionFilter? filter,
    String? error,
  }) {
    return TransactionState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, items, categories, searchQuery, filter, error];
}

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(this._repo) : super(const TransactionState());

  final TransactionRepository _repo;

  Future<void> loadTransactions() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final result = await Future.wait([
        _repo.fetchTransactions(),
        _repo.fetchCategories(),
      ]);
      emit(
        state.copyWith(
          loading: false,
          items: result[0] as List<TransactionModel>,
          categories: result[1] as List<CategoryModel>,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: mapErrorMessage(e)));
    }
  }

  Future<void> createTransaction(TransactionModel model) async {
    emit(state.copyWith(error: null));
    try {
      await _repo.saveTransaction(model);
      final items = await _repo.fetchTransactions();
      emit(state.copyWith(items: items));
    } catch (e) {
      emit(state.copyWith(error: mapErrorMessage(e)));
    }
  }

  Future<void> updateTransaction(TransactionModel model) async {
    emit(state.copyWith(error: null));
    try {
      await _repo.updateTransaction(model);
      if (model.id == null) {
        final items = await _repo.fetchTransactions();
        emit(state.copyWith(items: items));
        return;
      }

      final updated = state.items
          .map((tx) => tx.id == model.id ? model : tx)
          .toList(growable: false);
      emit(state.copyWith(items: updated));
    } catch (e) {
      emit(state.copyWith(error: mapErrorMessage(e)));
    }
  }

  Future<void> removeTransaction(int id) async {
    emit(state.copyWith(error: null));
    try {
      await _repo.deleteTransaction(id);
      final updated = state.items.where((tx) => tx.id != id).toList(growable: false);
      emit(state.copyWith(items: updated));
    } catch (e) {
      emit(state.copyWith(error: mapErrorMessage(e)));
    }
  }

  Future<void> createCategory(CategoryModel model) async {
    emit(state.copyWith(error: null));
    try {
      await _repo.saveCategory(model);
      final categories = await _repo.fetchCategories();
      emit(state.copyWith(categories: categories));
    } catch (e) {
      emit(state.copyWith(error: mapErrorMessage(e)));
    }
  }

  Future<void> archiveCategory(int categoryId) async {
    emit(state.copyWith(error: null));
    try {
      await _repo.archiveCategory(categoryId);
      final categories = await _repo.fetchCategories();
      emit(state.copyWith(categories: categories));
    } catch (e) {
      emit(state.copyWith(error: mapErrorMessage(e)));
    }
  }

  void setSearchQuery(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  void setFilter(TransactionFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  Future<void> recoverCorruptedDatabase() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await _repo.recoverCorruptedDatabase();
      await loadTransactions();
    } catch (e) {
      emit(state.copyWith(loading: false, error: mapErrorMessage(e)));
    }
  }
}
