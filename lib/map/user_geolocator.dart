import 'package:geolocator/geolocator.dart';

Future<Position> _getUserLocation() async {
  // Verifica si los permisos de ubicación están habilitados
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Los servicios de ubicación están deshabilitados.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Los permisos de ubicación fueron denegados.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Los permisos de ubicación están denegados permanentemente.');
  }

  // Obtiene la ubicación actual
  return await Geolocator.getCurrentPosition();
}