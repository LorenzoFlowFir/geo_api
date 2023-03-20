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
  String _selectedRegions = '';
  List<String> _regions = [];
  List<String> _idRegions = [];

  String _selectedDpt = '';
  List<String> _departement = [];
  List<String> _idDepartement = [];

  @override
  void initState() {
    super.initState();
    fetchRegions().then((regions) {
      setState(() {
        //print(regions);
        _regions = regions;
      });
    });
    fetchCodeRegions().then((idregions) {
      setState(() {
        //print(regions);
        _idRegions = idregions;
      });
    });
    fetchDepartemnts(_selectedRegions).then((dpt) {
      setState(() {
        //print(regions);
        _departement = dpt;
      });
    });
    fetchCodeDepartemnts(_selectedRegions).then((codeDpt) {
      setState(() {
        //print(regions);
        _idDepartement = codeDpt;
      });
    });
  }

  Future<List<String>> fetchRegions() async {
    final response =
        await http.get(Uri.parse('https://geo.api.gouv.fr/regions'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<String> regions = [];
      for (var i = 0; i < data.length; i++) {
        regions.add(data[i]['nom']);
      }
      return regions;
    } else {
      throw Exception('Failed to fetch regions');
    }
  }

  Future<List<String>> fetchCodeRegions() async {
    final response =
        await http.get(Uri.parse('https://geo.api.gouv.fr/regions'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<String> idRegions = [];
      for (var i = 0; i < data.length; i++) {
        idRegions.add(data[i]['code']);
      }
      return idRegions;
    } else {
      throw Exception('Failed to fetch regions');
    }
  }

  Future<List<String>> fetchDepartemnts(codeRegion) async {
    final response = await http.get(
        Uri.parse('https://geo.api.gouv.fr/regions/$codeRegion/departements'));
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

  Future<List<String>> fetchCodeDepartemnts(codeRegion) async {
    final response = await http.get(
        Uri.parse('https://geo.api.gouv.fr/regions/$codeRegion/departements'));
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
                            onTap: () => {
                              _selectedRegions = _idRegions[index],
                              print(_selectedRegions),
                              fetchCodeDepartemnts(_selectedRegions),
                              fetchCodeDepartemnts(_selectedRegions)
                            },
                          );
                        },
                      ),
                    )
            ],
          ),
          Column(
              /*
            children: [
              const Text("Départements"),
              _selectedRegions == ''
                  ? const Center(
                      child: Text("Veuillez sélectionner une région"),
                    )
                  : SizedBox(
                      height: 200,
                      width: 200,
                      child: ListView.builder(
                        itemCount: _departement.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              title: Text(_departement[index]),
                              onTap: () =>
                                  _selectedDpt = _idDepartement[index]);
                        },
                      )),*
FutureBuilder<List<String>>(
                future: fetchDepartemnts(_selectedRegions),
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
            ],*/
              )
        ],
      )),
    );
  }
}
