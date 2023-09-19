import 'package:flutter/material.dart';

void main() {
  runApp(const DropdownBuild());
}

class DropdownBuild extends StatefulWidget {
  const DropdownBuild({super.key});

  @override
  State<DropdownBuild> createState() => _DropdownBuildState();
}

class _DropdownBuildState extends State<DropdownBuild> {
  @override
  Widget build(BuildContext context) {
    String? selectedOption;
    List<String> status = ["ជោគជ័យ", "កំពុងដំណើរការ", "បោះបង់"];

    final TextEditingController selectedValueController =
        TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ស្ថានភាព",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Container(
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            dropdownColor: Colors.white,
            value: selectedOption,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption = newValue!;
              });
            },
            items: status.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
