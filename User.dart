class User {
  final int? id;
  final String username;
  final String password;


  User({this.id, required this.username,required this.password});

  factory User.fromMap(Map<String, dynamic> json) => new User(
    id: json['id'],
    username: json['username'],
    password: json['password'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}

class Student {
  final int? ogrenci_id;
  final String name;
  final String surname;
  final String sinif;

  Student({this.ogrenci_id,required this.name,required this.surname,required this.sinif});

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
      ogrenci_id: json['id'],
      name: json['name'],
      surname:json['surname'],
      sinif:json['sinif']
  );

  Map<String, dynamic> toMap() {
    return {
      'ogrenci_id': ogrenci_id,
      'name':name,
      'surname':surname,
      'sinif':sinif

    };
  }
}

class Brans {
  final int? brans_id;
  final String brans;

  Brans({this.brans_id,required this.brans});

  factory Brans.fromMap(Map<String, dynamic> json) => new Brans(
      brans_id: json['brans_id'],
      brans: json['brans'],
  );

  Map<String, dynamic> toMap() {
    return {
      'brans_id': brans_id,
      'brans':brans,

    };
  }
}
class Ders {
  final int? dersId;
  final String dersAdi;

  Ders({this.dersId,required this.dersAdi});

  factory Ders.fromMap(Map<String, dynamic> json) => new Ders(
    dersId: json['dersId'],
    dersAdi: json['dersAdi'],
  );

  Map<String, dynamic> toMap() {
    return {
      'dersId': dersId,
      'dersAdi':dersAdi,

    };
  }
}