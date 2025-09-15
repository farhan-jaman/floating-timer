import 'package:floating_timer/features/edit_pomodoro/edit_input.dart';
import 'package:floating_timer/helpers/settings_helper.dart';
import 'package:floating_timer/models/pomodoro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final provider = context.read<PomodoroTimer>();

    int pomodoro = provider.config.pomodoro.inMinutes;
    int shortBreak = provider.config.shortBreak.inMinutes;
    int sessions = provider.config.sessions;

    void onClosed() {
      provider.editPomodoro(Pomodoro(
        pomodoro: Duration(minutes: pomodoro),
        shortBreak: Duration(minutes: shortBreak),
        sessions: sessions,
      ));
    }

    return Expanded(
      child: ListView(
        children: [
          IconButton(
            onPressed: () {
              context.read<SettingsHelper>().changePage(false);
              onClosed();
            },
            icon: Icon(
              Icons.close_rounded,
              size: (width / 20).clamp(20, 36),
            ),
          ),
          EditInput(
            label: 'Pomodoro',
            selectedValue: pomodoro,
            onChanged: (value) => pomodoro = value ?? 0,
          ),
          EditInput(
            label: 'Break',
            selectedValue: shortBreak,
            onChanged: (value) => shortBreak = value ?? 0,
          ),
          EditInput(
            label: 'Sessions',
            selectedValue: sessions,
            onChanged: (value) => sessions = value ?? 0,
          ),
        ],
      ),
    );
  }
}