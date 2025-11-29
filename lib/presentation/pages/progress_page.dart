import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/progress/progress_bloc.dart';
import '../bloc/progress/progress_event.dart';
import '../bloc/progress/progress_state.dart';
import '../widgets/progress_chart.dart';

/// 進捗画面
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  void initState() {
    super.initState();
    // 画面表示時に最新データを読み込む
    Future.microtask(() {
      if (mounted) {
        context.read<ProgressBloc>().add(const ProgressLoadEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _ProgressPageContent();
  }
}

class _ProgressPageContent extends StatelessWidget {
  const _ProgressPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('進捗')),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state.status == ProgressStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.userProgress == null) {
            return const Center(child: Text('進捗データがありません'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ProgressChart(
              progress: state.userProgress!,
              totalLessons: 15,
            ),
          );
        },
      ),
    );
  }
}
