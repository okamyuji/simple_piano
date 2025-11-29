# シンプルピアノ学習アプリ

初心者向けのピアノ学習アプリケーションです。
楽しく続けられる練習環境を提供し、段階的にピアノ演奏技術を習得できます。

## アプリケーション概要

このアプリは、ピアノ初心者が挫折せずに学習を続けられることを目的としています。
コンパクトな鍵盤で基礎から学び、体系的なレッスンと励ましメッセージで学習をサポートします。

**バージョン**: 1.0.0  
**対応プラットフォーム**: iOS 13.0+, Android 5.0+ (API 21+)  
**開発フレームワーク**: Flutter 3.10.0+

## 主な機能

### 1. ピアノ演奏機能

- **オクターブ切り替え対応**: C2からC7までの5オクターブに対応（デフォルトはC4-C6）
- **リアルタイム音源生成**: WAVファイルを動的に生成し、複数の倍音を含むピアノらしい音色を実現
- **ポリフォニック再生**: 8つの音を同時に鳴らせる和音演奏対応
- **視覚的フィードバック**: 鍵盤押下時のアニメーションとハプティックフィードバック
- **音量調整**: マスターボリュームコントロール（0-100%）

### 2. レッスンシステム

- **5レベル15レッスン**: 段階的な学習カリキュラム
    - レベル1: ドレミの基礎（3レッスン）
    - レベル2: 音階練習（3レッスン）
    - レベル3: 簡単なメロディ（3レッスン）
    - レベル4: 両手練習（3レッスン）
    - レベル5: 曲の完成（3レッスン）
- **インタラクティブな練習画面**:
    - 現在の目標音符の表示
    - リアルタイム進捗バー
    - 正解率の表示
    - 目標精度達成で次レッスン解除
- **自動進捗記録**: セッション時間と演奏音符数を自動記録

### 3. 進捗管理

シンプルで分かりやすい進捗表示：

- **レッスン完了**: 15レッスン中の達成数を視覚的に表示
- **総練習時間**: 累積練習時間の記録
- **連続練習**: ストリーク日数でモチベーション維持
- **演奏音符数**: 総演奏数の記録

すべての進捗データは`UserProgress`エンティティで一元管理され、データの整合性を保証します。

### 4. 練習サポート機能

- **メトロノーム**:
    - BPM調整（40-208）
    - 視覚的なビート表示
    - ダウンビート/アップビートの区別
- **自由演奏モード**: レッスンの制約なしで自由に演奏
- **設定画面**
    - 音量調整
    - データ削除（練習データのリセット）
    - アプリ情報の表示

## 技術仕様

### アーキテクチャ

Clean Architectureを採用し、以下の3層構造で実装しています。

#### Domain層（ビジネスロジック）

- **エンティティ**: `Lesson`, `Note`, `PracticeSession`, `UserProgress`, `DailyChallenge`
- **ユースケース**: 各機能の実行ロジック
- **リポジトリインターフェース**: データ層への抽象化

#### Data層（データアクセス）

- **リポジトリ実装**: ドメイン層のインターフェースを実装
- **データソース**:
    - `LocalStorageDataSource`: SharedPreferencesでのキーバリュー保存
    - `DatabaseHelper`: SQLiteでのトランザクション管理
    - `AudioEngine`: リアルタイムWAV生成とオーディオ再生
- **モデル**: JSONシリアライズ/デシリアライズ対応

#### Presentation層（UI/UX）

- **BLoC**: `flutter_bloc`による状態管理
- **ページ**: ホーム、ピアノ演奏、レッスン、進捗、設定
- **ウィジェット**: 再利用可能なコンポーネント

#### 設計原則

1. **Single Source of Truth**: `UserProgress`を唯一の情報源とし、すべてのリポジトリが参照
2. **依存性注入**: `get_it`と`injectable`による完全なDI
3. **疎結合**: 各層は抽象（インターフェース）に依存
4. **テスト容易性**: 全レイヤーでモック可能な設計

### 使用技術

#### 状態管理とDI

- flutter_bloc 8.1.6（状態管理）
- get_it 8.0.2（依存性注入コンテナ）
- injectable 2.5.0（DI自動生成）

#### 音声処理

- audioplayers 6.1.0（音声再生エンジン）
    - リアルタイムWAV生成による高品質な音源
    - 8チャンネルポリフォニック対応
    - iOS/Android両対応のオーディオセッション管理

#### データ永続化

- shared_preferences 2.3.3（`UserProgress`のJSON保存）
- sqflite 2.4.1（`PracticeSession`と`DailyChallenge`の保存）
- path_provider 2.1.5（一時WAVファイルのパス管理）
- sqflite_common_ffi 2.3.3（テスト用インメモリDB）

#### ユーティリティ

