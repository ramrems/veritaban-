import 'package:flutter/material.dart';
import 'package:ogrenci_takip_sqlite/Controller.dart';

import 'database_helper.dart';

class SelectedBranchPage extends StatefulWidget {
  final String? selectedBranch; // Seçilen branş adı

  SelectedBranchPage({required this.selectedBranch});

  @override
  _SelectedBranchPageState createState() => _SelectedBranchPageState();
}

class _SelectedBranchPageState extends State<SelectedBranchPage> {
  late DatabaseHelper databaseHelper;

  Map<String, bool> konuDurumu = {};

  @override
  Widget build(BuildContext context) {
    int? ogrenciId=Controller().loggedInOgrenciId;
    print('Logged In Ogrenci ID: $ogrenciId');
    print(Controller().loggedInOgrenciId);
    print(Controller().loggedInOgrenciBranch);


    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getTamamlanmadiKonularByBranch(widget.selectedBranch,ogrenciId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Veri bekleniyor ise loading göster
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Konu bulunamadı.'));
        } else {
          List<Map<String, dynamic>> tamamlanmadiKonular = snapshot.data ?? [];
          print("aaaaaaa $tamamlanmadiKonular");
          // Veri varsa, ListView ile konu adlarını göster
          return Scaffold(
            appBar: AppBar(
              title: Text('Tamamlanmayan Konular - ${widget.selectedBranch}'),
            ),
            body: ListView.builder(
              //itemCount: snapshot.data!.length,
              itemCount:tamamlanmadiKonular.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> konu = tamamlanmadiKonular[index];
                final konuAdi = snapshot.data![index]['konu_adi'];
                final konuId  = snapshot.data![index]['konu_id'];
                //print("snapshot: ${snapshot.data![index]}");
                print("snapshot: ${snapshot.data!}");
                return ListTile(
                  //title:Text(konu['konu_adi'].toString()),
                  title: Row(
                    children: [
                      Checkbox(
                        value: konuDurumu[konuAdi] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            konuDurumu[konuAdi] = value ?? false;
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
