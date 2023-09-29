import processing.sound.*;
//PImage object for images
PFont f,endF;

SoundFile ding;
PImage img;
int numBalls = 10;
float cor = 0.8f; // Coefficient of Restitution
float obstacleSpeed = 50;
Vec2 gravity = new Vec2(0,250);//new Vec2(0,350); //mimic pinball machine slanted, not direct fall

Vec2 pos[] = new Vec2[numBalls];
Vec2 vel[] = new Vec2[numBalls];
float radius[] = new float[numBalls];
float mass[] = new float[numBalls];
float origMass = pow(0.2*10,2);
float newMass = pow(0.1*10,2);
Circle pinballs[] = new Circle[numBalls];
int colorID[] = new int[numBalls];
float maxVel = 1000;


Vec2 obstacleVel = new Vec2(0, 0); //ALL OBSTACLES ZERO VELOCITY
float defRadius = 30;
float circObjRadius1,circObjRadius2,circObjRadius3,circObjRadius4,circObjRadius5,circObjRadius6;

Circle circleObjects[] = new Circle[6]; //circle objects list
int collColor = color(150,20,20); //collision red
int circDefColor = color(0,200,50);//default green
int cirColor1,cirColor2,cirColor3,cirColor4,cirColor5,cirColor6;

Box b1,b2,b3,b4,b5,b6;
int recDefCol = color(110,55,55); //default brown
int rectColor;
Box boxObjects[] = new Box[6]; 

Box l1,l2,l3,l4; //lines/flippers
Box lineObjects[] = new Box[4];

int score = 0;
int endCounter[] = new int[10];
//second point is the tip
Line lineLeft = new Line(0,600,175,670);
Line lineRight = new Line(500,600,325,670); //line reads left to right - - thickness 4

Line flipperL = new Line(175,670,225,680); //thickness 5
Line flipperR = new Line(325,670,275,680);
float flipLeftAngVel = 0; //radians
float flipRightAngVel = 0;
float flipLeftAngle = 0;
float flipRightAngle = 0;
float flipMass = 70;


void dropBalls(){
 for (int i = 0; i < numBalls; i++) {
    radius[i] = 10;
    pos[i] = new Vec2(random(width), -750-radius[i]);
    vel[i] = new Vec2(random(-15,15), random(-25,25));
    mass[i] = origMass; //mass function of radius
    colorID[i] = 0; //default color
    Circle c = new Circle(pos[i], radius[i]); //put pinballs into list
    pinballs[i] = c;
  } 
}


// reset the balls to random positions and velocities
void resetBalls(){
  //clist = new Circle[numBalls];
  score = 0;
  endCounter = new int[10];
  
  ding = new SoundFile(this,"ding wav file.wav");
  ding.amp(0.15);
  ding.stop();
  
  circObjRadius1 = defRadius;
  circObjRadius2 = defRadius;
  circObjRadius3 = defRadius;
  circObjRadius4 = defRadius;
  circObjRadius5 = defRadius;
  circObjRadius6 = defRadius;
  cirColor1 = circDefColor; //default obstacle color blue
  cirColor2 = circDefColor;
  cirColor3 = circDefColor;
  cirColor4 = circDefColor;
  cirColor5 = circDefColor;
  cirColor6 = circDefColor;
  
    //fill circle objects list
    Vec2 circle1 = new Vec2(125, 290); //top left
    Vec2 circle2 = new Vec2(63, 525); //bottom left
    Vec2 circle3 = new Vec2(375, 290); //top right
    Vec2 circle4 = new Vec2(437, 525); //bottom right
    Vec2 circle5 = new Vec2(250, 360); //bottom middle
    Vec2 circle6 = new Vec2(250, 150); //top middle
    Circle c1 = new Circle(circle1, circObjRadius1);
    Circle c2 = new Circle(circle2, circObjRadius2);
    Circle c3 = new Circle(circle3, circObjRadius3);
    Circle c4 = new Circle(circle4, circObjRadius4);
    Circle c5 = new Circle(circle5, circObjRadius5);
    Circle c6 = new Circle(circle6, circObjRadius6);
    circleObjects[0] = c1; 
    circleObjects[1] = c2;
    circleObjects[2] = c3;
    circleObjects[3] = c4;
    circleObjects[4] = c5;
    circleObjects[5] = c6;
  
    rectColor = recDefCol;
    b1 = new Box(250,500,30,125); //rectangle
    
    b2 = new Box(100,740,30,30); //presents,left to right
    b3 = new Box(370,725,50,50);
    b4 = new Box(430,715,70,70);
    
    b5 = new Box(380,425,20,20);//mid box obstacles
    b6 = new Box(120,425,20,20);
    
    boxObjects[0] = b1;
    boxObjects[1] = b2;
    boxObjects[2] = b3;
    boxObjects[3] = b4;
    boxObjects[4] = b5;
    boxObjects[5] = b6;
}

