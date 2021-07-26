import 'dart:convert';
import 'dart:async';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:gifs/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search = null;
  int _offset = 0;
  int _limit = 19;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=4OyahWeyCNvmvOiDeyFpqYRLqhab7qOr&limit=20&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=4OyahWeyCNvmvOiDeyFpqYRLqhab7qOr&q=$_search&limit=$_limit&offset=$_offset&rating=g&lang=en");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.gif"),
        //Esse widget pega uma imagem da internet
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui!!",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0)),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  if (text == "")
                    _search = null;
                  else
                    _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        //Barra de carregamento circular
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null)
      return data.length;
    else
      return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //Mostra como os itens serão organizados na tela
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          //Função que irá retornar o widget que será colocado em cada posição
          if (_search == null || index < snapshot.data["data"].length) {
            return GestureDetector( //Assim seremos capazes de clicar na imagem
              child: FadeInImage.memoryNetwork( //Poderia ter usado simplesmente o Image.network mas dessa forma o gif surgiria abruptamente. Nesse novo modo eleaparece mais suavemente
                  placeholder: kTransparentImage, //O que terá antes da imagem aparecer. Nesse caso usaos um plugins de uma imagem transparente
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push( //O Navigator.push espera como parâmetro um context e uma route
                    context,
                    MaterialPageRoute( //route é um caminho entre as duas telas
                        builder: (context) => GifPage(snapshot.data["data"][index])
                    )
                );
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          } else if(_search != null && _offset == 0){
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 70.0),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    //O setState vai obrigar o FutureBuilder a recarregar e atualizar a tela com os novos gifs
                    _offset += 19;
                    //_limit = 18;
                  });
                },
              ),
            );
          } else /*if(_search != null && _offset >= 19)*/{
            return Container(
                  child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_left, color: Colors.white, size: 60.0)
                                ],
                              ),
                              onTap: (){
                                setState(() {
                                  _offset -= 19;
                                  if(_offset < 0) _offset = 0;
                                });
                              },
                            ),
                            GestureDetector(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_right, color: Colors.white, size: 60.0)
                                ],
                              ),
                              onTap: (){
                                setState(() {
                                  _offset += 19;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                );
          }
        });
  }
}
