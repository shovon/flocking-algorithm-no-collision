class window.Cylinder
    processing: null

    radius: 20
    location: null

    constructor: (options = {}) ->
        throw "A processing instance needs to be defined." if not options.processing?

        @processing = options.processing
        @radius = options.radius || Math.floor Math.random()*40
        @location = options.location || new Vector(Math.floor(Math.random()*@processing.width + 5), Math.floor(Math.random()*@processing.height + 5))
        return

    render: ->
        @processing.fill(128, 255, 128)
        @processing.stroke(0, 255, 0)
        @processing.pushMatrix()
        @processing.translate(@location.x, @location.y)
        @processing.ellipse(0, 0, @radius*2, @radius*2)
        @processing.popMatrix()
