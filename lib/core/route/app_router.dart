import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/yoga/presentation/bloc/yoga_session_bloc.dart';
import '../../features/yoga/presentation/bloc/yoga_session_event.dart';
import '../../features/yoga/presentation/pages/yoga_preview_page.dart';
import '../../features/yoga/presentation/pages/yoga_session_page.dart';
import '../../features/yoga/presentation/pages/create_yoga_page.dart';
import '../di/injection_container.dart' show getIt;

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<YogaSessionBloc>()..add(LoadYogaSession()),
        child: const YogaPreviewPage(),
      ),
    ),
    GoRoute(
      path: '/session',
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<YogaSessionBloc>()..add(LoadYogaSession()),
        child: const YogaSessionScreen(),
      ),
    ),
    GoRoute(
      path: '/create-pose',
      builder: (context, state) => CreateYogaPage(),
    ),
  ],
);
