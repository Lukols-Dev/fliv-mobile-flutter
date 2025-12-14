import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // PROFILE HEADER
                      Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xFFE5E7EB),
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Jan Nowak',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'ID: DRV-2874',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // PROFILE USER SECTION
                      _SectionHeader(
                        icon: Icons.person_outline,
                        title: t.profile_user_profile,
                      ),
                      const SizedBox(height: 8),
                      _ProfileListItem(
                        title: t.profile_your_data,
                        onTap: () {
                          context.push('/account/your-data');
                        },
                      ),
                      _ProfileListItem(
                        title: t.profile_driver_data,
                        onTap: () {
                          context.push('/account/driver-data');
                        },
                      ),

                      const SizedBox(height: 24),

                      // APP SETTINGS SECTION
                      _SectionHeader(
                        icon: Icons.settings_outlined,
                        title: t.profile_app_settings,
                      ),
                      const SizedBox(height: 8),
                      _ProfileListItem(
                        title: t.profile_location,
                        onTap: () {
                          // TODO: Navigate to location settings
                        },
                      ),
                      _ProfileListItem(
                        title: t.profile_language,
                        onTap: () {
                          // TODO: Navigate to language settings
                        },
                      ),

                      const SizedBox(height: 24),

                      // ABOUT APP SECTION
                      _SectionHeader(
                        icon: Icons.info_outline,
                        title: t.profile_about_app,
                      ),
                      const SizedBox(height: 8),
                      _ProfileListItem(
                        title: t.profile_terms,
                        onTap: () {
                          // TODO: Navigate to terms
                        },
                      ),
                      _ProfileListItem(
                        title: t.profile_privacy_policy,
                        onTap: () {
                          // TODO: Navigate to privacy policy
                        },
                      ),

                      const SizedBox(height: 32),

                      // LOGOUT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: () {
                            // TODO: Implement logout logic
                            context.go('/auth');
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0F4D46),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            t.profile_logout,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _ProfileListItem extends StatelessWidget {
  const _ProfileListItem({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}
