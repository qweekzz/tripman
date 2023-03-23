import 'package:tripman/dateBase/DateBaseServices.dart';
import 'package:tripman/models/camps_model.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  DataBaseServices service = DataBaseServices();

  @override
  Future addCampData(String clientId, String AdminId, String userPhone,
      String comment, String status, Camps camp) {
    return service.addCampData(
        clientId, AdminId, userPhone, comment, status, camp);
  }

  @override
  Future<List<Camps>> getCampData() {
    return service.getCampData();
  }

  @override
  Future addAdminData(
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
  ) {
    return service.addAdminData(adminId, adminPhone, name, type, desc, human,
        img, address, closeDate, price);
  }
}

abstract class DatabaseRepository {
  Future<void> addCampData(
    String clientId,
    String AdminId,
    String userPhone,
    String comment,
    String status,
    Camps camp,
  );

  Future<List<Camps>> getCampData();

  Future<void> addAdminData(
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
  );
}
