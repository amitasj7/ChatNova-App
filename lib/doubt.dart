import 'package:flutter/material.dart';

class Doubt extends StatefulWidget {
  const Doubt({super.key});

  @override
  State<Doubt> createState() => _DoubtState();
}

class _DoubtState extends State<Doubt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Expanded(
            child: Container(
          height: MediaQuery.of(context).size.height * 3,
          color: Colors.teal,
        )),
      ),
    );
  }
}
