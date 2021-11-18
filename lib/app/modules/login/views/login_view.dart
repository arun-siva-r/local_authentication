import 'package:flutter/material.dart';
import 'package:flutter_app_local_auth/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0x00f59297),
        child: const Icon(
          Icons.messenger_outline_outlined,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              height: Get.height / 3,
              left: 0,
              right: 0,
              child: Image.network(
                'https://s3-alpha-sig.figma.com/img/706b/ffb9/f279e53549edcfea41a28ee8d02f8efb?Expires=1638144000&Signature=RxnjU13b3QivigU6FUcPeJtHUVjWBC02p-9Ml1aN0oif1AYB1iTPACdLP5dEATmITQaoaDUaOmmB6JQp9Id3YVsdue5zyzoCdODx3pKN2Kqy6vIij2eyMsczhnVxeMMtfBR0M8mvMqEob~UPP2SnSz9R3T-UKtRLhimJlh9o5pcrjPARk~PjxblvJTytgO1QeftPSIRfVOx0xNXFvQBrdPC3CzBwTWTs6w3~PvhpUKg1gWnxLap39l1-q27BPp9qhVXwKDc-4EaRsBjb9~zdCGsK-tUPkCtgzUkyuwxJ7dyQFb~6JpZTGnGf7SGWheg78FduKJwnzKZwawgaHuedjQ__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
                fit: BoxFit.fill,
              )),
          Positioned(
              top: Get.height / 3,
              height: Get.height - (Get.height / 3),
              left: 0,
              width: Get.width,
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                color: const Color(0x00f2ece2),
                child: Container(
                  color: const Color(0x00f2ece2),
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Text(
                        'Member Log In',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Username',
                                ),
                              ),
                              TextFormField(
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          controller.loginBioMetrics();
                                        },
                                        icon: const Icon(Icons.face))),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: MaterialButton(
                                  color: const Color(0X00f59297),
                                  child: const Text(
                                    'LOG IN',
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  onPressed: () {
                                    controller.isLoggedIn = true;
                                    Get.toNamed(Routes.HOME);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'FORGET YOUR PASSWORD',
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'HOTEL GUEST LOGIN',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
