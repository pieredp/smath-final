import 'dart:async';
import 'dart:math';


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/main_menu.dart';
import 'package:flutter_snake_game/problem.dart';
import 'package:flutter_snake_game/sound_manager.dart';


import 'control_panel.dart';
import 'direction.dart';
import 'direction_type.dart';
import 'piece.dart';


class GamePage extends StatefulWidget {
  final String type;


  GamePage(this.type);

  @override
  _GamePageState createState() => _GamePageState();

}

class _GamePageState extends State<GamePage> {
  List<Offset> positions = [];
  int length = 10;
  int step = 40;
  Direction direction = Direction.right;

  List<Piece> foods = [];
  List<Offset> foodsPosition = [];

  double screenWidth;
  double screenHeight;
  int lowerBoundX, upperBoundX, lowerBoundY, upperBoundY;

  Timer timer;
  double speed = 1;

  int score = 0;
  List<Problem> problems = [];
  Problem problem;

  bool playMusic = true;
  bool changeColor = false;
  Color shadowColor;
  Color prevFoodColor = Colors.red;

  SoundManager _soundManager = SoundManager();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  bool isGameOver = false;

  void draw()  {
    if (positions.length == 0) {
      positions.add(getRandomPositionWithinRange());
    }

    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (int i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    positions[0] = getNextPosition(positions[0]);
  }

  Direction getRandomDirection([DirectionType type]) {
    if (type == DirectionType.horizontal) {
      bool random = Random().nextBool();
      if (random) {
        return Direction.right;
      } else {
        return Direction.left;
      }
    } else if (type == DirectionType.vertical) {
      bool random = Random().nextBool();
      if (random) {
        return Direction.up;
      } else {
        return Direction.down;
      }
    } else {
      int random = Random().nextInt(4);
      return Direction.values[random];
    }
  }

  Offset getRandomPositionWithinRange() {
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;
    return Offset(roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble());
  }

  List<Offset> getRandomPositionWithinRangeV2() {
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;
    List<Offset> temp = [];
    temp.add(Offset(roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble()));
    posX = Random().nextInt(upperBoundX) + lowerBoundX;
    posY = Random().nextInt(upperBoundY) + lowerBoundY;
    temp.add(Offset(roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble()));
    posX = Random().nextInt(upperBoundX) + lowerBoundX;
    posY = Random().nextInt(upperBoundY) + lowerBoundY;
    temp.add(Offset(roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble()));
    return temp;
  }

  bool detectCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {

      return true;
    } else if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }

