import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'innergrid.dart';
import 'numberButton.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Puzzle puzzle;
  List<List<int>>? sudokuBoard;
  int? selectedCell;

  @override
  void initState() {
    super.initState();
    generateSudoku();
  }

  /// Génère une grille de Sudoku aléatoire et met à jour l'état du jeu.
  Future<void> generateSudoku() async {
    PuzzleOptions puzzleOptions = PuzzleOptions(patternName: "random");
    puzzle = Puzzle(puzzleOptions);

    await puzzle.generate();

    setState(() {
      sudokuBoard = puzzle.board()?.matrix()?.map((row) =>
          row.map((cell) => cell.getValue() ?? 0).toList()
      ).toList();
    });
  }

  /// Gère la sélection d'une case en mettant à jour l'index de la case sélectionnée.
  void handleCellTap(int globalIndex) {
    setState(() {
      selectedCell = globalIndex;
    });
  }

  /// Extrait les valeurs d'un bloc 3x3 à partir de la grille Sudoku.
  ///
  /// - [board] : La grille complète du Sudoku.
  /// - [blockX] : L'index de colonne du bloc (0 à 2).
  /// - [blockY] : L'index de ligne du bloc (0 à 2).
  ///
  /// Retourne une liste des 9 valeurs du bloc.
  List<int> extractBlockValues(List<List<int>> board, int blockX, int blockY) {
    List<int> values = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        values.add(board[blockY * 3 + i][blockX * 3 + j]);
      }
    }
    return values;
  }

  /// Met à jour la valeur de la cellule sélectionnée avec la valeur donnée par l'utilisateur.
  void setCellValue(int value) {
    if (selectedCell != null) {
      int pos = selectedCell!;
      puzzle.board()!.cellAt(pos as Position).setValue(value);

      setState(() {
        sudokuBoard = puzzle.board()?.matrix()?.map((row) =>
            row.map((cell) => cell.getValue() ?? 0).toList()
        ).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: sudokuBoard == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: boxSize * 3,
              width: boxSize * 3,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  var x = index % 3;
                  var y = index ~/ 3;
                  var blockValues = extractBlockValues(sudokuBoard!, x, y);

                  return Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 1),
                    ),
                    child: InnerGrid(
                      blockValues: blockValues,
                      selectedIndex: selectedCell != null && selectedCell! ~/ 9 == index ? selectedCell! % 9 : null,
                      onCellTap: (innerIndex) {
                        int globalIndex = index * 9 + innerIndex;
                        handleCellTap(globalIndex);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              int value = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: NumberButton(
                  value: value,
                  onPressed: setCellValue,
                ),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              int value = index + 6;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: NumberButton(
                  value: value,
                  onPressed: setCellValue,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

