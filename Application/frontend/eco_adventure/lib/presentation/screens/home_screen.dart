import 'package:eco_adventure/presentation/models/user_model.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
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
  int _selectedIndex = 0;
  AuthProvider? _authProvider;

  Future<void> _onItemTapped(BuildContext context, int index) async {
    setState(() async {
      _selectedIndex = index;

      if (index == 4) {
        context.go('/profile');
      } else if (index == 5) {
        await _authProvider?.logout();
        context.replace('/');
      }
    });
  }

  void launchUrl(Uri url) {}

  @override
  Widget build(BuildContext context) {
    var user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          context.go('/profile');
                        },
                        icon: Icon(Icons.account_circle,
                            color: Color.fromARGB(255, 22, 160, 133),
                            size: 48)),
                    const SizedBox(width: 10),
                    Text('Welcome ${user?.username ?? ''}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                  ],
                ),
              ],
            ),
          )),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Flexible(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const _SearchBar(),
              const SizedBox(height: 40),
              Scrollbar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last visited places',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('You have not yet visited any places',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                        ],
                      ), // ecoadventure2023
                      const SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Popular places',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: const [
                                    _PlaceCard(
                                      imageUrl:
                                          'https://lh5.googleusercontent.com/p/AF1QipPwW3wV_SX5s4UXOhmhjWaCo-RYZ5hBxlQFu5GK=s515-k-no',
                                      title: 'Quilotoa Lagoon',
                                      description:
                                          'The Quilotoa Lagoon is a water-filled caldera and the most western volcano in the Ecuadorian Andes.',
                                    ),
                                    _PlaceCard(
                                      imageUrl:
                                          'https://images.unsplash.com/photo-1681236616704-46810f82982b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
                                      title: 'Peguche Waterfall',
                                      description:
                                          'Pools for purification rituals during religious festivals, wooded trails and camping area.',
                                    ),
                                    _PlaceCard(
                                      imageUrl:
                                          'https://lh5.googleusercontent.com/p/AF1QipPbN-qxAmz9GRiFaUXBm8JxnCOSvKQD9chMdXNq=w426-h240-k-no',
                                      title: 'Secret Garden Cotopaxi',
                                      description:
                                          'Rated In The Tripadvisor Top 1% Worldwide Relax, Waterfalls, Horseriding, Hiking and Climbing everything with the great View of the Highest Activo Volcano in Ecuador',
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(height: 40),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Near places',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: FlutterMap(
                                options: MapOptions(
                                  center: const LatLng(-0.4200757, -78.4041347),
                                  zoom: 9.2,
                                ),
                                nonRotatedChildren: [
                                  RichAttributionWidget(
                                    attributions: [
                                      TextSourceAttribution(
                                        'OpenStreetMap contributors',
                                        onTap: () => launchUrl(Uri.parse(
                                            'https://openstreetmap.org/copyright')),
                                      ),
                                    ],
                                  ),
                                ],
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.4200757, -78.4041347),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.4293022, -78.4330596),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.4138746, -78.4015169),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.4200757, -78.4041347),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.3772177, -78.1443787),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.4262339, -78.3673563),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.5070837, -78.6070814),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.5546319, -78.5164442),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      Marker(
                                        width: 80,
                                        height: 80,
                                        point: const LatLng(
                                            -0.5043372, -78.4898366),
                                        builder: (ctx) => const Icon(
                                          Icons.place,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Last reviews',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                      height: 400,
                                      child: ListView(
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                            tileColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.black12,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            leading: const Icon(Icons.person),
                                            title: const Text(
                                              'GPAguirre3',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10),
                                                  Text(
                                                      'A beautiful place to visit, I recommend it.'),
                                                  SizedBox(height: 10),
                                                  Row(children: [
                                                    Text(
                                                      'Visited place:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(Icons.place,
                                                        color: Colors.red,
                                                        size: 20),
                                                    SizedBox(width: 2),
                                                    Text('Quilotoa Lagoon'),
                                                  ]),
                                                  SizedBox(height: 1),
                                                  Row(children: [
                                                    Text(
                                                      'Score:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                  ])
                                                ]),
                                          ),
                                          const SizedBox(height: 10),
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                            tileColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.black12,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            leading: const Icon(Icons.person),
                                            title: const Text(
                                              'White',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10),
                                                  Text(
                                                      'I was amazed by the beauty of this place, I will definitely return.'),
                                                  SizedBox(height: 10),
                                                  Row(children: [
                                                    Text(
                                                      'Visited place:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(Icons.place,
                                                        color: Colors.red,
                                                        size: 20),
                                                    SizedBox(width: 2),
                                                    Text('Peguche Waterfall'),
                                                  ]),
                                                  SizedBox(height: 1),
                                                  Row(children: [
                                                    Text(
                                                      'Score:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                    Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20),
                                                    Icon(Icons.star,
                                                        color: Colors.grey,
                                                        size: 20),
                                                  ])
                                                ]),
                                          ),
                                        ],
                                      ))
                                ])
                          ])
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 219, 226, 228),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 22, 160, 133),
        unselectedItemColor: const Color.fromARGB(255, 48, 54, 63),
        onTap: (index) => _onItemTapped(context, index),
        selectedLabelStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
          height: 50,
          child: SearchBar(
            hintText: 'Search for places, activities, etc.',
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.focused))
                return const Color.fromARGB(255, 230, 236, 238);
              else
                return const Color.fromARGB(255, 219, 226, 228);
            }),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
            leading: const Icon(Icons.search),
          )),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const _PlaceCard(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
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
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: SizedBox(
                    width: 180,
                    height: 30,
                    child: Text(description,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54))),
              ),
            ],
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 1,
      margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
    );
  }
}
