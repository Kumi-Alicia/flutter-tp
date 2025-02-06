import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble(); // Calcul de la taille de chaque carré

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          height: boxSize * 3, // Hauteur de la grille
          width: boxSize * 3,  // Largeur de la grille
          child: GridView.count(
            crossAxisCount: 3,  // 3 éléments par ligne
            mainAxisSpacing: 0, // Aucune marge verticale
            crossAxisSpacing: 0, // Aucune marge horizontale
            children: List.generate(9, (index) {
              return Container(
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 1), // Bord bleu
                ),
              );
            }),

          ),
        ),
      ),
    );
  }
}
