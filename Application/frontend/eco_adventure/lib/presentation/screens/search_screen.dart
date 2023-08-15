import 'dart:developer';
import 'dart:math';

import 'package:eco_adventure/presentation/models/destination_model.dart';
import 'package:eco_adventure/presentation/models/location_model.dart';
import 'package:eco_adventure/presentation/providers/destination_provider.dart';
import 'package:eco_adventure/presentation/widgets/default.layout.dart';
import 'package:eco_adventure/presentation/widgets/searchbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  String? searchValue;
  SearchScreen({Key? key, this.searchValue}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.searchValue != null && widget.searchValue!.trim().isNotEmpty) {
      Provider.of<DestinationProvider>(context, listen: false).searchDestinations(widget.searchValue!).then((_) {
        widget.searchValue = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var searchResults = Provider.of<DestinationProvider>(context).foundDestinations;

    if (widget.searchValue != null && widget.searchValue!.trim().isNotEmpty) {
      Provider.of<DestinationProvider>(context, listen: false).searchDestinations(widget.searchValue!).then((_) {
        widget.searchValue = null;
      });
    }

    /*
    searchResults = List.generate(
        5,
        (index) => Destination(
            id: 3,
            name: 'Cotopaxi Volcano',
            description:
                'Cotopaxi is an active stratovolcano in the Andes Mountains, located in the Latacunga canton of Cotopaxi Province, about 50 km (31 mi) south of Quito, and 33 km (21 mi) northeast of the city of Latacunga, Ecuador, in South America. It is the second-highest summit in Ecuador, reaching a height of 5,897 m (19,347 ft).',
            latitude: -0.683333,
            longitude: -78.433333,
            altitude: 5897,
            city: City(id: 36, name: 'Latacunga'),
            image:
                'https://images.squarespace-cdn.com/content/v1/5eee94533a3cfc6d99c242d9/1592862982817-LEXYRN6WPKTHOGE1MB4W/Chimborazo+al+Amanecer.jpg'));
*/
    return DefaultLayout(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black38,
              ),
              onPressed: () {
                context.go('/home');
              },
            ),
            title: const Padding(
              padding: EdgeInsets.only(top: 24.0, bottom: 18.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Text('Search',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      )),
                ],
              ),
            )),
        child: Stack(
          children: [
            Column(children: [
              Flexible(
                  child: RefreshIndicator(
                      onRefresh: () async {},
                      child: CustomScrollView(slivers: [
                        SliverAppBar(
                          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                          toolbarHeight: 85,
                          elevation: 0,
                          floating: true,
                          pinned: true,
                          snap: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 18.0),
                              child: CustomSearchBar(
                                onSearch: (searchValue) {
                                  Provider.of<DestinationProvider>(context, listen: false)
                                      .searchDestinations(searchValue);
                                },
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final destination = searchResults[index];

                              return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                                  child: _SearchResultCard(
                                    imageUrl: destination.image!,
                                    title: destination.name ?? '',
                                    description: destination.description ?? '',
                                    score: destination.score,
                                    onTap: () {
                                      context.go('/destination/${destination.id}');
                                    },
                                  ));
                            },
                            childCount: searchResults.length,
                          ),
                        ),
                      ])))
            ]),
          ],
        ));
  }
}

class _SearchResultCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Function()? onTap;
  final double? score;

  const _SearchResultCard(
      {Key? key, required this.imageUrl, required this.title, required this.description, this.onTap, this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int grayStars = 5;
    int goldStars = 0;
    int fixedScore = 0;

    if (score != null) {
      fixedScore = max(min(score!.toInt(), 5), 0);
      grayStars = 5 - fixedScore;
      goldStars = fixedScore;
    }

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 0,
      margin: const EdgeInsets.only(right: 10.0, bottom: 5.0, left: 10.0),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: SizedBox(
                      width: 180,
                      child: Text(
                          description,
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                  ),
                  // adjust to bottom
                  // show rating
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ...List.generate(
                                      goldStars, (index) => Icon(Icons.star, color: Colors.yellow[600], size: 16.0)),
                                  ...List.generate(
                                      grayStars, (index) => Icon(Icons.star, color: Colors.grey[400], size: 16.0))
                                ],
                              ))))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
