import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../bloc/yoga_session_bloc.dart';
import '../bloc/yoga_session_event.dart';
import '../bloc/yoga_session_state.dart';

class YogaSessionScreen extends StatefulWidget {
  const YogaSessionScreen({super.key});

  @override
  State<YogaSessionScreen> createState() => _YogaSessionScreenState();
}

class _YogaSessionScreenState extends State<YogaSessionScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _backgroundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Yoga Session'),
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
                  Text('Loading yoga session...'),
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
            final pose = state.poses[state.currentIndex];

            // Play or pause audio safely using just_audio
            () async {
              try {
                await _audioPlayer.setAsset(pose.audioPath);
                if (state.isPlaying) {
                  await _audioPlayer.play();
                } else {
                  await _audioPlayer.pause();
                }
              } catch (e) {
                debugPrint('Audio error: $e');
              }
            }();

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green[50]!, Colors.blue[50]!],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: state.poses.isNotEmpty
                          ? (state.currentIndex + 1) / state.poses.length
                          : 0.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.green[400]!,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pose ${state.currentIndex + 1} of ${state.poses.length}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(50),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${state.totalTime - state.currentTime}s remaining',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: state.totalTime > 0
                                ? state.currentTime / state.totalTime
                                : 0.0,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue[400]!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      pose.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(80),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            pose.imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.fitness_center,
                                      size: 100,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Image not found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Duration: ${pose.duration} seconds',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous, size: 32),
                          onPressed: state.currentIndex > 0
                              ? () => context.read<YogaSessionBloc>().add(
                                  PreviousPose(),
                                )
                              : null,
                          color: state.currentIndex > 0
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: state.isPlaying ? Colors.red : Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              state.isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 32,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (state.isPlaying) {
                                context.read<YogaSessionBloc>().add(
                                  PausePose(),
                                );
                              } else {
                                context.read<YogaSessionBloc>().add(PlayPose());
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, size: 32),
                          onPressed: state.currentIndex < state.poses.length - 1
                              ? () => context.read<YogaSessionBloc>().add(
                                  NextPose(),
                                )
                              : null,
                          color: state.currentIndex < state.poses.length - 1
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
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
                  'Welcome to Yoga Session',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
     
    );
  }
}
