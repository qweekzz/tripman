import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tripman/dateBase/bloc/date_base_bloc.dart';

class CreatePricePage extends StatelessWidget {
  const CreatePricePage({
    super.key,
    required this.adminId,
    required this.name,
    required this.type,
    required this.desc,
    required this.human,
    required this.img,
    required this.closeDate,
    required this.address,
  });
  final String adminId;
  final String name;
  final String type;
  final String desc;
  final String human;
  final List<String> img;
  final List<DateTime> closeDate;
  final String address;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerAdminPhone =
        TextEditingController(text: '');
    final TextEditingController controllerPrice =
        TextEditingController(text: '');

    return BlocListener<DateBaseBloc, DateBaseState>(
      listenWhen: (previous, current) {
        return current is DateBaseAdminSaveState ? true : false;
      },
      listener: (context, state) {
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
                        'Объект добавлен, ожидайте модерации.',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Время модерациив среднем занимает 2-3 часа',
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
                            side:
                                const BorderSide(color: Colors.black, width: 1),
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
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Цена и контакты',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          actions: [
            const Center(
              child: Text(
                '3 из 3',
                style: TextStyle(color: Colors.black),
              ),
            ),
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Телефон для принятия звонков',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _phoneInput(
                    controllerAdminPhone: controllerAdminPhone,
                  ),
                  const Text(
                    'Цена за сутки',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controllerPrice,
                    onChanged: (value) {
                      // print(controllerName.text);
                    },
                    style: const TextStyle(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: ' ₽',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      side: const BorderSide(color: Colors.black, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      AutoRouter.of(context).navigateBack();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        side: const BorderSide(color: Colors.black, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        context.read<DateBaseBloc>().add(DateAdminSaveEvent(
                              adminId: adminId,
                              adminPhone: controllerAdminPhone.text,
                              name: name,
                              type: type,
                              desc: desc,
                              human: human,
                              img: img,
                              closeDate: closeDate,
                              address: address,
                              price: controllerPrice.text,
                            ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          SizedBox(),
                          Text('Добавить объект'),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _phoneInput extends StatelessWidget {
  final TextEditingController controllerAdminPhone;
  _phoneInput({Key? key, required this.controllerAdminPhone}) : super(key: key);
  final maskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    type: MaskAutoCompletionType.eager,
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [maskFormatter],
      controller: controllerAdminPhone,
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
  }
}
