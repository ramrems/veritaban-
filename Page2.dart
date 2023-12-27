import 'package:flutter/material.dart';
import 'User.dart';
import 'database_helper.dart';

//void main() => runApp(SqliteApp());

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final textController = TextEditingController();
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    void showLogOut() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("LogOut"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Çıkış Yapmak İstiyor Musunuz?",style: TextStyle(),),
            ],
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.pop(context);
                await DatabaseHelper.instance.signOut(context);
              },
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Alert dialogu kapat
              },
              child: Text("NO"),
            ),
          ],
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Uygulama Kullanıcıları'),
        ),

        body:  Center(
          child: FutureBuilder<List<User>>(
              future: DatabaseHelper.instance.getUsers(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<User>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Loading...'));
                }
                return snapshot.data!.isEmpty
                    ?Center(child: Text("NO User in List"))
                    :ListView(
                  children: snapshot.data!.map((user) {
                    return Center(
                      child: Card(
                        color: selectedId == user.id
                            ? Colors.white70
                            : Colors.white,
                        child: ListTile(
                          title: Text(user.username),
                          onTap: () {
                            setState(() {
                              if (selectedId == null) {
                                textController.text = user.username;
                                selectedId = user.id;
                              } else {
                                textController.text = '';
                                selectedId = null;
                              }
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              DatabaseHelper.instance.removeUser(user.id!);
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),

        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.logout),
          onPressed: () async {
            showLogOut();
          },
        ),

      );
  }
}