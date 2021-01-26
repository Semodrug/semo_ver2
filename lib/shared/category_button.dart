import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String str;

  const CategoryButton({Key key, this.str}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _shortenCategory(String data) {
      String newName = '';

      newName = data.substring(7, (data.length));
      return newName;
    }

    return ElevatedButton(
      child: Text(
        '${_shortenCategory(str)}',
        style: TextStyle(fontSize: 12),
      ),
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(Size(10, 30)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 10)),
          elevation: MaterialStateProperty.all<double>(0.0),
          // Color(0xFFF7F7F7) Color(0xFF009E8C)
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white10),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(color: Colors.grey[300])))),
      onPressed: () {},
    );
  }
}
