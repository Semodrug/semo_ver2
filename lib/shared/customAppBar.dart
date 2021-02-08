import 'package:flutter/material.dart';
import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/theme/colors.dart';

class CustomAppBarWithGoToBack extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;

  final String title;
  final Icon customIcon;
  final double elevation;

  CustomAppBarWithGoToBack( this.title, this.customIcon, this.elevation,
      {
        Key key,
      })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
        style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),),
      elevation: elevation,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(icon: customIcon, color: primary300_main,
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}


class CustomAppBarWithArrowBackAndSearch extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;
  final String title;
  final double elevation;

  CustomAppBarWithArrowBackAndSearch( this.title, this.elevation,
      {
        Key key,
      })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      AppBar(
      title: Text(title, style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),),
      elevation: elevation,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.search,
              color: primary300_main,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            ),
          ),
        ),
        //for test home
      ],
      leading: IconButton(icon: Icon(Icons.arrow_back), color: primary300_main,
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}

class CustomAppBarBarcode extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;

  CustomAppBarBarcode(
      {
        Key key,
      })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('바코드 인식', style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),),
      elevation: 3,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            icon: ImageIcon(
              AssetImage('assets/icons/home_icon.png'),color: primary300_main,
              // color: gray100,
            ),
            onPressed: () => Navigator.pushNamed(context, '/bottom_bar')
          ),
        ),
        //for test home
      ],
      leading: IconButton(icon: Icon(Icons.arrow_back), color: primary300_main,
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}
