import 'package:go_router/go_router.dart';
import 'package:klleon/main.dart';
import 'package:klleon/roots/contact_detail_root.dart';
import 'package:klleon/roots/contact_root.dart';
import 'package:klleon/roots/splash_root.dart';

import 'contact_router_path.dart';

final contactRouter = GoRouter(
  initialLocation: RouterPath.splash,
  routes: [
    GoRoute(
      path: RouterPath.splash,
      builder: (context, state) {
        return SplashRoot(
          onPressed: () {
            context.go(RouterPath.contact);
          },
        );
      },
    ),
    GoRoute(
      path: RouterPath.contact,
      builder: (context, state) {
        return ContactRoot(
          onPressed: () {
            context.go("${RouterPath.contact}/1");
          },
        );
      },
      routes: [
        GoRoute(
          path: RouterPath.contactDetail,
          builder: (context, state) {
            final contactId = state.pathParameters['contactId'];
            return ContactDetailRoot(
              onPressed: () {
                logger.d("click");
              },
            );
          },
        ),
      ],
    ),
  ],
);
