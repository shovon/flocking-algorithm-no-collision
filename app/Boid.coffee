class window.Boid
    processing: null
    
    radius: 5 # "radius" of the triangle.

    location: null
    velocity: null

    constructor: (options = {}) ->
        throw "A processing instance needs to be defined." if not options.processing?

        @processing = options.processing
        @location   = options.location || new Vector @processing.width/2 - 400, @processing.height/2
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

    swerve_to: (target) ->
        desired = Vector.subtract(target, @location)
        distance = desired.magnitude()
        swerve = new Vector

        if distance > 0
            desired.normalize()
            desired.multiply(MAX_SPEED*(1/distance))

            swerve = desired.subtract(@velocity)
            swerve.limit(MAX_FORCE)

        return swerve

    avoidCollision: (cylinders) ->
        mean = new Vector
        count = 0

        for cylinder in cylinders
            distance = @location.distance(cylinder.location)
            if distance > 0 and distance < cylinder.radius + 10 #DESIRED_SEPARATION + cylinder.radius
                mean.add Vector.subtract(@location, cylinder.location).normalize().divide(distance)
                count++

        mean.divide(count) if count > 0
        return mean

    swerveFromObjects: (cylinders) ->
        sum = new Vector
        count = 0

        for cylinder in cylinders
            distance = @location.distance(cylinder.location)
            if distance > 100
                normalizedVel = @velocity.copy().normalize()

                boidLine = new Line(
                    new Vector @location.x, @location.y
                    new Vector @location.x + normalizedVel.x*BOID_VISION, @location.y + normalizedVel.y*BOID_VISION
                )

                # The theta of the circle's perpendicular line.
                perpTheta = -Math.atan2(-@velocity.y, @velocity.x) + Math.PI/2
                line1 = new Line(
                    new Vector cylinder.location.x, cylinder.location.y
                    new Vector cylinder.location.x + Math.cos(perpTheta)*(cylinder.radius+OBJECT_RADIUS_EXCESS), cylinder.location.y + Math.sin(perpTheta)*(cylinder.radius+OBJECT_RADIUS_EXCESS)
                )
                perpTheta = -Math.atan2(-@velocity.y, @velocity.x) - Math.PI/2
                line2 = new Line(
                    new Vector cylinder.location.x, cylinder.location.y
                    new Vector cylinder.location.x + Math.cos(perpTheta)*(cylinder.radius+OBJECT_RADIUS_EXCESS), cylinder.location.y + Math.sin(perpTheta)*(cylinder.radius+OBJECT_RADIUS_EXCESS)
                )

                intersects = boidLine.intersects(line1)
                intersects = intersects || boidLine.intersects(line2)

                if intersects
                    #mean.add Vector.subtract(@location, cylinder.location).normalize().divide(distance/2)
                    
                    desired = new Vector

                    # Try to find the closest extremity
                    if @location.distance(line1.p2) <= @location.distance(line2.p2)
                        sum.add line1.p2
                    else
                        sum.add line2.p2

                    count++

                #@processing.line line1.p1.x, line1.p1.y, line1.p2.x, line1.p2.y
                #@processing.line line2.p1.x, line2.p1.y, line2.p2.x, line2.p2.y

                ###
                @processing.line boidLine.p1.x, boidLine.p1.y, boidLine.p2.x, boidLine.p2.y
                
                font = @processing.loadFont("Arial")
                @processing.textFont(font)
                @processing.text(intersects.toString(), @location.x - 20, @location.y - 20)
                @processing.fill(0, 0, 0)
                ###

        if count > 0
            return @steer_to sum.divide(count)
        
        return sum

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

    toWayPoint: (target) ->
        desired = Vector.subtract target, @location
        desired.normalize()
        desired.multiply(MAX_SPEED)
        steer = desired.subtract(@velocity)
        steer.limit(MAX_FORCE*2)
        return steer

    flock: (neighbours, cylinders) ->
        separation        = @separate(neighbours).multiply(SEPARATION_WEIGHT)
        alignment         = @align(neighbours).multiply(ALIGNMENT_WEIGHT)
        cohesion          = @cohere(neighbours).multiply(COHESION_WEIGHT)
        toWayPoint        = @toWayPoint(new Vector @processing.width, @processing.height/2).multiply(WAYPOINT_WEIGHT)
        avoidCollision    = @avoidCollision(cylinders).multiply(AVOIDANCE_WEIGHT)
        swerveFromObjects = @swerveFromObjects(cylinders).multiply(SWERVE_WEIGHT)
        #avoidWalls     = @avoidWalls().multiply(AVOIDANCE_WEIGHT)
        #return separation.add(alignment).add(cohesion).add(avoidCollision).add(avoidWalls);
        #return separation.add(alignment).add(cohesion).add(avoidCollision).add(toWayPoint).add(swerveFromObjects);
        #return separation.add(alignment).add(cohesion).add(toWayPoint).add(avoidCollision).add(swerveFromObjects);
        #return separation.add(alignment).add(cohesion).add(avoidCollision).add(swerveFromObjects);
        return separation.add(alignment).add(cohesion).add(avoidCollision).add(swerveFromObjects).add(toWayPoint)
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