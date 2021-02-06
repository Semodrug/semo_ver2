import 'package:flutter/material.dart';
import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/mypage/my_page.dart';
import 'package:semo_ver2/theme/colors.dart';

class IYMYAppBar extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;

  final String title;

  IYMYAppBar(
    this.title, {
    Key key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == 'home') {
      return AppBar(
        elevation: 3,
        title: SizedBox(
            height: 56,
            width: 70,
            child: Image(image: AssetImage('assets/icons/iymy.png'))),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.person,
                color: primary300_main,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              ),
            ),
          ),
          //for test home
        ],
      );
    } else //category bar
      return AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.5,
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
      );
  }
}

