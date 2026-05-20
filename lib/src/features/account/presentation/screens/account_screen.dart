import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/src/core/utils/open_url.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/l10n/l10n.dart';
import 'package:mobile/src/core/l10n/locale_controller.dart';
import 'package:mobile/src/features/auth/application/auth_controller.dart';
import 'package:mobile/src/features/driver/application/driver_profile_provider.dart';
import 'package:mobile/src/features/users/application/avatar_controller.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  Future<void> _pickAndUploadAvatar(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context)!;
    final picker = ImagePicker();

    try {
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (file == null) return;

      await ref
          .read(avatarControllerProvider.notifier)
          .uploadAvatar(filePath: file.path);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.profile_avatar_updated)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.profile_avatar_update_failed(e.toString())),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(driverProfileProvider);
    final profile = profileAsync.maybeWhen(data: (p) => p, orElse: () => null);
    final fullName = profile != null
        ? '${profile.firstName} ${profile.lastName}'.trim()
        : '—';
    final driverId = profile?.driverCode ?? '—';

    final avatarUrl = profile?.avatarUrl;
    final isAvatarUploading = ref.watch(avatarControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F4D46)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // PROFILE HEADER
                      Column(
                        children: [
                          InkWell(
                            onTap: () => _pickAndUploadAvatar(context, ref),
                            borderRadius: BorderRadius.circular(999),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: const Color(0xFFE5E7EB),
                                  backgroundImage: avatarUrl != null
                                      ? NetworkImage(avatarUrl)
                                      : null,
                                  child: avatarUrl == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Color(0xFF111827),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ),
                                if (isAvatarUploading)
                                  Container(
                                    width: 104,
                                    height: 104,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 26,
                                        height: 26,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            fullName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Figtree',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: $driverId',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Figtree',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // PROFILE USER SECTION
                      _SectionHeader(
                        icon: Icons.person_outlined,
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
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            builder: (ctx) {
                              final currentLocale = ref.read(
                                localeControllerProvider,
                              );
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (final l in SupportedLocales.all)
                                      ListTile(
                                        title: Text(
                                          SupportedLocales.label(l),
                                          style: const TextStyle(
                                            fontFamily: 'Figtree',
                                            color: Colors.black,
                                          ),
                                        ),
                                        trailing:
                                            l.languageCode ==
                                                currentLocale.languageCode
                                            ? const Icon(Icons.check_rounded)
                                            : null,
                                        onTap: () {
                                          ref
                                              .read(
                                                localeControllerProvider
                                                    .notifier,
                                              )
                                              .setLocale(l);
                                          if (ctx.mounted) Navigator.pop(ctx);
                                        },
                                      ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              );
                            },
                          );
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
                        onTap: () => openLegalUrl(
                          context,
                          'https://www.neuroface.pl/pl/regulamin',
                        ),
                      ),
                      _ProfileListItem(
                        title: t.profile_privacy_policy,
                        onTap: () => openLegalUrl(
                          context,
                          'https://www.neuroface.pl/pl/polityka-prywatnosci',
                        ),
                      ),

                      const SizedBox(height: 32),

                      // LOGOUT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: () async {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signOut();
                            if (context.mounted) {
                              context.go('/auth');
                            }
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
                              fontFamily: 'Figtree',
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 24, color: Colors.black),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Figtree',
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }
}
