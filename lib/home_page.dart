import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:day_01_counter_app/widgets/button_widget.dart';
import 'package:day_01_counter_app/widgets/reset_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //========================= Variables =========================
  int _counter = 0;
  late AudioPlayer _audioPlayer;

  late AnimationController _counterAnimationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _counterAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double?> _backgroundAnimation;

  //========================= Initialization =========================

  @override
  void initState() {
    super.initState();

    // Initialize the audio player
    _audioPlayer = AudioPlayer();

    // counter Animation Controller

    _counterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // button Animation Controller
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // background Animation Controller
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // counter scale Animation
    _counterAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _counterAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // button scale Animation
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // background color Animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.linear,
      ),
    );
  }

  //========================= Lifecycle =========================

  @override
  void dispose() {
    _counterAnimationController.dispose();
    _buttonAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  //========================= Actions =========================

  void _playCustomSound(String soundFile) async {
    await _audioPlayer.play(AssetSource(soundFile));
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _animateCounter();
    _animateButton();
    _playCustomSound('sounds/coin.mp3');
    HapticFeedback.lightImpact();
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
    _animateCounter();
    _animateButton();
    SystemSound.play(SystemSoundType.click);
    // _playCustomSound('sounds/coin.mp3');
    HapticFeedback.lightImpact();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    SystemSound.play(SystemSoundType.alert);
    // _playCustomSound('assets/sounds/coin.mp3');
    HapticFeedback.lightImpact();
  }

  void _animateCounter() {
    _counterAnimationController.forward().then((_) {
      _counterAnimationController.reverse();
    });
  }

  void _animateButton() {
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });
  }

  //========================= UI =========================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(
                  _backgroundAnimation.value! * 2 * math.pi,
                ),
                colors:
                    isDark
                        ? [
                          const Color(0xff1A1A2E),
                          const Color(0xFF16213E),
                          const Color(0xFF0F3460),
                          const Color(0xFF533A71),
                        ]
                        : [
                          const Color(0xFFE8F5E8),
                          const Color(0xFFF0F8FF),
                          const Color(0xFFF5F0FF),
                          const Color(0xFFFFE8F5),
                        ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Header
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "Counter",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2.0,
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),

                    // Counter Display
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _counterAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _counterAnimation.value,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors:
                                        isDark
                                            ? [
                                              colorScheme.surface.withOpacity(
                                                0.1,
                                              ),
                                              colorScheme.surface.withOpacity(
                                                0.5,
                                              ),
                                            ]
                                            : [
                                              Colors.white.withOpacity(0.9),
                                              Colors.white.withOpacity(0.6),
                                            ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.1,
                                      ),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color:
                                          isDark
                                              ? Colors.black.withOpacity(0.3)
                                              : Colors.black.withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w200,
                                      color: colorScheme.primary,
                                      letterSpacing: 1.5,
                                    ),
                                    duration: const Duration(microseconds: 300),
                                    child: Text(
                                      '$_counter',
                                      key: ValueKey<int>(_counter),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Action Buttons
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Decrement Button
                          AnimatedBuilder(
                            animation: _buttonAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _buttonAnimation.value,
                                child: ButtonWidget(
                                  icon: Icons.remove,
                                  onPressed: _decrementCounter,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorScheme.error,
                                      colorScheme.error.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // increment Button
                          AnimatedBuilder(
                            animation: _buttonAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _buttonAnimation.value,
                                child: ButtonWidget(
                                  icon: Icons.add,
                                  onPressed: _incrementCounter,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorScheme.error,
                                      colorScheme.error.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Reset Button
                    Expanded(
                      flex: 1,
                      child: ResetButton(
                        onPressed: _resetCounter,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
