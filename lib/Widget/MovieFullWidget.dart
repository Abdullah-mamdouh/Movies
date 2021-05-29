import 'dart:convert';

import 'package:app_api/Models/movie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class MovieFullWidget extends StatefulWidget {
  @override
  _MovieFullWidgetState createState() => _MovieFullWidgetState();
}

class _MovieFullWidgetState extends State<MovieFullWidget> {
  List<Movie> movies = new List<Movie>();

  int page = 0;

  ScrollController _sc = new ScrollController();

  int  number_startedpage= 1;

  final Dio dio = new Dio();
  @override
  void initState() {
    super.initState();
    _populateAllMovies();
    _sc.addListener((() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _fetchAllMovies(number_startedpage);
        _populateAllMovies();
      }
    }));
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  void _populateAllMovies() async {
    final movie = await _fetchAllMovies(++page);
    setState(() {
      movies.addAll(movie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          controller: _sc,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            int numb_page = movies.length;

            final movie = movies[index];
            print(movie.poster +
                "       " +
                page.toString()

               );

            return Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),

              child: Card(
                  margin: EdgeInsets.only(left: 1, right: 1, top: 5),
                  shadowColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.lightGreenAccent,
                  elevation: 10,

                  child: Padding(
                    padding: EdgeInsets.only(left: 8, top: 5, bottom: 5),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        movie.date != null
                            ? Text(movie.date,
                                style: TextStyle(color: Colors.red[500]))
                            : Text(DateTime.now().toString(),
                                style: TextStyle(color: Colors.red[500])),
                        SizedBox(
                          height: 5,
                        ),
                        Row(

                          children: [
                            SizedBox(
                                width: 100,
                                child: ClipRRect(
                                  child: Image.network(
                                      'https://image.tmdb.org/t/p/original' +
                                          movie.poster),
                                  borderRadius: BorderRadius.circular(10),
                                )),

                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 5, right: 3),
                                child: Text(movie.overview),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            );
          }),
      resizeToAvoidBottomInset: false,
    );
  }

  // get data from API
  Future<List<Movie>> _fetchAllMovies(int number) async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key=acea91d2bff1c"
                "53e6604e4985b6989e2&page=" +
            number.toString()));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["results"];
      // List<Movie> l = new List<Movie>();
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies!");
    }
  }
}
