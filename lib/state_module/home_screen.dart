import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'product_model.dart';
import 'counter_logic.dart';
import 'detail_screen.dart';
import 'theme_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = true;

  int sum(int a, int b) {
    return a + b;
  }

  Future<int> add(int a, int b) {
    return Future.value(a + b);
  }

  @override
  Widget build(BuildContext context) {
    add(20, 30).then((value) {
      debugPrint("value = $value");
    });

    int s = sum(10, 20);
    debugPrint("s = $s");

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(backgroundColor: Theme.of(context).colorScheme.primary);
  }

  AppBar _buildAppBar() {
    bool dark = context.watch<ThemeLogic>().dark;
    return AppBar(
      title: Text("Home Screen"),
      actions: [
        IconButton(
          onPressed: () {
            context.read<ThemeLogic>().toggleDark();
          },
          icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
        ),
        IconButton(
          onPressed: () {
            context.read<CounterLogic>().decrease();
          },
          icon: Icon(Icons.remove),
        ),
        IconButton(
          onPressed: () {
            context.read<CounterLogic>().increase();
          },
          icon: Icon(Icons.add),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
          icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
        ),
      ],
    );
  }

  Future<List<ProductModel>> _readApiData() async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://api.escuelajs.co/api/v1/products"),
      );
      if (response.statusCode == 200) {
        // ✅ Use the productModelFromJson helper from product_model.dart
        List<ProductModel> products = productModelFromJson(response.body);
        return products;
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  late Future<List<ProductModel>> _futureData = _readApiData();

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureData = _readApiData();
        });
      },
      child: FutureBuilder<List<ProductModel>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.error.toString()),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _futureData = _readApiData();
                      });
                    },
                    child: Text("RETRY"),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return _isGridView
                ? _buildGridView(snapshot.data)
                : _buildListView(snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildGridView(List<ProductModel>? items) {
    if (items == null) return Center(child: Icon(Icons.list));

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = constraints.maxWidth > 600 ? 4 : 2;

        return GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 3 / 5,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DetailScreen(item)),
                );
              },
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(8),
                        child: CachedNetworkImage(
                          // ✅ item.images is List<String>, use first image
                          imageUrl: item.images.isNotEmpty
                              ? item.images[0]
                              : '',
                          placeholder: (_, _) => Container(color: Colors.grey),
                          errorWidget: (_, _, _) =>
                              Container(color: Colors.grey.shade800),
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            // ✅ item.price is int
                            "USD ${item.price}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListView(List<ProductModel>? items) {
    if (items == null) return Center(child: Icon(Icons.list));

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => DetailScreen(item)));
          },
          child: Card(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  child: CachedNetworkImage(
                    // ✅ item.images is List<String>, use first image
                    imageUrl: item.images.isNotEmpty ? item.images[0] : '',
                    placeholder: (_, _) =>
                        Container(width: 100, height: 100, color: Colors.grey),
                    errorWidget: (_, _, _) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade800,
                    ),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        // ✅ item.price is int
                        "USD ${item.price}",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
