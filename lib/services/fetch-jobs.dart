import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobscrapper_mobile/models/job.dart';

Future<List<Job>> fetchJobsFromApi(Map<String, dynamic> filters) async {
  const String baseUrl = 'http://35.223.83.102/api/joblist/';
  Uri uri = Uri.parse(baseUrl).replace(queryParameters: filters);

  print('Fetching jobs from: $uri');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> jobList = jsonResponse['results'];
    int totalJobs = jsonResponse['total'];

    if (jobList.isEmpty) {
      return [];
    } else {
      List<Job> jobs = jobList.map((job) => Job.fromJson(job)).toList();
      jobs.first.total = totalJobs; // Setting the total count in the first job for pagination
      return jobs;
    }
  } else {
    throw Exception('Failed to load jobs');
  }
}
