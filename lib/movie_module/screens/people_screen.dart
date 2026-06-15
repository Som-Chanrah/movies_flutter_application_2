import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/person_model.dart';
import '../services/the_people_service.dart';
import 'person_detail_screen.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final _service = ThePeopleService();

  late Future<PopularPeople> _futureData = _service.readPopular();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("People")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = _service.readPopular();
          });
        },
        child: FutureBuilder<PopularPeople>(
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
                        _futureData = _service.readPopular();
                      });
                    },
                    child: Text("RETRY"),
                  ),
                ],
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return _buildGridView(snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildGridView(PopularPeople? data) {
    if (data == null) return Center(child: Icon(Icons.person));

    final items = data.results;

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PersonDetailScreen(item.id.toString()),
              ),
            );
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.profilePath == null
                        ? Container(color: Colors.grey)
                        : CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500/${item.profilePath}',
                            placeholder: (context, url) =>
                                Container(color: Colors.grey),
                            errorWidget: (context, url, error) =>
                                Container(color: Colors.grey.shade800),
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
