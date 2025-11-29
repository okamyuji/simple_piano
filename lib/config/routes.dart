import 'package:flutter/material.dart';

import '../domain/entities/lesson.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/lesson_page.dart';
import '../presentation/pages/lesson_practice_page.dart';
import '../presentation/pages/piano_page.dart';
import '../presentation/pages/progress_page.dart';
import '../presentation/pages/settings_page.dart';

/// ルート名定数
class Routes {
  Routes._();

  static const String home = '/';
  static const String piano = '/piano';
  static const String lesson = '/lesson';
  static const String lessonPractice = '/lesson_practice';
  static const String progress = '/progress';
  static const String settings = '/settings';
}

/// ルート生成
class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.piano:
        return MaterialPageRoute(builder: (_) => const PianoPage());
      case Routes.lesson:
        return MaterialPageRoute(builder: (_) => const LessonPage());
      case Routes.lessonPractice:
        final lesson = settings.arguments as Lesson;
        // LessonPracticePageはcontext.read<PianoBloc>()を使うため、
        // builderでcontextを使う必要がある
        return MaterialPageRoute(
          builder: (context) => LessonPracticePage(lesson: lesson),
        );
      case Routes.progress:
        return MaterialPageRoute(builder: (_) => const ProgressPage());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('ルートが見つかりません: ${settings.name}')),
          ),
        );
    }
  }
}
