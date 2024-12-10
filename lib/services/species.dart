import 'package:flutter/material.dart';
import 'package:wildlife_api_connection/api_client.dart';
import 'package:wildlife_api_connection/models/species.dart';
import 'package:wildlife_api_connection/species_api.dart';

class SpeciesService {
  final _speciesApi = SpeciesApi(
    ApiClient("https://wildlifenl-uu-michi011.apps.cl01.cp.its.uu.nl/species"),
  );

  Future<List<Species>> getAllSpecies() {
    try {
      final response = _speciesApi.getAllSpecies();
      return response;
    } catch (e) {
      debugPrint("Get all species failed: $e");
      throw ("Get all species failed: $e");
    }
  }
}
