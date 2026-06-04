// AI生成 - 应用入口文件
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user_provider.dart';
import 'models/theme_provider.dart';
import 'models/travel_plan_provider.dart';
import 'models/user_preferences_provider.dart';
import 'services/hive_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Hive
  await HiveService.init();

  runApp(const MyApp());
}

/// 应用主组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 用户状态管理
        ChangeNotifierProvider(create: (_) => UserProvider()..checkLoginStatus()),
        // 主题状态管理
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadThemeSetting()),
        // 行程状态管理
        ChangeNotifierProvider(create: (_) => TravelPlanProvider()),
        // 用户偏好状态管理
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()..loadPreferences()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: '云游助手',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AppRouter(),
          );
        },
      ),
    );
  }
}

/// 应用路由控制
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // 根据登录状态决定显示哪个页面
        if (userProvider.isLoggedIn) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
