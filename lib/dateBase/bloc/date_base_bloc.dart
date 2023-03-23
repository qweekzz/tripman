import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tripman/dateBase/DataBase_repository.dart';

import 'package:tripman/models/camps_model.dart';

part 'date_base_event.dart';
part 'date_base_state.dart';

class DateBaseBloc extends Bloc<DateBaseEvent, DateBaseState> {
  final DatabaseRepository _databaseRepository;
  DateBaseBloc(this._databaseRepository) : super(DateBaseInitial()) {
    on<DateGet>(_getCampsData);
    on<DateSave>(_saveOrderData);
    on<DateAdminSaveEvent>(_saveAdminData);
  }

  _getCampsData(DateGet event, Emitter emit) async {
    List<Camps> listOfCamps = await _databaseRepository.getCampData();
    emit(DateBaseSuccess(listOfCamps));
  }

  _saveOrderData(DateSave event, Emitter emit) async {
    List<Camps> listOfCamps = await _databaseRepository.getCampData();
    await _databaseRepository.addCampData(
      event.clientId,
      event.AdminId,
      event.userPhone,
      event.comment,
      event.status,
      event.uid,
    );
    emit(DateBaseSave(
      event.clientId,
      event.AdminId,
      event.userPhone,
      event.comment,
      event.status,
      listOfCamps,
    ));
  }

  _saveAdminData(DateAdminSaveEvent event, Emitter emit) async {
    await _databaseRepository.addAdminData(
      event.adminId,
      event.adminPhone,
      event.name,
      event.type,
      event.desc,
      event.human,
      event.img,
      event.address,
      event.closeDate,
      event.price,
    );
    emit(DateBaseAdminSaveState(
      event.adminId,
      event.adminPhone,
      event.name,
      event.type,
      event.desc,
      event.human,
      event.img,
      event.address,
      event.closeDate,
      event.price,
    ));
  }
}
