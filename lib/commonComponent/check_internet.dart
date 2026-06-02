import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:v_verify/commonComponent/custom_button.dart';

import '../screen/Bottom/bottomNavbar.dart';

void checkInternet(BuildContext context) async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    _showMyDialog(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("No Internet Connection"),
      backgroundColor: Colors.red,
    ));
  } else {}
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'No Internet Connection',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please Turn On Your Internet And Retry',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        actions: <Widget>[
          CustomButton(
            text: "Retry",
            gradientColors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorDark,
            ],
            onTap: () async {
              final List<ConnectivityResult> connectivityResult =
                  await (Connectivity().checkConnectivity());
              if (connectivityResult.contains(ConnectivityResult.none)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "No internet connection please check your internet!"),
                  backgroundColor: Colors.red,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Internet is connected",
                  ),
                  backgroundColor: Colors.green,
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => BottomNavigationScreen(),
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
