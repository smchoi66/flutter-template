import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> getUserData() async {
    final response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    final jsonData = jsonDecode(response.body);
    final List<User> users = [];
    if (jsonData != null) {
      for (final u in jsonData) {
        final User user = User(
            u['name'] as String, u['email'] as String, u['username'] as String);
        users.add(user);
      }
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<User>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (_, int index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].userName),
                    trailing: Text(snapshot.data![index].userName),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final String userName;

  User(this.name, this.email, this.userName);
}
