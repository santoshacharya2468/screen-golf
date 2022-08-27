import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Position?> getCurrentLocation() async {

  LocationPermission permission;
 
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return null;
  } 

  return await Geolocator.getCurrentPosition();
}

Future<Map<String,dynamic>> fullAddressFromPosition(LatLng position)async{
List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
 return placemarks.first.toJson();
}