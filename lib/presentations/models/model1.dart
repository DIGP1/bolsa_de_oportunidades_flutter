// lib/presentations/models/job_model.dart
class JobOpportunity {
  final String title;
  final String company;
  final String location;
  final String type;
  final String salary;
  final String description;

  JobOpportunity({
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
    required this.description,
  });

  // Aquí más tarde añadiremos métodos para convertir desde/hacia JSON
  // cuando integremos la API
}