- freezed 2.5.7（イミュータブルクラス生成）
- json_serializable 6.8.0（JSON変換）
- equatable 2.0.7（値オブジェクト比較）
- dartz 0.10.1（関数型プログラミング）

### 動作環境

- **iOS**: 13.0以降（iPhone/iPad対応）
- **Android**: 5.0以降（API Level 21+）
- **Flutter SDK**: 3.10.0以降
- **Dart SDK**: 3.10.0以降

### テスト品質

- **ユニットテスト**: 136テスト（全てPass）
- **統合テスト**: SQLiteを使用した実際のDB操作テスト
- **E2Eテスト**: Maestroによる完全なユーザーフローテスト
- **カバレッジ目標**: 全レイヤーで80%以上を維持

## 開発環境のセットアップ

### 前提条件

- Flutter SDK 3.10.0以降
- Dart SDK 3.10.0以降
- iOS開発の場合：Xcode 14.0以降
- Android開発の場合：Android Studio

### 初期セットアップ

```bash
# リポジトリのクローン
git clone <repository-url>
cd simple_piano

# 依存関係のインストール
flutter pub get

# コード生成の実行
flutter pub run build_runner build --delete-conflicting-outputs
```

### 開発用ビルドの実行

```bash
# iOSシミュレータで実行
flutter run -d "iPhone 16e"

# Android エミュレータで実行
flutter run -d emulator-5554

# デバッグモードでホットリロード有効
flutter run --debug
```

## テスト

このプロジェクトは包括的なテストスイートを備えています。

### ユニットテストの実行

```bash
# すべてのユニットテストを実行（136テスト）
flutter test

# 統合テストのみ実行
flutter test test/integration/

# カバレッジレポート付きで実行
flutter test --coverage

# カバレッジレポートの表示（macOS/Linux）
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

#### テストの構成

- **ドメイン層テスト**: エンティティとユースケースのテスト
- **データ層テスト**: リポジトリとデータソースのテスト
- **プレゼンテーション層テスト**: BLoCとウィジェットのテスト
- **統合テスト**: `ProgressRepositoryImpl`のSQLite実操作テスト

### E2Eテスト（Maestro）の実行

Maestroを使用した完全なUI自動テストを実装しています。

```bash
# 前提：Maestroのインストール
curl -Ls "https://get.maestro.mobile.dev" | bash

# iOSシミュレータを起動
open -a Simulator

