import 'dart:async';

import '../models/person_model.dart';

class ThePeopleService {
  Future<PopularPeople> readPopular() async {
    await Future.delayed(Duration(milliseconds: 200));
    final results = List.generate(
      8,
      (i) =>
          PersonSummary(id: i + 1, name: 'Person ${i + 1}', profilePath: null),
    );
    return PopularPeople(results: results);
  }

  Future<PersonDetail> get(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    final intId = int.tryParse(id) ?? 0;
    return PersonDetail(
      id: intId,
      name: 'Person $id',
      profilePath: null,
      biography: 'Biography for person $id',
      birthday: '1970-01-01',
      placeOfBirth: 'Unknown',
    );
  }
}
