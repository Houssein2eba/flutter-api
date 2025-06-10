import 'package:demo/core/middleware/auth_middleware.dart';
import 'package:demo/services/auth_binding.dart';
import 'package:demo/services/user_binding.dart';
import 'package:demo/views/auth/login.dart';
import 'package:demo/views/clients/create.dart';
import 'package:demo/views/clients/edit.dart';
import 'package:demo/views/clients/show.dart';
import 'package:demo/views/dashboard.dart';
import 'package:demo/views/homepage.dart';
import 'package:demo/views/notifications/index.dart';
import 'package:demo/views/stock/index.dart';
import 'package:demo/views/users/create.dart';
import 'package:demo/views/users/edit.dart';
import 'package:demo/views/users/index.dart';
import 'package:get/get.dart';

class RouteClass {
  static String home = "/";
  static String login = "/login";
  static String createClient = "/create-client";
  static String notifications = "/notifications";
  static String editClient = "/edit-client";
  static String showClient = "/show-client";
  static String users = "/users";
  static String createUser = "/create-user";
  static String editUser = "/edit-user";
  static String dashBoard = "/dashboard";
  static String stocks = "/stocks";


  static String getStocksRoute() => stocks;
  static String getHomeRoute() => home;
  static String getLoginRoute() => login;
  static String getClientsRoute() => home;
  static String getNotificationsRoute() => notifications;
  static String getCreateClientRoute() => createClient;
  static String getEditClientRoute() => editClient;
  static String getShowClientRoute() => showClient;
  static String getUsersRoute() => users;
  static String getCreateUserRoute() => createUser;
  static String getEditUserRoute() => editUser;
  static String getDashBoardRoute() => dashBoard;

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: dashBoard,
        page: () => DashboardScreen(),
        middlewares: [SanctumAuthMiddleware()],
        binding: UserBinding(),
      ),
      GetPage(
        name: home,
        page: () => HomePage(),
        middlewares: [SanctumAuthMiddleware()],
        binding: UserBinding(),
      ),
      GetPage(name: login, page: () => Login(), binding: AuthBinding()),
      GetPage(
        name: createClient,
        page: () => CreateClient(),
        middlewares: [SanctumAuthMiddleware()],
      ),
      GetPage(
        name: notifications,
        page: () => NotificationPage(),
        middlewares: [SanctumAuthMiddleware()],
        binding: UserBinding(),
      ),
      GetPage(
        name: editClient,
        page: () {
          final client = Get.arguments as Map<String, dynamic>;
          return EditClientPage(client: client);
        },
        middlewares: [SanctumAuthMiddleware()],
      ),
      GetPage(
        name: showClient,
        page: () => ClientDetailsPage(),
        middlewares: [SanctumAuthMiddleware()],
        binding: UserBinding(),
      ),
      GetPage(
        name: users,
        page: () => UserPage(),
        middlewares: [SanctumAuthMiddleware()],
        binding: UserBinding(),
      ),
      GetPage(
        name: createUser,
        page: () => CreateUser(),
        middlewares: [SanctumAuthMiddleware()],
        binding: UserBinding(),
      ),
      GetPage(
        name: editUser,
        page: () => EditUser(),
        middlewares: [SanctumAuthMiddleware()],
      ),
      GetPage(
        name: stocks,
        page: () => StockCard(),
        middlewares: [SanctumAuthMiddleware()],
        binding: UserBinding(),
      ),
    ];
  }
}
