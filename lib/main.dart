//API Key: 4OyahWeyCNvmvOiDeyFpqYRLqhab7qOr
//Trending: https://api.giphy.com/v1/gifs/trending?api_key=4OyahWeyCNvmvOiDeyFpqYRLqhab7qOr&limit=20&rating=g
//Search: https://api.giphy.com/v1/gifs/search?api_key=4OyahWeyCNvmvOiDeyFpqYRLqhab7qOr&q=&limit=25&offset=25&rating=g&lang=en
/*
    share: ^0.6.1+1
    transparent_image: ^1.0.0
    http: ^0.12.0+2
 */

import 'package:flutter/material.dart';
import 'package:gifs/ui/home_page.dart';
import 'package:gifs/ui/gif_page.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(), //Minha tela inicial
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
