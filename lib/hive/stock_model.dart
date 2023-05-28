import 'package:hive/hive.dart';

part 'stock_model.g.dart';

@HiveType(typeId: 0)
class Stock extends HiveObject {
  @HiveField(0)
  late String companyName;

  @HiveField(1)
  late double sharePrice;
}