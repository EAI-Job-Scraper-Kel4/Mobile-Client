import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobscrapper_mobile/models/job.dart';

Future<List<Job>> fetchJobsFromApi([Map<String, dynamic>? filters]) async {
  const String baseUrl = 'https://7305e73a-dba0-44e5-800d-cb9bfffc1b19.mock.pstmn.io/joblist';
  Uri uri = Uri.parse(baseUrl);

  if (filters != null && filters.isNotEmpty) {
    filters.removeWhere((key, value) => value == null || value.toString().isEmpty);
    uri = uri.replace(queryParameters: filters);
  }

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);

    if(jsonResponse.isEmpty){
      print("masuk sini");
      return [];
    } else {
      List jsonResponse = json.decode(response.body)['jobs'];
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    }
    // List jsonResponse = json.decode(response.body)['jobs'];
    // if (jsonResponse != null) {
    //   print("jsonResponse nggak null");
    //   // Handle the case where the response is a list of jobs
    //   return jsonResponse.map((job) => Job.fromJson(job)).toList();
    // } else {
    //   print("jsonResponse null");
    //   // Handle the case where the response is an empty object
    //   // Return an empty list or throw an error, depending on your requirements
    //   return [];
    // }
    // print("Ini responsenya ");
    // print(response);
    // List jsonResponse = json.decode(response.body)['jobs'];
    // print("Ini json responsenya ");
    // print(jsonResponse);
    // return jsonResponse.map((job) => Job.fromJson(job)).toList();
  } else {
    throw Exception('Failed to load jobs');
  }
}