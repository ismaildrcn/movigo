import 'package:movigo/data/model/movie/cast_model.dart';
import 'package:movigo/data/model/movie/crew_model.dart';

class Credits {
  final int id;
  final List<CastModel> cast;
  final List<CrewModel> crew;

  Credits({required this.id, required this.cast, required this.crew});

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
      id: json['id'],
      cast: (json['cast'] as List)
          .map((castJson) => CastModel.fromJson(castJson))
          .toList(),
      crew: (json['crew'] as List)
          .map((crewJson) => CrewModel.fromJson(crewJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "cast": cast.map((e) => e.toJson()).toList(),
    "crew": crew.map((e) => e.toJson()).toList(),
  };
}
