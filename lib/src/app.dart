import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: Center(child: Text('Ekran roboczy'))),
    );
  }
}
