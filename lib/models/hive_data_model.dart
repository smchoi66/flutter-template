import 'package:hive/hive.dart';

part 'hive_data_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? productName;
  @HiveField(2)
  int? categoryId;
  @HiveField(3)
  String? productDesc;
  @HiveField(4)
  double? price;
  @HiveField(5)
  String? productPic;
}

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  String? categoryName;
  @HiveField(1)
  int? categoryId;

  CategoryModel({
    this.categoryName,
    this.categoryId,
  });
  
}
