

class Movie {
  final String title;
  final String poster;
  final String date;
  final String overview;

  Movie({this.title, this.poster, this.date, this.overview});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        title: json["title"],
        poster: json["poster_path"],
        date: json["release_date"],
        overview: json["overview"]
    );
  }

}