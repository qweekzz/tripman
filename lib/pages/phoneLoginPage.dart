// ignore_for_file: unused_local_variable, avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/forms/bloc/forms_bloc.dart';
import 'package:tripman/models/user_model.dart';
import 'package:tripman/routers/router.gr.dart';

class PhoneLoginPage extends StatelessWidget {
  final TextEditingController controllerNumb =
      TextEditingController(text: '+7');
  PhoneLoginPage({super.key, controllerNumb});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FormsBloc, FormsValidate>(
          listener: (context, state) {
            if (state.isPhoneValid) {
              context.read<AuthenticationBloc>().add(AuthenticationStarted());
              context.read<FormsBloc>().add(const FormSucceeded());
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              print('BlocListener loginPhone');
              AutoRouter.of(context).replaceNamed('/home');
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Выход',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          // leadingWidth: 30,
          leading: IconButton(
              onPressed: () {
                AutoRouter.of(context).navigateBack();
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Colors.black,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Text(
                    'Для использования приложения пожалуйста укажите ваш номер телефона',
                    style: TextStyle(color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: _phoneInput(
                      controllerNumb: controllerNumb,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  _SubmitButton(controllerNumb: controllerNumb),
                  const RichTextLicense(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final TextEditingController controllerNumb;
  const _SubmitButton({Key? key, required this.controllerNumb})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormsBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              side: const BorderSide(color: Colors.black, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.black,
            ),
            onPressed: state.isPhoneValid
                ? () {
                    context
                        .read<FormsBloc>()
                        .add(const FormSubmitted(value: Status.phoneIn));
                    // AutoRouter.of(context).pushNamed('/opt');
                    print(Users);
                    AutoRouter.of(context).push(
                      OptRoute(controllerNumb: controllerNumb.text),
                    );
                    print('loginPhone');
                  }
                : null,
            child: const Text('Подтвердить номер'),
          ),
        );
      },
    );
  }
}

class _phoneInput extends StatelessWidget {
  final TextEditingController controllerNumb;
  _phoneInput({Key? key, required this.controllerNumb}) : super(key: key);
  final maskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    type: MaskAutoCompletionType.eager,
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsValidate>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            print(controllerNumb);
            context.read<FormsBloc>().add(PhoneChanged(controllerNumb.text));
          },
          inputFormatters: [maskFormatter],
          controller: controllerNumb,
          key: const Key('phoneForm_phoneInput_textField'),
          // onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'phone number',
            helperText: '',
            // errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class RichTextLicense extends StatelessWidget {
  const RichTextLicense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'При входе на ресурс,\nвы принимаете ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'условия доступа',
              style: const TextStyle(color: Colors.blue, height: 1.5),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AutoRouter.of(context).pushNamed('/license');
                },
            ),
          ],
        ),
      ),
    );
  }
}
