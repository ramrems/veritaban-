import 'package:get/get.dart';

import 'database_helper.dart';


class Controller extends GetxController{

 // List<Map<String, dynamic>> searchResults=[]; //Api Service için

  //Map<String, dynamic> ? kitapDetay;//tıklanan kitap

  List<String> okunan_dizi =[];//okuduğum kitapların listesi
  //List<dynamic> takip_edilen =[];//Takip ettiklerimin listesi

  late bool isRated;

  var loggedInOgrenciId=DatabaseHelper.instance.getLoggedInOgrenciId();
  var loggedInOgrenciBranch=DatabaseHelper.instance.getLoggedInOgrenciBranch();
  RxList<String> konular = <String>[].obs;
  //List<Map<String, dynamic>> konular =DatabaseHelper.instance.getKonuAdlariByBranch(loggedInOgrenciBranch);
  //List<dynamic> MyOkunanKitapIDList =[];

  var kitapIDList =[];

  var tappedUserMail;
  var tappedBookId;
  var newPdfUrl;

  RxList<String> My_takip_edilen = <String>[].obs;
  RxList<String> takipci = <String>[].obs;
  RxList<String> takipList = <String>[].obs;

}