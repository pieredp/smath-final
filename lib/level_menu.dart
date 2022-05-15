


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class LevelMenu extends StatelessWidget {
  final String gameType;


  LevelMenu(this.gameType);

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
                    'Choose Level',
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
                        builder: (context) => GamePage(gameType, 1),
                      ),
                    );
                  },
                  child: Text('Level 1'),
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
                        builder: (context) => GamePage(gameType, 2),
                      ),
                    );
                  },
                  child: Text('Level 2'),
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
                        builder: (context) => GamePage(gameType, 3),
                      ),
                    );
                  },
                  child: Text('Level 3'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}