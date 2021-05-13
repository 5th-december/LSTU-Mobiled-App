import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';

class PrivateChatAppBar extends StatelessWidget implements PreferredSizeWidget
{
  final Person companion;
  
  PrivateChatAppBar({Key key, this.companion}): super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(20.0);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                SizedBox(width: 2,),
                PersonProfilePicture(
                  displayed: this.companion,
                  size: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${companion.name} ${companion.surname}")
                    ],
                  ),
                ),
                Icon(Icons.settings,color: Colors.black54,),
              ],
            ),
          ),
        ),
      );
  }
}