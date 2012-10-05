(function() {
  var canvas, flock, processingInstance;

  window.SEPARATION_WEIGHT = 2;

  window.ALIGNMENT_WEIGHT = 1;

  window.COHESION_WEIGHT = 0.01;

  window.MAX_SPEED = 2;

  window.NEIGHBOUR_RADIUS = 60;

  window.MAX_FORCE = 0.05;

  window.DESIRED_SEPARATION = 25;

  window.AVOIDANCE_WEIGHT = 100;

  window.BOID_VISION = 400;

  window.OBJECT_RADIUS_EXCESS = 60;

  window.SWERVE_WEIGHT = 1;

  window.WAYPOINT_WEIGHT = 0.1;

  flock = function(processing) {
    var boidSpawnLoc, boids, cylinders, i, start;
    processing.width = 855;
    processing.height = 500;
    start = new Vector(processing.width / 2, processing.height / 2);
    boidSpawnLoc = new Vector(Math.random() * processing.width, Math.random() * processing.height);
    boids = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 1; _i <= 100; i = ++_i) {
        _results.push(new Boid({
          processing: processing,
          location: boidSpawnLoc.copy()
        }));
      }
      return _results;
    })();
    cylinders = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 1; _i <= 1; i = ++_i) {
        _results.push(new Cylinder({
          radius: 20,
          processing: processing,
          location: new Vector(processing.width / 2, processing.height / 2)
        }));
      }
      return _results;
    })();
    if (cylinders.length) {
      cylinders[0].mainBoid = boids[0];
    }
    return processing.draw = function() {
      var boid, cylinder, _i, _j, _len, _len1;
      processing.background(255);
      for (_i = 0, _len = cylinders.length; _i < _len; _i++) {
        cylinder = cylinders[_i];
        cylinder.render();
      }
      for (_j = 0, _len1 = boids.length; _j < _len1; _j++) {
        boid = boids[_j];
        boid.step(boids, cylinders);
        boid.render();
      }
      /*
              firstBoid = boids[0]
              normalizedVel = firstBoid.velocity.copy().normalize()
              boidLine = new Line(
                  new Vector firstBoid.location.x, firstBoid.location.y
                  new Vector firstBoid.location.x + normalizedVel.x*BOID_VISION, firstBoid.location.y + normalizedVel.y*BOID_VISION
              )
              processing.line(boidLine.p1.x, boidLine.p1.y, boidLine.p2.x, boidLine.p2.y)
              processing.stroke(0, 0, 0)
              
              firstCylinder = cylinders[0]
              perpTheta = -Math.atan2(-firstBoid.velocity.y, firstBoid.velocity.x) - Math.PI/2
              cylinderLine1 = new Line(
                  new Vector firstCylinder.location.x, firstCylinder.location.y
                  new Vector firstCylinder.location.x + Math.cos(perpTheta)*(firstCylinder.radius+OBJECT_RADIUS_EXCESS), firstCylinder.location.y + Math.sin(perpTheta)*(firstCylinder.radius+OBJECT_RADIUS_EXCESS)
              )
              perpTheta = -Math.atan2(-firstBoid.velocity.y, firstBoid.velocity.x) + Math.PI/2
              cylinderLine2 = new Line(
                  new Vector firstCylinder.location.x, firstCylinder.location.y
                  new Vector firstCylinder.location.x + Math.cos(perpTheta)*(firstCylinder.radius+OBJECT_RADIUS_EXCESS), firstCylinder.location.y + Math.sin(perpTheta)*(firstCylinder.radius+OBJECT_RADIUS_EXCESS)
              )
              processing.line(cylinderLine1.p1.x, cylinderLine1.p1.y, cylinderLine1.p2.x, cylinderLine1.p2.y)
              processing.line(cylinderLine2.p1.x, cylinderLine2.p1.y, cylinderLine2.p2.x, cylinderLine2.p2.y)
              processing.stroke(0, 0, 0)
      
              intersects = boidLine.intersects(cylinderLine1)
              intersects = intersects || boidLine.intersects(cylinderLine2)
      
              font = processing.loadFont("Arial")
              processing.textFont(font)
              processing.text("Collide: " + intersects.toString(), 20, 20)
              processing.fill(0, 0, 0)
      */

      return true;
    };
  };

  canvas = $('<canvas width="855" height="500">').appendTo($('#flocking-demo'))[0];

  processingInstance = new Processing(canvas, flock);

}).call(this);
