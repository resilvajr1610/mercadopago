import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());
String _idPagamento;
const publicKey = "APP_USR-45f147a6-4487-41c7-9615-a1b7a2e7918d";

  Future<void> getData()async{
    var res = await http.post("https://api.mercadopago.com/checkout/preferences?access_token=TEST-2830808265180597-071819-836e7650fa5c9b968a4b36cfb9a46934-10733880",
      body: jsonEncode(
          {
            "items": [
              {
                "title": "Título do produto",
                "description": "Descrição do produto",
                "quantity": 1,
                "currency_id": "ARS",
                "unit_price": 1.35
              }
            ],
            "payer": {
              "email": "payer@email.com"
            }
          }
      )
    );
    print(res.body);
    var json = jsonDecode(res.body);
    _idPagamento = json['id'];
    //print("pagamento : "+_idPagamento);
  }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  PaymentResult result =
                  await MercadoPagoMobileCheckout.startCheckout(
                    publicKey,
                    _idPagamento,
                  );
                  print(result.toString());
                  if(result.status == "approved"){
                    print('Pagamento foi aprovado.');
                  }
                },
                child: Text("Pagar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}