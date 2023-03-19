part of 'date_base_bloc.dart';

abstract class DateBaseState extends Equatable {
  const DateBaseState();

  @override
  List<Object> get props => [];
}

class DateBaseInitial extends DateBaseState {}

class DateBaseSuccess extends DateBaseState {
  final List<Camps> listOfCamps;
  const DateBaseSuccess(this.listOfCamps);

  @override
  List<Object> get props => [listOfCamps];
}

class DateBaseSave extends DateBaseState {
  final String clientId;
  final String AdminId;
  final String userPhone;
  final String comment;
  final String status;
  const DateBaseSave(
    this.clientId,
    this.AdminId,
    this.userPhone,
    this.comment,
    this.status,
  );

  @override
  List<Object> get props => [clientId, AdminId, userPhone, comment, status];
}

class DateBaseAdminSaveState extends DateBaseState {
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
  const DateBaseAdminSaveState(
    this.adminId,
    this.adminPhone,
    this.name,
    this.type,
    this.desc,
    this.human,
    this.img,
    this.address,
    this.closeDate,
    this.price,
  );

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

class DateBaseFail extends DateBaseState {
  @override
  List<Object> get props => [];
}

// class DateBaseSuccess extends DateBaseState {
//   // final List<Camps> listOfCamps;
//   const DateBaseSuccess();

//   @override
//   List<Object> get props => [];
// }
