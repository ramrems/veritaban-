import 'package:flutter/material.dart';
import '../User.dart';
import '../database_helper.dart';
import '../drawer.dart';


InputDecoration decorfonk(String labelText){
  return InputDecoration(
// hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
    filled: true,
    //fillColor: ColorOptions.C_background,
    labelText: labelText,
//alignLabelWithHint: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 3,),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(),
    ),
    labelStyle: TextStyle(),
    border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        )
    ),
  );
}
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  bool loading=false;

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: ekranGenisligi/4,
                  ),
                  //Icon(Icons.person),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,bottom: ekranYuksekligi/30),
                    child: TextField(
                        controller: usernameController,
                        decoration: decorfonk("username")
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,bottom: ekranYuksekligi/30),
                    child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration:decorfonk("Password")
                    ),
                  ),
                  loading? CircularProgressIndicator(): Container(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                       // backgroundColor: ColorOptions.C_background,
                      ),
                      child: Text("Log in",
                        style: TextStyle(fontSize: ekranGenisligi/25,),),
                      onPressed: () async {
                        setState(() {
                          loading=true;
                        });
                        if(usernameController.text==""||passwordController==""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required!"),backgroundColor: Colors.red,));
                        }
                        else{
                            await DatabaseHelper.instance.login(User(username: usernameController.text, password: passwordController.text),context);
                            //print("success");

                        }
                        setState(() {
                          loading=false;
                        });
                        //print("Giriş yapıldı");
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=> DrawerScreen()));

                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
