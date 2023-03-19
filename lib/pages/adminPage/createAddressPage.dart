import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tripman/routers/router.gr.dart';

class CreateAddressPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final TextEditingController controllerAddress =
        TextEditingController(text: '');
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: controllerAddress,
              onChanged: (value) {
                print(controllerAddress.text);
              },
              style: const TextStyle(),
              decoration: const InputDecoration(
                // contentPadding: EdgeInsets.all(5),
                // border: OutlineInputBorder(),
                labelText: 'Адрес',
                // errorText: state.email.invalid ? 'invalid email' : null,
              ),
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
                    onPressed: () {
                      AutoRouter.of(context).push(CreatePriceRoute(
                        adminId: adminId,
                        name: name,
                        type: type,
                        desc: desc,
                        human: human,
                        img: img,
                        closeDate: closeDate,
                        address: controllerAddress.text,
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  }
}