void setup(){
  size(500, 750); //mimic pinball machine rectangle shape
  img = loadImage("christmas.jpg");
  f = createFont("Arial Bold",30,true);
  endF = createFont("Georgia Bold", 100, true);
  smooth();
  noStroke();
  // create the balls
  dropBalls();
  resetBalls();
}

void simulateL(float angVel, float dt){
    if(leftPressed && (flipLeftAngle > -PI/5)){ //stopping point
      flipLeftAngle += angVel*dt;
    }
    else if(flipLeftAngle < -PI/5){
      flipLeftAngle = -PI/5;
      flipLeftAngVel = 0;
    }
    else if(!leftPressed && (flipLeftAngle <= 0)) { //released, not past start, bring back down
      flipLeftAngle += angVel * dt;
    }
    
}
void simulateR(float angVel, float dt){
  if(rightPressed && (flipRightAngle < PI/5)){ //stopping point
      flipRightAngle += angVel*dt;
    }
    else if(flipRightAngle > PI/5){
      flipRightAngle = PI/5;
      flipRightAngVel = 0;
    }
    else if(!rightPressed && (flipRightAngle >= 0)) { 
      flipRightAngle += angVel * dt;
    }
}
//FUNCTION TO HANDLE OBSTACLE SIZE CHANGE
void objSizeUpdate(float dt){
  if(circObjRadius1 > 30){
    circObjRadius1 -= 8*dt;
    circleObjects[0].radius = circObjRadius1;
  }
  else {
    cirColor1 = circDefColor;
  }
  if(circObjRadius2 > 30){
    circObjRadius2 -= 8*dt;
    circleObjects[1].radius = circObjRadius2;
  }
  else {
    cirColor2 = circDefColor;
  }
  if(circObjRadius3 > 30){
    circObjRadius3 -= 8*dt;
    circleObjects[2].radius = circObjRadius3;
  }
  else {
    cirColor3 = circDefColor;
  }
  if(circObjRadius4 > 30){
    circObjRadius4 -= 8*dt;
    circleObjects[3].radius = circObjRadius4;
  }
  else {
    cirColor4 = circDefColor;
  }
  if(circObjRadius5 > 30){
    circObjRadius5 -= 8*dt;
    circleObjects[4].radius = circObjRadius5;
  }
  else {
    cirColor5 = circDefColor;
  }
  if(circObjRadius6 > 30){
    circObjRadius6 -= 8*dt;
    circleObjects[5].radius = circObjRadius6;
  }
  else {
    cirColor6 = circDefColor;
  }
}
//FUNCTION TO HANDLE OBSTACLE COLOR CHANGE
void changeObjColor(int k){
  if(k == 0){
    cirColor1 = collColor;
    circObjRadius1 = 40;
    circleObjects[0].radius = 40;
  }
  else if(k == 1){
    cirColor2 = collColor;
    circObjRadius2 = 40;
    circleObjects[1].radius = 40;
  }
  else if(k == 2){
    cirColor3 = collColor;
    circObjRadius3 = 40;
    circleObjects[2].radius = 40;
  }
  else if(k == 3){
    cirColor4 = collColor;
    circObjRadius4 = 40;
    circleObjects[3].radius = 40;
  }
  else if(k == 4){
    cirColor5 = collColor;
    circObjRadius5 = 40;
    circleObjects[4].radius = 40;
  }
  else if(k == 5){
    cirColor6 = collColor;
    circObjRadius6 = 40;
    circleObjects[5].radius = 40;
  }
}
void updatePhysics(float dt){
  // Update obstacle position
  
  objSizeUpdate(dt);
  obstacleVel = new Vec2(0,0);
  
  if(leftPressed){
    if(flipLeftAngle == -PI/5){
      flipLeftAngVel = 0; 
    }
    else {
      flipLeftAngVel = -8;
    }
    simulateL(flipLeftAngVel,dt);
    flipperL.x2 = 50*cos(flipLeftAngle) - 10*sin(flipLeftAngle) + 175; //translate origin to flip start, calculate rotation around it, translate back
    flipperL.y2 = 50*sin(flipLeftAngle) + 10*cos(flipLeftAngle) + 670;
    
  }
  else if (!leftPressed){ //reset flipper position
    if(flipLeftAngle == 0){
       flipLeftAngVel = 0; 
    }
    else if(flipLeftAngle < 0){ //if flipper opened
      flipLeftAngVel = 10;
      simulateL(flipLeftAngVel,dt);
    }
    else if(flipLeftAngle > 0){ //reset if goes past by a little
      flipLeftAngle = 0;
      flipLeftAngVel = 0; //no velocity when still
    }
    flipperL.x2 = 50*cos(flipLeftAngle) - 10*sin(flipLeftAngle) + 175;
    flipperL.y2 = 50*sin(flipLeftAngle) + 10*cos(flipLeftAngle) + 670;
  }
  if(rightPressed) {
    if(flipRightAngle == PI/5){
      flipRightAngVel = 0;
    }
    else {
      flipRightAngVel = 8;
    }
    simulateR(flipRightAngVel,dt); 
    flipperR.x2 = -50*cos(flipRightAngle) - 10*sin(flipRightAngle) + 325; //translate origin to flip start, calculate rotation around it, translate back
    flipperR.y2 = -50*sin(flipRightAngle) + 10*cos(flipRightAngle) + 670;
    
  }
  else if (!rightPressed){ //reset flipper position
      if(flipRightAngle == 0){
         flipRightAngVel = 0; 
      }
      else if(flipRightAngle > 0){ //if flipper opened
        flipRightAngVel = -10;
        simulateR(flipRightAngVel,dt);
      }
      else if(flipRightAngle < 0){ //reset if goes past by a little
        flipRightAngle = 0;
        flipRightAngVel = 0;
      }
      flipperR.x2 = -50*cos(flipRightAngle) - 10*sin(flipRightAngle) + 325; //translate origin to flip start, calculate rotation around it, translate back
      flipperR.y2 = -50*sin(flipRightAngle) + 10*cos(flipRightAngle) + 670;
  }
  
  // Update ball positions
  for (int i = 0; i < numBalls; i++){
    if(pos[i].y > 720 ){ //check if below flippers -END GAME CONDITION
      vel[i] = new Vec2(vel[i].x/1.01,vel[i].y/1.05);
      endCounter[i] = 1;
    }
    else if(mass[i] == 0){ //stuck -END GAME CONDITION
      endCounter[i] = 1; 
    }
    Vec2 ma = gravity.times(mass[i]); //Account for mass in gravity force; F = ma
    vel[i].add(ma.times(dt)); //gravity added
    vel[i].x = clamp(vel[i].x,-maxVel/2,maxVel/2); //clamp velocities
    vel[i].y = clamp(vel[i].y,-maxVel,maxVel);
    pos[i].add(vel[i].times(dt));
    pinballs[i].pos = pos[i]; //update my pinball list position
    
    if(mass[i] == newMass){ //change color when mass reduced
      colorID[i] = 1;
    }
    else {
      colorID[i] = 0;
    }
    // Ball-Wall Collision (account for radius)
    if (pos[i].x < radius[i]){
      pos[i].x = radius[i];
      pinballs[i].pos.x = pos[i].x;
      vel[i].x *= -cor;
    }
    if (pos[i].x > width - radius[i]){
      pos[i].x = width - radius[i];
      pinballs[i].pos.x = pos[i].x;
      vel[i].x *= -cor;
    }
    if (pos[i].y < radius[i]){
      pos[i].y = radius[i];
      pinballs[i].pos.y = pos[i].y;
      vel[i].y *= -cor;
    }
    if (pos[i].y > height - radius[i]){
      pos[i].y = height - radius[i];
      pinballs[i].pos.y = pos[i].y;
      vel[i].y *= -cor;
    }

    
    // Ball-Ball Collision
    for (int j = i + 1; j < numBalls; j++){
      Vec2 delta = pos[i].minus(pos[j]);
      float dist = delta.length();
      if (dist < radius[i] + radius[j]){
        // Move balls out of collision
        float overlap = 0.5f * (dist - radius[i] - radius[j]);
        pos[i].subtract(delta.normalized().times(overlap));
        pinballs[i].pos = pos[i];
        
        pos[j].add(delta.normalized().times(overlap));
        pinballs[j].pos = pos[j];
        // Collision
        Vec2 dir = delta.normalized();
        float v1 = dot(vel[i], dir);
        float v2 = dot(vel[j], dir);
        float m1 = mass[i];
        float m2 = mass[j];
        // Pseudo-code for collision response
        float new_v1,new_v2;
        
        if(m1 == 0){ //stuck to purple box case
           new_v1 = 0;
           new_v2 = -v2* cor;
           vel[i] = vel[i].times(new_v1);
           vel[j].add(dir.times((new_v2 - v2))); 
        }
        if(m2 == 0){ //stuck to purple box case
          new_v2 = 0;
          new_v1 = -v1 * cor;
          vel[j] = vel[j].times(new_v2);
          vel[i].add(dir.times((new_v1 - v1))); 
        }
        else{
          new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
          new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
          vel[i].add(dir.times((new_v1 - v1))); //# Add the change in velocity along the collision axis
          vel[j].add(dir.times((new_v2 - v2))); //
        }
        
      }
    }
   //pinball and box collision , no score for boxes at bottom
    for(int h = 0; h < boxObjects.length; h++){
      if(CircleBoxCollision(pinballs[i],boxObjects[h])){ //collide box object
        Vec2 closestPoint = new Vec2(
           clamp(pinballs[i].pos.x,boxObjects[h].x - boxObjects[h].w/2, boxObjects[h].x + boxObjects[h].w/2),
           clamp(pinballs[i].pos.y, boxObjects[h].y - boxObjects[h].h/2, boxObjects[h].y + boxObjects[h].h/2));
        Vec2 dir = pinballs[i].pos.minus(closestPoint);
        float dist = dir.length();
        if(dist > radius[i]){ //to far
          return;
        }
          dir.normalize();
          pinballs[i].pos = closestPoint.plus(dir.times(radius[i]));
          pos[i] = closestPoint.plus(dir.times(radius[i]));
          float v1 = dot(vel[i],dir);
          float v2 = dot(obstacleVel,dir);
          float new_v1 = v2 -(v1 - v2) * cor;
          vel[i].add(dir.times(new_v1 - v1));
          if(h == 4 || h == 5){
            vel[i] = new Vec2(0,0);
            mass[i] = 0;
          }
          if(h == 0) { //mass changer brown rectangle, + 10 score for brown rec.
            mass[i] = newMass; 
            score += 10;
          }
       }
    }
      
    //Ball-flipper collision //left flipper first
    if(CircleLineCollision(pinballs[i], flipperL)){
      Vec2 tip = new Vec2(flipperL.x2,flipperL.y2);
      Vec2 flipperPos = new Vec2(flipperL.x1,flipperL.y1);
      Vec2 dir = tip.minus(flipperPos);
      Vec2 dnorm = dir.normalized();
      float proj = dot(pos[i].minus(flipperPos),dnorm);
      Vec2 closest = new Vec2(0,0);
      if(proj < 0) {
         closest = flipperPos;
      }
      else if(proj > dir.length()){
         closest = tip;
      }
      else {
         closest = flipperPos.plus(dnorm.times(proj));
      }
      dir = pos[i].minus(closest);
      dir.normalize();
      pinballs[i].pos = closest.plus(dir.times(pinballs[i].radius)); //update my list of circle objects
      pos[i] = closest.plus(dir.times(pinballs[i].radius));
      
      Vec2 radius = closest.minus(flipperPos);
      Vec2 r_perp = new Vec2(-radius.y,radius.x);
      Vec2 surfaceVel = r_perp.times(flipLeftAngVel);
      
      float vball = dot(vel[i],dir);
      float vflip = dot(surfaceVel, dir);
      float m1 = mass[i];
      float new_vel = (m1*vball + flipMass*vflip - flipMass * (vball - vflip)*cor) / (m1 + flipMass);
      vel[i] = vel[i].plus(dir.times(new_vel - vball));
    }
    if(CircleLineCollision(pinballs[i], flipperR)){ //right flipper now
      Vec2 tip = new Vec2(flipperR.x2,flipperR.y2);
      Vec2 flipperPos = new Vec2(flipperR.x1,flipperR.y1);
      Vec2 dir = tip.minus(flipperPos);
      Vec2 dnorm = dir.normalized();
      float proj = dot(pos[i].minus(flipperPos),dnorm);
      Vec2 closest = new Vec2(0,0);
      if(proj < 0) {
         closest = flipperPos;
      }
      else if(proj > dir.length()){
         closest = tip;
      }
      else {
         closest = flipperPos.plus(dnorm.times(proj));
      }
      dir = pos[i].minus(closest);
      dir.normalize();
      pinballs[i].pos = closest.plus(dir.times(pinballs[i].radius)); //update my list of circle objects
      pos[i] = closest.plus(dir.times(pinballs[i].radius));
      
      Vec2 radius = closest.minus(flipperPos);
      Vec2 r_perp = new Vec2(-radius.y,radius.x);
      Vec2 surfaceVel = r_perp.times(flipRightAngVel);
      float vball = dot(vel[i],dir);
      float vflip = dot(surfaceVel, dir);
      float m1 = mass[i];
      float new_vel = (m1*vball + flipMass*vflip - flipMass * (vball - vflip)*cor) / (m1 + flipMass);
      vel[i] = vel[i].plus(dir.times(new_vel - vball));
      
    }
    if(CircleLineCollision(pinballs[i], lineLeft)){ //left line collision
      Vec2 tip = new Vec2(lineLeft.x2,lineLeft.y2);
      Vec2 lineLeftPos = new Vec2(lineLeft.x1,lineLeft.y1);
      Vec2 dir = tip.minus(lineLeftPos);
      Vec2 dnorm = dir.normalized();
      float proj = dot(pos[i].minus(lineLeftPos),dnorm);
      Vec2 closest = new Vec2(0,0);
      if(proj < 0) {
         closest = lineLeftPos;
      }
      else if(proj > dir.length()){
         closest = tip;
      }
      else {
         closest = lineLeftPos.plus(dnorm.times(proj));
      }
      dir = pos[i].minus(closest);
      dir.normalize();
      pinballs[i].pos = closest.plus(dir.times(pinballs[i].radius)); //update my list of circle objects
      pos[i] = closest.plus(dir.times(pinballs[i].radius));
      
      float vball = dot(vel[i],dir);
      float vline = dot(obstacleVel, dir);
      float new_vel = vline -(vball - vline) * cor;
      vel[i] = vel[i].plus(dir.times(new_vel - vball));
    }
    if(CircleLineCollision(pinballs[i], lineRight)){ //left line collision
      Vec2 tip = new Vec2(lineRight.x2,lineRight.y2);
      Vec2 lineRightPos = new Vec2(lineRight.x1,lineRight.y1);
      Vec2 dir = tip.minus(lineRightPos);
      Vec2 dnorm = dir.normalized();
      float proj = dot(pos[i].minus(lineRightPos),dnorm);
      Vec2 closest = new Vec2(0,0);
      if(proj < 0) {
         closest = lineRightPos;
      }
      else if(proj > dir.length()){
         closest = tip;
      }
      else {
         closest = lineRightPos.plus(dnorm.times(proj));
      }
      dir = pos[i].minus(closest);
      dir.normalize();
      pinballs[i].pos = closest.plus(dir.times(pinballs[i].radius)); //update my list of circle objects
      pos[i] = closest.plus(dir.times(pinballs[i].radius));
      
      float vball = dot(vel[i],dir);
      float vline = dot(obstacleVel, dir);
      //float m1 = mass[i];
      float new_vel = vline -(vball - vline) * cor;
      //float new_vel = (m1*vball + flipMass*vflip - flipMass * (vball - vflip)*cor) / (m1 + flipMass);
      vel[i] = vel[i].plus(dir.times(new_vel - vball));
    }
    
    // Ball-Obstacle Collision
    for(int k = 0; k < circleObjects.length; k++){ //per circle obstacle, + 20 score
      
      Vec2 delta = pos[i].minus(circleObjects[k].pos);
      float dist = delta.length();
      float overlap = dist - radius[i] - circleObjects[k].radius;
      if (overlap <= 0){
        score += 20;
        changeObjColor(k);
        
        ding.play(); //play ding sound on ball circle-obj collision
        pos[i].subtract(delta.normalized().times(overlap));
        pinballs[i].pos = pos[i];
        Vec2 dir = delta.normalized();
        float v1 = dot(vel[i], dir);
        float v2 = dot(obstacleVel, dir); //#5
        float new_v1 = v2 - (v1 - v2) * cor; //Compute the correct new_v1 assuming infinite mass obstacle
        vel[i].add(dir.times(new_v1 - v1)); // Add the change in velocity along the collision axis
        mass[i] = origMass;
      }
    }
  }
}

boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed;
void keyPressed(){
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == UP) upPressed = true; 
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == SHIFT) shiftPressed = true;
  if (keyCode == ' ') paused = !paused;
}

void keyReleased(){
  // reset if 'r' if pressed
  if (key == 'r'){
    resetBalls();
    dropBalls();
    paused = true;
  }
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == UP) upPressed = false; 
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
}
boolean paused = true;
void draw(){
  background(img); //set
  if (paused == false) {updatePhysics(1.0/(frameRate*3));
  updatePhysics(1.0/(frameRate*3));
  updatePhysics(1.0/(frameRate*3));
  }
  int count =0;
  for(int i = 0; i<10; i++){
    count += endCounter[i];
  }
  if(count == 10){ //CHECK GAME OVER (Here because need to draw over obstacles and bg)
      paused = !paused;
      fill(150,150,150);
      textFont(endF);
      textAlign(CENTER);
      text("GAME\nOVER",250,250); 
      textFont(f);
      textAlign(CENTER);
      text("SCORE: "+ str(score),250,500);
  }
  else {
    
  fill(255, 0, 0); //balls red
  stroke(0,0,0);
  for (int i = 0; i < numBalls; i++) {
      if(colorID[i] == 1){ //collided with box
        fill(110,250,250); // turn cyan
      }
      else {
        fill(255,0,0); //default red  
      }
      ellipse(pos[i].x, pos[i].y, radius[i] * 2, radius[i] * 2);
  }
  
  fill(100,0,100);
  rectMode(CENTER);
  rect(250,20,500,40); //scoreboard
  fill(230,230,230);
  textFont(f);
  textAlign(LEFT);
  text("SCORE: "+ str(score),0,30);
  // draw the circle obstacles
  fill(cirColor1);
  ellipse(circleObjects[0].pos.x, circleObjects[0].pos.y, circObjRadius1 * 2, circObjRadius1 * 2);
  fill(cirColor2);
  ellipse(circleObjects[1].pos.x, circleObjects[1].pos.y, circObjRadius2 * 2, circObjRadius2 * 2);
  fill(cirColor3);
  ellipse(circleObjects[2].pos.x, circleObjects[2].pos.y, circObjRadius3 * 2, circObjRadius3 * 2);
  fill(cirColor4);
  ellipse(circleObjects[3].pos.x, circleObjects[3].pos.y, circObjRadius4 * 2, circObjRadius4 * 2);
  fill(cirColor5);
  ellipse(circleObjects[4].pos.x, circleObjects[4].pos.y, circObjRadius5 * 2, circObjRadius5 * 2);
  fill(cirColor6);
  ellipse(circleObjects[5].pos.x, circleObjects[5].pos.y, circObjRadius6 * 2, circObjRadius6 * 2);
  
  
  //draw boxes
  fill(rectColor);
  rectMode(CENTER);
  rect(b1.x,b1.y,b1.w,b1.h); //rectangle
  fill(255,150,100);
  rect(b2.x,b2.y,b2.w,b2.h); //presents,left to right
  fill(10,200,150);
  rect(b3.x,b3.y,b3.w,b3.h);
  fill(175,150,170);
  rect(b4.x,b4.y,b4.w,b4.h);
  
  fill(150,0,150);
  rect(b5.x,b5.y,b5.w,b5.h);
  fill(150,0,150);
  rect(b6.x,b6.y,b6.w,b6.h);
   
  //DRAW FLIPPER ARMS //2nd point is the tip
  stroke(0,125,0);
  strokeWeight(4); //add to pinball radius when testing line to account for thickness?
  line(0,600,175,670);  //left
  line(500,600,325,670); //right
  strokeWeight(1);
  
  //DRAW FLIPPERS //LEFT THEN RIGHT // TIP is 2nd point
  pushMatrix(); 
  translate(175,670);
  rotate(flipLeftAngle);
  stroke(0,225,0);
  strokeWeight(5);
  line(0,0,50,10); //left to right, flippers +620\\\\
  translate(0,0);
  popMatrix();
  
  pushMatrix();
  translate(325,670);
  rotate(flipRightAngle); //apply angular rotation
  stroke(0,225,0);
  strokeWeight(5);
  line(0,0,-50,10);
  translate(0,0);
  popMatrix();
  strokeWeight(1);
  
  }
}

