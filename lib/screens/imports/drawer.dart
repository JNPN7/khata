import 'package:flutter/material.dart';
import 'package:khata/imports/constants.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: <Widget>[
          profile(),
          menu()
        ]
      )
    );
  }
}
Widget profile(){
  return Container(
    color: primaryColor,
    padding: EdgeInsets.fromLTRB(20, 35, 10, 35),
    child: Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40,
          child: Icon(Icons.bug_report, color: primaryColor, size: 70,),
        ),
        SizedBox(width: 15,),
        Text('Jake Paralta', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
      ],
    ),
  );
}
Widget menu(){
  return Padding(
    padding: const EdgeInsets.only(left: 20, top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton.icon(
          onPressed: (){}, 
          icon: Icon(Icons.account_balance_wallet, color: primaryColor,),
          label: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text('View Report'),
          )
        ),
        FlatButton.icon(
          onPressed: (){}, 
          icon: Icon(Icons.group, color: primaryColor,),
          label: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text('All Clients'),
          )
        ),
        FlatButton.icon(
          onPressed: (){}, 
          icon: Icon(Icons.date_range, color: primaryColor,),
          label: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text('All remainders'),
          )
        ),
        FlatButton.icon(
          onPressed: (){}, 
          icon: Icon(Icons.computer, color: primaryColor,),
          label: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text('About Developer'),
          )
        ),
      ],
    ),
  );
}