import 'package:geolocator/geolocator.dart';

class GeolocationService {
  /// Determines if location services are enabled and requests permission if needed.
  /// Returns true if location services are enabled and permission is granted.
  Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Gets the current position of the device.
  /// Throws a [LocationServiceException] if location services are disabled
  /// or permission is denied.
  Future<Position> getCurrentPosition() async {
    final hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      throw const LocationServiceException('Location permission denied');
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw LocationServiceException(e.toString());
    }
  }

  /// Gets the last known position of the device.
  /// Returns null if no position is available.
  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  /// Stream of position updates.
  /// Throws a [LocationServiceException] if location services are disabled
  /// or permission is denied.
  Stream<Position> getPositionStream() async* {
    final hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      throw const LocationServiceException('Location permission denied');
    }

    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  /// Calculates the distance between two coordinates in meters.
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Opens location settings on the device.
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Opens app settings on the device.
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}

/// Exception thrown when location services fail
class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}