mat4 = {}

local mat4 = mat4
local mat = mat4 -- different name to the same table, sublime text ctrl-r won't work correctly if it is mat
local vec3 = vec3
local mathf = mathf
local EPSILON = mathf.EPSILON
local math = math
local abs = math.abs
local mathExt = mathExt
local vec3Ext = mathExt.vec3
local quatExt = mathExt.quat
local mat4Ext = mathExt.mat4
local tonumber = tonumber
local setmetatable = setmetatable
local type = type
local string = string
local split = LuaUtils.string_split

local mt = {}
function mt.__tostring(v)
    local s = v:get()
    local str = string.format("mat4: %.5f", s[1])
    for i = 2, 16, 1 do
        str = string.format("%s,%.5f", str, s[i])
    end
    return str
end

function mt.__add(a, b)
    return mat4.newud(mat4Ext.Add(a, b))
end

function mt.__sub(a, b)
    return mat4.newud(mat4Ext.Sub(a, b))
end

function mt.__mul(a, b)
    if type(b) == 'userdata' then
        if b.classname == 'mat4' then
            return mat4.newud(mat4Ext.MulM(a, b))
        elseif b.classname == 'vec3' then
            return vec3.newud(a:mulPoint3x4(b))  -- same result as Matrix4x4.MultiplyPoint3x4 in unity
        else
            DebugError(function() return "type of b is wrong: ".. type(b) end);
        end
    else
        return mat4.newud(mat4Ext.MulS(a, b))
    end
end


function mt.__eq(a, b)
    if rawequal(a, b) then
        return true
    end
    return mat4Ext.Eq(a, b)
end

function mt.__concat(a, b)
    return tostring(a) .. tostring(b)
end

function mt.__gc(t)
    mat4Ext.Destroy(t)
end

mt.__index = mat4

mat4.classname = 'mat4'

function mat.newud(ud)
    mathExt.SetMeta(ud, mt)
    return ud
end

function mat.new(v)
    local t = nil
    if v == nil then
        t = mat4Ext.Create()
    else
        if type(v) == 'userdata' then
            t = mat4Ext.CreateM(v)
        elseif type(v) == 'table' then
            t = mat4Ext.CreateS(v)
        end
    end
    return mat4.newud(t)
end

function mat:get()
    return mat4Ext.Get(self)
end

function mat:copy()
    return mat.new(self)
end

function mat:set(v)
    if type(v) == 'userdata' then
        if v.classname == 'mat4' then
            mat4Ext.Set(self, v)
        else
            DebugError(function() return "type of v is wrong: ".. type(v) end)
        end
    elseif type(v) == 'table' then
        mat4Ext.SetS(self, v)
    end
end

function mat:encode()
    local s = self:get()
    local str = string.format("%.6f", s[1])
    for i = 2, 16, 1 do
        str = string.format("%s,%.6f", str, s[i])
    end
    return str
end

function mat:encodeBase64()
    return mat4Ext.EncodeBase64(self)
end

function mat.decode(str)
    local s = split(str, ',')
    local t = {}
    for i, v in ipairs(s) do
        t[i] = tonumber(v)
    end
    return mat4.new(t)
end

function mat.decodeParams(params, startIndex)
    local startIndex = startIndex or 1
    local t = {}
    for i = 1, 16, 1 do
        t[i] = tostring(params[i + startIndex - 1])
    end
    return mat4.new(t)
end

function mat.decodeBase64(str)
    return mat4.newud(mat4Ext.DecodeBase64(str))
end

function mat:setTrans(v) -- v is vec3
    mat4Ext.SetTrans(self, v)
end

function mat:getTrans()
    return vec3.newud(mat4Ext.GetTrans(self))
end

function mat:setRot(v) -- v is vec3 of radians
    mat4Ext.SetRot(self, v)
end

function mat:getRot()
    return vec3.newud(mat4Ext.GetRot(self))
end

function mat:setScale(v) -- v is vec3
    mat4Ext.SetScale(self, v)
end

function mat:getScale()
    return vec3.newud(mat4Ext.GetScale(self))
end

function mat:lerp(m2, t)
    return mat4.newud(mat4Ext.lerp(self, m2, t))
end

function mat:mulPoint3x4(v)  -- same result as Matrix4x4.MultiplyPoint3x4 in unity
    return vec3.newud(mat4Ext.MulV(a, b))
end

function mat:mulPoint(v) -- same result as Matrix4x4.MultiplyPoint in unity
    return vec3.newud(mat4Ext.MulPoint(self, v))
end

function mat:inversed() -- return hasInv, invMat
    return mat4.newud(mat4Ext.Inversed(self))
end

function mat:transposed()
    return mat4.newud(mat4Ext.Transposed(self))
end

function mat.buildLookAt(pos, target, up)
    local up = up ~= nil and up or vec3.up()
    return mat4.newud(mat4Ext.BuildLookAt(pos, target, up))
end



-- Test
-- local m1 = mat4.new()
-- local m2 = mat4.new(m1)
-- local g = m2:get()
-- local m3 = mat4.new(g)
-- local m4 = mat4.new()
-- m4.set(g)
-- DebugLog("m1: " .. m1)
-- DebugLog("m2: " .. m2)
-- DebugLog("m3: " .. m3)
-- DebugLog("m4: " .. m4)
-- local m5 = mat4.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16})
-- ext.SendMessageToUnity("TestMatrix", m5:encode())
-- local v1 = vec3.new(5, 6, 7)
-- local v2 = m5 * v1
-- DebugLog("v2: " .. v2)
-- local str = m5:encode()
-- DebugLog("mm: " .. str)
-- local m6 = mat4.decode(str)
-- DebugLog("m6: " .. m6)
-- End Test