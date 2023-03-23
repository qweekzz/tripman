import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripman/authentication/authentication_repository.dart';
import 'package:tripman/models/user_model.dart';

part 'forms_event.dart';
part 'forms_state.dart';

class FormsBloc extends Bloc<FormsEvent, FormsValidate> {
  final AuthenticationRepository _authenticationRepository;

  FormsBloc(this._authenticationRepository)
      : super(FormsValidate(
          email: '',
          password: '',
          phone: '+7',
          smsCode: 'q',
          isEmailValid: false,
          isPasswordValid: false,
          isLoading: false,
          isPhoneValid: false,
        )) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<SmsCodeChanged>(_onSmsCodeChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<FormSucceeded>(_onFormSucceeded);
  }

  //  void passwordChanged(String value) {
  //   final password = Password.dirty(value);
  //   emit(
  //     state.copyWith(
  //       password: password,
  //       status: Formz.validate([state.email, password]),
  //     ),
  //   );
  // }
  _onFormSucceeded(FormSucceeded event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(isEmailValid: true, isPasswordValid: true));
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  _onEmailChanged(EmailChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      email: event.email,
      isEmailValid: _isEmailValid(event.email),
    ));
  }

  _onPhoneChanged(PhoneChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      phone: event.phone,
      // !!!
      isPhoneValid: true,
    ));
  }

  _onSmsCodeChanged(SmsCodeChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      smsCode: event.smsCode,
      // !!!
      isPhoneValid: true,
    ));
  }

  final RegExp _passwordRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]',
  );

  bool _isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  _onPasswordChanged(PasswordChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      password: event.password,
      isEmailValid: _isPasswordValid(event.password),
    ));
  }

  _onFormSubmitted(
    FormSubmitted event,
    Emitter<FormsValidate> emit,
  ) async {
    Users user = Users(
      email: state.email,
      password: state.password,
      phone: state.phone,
      smsCode: state.smsCode,
    );
    if (event.value == Status.signIn) {
      await _updateUIAndSignIn(event, emit, user);
      // emit(state.copyWith(isLoading: false));
      // await AuthenticationRepository().signIn(user);
    } else if (event.value == Status.signUp) {
      await _updateUIAndSignUp(event, emit, user);
    } else if (event.value == Status.phoneIn) {
      await _updateUIAndSignInPhone(event, emit, user);
    } else if (event.value == Status.phoneIn2) {
      await _confirmSMS(event, emit, user);
    }

    // if (event.value == Status.signUp) {
    //   await _updateUIAndSignUp(event, emit, user);
    // }
  }

  _updateUIAndSignUp(
      FormSubmitted event, Emitter<FormsValidate> emit, Users user) async {
    emit(
      state.copyWith(
          isEmailValid: _isEmailValid(state.email),
          // isPasswordValid: _isPasswordValid(state.password),
          isLoading: true),
    );
    if (state.isEmailValid && state.isPasswordValid) {
      try {
        UserCredential? authUser = await _authenticationRepository.signUp(user);
        Users updatedUser = user.copyWith(uid: authUser!.user!.uid);
        // await _databaseRepository.saveUserData(updatedUser);
        if (updatedUser != null) {
          emit(state.copyWith(isLoading: false));
        } else {
          emit(state.copyWith(isEmailValid: false, isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, isEmailValid: false));
      }
    } else {
      emit(state.copyWith(isLoading: false, isEmailValid: false));
    }
  }

  _updateUIAndSignIn(
      FormSubmitted event, Emitter<FormsValidate> emit, Users user) async {
    emit(
      state.copyWith(
          isEmailValid: _isEmailValid(state.email),
          // isPasswordValid: _isPasswordValid(state.password),
          isLoading: true),
    );
    if (state.isEmailValid && state.isPasswordValid) {
      try {
        UserCredential? authUser = await _authenticationRepository.signIn(user);
        Users updatedUser = user.copyWith(uid: authUser!.user!.uid);
        // await _databaseRepository.saveUserData(updatedUser);
        if (updatedUser != null) {
          emit(state.copyWith(isLoading: false));
        } else {
          emit(state.copyWith(isEmailValid: false, isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, isEmailValid: false));
      }
    } else {
      emit(state.copyWith(isLoading: false, isEmailValid: false));
    }
  }

  _updateUIAndSignInPhone(
      FormSubmitted event, Emitter<FormsValidate> emit, Users user) async {
    emit(
      state.copyWith(isPhoneValid: true, isLoading: true),
    );
    if (state.isPhoneValid) {
      try {
        UserCredential? authUser =
            await _authenticationRepository.verifyPhoneNumber(user);
        Users updatedUser = user.copyWith(uid: authUser!.user!.uid);
        // await _databaseRepository.saveUserData(updatedUser);
        if (updatedUser != null) {
          emit(state.copyWith(isLoading: false));
        } else {
          emit(state.copyWith(isEmailValid: false, isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, isEmailValid: false));
      }
    } else {
      emit(state.copyWith(isLoading: false, isEmailValid: false));
    }
  }

  _confirmSMS(
      FormSubmitted event, Emitter<FormsValidate> emit, Users user) async {
    // emit(
    //   state.copyWith(isPhoneValid: true, isLoading: true, smsCode: '123456'),
    // );

    if (state.isPhoneValid) {
      try {
        UserCredential? authUser = await _authenticationRepository
            .verifyPhoneNumber2(user, state.smsCode);
        Users updatedUser = user.copyWith(uid: authUser!.user!.uid);
        // await _databaseRepository.saveUserData(updatedUser);
        if (updatedUser != null) {
          emit(state.copyWith(isLoading: false));
        } else {
          emit(state.copyWith(isEmailValid: false, isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    } else {
      emit(state.copyWith(isLoading: false, isEmailValid: false));
    }
  }

  // _authenticateUser(
  //     FormSubmitted event, Emitter<FormsValidate> emit, Users user) async {
  //   emit(
  //     state.copyWith(
  //         isEmailValid: _isEmailValid(state.email),
  //         // isPasswordValid: _isPasswordValid(state.password),
  //         isLoading: true),
  //   );
  //   if (state.isEmailValid && state.isPasswordValid) {
  //     try {
  //       UserCredential? authUser = await _authenticationRepository.signIn(user);
  //       Users updatedUser =
  //           user.copyWith(isVerified: authUser!.user!.emailVerified);
  //       if (updatedUser.isVerified!) {
  //         emit(state.copyWith(isLoading: false, errorMessage: ""));
  //       } else {
  //         emit(state.copyWith(
  //             isFormValid: false,
  //             errorMessage:
  //                 "Please Verify your email, by clicking the link sent to you by mail.",
  //             isLoading: false));
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       emit(state.copyWith(
  //           isLoading: false, errorMessage: e.message, isFormValid: false));
  //     }
  //   } else {
  //     emit(state.copyWith(
  //         isLoading: false, isFormValid: false, isFormValidateFailed: true));
  //   }
  // }

  // _onFormSucceeded(FormSucceeded event, Emitter<FormsValidate> emit) {
  //   emit(state.copyWith(isFormSuccessful: true));
  // }
}
