(function() {

  window.Line = (function() {

    function Line(p1, p2) {
      this.p1 = p1 != null ? p1 : new Vector();
      this.p2 = p2 != null ? p2 : new Vector();
    }

    Line.prototype.isOnSegment = function(xi, yi, xj, yj, xk, yk) {
      return (xi <= xk || xj <= xk) && (xk <= xi || xk <= xj) && (yi <= yk || yj <= yk) && (yk <= yi || yk <= yj);
    };

    Line.prototype.computeDirection = function(xi, yi, xj, yj, xk, yk) {
      var a, b;
      a = (xk - xi) * (yj - yi);
      b = (xj - xi) * (yk - yi);
      if (a < b) {
        return -1;
      } else if (a > b) {
        return 1;
      } else {
        return 0;
      }
    };

    Line.prototype.intersects = function(line) {
      var d1, d2, d3, d4, max, min, p1, p2, p3, p4;
      max = Math.max, min = Math.min;
      p1 = this.p1;
      p2 = this.p2;
      p3 = line.p1;
      p4 = line.p2;
      d1 = this.computeDirection(p3.x, p3.y, p4.x, p4.y, p1.x, p1.y);
      d2 = this.computeDirection(p3.x, p3.y, p4.x, p4.y, p2.x, p2.y);
      d3 = this.computeDirection(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
      d4 = this.computeDirection(p1.x, p1.y, p2.x, p2.y, p4.x, p4.y);
      return (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) && ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) || (d1 === 0 && this.isOnSegment(p3.x, p3.y, p4.x, p4.y, p1.x, p1.y)) || (d2 === 0 && this.isOnSegment(p3.x, p3.y, p4.x, p4.y, p2.x, p2.y)) || (d3 === 0 && this.isOnSegment(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)) || (d4 === 0 && this.isOnSegment(p1.x, p1.y, p2.x, p2.y, p4.x, p4.y));
    };

    return Line;

  })();

}).call(this);
