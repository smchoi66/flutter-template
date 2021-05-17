import 'package:flutter/material.dart';
import 'package:flutter_basic/models/hive_data_model.dart';
import 'package:flutter_basic/screens/home.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  var initialized = false;
  if (!initialized) {
    initialized = true;
    await Hive.initFlutter();
    Hive.registerAdapter<ProductModel>(ProductModelAdapter());
    Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Template',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
