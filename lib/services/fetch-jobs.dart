import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobscrapper_mobile/models/job.dart';

Future<List<Job>> fetchJobsFromApi([Map<String, dynamic>? filters]) async {
  const String baseUrl = 'http://34.67.14.30:8000/api/joblist/';
  Uri uri = Uri.parse(baseUrl);

  if (filters != null && filters.isNotEmpty) {
    filters.removeWhere((key, value) => value == null || value.toString().isEmpty);
    uri = uri.replace(queryParameters: filters);
  }

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);

    if(jsonResponse.isEmpty){
      return [];
    } else {
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    }
  } else {
    throw Exception('Failed to load jobs');
  }
}