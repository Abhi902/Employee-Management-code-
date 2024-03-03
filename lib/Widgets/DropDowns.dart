import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDowns extends StatefulWidget {
  final List<String> options;
  final String type;
  final Function callBack;
  final bool editEnable;
  final int index;
  DropDowns(
      {required this.type,
      required this.options,
      required this.callBack,
      this.editEnable = true,
      required this.index});
  @override
  DropDownsState createState() => DropDownsState();
}

class DropDownsState extends State<DropDowns> {
  String? _desig;
  DropDownsState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.options.contains(_desig)) {
      _desig = null; // or assign a default value based on the business logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color.fromARGB(20, 255, 255, 255),
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(widget.type + ':  ',
                textAlign: TextAlign.left,
                style: GoogleFonts.josefinSans(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decorationThickness: 10))),
          ),
          IgnorePointer(
            ignoring: !(widget.editEnable),
            child: DropdownButtonFormField(
              isExpanded: true,
              iconSize: 30,
              iconEnabledColor:
                  widget.editEnable ? Colors.black : Colors.transparent,
              items: widget.options.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              value: _desig,
              validator: (value) =>
                  (value == null) ? 'This field must be filled' : null,
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (newValue) {},
              onSaved: (value) {
                // widget.valueSet(widget.index, value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
