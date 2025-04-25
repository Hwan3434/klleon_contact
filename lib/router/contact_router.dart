import 'package:go_router/go_router.dart';
import 'package:klleon/roots/contact_detail_root.dart';
import 'package:klleon/roots/contact_root.dart';
import 'package:klleon/roots/splash_root.dart';
import 'package:presentation/common/screen_path.dart';

final contactRouter = GoRouter(
  initialLocation: ScreenPath.splash,
  routes: [
    GoRoute(
      path: ScreenPath.splash,
      builder: (context, state) {
        return SplashRoot(
          onPressed: () {
            context.go(ScreenPath.contact);
          },
        );
      },
    ),
    GoRoute(
      path: ScreenPath.contact,
      builder: (context, state) {
        return const ContactRoot();
      },
      routes: [
        GoRoute(
          path: ScreenPath.contactDetail,
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
