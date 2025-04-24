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
            if (contactId != null) {
              context.go("${RouterPath.contact}/$contactId"); // 수정
            } else {
              context.go("${RouterPath.contact}/new"); // 생성
            }
          },
        );
      },
      routes: [
        GoRoute(
          path: RouterPath.contactDetail,
          builder: (context, state) {
            final contactId = state.pathParameters['contactId'];
            if (contactId == 'new') {
              return ContactDetailRoot(contactId: null);
            } else {
              return ContactDetailRoot(contactId: contactId);
            }
          },
        ),
      ],
    ),
  ],
);
