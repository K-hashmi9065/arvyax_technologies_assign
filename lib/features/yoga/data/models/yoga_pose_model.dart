import '../../domain/entities/yoga_pose_entity.dart';

class YogaPoseModel extends YogaPoseEntity {
  YogaPoseModel({
    required super.name,
    required super.imagePath,
    required super.audioPath,
    required super.duration,
  });

  factory YogaPoseModel.fromJson(Map<String, dynamic> json) {
    try {
      return YogaPoseModel(
        name: json['name'] as String,
        imagePath: json['image'] as String,
        audioPath: json['audio'] as String,
        duration: json['duration'] as int,
      );
    } catch (e) {
      throw FormatException('Invalid YogaPose JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': imagePath,
      'audio': audioPath,
      'duration': duration,
    };
  }
}

