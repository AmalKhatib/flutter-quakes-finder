import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quakes_app/model/quakes_model.dart';
import 'package:quakes_app/network/network.dart';

class QuakesApp extends StatefulWidget {
  @override
  _QuakesAppState createState() => _QuakesAppState();
}

class _QuakesAppState extends State<QuakesApp> {

  Future<QuakesModel> _quakesData;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = <Marker>[];
  double _zoomVal = 5.0;

  @override
  void initState() {
    super.initState();
    _quakesData = Network().getQuakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            buildGoogleMap(context),
            _zoomMinus(),
            _zoomPlus()
          ]
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _findQuakes,
          label: Text("find quakes")
      ),
    );
  }

  Widget buildGoogleMap(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(36.1083333, -117.8608333), zoom: _zoomVal),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_markers),
      ),
    );
  }

  Widget _zoomMinus(){
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(FontAwesomeIcons.searchMinus, color: Colors.black87,),
          onPressed: (){
            _zoomVal--;
            _animateCamera(_zoomVal);
          },
        ),
      ),
    );
  }

  Widget _zoomPlus(){
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(FontAwesomeIcons.searchPlus, color: Colors.black87,),
        onPressed: (){
          _zoomVal--;
          _animateCamera(_zoomVal);
        },
      ),
    );
  }

  _findQuakes() {
    _markers.clear();
    _handleResponse();
  }

  _handleResponse() {
    setState(() {
      _quakesData.then((quakes) => {
        print(quakes.features[0].type),
        quakes.features.forEach((quake) =>
        {
          _markers.add(Marker(
              markerId: MarkerId(quake.id),
              infoWindow: InfoWindow(title: quake.properties.mag.toString(), snippet: quake.properties.title),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta),
              position: LatLng(quake.geometry.coordinates[1], quake.geometry.coordinates[0])
          ))
        })
      });
    });
  }

  Future<Void> _animateCamera(double zoomVal) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(40.712776, -74.005974), zoom: _zoomVal))
    );
  }


}
