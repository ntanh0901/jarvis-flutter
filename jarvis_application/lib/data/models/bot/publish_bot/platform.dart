

class Platform {
  final String name;
  final String icon;
  bool status;

  Platform({
    required this.name,
    required this.icon,
    this.status = false,
  });
}
