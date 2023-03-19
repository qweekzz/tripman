part of 'date_bloc.dart';

abstract class DateEvent extends Equatable {
  const DateEvent();

  @override
  List<Object> get props => [];
}

class DateChangedButton extends DateEvent {
  final String date;
  const DateChangedButton(this.date);

  @override
  List<Object> get props => [date];
}