//COLLISION FUNCTIONS, OBJECT CLASSES, VEC2 LIB --------------------------
boolean CircleCircleCollision(Circle c1, Circle c2){ 
  
  float dist = c1.pos.distanceTo(c2.pos);
  if(dist <= (c1.radius + c2.radius)){
    return true;
  }
  return false;
}

boolean BoxBoxCollision(Box b1, Box b2){
  if(abs(b1.x - b2.x) > (b1.w + b2.w)/2){ 
    return false;
  }
  if(abs(b1.y - b2.y) > (b1.h + b2.h)/2){
    return false;
  }
  return true;
}

boolean CircleLineCollision(Circle c1, Line l1){
  float[] dataList = {0,-1,-1}; //first index 1 for collision, next 2 are x,y position of collision
  float a,b,c, discriminant,t1,t2;
  float LineLength =  sqrt(pow(l1.x2-l1.x1,2) + pow(l1.y2-l1.y1,2)); //l1.p1.distanceTo(l1.p2);
  Vec2 StartMinusCenter = new Vec2(l1.x1 - c1.pos.x, l1.y1 - c1.pos.y); //start to center vect.
  Vec2 direction = new Vec2(l1.x2 - l1.x1, l1.y2 - l1.y1);
  Vec2 EndMinusCenter = new Vec2(l1.x2 - c1.pos.x, l1.y2 - c1.pos.y); //P0 - C
  direction.normalize(); //normalize resulting direction vector
  
  a = pow(direction.x,2) + pow(direction.y,2); //should equal 1 since normalized
  b = 2 * dot(direction,StartMinusCenter);
  c = pow(StartMinusCenter.x,2) + pow(StartMinusCenter.y,2) - pow(c1.radius,2);
  discriminant = pow(b,2) - (4*a*c);
  
  if(discriminant < 0){ //negative discriminant, no intersection (undefined)
    return false;
  }
  else { //two possible t solutions
    t1 = (-1*b + sqrt(discriminant)) / (2*a);
    t2 = (-1*b - sqrt(discriminant)) / (2*a);
    //float closestInt = 0;
    if((t1 < 0) && (t2 < 0)){ //both negative
      return false;
    }
    else if(pow(EndMinusCenter.x,2) + pow(EndMinusCenter.y,2) <= pow(c1.radius,2)){ //end point on or inside circle (YES)
      dataList[0] = 1;
      
      float int_x = l1.x2; //end point
      float int_y = l1.y2;
      dataList[1] = int_x;
      dataList[2] = int_y;
      return true;
    }
    else if(pow(StartMinusCenter.x,2) + pow(StartMinusCenter.y,2) <= pow(c1.radius,2)){ //start point on or inside circle (YES)
      dataList[0] = 1;
      float int_x = l1.x1; //start point
      float int_y = l1.y1;
      dataList[1] = int_x;
      dataList[2] = int_y;
      return true;
    }
    else if(( t1 >= LineLength) && (t2 >= LineLength)){ //both (ray)intersections past line length(not on line segment) (NONE)
      return false;
    }
    else if((t1 < LineLength)){ //interesect
      dataList[0] = 1;
      return true;
    }
    else if((t2 < LineLength)){ //interesect
      dataList[0] = 1;
      return true;
    }
    else { //NONE
      return false;  
    }
  }
}

