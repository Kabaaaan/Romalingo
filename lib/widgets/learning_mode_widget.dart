import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LearningModeWidget extends StatelessWidget {
  final Map<dynamic, dynamic>? currentWord;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final VoidCallback onRemember;

  const LearningModeWidget({
    Key? key,
    required this.currentWord,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.onRemember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentWord == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
        ),
      );
    }

    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWordCard(),
              SizedBox(height: 30),
              _buildRememberButton(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.learningGradientStart,
            AppConstants.learningGradientEnd,
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
            Container(
              constraints: BoxConstraints(minHeight: 40),
              child: Text(
                currentWord!['en'] ?? '',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 15),
            Divider(color: Colors.white54, height: 1, thickness: 1),
            SizedBox(height: 15),
            Container(
              constraints: BoxConstraints(minHeight: 40),
              child: Text(
                currentWord!['ru'] ?? '',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (currentWord!['tr'] != null && currentWord!['tr'].isNotEmpty)
              Column(
                children: [
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Транскрипция: ${currentWord!['tr']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      constraints: BoxConstraints(minHeight: 60),
      child: ElevatedButton(
        onPressed: onRemember,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.successColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          shadowColor: AppConstants.successColor.withOpacity(0.4),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: 24),
          child: Text(
            'ЗАПОМНИЛ!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}