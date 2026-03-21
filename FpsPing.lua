-- SavedVariables fallback
FPSPingDB = FPSPingDB or {}
FPSPingDB.scale = FPSPingDB.scale or 1.0
FPSPingDB.layout = FPSPingDB.layout or "vertical" -- "vertical" or "horizontal"

-- Create the stats display frame
local statsFrame = CreateFrame("Frame", "FPSPingFrame", UIParent)
statsFrame:SetWidth(180)
statsFrame:SetHeight(40)
statsFrame:SetMovable(true)
statsFrame:EnableMouse(true)
statsFrame:RegisterForDrag("LeftButton")
statsFrame:SetScale(FPSPingDB.scale)

-- Drag and save position
statsFrame:SetScript("OnDragStart", function()
  this:StartMoving()
end)
statsFrame:SetScript("OnDragStop", function()
  this:StopMovingOrSizing()
  local point, relativeTo, relativePoint, xOfs, yOfs = this:GetPoint()
  FPSPingDB.position = {
    point = point,
    relativeTo = relativeTo,
    relativePoint = relativePoint,
    xOfs = xOfs,
    yOfs = yOfs
  }
end)

-- Restore saved position
local function RestorePosition()
  local pos = FPSPingDB.position
  statsFrame:ClearAllPoints()
  if pos then
    statsFrame:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.xOfs or 0, pos.yOfs or 0)
  else
    statsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
end
RestorePosition()
statsFrame:Show()

-- Create font string
local text = statsFrame:CreateFontString(nil, "OVERLAY")
text:SetPoint("TOPLEFT", statsFrame, "TOPLEFT", 0, 0)
text:SetJustifyH("LEFT")
text:SetJustifyV("TOP")
text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
text:SetText("")

-- Shared data
local latencyWorld = 0

-- Update latency
local function UpdateLatency()
  if GetNetStats then
    local _, _, world = GetNetStats()
    latencyWorld = world
  end
end

-- Color coding for FPS: 0-30 red, 31-45 orange, 46-59 yellow, 60-75 white, 76+ green
local function FpsColor(fps)
  if fps <= 30 then return "ff0000"
  elseif fps <= 45 then return "ff8800"
  elseif fps <= 59 then return "ffff00"
  elseif fps <= 75 then return "ffffff"
  else return "00ff00" end
end

-- Color coding for MS: 0-60 green, 61-90 white, 91-120 yellow, 121-150 orange, 151+ red
local function MsColor(ms)
  if ms <= 60 then return "00ff00"
  elseif ms <= 90 then return "ffffff"
  elseif ms <= 120 then return "ffff00"
  elseif ms <= 150 then return "ff8800"
  else return "ff0000" end
end

-- Update display based on layout
local function UpdateStats()
  local fps = math.floor(GetFramerate() + 0.5)
  local fc = FpsColor(fps)
  local mc = MsColor(latencyWorld)
  if FPSPingDB.layout == "horizontal" then
    text:SetText(string.format(
      "|cffffffffFPS:|r |cff%s%d|r  |cffffffffMS:|r |cff%s%d|r",
      fc, fps, mc, latencyWorld
    ))
  else
    text:SetText(string.format(
      "|cffffffffFPS:|r |cff%s%d|r\n|cffffffffMS:|r |cff%s%d|r",
      fc, fps, mc, latencyWorld
    ))
  end
end


-- Right-click to toggle layout
statsFrame:SetScript("OnMouseUp", function()
  if arg1 == "RightButton" then
    FPSPingDB.layout = (FPSPingDB.layout == "vertical") and "horizontal" or "vertical"
    UpdateStats()
  end
end)

-- OnUpdate-based timers (replaces C_Timer.NewTicker for 1.12 compat)
local statsElapsed = 0
local latencyElapsed = 0
local latencyStarted = false

statsFrame:SetScript("OnUpdate", function()
  statsElapsed = statsElapsed + arg1
  if statsElapsed >= 1 then
    statsElapsed = 0
    UpdateStats()
  end
  if latencyStarted then
    latencyElapsed = latencyElapsed + arg1
    if latencyElapsed >= 5 then
      latencyElapsed = 0
      UpdateLatency()
    end
  end
end)

-- Latency update on login
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function()
  UpdateLatency()
  latencyStarted = true
end)

-- Slash command to reset position
SLASH_FPSPINGRESET1 = "/fpsreset"
SlashCmdList["FPSPINGRESET"] = function()
  statsFrame:ClearAllPoints()
  statsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  FPSPingDB.position = nil
end
