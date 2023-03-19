part of 'date_bloc.dart';

class DateState extends Equatable {
  const DateState();

  @override
  List<Object> get props => [];
}

class DateInitial extends DateState {
  const DateInitial();
}

class DateInfo extends DateState {
  final String date;

  DateInfo({
    required this.date,
  });

  DateInfo copyWith({
    String? date,
  }) {
    return DateInfo(
      date: date ?? this.date,
    );
  }
}
