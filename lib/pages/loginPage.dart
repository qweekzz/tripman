import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/forms/bloc/forms_bloc.dart';
import 'package:tripman/pages/homePage.dart';
import 'package:tripman/pages/registPage.dart';

import '../forms/bloc/forms_bloc.dart';

OutlineInputBorder border = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 3.0));

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<FormsBloc, FormsValidate>(
          listener: (context, state) {
            if (state.isEmailValid && !state.isLoading) {
              context.read<AuthenticationBloc>().add(AuthenticationStarted());
              context.read<FormsBloc>().add(const FormSucceeded());
              // print(state.isEmailValid);
              // print(state.isPasswordValid);
              print(state.isPhoneValid);
              print(state);
              print(context.read<AuthenticationBloc>().state);
            }
            // else if (!state.isEmailValid || !state.isPasswordValid) {
            //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //       content:
            //           Text('!state.isEmailValid || !state.isPasswordValid')));
            // }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              print('BlocListener login');
              AutoRouter.of(context).replaceNamed('/home');
            }
          },
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Center(
              child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
              const _EmailField(),
              SizedBox(height: size.height * 0.01),
              const _PasswordField(),
              SizedBox(height: size.height * 0.01),
              const _SubmitButton(),
              const _SignInNavigate(),
            ]),
          ))),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormsBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
              onChanged: (value) {
                context.read<FormsBloc>().add(EmailChanged(value));
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                helperText: 'gmail.com',
                errorText: !state.isEmailValid
                    ? 'Please ensure the email entered is valid'
                    : null,
                hintText: 'Email',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: border,
              )),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormsBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: border,
              helperText:
                  '''Password should be at least 8 characters with at least one letter and number''',
              helperMaxLines: 2,
              labelText: 'Password',
              errorMaxLines: 2,
              errorText: !state.isPasswordValid
                  ? '''Password must be at least 8 characters and contain at least one letter and number'''
                  : null,
            ),
            onChanged: (value) {
              print('ecnm');
              context.read<FormsBloc>().add(PasswordChanged(value));
            },
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormsBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: OutlinedButton(
            onPressed: state.isEmailValid
                ? () {
                    context
                        .read<FormsBloc>()
                        .add(FormSubmitted(value: Status.signIn));
                    // context
                    //     .read<AuthenticationBloc>()
                    //     .add(AuthenticationStarted());
                    // print(context.read<AuthenticationBloc>().state);

                    print('login');
                    if (state is AuthenticationSuccess) {
                      AutoRouter.of(context).replaceNamed('/home');
                      print(context.read<AuthenticationBloc>().state);
                    }
                  }
                : null,
            child: Text('Войти'),
          ),
        );
      },
    );
  }
}

class _SignInNavigate extends StatelessWidget {
  const _SignInNavigate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          const TextSpan(
              text: 'Нет аккаунта? ',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => {
                      AutoRouter.of(context).pushNamed('/reg'),
                    },
              text: 'зарегистрироваться',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
        ]));
  }
}