boolean CircleBoxCollision(Circle c1, Box b1){
  Vec2 closestPoint = new Vec2(
     clamp(c1.pos.x, b1.x - b1.w/2, b1.x + b1.w/2),
    clamp(c1.pos.y, b1.y - b1.h/2, b1.y + b1.h/2));
    
  return (c1.pos.distanceTo(closestPoint) <= c1.radius); //inclusive if on edge
}

boolean SameSide(Line l1, float x1, float y1, float x2, float y2){
  float cross1 = cross(l1.x2 - l1.x1, l1.y2 - l1.y1, x1 - l1.x1, y1 - l1.y1);
  float cross2 = cross(l1.x2 - l1.x1, l1.y2 - l1.y1, x2 - l1.x1, y2 - l1.y1);
  if(cross1*cross2 > 0){ //same sign means same side (same sign mult is non-neg)
    return true;
  }
  return false;
}

boolean LineLineCollision(Line l1, Line l2){
  if(SameSide(l1,l2.x1,l2.y1,l2.x2, l2.y2)){ return false; } //same side, no intersection
  if(SameSide(l2, l1.x1, l1.y1, l1.x2, l1.y2)){ return false; }
  
  return true; //else
}

//LineBox variables
float x1,x2,y1,y2;
Line bl1,bl2,bl3,bl4;

