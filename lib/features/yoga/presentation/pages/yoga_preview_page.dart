import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/yoga_pose_entity.dart';
import '../bloc/yoga_session_bloc.dart';
import '../bloc/yoga_session_event.dart';
import '../bloc/yoga_session_state.dart';
import '../widgets/custom_button.dart';
import 'pose_card.dart';

class YogaPreviewPage extends StatelessWidget {
  const YogaPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Session Preview'),
        backgroundColor: Colors.green[100],
      ),
      body: BlocBuilder<YogaSessionBloc, YogaSessionState>(
        builder: (context, state) {
          if (state is YogaSessionLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading poses...'),
                ],
              ),
            );
          } else if (state is YogaSessionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<YogaSessionBloc>().add(LoadYogaSession()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is YogaSessionLoaded) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green[50]!, Colors.blue[50]!],
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Yoga Session Preview',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${state.poses.length} poses • ${_calculateTotalDuration(state.poses)} minutes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Poses list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.poses.length,
                      itemBuilder: (context, index) {
                        final pose = state.poses[index];
                        return PoseCard(pose: pose, index: index);
                      },
                    ),
                  ),

                  // Start button
                  CustomButton(
                    onPressed: () => context.go('/create-pose'),
                    text: 'New Yoga Session Create',
                  ),
                  SizedBox(height: 5),
                  // Start button
                  CustomButton(
                    onPressed: () => context.go('/session'),
                    text: 'Start Yoga Session',
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No poses available',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  int _calculateTotalDuration(List<YogaPoseEntity> poses) {
    final totalSeconds = poses.fold<int>(0, (sum, pose) => sum + pose.duration);
    return (totalSeconds / 60).round();
  }
}
