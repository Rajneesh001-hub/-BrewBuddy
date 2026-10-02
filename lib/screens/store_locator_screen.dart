// ─── Store Locator Screen ─────────────────────────────────────────────────────
// OpenStreetMap with store markers + user location, scrollable store list,
// Directions (url_launcher → Google Maps) and Order Here button.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _moveToStore(StoreProvider storeProvider) {
    final store = storeProvider.selectedStore;
    if (store != null) {
      _mapController.move(
        LatLng(store.latitude, store.longitude),
        14.0,
      );
    }
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

        // Build markers for all stores
        final storeMarkers = stores
            .map(
              (store) => Marker(
                point: LatLng(store.latitude, store.longitude),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => storeProvider.selectStore(store),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: storeProvider.selectedStore?.id == store.id
                          ? AppColors.freshGreen
                          : AppColors.caramelGold,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList();

        // User location marker
        if (storeProvider.hasLocation) {
          storeMarkers.add(
            Marker(
              point: LatLng(
                storeProvider.userPosition!.latitude,
                storeProvider.userPosition!.longitude,
              ),
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          );
        }

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
                  if (storeProvider.hasLocation) {
                    _mapController.move(
                      LatLng(
                        storeProvider.userPosition!.latitude,
                        storeProvider.userPosition!.longitude,
                      ),
                      12.0,
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
              // ── OpenStreetMap ──────────────────────────────────────────
              SizedBox(
                height: 280,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        const LatLng(20.5937, 78.9629), // India center
                    initialZoom: 5.0,
                  ),
                  children: [
                    // OpenStreetMap tiles
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.brewbuddy.app',
                    ),
                    // Markers layer
                    MarkerLayer(
                      markers: storeMarkers,
                    ),
                  ],
                ),
              ),

              // ── Error message ──────────────────────────────────────────
              if (storeProvider.locationError.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  color: AppColors.errorRed.withValues(alpha: 0.1),
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
