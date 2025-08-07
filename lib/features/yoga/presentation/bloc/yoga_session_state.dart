
import '../../domain/entities/yoga_pose_entity.dart';

abstract class YogaSessionState {}

class YogaSessionInitial extends YogaSessionState {}

class YogaSessionLoading extends YogaSessionState {}

class YogaSessionLoaded extends YogaSessionState {
  final List<YogaPoseEntity> poses;
  final int currentIndex;
  final bool isPlaying;
  final int currentTime;
  final int totalTime;

  YogaSessionLoaded({
    required this.poses,
    required this.currentIndex,
    required this.isPlaying,
    required this.currentTime,
    required this.totalTime,
  });
}

class YogaSessionError extends YogaSessionState {
  final String message;
  YogaSessionError(this.message);
}
