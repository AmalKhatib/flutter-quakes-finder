import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quakes_app/model/quakes_model.dart';

class Network{

  Future<QuakesModel> getQuakes() async{
    final url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";

    final response = await http.Client().get(Uri.parse(url));

    if(response.statusCode == 200){
      return QuakesModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Couldn’t get data!");
    }
  }

}