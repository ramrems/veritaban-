import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ogrenci_takip_sqlite/Controller.dart';
import 'package:ogrenci_takip_sqlite/drawer.dart';
import 'package:ogrenci_takip_sqlite/KonuListeleri.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'Authentication/register.dart';
import 'Topic.dart';
import 'User.dart';

class DatabaseHelper {

  int? _loggedInOgrenciId;
  String? _loggedInOgrenciBranch;

  void setLoggedInOgrenciId(int ogrenciId) {
    _loggedInOgrenciId = ogrenciId;
  }

  int? getLoggedInOgrenciId() {
    return _loggedInOgrenciId;
  }

  void setLoggedInOgrenciBranch(String ogrencBranch) {
    _loggedInOgrenciBranch = ogrencBranch;
  }

  String? getLoggedInOgrenciBranch() {
    return _loggedInOgrenciBranch;
  }

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get usersDatabase  async => _database ??= await _initUsersDatabase();

  Future<void> executeInsertCommands() async {
    Database db = await usersDatabase; // Change this to your desired database

    try {
      await db.transaction((txn) async {
        await txn.execute('INSERT INTO dersler (dersAdi) VALUES (\'türkçe\')');
        await txn.execute('INSERT INTO dersler (dersAdi) VALUES (\'matematik\')');
        await txn.execute('INSERT INTO dersler (dersAdi) VALUES (\'fizik\')');
        await txn.execute('INSERT INTO dersler (dersAdi) VALUES (\"kimya\")');
        await txn.execute('INSERT INTO dersler (dersAdi) VALUES (\'biyoloji\')');
        await txn.execute('INSERT INTO dersler (dersAdi) VALUES (\'tarih\')');
        await txn.execute('INSERT INTO dersler (dersAdi) VALUES (\'coğrafya\')');
        await txn.execute('INSERT INTO dersler (dersAdi) VALUES (\'felsefe\')');
      });

      print('Insert commands executed successfully.');
      // Insert coğrafya topics for TYT
     await insertTopicsForBrans(Konular.topicsTYTCografya,7,1,'TYT');
     await insertTopicsForBrans(Konular.topicsTYTMat,2,1,'TYT');
     await insertTopicsForBrans(Konular.topicsAYT_SAYMat,2,3,'AYT_SAY');
/*
      String? loggedInOgrenciBranch = Controller().loggedInOgrenciBranch;
      print("hhhhhh $loggedInOgrenciBranch");
      int? yksBransId = await DatabaseHelper.instance.getBranchIdByName(loggedInOgrenciBranch);

      List<int> konuIds = await DatabaseHelper.instance.insertTopicsForBrans(Konular.topicsTYTCografya, 7, 1, 'TYT');
      await DatabaseHelper.instance.insertOgrenciKonuForBrans(Controller().loggedInOgrenciId, konuIds, yksBransId!, 'Tamamlanmadi');*/

// Access the generated konu_ids
     /* for (int konuId in konuIds) {
        print('Generated konu_id: $konuId');
      }*/

      // await DatabaseHelper.instance.fillOgrenciKonu(Controller().loggedInOgrenciId,Konular.topicsTYTCografya.cast<Map<String, dynamic>>());
      // await DatabaseHelper.instance.fillOgrenciKonu(Controller().loggedInOgrenciId,Konular.topicsTYTMat.cast<Map<String, dynamic>>());
      // await DatabaseHelper.instance.fillOgrenciKonu(Controller().loggedInOgrenciId,Konular.topicsAYTMat.cast<Map<String, dynamic>>());
      print('Insert commands executed successfully.');

    } catch (e) {
      print('Error executing insert commands: $e');
    }
  }

