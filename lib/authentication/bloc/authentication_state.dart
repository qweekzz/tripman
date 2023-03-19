part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final String? id;
  const AuthenticationSuccess({this.id});

  @override
  List<Object> get props => [id ?? ''];
}

class AuthenticationFail extends AuthenticationState {
  @override
  List<Object> get props => [];
}
