import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedLeadingTextImage extends StatelessWidget {
  final String phrase;

  RoundedLeadingTextImage({Key key, @required this.phrase}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String getTextLabel() {
      final List<String> words = this.phrase.split(' ');
      if (words.length >= 2) {
        return words[0].substring(0, 1) + words[1].substring(0, 1);
      } else if (words.length == 1) {
        if (words[0].length >= 2) {
          return words[0].substring(0, 2);
        } else if (words[0].length == 1) {
          return words[0];
        }
      }
      return '';
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Color.fromRGBO(165, 153, 255, 1.0)),
      child: Center(
        child: Text(getTextLabel().toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 30.0)),
      ),
    );
  }
}
