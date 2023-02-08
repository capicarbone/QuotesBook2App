class Author {
  final String firstName;
  final String lastName;
  final String shortDescription;
  final String? pictureUrl;

  Author(
      {required this.firstName,
      required this.lastName,
      required this.shortDescription,
      this.pictureUrl});
}
