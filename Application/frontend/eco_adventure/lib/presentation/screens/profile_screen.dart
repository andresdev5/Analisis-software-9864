import 'package:eco_adventure/presentation/models/user_profile.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:eco_adventure/presentation/providers/user_provider.dart';
import 'package:eco_adventure/presentation/widgets/default.layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<AuthProvider>().user;
    //final profile = context.watch<UserProvider>().profile;
    Provider.of<UserProvider>(context, listen: false).getProfile();

    return DefaultLayout(
      child: FutureBuilder<UserProfile>(
          future: context.watch<UserProvider>().getProfile(),
          builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
            var profile = snapshot.data;

            if (snapshot.connectionState == ConnectionState.done) {
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
                            margin: const EdgeInsets.only(left: 25),
                            child: Text(
                              (profile?.firstname ?? (user?.username ?? '')),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Flexible(
                            child: ListView(
                              children: [
                                Container(
                                    // white box, border 1 px gray, rounded corners, shadow
                                    margin: const EdgeInsets.only(
                                        left: 25, right: 25, bottom: 25),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Personal Information',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 16),
                                          Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 153, 163, 177)),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                (profile?.firstname ?? ''),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Lastname',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 153, 163, 177)),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                (profile?.lastname ?? ''),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Email',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 153, 163, 177)),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                (user?.email ?? ''),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Phone',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 153, 163, 177)),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                (profile?.phone ?? '-'),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Birthday',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 153, 163, 177)),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                profile != null && profile.birthday != null
                                                  ? DateFormat('yyyy-MM-dd').format(profile.birthday!)
                                                  : '-',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Location',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 153, 163, 177)),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                (profile?.city?.name ?? '-'),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ])),
                                Container(
                                    // white box, border 1 px gray, rounded corners, shadow
                                    margin: const EdgeInsets.only(
                                        left: 25, right: 25, bottom: 25),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('About',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 16),
                                          Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                profile?.about ?? '-',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(255, 59, 68, 80)),
                                              ),
                                            ],
                                          ),
                                        ]))
                              ],
                            ),
                          )
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
                    Color.fromARGB(215, 22, 160, 133),
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
                  margin: const EdgeInsets.only(left: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: null,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color.fromARGB(255, 245, 245, 245), width: 5),
                    image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://i.imgur.com/N0zWv1L.png')),
                  ),
                ),
              ],
            ),
          ),
        ),
        // dots button with dropdown menu
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(top: 50, right: 25),
            child: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      context.goNamed('profile-edit');
                    },
                    child: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
