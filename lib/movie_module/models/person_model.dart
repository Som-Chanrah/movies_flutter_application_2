class PersonSummary {
  final int id;
  final String name;
  final String? profilePath;

  PersonSummary({required this.id, required this.name, this.profilePath});
}

class PopularPeople {
  final List<PersonSummary> results;

  PopularPeople({required this.results});
}

class PersonDetail {
  final int id;
  final String name;
  final String? profilePath;
  final String? biography;
  final String? birthday;
  final String? placeOfBirth;

  PersonDetail({
    required this.id,
    required this.name,
    this.profilePath,
    this.biography,
    this.birthday,
    this.placeOfBirth,
  });
}
