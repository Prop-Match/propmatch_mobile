import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'landlord_dashboard_screen.dart';
import 'landlord_leads_screen.dart';
import 'package:propmatch_mobile/features/matching_chat/presentation/screens/conversations_screen.dart';
import 'package:propmatch_mobile/features/profile/presentation/screens/profile_screen.dart';

class LandlordMainScreen extends StatefulWidget {
  const LandlordMainScreen({super.key});

  @override
  State<LandlordMainScreen> createState() => _LandlordMainScreenState();
}

class _LandlordMainScreenState extends State<LandlordMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    LandlordDashboardScreen(),
    LandlordLeadsScreen(),
    ConversationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layout_dashboard),
            activeIcon: Icon(LucideIcons.layout_dashboard, color: AppColors.primary),
            label: 'لوحة التحكم',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.users),
            activeIcon: Icon(LucideIcons.users, color: AppColors.primary),
            label: 'سوق الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.message_square),
            activeIcon: Icon(LucideIcons.message_square, color: AppColors.primary),
            label: 'المحادثات',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            activeIcon: Icon(LucideIcons.user, color: AppColors.primary),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
