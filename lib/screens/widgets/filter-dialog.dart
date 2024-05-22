import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final void Function(Map<String, dynamic>) onApplyFilter;

  FilterDialog({required this.onApplyFilter});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _jobTypeController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _publicationDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter Jobs', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _jobTypeController,
                      decoration: InputDecoration(labelText: 'Type of Job'),
                    ),
                    TextFormField(
                      controller: _companyController,
                      decoration: InputDecoration(labelText: 'Company'),
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _publicationDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        _publicationDate == null
                            ? 'Select Publication Date'
                            : 'Publication Date: ${_publicationDate!.toLocal()}'.split(' ')[0],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop();
                        widget.onApplyFilter({
                          'jobType': _jobTypeController.text,
                          'company': _companyController.text,
                          'location': _locationController.text,
                          'publicationDate': _publicationDate?.toIso8601String(),
                        });
                      }
                    },
                    child: Text('Apply Filters'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _jobTypeController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}