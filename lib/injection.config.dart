// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'data/datasources/audio/audio_engine.dart' as _i1000;
import 'data/datasources/local/database_helper.dart' as _i759;
import 'data/datasources/local/local_storage_datasource.dart' as _i772;
import 'data/repositories/audio_repository_impl.dart' as _i774;
import 'data/repositories/lesson_repository_impl.dart' as _i770;
import 'data/repositories/progress_repository_impl.dart' as _i377;
import 'data/repositories/recording_repository_impl.dart' as _i429;
import 'data/services/lesson_data_service.dart' as _i221;
import 'domain/repositories/audio_repository.dart' as _i94;
import 'domain/repositories/lesson_repository.dart' as _i262;
import 'domain/repositories/progress_repository.dart' as _i75;
import 'domain/repositories/recording_repository.dart' as _i463;
import 'domain/usecases/get_daily_challenge.dart' as _i537;
import 'domain/usecases/get_lessons.dart' as _i142;
import 'domain/usecases/get_user_progress.dart' as _i731;
import 'domain/usecases/play_note.dart' as _i981;
import 'domain/usecases/record_session.dart' as _i376;
import 'domain/usecases/save_progress.dart' as _i50;
import 'domain/usecases/start_recording.dart' as _i888;
import 'domain/usecases/stop_note.dart' as _i106;
import 'domain/usecases/stop_recording.dart' as _i121;
import 'injection_module.dart' as _i212;
import 'presentation/bloc/lesson/lesson_bloc.dart' as _i613;
import 'presentation/bloc/piano/piano_bloc.dart' as _i951;
import 'presentation/bloc/progress/progress_bloc.dart' as _i243;
import 'presentation/bloc/recording/recording_bloc.dart' as _i28;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    gh.lazySingleton<_i1000.AudioEngine>(() => _i1000.AudioEngine());
    gh.lazySingleton<_i759.DatabaseHelper>(() => _i759.DatabaseHelper());
    gh.lazySingleton<_i221.LessonDataService>(() => _i221.LessonDataService());
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => injectionModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i772.LocalStorageDataSource>(
      () => _i772.LocalStorageDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i94.AudioRepository>(
      () => _i774.AudioRepositoryImpl(gh<_i1000.AudioEngine>()),
    );
    gh.lazySingleton<_i75.ProgressRepository>(
      () => _i377.ProgressRepositoryImpl(
        gh<_i772.LocalStorageDataSource>(),
        gh<_i759.DatabaseHelper>(),
      ),
    );
    gh.lazySingleton<_i463.RecordingRepository>(
      () => _i429.RecordingRepositoryImpl(gh<_i759.DatabaseHelper>()),
    );
    gh.lazySingleton<_i262.LessonRepository>(
      () => _i770.LessonRepositoryImpl(
        gh<_i221.LessonDataService>(),
        gh<_i75.ProgressRepository>(),
      ),
    );
    gh.factory<_i888.StartRecording>(
      () => _i888.StartRecording(gh<_i463.RecordingRepository>()),
    );
    gh.factory<_i121.StopRecording>(
      () => _i121.StopRecording(gh<_i463.RecordingRepository>()),
    );
    gh.factory<_i981.PlayNote>(
      () => _i981.PlayNote(gh<_i94.AudioRepository>()),
    );
    gh.factory<_i106.StopNote>(
      () => _i106.StopNote(gh<_i94.AudioRepository>()),
    );
    gh.factory<_i142.GetLessons>(
      () => _i142.GetLessons(gh<_i262.LessonRepository>()),
    );
    gh.factory<_i28.RecordingBloc>(
      () => _i28.RecordingBloc(
        startRecordingUseCase: gh<_i888.StartRecording>(),
        stopRecordingUseCase: gh<_i121.StopRecording>(),
        recordingRepository: gh<_i463.RecordingRepository>(),
      ),
    );
    gh.factory<_i537.GetDailyChallenge>(
      () => _i537.GetDailyChallenge(gh<_i75.ProgressRepository>()),
    );
    gh.factory<_i731.GetUserProgress>(
      () => _i731.GetUserProgress(gh<_i75.ProgressRepository>()),
    );
    gh.factory<_i376.RecordSession>(
      () => _i376.RecordSession(gh<_i75.ProgressRepository>()),
    );
    gh.factory<_i50.SaveProgress>(
      () => _i50.SaveProgress(gh<_i75.ProgressRepository>()),
    );
    gh.factory<_i243.ProgressBloc>(
      () => _i243.ProgressBloc(
        getUserProgressUseCase: gh<_i731.GetUserProgress>(),
        saveProgressUseCase: gh<_i50.SaveProgress>(),
        recordSessionUseCase: gh<_i376.RecordSession>(),
        getDailyChallengeUseCase: gh<_i537.GetDailyChallenge>(),
        progressRepository: gh<_i75.ProgressRepository>(),
      ),
    );
    gh.factory<_i613.LessonBloc>(
      () => _i613.LessonBloc(
        getLessonsUseCase: gh<_i142.GetLessons>(),
        lessonRepository: gh<_i262.LessonRepository>(),
      ),
    );
    gh.factory<_i951.PianoBloc>(
      () => _i951.PianoBloc(
        playNoteUseCase: gh<_i981.PlayNote>(),
        stopNoteUseCase: gh<_i106.StopNote>(),
        audioRepository: gh<_i94.AudioRepository>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i212.InjectionModule {}
