import 'package:flutter/material.dart';
import '../utils/constants.dart';

class WaitingStateWidget extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final int selectedOption;
  final double selectedNumber;
  final VoidCallback onSkipTimer;

  const WaitingStateWidget({
    Key? key,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.selectedOption,
    required this.selectedNumber,
    required this.onSkipTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimerIcon(),
            SizedBox(height: 50),
            _buildInfoPanel(),
            SizedBox(height: 30),
            _buildNewWordButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.learningGradientStart,
            AppConstants.learningGradientEnd,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Icon(Icons.timer_outlined, size: 50, color: Colors.white),
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, color: AppConstants.primaryColor, size: 16),
              SizedBox(width: 8),
              Text(
                'Режим: ${selectedOption == 0 ? 'Обучение' : 'Проверка'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, color: AppConstants.primaryColor, size: 16),
              SizedBox(width: 8),
              Text(
                'Интервал: ${selectedNumber.toInt()} секунд',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewWordButton() {
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onSkipTimer,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.successColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          shadowColor: AppConstants.successColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Новое слово',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}