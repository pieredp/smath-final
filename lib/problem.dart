

import 'dart:math';

class Problem {
  int x,y;
  final String type;

  Problem(this.type);


  Problem generateProblem(){
    var rng = Random();
    if(type == 'add') {
      this.x = rng.nextInt(20)+1;
      this.y = rng.nextInt(20)+1;
    }
    else if(type == 'mult'){
      this.x = rng.nextInt(10)+1;
      this.y = rng.nextInt(10)+1;
    }
    return this;
  }
}