import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

import 'package:mobile/src/core/location/location.dart';

String? _pickCity(Placemark p) {
  final v1 = p.locality?.trim();
  if (v1 != null && v1.isNotEmpty) return v1;

  final v2 = p.subAdministrativeArea?.trim();
  if (v2 != null && v2.isNotEmpty) return v2;

  final v3 = p.administrativeArea?.trim();
  if (v3 != null && v3.isNotEmpty) return v3;

  return null;
}

String? _pickStreet(Placemark p) {
  final street = p.street?.trim();
  if (street != null && street.isNotEmpty) return street;

  // fallback jeśli street puste (różnice platform)
  final thoroughfare = p.thoroughfare?.trim();
  final subThoroughfare = p.subThoroughfare?.trim();

  final parts = <String>[];
  if (thoroughfare != null && thoroughfare.isNotEmpty) parts.add(thoroughfare);
  if (subThoroughfare != null && subThoroughfare.isNotEmpty) {
    parts.add(subThoroughfare);
  }

  if (parts.isEmpty) return null;
  return parts.join(' ');
}

final locationCityStreetProvider = FutureProvider.autoDispose
    .family<String?, AppLocation>((ref, loc) async {
      final list = await placemarkFromCoordinates(loc.lat, loc.lon);
      if (list.isEmpty) return null;

      final p = list.first;

      final city = _pickCity(p);
      final street = _pickStreet(p);

      if (city == null && street == null) return null;
      if (street == null) return city;
      if (city == null) return street;

      return '$street, $city';
    });