    return false;
  }

  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Game Over",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Your game is over but you played well. Your score is " + score.toString() + ".",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                Navigator.of(context).pop();
                restart();
              },
              child: Text(
                "Restart",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MainMenu(),
                ),
                );
              },
              child: Text(
                "Main Menu",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Offset getNextPosition(Offset position) {
    Offset nextPosition;

    if (detectCollision(position) == true) {
      _soundManager.stopBackgroundMusic();
      if (timer != null && timer.isActive) timer.cancel();
      Future.delayed(Duration(milliseconds: 500), () => showGameOverDialog());
      isGameOver = true;
      return position;
    }

    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }

    return nextPosition;
  }



  List<Problem> generateNewProblems() {
    List<Problem> tempProblems = [];

    for (int i = 0; i < foodsPosition.length; i++) {
      tempProblems.add(Problem(widget.type).generateProblem());
    }
    return tempProblems;
  }


  bool isAnswerCorrect(Piece foodPiece){
    if(widget.type == 'add'){
      if(foodPiece.problem.x + foodPiece.problem.y == problems[0].x + problems[0].y){
        return true;
      }
    }
    else if (widget.type == 'mult'){
      if(foodPiece.problem.x * foodPiece.problem.y == problems[0].x * problems[0].y){
        return true;
      }
    }

    return false;
  }

  Color getShadowColor(){
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }


  void drawFood() {
    if (foodsPosition.isEmpty) {
      foodsPosition = getRandomPositionWithinRangeV2();
      problems = generateNewProblems();
    }
    for(int i = 0; i < foodsPosition.length; i++){
      if (foodsPosition[i] == positions[0]) {
        if(isAnswerCorrect(foods[i])){
          _soundManager.playCorrectAnswerSound();
          prevFoodColor = foods[i].color;
          shadowColor = getShadowColor();
          changeColor = true;
          length++;
          if(speed<5) {
            speed = speed + 0.25;
          }
          score = score + 1;
          changeSpeed();
          draw();
        }
       else{
         _soundManager.playWrongAnswerSound();
         shadowColor = getShadowColor();
         changeColor = false;
         //length--;
        }
        foodsPosition = getRandomPositionWithinRangeV2();
        problems = generateNewProblems();
      }
    }

    if(foods.isNotEmpty){
      foods.clear();
    }
    for(int i = 0; i < foodsPosition.length; i++) {
      foods.add(Piece(
        posX: foodsPosition[i].dx.toInt(),
        posY: foodsPosition[i].dy.toInt(),
        size: step,
        color: shadowColor == null ? Colors.purple:shadowColor,
        // isAnimated: true,
        problem: problems[i],
        shadowColor: shadowColor == null ? Colors.purple:shadowColor,
        gameType: widget.type,
        image: 'images/apple.png'
      )
      );
    }
  }


  List<Piece> getPieces() {
    List<Piece> pieces = [];
    draw();
    drawFood();

    for (int i = 0; i < length; i++) {
      if (i >= positions.length) {
        continue;
      }

      pieces.add(
        Piece(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          size: step,
          color: prevFoodColor,
          shadowColor: prevFoodColor,
          gameType: widget.type,
          image: getSnakePiece(i)
        ),
      );
    }

    return pieces;
  }

  Widget getControls() {
    return ControlPanel(
      onTapped: (Direction newDirection) {
        direction = newDirection;
      },
    );
  }



  int roundToNearestTens(int num) {
    int divisor = step;
    int output = (num ~/ divisor) * divisor;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  void changeSpeed() {
    if (timer != null && timer.isActive) timer.cancel();

    // if you want timer to tick at fixed duration.
    timer = Timer.periodic(Duration(milliseconds: 200 ~/ speed), (timer) {
      setState(() {});
    });
  }

  Widget getScore() {
    return Positioned(
      top: 50.0,
      right: 40.0,
      child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            "Score: " + score.toString(),
            style: TextStyle(
              fontSize: 40,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = Colors.blue[700],
            ),
          ),
          // Solid text as fill.
          Text(
            "Score: " + score.toString(),
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );


  }

  String getProblemStringByType(){
    int x,y;

    if(problems[0].x > problems[0].y){
      x = problems[0].x;
      y = problems[0].y;
    }
    else{
      x = problems[0].y;
      y = problems[0].x;
    }


    if(widget.type == 'add'){
      return "Problem to solve: $x + $y";
    }
    else if(widget.type == 'mult'){
      return "Problem to solve: $x x $y";
    }
    return "Problem to solve: $x + $y";
  }

  Widget getProblem() {
    return Positioned(
      top: 50.0,
      left: 40.0,
      child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            getProblemStringByType() ,
            style: TextStyle(
              fontSize: 40,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = Colors.blue[700],
            ),
          ),
          // Solid text as fill.
          Text(
            getProblemStringByType(),
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  void restart() {
    _soundManager.playBackgroundMusic();
    score = 0;
    length = 5;
    positions = [];
    direction = getRandomDirection();
    speed = 1;
    changeSpeed();
    isGameOver = false;
  }

  Widget getPlayAreaBorder() {
    return Positioned(
      top: lowerBoundY.toDouble(),
      left: lowerBoundX.toDouble(),
      child: Container(
        width: (upperBoundX - lowerBoundX + step).toDouble(),
        height: (upperBoundY - lowerBoundY + step).toDouble(),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _soundManager.playBackgroundMusic();
    restart();
  }

  Widget getKeyboardControls(BuildContext context){
    return RawKeyboardListener(
      autofocus: true,
        focusNode: FocusNode(),
        onKey: (event){
          if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)){
            direction = Direction.up;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)){
            direction = Direction.down;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
            direction = Direction.left;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)){
            direction = Direction.right;
          }
        }, child: Container(),

    );
  }

  String getSnakePiece(int i) {
    if (isGameOver) {
      return '';
    }
    // head
    if (i == 0) {
      if (direction == Direction.right) {
        return 'images/snake-pieces/head-right.png';
      }
      else if (direction == Direction.left) {
        return 'images/snake-pieces/head-left.png';
      }
      else if (direction == Direction.up) {
        return 'images/snake-pieces/head-top.png';
      }
      else if (direction == Direction.down) {
        return 'images/snake-pieces/head-bottom.png';
      }
    }
    // tail
    else if (i == length - 1) {
      if (positions[i].dx > positions[i - 1].dx) {
        return 'images/snake-pieces/tail-left.png';
      }
      if (positions[i].dx < positions[i - 1].dx) {
        return 'images/snake-pieces/tail-right.png';
      }
      if (positions[i].dy > positions[i - 1].dy) {
        return 'images/snake-pieces/tail-top.png';
      }
      if (positions[i].dy < positions[i - 1].dy) {
        return 'images/snake-pieces/tail-bottom.png';
      }
    }
    // corner piece
    else if ((positions[i].dy > positions[i - 1].dy &&
             positions[i].dx > positions[i + 1].dx) ||
            (positions[i].dx > positions[i - 1].dx &&
              positions[i].dy > positions[i + 1].dy)) {
      return 'images/snake-pieces/left-top.png';
    }
    else if ((positions[i].dy > positions[i - 1].dy &&
             positions[i].dx < positions[i + 1].dx) ||
            (positions[i].dx < positions[i - 1].dx &&
                positions[i].dy > positions[i + 1].dy)) {
      return 'images/snake-pieces/right-top.png';
    }
    else if ((positions[i].dy < positions[i - 1].dy &&
        positions[i].dx < positions[i + 1].dx) ||
        (positions[i].dx < positions[i - 1].dx &&
            positions[i].dy < positions[i + 1].dy)) {
      return 'images/snake-pieces/right-bottom.png';
    }
    else if ((positions[i].dy < positions[i - 1].dy &&
        positions[i].dx > positions[i + 1].dx) ||
        (positions[i].dx > positions[i - 1].dx &&
            positions[i].dy < positions[i + 1].dy)) {
      return 'images/snake-pieces/left-bottom.png';
    }
    // straight piece
    else {
      if (positions[i].dy == positions[i - 1].dy) {
        return 'images/snake-pieces/left-right.png';
      }
      else if (positions[i].dx == positions[i - 1].dx) {
        return 'images/snake-pieces/top-bottom.png';
      }
    }

    return '';
  }
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    lowerBoundX = step;
    lowerBoundY = step;
    upperBoundX = roundToNearestTens(screenWidth.toInt() - step);
    upperBoundY = roundToNearestTens(screenHeight.toInt() - step);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Stack(
          children: [
            getPlayAreaBorder(),
            Container(
              child: Stack(
                children: getPieces(),
              ),
            ),
            foods[0],
            foods[1],
            foods[2],
            getControls(),
            getScore(),
            getProblem(),
            getKeyboardControls(context)
          ],
        ),
      ),
    );
  }
}
