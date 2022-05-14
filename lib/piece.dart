import 'package:flutter/material.dart';
import 'package:flutter_snake_game/problem.dart';
import 'dart:math';

class Piece extends StatefulWidget {
  final int posX, posY;
  final int size;
  final Color color;
  final bool isAnimated;
  final Problem problem;
  final Color shadowColor;
  final String gameType;
  const Piece({Key key, this.posX, this.posY, this.size, this.color = const Color(0XFFBF3105), this.isAnimated = false, this.problem, this.shadowColor, this.gameType}) : super(key: key);



  @override
  _PieceState createState() => _PieceState();

  String getSum(){
    if(this.problem != null){
      if(gameType == 'add') {
        return (this.problem.x + this.problem.y).toString();
      }
      else if (gameType == 'mult'){
        return (this.problem.x * this.problem.y).toString();
      }
    }
    return "";
  }



}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      lowerBound: 0.25,
      upperBound: 1.0,
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.posX.toDouble(),
      top: widget.posY.toDouble(),
      child: Opacity(
        opacity: widget.isAnimated ? _animationController.value : 1.0,
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(
              Radius.circular(
                widget.size.toDouble(),
              ),
            ),
            border: Border.all(color: Colors.black, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor,
                  spreadRadius: 12,
                  blurRadius: 15,
                  offset: Offset(0, 0),
                )
              ],
          ),
          child: Text("${widget.getSum()}", textAlign: TextAlign.center,softWrap: true,style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),),
        ),
      ),
    );
  }
}
