import 'package:flutter/material.dart';
import 'Topic.dart';
import 'database_helper.dart'; // Database modelinize uygun import yapın

class SubjectsPage extends StatelessWidget {
  final String subjectName;

  SubjectsPage({required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getKonuAdlariByDers(subjectName),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          print("fdgfg ${snapshot.data}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No topics found for $subjectName'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> topic = snapshot.data![index];
              return ListTile(
                title: Text(topic['konu_adi']),
                // Add other ListTile customization if needed
              );
            },
          );
        },
      ),
    );
  }
}
