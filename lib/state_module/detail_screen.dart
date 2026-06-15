import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'product_model.dart';
import 'counter_logic.dart';

class DetailScreen extends StatefulWidget {
  final ProductModel item;

  const DetailScreen(this.item, {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        actions: [
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
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1000),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final item = widget.item;
    final int cnt = context.watch<CounterLogic>().counter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Carousel Slideshow
        _buildSlideshow(item.images),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Category Chip
              Chip(
                avatar: CachedNetworkImage(
                  imageUrl: item.category.image,
                  errorWidget: (_, __, ___) => Icon(Icons.category),
                ),
                label: Text(item.category.name),
              ),

              SizedBox(height: 8),

              // ✅ Title Card
              Card(
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.cartShopping),
                  title: Text(
                    item.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 8),

              // ✅ Price Card
              Card(
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.dollarSign),
                  title: Text(
                    "USD ${item.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8),

              // ✅ Category Card
              Card(
                child: ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text("In ${item.category.name} Category"),
                ),
              ),

              SizedBox(height: 8),

              // ✅ Description with dynamic font size from counter
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    item.description,
                    style: TextStyle(fontSize: 14 + cnt.toDouble()),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // ✅ Extra thumbnail images if more than 1
              if (item.images.length > 1)
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.images.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: item.images[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ Carousel Slideshow
  Widget _buildSlideshow(List<String> images) {
    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        aspectRatio: 4 / 3,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
      itemBuilder: (context, index, viewIndex) {
        final image = images[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(8),
            child: CachedNetworkImage(
              imageUrl: image,
              placeholder: (ctx, url) => Container(color: Colors.grey),
              errorWidget: (ctx, url, err) => Container(
                color: Colors.grey.shade800,
                child: Icon(Icons.broken_image, size: 60),
              ),
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