boolean LineBoxCollision(Line l1, Box b1){
   x1 = b1.x - (b1.w / 2); //left x
   x2 = b1.x + (b1.w / 2); //right x
   y1 = b1.y - (b1.h / 2); //bottom y
   y2 = b1.y + (b1.h / 2); //top x
   bl1 = new Line(x1,y1,x2,y1); //create box lines
   bl2 = new Line(x2,y1,x1,y2);
   bl3 = new Line(x1,y2,x2,y2);
   bl4 = new Line(x2,y2,x1,y1);
  
  return LineLineCollision(l1,bl1) || LineLineCollision(l1,bl2) || LineLineCollision(l1,bl3) || LineLineCollision(l1,bl4);
}

int[] returnCollisions(Circle[] clist, Box[] blist, Line[] llist){ //gather collisions from objects lists
  int numObj = clist.length + llist.length + blist.length;
  int numCollisions = 0; //total collision counter
     
  int[] colList = new int[numObj]; //set to be able to hold TOTAL number of objects
     int indx = 0; //index in ID list
       for(int v = 0; v < clist.length; v++){
         if(clist[v].collide == 1){
           colList[indx] = clist[v].id;
           numCollisions++;
           indx++;
         }
         
       }
       for(int e = 0; e < llist.length; e++){
         if(llist[e].collide == 1){
           colList[indx] = llist[e].id;
           numCollisions++;
           indx++;
         }
       }
       for(int r = 0; r < blist.length; r++){
         if(blist[r].collide == 1){
           colList[indx] = blist[r].id;
           numCollisions++;
           indx++;
         }
       }
  int[] flushIdList = new int[numCollisions]; //completely full list of collisions
  for(int i =0; i< numCollisions; i++){
    flushIdList[i] = colList[i];
  }
  return flushIdList;
}

