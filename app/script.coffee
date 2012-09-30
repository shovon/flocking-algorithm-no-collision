window.SEPARATION_WEIGHT = 2
window.ALIGNMENT_WEIGHT = 2
window.COHESION_WEIGHT = 2
window.MAX_SPEED = 2

flock = (processing) ->
    processing.width = 850
    processing.height = 500
    start = new Vector processing.width/2, processing.height/2

    boids = for i in [0..100] #[new Boid { processing: processing }]
        new Boid { processing: processing }

    processing.draw = ->
        processing.background 255
        for boid, i in boids
            boid.step(boids.slice(0, i).concat(boids.slice(i + 1, boids.length)))
            boid.render()
        return true

canvas = $('<canvas width="855" height="500">').appendTo($ '#flocking-demo')[0]
processingInstance = new Processing(canvas, flock)