// ─── Profile Screen ────────────────────────────────────────────────────────────
// Shows the logged-in user's profile data with logout.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_models.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')} / '
        '${date.month.toString().padLeft(2, '0')} / '
        '${date.year}';
  }

  String _tierLabel(int stars) {
    if (stars >= 30) return 'Gold';
    if (stars >= 5) return 'Green';
    return 'Green';
  }

  Color _tierColor(int stars) {
    if (stars >= 30) return AppColors.caramelGold;
    return AppColors.freshGreen;
  }

  void _showAllOrders(BuildContext context, List<dynamic> orders) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Orders (${orders.length})',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.deepGreen,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.lightGrey),
              // Orders list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final formattedDate =
                        '${order.placedAt.day.toString().padLeft(2, '0')}/'
                        '${order.placedAt.month.toString().padLeft(2, '0')}/'
                        '${order.placedAt.year}';
                    final formattedTime =
                        '${order.placedAt.hour.toString().padLeft(2, '0')}:'
                        '${order.placedAt.minute.toString().padLeft(2, '0')}';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.cornerRadius,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order #${order.orderId}',
                                    style:
                                        AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.deepGreen,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.freshGreen
                                          .withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      'Ready',
                                      style: AppTextStyles.labelSmall
                                          .copyWith(
                                        color: AppColors.freshGreen,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$formattedDate at $formattedTime',
                                    style:
                                        AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.mediumGrey,
                                    ),
                                  ),
                                  Text(
                                    '₹${order.total.toStringAsFixed(2)}',
                                    style:
                                        AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.deepGreen,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                                    style:
                                        AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.mediumGrey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 16,
                                        color: AppColors.caramelGold,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${order.starsEarned}',
                                        style: AppTextStyles.bodySmall
                                            .copyWith(
                                          color: AppColors.caramelGold,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        ),
        title: Text(
          'Log out?',
          style: AppTextStyles.h4.copyWith(color: AppColors.deepGreen),
        ),
        content: Text(
          'You will be returned to the login screen.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Log Out',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.errorRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    final AuthUser? user = authProvider.currentUser;
    final stars = userProvider.stars;

    // Guest screen
    if (authProvider.isGuest || user == null) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        appBar: _buildAppBar(context, isGuest: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('☕', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                Text(
                  'You\'re browsing as Guest',
                  style: AppTextStyles.h3.copyWith(color: AppColors.deepGreen),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Log in to see your profile, earn Stars, and unlock rewards.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.freshGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.cornerRadius),
                      ),
                    ),
                    child: Text(
                      'Log In / Sign Up',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final initials = user.name.isNotEmpty
        ? user.name
            .trim()
            .split(' ')
            .where((w) => w.isNotEmpty)
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: _buildAppBar(context, isGuest: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Banner with convex curve ────────────────────────────
            ClipPath(
              clipper: _ConvexBottomClipper(),
              child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.deepGreen,
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 56),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.freshGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.3),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Name
                  Text(
                    user.name.isNotEmpty ? user.name : 'BrewBuddy Member',
                    style: AppTextStyles.h3.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  // Phone
                  Text(
                    '+91 ${user.phone}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stars + Tier chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _InfoChip(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.caramelGold,
                        label: '$stars Stars',
                      ),
                      const SizedBox(width: 10),
                      _InfoChip(
                        icon: Icons.workspace_premium_rounded,
                        iconColor: _tierColor(stars),
                        label: '${_tierLabel(stars)} Tier',
                      ),
                    ],
                  ),
                ],
              ),
            ), // end ClipPath child Container
            ), // end ClipPath

            const SizedBox(height: 24),

            // ── Profile Details ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROFILE DETAILS',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.mediumGrey,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ProfileCard(
                    children: [
                      _ProfileRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Full Name',
                        value: user.name.isNotEmpty ? user.name : '—',
                      ),
                      _Divider(),
                      _ProfileRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: '+91 ${user.phone}',
                      ),
                      _Divider(),
                      _ProfileRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value:
                            user.email.isNotEmpty ? user.email : '—',
                      ),
                      _Divider(),
                      _ProfileRow(
                        icon: Icons.cake_outlined,
                        label: 'Birthday',
                        value: _formatDate(user.dateOfBirth),
                      ),
                      _Divider(),
                      _ProfileRow(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: 'WhatsApp Updates',
                        value: user.whatsappUpdates ? 'Enabled' : 'Disabled',
                        valueColor: user.whatsappUpdates
                            ? AppColors.freshGreen
                            : AppColors.mediumGrey,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Loyalty Summary ──────────────────────────────────────
                  Text(
                    'LOYALTY',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.mediumGrey,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ProfileCard(
                    children: [
                      _ProfileRow(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.caramelGold,
                        label: 'Star Balance',
                        value: '$stars Stars',
                        valueColor: AppColors.caramelGold,
                      ),
                      _Divider(),
                      _ProfileRow(
                        icon: Icons.workspace_premium_rounded,
                        iconColor: _tierColor(stars),
                        label: 'Current Tier',
                        value: '${_tierLabel(stars)} Tier',
                        valueColor: _tierColor(stars),
                      ),
                      _Divider(),
                      _ProfileRow(
                        icon: Icons.trending_up_rounded,
                        label: 'Stars to Gold',
                        value: stars >= 30
                            ? '🎉 Gold achieved!'
                            : '${30 - stars} more stars',
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Order History ──────────────────────────────────────
                  Text(
                    'ORDER HISTORY',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.mediumGrey,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      if (cartProvider.orderHistory.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.cornerRadius,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                const Text(
                                  '📦',
                                  style: TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No orders yet',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.mediumGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Sort orders by most recent first
                      final sortedOrders = List<dynamic>.from(cartProvider.orderHistory)
                        ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
                      
                      // Show only first 2 orders in the main section
                      final displayedOrders = sortedOrders.take(2).toList();
                      final hasMoreOrders = sortedOrders.length > 2;

                      return Column(
                        children: [
                          ...displayedOrders.map((order) {
                            final formattedDate =
                                '${order.placedAt.day.toString().padLeft(2, '0')}/'
                                '${order.placedAt.month.toString().padLeft(2, '0')}/'
                                '${order.placedAt.year}';
                            final formattedTime =
                                '${order.placedAt.hour.toString().padLeft(2, '0')}:'
                                '${order.placedAt.minute.toString().padLeft(2, '0')}';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.cornerRadius,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Order #${order.orderId}',
                                            style:
                                                AppTextStyles.labelMedium.copyWith(
                                              color: AppColors.deepGreen,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.freshGreen
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Text(
                                              'Ready',
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                color: AppColors.freshGreen,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '$formattedDate at $formattedTime',
                                            style:
                                                AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.mediumGrey,
                                            ),
                                          ),
                                          Text(
                                            '₹${order.total.toStringAsFixed(2)}',
                                            style:
                                                AppTextStyles.labelMedium.copyWith(
                                              color: AppColors.deepGreen,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                                            style:
                                                AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.mediumGrey,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star_rounded,
                                                size: 16,
                                                color: AppColors.caramelGold,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${order.starsEarned}',
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                  color: AppColors.caramelGold,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          
                          // See All button if there are more than 2 orders
                          if (hasMoreOrders) ...[
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                _showAllOrders(context, sortedOrders);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.freshGreen.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.cornerRadius,
                                  ),
                                  border: Border.all(
                                    color: AppColors.freshGreen.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'See All Orders (${sortedOrders.length})',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.freshGreen,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.freshGreen,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // ── Logout Button ──────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context),
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.errorRed,
                        size: 20,
                      ),
                      label: Text(
                        'Log Out',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.errorRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: AppColors.errorRed,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.cornerRadius),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'BrewBuddy · Version 1.0.0',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, {required bool isGuest}) {
    return AppBar(
      backgroundColor: AppColors.deepGreen,
      foregroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      title: Text(
        'My Profile',
        style: AppTextStyles.h4.copyWith(color: AppColors.white),
      ),
    );
  }
}

// ─── Helper Widgets ────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;

  const _ProfileCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _ProfileRow({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? AppColors.mediumGrey,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: valueColor ?? AppColors.darkText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 50,
      endIndent: 0,
      color: AppColors.lightGrey,
    );
  }
}

// ─── Convex bottom clipper ─────────────────────────────────────────────────────
// Produces a downward-bulging convex curve at the bottom of the header.
class _ConvexBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // left side down
    path.quadraticBezierTo(
      size.width / 2, size.height + 40, // control point — bulges down
      size.width, size.height - 40,      // right end
    );
    path.lineTo(size.width, 0); // right side up
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_ConvexBottomClipper oldClipper) => false;
}
