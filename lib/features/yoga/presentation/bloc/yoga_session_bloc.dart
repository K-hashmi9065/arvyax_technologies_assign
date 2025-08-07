import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/yoga_pose_entity.dart';
import '../../domain/usecases/load_yoga_poses.dart';
import 'yoga_session_event.dart';
import 'yoga_session_state.dart';



class YogaSessionBloc extends Bloc<YogaSessionEvent, YogaSessionState> {
  final LoadYogaPoses loadYogaPoses;
  Timer? _timer;

  YogaSessionBloc(this.loadYogaPoses) : super(YogaSessionInitial()) {
    on<LoadYogaSession>(_onLoadYogaSession);
    on<PlayPose>(_onPlayPose);
    on<PausePose>(_onPausePose);
    on<ResumePose>(_onResumePose);
    on<NextPose>(_onNextPose);
    on<PreviousPose>(_onPreviousPose);
    on<PoseCompleted>(_onPoseCompleted);
    on<TimerTick>(_onTimerTick);
  }

  Future<void> _onLoadYogaSession(
    LoadYogaSession event,
    Emitter<YogaSessionState> emit,
  ) async {
    emit(YogaSessionLoading());
    final result = await loadYogaPoses();
    result.fold(
        (failure) => emit(YogaSessionError(failure.message)),
      (poses) => emit(
        YogaSessionLoaded(
          poses: poses,
          currentIndex: 0,
          isPlaying: false,
          currentTime: 0,
          totalTime: poses.isNotEmpty ? poses[0].duration : 0,
        ),
      ),
    );
  }

  void _onPlayPose(PlayPose event, Emitter<YogaSessionState> emit) {
    if (state is YogaSessionLoaded) {
      final loaded = state as YogaSessionLoaded;
      emit(loaded.copyWith(isPlaying: true));
      _startTimer();
    }
  }

  void _onPausePose(PausePose event, Emitter<YogaSessionState> emit) {
    if (state is YogaSessionLoaded) {
      final loaded = state as YogaSessionLoaded;
      emit(loaded.copyWith(isPlaying: false));
      _stopTimer();
    }
  }

  void _onResumePose(ResumePose event, Emitter<YogaSessionState> emit) {
    if (state is YogaSessionLoaded) {
      final loaded = state as YogaSessionLoaded;
      emit(loaded.copyWith(isPlaying: true));
      _startTimer();
    }
  }

  void _onNextPose(NextPose event, Emitter<YogaSessionState> emit) {
    if (state is YogaSessionLoaded) {
      final loaded = state as YogaSessionLoaded;
      if (loaded.currentIndex < loaded.poses.length - 1) {
        _stopTimer();
        emit(
          loaded.copyWith(
            currentIndex: loaded.currentIndex + 1,
            isPlaying: true,
            currentTime: 0,
            totalTime: loaded.poses[loaded.currentIndex + 1].duration,
          ),
        );
        _startTimer();
      }
    }
  }

  void _onPreviousPose(PreviousPose event, Emitter<YogaSessionState> emit) {
    if (state is YogaSessionLoaded) {
      final loaded = state as YogaSessionLoaded;
      if (loaded.currentIndex > 0) {
        _stopTimer();
        emit(
          loaded.copyWith(
            currentIndex: loaded.currentIndex - 1,
            isPlaying: true,
            currentTime: 0,
            totalTime: loaded.poses[loaded.currentIndex - 1].duration,
          ),
        );
        _startTimer();
      }
    }
  }

  void _onPoseCompleted(PoseCompleted event, Emitter<YogaSessionState> emit) {
    if (state is YogaSessionLoaded) {
      final loaded = state as YogaSessionLoaded;
      if (loaded.currentIndex < loaded.poses.length - 1) {
        add(NextPose());
      } else {
        _stopTimer();
        emit(loaded.copyWith(isPlaying: false));
      }
    }
  }

  void _onTimerTick(TimerTick event, Emitter<YogaSessionState> emit) {
    if (state is YogaSessionLoaded) {
      final loaded = state as YogaSessionLoaded;
      if (loaded.currentTime >= loaded.totalTime) {
        add(PoseCompleted());
      } else {
        emit(loaded.copyWith(currentTime: loaded.currentTime + 1));
      }
    }
  }

  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TimerTick());
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}

extension on YogaSessionLoaded {
  YogaSessionLoaded copyWith({
    List<YogaPoseEntity>? poses,
    int? currentIndex,
    bool? isPlaying,
    int? currentTime,
    int? totalTime,
  }) {
    return YogaSessionLoaded(
      poses: poses ?? this.poses,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      currentTime: currentTime ?? this.currentTime,
      totalTime: totalTime ?? this.totalTime,
    );
  }
}
