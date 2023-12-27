import 'package:flutter/material.dart';
import 'package:ogrenci_takip_sqlite/pageCompleted.dart';

import 'package:ogrenci_takip_sqlite/pageUncompleted.dart';
import 'package:ogrenci_takip_sqlite/Page2.dart';
import 'package:ogrenci_takip_sqlite/Page3.dart';
import 'package:ogrenci_takip_sqlite/page1.dart';

import 'Controller.dart';
import 'database_helper.dart';



const appBarColor= Color(0xFF7C85B5);

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {


  //var sayfaListe=[ProfileDesign(),Page1(),Page2()];
  int secilenIndex=0;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {

    var ekranBilgisi= MediaQuery.of(context);
    final double ekranYuksekligi= ekranBilgisi.size.height;
    final double ekranGenisligi= ekranBilgisi.size.width;

    return Scaffold(
      backgroundColor: Colors.brown[50],
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("YKS KONU TAKİBİ",style: TextStyle(color: Colors.white,fontSize: 30),),
              decoration: BoxDecoration(
                color: Colors.deepOrange[900],
              ),
            ),
/*            ListTile(
              title: Text("Tüm dersler ve konuları",style: TextStyle(color: Colors.deepOrange[900]),),
              leading: Icon(Icons.border_color_outlined,color: Colors.deepOrange[900],),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Page1()));
              },
            ),*/
            ListTile(
              title: Text("Uygulama Kullanıcıları",style: TextStyle(color: Colors.deepOrange[900]),),
              leading: Icon(Icons.people_alt_sharp,color: Colors.deepOrange[900],),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Page2()));
              },
            ),
            ListTile(
              title: Text("Tüm dersler ve konuları",style: TextStyle(color: Colors.deepOrange[900]),),
              leading: Icon(Icons.border_color_outlined,color: Colors.deepOrange[900],),
              onTap: (){
                setState(() {
                  secilenIndex=2;
                  //Get.put(ApiService2().OkunanKitaplariListeyeAtama());
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Page3()));

                });
              },
            ),
            ListTile(
              title: Text("Tamamlanan Konularım",style: TextStyle(color: Colors.deepOrange[900]),),
              leading: Icon(Icons.library_add_check,color: Colors.deepOrange[900],),
              onTap: (){
                setState(() {
                  secilenIndex=2;
                  //Get.put(ApiService2().OkunanKitaplariListeyeAtama());
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PageTamamlanan(selectedBranch:  Controller().loggedInOgrenciBranch)));

                });

              },
            ),
            ListTile(
              title: Text("Tamamlanmayan konularım",style: TextStyle(color: Colors.deepOrange[900]),),
              leading: Icon(Icons.access_time_rounded,color: Colors.deepOrange[900],),
              onTap: (){
                setState(() {
                  secilenIndex=2;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SelectedBranchPage(selectedBranch: Controller().loggedInOgrenciBranch)));

              },
            ),
            ListTile(
              title: Text("Edit Profile",style: TextStyle(color: Colors.deepOrange[900]),),
              leading: Icon(Icons.edit,color: Colors.deepOrange[900],),
              onTap: (){
                setState(() {
                  secilenIndex=2;
                });
                //Navigator.pop(context);
                //Get.to(UserEditScreen());

              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                clipBehavior: Clip.none, alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 280.0,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://i.ytimg.com/vi/jfKfPfyJRdk/maxresdefault.jpg'))),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: 0.0,
                    child: Container(
                      width: ekranGenisligi,
                      height: 52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(icon: Icon(Icons.menu, color: Colors.white,),
                                onPressed: () => scaffoldKey.currentState!.openDrawer(),
                              ),
                              Text('My Profile', style: TextStyle(
                                  color: Colors.white, fontSize: 22),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 220,
                  height: 90,
                ),
           Text("${Controller().loggedInOgrenciBranch} Öğrencisi ",style: TextStyle(fontSize: ekranGenisligi/25,
               fontWeight:FontWeight.bold,color: Colors.green[900] ))
           /*     ElevatedButton.icon(
                  onPressed: () async {

                  },
                  icon: Icon(Icons.library_add),
                  label: Text("Gallery"),
                ),*/
              ],
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: DatabaseHelper.instance.getOgrenciBilgileri(Controller().loggedInOgrenciId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Veri bekleniyor ise loading göster
                   } else if (snapshot.hasError) {
                  //print(Controller().loggedInOgrenciId);
                  print('Error: ${snapshot.error}');
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('öğrenci bilgisi bulunamadı.'));
                } else {
                  Map<String, dynamic>? ogrenci = snapshot.data ;
                  print("ccc ${ogrenci!['name']}");
                   return Padding(
                     padding: EdgeInsets.only(left: 80.0),
                     child: ListTile(
                       title: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                             children:[
                               Padding(
                                 padding: EdgeInsets.all(ekranYuksekligi/100),
                                 child: Text("isim : ${ogrenci['name']}",style: TextStyle(fontSize: ekranGenisligi/20,
                                     fontWeight:FontWeight.bold,color: Colors.deepOrange[900] )),
                               ),
                               Padding(
                                 padding: EdgeInsets.all(ekranYuksekligi/100),
                                 child: Text("soyisim : ${ogrenci['surname']}",style: TextStyle(fontSize: ekranGenisligi/20,
                                     fontWeight:FontWeight.bold,color: Colors.deepOrange[900] )),
                               ),
                               Padding(
                                 padding: EdgeInsets.all(ekranYuksekligi/100),
                                 child: Text("kullanıcı adı : ${ogrenci['username']}",style: TextStyle(fontSize: ekranGenisligi/20,
                                   fontWeight:FontWeight.bold,color: Colors.deepOrange[900] )),
                               ),
                               Padding(
                                 padding: EdgeInsets.all(ekranYuksekligi/100),
                                 child: Text("Sınıf: ${ogrenci['sinif']}",style: TextStyle(fontSize: ekranGenisligi/20,
                                   fontWeight:FontWeight.bold,color: Colors.deepOrange[900] )),
                               ),
                             ],
                           ),
                     ),
                   );
                }
                },),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () async {
          showLogOut();
        },
      ),
    );
  }
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
}
