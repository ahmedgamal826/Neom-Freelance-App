//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports

class DropDownMenu<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final String hintText;
  final ValueChanged<T?> onChanged;
  final String? labelText;
  final String? Function(T?)? validator;

  //SECTION - Widget Arguments
  //!SECTION
  //
  const DropDownMenu({
    super.key,
    this.value,
    this.items,
    required this.hintText,
    required this.onChanged,
    this.labelText,
    this.validator,
  });

  //SECTION - Stateless functions
  @override
  Widget build(BuildContext context) {
    //SECTION - Build Setup
    //t2 -Values
    //double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    //t2 -Values
    //
    //t2 -Widgets
    //t2 -Widgets
    //!SECTION

    //SECTION - Build Return
    return DropdownButtonFormField(
      validator: validator,
      value: value,
      isExpanded: true,
      hint: Text(hintText),
      items: items,
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(labelText ?? ""),
        hintText: hintText,
        // contentPadding: EdgeInsets.all(16)
      ),
    );
    //!SECTION
  }
}
