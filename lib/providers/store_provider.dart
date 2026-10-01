// ─── Store Provider ───────────────────────────────────────────────────────────
// Manages store list, user location, and selected store state.

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/store_model.dart';
import '../data/mock_stores.dart';
import 'dart:math' as math;

class StoreProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  final List<StoreModel> _stores = mockStores;
  StoreModel? _selectedStore;
  Position? _userPosition;
  bool _isLoadingLocation = false;
  String _locationError = '';

  // ── Getters ────────────────────────────────────────────────────────────────

  List<StoreModel> get stores => _stores;

  StoreModel? get selectedStore => _selectedStore;

  Position? get userPosition => _userPosition;

  bool get isLoadingLocation => _isLoadingLocation;

  String get locationError => _locationError;

  bool get hasLocation => _userPosition != null;

  /// Stores sorted by distance from user (if location available)
  List<StoreModel> get sortedStores {
    if (_userPosition == null) return _stores;
    final sorted = List<StoreModel>.from(_stores);
    sorted.sort((a, b) {
      final da = _distanceTo(a);
      final db = _distanceTo(b);
      return da.compareTo(db);
    });
    return sorted;
  }

  // ── Distance helpers ───────────────────────────────────────────────────────

  /// Distance from user to a store in km (returns -1 if no location)
  double distanceTo(StoreModel store) {
    if (_userPosition == null) return -1;
    return _distanceTo(store);
  }

  double _distanceTo(StoreModel store) {
    if (_userPosition == null) return 0;
    return _haversineDistance(
      _userPosition!.latitude,
      _userPosition!.longitude,
      store.latitude,
      store.longitude,
    );
  }

  /// Haversine formula for distance in km
  double _haversineDistance(
    double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0; // Earth radius in km
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  double _toRad(double deg) => deg * math.pi / 180;

  String formattedDistance(StoreModel store) {
    final d = distanceTo(store);
    if (d < 0) return 'Distance N/A';
    if (d < 1) return '${(d * 1000).round()} m away';
    return '${d.toStringAsFixed(1)} km away';
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void selectStore(StoreModel store) {
    _selectedStore = store;
    notifyListeners();
  }

  /// Request and fetch the user's current location
  Future<void> fetchUserLocation() async {
    _isLoadingLocation = true;
    _locationError = '';
    notifyListeners();

    try {
      // Check permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'Location services are disabled.';
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationError = 'Location permission denied.';
          _isLoadingLocation = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError = 'Location permission permanently denied.';
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      _userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _locationError = 'Could not get location: $e';
    }

    _isLoadingLocation = false;
    notifyListeners();
  }
}
