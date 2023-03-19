import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tripman/authentication/authentication_repository.dart';
import 'package:tripman/models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        Users user = await _authenticationRepository.getCurrentUser().first;
        if (user.uid != '') {
          String? id = '${user.uid}';
          print("user ID ${user.uid}");
          emit(AuthenticationSuccess(id: id));
        } else {
          print("user ID2 ${user.uid}");

          emit(AuthenticationFail());
        }
      } else if (event is AuthenticationSignedOut) {
        await _authenticationRepository.signOut();
        emit(AuthenticationFail());
      }
    });
  }
}
