import 'package:flutter/material.dart';
import 'package:todo_app_list/src/config/color_constants.dart';

class SearchWidgetBuild extends StatelessWidget {
  final Function(String) onSearchQueryChanged;

  SearchWidgetBuild(this.onSearchQueryChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: onSearchQueryChanged,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "ស្វែងរក....",
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
