import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String value = currenciesList[0];
  String data = "?";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bitcoin Tracker"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Colors.lightBlue,
                elevation: 8.0,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "1 BTC= $data $value",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.lightBlue,
              height: 150.0,
              alignment: Alignment.center,
              child: Platform.isIOS ? _getIosDropDown() : _getAndroidDropDown(),
            )
          ],
        ),
      ),
    );
  }

  CupertinoPicker _getIosDropDown() {
    List<Text> dropdownItem = [];
    for (String s in currenciesList) {
      dropdownItem.add(Text(s));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 34.0,
        onSelectedItemChanged: (value) {
          setState(() {});
        },
        children: dropdownItem);
  }

  DropdownButton _getAndroidDropDown() {
    List<DropdownMenuItem<String>> dropdownItem = [];
    for (String s in currenciesList) {
      dropdownItem.add(
        DropdownMenuItem<String>(
          child: Text(s),
          value: s,
        ),
      );
    }

    return DropdownButton<String>(
      value: value,
      items: dropdownItem,
      onChanged: (value) {
        var url = 'https://rest.coinapi.io/v1/exchangerate/BTC/$value';
        setState(() {
          this.value = value;
          data = "?";
        });
        getCoinData(url);
      },
    );
  }

  void getCoinData(String url) async {
    data = await getData(url);
    setState(() {
      this.data = data;
      print(data);
    });
  }

  Future<String> getData(String url) async {
    String coin = "";
    var respons = await get(url,
        headers: {"X-CoinAPI-Key": "AB806144-A1A3-486E-B073-307616DCE8FD"});
    if (respons.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(respons.body);
      String rete = data['rate'].toStringAsFixed(3);
      if (rete != null) {
        coin = rete;
      }
    }
    return coin;
  }
}
