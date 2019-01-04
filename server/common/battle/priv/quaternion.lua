quaternion = {}

-- quaternion 不可变，创建后不能改变各元素值

local quaternion = quaternion
local vec3 = vec3

local mathf = mathf
local EPSILON = mathf.EPSILON
local clamp = mathf.clamp

local math = math
local abs = math.abs

local mathExt = mathExt
local vec3Ext = mathExt.vec3
local quatExt = mathExt.quat

local tonumber = tonumber
local setmetatable = setmetatable
local type = type

local mt = {}

function mt.__tostring(v)
     local x, y, z, w = v:get()
    return string.format('quaternion: %.5f, %.5f, %.5f, %.5f', x, y, z, w)
end

function mt.__add(a, b)
    return quaternion.newud(quatExt.Add(a, b))
end

function mt.__mul(a, b)
    if type(b) == 'userdata' then
        if b.classname == 'quaternion' then
            return quaternion.newud(quatExt.Mul(a,b))
        elseif b.classname == 'vec3' then
            return vec3.newud(quatExt.MulV(a, b))
        else
            DebugError(function() return "type of b is wrong: ".. type(b) end);
        end
    else
        return quaternion.newud(quatExt.MulS(a, b))
    end
end


function mt.__unm(a) -- w changes, quaternion:inversed() return a quaternion with w non-changed
    local x, y, z, w = a:get()
    return quaternion.new(-x, -y, -z, -w)
end

function mt.__eq(a, b)
    if rawequal(a, b) then
        return true
    end
    local a1, a2, a3, a4 = a:get()
    local b1, b2, b3, b4 = b:get()
    if (abs(a1 - b1) < EPSILON) and (abs(a2 - b2) < EPSILON) and (abs(a3 - b3) < EPSILON) and (abs(a4 - b4) < EPSILON) then
        return true
    else
        return false
    end
end

function mt.__concat(a, b)
    return tostring(a) .. tostring(b)
end

mt.__index = quaternion

quaternion.classname = 'quaternion'

function quaternion.newud(ud)
    mathExt.SetMeta(ud, mt)
    return ud
end

function quaternion.new(x, y, z, w)
    local t = nil

    if x == nil and y == nil and z == nil and w == nil then
        t = quatExt.Create()
    elseif x ~= nil and type(x) == 'userdata' and x.classname == 'quaternion' then
        t = quatExt.CreateQ(x)
    else
        local x = x and tonumber(x) or 0
        local y = y and tonumber(y) or 0
        local z = z and tonumber(z) or 0
        local w = w and tonumber(w) or 1
        t = quatExt.CreateS(x, y, z, w)
    end

    return quaternion.newud(t)
end

function quaternion:copy()
    -- return quaternion.new(self:get())
    return self -- quaternion 不可变，copy时直接返回自身是安全的
end


function quaternion:get() -- usage: local x, y, z, w = q:get()
    return quatExt.Get(self)
end

-- quaternion 不可变, 不允许使用set函数
-- function quaternion:set(x, y, z, w)
--     if x ~= nil and x.classname == 'quaternion' then
--         quatExt.Set(self, x)
--     else
--         local x = x and tonumber(x) or 0
--         local y = y and tonumber(y) or 0
--         local z = z and tonumber(z) or 0
--         local w = w and tonumber(w) or 1
--         quatExt.SetS(self, x, y, z, w)
--     end
-- end

function quaternion:normalized()
    return quaternion.newud(quatExt.Normalized(self))
end

function quaternion:inversed()
    local x, y, z, w = self:get()
    return quaternion.new(-x, -y, -z, w) -- w dosn't change
end

function quaternion:dot(v)
    return quatExt.Dot(self, v)
end

-- angle is in radians
function quaternion.fromEuler(x, y, z)
    return quaternion.newud(quatExt.FromEuler(x, y, z))
end

function quaternion:toEuler()
    local x, y, z = vec3Ext.Get(quatExt.ToEuler(self))
    return x, y, z
end

function quaternion:getRotateAngle()
    local x, y, z = vec3Ext.Get(quatExt.ToEuler(self))
    return math.deg(x), math.deg(y), math.deg(z)
end

-- angle is in radians
function quaternion.fromAngleAxis(angle, axis)
    return quaternion.newud(quatExt.FromAngleAxis(angle, axis))
end

function quaternion:toAngleAxis()
    local angle, vec = quatExt.ToAngleAxis(self)
    return angle, vec3.newud(vec)
end

function quaternion.rotationFromTo(from, to)
    return quaternion.newud(quatExt.RotationFromTo(from, to))
end

function quaternion:lerp(q2, t)
    return quaternion.newud(quatExt.Lerp(self, q2, t))
end

function quaternion:slerp(q2, t)
    return quaternion.newud(quatExt.SLerp(self, q2, t))
end




-- Test
-- local s1 = vec3.new(1, 0, 0)
-- local s2 = vec3.new(-1, 0, 0)
-- for i = 0.1, 1, 0.1 do
--     local s = s1:slerp(s2, i)
--     local q1 = quaternion.rotationFromTo(s1, s)
--     local angle, axis = q1:toAngleAxis()
--     DebugLog("i: " .. i .. " angle: " .. math.deg(angle) .. " s: " .. s)
-- end
-- End Test