part of 'forms_bloc.dart';

enum Status { signIn, signUp, phoneIn, phoneIn2 }

abstract class FormsEvent extends Equatable {
  const FormsEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends FormsEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends FormsEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class PhoneChanged extends FormsEvent {
  final String phone;
  const PhoneChanged(this.phone);

  @override
  List<Object> get props => [phone];
}

class SmsCodeChanged extends FormsEvent {
  final String smsCode;
  const SmsCodeChanged(this.smsCode);

  @override
  List<Object> get props => [smsCode];
}

class FormSucceeded extends FormsEvent {
  const FormSucceeded();

  @override
  List<Object> get props => [];
}

class FormSubmitted extends FormsEvent {
  final Status value;
  const FormSubmitted({required this.value});

  @override
  List<Object> get props => [value];
}

class PhoneFormSubmitted extends FormsEvent {
  final Status value;
  final Status phone;
  const PhoneFormSubmitted({required this.value, required this.phone});

  @override
  List<Object> get props => [value, phone];
}
