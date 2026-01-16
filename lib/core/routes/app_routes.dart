import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/admin_dashboard_page.dart';

class AppRoutes {
  static const String adminDashboard = '/admin';

  static Map<String, WidgetBuilder> routes = {
    adminDashboard: (context) => const AdminDashboardPage(),
  };
}