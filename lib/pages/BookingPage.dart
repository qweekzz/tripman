// ignore_for_file: avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';

import 'package:tripman/dateBase/bloc/date_base_bloc.dart';
import 'package:tripman/forms/bloc/forms_bloc.dart';

class BookingPage extends StatelessWidget {
  final TextEditingController controllerPhone =
      TextEditingController(text: '+7');
  final TextEditingController controllerComment =
      TextEditingController(text: '');
  BookingPage(
      {super.key,
      @PathParam('id') required this.itemId,
      controllerPhone,
      controllerComment});

  final int itemId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTimeRange? _selectedDateRange;
    _SelectDateRange() async {
      DateTimeRange? result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime(2030, 12, 31),
        currentDate: DateTime.now(),
        saveText: 'Выбрать',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      _selectedDateRange = result;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Заявка на бронирование',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AutoRouter.of(context).pushNamed('/home');
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: BlocListener<DateBaseBloc, DateBaseState>(
        listenWhen: (previous, current) {
          print('current $current');
          print('previous $previous');
          return current is DateBaseSave ? true : false;
        },
        listener: (context, state) async {
          // AutoRouter.of(context).pushNamed('/home');
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ваша заявка успешно отправлена',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Бронирование будет подтверждено в течении 24 часов',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              context.read<DateBaseBloc>().add(const DateGet());
                              AutoRouter.of(context).pushNamed('/home');
                            },
                            child: const Text('Отлично'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          context.read<DateBaseBloc>().add(const DateGet());
        },
        child: BlocBuilder<DateBaseBloc, DateBaseState>(
          builder: (context, state) {
            if (state is DateBaseSuccess) {
              Img() async {
                final storage = FirebaseStorage.instance;
                String downloadURL = await storage
                    .ref('images/${state.listOfCamps[itemId].img?.first}')
                    .getDownloadURL();
                return downloadURL;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      FutureBuilder<Object>(
                          future: Img(),
                          builder: (context, snapshot) {
                            return SizedBox(
                                width: MediaQuery.of(context).size.width * 1,
                                height: 180,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: snapshot.data != null
                                      ? Image.network(
                                          '${snapshot.data}',
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/tripman-413f6.appspot.com/o/images%2FnotFound.png?alt=media&token=72bc3878-5faf-4bb7-8543-ab1e85ebd140',
                                          fit: BoxFit.cover,
                                        ),
                                ));
                          }),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black12),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 16, 20, 16),
                              child: Row(
                                children: [
                                  Text(
                                    state.listOfCamps[itemId].name.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Заезд',
                                    // '${state.listOfCamps[index].closeDate[0].toDate().day} ${monthToWord(state.listOfCamps[index].closeDate[0].toDate().month) ?? '0'} - ${state.listOfCamps[index].closeDate[1].toDate().day} ${monthToWord(state.listOfCamps[index].closeDate[1].toDate().month) ?? '0'}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.black54),
                                  ),
                                  Text(
                                    '1 июня - 8 июня',
                                    // 'от ${state.listOfCamps[index].price.toString()} ₽',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Вместимость',
                                    // '${state.listOfCamps[index].closeDate[0].toDate().day} ${monthToWord(state.listOfCamps[index].closeDate[0].toDate().month) ?? '0'} - ${state.listOfCamps[index].closeDate[1].toDate().day} ${monthToWord(state.listOfCamps[index].closeDate[1].toDate().month) ?? '0'}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.black54),
                                  ),
                                  Text(
                                    'До ${state.listOfCamps[itemId].human} гостей',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'оплата',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.black54),
                                  ),
                                  Text(
                                    'От ${state.listOfCamps[itemId].price} ₽ / сутки',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Номер телефона',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _phoneInput(
                            controllerPhone: controllerPhone,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Комментарий',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _commentInput(
                            controllerComment: controllerComment,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                          onPressed: () async {
                            context.read<DateBaseBloc>().add(DateSave(
                                  clientId:
                                      '${context.read<AuthenticationBloc>().state.props.first}',
                                  AdminId: state.listOfCamps[itemId].adminId!,
                                  userPhone: controllerPhone.text,
                                  comment: controllerComment.text,
                                  status: 'Ожидание',
                                  uid: state.listOfCamps[itemId],
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Отправить заявку'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Text('данных нет');
            }
          },
        ),
      ),
    );
  }
}

class _phoneInput extends StatelessWidget {
  final TextEditingController controllerPhone;
  _phoneInput({Key? key, required this.controllerPhone}) : super(key: key);
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
            print(controllerPhone);
            context.read<FormsBloc>().add(PhoneChanged(controllerPhone.text));
          },
          inputFormatters: [maskFormatter],
          controller: controllerPhone,
          key: const Key('phoneForm_phoneInput_textField'),
          // onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            // labelText: 'phone number',
            helperText: '',
            // errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _commentInput extends StatelessWidget {
  final TextEditingController controllerComment;
  _commentInput({Key? key, required this.controllerComment}) : super(key: key);
  final maskFormatter = MaskTextInputFormatter(
    // mask: '+7 (###) ###-##-##',
    type: MaskAutoCompletionType.eager,
    filter: {"#": RegExp(r'[А-Я]')},
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsValidate>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            print(controllerComment);
            context.read<FormsBloc>().add(PhoneChanged(controllerComment.text));
          },
          maxLines: 1,
          inputFormatters: [maskFormatter],
          controller: controllerComment,
          key: const Key('phoneForm_phoneInput_textField'),
          // onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            // labelText: 'phone number',
            helperText: '',
            // errorText: state.email.invalid ? 'invalid email' : null,
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
    return SizedBox(
      width: size.width * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          side: const BorderSide(color: Colors.black, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.black,
        ),
        onPressed: () {
          // _SelectDateRange();
        },
        child: const Text('Забронировать'),
      ),
    );
  }
}