//Class to hold Circle data
public class Circle {
  //public float[] data = new float[3]; //x,y,r
  public Vec2 pos; //center point x and y
  public float radius;
  public int id = -1;
  public int collide = 0; //set to 1 for collision
  
  public Circle(Vec2 pos, float r){//constructor
    this.pos = pos;
    this.radius = r;
  }
}
//Line class to hold data
public class Line {
  float x1,y1,x2,y2;
  //public Vec2 p1,p2; //p1 start p2 end coords
  public int id = -1;
  public int collide = 0; //set to 1 for collision
  
  public Line(float x1, float y1, float x2, float y2){//constructor
    this.x1 = x1;
    this.x2 = x2;
    this.y1 = y1;
    this.y2 = y2;
  }
}
//Box class to hold box data
public class Box {
//public Vec2 pos; //center point x and y
  public float x,y,w,h;
  public int id = -1;
  public int collide = 0; //set to 1 for collision
  
  public Box(float x, float y, float w, float h){ //constructor
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}

public float clamp(float value, float min, float max){ //value clamp function
  if(value < min){
    return min;
  }
  else if(value > max){
    return max;
  }
  return value;
}

public float cross(float x1, float y1, float x2, float y2){
  return (x1*y2 - y1*x2); //ad - bc : (x1,y1) & (x2,y2) == (a,b) & (c,d)
}

//2DVector library based from Prof. Guy's version
public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public String toString(){
    return "(" + x+ "," + y +")";
  }
  
