import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class TransleterCore {
  static const filename = 'words.json';
  late List<Map> dictionary_data;
  late File _jsonFile;
  var random = Random();

  Future<void> initialize() async {
    await _initFile();
    dictionary_data = await getDataFromFile();
  }

  /// Инициализирует файл словаря в директории приложения.
  Future<void> _initFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    _jsonFile = File(filePath);

    if (!await _jsonFile.exists()) {
      await _createInitialFile();
    }
  }

  /// Создает начальный файл словаря.
  Future<void> _createInitialFile() async {
    try {
      final initialData = await rootBundle.loadString('assets/words.json');
      await _jsonFile.writeAsString(initialData);
    } catch (e) {
      final initialData = [];
      await _jsonFile.writeAsString(jsonEncode(initialData));
    }
  }

  Future<List<Map>> getDataFromFile() async {
    try {
      var input = await _jsonFile.readAsString();
      if (input.isEmpty) return [];

      var map = jsonDecode(input) as List;
      return map.cast<Map>();
    } catch (e) {
      await _createInitialFile();
      return [];
    }
  }

  Future<void> saveDataToFile() async {
    var jsonString = JsonEncoder.withIndent('  ').convert(dictionary_data);
    await _jsonFile.writeAsString(jsonString);
  }

  Future<Map> getWordToLearningMode() async {
    if (dictionary_data.isEmpty) {
      throw Exception('Словарь пуст!');
    }

    var unlearnedWords = dictionary_data
        .where((word) => !word['is_learned'])
        .toList();
    if (unlearnedWords.isEmpty) {
      throw Exception('Все слова уже изучены!');
    }

    int idx;
    do {
      idx = random.nextInt(dictionary_data.length);
    } while (dictionary_data[idx]['is_learned'] == true);

    dictionary_data[idx]['is_learned'] = true;
    await saveDataToFile();

    return dictionary_data[idx];
  }

  Future<Map<String, Map>> getWordToChekingMode() async {
    if (dictionary_data.isEmpty) {
      throw Exception('Словарь пуст!');
    }

    var unlearnedWords = dictionary_data
        .where((word) => !word['is_learned'])
        .toList();
    if (unlearnedWords.isEmpty) {
      throw Exception('Все слова уже изучены!');
    }

    int idx;
    int idx2;
    do {
      idx = random.nextInt(dictionary_data.length);
    } while (dictionary_data[idx]['is_learned'] == true);

    dictionary_data[idx]['is_learned'] = true;
    await saveDataToFile();

    idx2 = random.nextInt(dictionary_data.length);
    return {
      'main_word': dictionary_data[idx],
      'help_word': dictionary_data[idx2],
    };
  }
}
