/// Model class representing a Job or Internship opportunity.
class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String jobType; // 'Internship' or 'Full Time'
  final String workMode; // 'Remote', 'Hybrid', or 'On-site'
  final String salary; // e.g. '₹25,000 / month' or '₹6.5 - 8.0 LPA'
  final String description;
  final List<String> responsibilities;
  final List<String> requirements;
  final List<String> skills;
  final String companyLogoText; // Short 2-letter monogram for avatar
  final String postedDate;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.workMode,
    required this.salary,
    required this.description,
    required this.responsibilities,
    required this.requirements,
    required this.skills,
    required this.companyLogoText,
    required this.postedDate,
  });

  /// Factory constructor to create a Job from a JSON-compatible Map.
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      jobType: json['jobType'] as String,
      workMode: json['workMode'] as String,
      salary: json['salary'] as String,
      description: json['description'] as String,
      responsibilities: List<String>.from(json['responsibilities'] as List),
      requirements: List<String>.from(json['requirements'] as List),
      skills: List<String>.from(json['skills'] as List),
      companyLogoText: json['companyLogoText'] as String? ?? 'CC',
      postedDate: json['postedDate'] as String? ?? 'Recently',
    );
  }

  /// Converts the Job instance into a Map for serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'jobType': jobType,
      'workMode': workMode,
      'salary': salary,
      'description': description,
      'responsibilities': responsibilities,
      'requirements': requirements,
      'skills': skills,
      'companyLogoText': companyLogoText,
      'postedDate': postedDate,
    };
  }
}
