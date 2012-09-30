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

    step: (neighbors)->
        acceleration = @flock(neighbors)
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

    separate: (neighbors) ->
        return new Vector

    align: (neighbors) ->
        return new Vector

    cohere: (neighbors) ->
        return new Vector

    flock: (neighbors) ->
        separation = @separate(neighbors).multiply(SEPARATION_WEIGHT)
        alignment  = @align(neighbors).multiply(ALIGNMENT_WEIGHT)
        cohesion   = @cohere(neighbors).multiply(COHESION_WEIGHT)
        #return separation.add(alignment).add(cohesion);
        return @velocity

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