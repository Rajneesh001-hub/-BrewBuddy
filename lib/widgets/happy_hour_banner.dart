// ─── Happy Hour Banner ────────────────────────────────────────────────────────
// Live countdown timer card shown on the Home screen during / before happy hour.

import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HappyHourBanner extends StatefulWidget {
  const HappyHourBanner({super.key});

  @override
  State<HappyHourBanner> createState() => _HappyHourBannerState();
}

class _HappyHourBannerState extends State<HappyHourBanner> {
  late Timer _timer;
  Duration _timeRemaining = Duration.zero;
  bool _isActive = false;     // happy hour is on right now
  bool _isUpcoming = false;   // happy hour starts later today

  @override
  void initState() {
    super.initState();
    _update();
    // Tick every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void _update() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 16, 0); // 4 PM
    final end = DateTime(now.year, now.month, now.day, 19, 0);   // 7 PM

    if (mounted) {
      setState(() {
        if (now.isAfter(start) && now.isBefore(end)) {
          _isActive = true;
          _isUpcoming = false;
          _timeRemaining = end.difference(now);
        } else if (now.isBefore(start)) {
          _isActive = false;
          _isUpcoming = true;
          _timeRemaining = start.difference(now);
        } else {
          _isActive = false;
          _isUpcoming = false;
          _timeRemaining = Duration.zero;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    // Don't show after happy hour has ended for the day
    if (!_isActive && !_isUpcoming) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: AppDecorations.happyHourGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.caramelGold,
                  borderRadius: BorderRadius.circular(
                      AppDimensions.cornerRadiusPill),
                ),
                child: Text(
                  _isActive ? '🎉 ACTIVE NOW' : '⏰ COMING SOON',
                  style: AppTextStyles.tierBadge.copyWith(fontSize: 10),
                ),
              ),
              const Spacer(),
              Text(
                '4 PM – 7 PM',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Title + discount ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Happy Hour',
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '15% off all beverages',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // Countdown timer
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _isActive ? 'Ends in' : 'Starts in',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    _formatDuration(_timeRemaining),
                    style: AppTextStyles.timerText,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Eligible drinks chips ──
          Text(
            'Eligible drinks:',
            style: AppTextStyles.bodySmall
                .copyWith(color: Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              'Latte', 'Americano', 'Cappuccino',
              'Cold Brew', 'Frappuccino', 'Chai Latte',
            ].map((drink) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                    AppDimensions.cornerRadiusPill),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: Text(
                drink,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
