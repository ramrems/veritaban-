import 'package:flutter/material.dart';
import 'package:ogrenci_takip_sqlite/subjectsPage.dart';

import 'User.dart';
import 'database_helper.dart';

//void main() => runApp(SqliteApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Page3(),
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final textController = TextEditingController();
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dersler'),
      ),

      body:  Center(
        child: FutureBuilder<List<Ders>>(
            future: DatabaseHelper.instance.getDersler(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Ders>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ?Center(child: Text("NO subject in List"))
                  :ListView(
                children: snapshot.data!.map((ders) {
                  return Center(
                    child: Card(
                      color: selectedId == ders.dersId
                          ? Colors.white70
                          : Colors.white,
                      child: ListTile(
                        title: Text(ders.dersAdi),
                        onTap: () {
/*                          setState(() {

                          });*/
                          // Navigate to the TopicsPage and pass the subjectName
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectsPage(
                                subjectName: ders.dersAdi,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}