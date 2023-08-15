import 'package:eco_adventure/presentation/models/destination_model.dart';
import 'package:eco_adventure/presentation/models/review_model.dart';
import 'package:eco_adventure/presentation/models/travel_model.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:eco_adventure/presentation/providers/destination_provider.dart';
import 'package:eco_adventure/presentation/providers/review_provider.dart';
import 'package:eco_adventure/presentation/services/travel_service.dart';
import 'package:eco_adventure/presentation/widgets/default.layout.dart';
import 'package:eco_adventure/presentation/widgets/searchbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  final ScrollController _scrollController2 = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  final PopupController _popupLayerController = PopupController();

  void launchUrl(Uri url) {}

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // update
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void update() {}

  @override
  Widget build(BuildContext context) {
    var user = context.watch<AuthProvider>().user;

    return DefaultLayout(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  context.go('/profile');
                },
                icon: const Icon(Icons.account_circle, color: Color.fromARGB(255, 22, 160, 133), size: 38)),
            title: Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 22.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Text('Welcome ${user?.username ?? ''}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      )),
                ],
              ),
            )),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Flexible(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                CustomSearchBar(onSearch: (term) {
                  context.go(Uri(path: '/search', queryParameters: {'searchValue': term}).toString());
                }),
                const SizedBox(height: 40),
                SingleChildScrollView(
                  primary: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Last visited places',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            FutureBuilder(
                              future: Provider.of<TravelService>(context).getCompletedTravels(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: SizedBox(height: 40, child: CircularProgressIndicator()));
                                } else if (snapshot.hasData) {
                                  final travels = snapshot.data as List<Travel>;
                                  final destinations = travels.map((e) => e.destination!).toList();

                                  return SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Scrollbar(
                                        controller: _scrollController2,
                                        thumbVisibility: true,
                                        child: ListView.builder(
                                          controller: _scrollController2,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: destinations.length,
                                          itemBuilder: (context, index) {
                                            final destination = destinations[index];

                                            return _PlaceCard(
                                                imageUrl: destination.image!,
                                                title: destination.name ?? '',
                                                description: destination.description ?? '',
                                                onTap: () {
                                                  context.go('/destination/${destinations[index].id}');
                                                });
                                          },
                                        ),
                                      ));
                                } else {
                                  return const Text('You have not yet visited any places',
                                      style: TextStyle(fontSize: 14, color: Colors.black54));
                                }
                              },
                            ),
                          ],
                        ), // ecoadventure2023
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Popular places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            FutureBuilder(
                              future: Provider.of<DestinationProvider>(context, listen: false)
                                  .getPopularDestinations(notify: false),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final destinations = snapshot.data as List<Destination>;

                                  return SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Scrollbar(
                                        controller: _scrollController,
                                        thumbVisibility: true,
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: destinations.length,
                                          itemBuilder: (context, index) {
                                            return _PlaceCard(
                                                imageUrl: destinations[index].image!,
                                                title: destinations[index].name ?? '',
                                                description: destinations[index].description ?? '',
                                                onTap: () {
                                                  context.go('/destination/${destinations[index].id}');
                                                });
                                          },
                                        ),
                                      ));
                                } else {
                                  return const SizedBox(height: 200, width: double.infinity);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Near places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 230,
                            child: FlutterMap(
                              options: MapOptions(
                                center: const LatLng(-0.4200757, -78.4041347),
                                zoom: 9.2,
                                onTap: (_, __) => _popupLayerController.hideAllPopups(),
                              ),
                              nonRotatedChildren: [
                                RichAttributionWidget(
                                  attributions: [
                                    TextSourceAttribution(
                                      'OpenStreetMap contributors',
                                      onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                                    ),
                                  ],
                                ),
                              ],
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                FutureBuilder(
                                  future: Provider.of<DestinationProvider>(context, listen: false)
                                      .getDestinations(notify: false),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final destinations = snapshot.data as List<Destination>;
                                      return PopupMarkerLayer(
                                          options: PopupMarkerLayerOptions(
                                              markerTapBehavior: MarkerTapBehavior.togglePopup(),
                                              popupController: _popupLayerController,
                                              popupDisplayOptions: PopupDisplayOptions(
                                                builder: (_, Marker marker) {
                                                  if (marker is _DestinationMarker) {
                                                    return _DestinationMarkerPopup(destination: marker.destination);
                                                  }

                                                  return const Card(child: Text('Not a destination'));
                                                },
                                              ),
                                              markers: destinations
                                                  .map((destination) => _DestinationMarker(destination: destination))
                                                  .toList()
                                          )
                                        );
                                    } else {
                                      return MarkerLayer();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Last reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            SizedBox(
                                height: 410,
                                child: FutureBuilder(
                                    future:
                                        Provider.of<ReviewProvider>(context, listen: false).getReviews(notify: false),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final reviews = snapshot.data as List<Review>;
                                        return ListView(
                                          children: [
                                            ...reviews.map(
                                              (review) => Column(children: [
                                                ListTile(
                                                  dense: false,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                                  tileColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(color: Colors.black12, width: 1),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  leading: const Icon(Icons.person),
                                                  title: Text(
                                                    review.user?.username ?? '',
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  subtitle:
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    const SizedBox(height: 10),
                                                    Text(review.content ?? ''),
                                                    const SizedBox(height: 10),
                                                    Row(children: [
                                                      const Text(
                                                        'Visited place:',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      const Icon(Icons.place, color: Colors.red, size: 20),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        review.destination != null ? review.destination!.name! : '',
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ]),
                                                    const SizedBox(height: 1),
                                                    Row(children: [
                                                      const Text(
                                                        'Score:',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      ...List.generate(
                                                          review.score ?? 0,
                                                          (index) =>
                                                              const Icon(Icons.star, color: Colors.yellow, size: 20)),
                                                      ...List.generate(
                                                          5 - (review.score ?? 0),
                                                          (index) =>
                                                              const Icon(Icons.star, color: Colors.grey, size: 20)),
                                                    ])
                                                  ]),
                                                ),
                                                const SizedBox(height: 10),
                                              ]),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                    }))
                          ])
                        ])
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}

class _PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Function()? onTap;

  const _PlaceCard({Key? key, required this.imageUrl, required this.title, required this.description, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 1,
      margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.fill,
              width: 210,
              height: 110,
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
                      height: 30,
                      child: Text(description, style: const TextStyle(fontSize: 14, color: Colors.black54))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _DestinationMarker extends Marker {
  _DestinationMarker({required this.destination})
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          height: 80,
          width: 80,
          point: LatLng(destination.latitude!, destination.longitude!),
          builder: (ctx) => const Icon(
            Icons.place,
            color: Colors.red,
            size: 30,
          ),
        );

  final Destination destination;
}

class _DestinationMarkerPopup extends StatelessWidget {
  const _DestinationMarkerPopup({Key? key, required this.destination})
      : super(key: key);
  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(destination.image!, width: 200),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(destination.name!, style: const TextStyle(fontWeight: FontWeight.bold),)
            ),
          ],
        ),
      ),
    );
  }
}