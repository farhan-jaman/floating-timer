import 'package:floating_timer/models/pomodoro.dart';
import 'package:flutter/material.dart';

class SessionIndicator extends StatelessWidget {
  final PomodoroTimer provider;

  const SessionIndicator({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final progress = (provider.phase == PomodoroPhase.work)
      ? (provider.remaining.inSeconds / provider.config.pomodoro.inSeconds)
      : ((provider.phase == PomodoroPhase.shortBreak)
        ? (1 - (provider.remaining.inSeconds / provider.config.shortBreak.inSeconds))
        : 0.0);

    final double clampedProgress = (1 - progress).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.only(bottom: (width / 20).clamp(8, 24)),
      width: (width / 2).clamp(120, 600),
      height: (width / 20).clamp(16, 50),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular((width / 60).clamp(6, 18)),
        gradient: LinearGradient(
          colors: [
            Colors.greenAccent,
            Colors.white70,
          ],
          stops: [
            clampedProgress,
            clampedProgress,
          ]
        )
      ),
      child: Center(
        child: Text(
          'Session ${provider.currentSession}/${provider.config.sessions}',
          style: TextStyle(
            fontSize: (width / 28).clamp(10, 24),
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}