import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'innergrid.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Puzzle puzzle;
  List<List<int>>? sudokuBoard;
  List<List<int>>? solvedBoard;
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

      solvedBoard = puzzle.solvedBoard()?.matrix()?.map((row) =>
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
      body: sudokuBoard == null || solvedBoard == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
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
                  solvedBoard: solvedBoard!,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<int> extractBlockValues(List<List<int>> board, int blockX, int blockY) {
    List<int> values = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        values.add(board[blockY * 3 + i][blockX * 3 + j]);
      }
    }
    return values;
  }
}
