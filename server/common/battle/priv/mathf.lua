mathf = {}

local mathf = mathf

local mathExt = mathExt
local math = math
local min = math.min
local max = math.max
local floor = math.floor
local ceil = math.ceil
local log = math.log
local loge2 = math.log(2)

mathf.EPSILON = 1.0e-06


function mathf.sqr(x)
	return x * x
end

function mathf.clamp(value, low, high)
	return min(max(value, low), high)
end

function mathf.log2(x)
    return log(x) / loge2
end

function mathf.round(x) -- 和erlang:round一样，四舍五入
    local f = floor(x)
    return x - f < 0.5 and f or f + 1
end

function mathf.floatEqual(a, b, tolerance)
    local tol = tolerance or mathf.EPSILON
    return math.abs(a - b) <= tol
end

function mathf.floatCompare(a, b, tolerance)
    local tolerance = tolerance or mathf.EPSILON
    local temp = a - b
    if temp >= tolerance then
        -- a > b
        return 1
    elseif math.abs(temp) < tolerance then
        -- a == b
        return 0
    else
        -- a < b
        return -1
    end
end

function mathf.adjustFloat(a, tolerance)
    local tol = tolerance or mathf.EPSILON
    local f = floor(a)
    if a - f < tol then
        return f
    end
    local c = ceil(a)
    if c - a < tol then
        return c
    end
    return a
end

-- return x, y, z (x, y is screen pos, z is depth)
function mathf.SceneToCamera(sx, sy, sz, matVP, screenW, screenH)
    mathExt.SetCameraMatParam(matVP, screenW, screenH)
	return mathExt.SceneToCamera(sx, sy, sz)
end

-- return ray as vec3 start, dir
function mathf.CameraToScene(screenX, screenY, camPos, matVP, screenW, screenH)
    mathExt.SetCameraMatParam(matVP, screenW, screenH)
	local start, dir = mathExt.CameraToScene(screenX, screenY, camPos)
	return vec3.newud(start), vec3.newud(dir)
end

-- 比较指定pos和另两个pos的距离，返回更近的那一个
function mathf.GetCloserPos(selfPos, posA, posB)
    local sqDistanceA = selfPos:distsq(posA)
    local sqDistanceB = selfPos:distsq(posB)
    return sqDistanceA > sqDistanceB and posB or posA
end

function mathf.IsPointInPolygon(x, y, polygon) -- if too slow, use a c version in mathExt
    local inside = false

    local len = #polygon
    local i = 1
    local j = #polygon
    while true do
        if (polygon[i][2] > y) ~= (polygon[j][2] > y) and
            x < (polygon[j][1] - polygon[i][1]) * (y - polygon[i][2]) / (polygon[j][2] - polygon[i][2]) + polygon[i][1] then
            inside = not inside
        end

        j = i
        i = i + 1
        if i > len then
            break
        end
    end

    return inside

    -- http://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon
    -- bool inside = false;
    -- for ( int i = 0, j = polygon.Length - 1 ; i < polygon.Length ; j = i++ )
    -- {
    --     if ( ( polygon[ i ].Y > p.Y ) != ( polygon[ j ].Y > p.Y ) &&
    --          p.X < ( polygon[ j ].X - polygon[ i ].X ) * ( p.Y - polygon[ i ].Y ) / ( polygon[ j ].Y - polygon[ i ].Y ) + polygon[ i ].X )
    --     {
    --         inside = !inside;
    --     }
    -- }

    -- return startX1;
end

function mathf.Line2DIntersect(startX1, startY1, endX1, endY1, startX2, startY2, endX2, endY2) -- return isIntersects, pointX, pointY
    return mathExt.Line2DIntersect(startX1, startY1, endX1, endY1, startX2, startY2, endX2, endY2)
end

function mathf.RayToLine2DIntersect(startX1, startY1, endX1, endY1, startX2, startY2, endX2, endY2) -- return isIntersects, pointX, pointY
    return mathExt.RayToLine2DIntersect(startX1, startY1, endX1, endY1, startX2, startY2, endX2, endY2)
end