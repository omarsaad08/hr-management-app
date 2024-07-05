// presentation/components/hoveringbutton.dart
import 'package:flutter/material.dart';
import 'theme.dart';

class HoverButton extends StatefulWidget {
  final String name;
  final String routeName;

  HoverButton( BuildContext context, {required this.name, required this.routeName});

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _onHover(true),
      onExit: (event) => _onHover(false),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(widget.routeName);
        },
        child: AnimatedContainer(
          width: 750,
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 22.0),
          margin: EdgeInsets.all(8.0),
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: _isHovered ? clr(2) : clr(1),
            borderRadius: BorderRadius.circular(60.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(131, 0, 0, 0),
                blurRadius: 25.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.name,
            style: TextStyle(
              color: _isHovered ? Colors.black : Colors.white,
              fontSize: 25.0,
            ),
          ),
        ),
      ),
    );
  }
}
