import 'dart:math';

import 'package:flutter/material.dart';

Color primaryColor =  const Color(0xff21C4FF);

String getInitialsOfName(String name){
  List<String> split = name.split(' ');
  String initials;
  if (split.length > 1){
    initials = split[0][0].toUpperCase() + split[split.length-1][0].toUpperCase();
  }else{
    initials = split[0][0].toUpperCase();
  }
  return initials;
}

// TextFieldForm decoration
const inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff21C4FF), width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2),
  )
);

//tokenize
String tokenize(){
  String char = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  List<String> token = [];
  List<String> listChar = char.split('');
  var rand = Random();
  for(int i = 0; i < 10; i++) {
    token.add(listChar[rand.nextInt(listChar.length - 1)]);
  }
  return token.join();
}