  Future<List<int>> insertTopicsForBrans(List<String> topics, int dersId, int yariyili, String brans) async {
    Database db = await usersDatabase;
    List<int> konuIds = [];

    await Future.forEach(topics, (topic) async {
      int konuId = await db.insert(
        '$brans',
        {'konu_adi': topic, 'yariyili': yariyili, 'dersId': dersId},
      );
      konuIds.add(konuId);
    });

    return konuIds;
  }
  Future<void> insertOgrenciKonuForBrans(int? ogrenciId, List<int> konuIds,List<int> TYTkonuIds, int yksBransId, String durumu) async {
    Database db = await usersDatabase;

    if(yksBransId==1){
      try {
        await Future.forEach(TYTkonuIds, (konuId) async {
          await db.insert(
            'ogrenci_konu',
            {
              'ogrenci_id': ogrenciId,
              'konu_id': konuId,
              'yks_brans_id': yksBransId,
              'durumu': durumu,
            },
          );
        });

        print('Ogrenci Konu inserted successfully.');
      } catch (e) {
        print('Error inserting Ogrenci Konu: $e');
      }
    }
    else{
      try {
        await Future.forEach(konuIds, (konuId) async {
          await db.insert(
            'ogrenci_konu',
            {
              'ogrenci_id': ogrenciId,
              'konu_id': konuId,
              'yks_brans_id': yksBransId,
              'durumu': durumu,
            },
          );
        });

        await Future.forEach(TYTkonuIds, (konuId) async {
          await db.insert(
            'ogrenci_konu',
            {
              'ogrenci_id': ogrenciId,
              'konu_id': konuId,
              'yks_brans_id':'TYT',
              'durumu': durumu,
            },
          );
        });

        print('Ogrenci Konu inserted successfully.');
      } catch (e) {
        print('Error inserting Ogrenci Konu: $e');
      }

    }

  }

