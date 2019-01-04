vec3 = {}

-- vec3 不可变，创建后不能改变各元素值

local vec3 = vec3
local vec = vec3 -- different name to the same table, sublime text ctrl-r won't work correctly if it is vec3
local mathf = mathf
local EPSILON = mathf.EPSILON
local math = math
local abs = math.abs
local mathExt = mathExt
local vec3Ext = mathExt.vec3
local quatExt = mathExt.quat
local tonumber = tonumber
local setmetatable = setmetatable
local type = type
local string = string
local split = LuaUtils.string_split

local mt = {}
function mt.__tostring(v)
    local x, y, z = v:get()
    return string.format('vec3: %.5f, %.5f, %.5f', x, y, z)
end

function mt.__add(a, b)
    assert(a)
    assert(b and b.classname == 'vec3')
    return vec3.newud(vec3Ext.Add(a, b))
end

function mt.__sub(a, b)
    assert(a)
    assert(b and b.classname == 'vec3')
    return vec3.newud(vec3Ext.Sub(a, b))
end

function mt.__mul(a, b)
    assert(a and a.classname == 'vec3')
    assert(b, "vec3 __mul(a,b), b is nil.")
    if type(b) == 'userdata' and b.classname == 'vec3' then
        return vec3.newud(vec3Ext.Mul(a, b))
    else
        return vec3.newud(vec3Ext.MulS(a, b)) -- mul scalar float
    end
end

function mt.__div(a, b)
    assert(a and a.classname == 'vec3')
    assert(b)
     if type(b) == 'userdata' and b.classname == 'vec3' then
        return vec3.newud(vec3Ext.Div(a, b))
    else
        return vec3.newud(vec3Ext.DivS(a, b))
    end
end

function mt.__unm(a)
    assert(a)
    local x, y, z = vec3Ext.Get(a)
    return vec3.new(-x, -y, -z)
end

function mt.__eq(a, b)
    assert(a)
    assert(b)
    if rawequal(a, b) then
        return true
    end
    local a1, a2, a3 = vec3Ext.Get(a)
    local b1, b2, b3 = vec3Ext.Get(b)
    if (abs(a1 - b1) < EPSILON) and (abs(a2 - b2) < EPSILON) and (abs(a3 - b3) < EPSILON) then
        return true
    else
        return false
    end
end

function mt.__concat(a, b)
    return tostring(a) .. tostring(b)
end

function mt.__gc(t)
    vec3Ext.Destroy(t)
end

mt.__index = vec

vec.classname = 'vec3'

function vec.newud(ud)
    mathExt.SetMeta(ud, mt)
    return ud
end

function vec.new(x, y, z)
    local t = nil

    if x == nil and y == nil and z == nil then
        t = vec3Ext.Create()
    elseif x ~= nil and type(x) == 'userdata' and x.classname == 'vec3' then
        t = vec3Ext.CreateV(x)
    else
        local x = x and tonumber(x) or 0
        local y = y and tonumber(y) or 0
        local z = z and tonumber(z) or 0
        t = vec3Ext.CreateS(x, y, z)
    end

    return vec3.newud(t)
end

local VEC3_ZERO = vec3.new(0, 0, 0)
local VEC3_ONE = vec3.new(1, 1, 1)
local VEC3_FORWARD = vec3.new(0, 0, 1)
local VEC3_UP = vec3.new(0, 1, 0)
local VEC3_RIGHT = vec3.new(1, 0, 0)
local VEC3_LEFT = vec3.new(-1, 0, 0)

function vec.zero()
    return VEC3_ZERO
end

function vec.one()
    return VEC3_ONE
end

function vec.forward()
    return VEC3_FORWARD
end

function vec.up()
    return VEC3_UP
end

function vec.right()
    return VEC3_RIGHT
end

function vec.left()
    return VEC3_LEFT
end

function vec:copy()
    -- local x,y,z = self:get()
    -- return vec3.new(x, y, z)
    return self -- vec3 不可变，copy时直接返回自身是安全的
