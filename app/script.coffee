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

    ###
    cylinders = [
        new Cylinder { processing: processing, location: new Vector(processing.width / 2 + 50, processing.height / 2) }
        new Cylinder { processing: processing, radius: 10, location: new Vector(processing.width / 2 - 100, processing.height / 2 - 20)}
    ]
    ###
    cylinders = []

    processing.draw = ->
        processing.background 255

        for cylinder in cylinders
            cylinder.render()
        
        for boid in boids
            boid.step(boids, cylinders)
            boid.render()

        return true

canvas = $('<canvas width="855" height="500">').appendTo($ '#flocking-demo')[0]
processingInstance = new Processing(canvas, flock)