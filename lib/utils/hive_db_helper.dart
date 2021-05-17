import 'package:flutter_basic/models/hive_data_model.dart';
import 'package:hive/hive.dart';

class HiveDBService {
  final String _productBoxName = 'products';
  final String _categoryBoxName = 'categories';

  Future<Box<ProductModel>> productBox() async {
    final box = await Hive.openBox<ProductModel>(_productBoxName);
    return box;
  }

  Future<Box<CategoryModel>> categoryBox() async {
    final box = await Hive.openBox<CategoryModel>(_categoryBoxName);
    return box;
  }

  Future<bool> addProduct(ProductModel product) async {
    final box = await productBox();
    bool isSaved = false;
    final int inserted = await box.add(product);
    if (inserted == 1) {
      isSaved = true;
    } else {
      isSaved = false;
    }

    return isSaved;
  }

  Future<List<ProductModel>> getProducts() async {
    final box = await productBox();
    final List<ProductModel> products = box.values.toList();
    return products;
  }

  Future<List<CategoryModel>> getCategories() async {
    final box = await categoryBox();
    List<CategoryModel> categories = box.values.toList();
    if (categories.isEmpty) {
      await box.add(CategoryModel(categoryId: 1, categoryName: 'T-Shirt'));
      await box.add(CategoryModel(categoryId: 2, categoryName: 'Shirt'));
      await box.add(CategoryModel(categoryId: 3, categoryName: 'Trouser'));
      await box.add(CategoryModel(categoryId: 3, categoryName: 'Shoes'));
    }
    return categories = box.values.toList();
  }

  Future<void> updateProduct(dynamic key, ProductModel product) async {
    final box = await productBox();
    await box.put(key, product);
  }

  Future<void> deleteProduct(dynamic key) async {
    final box = await productBox();
    await box.delete(key);
  }
}
