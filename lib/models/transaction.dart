class Transactions{
  String clientId;
  int id;
  String date = '2020';
  int gasGiven;
  int cylinderGot;
  double moneyNeeded;
  double moneyGot;
  Transactions({this.clientId, this.id = 0, this.date, this.gasGiven, this.cylinderGot, this.moneyNeeded, this.moneyGot});
}