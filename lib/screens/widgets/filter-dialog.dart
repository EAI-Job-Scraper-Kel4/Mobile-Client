import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final void Function(Map<String, dynamic>) onApplyFilter;

  FilterDialog({required this.onApplyFilter});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _jobNameControllers = [TextEditingController()];
  List<TextEditingController> _companyControllers = [TextEditingController()];
  List<TextEditingController> _locationControllers = [TextEditingController()];
  String? _publicationDateCategory;
  final List<String> _dateCategories = [
    'today',
    'two_days_ago',
    'one_week_ago',
    'two_weeks_ago',
    'one_month_ago'
  ];
  List<String> _selectedSources = [];
  final List<String> _sources = [
    'linkedin',
    'jobstreet',
    'kalibrr',
    'karir',
  ];

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
              Text('Filter Jobs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildDynamicFields(
                      label: 'Type of Job',
                      controllers: _jobNameControllers,
                      addField: () => setState(() => _jobNameControllers.add(TextEditingController())),
                      removeField: (index) => setState(() {
                        if (_jobNameControllers.length > 1) {
                          _jobNameControllers.removeAt(index);
                        }
                      }),
                    ),
                    _buildDynamicFields(
                      label: 'Company',
                      controllers: _companyControllers,
                      addField: () => setState(() => _companyControllers.add(TextEditingController())),
                      removeField: (index) => setState(() {
                        if (_companyControllers.length > 1) {
                          _companyControllers.removeAt(index);
                        }
                      }),
                    ),
                    _buildDynamicFields(
                      label: 'Location',
                      controllers: _locationControllers,
                      addField: () => setState(() => _locationControllers.add(TextEditingController())),
                      removeField: (index) => setState(() {
                        if (_locationControllers.length > 1) {
                          _locationControllers.removeAt(index);
                        }
                      }),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Publication Date Category'),
                      value: _publicationDateCategory,
                      items: _dateCategories
                          .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category.replaceAll('_', ' ').toUpperCase()),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _publicationDateCategory = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildSourceSelection(),
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
                          'jobName': _jobNameControllers.map((controller) => controller.text).toList().join(','),
                          'company': _companyControllers.map((controller) => controller.text).toList().join(','),
                          'jobLocation': _locationControllers.map((controller) => controller.text).toList().join(','),
                          'publicationDateCategory': _publicationDateCategory,
                          'source': _selectedSources.join(','),
                        });
                      }
                    },
                    child: Text('Apply Filters'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicFields({
    required String label,
    required List<TextEditingController> controllers,
    required VoidCallback addField,
    required Function(int) removeField,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ...controllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(labelText: '$label ${index + 1}'),
                ),
              ),
              if (controllers.length > 1)
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => removeField(index),
                ),
            ],
          );
        }).toList(),
        TextButton(
          onPressed: addField,
          child: Text('Add $label'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildSourceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Source',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        Wrap(
          children: _sources.map((source) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _selectedSources.contains(source),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        _selectedSources.add(source);
                      } else {
                        _selectedSources.remove(source);
                      }
                    });
                  },
                ),
                Text(source),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _jobNameControllers.forEach((controller) => controller.dispose());
    _companyControllers.forEach((controller) => controller.dispose());
    _locationControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
