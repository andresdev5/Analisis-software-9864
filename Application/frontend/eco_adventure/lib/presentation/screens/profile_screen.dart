import 'package:eco_adventure/presentation/models/user_model.dart';
import 'package:eco_adventure/presentation/models/user_profile.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:eco_adventure/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _onItemTapped(BuildContext context, int index) {
    context.read<UserProvider>().getProfile();
    if (index == 0) {
      context.go('/home');
    } else if (index == 5) {
      context.read<AuthProvider>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<AuthProvider>().user;
    context.read<UserProvider>().getProfile();

    return Scaffold(
      body: FutureBuilder<UserProfile>(
          future: context.read<UserProvider>().getProfile(),
          builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
            var profile = snapshot.data;

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print('PROFILE ERROR ' + snapshot.error.toString());
                return Container(child: Text('Error'));
              }

              print('PROFILE!: ${profile}');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 1, child: _TopPortion()),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 25),
                            child: Text(
                              (profile?.firstname ?? (user?.username ?? '')),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // phone with label and below value
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 25),
                                child: Text(
                                  'Nombre',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                (profile?.firstname ?? ''),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // phone with label and below value
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 25),
                                child: Text(
                                  'Apellido',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                (profile?.lastname ?? ''),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // email with label and below value
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 25),
                                child: Text(
                                  'Email',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                (user?.email ?? ''),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // phone with label and below value
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 25),
                                child: Text(
                                  'Phone',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                (profile?.phone ?? ''),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
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
        currentIndex: 4,
        selectedItemColor: const Color.fromARGB(255, 22, 160, 133),
        unselectedItemColor: const Color.fromARGB(255, 48, 54, 63),
        onTap: (index) => _onItemTapped(context, index),
        selectedLabelStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 70),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(255, 22, 160, 133),
                    Color.fromARGB(255, 22, 160, 133)
                  ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              )),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 25),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://i.imgur.com/N0zWv1L.png')),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
