import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/yoga_pose_entity.dart';
import '../../domain/repositories/yoga_repository_interface.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exception.dart';
import '../models/yoga_pose_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class YogaRepositoryImpl implements YogaRepositoryInterface {
  @override
  Future<Either<Failure, List<YogaPoseEntity>>> loadYogaPoses() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/poses.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final poses = jsonList.map((e) => YogaPoseModel.fromJson(e)).toList();
      return Right(poses);
    } on PlatformException catch (e) {
      return Left(AssetFailure('Asset not found: ${e.message}'));
    } on FormatException catch (e) {
      return Left(AssetFailure('JSON format error: ${e.message}'));
    } on JsonParsingException catch (e) {
      return Left(AssetFailure('JSON parsing error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, YogaPoseEntity>> createYogaPose(
    YogaPoseEntity pose,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/poses.json');
      List poses = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        poses = json.decode(content);
      } else {
        // If file doesn't exist, copy from assets
        final assetContent = await rootBundle.loadString('assets/poses.json');
        poses = json.decode(assetContent);
      }
      // Convert YogaPoseEntity to Map
      final poseMap = {
        'name': pose.name,
        'image': pose.imagePath,
        'audio': pose.audioPath,
        'duration': pose.duration,
      };
      poses.add(poseMap);
      await file.writeAsString(json.encode(poses));
      return Right(pose);
    } catch (e) {
      return Left(UnknownFailure('Failed to create pose: $e'));
    }
  }
}
