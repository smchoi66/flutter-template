import 'package:flutter/material.dart';
import 'package:flutter_basic/models/hive_data_model.dart';
import 'package:flutter_basic/screens/add_edit_product.dart';
import 'package:flutter_basic/utils/form_helper.dart';
import 'package:flutter_basic/utils/hive_db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HiveDBService dbService;

  @override
  void initState() {
    super.initState();
    dbService = HiveDBService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("HIVE CRUD"),
      ),
      body: _fetchData(),
    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<ProductModel>>(
      future: dbService.getProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> products) {
        if (products.hasData) {
          return _buildUI(products.data!);
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildUI(List<ProductModel> products) {
    final List<Widget> widgets = <Widget>[];

    widgets.add(
      Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditProduct(),
              ),
            );
          },
          child: Container(
            height: 40.0,
            width: 100,
            color: Colors.blueAccent,
            child: const Center(
              child: Text(
                "Add Product",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildDataTable(products)],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget _buildDataTable(List<ProductModel> model) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text(
            "Product Name",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Price",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Action",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      sortColumnIndex: 1,
      rows: model
          .map(
            (data) => DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    data.productName!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    data.price.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditProduct(
                                  isEditMode: true,
                                  model: data,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            FormHelper.showMessage(
                              context,
                              "SQFLITE CRUD",
                              "Do you want to delete this record?",
                              "Yes",
                              () {
                                dbService.deleteProduct(data).then((value) {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                });
                              },
                              buttonText2: "No",
                              isConfirmationDialog: true,
                              onPressed2: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
