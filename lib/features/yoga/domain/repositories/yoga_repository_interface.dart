import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/yoga_pose_entity.dart';

abstract class YogaRepositoryInterface {
  Future<Either<Failure, List<YogaPoseEntity>>> loadYogaPoses();
 Future<Either<Failure, YogaPoseEntity>> createYogaPose(YogaPoseEntity pose);

}
