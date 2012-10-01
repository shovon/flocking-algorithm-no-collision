class window.Line
    constructor: (@p1=new Vector(), @p2=new Vector()) ->

    isOnSegment: (xi, yi, xj, yj, xk, yk) ->
        return (xi <= xk || xj <= xk) && (xk <= xi || xk <= xj) &&
            (yi <= yk || yj <= yk) && (yk <= yi || yk <= yj)

    computeDirection: (xi, yi, xj, yj, xk, yk) ->
        a = (xk - xi) * (yj - yi)
        b = (xj - xi) * (yk - yi)
        return if a < b then -1 else if a > b then 1 else 0

    intersects: (line) ->
        {max, min} = Math

        p1 = @p1
        p2 = @p2
        p3 = line.p1
        p4 = line.p2

        d1 = @computeDirection p3.x, p3.y, p4.x, p4.y, p1.x, p1.y
        d2 = @computeDirection p3.x, p3.y, p4.x, p4.y, p2.x, p2.y
        d3 = @computeDirection p1.x, p1.y, p2.x, p2.y, p3.x, p3.y
        d4 = @computeDirection p1.x, p1.y, p2.x, p2.y, p4.x, p4.y

        return (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
            ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) ||
            (d1 == 0 && @isOnSegment(p3.x, p3.y, p4.x, p4.y, p1.x, p1.y)) ||
            (d2 == 0 && @isOnSegment(p3.x, p3.y, p4.x, p4.y, p2.x, p2.y)) ||
            (d3 == 0 && @isOnSegment(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)) ||
            (d4 == 0 && @isOnSegment(p1.x, p1.y, p2.x, p2.y, p4.x, p4.y))
        