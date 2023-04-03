// ignore_for_file: avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/date/bloc/date_bloc.dart';
import 'package:tripman/dateBase/bloc/date_base_bloc.dart';
import 'package:tripman/routers/router.gr.dart';
import 'dart:math' as math;

import 'package:yandex_mapkit/yandex_mapkit.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> with TickerProviderStateMixin {
  late YandexMapController controller;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    DateTimeRange? _showDateRange;

    void _SelectDateRange() async {
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

      _showDateRange = result;
      context.read<DateBloc>().add(DateChangedButton(
          '${_showDateRange?.start.toString().split(' ')[0].substring(5, 10)} - ${_showDateRange?.end.toString().split(' ')[0].substring(5, 10)}'));
      // print('!!!state! ${state.date}');
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<DateBloc, DateState>(
        builder: (context, state) {
          TabController? tabController = TabController(vsync: this, length: 9);
          void _handleTabSelection() {
            setState(() {});
          }

          @override
          void initState() {
            super.initState();
            tabController = TabController(vsync: this, length: 9);
            tabController?.addListener(_handleTabSelection);
            print(tabController?.index);
          }

          print(state);
          final List tabs = [
            ['lib/assets/icons/more.svg', 'Все'],
            ['lib/assets/icons/1.svg', 'A-frame'],
            ['lib/assets/icons/2.svg', 'Сферы'],
            ['lib/assets/icons/3.svg', 'Модульные дома'],
            ['lib/assets/icons/5.svg', 'Барнхаусы'],
            ['lib/assets/icons/6.svg', 'Дома бочки'],
            ['lib/assets/icons/7.svg', 'Шале'],
            ['lib/assets/icons/8.svg', 'Базы отдыха'],
            ['lib/assets/icons/9.svg', 'Сафари'],
          ];
          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  showMaterialModalBottomSheet(
                    enableDrag: false,
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Scaffold(
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: Container(
                            color: Colors.transparent,
                            height: 90,
                            child: FloatingActionButton(
                              backgroundColor: Colors.black,
                              onPressed: () {},
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          body: BlocBuilder<DateBaseBloc, DateBaseState>(
                            builder: (context, state) {
                              if (state is DateBaseInitial) {
                                context
                                    .read<DateBaseBloc>()
                                    .add(const DateGet());
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is DateBaseSuccess) {
                                // print(
                                //     '!!!! ${state.listOfCamps.map((e) => e.name)}');
                                return YandexMap(
                                  mapObjects: [
                                    PlacemarkMapObject(
                                      opacity: 1,
                                      mapId: const MapObjectId(
                                          'normal_icon_placemark4'),
                                      point: const Point(
                                          latitude: 54.71627413875991,
                                          longitude: 56.01481599238483),
                                      icon: PlacemarkIcon.composite([
                                        PlacemarkCompositeIconItem(
                                            style: PlacemarkIconStyle(
                                                rotationType:
                                                    RotationType.noRotation,
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
                                    PlacemarkMapObject(
                                      opacity: 1,
                                      mapId: const MapObjectId(
                                          'normal_icon_placemark6'),
                                      point: const Point(
                                          latitude: 54.51627413875991,
                                          longitude: 56.21481599238483),
                                      icon: PlacemarkIcon.composite([
                                        PlacemarkCompositeIconItem(
                                            style: PlacemarkIconStyle(
                                                rotationType:
                                                    RotationType.noRotation,
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
                                                        'lib/assets/icons/shale.png')),
                                            name: 'TEST2'),
                                      ]),
                                    ),
                                    PlacemarkMapObject(
                                      mapId: const MapObjectId(
                                          'normal_icon_placemark5'),
                                      point: const Point(
                                          latitude: 54.91627413875991,
                                          longitude: 55.81481599238483),
                                      // icon: icon,
                                    ),
                                  ],
                                  onMapCreated: (YandexMapController
                                      yandexMapController) async {
                                    controller = yandexMapController;
                                    controller.getPoint(const ScreenPoint(
                                        x: 54.71627413875991,
                                        y: 56.01481599238483));

                                    controller.moveCamera(
                                      CameraUpdate.newCameraPosition(
                                        const CameraPosition(
                                          target: Point(
                                              latitude: 54.71627413875991,
                                              longitude: 56.01481599238483),
                                          zoom: 8,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Text('StateError');
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                backgroundColor: Colors.black,
                icon: const Icon(Icons.map_outlined),
                label: const Text('На карте'),
              ),
              key: _key,
              drawer: Drawer(
                width: MediaQuery.of(context).size.width * 1,
                child: SafeArea(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 26,
                        ),
                        title: const Text(
                          'Меню',
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: ListTile(
                            leading: const CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.black,
                              child: Center(
                                child: Text(
                                  'TRIP\nMAN',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Аккаунт',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '+79824453885',
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 16),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Добавить объекты'),
                        onTap: () {},
                        trailing: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(width: 0.5, color: Colors.black38))),
                      ),
                      ListTile(
                        title: const Text('Бронирование'),
                        onTap: () {},
                        trailing: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
                titleSpacing: 10,
                toolbarHeight: 80,
                title: Column(
                  children: const [
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      // controller: _controllerDate,
                      decoration: InputDecoration(
                        enabled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 26,
                        ),
                        hintText: 'Поиск',
                        labelStyle: TextStyle(
                          fontSize: 16,
                        ),
                        counterText: '',
                        isCollapsed: true,
                        contentPadding: EdgeInsets.fromLTRB(10, 18, 10, 18),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                leading: IconButton(
                  splashRadius: 26,
                  onPressed: () {},
                  icon: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: IconButton(
                      onPressed: () {
                        _key.currentState!.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                    child: IconButton(
                      splashRadius: 26,
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        showBarModalBottomSheet(
                          barrierColor: Colors.black54,
                          expand: false,
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Scaffold(
                                floatingActionButtonLocation:
                                    FloatingActionButtonLocation.centerDocked,
                                floatingActionButton: Container(
                                  color: Colors.white,
                                  height: 90,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            'Очистить',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        ),
                                        FloatingActionButton.extended(
                                          backgroundColor: Colors.black,
                                          onPressed: () {},
                                          label: const Text(
                                              'Показать 12 вариантов'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                body: ListView(
                                    reverse: false,
                                    shrinkWrap: true,
                                    controller:
                                        ModalScrollController.of(context),
                                    physics: const ClampingScrollPhysics(),
                                    children: [
                                      const ListTile(
                                        title: Text(
                                          'Фильтры',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            18, 10, 18, 30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Даты поездки',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            BlocBuilder<DateBloc, DateState>(
                                              builder: (context, state) {
                                                TextEditingController
                                                    _controllerDate =
                                                    TextEditingController(
                                                        text: '');
                                                if (state is DateInitial) {
                                                  _controllerDate =
                                                      TextEditingController(
                                                          text: '');
                                                } else if (state is DateInfo) {
                                                  _controllerDate =
                                                      TextEditingController(
                                                          text: state.date);
                                                }
                                                return TextField(
                                                  controller: _controllerDate,
                                                  decoration: InputDecoration(
                                                    enabled: true,
                                                    suffixIcon: IconButton(
                                                        onPressed: () async {
                                                          _SelectDateRange();
                                                        },
                                                        icon: const Icon(
                                                            Icons.date_range)),
                                                    labelText: 'Даты поездки',
                                                    labelStyle: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    counterText: '',
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 18, 10, 18),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                    border: const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                      borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      _FilterListTile('Ценовой диапазон',
                                          '6 000 ₽ – 34 000 ₽'),
                                      _FilterListTile('Отдаленость', '300 км'),
                                      _FilterListTile('Дома', 'A-Frame'),
                                      _FilterListTile(
                                          'Количество мест', '2 – 16'),
                                      _FilterListTile('Удобства',
                                          'Мангал, Парковка, Кухня'),
                                      _FilterListTile('Развлечения', 'Водоём'),
                                      const SizedBox(
                                        height: 70,
                                      ),
                                    ]),
                              ),
                            );
                          },
                        );
                      },
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          grade: 0.5,
                          weight: 0.5,
                          size: 26,
                          Icons.tune_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                bottom: TabBar(
                  controller: tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black38,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  physics: const BouncingScrollPhysics(),
                  indicator: const BoxDecoration(color: Colors.black12),
                  indicatorColor: Colors.amber,
                  isScrollable: true,
                  tabs: tabs
                      .asMap()
                      .map((index, tab) => MapEntry(
                          index,
                          Tab(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: AnimatedBuilder(
                                      animation: tabController!.animation!,
                                      builder: (context, child) {
                                        final value =
                                            tabController!.animation!.value -
                                                index;
                                        return SizedBox(
                                          height: 26,
                                          child: SvgPicture.asset(tab[0],
                                              color: ColorTween(
                                                      begin:
                                                          const Color.fromRGBO(
                                                              5, 5, 5, 1),
                                                      end: const Color.fromRGBO(
                                                          202, 202, 202, 1))
                                                  .lerp(math.min(
                                                      value < 0
                                                          ? (0 - value).abs()
                                                          : value,
                                                      1))),
                                        );
                                      }),
                                ),
                                Text(
                                  tab[1],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                )
                              ],
                            ),
                          )))
                      .values
                      .toList(),
                  // tabs: [
                  //   for (final tab in tabs)
                  //     Tab(
                  //       height: 65,
                  //       child: tab,
                  //     ),
                  // ],
                ),
              ),
              body: BlocBuilder<DateBaseBloc, DateBaseState>(
                builder: (context, state) {
                  print(state);
                  print('_tabController?.index ${tabController?.index}');
                  if (state is DateBaseInitial) {
                    context.read<DateBaseBloc>().add(const DateGet());
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DateBaseSuccess) {
                    if (state.listOfCamps.isEmpty) {
                      return const Center(
                        child: Text('Данных нет'),
                      );
                    } else {
                      return Scaffold(
                        body: TabBarView(
                          controller: tabController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: ListView.builder(
                                itemCount: state.listOfCamps.length,
                                itemBuilder: (context, index) {
                                  monthToWord(int month) {
                                    if (month == 1) {
                                      return 'января';
                                    } else if (month == 2) {
                                      return 'февраля';
                                    } else if (month == 3) {
                                      return 'марта';
                                    } else if (month == 4) {
                                      return 'апреля';
                                    } else if (month == 5) {
                                      return 'мая';
                                    } else if (month == 6) {
                                      return 'июня';
                                    } else if (month == 7) {
                                      return 'июля';
                                    } else if (month == 8) {
                                      return 'августа';
                                    } else if (month == 9) {
                                      return 'сентября';
                                    } else if (month == 10) {
                                      return 'октября';
                                    } else if (month == 11) {
                                      return 'ноября';
                                    } else if (month == 12) {
                                      return 'декабря';
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: InkWell(
                                      onTap: () {
                                        AutoRouter.of(context).push(
                                            SingleItemRoute(itemId: index));
                                      },
                                      child: Column(
                                        children: [
                                          CarouselSlider.builder(
                                            options: CarouselOptions(
                                              height: 335,
                                              autoPlay: false,
                                              enableInfiniteScroll: false,
                                              enlargeCenterPage: true,
                                              viewportFraction: 1,
                                              aspectRatio: 2.0,
                                              initialPage: 0,
                                            ),
                                            itemCount: state
                                                .listOfCamps[index].img?.length,
                                            itemBuilder: (context, indexScroll,
                                                realIndex) {
                                              Future<String> Img() async {
                                                String downloadURL2;
                                                final storage =
                                                    FirebaseStorage.instance;
                                                String downloadURL = await storage
                                                    .ref(
                                                        'images/${state.listOfCamps[index].img![realIndex]}')
                                                    .getDownloadURL();

                                                return downloadURL;
                                              }

                                              // print('!! ${Img()}');
                                              return FutureBuilder<Object>(
                                                  future: Img(),
                                                  builder: (context, snapshot) {
                                                    // print(
                                                    //     'snaphot ${snapshot.data}');
                                                    return SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      height: 335,
                                                      child: snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done
                                                          ? Stack(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              // fit: StackFit.expand,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius: const BorderRadius
                                                                          .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              12)),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: 320,
                                                                    key:
                                                                        UniqueKey(),
                                                                    imageUrl:
                                                                        'https://ik.imagekit.io/qweek/o/${snapshot.data.toString().split('/o/')[1]}',
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            CachedNetworkImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      imageUrl:
                                                                          'https://ik.imagekit.io/qweek/o/${snapshot.data.toString().split('/o/')[1]}&tr=bl-50',
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 30,
                                                                  left: 230,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                    ),
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            15),
                                                                    width: 82,
                                                                    height: 30,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Icon(Icons
                                                                            .near_me),
                                                                        Text(
                                                                          '111 км',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w400),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black87,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          15),
                                                                  width: 45,
                                                                  height: 20,
                                                                  child: Center(
                                                                    child: Text(
                                                                      '${realIndex + 1} / ${state.listOfCamps[index].img?.length}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : null,
                                                    );
                                                  });
                                            },
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black12),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 16, 20, 16),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        state.listOfCamps[index]
                                                            .name
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 20, 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'от ${state.listOfCamps[index].price.toString()} ₽',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${state.listOfCamps[index].closeDate![0].toDate().day} ${monthToWord(state.listOfCamps[index].closeDate![0].toDate().month) ?? '0'} - ${state.listOfCamps[index].closeDate![1].toDate().day} ${monthToWord(state.listOfCamps[index].closeDate![1].toDate().month) ?? '0'}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 20, 16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          'До ${state.listOfCamps[index].human} гостей',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black54)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            _tabContent(context, state, 'A-frame'),
                            _tabContent(context, state, 'Сферы'),
                            _tabContent(context, state, 'Модульные дома'),
                            _tabContent(context, state, 'Барнхаусы'),
                            _tabContent(context, state, 'Дома бочки'),
                            _tabContent(context, state, 'Шале'),
                            _tabContent(context, state, 'Базы отдыха'),
                            _tabContent(context, state, 'Сафари'),
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Center(child: Text('dataelse'));
                  }
                },
              ),
            ),
          );
        },
      ),
    );
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
        labelText: 'phone number',
        helperText: '',
        // errorText: state.email.invalid ? 'invalid email' : null,
      ),
    );
  }
}

Widget _FilterListTile(String title, String subtitle) {
  return Column(
    children: [
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(subtitle),
          ],
        ),
        onTap: () {},
        trailing: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
          size: 28,
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
            border: Border.fromBorderSide(
                BorderSide(width: 0.5, color: Colors.black38))),
      ),
    ],
  );
}

Widget _TabIcon(String icon, String nameIcon, int indx, tabController) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SvgPicture.asset(
            icon,
            fit: BoxFit.cover,
            color: tabController.index == 1 ? Colors.amber : Colors.grey,
          ),
        ),
        Text(
          nameIcon,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ),
      ],
    ),
  );
}

Widget _tabContent(context, state, String type) {
  Size size = MediaQuery.of(context).size;

  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: ListView.builder(
      itemCount: state.listOfCamps.length,
      itemBuilder: (context, index) {
        if (state.listOfCamps[index].type == type) {
          monthToWord(int month) {
            if (month == 1) {
              return 'января';
            } else if (month == 2) {
              return 'февраля';
            } else if (month == 3) {
              return 'марта';
            } else if (month == 4) {
              return 'апреля';
            } else if (month == 5) {
              return 'мая';
            } else if (month == 6) {
              return 'июня';
            } else if (month == 7) {
              return 'июля';
            } else if (month == 8) {
              return 'августа';
            } else if (month == 9) {
              return 'сентября';
            } else if (month == 10) {
              return 'октября';
            } else if (month == 11) {
              return 'ноября';
            } else if (month == 12) {
              return 'декабря';
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                AutoRouter.of(context).push(SingleItemRoute(itemId: index));
              },
              child: Column(
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 335,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      aspectRatio: 2.0,
                      initialPage: 0,
                    ),
                    itemCount: state.listOfCamps[index].img.length,
                    itemBuilder: (context, indexScroll, realIndex) {
                      Future<String> Img() async {
                        String downloadURL2;
                        final storage = FirebaseStorage.instance;
                        String downloadURL = await storage
                            .ref(
                                'images/${state.listOfCamps[index].img[realIndex]}')
                            .getDownloadURL();

                        return downloadURL;
                      }

                      return FutureBuilder<Object>(
                          future: Img(),
                          builder: (context, snapshot) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              height: 335,
                              child: snapshot.connectionState ==
                                      ConnectionState.done
                                  ? Stack(
                                      alignment: Alignment.bottomCenter,
                                      // fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          child: CachedNetworkImage(
                                            width: size.width,
                                            height: 320,
                                            key: UniqueKey(),
                                            imageUrl:
                                                'https://ik.imagekit.io/qweek/o/${snapshot.data.toString().split('/o/')[1]}',
                                            placeholder: (context, url) =>
                                                CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  'https://ik.imagekit.io/qweek/o/${snapshot.data.toString().split('/o/')[1]}&tr=bl-50',
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 30,
                                          left: 230,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            width: 82,
                                            height: 30,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.near_me),
                                                Text(
                                                  '111 км',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          width: 45,
                                          height: 20,
                                          child: Center(
                                            child: Text(
                                              '${realIndex + 1} / ${state.listOfCamps[index].img.length}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            );
                          });
                    },
                  ),
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
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Row(
                            children: [
                              Text(
                                state.listOfCamps[index].name.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'от ${state.listOfCamps[index].price.toString()} ₽',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${state.listOfCamps[index].closeDate[0].toDate().day} ${monthToWord(state.listOfCamps[index].closeDate[0].toDate().month) ?? '0'} - ${state.listOfCamps[index].closeDate[1].toDate().day} ${monthToWord(state.listOfCamps[index].closeDate[1].toDate().month) ?? '0'}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  'До ${state.listOfCamps[index].human} гостей',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Colors.black54)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    ),
  );
}

// final tabs2 = [
//   BlocConsumer<TestBloc, TestState>(
//     listener: (context, state) {
//       if (state is TestInitial) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('This is TestInitial!!!!'),
//         ));
//       } else if (state is UpdateTextState) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('This is UpdateTextState!!!!'),
//         ));
//       } else if (state is ShowSnackbarState) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('This is ShowSnackbarState!!!!'),
//         ));
//       }
//     },
//     builder: (context, state) {
//       print('rebuild ALL');
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           state is UpdateTextState
//               ? Text('${state.text}')
//               : Text('data'),
//           const SizedBox(
//             height: 16,
//           ),
//           TextButton(
//             onPressed: () {
//               a = a + 1;
//               print('A ');
//               context
//                   .read<TestBloc>()
//                   .add(LoginButtonTappedEvent(''));
//               // !--------------------------
//               // context
//               //     .read<TestBloc>()
//               //     .add(ShowSnackBarButtonTappedEvent());
//             },
//             child: Container(
//               child: Image.asset('lib/assets/icons/camp.png'),
//             ),
//           )
//         ],
//       );
//     },
//   ),

//   Container(
//     color: Colors.amber,
//   ),
//   Container(
//     color: Colors.black,
//   ),
//   Text(
//     'data1',
//     style: TextStyle(color: Colors.black),
//   ),
// ];
