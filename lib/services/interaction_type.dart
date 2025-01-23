import 'package:flutter/material.dart';
import 'package:wildlife_api_connection/api_client.dart';
import 'package:wildlife_api_connection/interaction_type_api.dart';
import 'package:wildlife_api_connection/models/interaction_type.dart';

class InteractionTypeService {
  final _interactionTypeApi = InteractionTypeApi(
    ApiClient(
        "https://wildlifenl-uu-michi011.apps.cl01.cp.its.uu.nl/interactionTypes"),
  );

  Future<List<InteractionType>> getAllInteractionTypes() {
    try {
      final response = _interactionTypeApi.getAll();
      return response;
    } catch (e) {
      debugPrint("Get all interation types failed: $e");
      throw ("Get all interaction types failed: $e");
    }
  }
}
