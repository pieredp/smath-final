

import 'dart:math';

class Problem {
  int x,y;

  final String type;

  Problem(this.type);


  Problem generateProblem(int level){
    int maxNum = 0;
    if(level == 1){
      maxNum = 10;
    }
    else if(level == 2){
      maxNum = 20;
    }
    else if(level == 3){
      maxNum = 30;
    }
    var rng = Random();
    if(type == 'add') {
      this.x = rng.nextInt(maxNum)+1;
      this.y = rng.nextInt(maxNum)+1;
    }
    else if(type == 'mult'){
      this.x = rng.nextInt(maxNum)+1;
      this.y = rng.nextInt(maxNum)+1;
    }
    return this;
  }
}