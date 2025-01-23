import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:wilde_buren/config/theme/asset_icons.dart';
import 'package:wilde_buren/services/animal.dart';
import 'package:wilde_buren/services/tracking.dart';
import 'package:wilde_buren/views/reporting/widgets/manager/location.dart';
import 'package:wildlife_api_connection/models/animal_tracking.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wildlife_api_connection/models/species.dart';

class MapView extends StatefulWidget {
  final AnimalService animalService;
  final TrackingService trackingService;

  const MapView({
    super.key,
    required this.animalService,
    required this.trackingService,
  });

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  // Set global properties
  late Timer _animalTimer;
  late Timer _trackingTimer;
  List<Marker> _markers = [];
  LatLng? _initialPosition;
  final MapController _mapController = MapController();

  // On initial state, set the initial location and start fetching markers with a timer
  @override
  void initState() {
    super.initState();
    processing();
  }

  // On initial state, set the initial location and start fetching markers with a timer await to prevent multiple permission requests
  void processing() async {
    await _setInitialLocation();
    await _startTimers();
    await _sendTracking();
    await _fetchMarkers();
  }

  @override
  void dispose() {
    _animalTimer.cancel();
    _trackingTimer.cancel();
    super.dispose();
  }

  // Set initial location for map bounds and camera center
  Future<void> _setInitialLocation() async {
    LatLng position = await _determinePosition();

    setState(() {
      _initialPosition = position;
    });
  }

  // Start timer to retrieve/upload location and fetch markers
  Future<void> _startTimers() async {
    // Set timer to retrieve location every 10 seconds
    _animalTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _fetchMarkers();
    });

    _trackingTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      await _sendTracking();
    });
  }

  // Get the current location of the device
  Future<LatLng> _determinePosition() async {
    if (!context.mounted) {
      return const LatLng(51.25851739912562, 5.622422796819703);
    }
    final location = await LocationManager().getUserLocation(context);
    return location;
  }

  // Fetch markers from the server using the animal service
  Future<void> _fetchMarkers() async {
    try {
      // Simulating API call
      List<AnimalTracking> animalTrackings =
          await widget.animalService.getAllAnimalTrackings();
      debugPrint('Animal trackings length: ${animalTrackings.length}');

      // Marker options
      List<Marker> newMarkers = animalTrackings.map((tracking) {
        var animalMarkerOptions = _getAnimalMarkerOptions(tracking.species);
        return Marker(
          width: animalMarkerOptions.size,
          height: animalMarkerOptions.size,
          rotate: true, // Keeps markers upright when rotating the map
          point:
              LatLng(tracking.location.latitude, tracking.location.longitude),
          child: GestureDetector(
            onTap: () {
              // Show dialog when clicking on a marker
              showDialog(
                  builder: (_) => AlertDialog(
                          title: const Text("Caught"),
                          content: Text("Clicked on ${tracking.name}"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"))
                          ]),
                  context: context,
                  barrierDismissible: true);
            },
            child: SvgPicture.asset(
              animalMarkerOptions.svgPath,
              colorFilter:
                  ColorFilter.mode(animalMarkerOptions.color, BlendMode.srcIn),
            ),
          ),
        );
      }).toList();

      // Set the new markers
      setState(() {
        _markers = newMarkers;
      });
    } catch (e) {
      debugPrint('Error fetching markers: $e');
    }
  }

  Future<void> _sendTracking() async {
    LatLng position = await _determinePosition();
    widget.trackingService
        .sendTrackingReading(LatLng(position.latitude, position.longitude));
    debugPrint('Sent tracking reading');
  }

  // Build the map view with the current location and markers
  @override
  Widget build(BuildContext context) {
    // If the initial position is not set, show a loading indicator
    if (_initialPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Set bounds for the camera constraint using initial position (Make sure this is not done dynamically which may crash because of camera constraint #https://github.com/fleaflet/flutter_map/issues/1760)
    final bounds = LatLngBounds(
      LatLng(
          _initialPosition!.latitude - 0.1, _initialPosition!.longitude - 0.1),
      LatLng(
          _initialPosition!.latitude + 0.1, _initialPosition!.longitude + 0.1),
    );

    // Map settings
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialPosition!,
        initialZoom: 16,
        minZoom: 12,
        maxZoom: 20,
        cameraConstraint: CameraConstraint.containCenter(bounds: bounds),
      ),
      children: [
        // Used to display the map tiles, in this case the World Imagery tiles (Check out other free tiles #https://alexurquhart.github.io/free-tiles/)
        TileLayer(
          urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.wildlifenl.wildgids',
        ),
        CurrentLocationLayer(), // Used to display the current location of the user (blue dot)
        MarkerLayer(markers: _markers),
      ],
    );
  }
}

// Struct for animal marker
class AnimalMarker {
  final String svgPath;
  final Color color;
  final double size;

  AnimalMarker({
    required this.svgPath,
    required this.color,
    required this.size,
  });
}

// Function to determine icon based on animal type
AnimalMarker _getAnimalMarkerOptions(Species species) {
  switch (species.id) {
    case '2e6e75fb-4888-4c8d-81c6-ab31c63a7ecb':
      return AnimalMarker(
          svgPath: AssetIcons.bison, color: Colors.lightGreen, size: 40);
    case '79952c1b-3f43-4d6e-9ff0-b6057fda6fc1':
      return AnimalMarker(
          svgPath: AssetIcons.scottishHighlander,
          color: Colors.lightGreen,
          size: 40);
    case '28775ecb-1af6-4b22-a87a-e15b1999d55c':
      return AnimalMarker(
          svgPath: AssetIcons.wildBoar, color: Colors.lightGreen, size: 50);
    case 'cf83db9d-dab7-4542-bc00-08c87d1da68d':
      return AnimalMarker(
          svgPath: AssetIcons.wolf, color: Colors.red.shade400, size: 40);
    default:
      return AnimalMarker(
          svgPath: AssetIcons.universal, color: Colors.lightGreen, size: 40);
  }
}
