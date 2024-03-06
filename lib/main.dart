import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:flutter_application_1/models/products.dart';
import 'models/launch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme:
        //     ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 216, 230, 228)),
        useMaterial3: true,
      ),
      home: const UsersScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key, required this.title});

  final String title;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<Launch>> futureItemsList;

  Future<List<Launch>> fetchItems() async {
    Uri uriobject = Uri.parse('https://api.spacexdata.com/v3/missions');

    final response = await http.get(uriobject);

    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      print('hi');

      List<Launch> itemsList = List<Launch>.from(
        parsedListJson
            .map<Launch>(
              (dynamic prod) => Launch.fromJson(prod),
            )
            .toList(),
      );
      print(itemsList);
      return itemsList;
    } else {
      throw Exception('Failed to find json');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureItemsList = fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 12, 82, 82),
          // leading: const Text('Space Missions'),
          title: const Text('Space Missions',
              style: TextStyle(color: Colors.white)),

          centerTitle: false,
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: futureItemsList,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data![index];
                      var generatedColor =
                          Random().nextInt(Colors.primaries.length);
                      Colors.primaries[generatedColor];
                      return AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.missionName!,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          item.description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                print("here");
                                              },
                                              child: Row(
                                                children: [
                                                  Text("More",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 15)),
                                                  Icon(
                                                    Icons.arrow_downward,
                                                    color: Colors.blue,
                                                  )
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 239, 234, 234)),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: AspectRatio(
                                            aspectRatio: 3 / 1,
                                            child: GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2),
                                                shrinkWrap: true,
                                                itemCount:
                                                    item.payloadIds!.length,
                                                itemBuilder: (context, index) {
                                                  var display =
                                                      item.payloadIds![index];
                                                  return Chip(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      backgroundColor:
                                                          Colors.primaries[
                                                              Random().nextInt(
                                                                  Colors
                                                                      .primaries
                                                                      .length)],
                                                      label: Text(display));
                                                }),
                                          ),
                                        ),
                                      ]),
                                )),
                          ));
                    });
              } else
                return const CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget buildItemWidget(String item) {
    print(item);
    return Image.network(
      item,
      height: 120,
      width: 130,
    );
  }
}