# すべてのE2Eテストを実行
maestro test .maestro/*.yaml

# 個別のテストを実行
maestro test .maestro/01_home_page_test.yaml
```

#### E2Eテストの内容

- **01_home_page_test.yaml**: ホーム画面のナビゲーションテスト
- **02_piano_page_test.yaml**: ピアノ演奏とオクターブ切り替えテスト
- **03_lesson_page_test.yaml**: レッスン選択と練習画面テスト
- **04_progress_page_test.yaml**: 進捗表示とデータ整合性テスト
- **05_settings_page_test.yaml**: 設定変更とデータ削除テスト
- **06_full_user_flow_test.yaml**: レッスン完了から進捗反映までの完全フロー

## リリースビルド

### iOSリリースビルド

```bash
# リリースビルドの作成
flutter build ios --release

# IPAファイルの作成（App Store配布用）
flutter build ipa --release
```

成果物の場所は以下の通りです。

- アプリバンドル：build/ios/iphoneos/Runner.app
- IPAファイル：build/ios/ipa/simple_piano.ipa

### Androidリリースビルド

```bash
# APKファイルの作成
flutter build apk --release

# App Bundle（Google Play推奨形式）の作成
flutter build appbundle --release
```

成果物の場所は以下の通りです。

- APKファイル：build/app/outputs/flutter-apk/app-release.apk
- App Bundle：build/app/outputs/bundle/release/app-release.aab

## インストール方法

### iOS実機へのインストール

最も簡単な方法はFlutterコマンドを使用することです。

```bash
# iPhoneをMacにUSB接続してから実行
flutter devices
flutter install --release
```

初回起動時に「信頼されていない開発元」エラーが表示される場合があります。
その場合は、iPhoneの「設定 > 一般 > VPNとデバイス管理」から開発元を信頼してください。

### Android実機へのインストール

```bash
# Androidデバイスで開発者向けオプションを有効化
# 設定 > デバイス情報 > ビルド番号を7回タップ

# USBデバッグを有効化
# 設定 > 開発者向けオプション > USBデバッグ

# デバイスをUSB接続してから実行
flutter install --release
```

代替方法としてADBコマンドも使用できます。

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## プロジェクト構造

```text
lib/
├── main.dart                    # アプリケーションエントリーポイント
├── injection.dart               # 依存性注入の設定
├── core/                        # コア機能
│   ├── constants/              # 定数定義
│   ├── errors/                 # エラークラス
│   ├── usecases/               # ユースケース基底クラス
│   └── utils/                  # ユーティリティ関数
├── domain/                      # ドメイン層
│   ├── entities/               # エンティティ
│   ├── repositories/           # リポジトリインターフェース
│   └── usecases/               # ユースケース実装
├── data/                        # データ層
│   ├── models/                 # データモデル
│   ├── repositories/           # リポジトリ実装
│   ├── datasources/            # データソース
│   └── services/               # サービス
├── presentation/                # プレゼンテーション層
│   ├── bloc/                   # BLoC状態管理
│   ├── pages/                  # 画面
│   └── widgets/                # 再利用可能なウィジェット
└── config/                      # 設定
    ├── theme.dart              # テーマ定義
    └── routes.dart             # ルーティング

test/                            # テストコード
├── domain/                     # ドメイン層のテスト
├── data/                       # データ層のテスト
└── presentation/               # プレゼンテーション層のテスト

.maestro/                        # Maestro統合テスト
└── *.yaml                      # テストシナリオ定義
```

## コード生成

このプロジェクトはコード生成を使用しています。
以下のファイルを変更した場合は、コード生成を再実行してください。

```bash
# コード生成の実行
flutter pub run build_runner build --delete-conflicting-outputs

# ウォッチモード（ファイル変更時に自動生成）
flutter pub run build_runner watch --delete-conflicting-outputs
```

コード生成の対象は以下の通りです。

- Freezedクラス（エンティティ、モデル）
- JSONシリアライズ/デシリアライズ
- 依存性注入の設定

## 静的解析とコード品質

```bash
# 静的解析の実行
flutter analyze

# コードフォーマット
flutter format lib/ test/

# Lintエラーの自動修正
dart fix --apply
```

## トラブルシューティング

### ビルドエラーが発生する場合

```bash
# クリーンビルド
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### iOS実機で音が出ない場合

1. デバイスのサイレントスイッチを確認
2. 音量が0になっていないか確認
3. アプリ内のマスターボリュームを確認

iOSでは`AVAudioSession`を`playback`カテゴリで設定しているため、サイレントモードでも音が出ます。

### iOS Podのエラー

```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

### Android Gradleのエラー

```bash
cd android
./gradlew clean
cd ..
flutter run
```

### SQLiteエラー（テスト時）

統合テストで`sqflite_common_ffi`のエラーが出る場合：

```bash
flutter pub get
flutter test test/integration/
```

## ライセンス

このプロジェクトは教育目的で開発されています。

## 実装のハイライト

### 音源生成システム

- **リアルタイムWAV生成**: `dart:typed_data`を使用した動的な音声データ生成
- **複数倍音**: 基本周波数の2倍、3倍、4倍、5倍の倍音を合成
- **ADSR エンベロープ**: Attack(10ms) → Decay(100ms) → Sustain(70%) → Release(2.5s)
- **プレイヤープール**: 8つの`AudioPlayer`インスタンスでポリフォニック再生
- **WAVキャッシング**: 生成済みWAVファイルを再利用して低レイテンシを実現

### データ整合性の保証

- **Single Source of Truth**: `UserProgress`エンティティが進捗データの唯一の情報源
- **完了レッスン管理**: `LessonRepository`は`ProgressRepository`を参照し、データの二重管理を排除
- **トランザクション保証**: SQLiteでの練習セッション記録

### パフォーマンス最適化

- **オクターブ範囲のプリロード**: 初期化時にC4-C5の音源を事前生成
- **オンデマンド生成**: オクターブ切り替え時に必要な音源のみ生成
- **一時ファイル管理**: 使用後の自動クリーンアップ

### テスト戦略

- **ユニットテスト**: モックを使用した各層の独立テスト
- **統合テスト**: `sqflite_common_ffi`による実DB操作テスト
- **E2Eテスト**: Maestroによるユーザーフロー検証

### コード品質

- **静的解析**: `flutter analyze`で0 issues
- **フォーマット**: Dart標準スタイルガイド準拠
- **ドキュメント**: 全パブリックAPIにドキュメントコメント

## 技術的な学び

このプロジェクトで得られた知見：

1. **Flutter音声処理**: `audioplayers`を使ったクロスプラットフォーム音声再生
2. **Clean Architecture**: 大規模アプリでの層分離とDI
3. **状態管理**: `flutter_bloc`によるリアクティブプログラミング
4. **SQLite活用**: Flutterアプリでのローカルデータベース設計
5. **テスト駆動開発**: ユニット・統合・E2Eテストの実践

## 参考資料

- [Flutter公式ドキュメント](https://docs.flutter.dev/)
- [Clean Architecture](https://blog.cleancoder.com/)
- [BLoC パターン](https://bloclibrary.dev/)
- [Maestro テストツール](https://maestro.mobile.dev/)
- [audioplayers パッケージ](https://pub.dev/packages/audioplayers)
- [sqflite パッケージ](https://pub.dev/packages/sqflite)
