// ─── Store Tile ───────────────────────────────────────────────────────────────
// A card showing store info, amenities, distance, and action buttons.

import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../theme/app_theme.dart';

class StoreTile extends StatelessWidget {
  final StoreModel store;
  final String distance;
  final VoidCallback onDirections;
  final VoidCallback onOrderHere;
  final bool isSelected;

  const StoreTile({
    super.key,
    required this.store,
    required this.distance,
    required this.onDirections,
    required this.onOrderHere,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(
          color: isSelected
              ? AppColors.freshGreen
              : AppColors.lightGrey,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Name + Open status ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.name, style: AppTextStyles.h5),
                    const SizedBox(height: 2),
                    Text(store.address, style: AppTextStyles.bodySmall),
                    Text(store.city, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              // Open/Closed badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: store.isOpenNow
                      ? AppColors.successGreenLight
                      : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(
                      AppDimensions.cornerRadiusPill),
                ),
                child: Text(
                  store.isOpenNow ? 'Open' : 'Closed',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: store.isOpenNow
                        ? AppColors.freshGreen
                        : AppColors.mediumGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Hours + Distance ──
          Row(
            children: [
              const Icon(Icons.schedule,
                  size: 14, color: AppColors.mediumGrey),
              const SizedBox(width: 4),
              Text(store.hours, style: AppTextStyles.bodySmall),
              const SizedBox(width: 16),
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.mediumGrey),
              const SizedBox(width: 4),
              Text(distance, style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 10),

          // ── Amenity icons ──
          Row(
            children: [
              if (store.hasWifi) _amenityChip(Icons.wifi, 'Wi-Fi'),
              if (store.hasSeating)
                _amenityChip(Icons.chair_outlined, 'Seating'),
              if (store.hasParking)
                _amenityChip(Icons.local_parking, 'Parking'),
              if (store.isDriveThru)
                _amenityChip(Icons.drive_eta_outlined, 'Drive-Thru'),
            ],
          ),
          const SizedBox(height: 14),

          // ── Action buttons ──
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDirections,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: const BorderSide(
                        color: AppColors.freshGreen, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.cornerRadiusPill),
                    ),
                  ),
                  icon: const Icon(Icons.directions,
                      size: 16, color: AppColors.freshGreen),
                  label: Text(
                    'Directions',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.freshGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onOrderHere,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.cornerRadiusPill),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined,
                      size: 16, color: Colors.white),
                  label: Text(
                    'Order Here',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amenityChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius:
            BorderRadius.circular(AppDimensions.cornerRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.deepGreen),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.deepGreen, fontSize: 10)),
        ],
      ),
    );
  }
}
