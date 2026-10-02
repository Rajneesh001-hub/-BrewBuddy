// ─── Track Order Screen ───────────────────────────────────────────────────────
// Live order tracking: animated step progress, biker info, countdown timer,
// and a simulated map showing biker movement toward the store.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../theme/app_theme.dart';

class TrackOrderScreen extends StatefulWidget {
  final OrderModel order;

  const TrackOrderScreen({super.key, required this.order});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen>
    with TickerProviderStateMixin {
  // ── Order steps ────────────────────────────────────────────────────────────
  static const _steps = [
    _OrderStep(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      title: 'Order Placed',
      subtitle: 'Your order has been received',
    ),
    _OrderStep(
      icon: Icons.coffee_maker_outlined,
      activeIcon: Icons.coffee_maker_rounded,
      title: 'Preparing',
      subtitle: 'Barista is crafting your brew',
    ),
    _OrderStep(
      icon: Icons.local_fire_department_outlined,
      activeIcon: Icons.local_fire_department_rounded,
      title: 'Almost Ready',
      subtitle: 'Finishing the final touches',
    ),
    _OrderStep(
      icon: Icons.check_circle_outline_rounded,
      activeIcon: Icons.check_circle_rounded,
      title: 'Ready for Pickup',
      subtitle: 'Your order is at the counter!',
    ),
  ];

  int _currentStep = 0;
  late int _remainingSeconds;
  Timer? _countdownTimer;
  Timer? _stepTimer;

  // Biker animation
  late AnimationController _bikerController;
  late Animation<double> _bikerAnimation;

  // Pulse animation for active step
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Biker position on mock map (0.0 = far, 1.0 = arrived)
  double _bikerProgress = 0.0;

  @override
  void initState() {
    super.initState();

    // Parse pickup time to calculate remaining seconds
    _remainingSeconds = _parsePickupSeconds(widget.order.pickupTime);

    // Pulse animation for active step dot
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Biker movement animation
    _bikerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _bikerAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _bikerController, curve: Curves.easeInOut),
    );

