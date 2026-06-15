import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/movie_detail_model.dart';
import '../services/the_movie_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen(this.movieId, {super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Detail")),
      body: _buildBody(),
    );
  }

  final _service = TheMovieService();

  late Future<MovieDetail> _futureData = _service.get(widget.movieId);

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = _service.get(widget.movieId);
          });
        },
        child: FutureBuilder<MovieDetail>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.error.toString()),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _futureData = _service.get(widget.movieId);
                      });
                    },
                    child: Text("RETRY"),
                  ),
                ],
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return _buildListView(snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(MovieDetail? item) {
    if (item == null) {
      return Center(child: Icon(Icons.list));
    }

    double screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1000 ? (screenWidth - 1000) / 2 : 8,
      ),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500/${item.posterPath}',
            placeholder: (_, _) => Container(color: Colors.grey),
            errorWidget: (_, _, _) => Container(color: Colors.grey.shade800),
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
            child: ListTile(
              leading: Icon(Icons.movie),
              title: Text(item.title),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(child: ListTile(title: Text(item.overview))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
            child: ListTile(
              leading: Icon(Icons.date_range),
              title: Text(
                '${item.releaseDate.day}/${item.releaseDate.month}/${item.releaseDate.year}',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
