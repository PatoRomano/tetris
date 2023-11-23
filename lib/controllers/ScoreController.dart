import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ScoreManager {
  late String _filePath;

  ScoreManager() {
    _initFilePath();
  }

  Future<void> _initFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/scores.json';
  }

  Future<List<Score>> readScores() async {
    String filePath = await getFilePath();
    try {
      final file = File(filePath);
      if (!(await file.exists())) {
        return [];
      }

      final contents = await file.readAsString();
      final parsed = jsonDecode(contents) as List<dynamic>;

      return parsed.map((scoreJson) => Score.fromJson(scoreJson)).toList();
    } catch (e) {
      print('error al leer el codigo: $e');
      return [];
    }
  }

  Future<String> getFilePath() async {
    await _initFilePath();
    return _filePath;
  }

  Future<void> writeScores(List<Score> scores) async {
    try {
      final file = File(_filePath);
      final jsonString = jsonEncode(scores.map((score) => score.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('error al escribir el codigo: $e');
    }
  }
}

class Score {
  final String playerName;
  final int score;

  Score({required this.playerName, required this.score});

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'score': score,
    };
  }

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      playerName: json['playerName'],
      score: json['score'],
    );
  }
}
