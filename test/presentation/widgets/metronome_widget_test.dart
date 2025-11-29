import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/core/constants/app_constants.dart';
import 'package:simple_piano/presentation/widgets/metronome_widget.dart';

void main() {
  group('MetronomeWidget', () {
    testWidgets('初期BPMが正しく設定される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MetronomeWidget(initialBpm: 120)),
        ),
      );

      expect(find.text('120'), findsOneWidget);
    });

    testWidgets('デフォルトBPMはAppConstants.defaultBpmである', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MetronomeWidget())),
      );

      expect(find.text('${AppConstants.defaultBpm}'), findsOneWidget);
    });

    testWidgets('BPMを増加できる', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MetronomeWidget(initialBpm: 100)),
        ),
      );

      expect(find.text('100'), findsOneWidget);

      // BPM増加ボタンを探してタップ
      final increaseButton = find.byIcon(Icons.add);
      expect(increaseButton, findsOneWidget);
      await tester.tap(increaseButton);
      await tester.pump();

      expect(find.text('101'), findsOneWidget);
    });

    testWidgets('BPMを減少できる', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MetronomeWidget(initialBpm: 100)),
        ),
      );

      expect(find.text('100'), findsOneWidget);

      // BPM減少ボタンを探してタップ
      final decreaseButton = find.byIcon(Icons.remove);
      expect(decreaseButton, findsOneWidget);
      await tester.tap(decreaseButton);
      await tester.pump();

      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('BPMはminBpm未満にならない', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MetronomeWidget(initialBpm: AppConstants.minBpm),
          ),
        ),
      );

      final decreaseButton = find.byIcon(Icons.remove);
      await tester.tap(decreaseButton);
      await tester.pump();

      expect(find.text('${AppConstants.minBpm}'), findsOneWidget);
    });

    testWidgets('BPMはmaxBpmを超えない', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MetronomeWidget(initialBpm: AppConstants.maxBpm),
          ),
        ),
      );

      final increaseButton = find.byIcon(Icons.add);
      await tester.tap(increaseButton);
      await tester.pump();

      expect(find.text('${AppConstants.maxBpm}'), findsOneWidget);
    });

    testWidgets('再生ボタンが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MetronomeWidget())),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text('開始'), findsOneWidget);
    });

    testWidgets('再生ボタンをタップすると停止アイコンに変わる', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MetronomeWidget())),
      );

      final playButton = find.text('開始');
      await tester.tap(playButton);
      await tester.pump();

      expect(find.byIcon(Icons.stop), findsOneWidget);
      expect(find.text('停止'), findsOneWidget);
    });

    testWidgets('停止ボタンをタップすると再生アイコンに戻る', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MetronomeWidget())),
      );

      // 再生開始
      final playButton = find.text('開始');
      await tester.tap(playButton);
      await tester.pump();

      // 停止
      final stopButton = find.text('停止');
      await tester.tap(stopButton);
      await tester.pump();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text('開始'), findsOneWidget);
    });

    testWidgets('BPM変更時にコールバックが呼ばれる', (tester) async {
      int? changedBpm;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MetronomeWidget(
              initialBpm: 100,
              onBpmChanged: (bpm) {
                changedBpm = bpm;
              },
            ),
          ),
        ),
      );

      final increaseButton = find.byIcon(Icons.add);
      await tester.tap(increaseButton);
      await tester.pump();

      expect(changedBpm, 101);
    });

    testWidgets('BPM増加ボタン（+10）が機能する', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MetronomeWidget(initialBpm: 100)),
        ),
      );

      expect(find.text('100'), findsOneWidget);

      final addCircleButton = find.byIcon(Icons.add_circle_outline);
      await tester.tap(addCircleButton);
      await tester.pump();

      expect(find.text('110'), findsOneWidget);
    });

    testWidgets('BPM減少ボタン（-10）が機能する', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MetronomeWidget(initialBpm: 100)),
        ),
      );

      expect(find.text('100'), findsOneWidget);

      final removeCircleButton = find.byIcon(Icons.remove_circle_outline);
      await tester.tap(removeCircleButton);
      await tester.pump();

      expect(find.text('90'), findsOneWidget);
    });

    testWidgets('メトロノームタイトルが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MetronomeWidget())),
      );

      expect(find.text('メトロノーム'), findsOneWidget);
    });

    testWidgets('BPMテキストが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MetronomeWidget())),
      );

      expect(find.text('BPM'), findsOneWidget);
    });
  });
}
