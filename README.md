# Romalingo - Приложение для изучения английского языка

<img src="https://img.shields.io/badge/Flutter-3.35.3-blue?logo=flutter" alt="Flutter Version"> <img src="https://img.shields.io/badge/Dart-3.9.2-blue?logo=dart" alt="Dart Version"> <img src="https://img.shields.io/badge/Android-3DDC84?logo=android&logoColor=white"> 

Приложение для изучения английских слов с помощью интервальных повторений и проверки знаний. Учите слова в удобном темпе с системой уведомлений.

## ✨ Особенности

- **📚 Два режима обучения**: Изучение новых слов и проверка знаний
- **⏰ Гибкие интервалы**: Настраиваемое время между повторениями
- **🔔 Умные уведомления**: Напоминания о времени учить слова
- **🎯 Восстановление сессии**: Приложение запоминает состояние после перезапуска
- **🎨 Красивый интерфейс**: Современный дизайн с анимациями
- **📊 Прогресс обучения**: Отслеживание запомненных слов

## 🏗️ Архитектура проекта

```
lib/
├── main.dart
├── screens/
│   ├── main_screen.dart       
│   └── settings_screen.dart    
├── widgets/
│   ├── learning_mode_widget.dart 
│   ├── checking_mode_widget.dart 
│   ├── waiting_state_widget.dart 
│   └── result_dialog.dart       
├── services/
│   ├── notification_service.dart 
│   ├── settings_manager.dart    
│   └── transleter_core.dart    
└── utils/
    ├── constants.dart       
    └── animation_utils.dart    
```

## 🚀 Установка и запуск

### Предварительные требования

- Flutter SDK 3.19.5 или выше
- Dart 3.3.0 или выше
- Android Studio / VS Code

### Установка
```bash
git clone https://github.com/your-username/romalingo.git
cd romalingo
flutter pub get
flutter run
```

1. **Отладка**:
```dart
flutter run --debug
```
2. **Сборка**:
```bash
flutter build apk --release
```

## ⚙️ Настройка

### Разрешения

Приложение запрашивает следующие разрешения:

- **Уведомления**: Для напоминаний об обучении
- **Хранилище**: Для сохранения прогресса и настроек

### Конфигурация

Основные настройки доступны в файле `lib/utils/constants.dart`:

```dart
class AppConstants {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Duration animationDuration = Duration(milliseconds: 800);
  // ... другие константы
}
```