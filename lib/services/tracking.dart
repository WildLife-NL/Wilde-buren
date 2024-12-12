// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:wilde_buren/config/app_config.dart';
import 'package:wildlife_api_connection/tracking_api.dart';

class TrackingService {
  final _trackingApi = TrackingApi(AppConfig.shared.apiClient);

  Future<void> sendTrackingReading(
    LatLng latlng,
  ) async {
    try {
      await _trackingApi.sendTrackingReading(latlng);
    } catch (e) {
      debugPrint('Authentication failed: $e');
    }
  }
}
