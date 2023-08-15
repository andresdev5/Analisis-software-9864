import 'dart:developer';

import 'package:eco_adventure/presentation/models/destination_model.dart';
import 'package:eco_adventure/presentation/models/review_model.dart';
import 'package:eco_adventure/presentation/models/travel_model.dart';
import 'package:eco_adventure/presentation/services/destination_service.dart';
import 'package:eco_adventure/presentation/services/travel_service.dart';
import 'package:eco_adventure/presentation/widgets/default.layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlaceScreen extends StatefulWidget {
  String? destinationId;

  PlaceScreen({Key? key, this.destinationId}) : super(key: key);

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  final ScrollController _reviewsScrollController = ScrollController();

  void _doTravel() {
    Provider.of<TravelService>(context, listen: false).createTravel(int.parse(widget.destinationId!)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Travel created!')));
      setState(() {});
    }).catchError((e,s) {
      log(e.toString());
      log(s.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occured')));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.destinationId == null) {
      return const DefaultLayout(child: Center(child: CircularProgressIndicator()));
    }

    return DefaultLayout(
        child: FutureBuilder(
            future: Provider.of<DestinationService>(context).getDestination(int.parse(widget.destinationId!)),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Destination destination = snapshot.data as Destination;
                return SafeArea(
                    child: Column(children: [
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
                        future: Provider.of<TravelService>(context).getActiveUserTravelByDestination(int.parse(widget.destinationId!)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            Travel? travel = snapshot.data as Travel?;

                            return travel == null ? FutureBuilder(
                              future: Provider.of<TravelService>(context).userIsTravelling(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  bool canTravel = !(snapshot.data as bool);

                                  return canTravel ? ElevatedButton(
                                    onPressed: canTravel ? _doTravel : null,
                                    child: const Text('Travel here', style: TextStyle(color: Colors.white)),
                                  ) : Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(150, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(4.0)
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('You are already traveling to another place', style: TextStyle(color: Colors.white))
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }
                            ) : // badge showing "you are travelling here";
                            const ElevatedButton(
                              onPressed: null,
                              child: Text('You are travelling here', style: TextStyle(color: Colors.white)),
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
                  ]),
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
                                  const Text('About', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Text(
                                    destination.description!,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.grey),
                                      const SizedBox(width: 5),
                                      Text(
                                        destination.city?.name ?? 'Unknown',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  // reviews
                                  const SizedBox(height: 20),
                                  const Text('Last reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  FutureBuilder(
                                    future: Provider.of<DestinationService>(context).getDestinationReviews(int.parse(widget.destinationId!)),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Review> reviews = snapshot.data as List<Review>;
                                        
                                        if (reviews.isEmpty) {
                                          return const Text('No reviews yet');
                                        }

                                        return Scrollbar(
                                          controller: _reviewsScrollController,
                                          thumbVisibility: true,
                                          child: SizedBox(
                                            height: 200,
                                            child: ListView.builder(
                                              controller: _reviewsScrollController,
                                              scrollDirection: Axis.vertical,
                                              itemCount: reviews.length,
                                              itemBuilder: (context, index) {
                                                index = 0;
                                                return Card(
                                                  margin: const EdgeInsets.only(bottom: 5.0),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              reviews[index].user?.username ?? 'Anonymous',
                                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            Text(
                                                              reviews[index].createdAt != null 
                                                                ? DateFormat('dd-MMM-yyyy').format(reviews[index].createdAt!)
                                                                : 'Unknown',
                                                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          reviews[index].content!,
                                                          style: const TextStyle(fontSize: 16),
                                                        ),
                                                        const SizedBox(height: 10),
                                                      ],
                                                    )
                                                  )
                                                );
                                              },
                                            ),
                                          ),  
                                        );
                                      } else {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                    },
                                  )
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
