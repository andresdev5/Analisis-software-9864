import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String)? onSearch;
  final String? hintText;

  const CustomSearchBar({super.key, this.onSearch, this.hintText});

  @override
  State<StatefulWidget> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
          height: 50,
          child: SearchBar(
            controller: _searchController,
            hintText: widget.hintText ?? 'Search for places, activities, etc.!',
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.focused)) {
                return const Color.fromARGB(255, 230, 236, 238);
              } else {
                return const Color.fromARGB(255, 219, 226, 228);
              }
            }),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
            trailing: [
              IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                  onPressed: () {
                    final term = _searchController.text;
                    _searchController.clear();
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (widget.onSearch != null) {
                      widget.onSearch!(term);
                    }
                  })
            ],
          )),
    );
  }
}