end

function vec:get() -- usage: local x, y, z = v:get()
    assert(self)
    return vec3Ext.Get(self)
end

function vec:x()
    assert(self)
    local x = vec3Ext.Get(self)
    return x
end

function vec:y()
    assert(self)
    local _, y = vec3Ext.Get(self)
    return y
end

function vec:z()
    assert(self)
    local _, _, z = vec3Ext.Get(self)
    return z
end

function vec:ZeroY()
    assert(self)
    local x, _, z = vec3Ext.Get(self)
    return vec3.new(x, 0, z)
end

-- vec3 不可变, 不允许使用set函数
-- function vec:set(x, y, z)
--     assert(self)
--     if x ~= nil and type(x) == 'userdata' and x.classname == 'vec3' then
--         vec3Ext.Set(self, x)
--     else
--         local x = x and tonumber(x) or 0
--         local y = y and tonumber(y) or 0
--         local z = z and tonumber(z) or 0
--         vec3Ext.SetS(self, x, y, z)
--     end
-- end

function vec:encode()
    assert(self)
    return string.format("%.6f,%.6f,%.6f", self:get())
end

function vec:encodeBase64()
    assert(self)
    return vec3Ext.EncodeBase64(self)
end

function vec.encodeTransformBase64(pos, dir, up)
    return vec3Ext.EncodeTransformBase64(pos, dir, up)
end

function vec.decode(str)
    local s = split(str, ',')
    local t = {}
    for i, v in ipairs(s) do
        t[i] = tonumber(v)
    end
    return vec3.new(t[1], t[2], t[3])
end

function vec.decodeBase64(str)
    return vec3.newud(vec3Ext.DecodeBase64(str))
end

function vec.decodeTransformBase64(str)
    local pos, dir, up = vec3Ext.DecodeTransformBase64(str)
    return vec3.newud(pos), vec3.newud(dir), vec3.newud(up)
end

function vec:dot(v)
    assert(self and v)
    return vec3Ext.Dot(self, v)
end

function vec:cross(v)
    assert(self and v)
    return vec3.newud(vec3Ext.Cross(self, v))
end

function vec:len()
    assert(self)
    return vec3Ext.Len(self)
end

function vec:lensq()
    assert(self)
     return vec3Ext.LenSq(self)
end

function vec:dist(v)
    assert(self and v)
    return vec3Ext.Dist(self, v)
end

function vec:distsq(v)
    assert(self and v)
    return vec3Ext.DistSq(self, v)
end

function vec:normalized()
    assert(self)
   return vec3.newud(vec3Ext.Normalized(self))
end

function vec:lerp(v2, t)
    assert(self and v2 and t)
    return vec3.newud(vec3Ext.Lerp(self, v2, mathf.clamp(t, 0, 1)))
end

function vec:slerp(v2, t)
    assert(self and v2 and t)
    return vec3.newud(vec3Ext.SLerp(self, v2, mathf.clamp(t, 0, 1)))
end


-- Test
-- local v1 = vec3.new(1, 2, 3)
-- local v2 = vec3.new(2, 3, 4)
-- local v3 = v1 + v2
-- local v4 = v1 - v2
-- local v5 = v1 * v2
-- local v6 = v1 / v2
-- local v7 = v1 * 2
-- local v8 = v1 / 2
-- DebugLog("v8: " .. tostring(v8))
-- DebugLog("== " .. tostring(v1 == v2) .. " " .. tostring(vec3.new(v1) == v1))
-- DebugLog("v8:len() " .. v8:len())
-- DebugLog("v8:lensq() " .. v8:lensq())
-- DebugLog("v8:normalized() " .. v8:normalized())
-- DebugLog("v8:dist(v7) " .. v8:dist(v7))
-- DebugLog("v8:distsq(v7) " .. v8:distsq(v7))
-- DebugLog("v8:dot(v7) " .. v8:dot(v7))
-- DebugLog("v8:cross(v6) " .. v8:cross(v6))
-- End Test

