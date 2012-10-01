class window.Boid
    processing: null
    
    radius: 5 # "radius" of the triangle.

    location: null
    velocity: null

    constructor: (options = {}) ->
        throw "A processing instance needs to be defined." if not options.processing?

        @processing = options.processing
        @location   = options.location || new Vector @processing.width/2, @processing.height/2
        @velocity   = options.velocity || new Vector(Math.random()*2 - 1, Math.random()*2 - 1)

    step: (neighbours, cylinders)->
        acceleration = @flock(neighbours, cylinders)
        @velocity.add(acceleration).limit(MAX_SPEED)
        @location.add(@velocity)
        @_wrapIfNeeded()

    _wrapIfNeeded: () ->
        minX = -@radius * 2
        minY = -@radius * 2

        maxX = @processing.width + @radius * 2
        maxY = @processing.height + @radius * 2

        if @location.x > maxX
            @location.x = minX

        if @location.y > maxY
            @location.y = minY

        if @location.x < minX
            @location.x = maxX

        if @location.y < minY
            @location.y = maxY

    separate: (neighbours) ->
        mean = new Vector
        count = 0

        for boid in neighbours
            distance = @location.distance(boid.location)
            if distance > 0 and distance < DESIRED_SEPARATION
                mean.add Vector.subtract(@location, boid.location).normalize().divide(distance)
                count++

        mean.divide(count) if count > 0
        return mean

    align: (neighbours) ->
        mean = new Vector
        count = 0

        for boid in neighbours
            distance = @location.distance(boid.location)
            if distance > 0 and distance < NEIGHBOUR_RADIUS
                mean.add(boid.velocity)
                count++

            mean.divide(count) if count > 0
            mean.limit(MAX_FORCE)

        return mean

    cohere: (neighbours) ->
        sum = new Vector
        count = 0

        for boid in neighbours
            distance = @location.distance(boid.location)
            if distance > 0 and distance < NEIGHBOUR_RADIUS
                sum.add(boid.location)
                count++

        if count > 0
            return @steer_to sum.divide(count)

        return sum

    steer_to: (target) ->
        desired = Vector.subtract(target, @location)
        distance = desired.magnitude()
        steer = new Vector

        if distance > 0
            desired.normalize()

            if distance < 100
                desired.multiply(MAX_SPEED*(distance/100.0))
            else
                desired.multiply(MAX_SPEED)

            steer = desired.subtract(@velocity)
            steer.limit(MAX_FORCE)

        return steer

    avoidCollision: (cylinders) ->
        mean = new Vector
        count = 0

        for cylinder in cylinders
            distance = @location.distance(cylinder.location)
            if distance > 0 and distance < DESIRED_SEPARATION + cylinder.radius*4
                mean.add Vector.subtract(@location, cylinder.location).normalize().divide(distance*2)
                count++

        mean.divide(count) if count > 0
        return mean

    avoidWalls: ->
        mean = new Vector
        count = 0
        walls = [
            new Vector 0, @location.y
            new Vector @processing.width, @location.y

            new Vector @location.x, 0
            new Vector @location.x, @processing.height
        ]

        for wall in walls
            distance = @location.distance(wall)
            if distance > 0 and distance < DESIRED_SEPARATION
                mean.add Vector.subtract(@location, wall).normalize().divide(distance*2)
                count++

        mean.divide(count) if count > 0
        return mean

    flock: (neighbours, cylinders) ->
        separation     = @separate(neighbours).multiply(SEPARATION_WEIGHT)
        alignment      = @align(neighbours).multiply(ALIGNMENT_WEIGHT)
        cohesion       = @cohere(neighbours).multiply(COHESION_WEIGHT)
        #avoidCollision = @avoidCollision(cylinders).multiply(AVOIDANCE_WEIGHT)
        #avoidWalls     = @avoidWalls().multiply(AVOIDANCE_WEIGHT)
        #return separation.add(alignment).add(cohesion).add(avoidCollision).add(avoidWalls);
        return separation.add(alignment).add(cohesion);
        #return @velocity

    render: ->
        theta = @velocity.heading() + @processing.radians 90
        @processing.fill(70)
        @processing.stroke(0, 0, 255)
        @processing.pushMatrix()
        @processing.translate(@location.x, @location.y)
        @processing.rotate(theta)
        @processing.beginShape(@processing.TRIANGLES)
        @processing.vertex(0, -1 * @radius * 2)
        @processing.vertex(-1 * @radius, @radius *2)
        @processing.vertex(@radius, @radius * 2)
        @processing.endShape()
        @processing.popMatrix()