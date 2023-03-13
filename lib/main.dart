import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _selectedRegions = [];
  List<String> _regions = [];
  List<String> _idRegions = [];

  @override
  void initState() {
    super.initState();
    fetchRegions().then((regions) {
      setState(() {
        //print(regions);
        _regions = regions;
      });
    });
  }

  Future<List<String>> fetchRegions() async {
    final response =
        await http.get(Uri.parse('https://geo.api.gouv.fr/regions'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<String> regions = [];
      List<String> idRegions = [];
      for (var i = 0; i < data.length; i++) {
        idRegions.add(data[i]['code']);
        regions.add(data[i]['nom']);
      }
      return regions;
    } else {
      throw Exception('Failed to fetch regions');
    }
  }

  Future<List<String>> fetchDepartemnts() async {
    final response = await http
        .get(Uri.parse('https://geo.api.gouv.fr/regions/28/departements'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<String> dpt = [];
      for (var i = 0; i < data.length; i++) {
        dpt.add(data[i]['nom']);
      }
      return dpt;
    } else {
      throw Exception('Failed to fetch dpt');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Row(
        children: [
          Column(
            children: [
              const Text("Régions"),
              _regions.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 200,
                      width: 200,
                      child: ListView.builder(
                        itemCount: _regions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(_regions[index]),
                            //onTap: fetchDepartemnts(idRegion),
                          );
                        },
                      ),
                    )
            ],
          ), /*
          Column(
            children: [
              const Text("Départements"),
              FutureBuilder<List<String>>(
                future: fetchDepartemnts(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data![index]),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          )*/
        ],
      )),
    );
  }
}
