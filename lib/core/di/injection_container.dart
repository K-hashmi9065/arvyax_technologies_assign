import 'package:get_it/get_it.dart';
import '../../features/yoga/domain/usecases/create_yoga_pose.dart';
import '../../features/yoga/presentation/bloc/yoga_session_bloc.dart';
import '../../features/yoga/domain/usecases/load_yoga_poses.dart';
import '../../features/yoga/domain/repositories/yoga_repository_interface.dart';
import '../../features/yoga/data/repositories/yoga_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Bloc
  getIt.registerFactory(() => YogaSessionBloc(getIt()));

  // Use cases
  getIt.registerLazySingleton(() => LoadYogaPoses(getIt()));

  // Repository
  getIt.registerLazySingleton<YogaRepositoryInterface>(
    () => YogaRepositoryImpl(),
  );
  GetIt.I.registerLazySingleton(() => CreateYogaPoseUseCase(GetIt.I<YogaRepositoryInterface>()));

}
