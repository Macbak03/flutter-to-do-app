import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/routing/routes.dart';
import 'package:to_do_app/ui/home/view_models/home_viewmodel.dart';
import 'package:to_do_app/ui/home/widgets/home_screen_desktop.dart';
import 'package:to_do_app/ui/home/widgets/home_screen_mobile.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          final viewModel = HomeViewModel(toDoListRepository: context.read());
          final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android;
          if (isMobile) {
            return HomeScreenMobile(viewModel: viewModel);
          } else {
            return HomeScreenDesktop(viewModel: viewModel);
          }
        }
      )
  ]
);