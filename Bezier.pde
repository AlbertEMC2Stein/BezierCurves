ArrayList<Controlpoint> cps; //<>//
ArrayList<Lerper> currentLerpers;
ArrayList<Lerper> temp;
ArrayList<PVector> curvePoints;
Controlpoint dragging = null;
float globalTimer = 0;

float dt = 0.0025;

///////////////////////////////////////////////////////////////////////////

void setup() {
  size(600, 600, P2D);
  pixelDensity(2);

  cps = new ArrayList<Controlpoint>();
  currentLerpers = new ArrayList<Lerper>();
  curvePoints = new ArrayList<PVector>();
}


void draw() {
  background(0);

  fill(255);
  text("t = " + nfc(globalTimer, 4), 5, 15);

  stroke(255);
  for (int i=0; i < cps.size(); i++) {
    Controlpoint cp = cps.get(i);
    cp.show();   

    if (cp.isEndpointOf != null) {
      cp.actOnLinesegment();
    }
  }

  if (currentLerpers.size() > 0) {
    curvePoints.add(currentLerpers.get(0).mPos.copy());
  }
  
  stroke(0, 255, 0);
  noFill();
  beginShape();
  for (PVector p : curvePoints) {
    vertex(p.x, p.y);
  }
  endShape();


  globalTimer = min(globalTimer + dt, 1);
  if (globalTimer == 1) {
    globalTimer = 0;
    curvePoints.clear();
  }
}

/////////////////////////////////////

void keyPressed() {
  if (key == 'r') {
    cps.clear();    
    currentLerpers.clear();
    temp.clear();
    curvePoints.clear();
    globalTimer = 0;
  }
}


void mouseClicked() { 
  modify(mouseX, mouseY);
  curvePoints.clear();
  globalTimer = 0;

  while (currentLerpers.size() >= 2) {
    temp = (ArrayList<Lerper>) currentLerpers.clone();
    currentLerpers.clear();

    for (int i = 1; i < temp.size(); i++) {
      Lerper end = temp.get(i);
      Lerper start = temp.get(i-1);

      Linesegment newLs = new Linesegment(start.mPos, end.mPos);
      end.isEndpointOf = newLs;

      currentLerpers.add(newLs.mLerper);
    }
  }
}


void mouseDragged() {
  if (dragging == null) {
    for (Controlpoint cp : cps) {
      if (cp.dSq(mouseX, mouseY) <= 100) {
        dragging = cp;
        break;
      }
    }
  } else {
    dragging.dragTo(mouseX, mouseY);
  }
}


void mouseReleased() {
  dragging = null;
}

///////////////////////////////////////////////////////////////////////////

void modify(float x, float y) {
  boolean createNew = true;
  int id = 0;

  for (Controlpoint cp : cps) {  
    if (cp.dSq(x, y) <= 100) { 
      createNew = false;
      break;
    }

    id++;
  }


  if (createNew) {
    if (cps.size() > 0) {
      cps.add(new Controlpoint(x, y, cps.get(cps.size()-1)));
    } else {
      cps.add(new Controlpoint(x, y, null));
    }
  } else {
    cps.remove(id);

    if (id == 0) {
      if (cps.size() == 1) {
        cps.get(0).isEndpointOf = null;
      } else if (cps.size() >= 2) {
        cps.get(0).isEndpointOf = null;
        cps.get(1).isEndpointOf.mLerper.isEndpointOf = null;
      }
    } else {
      for (int i = cps.size()-1; i > 0; i--) {
        Controlpoint cp = cps.get(i);
        Controlpoint prev = cps.get(i-1);

        cp.isEndpointOf = new Linesegment(prev.mPos, cp.mPos);
      }
    }
  }

  currentLerpers.clear();
  for (int i = 1; i < cps.size(); i++) {
    Controlpoint cp = cps.get(i);
    currentLerpers.add(cp.isEndpointOf.mLerper);
  }
}
