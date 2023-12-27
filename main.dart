import 'package:flutter/material.dart';
import 'package:ogrenci_takip_sqlite/Authentication/register.dart';
import 'Controller.dart';
import 'database_helper.dart';
import 'drawer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Create an instance of DatabaseHelper
  DatabaseHelper helper = DatabaseHelper.instance;
  // Call the executeInsertCommands method to perform insertions
  await helper.executeInsertCommands();
  Controller();
  runApp( MyApp());
  Controller();

}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
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
  int? selectedId;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.checkPreviousLogin(), // Bu fonksiyon kullanıcının varlığını kontrol eder
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Veri bekleniyorsa bekletme göster
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Kullanıcı varsa ManageScreen'e, yoksa RegisterScreen'e yönlendir
          if (snapshot.data == true) {
            return DrawerScreen();
          } else {
            return RegisterScreen();
          }
        }
      },
    );
  }
}
