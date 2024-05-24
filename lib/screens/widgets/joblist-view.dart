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
  int _currentPage = 1;
  int _totalJobs = 0;
  int _limit = 10;
  Map<String, dynamic> _currentFilters = {};

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
      Map<String, dynamic> queryParams = {
        'limit': _limit.toString(),
        'page': _currentPage.toString(),
        ...?_currentFilters,
        ...?filters,
      };
      List<Job> jobs = await fetchJobsFromApi(queryParams);
      setState(() {
        _jobs = jobs;
        _totalJobs = _jobs.isNotEmpty ? _jobs.first.total : 0;
        if (filters != null) {
          _currentFilters = filters;
        }
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
          _currentPage = 1;
          fetchJobs(filterData);
        },
      ),
    );
  }

  void _updateLimit(int? newValue) {
    if (newValue != null) {
      setState(() {
        _limit = newValue;
        _currentPage = 1;
      });
      fetchJobs();
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage -= 1;
      });
      fetchJobs();
    }
  }

  void _nextPage() {
    if (_currentPage * _limit < _totalJobs) {
      setState(() {
        _currentPage += 1;
      });
      fetchJobs();
    }
  }

  void _gotoPage(int page) {
    if (page >= 1 && page <= (_totalJobs / _limit).ceil()) {
      setState(() {
        _currentPage = page;
      });
      fetchJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Listings', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _openFilterDialog,
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          _buildLimitDropdown(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text(_error!))
                : ListView(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              children: _jobs.map((job) => JobCard(job: job)).toList(),
            ),
          ),
          _buildPaginationButtons(),
        ],
      ),
    );
  }

  Widget _buildLimitDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Jobs per page:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButton<int>(
            value: _limit,
            items: [10, 20, 30, 50, 100].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
            onChanged: _updateLimit,
            style: TextStyle(fontSize: 16, color: Colors.black),
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButtons() {
    int totalPages = (_totalJobs / _limit).ceil();
    int startPage = (_currentPage - 5 > 0) ? _currentPage - 5 : 1;
    int endPage = (_currentPage + 5 < totalPages) ? _currentPage + 5 : totalPages;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _currentPage > 1 ? _previousPage : null,
                child: Text('Prev'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Text(
                'Page $_currentPage of $totalPages',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: _currentPage * _limit < _totalJobs ? _nextPage : null,
                child: Text('Next'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 4,
            children: List<Widget>.generate(endPage - startPage + 1, (index) {
              int page = startPage + index;
              return ElevatedButton(
                onPressed: () => _gotoPage(page),
                child: Text(page.toString()),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: page == _currentPage ? Colors.deepPurple : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
