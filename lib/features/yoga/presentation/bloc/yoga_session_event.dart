abstract class YogaSessionEvent {}

class LoadYogaSession extends YogaSessionEvent {}

class PlayPose extends YogaSessionEvent {}

class PausePose extends YogaSessionEvent {}

class ResumePose extends YogaSessionEvent {}

class NextPose extends YogaSessionEvent {}

class PreviousPose extends YogaSessionEvent {}

class PoseCompleted extends YogaSessionEvent {}

class TimerTick extends YogaSessionEvent {}