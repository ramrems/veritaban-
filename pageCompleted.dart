import 'package:flutter/material.dart';
import 'package:ogrenci_takip_sqlite/Controller.dart';

import 'database_helper.dart';

class PageTamamlanan extends StatefulWidget {
  final String? selectedBranch; // Seçilen branş adı

  PageTamamlanan({required this.selectedBranch});

  @override
  _PageTamamlananState createState() => _PageTamamlananState();
}

class _PageTamamlananState extends State<PageTamamlanan> {
  late DatabaseHelper databaseHelper;

  Map<String, bool> konuDurumu = {};

  @override
  Widget build(BuildContext context) {
    int? ogrenciId=Controller().loggedInOgrenciId;
    print('Logged In Ogrenci ID: $ogrenciId');
    print(Controller().loggedInOgrenciId);
    print(Controller().loggedInOgrenciBranch);

    final double ekranGenisligi= MediaQuery.of(context).size.width;


    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getTamamlananKonularByBranch(widget.selectedBranch,ogrenciId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Veri bekleniyor ise loading göster
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Tamamlanan Konular - ${widget.selectedBranch}'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top:40,left: 10),
                  child: Center(child: Text("tamamlanmış konunuz bulunmamaktadır",style: TextStyle(fontSize: ekranGenisligi/20,color: Colors.deepOrange[900])),
                  ),
                ),
              ],
            ),
                );
        } else {
          List<Map<String, dynamic>> tamamlananKonular = snapshot.data ?? [];
          print("aaaaaaa $tamamlananKonular");
          // Veri varsa, ListView ile konu adlarını göster
          return Scaffold(
            appBar: AppBar(
              title: Text('Tamamlanan Konular - ${widget.selectedBranch}'),
            ),
            body: ListView.builder(
              //itemCount: snapshot.data!.length,
              itemCount:tamamlananKonular.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> konu = tamamlananKonular[index];
                final konuAdi = snapshot.data![index]['konu_adi'];
                final konuId  = snapshot.data![index]['konu_id'];
                //print("snapshot: ${snapshot.data![index]}");
                print("snapshot: ${snapshot.data!}");
                return ListTile(
                  //title:Text(konu['konu_adi'].toString()),
                  title: Row(
                    children: [
                      Checkbox(
                        value: konuDurumu[konuAdi] ?? true,
                        onChanged: (bool? value) {
                          setState(() {
                            konuDurumu[konuAdi] = value ?? true;
                            // Burada konunun durumunu güncelleyebilirsiniz
                            DatabaseHelper.instance.updateOgrenciKonuDurumu(ogrenciId,konuId, value ?? false);
                          });
                        },
                      ),
                      Text(konuAdi),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
