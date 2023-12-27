import 'package:flutter/material.dart';
import '../database_helper.dart';

/*void main() {
  runApp(Authentication());
}*/

/*class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}*/

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
 // final DatabaseHelper _databaseService = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*ElevatedButton(
              onPressed:(),
              child: Text('Add User'),
            ),*/
            /*ElevatedButton(
              onPressed: DatabaseHelper.instance.login,
              child: Text('Login'),
            ),*/
          ],
        ),
      ),
    );
  }

}
