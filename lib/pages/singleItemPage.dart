// ignore_for_file: avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';

import 'package:tripman/dateBase/bloc/date_base_bloc.dart';
import 'package:tripman/forms/bloc/forms_bloc.dart';

class SingleItemPage extends StatelessWidget {
  final TextEditingController controllerPhone =
      TextEditingController(text: '+7');
  final TextEditingController controllerComment =
      TextEditingController(text: '');
  SingleItemPage(
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
      // context.read<DateBloc>().add(DateChangedButton(
      //     '${_selectedDateRange?.start.toString().split(' ')[0].substring(5, 10)} - ${_selectedDateRange?.end.toString().split(' ')[0].substring(5, 10)}'));
      // print('!!!state! ${state.date}');
    }

    return Scaffold(
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
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      onPressed: () {
                        AutoRouter.of(context).navigateBack();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.black,
                    elevation: 0,
                    floating: false,
                    pinned: true,
                    snap: false,
                    expandedHeight: 300,
                    flexibleSpace: CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 335,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        aspectRatio: 2.0,
                        initialPage: 0,
                      ),
                      itemCount: state.listOfCamps[itemId].img?.length,
                      itemBuilder: (context, indexScroll, realIndex) {
                        Img() async {
                          final storage = FirebaseStorage.instance;
                          String downloadURL = await storage
                              .ref(
                                  'images/${state.listOfCamps[itemId].img?[realIndex]}')
                              .getDownloadURL();
                          return downloadURL;
                        }

                        // print('!! ${state.listOfCamps[itemId].name}');
                        return FutureBuilder<Object>(
                          future: Img(),
                          builder: (context, snapshot) {
                            return FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              centerTitle: true,
                              background: snapshot.data != null
                                  ? Image.network(
                                      '${snapshot.data}',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/tripman-413f6.appspot.com/o/images%2FnotFound.png?alt=media&token=72bc3878-5faf-4bb7-8543-ab1e85ebd140',
                                      fit: BoxFit.cover,
                                    ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.listOfCamps[itemId].name.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              state.listOfCamps[itemId].address.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              state.listOfCamps[itemId].desc.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'До ${state.listOfCamps[itemId].human} гостей',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'от ${state.listOfCamps[itemId].price.toString()} ₽',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.6,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 0, 15),
                                          side: const BorderSide(
                                              color: Colors.black, width: 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          backgroundColor: Colors.black,
                                        ),
                                        onPressed: () async {
                                          print(state.listOfCamps[itemId].uId);
                                          await _SelectDateRange();
                                          context
                                              .read<DateBaseBloc>()
                                              .add(DateSave(
                                                clientId:
                                                    '${context.read<AuthenticationBloc>().state.props.first}',
                                                AdminId: state
                                                    .listOfCamps[index]
                                                    .adminId!,
                                                userPhone: controllerPhone.text,
                                                comment: controllerComment.text,
                                                status: 'Ожидание',
                                                uid: state.listOfCamps[itemId],
                                              ));
                                        },
                                        child: const Text('Забронировать'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }, childCount: 1),
                  ),
                ],
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
          maxLines: 3,
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
