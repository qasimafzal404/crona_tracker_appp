import 'dart:convert';

import 'package:crona_tracker_app/Model/world_states_model.dart';
import 'package:crona_tracker_app/services/utilities/app_uri.dart';
import 'package:http/http.dart' as http;

class StatsService{

  Future<CovidStats>fetchWorldStatesRecord
  ()async{
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if(response.statusCode==200){
      var data = jsonDecode(response.body);
      return CovidStats.fromJson(data);
    }else{
      throw Exception('Error'); 
    }
}
}