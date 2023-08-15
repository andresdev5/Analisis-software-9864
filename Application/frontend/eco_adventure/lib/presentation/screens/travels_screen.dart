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
import 'package:go_router/go_router.dart';

class TravelsScreen extends StatefulWidget {
  TravelsScreen({Key? key}) : super(key: key);

  @override
  State<TravelsScreen> createState() => _TravelsScreenState();
}

class _TravelsScreenState extends State<TravelsScreen> {
  final ScrollController _reviewsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        child: FutureBuilder(
            future: Provider.of<TravelService>(context).getUserTravels(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Travel> travels = snapshot.data as List<Travel>;

                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                        child: Text('Travels', style: TextStyle(fontSize: 20)),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: travels.length,
                          itemBuilder: (context, index) {
                            Travel travel = travels[index];
                            return Stack(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      context.go('/travel/${travel.id}');
                                    },
                                  child: SizedBox(
                                    height: 100,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          travel.destination!.image!,
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(travel.destination!.name!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text('Start date: ${DateFormat('dd/MM/yyyy').format(travel.createdAt!)}'),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text('End date: ${travel.finishedAt != null ? DateFormat('dd/MM/yyyy').format(travel.finishedAt!) : '-'}'),
                                                ),
                                              ],
                                            )
                                          ]
                                        )
                                      ]
                                    ),
                                  )),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: Badge(
                                    label: Text(travel.finishedAt == null ? 'In progress' : 'Finished'),
                                    backgroundColor: travel.finishedAt == null ? Colors.green : Colors.grey,
                                  ),
                                )
                              ],
                            );
                          })
                        ),
                      )
                    ]
                                  ),
                  ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
