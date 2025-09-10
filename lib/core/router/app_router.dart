import 'package:auto_route/auto_route.dart';
import 'package:weather_app/app/presentation/home/view/home_view.dart';
import 'package:weather_app/app/presentation/settings/view/settings_view.dart';
import 'package:weather_app/app/presentation/splash/view/splash_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: RoutePath.splash.value,
          initial: true,
        ),
        AutoRoute(
          page: HomeRoute.page,
          path: RoutePath.home.value,
        ),
        AutoRoute(
          page: SettingsRoute.page,
          path: RoutePath.settings.value,
        ),
      ];
}

enum RoutePath {
  splash('/'),
  home('/home'),
  settings('/settings');

  final String value;

  const RoutePath(this.value);
}
