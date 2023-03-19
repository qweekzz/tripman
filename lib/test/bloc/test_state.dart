part of 'test_bloc.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object> get props => [];
}

class TestInitial extends TestState {}

class UpdateTextState extends TestState {
  final String text;
  UpdateTextState({required this.text});
}

class ShowSnackbarState extends TestState {}
