import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:floating_timer/helpers/settings_helper.dart';
import 'package:floating_timer/pages/home_page.dart';
import 'package:floating_timer/models/pomodoro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  windowManager.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PomodoroTimer()..init(),
        ),
        ChangeNotifierProvider(create: (_) => SettingsHelper()),
      ],
      child: MyApp(),
    )
  );

  doWhenWindowReady(() async {
    final initialSize = const Size(180, 240);
    appWindow.minSize = Size(16, 9);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.centerRight;
    appWindow.show();
    windowManager.setAlwaysOnTop(true);
    windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber)),
      home: HomePage(),
    );
  }
}