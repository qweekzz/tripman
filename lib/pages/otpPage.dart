// ignore_for_file: avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/forms/bloc/forms_bloc.dart';

class optPage extends StatelessWidget {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final String controllerNumb;
  final TextEditingController smsCode = TextEditingController();
  optPage({super.key, required this.controllerNumb});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: Colors.black),
      ),
    );

    Size size = MediaQuery.of(context).size;
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
            children: [
              Column(
                children: [
                  Pinput(
                    length: 6,
                    controller: pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    // hapticFeedbackType: HapticFeedbackType.lightImpact,
                  ),
                ],
              ),
              Column(
                children: [
                  BlocBuilder<FormsBloc, FormsValidate>(
                    builder: (context, state) {
                      return SizedBox(
                        width: size.width * 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            context.read<FormsBloc>().emit(
                                  state.copyWith(
                                      isPhoneValid: true,
                                      isLoading: true,
                                      smsCode: pinController.text),
                                );

                            // Users(smsCode: smsCode.text);
                            // Users().copyWith(smsCode: smsCode.text);

                            context.read<FormsBloc>().add(
                                const FormSubmitted(value: Status.phoneIn2));
                            print('phoneIn work');
                          },
                          child: Text('Подтвердить ${controllerNumb}'),
                        ),
                      );
                    },
                  ),
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

class RichTextLicense extends StatelessWidget {
  const RichTextLicense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
