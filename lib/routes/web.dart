import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/controllers/client/client_controller.dart';
import 'package:demo/controllers/client/update_client_controller.dart';
import 'package:demo/controllers/dasboard/dashboard_controller.dart';
import 'package:demo/controllers/notification_controller.dart';
import 'package:demo/controllers/order/single_order_controller.dart';
import 'package:demo/controllers/order/mouvement_controller.dart';
import 'package:demo/controllers/setting/setting_controller.dart';
import 'package:demo/controllers/user/user_controller.dart';
import 'package:demo/controllers/ventes/paginated_vantes_controller.dart';
import 'package:demo/controllers/ventes/ventes_controller.dart';
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
import 'package:demo/views/role/create.dart';
import 'package:demo/views/role/index.dart';
import 'package:demo/views/setting/index.dart';
import 'package:demo/views/stock/index.dart';
import 'package:demo/views/users/create.dart';
import 'package:demo/views/users/edit.dart';
import 'package:demo/views/users/index.dart';
import 'package:demo/views/vents/index.dart';
import 'package:demo/views/vents/list/paginated_vantes.dart';
import 'package:get/get.dart';

class RouteClass {
  static String settings = "/settings";
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
  static String roles = "/roles";
  static String crateRole = "/create-role";
  static String stockMovements = "/stock-movements";
  static String ventes = "/ventes";

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
      // 📦 STOCK MOVEMENTS
      GetPage(
        name: stockMovements,
        page: () => StockMovementsScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => StockMovementsController());
        }),
      ),

      // 📊 DASHBOARD
      GetPage(
        name: dashBoard,
        page: () => DashboardScreen(),
        middlewares: [SanctumAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.lazyPut(() => DashboardController());
          Get.lazyPut(() => Authcontroller());
        }),
      ),

      // 🏠 HOME PAGE
      GetPage(
        name: home,
        page: () => HomePage(),
        middlewares: [SanctumAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.lazyPut(() => Clientscontroller());
        }),
      ),

      // 🔐 LOGIN
      GetPage(name: login, page: () => Login(), binding: AuthBinding()),

      // 👥 Create CLIENTS
      GetPage(
        name: createClient,
        page: () => CreateClient(),
        middlewares: [SanctumAuthMiddleware()],
      ),
      GetPage(
        name: getEditClientRoute(),
        page: () => EditClientScreen(),
        middlewares: [SanctumAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.lazyPut(() => UpdateClientController());
        }),
      ),
      GetPage(
        name: showClient,
        page: () => ClientDetailsPage(),
        middlewares: [SanctumAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.lazyPut(() => SingleOrderController());
        }),
      ),

      // 🔔 NOTIFICATIONS
      GetPage(
        name: notifications,
        page: () => NotificationPage(),
        middlewares: [SanctumAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.lazyPut(() => NotificationController());
        }),
      ),

      // 👤 USERS
      GetPage(
        name: users,
        page: () => UserPage(),
        middlewares: [SanctumAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.lazyPut(() => UserController());
        }),
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

      // 🏪 STOCKS
      GetPage(
        name: stocks,
        page: () => StockCard(),
        middlewares: [SanctumAuthMiddleware()],
        binding: UserBinding(),
      ),

      // 🛡️ ROLES
      GetPage(
        name: roles,
        page: () => RolesScreen(),
        middlewares: [SanctumAuthMiddleware()],
      ),
      GetPage(name: crateRole, page: () => CreateRoleView()),
      //Ventes
      GetPage(
        name: ventes,
        page: () => PaginatedVentsScreen(),
        middlewares: [SanctumAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.lazyPut(() => PaginatedVentesController());
        }),
      ),
      //Settings
      GetPage(
        name: settings,
        page: () => SettingsScreen(),
        middlewares: [SanctumAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.lazyPut(() => SettingController());
        }),
      ),
    ];
  }
}
