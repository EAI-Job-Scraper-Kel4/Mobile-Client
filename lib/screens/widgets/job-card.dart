import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jobscrapper_mobile/models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  job.jobName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(job.company),
                SizedBox(height: 8.0),
                Text(job.jobLocation),
                SizedBox(height: 8.0),
                Text('Published on: ${job.publicationDate}'),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _launchURL(job.sourceUrl),
                child: Text(_getButtonText(job.source)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to get the button text based on the job source
  String _getButtonText(String source) {
    switch (source) {
      case 'linkedin.com':
        return 'Go To LinkedIn';
      case 'karir.com':
        return 'Go To Karir';
      case 'kalibrr.com':
        return 'Go To Kalibrr';
      case 'jobstreet.co.id':
        return 'Go To JobStreet';
      default:
        return 'Go To Source';
    }
  }

  void _launchURL(String url) async {
    await launchUrl(Uri.parse(url));
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
