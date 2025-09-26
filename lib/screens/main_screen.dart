// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';

import '../services/settings_manager.dart';
import '../services/notification_service.dart';
import '../services/transleter_core.dart';

import './settings_screen.dart';

import '../utils/animation_utils.dart';
import '../utils/constants.dart';

import '../widgets/learning_mode_widget.dart';
import '../widgets/checking_mode_widget.dart';
import '../widgets/waiting_state_widget.dart';
import '../widgets/result_dialog.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedOption = SettingsManager.defaultOption;
  double _selectedNumber = SettingsManager.defaultNumber;
  bool _notificationPending = false;
  bool _showResultDialog = false;

  late NotificationService _notificationService;
  late TransleterCore _transleterCore;
  Timer? _notificationTimer;
  late AnimationController _animationController;

  Map<dynamic, dynamic>? _currentWord;
  Map<dynamic, Map>? _checkingWords;
  String? _dialogTitle;
  String? _dialogMessage;
  bool? _isCorrectAnswer;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeServices() {
    _notificationService = NotificationService();
    _transleterCore = TransleterCore();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _scaleAnimation = AnimationUtils.createScaleAnimation(_animationController);
    _fadeAnimation = AnimationUtils.createFadeAnimation(_animationController);
  }

  Future<void> _initializeApp() async {
    await _notificationService.initialize();
    await _transleterCore.initialize();
    await _loadSettings();
    await _checkNotificationStatus();
    _animationController.forward();
  }

  Future<void> _loadSettings() async {
    final option = await SettingsManager.loadOption();
    final number = await SettingsManager.loadNumber();

    setState(() {
      _selectedOption = option;
      _selectedNumber = number;
    });
  }

  Future<void> _checkNotificationStatus() async {
    final pending = await SettingsManager.isNotificationPending();
    final timerActive = await SettingsManager.isTimerActive();
    final scheduledTime = await SettingsManager.getScheduledNotificationTime();

    if (pending) {
      setState(() => _notificationPending = true);
      await _loadWordForStudy();
      return;
    }

    // Таймер был активен, но приложение перезапустили
    if (timerActive && scheduledTime != null) {
      final now = DateTime.now();
      final timeDifference = scheduledTime.difference(now);

      if (timeDifference <= Duration.zero) {
        // Время уведомления уже прошло - Восстанавливаем состояние
        await _handleMissedNotification();
      } else {
        // Таймер ещё не сработал - перезапускаем
        await _restartTimer(timeDifference);
      }
      return;
    }

    // Ничего не активно - запускаем новый таймер
    await _startNotificationTimer();
  }

  Future<void> _handleMissedNotification() async {
    final mode = _getModeName();
    await _notificationService.showNotification(
      AppConstants.appName,
      'Пропущенное слово в режиме "$mode"!',
    );

    await SettingsManager.setNotificationPending(true);
    await SettingsManager.setTimerActive(false);
    await SettingsManager.clearScheduledNotificationTime();

    setState(() => _notificationPending = true);
    await _loadWordForStudy();
    _restartAnimation();
  }

  Future<void> _restartTimer(Duration remainingTime) async {
    _notificationTimer?.cancel();

    _notificationTimer = Timer(remainingTime, () async {
      await _showNotificationAndUpdateState();
    });
  }

  Future<void> _startNotificationTimer() async {
    _notificationTimer?.cancel();

    await SettingsManager.setTimerActive(true);
    await SettingsManager.setNotificationPending(false);

    final seconds = _selectedNumber.toInt();
    final scheduledTime = DateTime.now().add(Duration(seconds: seconds));
    await SettingsManager.setScheduledNotificationTime(scheduledTime);

    _notificationTimer = Timer(Duration(seconds: seconds), () async {
      await _showNotificationAndUpdateState();
    });
  }

  Future<void> _showNotificationAndUpdateState() async {
    final mode = _getModeName();
    await _notificationService.showNotification(
      AppConstants.appName,
      'Тебя ждёт новое слово в режиме "$mode"!',
    );

    await SettingsManager.setNotificationPending(true);
    await SettingsManager.setTimerActive(false);
    await SettingsManager.clearScheduledNotificationTime();
    await SettingsManager.setLastNotificationTime(DateTime.now());

    if (mounted) {
      setState(() => _notificationPending = true);
      await _loadWordForStudy();
      _restartAnimation();
    }
  }

  Future<void> _skipNotificationTimer() async {
    _notificationTimer?.cancel();

    await SettingsManager.setTimerActive(false);
    await SettingsManager.clearScheduledNotificationTime();
    await SettingsManager.setNotificationPending(true);
    await SettingsManager.setLastNotificationTime(DateTime.now());

    if (mounted) {
      setState(() => _notificationPending = true);
      await _loadWordForStudy();
      _restartAnimation();
    }
  }

  Future<void> _loadWordForStudy() async {
    if (_selectedOption == 0) {
      _currentWord = await _transleterCore.getWordToLearningMode();
      _checkingWords = null;
    } else {
      _checkingWords = await _transleterCore.getWordToChekingMode();
      _currentWord = null;
    }
    setState(() {});
  }

  Future<void> _handleArrival() async {
    _notificationTimer?.cancel();
    await SettingsManager.setNotificationPending(false);
    await SettingsManager.setTimerActive(false);
    await SettingsManager.clearScheduledNotificationTime();

    setState(() {
      _notificationPending = false;
      _currentWord = null;
      _checkingWords = null;
    });

    Future.delayed(Duration(seconds: 2), _startNotificationTimer);
  }

  void _handleRememberButton() {
    _setResultDialog(
      title: 'Поздравляем!',
      message: 'Вы успешно запомнили слово!',
      isCorrect: true,
    );
  }

  void _handleAnswer(bool isCorrect) {
    _setResultDialog(
      title: isCorrect ? 'Правильно!' : 'Неправильно',
      message: isCorrect
          ? 'Вы выбрали правильный перевод!'
          : 'Правильный перевод: ${_checkingWords!['main_word']?['ru']}',
      isCorrect: isCorrect,
    );
  }

  void _setResultDialog({
    required String title,
    required String message,
    required bool isCorrect,
  }) {
    setState(() {
      _dialogTitle = title;
      _dialogMessage = message;
      _isCorrectAnswer = isCorrect;
      _showResultDialog = true;
    });
  }

  void _showResultDialogFunc() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ResultDialog(
          title: _dialogTitle!,
          message: _dialogMessage!,
          isCorrect: _isCorrectAnswer!,
          secondsUntilNextWord: _selectedNumber.toInt(),
          onClose: () {
            Navigator.of(context).pop();
            setState(() => _showResultDialog = false);
            _handleArrival();
          },
        );
      },
    );
  }

  String _getModeName() => _selectedOption == 0 ? 'Обучение' : 'Проверка';

  void _restartAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  Widget _buildContent() {
    if (!_notificationPending) {
      return WaitingStateWidget(
        scaleAnimation: _scaleAnimation,
        fadeAnimation: _fadeAnimation,
        selectedOption: _selectedOption,
        selectedNumber: _selectedNumber,
        onSkipTimer: _skipNotificationTimer,
      );
    }

    return Column(
      children: [
        Expanded(
          child: _selectedOption == 0
              ? LearningModeWidget(
                  currentWord: _currentWord,
                  scaleAnimation: _scaleAnimation,
                  fadeAnimation: _fadeAnimation,
                  onRemember: _handleRememberButton,
                )
              : CheckingModeWidget(
                  checkingWords: _checkingWords,
                  scaleAnimation: _scaleAnimation,
                  fadeAnimation: _fadeAnimation,
                  onAnswer: _handleAnswer,
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showResultDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showResultDialogFunc();
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
              await _loadSettings();
              await _checkNotificationStatus();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  }
}
