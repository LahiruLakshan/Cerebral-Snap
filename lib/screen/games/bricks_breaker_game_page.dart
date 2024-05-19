import 'package:cerebral_snap/screen/games/bricks_breaker.dart';
import 'package:cerebral_snap/utils/constants.dart';
import 'package:cerebral_snap/widgets/game_over.dart';
import 'package:cerebral_snap/widgets/game_pause.dart';
import 'package:cerebral_snap/widgets/game_top_bar.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class BricksBreakerGamePage extends StatefulWidget {
  const BricksBreakerGamePage({super.key, required this.title});
  final String title;
  @override
  State<BricksBreakerGamePage> createState() => _BricksBreakerGamePageState();
}



class _BricksBreakerGamePageState extends State<BricksBreakerGamePage> with WidgetsBindingObserver{

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('app resumed');
        break;
      case AppLifecycleState.inactive:
        print('app inactive');
        break;
      case AppLifecycleState.paused:
        print('app paused');
        break;
      case AppLifecycleState.detached:
        print('app detached');
        break;
      default:
        print('app default');
    }
  }

  final Game game = BricksBreaker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(panelColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          GameTopBar(
            game: game,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GameWidget(
              game: game,
              overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
                'gameOverOverlay': (context, game) => GameOver(
                      game: game,
                    ),
                'gamePauseOverlay': (context, game) => GamePause(
                      game: game,
                    ),
              },
            ),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
