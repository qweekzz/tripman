part of 'forms_bloc.dart';

class FormsState extends Equatable {
  const FormsState();

  @override
  List<Object?> get props => [];
}

class FormsValidate extends FormsState {
  final String email;
  final String password;
  final String phone;
  final String smsCode;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPhoneValid;
  final bool isLoading;

  FormsValidate({
    required this.email,
    required this.password,
    required this.phone,
    required this.smsCode,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isPhoneValid,
    required this.isLoading,
  });

  FormsValidate copyWith({
    String? email,
    String? password,
    String? phone,
    String? smsCode,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPhoneValid,
    bool? isLoading,
  }) {
    return FormsValidate(
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      smsCode: smsCode ?? this.smsCode,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
        phone,
        smsCode,
        isEmailValid,
        isPasswordValid,
        isLoading,
        isPhoneValid
      ];
}
