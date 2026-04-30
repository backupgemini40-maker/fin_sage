import 'package:bloc_test/bloc_test.dart';
import 'package:fin_sage/core/errors/app_error_codes.dart';
import 'package:fin_sage/core/errors/app_exception.dart';
import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/data/models/category_model.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:fin_sage/data/repositories/account_repository.dart';
import 'package:fin_sage/data/repositories/transaction_repository.dart';
import 'package:fin_sage/logic/transactions/transaction_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockTransactionRepository repository;
  late MockAccountRepository accountRepository;

  setUpAll(() {
    registerFallbackValue(
      const CategoryModel(
          id: null, name: 'Fallback', colorHex: '#0D3B66', icon: 'wallet'),
    );
    registerFallbackValue(
      TransactionModel(
        id: 1,
        title: 'Fallback',
        amount: 1,
        date: DateTime(2026, 1, 1),
        categoryId: 1,
        accountId: 1,
        type: TransactionType.expense,
      ),
    );
  });

  const categories = [
    CategoryModel(id: 1, name: 'General', colorHex: '#0D3B66', icon: 'wallet'),
  ];
  const accounts = [
    AccountModel(
      id: 1,
      name: 'Primary',
      type: 'Cash',
      balance: 0,
      colorHex: '#4F8FC0',
      icon: 'account_balance_wallet',
    ),
  ];

  final transactions = [
    TransactionModel(
      id: 1,
      title: 'Lunch',
      amount: 45000,
      date: DateTime(2026, 4, 27),
      categoryId: 1,
      accountId: 1,
      type: TransactionType.expense,
    ),
  ];

  setUp(() {
    repository = MockTransactionRepository();
    accountRepository = MockAccountRepository();
    when(() => accountRepository.getAccounts())
        .thenAnswer((_) async => accounts);
  });

  blocTest<TransactionCubit, TransactionState>(
    'loadTransactions emits loading then populated state',
    build: () {
      when(() => repository.fetchTransactions())
          .thenAnswer((_) async => transactions);
      when(() => repository.fetchCategories())
          .thenAnswer((_) async => categories);
      return TransactionCubit(repository, accountRepository);
    },
    act: (cubit) => cubit.loadTransactions(),
    expect: () => [
      const TransactionState(loading: true),
      TransactionState(
        loading: false,
        items: transactions,
        categories: categories,
        accounts: accounts,
      ),
    ],
  );

  blocTest<TransactionCubit, TransactionState>(
    'loadTransactions emits error when repository throws',
    build: () {
      when(() => repository.fetchTransactions())
          .thenThrow(Exception('db failure'));
      when(() => repository.fetchCategories())
          .thenAnswer((_) async => categories);
      return TransactionCubit(repository, accountRepository);
    },
    act: (cubit) => cubit.loadTransactions(),
    expect: () => [
      const TransactionState(loading: true),
      isA<TransactionState>()
          .having((s) => s.error, 'error', contains('db failure')),
    ],
  );

  blocTest<TransactionCubit, TransactionState>(
    'createCategory emits stable code when repository throws app exception',
    build: () {
      when(
        () => repository.saveCategory(any()),
      ).thenThrow(const AppException('Category already exists',
          code: AppErrorCodes.categoryAlreadyExists));
      return TransactionCubit(repository, accountRepository);
    },
    act: (cubit) => cubit.createCategory(
      const CategoryModel(
          id: null, name: 'Food', colorHex: '#F4A261', icon: 'restaurant'),
    ),
    expect: () => [
      const TransactionState(
          loading: false, items: [], categories: [], error: null),
      const TransactionState(
        loading: false,
        items: [],
        categories: [],
        error: AppErrorCodes.categoryAlreadyExists,
      ),
    ],
  );

  blocTest<TransactionCubit, TransactionState>(
    'createCategory saves category and refreshes categories only',
    build: () {
      when(() => repository.saveCategory(any())).thenAnswer((_) async {});
      when(() => repository.fetchCategories())
          .thenAnswer((_) async => categories);
      return TransactionCubit(repository, accountRepository);
    },
    act: (cubit) => cubit.createCategory(
      const CategoryModel(
          id: null, name: 'Food', colorHex: '#F4A261', icon: 'restaurant'),
    ),
    expect: () => [
      const TransactionState(
          loading: false, items: [], categories: [], error: null),
      TransactionState(categories: categories),
    ],
    verify: (_) => verify(() => repository.saveCategory(any())).called(1),
  );

  blocTest<TransactionCubit, TransactionState>(
    'archiveCategory archives category and refreshes categories only',
    build: () {
      when(() => repository.archiveCategory(2)).thenAnswer((_) async {});
      when(() => repository.fetchCategories())
          .thenAnswer((_) async => categories);
      return TransactionCubit(repository, accountRepository);
    },
    act: (cubit) => cubit.archiveCategory(2),
    expect: () => [
      const TransactionState(
          loading: false, items: [], categories: [], error: null),
      TransactionState(categories: categories),
    ],
    verify: (_) => verify(() => repository.archiveCategory(2)).called(1),
  );

  blocTest<TransactionCubit, TransactionState>(
    'updateTransaction refreshes items from repository',
    build: () {
      when(() => repository.updateTransaction(any())).thenAnswer((_) async {});
      when(() => repository.fetchTransactions()).thenAnswer(
        (_) async => [
          TransactionModel(
            id: 1,
            title: 'Lunch Updated',
            amount: 50000,
            date: DateTime(2026, 4, 27),
            categoryId: 1,
            accountId: 1,
            type: TransactionType.expense,
          ),
        ],
      );
      when(() => repository.fetchCategories())
          .thenAnswer((_) async => categories);
      return TransactionCubit(repository, accountRepository);
    },
    seed: () => TransactionState(items: transactions, categories: categories),
    act: (cubit) => cubit.updateTransaction(
      TransactionModel(
        id: 1,
        title: 'Lunch Updated',
        amount: 50000,
        date: DateTime(2026, 4, 27),
        categoryId: 1,
        accountId: 1,
        type: TransactionType.expense,
      ),
    ),
    expect: () => [
      isA<TransactionState>()
          .having((s) => s.loading, 'loading', true)
          .having((s) => s.items, 'previous items', transactions)
          .having((s) => s.categories, 'categories', categories),
      isA<TransactionState>()
          .having((s) => s.items.first.title, 'updated title', 'Lunch Updated')
          .having((s) => s.categories, 'categories', categories)
          .having((s) => s.accounts, 'accounts', accounts),
    ],
    verify: (_) {
      verify(() => repository.updateTransaction(any())).called(1);
      verify(() => repository.fetchTransactions()).called(1);
      verify(() => repository.fetchCategories()).called(1);
    },
  );

  blocTest<TransactionCubit, TransactionState>(
    'setSearchQuery and setFilter update ui state through cubit',
    build: () => TransactionCubit(repository, accountRepository),
    act: (cubit) {
      cubit.setSearchQuery('lunch');
      cubit.setFilter(TransactionFilter.expense);
    },
    expect: () => [
      const TransactionState(searchQuery: 'lunch'),
      const TransactionState(
          searchQuery: 'lunch', filter: TransactionFilter.expense),
    ],
  );
}
