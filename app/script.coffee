window.SEPARATION_WEIGHT = 1
window.ALIGNMENT_WEIGHT = 1
window.COHESION_WEIGHT = 0.1
window.MAX_SPEED = 2
window.NEIGHBOUR_RADIUS = 40
window.MAX_FORCE = 0.05
window.DESIRED_SEPARATION = 20
window.AVOIDANCE_WEIGHT = 9

flock = (processing) ->
    processing.width = 855
    processing.height = 500
    start = new Vector processing.width/2, processing.height/2

    boids = for i in [1..100] #[new Boid { processing: processing }]
        new Boid { processing: processing }

    cylinders = [
        new Cylinder { processing: processing, location: new Vector(processing.width / 2 + 50, processing.height / 2) }
        #new Cylinder { processing: processing, radius: 10, location: new Vector(processing.width / 2 - 100, processing.height / 2 - 20)}
    ]
    #cylinders = []

    if cylinders.length
        cylinders[0].mainBoid = boids[0]

    processing.draw = ->
        processing.background 255



        for cylinder in cylinders
            cylinder.render()
        
        for boid in boids
            boid.step(boids, cylinders)
            boid.render()


        firstBoid = boids[0]
        normalizedVel = firstBoid.velocity.copy().normalize()
        boidLineP1 = new Vector firstBoid.location.x, firstBoid.location.y
        boidLineP2 = new Vector firstBoid.location.x + normalizedVel.x*200, firstBoid.location.y + normalizedVel.y*200
        processing.line(boidLineP1.x, boidLineP1.y, boidLineP2.x, boidLineP2.y)
        processing.stroke(0)
        
        firstCylinder = cylinders[0]
        perpTheta = Math.atan2(-firstBoid.velocity.x, firstBoid.velocity.y)
        cylinderLineP1 = new Vector firstCylinder.location.x, firstCylinder.location.y
        cylinderLineP2 = new Vector firstCylinder.location.x + Math.cos(perpTheta)*200, firstCylinder.location.y + Math.sin(perpTheta)*200
        processing.line(cylinderLineP1.x, cylinderLineP1.y, cylinderLineP2.x, cylinderLineP2.y)

        
        
        processing.stroke(0, 0, 0)
        font = processing.loadFont("Arial")
        processing.textFont(font)
        processing.text("Collide: false", 20, 20)
        processing.fill(0, 0, 0)
        
        return true

canvas = $('<canvas width="855" height="500">').appendTo($ '#flocking-demo')[0]
processingInstance = new Processing(canvas, flock)