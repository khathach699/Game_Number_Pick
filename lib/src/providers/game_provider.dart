// lib/providers/game_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sequence_game_provider.dart';
import 'matching_game_provider.dart';
import 'reflex_game_provider.dart';
import 'countdown_game_provider.dart';
import 'color_match_game_provider.dart';
import 'tile_swap_game_provider.dart';
import 'quick_math_game_provider.dart';
import 'simon_says_game_provider.dart';

enum GameMode {
  sequence,
  matching,
  reflex,
  countdown,
  colorMatch,
  tileSwap,
  quickMath,
  simonSays,
}

class GameProvider with ChangeNotifier {
  GameMode _gameMode = GameMode.sequence;
  GameMode get gameMode => _gameMode;

  void setGameMode(GameMode mode) {
    _gameMode = mode;
    notifyListeners();
  }

  void start(BuildContext context) {
    switch (_gameMode) {
      case GameMode.sequence:
        Provider.of<SequenceGameProvider>(
          context,
          listen: false,
        ).start(context);
        break;
      case GameMode.matching:
        Provider.of<MatchingGameProvider>(
          context,
          listen: false,
        ).start(context);
        break;
      case GameMode.reflex:
        Provider.of<ReflexGameProvider>(context, listen: false).start(context);
        break;
      case GameMode.countdown:
        Provider.of<CountdownGameProvider>(
          context,
          listen: false,
        ).start(context);
        break;
      case GameMode.colorMatch:
        Provider.of<ColorMatchGameProvider>(
          context,
          listen: false,
        ).start(context);
        break;
      case GameMode.tileSwap:
        Provider.of<TileSwapGameProvider>(
          context,
          listen: false,
        ).start(context);
        break;
      case GameMode.quickMath:
        Provider.of<QuickMathGameProvider>(
          context,
          listen: false,
        ).start(context);
        break;
      case GameMode.simonSays:
        Provider.of<SimonSaysGameProvider>(
          context,
          listen: false,
        ).start(context);
        break;
    }
  }

  void reset(BuildContext context) {
    switch (_gameMode) {
      case GameMode.sequence:
        Provider.of<SequenceGameProvider>(
          context,
          listen: false,
        ).reset(context);
        break;
      case GameMode.matching:
        Provider.of<MatchingGameProvider>(
          context,
          listen: false,
        ).reset(context);
        break;
      case GameMode.reflex:
        Provider.of<ReflexGameProvider>(context, listen: false).reset(context);
        break;
      case GameMode.countdown:
        Provider.of<CountdownGameProvider>(
          context,
          listen: false,
        ).reset(context);
        break;
      case GameMode.colorMatch:
        Provider.of<ColorMatchGameProvider>(
          context,
          listen: false,
        ).reset(context);
        break;
      case GameMode.tileSwap:
        Provider.of<TileSwapGameProvider>(
          context,
          listen: false,
        ).reset(context);
        break;
      case GameMode.quickMath:
        Provider.of<QuickMathGameProvider>(
          context,
          listen: false,
        ).reset(context);
        break;
      case GameMode.simonSays:
        Provider.of<SimonSaysGameProvider>(
          context,
          listen: false,
        ).reset(context);
        break;
    }
  }

  void handleClick(dynamic item, int index, BuildContext context) {
    switch (_gameMode) {
      case GameMode.sequence:
        Provider.of<SequenceGameProvider>(
          context,
          listen: false,
        ).handleClick(item, context);
        break;
      case GameMode.matching:
        Provider.of<MatchingGameProvider>(
          context,
          listen: false,
        ).handleClick(item, index, context);
        break;
      case GameMode.reflex:
        Provider.of<ReflexGameProvider>(
          context,
          listen: false,
        ).handleClick(index, context);
        break;
      case GameMode.countdown:
        Provider.of<CountdownGameProvider>(
          context,
          listen: false,
        ).handleClick(item, context);
        break;
      case GameMode.colorMatch:
        Provider.of<ColorMatchGameProvider>(
          context,
          listen: false,
        ).handleClick(item, context);
        break;
      case GameMode.tileSwap:
        Provider.of<TileSwapGameProvider>(
          context,
          listen: false,
        ).handleClick(item, index, context);
        break;
      case GameMode.quickMath:
        Provider.of<QuickMathGameProvider>(
          context,
          listen: false,
        ).handleClick(item, context);
        break;
      case GameMode.simonSays:
        Provider.of<SimonSaysGameProvider>(
          context,
          listen: false,
        ).handleClick(index, context);
        break;
    }
  }
}
