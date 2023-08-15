import 'dart:convert';
import 'dart:developer';

import 'package:eco_adventure/config.dart';
import 'package:eco_adventure/presentation/models/destination_model.dart';
import 'package:eco_adventure/presentation/models/travel_model.dart';
import 'package:eco_adventure/presentation/services/travel_service.dart';
import 'package:eco_adventure/presentation/widgets/default.layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';


class TravelScreen extends StatefulWidget {
  String? travelId;

  TravelScreen({Key? key, this.travelId}) : super(key: key);

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  final ScrollController _reviewsScrollController = ScrollController();
  Position? _currentPosition;
  List<LatLng> _points = [];
  List _listOfPoints = [];

  // review text controller
  final TextEditingController _reviewTextController = TextEditingController();
  // slider value
  double _sliderValue = 0.0;

  // /v2/directions/driving-car

  Future<bool> _findLocation(String latitude, String longitude) async {
    await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
      _currentPosition = position;
      log('CURRENT POS: $_currentPosition');
    }).catchError((e, s) {
      log('ERROR: $e, $s');
    });

    String startPoint = '${_currentPosition!.longitude},${_currentPosition!.latitude}';
    String endPoint = '$longitude,$latitude';

    final response = await http.get(Uri.parse(
      '${Config.openRouteServiceURL}/v2/directions/driving-car?start=$startPoint&end=$endPoint'));
    
    if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _listOfPoints = data['features'][0]['geometry']['coordinates'];
        _points = _listOfPoints
            .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
            .toList();
      
      return true;
    }

    return false;
  }

  void _completeTravel() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return _ReviewBottomSheet(
          onSubmit: (score, review) async {
            final travelService = Provider.of<TravelService>(context, listen: false);
            await travelService.createReview(int.parse(widget.travelId!), score.toInt(), review);
            await travelService.completeTravel(int.parse(widget.travelId!)).then((_) {
              Navigator.pop(context);
              setState(() {});
            });
          }
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.travelId == null) {
      log('TravelScreen: travelId is null');
      return const DefaultLayout(child: Center(child: CircularProgressIndicator()));
    }
    log('travelId: ${widget.travelId}');

    return DefaultLayout(
        child: FutureBuilder(
            future: Provider.of<TravelService>(context).getTravel(int.parse(widget.travelId!)),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Travel travel = snapshot.data as Travel;
                Destination destination = travel.destination!;

                return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Stack(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 220,
                        child: Image.network(
                          destination.image!,
                          height: 220,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // travel button
                      Positioned(
                        right: 10.0,
                        top: 10.0,
                        child: FutureBuilder(
                          future: Provider.of<TravelService>(context).getActiveUserTravelByDestination(destination.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              Travel? travel = snapshot.data as Travel?;

                              return travel == null ? Container() : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, 
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                onPressed: () {
                                  _completeTravel();
                                },
                                child: Text('Finish travel', style: TextStyle(color: Colors.white)),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }
                        ),
                      ),
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child: Container(
                          height: 80,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Color.fromARGB(255, 0, 0, 0), Colors.transparent])),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination.name!,
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  // description, location, price
                  Flexible(
                    child: SingleChildScrollView(
                        primary: true,
                        child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Map', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: Colors.grey[300],
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    child: Stack(
                                      children: [
                                        FutureBuilder(
                                          future: _findLocation(
                                            travel.destination!.latitude!.toString(), 
                                            travel.destination!.longitude!.toString()),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData && snapshot.data == true) {
                                              return FlutterMap(
                                                options: MapOptions(
                                                  zoom: 12,
                                                  center: LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                                                ),
                                                children: [
                                                  // Layer that adds the map
                                                  TileLayer(
                                                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                                                  ),
                                                  // Layer that adds points the map
                                                  MarkerLayer(
                                                    markers: [
                                                      // First Marker
                                                      Marker(
                                                        point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                                        width: 80,
                                                        height: 80,
                                                        builder: (context) => IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(Icons.location_on),
                                                          color: Colors.green,
                                                          iconSize: 25,
                                                        ),
                                                      ),
                                                      // Second Marker
                                                      Marker(
                                                        point: LatLng(destination.latitude!, destination.longitude!),
                                                        width: 80,
                                                        height: 80,
                                                        builder: (context) => IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(Icons.location_on),
                                                          color: Colors.red,
                                                          iconSize: 25,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Polylines layer
                                                  PolylineLayer(
                                                    polylineCulling: false,
                                                    polylines: [
                                                      Polyline(
                                                          points: _points, color: Colors.redAccent, strokeWidth: 3),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return const Center(child: CircularProgressIndicator());
                                            }
                                          }
                                        ),
                                      ]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        )
                    ),
                    ),
                  ),
                ]));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class _ReviewBottomSheet extends StatefulWidget {
  final Function(double, String) onSubmit;

  const _ReviewBottomSheet({Key? key, required this.onSubmit}) : super(key: key);

  @override
  __ReviewBottomSheetState createState() => __ReviewBottomSheetState();
}

class __ReviewBottomSheetState extends State<_ReviewBottomSheet> {
  double _score = 0.0;
  final _reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
        height: 500,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Completar viaje', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                // textarea for review
                const SizedBox(height: 10),
                const Text('¿Cómo estuvo tu viaje?'),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 3,
                  controller: _reviewTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Escribe aquí tu reseña',
                  ),
                ),
                const SizedBox(height: 10),
                // score slider
                const Text('Califica tu viaje'),
                const SizedBox(height: 10),
                Slider(
                  value: _score,
                  min: 0.0,
                  max: 5.0,
                  divisions: 5,
                  label: '0',
                  onChanged: (double value) {
                    _score = value;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Guardar cambios'),
                  onPressed: () {
                    widget.onSubmit(_score, _reviewTextController.text);
                  }
                ),
              ],
          ),
        ),
      ),
    );
  }
}