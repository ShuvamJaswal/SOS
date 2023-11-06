import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:sos/src/home_screen/data/call_help_controller.dart';

class HelpButton extends ConsumerStatefulWidget {
  const HelpButton({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HelpButtonState();
}

class _HelpButtonState extends ConsumerState<HelpButton>
    with SingleTickerProviderStateMixin {
  bool allow = true;
  Color but_col = Color.fromRGBO(235, 30, 0, 1);
  late AnimationController animationController;

  void start() {
    animationController.repeat();
  }

  void stop() {
    animationController.stop();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!allow) {
          return;
        }
        allow = false;

        stop();
        String data =
            await ref.watch(callHelpControllerProvider.notifier).callHelp();
        allow = true;
        if (data.isEmpty) {
          start();
          return;
        }
        start();
      },
      child: SizedBox(
        height: 300,
        width: 300,
        child: RippleWave(
            childTween: Tween(begin: 0.8, end: 1.0),
            color: but_col,
            // const Color.fromRGBO(235, 30, 0, 0),
            animationController: animationController,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: but_col, // Color.fromRGBO(235, 30, 0, 1),
              child: Text(
                "HELP ME !",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
      ),
    );
  }
}
