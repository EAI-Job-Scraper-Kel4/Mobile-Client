import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jobscrapper_mobile/models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              job.jobName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 8.0),
            Text('Company: ${job.company}', style: TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(height: 8.0),
            Text('Location: ${job.jobLocation}', style: TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(height: 8.0),
            Text('Published on: ${job.publicationDate}', style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _launchURL(context, job.sourceUrl),
              child: Text(_getButtonText(job.source)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText(String source) {
    switch (source.toLowerCase()) {
      case 'linkedin':
        return 'Go To LinkedIn';
      case 'karir':
        return 'Go To Karir';
      case 'kalibrr':
        return 'Go To Kalibrr';
      case 'jobstreet':
        return 'Go To JobStreet';
      default:
        return 'Go To Source';
    }
  }

  void _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
