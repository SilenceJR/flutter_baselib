import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';

class UdidUi extends StatelessWidget {
  const UdidUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UDID"),
      ),
      body: Center(
        child: FutureBuilder(
          future: FlutterUdid.consistentUdid,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Text('UDID: ${snapshot.data}');
            }
          },
        ),
      ),
    );
  }
}
