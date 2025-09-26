import 'package:flutter/material.dart';
import 'dart:async';
import '../services/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedOption = SettingsManager.defaultOption;
  double _selectedNumber = SettingsManager.defaultNumber;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final option = await SettingsManager.loadOption();
    final number = await SettingsManager.loadNumber();

    setState(() {
      _selectedOption = option;
      _selectedNumber = number;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await SettingsManager.saveOption(_selectedOption);
    await SettingsManager.saveNumber(_selectedNumber);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Настройки сохранены!'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _resetSettings() async {
    await SettingsManager.resetSettings();
    await _loadSettings();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Настройки сброшены!'),
        backgroundColor: Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildModeCard(
    String title,
    String description,
    int value,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: _selectedOption == value
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6C63FF), Color(0xFF9D4EDD)],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey[50]!],
                ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _selectedOption == value
                  ? Colors.white.withOpacity(0.2)
                  : Color(0xFF6C63FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: _selectedOption == value
                  ? Colors.white
                  : Color(0xFF6C63FF),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _selectedOption == value ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            description,
            style: TextStyle(
              color: _selectedOption == value
                  ? Colors.white70
                  : Colors.grey[600],
              fontSize: 12,
            ),
          ),
          trailing: Radio(
            value: value,
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value as int;
              });
            },
            activeColor: _selectedOption == value
                ? Colors.white
                : Color(0xFF6C63FF),
          ),
          onTap: () {
            setState(() {
              _selectedOption = value;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6C63FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModeCard(
                    'Режим обучения',
                    'Изучение слов с переводом и транскрипцией',
                    0,
                    Icons.auto_stories,
                  ),
                  _buildModeCard(
                    'Режим проверки',
                    'Тестирование знаний с выбором правильного перевода',
                    1,
                    Icons.quiz,
                  ),

                  SizedBox(height: 20),

                  Card(
                    elevation: 4,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.grey[50]!],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: Color(0xFF2196F3),
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Интервал',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF2196F3).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFF2196F3).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${_selectedNumber.toInt()} секунд',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2196F3),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Текущий интервал',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 25),

                            // Слайдер
                            Slider(
                              value: _selectedNumber,
                              min: SettingsManager.minNumber,
                              max: SettingsManager.maxNumber,
                              divisions:
                                  (SettingsManager.maxNumber -
                                          SettingsManager.minNumber)
                                      .toInt(),
                              label: _selectedNumber.toInt().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedNumber = value;
                                });
                              },
                              activeColor: Color(0xFF2196F3),
                              inactiveColor: Colors.grey[300],
                            ),

                            SizedBox(height: 10),

                            // Минимальное и максимальное значение
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${SettingsManager.minNumber.toInt()} сек',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                Text(
                                  '${SettingsManager.maxNumber.toInt()} сек',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Кнопки действий
                  Column(
                    children: [
                      // Кнопка сохранения
                      Container(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _saveSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: Color(0xFF4CAF50).withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Сохранить настройки',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _resetSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.red, width: 2),
                            ),
                            elevation: 2,
                            shadowColor: Colors.red.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restore, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Сбросить настройки',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}