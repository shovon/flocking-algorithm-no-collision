window.SEPARATION_WEIGHT = 1
window.ALIGNMENT_WEIGHT = 1
window.COHESION_WEIGHT = 0.1
window.MAX_SPEED = 2
window.NEIGHBOUR_RADIUS = 40
window.MAX_FORCE = 0.05
window.DESIRED_SEPARATION = 30

flock = (processing) ->
    processing.width = 855
    processing.height = 500
    start = new Vector processing.width/2, processing.height/2

    boids = for i in [0..100] #[new Boid { processing: processing }]
        new Boid { processing: processing }

    processing.draw = ->
        processing.background 255
        for boid, i in boids
            boid.step(boids)
            boid.render()
        return true

canvas = $('<canvas width="855" height="500">').appendTo($ '#flocking-demo')[0]
processingInstance = new Processing(canvas, flock)