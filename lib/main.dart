import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Dice'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const DicePage(),
      ),
    );
  }
}

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;
  bool isRolling = false;

  // Web Audio Context for realistic sound synthesis
  // html.AudioContext? _audioCtx;

  // Play a single click/clack sound representing a dice impact
  // void _playDiceImpactSound() {
  //   try {
  //     _audioCtx ??= html.AudioContext();

  //     final now = _audioCtx!.currentTime!;

  //     // 1. Noise buffer for high-frequency plastic friction/shattering sound
  //     final bufferSize = (_audioCtx!.sampleRate! * 0.04).toInt(); // 40ms noise burst
  //     final buffer = _audioCtx!.createBuffer(1, bufferSize, _audioCtx!.sampleRate!);
  //     final data = buffer.getChannelData(0);
  //     final rand = Random();

  //     for (int i = 0; i < bufferSize; i++) {
  //       data[i] = rand.nextDouble() * 2 - 1;
  //     }

  //     final noiseSource = _audioCtx!.createBufferSource();
  //     noiseSource.buffer = buffer;

  //     // Filter to simulate hard plastic/acrylic container body sound
  //     final filter = _audioCtx!.createBiquadFilter();
  //     filter.type = 'bandpass';
  //     filter.frequency!.value = 1800 + rand.nextInt(600); // Dynamic resonance pitch
  //     filter.Q!.value = 3.0;

      // Gain envelope for sudden impact decay
  //     final noiseGain = _audioCtx!.createGain();
  //     noiseGain.gain!.setValueAtTime(0.4, now);
  //     noiseGain.gain!.exponentialRampToValueAtTime(0.001, now + 0.035);

  //     noiseSource.connect(filter);
  //     filter.connect(noiseGain);
  //     noiseGain.connect(_audioCtx!.destination!);

  //     noiseSource.start(now);

  //     // 2. Tonal pop for solid body wooden/plastic thud
  //     final osc = _audioCtx!.createOscillator();
  //     final oscGain = _audioCtx!.createGain();

  //     osc.type = 'triangle';
  //     osc.frequency!.setValueAtTime(220 + rand.nextInt(80), now);
  //     osc.frequency!.exponentialRampToValueAtTime(40, now + 0.03);

  //     oscGain.gain!.setValueAtTime(0.5, now);
  //     oscGain.gain!.exponentialRampToValueAtTime(0.001, now + 0.03);

  //     osc.connect(oscGain);
  //     oscGain.connect(_audioCtx!.destination!);

  //     osc.start(now);
  //     osc.stop(now + 0.035);
  //   } catch (e) {
  //     // Handle browser audio context restrictions gracefully
  //   }
  // }

  // Play a sequence of dice rattles matching the timing of your audio clip
  // void playDiceSoundSequence() {
  //   // Exact rhythm intervals matching the audio sample (in milliseconds)
  //   final delays = [0, 80, 160, 230, 310, 390, 480, 560];

  //   for (int delay in delays) {
  //     Future.delayed(Duration(milliseconds: delay), () {
  //       if (mounted) {
  //         _playDiceImpactSound();
  //       }
  //     });
  //   }
  // }

  final AudioPlayer _audioPlayer = AudioPlayer();

Future<void> playDiceSound() async {
  await _audioPlayer.stop();
  await _audioPlayer.play(
    AssetSource('sounds/dice_roll.mp3'),
  );
}

  void rollDice() {
    if (isRolling) return;

    setState(() {
      isRolling = true;
    });

    // Trigger the rhythmic dice rattling sound sequence
    playDiceSound();

    int counter = 0;
    // Rapidly change numbers to match the sound duration (~650ms total)
    Timer.periodic(const Duration(milliseconds: 70), (timer) {
      setState(() {
        leftDiceNumber = Random().nextInt(6) + 1;
        rightDiceNumber = Random().nextInt(6) + 1;
      });

      counter++;
      if (counter >= 9) {
        timer.cancel(); // Stop animation
        setState(() {
          isRolling = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/images/img$leftDiceNumber.jpeg'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/images/img$rightDiceNumber.jpeg'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, right: 24.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: isRolling ? null : rollDice,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: const Text(
                'Roll Dice',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}