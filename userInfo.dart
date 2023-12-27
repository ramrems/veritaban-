import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ogrenci_takip_sqlite/Authentication/login.dart';
import 'package:ogrenci_takip_sqlite/drawer.dart';

import '../Controller.dart';
import '../KonuListeleri.dart';
import '../User.dart';
import '../database_helper.dart';



class UserInfoScreen extends StatefulWidget {
  final String username;
  final String password;

  UserInfoScreen({required this.username, required this.password});

  //UserInfoScreen(this.username,this.password);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState(username, password);
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late final String username;
  late final String password;
  late Controller _controller; // _controller sınıfınızın bir örneğini saklamak için

  _UserInfoScreenState(this.username,this.password);

  TextEditingController nameController=TextEditingController();
  TextEditingController surnameController=TextEditingController();
  TextEditingController bransController=TextEditingController();
  TextEditingController sinifController=TextEditingController();
  //TextEditingController departmentController=TextEditingController();
  String imageUrl='resimler/person_icon.png';

  bool loading=false;
  String dropdownValue_brans="";
  List<String> bransList = ['AYT_SAY', 'AYT_SOZ', 'AYT_EA','AYT_Dil', 'TYT'];

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      //backgroundColor: Colors.indigo,
      appBar: AppBar(
        // backgroundColor: Colors.indigo,
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
                  SizedBox(
                    width: 50,
                    height: 50,
                  ),
             /*     Icon(
                    Icons.person,
                    size: ekranGenisligi/4,
                  ),*/
                  //Icon(Icons.person),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,top:ekranYuksekligi/30,bottom: ekranYuksekligi/30),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        //fillColor: Colors.white,
                        labelText: "name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,bottom: ekranYuksekligi/30),
                    child: TextField(
                      controller:surnameController,
                      decoration: const InputDecoration(
                        filled: true,
                        //fillColor: Colors.white,
                        labelText: "surname",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,bottom: ekranYuksekligi/30),
                    child: Container(
                      //width: ekranGenisligi/2,
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                         isExpanded: true,
                         // dropdownColor: Colors.white , //color_beyaz_ton,
                          hint: Padding(
                            padding: EdgeInsets.only(left: ekranGenisligi/30),
                            child: Text("YKS Branşı seçiniz",style: TextStyle(fontWeight: FontWeight.bold,),
                            ),
                          ),
                          value:dropdownValue_brans == "" ? null : dropdownValue_brans,
                          icon: Padding(
                            padding: EdgeInsets.only(right: ekranGenisligi/50),
                            child: const Icon(Icons.arrow_drop_down),
                          ),
                          elevation: 16,
                          onChanged: (String? value) {
                            //dropdownValue_brans="";
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue_brans = value ?? "";
                              bransController.text=dropdownValue_brans;
                              print(dropdownValue_brans);
                            });
                          },
                          items: bransList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.only(left: ekranGenisligi/30),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left:ekranYuksekligi/20,right:ekranYuksekligi/20,bottom: ekranYuksekligi/30),
                    child: TextField(
                      controller: sinifController,
                      decoration: InputDecoration(
                        filled: true,
                        //fillColor: Colors.white,
                        labelText: "sınıf",
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                  ),

                  loading? CircularProgressIndicator():Container(
                    height: 50,
                    width: 150,
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          loading=true;
                        });
                        if(nameController.text==""|| surnameController.text== "" || bransController.text=="" || sinifController.text==""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required!"),backgroundColor: Colors.red,));
                        }

                        else{
                          await DatabaseHelper.instance.addUser(User(username: username, password:password));
                          await DatabaseHelper.instance.addStudent(Student(name: nameController.text, surname: surnameController.text,
                              sinif: sinifController.text));
                          print("success ogrenci");
                          print("loggedInOgrenciId Boş gelecek kesin ${Controller().loggedInOgrenciId}");

                          await DatabaseHelper.instance.addBrans(Brans(brans: bransController.text ));
                          print("success brans");

                          print("success");
                          await DatabaseHelper.instance.login(
                            User(username: username, password: password),
                            context,
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DrawerScreen()));
                          loading=false;


                          String? loggedInOgrenciBranch = Controller().loggedInOgrenciBranch;
                          print("hhhhhh $loggedInOgrenciBranch");
                          int? yksBransId = await DatabaseHelper.instance.getBranchIdByName(loggedInOgrenciBranch);

                          List<String> tumKonuAdlari=[] ;
                          List<int> tytKonuIds=[] ;
                          List<int> tumKonuIds=[] ;
                          List<Map<String, dynamic>> other=await DatabaseHelper.instance.getAllTopicsByBranch(loggedInOgrenciBranch);
                          List<Map<String, dynamic>> tyt=await DatabaseHelper.instance.getTYTTopics();

                          for(int i=0;i<other.length;i++){
                            tumKonuAdlari.add(other.elementAt(i)['konu_adi']);
                            tumKonuIds.add(other.elementAt(i)['konu_id']);
                          }
                          for(int i=0;i<tyt.length;i++){
                            tytKonuIds.add(tyt.elementAt(i)['konu_id']);
                          }
                          await DatabaseHelper.instance.insertOgrenciKonuForBrans(Controller().loggedInOgrenciId, tumKonuIds,tytKonuIds, yksBransId!, 'Tamamlanmadi');
                          //AuthService().userRepo.createUser(user);
                        }
                    /*    setState(() {
                          loading=false;
                        });*/
                      },
                      child: Icon(Icons.arrow_forward_outlined
                        /*style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[200],
                        ),*/
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
