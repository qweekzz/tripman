import 'package:auto_route/auto_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripman/authentication/bloc/authentication_bloc.dart';
import 'package:tripman/dateBase/bloc/date_base_bloc.dart';

class ObjectOrderPage extends StatelessWidget {
  const ObjectOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Объекты',
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<DateBaseBloc, DateBaseState>(
          builder: (context, state) {
            if (state is DateBaseSuccess) {
              return ListView.separated(
                itemCount: state.listOfCamps.length,
                itemBuilder: (context, index) {
                  return BlocBuilder<DateBaseBloc, DateBaseState>(
                    builder: (context, state) {
                      if (state is DateBaseInitial) {
                        context.read<DateBaseBloc>().add(const DateGet());
                        return const CircularProgressIndicator();
                      } else if (state is DateBaseSuccess) {
                        if (state.listOfCamps.isEmpty) {
                          return const Center(
                            child: Text('Объектов нет'),
                          );
                        } else {
                          Img() async {
                            final storage = FirebaseStorage.instance;
                            String downloadURL = await storage
                                .ref(
                                    'images/${state.listOfCamps[index].img![0]}')
                                .getDownloadURL();
                            return downloadURL;
                          }

                          if (state.listOfCamps[index].adminId ==
                              context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .props
                                  .first) {
                            print('print ${state.listOfCamps.length}');
                            return InkWell(
                              onTap: () {
                                if (state
                                    .listOfCamps[index].order!.isNotEmpty) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 300,
                                        child: ListView.separated(
                                          itemCount: state.listOfCamps[index]
                                                  .order?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Отклик',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  const Text(
                                                    '1 июня - 8 июня',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  const Text(
                                                    '+7 965 33 86 789',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const _SubmitButton1(),
                                                      const _SubmitButton2(),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1,
                                                color: Colors.black,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return;
                                }
                              },
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                elevation: 3,
                                child: SizedBox(
                                  height: 110,
                                  child: Row(
                                    children: [
                                      FutureBuilder<Object>(
                                          future: Img(),
                                          builder: (context, snapshot) {
                                            return Expanded(
                                                child: Container(
                                              child: snapshot.data != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      10)),
                                                      child: Image.network(
                                                        '${snapshot.data}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : Container(
                                                      color: Colors.white,
                                                    ),
                                            ));
                                          }),
                                      Flexible(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.listOfCamps[index]
                                                            .name ??
                                                        'название',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    state.listOfCamps[index]
                                                            .price ??
                                                        'цена пуста',
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Отклики',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    width: 26,
                                                    height: 26,
                                                    child: Center(
                                                      child: Text(
                                                        state.listOfCamps[index]
                                                                .order?.length
                                                                .toString() ??
                                                            '0',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }
                      } else {
                        return const Text('Объектов нет');
                      }
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 15);
                },
              );
            } else {
              return const Text('state is missing');
            }
          },
        ),
      ),
    );
  }
}

class _SubmitButton1 extends StatelessWidget {
  const _SubmitButton1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.42,
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(35, 13, 35, 13),
            side: const BorderSide(color: Colors.black, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {},
          child: const Text(
            'Отклонить',
            style: TextStyle(color: Colors.black),
          ),
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
    return Container(
      width: size.width * 0.42,
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(35, 13, 35, 13),
            side: const BorderSide(color: Colors.black, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.black,
          ),
          onPressed: () {},
          child: const Text(
            'Принять',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
