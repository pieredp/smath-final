import 'package:flutter/material.dart';

import 'game.dart';
import 'level_menu.dart';

class MainMenu extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                  'S-Math',
                  style: TextStyle(
                    fontFamily: 'SnakeFont',
                    fontSize: 200.0,
                    color: Colors.deepOrangeAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 20.0,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      )
                    ],
                  )
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: ElevatedButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  // Push and replace current screen (i.e MainMenu) with
                  // SelectSpaceship(), so that player can select a spaceship.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LevelMenu('add'),
                    ),
                  );
                },
                child: Text('Play Addition'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: ElevatedButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  // Push and replace current screen (i.e MainMenu) with
                  // SelectSpaceship(), so that player can select a spaceship.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LevelMenu('mult'),
                    ),
                  );
                },
                child: Text('Play Multiplication'),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

}