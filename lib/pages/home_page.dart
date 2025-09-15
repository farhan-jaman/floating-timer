import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:floating_timer/features/timer/timer_ui.dart';
import 'package:floating_timer/helpers/settings_helper.dart';
import 'package:floating_timer/pages/settings_page.dart';
import 'package:floating_timer/window_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.redAccent,
              Colors.amberAccent.shade100,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(
                    child: MoveWindow(),
                  ),
                  WindowButtons(),
                ],
              ),
            ),
            context.watch<SettingsHelper>().isSettings ? SettingsPage() : TimerUi(),
          ],
        ),
      ),
    );
  }
}