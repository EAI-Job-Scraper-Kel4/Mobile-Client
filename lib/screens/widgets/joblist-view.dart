import 'package:flutter/material.dart';
import 'package:jobscrapper_mobile/screens/widgets/filter-dialog.dart';
import 'package:jobscrapper_mobile/models/job.dart';
import 'package:jobscrapper_mobile/screens/widgets/job-card.dart';
import 'package:jobscrapper_mobile/services/fetch-jobs.dart';

class JobListView extends StatefulWidget {
  @override
  _JobListViewState createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  List<Job> _jobs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs([Map<String, dynamic>? filters]) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<Job> jobs = await fetchJobsFromApi(filters);
      setState(() {
        _jobs = jobs;
      });
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        onApplyFilter: (filterData) {
          fetchJobs(filterData);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Listings'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : ListView(
        children: _jobs.map((job) => JobCard(job: job)).toList(),
      ),
    );
  }
}
