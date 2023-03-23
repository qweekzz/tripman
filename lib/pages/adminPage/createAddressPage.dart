import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tripman/date/bloc/date_bloc.dart';
import 'package:tripman/routers/router.gr.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart' as geo;

import 'package:yandex_mapkit/yandex_mapkit.dart';

class CreateAddressPage extends StatefulWidget {
  const CreateAddressPage({
    super.key,
    required this.adminId,
    required this.name,
    required this.type,
    required this.desc,
    required this.human,
    required this.img,
    required this.closeDate,
  });
  final String adminId;
  final String name;
  final String type;
  final String desc;
  final String human;
  final List<String> img;
  final List<DateTime> closeDate;

  @override
  State<CreateAddressPage> createState() => _CreateAddressPageState();
}

class _CreateAddressPageState extends State<CreateAddressPage> {
  late YandexMapController controller;

  final geo.YandexGeocoder geocoder =
      geo.YandexGeocoder(apiKey: '29b1dd8a-2c23-446a-ae27-1a7970e05d47');

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerAddress = TextEditingController(text: '');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Адрес',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          const Center(
            child: Text(
              '2 из 3',
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
      body: BlocBuilder<DateBloc, DateState>(
        builder: (context, state) {
          if (state is DateInfo) {
            controllerAddress = TextEditingController(text: state.date);
          }
          return Column(
            children: [
              Flexible(
                flex: 3,
                child: YandexMap(
                  mapType: MapType.vector,
                  fastTapEnabled: false,
                  mapObjects: [
                    PlacemarkMapObject(
                      point: const Point(
                          latitude: 54.71627413875991,
                          longitude: 56.01481599238483),
                      mapId: const MapObjectId('start_placemark'),
                    )
                  ],
                  onMapCreated:
                      (YandexMapController yandexMapController) async {
                    controller = yandexMapController;
                    controller.getPoint(const ScreenPoint(
                        x: 54.71627413875991, y: 56.01481599238483));

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
                  onMapTap: (Point point) async {
                    final geo.GeocodeResponse geocodeFromPoint =
                        await geocoder.getGeocode(
                      geo.GeocodeRequest(
                        geocode: geo.PointGeocode(
                            latitude: point.latitude,
                            longitude: point.longitude),
                        lang: geo.Lang.ru,
                      ),
                    );
                    CircleMarker(
                        point: LatLng(54.71627413875991, 56.01481599238483),
                        radius: 10);
                    context.read<DateBloc>().add(DateChangedButton(
                        geocodeFromPoint.firstFullAddress.formattedAddress ??
                            'error'));
                  },
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        controller: controllerAddress,
                        onChanged: (value) {},
                        style: const TextStyle(),
                        decoration: const InputDecoration(
                          // contentPadding: EdgeInsets.all(5),
                          // border: OutlineInputBorder(),
                          labelText: 'Адрес',
                          // errorText: state.email.invalid ? 'invalid email' : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () async {
                                AutoRouter.of(context).push(CreatePriceRoute(
                                  adminId: widget.adminId,
                                  name: widget.name,
                                  type: widget.type,
                                  desc: widget.desc,
                                  human: widget.human,
                                  img: widget.img,
                                  closeDate: widget.closeDate,
                                  address: controllerAddress.text,
                                ));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  SizedBox(),
                                  Text('Цена и контакты'),
                                  Icon(Icons.arrow_forward)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


//  Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextField(
//                   controller: controllerAddress,
//                   onChanged: (value) {
//                     print(controllerAddress.text);
//                   },
//                   style: const TextStyle(),
//                   decoration: const InputDecoration(
//                     // contentPadding: EdgeInsets.all(5),
//                     // border: OutlineInputBorder(),
//                     labelText: 'Адрес',
//                     // errorText: state.email.invalid ? 'invalid email' : null,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
//                         side: const BorderSide(color: Colors.black, width: 1),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         backgroundColor: Colors.white,
//                       ),
//                       onPressed: () {
//                         AutoRouter.of(context).navigateBack();
//                       },
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
//                           side: const BorderSide(color: Colors.black, width: 1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           backgroundColor: Colors.black,
//                         ),
//                         onPressed: () {
//                           AutoRouter.of(context).push(CreatePriceRoute(
//                             adminId: widget.adminId,
//                             name: widget.name,
//                             type: widget.type,
//                             desc: widget.desc,
//                             human: widget.human,
//                             img: widget.img,
//                             closeDate: widget.closeDate,
//                             address: controllerAddress.text,
//                           ));
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: const [
//                             SizedBox(),
//                             Text('Цена и контакты'),
//                             Icon(Icons.arrow_forward)
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),