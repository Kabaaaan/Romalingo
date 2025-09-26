import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CheckingModeWidget extends StatelessWidget {
  final Map<dynamic, Map>? checkingWords;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final Function(bool) onAnswer;

  const CheckingModeWidget({
    Key? key,
    required this.checkingWords,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.onAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (checkingWords == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
        ),
      );
    }

    final mainWord = checkingWords!['main_word'];
    final helpWord = checkingWords!['help_word'];

    List<Map<String, dynamic>> options = [
      {'text': mainWord?['ru'], 'isCorrect': true},
      {'text': helpWord?['ru'], 'isCorrect': false},
    ];
    options.shuffle();

    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuestionCard(mainWord),
              ...options.map((option) => _buildOptionButton(option)).toList(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Map<dynamic, dynamic>? mainWord) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.checkingGradientStart,
            AppConstants.checkingGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Выберите правильный перевод:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            Text(
              mainWord?['en'] ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (mainWord?['tr'] != null && mainWord?['tr'].isNotEmpty)
              Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Транскрипция: ${mainWord?['tr']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(Map<String, dynamic> option) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      constraints: BoxConstraints(minHeight: 60),
      child: ElevatedButton(
        onPressed: () => onAnswer(option['isCorrect']),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppConstants.checkingGradientStart,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          shadowColor: Colors.black12,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: 40),
          child: Text(
            option['text'] ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}