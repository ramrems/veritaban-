
import 'package:flutter/material.dart';
import 'package:ogrenci_takip_sqlite/Authentication/userInfo.dart';
import 'login.dart';

InputDecoration decorfonk(String labelText){
  return InputDecoration(
// hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
    filled: true,
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  TextEditingController idController=TextEditingController();
  String imageUrl='resimler/person_icon.png';

  bool loading=false;

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(


      appBar: AppBar(
        //backgroundColor: Colors.indigo,
        title: Text("Register Screen"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Container(
                     height: 150,
                     width: 150,
                     child: CircleAvatar(
                       child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvNkMJ8Ju6sWhNZEoqJK70NLlNjCw9JfW3jw&usqp=CAU',
                       fit: BoxFit.cover ,),
            ),
                  ),
                  //Icon(Icons.person),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,top:ekranYuksekligi/30,bottom: ekranYuksekligi/30),
                    child: TextField(
                      controller: usernameController,
                      cursorColor: Colors.black,
                      decoration: decorfonk("Username"),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,bottom: ekranYuksekligi/30),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: decorfonk("Password"),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,bottom: ekranYuksekligi/30),
                    child: TextField(
                      obscureText: true,
                      controller: confirmPasswordController,
                      decoration: decorfonk("Confirm Password"),
                    ),
                  ),
                  loading? CircularProgressIndicator():Container(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      ),
                      child: Text("Submit",
                        style: TextStyle(fontSize: ekranGenisligi/25,),),
                      onPressed: () async {
                        setState(() {
                          loading=true;
                        });
                        if(usernameController.text=="" || passwordController==""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required!"),backgroundColor: Colors.red,));
                        }
                        else if(passwordController.text!=confirmPasswordController.text){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords don't match!"),backgroundColor: Colors.red,));
                        }
                        else{

                            print("success");
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> UserInfoScreen(username: usernameController.text, password: passwordController.text)));
                          //}
                        }
                        setState(() {
                          loading=false;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                      }
                      ,child: Text("Already have a account? Login here",
                      style: TextStyle(
                        //color: ColorOptions.C_search_appBar,
                        fontWeight: FontWeight.bold,
                        fontSize: ekranGenisligi/30,
                      ),
                    ),
                    ),
                  ),
                  Divider(),
                  /*loading? CircularProgressIndicator():SignInButton(Buttons.Google,text: "Continue with Google",
                      onPressed:() async{
                        setState(() {
                          loading=true;
                        });
                        await AuthService().SignInWithGoogle();
                        setState(() {
                          loading=false;
                        });
                      })*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