  Future<Database> _initUsersDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE dersler (
  dersId INTEGER PRIMARY KEY AUTOINCREMENT,
  dersAdi VARCHAR(150) NOT NULL)'''
    );
    await db.execute(
        '''CREATE TABLE yksBrans (
    brans_id INTEGER PRIMARY KEY AUTOINCREMENT,
    brans VARCHAR(20) CHECK (brans IN ('AYT_SAY', 'AYT_SOZ', 'AYT_EA','AYT_Dil', 'TYT')))'''
    );
    await db.execute(
        '''CREATE TABLE ogrenciler (
    ogrenci_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50),
    surname VARCHAR(50),
    sinif INT,
    brans_id INT,
    FOREIGN KEY (brans_id) REFERENCES yksBrans(brans_id))'''
    );
    await db.execute(
        '''CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(10),
    ogrenci_id INT,
    FOREIGN KEY (ogrenci_id) REFERENCES ogrenciler(ogrenci_id))'''
    );
    await db.execute(
        '''CREATE TABLE TYT (
    konu_id INTEGER PRIMARY KEY AUTOINCREMENT,
    konu_adi VARCHAR(150),
    yariyili INTEGER,
    dersId INTEGER,
    FOREIGN KEY (dersId) REFERENCES dersler(dersId))'''
    );
    await db.execute(
        '''CREATE TABLE AYT_SAY (
    konu_id INTEGER PRIMARY KEY AUTOINCREMENT,
    konu_adi VARCHAR(150),
    yariyili INTEGER,
    dersId INTEGER,
    FOREIGN KEY (dersId) REFERENCES dersler(dersId))'''
    );
    await db.execute(
        '''CREATE TABLE AYT_SOZ (
    konu_id INTEGER PRIMARY KEY AUTOINCREMENT,
    konu_adi VARCHAR(150),
    yariyili INTEGER,
    dersId INTEGER,
    FOREIGN KEY (dersId) REFERENCES dersler(dersId))'''
    );
    await db.execute(
        '''CREATE TABLE AYT_EA (
    konu_id INTEGER PRIMARY KEY AUTOINCREMENT,
    konu_adi VARCHAR(150),
    yariyili INTEGER,
    dersId INTEGER,
    FOREIGN KEY (dersId) REFERENCES dersler(dersId))'''
    );
    await db.execute(
        '''CREATE TABLE AYT_Dil (
    konu_id INTEGER PRIMARY KEY AUTOINCREMENT,
    konu_adi VARCHAR(150),
    yariyili INTEGER,
    dersId INTEGER,
    FOREIGN KEY (dersId) REFERENCES dersler(dersId))'''
    );
    await db.execute(
        '''CREATE TABLE ogrenci_konu (
    ogr_konu_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ogrenci_id INTEGER,
    konu_id INTEGER,
    yks_brans_id INTEGER,
    durumu TEXT CHECK(durumu IN ('Tamamlandi', 'Tamamlanmadi')) DEFAULT 'Tamamlanmadi',
    FOREIGN KEY (ogrenci_id) REFERENCES ogrenciler(ogrenci_id),
    FOREIGN KEY (konu_id) REFERENCES TYT(konu_id),
    FOREIGN KEY (yks_brans_id) REFERENCES ogrenciler(brans_id))'''
    );
  }

  Future<List<Topic>> getTopicsBySubject(String subjectName) async {
    Database db = await instance.usersDatabase;

    var subjectQueryResult = await db.query('dersler', where: 'dersAdi = ?', whereArgs: [subjectName]);
    print("subjectQueryResult${subjectQueryResult}");
    if (subjectQueryResult.isEmpty) {
      print("if e girip null liste oldu");
      return []; // Eğer ders bulunamazsa boş bir liste döndür
    }
    print("if e girmedi");

    int dersId = subjectQueryResult.first['dersId'] as int;

    // İlgili dersId'ye ait konuları almak için sorgu
    var topicsQueryResult = await db.query('TYT', where: 'dersId = ?', whereArgs: [dersId]);
    print("topicsQueryResult${topicsQueryResult}");

    List<Topic> topicList = topicsQueryResult.isNotEmpty
        ? topicsQueryResult.map((c) => Topic(
      id: c['konu_id'] as int,
      konu_adi: c['konu_adi'] as String,
      dersId: c['dersId'] as int,
      yariyili: c['yariyili'] as int,
    )).toList()
        : [];

    return topicList;
  }

  Future<List<Topic>> getTopics(int dersId) async {
    final Database db = await instance.usersDatabase;
    final List<Map<String, dynamic>> topics = await db.rawQuery('''
    SELECT * FROM TYT
    UNION
    SELECT * FROM AYT_SAY
    WHERE dersId = ?
  ''', [dersId]);

    List<Topic> topicList = topics.isNotEmpty
        ? topics.map((map) => Topic(
      id: map['konu_id'] as int,
      konu_adi: map['konu_adi'] as String,
      dersId: map['dersId'] as int,
      yariyili: map['yariyili'] as int,
    )).toList()
        : [];

    return topicList;
  }
  Future<List<Map<String, dynamic>>> getKonuAdlariByDers(String dersAdi) async {
    final Database db = await instance.usersDatabase;

    String sqlQuery = '''
    SELECT konu_id, konu_adi
    FROM TYT
    INNER JOIN dersler ON TYT.dersId = dersler.dersId
    WHERE dersler.dersAdi = ?
    UNION
    SELECT konu_id, konu_adi
    FROM AYT_SAY
    INNER JOIN dersler ON AYT_SAY.dersId = dersler.dersId
    WHERE dersler.dersAdi = ?
  ''';

    List<Map<String, dynamic>> konular = await db.rawQuery(sqlQuery, [dersAdi,dersAdi]);
    return konular;
  }

  Future<int?> getBranchIdByName(String? branchName) async {
    Database db = await usersDatabase;

    try {
      List<Map<String, dynamic>> result = await db.query(
        'yksBrans',
        where: 'brans = ?',
        whereArgs: [branchName],
      );

      if (result.isNotEmpty) {
        return result.first['brans_id'] as int;
      } else {
        print('Branş bulunamadı: $branchName');
        return null;
      }
    } catch (e) {
      print('Error getting branch id: $e');
      return null;
    }
  }

  Future<List<User>> getUsers() async {
    Database db = await instance.usersDatabase;
    var users = await db.query('users', orderBy: 'username');
    List<User> userList = users.isNotEmpty
        ? users.map((c) => User.fromMap(c)).toList()
        : [];
    return userList;
  }
  Future<List<Ders>> getDersler() async {
    Database db = await instance.usersDatabase;
    var dersler = await db.query('dersler', orderBy: 'dersAdi');
    List<Ders> dersList = dersler.isNotEmpty
        ? dersler.map((c) => Ders.fromMap(c)).toList()
        : [];
    return dersList;
  }
  Future<int> add(Topic topic) async {
    Database db = await instance.usersDatabase;
    return await db.insert('Topics', topic.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.usersDatabase;
    return await db.delete('Topics', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> removeUser(int id) async {
    Database db = await instance.usersDatabase;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> update(Topic topic) async {
    Database db = await instance.usersDatabase;
    return await db.update('Topics', topic.toMap(),
        where: "id = ?", whereArgs: [topic.id]);
  }
  Future<void> _addUser(User user) async {
    final Database db = await instance.usersDatabase;

     await db.insert('users', user.toMap());
  }
  Future<void> _addStudent(Student student) async {
    final Database db = await instance.usersDatabase;
    await db.insert('ogrenciler', student.toMap());
  }
  Future<void> _addBrans(Brans brans) async {
    final Database db = await instance.usersDatabase;
    String? loggedOgrenciBranch=brans.brans;
    setLoggedInOgrenciBranch(loggedOgrenciBranch);
    await db.insert('yksBrans', brans.toMap());
  }
  Future<void> addUser(User user) async {
    await _addUser(user);
  }
  Future<void> addStudent(Student student) async {
    await _addStudent(student);
  }
  Future<void> addBrans(Brans brans) async {
    await _addBrans(brans);
  }
  Future<int?> _login(User user, BuildContext context) async {
    final Database db = await instance.usersDatabase;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [user.username, user.password],
    );

    if (users.isNotEmpty) {
      int loggedInOgrenciId = users[0]['id'] as int;
      print('Login successful for student with ID: $loggedInOgrenciId');
      setLoggedInOgrenciId(loggedInOgrenciId);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DrawerScreen()), (route) => false);

      return loggedInOgrenciId;
    } else {
      print('Login failed');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed"), backgroundColor: Colors.red,));

      return null;
    }
  }


  Future<void> login(User user,BuildContext context) async {
    await _login(user,context);
  }
  Future<List<Map<String, dynamic>>> getKonuAdlariByBranch(String branch) async {
    final Database db = await instance.usersDatabase;

    String sqlQuery;

    if (branch == 'TYT') {
      sqlQuery = 'SELECT * FROM TYT';
    } else {
      sqlQuery = '''
      SELECT * FROM TYT
      UNION
      SELECT * FROM $branch
    ''';
    }

    List<Map<String, dynamic>> konular = await db.rawQuery(sqlQuery);
    return konular;
  }

  Future<List<Map<String, dynamic>>> getTamamlanmadiKonularByBranch(String? branch, int ogrenciId) async {
    final Database db = await instance.usersDatabase;

    // Öğrencinin tamamlamadığı konuları getir
    String tamamlanmayanlarQuery = '''
    SELECT konu_id
    FROM ogrenci_konu
    WHERE ogrenci_id = ? AND durumu = \'Tamamlanmadi\'
  ''';
    List<Map<String, dynamic>> tamamlanmayanlar = await db.rawQuery(tamamlanmayanlarQuery, [ogrenciId]);
    print("tamamlanmayanlar: $tamamlanmayanlar");

    String tumKonularQuery;
    List<Map<String, dynamic>> tumKonular;
    if(branch=='TYT') {
      // Tüm konuları getir
      tumKonularQuery = '''
    SELECT konu_id, konu_adi
    FROM $branch
  ''';
      tumKonular = await db.rawQuery(
          tumKonularQuery);
      print("tumKonular: $tumKonular");
    }
    else{
      tumKonularQuery = '''
    SELECT konu_id, konu_adi
    FROM TYT
    UNION ALL
    SELECT konu_id, konu_adi
    FROM $branch
  ''';

       tumKonular = await db.rawQuery(tumKonularQuery);
      print("tumKonular: $tumKonular");

    }

    // Tamamlanmamış konuları filtrele
    List<Map<String, dynamic>> tamamlanmamisKonular = tumKonular
        .where((konu) =>
        tamamlanmayanlar.any((tamamlanmayan) => tamamlanmayan['konu_id'] == konu['konu_id']))
        .toList();

    return tamamlanmamisKonular;
  }
  Future<List<Map<String, dynamic>>> getTamamlananKonularByBranch(String? branch, int ogrenciId) async {
    final Database db = await instance.usersDatabase;

    // Öğrencinin tamamladığı konuları getir
    String tamamlananlarQuery = '''
    SELECT konu_id
    FROM ogrenci_konu
    WHERE ogrenci_id = ? AND durumu = 'Tamamlandi'
  ''';
    List<Map<String, dynamic>> tamamlananlar = await db.rawQuery(tamamlananlarQuery, [ogrenciId]);
    print("tamamlananlar: $tamamlananlar");

    String tumKonularQuery;
    if(branch == 'TYT') {
      // Tüm konuları getir
      tumKonularQuery = '''
      SELECT konu_id, konu_adi
      FROM $branch
    ''';
    } else {
      // Tüm konuları ve tamamlananları birleştir
      tumKonularQuery = '''
      SELECT konu_id, konu_adi
      FROM TYT
      UNION ALL
      SELECT konu_id, konu_adi
      FROM $branch
    ''';
    }

    // SQL injection önlemek için parametreleri kullan
    List<Map<String, dynamic>> tumKonular = await db.rawQuery(tumKonularQuery);
    print("tumKonular: $tumKonular");

    // Tamamlanan konuları filtrele
    List<Map<String, dynamic>> tamamlananKonular = tumKonular
        .where((konu) =>
        tamamlananlar.any((tamamlanan) => tamamlanan['konu_id'] == konu['konu_id']))
        .toList();

    return tamamlananKonular;
  }

  Future<List<Map<String, dynamic>>> getAllTopicsByBranch(String? branch) async {
    final Database db = await instance.usersDatabase;
      String tumKonularQuery;
    List<Map<String, dynamic>> tumKonular;
    if(branch=='TYT') {
      // Tüm konuları getir
      tumKonularQuery = '''
    SELECT konu_id, konu_adi
    FROM $branch
  ''';
      tumKonular = await db.rawQuery(
          tumKonularQuery);
      print("tumKonular: $tumKonular");
    }
    else{
      tumKonularQuery = '''
    SELECT konu_id, konu_adi
    FROM TYT
    UNION ALL
    SELECT konu_id, konu_adi
    FROM $branch
  ''';

      tumKonular = await db.rawQuery(tumKonularQuery);
      print("tumKonular: $tumKonular");
    }
    //List<Map<String, dynamic>> tumKonular = await db.rawQuery(tumKonularQuery);
    // print("tumKonular: ${tumKonular.elementAt(1)['konu_id']}");
    // print("tumKonular: ${tumKonular.first['konu_id']}");

    print(tumKonular.length);
    List<String> tumKonularasString=[] ;
    for(int i=0;i<tumKonular.length;i++){
      tumKonularasString.add(tumKonular.elementAt(i)['konu_adi']);
    }
    return tumKonular;
  }
  Future<List<Map<String, dynamic>>> getTYTTopics() async {
    final Database db = await instance.usersDatabase;
    String tytKonularQuery = '''
    SELECT konu_id, konu_adi
    FROM TYT
  ''';
    List<Map<String, dynamic>>tytKonular = await db.rawQuery(
        tytKonularQuery);
      print("tytKonularQuery: $tytKonularQuery");
      print("tytKonular: $tytKonular");

    /*   List<String> tytKonularasString=[] ;

   for(int i=0;i<tytKonular.length;i++){
      tytKonularasString.add(tytKonular.elementAt(i)['konu_adi']);
    }*/
    return tytKonular;
  }


  Future<void> updateOgrenciKonuDurumu(int? ogrenciId, int konu_id, bool durum) async {
    final Database db = await instance.usersDatabase;
    String yeniDurum;
    if(durum== true){
      yeniDurum='Tamamlandi';
      print("tamam");
    }
    else{
      yeniDurum='Tamamlanmadi';

    }
    await db.update(
      'ogrenci_konu',
      {'durumu': yeniDurum},
      where: 'ogrenci_id = $ogrenciId AND konu_id = $konu_id',
    );
    print("updateOgrenciKonuDurumu çalıştırıldı");
  }

  Future<Map<String, dynamic>> getOgrenciBilgileri(int? ogrenciId) async {
    final Database db = await instance.usersDatabase;

    String query = '''
    SELECT 
      ogrenciler.name AS name,
      ogrenciler.surname AS surname,
      ogrenciler.sinif AS sinif,
      users.username AS username
    FROM ogrenciler
    JOIN users ON ogrenciler.ogrenci_id = users.id
    WHERE users.id = ?
  ''';

    List<Map<String, dynamic>> results = await db.rawQuery(query, [ogrenciId]);
    print("results: $results");

    // İsim, soyisim, sınıf ve branş bilgilerini içeren bir harita döndür
    return {
      'name': results[0]['name'],
      'surname': results[0]['surname'],
      'sinif': results[0]['sinif'],
      'username': results[0]['username'],
    };
  }
  Future<bool> checkPreviousLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Önceki giriş bilgilerini kontrol et
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  Future signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    //await DatabaseHelper.instance.signOut(context);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => RegisterScreen())));
  }
}


