import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;
  int _offset = 0;
  late Future<Map> _futureGifs;

  Future<Map> _getGifs() async {
    String url = _search == null
        ? 'https://api.giphy.com/v1/gifs/trending?api_key=1iVxCoiqKZbBPYFrLi4MygIWbOKGCnBv&limit=20&offset=0&rating=r&bundle=messaging_non_clips'
        : 'https://api.giphy.com/v1/gifs/search?api_key=1iVxCoiqKZbBPYFrLi4MygIWbOKGCnBv&q=$_search&limit=19&offset=$_offset&rating=r&lang=en&bundle=messaging_non_clips';

    if (_search == "") {
      url =
      'https://api.giphy.com/v1/gifs/trending?api_key=1iVxCoiqKZbBPYFrLi4MygIWbOKGCnBv&limit=20&offset=0&rating=r&bundle=messaging_non_clips';
    }
    final response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _futureGifs = _getGifs(); // Inicializa a requisição
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
          'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                if (text != _search) {
                  setState(() {
                    _search = text;
                    _offset = 0;
                    _futureGifs = _getGifs();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _futureGifs,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
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
    if(_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    List gifs = snapshot.data["data"];
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _getCount(gifs),
      itemBuilder: (context, index) {
        if (index < gifs.length) {
          String gifUrl = gifs[index]["images"]["fixed_height"]["url"];
          String gifId = gifs[index]["id"];
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: gifUrl,
              height: 300,
            fit: BoxFit.cover,),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => GifPage(gifs[index])));
            },
            onLongPress: () {
              Share.share(gifUrl);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 70),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19; // Aumenta o offset para carregar mais
                  _futureGifs = _getGifs(); // Atualiza os GIFs
                });
              },
            ),
          );
        }
      },
    );
  }

}