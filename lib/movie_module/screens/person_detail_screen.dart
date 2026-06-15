import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/person_model.dart';
import '../services/the_people_service.dart';

class PersonDetailScreen extends StatefulWidget {
  final String personId;

  const PersonDetailScreen(this.personId, {super.key});

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  final _service = ThePeopleService();

  late Future<PersonDetail> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _service.get(widget.personId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Person Detail")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureData = _service.get(widget.personId);
          });
        },
        child: FutureBuilder<PersonDetail>(
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
                        _futureData = _service.get(widget.personId);
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

  Widget _buildListView(PersonDetail? item) {
    if (item == null) return Center(child: Icon(Icons.person));

    double screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1000 ? (screenWidth - 1000) / 2 : 8,
      ),
      children: [
        if (item.profilePath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500/${item.profilePath}',
              placeholder: (context, url) => Container(color: Colors.grey),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.grey.shade800),
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(item.name),
            ),
          ),
        ),
        if (item.biography != null && item.biography!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Card(child: ListTile(title: Text(item.biography!))),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
            child: ListTile(
              leading: Icon(Icons.cake),
              title: Text(item.birthday ?? ""),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
            child: ListTile(
              leading: Icon(Icons.place),
              title: Text(item.placeOfBirth ?? ""),
            ),
          ),
        ),
      ],
    );
  }
}
