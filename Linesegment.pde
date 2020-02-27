class Linesegment {
  PVector mStart;
  PVector mEnd;
  Lerper mLerper;

  Linesegment(PVector start, PVector end) {
    mStart = start;
    mEnd = end;

    mLerper = new Lerper(start, end, null);
  }


  void moveLerper() {
    mLerper.lerpL(globalTimer);

    if (mLerper.isEndpointOf != null) {
      mLerper.isEndpointOf.moveLerper();
    } 
  }

  void show() {
    stroke(255);
    line(mStart.x, mStart.y, mEnd.x, mEnd.y);
    mLerper.show(color(255, 0, 0));
  }
}
