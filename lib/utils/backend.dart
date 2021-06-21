import 'package:khata/imports/constants.dart';
import 'package:khata/models/clients.dart';
import 'package:khata/models/transaction.dart';
import 'package:khata/utils/clientsdb.dart';

class ClientService{
  Future addClient(String name, String phone, int gasCost) async{
    String id;
    List<String> listOfId = await DBclient.instance.getAllId();
    do{
      id = tokenize();
      print(id);
    }while(listOfId.contains(id));
    Client client = Client(
      id: id,
      name: name,
      phone: phone,
      gasCost: gasCost,
    );
    int i = await DBclient.instance.insertNewClient(client);
    print(i);
    await DBclient.instance.createClientDB(id);
  }
  
  Future<List<Client>> getAllClients(){
    return DBclient.instance.getAllClients();
  }
}

class TransactionService{
  Future addTransaction(String clientId, int gasGiven, int cylinderGot, double moneyGot, int gasCost) async{
    Transactions transaction = Transactions(
      clientId: clientId, 
      gasGiven: gasGiven,
      cylinderGot: cylinderGot,
      moneyNeeded: (gasGiven*gasCost).toDouble(),
      moneyGot: moneyGot,
    );
    int i = await DBclient.instance.insertClientTransaction(transaction);
    print(i);
  }

  Future<List<Transactions>> getAllTransaction(String clientId){
    return DBclient.instance.getAllTransaction(clientId);
  }
}