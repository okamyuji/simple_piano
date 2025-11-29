import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'injection.dart';
import 'presentation/bloc/piano/piano_bloc.dart';
import 'presentation/bloc/piano/piano_event.dart';
import 'presentation/bloc/progress/progress_bloc.dart';
import 'presentation/bloc/progress/progress_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<PianoBloc>()..add(const PianoInitializeEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<ProgressBloc>()
            ..add(const ProgressLoadEvent())
            ..add(const ProgressLoadDailyChallengeEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'シンプルピアノ',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: Routes.home,
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
