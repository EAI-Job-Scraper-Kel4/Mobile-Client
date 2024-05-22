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
    List jsonResponse = json.decode(response.body)['jobs'];
    return jsonResponse.map((job) => Job.fromJson(job)).toList();
  } else {
    throw Exception('Failed to load jobs');
  }
}