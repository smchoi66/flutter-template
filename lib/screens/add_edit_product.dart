import 'package:flutter/material.dart';
import 'package:flutter_basic/models/hive_data_model.dart';
import 'package:flutter_basic/screens/home.dart';
import 'package:flutter_basic/utils/form_helper.dart';
import 'package:flutter_basic/utils/hive_db_helper.dart';

class AddEditProduct extends StatefulWidget {
  const AddEditProduct({Key? key, this.model, this.isEditMode = false})
      : super(key: key);
  final ProductModel? model;
  final bool isEditMode;

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  late ProductModel model;
  late HiveDBService dbService;
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbService = HiveDBService();

    if (widget.isEditMode && widget.model != null) {
      model = widget.model!;
    } else {
      model = ProductModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        // automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? "Edit Product" : "Add Product"),
      ),
      body: Form(
        key: _globalFormKey,
        child: _formUI(),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHelper.fieldLabel("Product Name"),
              FormHelper.textInput(
                context,
                model.productName,
                (String value) => {
                  model.productName = value,
                },
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return 'Please enter Product Name.';
                  }
                  return null;
                },
              ),
              FormHelper.fieldLabel("Product Description"),
              FormHelper.textInput(
                  context,
                  model.productDesc,
                  (String value) => {
                        model.productDesc = value,
                      },
                  isTextArea: true, onValidate: (value) {
                return null;
              }),
              FormHelper.fieldLabel("Product Price"),
              FormHelper.textInput(
                context,
                model.price?.toString(),
                (String value) => {
                  model.price = double.parse(value),
                },
                isNumberInput: true,
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return 'Please enter price.';
                  }

                  if (value.toString().isNotEmpty &&
                      double.parse(value.toString()) <= 0) {
                    return 'Please enter valid price.';
                  }
                  return null;
                },
              ),
              FormHelper.fieldLabel("Product Category"),
              _productCategory(),
              FormHelper.fieldLabel("Select Product Photo"),
              FormHelper.picPicker(
                model.productPic,
                (file) => {
                  setState(
                    () {
                      model.productPic = file.path.toString();
                    },
                  )
                },
              ),
              btnSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCategory() {
    return FutureBuilder<List<CategoryModel>>(
      future: dbService.getCategories(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CategoryModel>> categories) {
        if (categories.hasData) {
          return FormHelper.selectDropdown(
            context,
            model.categoryId.toString(),
            categories.data,
            (value) => {model.categoryId = int.parse(value.toString())},
            onValidate: (value) {
              if (value == null) {
                return 'Please enter Product Category.';
              }
              return null;
            },
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

  bool validateAndSave() {
    final form = _globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget btnSubmit() {
    return Align(
      // alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          if (validateAndSave()) {
            if (widget.isEditMode) {
              dbService.updateProduct(model.key, model).then((value) {
                FormHelper.showMessage(
                  context,
                  "HIVE CRUD",
                  "Data Modified Successfully",
                  "Ok",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                );
              });
            } else {
              dbService.addProduct(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "HIVE CRUD",
                  "Data Submitted Successfully",
                  "Ok",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                );
              });
            }
          }
        },
        child: Container(
          height: 40.0,
          margin: const EdgeInsets.all(10),
          width: 100,
          color: Colors.blueAccent,
          child: const Center(
            child: Text(
              "Save Product",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
