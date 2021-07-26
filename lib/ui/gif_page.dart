import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  late final Map _gifData;
  GifPage(this._gifData); //Construtor para pegar as informações vindas da outra tela. Nesse caso estamos pegando o json do gif selecionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: (){
                Share.share(_gifData["images"]["fixed_height"]["url"]);
              },
              icon: Icon(Icons.share)
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      )
    );
  }
}
