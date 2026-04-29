import 'package:fin_sage/data/datasources/local/local_database_datasource.dart';

class DriftQueryService {
  DriftQueryService(this._local);

  final LocalDatabaseDataSource _local;

  Future<Map<String, double>> monthlySummary() => _local.monthlySummary();
}
