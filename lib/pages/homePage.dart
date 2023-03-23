// ignore_for_file: avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/date/bloc/date_bloc.dart';
import 'package:tripman/dateBase/bloc/date_base_bloc.dart';
import 'package:tripman/routers/router.gr.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
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
          TextEditingController _controllerDate =
              TextEditingController(text: '');
          if (state is DateInitial) {
            _controllerDate = TextEditingController(text: '');
          } else if (state is DateInfo) {
            _controllerDate = TextEditingController(text: state.date);
          }
          print(state);
          final tabs = [
            _TabIcon('lib/assets/icons/camp.png', 'Кэмпинги'),
            _TabIcon('lib/assets/icons/glamp.png', 'Глэмпинги'),
            _TabIcon('lib/assets/icons/barrel2.png', 'Бочка'),
            _TabIcon('lib/assets/icons/basa.png', 'База отдыха'),
            _TabIcon('lib/assets/icons/shale.png', 'Шале'),
          ];
          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 110,
                title: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _controllerDate,
                      decoration: InputDecoration(
                        enabled: true,
                        suffixIcon: IconButton(
                            onPressed: () async {
                              _SelectDateRange();
                            },
                            icon: const Icon(Icons.date_range)),
                        labelText: 'Даты поездки',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        counterText: '',
                        isCollapsed: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 18, 10, 18),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: IconButton(
                      iconSize: 55,
                      onPressed: () {
                        showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: Colors.black45,
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            pageBuilder: (BuildContext buildContext,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 500),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(20),
                                  color: Colors.black,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Меню',
                                            style: TextStyle(
                                              fontFamily: 'Raleway',
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                          Material(
                                            color: Colors.black,
                                            child: IconButton(
                                              onPressed: () {
                                                AutoRouter.of(context)
                                                    .pushNamed('/home');
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Material(
                                        color: Colors.black,
                                        child: InkWell(
                                          onTap: () {
                                            AutoRouter.of(context)
                                                .pushNamed('/createCamp');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              children: const [
                                                Text(
                                                  'Добавить объекты',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Material(
                                        color: Colors.black,
                                        child: InkWell(
                                          onTap: () {
                                            AutoRouter.of(context)
                                                .pushNamed('/objectOrder');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              children: const [
                                                Text(
                                                  'Объекты',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Material(
                                        color: Colors.black,
                                        child: InkWell(
                                          onTap: () {
                                            context
                                                .read<AuthenticationBloc>()
                                                .add(AuthenticationSignedOut());
                                            AutoRouter.of(context)
                                                .pushNamed('/');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              children: const [
                                                Text(
                                                  'Выход',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        width: 55,
                        height: 55,
                        child: const Icon(
                          size: 35,
                          Icons.menu,
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
                  physics: const BouncingScrollPhysics(),
                  indicatorColor: Colors.transparent,
                  isScrollable: true,
                  // onTap: (index) { },
                  tabs: [
                    for (final tab in tabs)
                      Tab(
                        child: tab,
                      ),
                  ],
                ),
              ),
              body: BlocBuilder<DateBaseBloc, DateBaseState>(
                builder: (context, state) {
                  print(state);
                  if (state is DateBaseInitial) {
                    context.read<DateBaseBloc>().add(const DateGet());
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DateBaseSuccess) {
                    if (state.listOfCamps.isEmpty) {
                      return const Center(
                        child: Text('Данных нет'),
                      );
                    } else {
                      Timestamp test = state.listOfCamps[0].closeDate![0];

                      var maps = state.listOfCamps
                          .where((element) => element.type == 'Глэмпинги')
                          .length;

                      // var openData = state.listOfCamps[0].toMap();

                      // print('openData $openData');
                      return Scaffold(
                        body: TabBarView(
                          children: [
                            _tabContent(context, state, 'Кэмпинги'),
                            _tabContent(context, state, 'Глэмпинги'),
                            _tabContent(context, state, 'Бочка'),
                            _tabContent(context, state, 'База отдыха'),
                            _tabContent(context, state, 'Шале'),
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

Widget _TabIcon(String icon, String nameIcon) {
  return Column(
    children: [
      Container(
        child: Image.asset(
          icon,
          height: 30,
          width: 30,
          color: Colors.black,
        ),
      ),
      Text(
        nameIcon,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
      ),
    ],
  );
}

Widget _tabContent(context, state, String type) {
  Size size = MediaQuery.of(context).size;

  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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

                      print('!! ${Img()}');
                      return FutureBuilder<Object>(
                          future: Img(),
                          builder: (context, snapshot) {
                            print('snaphot ${snapshot.data}');
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              height: 335,
                              child: snapshot.connectionState ==
                                      ConnectionState.done
                                  ? Stack(
                                      alignment: Alignment.bottomCenter,
                                      // fit: StackFit.expand,
                                      children: [
                                        CachedNetworkImage(
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
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
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
          return const SizedBox(
            height: 0,
          );
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