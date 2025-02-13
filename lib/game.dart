import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class InnerGrid extends StatelessWidget {
  final List<int> blockValues; // Values for the 3x3 block

  const InnerGrid({Key? key, required this.blockValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(9, (index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.3),
          ),
          child: Center(
            child: Text(
              blockValues[index] == 0 ? '' : '${blockValues[index]}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }),
    );
  }
}

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Puzzle puzzle;  // Variable pour stocker la grille générée
  List<List<int>>? sudokuBoard;

  @override
  void initState() {
    super.initState();
    // Start the puzzle generation process asynchronously
    generateSudoku();
  }

  Future<void> generateSudoku() async {
    // Configure puzzle options (we can change the pattern if needed)
    PuzzleOptions puzzleOptions = PuzzleOptions(patternName: "random");
    puzzle = Puzzle(puzzleOptions);

    // Generate the puzzle
    await puzzle.generate();

    // Once puzzle is generated, extract the board and update the state
    setState(() {
      sudokuBoard = puzzle.board()?.matrix()?.map((row) =>
          row.map((cell) => cell.getValue() ?? 0).toList()
      ).toList();
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
      body: sudokuBoard == null
          ? Center(child: CircularProgressIndicator()) // Loading indicator while generating puzzle
          : Center(
        child: SizedBox(
          height: boxSize * 3,
          width: boxSize * 3,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              var x = index % 3;  // Bloc (x)
              var y = index ~/ 3;  // Position dans le bloc (y)
              // Extract the 3x3 block of values
              var blockValues = [
                sudokuBoard![y * 3][x * 3], sudokuBoard![y * 3][x * 3 + 1], sudokuBoard![y * 3][x * 3 + 2],
                sudokuBoard![y * 3 + 1][x * 3], sudokuBoard![y * 3 + 1][x * 3 + 1], sudokuBoard![y * 3 + 1][x * 3 + 2],
                sudokuBoard![y * 3 + 2][x * 3], sudokuBoard![y * 3 + 2][x * 3 + 1], sudokuBoard![y * 3 + 2][x * 3 + 2],
              ];

              return Container(
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 1),
                ),
                child: InnerGrid(blockValues: blockValues), // Use InnerGrid for each block
              );
            },
          ),
        ),
      ),
    );
  }
}
