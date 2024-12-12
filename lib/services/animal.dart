import 'package:flutter/foundation.dart';
import 'package:wilde_buren/config/app_config.dart';
import 'package:wildlife_api_connection/models/animal_tracking.dart';
import 'package:wildlife_api_connection/animal_api.dart';

class AnimalService {
  final _animalApi = AnimalApi(
    AppConfig.shared.apiClient,
  );

  Future<List<AnimalTracking>> getAllAnimalTrackings() async {
    try {
      final response = await _animalApi.getAllAnimalTrackings();
      return response;
    } catch (e) {
      debugPrint("Get all animal trackings failed: $e");
      throw ("Get all animal trackings failed: $e");
    }
  }
}
