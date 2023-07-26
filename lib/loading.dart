import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Center(
          child: Container(
              child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: Colors.green,
          ),
          SizedBox(width: 5),
          Text("Loading please wait...",
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.blueGrey,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold)),
        ],
      ))),
    ));
  }
}
