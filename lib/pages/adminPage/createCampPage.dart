import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/counter/bloc/counter_bloc.dart';
import 'package:tripman/dateBase/bloc/date_base_bloc.dart';
import 'package:tripman/routers/router.gr.dart';

enum Type { camp, camp2, camp3, camp4, camp5 }

final List<String> type = [
  "Кэмпинги",
  "Глэмпинги",
  "Бочка",
  "База отдыха",
  "Шале"
];

class CreateCampPage extends StatefulWidget {
  const CreateCampPage({super.key});

  @override
  State<CreateCampPage> createState() => _CreateCampPageState();
}

class _CreateCampPageState extends State<CreateCampPage> {
  final controllerImg = MultiImagePickerController(
    maxImages: 10,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
    // withData: true,
    withReadStream: true,
  );

  final TextEditingController controllerName = TextEditingController(text: '');
  final TextEditingController controllerDesc = TextEditingController(text: '');
  Type _character = Type.camp;
  int ind = 0;
  DateTimeRange? _selectedDateRange;
  List<DateTime>? arraryDateRange;

  selectType() {
    print(type.elementAt(_character.index));
    return type.elementAt(_character.index);
  }

  @override
  Widget build(BuildContext context) {
    _SelectDateRange() async {
      DateTimeRange? result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2023, 1, 1),
        lastDate: DateTime(2025, 12, 31),
        currentDate: DateTime.now(),
        saveText: 'Выбрать',
        // helpText: 'helpText',
        // cancelText: 'cancelText',
        // confirmText: 'confirmText',
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

      arraryDateRange = [_selectedDateRange!.start, _selectedDateRange!.end];
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Объект',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          const Center(
            child: Text(
              '1 из 3',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Тип',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //select type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          _RadioIcon('lib/assets/icons/camp.png', 'Кэмпинги'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Radio<Type>(
                        splashRadius: 1,
                        fillColor: MaterialStateProperty.all(Colors.black),
                        value: Type.camp,
                        groupValue: _character,
                        onChanged: (Type? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black54))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          _RadioIcon('lib/assets/icons/glamp.png', 'Глэмпинги'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Radio<Type>(
                        splashRadius: 1,
                        fillColor: MaterialStateProperty.all(Colors.black),
                        value: Type.camp2,
                        groupValue: _character,
                        onChanged: (Type? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black54))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          _RadioIcon('lib/assets/icons/barrel2.png', 'Бочка'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Radio<Type>(
                        splashRadius: 1,
                        fillColor: MaterialStateProperty.all(Colors.black),
                        value: Type.camp3,
                        groupValue: _character,
                        onChanged: (Type? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black54))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _RadioIcon(
                          'lib/assets/icons/basa.png', 'Базы отдыха'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Radio<Type>(
                        splashRadius: 1,
                        fillColor: MaterialStateProperty.all(Colors.black),
                        value: Type.camp4,
                        groupValue: _character,
                        onChanged: (Type? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black54))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _RadioIcon('lib/assets/icons/shale.png', 'Шале'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Radio<Type>(
                        splashRadius: 1,
                        fillColor: MaterialStateProperty.all(Colors.black),
                        value: Type.camp5,
                        groupValue: _character,
                        onChanged: (Type? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //select name
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Название',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: controllerName,
                        onChanged: (value) {
                          print(controllerName.text);
                        },
                        style: const TextStyle(),
                        decoration: const InputDecoration(
                          // contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                          labelText: '',
                          // errorText: state.email.invalid ? 'invalid email' : null,
                        ),
                      ),
                    ],
                  ),
                ),
                //select desc
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Описание',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        onChanged: (value) {},
                        maxLines: 3,
                        controller: controllerDesc,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          labelText: '',
                          helperText: '',
                          // errorText: state.email.invalid ? 'invalid email' : null,
                        ),
                      )
                    ],
                  ),
                ),
                //select human
                BlocBuilder<CounterBloc, int>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                flex: 3,
                                child: Text(
                                  'Количество гостей',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<CounterBloc>()
                                            .add(CounterIncEvent());
                                      },
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        size: 28,
                                      ),
                                    ),
                                    Text(
                                      '$state',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<CounterBloc>()
                                            .add(CounterDecEvent());
                                      },
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 10)),
                          SizedBox(
                            height: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(color: Colors.black38))),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                //select img
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 100),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          MultiImagePickerView(
                            controller: controllerImg,
                            addButtonTitle: 'Добавить изображение',
                            addMoreButtonTitle: 'Добавить изображение2',
                            initialContainerBuilder: (context, pickerCallback) {
                              return InkWell(
                                onTap: () => pickerCallback(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Добавить фото',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.image_outlined,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            padding: const EdgeInsets.all(10),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 10)),
                      SizedBox(
                        height: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.black38))),
                        ),
                      ),
                    ],
                  ),
                ),
                //route button
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                      final storageRef = FirebaseStorage.instance;
                      //Поправить
                      await controllerImg.images.map((e) async {
                        var path = File(e.path!);
                        await storageRef.ref('images/${e.name}').putFile(path);
                        return e.name.toString();
                      }).toList();
                      await _SelectDateRange();

                      final arrImg = controllerImg.images.map((e) {
                        return e.name.toString();
                      }).toList();
                      print(arraryDateRange);

                      AutoRouter.of(context).push(CreateAddressRoute(
                        adminId:
                            '${context.read<AuthenticationBloc>().state.props.first}',
                        name: controllerName.text,
                        type: selectType(),
                        desc: controllerDesc.text,
                        human: '${context.read<CounterBloc>().state}',
                        img: arrImg,
                        closeDate: arraryDateRange!,
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(),
                        const Text('Занятые даты'),
                        Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controllerImg.dispose();
    super.dispose();
  }
}

class _phoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {},
      style: const TextStyle(),
      decoration: const InputDecoration(
        // contentPadding: EdgeInsets.all(5),
        border: OutlineInputBorder(),
        // labelText: 'phone number',
        helperText: '',
        // errorText: state.email.invalid ? 'invalid email' : null,
      ),
    );
  }
}

Widget _RadioIcon(String icon, String nameIcon) {
  return Row(
    children: [
      Container(
        margin: EdgeInsets.only(right: 15),
        child: Image.asset(
          icon,
          height: 40,
          width: 40,
          color: Colors.black,
        ),
      ),
      Text(
        nameIcon,
      ),
    ],
  );
}
