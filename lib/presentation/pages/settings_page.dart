import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/database_helper.dart';
import '../../injection.dart';
import '../bloc/piano/piano_bloc.dart';
import '../bloc/piano/piano_event.dart';
import '../bloc/piano/piano_state.dart';
import '../widgets/metronome_widget.dart';

/// 設定画面
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PianoBloc>(),
      child: const _SettingsPageContent(),
    );
  }
}

class _SettingsPageContent extends StatelessWidget {
  const _SettingsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // オーディオ設定
          _buildSectionHeader(context, 'オーディオ設定'),
          BlocBuilder<PianoBloc, PianoState>(
            builder: (context, state) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'マスターボリューム',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.volume_down),
                          Expanded(
                            child: Slider(
                              value: state.volume,
                              min: 0.0,
                              max: 1.0,
                              divisions: 20,
                              label: '${(state.volume * 100).round()}%',
                              onChanged: (value) {
                                context.read<PianoBloc>().add(
                                  PianoVolumeChangedEvent(volume: value),
                                );
                              },
                            ),
                          ),
                          const Icon(Icons.volume_up),
                        ],
                      ),
                      Text(
                        '${(state.volume * 100).round()}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          // メトロノーム
          _buildSectionHeader(context, 'メトロノーム'),
          const MetronomeWidget(),
          const SizedBox(height: 24),
          // アプリ情報
          _buildSectionHeader(context, 'アプリ情報'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('バージョン'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('ライセンス'),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'シンプルピアノ',
                      applicationVersion: '1.0.0',
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('ヘルプ'),
                  onTap: () {
                    _showHelpDialog(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // データ管理
          _buildSectionHeader(context, 'データ管理'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('すべてのデータを削除'),
                  onTap: () => _showDeleteDataDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// セクションヘッダーを構築
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ヘルプダイアログを表示
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ヘルプ'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '使い方',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('1. ホーム画面から「自由演奏」または「レッスン」を選択'),
              SizedBox(height: 4),
              Text('2. ピアノ鍵盤をタップして音を出す'),
              SizedBox(height: 4),
              Text('3. レッスンでは指示に従って練習'),
              SizedBox(height: 4),
              Text('4. 進捗画面で上達を確認'),
              SizedBox(height: 16),
              Text(
                'ヒント',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• 毎日少しずつ練習することが上達の秘訣です'),
              SizedBox(height: 4),
              Text('• デイリーチャレンジに挑戦してモチベーションを維持'),
              SizedBox(height: 4),
              Text('• 録音機能で自分の演奏を聴き返しましょう'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  /// データ削除確認ダイアログを表示
  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('データ削除'),
        content: const Text('すべての進捗データ、録音、設定が削除されます。\nこの操作は取り消せません。本当に削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                debugPrint('[Settings] データ削除開始');

                // SharedPreferencesのクリア
                final prefs = getIt<SharedPreferences>();
                final success = await prefs.clear();
                debugPrint('[Settings] SharedPreferences削除: $success');

                // データベースの削除
                final dbHelper = getIt<DatabaseHelper>();
                await dbHelper.deleteDatabase();
                debugPrint('[Settings] データベース削除完了');

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('すべてのデータを削除しました'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // アプリを再起動するように促す
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('削除完了'),
                      content: const Text('データを削除しました。アプリを終了します。再度起動してください。'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            SystemNavigator.pop(); // アプリを終了
                          },
                          child: const Text('終了'),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                debugPrint('[Settings] データ削除エラー: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('削除に失敗しました: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}
