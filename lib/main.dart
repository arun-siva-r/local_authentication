// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_supportState == _SupportState.unknown)
                  CircularProgressIndicator()
                else if (_supportState == _SupportState.supported)
                  Text("This device is supported")
                else
                  Text("This device is not supported"),
                Divider(height: 100),
                Text('Can check biometrics: $_canCheckBiometrics\n'),
                ElevatedButton(
                  child: const Text('Check biometrics'),
                  onPressed: _checkBiometrics,
                ),
                Divider(height: 100),
                Text('Available biometrics: $_availableBiometrics\n'),
                ElevatedButton(
                  child: const Text('Get available biometrics'),
                  onPressed: _getAvailableBiometrics,
                ),
                Divider(height: 100),
                Text('Current State: $_authorized\n'),
                (_isAuthenticating)
                    ? ElevatedButton(
                        onPressed: _cancelAuthentication,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Cancel Authentication"),
                            Icon(Icons.cancel),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          ElevatedButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Authenticate'),
                                Icon(Icons.perm_device_information),
                              ],
                            ),
                            onPressed: _authenticate,
                          ),
                          ElevatedButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_isAuthenticating
                                    ? 'Cancel'
                                    : 'Authenticate: biometrics only'),
                                Icon(Icons.fingerprint),
                              ],
                            ),
                            onPressed: _authenticateWithBiometrics,
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}



/// Code
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_app_authentication/screens/homepage.dart';
// import 'package:local_auth/local_auth.dart';

// void main() {
//   runApp(const MyHomeApp());
// }

// class MyHomeApp extends StatelessWidget {
//   const MyHomeApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp());
//   }
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   final LocalAuthentication auth = LocalAuthentication();
//   bool _isDeviceSupported = false;
//   bool _isLoggedIn = false;

//   @override
//   void initState() {
//     if (!kIsWeb) {
//       auth
//           .isDeviceSupported()
//           .then((bool isSupported) => _isDeviceSupported = isSupported);
//     }
//     WidgetsBinding.instance?.addObserver(this);
//     super.initState();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _isLoggedIn) {
//       _loginBioMetrics();
//     }

//     super.didChangeAppLifecycleState(state);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance?.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0x00f59297),
//         child: const Icon(
//           Icons.messenger_outline_outlined,
//           color: Colors.black,
//         ),
//         onPressed: () {},
//       ),
//       body: Stack(
//         children: <Widget>[
//           Positioned(
//               top: 0,
//               height: 375,
//               left: 0,
//               right: 0,
//               child: Image.network(
//                 'https://s3-alpha-sig.figma.com/img/706b/ffb9/f279e53549edcfea41a28ee8d02f8efb?Expires=1638144000&Signature=RxnjU13b3QivigU6FUcPeJtHUVjWBC02p-9Ml1aN0oif1AYB1iTPACdLP5dEATmITQaoaDUaOmmB6JQp9Id3YVsdue5zyzoCdODx3pKN2Kqy6vIij2eyMsczhnVxeMMtfBR0M8mvMqEob~UPP2SnSz9R3T-UKtRLhimJlh9o5pcrjPARk~PjxblvJTytgO1QeftPSIRfVOx0xNXFvQBrdPC3CzBwTWTs6w3~PvhpUKg1gWnxLap39l1-q27BPp9qhVXwKDc-4EaRsBjb9~zdCGsK-tUPkCtgzUkyuwxJ7dyQFb~6JpZTGnGf7SGWheg78FduKJwnzKZwawgaHuedjQ__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
//                 fit: BoxFit.fill,
//               )),
//           Positioned(
//               top: 370,
//               height: MediaQuery.of(context).size.height - 370,
//               left: 0,
//               width: MediaQuery.of(context).size.width,
//               child: Card(
//                 shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20))),
//                 color: const Color(0x00f2ece2),
//                 child: Container(
//                   color: const Color(0x00f2ece2),
//                   padding: const EdgeInsets.only(left: 25, right: 25),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       const Text(
//                         'Member Log In',
//                         style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black),
//                       ),
//                       Card(
//                         shape: const RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10, right: 10),
//                           child: Column(
//                             children: <Widget>[
//                               TextFormField(
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 textInputAction: TextInputAction.next,
//                                 decoration: const InputDecoration(
//                                   border: UnderlineInputBorder(),
//                                   labelText: 'Username',
//                                 ),
//                               ),
//                               TextFormField(
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 textInputAction: TextInputAction.next,
//                                 decoration: InputDecoration(
//                                     border: const UnderlineInputBorder(),
//                                     labelText: 'Password',
//                                     suffixIcon: IconButton(
//                                         onPressed: () async {
//                                           _loginBioMetrics();
//                                         },
//                                         icon: const Icon(Icons.face))),
//                               ),
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: MaterialButton(
//                                   color: const Color(0X00f59297),
//                                   child: const Text(
//                                     'LOG IN',
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.black),
//                                   ),
//                                   onPressed: () {
//                                     _isLoggedIn = true;
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const HomePage()));
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: MaterialButton(
//                                   onPressed: () {},
//                                   child: const Text(
//                                     'FORGET YOUR PASSWORD',
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.black),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         shape: const RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                         child: Container(
//                           height: 50,
//                           padding: const EdgeInsets.only(left: 10, right: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: const <Widget>[
//                               Text(
//                                 'HOTEL GUEST LOGIN',
//                                 style: TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w400,
//                                     color: Colors.black),
//                               ),
//                               Icon(Icons.keyboard_arrow_right)
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )),
//         ],
//       ),
//     );
//   }

//   void _loginBioMetrics() async {
//     if(kIsWeb) {
//       return;
//     }
//     final bool canCheckBioMetric = await auth.canCheckBiometrics;
//     List<BiometricType> availableBiometrics =
//     await auth.getAvailableBiometrics();
//     if (_isDeviceSupported && canCheckBioMetric && availableBiometrics.isNotEmpty) {
//       bool authenticated = await auth.authenticate(
//       localizedReason: 'Login to the app',
//           useErrorDialogs: true,
//           stickyAuth: true,
//           biometricOnly: true);
//       if (authenticated && !_isLoggedIn) {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => const HomePage()));
//             _isLoggedIn = true;
//       }
//       return;
//     }
//     _isLoggedIn = false;
//     const snackBar = SnackBar(content: Text('Not Supported'));

//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     return;
//   }
// }
