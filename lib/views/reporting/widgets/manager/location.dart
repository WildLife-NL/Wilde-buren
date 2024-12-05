import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:wilde_buren/views/home/home_view.dart';

class LocationManager {
  Future<LatLng> getUserLocation(BuildContext context) async {
    final status = await _getLocationPermission();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } else if (status.isDenied) {
      if (!context.mounted) {
        return const LatLng(51.25851739912562, 5.622422796819703);
      }
      requestLocationAccess(context);
    } else {
      if (!context.mounted) {
        return const LatLng(51.25851739912562, 5.622422796819703);
      }
      _showLocationPermissionDialog(context);
    }
    return const LatLng(51.25851739912562, 5.622422796819703);
  }

  Future<PermissionStatus> _getLocationPermission() async {
    return await Permission.location.request();
  }

  Future<void> requestLocationAccess(BuildContext context) async {
    await _getLocationPermission();
    return;
  }

  void _showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Locatie Permissie nodig'),
          content: const Text(
              'Deze app heeft toegang tot je locatie nodig om verder te gaan. Om toestemming te geven tot je locatie moet je dit aanpassen in je instellingen.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeView(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Rapportatie beindigen'),
            ),
          ],
        );
      },
    );
  }
}
