import 'package:doit_app/app_constants.dart';
import 'package:doit_app/screens/tasks_screen.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedActionIndex = 0;

  void _onPlaceholderAction(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label disponível em breve.'),
        backgroundColor: Colors.white10,
      ),
    );
  }

  void _openProfileSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                const CustomText(
                  text: 'User Profile',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                const SizedBox(height: 14),
                _ProfileActionTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Update profile',
                  onTap: () {
                    Navigator.pop(context);
                    _onPlaceholderAction('Update profile');
                  },
                ),
                _ProfileActionTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    _onPlaceholderAction('Settings');
                  },
                ),
                _ProfileActionTile(
                  icon: Icons.delete_outline,
                  title: 'Delete account',
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                    _onPlaceholderAction('Delete account');
                  },
                ),
                _ProfileActionTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  color: const Color(0xFFFFE082),
                  onTap: () {
                    Navigator.pop(context);
                    _onPlaceholderAction('Logout');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required int index,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final bool isSelected = _selectedActionIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _selectedActionIndex = index;
        });
        if (onTap != null) {
          onTap();
        } else {
          _onPlaceholderAction(label);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.brandPurple.withValues(alpha: 0.35)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white24 : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 22,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: label,
              fontSize: 11.5,
              color: isSelected ? Colors.white : const Color(0xFFC8C8C8),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppConstants.brandPurple, Colors.black],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 140),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: 'Welcome, User!',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: _openProfileSheet,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 105,
                  height: 105,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConstants.brandPurple,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 26),
                const CustomText(
                  text: 'Ready to get started?',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const CustomText(
                  text:
                      'Use the bottom menu to navigate between the main areas.',
                  fontSize: 14,
                  color: Color(0xFFB8B8B8),
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF111111).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.32),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    index: 0,
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                  ),
                  _buildQuickActionButton(
                    index: 1,
                    icon: Icons.today_outlined,
                    label: 'Today',
                  ),
                  _buildQuickActionButton(
                    index: 2,
                    icon: Icons.view_list_outlined,
                    label: 'Tasks',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TasksScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    index: 3,
                    icon: Icons.smart_toy_outlined,
                    label: 'Chatbot',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: CustomText(text: title, fontSize: 15, color: color),
      onTap: onTap,
    );
  }
}
