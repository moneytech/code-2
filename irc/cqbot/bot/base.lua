require "socket"
require "moonscript"

--- Convenience wrapper to reply to the channel
--  @param message the message to say
function reply(message)
  bot.Say("#"..bot.Config.Bot.Channel, message)
end

-- http://lua-users.org/wiki/SplitJoin
-- Compatibility: Lua-5.1
function split(str, pat)
  local t = {}  -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(t,cap)
    end
    last_end = e+1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

function join(table, str)
  return table.concat(table, str)
end

-- http://stackoverflow.com/a/12674376
function keys(tab)
  local keyset={}
  local n=0

  for k,v in pairs(tab) do
    n=n+1
    keyset[n]=k
  end

  return keyset
end

-- http://lua-users.org/wiki/SleepFunction
function sleep(sec)
  socket.select(nil, nil, sec)
end

-- http://lua-users.org/wiki/SimpleLuaClasses
-- class.lua
-- Compatible with Lua 5.1 (not 5.0).
function class(base, init)
  local c = {}    -- a new class instance
  if not init and type(base) == 'function' then
    init = base
    base = nil
  elseif type(base) == 'table' then
    -- our new class is a shallow copy of the base class!
    for i,v in pairs(base) do
      c[i] = v
    end
    c._base = base
  end
  -- the class will be the metatable for all its objects,
  -- and they will look up their methods in it.
  c.__index = c

  -- expose a constructor which can be called by <classname>(<args>)
  local mt = {}
  mt.__call = function(class_tbl, ...)
    local obj = {}
    setmetatable(obj,c)
    if init then
      init(obj,...)
    else
      -- make sure that any stuff from the base class is initialized!
      if base and base.init then
        base.init(obj, ...)
      end
    end
    return obj
  end
  c.init = init
  c.is_a = function(self, klass)
    local m = getmetatable(self)
    while m do
      if m == klass then return true end
      m = m._base
    end
    return false
  end
  setmetatable(c, mt)
  return c
end

--[[
A = class(function (self, x)
  self.x = x
end)

function A:test()
  print(self.x)
end

a = A("5")
a:test() --> 5
--]]

-- http://stackoverflow.com/a/326715
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()

  if raw then
    return s
  end

  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

-- Wrapper for AddLuaCommand
function register_command(verb, help, func)
  script.AddLuaCommand(bot, verb, help, func)
end

-- A decorator for requiring elevated permissions
function elevated(...)
  local mt = {__concat =
  function(a,f)
    return function(user, ...)
      if user.Nick ~= "Xena" then
        return "No permissions"
      end

      return f(user, ...)
    end
  end
  }

  return setmetatable({...}, mt)
end

--[[
Usage:

elevatedtest =
  elevated() ..
  function(user, message)
    return "Hi master"
  end

--]]

-- Golua sucks
pcall = unsafe_pcall
xpcall = unsafe_xpcall

-- http://lua-users.org/wiki/StringRecipes
function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str
end

-- Moonscript
moon = require "moonscript"

function moon_dofile(fname)
  moon.loadfile(fname)()
end
