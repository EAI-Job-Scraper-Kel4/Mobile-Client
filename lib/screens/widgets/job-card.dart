import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jobscrapper_mobile/models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              job.jobName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(job.company),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(job.jobLocation),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Published on: ${job.publicationDate}'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.link),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    job.source,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.open_in_new),
                  onPressed: () => _launchURL(job.sourceUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
