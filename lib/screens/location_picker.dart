import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:massageapp/helper/get_location.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng ? currentPosition;
   Completer<GoogleMapController> _controller = Completer();
   static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();
    _focusCurrentPosition();
  }
  _focusCurrentPosition()async{
    final loc=await getCurrentLocation();
    if(loc==null)return;
    position=LatLng(loc.latitude, loc.longitude);
    if(position!=null){
    var controller= await  _controller.future;
     controller.animateCamera(CameraUpdate.newLatLng(position!));
     marker=Marker(markerId: MarkerId('f'),position: position!);
          setState(() {
            
          });
          var pm=await fullAddressFromPosition( position!);
          placemark=Placemark.fromMap(pm);
          setState(() {
            
          });
    }
  }
  Marker? marker;
  Placemark? placemark;
  LatLng ? position;
 @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers:marker!=null? {marker!} :{},
            onTap: (p)async{
             final result=await fullAddressFromPosition(p);
              position=p;
              marker=Marker(markerId: MarkerId('f'),position: p);
              setState(() {
                placemark=Placemark.fromMap(result);
              });
            },
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 10,
            child: Card(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                   // height: 100,
                   padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      //color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  //  width: 300,
                    child:placemark==null?SizedBox():Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Name:${placemark!.name}\n postal code :${placemark!.postalCode}\n Country:${placemark!.country}'),
                    ) ,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(onPressed: ()async{      
                      Navigator.of(context).pop({
                        'placemark':placemark,
                        'position':position,
                      });
                    }, child: Text('Select')),
                  )
                ],
              ),
            ))
        ],
      ),
      
    );
  }
}
