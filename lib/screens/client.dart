import 'package:flutter/material.dart';

import 'package:khata/imports/constants.dart';
import 'package:khata/imports/loading.dart';
import 'package:khata/models/clients.dart';
import 'package:khata/models/transaction.dart';
import 'package:khata/utils/backend.dart';

class ClientScreen extends StatefulWidget {

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final _formAddTransaction =  GlobalKey<FormState>();

  int gasGiven;
  int cylinderTaken;
  double moneyGot;
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Map<String, dynamic> clientmap = ModalRoute.of(context).settings.arguments ?? {};
    Client client = clientmap['client'];

    Future<Widget> _addTransactionPopUp(){
      return showDialog(
        context: context,
        builder: (BuildContext context){
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: AlertDialog(
              title: Text('Add Transaction'),
              content: Container(
                height: 300,
                child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                   child: Form(
                    key: _formAddTransaction,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Gas given: '),
                            SizedBox(width: 10,),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: inputDecoration,
                                validator: (val) {
                                  final isDigitsOnly = int.tryParse(val);
                                  if(isDigitsOnly != null){
                                    return null;
                                  }else{
                                    return 'Enter Gas Given';
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    gasGiven = int.parse(val);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text('Cylinder taken:'),
                            SizedBox(width: 10,),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: inputDecoration,
                                validator: (val) {
                                  final isDigitsOnly = int.tryParse(val);
                                  if(isDigitsOnly != null){
                                    return null;
                                  }else{
                                    return 'Enter Cylinder Taken';
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    cylinderTaken = int.parse(val);                                    
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text('Money got:'),
                            SizedBox(width: 10,),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: inputDecoration,
                                validator: (val) {
                                  final isDigitsOnly = int.tryParse(val);
                                  if(isDigitsOnly != null){
                                    return null;
                                  }else{
                                    return 'Enter Money Got';
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    moneyGot = double.parse(val);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    if(_formAddTransaction.currentState.validate()){
                      TransactionService transactionService = TransactionService();
                      transactionService.addTransaction(client.id, gasGiven, cylinderTaken, moneyGot, client.gasCost); 
                      Navigator.of(context).pop();
                    }
                  },
                  textColor: Colors.white,
                  color: primaryColor,
                  child: const Text('Add transaction'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.red,
                  child: const Text('Discard'),
                ),
              ],
            ),
          );
        }
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${client.name}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.edit),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _addTransactionPopUp();
          },
          backgroundColor: Color.fromRGBO(33, 196, 255, .7),
          child: Icon(Icons.note_add)
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                height: size.height*.15,
                color: primaryColor,
              ),
              clipper: CustomClipPath(),
            ),
            mainContent(size, context, client),
          ],
        ),
      ),
    );
  }
}
class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 40;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 30 : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
Widget mainContent(Size size, BuildContext context, Client client){
  return Container(
    width: size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: card(size, client),
        ),
        SizedBox(height: 15,),
        Expanded(
          child: transactions(context, client),
        ),
      ],
    ),
  );
}

Widget card(Size size, Client client){
  return Card(
    elevation: 4,
    child: Container(
      width: size.width * .85,
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Money',
                style: TextStyle(fontSize: 20)
              ),
              Text('${client.netCredit}',
                style: TextStyle(fontSize: 20, color: Colors.green)
              )
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Cylinder',
                style: TextStyle(fontSize: 20)
              ),
              Text('${client.netGas}',
                style: TextStyle(fontSize: 20, color: Colors.green)
              )
            ],
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(Icons.report, size: 30, color: primaryColor),
                  Text('report')
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.mail_outline, size: 30, color: primaryColor,),
                  Text('sms')
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.call, size: 30, color: primaryColor),
                  Text('call')
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.date_range, size: 30, color: primaryColor),
                  Text('remainder')
                ],
              ),
            ],
          )
        ],
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
  );
}

