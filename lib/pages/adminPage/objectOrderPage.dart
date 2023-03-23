// ignore_for_file: avoid_print

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
      body: BlocListener<DateBaseBloc, DateBaseState>(
        listenWhen: (previous, current) {
          return current is DateBaseSave ? true : false;
        },
        listener: (context, state) async {
          context.read<DateBaseBloc>().add(const DateGet());
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<DateBaseBloc, DateBaseState>(
            builder: (context, state) {
              if (state is DateBaseSuccess || state is DateBaseSave) {
                return ListView.separated(
                  itemCount: state.listOfCamps.length,
                  itemBuilder: (context, index) {
                    return BlocBuilder<DateBaseBloc, DateBaseState>(
                      builder: (context, state) {
                        if (state is DateBaseInitial) {
                          context.read<DateBaseBloc>().add(const DateGet());
                          return const CircularProgressIndicator();
                        } else if (state is DateBaseSuccess ||
                            state is DateBaseSave) {
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
                                            itemBuilder: (context, index2) {
                                              print(state.listOfCamps[index]
                                                      .order!.values
                                                      .toList()[index2]
                                                  ['userPhone']);
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: BlocBuilder<DateBaseBloc,
                                                    DateBaseState>(
                                                  builder: (context, state) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Отклик',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Text(
                                                          '${state.listOfCamps[index].order!.values.toList()[index2]['userPhone']}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          '${state.listOfCamps[index].order!.values.toList()[index2]['status']}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        state.listOfCamps[index]
                                                                        .order!.values
                                                                        .toList()[index2]
                                                                    [
                                                                    'status'] ==
                                                                'Ожидание'
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.42,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              25),
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              35,
                                                                              13,
                                                                              35,
                                                                              13),
                                                                          side: const BorderSide(
                                                                              color: Colors.black,
                                                                              width: 1),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                          ),
                                                                          backgroundColor: const Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          context
                                                                              .read<DateBaseBloc>()
                                                                              .add(
                                                                                DateSave(
                                                                                  clientId: state.listOfCamps[index].order!.keys.toList()[index2],
                                                                                  AdminId: '${context.read<AuthenticationBloc>().state.props.first}',
                                                                                  userPhone: '${state.listOfCamps[index].order!.values.toList()[index2]['userPhone']}',
                                                                                  comment: '${state.listOfCamps[index].order!.values.toList()[index2]['comment']}',
                                                                                  status: 'отклонен',
                                                                                  uid: state is DateBaseSave ? state.listOfCamps[index] : state.listOfCamps[index],
                                                                                ),
                                                                              );

                                                                          print(context
                                                                              .read<DateBaseBloc>()
                                                                              .state);
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Отклонить',
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // поменять статус на приянто
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.42,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              25),
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              35,
                                                                              13,
                                                                              35,
                                                                              13),
                                                                          side: const BorderSide(
                                                                              color: Colors.black,
                                                                              width: 1),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                          ),
                                                                          backgroundColor: const Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          context
                                                                              .read<DateBaseBloc>()
                                                                              .add(
                                                                                DateSave(
                                                                                  clientId: state.listOfCamps[index].order!.keys.toList()[index2],
                                                                                  AdminId: '${context.read<AuthenticationBloc>().state.props.first}',
                                                                                  userPhone: '${state.listOfCamps[index].order!.values.toList()[index2]['userPhone']}',
                                                                                  comment: '${state.listOfCamps[index].order!.values.toList()[index2]['comment']}',
                                                                                  status: 'Принято',
                                                                                  uid: state is DateBaseSave ? state.listOfCamps[index] : state.listOfCamps[index],
                                                                                ),
                                                                              );
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Принять',
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    );
                                                  },
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
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
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                        child: Image.network(
                                                          '${snapshot.data}',
                                                          height: 110,
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
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Отклики',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
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
                                                          state
                                                                  .listOfCamps[
                                                                      index]
                                                                  .order
                                                                  ?.length
                                                                  .toString() ??
                                                              '0',
                                                          style:
                                                              const TextStyle(
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
      ),
    );
  }
}
