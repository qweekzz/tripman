import 'package:cloud_firestore/cloud_firestore.dart';

class Camps {
  final String? uId;
  final String? adminId;
  final String? adminPhone;
  final String? userPhone;
  final String? name;
  final String? desc;
  final String? comment;
  final String? type;
  final String? address;
  final String? status;
  final List<dynamic>? img;
  final String? human;
  final String? price;
  final List<dynamic>? closeDate;
  final Map? order;

  Camps({
    this.uId,
    this.adminId,
    this.adminPhone,
    this.userPhone,
    this.name,
    this.desc,
    this.comment,
    this.type,
    this.address,
    this.status,
    this.img,
    this.human,
    this.price,
    this.closeDate,
    this.order,
  });

  Camps copyWith({
    String? uId,
    String? adminId,
    String? adminPhone,
    String? userPhone,
    String? name,
    String? desc,
    String? comment,
    String? type,
    String? address,
    String? status,
    List<dynamic>? img,
    String? human,
    String? price,
    List<dynamic>? closeDate,
    Map? order,
  }) {
    return Camps(
      uId: uId ?? this.uId,
      adminId: adminId ?? this.adminId,
      adminPhone: adminPhone ?? this.adminPhone,
      userPhone: userPhone ?? this.userPhone,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      comment: comment ?? this.comment,
      type: type ?? this.type,
      address: address ?? this.address,
      status: status ?? this.status,
      img: img ?? this.img,
      human: human ?? this.human,
      price: price ?? this.price,
      closeDate: closeDate ?? this.closeDate,
      order: order ?? this.order,
    );
  }

  //  "CourseID.$index": {
  //     'MyLesson': lesson,
  //     'ID': doc,
  //   }

  //     "order.$id": {
  //   'userPhone': campData.userPhone,
  //   'OpenDate': campData.OpenDate,
  //   'comment': campData.comment,
  //   'status': 'Ожидание',
  // }
  Map<String, dynamic> toMap() {
    return {
      "order.$adminId": {
        'userPhone': userPhone,
        'comment': comment,
        'status': 'Ожидание',
      }
    };
  }

  Camps.fromDocumentSnapshot(
    DocumentSnapshot<Map<dynamic, dynamic>> doc,
  )   : uId = doc.id,
        adminId = doc.data()!["adminId"],
        adminPhone = doc.data()!["adminPhone"],
        userPhone = doc.data()!["userPhone"],
        name = doc.data()!["name"],
        desc = doc.data()!["desc"],
        comment = doc.data()!["comment"],
        type = doc.data()!["type"],
        address = doc.data()!["address"],
        status = doc.data()!["address"],
        img = doc.data()!["img"],
        human = doc.data()!["human"],
        price = doc.data()!["price"],
        closeDate = doc.data()!["closeDate"],
        order = doc.data()!["order"];
}
