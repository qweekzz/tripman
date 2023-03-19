import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripman/models/camps_model.dart';

class DataBaseServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addCampData(
    String clientId,
    String AdminId,
    String userPhone,
    String comment,
    String status,
  ) async {
    await _db.collection("camps").doc(AdminId).update({
      "order.$clientId": {
        'userPhone': userPhone,
        'comment': comment,
        'status': status,
      }
    });
  }

  Future<List<Camps>> getCampData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("camps").get();
    // print(snapshot.docs);
    return snapshot.docs
        .map((docSnapshot) => Camps.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  addAdminData(
    String adminId,
    String adminPhone,
    String name,
    String type,
    String desc,
    String human,
    List<String> img,
    String address,
    List<DateTime> closeDate,
    String price,
  ) async {
    await _db.collection("camps").doc().set({
      'adminId': adminId,
      'adminPhone': adminPhone,
      'name': name,
      'type': type,
      'desc': desc,
      'human': human,
      'img': img,
      'address': address,
      'closeDate': closeDate,
      'price': price,
    });
  }
}




  // addCampData(Camps campData, doc, id) async {
  //   await _db.collection("camps").doc(doc).update({
    //   "order.$id": {
    //     'userPhone': campData.userPhone,
    //     'OpenDate': campData.OpenDate,
    //     'comment': campData.comment,
    //     'status': 'Ожидание',
    //   }
    // });
  // }