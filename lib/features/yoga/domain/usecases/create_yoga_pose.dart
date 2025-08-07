import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/yoga_pose_entity.dart';
import '../repositories/yoga_repository_interface.dart';

class CreateYogaPoseUseCase {
  final YogaRepositoryInterface repository;

  CreateYogaPoseUseCase(this.repository);

  Future<Either<Failure, YogaPoseEntity>> call(YogaPoseEntity pose) {
    return repository.createYogaPose(pose);
  }
}
