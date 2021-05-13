import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';

class PrivateChatAppBar extends StatelessWidget with PreferredSizeWidget
{
  final Person companion;
  
  PrivateChatAppBar({Key key, this.companion}): super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
  
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
                  icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.black,),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PersonProfilePicture(
                        displayed: this.companion,
                        size: this.preferredSize.height * 0.65,
                      ),
                      SizedBox(width: 12,),
                      Text(
                        "${companion.name} ${companion.surname}", 
                        style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w600, fontSize: 18.0),
                      )
                    ]
                  )
                ),
              ],
            ),
          ),
        ),
      );
  }
}