import 'package:flutter/material.dart';
import 'package:khata/imports/loading.dart';
import 'package:khata/models/clients.dart';
import 'package:khata/screens/imports/client_card.dart';
import 'package:khata/screens/imports/drawer.dart';
import 'package:khata/imports/constants.dart';
import 'package:khata/utils/backend.dart';

class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formAddClient =  GlobalKey<FormState>();

  String name;
  String phone;
  int gasCost;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    Future<Widget> _addClientPopUp(){
      return showDialog(
        context: context,
        builder: (BuildContext context){
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: AlertDialog(
              title: Text('Add Client'),
              content: Container(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formAddClient,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Name'),
                            SizedBox(width: 10,),
                            Expanded(
                              child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                decoration: inputDecoration,
                                validator: (val) => val.isEmpty ? 'Enter Name' : null,
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text('Phone no:'),
                            SizedBox(width: 10,),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: inputDecoration,
                                validator: (val) {
                                  final isDigitsOnly = int.tryParse(val);
                                  if(isDigitsOnly != null && val.length == 10){
                                    return null;
                                  }else{
                                    return 'Please enter Valid Phone no';
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    phone = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text('Gas Cost'),
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
                                    return 'Enter Gas Cost';
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    gasCost = int.parse(val);
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
                  onPressed: () async{
                    if(_formAddClient.currentState.validate()){
                      ClientService clientService = ClientService();
                      await clientService.addClient(name, phone, gasCost);
                      Navigator.of(context).pop();
                    }
                  },
                  textColor: Colors.white,
                  color: primaryColor,
                  child: const Text('Add client'),
                ),
                FlatButton(
                  onPressed: () async{
                    Navigator.of(context).pop();
                    ClientService clientService = ClientService();
                    List<Client> client = await clientService.getAllClients();
                    print(client[0].name); 
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
            'HAMRO PASAL',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        drawer: DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addClientPopUp(),
          backgroundColor: Color.fromRGBO(33, 196, 255, .7),
          child: Icon(Icons.person_add),
          
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
            homeContent(size, context),
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
Widget homeContent(Size size, BuildContext context){
  return Container(
    width: size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 40),
          child: card(size, context),
        ),
        SizedBox(height: 15,),
        Expanded(
          child: listOfClients(),
        ),
      ],
    ),
  );
}

Widget card(Size size, BuildContext context){
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
              Text('Rs. 4000',
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
              Text('40',
                style: TextStyle(fontSize: 20, color: Colors.green)
              )
            ],
          ),
          SizedBox(height: 15,),
          FlatButton.icon(
            onPressed: (){
              
            },
            label: Text('View Report',
              style:TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w600)
            ),
            icon: Icon(Icons.account_balance_wallet, color: primaryColor, size: 30,),
          )
        ],
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
  );
}

Widget listOfClients(){
  ClientService clientService = ClientService();
  return FutureBuilder(
    future: clientService.getAllClients(),
    builder: (context, snapshot){
      if (snapshot.hasData){
        List<Client> clients =snapshot.data;
        return Padding(
          padding: const EdgeInsets.only(left: 15, right:15),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${clients.length} Clients', 
                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: primaryColor, size: 25,),
                    onPressed: (){}
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: clients.length,
                  itemBuilder: (BuildContext context, int index){
                    Client client = clients[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/client', arguments: {
                          'client': client
                        }
                        );
                      },
                      child: ClientCard(client: client,)
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }else{
        return LoadingNotFullScreen();
      }
    },
  );
}