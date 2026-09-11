import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'tenant_browse_screen.dart';
import 'my_tenant_requests_screen.dart';
import 'package:propmatch_mobile/features/matching_chat/presentation/screens/conversations_screen.dart';
import 'package:propmatch_mobile/features/profile/presentation/screens/profile_screen.dart';

class TenantMainScreen extends StatefulWidget {
  const TenantMainScreen({super.key});

  @override
  State<TenantMainScreen> createState() => _TenantMainScreenState();
}

class _TenantMainScreenState extends State<TenantMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TenantBrowseScreen(),
    MyTenantRequestsScreen(),
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
            icon: Icon(LucideIcons.compass),
            activeIcon: Icon(LucideIcons.compass, color: AppColors.primary),
            label: 'استكشاف',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.file_text),
            activeIcon: Icon(LucideIcons.file_text, color: AppColors.primary),
            label: 'طلباتي',
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
