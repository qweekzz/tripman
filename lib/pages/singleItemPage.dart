// ignore_for_file: avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';

import 'package:tripman/dateBase/bloc/date_base_bloc.dart';
import 'package:tripman/forms/bloc/forms_bloc.dart';
import 'package:tripman/routers/router.gr.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class SingleItemPage extends StatelessWidget {
  SingleItemPage(
      {super.key,
      @PathParam('id') required this.itemId,
      controllerPhone,
      controllerComment});

  final int itemId;
  late YandexMapController controller;

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: Colors.white,
        height: 90,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '6-12 гостей',
                        // 'До ${state.listOfCamps[itemId].human} гостей',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'от 15 000 ₽ ',
                        // 'от ${state.listOfCamps[itemId].price.toString()} ₽',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.black,
                onPressed: () async {
                  // await _SelectDateRange();
                  AutoRouter.of(context).push(BookingRoute(itemId: itemId));
                },
                label: Text('Забронировать'),
              ),
            ],
          ),
        ),
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
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    excludeHeaderSemantics: true,
                    stretchTriggerOffset: 150,
                    onStretchTrigger: () async {
                      return;
                    },
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
                    flexibleSpace: FlexibleSpaceBar(
                      background: CarouselSlider.builder(
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
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  FlexibleSpaceBar(
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
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    width: 45,
                                    height: 20,
                                    child: Center(
                                      child: Text(
                                        '${realIndex + 1} / ${state.listOfCamps[itemId].img?.length}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showMaterialModalBottomSheet(
                                      enableDrag: false,
                                      expand: false,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                          child: Scaffold(
                                            floatingActionButtonLocation:
                                                FloatingActionButtonLocation
                                                    .centerDocked,
                                            floatingActionButton: Container(
                                              color: Colors.transparent,
                                              height: 90,
                                              child: FloatingActionButton(
                                                backgroundColor: Colors.black,
                                                onPressed: () {},
                                                child: IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ),
                                            body: BlocBuilder<DateBaseBloc,
                                                DateBaseState>(
                                              builder: (context, state) {
                                                if (state is DateBaseInitial) {
                                                  context
                                                      .read<DateBaseBloc>()
                                                      .add(const DateGet());
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (state
                                                    is DateBaseSuccess) {
                                                  // print(
                                                  //     '!!!! ${state.listOfCamps.map((e) => e.name)}');
                                                  return YandexMap(
                                                    mapObjects: [
                                                      PlacemarkMapObject(
                                                        opacity: 1,
                                                        mapId: const MapObjectId(
                                                            'normal_icon_placemark1'),
                                                        point: const Point(
                                                            latitude:
                                                                54.71627413875991,
                                                            longitude:
                                                                56.01481599238483),
                                                        icon: PlacemarkIcon
                                                            .composite([
                                                          PlacemarkCompositeIconItem(
                                                              style: PlacemarkIconStyle(
                                                                  rotationType:
                                                                      RotationType
                                                                          .noRotation,
                                                                  zIndex: 0,
                                                                  image: BitmapDescriptor
                                                                      .fromAssetImage(
                                                                          'lib/assets/icons/cluster.png')),
                                                              name: 'TEST'),
                                                          PlacemarkCompositeIconItem(
                                                              style: PlacemarkIconStyle(
                                                                  zIndex: 1,
                                                                  image: BitmapDescriptor
                                                                      .fromAssetImage(
                                                                          'lib/assets/icons/barrel2.png')),
                                                              name: 'TEST2'),
                                                        ]),
                                                      ),
                                                    ],
                                                    onMapCreated:
                                                        (YandexMapController
                                                            yandexMapController) async {
                                                      controller =
                                                          yandexMapController;
                                                      controller.getPoint(
                                                          const ScreenPoint(
                                                              x: 54.71627413875991,
                                                              y: 56.01481599238483));

                                                      controller.moveCamera(
                                                        CameraUpdate
                                                            .newCameraPosition(
                                                          const CameraPosition(
                                                            target: Point(
                                                                latitude:
                                                                    54.71627413875991,
                                                                longitude:
                                                                    56.01481599238483),
                                                            zoom: 8,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  // return Text('123');
                                                } else {
                                                  return const Text(
                                                      'StateError');
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'lib/assets/icons/map.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: Text(
                                          state.listOfCamps[itemId].address
                                              .toString(),
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 52,
                                  width: 52,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      width: 52,
                                      height: 52,
                                      child: const Icon(
                                        grade: 0.8,
                                        weight: 0.8,
                                        size: 24,
                                        Icons.route_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 85,
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Icon(
                                        Icons.phone_outlined,
                                        size: 32,
                                      ),
                                      Text(
                                        'Позвонить',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 85,
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Icon(
                                        Icons.messenger_outline_sharp,
                                        size: 32,
                                      ),
                                      Text(
                                        'Написать',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 85,
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16)),
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Icon(
                                        Icons.share_outlined,
                                        size: 32,
                                      ),
                                      Text(
                                        'Поделиться',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                            const Text(
                              'Развлечения',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 200,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                children: [
                                  Image.asset(
                                    'lib/assets/icons/img1.png',
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 140,
                                    width: 200,
                                    child: Image.asset(
                                      'lib/assets/icons/img2.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 140,
                                    width: 200,
                                    child: Image.asset(
                                      'lib/assets/icons/img5.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'Удобства',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              child: GridView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 0.7, color: Colors.black38),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/icons/ТВ.svg',
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 15),
                                        const Text('ТВ'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 0.7, color: Colors.black38),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/icons/Мангал.svg',
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 15),
                                        const Text('Мангал'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 0.7, color: Colors.black38),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/icons/Кондиционер.svg',
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 15),
                                        const Text('Кондиционер'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 0.7, color: Colors.black38),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/icons/Парковка.svg',
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 15),
                                        const Text('Парковка'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'Удобства',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 0.7, color: Colors.black38),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'lib/assets/icons/Мангал.svg',
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(width: 15),
                                          const Text('Двуспальная кровать'),
                                        ],
                                      ),
                                      const Text('3'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 0.7, color: Colors.black38),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'lib/assets/icons/Мангал.svg',
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(width: 15),
                                          Text('Диван'),
                                        ],
                                      ),
                                      Text('1'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 100,
                            ),
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
