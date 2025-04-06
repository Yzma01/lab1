import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserMap extends StatefulWidget {
  @override
  _UserMapState createState() => _UserMapState();
}

class _UserMapState extends State<UserMap> {
  GoogleMapController? _mapController;
  LatLng? _userLocation;
  List<Marker> _markers = [];
  String _distanceInfo = '';

  @override
  void initState() {
    super.initState();
    _getUserLocation().then((position) {
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _addMarker(_userLocation!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String location = await _getLocationInput(context);
              if (location.isNotEmpty) {
                await searchLocation(location);
              }
            },
          ),
        ],
      ),
      body:
          _userLocation == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        setState(() {
                          _mapController = controller;
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: _userLocation!,
                        zoom: 15.0,
                      ),
                      markers: Set<Marker>.of(_markers),
                      onTap: _addMarker,
                    ),
                  ),
                  if (_distanceInfo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _distanceInfo,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
    );
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de ubicación denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permisos de ubicación denegados permanentemente.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _addMarker(LatLng position) {
    setState(() {
      if (_markers.length >= 2) {
        _markers.removeAt(0);
      }

      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(title: 'Punto seleccionado'),
        ),
      );

      if (_markers.length == 2) {
        _calculateDistance();
      } else {
        _distanceInfo = '';
      }

      // 📌 **Mover la cámara al último marcador**
      _mapController?.animateCamera(CameraUpdate.newLatLng(position));
    });
  }

  void _calculateDistance() {
    if (_markers.length == 2) {
      double distance = Geolocator.distanceBetween(
        _markers[0].position.latitude,
        _markers[0].position.longitude,
        _markers[1].position.latitude,
        _markers[1].position.longitude,
      );

      setState(() {
        _distanceInfo = 'Distancia: ${(distance / 1000).toStringAsFixed(2)} km';
      });
    }
  }

  Future<void> searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng location = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        // 📌 **Agregar marcador y mover la cámara**
        _addMarker(location);
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
      } else {
        _showErrorDialog('Ubicación no encontrada');
      }
    } catch (e) {
      _showErrorDialog('Error al buscar ubicación: $e');
    }
  }

  Future<String> _getLocationInput(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return await showDialog<String>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Buscar ubicación'),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Ingrese una dirección',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, ''),
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    child: Text('Buscar'),
                  ),
                ],
              ),
        ) ??
        '';
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}
