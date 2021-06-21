import 'dart:io';
import 'package:khata/models/transaction.dart';
import 'package:khata/models/clients.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DBclient {
  static final _dbName = 'filesdatabase.db';
  static final _dbVersion = 1;
  static final String _tableName = 'list_of_clients';

  ////////// for list of clients //////////////
  // static final String _columnSN = 'sn';
  static final String _columnId = 'id';
  static final String _columnName = 'name';
  static final String _columnPhone = 'phone';
  static final String _columnGasCost = 'gas_cost';
  static final String _columnNetCredit = 'net_credit';
  static final String _columnNetGas = 'net_gas';

  ////////// for single client //////////////
  static final String _columnDate = 'date';
  static final String _columnGasGiven = 'gas_given';
  static final String _columnCylinderGot = 'cylinder_got';
  static final String _columnMoneyNeeded = 'money_needed';
  static final String _columnMoneyGot = 'money_got';
  
  //singleton class
  DBclient._();
  static final DBclient instance = DBclient._();

  static Database _database;
  Future<Database> get database async{
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  _initDB() async{
    Directory directory= await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(
      path, 
      version: _dbVersion,
      onCreate: _onCreate
    );
  }

  ///////////////////// listOfClient //////////////////////////

  Future _onCreate(Database db, int version) async{
    // $_columnSN INTEGER PRIMARY KEY AUTOINCREMENT, 
    await db.execute('''
    CREATE TABLE $_tableName (
      $_columnId TEXT PRIMARY KEY,
      $_columnName TEXT NOT NULL,
      $_columnPhone TEXT,
      $_columnGasCost INT NOT NULL,
      $_columnNetCredit DOUBLE,
      $_columnNetGas INTEGER
    ) 
    '''
    );
  }

  //insert clients data
  Future<int> insertNewClient(Client client) async{
    Database db = await instance.database;
    return await db.rawInsert('''
      INSERT INTO $_tableName (
        $_columnId, $_columnName, $_columnPhone, $_columnGasCost, $_columnNetCredit, $_columnNetGas
      ) VALUES (
        ?, ?, ?, ?, ?, ?
      )
    ''',
    [ client.id, client.name, client.phone, client.gasCost,client.netCredit, client.netGas]
    );
  }

  Client _clientFromquery(Map<String, dynamic> client){
    try{
      return Client(
        id: client[_columnId],
        name: client[_columnName],
        phone: client[_columnPhone],
        gasCost: client[_columnGasCost],
        netCredit: client[_columnNetCredit],
        netGas: client[_columnNetGas]
      );
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  List<Client> _listOfClientfromquery(List<Map<String, dynamic>> listOfClients){
    List<Client> list = [];
    for(Map<String, dynamic> clients in listOfClients){
      list.add(_clientFromquery(clients));
    }
    return list;
  }

  //get all clients
  Future<List<Client>> getAllClients() async{
    Database db = await instance.database;
    List<Map<String, dynamic>> query = await db.query(_tableName);
    return _listOfClientfromquery(query);
  }

  //update clients data
  Future<int> updateClientData(Client client) async{
    Database db = await instance.database;
    return await db.rawUpdate('''
      UPDATE $_tableName 
      SET $_columnName = ?, $_columnPhone = ?, $_columnGasCost = ?
      WHERE $_columnId = ?
      ''', 
      [client.name, client.phone, client.gasCost, client.id]
    );
  }

  //delete client data
  Future<int> deleteClientData(String id) async{
    Database db = await instance.database;
    return db.delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  List<String> _getListFromMap(List<Map<String, dynamic>> listOfId){
    List<String> list = [];
    for(Map<String, dynamic> id in listOfId){
      list.add(id[_columnId]);
    }
    return list;
  }

  //get all id
  Future<List<String>> getAllId() async{
    Database db = await instance.database;
    List<Map<String, dynamic>> list = await db.rawQuery('''
      SELECT $_columnId FROM $_tableName;
      ''',
    );
    return _getListFromMap(list);
  }

  /////////////// Client ////////////////////
  
  Future createClientDB(String id) async{
    Database db = await instance.database;
    return db.execute('''
    CREATE TABLE $id (
      $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_columnDate DATETIME DEFAULT CURRENT_TIMESTAMP,
      $_columnGasGiven INTEGER NOT NULL,
      $_columnCylinderGot INTEGER NOT NULL,
      $_columnMoneyNeeded DOUBLE NOT NULL,
      $_columnMoneyGot DOUBLE NOT NULL
    )
    '''  
    );
  }

  //insert transaction
  Future<int> insertClientTransaction(Transactions transaction) async{
    Database db = await instance.database;
    return db.rawInsert('''
    INSERT INTO ${transaction.clientId} (
      $_columnGasGiven, $_columnCylinderGot, $_columnMoneyNeeded, $_columnMoneyGot 
    ) VALUES (
      ?, ?, ?, ?
    )
    ''',
    [transaction.gasGiven, transaction.cylinderGot, transaction.moneyNeeded, transaction.moneyGot]
    );
  }

  Transactions _transactionFromquery(Map<String, dynamic> transaction, String id){
    return Transactions(
      clientId: id,
      id: transaction[_columnId],
      date: transaction[_columnDate],
      gasGiven: transaction[_columnGasGiven],
      cylinderGot: transaction[_columnCylinderGot],
      moneyNeeded: transaction[_columnMoneyNeeded],
      moneyGot: transaction[_columnMoneyGot]
    );
  }

  
  List<Transactions> _listoftransactionfromquery(List<Map<String, dynamic>> listOfTransactions, String id){
    List<Transactions> list = [];
    for(Map<String, dynamic> transaction in listOfTransactions){
      list.add(_transactionFromquery(transaction, id));
    }
    return list;
  }

  //Get all transaction
  Future<List<Transactions>> getAllTransaction(String id) async{
    Database db = await instance.database;
    List<Map<String, dynamic>> query = await db.query(id);
    return _listoftransactionfromquery(query, id);
  }

  //update transaction
  Future<int> updateTransactionData(Transactions transaction) async{
    Database db = await instance.database;
    return await db.rawUpdate('''
      UPDATE ${transaction.clientId} 
      SET $_columnGasGiven = ?, $_columnCylinderGot = ?, $_columnMoneyNeeded = ?, $_columnMoneyGot = ?
      WHERE $_columnId = ?
      ''', 
      [transaction.gasGiven, transaction.cylinderGot, transaction.moneyNeeded, transaction.moneyGot]
    );
  }

  //delete transaction
  Future<int> deleteTransactionData(String clientId, int id) async{
    Database db = await instance.database;
    return db.delete(clientId, where: '$_columnId = ?', whereArgs: [id]);
  }

}