    // Countdown every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
        // Move biker progress forward as time ticks
        _bikerProgress = 1.0 -
            (_remainingSeconds / max(1, _parsePickupSeconds(widget.order.pickupTime)));
        _bikerProgress = _bikerProgress.clamp(0.0, 1.0);
      });
    });

    // Auto-advance steps to simulate real progress
    _scheduleStepAdvance();
  }

  void _scheduleStepAdvance() {
    // Step 0 → 1 after 3s, 1 → 2 after 8s, 2 → 3 after 15s
    final delays = [3, 8, 15];
    for (int i = 0; i < delays.length; i++) {
      Future.delayed(Duration(seconds: delays[i]), () {
        if (!mounted) return;
        setState(() {
          if (_currentStep < i + 1) _currentStep = i + 1;
        });
      });
    }
  }

  int _parsePickupSeconds(String pickupTime) {
    // pickupTime is like "3:45 PM" — calculate seconds from now
    try {
      final now = DateTime.now();
      final parts = pickupTime.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      if (parts.length > 1 && parts[1] == 'PM' && hour != 12) hour += 12;
      if (parts.length > 1 && parts[1] == 'AM' && hour == 12) hour = 0;
      final pickup = DateTime(now.year, now.month, now.day, hour, minute);
      final diff = pickup.difference(now).inSeconds;
      return diff > 0 ? diff : 900; // fallback 15 min
    } catch (_) {
      return 900;
    }
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _etaLabel() {
    if (_remainingSeconds <= 0) return 'Ready now!';
    final minutes = (_remainingSeconds / 60).ceil();
    return '$minutes min away';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _stepTimer?.cancel();
    _bikerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _currentStep >= _steps.length - 1;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        foregroundColor: AppColors.white,
        title: Text(
          'Track Order #${widget.order.orderId}',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isReady
                      ? AppColors.freshGreen
                      : AppColors.caramelGold,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  isReady ? '✓ Ready' : 'Live',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ETA Hero Card ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3932), Color(0xFF2D5A4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(AppDimensions.cornerRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepGreen.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Timer circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(_remainingSeconds),
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'remaining',
                          style: AppTextStyles.bodySmall.copyWith(
                            color:
                                AppColors.white.withValues(alpha: 0.7),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isReady
                              ? '🎉 Your order is ready!'
                              : '☕ ${_steps[_currentStep].title}',
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isReady
                              ? 'Head to the counter to pick up'
                              : _etaLabel(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color:
                                AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Mini progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (_currentStep + 1) / _steps.length,
                            backgroundColor:
                                AppColors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.caramelGold,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Step ${_currentStep + 1} of ${_steps.length}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color:
                                AppColors.white.withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Mock Map ───────────────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadius),
              child: Container(
                height: 180,
                width: double.infinity,
                color: const Color(0xFFE8F0E9),
                child: Stack(
                  children: [
                    // Road lines
                    CustomPaint(
                      size: const Size(double.infinity, 180),
                      painter: _RoadPainter(),
                    ),
                    // Store marker
                    Positioned(
                      right: 40,
                      top: 60,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.deepGreen,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.deepGreen
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.store_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.deepGreen,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'BrewBuddy',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Animated biker
                    AnimatedBuilder(
                      animation: _bikerAnimation,
                      builder: (context, child) {
                        // Move biker from left to right based on progress
                        final leftPos =
                            30.0 + (_bikerProgress * 240.0);
                        return Positioned(
                          left: leftPos + _bikerAnimation.value,
                          top: 70,
                          child: Column(
                            children: [
                              ScaleTransition(
                                scale: _pulseAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.freshGreen,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.freshGreen
                                            .withValues(alpha: 0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Text('🛵',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.freshGreen,
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _etaLabel(),
                                  style: AppTextStyles.bodySmall
                                      .copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // "LIVE" badge
                    Positioned(
                      top: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'LIVE',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Biker Info Card ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.freshGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.freshGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Center(
                      child:
                          Text('🛵', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ravi Kumar',
                          style: AppTextStyles.h5
                              .copyWith(color: AppColors.deepGreen),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.caramelGold, size: 14),
                            const SizedBox(width: 3),
                            Text(
                              '4.9 · BrewBuddy Delivery Partner',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.mediumGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KA 05 MX 7842',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.freshGreen,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Call button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Calling delivery partner… (demo)'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.freshGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.freshGreen.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.phone_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Order Steps Timeline ───────────────────────────────────────
            Text(
              'ORDER PROGRESS',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.mediumGrey,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Column(
                children: List.generate(_steps.length, (index) {
                  final step = _steps[index];
                  final isDone = index < _currentStep;
                  final isActive = index == _currentStep;
                  final isPending = index > _currentStep;
                  final isLast = index == _steps.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step indicator column
                      Column(
                        children: [
                          // Circle
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: isActive
                                    ? _pulseAnimation.value
                                    : 1.0,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDone
                                        ? AppColors.freshGreen
                                        : isActive
                                            ? AppColors.deepGreen
                                            : AppColors.lightGrey,
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: AppColors.deepGreen
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Icon(
                                    isDone
                                        ? Icons.check_rounded
                                        : isActive
                                            ? step.activeIcon
                                            : step.icon,
                                    color: isPending
                                        ? AppColors.mediumGrey
                                        : AppColors.white,
                                    size: 18,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Connector line
                          if (!isLast)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: 2,
                              height: 40,
                              color: isDone
                                  ? AppColors.freshGreen
                                  : AppColors.lightGrey,
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Step text
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 6,
                            bottom: isLast ? 0 : 28,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: isPending
                                      ? AppColors.mediumGrey
                                      : AppColors.deepGreen,
                                  fontWeight: isActive
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isDone
                                    ? '✓ Completed'
                                    : isActive
                                        ? step.subtitle
                                        : 'Pending',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDone
                                      ? AppColors.freshGreen
                                      : isActive
                                          ? AppColors.mediumGrey
                                          : AppColors.lightGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Timestamp or active badge
                      if (isDone || isActive)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppColors.successGreenLight
                                  : AppColors.caramelGold
                                      .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              isDone ? 'Done' : 'Now',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: isDone
                                    ? AppColors.freshGreen
                                    : AppColors.caramelGold,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // ── Order Details ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Details', style: AppTextStyles.h5),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.tag_rounded,
                    label: 'Order #',
                    value: widget.order.orderId,
                  ),
                  const Divider(height: 16, color: AppColors.lightGrey),
                  _InfoRow(
                    icon: Icons.store_outlined,
                    label: 'Store',
                    value: widget.order.storeName,
                  ),
                  const Divider(height: 16, color: AppColors.lightGrey),
                  _InfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'Pickup Time',
                    value: widget.order.pickupTime,
                    valueColor: AppColors.freshGreen,
                  ),
                  const Divider(height: 16, color: AppColors.lightGrey),
                  _InfoRow(
                    icon: Icons.receipt_outlined,
                    label: 'Total',
                    value: '₹${widget.order.total.toStringAsFixed(0)}',
                    valueColor: AppColors.deepGreen,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Data class for order steps ────────────────────────────────────────────────
class _OrderStep {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final String subtitle;

  const _OrderStep({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.subtitle,
  });
}

// ─── Info row widget ───────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.mediumGrey),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGrey),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            color: valueColor ?? AppColors.darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Road painter for mock map ────────────────────────────────────────────────
class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFCED4C8)
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Main horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      roadPaint,
    );

    // Dashed center line
    const dashWidth = 14.0;
    const dashGap = 10.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height * 0.55),
        Offset(x + dashWidth, size.height * 0.55),
        linePaint,
      );
      x += dashWidth + dashGap;
    }

    // Some building blocks for context
    final buildingPaint = Paint()..color = const Color(0xFFBCC5B8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(60, 20, 40, 25),
        const Radius.circular(4),
      ),
      buildingPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(150, 15, 30, 30),
        const Radius.circular(4),
      ),
      buildingPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(240, 22, 50, 20),
        const Radius.circular(4),
      ),
      buildingPaint,
    );
  }

  @override
  bool shouldRepaint(_RoadPainter oldDelegate) => false;
}
