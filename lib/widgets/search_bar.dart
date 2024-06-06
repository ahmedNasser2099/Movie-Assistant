import 'package:flutter/material.dart';

class searchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const searchBar({super.key, required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}
