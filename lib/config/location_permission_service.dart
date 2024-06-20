import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionService {
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
    } else {
      print('Location permissions granted');
    }
    return permission;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Future<Placemark?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  Future<bool> isLocationPermissionGranted() {
    return Geolocator.isLocationServiceEnabled();
  }
}