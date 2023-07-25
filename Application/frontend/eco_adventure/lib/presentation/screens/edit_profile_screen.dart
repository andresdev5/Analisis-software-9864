import 'package:eco_adventure/presentation/models/location_model.dart';
import 'package:eco_adventure/presentation/models/user_model.dart';
import 'package:eco_adventure/presentation/models/user_profile.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:eco_adventure/presentation/providers/location_provider.dart';
import 'package:eco_adventure/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  _EditProfileForm? _editProfileFormWidget;
  final _globalKey = GlobalKey<_EditProfileFormState>();

  void _onItemTapped(BuildContext context, int index) {
    context.read<UserProvider>().getProfile();
    if (index == 0) {
      context.go('/home');
    } else if (index == 5) {
      context.read<AuthProvider>().logout();
    }
  }

  Future _saveProfile() async {
    var firstname = _globalKey.currentState?._firstname.text;
    var lastname = _globalKey.currentState?._lastname.text;
    var phone = _globalKey.currentState?._phone.text;
    var about = _globalKey.currentState?._about.text;
    var birthday = _globalKey.currentState?._birthday;
    var country = _globalKey.currentState?._country;

    User user = Provider.of<AuthProvider>(context, listen: false).user!;
    await Provider.of<UserProvider>(context, listen: false).updateProfile(user.id!, UserProfile(
      firstname: firstname,
      lastname: lastname,
      phone: phone,
      about: about,
      birthday: birthday,
      country: country,
    ));

    // show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated'),
      ),
    );

    context.go('/profile');
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<AuthProvider>().user;
    context.read<UserProvider>().getProfile();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: FutureBuilder<UserProfile>(
          future: context.read<UserProvider>().getProfile(),
          builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
            var profile = snapshot.data;
            _editProfileFormWidget = _EditProfileForm(
              key: _globalKey,
              context,
              user!,
              profile!,
            );

            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _TopPortion(onSave: _saveProfile)),
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
                          Container(
                            padding: const EdgeInsets.all(25),
                            // form edit profile
                            child: _editProfileFormWidget,
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
  Function onSave;

  _TopPortion({Key? key, required this.onSave}) : super(key: key);

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
                    border: Border.all(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        width: 5),
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
            child: IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () {
                onSave();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  User _user;
  UserProfile _profile;

  _EditProfileForm(this.context, this._user, this._profile, {Key? key})
      : super(key: key);

  final BuildContext context;

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  List _countriesList = [];

  final _formKey = GlobalKey<FormState>();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _phone = TextEditingController();
  final _about = TextEditingController();
  DateTime _birthday = DateTime.now();
  Country? _country;

  Future getAllCountries() async {
    var data = await widget.context.read<LocationProvider>().getAllCountries();
    var countries = [];

    for (var country in data) {
      countries.add(Country(code: country.code, name: country.name));
    }

    setState(() {
      _countriesList = countries;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCountries();
  }

  @override
  Widget build(BuildContext context) {
    _firstname.text = widget._profile.firstname ?? '';
    _lastname.text = widget._profile.lastname ?? '';
    _phone.text = widget._profile.phone ?? '';
    _about.text = widget._profile.about ?? '';
    _birthday = widget._profile.birthday ?? DateTime.now();

    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _firstname,
              decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastname,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // bithday date picker
            TextFormField(
              controller: TextEditingController(
                  text: DateFormat('dd-MM-yyyy').format(_birthday)),
              decoration: const InputDecoration(
                labelText: 'Birthday',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              onTap: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (date != null) {
                  _birthday = date;
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _about,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'About',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // dropdown country
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Country',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              value: _country,
              onChanged: (dynamic value) {
                setState(() => _country = value);
              },
              items: _countriesList.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country.name),
                );
              }).toList(),
            ),
          ],
        ));
  }
}
