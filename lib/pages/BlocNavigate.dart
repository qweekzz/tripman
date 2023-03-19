import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/pages/homePage.dart';
import 'package:tripman/pages/loginPage.dart';
import 'package:tripman/pages/startPage.dart';

class BlocNavigate extends StatelessWidget {
  const BlocNavigate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        print(state);
        if (state is AuthenticationSuccess) {
          return const homePage();
        } else {
          return const StartPage();
        }
      },
    );
  }
}
