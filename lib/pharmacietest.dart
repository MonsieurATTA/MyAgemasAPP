/* import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Pharmacie>>? futurePharmacies;

  @override
  void initState() {
    super.initState();
    futurePharmacies = fetchpharmacies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LISTE DES PHARMACIES',
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(),
          child: FutureBuilder(
            future: futurePharmacies,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (snapshot.hasData) {
                return Center(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.local_hospital,
                            color: Colors.green,
                          ),
                          title: Text(snapshot.data![index].nomphar),
                          subtitle: Text(snapshot.data![index].situationgeo),
                          trailing: Text(snapshot.data![index].telphar),
                        ),
                      );
                    },
                  ),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Future<List<Pharmacie>> fetchpharmacies() async {
    {
      var response = await http.get(
        Uri.parse("https://apimoka.agemas96.com/pharmacies"),
      );
      if (response.statusCode == 200) {
        List document = jsonDecode(response.body);

        return document
            .map((pharmacie) => Pharmacie.fromJson(pharmacie))
            .toList();
      } else {
        throw Exception('Erreur lors du chargementdes pharmaciees');
      }
    }
  }
}

class Pharmacie {
  final String nomphar;
  final String situationgeo;
  final String telphar;

  Pharmacie({
    required this.nomphar,
    required this.situationgeo,
    required this.telphar,
  });

  factory Pharmacie.fromJson(Map<String, dynamic> json) {
    return Pharmacie(
      nomphar: (json['nomphar'] as String?) ?? '',
      situationgeo: (json['situationgeo'] as String?) ?? '',
      telphar: (json['telphar'] as String?) ?? '',
    );
  }
}
 */
