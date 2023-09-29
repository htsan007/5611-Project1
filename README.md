# 5611-Project1 Pinball Game

**Project Overview video:**
{% include youtube.html id="IW7sk3QoJFE" %}

---

**Timestamps and List of attempted features:**
----
**Pinball Game:** 0:00 - 1:08

A pinball game was created with working flippers, pause, play and restart functionality. When the game starts, all balls will fall from the top and begin colliding with other objects in the scene. On losing all the given balls, the game will end and show the ending screen with your final score. 

---
**Score Display:** 0:18 - 1:08

The score is displayed at the top during the game, and once again on the end game screen. Pinball to circle-obstacle collision gives 20 points, while pinball to brown-rectangle gives 10. No other obstacles give points.

---
**Circular Obstacles:** 1:19 - 1:49

There are six circle objects that all start out as green.

---
**Reactive Obstacles:** 1:19 - 1:49

The circle objects are reactive and upon collision with pinball will increase in size and turn red. After the collision, the circle will gradually shrink back to the original size and then turn green.

---
**Sound Effects:** 1:28 - 1:37

The circle objects also play a "ding" sound affect with struck by a pinball.

---
**Line-Segment/Polygon Obstacles:** 1:50 - 2:48

There are both boxes and line-segment obstacles. The line-segments take the form of the flippers and its arms, while the box objects appear as obstacles in the scene. 

---
**Multiple Material Types:** 1:51 - 2:48

The box obstacles do have multiple material types. The brown-rectangle reduces the mass of the colliding pinball, and also changes the pinball color to blue. This gives the effect of reduced gravity on the pinball. The pink boxes have a stick property to them, and when a pinball collides with it, it will get stuck to the box for the rest of the game.

---
**Textured Background:** 2:49 - 3:03

The background is textured a festive christmas theme, and matches the layout of the objects that resembles a christmas tree with presents.

---
**Basic Pinball Dynamics:** 3:04 - 3:40

To simulate basic pinball dynamics, a gravitational acceleration was combined with the pinball mass to create a gravitational force, which was then applied to the pinballs velocity. This created a more realistic simulation of a ball falling, as it speeds up over time. Collisions were calculated using the initial velocities and masses of both objects, in order to determine the final velocities and directions that they will bounce off.

---
**Multiple Balls Interacting:** 3:18 - 3:40

There are ten pinballs dropped into the scene when the game starts. Throughout the game they will collide with each other and other obstacles in the scene.

---

Image Captures
---

|Game Start Screen:          | Mid Game Screen:          |Game Over Screen:    | 
|-------------------------|-------------------------|-------------------------------------|
|<img src="./docs/assets/gamestart.JPG" width="200" height="300"> | <img src="./docs/assets/midgame.JPG" width="200" height="300"> |  <img src="./docs/assets/gameover.JPG" width="200" height="300">  |          

---

Difficulties
---

---
***Source code download:*** <a href= "CSCI5611_Project_1.pde" download>Download Game Code</a>

All processing code was written by me. Included in the above file is a collision library, a Vec2 library to handle 2D vectors, object classes to hold obstacle information (Circles,Boxes,Lines), and the code for the pinball game. The Vec2 library was modified from Professor Guy's given version. The processing <a href="https://processing.org/reference/libraries/sound/index.html"> Sound Library </a> was used to implement the sound effects for the game. Other code models and structuring were used from Professor Guy's slides and code examples as a basis for things like implementing gravity, collision detection and calculating new velocity/direction, and flippers. <a href="https://processing.org/reference/"> Processing documentation </a> was also referenced to explore built in functions and their functionalities (Some examples are the PImage and PFont classes for texturing and adding text to the scene). 


---
