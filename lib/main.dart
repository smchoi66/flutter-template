import 'package:flutter/material.dart';
import 'package:flutter_basic/models/facts_response.dart';
import 'package:flutter_basic/services/facts_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  FactsService factsService = FactsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Template'),
      ),
      body: FutureBuilder(
        future: factsService.getFacts(),
        builder: (_, AsyncSnapshot<FactsResponse?> snapshot) {
          if (snapshot.hasData) {
            final factsResponse = snapshot.data!;
            return ListView.builder(
              itemCount: factsResponse.facts?.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(factsResponse.facts![index].title!),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
