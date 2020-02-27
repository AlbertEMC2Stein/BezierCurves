class Controlpoint {
  PVector mPos;
  Linesegment isEndpointOf;

  Controlpoint (float x, float y, Controlpoint previous) {
    mPos = new PVector(x, y);

    if (previous != null) {
      isEndpointOf = new Linesegment(previous.mPos, mPos);
    } else {
      isEndpointOf = null;
    }
  }


  void dragTo(float x, float y) {
    mPos.set(x, y);
  }
  
  void actOnLinesegment() {
   isEndpointOf.moveLerper(); 
  }

  float dSq(float x, float y) {
    float dx = x - mPos.x;
    float dy = y - mPos.y;

    return sq(dx) + sq(dy);
  }
  
  void show() {
    stroke(255);
    noFill();
    ellipse(mPos.x, mPos.y, 10, 10);

    stroke(255);
    fill(255);
    ellipse(mPos.x, mPos.y, 2, 2);

    if (isEndpointOf != null) {
      isEndpointOf.show();
    }
  }
}