  public float length(){
   if((x==0) && (y==0)){
      return 0;
    }
    else {
      return sqrt(x*x+y*y);
    }
  }
  
  
  public Vec2 plus(Vec2 rhs){
    return new Vec2(x+rhs.x, y+rhs.y);
  }
  
  public void add(Vec2 rhs){
    x += rhs.x;
    y += rhs.y;
  }
  
  public Vec2 minus(Vec2 rhs){
    return new Vec2(x-rhs.x, y-rhs.y);
  }
  
  public void subtract(Vec2 rhs){
    x -= rhs.x;
    y -= rhs.y;
  }
  
  public Vec2 times(float rhs){
    return new Vec2(x*rhs, y*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
  }
  
  public void clampToLength(float maxL){
    if((x==0) && (y==0)){
     return;
    }
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }
  
  
  public void setToLength(float newL){
    if((x==0) && (y==0)){
     return;
    }
    float magnitude = sqrt(x*x + y*y);
    x *= newL/magnitude;
    y *= newL/magnitude;
  }
  
  public void normalize(){
    if((x == 0) && (y == 0)){
      return;
    }
    else {
      float magnitude = sqrt(x*x + y*y);
      x /= magnitude;
      y /= magnitude;
    }
  }
  
  public Vec2 normalized(){
    if((x == 0) && (y == 0)){
      return new Vec2(0,0);
    }
    float magnitude = sqrt(x*x + y*y);
    return new Vec2(x/magnitude, y/magnitude);
  }
  
  public float distanceTo(Vec2 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    if((dx == 0) && (dy == 0)){
      return 0;
    }
    return sqrt(dx*dx + dy*dy);
  }
}

Vec2 interpolate(Vec2 a, Vec2 b, float t){
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b){
  return a.x*b.x + a.y*b.y;
}
float vecCross(Vec2 a, Vec2 b){
  return (a.x*b.y - a.y*b.x); //ad - bc
}
Vec2 projAB(Vec2 a, Vec2 b){
  return b.times(a.x*b.x + a.y*b.y);
}
