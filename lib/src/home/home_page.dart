import 'package:flutter/material.dart';
import 'package:local_auth/src/home/home_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

extension RxNotifierExt<T> on RxNotifier<T> {
  bool compare(T a) => a == this.value;
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  final _key = GlobalKey<ScaffoldState>();
  RxDisposer disposer;
  @override
  void initState() {
    disposer = rxObserver(() {
      if (controller.check.value == true) {
        controller.getBiometrics();
      }
      if (controller.status.compare(Status.awaiting)) {
        _key.currentState.showBottomSheet((context) => BottomSheet(
            onClosing: () {},
            builder: (context) => Material(
                  child: RxBuilder(
                      builder: (context) => Container(
                          height: 300,
                          child: Text(
                            controller.status.toString(),
                          ))),
                )));
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
      key: _key,
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
                    onTap: () {
                      controller.didAuthenticate();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
