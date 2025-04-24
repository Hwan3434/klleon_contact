import 'package:go_router/go_router.dart';
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
          onPressed: (contactId) {
            context.go("${RouterPath.contact}/$contactId");
          },
        );
      },
      routes: [
        GoRoute(
          path: RouterPath.contactDetail,
          builder: (context, state) {
            final contactId = state.pathParameters['contactId'];
            return ContactDetailRoot(contactId: contactId);
          },
        ),
      ],
    ),
  ],
);
