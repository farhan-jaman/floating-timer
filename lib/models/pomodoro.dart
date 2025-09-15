import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:floating_timer/helpers/pomodoro_storage.dart';
import 'package:flutter/material.dart';

class Pomodoro {
  final Duration pomodoro;
  final Duration shortBreak;
  final Duration? longBreak;
  final int sessions;

  Pomodoro({
    required this.pomodoro,
    required this.shortBreak,
    this.longBreak,
    this.sessions = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'pomodoro': pomodoro.inSeconds,
      'shortBreak': shortBreak.inSeconds,
      'longBreak': longBreak?.inSeconds,
      'sessions': sessions,
    };
  }

  factory Pomodoro.fromJson(Map<String, dynamic> json) {
    return Pomodoro(
      pomodoro: Duration(seconds: json['pomodoro']),
      shortBreak: Duration(seconds: json['shortBreak']),
      longBreak: Duration(seconds: (json['longBreak']) ?? 0),
      sessions: json['sessions'],
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static Pomodoro fromJsonString(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return Pomodoro.fromJson(data);
  }
}

// P O M O D O R O    T I M E R
enum PomodoroPhase { work, shortBreak, done }

class PomodoroTimer extends ChangeNotifier {
  Pomodoro config = Pomodoro(pomodoro: Duration(minutes: 25), shortBreak: Duration(minutes: 5));
  int currentSession = 1;
  PomodoroPhase phase = PomodoroPhase.work;
  bool isEven = false;
  bool isRunning = false;

  Duration remaining = Duration.zero;
  Timer? _timer;

  final player = AudioPlayer();

  Future<void> init() async {
    config = await PomodoroStorage.loadPomodoro() ?? Pomodoro(
      pomodoro: Duration(minutes: 25),
      shortBreak: Duration(minutes: 5),
      sessions: 3,
    );
    remaining = config.pomodoro;
    notifyListeners();
  }

  Future<void> editPomodoro(Pomodoro newPomodoro) async {
    if (
      newPomodoro.pomodoro != config.pomodoro
      || newPomodoro.shortBreak != config.shortBreak
      || newPomodoro.sessions != config.sessions
    ) {
      config = newPomodoro;
      remaining = config.pomodoro;
      currentSession = 1;
      phase = PomodoroPhase.work;
      isRunning = false;
      await PomodoroStorage.savePomodoro(config);
      notifyListeners();
    }
  }

  void start() {
    isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await playSound();

      if (remaining.inSeconds > 0) {
        remaining -= Duration(seconds: 1);
        isEven = (remaining.inSeconds % 2 == 0);
      } else {
        _nextPhase();
      }
      notifyListeners();
    });
  }

  void _nextPhase() {
    if (phase == PomodoroPhase.work) {
      if (currentSession >= config.sessions) {
        phase = PomodoroPhase.done;
        _timer?.cancel();
        return;
      }
      phase = PomodoroPhase.shortBreak;
      remaining = config.shortBreak;
    } else {
      currentSession++;
      phase = PomodoroPhase.work;
      remaining = config.pomodoro;
    }
  }

  void stop() {
    isRunning = false;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void reset() {
    isRunning = false;
    _timer?.cancel();
    _timer = null;
    currentSession = 1;
    phase = PomodoroPhase.work;
    remaining = config.pomodoro;
    notifyListeners();
  }

  void skipTo(PomodoroPhase newPhase) {
    isRunning = false;
    _timer?.cancel();
    _timer = null;
    phase = newPhase;
    if (newPhase == PomodoroPhase.work) remaining = config.pomodoro;
    if (newPhase == PomodoroPhase.shortBreak) remaining = config.shortBreak;
    notifyListeners();
  }

  Future<void> playSound() async {
    await player.setVolume(0.2);
    if (phase == PomodoroPhase.work) {
      if (remaining == config.pomodoro) {
        await player.stop();
        await player.play(AssetSource('bell.mp3'));
      }
      if (remaining.inSeconds == 3) {
        await player.stop();
        await player.play(AssetSource('break-start.wav'));
      }
    }
    if (phase == PomodoroPhase.shortBreak) {
      if (remaining.inSeconds == 8) {
        await player.stop();
        await player.play(AssetSource('focus-start.wav'));
      }
    }
  }
}