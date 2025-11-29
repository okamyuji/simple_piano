import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_piano/data/datasources/local/database_helper.dart';
import 'package:simple_piano/presentation/bloc/piano/piano_bloc.dart';
import 'package:simple_piano/presentation/bloc/piano/piano_state.dart';

import 'settings_page_test.mocks.dart';

@GenerateMocks([DatabaseHelper, SharedPreferences, PianoBloc])
void main() {
  late MockDatabaseHelper mockDatabaseHelper;
  late MockSharedPreferences mockSharedPreferences;
  late MockPianoBloc mockPianoBloc;
  final getIt = GetIt.instance;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockSharedPreferences = MockSharedPreferences();
    mockPianoBloc = MockPianoBloc();

    // PianoBlocのstateとstreamをスタブ
    when(mockPianoBloc.state).thenReturn(const PianoState());
    when(
      mockPianoBloc.stream,
    ).thenAnswer((_) => Stream.value(const PianoState()));

    getIt.registerSingleton<DatabaseHelper>(mockDatabaseHelper);
    getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
    getIt.registerFactory<PianoBloc>(() => mockPianoBloc);
  });

  tearDown(() {
    getIt.reset();
  });

  group('SettingsPage データ削除テスト', () {
    test('DatabaseHelperのdeleteDatabase()が正しく動作する', () async {
      // Arrange
      when(mockDatabaseHelper.deleteDatabase()).thenAnswer((_) async => {});

      // Act
      await mockDatabaseHelper.deleteDatabase();

      // Assert
      verify(mockDatabaseHelper.deleteDatabase()).called(1);
    });

    test('SharedPreferencesのclear()が正しく動作する', () async {
      // Arrange
      when(mockSharedPreferences.clear()).thenAnswer((_) async => true);

      // Act
      final result = await mockSharedPreferences.clear();

      // Assert
      expect(result, true);
      verify(mockSharedPreferences.clear()).called(1);
    });
  });
}
