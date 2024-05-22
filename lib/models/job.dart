class Job {
  final String jobName;
  final String publicationDate;
  final String jobLocation;
  final String company;
  final String source;
  final String sourceUrl;

  Job({
    required this.jobName,
    required this.publicationDate,
    required this.jobLocation,
    required this.company,
    required this.source,
    required this.sourceUrl,
  });

  // Factory constructor to create a Job instance from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobName: json['job_name'],
      publicationDate: json['publication_date'],
      jobLocation: json['job_location'],
      company: json['company'],
      source: json['source'],
      sourceUrl: json['source_url'],
    );
  }

  // Method to convert a Job instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'job_name': jobName,
      'publication_date': publicationDate,
      'job_location': jobLocation,
      'company': company,
      'source': source,
      'source_url': sourceUrl,
    };
  }
}