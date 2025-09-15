import 'package:floating_timer/features/timer/pomodoro_text_button.dart';
import 'package:floating_timer/features/timer/restart_pomodoro.dart';
import 'package:floating_timer/features/timer/session_indicator.dart';
import 'package:floating_timer/helpers/settings_helper.dart';
import 'package:floating_timer/models/pomodoro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerUi extends StatefulWidget {
  const TimerUi({super.key});

  @override
  State<TimerUi> createState() => _TimerUiState();
}

class _TimerUiState extends State<TimerUi> with TickerProviderStateMixin {

  late final AnimationController _playPauseController;
  late final AnimationController _refreshController;
  late final AnimationController _editController;

  @override
  void initState() {
    super.initState();

    _playPauseController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _refreshController = AnimationController(
      duration: Duration(milliseconds: 180),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _editController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _refreshController.dispose();
    _editController.dispose();

    super.dispose();
  }

  String getTimeString(Duration time) {
    final minutes = time.inMinutes.toString().padLeft(2, '0');
    final seconds = (time.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;

    return Consumer<PomodoroTimer>(
      builder: (context, provider, child) {
        _playPauseController.value = provider.isRunning ? 1.0 : 0.0;
        
        if (provider.phase == PomodoroPhase.done) {
          return RestartPomodoro(
            fontSize: (windowWidth / 20).clamp(16, 48),
            onPressed: () {
              provider.reset();
              _playPauseController.reverse();
            },
          );
        }
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   '${provider.currentSession}/${provider.config.sessions}',
              //   style: TextStyle(
              //     fontSize: (windowWidth / 20).clamp(14, 48),
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              
              SessionIndicator(provider: provider),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PomodoroTextButton(
                      onTap: () {
                        _playPauseController.reverse();
                        provider.skipTo(PomodoroPhase.work);
                      },
                      isFocused: (provider.phase == PomodoroPhase.work),
                      text: 'Focus',
                      fontSize: (windowWidth /24).clamp(12, 36),
                    ),

                    SizedBox(width: 12,),

                    PomodoroTextButton(
                      onTap: () {
                        _playPauseController.reverse();
                        provider.skipTo(PomodoroPhase.shortBreak);
                      },
                      isFocused: (provider.phase == PomodoroPhase.shortBreak),
                      text: 'Break',
                      fontSize: (windowWidth /24).clamp(12, 36),
                    ),
                  ],
                ),
              ),
              Text(
                getTimeString(provider.remaining),
                style: TextStyle(
                  fontSize: (windowWidth / 6).clamp(48, 120),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
        
                  // play-pause button
                  IconButton(
                    onPressed: () {
                      if (provider.isRunning) {
                        provider.stop();
                        _playPauseController.reverse();
                      } else {
                        provider.start();
                        _playPauseController.forward();
                      }
                    },
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _playPauseController,
                      size: (windowWidth / 10).clamp(24, 65),
                    ),
                  ),
        
                  // reset button
                  RotationTransition(
                    turns: _refreshController,
                    child: IconButton(
                      onPressed: () {
                        provider.reset();
                        _refreshController.forward().then((_) => _refreshController.reset());
                        if (provider.isRunning) _playPauseController.reverse();
                      },
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: (windowWidth / 10).clamp(24, 65),
                      ),
                    ),
                  ),

                  // settings button
                  RotationTransition(
                    turns: _editController,
                    child: IconButton(
                      onPressed: () {
                        _editController.forward().then((_) => _editController.reverse());
                        context.read<SettingsHelper>().changePage(true);
                      },
                      icon: Icon(
                        Icons.settings_rounded,
                        size: (windowWidth / 10).clamp(20, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}