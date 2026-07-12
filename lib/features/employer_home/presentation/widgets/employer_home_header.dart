import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/employer_service.dart';
import '../../../auth/providers/auth_providers.dart';

class EmployerHomeHeader extends ConsumerWidget {
  const EmployerHomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final uid = user?.uid ?? 'lumen-energy-uid';
    final profileAsync = ref.watch(employerProfileStreamProvider(uid));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          const Icon(
            Icons.wb_sunny_outlined,
            color: AppColors.primary,
            size: 26,
          ),
          const SizedBox(width: 8),
          Text(
            'AluOp-Connect',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
          ),
          const Spacer(),
          const Icon(
            Icons.notifications_none,
            size: 26,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 16),
          profileAsync.when(
            loading: () => Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
                ),
              ),
            ),
            error: (err, stack) => Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'AO',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            data: (profile) {
              final orgName = profile?.orgName ?? user?.fullName ?? 'Lumen-Energy';
              final initials = _getInitials(orgName);

              return Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

String _getInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.isEmpty) return 'EM';
  if (words.length == 1) {
    return words[0].length >= 2 ? words[0].substring(0, 2).toUpperCase() : words[0].toUpperCase();
  }
  return '${words[0][0]}${words[1][0]}'.toUpperCase();
}
