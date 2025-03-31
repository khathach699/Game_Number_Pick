// lib/pages/game/game_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_flutter/src/providers/color_match_game_provider.dart';
import 'package:game_flutter/src/providers/countdown_game_provider.dart';
import 'package:game_flutter/src/providers/matching_game_provider.dart';
import 'package:game_flutter/src/providers/quick_math_game_provider.dart';
import 'package:game_flutter/src/providers/reflex_game_provider.dart';
import 'package:game_flutter/src/providers/sequence_game_provider.dart';
import 'package:game_flutter/src/providers/programming_quiz_game_Provider.dart';
import 'package:game_flutter/src/providers/tile_swap_game_provider.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/game_provider.dart';
import 'package:game_flutter/src/providers/audio_provider.dart';
import 'package:game_flutter/src/pages/game/widgets/sequence_game_widget.dart';
import 'package:game_flutter/src/pages/game/widgets/matching_game_widget.dart';
import 'package:game_flutter/src/pages/game/widgets/reflex_game_widget.dart';
import 'package:game_flutter/src/pages/game/widgets/countdown_game_widget.dart';
import 'package:game_flutter/src/pages/game/widgets/color_match_game_widget.dart';
import 'package:game_flutter/src/pages/game/widgets/tile_swap_game_widget.dart';
import 'package:game_flutter/src/pages/game/widgets/quick_math_game_widget.dart';
import 'package:game_flutter/src/pages/game/widgets/programming_quiz_game_widget.dart';
import '../../apps/my_app.dart';

class GamePage extends StatelessWidget with RouteAware {
  static const routeName = '/game-page';
  const GamePage({super.key});

  @override
  void didPush() {
    final audioProvider = Provider.of<AudioProvider>(
      MyApp.navigatorKey.currentContext!,
      listen: false,
    );
    audioProvider.enterGamePage();
  }

  @override
  void didPop() {
    final audioProvider = Provider.of<AudioProvider>(
      MyApp.navigatorKey.currentContext!,
      listen: false,
    );
    audioProvider.exitGamePage();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    });

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    _initializeGame(context, gameProvider);

    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          body: Container(
            width: 1.sw,
            height: 1.sh,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/image 1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: _buildGameWidget(context, gameProvider),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _initializeGame(BuildContext context, GameProvider gameProvider) {
    switch (gameProvider.gameMode) {
      case GameMode.sequence:
        if (!Provider.of<SequenceGameProvider>(
          context,
          listen: false,
        ).isInitialized) {
          gameProvider.start(context);
        }
        break;
      case GameMode.matching:
        if (!Provider.of<MatchingGameProvider>(
          context,
          listen: false,
        ).isInitialized) {
          gameProvider.start(context);
        }
        break;
      case GameMode.reflex:
        if (!Provider.of<ReflexGameProvider>(
          context,
          listen: false,
        ).isInitialized) {
          gameProvider.start(context);
        }
        break;
      case GameMode.countdown:
        if (!Provider.of<CountdownGameProvider>(
          context,
          listen: false,
        ).isInitialized) {
          gameProvider.start(context);
        }
        break;
      case GameMode.colorMatch:
        if (!Provider.of<ColorMatchGameProvider>(
          context,
          listen: false,
        ).isInitialized) {
          gameProvider.start(context);
        }
        break;
      case GameMode.tileSwap:
        if (!Provider.of<TileSwapGameProvider>(
          context,
          listen: false,
        ).isInitialized) {
          gameProvider.start(context);
        }
        break;
      case GameMode.quickMath:
        if (!Provider.of<QuickMathGameProvider>(
          context,
          listen: false,
        ).isInitialized) {
          gameProvider.start(context);
        }
        break;
      case GameMode.simonSays:
        if (!Provider.of<ProgrammingQuizGameProvider>(
          context,
          listen: false,
        ).isInitialized) {
          gameProvider.start(context);
        }
        break;
    }
  }

  Widget _buildGameWidget(BuildContext context, GameProvider gameProvider) {
    switch (gameProvider.gameMode) {
      case GameMode.sequence:
        return SequenceGameWidget();
      case GameMode.matching:
        return MatchingGameWidget();
      case GameMode.reflex:
        return ReflexGameWidget();
      case GameMode.countdown:
        return CountdownGameWidget();
      case GameMode.colorMatch:
        return ColorMatchGameWidget();
      case GameMode.tileSwap:
        return TileSwapGameWidget();
      case GameMode.quickMath:
        return QuickMathGameWidget();
      case GameMode.simonSays:
        return ProgrammingQuizGameWidget();
    }
  }
}
