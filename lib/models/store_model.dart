// ─── Store Model ──────────────────────────────────────────────────────────────
// Represents a BrewBuddy store location.

class StoreModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String openingTime; // e.g. "07:00 AM"
  final String closingTime; // e.g. "10:00 PM"
  final bool hasWifi;
  final bool hasSeating;
  final bool hasParking;
  final bool isDriveThru;
  final String phoneNumber;

  const StoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
    this.hasWifi = true,
    this.hasSeating = true,
    this.hasParking = false,
    this.isDriveThru = false,
    required this.phoneNumber,
  });

  /// Returns a formatted hours string
  String get hours => '$openingTime – $closingTime';

  /// Whether the store is currently open (simplified check)
  bool get isOpenNow {
    final now = DateTime.now();
    // Parse opening/closing from "HH:MM AM/PM" format
    try {
      final open = _parseTime(openingTime);
      final close = _parseTime(closingTime);
      final currentMinutes = now.hour * 60 + now.minute;
      return currentMinutes >= open && currentMinutes < close;
    } catch (_) {
      return true;
    }
  }

  int _parseTime(String timeStr) {
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final String period = parts[1].toUpperCase();
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return hour * 60 + minute;
  }
}
