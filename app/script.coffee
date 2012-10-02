window.SEPARATION_WEIGHT = 2
window.ALIGNMENT_WEIGHT = 3
window.COHESION_WEIGHT = 0.01
window.MAX_SPEED = 2
window.NEIGHBOUR_RADIUS = 60
window.MAX_FORCE = 0.05
window.DESIRED_SEPARATION = 25
window.AVOIDANCE_WEIGHT = 9
window.BOID_VISION = 400
window.OBJECT_RADIUS_EXCESS = 10
window.SWERVE_WEIGHT = 30

flock = (processing) ->
    processing.width = 855
    processing.height = 500
    start = new Vector processing.width/2, processing.height/2

    boidSpawnLoc = new Vector Math.random()*processing.width, Math.random()*processing.height

    boids = for i in [1..100] #[new Boid { processing: processing }]
        new Boid
            processing: processing
            location: boidSpawnLoc.copy()

    cylinders = for i in [1..4]
        new Cylinder { processing: processing}

    if cylinders.length
        cylinders[0].mainBoid = boids[0]

    processing.draw = ->
        processing.background 255

        for cylinder in cylinders
            cylinder.render()
        
        for boid in boids
            boid.step(boids, cylinders)
            boid.render()

        ###

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
        ###
        
        return true

canvas = $('<canvas width="855" height="500">').appendTo($ '#flocking-demo')[0]
processingInstance = new Processing(canvas, flock)