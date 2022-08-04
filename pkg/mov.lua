NORTH = 180 -- -z
EAST = 270  -- +x
SOUTH = 0 -- +z
WEST = 90  -- -x
INV = nil

tx = nil
ty = nil
tz = nil
td = INV

function turn(dir)
    while dir ~= td do    
        ddir = dir - td
        if ddir > 0 then
            turtle.turnRight()
            td = td+90
        else
            turtle.turnLeft()
            td = td-90
        end
    end
end

function pos(update)
    update = update or false

    local x, y, z = gps.locate(2, false)
    if not x then
        error("could not locate")
        exit()
    end
    if update then
        tx = x
        ty = y
        tz = z
    end
    return x, y, z
end

function fwd(distance)
    distance = distance or 1

    while distance > 0 do
        if turtle.forward() then
            if td == NORTH then
                tz = tz-1;
            elseif td == EAST then
                tx = tx+1;
            elseif td == SOUTH then
                tz = tz+1;
            elseif td == WEST then
                tx = tx-1;
            end
        else
            error("could not move")
            exit()
        end
    distance = distance-1;
    end
end

function asc()
    while ty ~= 255 do
        if turtle.up() then
            ty = ty+1;
        else
            error("could not move")
            exit()
        end
    end
end

function desc()
    while turtle.down() do
        ty = ty-1;
    end
end

function orientation()
    local x0, y0, z0 = pos()
    turtle.forward()
    local x1, y1, z1 = pos()
    if x0 ~= x1 then
        if x0 > x1 then
            td = WEST
            tx = tx-1;
        else
            td = EAST
            tx = tx+1;
        end
    else
        if z0 > z1 then
            td = NORTH
            tz = tz-1;
        else
            td = SOUTH
            tz = tz+1;
        end
    end
    return td
end

function moveTo(x, z)
    if x == nil or z == nil then
        error("invalid parameters")
        exit()
    end
    
    local dx = x - tx
    local dz = z - tz

    if dx == 0 and dz == 0 then
        error("already at destination")
        exit()
    end

    local fuel_needed = (dx+tz+(255-ty)+255);

    if turtle.getFuelLevel() < fuel_needed then
        error("not enough fuel, need "..fuel_needed)
        exit()
    end

    print("arrival at "..x..","..z.. " with ~"..turtle.getFuelLevel()-fuel_needed.." fuel")

    if dx ~= 0 then
        if dx > 0 then
            turn(EAST)
            fwd(dx)
        else
            turn(WEST)
            fwd(-dx)
        end
    end
    if dz ~= 0 then
        if dz > 0 then
            turn(SOUTH)
            fwd(dz)
        else
            turn(NORTH)
            fwd(-dz)
        end
    end

end