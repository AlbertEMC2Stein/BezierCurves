class Lerper {  
  PVector mStart;
  PVector mEnd;
  PVector mPos;
  Linesegment isEndpointOf;

  Lerper(PVector start, PVector end, Lerper previous) {
    mStart = start;
    mEnd = end;
    mPos = start.copy();

    if (previous != null) {
      isEndpointOf = new Linesegment(previous.mStart, mEnd);
    } else {
      isEndpointOf = null;
    }
  }
  
  Lerper(Lerper l) {
    mStart = l.mStart;
    mEnd = l.mEnd;
    mPos = l.mStart.copy();
    isEndpointOf = l.isEndpointOf;
  }


  void lerpL(float p) {
    float newX = (1-p)*mStart.x + p*mEnd.x;
    float newY = (1-p)*mStart.y + p*mEnd.y;

    mPos.set(newX, newY);
  }
  
  Lerper copy() {
    return new Lerper(this);
  }

  void show(color c) {    
    stroke(255);
    fill(c);
    ellipse(mPos.x, mPos.y, 5, 5);

    if (isEndpointOf != null) {
      isEndpointOf.show();
    } 
  }
}
