// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; //Added

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(primaryColor: Colors.white),
      home: RandomWords(),
    );
  }
}

//コメント作成 + Widget Return
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>(); //Icon
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context)
        .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return new Scaffold(
        appBar: new AppBar(title: const Text('Sabed Suggenstions')),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Barを作成して、Title propertyをセット、Bodyを構成するWidgetをCallする
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        //UI partsもwidgetとして定義する
        padding: const EdgeInsets.all(16.0),
        // itemBuilder は単語ごとに1回呼び出され、その単語を1つの ListTile として配置します。
        // 偶数行なら、この関数は ListTile を生成し、
        // 奇数業なら、この関数は Divider widget (区切り線)を生成します。
        // ただし、小さなデバイスではこの線は見えづらいかもしれません。
        itemBuilder: (context, i) {
          // 1 pixel の区切り線を各行の前に表示します。
          if (i.isOdd) return Divider();

          // "i ~/ 2" という文法は、 i を 2で割って整数を返します。
          // 例えば、 i が 1, 2, 3, 4, 5 なら結果は 0, 1, 1, 2, 2 となります。
          // これは ListView 内の実際の単語数を計算します。つまり区切り線の数を引きます。
          final index = i ~/ 2;
          // もし利用可能な単語群の最後に到達したら...
          if (index >= _suggestions.length) {
            // ...最後まで来たら、更に10単語生成し、suggestions list に追加します。
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      // Iconのクリック挙動
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}

//State保持
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
