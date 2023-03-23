part of 'date_base_bloc.dart';

abstract class DateBaseEvent extends Equatable {
  const DateBaseEvent();

  @override
  List<Object> get props => [];
}

class DateGet extends DateBaseEvent {
  const DateGet();
  @override
  List<Object> get props => [];
}

class DateSave extends DateBaseEvent {
  final String clientId;
  final String AdminId;
  final String userPhone;

  final String comment;
  final String status;
  final Camps uid;
  const DateSave({
    required this.clientId,
    required this.AdminId,
    required this.userPhone,
    required this.comment,
    required this.status,
    required this.uid,
  });

  @override
  List<Object> get props => [clientId, AdminId, userPhone, comment, status];
}

class DateAdminSaveEvent extends DateBaseEvent {
  final String adminId;
  final String adminPhone;
  final String name;
  final String type;
  final String desc;
  final String human;
  final List<String> img;
  final String address;
  final List<DateTime> closeDate;
  final String price;
  const DateAdminSaveEvent({
    required this.adminId,
    required this.adminPhone,
    required this.name,
    required this.type,
    required this.desc,
    required this.human,
    required this.img,
    required this.address,
    required this.closeDate,
    required this.price,
  });

  @override
  List<Object> get props => [
        adminId,
        adminPhone,
        name,
        type,
        desc,
        human,
        img,
        address,
        closeDate,
        price
      ];
}
