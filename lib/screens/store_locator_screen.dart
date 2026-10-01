// ─── Store Locator Screen ─────────────────────────────────────────────────────
// Google Map with store markers + user location, scrollable store list,
// Directions (url_launcher → Google Maps) and Order Here button.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/menu_provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/store_tile.dart';
import 'menu_screen.dart';

class StoreLocatorScreen extends StatefulWidget {
  const StoreLocatorScreen({super.key});

  @override
  State<StoreLocatorScreen> createState() => _StoreLocatorScreenState();
}

class _StoreLocatorScreenState extends State<StoreLocatorScreen> {
  GoogleMapController? _mapController;

  // Default camera position — centered on India
  static const CameraPosition _indiaCenter = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 5.0,
  );

  Set<Marker> _buildMarkers(StoreProvider storeProvider) {
    final markers = <Marker>{};

    for (final store in storeProvider.stores) {
      final isSelected = storeProvider.selectedStore?.id == store.id;
      markers.add(
        Marker(
          markerId: MarkerId(store.id),
          position: LatLng(store.latitude, store.longitude),
          infoWindow: InfoWindow(
            title: store.name,
            snippet: store.hours,
          ),
          icon: isSelected
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRose),
          onTap: () => storeProvider.selectStore(store),
        ),
      );
    }

    // User location marker
    if (storeProvider.hasLocation) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            storeProvider.userPosition!.latitude,
            storeProvider.userPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue),
        ),
      );
    }

    return markers;
  }

  void _moveToStore(StoreProvider storeProvider) {
    final store = storeProvider.selectedStore;
    if (store != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(store.latitude, store.longitude),
          14.0,
        ),
      );
    }
  }

  Widget _buildMapPlaceholder() {
    return Container(
      color: AppColors.lightGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_rounded,
              size: 48, color: AppColors.mediumGrey),
          const SizedBox(height: 12),
          Text(
            'Map View',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Browse stores in the list below',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDirections(
      double lat, double lng, String name) async {
    final encodedName = Uri.encodeComponent(name);
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_name=$encodedName&travelmode=driving');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: open maps.google.com
      final fallback =
          Uri.parse('https://maps.google.com/?q=$lat,$lng');
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (context, storeProvider, _) {
        final stores = storeProvider.sortedStores;

        return Scaffold(
          backgroundColor: AppColors.cream,
          appBar: AppBar(
            backgroundColor: AppColors.deepGreen,
            automaticallyImplyLeading: false,
            title: const Text('Find a Store'),
            actions: [
              // Location button
              IconButton(
                onPressed: () async {
                  await storeProvider.fetchUserLocation();
                  if (storeProvider.hasLocation && _mapController != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(
                          storeProvider.userPosition!.latitude,
                          storeProvider.userPosition!.longitude,
                        ),
                        12.0,
                      ),
                    );
                  }
                },
                icon: storeProvider.isLoadingLocation
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Icon(
                        storeProvider.hasLocation
                            ? Icons.my_location
                            : Icons.location_searching,
                        color: AppColors.white,
                      ),
                tooltip: 'Use my location',
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Column(
            children: [
              // ── Google Map ─────────────────────────────────────────────
              SizedBox(
                height: 280,
                child: _buildMapPlaceholder(),
              ),

              // ── Error message ──────────────────────────────────────────
              if (storeProvider.locationError.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  color: AppColors.errorRed.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.errorRed, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          storeProvider.locationError,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.errorRed),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── Store count header ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Row(
                  children: [
                    Text(
                      '${stores.length} Stores',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const Spacer(),
                    if (storeProvider.hasLocation)
                      Text(
                        'Sorted by distance',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.freshGreen),
                      ),
                  ],
                ),
              ),

              // ── Store list ─────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    final isSelected =
                        storeProvider.selectedStore?.id == store.id;

                    return StoreTile(
                      store: store,
                      distance: storeProvider.formattedDistance(store),
                      isSelected: isSelected,
                      onDirections: () => _openDirections(
                        store.latitude,
                        store.longitude,
                        store.name,
                      ),
                      onOrderHere: () {
                        storeProvider.selectStore(store);
                        _moveToStore(storeProvider);
                        // Navigate to menu
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MenuScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
