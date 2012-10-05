(function() {

  window.Cylinder = (function() {

    Cylinder.prototype.processing = null;

    Cylinder.prototype.radius = 20;

    Cylinder.prototype.location = null;

    function Cylinder(options) {
      if (options == null) {
        options = {};
      }
      if (!(options.processing != null)) {
        throw "A processing instance needs to be defined.";
      }
      this.processing = options.processing;
      this.radius = options.radius || Math.floor(Math.random() * 40);
      this.location = options.location || new Vector(Math.floor(Math.random() * this.processing.width + 5), Math.floor(Math.random() * this.processing.height + 5));
      return;
    }

    Cylinder.prototype.render = function() {
      this.processing.fill(128, 255, 128);
      this.processing.stroke(0, 255, 0);
      this.processing.pushMatrix();
      this.processing.translate(this.location.x, this.location.y);
      this.processing.ellipse(0, 0, this.radius * 2, this.radius * 2);
      return this.processing.popMatrix();
    };

    return Cylinder;

  })();

}).call(this);