Widget transactions(BuildContext context, Client client){
  TransactionService transactionService = TransactionService();
  return Padding(
    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Table(
            border: TableBorder(verticalInside: BorderSide(width: 1, color: primaryColor)),
            defaultColumnWidth: FixedColumnWidth(100),
            children: [TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Date', textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Gas', textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Cylinder', textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Money needed', textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Money got', textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Net Gas', textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Net Money', textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('edit', textAlign: TextAlign.center,),
                ),
              ]
            )],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FutureBuilder(
                future: transactionService.getAllTransaction(client.id),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<Transactions> transactions = snapshot.data;
                    return Table(
                      border: TableBorder(verticalInside: BorderSide(width: 1, color: primaryColor)),
                      defaultColumnWidth: FixedColumnWidth(100),
                      children: tablerow(context, transactions),
                    );
                  }else{
                    return LoadingNotFullScreen();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

List<TableRow> tablerow(BuildContext context, List<Transactions> transactions){
  Future<Widget> _editPopUp(Transactions transaction){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: AlertDialog(
            title: Text('Edit Transaction'),
            content: Container(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  child: Column(
                    children: [
                      Text('${transaction.date}'),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Text('Gas given: '),
                          SizedBox(width: 10,),
                          Expanded(
                            child: TextFormField(
                              initialValue: '${transaction.gasGiven}',
                              keyboardType: TextInputType.number,
                              decoration: inputDecoration,
                              validator: (val) {
                                  final isDigitsOnly = int.tryParse(val);
                                  if(isDigitsOnly != null){
                                    return null;
                                  }else{
                                    return 'Enter Gas Given';
                                  }
                                },
                              onChanged: (val) {
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Text('Cylinder taken:'),
                          SizedBox(width: 10,),
                          Expanded(
                            child: TextFormField(
                              initialValue: '${transaction.cylinderGot}',
                              keyboardType: TextInputType.number,
                              decoration: inputDecoration,
                              validator: (val) {
                                  final isDigitsOnly = int.tryParse(val);
                                  if(isDigitsOnly != null){
                                    return null;
                                  }else{
                                    return 'Enter Cylinder Taken';
                                  }
                                },
                              onChanged: (val) {
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Text('Money got:'),
                          SizedBox(width: 10,),
                          Expanded(
                            child: TextFormField(
                              initialValue: '${transaction.moneyGot}',
                              keyboardType: TextInputType.number,
                              decoration: inputDecoration,
                              validator: (val) {
                                  final isDigitsOnly = int.tryParse(val);
                                  if(isDigitsOnly != null){
                                    return null;
                                  }else{
                                    return 'Enter Money Got';
                                  }
                                },
                              onChanged: (val) {
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
                color: primaryColor,
                child: const Text('Set Changes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.red,
                child: const Text('Discard Changes'),
              ),
            ],
          ),
        );
      }
    );
  }
  return transactions.asMap().keys.toList().map((index) {
    Transactions transaction = transactions[index];
    double netMoney = transaction.moneyNeeded - transaction.moneyGot;
    int netGas = transaction.gasGiven - transaction.cylinderGot;
    return TableRow(
    decoration: BoxDecoration(color: index % 2 == 1  ? Colors.grey[200] : Colors.white),
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text('${transaction.date}', textAlign: TextAlign.center,),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text('${transaction.gasGiven}', textAlign: TextAlign.center,),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text('${transaction.cylinderGot}', textAlign: TextAlign.center,),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text('${transaction.moneyNeeded}', textAlign: TextAlign.center,),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text('${transaction.moneyGot}', textAlign: TextAlign.center,),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text('${netGas.abs()}', textAlign: TextAlign.center, style: TextStyle(color: netGas >= 0 ? Colors.green : Colors.red)),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text('$netMoney', textAlign: TextAlign.center, style: TextStyle(color: netMoney >= 0 ? Colors.green : Colors.red),),
      ),
      IconButton(
        onPressed: (){
          _editPopUp(transaction);
        },
        icon: Icon(Icons.edit),
      ),
    ]
  );
  }).toList();
}