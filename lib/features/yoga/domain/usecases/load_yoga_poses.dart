import 'package:dartz/dartz.dart';
import '../entities/yoga_pose_entity.dart';
import '../repositories/yoga_repository_interface.dart';
import '../../../../core/errors/failure.dart';

class LoadYogaPoses {
  final YogaRepositoryInterface repository;
  LoadYogaPoses(this.repository);

  Future<Either<Failure, List<YogaPoseEntity>>> call() {
    return repository.loadYogaPoses();
  }
}
