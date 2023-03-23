// ignore_for_file: unused_local_variable

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height1 = size.height;
    var width1 = size.width;

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width1,
                height: height1,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        Text(
                          'TRIPMAN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              letterSpacing: 8,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Путешествия по \nРеспублике Башкортостан',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(),
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
              color: Colors.white,
            ),
            width: width1,
            height: height1 / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                _SubmitButton1(),
                _SubmitButton2(),
                RichTextLicense(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton1 extends StatelessWidget {
  const _SubmitButton1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(50, 13, 50, 13),
          side: const BorderSide(color: Colors.black, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        onPressed: () {
          AutoRouter.of(context).pushNamed('/login');
        },
        icon: const Icon(
          Icons.email,
          color: Colors.black,
        ),
        label: const Text(
          'Войти по электронной почту',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class _SubmitButton2 extends StatelessWidget {
  const _SubmitButton2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(50, 13, 50, 13),
          side: const BorderSide(color: Colors.black, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        onPressed: () {
          AutoRouter.of(context).pushNamed('/phoneLogin');
        },
        icon: const Icon(
          Icons.phone_callback,
          color: Colors.black,
        ),
        label: const Text(
          'Войти по номеру телефона',
          style: TextStyle(color: Colors.black),
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
