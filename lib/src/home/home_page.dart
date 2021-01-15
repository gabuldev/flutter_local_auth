import 'package:flutter/material.dart';
import 'package:local_auth/src/home/home_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  RxDisposer disposer;
  @override
  void initState() {
    disposer = rxObserver(() {
      if (controller.check.value == true) {
        controller.getBiometrics();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Auth"),
      ),
      floatingActionButton: FloatingActionButton(
        child: RxBuilder(
          builder: (_) =>
              controller.check.value ? Icon(Icons.check) : Icon(Icons.get_app),
        ),
        onPressed: () {
          controller.checkBiometrics();
        },
      ),
      body: RxBuilder(
        builder: (_) => ListView(
          children: controller.biometrics.value
              .map((e) => ListTile(
                    title: Text(e.index.toString()),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
