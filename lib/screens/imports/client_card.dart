import 'package:flutter/material.dart';
import 'package:khata/imports/constants.dart';
import 'package:khata/models/clients.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  ClientCard({this.client});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor,
                child: Text(getInitialsOfName(client.name), style: TextStyle(fontSize: 22, color: Colors.white)),
                radius: 25,
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(client.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),),
                  Text(client.phone, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('Rs. ${client.netCredit}', 
                style: TextStyle(
                  color: client.netCredit >= 0 ? Colors.green : Colors.red,
                  fontSize: 15,
                )
              ),
              Text('${client.netGas.abs()}', 
                style: TextStyle(
                  color: client.netGas >= 0 ? Colors.green : Colors.red,
                  fontSize: 15,
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}