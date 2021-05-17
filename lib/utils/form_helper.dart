import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_basic/models/hive_data_model.dart';
import 'package:image_picker/image_picker.dart';

class FormHelper {
  static Widget textInput(
    BuildContext context,
    Object? initialValue,
    Function onChanged, {
    bool isTextArea = false,
    bool isNumberInput = false,
    Function? onValidate,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      initialValue: initialValue != null ? initialValue.toString() : "",
      decoration: fieldDecoration(context, "", ""),
      maxLines: !isTextArea ? 1 : 3,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      onChanged: (String value) => onChanged(value),
      validator: (value) {
        return onValidate!(value).toString();
      },
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          // width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          // width: 1,
        ),
      ),
    );
  }

  static Widget selectDropdown(
    BuildContext context,
    String initialValue,
    List<CategoryModel>? data,
    Function onChanged, {
    Function? onValidate,
  }) {
    return Container(
      height: 75,
      padding: const EdgeInsets.only(top: 5),
      child: DropdownButtonFormField<String>(
        hint: const Text("Select"),
        value: initialValue,
        // isDense: true,
        onChanged: (newValue) {
          FocusScope.of(context).requestFocus(FocusNode());
          onChanged(newValue);
        },
        validator: (value) {
          return onValidate!(value).toString();
        },
        decoration: fieldDecoration(context, "", ""),
        items: data!.map<DropdownMenuItem<String>>(
          (CategoryModel data) {
            return DropdownMenuItem<String>(
              value: data.categoryId.toString(),
              child: Text(
                data.categoryName.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Text(
        labelName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }

  static Widget picPicker(String? fileName, Function onFilePicked) {
    Future<PickedFile?> _imageFile;
    final ImagePicker _picker = ImagePicker();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.image, size: 35.0),
                onPressed: () {
                  _imageFile = _picker.getImage(source: ImageSource.gallery);
                  _imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: IconButton(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                icon: const Icon(Icons.camera, size: 35.0),
                onPressed: () {
                  _imageFile = _picker.getImage(source: ImageSource.camera);
                  _imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
          ],
        ),
        if (fileName != null)
          Image.file(
            File(fileName),
            width: 300,
            height: 300,
          )
        else
          Container()
      ],
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    VoidCallback onPressed, {
    bool isConfirmationDialog = false,
    String buttonText2 = '',
    VoidCallback? onPressed2,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
            Visibility(
              visible: isConfirmationDialog,
              child: ElevatedButton(
                onPressed: onPressed2,
                child: Text(buttonText2),
              ),
            ),
          ],
        );
      },
    );
  }
}
