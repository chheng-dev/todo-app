import 'package:flutter/material.dart';
import 'package:todo_app_list/src/config/color_constants.dart';

class SearchWidgetBuild extends StatelessWidget {
  const SearchWidgetBuild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          child: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                labelText: "ស្វែងរក....",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: Icon(
                  Icons.search,
                  color: ColorConstants.primary,
                ),
                border: InputBorder.none
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(12),
                // ),
                ),
          ),
        ),
      ],
    );
  }
}
