--- CursorContinue.spoon: Double-Enter to send phrase in Cursor chat
local obj = {}
obj.__index = obj
obj.name = "CursorContinue"
obj.version = "0.1.0"
obj.author = "Vincent J Lim & contributors"
obj.homepage = "local"
obj.license = "MIT"

-- Config
obj.phrase = "진행시켜"
obj.doubleTapInterval = 0.35
obj.onlyWhenCursorFrontmost = true
obj.consumeDoubleEnter = true
obj.showAlertOnTrigger = true

obj._tap = nil
obj._lastTapAt = 0

function obj:isCursorFrontmost()
  local app = hs.application.frontmostApplication()
  if not app then return false end
  local name = (app:name() or ""):lower()
  local bid  = (app:bundleID() or ""):lower()
  if name:find("cursor", 1, true) then return true end
  if bid:find("cursor", 1, true) then return true end
  if bid:match("^com%.todesktop%.") then return name:find("cursor", 1, true) ~= nil end
  return false
end

function obj:start()
  if self._tap then self._tap:stop(); self._tap = nil end
  self._lastTapAt = 0
  local RETURN    = hs.keycodes.map["return"]
  local PAD_ENTER = hs.keycodes.map["padEnter"]
  self._tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    if self.onlyWhenCursorFrontmost and not self:isCursorFrontmost() then return false end
    local key = e:getKeyCode()
    if key ~= RETURN and key ~= PAD_ENTER then return false end
    local flags = e:getFlags()
    if flags.cmd or flags.alt or flags.ctrl or flags.shift or flags.fn then return false end
    local now = hs.timer.secondsSinceEpoch()
    if (now - self._lastTapAt) < self.doubleTapInterval then
      self._lastTapAt = 0
      if self.showAlertOnTrigger then hs.alert.show(self.phrase .. " ▶") end
      hs.eventtap.keyStrokes(self.phrase)
      hs.eventtap.keyStroke({}, "return")
      return self.consumeDoubleEnter
    else
      self._lastTapAt = now
      return false
    end
  end)
  self._tap:start()
  return self
end

function obj:stop()
  if self._tap then self._tap:stop() end
  self._tap = nil
  return self
end

return obj
