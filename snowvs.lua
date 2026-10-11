task.defer(function() -- это запустится параллельно, работу основного скрипта затронуть не должно
  repeat task.wait() until game:IsLoaded()
  task.wait(1)
  
  local Players = game:GetService('Players')
  local CoreGui = game:GetService('CoreGui')
  local TweenService = game:GetService('TweenService')

  local ui = Instance.new('ScreenGui')
  ui.ResetOnSpawn = false
  ui.Name = tostring(math.random(1000000, 9999999))..tostring(math.random(1000000, 9999999))
  ui.DisplayOrder = 100

  local image = Instance.new('ImageLabel')
  image.BackgroundTransparency = 1
  image.AnchorPoint = Vector2.new(0, 1)
  image.Position = UDim2.new(0, -200, 0.9, 0)
  image.Size = UDim2.fromOffset(200, 150)
  image.BorderSizePixel = 0

  if getcustomasset and writefile then
    writefile('kurtisimg.png', game:HttpGet('https://github.com/anowerrrr333-star/imgforscript/blob/main/Frame%201.png?raw=true'))
    image.Image = getcustomasset('kurtisimg.png')
  end

  image.Parent = ui
  ui.Parent = gethui and gethui() or CoreGui or Players.LocalPlayer:WaitForChild('PlayerGui')

  local initialPosition = image.Position
  local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

  TweenService:Create(image, tweenInfo, {Position = UDim2.new(0.05, 0, 0.9, 0)}):Play()
  
  task.wait(0.5 + 7)
  
  TweenService:Create(image, tweenInfo, {Position = initialPosition}):Play()
  
  task.wait(0.5)
  
  ui:Destroy()
end)

task.defer(function() -- это запустится параллельно, работу основного скрипта затронуть не должно
  repeat task.wait() until game:IsLoaded()
  task.wait(1)
  
  local Players = game:GetService('Players')
  local CoreGui = game:GetService('CoreGui')
  local TweenService = game:GetService('TweenService')

  local ui = Instance.new('ScreenGui')
  ui.ResetOnSpawn = false
  ui.Name = tostring(math.random(1000000, 9999999))..tostring(math.random(1000000, 9999999))
  ui.DisplayOrder = 100

  local image = Instance.new('ImageLabel')
  image.BackgroundTransparency = 1
  image.AnchorPoint = Vector2.new(0, 1)
  image.Position = UDim2.new(0, -200, 0.9, 0)
  image.Size = UDim2.fromOffset(200, 150)
  image.BorderSizePixel = 0

  if getcustomasset and writefile then
    writefile('kurtisimg.png', game:HttpGet('https://github.com/anowerrrr333-star/imgforscript/blob/main/Frame%201.png?raw=true'))
    image.Image = getcustomasset('kurtisimg.png')
  end

  image.Parent = ui
  ui.Parent = gethui and gethui() or CoreGui or Players.LocalPlayer:WaitForChild('PlayerGui')

  local initialPosition = image.Position
  local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

  TweenService:Create(image, tweenInfo, {Position = UDim2.new(0.05, 0, 0.9, 0)}):Play()
  
  task.wait(0.5 + 7)
  
  TweenService:Create(image, tweenInfo, {Position = initialPosition}):Play()
  
  task.wait(0.5)
  
  ui:Destroy()
end)


local function _w(t) t = t or 0.03 if task and type(task.wait) == "function" then task.wait(t) elseif type(wait) == "function" then wait(t) end end do local n = 0 while n < 200 do local ok, loaded = pcall(function() return game:IsLoaded() end) if ok and loaded then break end n = n + 1; _w(0.05) end end
_w(0.1); print("[snow.vs] Starting..."); local Players = game:GetService("Players"); local RunService = game:GetService("RunService"); local UIS = game:GetService("UserInputService"); local TS = game:GetService("TweenService"); local Lighting = game:GetService("Lighting"); local HS = game:GetService("HttpService"); local LP = Players.LocalPlayer if not LP then local ok, plr = pcall(function() return Players:WaitForChild("LocalPlayer", 15) end) if ok then LP = plr end end if not LP then warn("[snow.vs] LocalPlayer not found - abort") return end local _genv = _G pcall(function()
if type(getgenv) == "function" then local g = getgenv() if type(g) == "table" then _genv = g end end end) local function destroyOldGuis() local names = {"CrystalVSHub", "CursedHub", "VersincMobileButtons", "VersicnIntro"}; local parents = {} pcall(function() table.insert(parents, game:GetService("CoreGui")) end) pcall(function() if LP then table.insert(parents, LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 2)) end end) pcall(function() if type(gethui) == "function" then table.insert(parents, gethui()) end end) for _, parent in ipairs(parents) do if parent then
for _, name in ipairs(names) do pcall(function() local o = parent:FindFirstChild(name) while o do o:Destroy(); o = parent:FindFirstChild(name) end end) end end end _G.VersincMobileButtonRefs = {} end if _genv.__CrystalVSHubLoaded then pcall(destroyOldGuis); _genv.__CrystalVSHubLoaded = false warn("[snow.vs] Old instance cleaned - reloading...") end pcall(destroyOldGuis); pcall(function() if type(_genv.__CrystalAntiDropCleanup) == "function" then _genv.__CrystalAntiDropCleanup() end end); _G.__AntiTPBatEnabled = false
-- >>> ANTI TP BAT BEGIN
-- ============================================================
-- ANTI TP BAT (V1 / V2 / V3 / V4 + SPAM)
-- Desync del PhysicsRepRootPart su una part esca + lock del movimento.
--   V1 Rosso  : coordinate estreme
--   V2 Blu    : Y = -120
--   V3 Verde  : jitter random con ricreazione continua (mai a 0,0)
--   V4 Viola  : posizione fissa (400, 0, 400)
-- Hard stop automatico su morte nemico / morte propria / ragdoll proprio.
-- Tutto dentro un do-block: nessun local nuovo nel main chunk (limite 200).
-- ============================================================
;(function()
  local ATP_active      = false
  local voidPart        = nil
  local jitterThread    = nil
  local jitterRunning   = false
  local spamThread      = nil
  local lockConn        = nil
  local frozenCFrame    = nil
  local savedWalkSpeed  = nil
  local savedJumpPower  = nil
  local savedAutoRotate = nil

  _G.AmbitiousAntiTPBatEnabled = _G.AmbitiousAntiTPBatEnabled == true
  _G.AmbitiousAntiTPBatSpam    = _G.AmbitiousAntiTPBatSpam == true
  _G.AmbitiousAntiTPBatVersion = math.clamp(tonumber(_G.AmbitiousAntiTPBatVersion) or 1, 1, 4)

  local function getHRP()
    local c = LP.Character
    if not c then return nil, nil end
    return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
  end

  local function setPartAppearance(part, version)
    local color, transparency
    if version == 1 then
      color, transparency = Color3.fromRGB(255, 50, 50), 0.5
    elseif version == 2 then
      color, transparency = Color3.fromRGB(50, 100, 255), 0.5
    elseif version == 3 then
      color, transparency = Color3.fromRGB(50, 255, 50), 0.5
    elseif version == 4 then
      color, transparency = Color3.fromRGB(200, 50, 200), 0.5
    else
      color, transparency = Color3.fromRGB(255, 255, 255), 1
    end
    pcall(function()
      part.Color = color
      part.Transparency = transparency
    end)
  end

  -- Punta il PhysicsRepRootPart su target (part esca oppure di nuovo l'HRP)
  local function repTo(target)
    local hrp = getHRP()
    if hrp and sethiddenproperty and target then
      pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", target) end)
    end
  end

  local function destroyVoidPart()
    if voidPart then
      local hrp = getHRP()
      if hrp then repTo(hrp) end
      pcall(function() voidPart:Destroy() end)
      voidPart = nil
    end
  end

  local function makePart(ver, pos)
    local p = Instance.new("Part")
    p.Name       = "DesyncTrapPart"
    p.Size       = Vector3.new(1, 1, 1)
    p.CanCollide = false
    p.Anchored   = true
    p.Position   = pos
    setPartAppearance(p, ver)
    p.Parent = workspace
    return p
  end

  local function createVoidPart()
    if voidPart then
      pcall(function() voidPart:Destroy() end)
      voidPart = nil
    end
    local ver = _G.AmbitiousAntiTPBatVersion or 1
    local pos
    if ver == 4 then
      pos = Vector3.new(400, 0, 400)
    elseif ver == 3 then
      local rx, rz = math.random(-300, 300), math.random(-300, 300)
      if rx == 0 and rz == 0 then rx, rz = 1, 1 end
      pos = Vector3.new(rx, 0, rz)
    elseif ver == 2 then
      pos = Vector3.new(0, -120, 0)
    else
      pos = Vector3.new(99999999999, 99999999999, 99999999999)
    end
    voidPart = makePart(ver, pos)
  end

  local function stopVoidJitter()
    jitterRunning = false
    if jitterThread then
      pcall(task.cancel, jitterThread)
      jitterThread = nil
    end
  end

  local function startVoidJitter()
    stopVoidJitter()
    jitterRunning = true
    jitterThread = task.spawn(function()
      while jitterRunning and ATP_active and _G.AmbitiousAntiTPBatVersion == 3 do
        local rx, rz
        repeat
          rx = math.random(-300, 300)
          rz = math.random(-300, 300)
        until not (rx == 0 and rz == 0)
        if voidPart then
          pcall(function() voidPart:Destroy() end)
          voidPart = nil
        end
        voidPart = makePart(3, Vector3.new(rx, 0, rz))
        repTo(voidPart)
        task.wait(0)
      end
    end)
  end

  local function lockMovement()
    local hrp, hum = getHRP()
    if not hrp then return end
    frozenCFrame = hrp.CFrame
    if hum then
      savedWalkSpeed  = hum.WalkSpeed
      savedJumpPower  = hum.JumpPower
      savedAutoRotate = hum.AutoRotate
      pcall(function()
        hum.WalkSpeed  = 0
        hum.JumpPower  = 0
        hum.AutoRotate = false
      end)
    end
    if lockConn then pcall(function() lockConn:Disconnect() end) end
    lockConn = RunService.RenderStepped:Connect(function()
      local r = getHRP()
      if frozenCFrame and r and r.Parent then
        r.CFrame = frozenCFrame
      end
    end)
  end

  local function unlockMovement()
    local _, hum = getHRP()
    if hum then
      pcall(function()
        hum.WalkSpeed  = savedWalkSpeed or 16
        hum.JumpPower  = savedJumpPower or 50
        if savedAutoRotate == nil then
          hum.AutoRotate = true
        else
          hum.AutoRotate = savedAutoRotate
        end
      end)
    end
    savedWalkSpeed, savedJumpPower, savedAutoRotate = nil, nil, nil
    if lockConn then
      pcall(function() lockConn:Disconnect() end)
      lockConn = nil
    end
    frozenCFrame = nil
  end

  local function enableCore()
    if ATP_active then return end
    ATP_active = true
    -- Qui passano TUTTE le accensioni: setEnabled, setVersion, setSpam,
    -- startSpamLoop e il watcher. Armare qui invece che nel solo
    -- setEnabled significa che nessuna strada resta scoperta.
    if _G.AmbitiousAntiDieArmNow then pcall(_G.AmbitiousAntiDieArmNow) end
    createVoidPart()
    repTo(voidPart)
    lockMovement()
    if _G.AmbitiousAntiTPBatVersion == 3 then startVoidJitter() end
  end

  local function disableCore()
    if not ATP_active then return end
    ATP_active = false
    stopVoidJitter()
    unlockMovement()
    destroyVoidPart()
  end

  -- Riaggancio continuo (solo V1, V2, V4: la V3 ricrea la part da sola)
  local function applyDesync()
    if not ATP_active then return end
    if _G.AmbitiousAntiTPBatVersion == 3 then return end
    if not voidPart or not voidPart.Parent then createVoidPart() end
    repTo(voidPart)
  end

  RunService.Heartbeat:Connect(applyDesync)
  RunService.Stepped:Connect(applyDesync)

  local function stopSpamLoop()
    if spamThread then
      pcall(task.cancel, spamThread)
      spamThread = nil
    end
  end

  local function startSpamLoop()
    stopSpamLoop()
    spamThread = task.spawn(function()
      enableCore()
      while _G.AmbitiousAntiTPBatSpam and _G.AmbitiousAntiTPBatEnabled do
        task.wait(0.5)
        if not (_G.AmbitiousAntiTPBatSpam and _G.AmbitiousAntiTPBatEnabled) then break end
        disableCore()
        task.wait(0.5)
        if not (_G.AmbitiousAntiTPBatSpam and _G.AmbitiousAntiTPBatEnabled) then break end
        enableCore()
      end
      if _G.AmbitiousAntiTPBatEnabled then enableCore() else disableCore() end
    end)
  end

  local function refreshUI()
    pcall(function()
      if _G._AmbitiousAntiTPBatSetRowVisual then
        _G._AmbitiousAntiTPBatSetRowVisual(_G.AmbitiousAntiTPBatEnabled == true)
      end
      if _G._AmbitiousAntiTPBatSetSpamVisual then
        _G._AmbitiousAntiTPBatSetSpamVisual(_G.AmbitiousAntiTPBatSpam == true)
      end
      if _G._AmbitiousAntiTPBatSetVersionVisual then
        _G._AmbitiousAntiTPBatSetVersionVisual(_G.AmbitiousAntiTPBatVersion or 1)
      end
      if _G.CrystalRefreshMobileButtonStates then
        pcall(_G.CrystalRefreshMobileButtonStates)
      end
    end)
  end
  _G._AmbitiousAntiTPBatRefreshUI = refreshUI

  local function saveCfg()
    if type(_G.CrystalSaveConfig) == "function" then pcall(_G.CrystalSaveConfig) end
  end

  local function setEnabled(on, skipSave)
    on = on and true or false
    _G.AmbitiousAntiTPBatEnabled = on
    if on then
      if _G.AmbitiousAntiTPBatSpam then
        startSpamLoop()
      else
        stopSpamLoop()
        enableCore()
      end
    else
      stopSpamLoop()
      disableCore()
    end
    refreshUI()
    if not skipSave then saveCfg() end
  end

  local function setSpam(on, skipSave)
    on = on and true or false
    _G.AmbitiousAntiTPBatSpam = on
    if _G.AmbitiousAntiTPBatEnabled then
      if on then
        startSpamLoop()
      else
        stopSpamLoop()
        enableCore()
      end
    else
      stopSpamLoop()
    end
    refreshUI()
    if not skipSave then saveCfg() end
  end

  local function setVersion(v, skipSave)
    v = math.clamp(tonumber(v) or 1, 1, 4)
    local changed = (v ~= _G.AmbitiousAntiTPBatVersion)
    if changed then
      stopSpamLoop()
      disableCore()
      _G.AmbitiousAntiTPBatVersion = v
      if _G.AmbitiousAntiTPBatEnabled then
        if _G.AmbitiousAntiTPBatSpam then startSpamLoop() else enableCore() end
      end
    end
    refreshUI()
    if changed and not skipSave then saveCfg() end
  end

  -- HARD STOP: spegne solo il modulo principale, la Spam resta come impostazione
  local function hardStop()
    if not (ATP_active or _G.AmbitiousAntiTPBatEnabled) then return end
    _G.AmbitiousAntiTPBatEnabled = false
    stopSpamLoop()
    disableCore()
    refreshUI()
    saveCfg()
  end

  local function onDeadTrigger()
    if ATP_active or _G.AmbitiousAntiTPBatEnabled then hardStop() end
  end

  -- ---- ENEMY DEATH WATCHER ----
  local enemyListeners = {}

  local function clearEnemyListeners(plr)
    local t = enemyListeners[plr]
    if t then
      for _, c in ipairs(t) do pcall(function() c:Disconnect() end) end
      enemyListeners[plr] = nil
    end
  end

  local function watchEnemyCharacter(plr, character)
    clearEnemyListeners(plr)
    if not character then return end
    local conns = {}
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
      table.insert(conns, hum.Died:Connect(onDeadTrigger))
      table.insert(conns, hum.HealthChanged:Connect(function(hp)
        if hp <= 0 then onDeadTrigger() end
      end))
    end
    table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
      if not parent then onDeadTrigger() end
    end))
    enemyListeners[plr] = conns
  end

  local function setupEnemyPlayer(plr)
    if plr == LP then return end
    if plr.Character then watchEnemyCharacter(plr, plr.Character) end
    plr.CharacterAdded:Connect(function(c) watchEnemyCharacter(plr, c) end)
  end

  for _, p in ipairs(Players:GetPlayers()) do pcall(setupEnemyPlayer, p) end
  Players.PlayerAdded:Connect(function(p) pcall(setupEnemyPlayer, p) end)
  Players.PlayerRemoving:Connect(function(p) pcall(clearEnemyListeners, p) end)

  -- ---- SELF DEATH + RAGDOLL WATCHER ----
  local selfConns = {}
  local wasRagdolled = false

  local function clearSelfConns()
    for _, c in ipairs(selfConns) do pcall(function() c:Disconnect() end) end
    selfConns = {}
  end

  local function setupSelfWatchers(character)
    clearSelfConns()
    wasRagdolled = false
    if not character then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
      table.insert(selfConns, hum.Died:Connect(onDeadTrigger))
      table.insert(selfConns, hum.HealthChanged:Connect(function(hp)
        if hp <= 0 then onDeadTrigger() end
      end))
      table.insert(selfConns, hum.StateChanged:Connect(function(_, newState)
        local isRag = (newState == Enum.HumanoidStateType.Physics)
        pcall(function()
          if newState == Enum.HumanoidStateType.Ragdoll then isRag = true end
        end)
        if isRag and not wasRagdolled then
          wasRagdolled = true
          onDeadTrigger()
        elseif not isRag then
          wasRagdolled = false
        end
      end))
    end
    table.insert(selfConns, character.AncestryChanged:Connect(function(_, parent)
      if not parent then onDeadTrigger() end
    end))
  end

  if LP.Character then setupSelfWatchers(LP.Character) end

  LP.CharacterAdded:Connect(function(c)
    setupSelfWatchers(c)
    -- Respawn: il vecchio HRP non esiste piu', si riparte spenti
    _G.AmbitiousAntiTPBatEnabled = false
    stopSpamLoop()
    disableCore()
    refreshUI()
  end)

  -- ---- API PUBBLICA ----
  _G.AmbitiousAntiTPBat = {
    setEnabled = function(on, skipSave) setEnabled(on, skipSave) end,
    isEnabled  = function() return _G.AmbitiousAntiTPBatEnabled == true end,
    toggle     = function() setEnabled(not (_G.AmbitiousAntiTPBatEnabled == true)) end,
    setSpam    = function(on, skipSave) setSpam(on, skipSave) end,
    getSpam    = function() return _G.AmbitiousAntiTPBatSpam == true end,
    setVersion = function(v, skipSave) setVersion(v, skipSave) end,
    getVersion = function() return _G.AmbitiousAntiTPBatVersion or 1 end,
    hardStop   = hardStop,
  }

  _G.AmbitiousToggleAntiTPBat = function()
    setEnabled(not (_G.AmbitiousAntiTPBatEnabled == true))
  end

  -- Watchdog: riallinea lo stato reale al flag
  task.spawn(function()
    while true do
      task.wait(0.5)
      if _G.AmbitiousAntiTPBatEnabled then
        if not _G.AmbitiousAntiTPBatSpam and not ATP_active then
          pcall(enableCore)
        end
      elseif ATP_active then
        pcall(disableCore)
      end
    end
  end)
end)()
-- <<< ANTI TP BAT END

-- >>> CRYSTAL ANTI TP BAT ADAPTER BEGIN
-- API compatível com o Crystal + funções do AMBITIOUS:
-- V1 / V2 / V3 / V4 + Spam, hard-stop, morte/ragdoll e lock de movimento.
local AntiTPBat = AntiTPBat or {}
local function _crystalAntiTPSetMode(mode)
    local map = { ORIGINAL = 1, SPACE = 2, VOID = 3, FIXED = 4 }
    local v = map[mode] or tonumber(mode) or 1
    v = math.clamp(v, 1, 4)
    if _G.AmbitiousAntiTPBat then
        _G.AmbitiousAntiTPBat.setVersion(v)
    else
        _G.AmbitiousAntiTPBatVersion = v
    end
    return v
end
local function _crystalAntiTPGetMode()
    local v = (_G.AmbitiousAntiTPBat and _G.AmbitiousAntiTPBat.getVersion and _G.AmbitiousAntiTPBat.getVersion())
        or _G.AmbitiousAntiTPBatVersion or 1
    return math.clamp(tonumber(v) or 1, 1, 4)
end
function AntiTPBat.set(on)
    if _G.AmbitiousAntiTPBat and _G.AmbitiousAntiTPBat.setEnabled then
        _G.AmbitiousAntiTPBat.setEnabled(on == true)
    else
        _G.AmbitiousAntiTPBatEnabled = on == true
    end
    _G.__AntiTPBatEnabled = _G.AmbitiousAntiTPBatEnabled == true
    return _G.__AntiTPBatEnabled
end
function AntiTPBat.toggle()
    return AntiTPBat.set(not (_G.AmbitiousAntiTPBatEnabled == true))
end
function AntiTPBat.isOn()
    return _G.AmbitiousAntiTPBatEnabled == true
end
function AntiTPBat.setMode(mode)
    return _crystalAntiTPSetMode(mode)
end
function AntiTPBat.getMode()
    return _crystalAntiTPGetMode()
end
function AntiTPBat.setSpam(on)
    if _G.AmbitiousAntiTPBat and _G.AmbitiousAntiTPBat.setSpam then
        _G.AmbitiousAntiTPBat.setSpam(on == true)
    else
        _G.AmbitiousAntiTPBatSpam = on == true
    end
end
function AntiTPBat.getSpam()
    return _G.AmbitiousAntiTPBatSpam == true
end
function AntiTPBat.setVersion(v)
    return _crystalAntiTPSetMode(v)
end
function AntiTPBat.getVersion()
    return _crystalAntiTPGetMode()
end
-- <<< CRYSTAL ANTI TP BAT ADAPTER END

local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons) or nil; local _IS_MOBILE = false pcall(function() _IS_MOBILE = UIS.TouchEnabled == true and UIS.KeyboardEnabled ~= true end) pcall(function() if UIS.TouchEnabled and not UIS.MouseEnabled then _IS_MOBILE = true end end) local function _perfEveryN(nMobile, nDesktop) local n = _IS_MOBILE and nMobile or nDesktop if n <= 1 then return true end local bucket = math.floor(os.clock() * 60)
return (bucket % n) == 0 end local function _perfDue(key, mobileSec, desktopSec) return _perfEveryN(math.max(1, math.floor((mobileSec or 0.1) * 60)), math.max(1, math.floor((desktopSec or 0.05) * 60))) end local S = { NS = 60, CS = 30, LAGGER_SPEED = 15, LAGGER_CARRY_SPEED = 24.5, speedMethod = "V1", speedProfiles = { V1 = { normalSpeed = 60, carrySpeed = 30, laggerSpeed = 15, laggerCarrySpeed = 24.5 }, V2 = { normalSpeed = 60, carrySpeed = 30, laggerSpeed = 15, laggerCarrySpeed = 24.5 } }, speedMode = false, antiRagdollEnabled = false, antiRagdollMode = 1, aimbotMode = 1, antiBatBypassEnabled = false, laggerToggled = false, laggerPhase = 0, autoCarrySpeedEnabled = false, setAutoCarrySpeedVisual = nil, _autoCarryFromSteal = false, _autoCarryWaitingPickup = false,
_autoCarryGraceUntil = 0, _autoCarryPickupUntil = 0, _autoCarryReturnMode = nil, _stealAttrWasActive = false, medusaCounterEnabled = false, medusaResetEnabled = false, batCounterEnabled = false, unwalkEnabled = false, medusaDebounce = false, medusaLastUsed = 0, dropActive = false, autoLeftEnabled = false, autoRightEnabled = false, autoLeftSetVisual = nil, autoRightSetVisual = nil, speedLabel = nil, autoBatEnabled = false, batV2Enabled = false, autoSwingEnabled = true, autoBatSetVisual = nil, batV2SetVisual = nil, autoBatEquippedThisRun = false, _autoBatTarget = nil, _autoBatLastScan = 0, resetAutoBatMotion = nil,
AUTO_BAT_SPEED = 58, AUTO_BAT_VERT_SPEED = 52, AUTO_BAT_DIST = -2.8, AUTO_BAT_HEIGHT = 4.75, AUTO_BAT_V_OFF = 1, AUTO_BAT_TURN_SPEED = 285, AUTO_BAT_MAX_TURN_RATE = 28, setBatCounterVisual = nil, startBatCounter = nil, stopBatCounter = nil, enableAutoBat = nil, disableAutoBat = nil, antiLagEnabled = false, removeAccessoriesEnabled = false, antiDieEnabled = false, antiFlingShieldEnabled = false, antiLagDescConn = nil, stretchRezEnabled = false, stretchRezConn = nil, setStretchRezVisual = nil, unwalkSavedAnimate = nil,
_anyKeyListening = false, autoTPEnabled = false, autoTPHeight = 20, autoTPConn = nil, setAutoTPVisual = nil, autoSaveEnabled = true, _lastSaveOk = false, _lastSaveAt = 0, cursedResetRemote = nil, CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42", AntiRagdollConns = {}, noPlayerCollisionEnabled = false, safeModeEnabled = false, autoResetOnMedEnabled = false, showTracerEnabled = false, ragdollCountdownEnabled = false, guiLocked = false, hideMobileButtons = false, lockMobileButtons = false, allLockButtons = false, moveButtons = false, progressBarScale = 100, infJumpMode = "hold",
mirrorTPDownEnabled = false, _bodyLockPausedByCombat = false, _bodyLockWanted = false, _bodyLockPausedByBrainrot = false, mobileButtonScale = 0.80, miniUiScale = 1.00, keyboardOverlayEnabled = false, antiDropEnabled = false, } local VS, UI, F = {}, {}, {} local NS, CS = S.NS, S.CS; local CONFIG_FILE, CONFIG_FILE_LEGACY = "CrystalVSHubConfig.json", "PrimeVSHubConfig.json" local _isfile = isfile or (syn and syn.isfile) or function() return false end local _readfile = readfile or (syn and syn.readfile) or function() return nil end
local _writefile = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or nil; local antiRagdollConn = nil; local antiRagdollModeActive = nil; local ragdollConnections = {}; local cachedCharData = {}; local isBoosting = false; local BOOST_SPEED = 400 local AR_DEFAULT_SPEED = 16 local function arGetNormalSpeed() return AR_DEFAULT_SPEED end local function arV2ResetCharacter(char) local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart") if not hum or not root or hum.Health <= 0 then return end pcall(function()
hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero; root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero hum.PlatformStand = false; hum.Sit = false; hum.AutoRotate = true hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50 hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or AR_DEFAULT_SPEED for _, obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") then obj.Enabled = true
elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then obj.Enabled = true elseif obj:IsA("BasePart") then obj.CanCollide = true; obj.AssemblyLinearVelocity = Vector3.zero; obj.AssemblyAngularVelocity = Vector3.zero end end if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end local playerModule = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule"); local controlModule = playerModule and playerModule:FindFirstChild("ControlModule") if controlModule then
local loaded, module = pcall(require, controlModule) if loaded and module and module.Enable then pcall(function() module:Enable() end) end end end) end local function arCacheCharacterData() local char = LP.Character if not char then return false end local hum = char:FindFirstChildOfClass("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart") if not hum or not root then return false end cachedCharData = { character = char, humanoid = hum, root = root }; S._ragdollCache = cachedCharData return true end local function arDisconnectAll()
for _, conn in ipairs(ragdollConnections) do pcall(function() conn:Disconnect() end) end ragdollConnections = {} end local AR_STATES = { [Enum.HumanoidStateType.Physics] = true, [Enum.HumanoidStateType.Ragdoll] = true, [Enum.HumanoidStateType.FallingDown] = true } local function arIsRagdolled() if not cachedCharData.humanoid then return false end if AR_STATES[cachedCharData.humanoid:GetState()] then return true end local endTime = LP:GetAttribute("RagdollEndTime") return (endTime and (endTime - workspace:GetServerTimeNow()) > 0) or false end local function arForceExitRagdoll()
if not cachedCharData.humanoid or not cachedCharData.root then return end pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end) for _, d in ipairs(cachedCharData.character:GetDescendants()) do if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and tostring(d.Name):find("RagdollAttachment")) then pcall(function() d:Destroy() end) end end if not isBoosting then isBoosting = true pcall(function() cachedCharData.humanoid.WalkSpeed = BOOST_SPEED end) end pcall(function()
if cachedCharData.humanoid.Health > 0 then cachedCharData.humanoid:ChangeState(Enum.HumanoidStateType.Running) end cachedCharData.root.Anchored = false end) end local function arHeartbeatLoop() while antiRagdollModeActive == "v1" do task.wait() local currentlyRagdolled = arIsRagdolled() if currentlyRagdolled then arForceExitRagdoll() elseif isBoosting and not currentlyRagdolled then isBoosting = false if cachedCharData.humanoid then pcall(function() cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end) end end end end function F.startAntiRagdoll()
local requestedMode = (S.antiRagdollMode == 2) and "v2" or "v1" if antiRagdollModeActive == requestedMode and (#S.AntiRagdollConns > 0 or antiRagdollConn) then return end F.stopAntiRagdoll() if not arCacheCharacterData() then return end antiRagdollModeActive = requestedMode if requestedMode == "v2" then antiRagdollConn = RunService.Heartbeat:Connect(function() if antiRagdollModeActive ~= "v2" or not S.antiRagdollEnabled then return end local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid") if not hum then return end local state = hum:GetState()
if AR_STATES[state] or state == Enum.HumanoidStateType.Dead or hum.PlatformStand == true or hum.Sit == true then arV2ResetCharacter(char) end end) table.insert(S.AntiRagdollConns, antiRagdollConn) return end local camConn = RunService.RenderStepped:Connect(function() local cam = workspace.CurrentCamera if cam and cachedCharData.humanoid then cam.CameraSubject = cachedCharData.humanoid end end) table.insert(ragdollConnections, camConn); table.insert(S.AntiRagdollConns, camConn) local respawnConn = LP.CharacterAdded:Connect(function()
isBoosting = false; task.wait(0.5); arCacheCharacterData() end) table.insert(ragdollConnections, respawnConn); table.insert(S.AntiRagdollConns, respawnConn); task.spawn(arHeartbeatLoop) end function F.stopAntiRagdoll() antiRagdollModeActive = nil if antiRagdollConn then pcall(function() antiRagdollConn:Disconnect() end); antiRagdollConn = nil end if isBoosting and cachedCharData.humanoid then pcall(function() cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end) end isBoosting = false; arDisconnectAll() for _, conn in pairs(S.AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
S.AntiRagdollConns = {}; cachedCharData = {}; S._ragdollCache = {} end local _adDeathConns = {}; local _adHeartConn = nil; local _adCharConn = nil; local _afsLoop = nil local _antiDie = { loop = nil, healthConn = nil, diedConn = nil, humanoid = nil, lastHealTime = 0, invincibleUntil = 0, config = { healthThreshold = 50, invincibilityFrames = 0.75, ragdollProtection = true, autoRevive = true }, } local function _adDisconnectHumanoid() if _antiDie.healthConn then pcall(function() _antiDie.healthConn:Disconnect() end); _antiDie.healthConn = nil end
if _antiDie.diedConn then pcall(function() _antiDie.diedConn:Disconnect() end); _antiDie.diedConn = nil end _antiDie.humanoid = nil end local function _adDisconnectAll() for _, c in ipairs(_adDeathConns) do pcall(function() c:Disconnect() end) end _adDeathConns = {} if _adHeartConn then pcall(function() _adHeartConn:Disconnect() end); _adHeartConn = nil end _adDisconnectHumanoid() end local function _adSuperHeal(hum) if not hum or not hum.Parent then return end local maxHealth = hum.MaxHealth or 100 if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end pcall(function()
hum.Health = maxHealth if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end end) _antiDie.invincibleUntil = tick() + (_antiDie.config.invincibilityFrames or 0.75) _antiDie.lastHealTime = tick() pcall(function() local char = hum.Parent if not char then return end for _, child in ipairs(char:GetChildren()) do if child:IsA("NumberValue") then local name = child.Name:lower() if name:find("health") or name:find("hp") or name:find("life") then child.Value = maxHealth end end if child:IsA("BoolValue") and child.Name:lower():find("dead") then child.Value = false end end end) end
local function _adPreventDamage(root, hum) if not hum then return end if hum.Health < (hum.MaxHealth or 100) then _adSuperHeal(hum) end if tick() < (_antiDie.invincibleUntil or 0) then if hum.Health < (hum.MaxHealth or 100) then pcall(function() hum.Health = hum.MaxHealth or 100 end) end end if _antiDie.config.ragdollProtection then local state = hum:GetState() if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Dead then pcall(function()
hum:ChangeState(Enum.HumanoidStateType.GettingUp) hum:ChangeState(Enum.HumanoidStateType.Running) end) _adSuperHeal(hum) if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero root.AssemblyLinearVelocity = Vector3.new( root.AssemblyLinearVelocity.X, math.max(root.AssemblyLinearVelocity.Y, -10), root.AssemblyLinearVelocity.Z ) end) end end end if hum.Health <= 0 then _adSuperHeal(hum) pcall(function() hum.PlatformStand = false hum.Sit = false hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end end function F.applyAntiReset()
pcall(function() game:GetService("StarterGui"):SetCore("ResetButtonCallback", false) end) end function F.restoreReset() pcall(function() game:GetService("StarterGui"):SetCore("ResetButtonCallback", true) end) end local function protectCharClean(char) if not S.antiDieEnabled then return end char = char or LP.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if not hum then local ok, waited = pcall(function() return char:WaitForChild("Humanoid", 3) end) if ok and waited and waited:IsA("Humanoid") then hum = waited end end
if not hum or not S.antiDieEnabled then return end _adDisconnectHumanoid() _antiDie.humanoid = hum pcall(function() hum.BreakJointsOnDeath = false hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end) _adSuperHeal(hum) _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function() if not S.antiDieEnabled or not hum.Parent then return end if hum.Health <= 0 or hum.Health < (_antiDie.config.healthThreshold or 50) then _adSuperHeal(hum) end end) table.insert(_adDeathConns, _antiDie.healthConn) _antiDie.diedConn = hum.Died:Connect(function()
if not S.antiDieEnabled or not char.Parent then return end task.wait() if not S.antiDieEnabled or not char.Parent then return end pcall(function() local newHum = Instance.new("Humanoid") newHum.Name = "ReplacedHumanoid" newHum.BreakJointsOnDeath = false newHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) local maxH = (hum.MaxHealth and hum.MaxHealth > 0 and hum.MaxHealth ~= math.huge) and hum.MaxHealth or 100 newHum.MaxHealth = maxH newHum.Health = maxH newHum.Parent = char if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = newHum end
if hum.Parent then hum:Destroy() end end) if S.antiDieEnabled then protectCharClean(char) end end) table.insert(_adDeathConns, _antiDie.diedConn) end function F.startAntiDie() S.antiDieEnabled = true _adDisconnectAll() if _antiDie.loop then pcall(function() _antiDie.loop:Disconnect() end); _antiDie.loop = nil end if _adCharConn then pcall(function() _adCharConn:Disconnect() end); _adCharConn = nil end _antiDie.loop = RunService.Heartbeat:Connect(function() if not S.antiDieEnabled then return end local char = LP.Character if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid") local root = char:FindFirstChild("HumanoidRootPart") if not hum then return end _adPreventDamage(root, hum) end) _adHeartConn = _antiDie.loop _adCharConn = LP.CharacterAdded:Connect(function(c) if not S.antiDieEnabled then return end task.defer(function() protectCharClean(c) end) task.spawn(function() for _ = 1, 12 do if not S.antiDieEnabled then return end F.applyAntiReset() task.wait(0.25) end end) end) task.defer(function() protectCharClean(LP.Character) end) F.applyAntiReset() task.spawn(function() for _ = 1, 12 do
if not S.antiDieEnabled then return end F.applyAntiReset() task.wait(0.25) end end) end function F.stopAntiDie() S.antiDieEnabled = false if _antiDie.loop then pcall(function() _antiDie.loop:Disconnect() end); _antiDie.loop = nil end if _adCharConn then pcall(function() _adCharConn:Disconnect() end); _adCharConn = nil end local hum = _antiDie.humanoid _adDisconnectAll() if hum and hum.Parent then pcall(function() hum.BreakJointsOnDeath = true hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end) end local char = LP.Character; local chum = char and char:FindFirstChildOfClass("Humanoid")
if chum then pcall(function() chum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) if chum.MaxHealth == math.huge then chum.MaxHealth = 100 end chum.Health = math.min(chum.Health, chum.MaxHealth) if chum.Health <= 0 then chum.Health = chum.MaxHealth end end) end F.restoreReset() end local ANTI_FLING_MAX_LIN = 160 local ANTI_FLING_MAX_ANG = 45 local ANTI_FLING_AIMBOT_LIN = 220 local ANTI_FLING_AIMBOT_ANG = 60 local function _antiFlingApply(root, char, maxLin, maxAng) if not root or not root.Parent then return end pcall(function() local v = root.AssemblyLinearVelocity
local horiz = Vector3.new(v.X, 0, v.Z) local hMag = horiz.Magnitude if hMag > maxLin then local scale = maxLin / hMag root.AssemblyLinearVelocity = Vector3.new(v.X * scale, v.Y, v.Z * scale) elseif v.Magnitude > maxLin * 1.35 then root.AssemblyLinearVelocity = v.Unit * maxLin end local av = root.AssemblyAngularVelocity if av.Magnitude > maxAng then root.AssemblyAngularVelocity = Vector3.zero end if char then for _, p in ipairs(char:GetChildren()) do if p:IsA("BasePart") and p ~= root then local pv = p.AssemblyLinearVelocity local ph = Vector3.new(pv.X, 0, pv.Z)
if ph.Magnitude > maxLin * 1.2 then local scale = (maxLin * 1.05) / ph.Magnitude p.AssemblyLinearVelocity = Vector3.new(pv.X * scale, pv.Y, pv.Z * scale) end if p.AssemblyAngularVelocity.Magnitude > maxAng then p.AssemblyAngularVelocity = Vector3.zero end end end end end) end
-- ANTI DROP: velocity spoof isolated from the original 404 utility.
do
local _antiDrop = { active = false, mt = nil, oldIndex = nil, oldNewIndex = nil, spoofedVelocity = Vector3.zero }
local function _antiDropRestore()
 if not _antiDrop.active then return end
 local mt = _antiDrop.mt
 if mt and _antiDrop.oldIndex and _antiDrop.oldNewIndex then
  pcall(function()
   setreadonly(mt, false)
   mt.__index = _antiDrop.oldIndex
   mt.__newindex = _antiDrop.oldNewIndex
   setreadonly(mt, true)
  end)
 end
 _antiDrop.active = false; _antiDrop.mt = nil; _antiDrop.oldIndex = nil; _antiDrop.oldNewIndex = nil; _antiDrop.spoofedVelocity = Vector3.zero
end
function F.startAntiDrop()
 if _antiDrop.active then S.antiDropEnabled = true; return true end
 if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then
  S.antiDropEnabled = false; warn("[snow.vs] Anti Drop unsupported by this executor"); return false
 end
 local ok, mt = pcall(getrawmetatable, game)
 if not ok or not mt then S.antiDropEnabled = false; return false end
 local oldIndex, oldNewIndex = mt.__index, mt.__newindex
 if not oldIndex or not oldNewIndex then S.antiDropEnabled = false; return false end
 _antiDrop.mt = mt; _antiDrop.oldIndex = oldIndex; _antiDrop.oldNewIndex = oldNewIndex
 local installed = pcall(function()
  setreadonly(mt, false)
  mt.__index = newcclosure(function(self, key)
   if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and LP.Character and self:IsDescendantOf(LP.Character) then
    return _antiDrop.spoofedVelocity
   end
   return oldIndex(self, key)
  end)
  mt.__newindex = newcclosure(function(self, key, value)
   if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and LP.Character and self:IsDescendantOf(LP.Character) then
    _antiDrop.spoofedVelocity = value
    return
   end
   return oldNewIndex(self, key, value)
  end)
  setreadonly(mt, true)
 end)
 if not installed then
  pcall(function() setreadonly(mt, true) end)
  _antiDrop.mt = nil; _antiDrop.oldIndex = nil; _antiDrop.oldNewIndex = nil; S.antiDropEnabled = false
  warn("[snow.vs] Anti Drop failed to start"); return false
 end
 _antiDrop.active = true; S.antiDropEnabled = true
 _genv.__CrystalAntiDropCleanup = _antiDropRestore
 return true
end
function F.stopAntiDrop()
 S.antiDropEnabled = false
 _antiDropRestore()
 if _genv.__CrystalAntiDropCleanup == _antiDropRestore then _genv.__CrystalAntiDropCleanup = nil end
end
end
function F.startAntiFlingShield() S.antiFlingShieldEnabled = true if _afsLoop then pcall(function() _afsLoop:Disconnect() end); _afsLoop = nil end _afsLoop = RunService.Heartbeat:Connect(function() if not S.antiFlingShieldEnabled then return end local char = LP.Character if not char then return end
local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local aimOn = (S.autoBatEnabled == true) or (tpBatEnabled == true) or (S.antiBatBypassEnabled == true) local maxLin = aimOn and ANTI_FLING_AIMBOT_LIN or ANTI_FLING_MAX_LIN local maxAng = aimOn and ANTI_FLING_AIMBOT_ANG or ANTI_FLING_MAX_ANG _antiFlingApply(root, char, maxLin, maxAng) end) end function F.stopAntiFlingShield() S.antiFlingShieldEnabled = false if _afsLoop then pcall(function() _afsLoop:Disconnect() end); _afsLoop = nil end end
local removeAccConn = nil; local removeAccChildConn = nil; local removeAccActive = false local function isHatOrHairAccessory(accessory) if not accessory or not accessory:IsA("Accessory") then return false end local accessoryType = nil pcall(function() accessoryType = accessory.AccessoryType end) if accessoryType == Enum.AccessoryType.Hat or accessoryType == Enum.AccessoryType.Hair then return true end for _, item in ipairs(accessory:GetDescendants()) do if item:IsA("Attachment") and (item.Name == "HatAttachment" or item.Name == "HairAttachment") then return true end end
local lowerName = tostring(accessory.Name):lower() return lowerName:find("hair", 1, true) ~= nil or lowerName:find("hat", 1, true) ~= nil end local function removeCharAccessories(char) if not char then return end for _, child in ipairs(char:GetChildren()) do pcall(function() if child:IsA("Accessory") and isHatOrHairAccessory(child) then child:Destroy() end end) end end function F.startRemoveAccessories() removeAccActive = true; S.removeAccessoriesEnabled = true local function bindCharacter(char) if removeAccChildConn then removeAccChildConn:Disconnect(); removeAccChildConn = nil end
removeCharAccessories(char) if char then removeAccChildConn = char.ChildAdded:Connect(function(child) if not removeAccActive or not child:IsA("Accessory") then return end task.defer(function() if child.Parent == char then removeCharAccessories(char) end end) end) end end bindCharacter(LP.Character) if removeAccConn then removeAccConn:Disconnect() end removeAccConn = LP.CharacterAdded:Connect(function(char) task.wait(0.15) bindCharacter(char) end) end function F.stopRemoveAccessories() removeAccActive = false; S.removeAccessoriesEnabled = false
if removeAccConn then removeAccConn:Disconnect(); removeAccConn = nil end if removeAccChildConn then removeAccChildConn:Disconnect(); removeAccChildConn = nil end end local moveProxy = nil function F.ensureProxy() local c = LP.Character if not c then return nil end local root = c:FindFirstChild("HumanoidRootPart") if not root then return nil end if moveProxy and moveProxy.Parent == c then return moveProxy end if moveProxy then moveProxy:Destroy() end
moveProxy = Instance.new("Part"); moveProxy.Name = "CursedHub_MoveProxy"; moveProxy.Size = Vector3.new(1, 1, 1); moveProxy.Transparency = 1; moveProxy.CanCollide = false; moveProxy.Massless = true; moveProxy.Parent = c; local weld = Instance.new("WeldConstraint"); weld.Part0 = root; weld.Part1 = moveProxy; weld.Parent = moveProxy return moveProxy end function F.destroyProxy() if moveProxy then moveProxy:Destroy(); moveProxy = nil end end local infJumpEnabled = false; local holdInfJumpConn = nil; local infJumpInputConns = {}; local INF_JUMP_POWER = 55 local function applyJumpVel(root, y)
if not root or not root.Parent then return end pcall(function() local cv = root.AssemblyLinearVelocity root.AssemblyLinearVelocity = Vector3.new(cv.X, y, cv.Z) end) end local function manualJumpBoost(boost) if not infJumpEnabled then return end if (S.infJumpMode or "hold") ~= "manual" then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if root then applyJumpVel(root, boost or INF_JUMP_POWER) end end local function startHoldInfJump() if holdInfJumpConn then return end holdInfJumpConn = RunService.Heartbeat:Connect(function()
if not infJumpEnabled then return end if (S.infJumpMode or "hold") ~= "hold" then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end local isJumpHeld = false pcall(function() isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.ButtonA) or (hum.Jump == true) end) local cv = root.AssemblyLinearVelocity if isJumpHeld and cv.Y < 35 then applyJumpVel(root, INF_JUMP_POWER) end cv = root.AssemblyLinearVelocity
if cv.Y < -120 then applyJumpVel(root, -120) end end) end local function stopHoldInfJump() if holdInfJumpConn then pcall(function() holdInfJumpConn:Disconnect() end) holdInfJumpConn = nil end end function F.startInfJump() for _, c in ipairs(infJumpInputConns) do pcall(function() c:Disconnect() end) end infJumpInputConns = {}; stopHoldInfJump() table.insert(infJumpInputConns, UIS.JumpRequest:Connect(function() if not infJumpEnabled then return end if (S.infJumpMode or "hold") == "manual" then manualJumpBoost(50) end end))
table.insert(infJumpInputConns, UIS.InputBegan:Connect(function(input, gp) if gp or UIS:GetFocusedTextBox() then return end if not infJumpEnabled then return end if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then if (S.infJumpMode or "hold") == "manual" then manualJumpBoost(50) end end end)) if (S.infJumpMode or "hold") == "hold" then startHoldInfJump() end end function F.stopInfJump() stopHoldInfJump() for _, c in ipairs(infJumpInputConns) do pcall(function() c:Disconnect() end) end infJumpInputConns = {} end function F.setInfJumpMode(mode)
mode = (mode == "manual") and "manual" or "hold"; S.infJumpMode = mode if infJumpEnabled then F.startInfJump() else stopHoldInfJump() end end local mirrorTPPreviousY = {}; local mirrorTPLastTeleport = 0; local mirrorTPConn = nil local function mirrorTPAimbotActive() return (aimbotEnabled == true) or (tpBatEnabled == true) or (S.autoBatEnabled == true) or (_G.MirrorNormalAimbotOn == true) or (_G.MirrorAntiBypassAimbotOn == true) or (_G.MirrorAntiDesyncAimbotOn == true) end local MIRROR_TP_DROP_THRESHOLD = 3; local MIRROR_TP_DOWN_Y = -7.00 local function mirrorTPTeleportDown()
local character = LP.Character; local root = character and character:FindFirstChild("HumanoidRootPart"); local humanoid = character and character:FindFirstChildOfClass("Humanoid") if not root or not humanoid or humanoid.Health <= 0 then return end local now = tick() if now - (mirrorTPLastTeleport or 0) < 0.08 then return end mirrorTPLastTeleport = now; local _, yaw = root.CFrame:ToEulerAnglesYXZ(); root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z) * CFrame.Angles(0, yaw, 0); root.Velocity = Vector3.zero
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end) end function F.startMirrorTPDown() if mirrorTPConn then return end S.mirrorTPDownEnabled = true _G.MirrorSetTPDown = function(enabled) S.mirrorTPDownEnabled = enabled == true if not S.mirrorTPDownEnabled then mirrorTPPreviousY = {} end end mirrorTPConn = RunService.Heartbeat:Connect(function() if not S.mirrorTPDownEnabled then return end if not mirrorTPAimbotActive() then if next(mirrorTPPreviousY) then mirrorTPPreviousY = {} end return end for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart") if tr then local currentY = tr.Position.Y; local previousY = mirrorTPPreviousY[plr.UserId] if previousY and (previousY - currentY) >= MIRROR_TP_DROP_THRESHOLD then pcall(mirrorTPTeleportDown); mirrorTPPreviousY = {} return end mirrorTPPreviousY[plr.UserId] = currentY end end end end) end function F.stopMirrorTPDown() S.mirrorTPDownEnabled = false if mirrorTPConn then pcall(function() mirrorTPConn:Disconnect() end) mirrorTPConn = nil end mirrorTPPreviousY = {} end function F.startFloat() end function F.stopFloat() end
function F.setFloat(on) end function F.toggleFloat() end function F.getFloatSpeed() return 0 end function F.setFloatModeSpeed(v) end function F.cycleFloatMode() return "normal" end function F.setMirrorTPDown(on) if on then F.startMirrorTPDown() else F.stopMirrorTPDown() end if VS.setMirrorTPVisual then VS.setMirrorTPVisual(on == true) end end local aimbotEnabled = false; local tpBatEnabled = false; local tpBatMode = 1; local TP_BAT_KEY = Enum.KeyCode.V; local TP_BAT_CONTROLLER = Enum.KeyCode.ButtonY; local setTPBatVisual, tpBatUIState, tpBatModeLbl = nil, nil, nil
local setAimbotState, setTPBatState, getTPBatMode, findBatTool, getClosestAliveRoot local TP_BAT_MODES local startAimbot, stopAimbot, startTPBat, stopTPBat local function __initAimbotTPBat() aimbotEnabled = false; local aimbotConn = nil; tpBatEnabled = false; local aimbotSwingCooldown = false; local AIMBOT_SPEED = 63; local AIMBOT_VERT_SPEED = 52; local AIMBOT_DISTANCE = -2.8; local AIMBOT_HEIGHT = 4.75; local AIMBOT_V_OFFSET = 1; local AIMBOT_MAX_TURN_RATE = 28; local AIMBOT_SWING_DIST = 5; local AIMBOT_SWING_CD = 0.3; local _aimbotLastSwing = 0 findBatTool = function()
local char = LP.Character if not char then return nil end for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end end local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack") if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end end end return nil end local function swingBatTool() if aimbotSwingCooldown then return end aimbotSwingCooldown = true pcall(function() local bat = findBatTool()
local char = LP.Character if not bat or not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end local remote = bat:FindFirstChildOfClass("RemoteEvent") if remote then pcall(function() remote:FireServer() end) else pcall(function() bat:Activate() end) end end) task.delay(0.09, function() aimbotSwingCooldown = false end) end local _closestCache, _closestCacheAt = nil, 0 getClosestAliveRoot = function() local now = os.clock(); local ttl = _IS_MOBILE and 0.07 or 0.025
if _closestCache and (now - _closestCacheAt) < ttl then if _closestCache.Parent then return _closestCache end end local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local d = (tRoot.Position - root.Position).Magnitude if d < minDist then
minDist = d; closest = tRoot end end end end _closestCache, _closestCacheAt = closest, now return closest end startAimbot = function()
    if aimbotConn then return end
    if tpBatEnabled then return end
    pcall(function()
        if K7 and K7.bodyLockEnabled then
            S._bodyLockPausedByCombat = true
            if K7.stopBodyLock then K7.stopBodyLock() end
            if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(false) end
        end
    end)
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    local prevAutoRotate = hum0 and hum0.AutoRotate
    if hum0 then hum0.AutoRotate = false end
    aimbotEnabled = true

    aimbotConn = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled or tpBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if hum.AutoRotate then hum.AutoRotate = false end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBatTool and findBatTool() or nil
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = getClosestAliveRoot and getClosestAliveRoot() or nil
        if not target or not target.Parent then
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end

        -- Clean Aimbot: prediction + aproximação + rotação suave.
        local targetVel = target.AssemblyLinearVelocity or Vector3.zero
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3

        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.zero
        end

        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * AIMBOT_SPEED, yVel, flatDir.Z * AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end

        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then
            local now = tick()
            if now - _aimbotLastSwing >= AIMBOT_SWING_CD then
                _aimbotLastSwing = now
                if swingBatTool then
                    pcall(swingBatTool)
                end
            end
        end
    end)
end
stopAimbot = function()
    aimbotEnabled = false
    if aimbotConn then
        pcall(function() aimbotConn:Disconnect() end)
        aimbotConn = nil
    end
    if not tpBatEnabled then
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
            root.AssemblyAngularVelocity = Vector3.zero
        end
        local hum2 = c and c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2.AutoRotate = true end
    end
    aimbotSwingCooldown = false
    pcall(function()
        if S._bodyLockPausedByCombat and not tpBatEnabled and K7 and K7.startBodyLock then
            S._bodyLockPausedByCombat = false
            K7.startBodyLock()
            if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(true) end
        end
    end)
end
setAimbotState = function(on) if on then pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end) pcall(function() if stopAimbot then stopAimbot() end end)
if (S.aimbotMode or 1) == 2 then F.startAimbotBypassAntiBat() else startAimbot() end else pcall(function() if stopAimbot then stopAimbot() end end) pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end) end end local function isAimbotAnyOn() return aimbotEnabled == true or antiBatBypassLockEnabled == true or S.antiBatBypassEnabled == true end local tpBatConn, tpBatSwingCd, tpBatWasAimbot = nil, false, false TP_BAT_MODES = { [1] = { name = "V1", speed = 200, cameraSpeed = 200, height = 1.2, hitDist = 10, doTP = true },
[2] = { name = "V2", speed = 70, cameraSpeed = 70, height = 0.9, hitDist = 12, doTP = true }, [3] = { name = "V3", speed = 200, cameraSpeed = 200, height = 0.55, hitDist = 8, doTP = true, sureHit = true }, } getTPBatMode = function() return TP_BAT_MODES[tpBatMode] or TP_BAT_MODES[1] end local function tpBatSwing() if tpBatSwingCd then return end if S.autoSwingEnabled == false then return end tpBatSwingCd = true task.delay(0.08, function() tpBatSwingCd = false end) pcall(function() local char = LP.Character if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid"); local bat = findBatTool and findBatTool() or nil if not bat then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("bat") or n:find("slap") or n:find("glove") then bat = t; break end end end end if not bat then local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack") if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("bat") or n:find("slap") or n:find("glove") then bat = t; break end end end end end
if not bat or not hum then return end if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end pcall(function() bat:Activate() end) local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildWhichIsA("RemoteEvent") if remote then pcall(function() remote:FireServer() end) end end) end local function tpBatAntiDie(char, hum) pcall(function() hum.MaxHealth = math.max(hum.MaxHealth, 100) hum.Health = hum.MaxHealth; hum.BreakJointsOnDeath = false; hum.RequiresNeck = false; hum.PlatformStand = false; hum.Sit = false pcall(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false); hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false); hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) end) local st = hum:GetState() if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then hum:ChangeState(Enum.HumanoidStateType.Running) end if not char:FindFirstChild("K7TPBatFF") then
local ff = Instance.new("ForceField"); ff.Name = "K7TPBatFF"; ff.Visible = false; ff.Parent = char end end) end local function tpBatAntiFling(char, root) pcall(function() local maxLin, maxAng = 85, 15 local v = root.AssemblyLinearVelocity if v.Magnitude > maxLin then root.AssemblyLinearVelocity = v.Unit * maxLin end if root.AssemblyAngularVelocity.Magnitude > maxAng then root.AssemblyAngularVelocity = Vector3.zero end for _, p in ipairs(char:GetChildren()) do if p:IsA("BasePart") and p ~= root then if p.AssemblyLinearVelocity.Magnitude > maxLin * 1.1 then
p.AssemblyLinearVelocity = p.AssemblyLinearVelocity.Unit * maxLin end if p.AssemblyAngularVelocity.Magnitude > maxAng then p.AssemblyAngularVelocity = Vector3.zero end end end end) end local function tpBatLoopV1() return RunService.Heartbeat:Connect(function() if not tpBatEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum or hum.Health <= 0 then return end pcall(function() local bat = findBatTool and findBatTool() or nil
if bat and bat.Parent ~= char then hum:EquipTool(bat) end end) tpBatAntiDie(char, hum) local targetRoot = getClosestAliveRoot and getClosestAliveRoot() or nil if not targetRoot or not targetRoot.Parent then return end pcall(function() if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end end) local back = targetRoot.CFrame.LookVector
local flatBack = Vector3.new(back.X, 0, back.Z); local offset = (flatBack.Magnitude < 0.05) and Vector3.new(0, 1.2, 2.2) or (Vector3.new(0, 1.2, 0) - flatBack.Unit * 2.2); local targetPos = targetRoot.Position + offset; local dist = (root.Position - targetPos).Magnitude if dist > 10 then root.CFrame = CFrame.new(targetPos, targetRoot.Position); root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero elseif dist > 2.5 then local dir = targetPos - root.Position; local flatDir = Vector3.new(dir.X, 0, dir.Z) if flatDir.Magnitude > 0.05 then
root.AssemblyLinearVelocity = flatDir.Unit * math.min(200, dist * 8) + Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.2, 0) end local flat = Vector3.new(targetRoot.Position.X - root.Position.X, 0, targetRoot.Position.Z - root.Position.Z) if flat.Magnitude > 0.1 then root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit) end else local flat = Vector3.new(targetRoot.Position.X - root.Position.X, 0, targetRoot.Position.Z - root.Position.Z) if flat.Magnitude > 0.1 then root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit) end
local v = root.AssemblyLinearVelocity; root.AssemblyLinearVelocity = Vector3.new(v.X * 0.5, math.max(v.Y, -10), v.Z * 0.5) end pcall(function() local cam = workspace.CurrentCamera if cam then local camGoal = CFrame.new(cam.CFrame.Position, targetRoot.Position); local camSpd = (TP_BAT_MODES and TP_BAT_MODES[1] and TP_BAT_MODES[1].cameraSpeed) or 200; cam.CFrame = cam.CFrame:Lerp(camGoal, math.clamp(camSpd * 0.016, 0, 1)) end end) tpBatSwing() tpBatAntiFling(char, root) end) end local function tpBatLoopV2() local function getClosestRootV2() local char = LP.Character local root = char and char:FindFirstChild("HumanoidRootPart") if not root then return nil, math.huge end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart") local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local dist = (tRoot.Position - root.Position).Magnitude if dist < minDist then minDist = dist; closest = tRoot end end end end return closest, minDist end pcall(function() local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum0 then hum0.AutoRotate = false end end) _G.__FlowTPBatV2Token = (_G.__FlowTPBatV2Token or 0) + 1 local token = _G.__FlowTPBatV2Token
task.spawn(function() while tpBatEnabled and tpBatMode == 2 and token == _G.__FlowTPBatV2Token do task.wait(0.05) if not tpBatEnabled or tpBatMode ~= 2 or token ~= _G.__FlowTPBatV2Token then break end local target = select(1, getClosestRootV2()) if target then local char = LP.Character local hrp = char and char:FindFirstChild("HumanoidRootPart") if hrp then pcall(function() local targetPos = target.Position + Vector3.new(0, 0.9, 0) if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = CFrame.new(targetPos) end local cam = workspace.CurrentCamera
if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position) end if sethiddenproperty then pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", target) end) end end) end end end end) return RunService.RenderStepped:Connect(function() if not tpBatEnabled or tpBatMode ~= 2 then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end tpBatAntiDie(char, hum) if not char:FindFirstChildOfClass("Tool") then
local bat = findBatTool and findBatTool() or nil if bat then pcall(function() hum:EquipTool(bat) end) end end local target, targetDist = getClosestRootV2() if not target then return end local myPos = root.Position local targetPos = target.Position local direction = targetPos - myPos local flatDir = Vector3.new(direction.X, 0, direction.Z) if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end local chaseSpeed = 58 local desiredHeight = targetPos.Y + 3.7 local yVel = (desiredHeight - myPos.Y) * 19.5
if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end yVel = math.clamp(yVel, -70, 110) local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed) root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8) local toTarget = targetPos - myPos if toTarget.Magnitude > 0.1 then local goalCF = CFrame.lookAt(myPos, targetPos) local diffCF = root.CFrame:Inverse() * goalCF local rx, ry, rz = diffCF:ToEulerAnglesXYZ() rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5)
root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42)) end if targetDist <= 8 then tpBatSwing() end tpBatAntiFling(char, root) end) end local function tpBatLoopV3() local sureCD = false local function sureHitSwing() if S.autoSwingEnabled == false then return end if sureCD then return end sureCD = true pcall(function() local bat = findBatTool and findBatTool() or nil local char = LP.Character if not bat or not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if bat.Parent ~= char and hum then
pcall(function() hum:EquipTool(bat) end) end for _ = 1, 3 do pcall(function() bat:Activate() end) local ev = bat:FindFirstChildWhichIsA("RemoteEvent") if ev then pcall(function() ev:FireServer() end) end end local rf = bat:FindFirstChildWhichIsA("RemoteFunction") if rf then pcall(function() rf:InvokeServer() end) end end) task.delay(0.045, function() sureCD = false end) end local function camLookFlat() local cam = workspace.CurrentCamera local look if cam then look = cam.CFrame.LookVector else
local c = LP.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); look = r and r.CFrame.LookVector or Vector3.new(0, 0, -1) end local flat = Vector3.new(look.X, 0, look.Z) if flat.Magnitude < 0.05 then flat = Vector3.new(0, 0, -1) end return flat.Unit end return RunService.Heartbeat:Connect(function() if not tpBatEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum or hum.Health <= 0 then return end
if tpBatAntiDie then tpBatAntiDie(char, hum) end pcall(function() local bat = findBatTool and findBatTool() or nil if bat and bat.Parent ~= char then hum:EquipTool(bat) end end) local targetRoot = getClosestAliveRoot and getClosestAliveRoot() or nil if not targetRoot or not targetRoot.Parent then return end pcall(function() if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end end) local look = camLookFlat()
local tVel = targetRoot.AssemblyLinearVelocity or Vector3.zero; local pred = targetRoot.Position + Vector3.new(tVel.X, 0, tVel.Z) * 0.08; local standDist = 2.0; local standPos = pred - look * standDist + Vector3.new(0, 0.55, 0); local faceAt = Vector3.new(pred.X, standPos.Y, pred.Z); local goal = CFrame.lookAt(standPos, faceAt); root.CFrame = root.CFrame:Lerp(goal, 0.62); local v = root.AssemblyLinearVelocity; root.AssemblyLinearVelocity = Vector3.new(v.X * 0.35, v.Y, v.Z * 0.35) pcall(function() local cam = workspace.CurrentCamera if cam then
local camGoal = CFrame.new(cam.CFrame.Position, targetRoot.Position + Vector3.new(0, 0.5, 0)); local camSpd = (TP_BAT_MODES and TP_BAT_MODES[3] and TP_BAT_MODES[3].cameraSpeed) or 200; cam.CFrame = cam.CFrame:Lerp(camGoal, math.clamp(camSpd * 0.016, 0, 1)) end end) sureHitSwing() if tpBatAntiFling then tpBatAntiFling(char, root) end end) end startTPBat = function() if tpBatConn then pcall(function() tpBatConn:Disconnect() end) tpBatConn = nil end tpBatEnabled = true if tpBatMode ~= 1 and tpBatMode ~= 2 and tpBatMode ~= 3 then tpBatMode = 1 end pcall(function() if K7 and K7.bodyLockEnabled then S._bodyLockPausedByCombat = true if K7.stopBodyLock then K7.stopBodyLock() end end end) if aimbotEnabled or (S.antiBatBypassEnabled == true) then
tpBatWasAimbot = true pcall(function() if stopAimbot then stopAimbot() end end) pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end) else tpBatWasAimbot = false end if S.autoBatEnabled then pcall(function() if S.disableAutoBat then S.disableAutoBat() end end) end pcall(function() if F.destroyProxy then F.destroyProxy() end end) local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum0 then hum0.AutoRotate = false pcall(function() hum0.BreakJointsOnDeath = false hum0:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end) end
if tpBatMode == 3 then tpBatConn = tpBatLoopV3() elseif tpBatMode == 2 then tpBatConn = tpBatLoopV2() else tpBatConn = tpBatLoopV1() end if tpBatUIState then tpBatUIState(true) end if VS and VS.setTPBatVisual then pcall(function() VS.setTPBatVisual(true) end) end end stopTPBat = function() tpBatEnabled = false if tpBatConn then pcall(function() tpBatConn:Disconnect() end) tpBatConn = nil end tpBatSwingCd = false; local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart") if root then root.AssemblyAngularVelocity = Vector3.zero pcall(function()
if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", root) end end) end pcall(function() if c then local ff = c:FindFirstChild("K7TPBatFF") if ff then ff:Destroy() end end end) local hum2 = c and c:FindFirstChildOfClass("Humanoid") if hum2 then hum2.AutoRotate = true pcall(function() hum2.BreakJointsOnDeath = true hum2.RequiresNeck = true; hum2:SetStateEnabled(Enum.HumanoidStateType.Dead, true); hum2:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true); hum2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true); hum2:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
end) end if tpBatWasAimbot then tpBatWasAimbot = false task.defer(function() if not tpBatEnabled and setAimbotState then setAimbotState(true) if VS and VS.setAimbotVisual then pcall(function() VS.setAimbotVisual(true) end) end end end) end if tpBatUIState then tpBatUIState(false) end if VS and VS.setTPBatVisual then pcall(function() VS.setTPBatVisual(false) end) end task.defer(function() pcall(function() if S._bodyLockPausedByCombat and not aimbotEnabled and not tpBatEnabled and K7 and K7.startBodyLock then S._bodyLockPausedByCombat = false; K7.startBodyLock()
if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(true) end end end) end) end setTPBatState = function(on) if on then startTPBat() else stopTPBat() end end local antiBatBypassLockEnabled = false; local AceAntiBypassAimbot = { conn = nil, swingCooldown = false, prevAutoRotate = nil }; local AceAntiBypassAimbotSpeed = 58; local AceAntiBypassLaggerAimbotSpeed = 40 local function GetAntiBypassAimbotSpeed() if S.laggerToggled then return tonumber(AceAntiBypassLaggerAimbotSpeed) or 40 end return tonumber(AceAntiBypassAimbotSpeed) or 58 end local function AntiBypassGetClosest()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil, math.huge end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local dist = (tRoot.Position - root.Position).Magnitude if dist < minDist then minDist = dist; closest = tRoot end end end end return closest, minDist end local function AntiBypassFindBat()
if findBatTool then return findBatTool() end local char = LP.Character if not char then return nil end for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then local n = tool.Name:lower() if n:find("bat") or n:find("slap") then return tool end end end local bp = LP:FindFirstChild("Backpack") if bp then for _, tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") then local n = tool.Name:lower() if n:find("bat") or n:find("slap") then return tool end end end end return nil end local function AntiBypassTrySwing() if AceAntiBypassAimbot.swingCooldown then return end
if S.autoSwingEnabled == false then return end AceAntiBypassAimbot.swingCooldown = true pcall(function() local char = LP.Character if not char then return end local bat = AntiBypassFindBat() if not bat then return end local hum = char:FindFirstChildOfClass("Humanoid") if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end pcall(function() bat:Activate() end) local ev = bat:FindFirstChildWhichIsA("RemoteEvent") if ev then pcall(function() ev:FireServer() end) end end) task.delay(0.03, function() AceAntiBypassAimbot.swingCooldown = false end) end
function F.startAimbotBypassAntiBat() pcall(function() if tpBatEnabled and stopTPBat then stopTPBat() end end) pcall(function() if aimbotEnabled and stopAimbot then stopAimbot() end end) pcall(function() if S.autoBatEnabled and S.disableAutoBat then S.disableAutoBat() end end) if AceAntiBypassAimbot.conn then pcall(function() AceAntiBypassAimbot.conn:Disconnect() end) AceAntiBypassAimbot.conn = nil end antiBatBypassLockEnabled = true; S.antiBatBypassEnabled = true; local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum0 then
AceAntiBypassAimbot.prevAutoRotate = hum0.AutoRotate; hum0.AutoRotate = false end pcall(function() F.destroyProxy() end) local bypassTick = 0; local _bpTarget, _bpDist, _bpLastScan = nil, math.huge, 0 AceAntiBypassAimbot.conn = RunService.Heartbeat:Connect(function() if not antiBatBypassLockEnabled then return end bypassTick = bypassTick + 1 if bypassTick % (_IS_MOBILE and 3 or 8) == 0 then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
if not root or not hum then return end if bypassTick % 5 == 0 then local bat = AntiBypassFindBat() if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end end local now = os.clock() if (now - _bpLastScan) >= (_IS_MOBILE and 0.08 or 0.03) then _bpLastScan = now; _bpTarget, _bpDist = AntiBypassGetClosest() end local target, targetDist = _bpTarget, _bpDist if not target then return end local myPos = root.Position; local targetPos = target.Position; local direction = targetPos - myPos; local flatDir = Vector3.new(direction.X, 0, direction.Z) if flatDir.Magnitude > 0 then
flatDir = flatDir.Unit else flatDir = Vector3.zero end local chaseSpeed = GetAntiBypassAimbotSpeed(); local desiredHeight = targetPos.Y + 3.7; local yVel = (desiredHeight - myPos.Y) * 19.5 if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end yVel = math.clamp(yVel, -70, 110); local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed); root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8); local toTarget = targetPos - myPos if toTarget.Magnitude > 0.1 then
local goalCF = CFrame.lookAt(myPos, targetPos); local diffCF = root.CFrame:Inverse() * goalCF; local rx, ry, rz = diffCF:ToEulerAnglesXYZ(); rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5); root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42)) end if targetDist <= 8 then AntiBypassTrySwing() end end) if VS and VS.setAntiBatBypassVisual then pcall(function() VS.setAntiBatBypassVisual(true) end) end end function F.stopAimbotBypassAntiBat()
antiBatBypassLockEnabled = false; S.antiBatBypassEnabled = false if AceAntiBypassAimbot.conn then pcall(function() AceAntiBypassAimbot.conn:Disconnect() end) AceAntiBypassAimbot.conn = nil end AceAntiBypassAimbot.swingCooldown = false; local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart") if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end local hum = c and c:FindFirstChildOfClass("Humanoid") if hum then local prev = AceAntiBypassAimbot.prevAutoRotate; hum.AutoRotate = (prev == nil) and true or prev end
AceAntiBypassAimbot.prevAutoRotate = nil if VS and VS.setAntiBatBypassVisual then pcall(function() VS.setAntiBatBypassVisual(false) end) end end end local cursedInstaReset local K7 = { fovEnabled = false, fovValue = 80, lineESPEnabled = false, speedESPEnabled = false, animPackEnabled = false, animPackName = "Tryhard", animPackIndex = 1, headlessEnabled = false, korbloxEnabled = false, bodyLockEnabled = false, bodyLockRadius = 60, medusaResetEnabled = false, currentSkyTheme = "Off", skyThemeIndex = 1, } K7.headIndicator = nil K7.headSpeedConn = nil function K7.updateHeadIndicatorTheme()
local indicator = K7.headIndicator if not indicator then return end local accent = S.themeColor or Color3.fromRGB(245, 245, 247) if indicator.discord then indicator.discord.TextColor3 = accent end if indicator.speed then indicator.speed.TextColor3 = accent end if indicator.divider then indicator.divider.BackgroundColor3 = accent end end function K7.setupHeadIndicator(char) char = char or LP.Character; local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5)) if not head then return end local old = head:FindFirstChild("CrystalVSHeadIndicator")
if old then old:Destroy() end
local bb = Instance.new("BillboardGui"); bb.Name = "CrystalVSHeadIndicator"; bb.Size = UDim2.new(0, 250, 0, 90); bb.StudsOffset = Vector3.new(0, 3.5, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 600; bb.Adornee = head; bb.Parent = head; local accent = S.themeColor or Color3.fromRGB(245, 245, 247); local discordLbl = Instance.new("TextLabel"); discordLbl.Name = "Discord"; discordLbl.Size = UDim2.new(1, 0, 0.30, 0); discordLbl.Position = UDim2.new(0, 0, 0.30, 0); discordLbl.BackgroundTransparency = 1; discordLbl.Text = ".gg/EgzARV5gw"; discordLbl.TextColor3 = accent; discordLbl.Font = Enum.Font.GothamBold; discordLbl.TextScaled = true; discordLbl.TextStrokeTransparency = 0; discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); discordLbl.Parent = bb; local divider = Instance.new("Frame"); divider.Name = "Divider"; divider.Size = UDim2.new(0.72, 0, 0, 2); divider.Position = UDim2.new(0.14, 0, 0.635, 0); divider.BackgroundColor3 = accent; divider.BackgroundTransparency = 0.15; divider.BorderSizePixel = 0; divider.ZIndex = 2; divider.Parent = bb; local dividerCorner = Instance.new("UICorner"); dividerCorner.CornerRadius = UDim.new(1, 0); dividerCorner.Parent = divider; local speedLbl = Instance.new("TextLabel"); speedLbl.Name = "Speed"; speedLbl.Size = UDim2.new(1, 0, 0.30, 0); speedLbl.Position = UDim2.new(0, 0, 0.66, 0); speedLbl.BackgroundTransparency = 1; speedLbl.Text = "0.0"; speedLbl.TextColor3 = accent; speedLbl.Font = Enum.Font.GothamBold; speedLbl.TextScaled = true; speedLbl.TextStrokeTransparency = 0; speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); speedLbl.Parent = bb; K7.headIndicator = { bb = bb, discord = discordLbl, speed = speedLbl, divider = divider }; K7.updateHeadIndicatorTheme()
end function K7.startHeadSpeedUpdates() if K7.headSpeedConn then K7.headSpeedConn:Disconnect() end K7.headSpeedConn = RunService.Heartbeat:Connect(function() local indicator = K7.headIndicator if not indicator or not indicator.bb or not indicator.bb.Parent then return end local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local displaySpeed = 0 if S and (S.autoLeftEnabled or S.autoRightEnabled) then local ok, value = pcall(function() return (F and F.getAutoPathSpeed and F.getAutoPathSpeed()) or nil end) if ok and type(value) == "number" then
displaySpeed = value elseif F and F.getActiveMoveSpeed then local ok2, v2 = pcall(F.getActiveMoveSpeed) if ok2 and type(v2) == "number" then displaySpeed = v2 end end elseif F and F.getActiveMoveSpeed then local ok, value = pcall(F.getActiveMoveSpeed) if ok and type(value) == "number" then displaySpeed = value end elseif hrp then local velocity = hrp.AssemblyLinearVelocity; displaySpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude end indicator.speed.Text = string.format("%.1f", displaySpeed) end) end local function bindHeadIndicator(char) task.spawn(function() task.wait(0.25)
K7.setupHeadIndicator(char); K7.startHeadSpeedUpdates() end) end bindHeadIndicator(LP.Character); LP.CharacterAdded:Connect(bindHeadIndicator) do local skyThemeTag = "CursedSkyTheme"; local currentSkyTheme = "Off"; local SkyOrder = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"} local SkyPresets = { ["Off"]={kind="off"},
["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}}, ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}}, ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}}, ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4}}, ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2}}, ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2}},
["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5}}, ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8}}, ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4}}, ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6}}, ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4}}, ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5}}, ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={sun=6},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3}},
["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2}}, ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}}, ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8}},
["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2}}, ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6}}, } local function skyRGB(t) return Color3.fromRGB(t[1],t[2],t[3]) end local function applySkyTheme(mode) currentSkyTheme = mode or "Off"; K7.currentSkyTheme = currentSkyTheme for _,child in ipairs(Lighting:GetChildren()) do
if child:GetAttribute(skyThemeTag) then pcall(function() child:Destroy() end) end end local terrain = workspace:FindFirstChildOfClass("Terrain") if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(skyThemeTag) then pcall(function() child:Destroy() end) end end end local preset = SkyPresets[mode] if not preset or preset.kind == "off" then Lighting.ClockTime = 14; Lighting.Brightness = 2; Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127); Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.FogEnd = 100000; Lighting.GlobalShadows = true return end
Lighting.FogStart = 0; Lighting.FogEnd = 100000; Lighting.GlobalShadows = true; Lighting.ClockTime = preset.clock or 14; Lighting.Brightness = preset.brightness or 2 if preset.outAmb then Lighting.OutdoorAmbient = skyRGB(preset.outAmb) end if preset.ambient then Lighting.Ambient = skyRGB(preset.ambient) end if preset.sky then local skyInst = Instance.new("Sky"); skyInst:SetAttribute(skyThemeTag, true) if preset.sky.stars then skyInst.StarCount = preset.sky.stars end if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end skyInst.Parent = Lighting end if preset.atm then local atm = Instance.new("Atmosphere"); atm:SetAttribute(skyThemeTag, true); atm.Density = preset.atm.dens or 0.3; atm.Color = skyRGB(preset.atm.color); atm.Decay = skyRGB(preset.atm.decay); atm.Glare = preset.atm.glare or 1; atm.Haze = preset.atm.haze or 1; atm.Parent = Lighting end if preset.clouds and terrain then
local clouds = Instance.new("Clouds"); clouds:SetAttribute(skyThemeTag, true); clouds.Cover = preset.clouds.cover or 0.5; clouds.Density = preset.clouds.dens or 0.5; clouds.Color = skyRGB(preset.clouds.color); clouds.Parent = terrain end end local skyThemeIndex = 1 local function cycleSkyTheme(dir) skyThemeIndex = skyThemeIndex + (dir or 1) if skyThemeIndex < 1 then skyThemeIndex = #SkyOrder end if skyThemeIndex > #SkyOrder then skyThemeIndex = 1 end applySkyTheme(SkyOrder[skyThemeIndex]); K7.skyThemeIndex = skyThemeIndex return SkyOrder[skyThemeIndex] end
_G._VezyFOV = _G._VezyFOV or 70; local fovEnabled = false; local fovValue = 70; local fovConn = nil; local stretchRezEnabled = false; local stretchRezConn, stretchFovConn = nil, nil; local stretchFOV = 120; _G.State = _G.State or {}; State = _G.State; State.stretchedResEnabled = false; State.stretchFOV = 120 local function applyStretchFOV(val) local cam = workspace.CurrentCamera if cam then pcall(function() cam.FieldOfView = val end) end end local function enableStretchRez() S.stretchRezEnabled = true; State.stretchedResEnabled = true; local cam = workspace.CurrentCamera
if not cam then return end if S.stretchRezConn then S.stretchRezConn:Disconnect() end if stretchFovConn then stretchFovConn:Disconnect() end stretchFovConn = RunService.Heartbeat:Connect(function() if not S.stretchRezEnabled then return end if not _perfEveryN(4, 2) then return end applyStretchFOV(State.stretchFOV or stretchFOV) end) S.stretchRezConn = RunService.Heartbeat:Connect(function() if not S.stretchRezEnabled then if S.stretchRezConn then S.stretchRezConn:Disconnect(); S.stretchRezConn = nil end return end if _IS_MOBILE and not _perfEveryN(2, 1) then return end if cam then
cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1) end end) end local function disableStretchRez() S.stretchRezEnabled = false; State.stretchedResEnabled = false if S.stretchRezConn then S.stretchRezConn:Disconnect(); S.stretchRezConn = nil end if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end pcall(function() if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = _G._VezyFOV or 70 end end) end local function applyFOV() pcall(function() RunService:UnbindFromRenderStep("CursedFOV") end)
if fovConn then fovConn:Disconnect(); fovConn = nil end if not K7.fovEnabled then local target = _G._VezyFOV or 70 if workspace.CurrentCamera and not State.stretchedResEnabled then workspace.CurrentCamera.FieldOfView = target end return end local cam = workspace.CurrentCamera; local target = K7.fovValue or _G._VezyFOV or 70; _G._VezyFOV = target if cam and not State.stretchedResEnabled then cam.FieldOfView = target end pcall(function() RunService:BindToRenderStep("CursedFOV", Enum.RenderPriority.Camera.Value + 1, function() if not K7.fovEnabled then return end
if State.stretchedResEnabled then return end local c = workspace.CurrentCamera if c then c.FieldOfView = K7.fovValue or _G._VezyFOV or 70 end end) end) fovConn = RunService.Heartbeat:Connect(function() if not _perfEveryN(3, 1) then return end if not K7.fovEnabled then return end if State.stretchedResEnabled then return end local c = workspace.CurrentCamera if c then c.FieldOfView = K7.fovValue or _G._VezyFOV or 70 end end) end do local _VezyFOVPropConn = nil local function _attachFOVLock(cam) if not cam then return end
if _VezyFOVPropConn then pcall(function() _VezyFOVPropConn:Disconnect() end) end pcall(function() if not State.stretchedResEnabled then cam.FieldOfView = _G._VezyFOV or 70 end end) _VezyFOVPropConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function() local target = _G._VezyFOV or 70 if not State.stretchedResEnabled and cam.FieldOfView ~= target then pcall(function() cam.FieldOfView = target end) end end) end pcall(function() if workspace.CurrentCamera then _attachFOVLock(workspace.CurrentCamera) end workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() task.wait()
pcall(function() _attachFOVLock(workspace.CurrentCamera) end) end) if LP then LP.CharacterAdded:Connect(function() task.wait(0.3) pcall(function() _attachFOVLock(workspace.CurrentCamera) end) end) end end) end local headlessEnabled, korbloxEnabled = false, false
local HEADLESS_MESH_ID = "rbxassetid://1095708"
local savedHeadlessFace = nil
local savedHeadlessHeadTransparency = nil
local savedHeadlessHeadCanCollide = nil
local function applyHeadless(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if enabled then
        if savedHeadlessHeadTransparency == nil then savedHeadlessHeadTransparency = head.Transparency end
        if savedHeadlessHeadCanCollide == nil then savedHeadlessHeadCanCollide = head.CanCollide end
        local face = head:FindFirstChild("face")
        if face and not savedHeadlessFace then
            pcall(function() savedHeadlessFace = face:Clone() end)
        end
        if face then pcall(function() face:Destroy() end) end
        head.Transparency = 1
        head.CanCollide = false
        for _, c in ipairs(head:GetChildren()) do
            if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then pcall(function() c:Destroy() end) end
        end
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head
    else
        for _, c in ipairs(head:GetChildren()) do
            if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then pcall(function() c:Destroy() end) end
        end
        head.Transparency = savedHeadlessHeadTransparency or 0
        head.CanCollide = savedHeadlessHeadCanCollide ~= false
        if savedHeadlessFace and not head:FindFirstChild("face") then
            pcall(function()
                local face = savedHeadlessFace:Clone()
                face.Name = "face"
                face.Transparency = 0
                face.Parent = head
            end)
        end
        savedHeadlessFace = nil
        savedHeadlessHeadTransparency = nil
        savedHeadlessHeadCanCollide = nil
    end
end
local KORBLOX_ASSETS = { ["Left Leg"] = { id = "rbxassetid://139607673",
targetBodyPart = "LeftUpperLeg", partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}, scale = Vector3.new(1, 1, 1), offset = CFrame.new(), }, ["Right Leg"] = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}, scale = Vector3.new(1, 1, 1), offset = CFrame.new(), }, } local korbloxSide = 1 local function clearKorbloxAttachments(char) if not char then return end for _, name in ipairs({"Korblox_LeftLeg", "Korblox_RightLeg", "Korblox_Left Leg", "Korblox_Right Leg"}) do
local old = char:FindFirstChild(name) if old then pcall(function() old:Destroy() end) end end for _, child in ipairs(char:GetChildren()) do if child.Name:find("^Korblox_") then pcall(function() child:Destroy() end) end end for _, partName in ipairs({ "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg", }) do local limb = char:FindFirstChild(partName) if limb and limb:IsA("BasePart") then limb.Transparency = 0 end end end local function attachKorbloxMesh(char, itemName, config) if not char then return false, "No character" end
local targetPart = char:FindFirstChild(config.targetBodyPart) if not targetPart then if itemName == "Left Leg" then targetPart = char:FindFirstChild("Left Leg") elseif itemName == "Right Leg" then targetPart = char:FindFirstChild("Right Leg") end end if not targetPart then return false, "Target part missing" end local safeName = "Korblox_" .. itemName:gsub("%s+", ""); local oldAsset = char:FindFirstChild(safeName) if oldAsset then pcall(function() oldAsset:Destroy() end) end for _, partName in ipairs(config.partsToHide) do local limb = char:FindFirstChild(partName)
if limb and limb:IsA("BasePart") then limb.Transparency = 1 end end local success, objects = pcall(function() return game:GetObjects(config.id) end) if not success or not objects or #objects == 0 then return false, "Asset fetch failed" end local assetModel = objects[1]; assetModel.Name = safeName; local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true) if not mainMesh then return false, "No MeshPart in asset" end pcall(function() mainMesh.Size = mainMesh.Size * (config.scale or Vector3.new(1,1,1))
mainMesh.CanCollide = false; mainMesh.Anchored = false; mainMesh.CFrame = targetPart.CFrame * (config.offset or CFrame.new()) end) local weld = Instance.new("WeldConstraint") weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh; assetModel.Parent = char return true end local function applyKorblox(char, enabled) if not char then return end clearKorbloxAttachments(char) if not enabled then return end local sides = {}; local side = korbloxSide or 1 if side == 2 then sides = {"Left Leg"} elseif side == 3 then sides = {"Left Leg", "Right Leg"} else sides = {"Right Leg"} end
for _, itemName in ipairs(sides) do local config = KORBLOX_ASSETS[itemName] if config then local ok, err = attachKorbloxMesh(char, itemName, config) if not ok then warn("[snow.vs] Korblox equip failed (" .. itemName .. "): " .. tostring(err)) end end end end local bodyLockEnabled = false; local bodyLockRadius = 60; local bodyLockConn = nil local function getNearestBodyLockTarget() local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil end local nearest, shortest = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then local tr = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tr and hum and hum.Health > 0 then local d = (tr.Position - root.Position).Magnitude if d <= (K7.bodyLockRadius or bodyLockRadius or 60) and d < shortest then shortest = d; nearest = plr end end end end return nearest end local function isNearBrainrot(root, radius) if not root then return false end radius = radius or 5 local ok, parts = pcall(function() return workspace:GetPartBoundsInRadius(root.Position, radius) end)
if not ok or not parts then return false end for _, p in ipairs(parts) do if p and p:IsA("BasePart") then local model = p:FindFirstAncestorOfClass("Model") if model and model ~= LP.Character then if not Players:GetPlayerFromCharacter(model) then local n = string.lower(model.Name) if n:find("brainrot", 1, true) or n:find("animal", 1, true) or n:find("steal", 1, true) then return true end local par = model.Parent if par then local pn = string.lower(par.Name) if pn:find("brainrot", 1, true) or pn:find("animals", 1, true) then return true end end end end end end return false end
local function startBodyLock() if bodyLockConn then K7.bodyLockEnabled = true; bodyLockEnabled = true; S._bodyLockWanted = true return end K7.bodyLockEnabled = true; bodyLockEnabled = true; S._bodyLockWanted = true; S._bodyLockPausedByBrainrot = false; local _blCachedTarget = nil; local _blLastScan = 0; local _blLastBrain = 0; local _blNearBrain = false bodyLockConn = RunService.Heartbeat:Connect(function() if not K7.bodyLockEnabled then return end if aimbotEnabled or tpBatEnabled or antiBatBypassLockEnabled then return end
local char = LP.Character; local myRoot = char and char:FindFirstChild("HumanoidRootPart"); local humanoid = char and char:FindFirstChildOfClass("Humanoid") if not myRoot or not humanoid or humanoid.Health <= 0 then return end local now = os.clock(); local brainInterval = _IS_MOBILE and 0.18 or 0.08 if (now - _blLastBrain) >= brainInterval then _blLastBrain = now; local holding, near = false, false pcall(function() holding = F.isCarryingBrainrot and F.isCarryingBrainrot(char) == true end) pcall(function() near = isNearBrainrot and isNearBrainrot(myRoot, 5) == true end)
_blNearBrain = holding or near end if _blNearBrain then S._bodyLockPausedByBrainrot = true; humanoid.AutoRotate = true return end local scanInterval = _IS_MOBILE and 0.12 or 0.05 if (now - _blLastScan) >= scanInterval then _blLastScan = now; _blCachedTarget = getNearestBodyLockTarget() end local target = _blCachedTarget if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local targetPos = target.Character.HumanoidRootPart.Position; local myPos = myRoot.Position; local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos
if offset.Magnitude > 0.1 then humanoid.AutoRotate = false; local lookDir = offset.Unit local currentDir = myRoot.CFrame.LookVector local cross = currentDir:Cross(lookDir); local currentVel = myRoot.AssemblyAngularVelocity; myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z) end else humanoid.AutoRotate = true end end) end local function stopBodyLock(fromUser) K7.bodyLockEnabled = false; bodyLockEnabled = false if bodyLockConn then bodyLockConn:Disconnect(); bodyLockConn = nil end local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then hum.AutoRotate = true end if fromUser == true then S._bodyLockWanted = false; S._bodyLockPausedByBrainrot = false end end if not S._bodyLockBrainrotWatcher then S._bodyLockBrainrotWatcher = true RunService.Heartbeat:Connect(function() if not S._bodyLockWanted then return end if S._bodyLockPausedByCombat then return end if aimbotEnabled or tpBatEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local holding, near = false, false
pcall(function() holding = F.isCarryingBrainrot and F.isCarryingBrainrot(char) == true end) pcall(function() near = isNearBrainrot and isNearBrainrot(root, 5) == true end) if holding or near then S._bodyLockPausedByBrainrot = true return end if S._bodyLockPausedByBrainrot or not bodyLockConn then S._bodyLockPausedByBrainrot = false if not bodyLockConn then pcall(startBodyLock) else K7.bodyLockEnabled = true; bodyLockEnabled = true end if VS and VS.setBodyLockVisual then pcall(function() VS.setBodyLockVisual(true) end) end end end) end
local medusaResetEnabled = false; local medusaResetConns = {}; local medusaResetDebounce = false local function onPartAnchoredForReset(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency == 1 and part.Name ~= "HumanoidRootPart" then if medusaResetDebounce or not K7.medusaResetEnabled then return end medusaResetDebounce = true task.spawn(function() if cursedInstaReset then cursedInstaReset() end task.wait(1.5); medusaResetDebounce = false end) end end) end local function startMedusaReset()
for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end medusaResetConns = {}; local char = LP.Character if not char then return end for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(medusaResetConns, onPartAnchoredForReset(part)) end end table.insert(medusaResetConns, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(medusaResetConns, onPartAnchoredForReset(part)) end end)) end local function stopMedusaReset() for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
medusaResetConns = {}; medusaResetDebounce = false end local lineESPEnabled = false; local speedESPEnabled = false; local PlayerESP = { enabled = false, conns = {}, playerData = {} }; local TracerESP = { drawings = {}, conn = nil, gui = nil } local function startPlayerESP() if PlayerESP.enabled then return end PlayerESP.enabled = true local function cleanup(plr) local d = PlayerESP.playerData[plr] if not d then return end pcall(function() if d.highlight then d.highlight:Destroy() end end) pcall(function() if d.billboard then d.billboard:Destroy() end end)
for _, c in ipairs(d.conns or {}) do pcall(function() c:Disconnect() end) end PlayerESP.playerData[plr] = nil end local function setupPlayer(plr, char) if not PlayerESP.enabled or plr == LP then return end cleanup(plr); char = char or plr.Character if not char then return end local hrp = char:FindFirstChild("HumanoidRootPart"); local head = char:FindFirstChild("Head") or hrp if not hrp then return end
local hl = Instance.new("Highlight"); hl.Name = "SevenUpPlayerESP"; hl.Adornee = char; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; local acc = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); hl.FillColor = acc; hl.FillTransparency = 0.72; hl.OutlineColor = acc; hl.OutlineTransparency = 0.08; hl.Parent = char; local bb = Instance.new("BillboardGui"); bb.Name = "SevenUpPlayerESP_BB"; bb.Adornee = head; bb.Size = UDim2.new(0, 120, 0, 28); bb.StudsOffset = Vector3.new(0, 2.8, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 600; local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = plr.DisplayName or plr.Name; lbl.TextColor3 = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextStrokeTransparency = 0.3
pcall(function() bb.Parent = game:GetService("CoreGui") end) if not bb.Parent then pcall(function() bb.Parent = LP:FindFirstChild("PlayerGui") end) end local lastEspUp = 0 local conn = RunService.Heartbeat:Connect(function() if not PlayerESP.enabled or not hrp.Parent then return end local now = os.clock(); local interval = _IS_MOBILE and 0.22 or 0.08 if (now - lastEspUp) < interval then return end lastEspUp = now; local v = hrp.AssemblyLinearVelocity; local spd = Vector3.new(v.X, 0, v.Z).Magnitude; lbl.Text = string.format("%s\n%.0f sps", plr.DisplayName or plr.Name, spd) end)
PlayerESP.playerData[plr] = { highlight = hl, billboard = bb, conns = { conn } } end for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setupPlayer, plr, c) end)) if plr.Character then task.defer(setupPlayer, plr, plr.Character) end end end table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr) table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setupPlayer, plr, c) end)) end)) table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup)) end
local function stopPlayerESP() PlayerESP.enabled = false for _, c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end PlayerESP.conns = {} for plr, d in pairs(PlayerESP.playerData) do pcall(function() if d.highlight then d.highlight:Destroy() end end) pcall(function() if d.billboard then d.billboard:Destroy() end end) for _, c in ipairs(d.conns or {}) do pcall(function() c:Disconnect() end) end end PlayerESP.playerData = {} end local function ensureTracerGui() if TracerESP.gui and TracerESP.gui.Parent then return TracerESP.gui end
local g = Instance.new("ScreenGui"); g.Name = "VersincTracerESP"; g.IgnoreGuiInset = true; g.DisplayOrder = 50; g.ResetOnSpawn = false pcall(function() g.Parent = game:GetService("CoreGui") end) if not g.Parent then pcall(function() g.Parent = LP:FindFirstChild("PlayerGui") end) end TracerESP.gui = g return g end local function tracerCleanup(plr) local d = TracerESP.drawings[plr] if d then pcall(function() if d.line then d.line:Destroy() end end) TracerESP.drawings[plr] = nil end end local function startTracerESP() if TracerESP.conn then pcall(function() TracerESP.conn:Disconnect() end)
TracerESP.conn = nil end for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end ensureTracerGui(); S.showTracerEnabled = true TracerESP.conn = RunService.Heartbeat:Connect(function() if not S.showTracerEnabled and not (K7 and K7.lineESPEnabled) then for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end return end if not _perfEveryN(3, 1) then return end if not TracerESP.gui or not TracerESP.gui.Parent then return end local myChar = LP.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart") if not myRoot then return end local cam = workspace.CurrentCamera
if not cam then return end local seen = {} for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tr = plr.Character:FindFirstChild("HumanoidRootPart") if tr then seen[plr] = true; local sp, son = cam:WorldToViewportPoint(myRoot.Position); local ep, eon = cam:WorldToViewportPoint(tr.Position) if son and eon then local line = TracerESP.drawings[plr] and TracerESP.drawings[plr].line if not line then
line = Instance.new("Frame"); line.Name = "Tracer_" .. plr.Name; line.AnchorPoint = Vector2.new(0.5, 0.5); line.BorderSizePixel = 0; line.BackgroundColor3 = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); line.BackgroundTransparency = 0.15; line.Parent = TracerESP.gui; TracerESP.drawings[plr] = { line = line } end
local dx, dy = ep.X - sp.X, ep.Y - sp.Y; local len = math.sqrt(dx * dx + dy * dy); line.Size = UDim2.fromOffset(math.max(1, len), 2); line.Position = UDim2.fromOffset((sp.X + ep.X) / 2, (sp.Y + ep.Y) / 2); line.Rotation = math.deg(math.atan2(dy, dx)); line.Visible = true else tracerCleanup(plr) end end end end for plr in pairs(TracerESP.drawings) do if not seen[plr] then tracerCleanup(plr) end end end) end local function stopTracerESP() S.showTracerEnabled = false if TracerESP.conn then TracerESP.conn:Disconnect(); TracerESP.conn = nil end
for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end if TracerESP.gui then pcall(function() TracerESP.gui:Destroy() end); TracerESP.gui = nil end end local function refreshESP() stopPlayerESP(); stopTracerESP() if not K7 then return end if K7.lineESPEnabled or K7.speedESPEnabled then startPlayerESP(); startTracerESP() end end if K7 then K7.refreshESP = refreshESP end local animPackEnabled = false; local animPackName = "Tryhard"; local savedAnimateClone = nil; local applyingAnim = false local ANIM_PACKS = { ["Tryhard"] = {
Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 707897309, RunAnim = 707861613, JumpAnim = 116936326516985, FallAnim = 116936326516985, ClimbAnim = 116936326516985, Swim = 116936326516985, SwimIdle = 116936326516985, }, ["Crazy"] = { Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 134824450619865, RunAnim = 134824450619865, JumpAnim = 121454505477205, FallAnim = 94788218468396, ClimbAnim = 121454505477205, Swim = 121454505477205, SwimIdle = 121454505477205, }, ["Adidas Sports"] = {
Animation1 = 18537376492, Animation2 = 18537371272, WalkAnim = 18537392113, RunAnim = 18537384940, JumpAnim = 18537380791, FallAnim = 18537367238, ClimbAnim = 18537363391, Swim = 18537389531, SwimIdle = 18537387180, }, ["Adidas Community"] = { Animation1 = 122257458498464, Animation2 = 102357151005774, WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385, FallAnim = 98600215928904, ClimbAnim = 88763136693023, Swim = 133308483266208, SwimIdle = 109346520324160, }, ["Adidas Aura"] = {
Animation1 = 110211186840347, Animation2 = 114191137265065, WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204, FallAnim = 95603166884636, ClimbAnim = 97824616490448, Swim = 134530128383903, SwimIdle = 94922130551805, }, ["Wicked Popular"] = { Animation1 = 118832222982049, Animation2 = 76049494037641, WalkAnim = 92072849924640, RunAnim = 72301599441680, JumpAnim = 104325245285198, FallAnim = 121152442762481, ClimbAnim = 131326830509784, Swim = 99384245425157, SwimIdle = 113199415118199, }, ["Elder"] = {
Animation1 = 10921101664, Animation2 = 10921102574, WalkAnim = 10921111375, RunAnim = 10921104374, JumpAnim = 10921107367, FallAnim = 10921105765, ClimbAnim = 10921100400, Swim = 10921108971, SwimIdle = 10921110137, }, ["Zombie"] = { Animation1 = 10921344533, Animation2 = 10921345376, WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278, FallAnim = 10921350320, ClimbAnim = 10921343576, Swim = 10921352344, SwimIdle = 10921353442, }, ["Mage"] = {
Animation1 = 10921144709, Animation2 = 10921145797, WalkAnim = 10921152678, RunAnim = 10921148209, JumpAnim = 10921149743, FallAnim = 10921148939, ClimbAnim = 10921143404, Swim = 10921150788, SwimIdle = 10921151661, }, ["Catwalk Glam"] = { Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985, FallAnim = 92294537340807, ClimbAnim = 119377220967554, Swim = 134591743181628, SwimIdle = 98854111361360, }, ["Astronaut"] = {
Animation1 = 10921034824, Animation2 = 10921036806, WalkAnim = 10921046031, RunAnim = 10921039308, JumpAnim = 10921042494, FallAnim = 10921040576, ClimbAnim = 10921032124, Swim = 10921044000, SwimIdle = 10921045006, }, ["Werewolf"] = { Animation1 = 10921330408, Animation2 = 10921333667, WalkAnim = 10921342074, RunAnim = 10921336997, JumpAnim = 10921337907, FallAnim = 10921337907, ClimbAnim = 10921329322, Swim = 10921340419, SwimIdle = 10921341319, }, ["Superhero"] = {
Animation1 = 10921288909, Animation2 = 10921290167, WalkAnim = 10921298616, RunAnim = 10921291831, JumpAnim = 10921294559, FallAnim = 10921293373, ClimbAnim = 10921286911, Swim = 10921295495, SwimIdle = 10921297391, }, ["Toy"] = { Animation1 = 10921301576, Animation2 = 10921301576, WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158, FallAnim = 10921307241, ClimbAnim = 10921300839, Swim = 10921309319, SwimIdle = 10921310341, }, ["No Boundaries"] = {
Animation1 = 18747067405, Animation2 = 18747063918, WalkAnim = 18747074203, RunAnim = 18747070484, JumpAnim = 18747069148, FallAnim = 18747062535, ClimbAnim = 18747060903, Swim = 18747073181, SwimIdle = 18747071682, }, ["NFL"] = { Animation1 = 92080889861410, Animation2 = 74451233229259, WalkAnim = 110358958299415, RunAnim = 117333533048078, JumpAnim = 119846112151352, FallAnim = 129773241321032, ClimbAnim = 134630013742019, Swim = 132697394189921, SwimIdle = 79090109939093, }, ["Vampire"] = {
Animation1 = 10921315373, Animation2 = 10921315373, WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186, FallAnim = 10921321317, ClimbAnim = 10921314188, Swim = 10921324408, SwimIdle = 10921325443, }, ["Ninja"] = { Animation1 = 656117400, Animation2 = 656118341, WalkAnim = 656121766, RunAnim = 656118852, JumpAnim = 656117878, FallAnim = 656115606, ClimbAnim = 656114359, Swim = 656119721, SwimIdle = 656121397, }, ["Robot"] = {
Animation1 = 616088211, Animation2 = 616089559, WalkAnim = 616095330, RunAnim = 616091570, JumpAnim = 616090535, FallAnim = 616087089, ClimbAnim = 616086039, Swim = 616092998, SwimIdle = 616094091, }, ["Levitation"] = { Animation1 = 616006778, Animation2 = 616008087, WalkAnim = 616013216, RunAnim = 616010382, JumpAnim = 616008936, FallAnim = 616005863, ClimbAnim = 616003713, Swim = 616011509, SwimIdle = 616012453, }, ["Stylish"] = {
Animation1 = 616136790, Animation2 = 616138447, WalkAnim = 616146177, RunAnim = 616140816, JumpAnim = 616139451, FallAnim = 616134815, ClimbAnim = 616133594, Swim = 616143378, SwimIdle = 616144772, }, ["Bubbly"] = { Animation1 = 910004836, Animation2 = 910009958, WalkAnim = 910034870, RunAnim = 910025107, JumpAnim = 910016857, FallAnim = 910001910, ClimbAnim = 909997997, Swim = 910028158, SwimIdle = 910030921, }, ["Cartoon"] = {
Animation1 = 742637544, Animation2 = 742638445, WalkAnim = 742640026, RunAnim = 742638842, JumpAnim = 742637942, FallAnim = 742637151, ClimbAnim = 742636889, Swim = 742639220, SwimIdle = 742639812, }, ["Wicked Dancing"] = { Animation1 = 92849173543269, Animation2 = 132238900951109, WalkAnim = 73718308412641, RunAnim = 135515454877967, JumpAnim = 78508480717326, FallAnim = 78147885297412, ClimbAnim = 129447497744818, Swim = 110657013921774, SwimIdle = 129183123083281, }, ["Normal"] = {
Animation1 = 507766388, Animation2 = 507766666, WalkAnim = 507777826, RunAnim = 507767714, JumpAnim = 507765000, FallAnim = 507767968, ClimbAnim = 507765644, Swim = 507784897, SwimIdle = 507784897, }, } local ANIM_PACK_LIST = {"Tryhard","Crazy","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie","Mage","Catwalk Glam","Astronaut","Werewolf","Superhero","Toy","No Boundaries","NFL","Vampire","Ninja","Robot","Levitation","Stylish","Bubbly","Cartoon","Wicked Dancing","Normal"} local animPackIndex = 1 local function setAnimId(obj, id)
if not obj or not id then return end local idStr = type(id) == "number" and ("rbxassetid://" .. tostring(id)) or tostring(id) if not idStr:find("rbxassetid://") and tonumber(idStr) then idStr = "rbxassetid://" .. idStr end pcall(function() if obj:IsA("Animation") then obj.AnimationId = idStr elseif obj:IsA("StringValue") then obj.Value = idStr end end) end local function applyAnimPack(name) if not K7.animPackEnabled then return end if applyingAnim then return end name = name or K7.animPackName if not name or name == "" then applyingAnim = false; return end
K7.animPackName = name; applyingAnim = true; local pack = ANIM_PACKS[name] if not pack then applyingAnim = false; return end local char = LP.Character if not char then applyingAnim = false; return end local animate = char:FindFirstChild("Animate") if not animate then applyingAnim = false; return end if not savedAnimateClone then pcall(function() savedAnimateClone = animate:Clone() end) end local hum = char:FindFirstChildOfClass("Humanoid") if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end end local function ensure(folder, animName)
if not folder then return nil end local a = folder:FindFirstChild(animName) if not a then a = Instance.new("Animation"); a.Name = animName; a.Parent = folder end return a end local function setFolderAnim(folderName, animName, id) if not id then return end local folder = animate:FindFirstChild(folderName) if not folder then folder = Instance.new("Folder"); folder.Name = folderName; folder.Parent = animate end setAnimId(ensure(folder, animName), id) for _, ch in ipairs(folder:GetChildren()) do if ch:IsA("Animation") or ch:IsA("StringValue") then setAnimId(ch, id) end end end
setFolderAnim("walk", "WalkAnim", pack.WalkAnim); setFolderAnim("run", "RunAnim", pack.RunAnim); setFolderAnim("jump", "JumpAnim", pack.JumpAnim); setFolderAnim("fall", "FallAnim", pack.FallAnim); setFolderAnim("climb", "ClimbAnim", pack.ClimbAnim); setFolderAnim("swim", "Swim", pack.Swim); setFolderAnim("swimidle", "SwimIdle", pack.SwimIdle); local idle = animate:FindFirstChild("idle") if not idle then idle = Instance.new("Folder"); idle.Name = "idle"; idle.Parent = animate end if idle then
setAnimId(ensure(idle, "Animation1"), pack.Animation1); setAnimId(ensure(idle, "Animation2"), pack.Animation2 or pack.Animation1) for _, ch in ipairs(idle:GetChildren()) do if ch:IsA("Animation") or ch:IsA("StringValue") then if ch.Name:find("1") then setAnimId(ch, pack.Animation1) elseif ch.Name:find("2") then setAnimId(ch, pack.Animation2 or pack.Animation1) end end end end animate.Disabled = true; task.wait(0.05); animate.Disabled = false; animPackName = name; K7.animPackName = name; applyingAnim = false; print("[snow.vs] Anim pack applied:", name) end local function resetAnimPack()
local char = LP.Character if not char then return end local animate = char:FindFirstChild("Animate") if animate then animate:Destroy() end if savedAnimateClone then local n = savedAnimateClone:Clone(); n.Parent = char; n.Disabled = true; task.wait(0.05); n.Disabled = false end end K7.applySkyTheme = applySkyTheme; K7.cycleSkyTheme = cycleSkyTheme; K7.applyFOV = applyFOV; K7.enableStretchRez = enableStretchRez; K7.disableStretchRez = disableStretchRez; K7.applyHeadless = applyHeadless; K7.applyKorblox = applyKorblox; K7.korbloxSide = korbloxSide
K7.setKorbloxSide = function(n) korbloxSide = n; K7.korbloxSide = n end K7.startBodyLock = startBodyLock; K7.stopBodyLock = stopBodyLock; K7.startMedusaReset = startMedusaReset; K7.stopMedusaReset = stopMedusaReset; K7.refreshESP = refreshESP; K7.applyAnimPack = applyAnimPack; K7.resetAnimPack = resetAnimPack; K7.ANIM_PACK_LIST = ANIM_PACK_LIST if K7.currentSkyTheme == nil then K7.currentSkyTheme = currentSkyTheme end if K7.skyThemeIndex == nil then K7.skyThemeIndex = skyThemeIndex end if K7.fovValue == nil then K7.fovValue = fovValue end
-- ===== [snow.vs] Accessory Pack (Mario / MARIO 2 skins) =====
do
    local ACCESSORY_PACK_LIST = {"Off", "Mario", "MARIO 2"}
    local MARIO_PACKS = {
        ["Mario"] = {
            shirt = "rbxassetid://123764725120081",
            headAccessory = 137837399125122,
            pants = "rbxassetid://92638141186215",
            headOffset = Vector3.new(0, 0, 0),
            headRotation = Vector3.new(0, 0, 0),
        },
        ["MARIO 2"] = {
            -- Same shirt and pants as Mario; only the hat/accessory changes.
            shirt = "rbxassetid://123764725120081",
            headAccessory = 12865041226,
            pants = "rbxassetid://92638141186215",
            headOffset = Vector3.new(0, 0, 0),
            headRotation = Vector3.new(0, 0, 0),
        },
    }

    local ORIG = { shirt = nil, pants = nil, accessories = {} }

    local function saveOriginalOutfit(char)
        if not char then return end
        local shirt = char:FindFirstChildWhichIsA("Shirt")
        local pants = char:FindFirstChildWhichIsA("Pants")
        ORIG.shirt = shirt and shirt.ShirtTemplate or nil
        ORIG.pants = pants and pants.PantsTemplate or nil
    end

    local function clearAllOutfit(char)
        if not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Shirt") or obj:IsA("Pants") then pcall(function() obj:Destroy() end) end
        end
    end

    local function restoreOriginalOutfit(char)
        if not char then return end
        clearAllOutfit(char)
        if ORIG.shirt then local s = Instance.new("Shirt"); s.ShirtTemplate = ORIG.shirt; s.Parent = char end
        if ORIG.pants then local p = Instance.new("Pants"); p.PantsTemplate = ORIG.pants; p.Parent = char end
        ORIG.shirt = nil
        ORIG.pants = nil
    end

    local function saveOriginalAccessories(char)
        ORIG.accessories = {}
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Hat") then
                pcall(function() table.insert(ORIG.accessories, child:Clone()) end)
            end
        end
    end

    local function clearAllAccessories(char)
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            pcall(function()
                if child:IsA("Accessory") or child:IsA("Hat") or (typeof(child.Name) == "string" and child.Name:sub(1, 6) == "AuFfit") then
                    child:Destroy()
                elseif child.Name:find("Korblox_") or child.Name:find("Headless_") then
                    child:Destroy()
                end
            end)
        end
        for _, partName in ipairs({"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then part.Transparency = 0 end
        end
    end

    local function restoreOriginalAccessories(char)
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            pcall(function()
                if child:IsA("Accessory") or child:IsA("Hat") or (typeof(child.Name) == "string" and child.Name:sub(1, 6) == "AuFfit") then
                    child:Destroy()
                end
            end)
        end
        for _, clone in ipairs(ORIG.accessories) do
            pcall(function()
                local newAcc = clone:Clone()
                newAcc.Parent = char
            end)
        end
        ORIG.accessories = {}
    end

    local function attachPackAsset(assetId, objectName, targetPart, offset, rotation)
        if not assetId or not targetPart then return end
        local old = targetPart.Parent:FindFirstChild(objectName)
        if old then pcall(function() old:Destroy() end) end
        local objs
        local ok, res = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(assetId))
        end)
        if ok and typeof(res) == "table" and #res > 0 then
            objs = res
        else
            ok, res = pcall(function()
                return game:GetService("InsertService"):LoadAsset(assetId)
            end)
            if ok and res then objs = {res} end
        end
        if not objs then return end

        local char = targetPart.Parent
        for _, o in ipairs(objs) do
            local s = o:IsA("Shirt") and o or o:FindFirstChildWhichIsA("Shirt", true)
            if s then
                local charShirt = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
                charShirt.Name = "Shirt"
                charShirt.ShirtTemplate = s.ShirtTemplate
                charShirt.Parent = char
            end
            local p = o:IsA("Pants") and o or o:FindFirstChildWhichIsA("Pants", true)
            if p then
                local charPants = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
                charPants.Name = "Pants"
                charPants.PantsTemplate = p.PantsTemplate
                charPants.Parent = char
            end
        end

        local handle
        for _, o in ipairs(objs) do
            if o:IsA("BasePart") then handle = o break end
            local found = o:FindFirstChildWhichIsA("BasePart", true)
            if found then handle = found break end
        end
        if handle then
            local h = handle:Clone()
            h.Name = objectName
            h.CanCollide = false
            h.Anchored = false
            h.Massless = true
            h.Parent = char
            local r = rotation or Vector3.zero
            local weld = Instance.new("Weld")
            weld.Part0 = targetPart
            weld.Part1 = h
            local att = h:FindFirstChildWhichIsA("Attachment")
            local targetAtt = att and targetPart:FindFirstChild(att.Name)
            if targetAtt and att then
                weld.C0 = targetAtt.CFrame * CFrame.Angles(math.rad(r.X), math.rad(r.Y), math.rad(r.Z))
                weld.C1 = att.CFrame
            else
                weld.C0 = CFrame.new(offset or Vector3.zero) * CFrame.Angles(math.rad(r.X), math.rad(r.Y), math.rad(r.Z))
            end
            weld.Parent = h
        end
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
    end

    local function resolveClothingTemplate(assetId, className, fallback)
        local direct = "rbxassetid://" .. tostring(assetId)
        local ok, result = pcall(function()
            local objs = game:GetObjects(direct)
            for _, obj in ipairs(objs) do
                local clothing = obj:IsA(className) and obj or obj:FindFirstChildWhichIsA(className, true)
                if clothing then
                    local prop = className == "Shirt" and "ShirtTemplate" or "PantsTemplate"
                    local value = clothing[prop]
                    if value and value ~= "" then return value end
                end
            end
        end)
        if ok and result and result ~= "" then return result end
        return direct or fallback
    end

    local function applyMarioOutfit(packName)
        local config = MARIO_PACKS[packName or K7.accessoryPackName or "Mario"]
        if not config then return false end
        local char = LP.Character
        if not char then return false end

        local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 10)
        if not head then return false end

        -- Mario outfit: force the classic shirt/pants textures onto the character.
        clearAllOutfit(char)

        local shirt = Instance.new("Shirt")
        shirt.Name = "MarioShirt"
        shirt.ShirtTemplate = resolveClothingTemplate(123764725120081, "Shirt", config.shirt)
        shirt.Parent = char

        local pants = Instance.new("Pants")
        pants.Name = "MarioPants"
        pants.PantsTemplate = resolveClothingTemplate(92638141186215, "Pants", config.pants)
        pants.Parent = char

        -- Remove any previous copy of the Mario accessory and attach the new one.
        local oldAccessory = char:FindFirstChild("AuFfitHead")
        if oldAccessory then pcall(function() oldAccessory:Destroy() end) end
        attachPackAsset(config.headAccessory, "AuFfitHead", head, config.headOffset, config.headRotation)

        -- IMPORTANT: Mario mode always hides the real character head.
        -- The Mario accessory remains visible because it is attached to the Head part.
        pcall(function()
            savedHeadlessHeadTransparency = head.Transparency
            savedHeadlessHeadCanCollide = head.CanCollide
        end)
        local face = head:FindFirstChild("face")
        if face and not savedHeadlessFace then
            pcall(function() savedHeadlessFace = face:Clone() end)
        end
        if face then pcall(function() face:Destroy() end) end
        head.Transparency = 1
        head.CanCollide = false

        -- Do not create a visible replacement head. Only the accessory stays.
        for _, c in ipairs(head:GetChildren()) do
            if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then
                pcall(function() c:Destroy() end)
            end
        end

        K7.headlessEnabled = true
        return true
    end

    local function applyAccessoryPack(packName)
        packName = packName or K7.accessoryPackName or "Off"
        local char = LP.Character
        if not char then return end
        K7.accessoryPackName = packName

        if packName == "Off" then
            clearAllAccessories(char)
            restoreOriginalOutfit(char)
            restoreOriginalAccessories(char)
            -- Restore the real head and face when Mario mode is turned off.
            pcall(function() applyHeadless(char, false) end)
            K7.headlessEnabled = false
            print("[snow.vs] Accessory pack: Off")
            return
        end

        if packName == "Mario" or packName == "MARIO 2" then
            if not ORIG.shirt and not ORIG.pants then saveOriginalOutfit(char) end
            if #ORIG.accessories == 0 then saveOriginalAccessories(char) end
            clearAllAccessories(char)
            pcall(applyMarioOutfit, packName)
            print("[snow.vs] Accessory pack applied:", packName)
        end
    end

    local function resetAccessoryPack()
        K7.accessoryPackName = "Off"
        pcall(applyAccessoryPack, "Off")
    end

    pcall(function()
        LP.CharacterAdded:Connect(function()
            task.wait(1.5)
            if K7.accessoryPackEnabled and K7.accessoryPackName and K7.accessoryPackName ~= "Off" then
                pcall(applyAccessoryPack, K7.accessoryPackName)
            end
            if K7.headlessEnabled then
                task.wait(0.1)
                pcall(applyHeadless, LP.Character, true)
            end
        end)
    end)

    K7.ACCESSORY_PACK_LIST = ACCESSORY_PACK_LIST
    K7.applyAccessoryPack = applyAccessoryPack
    K7.resetAccessoryPack = resetAccessoryPack
    if K7.accessoryPackEnabled == nil then K7.accessoryPackEnabled = false end
    if K7.accessoryPackName == nil then K7.accessoryPackName = "Mario" end
    if K7.accessoryPackIndex == nil then K7.accessoryPackIndex = 2 end
end-- ===== [snow.vs] Fim Accessory Pack =====

if K7.animPackName == nil then K7.animPackName = animPackName end if K7.animPackIndex == nil then K7.animPackIndex = animPackIndex end if K7.bodyLockRadius == nil then K7.bodyLockRadius = bodyLockRadius end print("[snow.vs] K7 systems ready") end enableStretchRez = function(...) if K7 and K7.enableStretchRez then return K7.enableStretchRez(...) end end disableStretchRez = function(...) if K7 and K7.disableStretchRez then return K7.disableStretchRez(...) end end task.spawn(function() local BLACKLIST_URL="https://pastebin.com/2zLUXv2K" pcall(function() HS.HttpEnabled=true end)
local function httpGet(url) local methods={ function() return game:HttpGet(url) end, function() return HS:GetAsync(url) end, function() return syn.request({Url=url,Method="GET"}).Body end, function() return http_request({Url=url,Method="GET"}).Body end, function() return request({Url=url,Method="GET"}).Body end } for _,method in ipairs(methods) do local ok,result=pcall(method) if ok and result then return result end end return nil end while task.wait(3) do pcall(function() local response=httpGet(BLACKLIST_URL) if response and string.find(response,tostring(LP.UserId),1,true) then
LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633"); task.wait(999999) end end) end end) pcall(function() if type(hookfunction) ~= "function" then return end local wrap = newcclosure or function(f) return f end local probe = Instance.new("RemoteEvent") local oldFire oldFire = hookfunction(probe.FireServer, wrap(function(self, ...) if not S.cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") then local n = self.Name if type(n) == "string" and n:sub(1, 3) == "RE/" then S.cursedResetRemote = self end end
return oldFire(self, ...) end)) pcall(function() probe:Destroy() end) end) task.spawn(function() task.wait(2) if S.cursedResetRemote then return end pcall(function() local rs = game:GetService("ReplicatedStorage") for _, desc in ipairs(rs:GetDescendants()) do if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then S.cursedResetRemote = desc return end end end) end) local _resetCooldown = false local _resetThread = nil; local _resetChar = nil; local _resetStop = false; local RESET_TICK = 0.05; local RESET_MAX_ATTEMPTS = 40 local function _stopInstaResetSeq() _resetStop = true
if _resetThread then pcall(function() task.cancel(_resetThread) end) _resetThread = nil end _resetCooldown = false; local character = LP.Character if character then local humanoid = character:FindFirstChildOfClass("Humanoid") if humanoid then pcall(function() humanoid.HipHeight = 2 local root = character:FindFirstChild("HumanoidRootPart") if root then root.CanCollide = true end for _, part in ipairs(character:GetChildren()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end end end) end end _resetChar = nil; _resetStop = false end
if not _G.__VersincInstaResetCharHook then _G.__VersincInstaResetCharHook = true LP.CharacterAdded:Connect(function() _stopInstaResetSeq() end) end cursedInstaReset = function() if _resetCooldown then return end _resetCooldown = true; _resetStop = false; local character = LP.Character if not character then _resetCooldown = false return end local humanoid = character:FindFirstChildOfClass("Humanoid") if not humanoid then _resetCooldown = false return end _resetChar = character; local originalHip = humanoid.HipHeight _resetThread = task.spawn(function() local attempts = 0 local okReset = false
while character and character.Parent and humanoid and humanoid.Health > 0 and not _resetStop do if LP.Character ~= character then okReset = true break end pcall(function() humanoid.HipHeight = 1e30 humanoid.AutoRotate = true; local root = character:FindFirstChild("HumanoidRootPart") if root then root.CanCollide = false end for _, part in ipairs(character:GetChildren()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end end end) if not character.Parent or humanoid.Health <= 0 or LP.Character ~= character then okReset = true break end
attempts = attempts + 1 if attempts >= RESET_MAX_ATTEMPTS then break end task.wait(RESET_TICK) end if not okReset and character and character.Parent and humanoid and humanoid.Health > 0 then pcall(function() humanoid.Health = 0 end) task.wait(0.1) if not character.Parent or humanoid.Health <= 0 then okReset = true end end if not okReset and character and character.Parent and humanoid then pcall(function() humanoid.HipHeight = originalHip local root = character:FindFirstChild("HumanoidRootPart") if root then root.CanCollide = true end for _, part in ipairs(character:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end end end) end _resetCooldown = false; _resetThread = nil; _resetChar = nil; _resetStop = false end) end local KB = { DropBrainrot={kb=Enum.KeyCode.H,gp=nil}, AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil}, AutoRight   ={kb=Enum.KeyCode.C,gp=nil}, AutoBat     ={kb=Enum.KeyCode.E,gp=nil}, TPBat       ={kb=Enum.KeyCode.V,gp=Enum.KeyCode.ButtonY}, TPFloor     ={kb=Enum.KeyCode.F,gp=nil}, InstaReset  ={kb=Enum.KeyCode.T,gp=nil}, GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil}, LaggerToggle={kb=Enum.KeyCode.R,gp=nil}, } pcall(__initAimbotTPBat)
local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81); local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48); local isCurrentlyStealing = false; local autoStealConnection = nil; local barResetTween = nil; local stealGen = 0; local autoStealEnabled = false; local selectedStealMode = "Semi"; local autoStealRadius = 20; local AceStealRadii = {Normal = 20, Semi = 20}; local autoGrabStopEnabled, autoGrabStopTime, autoGrabStopPercent, autoGrabDelayRadius = true, 1.00, 75, 8 local Steal = { AutoStealEnabled = false, StealRadius = 20, StealDuration = 1.3,
Data = {}, AutoGrabStopEnabled = true, AutoGrabStopTime = 1.00, AutoGrabStopPercent = 75, AutoGrabDelayRadius = 8, } local progressRadLbl, progressFill, progressPct = nil, nil, nil local setupStealBarAPI, resetProgressBar, AceAutoStealSync, startAutoSteal, stopAutoSteal local stealsCount = 0; local FILL_LIGHT = Color3.fromRGB(255, 0, 0); local FILL_DARK = Color3.fromRGB(20, 150, 72) local function syncStealAliases()
Steal.AutoGrabStopEnabled = autoGrabStopEnabled == true; Steal.AutoGrabStopTime = tonumber(autoGrabStopTime) or 1.00; Steal.AutoGrabStopPercent = math.clamp(tonumber(autoGrabStopPercent) or 75, 1, 100); Steal.AutoGrabDelayRadius = tonumber(autoGrabDelayRadius) or 8; Steal.StealRadius = tonumber(autoStealRadius) or Steal.StealRadius or 20; Steal.AutoStealEnabled = autoStealEnabled == true end local function resetProgressVisuals() if progressPct then progressPct.Text = "0%" end if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0); progressFill.BackgroundColor3 = FILL_LIGHT end end resetProgressBar = resetProgressVisuals setupStealBarAPI = function() end
local function getPromptWorldPos(prompt) if not prompt then return nil end local ok, pos = pcall(function() local p = prompt.Parent if p and p:IsA("Attachment") then return p.WorldPosition end if p and p:IsA("BasePart") then return p.Position end if p and p.Parent and p.Parent:IsA("BasePart") then return p.Parent.Position end local ad = prompt.Parent if ad and ad:IsA("Attachment") and ad.Parent and ad.Parent:IsA("BasePart") then return ad.Parent.Position end return nil end) return ok and pos or nil end function Steal.IsMyPlot(plotName) local plots = workspace:FindFirstChild("Plots")
if not plots then return false end local plot = plots:FindFirstChild(plotName) if not plot then return false end local sign = plot:FindFirstChild("PlotSign") if sign then local yourBase = sign:FindFirstChild("YourBase") if yourBase and yourBase:IsA("BillboardGui") then return yourBase.Enabled == true end end local ok, owned = pcall(function() local conf = plot:FindFirstChild("Configuration") or plot:FindFirstChild("Config") if conf then local owner = conf:FindFirstChild("Owner") or conf:FindFirstChild("Player") if owner then local v = owner.Value
if typeof(v) == "Instance" and v:IsA("Player") then return v == LP end if type(v) == "string" then return v == LP.Name or v == tostring(LP.UserId) end end end return false end) return ok and owned or false end local function isStealPrompt(prompt) if not prompt or not prompt:IsA("ProximityPrompt") then return false end local at = (prompt.ActionText or ""):lower(); local ot = (prompt.ObjectText or ""):lower() if at:find("steal", 1, true) or ot:find("steal", 1, true) then return true end return false end function Steal.FindNearestPrompt() local character = LP.Character
if not character then return nil, nil end local root = character:FindFirstChild("HumanoidRootPart") if not root then return nil, nil end local plots = workspace:FindFirstChild("Plots") if not plots then return nil, nil end local nearestPrompt, nearestDistance, nearestPodName = nil, math.huge, nil; local radius = tonumber(Steal.StealRadius) or tonumber(autoStealRadius) or 20 for _, plot in ipairs(plots:GetChildren()) do if plot:IsA("Model") and not Steal.IsMyPlot(plot.Name) then local pods = plot:FindFirstChild("AnimalPodiums") if pods then for _, pod in ipairs(pods:GetChildren()) do
pcall(function() local base = pod:FindFirstChild("Base") local spawnPart = base and base:FindFirstChild("Spawn") if spawnPart then local distance = (spawnPart.Position - root.Position).Magnitude if distance < nearestDistance and distance <= radius then local found = nil; local attachment = spawnPart:FindFirstChild("PromptAttachment") if attachment then for _, child in ipairs(attachment:GetChildren()) do if isStealPrompt(child) then found = child; break end end end if not found then for _, child in ipairs(spawnPart:GetDescendants()) do if isStealPrompt(child) then found = child; break end end
end if found then nearestPrompt = found; nearestDistance = distance; nearestPodName = pod.Name end end end end) end end end end return nearestPrompt, nearestPodName end Steal.updateProgress = function(elapsed, duration) if progressFill then local progress = math.clamp(elapsed / duration, 0, 1); progressFill.Size = UDim2.new(progress, 0, 1, 0); progressFill.BackgroundColor3 = FILL_LIGHT:Lerp(FILL_DARK, progress) end if progressPct then progressPct.Text = string.format("%d%%", math.floor(math.clamp(elapsed / duration, 0, 1) * 100)) end end Steal.checkCancelled = function(prompt)
local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart") if not prompt or not prompt.Parent then return true end local pos = getPromptWorldPos(prompt) if not pos and prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent:IsA("BasePart") then pos = prompt.Parent.Parent.Position end if hrp and pos then local radius = tonumber(Steal.StealRadius) or 20 if (hrp.Position - pos).Magnitude > radius + 4 then return true end end return false end Steal.runPhase1 = function(data, prompt, duration, startTime)
local stopAt = ((selectedStealMode == "Semi" or selectedStealMode == "V3") and (duration * (math.clamp(tonumber(autoGrabStopPercent) or tonumber(Steal.AutoGrabStopPercent) or 75, 1, 100) / 100))) or (tonumber(autoGrabStopTime) or tonumber(Steal.AutoGrabStopTime) or 1.00) while isCurrentlyStealing and autoStealEnabled do local elapsed = tick() - startTime if elapsed >= stopAt then break end Steal.updateProgress(elapsed, duration) if Steal.checkCancelled(prompt) then break end task.wait() end return math.clamp(stopAt / duration, 0, 1) end Steal.runPhase2 = function(data, prompt, stopProgress, duration, startTime)
local stopAt = ((selectedStealMode == "Semi" or selectedStealMode == "V3") and (duration * (math.clamp(tonumber(autoGrabStopPercent) or tonumber(Steal.AutoGrabStopPercent) or 75, 1, 100) / 100))) or (tonumber(autoGrabStopTime) or 1.00); local delayR = tonumber(autoGrabDelayRadius) or tonumber(Steal.AutoGrabDelayRadius) or 8; local phase2Timeout = math.max(2.99 - stopAt - math.max(duration - stopAt, 0), 0.05); local phase2Start = tick() while isCurrentlyStealing and autoStealEnabled do if tick() - phase2Start >= phase2Timeout then return "restart" end if Steal.checkCancelled(prompt) then return "cancel" end local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local pos = getPromptWorldPos(prompt)
if not pos and prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent:IsA("BasePart") then pos = prompt.Parent.Parent.Position end if hrp and pos then local dist = (hrp.Position - pos).Magnitude if dist <= delayR then if progressPct then progressPct.Text = string.format("%d%%", math.floor(stopProgress * 100)) end break elseif dist > (tonumber(Steal.StealRadius) or 20) + 6 then return "cancel" end end task.wait() end return "continue" end Steal.finish = function(data, stopProgress, duration)
local stopAt = ((selectedStealMode == "Semi" or selectedStealMode == "V3") and (duration * (math.clamp(tonumber(autoGrabStopPercent) or tonumber(Steal.AutoGrabStopPercent) or 75, 1, 100) / 100))) or (tonumber(autoGrabStopTime) or 1.00); local fillStart = tick(); local fillDuration = math.max(duration - stopAt, 0.05) while true do local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1); local totalProgress = stopProgress + fp * (1 - stopProgress) if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0); progressFill.BackgroundColor3 = FILL_LIGHT:Lerp(FILL_DARK, totalProgress) end if progressPct then progressPct.Text = string.format("%d%%", math.floor(totalProgress * 100)) end if fp >= 1 then break end task.wait() end
for _, func in ipairs(data.TriggerConnections) do task.spawn(func) end stealsCount = stealsCount + 1 end Steal.resetAfter = function(data) if progressFill then pcall(function() barResetTween = TS:Create(progressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = FILL_LIGHT, }) barResetTween:Play() end) end resetProgressVisuals() if data then data.Ready = true end isCurrentlyStealing = false end function Steal.Execute(prompt, podName) if isCurrentlyStealing then return end if not autoStealEnabled then return end if not prompt then return end
if not Steal.Data[prompt] then Steal.Data[prompt] = { HoldConnections = {}, TriggerConnections = {}, Ready = true, } pcall(function() if getconnections then for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if conn.Function then table.insert(Steal.Data[prompt].HoldConnections, conn.Function) end end for _, conn in ipairs(getconnections(prompt.Triggered)) do if conn.Function then table.insert(Steal.Data[prompt].TriggerConnections, conn.Function) end end end end) end local data = Steal.Data[prompt] if not data.Ready then return end
data.Ready = false; isCurrentlyStealing = true; stealGen = stealGen + 1 if barResetTween then pcall(function() barResetTween:Cancel() end) barResetTween = nil end resetProgressVisuals() if progressFill then progressFill.BackgroundColor3 = FILL_LIGHT end syncStealAliases(); local duration = tonumber(Steal.StealDuration) or 1.3 task.spawn(function() for _, func in ipairs(data.HoldConnections) do task.spawn(func) end local startTime = tick(); local stopProgress = Steal.runPhase1(data, prompt, duration, startTime) if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
if progressPct then progressPct.Text = string.format("%d%%", math.floor(stopProgress * 100)) end local phase2Result = Steal.runPhase2(data, prompt, stopProgress, duration, startTime) if phase2Result == "restart" then resetProgressVisuals(); data.Ready = true isCurrentlyStealing = false; task.wait() if autoStealEnabled then Steal.Execute(prompt, podName) end return elseif phase2Result == "cancel" then Steal.resetAfter(data) return end if isCurrentlyStealing and autoStealEnabled then Steal.finish(data, stopProgress, duration) end Steal.resetAfter(data) end) end startAutoSteal = function()
autoStealEnabled = true; Steal.AutoStealEnabled = true; autoGrabStopEnabled = true; syncStealAliases() if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.0f", Steal.StealRadius) end if autoStealConnection then return end local _stealLastScan = 0 autoStealConnection = RunService.Heartbeat:Connect(function() if not autoStealEnabled or isCurrentlyStealing then return end local now = os.clock(); local interval = _IS_MOBILE and 0.16 or 0.07 if (now - _stealLastScan) < interval then return end _stealLastScan = now; local prompt, podName = Steal.FindNearestPrompt() if prompt then
pcall(Steal.Execute, prompt, podName) end end) end stopAutoSteal = function() autoStealEnabled = false; Steal.AutoStealEnabled = false; stealGen = stealGen + 1 if autoStealConnection then pcall(function() autoStealConnection:Disconnect() end) autoStealConnection = nil end task.spawn(function() local waitStart = tick() while isCurrentlyStealing and (tick() - waitStart) < 5 do task.wait(0.05) end isCurrentlyStealing = false; resetProgressVisuals() end) end AceAutoStealSync = function() syncStealAliases() if autoStealEnabled then startAutoSteal() else stopAutoSteal() end end
local Conns = {batCounter=nil,anchor={},progress=nil}; local MEDUSA_COOLDOWN,batCounterDebounce = 25,false; local lastMoveDir = Vector3.new(0,0,0) local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true, [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Right]=true,[Enum.KeyCode.Down]=true} function F.getActiveMoveSpeed() return S.laggerToggled and (S.laggerPhase==2 and S.LAGGER_CARRY_SPEED or S.LAGGER_SPEED) or (S.speedMode and CS or NS) end function F.getAutoPathSpeed() return NS end function F.isRagdollState(hum)
if not hum then return true end if S.antiRagdollEnabled then return false end local st = hum:GetState() return st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or hum.PlatformStand == true end function F.isMyPlotByName(plotName) local plots=workspace:FindFirstChild("Plots") if not plots then return false end local plot=plots:FindFirstChild(plotName) if not plot then return false end local sign=plot:FindFirstChild("PlotSign") if sign then local yb=sign:FindFirstChild("YourBase") if yb and yb:IsA("BillboardGui") then
return yb.Enabled==true end end return false end local spoofedVelocity = Vector3.zero --[[ anti-drop removido ]] local function applyVelocitySpeed(speed)
local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart") if not char or not hum or not root or hum.Health <= 0 then return end if F.isRagdollState(hum) then lastMoveDir = Vector3.new(0, 0, 0) return end if S.autoBatEnabled or S.autoLeftEnabled or S.autoRightEnabled or tpBatEnabled or aimbotEnabled then return end local dir = hum.MoveDirection; local spd = tonumber(speed) or F.getActiveMoveSpeed() or 16 if dir.Magnitude > 0.05 then lastMoveDir = dir pcall(function() if root.SetNetworkOwner then
root:SetNetworkOwner(LP) end end) local unit = dir.Unit local y = root.AssemblyLinearVelocity.Y; spoofedVelocity = Vector3.new(unit.X * 16, y, unit.Z * 16); root.AssemblyLinearVelocity = Vector3.new(unit.X * spd, y, unit.Z * spd) elseif S.antiRagdollEnabled and lastMoveDir.Magnitude > 0.05 then local anyHeld = false for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld = true break end end if anyHeld then pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end) local unit = lastMoveDir.Unit
local y = root.AssemblyLinearVelocity.Y; spoofedVelocity = Vector3.new(unit.X * 16, y, unit.Z * 16); root.AssemblyLinearVelocity = Vector3.new(unit.X * spd, y, unit.Z * spd) else spoofedVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0) end else spoofedVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0) end if S.speedLabel then local real = root.AssemblyLinearVelocity; S.speedLabel.Text = string.format("Speed: %.1f", Vector3.new(real.X, 0, real.Z).Magnitude) end end RunService.PreSimulation:Connect(function() applyVelocitySpeed(F.getActiveMoveSpeed()) end)
local alConn,arConn=nil,nil local alPhase,arPhase=1,1 function F.stopAutoLeft() if alConn then alConn:Disconnect();alConn=nil end;alPhase=1 local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end F.destroyProxy() end function F.stopAutoRight() if arConn then arConn:Disconnect();arConn=nil end;arPhase=1 local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
if S.autoRightSetVisual then S.autoRightSetVisual(false) end F.destroyProxy() end function F.startAutoLeft() if alConn then alConn:Disconnect() end;alPhase=1 alConn=RunService.Heartbeat:Connect(function() if not S.autoLeftEnabled then return end local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid") if not hrp or not hum then return end if F.isRagdollState(hum) then hum:Move(Vector3.zero,false);return end local spd=F.getAutoPathSpeed(); local proxy = F.ensureProxy() if not proxy then return end
if alPhase==1 then local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z) if (tgt-hrp.Position).Magnitude<1 then alPhase=2; local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) return end local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) elseif alPhase==2 then local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z) if (tgt-hrp.Position).Magnitude<1 then
hum:Move(Vector3.zero,false); proxy.AssemblyLinearVelocity=Vector3.zero S.autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end; alPhase=1;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; F.destroyProxy() return end local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) end end) end function F.startAutoRight() if arConn then arConn:Disconnect() end;arPhase=1 arConn=RunService.Heartbeat:Connect(function() if not S.autoRightEnabled then return end
local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid") if not hrp or not hum then return end if F.isRagdollState(hum) then hum:Move(Vector3.zero,false);return end local spd=F.getAutoPathSpeed(); local proxy = F.ensureProxy() if not proxy then return end if arPhase==1 then local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z) if (tgt-hrp.Position).Magnitude<1 then
arPhase=2; local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) return end local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) elseif arPhase==2 then local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z) if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false); proxy.AssemblyLinearVelocity=Vector3.zero
S.autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end; arPhase=1;if S.autoRightSetVisual then S.autoRightSetVisual(false) end; F.destroyProxy() return end local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) end end) end function F.setupSpeedIndicator(char) S.speedLabel = nil pcall(function() local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5)) if head then local oldBb = head:FindFirstChild("CursedSpeedBillboard") while oldBb do
oldBb:Destroy(); oldBb = head:FindFirstChild("CursedSpeedBillboard") end end end) end function F.startUnwalk() local c=LP.Character;if not c then return end; local hum=c:FindFirstChildOfClass("Humanoid") if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end local anim=c:FindFirstChild("Animate") if anim then S.unwalkSavedAnimate=anim:Clone();anim:Destroy() end end function F.stopUnwalk() local c=LP.Character if c and S.unwalkSavedAnimate then S.unwalkSavedAnimate:Clone().Parent=c;S.unwalkSavedAnimate=nil end end
local dropActive = false; local DROP_ASCEND_DURATION = 0.25; local DROP_ASCEND_SPEED = 240; local _dropConn = nil local function _dropSetBtn(state) pcall(function() local entry = (_G.VersincMobileButtonRefs or {}).drop if entry and entry.setActive then entry.setActive(state and true or false) end end) end function F.dropTeleportToFloor(char, hum, root) if not root then return false end local ok = false pcall(function() local params = RaycastParams.new() params.FilterDescendantsInstances = { char } params.FilterType = Enum.RaycastFilterType.Exclude params.IgnoreWater = true
local origin = root.Position + Vector3.new(0, 5, 0) local result = workspace:Raycast(origin, Vector3.new(0, -2000, 0), params) if result and result.Position then local offset = ((hum and hum.HipHeight) or 2) + (root.Size.Y / 2) + 0.05 root.CFrame = CFrame.new(root.Position.X, result.Position.Y + offset, root.Position.Z) ok = true elseif root.Position.Y < -100 then root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z) end root.AssemblyLinearVelocity = Vector3.zero root.AssemblyAngularVelocity = Vector3.zero
if hum and hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end end) return ok end function F.stopAutoTPForAction() if S.autoTPEnabled then pcall(function() if F.stopAutoTP then F.stopAutoTP() end end) S.autoTPEnabled = false pcall(function() if VS and VS.setAutoTPVisual then VS.setAutoTPVisual(false) end end) pcall(function() if F.saveConfig then F.saveConfig() end end) end end function F.runDrop() if dropActive or S.dropActive then return end F.stopAutoTPForAction() local char = LP.Character local hum  = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart") if not char or not hum or not root or hum.Health <= 0 then return end dropActive = true; S.dropActive = true _dropSetBtn(true) local t0 = tick() local duration = tonumber(DROP_ASCEND_DURATION) or 0.25 local speed = tonumber(DROP_ASCEND_SPEED) or 240 if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end local function finish() dropActive = false; S.dropActive = false _dropSetBtn(false) end _dropConn = RunService.Heartbeat:Connect(function() local currentChar = LP.Character
local r  = currentChar and currentChar:FindFirstChild("HumanoidRootPart") local ch = currentChar and currentChar:FindFirstChildOfClass("Humanoid") if not r or not ch or ch.Health <= 0 or not dropActive then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end finish() return end if tick() - t0 >= duration then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero F.dropTeleportToFloor(currentChar, ch, r) finish() return end
r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, speed, r.AssemblyLinearVelocity.Z) end) end function F.stopDrop() dropActive = false; S.dropActive = false if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end _dropSetBtn(false) end LP.CharacterRemoving:Connect(function() F.stopDrop() end) function F.doAutoTPDown(force) local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end; local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end if not force then
if hum2.FloorMaterial~=Enum.Material.Air then return end if hrp.Position.Y<S.autoTPHeight then return end end hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z) *CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0) hrp.AssemblyLinearVelocity=Vector3.zero end function F.startAutoTP() if S.autoTPConn then task.cancel(S.autoTPConn);S.autoTPConn=nil end S.autoTPConn=task.spawn(function() while S.autoTPEnabled do task.wait(0.1) pcall(function() F.doAutoTPDown(false) end) end end) end function F.stopAutoTP() S.autoTPEnabled=false
if S.autoTPConn then task.cancel(S.autoTPConn);S.autoTPConn=nil end end function F.runTPFloor() pcall(function() F.doAutoTPDown(true) end) end local defLightBrightness,defLightClock,defLightAmbient function F.applyAntiLagDerender(obj) pcall(function() if obj:IsA("Beam") or obj:IsA("Attachment") or obj:IsA("Highlight") or obj:IsA("BillboardGui") then local n = (obj.Name or ""):lower() if n:find("versinc") or n:find("tracer") or n:find("lineesp") or n:find("sevenup") or n:find("playeresp") then return end local p = obj.Parent while p do local pn = (p.Name or ""):lower()
if pn:find("versinc") or pn:find("tracer") or pn == "versinctracers" or pn:find("esp") then return end p = p.Parent end end if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then obj.Enabled = false elseif obj:IsA("Decal") or obj:IsA("Texture") then
if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then pcall(function() obj:Destroy() end) end elseif obj:IsA("SurfaceAppearance") then pcall(function() obj:Destroy() end) elseif obj:IsA("Accessory") or obj:IsA("Hat") then for _, d in ipairs(obj:GetDescendants()) do if d:IsA("BasePart") then d.CastShadow = false; d.Material = Enum.Material.Plastic end end elseif obj:IsA("Animator") and obj.Parent and obj.Parent.Parent ~= LP.Character then pcall(function() obj:Destroy() end) elseif obj:IsA("PostEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect")
or obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then obj.Enabled = false end end) end function F.enableAntiLag() S.antiLagEnabled = true; defLightBrightness = defLightBrightness or Lighting.Brightness; defLightClock = defLightClock or Lighting.ClockTime; defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient pcall(function() Lighting.GlobalShadows = false Lighting.FogEnd = 1e10; Lighting.Brightness = 1; Lighting.EnvironmentDiffuseScale = 0; Lighting.EnvironmentSpecularScale = 0
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end) for _, e in ipairs(Lighting:GetDescendants()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("Atmosphere") or e:IsA("Clouds") or e:IsA("PostEffect") then e.Enabled = false end end) end for _, obj in ipairs(workspace:GetDescendants()) do if S.antiLagEnabled then F.applyAntiLagDerender(obj) end end if S.antiLagDescConn then S.antiLagDescConn:Disconnect() end
S.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj) if not S.antiLagEnabled then return end task.defer(function() F.applyAntiLagDerender(obj) end) end) end function F.disableAntiLag() S.antiLagEnabled = false if S.antiLagDescConn then S.antiLagDescConn:Disconnect(); S.antiLagDescConn = nil end pcall(function() if defLightBrightness then Lighting.Brightness = defLightBrightness end if defLightClock then Lighting.ClockTime = defLightClock end if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end Lighting.GlobalShadows = true; Lighting.ExposureCompensation = 0
settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic for _, e in ipairs(Lighting:GetDescendants()) do pcall(function() if e:IsA("PostEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("Atmosphere") or e:IsA("Clouds") then e.Enabled = true end end) end end) end local _kbOverlay = { screen = nil, conns = {}, buttons = {}, enabled = false, panel = nil, } local function _kbDisconnectAll() for _, c in ipairs(_kbOverlay.conns) do pcall(function() c:Disconnect() end) end
_kbOverlay.conns = {} end local function _kbTrack(conn) table.insert(_kbOverlay.conns, conn) return conn end function F.stopKeyboardOverlay() S.keyboardOverlayEnabled = false; _kbOverlay.enabled = false; _kbDisconnectAll() if _kbOverlay.screen then pcall(function() _kbOverlay.screen:Destroy() end) _kbOverlay.screen = nil end _kbOverlay.buttons = {}; _kbOverlay.panel = nil pcall(function() local env = (type(getgenv) == "function" and getgenv()) or _G if env.__VersincKeyboardOverlay then env.__VersincKeyboardOverlay = nil end end) end function F.startKeyboardOverlay()
if _kbOverlay.enabled and _kbOverlay.screen and _kbOverlay.screen.Parent then S.keyboardOverlayEnabled = true return end F.stopKeyboardOverlay(); S.keyboardOverlayEnabled = true _kbOverlay.enabled = true; local guiParent = nil pcall(function() if type(gethui) == "function" then guiParent = gethui() end end) if not guiParent then pcall(function() guiParent = game:GetService("CoreGui") end) end if not guiParent then guiParent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 3) end if not guiParent then return end local CONFIG = { guiName = "VersincKeyboardOverlay", uiScale = 1.0,
keySize = 30, keyGap = 4, mouseWidth = 58, mouseHeight = 92, mouseGap = 16, trackSpeed = 1500, trackAttack = 0.65, trackRelease = 0.18, toggleKey = Enum.KeyCode.F8, hideWhileTyping = true, wheelFlash = 0.13, fadeIn = 0.03, fadeOut = 0.11, defaultPos = Vector2.new(0.025, 0.62), } local THEME = { panelFill = Color3.fromRGB(0, 0, 0), panelIdle = 0.40, keyFill = Color3.fromRGB(0, 0, 0), keyIdle = 0.05, pressFill = Color3.fromRGB(255, 255, 255), pressIdle = 0.00, line = Color3.fromRGB(255, 255, 255), lineIdle = 0.35, lineActive = 0.00, textIdle = Color3.fromRGB(255, 255, 255),
textActive = Color3.fromRGB(0, 0, 0), textStroke = 0.70, headerIdle = 0.30, headerLocked = 1.00, font = Enum.Font.GothamBold, fontCaption = Enum.Font.Gotham, } local KEYBOARD_ROWS = { { { id = "Escape", label = "ESC", w = 1.5 }, { id = "One", label = "1" }, { id = "Two", label = "2" }, { id = "Three", label = "3" }, { id = "Four", label = "4" }, { id = "Five", label = "5" }, }, { { id = "Tab", label = "TAB", w = 1.5 }, { id = "Q", label = "Q" }, { id = "W", label = "W" }, { id = "E", label = "E" }, { id = "R", label = "R" }, { id = "T", label = "T" }, }, {
{ id = "CapsLock", label = "CAPS", w = 1.75 }, { id = "A", label = "A" }, { id = "S", label = "S" }, { id = "D", label = "D" }, { id = "F", label = "F" }, { id = "G", label = "G" }, }, { { id = "LeftShift", label = "SHIFT", w = 2.25 }, { id = "Z", label = "Z" }, { id = "X", label = "X" }, { id = "C", label = "C" }, { id = "V", label = "V" }, { id = "B", label = "B" }, }, { { id = "LeftControl", label = "CTRL", w = 1.5 }, { id = "LeftAlt", label = "ALT", w = 1.25 }, { id = "Space", label = "SPACE", w = 3.5 }, }, } local function new(class, props, children) local inst = Instance.new(class)
for key, value in pairs(props or {}) do if key ~= "Parent" then inst[key] = value end end for _, child in ipairs(children or {}) do child.Parent = inst end if props and props.Parent then inst.Parent = props.Parent end return inst end local function kTween(inst, duration, props) TS:Create(inst, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end local Cell = {}; Cell.__index = Cell function Cell.new(fill, stroke, label) return setmetatable({ fill = fill, stroke = stroke, label = label, active = false }, Cell) end function Cell:setActive(on)
if self.active == on then return end self.active = on; local duration = on and CONFIG.fadeIn or CONFIG.fadeOut if self.frame then kTween(self.frame, duration, { BackgroundColor3 = on and THEME.pressFill or THEME.keyFill, BackgroundTransparency = on and THEME.pressIdle or THEME.keyIdle, }) end if self.fill and not self.analog then kTween(self.fill, duration, { BackgroundColor3 = THEME.pressFill, BackgroundTransparency = on and THEME.pressIdle or 1, }) end if self.stroke then kTween(self.stroke, duration, { Color = THEME.line, Transparency = on and THEME.lineActive or THEME.lineIdle, }) end
if self.label and not self.analog then kTween(self.label, duration, { TextColor3 = on and THEME.textActive or THEME.textIdle, TextStrokeTransparency = on and 1 or THEME.textStroke, }) end if self.dot then self.dot.BackgroundColor3 = on and Color3.new(0, 0, 0) or THEME.pressFill; self.dot.BackgroundTransparency = on and 0 or 0.15 end end function Cell:flash(duration) self.flashToken = (self.flashToken or 0) + 1; local token = self.flashToken; self:setActive(true) task.delay(duration or CONFIG.wheelFlash, function() if self.flashToken == token then self:setActive(false) end end) end
local function makeKey(parent, def, rect) local cornerR = def.circle and UDim.new(1, 0) or UDim.new(0, 5) local frame = new("Frame", { Name = def.id or "Key", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = THEME.keyIdle, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(rect.x, rect.y), Size = UDim2.fromOffset(rect.w, rect.h), Parent = parent, }, { new("UICorner", { CornerRadius = cornerR }) }) local stroke = new("UIStroke", { Color = THEME.line, Thickness = 1.4, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = frame, })
local fill = new("Frame", { Name = "Fill", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 2, Parent = frame, }, { new("UICorner", { CornerRadius = cornerR }) }) local label if def.label then label = new("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Font = THEME.font, Text = def.label, TextColor3 = THEME.textIdle, TextScaled = true, TextStrokeColor3 = Color3.new(0, 0, 0), TextStrokeTransparency = THEME.textStroke, ZIndex = 3, Parent = frame, }, { new("UIPadding", {
PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3), PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2), }), new("UITextSizeConstraint", { MaxTextSize = math.max(9, math.floor(rect.h * 0.55)) }), }) end local cell = Cell.new(fill, stroke, label); cell.frame = frame return cell end pcall(function() local old = guiParent:FindFirstChild(CONFIG.guiName) if old then old:Destroy() end end) local screen = new("ScreenGui", { Name = CONFIG.guiName, ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = guiParent, })
_kbOverlay.screen = screen local HEADER_HEIGHT, PADDING = 18, 8; local unit = CONFIG.keySize + CONFIG.keyGap; local widestRow = 0 for _, row in ipairs(KEYBOARD_ROWS) do local total = 0 for _, def in ipairs(row) do total = total + (def.w or 1) end widestRow = math.max(widestRow, total) end local keysWidth = widestRow * unit - CONFIG.keyGap; local keysHeight = #KEYBOARD_ROWS * unit - CONFIG.keyGap local bodySize = Vector2.new( keysWidth + CONFIG.mouseGap + CONFIG.mouseWidth, math.max(keysHeight, CONFIG.mouseHeight) ) local root = new("Frame", { Name = "Panel", Active = false,
BackgroundColor3 = THEME.panelFill, BackgroundTransparency = THEME.panelIdle, BorderSizePixel = 0, Size = UDim2.fromOffset(bodySize.X + PADDING * 2, bodySize.Y + PADDING * 2 + HEADER_HEIGHT), Position = UDim2.fromScale(CONFIG.defaultPos.X, CONFIG.defaultPos.Y), Parent = screen, }, { new("UIScale", { Scale = CONFIG.uiScale }), new("UICorner", { CornerRadius = UDim.new(0, 10) }), }) new("UIStroke", { Color = THEME.line, Thickness = 1, Transparency = 0.85, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = root, }) local header = new("Frame", { Name = "Handle", Active = true,
BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = THEME.headerIdle, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, HEADER_HEIGHT), Parent = root, }, { new("UICorner", { CornerRadius = UDim.new(0, 8) }), new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 5) }), }) new("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -22, 1, 0), Font = THEME.fontCaption, Text = "KEYBOARD + MOUSE", TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.textIdle, TextTransparency = 0.25, Parent = header, }) local body = new("Frame", {
Name = "Body", Active = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(PADDING, HEADER_HEIGHT + PADDING), Size = UDim2.fromOffset(bodySize.X, bodySize.Y), Parent = root, }) local Buttons = {} for rowIndex, row in ipairs(KEYBOARD_ROWS) do local x = 0; local y = (rowIndex - 1) * unit for _, def in ipairs(row) do local width = (def.w or 1) * unit - CONFIG.keyGap local cell = makeKey(body, def, { x = math.floor(x), y = y, w = math.floor(width), h = CONFIG.keySize, }) if def.id then Buttons[def.id] = cell end x = x + (def.w or 1) * unit end end
local originX = keysWidth + CONFIG.mouseGap; local originY = math.floor((bodySize.Y - CONFIG.mouseHeight) / 2); local width, height = CONFIG.mouseWidth, CONFIG.mouseHeight; local radius = math.floor(width * 0.42); local topPart = math.floor(height * 0.40); local wheelW = math.max(7, math.floor(width * 0.16)); local sideW = math.floor((width - wheelW - 4) / 2) local mouseBody = new("Frame", { Name = "Mouse", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = THEME.keyIdle, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(originX, originY),
Size = UDim2.fromOffset(width, height), Parent = body, }, { new("UICorner", { CornerRadius = UDim.new(0, radius) }) }) new("UIStroke", { Color = THEME.line, Thickness = 1.4, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = mouseBody, }) local function makeMouseButton(name, clipX, fillX) local clip = new("Frame", { Name = name .. "Clip", BackgroundTransparency = 1, ClipsDescendants = true, Position = UDim2.fromOffset(clipX, 0), Size = UDim2.fromOffset(sideW, topPart), ZIndex = 2, Parent = mouseBody, }) local fill = new("Frame", {
Name = name, BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(fillX, 0), Size = UDim2.fromOffset(sideW + radius, topPart + radius), Parent = clip, }, { new("UICorner", { CornerRadius = UDim.new(0, radius) }) }) local cell = Cell.new(fill, nil, nil) cell.frame = fill return cell end local mouseLeft = makeMouseButton("LeftButton", 0, 0); local mouseRight = makeMouseButton("RightButton", width - sideW, -radius); Buttons.Mouse1 = mouseLeft; Buttons.Mouse2 = mouseRight new("Frame", {
Name = "Split", BackgroundColor3 = THEME.line, BackgroundTransparency = 0.55, BorderSizePixel = 0, Position = UDim2.fromOffset(0, topPart), Size = UDim2.new(1, 0, 0, 1), ZIndex = 4, Parent = mouseBody, }) local wheelH = math.floor(topPart * 0.60) local wheel = new("Frame", { Name = "Wheel", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = 0.1, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(math.floor((width - wheelW) / 2), math.floor(topPart * 0.20)), Size = UDim2.fromOffset(wheelW, wheelH), ZIndex = 5, Parent = mouseBody,
}, { new("UICorner", { CornerRadius = UDim.new(0, math.floor(wheelW / 2)) }) }) local wheelStroke = new("UIStroke", { Color = THEME.line, Thickness = 1.2, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = wheel, }) local wheelFill = new("Frame", { Name = "Fill", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 6, Parent = wheel, }, { new("UICorner", { CornerRadius = UDim.new(0, math.floor(wheelW / 2)) }) }) local mouseWheel = Cell.new(wheelFill, wheelStroke, nil)
mouseWheel.frame = wheel; mouseWheel.basePosition = wheel.Position; Buttons.Mouse3 = mouseWheel; local zone = math.min(math.floor(width / 2) - 7, math.floor((height - topPart) / 2) - 6) local ring = new("Frame", { Name = "TrackZone", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(math.floor(width / 2), topPart + math.floor((height - topPart) / 2)), Size = UDim2.fromOffset(zone * 2, zone * 2), ZIndex = 3, Parent = mouseBody, }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) }) new("UIStroke", {
Color = THEME.line, Thickness = 1, Transparency = 0.8, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = ring, }) local trackerDot = new("Frame", { Name = "Pointer", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 0.2, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(8, 8), ZIndex = 4, Parent = ring, }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) }) local trackerRadius = zone - 4 _kbOverlay.buttons = Buttons local function isTyping()
return CONFIG.hideWhileTyping and UIS:GetFocusedTextBox() ~= nil end local function releaseAll() for _, cell in pairs(Buttons) do cell:setActive(false) end if mouseWheel.frame and mouseWheel.basePosition then mouseWheel.frame.Position = mouseWheel.basePosition end trackerDot.Position = UDim2.fromScale(0.5, 0.5) end local function resolveId(input) local kind = input.UserInputType if kind == Enum.UserInputType.Keyboard then return input.KeyCode.Name elseif kind == Enum.UserInputType.MouseButton1 then return "Mouse1" elseif kind == Enum.UserInputType.MouseButton2 then return "Mouse2"
elseif kind == Enum.UserInputType.MouseButton3 then return "Mouse3" end return nil end _kbTrack(UIS.InputBegan:Connect(function(input) if isTyping() then return end local id = resolveId(input); local cell = id and Buttons[id] if cell then cell:setActive(true) end end)) _kbTrack(UIS.InputEnded:Connect(function(input) local id = resolveId(input) local cell = id and Buttons[id] if cell then cell:setActive(false) end end)) _kbTrack(UIS.InputChanged:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseWheel or isTyping() then return end
local up = input.Position.Z > 0; mouseWheel:flash(CONFIG.wheelFlash); local base = mouseWheel.basePosition; mouseWheel.frame.Position = base + UDim2.fromOffset(0, up and -3 or 3) task.delay(CONFIG.wheelFlash, function() if mouseWheel.frame then kTween(mouseWheel.frame, 0.08, { Position = base }) end end) end)) local pointerAccum, pointerCurrent, pointerLast = Vector2.zero, Vector2.zero, nil _kbTrack(UIS.InputChanged:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end local delta = Vector2.new(input.Delta.X, input.Delta.Y)
if delta.Magnitude < 0.001 then local position = Vector2.new(input.Position.X, input.Position.Y) if pointerLast then delta = position - pointerLast end pointerLast = position else pointerLast = nil end pointerAccum = pointerAccum + delta end)) _kbTrack(RunService.RenderStepped:Connect(function(step) local frame = math.clamp(step, 1 / 240, 1 / 15) local velocity = pointerAccum / frame; pointerAccum = Vector2.zero; local target = Vector2.zero; local speed = velocity.Magnitude if speed > 1 then
local amount = 1 - math.exp(-speed / CONFIG.trackSpeed); target = velocity.Unit * math.clamp(amount, 0, 1) end local rate = target.Magnitude > pointerCurrent.Magnitude and CONFIG.trackAttack or CONFIG.trackRelease; pointerCurrent = pointerCurrent + (target - pointerCurrent) * math.clamp(rate * frame * 60, 0, 1) if pointerCurrent.Magnitude < 0.004 then pointerCurrent = Vector2.zero end trackerDot.Position = UDim2.new( 0.5, pointerCurrent.X * trackerRadius, 0.5, pointerCurrent.Y * trackerRadius ) trackerDot.BackgroundTransparency = 0.2 - math.min(pointerCurrent.Magnitude, 1) * 0.2 end)) do
local dragInput, startMouse, startOffset _kbTrack(header.InputBegan:Connect(function(input) local kind = input.UserInputType if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end local view = screen.AbsoluteSize; dragInput = input; startMouse = Vector2.new(input.Position.X, input.Position.Y); startOffset = Vector2.new(root.Position.X.Scale * view.X, root.Position.Y.Scale * view.Y) end)) _kbTrack(UIS.InputChanged:Connect(function(input) if not dragInput then return end local moving if dragInput.UserInputType == Enum.UserInputType.Touch then
moving = (input == dragInput) else moving = (input.UserInputType == Enum.UserInputType.MouseMovement) end if not moving then return end local view = screen.AbsoluteSize; local target = startOffset + (Vector2.new(input.Position.X, input.Position.Y) - startMouse); root.Position = UDim2.fromScale(target.X / view.X, target.Y / view.Y) end)) _kbTrack(UIS.InputEnded:Connect(function(input) if dragInput and input == dragInput then dragInput = nil end end)) end _kbTrack(UIS.InputBegan:Connect(function(input) if input.KeyCode ~= CONFIG.toggleKey or isTyping() then return end
screen.Enabled = not screen.Enabled if not screen.Enabled then releaseAll() end end)) _kbTrack(UIS.WindowFocusReleased:Connect(releaseAll)) pcall(function() local env = (type(getgenv) == "function" and getgenv()) or _G env.__VersincKeyboardOverlay = { destroy = F.stopKeyboardOverlay, screen = screen } end) end function F.findMedusa() local c = LP.Character if not c then return nil end for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end local bp = LP:FindFirstChild("Backpack")
if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end return nil end function F.useMedusaCounter() if S.medusaDebounce then return end if MEDUSA_COOLDOWN > (tick() - S.medusaLastUsed) then return end local c = LP.Character if not c then return end S.medusaDebounce = true; local med = F.findMedusa() if not med then S.medusaDebounce = false; return end if med.Parent ~= c then local hum2 = c:FindFirstChildOfClass("Humanoid") if hum2 then hum2:EquipTool(med) end end
pcall(function() med:Activate() end) S.medusaLastUsed = tick(); S.medusaDebounce = false end function F.onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency == 1 then if S.medusaResetEnabled then if cursedInstaReset then cursedInstaReset() end elseif S.medusaCounterEnabled then F.useMedusaCounter() end end end) end function F.setupMedusa(char) for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end Conns.anchor = {} if not char then return end for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then table.insert(Conns.anchor, F.onAnchorChanged(part)) end end table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor, F.onAnchorChanged(part)) end end)) end function F.stopMedusaCounter() for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end Conns.anchor = {} end function F.refreshMedusaWatch() if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(LP.Character) else F.stopMedusaCounter() end end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"} function F.findBatForCounter() local c=LP.Character;if not c then return nil end; local bp=LP:FindFirstChildOfClass("Backpack") for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end return nil end function F.swingBatForCounter(bat,char) local hum2=char:FindFirstChildOfClass("Humanoid") if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction") if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end end S.startBatCounter=function() if Conns.batCounter then return end Conns.batCounter=RunService.Heartbeat:Connect(function() if not S.batCounterEnabled then return end if batCounterDebounce then return end local char=LP.Character;if not char then return end; local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end; local st=hum2:GetState() if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
batCounterDebounce=true task.spawn(function() local bat=F.findBatForCounter() if bat then F.swingBatForCounter(bat,char) end task.wait(0.5);batCounterDebounce=false end) end end) end S.stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end batCounterDebounce=false end function F.getAutoBatTarget() local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil end local now=tick() if now-S._autoBatLastScan<=0.1 and S._autoBatTarget and S._autoBatTarget.Parent then
local hum=S._autoBatTarget.Parent:FindFirstChildOfClass("Humanoid") if hum and hum.Health>0 then return S._autoBatTarget end end S._autoBatLastScan=now; S._autoBatTarget=nil; local closest,minDist=nil,math.huge for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP and plr.Character then local tRoot=plr.Character:FindFirstChild("HumanoidRootPart"); local hum=plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude if dist<minDist then minDist=dist;closest=tRoot end end end end S._autoBatTarget=closest
return S._autoBatTarget end S.resetAutoBatMotion=function() local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid") if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end if hum then hum.AutoRotate=true end end local _autoTPWasEnabled=false S.enableAutoBat = function() if S.autoLeftEnabled then S.autoLeftEnabled=false;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end;F.stopAutoLeft() end
if S.autoRightEnabled then S.autoRightEnabled=false;if S.autoRightSetVisual then S.autoRightSetVisual(false) end;F.stopAutoRight() end if S.autoTPEnabled then _autoTPWasEnabled=true;F.stopAutoTP();if VS.setAutoTPVisual then VS.setAutoTPVisual(false) end else _autoTPWasEnabled=false end S.autoBatEquippedThisRun=false; S.autoBatEnabled=true end S.disableAutoBat = function() S.autoBatEnabled=false; S.autoBatEquippedThisRun=false; local char=LP.Character if char then local hum2=char:FindFirstChildOfClass("Humanoid") if hum2 then hum2.AutoRotate=true end end
if S.resetAutoBatMotion then S.resetAutoBatMotion() end if _autoTPWasEnabled then _autoTPWasEnabled=false;S.autoTPEnabled=true if VS.setAutoTPVisual then VS.setAutoTPVisual(true) end;F.startAutoTP() end F.destroyProxy() end function F.queueAutoLeftStart() if not F.safeModeTryStart() then S.autoLeftEnabled=false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; return end S.autoLeftEnabled=true if S.autoRightEnabled then S.autoRightEnabled=false;if S.autoRightSetVisual then S.autoRightSetVisual(false) end;F.stopAutoRight() end
if S.autoBatEnabled then S.disableAutoBat();if S.autoBatSetVisual then S.autoBatSetVisual(false) end end F.startAutoLeft() end function F.queueAutoRightStart() if not F.safeModeTryStart() then S.autoRightEnabled=false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; return end S.autoRightEnabled=true if S.autoLeftEnabled then S.autoLeftEnabled=false;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end;F.stopAutoLeft() end if S.autoBatEnabled then S.disableAutoBat();if S.autoBatSetVisual then S.autoBatSetVisual(false) end end F.startAutoRight() end
function F.queueAutoBatStart() if not F.safeModeTryStart() then if S.autoBatSetVisual then S.autoBatSetVisual(false) end; return end if S.autoLeftEnabled then S.autoLeftEnabled=false;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end;F.stopAutoLeft() end if S.autoRightEnabled then S.autoRightEnabled=false;if S.autoRightSetVisual then S.autoRightSetVisual(false) end;F.stopAutoRight() end S.enableAutoBat() end RunService.Heartbeat:Connect(function() if not S.autoBatEnabled then return end
local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local root=char and char:FindFirstChild("HumanoidRootPart") if not root or not hum then return end if not S.autoBatEquippedThisRun then S.autoBatEquippedThisRun=true if not char:FindFirstChildOfClass("Tool") then local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack"); local bpBat=bp and bp:FindFirstChild("Bat") if bpBat then pcall(function() hum:EquipTool(bpBat) end) end end end local target=F.getAutoBatTarget() if target then
local targetVel=target.AssemblyLinearVelocity; local aimTargetPos=target.Position+(targetVel*math.clamp(targetVel.Magnitude/130,0.05,0.15))+Vector3.new(0,S.AUTO_BAT_V_OFF,0); hum.AutoRotate=false; local look=aimTargetPos-root.Position; local flatLook=Vector3.new(look.X,0,look.Z) if look.Magnitude>0.01 and flatLook.Magnitude>0.01 then
local targetYaw=math.deg(math.atan2(-flatLook.X,-flatLook.Z)); local yawDelta=(targetYaw-root.Orientation.Y+180)%360-180; local targetPitch=math.deg(math.atan2(look.Y,flatLook.Magnitude)); local pitchDelta=(targetPitch-root.Orientation.X+180)%360-180; local yawRate=math.clamp(math.rad(yawDelta)*S.AUTO_BAT_TURN_SPEED,-S.AUTO_BAT_MAX_TURN_RATE,S.AUTO_BAT_MAX_TURN_RATE); local pitchRate=math.clamp(math.rad(pitchDelta)*S.AUTO_BAT_TURN_SPEED,-S.AUTO_BAT_MAX_TURN_RATE,S.AUTO_BAT_MAX_TURN_RATE); local yawRad=math.rad(root.Orientation.Y); local rightAxis=Vector3.new(math.cos(yawRad),0,-math.sin(yawRad)); root.AssemblyAngularVelocity=Vector3.new(0,yawRate,0)+(rightAxis*pitchRate)
else root.AssemblyAngularVelocity=Vector3.zero end local dir=look.Magnitude>0.01 and look.Unit or Vector3.zero; local standPos=aimTargetPos-(dir*S.AUTO_BAT_DIST)+Vector3.new(0,S.AUTO_BAT_HEIGHT,0); local moveDir=standPos-root.Position; local hDir=Vector3.new(moveDir.X,0,moveDir.Z); local hVel=hDir.Magnitude>0.1 and hDir.Unit*S.AUTO_BAT_SPEED or Vector3.zero; local vVel=math.abs(moveDir.Y)>0.1 and Vector3.new(0,math.sign(moveDir.Y)*S.AUTO_BAT_VERT_SPEED,0) or Vector3.new(0,-2,0); local proxy = F.ensureProxy() if proxy then proxy.AssemblyLinearVelocity = hVel + vVel end
if hDir.Magnitude>0.5 then hum:Move(hDir.Unit,false) end else hum.AutoRotate=true; root.AssemblyAngularVelocity=Vector3.zero end if S.autoSwingEnabled then local bat=char:FindFirstChild("Bat") if bat and bat:IsA("Tool") then bat:Activate() end end end) local function applyCrystalDiscord(char) task.defer(function() local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5)) if not head then return end local old = head:FindFirstChild("CrystalDiscord") if old then old:Destroy() end local bb = Instance.new("BillboardGui"); bb.Name = "CrystalDiscord"; bb.Adornee = head; bb.Size = UDim2.fromOffset(190, 28); bb.StudsOffset = Vector3.new(0, 3.2, 0); bb.AlwaysOnTop = true; bb.Parent = head; local label = Instance.new("TextLabel"); label.Size = UDim2.fromScale(1, 1); label.BackgroundTransparency = 1; label.Text = ""; label.TextColor3 = Color3.fromRGB(255, 0, 0); label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); label.TextStrokeTransparency = 0.25; label.Font = Enum.Font.GothamBold; label.TextSize = 14; label.Parent = bb end) end if LP.Character then applyCrystalDiscord(LP.Character) end LP.CharacterAdded:Connect(applyCrystalDiscord) LP.CharacterAdded:Connect(function(char) F.destroyProxy() task.wait(0.5); F.setupSpeedIndicator(char) if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(char) end if S.batCounterEnabled then S.startBatCounter() end if S.unwalkEnabled then task.wait(0.5);F.startUnwalk() end if S.antiRagdollEnabled then
task.wait(0.3); F.startAntiRagdoll() end if infJumpEnabled then task.wait(0.2); F.startInfJump() end if aimbotEnabled then task.wait(0.3); startAimbot() end if tpBatEnabled then task.wait(0.3); startTPBat() end pcall(function() if K7.headlessEnabled then task.wait(0.2); K7.applyHeadless(char, true) end if K7.korbloxEnabled then task.wait(0.2); K7.applyKorblox(char, true) end if S.medusaResetEnabled or S.medusaCounterEnabled then task.wait(0.2); F.setupMedusa(char) end if K7.bodyLockEnabled then task.wait(0.2); K7.startBodyLock() end
if K7.animPackEnabled then task.wait(0.3); K7.applyAnimPack(K7.animPackName) end if K7.lineESPEnabled or K7.speedESPEnabled then task.wait(0.5); K7.refreshESP() end end) end) if LP.Character then F.setupSpeedIndicator(LP.Character) end _G.AceNoPlayerCollisionState = _G.AceNoPlayerCollisionState or {connections = {}, running = false} function F.setOtherPlayerCollision(state) for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then for _, part in ipairs(plr.Character:GetDescendants()) do if part:IsA("BasePart") then pcall(function() part.CanCollide = state end) end end
end end end function F.enableNoPlayerCollision() local st = _G.AceNoPlayerCollisionState if st.running then return end S.noPlayerCollisionEnabled = true; st.running = true for _, conn in ipairs(st.connections or {}) do pcall(function() conn:Disconnect() end) end st.connections = {}; F.setOtherPlayerCollision(false) table.insert(st.connections, LP.CharacterAdded:Connect(function() task.wait(0.5) if S.noPlayerCollisionEnabled then F.setOtherPlayerCollision(false) end end)) table.insert(st.connections, Players.PlayerAdded:Connect(function(plr) local c = plr.CharacterAdded:Connect(function()
task.wait(0.5) if S.noPlayerCollisionEnabled then F.setOtherPlayerCollision(false) end end) table.insert(st.connections, c) end)) local collisionScanElapsed = 0 table.insert(st.connections, RunService.Heartbeat:Connect(function(dt) if not S.noPlayerCollisionEnabled then return end collisionScanElapsed = collisionScanElapsed + (dt or 0) if collisionScanElapsed < 0.25 then return end collisionScanElapsed = 0 for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide == true then pcall(function() part.CanCollide = false end) end end end end end)) end function F.disableNoPlayerCollision() local st = _G.AceNoPlayerCollisionState; S.noPlayerCollisionEnabled = false if not st.running then return end st.running = false for _, conn in ipairs(st.connections or {}) do pcall(function() conn:Disconnect() end) end st.connections = {}; F.setOtherPlayerCollision(true) end function F.safeModeGetCountdownLabel() local ok, label = pcall(function() local pg = LP:FindFirstChild("PlayerGui") if not pg then return nil end
local a = pg:FindFirstChild("DuelsMachineTopFrame"); local b = a and a:FindFirstChild("DuelsMachineTopFrame"); local t = b and b:FindFirstChild("Timer") return t and t:FindFirstChild("Label") end) return (ok and label) or nil end function F.safeModeCountdownNumber(text) local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "") if t == "GO" or t == "START" or t == "READY" then return true end local n = tonumber(t) return n ~= nil and n >= 0 and n <= 10 end function F.safeModeInDuelCountdown() local label = F.safeModeGetCountdownLabel()
return label and F.safeModeCountdownNumber(label.Text) or false end function F.safeModeHoldingBrainrot() local ok, val = pcall(function() return LP:GetAttribute("Stealing") end) if ok and val == true then return true end local char = LP.Character if not char then return false end local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end) if ok3 and val3 == true then return true end if F.isCarryingBrainrot and F.isCarryingBrainrot(char) then return true end return false end function F.safeModeIsLocked() if not S.safeModeEnabled then return false end
return F.safeModeInDuelCountdown() or F.safeModeHoldingBrainrot() end function F.safeModeForceStop(reason) local stopped = false if tpBatEnabled and stopTPBat then pcall(function() stopTPBat() end) if VS.setTPBatVisual then pcall(VS.setTPBatVisual, false) end stopped = true end if aimbotEnabled and stopAimbot then pcall(function() stopAimbot() end) stopped = true end if S.autoBatEnabled then S.autoBatEnabled = false if S.disableAutoBat then pcall(S.disableAutoBat) end if S.autoBatSetVisual then pcall(S.autoBatSetVisual, false) end stopped = true end if S.autoLeftEnabled then
S.autoLeftEnabled = false if F.stopAutoLeft then F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end stopped = true end if S.autoRightEnabled then S.autoRightEnabled = false if F.stopAutoRight then F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(false) end stopped = true end if stopped then print("[snow.vs] Safe Mode:", reason or "SAFE MODE LOCK") end end function F.safeModeTryStart() if F.safeModeIsLocked() then F.safeModeForceStop("SAFE MODE LOCK") return false end return true end if not _G.__VersincSafeModeMonitor then
_G.__VersincSafeModeMonitor = true RunService.Heartbeat:Connect(function() if S.safeModeEnabled and F.safeModeIsLocked() then F.safeModeForceStop("SAFE MODE LOCK") end end) end function F.setupDeathReset() end _G.AceAutoResetOnMed = _G.AceAutoResetOnMed or { conns = {}, enabled = false, medTriggered = false, lastFire = 0, cooldown = 2.25 } function F.autoResetShouldFire(part) local state = _G.AceAutoResetOnMed if not state or not state.enabled then return false end if state.medTriggered then return false end if tick() - (state.lastFire or 0) < (state.cooldown or 2.25) then return false end
if not part or not part.Parent then return false end if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then return false end return part.Anchored == true and part.Transparency == 1 end function F.autoResetFireOnce(part) if not F.autoResetShouldFire(part) then return end local state = _G.AceAutoResetOnMed; state.medTriggered = true; state.lastFire = tick() task.delay(2.3, function() if state.enabled and cursedInstaReset then pcall(cursedInstaReset) end end) end function F.stopAutoResetOnMed() local state = _G.AceAutoResetOnMed if not state then return end
for _, conn in ipairs(state.conns or {}) do pcall(function() conn:Disconnect() end) end state.conns = {}; state.medTriggered = false end function F.startAutoResetOnMed(char) local state = _G.AceAutoResetOnMed if not state then return end F.stopAutoResetOnMed(); state.medTriggered = false char = char or LP.Character if not char then return end for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(state.conns, part:GetPropertyChangedSignal("Anchored"):Connect(function() F.autoResetFireOnce(part) end)) F.autoResetFireOnce(part) end end
table.insert(state.conns, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(state.conns, part:GetPropertyChangedSignal("Anchored"):Connect(function() F.autoResetFireOnce(part) end)) F.autoResetFireOnce(part) end end)) table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent) if not parent then state.medTriggered = false end end)) end function F.setAutoResetOnMed(on) S.autoResetOnMedEnabled = on and true or false; _G.AceAutoResetOnMed.enabled = S.autoResetOnMedEnabled if S.autoResetOnMedEnabled then F.startAutoResetOnMed(LP.Character) else
F.stopAutoResetOnMed() end end if not _G.__VersincMedFlingCharConn then _G.__VersincMedFlingCharConn = true LP.CharacterAdded:Connect(function(char) if S.autoResetOnMedEnabled then task.wait(0.25); F.startAutoResetOnMed(char) end end) end S._tracerFolder = nil; S._tracerConn = nil function F.clearTracers() if S._tracerFolder then pcall(function() S._tracerFolder:Destroy() end) end S._tracerFolder = nil end function F.refreshTracers() if not S.showTracerEnabled then F.clearTracers(); return end local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not myRoot then return end local folder = S._tracerFolder if not folder or not folder.Parent then folder = Instance.new("Folder"); folder.Name = "VersincTracers"; folder.Parent = workspace; S._tracerFolder = folder end local att0 = myRoot:FindFirstChild("VersincTracerAtt") if not att0 or att0.Parent ~= myRoot then if att0 then pcall(function() att0:Destroy() end) end att0 = Instance.new("Attachment"); att0.Name = "VersincTracerAtt"; att0.Parent = myRoot end local alive = {} for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then
local root = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if root and hum and hum.Health > 0 then alive[plr.Name] = true; local beam = folder:FindFirstChild("TR_" .. plr.Name); local att1 = root:FindFirstChild("VersincTracerAtt") if not att1 or att1.Parent ~= root then if att1 then pcall(function() att1:Destroy() end) end att1 = Instance.new("Attachment"); att1.Name = "VersincTracerAtt"; att1.Parent = root end if not beam then
beam = Instance.new("Beam"); beam.Name = "TR_" .. plr.Name; beam.Width0 = 0.12; beam.Width1 = 0.08; beam.FaceCamera = true; beam.LightEmission = 0.65; beam.LightInfluence = 0; beam.Segments = 1; beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)); beam.Transparency = NumberSequence.new(0.12); beam.Parent = folder end beam.Attachment0 = att0; beam.Attachment1 = att1 end end end for _, ch in ipairs(folder:GetChildren()) do if ch:IsA("Beam") then local name = ch.Name:match("^TR_(.+)$") if name and not alive[name] then
pcall(function() ch:Destroy() end) end end end end function F.setShowTracer(on) S.showTracerEnabled = on and true or false if S._tracerConn then pcall(function() S._tracerConn:Disconnect() end); S._tracerConn = nil end if S.showTracerEnabled then F.refreshTracers(); local acc = 0 S._tracerConn = RunService.Heartbeat:Connect(function(dt) acc = acc + (dt or 0) if acc < 0.2 then return end acc = 0; F.refreshTracers() if S._tracerFolder then for _, ch in ipairs(S._tracerFolder:GetDescendants()) do if ch:IsA("Beam") then ch.Enabled = true end end end end) else F.clearTracers() end end
S._ragdollCdConn = nil; S._ragdollCdCharConn = nil; S._ragdollCdEnd = 0; S._ragdollCdLabel = nil; local RAGDOLL_CD_SECONDS = 2.6 function F.stopRagdollCountdown() if S._ragdollCdConn then S._ragdollCdConn:Disconnect(); S._ragdollCdConn = nil end if S._ragdollCdCharConn then S._ragdollCdCharConn:Disconnect(); S._ragdollCdCharConn = nil end if S._ragdollCdLabel then S._ragdollCdLabel.Visible = false; S._ragdollCdLabel.Text = "" end if S._ragdollCdBillboard then pcall(function() S._ragdollCdBillboard:Destroy() end) S._ragdollCdBillboard = nil; S._ragdollCdLabel = nil end end
function F.ensureRagdollCdLabel(char) char = char or LP.Character; local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")) if not head then return nil end pcall(function() local pg = LP:FindFirstChild("PlayerGui") local old = pg and pg:FindFirstChild("VersincRagdollCD") if old then old:Destroy() end end) if S._ragdollCdBillboard then pcall(function() S._ragdollCdBillboard:Destroy() end) S._ragdollCdBillboard = nil; S._ragdollCdLabel = nil end
local bb = Instance.new("BillboardGui"); bb.Name = "VersincRagdollCD"; bb.Adornee = head; bb.Size = UDim2.new(0, 90, 0, 40); bb.StudsOffset = Vector3.new(0, 5.8, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 200; bb.Enabled = false; bb.Parent = head; S._ragdollCdBillboard = bb; local bg = Instance.new("Frame"); bg.Name = "BG"; bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.fromRGB(12, 12, 14); bg.BackgroundTransparency = 0.15; bg.BorderSizePixel = 0; bg.Visible = false; bg.Parent = bb; local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = bg; local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(180, 180, 185); st.Thickness = 1; st.Transparency = 0.4; st.Parent = bg; local lbl = Instance.new("TextLabel"); lbl.Name = "CD"; lbl.Size = UDim2.new(1, -6, 1, -4); lbl.Position = UDim2.new(0, 3, 0, 2); lbl.BackgroundTransparency = 1; lbl.Text = ""; lbl.TextColor3 = Color3.fromRGB(245, 245, 247); lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 18; lbl.TextStrokeTransparency = 0.35; lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); lbl.Visible = false; lbl.Parent = bg; S._ragdollCdLabel = lbl
return lbl end function F.hookRagdollCountdown(char) F.stopRagdollCountdown() if not S.ragdollCountdownEnabled then return end char = char or LP.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4) if not hum then return end F.ensureRagdollCdLabel(char); S._ragdollCdEnd = 0 local function showCd(on) local bb = S._ragdollCdBillboard; local lbl = S._ragdollCdLabel if bb then bb.Enabled = on and true or false end if lbl then lbl.Visible = on and true or false if lbl.Parent then lbl.Parent.Visible = on and true or false end
if not on then lbl.Text = "" end end end local function beginCountdown() S._ragdollCdEnd = tick() + RAGDOLL_CD_SECONDS; showCd(true) end local function isRag() local st = hum:GetState() return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown end S._ragdollCdCharConn = hum.StateChanged:Connect(function(_, newState) if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown then beginCountdown() end end)
S._ragdollCdConn = RunService.RenderStepped:Connect(function() if not S.ragdollCountdownEnabled then F.stopRagdollCountdown(); return end local lbl = S._ragdollCdLabel if not lbl or not lbl.Parent then F.ensureRagdollCdLabel(LP.Character); lbl = S._ragdollCdLabel if not lbl then return end showCd(false) end if isRag() and S._ragdollCdEnd <= tick() then beginCountdown() end local left = math.max(0, S._ragdollCdEnd - tick()) if left > 0 then showCd(true); lbl.Text = string.format("%.1fs", left) if left <= 0.8 then lbl.TextColor3 = Color3.fromRGB(255, 255, 255) elseif left <= 1.5 then
lbl.TextColor3 = Color3.fromRGB(210, 210, 215) else lbl.TextColor3 = Color3.fromRGB(180, 180, 185) end else showCd(false) end end) showCd(false) end function F.setRagdollCountdown(on) S.ragdollCountdownEnabled = on and true or false if S.ragdollCountdownEnabled then F.hookRagdollCountdown(LP.Character) else F.stopRagdollCountdown() end end if not _G.__VersincRagdollCdChar then _G.__VersincRagdollCdChar = true LP.CharacterAdded:Connect(function(char) if S.ragdollCountdownEnabled then task.wait(0.3); F.hookRagdollCountdown(char) end end) end
_G.VersincMobileButtonRefs = _G.VersincMobileButtonRefs or {}; _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} function F.saveMobileButtonPositions() _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} for k, entry in pairs(_G.VersincMobileButtonRefs or {}) do local h = entry and entry.holder if h and h.Parent then local p = h.Position _G.VersincMobileButtonPositions[k] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset, } end end pcall(function() if F.saveConfig then F.saveConfig(true) end end) end
function F.applyMobileButtonsHidden() local function setEn(g) if g then g.Enabled = not (S.hideMobileButtons == true) end end pcall(function() if gethui then setEn(gethui():FindFirstChild("VersincMobileButtons")) end end) pcall(function() setEn(game:GetService("CoreGui"):FindFirstChild("VersincMobileButtons")) end) local pg = LP:FindFirstChild("PlayerGui") if pg then setEn(pg:FindFirstChild("VersincMobileButtons")) end end function F.applyMobileButtonSize() S.mobileButtonScale = math.clamp(tonumber(S.mobileButtonScale) or 0.80, 0.30, 1.90) for _, entry in pairs(_G.VersincMobileButtonRefs) do
local holder = entry and entry.holder if holder then local sc = holder:FindFirstChild("MobileButtonScale") or Instance.new("UIScale"); sc.Name = "MobileButtonScale"; sc.Scale = S.mobileButtonScale; sc.Parent = holder end end end function F.resetMobileButtons() S.mobileButtonScale = 0.80; S.miniUiScale = 1.00; if _G.__VersincMiniScaleObj then _G.__VersincMiniScaleObj.Scale = 1.00 end if UI.miniSizeLbl then UI.miniSizeLbl.Text = "1.00" end; S.hideMobileButtons = false; _G.VersincMobileButtonPositions = {}; F.buildMobileButtons(); F.applyMobileButtonSize(); F.applyMobileButtonsHidden() pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.buildMobileButtons() if _G.__VersincBuildingMobile then return end
_G.__VersincBuildingMobile = true if type(_G.__VersincMobileInputConns) == "table" then for _, c in ipairs(_G.__VersincMobileInputConns) do pcall(function() c:Disconnect() end) end end _G.__VersincMobileInputConns = {}; local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 8) if not pg then _G.__VersincBuildingMobile = false; return end pcall(function() local function wipe(parent) if not parent then return end for _, ch in ipairs(parent:GetChildren()) do if ch.Name == "VersincMobileButtons" then pcall(function() ch:Destroy() end) end end end wipe(pg)
pcall(function() wipe(game:GetService("CoreGui")) end) pcall(function() if type(gethui) == "function" then wipe(gethui()) end end) end) _G.VersincMobileButtonRefs = {} _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {}; local isMobile = false pcall(function() if UIS.TouchEnabled then isMobile = true end end) local cam = workspace.CurrentCamera local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) if vp.X < 900 or vp.Y < 600 then isMobile = true end pcall(function() if UIS.MouseEnabled and UIS.KeyboardEnabled and not UIS.TouchEnabled then isMobile = false end end)
S._isMobileLayout = isMobile local mobileGui = Instance.new("ScreenGui"); mobileGui.Name = "VersincMobileButtons"; mobileGui.ResetOnSpawn = false; mobileGui.IgnoreGuiInset = true; mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; mobileGui.DisplayOrder = 9999; mobileGui.Enabled = true; local parented = false pcall(function() if gethui then mobileGui.Parent = gethui(); parented = mobileGui.Parent ~= nil end end) if not parented then pcall(function() mobileGui.Parent = game:GetService("CoreGui"); parented = mobileGui.Parent ~= nil end) end if not parented then mobileGui.Parent = pg end
if S.hideMobileButtons ~= true then mobileGui.Enabled = true else mobileGui.Enabled = false end local mobileButtons = _G.VersincMobileButtonRefs local function udimFromSaved(key, default) local store = _G.VersincMobileButtonPositions or {}; local s = store[key] if type(s) ~= "table" then return default end local xs = tonumber(s.xs); local ys = tonumber(s.ys) if xs == nil or ys == nil then return default end local xo = tonumber(s.xo) or 0; local yo = tonumber(s.yo) or 0 return UDim2.new(xs, xo, ys, yo) end local function savePos(key, holder) if not holder then return end
local p = holder.Position; _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} _G.VersincMobileButtonPositions[key] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset, } for k, entry in pairs(_G.VersincMobileButtonRefs or {}) do local h = entry and entry.holder if h and h.Parent then local hp = h.Position _G.VersincMobileButtonPositions[k] = { xs = hp.X.Scale, xo = hp.X.Offset, ys = hp.Y.Scale, yo = hp.Y.Offset, } end end end local function persistMobilePositions() pcall(function() if F.saveConfig then F.saveConfig(true) end end) end
local function getTheme() return Color3.fromRGB(255, 0, 0) end local FP_INACTIVE_BG   = Color3.fromRGB(45, 0, 0); local FP_INACTIVE_TEXT = Color3.fromRGB(255, 255, 255); local FP_STROKE = Color3.fromRGB(255, 0, 0); local FP_ACTIVE_BG = Color3.fromRGB(255, 25, 25); local FP_ACTIVE_TEXT = Color3.fromRGB(0, 0, 0) local function setActive(btn, state) if not btn or not btn.Parent then return end local pressed = btn:GetAttribute("Pressed") == true; state = (state == true) or pressed; local visual = state and "on" or "off"
if btn:GetAttribute("VisualState") == visual and not pressed then return end btn:SetAttribute("VisualState", visual); local lbl = btn:FindFirstChild("MBLabel"); local st = btn:FindFirstChildOfClass("UIStroke"); local theme = getTheme() if state then btn.BackgroundColor3 = FP_ACTIVE_BG; btn.BackgroundTransparency = 0; btn.TextColor3 = FP_ACTIVE_TEXT if lbl then lbl.TextColor3 = FP_ACTIVE_TEXT end if st then st.Color = theme; st.Transparency = 0 end else btn.BackgroundColor3 = FP_INACTIVE_BG; btn.BackgroundTransparency = 0; btn.TextColor3 = FP_INACTIVE_TEXT
if lbl then lbl.TextColor3 = FP_INACTIVE_TEXT end if st then st.Color = theme; st.Transparency = 0.4 end end end _G._VersincApplyMobileTheme = function(col) col = Color3.fromRGB(255, 0, 0); S.themeColor = col for _, entry in pairs(mobileButtons) do local btn = entry and entry.btn if btn and btn.Parent then local st = btn:GetAttribute("VisualState"); btn:SetAttribute("VisualState", nil); setActive(btn, st == "on") end end end local function refreshAllMobileStates() for key, entry in pairs(mobileButtons) do local btn = entry and entry.btn if btn then local keep = false if key == "autoLeft" then keep = S.autoLeftEnabled == true
elseif key == "autoRight" then keep = S.autoRightEnabled == true elseif key == "aimbot" then keep = (tpBatEnabled == true) or (aimbotEnabled == true) elseif key == "autoBat" then keep = S.autoBatEnabled == true elseif key == "batV2" then keep = S.batV2Enabled == true elseif key == "carry" then keep = S.speedMode == true and not S.laggerToggled elseif key == "lagger" then keep = S.laggerToggled == true and S.laggerPhase == 1 elseif key == "laggerCarry" then keep = S.laggerToggled == true and S.laggerPhase == 2 elseif key == "antitp" then keep = (_G.__AntiTPBatEnabled == true) end setActive(btn, keep) end end end
_G._VersincRefreshMobileButtons = refreshAllMobileStates local function pulse(btn) if not btn then return end btn:SetAttribute("Pressed", true); setActive(btn, true) task.delay(0.15, function() if btn and btn.Parent then btn:SetAttribute("Pressed", false); refreshAllMobileStates() end end) end local btnW, btnH = 60, 60 local function makeButton(key, label, pos, onPress)
local holder = Instance.new("Frame"); holder.Name = "MBH_" .. key; holder.Size = UDim2.new(0, btnW, 0, btnH); holder.Position = udimFromSaved(key, pos); holder.BackgroundTransparency = 1; holder.ZIndex = 1000; holder.Active = true; holder.Parent = mobileGui; local btn = Instance.new("TextButton"); btn.Name = "MB_" .. key; btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = FP_INACTIVE_BG; btn.BackgroundTransparency = 0; btn.BorderSizePixel = 0; btn.Text = ""; btn.TextColor3 = FP_INACTIVE_TEXT; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.TextWrapped = true; btn.AutoButtonColor = false; btn.ZIndex = 1002; btn.Active = true; btn.Selectable = true; btn:SetAttribute("ThemeMobile", true); btn.Parent = holder; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18); local stroke = Instance.new("UIStroke", btn); stroke.Color = FP_STROKE; stroke.Thickness = 1.2; stroke.Transparency = 0.4; local blabel = Instance.new("TextLabel", btn); blabel.Name = "MBLabel"; blabel.Size = UDim2.new(1, 0, 1, 0); blabel.BackgroundTransparency = 1; blabel.Text = label; blabel.TextColor3 = FP_INACTIVE_TEXT; blabel.Font = Enum.Font.GothamBold; blabel.TextSize = 10; blabel.TextWrapped = true; blabel.ZIndex = 1003; local pressing, dragging = false, false; local pressPos, holderStart = nil, nil; local fired = false
local function fireAction() if fired then return end fired = true pcall(function() if onPress then onPress(btn) end end) task.defer(refreshAllMobileStates) task.delay(0.25, function() fired = false end) end local function beginPress(input) pressing = true; dragging = false; fired = false; pressPos = input.Position; holderStart = holder.Position; btn:SetAttribute("Pressed", true); setActive(btn, true) end local function endPress() if not pressing then return end if pressing and not dragging then fireAction() end if dragging then savePos(key, holder); persistMobilePositions() end
pressing = false; dragging = false; btn:SetAttribute("Pressed", false); task.delay(0.05, refreshAllMobileStates) end btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then beginPress(input) end end) local function track(conn) if conn then _G.__VersincMobileInputConns = _G.__VersincMobileInputConns or {}; table.insert(_G.__VersincMobileInputConns, conn) end return conn end track(UIS.InputEnded:Connect(function(input) if not pressing then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then endPress() end end)) local groupStart = nil track(UIS.InputChanged:Connect(function(input) if not pressing then groupStart = nil; return end if S.moveButtons ~= true and S.allLockButtons ~= true then return end if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end if not pressPos then return end local delta = input.Position - pressPos; local thresh = isMobile and 18 or 8
if not dragging and (math.abs(delta.X) > thresh or math.abs(delta.Y) > thresh) then dragging = true if S.allLockButtons == true then groupStart = {} for k, entry in pairs(_G.VersincMobileButtonRefs or {}) do local h = entry and entry.holder if h and h.Parent then groupStart[k] = h.Position end end end end if dragging then if S.allLockButtons == true and groupStart then for k, startPos in pairs(groupStart) do local entry = (_G.VersincMobileButtonRefs or {})[k] local h = entry and entry.holder if h and h.Parent then h.Position = UDim2.new( startPos.X.Scale, startPos.X.Offset + delta.X,
startPos.Y.Scale, startPos.Y.Offset + delta.Y ) end end elseif holderStart then holder.Position = UDim2.new( holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y ) end end end)) btn.Activated:Connect(function() if dragging then return end if pressing then endPress() else fireAction() end end) mobileButtons[key] = {holder = holder, btn = btn, setActive = function(state) setActive(btn, state) end} setActive(btn, false) return btn end local defaults do
local GAP_X, GAP_Y = 8, 14; local MARGIN_R = isMobile and 12 or 18; local totalW = btnW * 3 + GAP_X * 2 local col = { -(totalW + MARGIN_R), -(totalW + MARGIN_R) + (btnW + GAP_X), -(totalW + MARGIN_R) + 2 * (btnW + GAP_X), } local ROWS = 4 local function slot(c, r) return UDim2.new(1, col[c], 0.5, -((ROWS * (btnH + GAP_Y)) / 2) + (r - 1) * (btnH + GAP_Y)) end defaults = { antitp      = slot(1, 1), drop        = slot(2, 1), autoLeft    = slot(3, 1), aimbot      = slot(1, 2), autoBat     = slot(2, 2), batV2       = slot(3, 2), autoRight   = slot(1, 3), tp          = slot(2, 3), carry       = slot(3, 3),
laggerCarry = slot(2, 4), lagger      = slot(3, 4), } end makeButton("antitp", "ANTI\nTP BAT", defaults.antitp, function() if AntiTPBat and AntiTPBat.toggle then AntiTPBat.toggle() end end) makeButton("drop", "DROP\nBR", defaults.drop, function(btn) if F.runDrop then F.runDrop() end pulse(btn) end) makeButton("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function() if S.autoLeftEnabled then S.autoLeftEnabled = false if F.stopAutoLeft then F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end else if F.queueAutoLeftStart then F.queueAutoLeftStart() end
if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end end end) makeButton("autoBat", "BAT\nAIMBOT", defaults.autoBat, function() if S.autoBatEnabled then S.autoBatEnabled = false if S.disableAutoBat then S.disableAutoBat() end if S.autoBatSetVisual then S.autoBatSetVisual(false) end else if F.queueAutoBatStart then F.queueAutoBatStart() end if S.autoBatSetVisual then S.autoBatSetVisual(S.autoBatEnabled) end end end) makeButton("batV2", "BAT V2", defaults.batV2, function() if S.batV2Enabled then S.batV2Enabled = false if S.disableAutoBat then S.disableAutoBat() end if S.batV2SetVisual then S.batV2SetVisual(false) end else S.batV2Enabled = true if F.queueAutoBatStart then F.queueAutoBatStart() end if S.batV2SetVisual then S.batV2SetVisual(true) end end end) makeButton("aimbot", "TP\nBAT", defaults.aimbot, function() if F.safeModeTryStart and not F.safeModeTryStart() then return end
if setTPBatState then setTPBatState(not tpBatEnabled) end if VS.setTPBatVisual then VS.setTPBatVisual(tpBatEnabled) end end) makeButton("autoRight", "AUTO\nRIGHT", defaults.autoRight, function() if S.autoRightEnabled then S.autoRightEnabled = false if F.stopAutoRight then F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(false) end else if F.queueAutoRightStart then F.queueAutoRightStart() end if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end end end) makeButton("tp", "TP\nDOWN", defaults.tp, function(btn) if F.runTPFloor then F.runTPFloor() end
pulse(btn) end) makeButton("carry", "CARRY\nSPD", defaults.carry, function() if F.toggleCarryMode then F.toggleCarryMode() end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) makeButton("lagger", "LAGGER\nMODE", defaults.lagger, function() if S.laggerToggled and S.laggerPhase == 1 then S.laggerToggled = false; S.laggerPhase = 0 else S.speedMode = false; S.laggerToggled = true; S.laggerPhase = 1 end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) makeButton("laggerCarry", "LAGGER\nCARRY", defaults.laggerCarry, function()
if S.laggerToggled and S.laggerPhase == 2 then S.laggerToggled = false; S.laggerPhase = 0 else S.speedMode = false; S.laggerToggled = true; S.laggerPhase = 2 end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) if isMobile and (not S.mobileButtonScale or S.mobileButtonScale == 0.80) then S.mobileButtonScale = 1.05 end F.applyMobileButtonSize(); F.applyMobileButtonsHidden() task.defer(function() refreshAllMobileStates() if S.themeColor and _G._VersincApplyMobileTheme then pcall(function() _G._VersincApplyMobileTheme(S.themeColor) end) end end)
-- [FIX] Sync visual state dos botoes (Auto Left / Auto Right e afins) quando a funcao para sozinha
local function _fpStateSig() return tostring(S.autoLeftEnabled == true) .. tostring(S.autoRightEnabled == true) .. tostring(S.autoBatEnabled == true) .. tostring(S.batV2Enabled == true) .. tostring(tpBatEnabled == true) .. tostring(_G.__AntiTPBatEnabled == true) .. tostring(S.speedMode == true) .. tostring(S.laggerToggled == true) .. tostring(S.laggerPhase) end
if _G.__VersincVisualSyncLoop then _G.__VersincVisualSyncLoop = false end
_G.__VersincVisualSyncLoop = true
_G.__VersincRefreshMobileStates = refreshAllMobileStates
task.spawn(function()
  local last = nil
  while _G.__VersincVisualSyncLoop do
    local ok, sig = pcall(_fpStateSig)
    if ok and sig ~= last then
      last = sig
      pcall(refreshAllMobileStates)
      pcall(function()
        if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled == true) end
        if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled == true) end
        if S.autoBatSetVisual then S.autoBatSetVisual(S.autoBatEnabled == true) end if S.batV2SetVisual then S.batV2SetVisual(S.batV2Enabled == true) end
      end)
    end
    task.wait(0.1)
  end
end)
_G.__VersincBuildingMobile = false end function F.saveConfig(force) if not _writefile then S._lastSaveOk = false if UI and UI.saveStatusLbl then UI.saveStatusLbl.Text = "Save: no writefile"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(255, 120, 120) end return false end local ok, err = pcall(function() local function ks(e) if type(e) ~= "table" then return {kb=nil,gp=nil} end return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil} end local function numFromBox(box, fallback) if box and box.Text then local n = tonumber(box.Text) if n then return n end end return fallback end
if UI then local v v = numFromBox(UI.radInput, nil) if v and v > 0 then autoStealRadius = v; Steal.StealRadius = v end v = numFromBox(UI.stealDurInput, nil) if v and v >= 0.1 then Steal.StealDuration = v end v = numFromBox(UI.stopTimeInput, nil) if v and v > 0 then autoGrabStopTime = v; Steal.AutoGrabStopTime = v end v = numFromBox(UI.stopTimePercentInput, nil) if v and v >= 1 and v <= 100 then autoGrabStopPercent = v; Steal.AutoGrabStopPercent = v end v = numFromBox(UI.delayRadInput, nil) if v and v > 0 then autoGrabDelayRadius = v; Steal.AutoGrabDelayRadius = v end v = numFromBox(UI.normalBox, nil) if v and v > 0 then NS = v end v = numFromBox(UI.carryBox, nil) if v and v > 0 then CS = v end v = numFromBox(UI.laggerBox, nil)
if v and v > 0 then S.LAGGER_SPEED = v end v = numFromBox(UI.laggerCarryBox, nil) if v and v > 0 then S.LAGGER_CARRY_SPEED = v end v = numFromBox(UI.autoTPHeightBox, nil) if v then S.autoTPHeight = v end end
local stealRad = tonumber(autoStealRadius) or (Steal and Steal.StealRadius) or 20; local stealDur = (Steal and tonumber(Steal.StealDuration)) or 1.3; local stopT = tonumber(autoGrabStopTime) or (Steal and tonumber(Steal.AutoGrabStopTime)) or 1.00; local stopPct = math.clamp(tonumber(autoGrabStopPercent) or (Steal and tonumber(Steal.AutoGrabStopPercent)) or 75, 1, 100); local delayR = tonumber(autoGrabDelayRadius) or (Steal and tonumber(Steal.AutoGrabDelayRadius)) or 8; autoGrabStopTime = stopT; autoGrabStopPercent = stopPct; autoGrabDelayRadius = delayR if Steal then
Steal.StealRadius = stealRad; Steal.StealDuration = stealDur; Steal.AutoGrabStopTime = stopT; Steal.AutoGrabStopPercent = stopPct; Steal.AutoGrabDelayRadius = delayR; Steal.AutoGrabStopEnabled = autoGrabStopEnabled == true end local activeSpeedProfile = S.speedProfiles[S.speedMethod]; if activeSpeedProfile then activeSpeedProfile.normalSpeed = NS; activeSpeedProfile.carrySpeed = CS; activeSpeedProfile.laggerSpeed = S.LAGGER_SPEED; activeSpeedProfile.laggerCarrySpeed = S.LAGGER_CARRY_SPEED end local cfg = { normalSpeed = NS, carrySpeed = CS, speedMethod = S.speedMethod, speedProfiles = S.speedProfiles, dropBrainrotKey = ks(KB.DropBrainrot), autoLeftKey = ks(KB.AutoLeft), autoRightKey = ks(KB.AutoRight), autoBatKey = ks(KB.AutoBat), tpBatKey = ks(KB.TPBat), laggerToggleKey = ks(KB.LaggerToggle), tpFloorKey = ks(KB.TPFloor), instaResetKey = ks(KB.InstaReset), guiHideKey = ks(KB.GuiHide), speedToggleKey = ks(KB.SpeedToggle),
grabRadius = stealRad, stealDuration = stealDur, selectedStealMode = selectedStealMode, aceStealRadii = AceStealRadii and { Normal = AceStealRadii.Normal, Semi = AceStealRadii.Semi } or nil, autoGrabStopEnabled = autoGrabStopEnabled == true, autoGrabStopTime = stopT, autoGrabStopPercent = stopPct, autoGrabDelayRadius = delayR, antiRagdollMode = S.antiRagdollMode or 1, aimbotMode = S.aimbotMode or 1, antiRagdoll = S.antiRagdollEnabled, antiDieEnabled = S.antiDieEnabled, antiDropEnabled = S.antiDropEnabled, antiFlingShieldEnabled = S.antiFlingShieldEnabled, removeAccessories = S.removeAccessoriesEnabled, autoStealEnabled = autoStealEnabled,
medusaCounter = S.medusaCounterEnabled, medusaReset = S.medusaResetEnabled, batCounter = S.batCounterEnabled, infJump = infJumpEnabled, aimbot = aimbotEnabled, tpBat = tpBatEnabled, antiBatBypass = S.antiBatBypassEnabled == true or antiBatBypassLockEnabled == true, aimbotSpeed = AIMBOT_SPEED or 63, autoLeft = S.autoLeftEnabled == true, autoRight = S.autoRightEnabled == true, tpBatMode = tpBatMode, antiTPBatEnabled = AntiTPBat.isOn(), antiTPBatSpam = AntiTPBat.getSpam(), antiTPBatVersion = AntiTPBat.getVersion(), tpBatLegacyKey = (TP_BAT_KEY and TP_BAT_KEY.Name) or "V", carryMode = S.speedMode, laggerMode = S.laggerToggled, laggerCarryMode = S.laggerPhase == 2, autoCarrySpeedEnabled = S.autoCarrySpeedEnabled,
noPlayerCollisionEnabled = S.noPlayerCollisionEnabled, safeModeEnabled = S.safeModeEnabled, autoResetOnMedEnabled = S.autoResetOnMedEnabled, laggerSpeed = S.LAGGER_SPEED, laggerCarrySpeed = S.LAGGER_CARRY_SPEED, autoBat = S.autoBatEnabled, autoSwing = S.autoSwingEnabled, unwalkEnabled = S.unwalkEnabled, antiLag = S.antiLagEnabled, keyboardOverlay = S.keyboardOverlayEnabled == true, stretchRez = S.stretchRezEnabled, autoTPEnabled = S.autoTPEnabled, autoTPHeight = S.autoTPHeight, skyTheme = K7 and K7.currentSkyTheme or nil, fovEnabled = K7 and K7.fovEnabled or false,
fovValue = (K7 and K7.fovValue) or (_G._VezyFOV) or 70, headless = K7 and K7.headlessEnabled or false, korbloxSide = korbloxSide or (K7 and K7.korbloxSide) or 1, korblox = K7 and K7.korbloxEnabled or false, bodyLock = K7 and K7.bodyLockEnabled or false, bodyLockRadius = K7 and K7.bodyLockRadius or 60, lineESP = K7 and K7.lineESPEnabled or false, speedESP = K7 and K7.speedESPEnabled or false, animPackEnabled = K7 and K7.animPackEnabled or false, animPack = K7 and K7.animPackName or nil, animPackIndex = K7 and K7.animPackIndex or 1, accessoryPackEnabled = K7 and K7.accessoryPackEnabled or false, accessoryPack = K7 and K7.accessoryPackName or "Off", accessoryPackIndex = K7 and K7.accessoryPackIndex or 1,
guiScale = (_G._VersincGetGuiScale and _G._VersincGetGuiScale()) or 1, themeName = "GREEN", bgId = (type(S.currentBgId) == "string" and S.currentBgId ~= "" and S.currentBgId) or "rbxassetid://116587787334634", bgIntensity = 1, autoSaveEnabled = S.autoSaveEnabled, showTracerEnabled = S.showTracerEnabled, ragdollCountdownEnabled = S.ragdollCountdownEnabled, guiLocked = S.guiLocked, hubPos = S.hubPos, miniPos = S.miniPos, hideMobileButtons = S.hideMobileButtons, lockMobileButtons = S.lockMobileButtons == true, allLockButtons = S.allLockButtons == true, moveButtons = S.moveButtons == true,
progressBarScale = S.progressBarScale or 100, stealBarPos = S.stealBarPos, keyboardOverlay = S.keyboardOverlayEnabled == true, mobileButtonScale = S.mobileButtonScale, infJumpMode = S.infJumpMode or "hold", mirrorTPDown = S.mirrorTPDownEnabled == true, mobileButtonPositions = _G.VersincMobileButtonPositions, } local encoded = HS:JSONEncode(cfg) _writefile(CONFIG_FILE, encoded) pcall(function() _writefile(CONFIG_FILE_LEGACY, encoded) end) end) S._lastSaveOk = ok and true or false S._lastSaveAt = tick() if UI and UI.saveStatusLbl then if ok then
UI.saveStatusLbl.Text = "Saved OK"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(100, 220, 160) else UI.saveStatusLbl.Text = "Save failed"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(255, 120, 120); warn("[snow.vs] F.saveConfig error:", err) end end return ok end task.spawn(function() while true do task.wait(5) if S.autoSaveEnabled ~= false then pcall(function() F.saveConfig(true) end) end end end) local CONFIG_EXPORT_FILE = "CrystalVSHub_Export.json"
local CONFIG_IMPORT_FILE = "CrystalVSHub_Import.json"; local _setclipboard = setclipboard or toclipboard or (syn and syn.write_clipboard); local _getclipboard = getclipboard or (syn and syn.read_clipboard) function F.saveMobileButtonsOnly() if not _writefile then return false end local ok = pcall(function() local raw = nil if _isfile(CONFIG_FILE) then pcall(function() raw = _readfile(CONFIG_FILE) end) end local cfg = {} if raw and raw ~= "" then pcall(function() cfg = HS:JSONDecode(raw) or {} end) end if type(cfg) ~= "table" then cfg = {} end
cfg.mobileButtonPositions = _G.VersincMobileButtonPositions or cfg.mobileButtonPositions; cfg.mobileButtonScale = S.mobileButtonScale; cfg.miniUiScale = S.miniUiScale; cfg.hideMobileButtons = S.hideMobileButtons == true; cfg.lockMobileButtons = S.lockMobileButtons == true; cfg.allLockButtons = S.allLockButtons == true; cfg.moveButtons = S.moveButtons == true; cfg.progressBarScale = S.progressBarScale or 100; _writefile(CONFIG_FILE, HS:JSONEncode(cfg)) end) return ok == true end function F.exportConfig() local okSnap = pcall(function() if F.saveConfig then F.saveConfig(true) end end) local raw = nil
if _isfile(CONFIG_FILE) then pcall(function() raw = _readfile(CONFIG_FILE) end) end if not raw or raw == "" then return false, "no_config" end pcall(function() _writefile(CONFIG_EXPORT_FILE, raw) end) local copied = false if _setclipboard then copied = pcall(_setclipboard, raw) end return true, copied and "copied_and_exported" or "exported_to_file" end function F.importConfig(pastedText) local raw = tostring(pastedText or ""):match("^%s*(.-)%s*$") or "" if raw == "" and _getclipboard then local clipOk, clip = pcall(_getclipboard)
if clipOk and type(clip) == "string" then raw = clip:match("^%s*(.-)%s*$") or "" end end if raw == "" and _isfile(CONFIG_IMPORT_FILE) then pcall(function() raw = tostring(_readfile(CONFIG_IMPORT_FILE) or ""):match("^%s*(.-)%s*$") or "" end) end if raw == "" then return false, "empty" end local valid, decoded = pcall(function() return HS:JSONDecode(raw) end) if not valid or type(decoded) ~= "table" then return false, "invalid_json" end local encodedOk, normalized = pcall(function() return HS:JSONEncode(decoded) end) if not encodedOk then return false, "encode_failed" end
pcall(function() _writefile(CONFIG_FILE, normalized) end) _savedCfg = decoded pcall(function() if F.loadConfigKeys then F.loadConfigKeys() end if F.loadConfigState then F.loadConfigState() end end) return true, "imported" end function F.resetAllConfig() pcall(function() if S.antiRagdollEnabled then S.antiRagdollEnabled=false; F.stopAntiRagdoll() end end) pcall(function() if S.antiDropEnabled and F.stopAntiDrop then F.stopAntiDrop() end end) pcall(function() if infJumpEnabled then infJumpEnabled=false; F.stopInfJump() end end) pcall(function() if tpBatEnabled and setTPBatState then setTPBatState(false) end end)
pcall(function() if aimbotEnabled and setAimbotState then setAimbotState(false) end end) pcall(function() if S.autoBatEnabled and S.disableAutoBat then S.autoBatEnabled=false; S.disableAutoBat() end end) pcall(function() if S.laggerToggled then S.laggerToggled=false; S.laggerPhase=0 end end) pcall(function() if S.speedMode then S.speedMode=false end end) pcall(function() if S.autoTPEnabled and F.stopAutoTP then F.stopAutoTP() end end) pcall(function() if S.unwalkEnabled and F.stopUnwalk then S.unwalkEnabled=false; F.stopUnwalk() end end)
pcall(function() if S.antiLagEnabled and F.disableAntiLag then F.disableAntiLag() end end) pcall(function() if F.stopKeyboardOverlay then F.stopKeyboardOverlay() end end) pcall(function() if S.stretchRezEnabled and disableStretchRez then disableStretchRez() end end) pcall(function() if S.showTracerEnabled and F.setShowTracer then F.setShowTracer(false) end end) pcall(function() if S.ragdollCountdownEnabled and F.setRagdollCountdown then F.setRagdollCountdown(false) end end) pcall(function() if S.noPlayerCollisionEnabled and F.disableNoPlayerCollision then F.disableNoPlayerCollision() end end)
pcall(function() if autoStealEnabled and stopAutoSteal then stopAutoSteal() end end) pcall(function() if S.batCounterEnabled and S.stopBatCounter then S.batCounterEnabled=false; S.stopBatCounter() end end) pcall(function() if S.medusaCounterEnabled or S.medusaResetEnabled then S.medusaCounterEnabled=false; S.medusaResetEnabled=false end end) pcall(function() if S.autoResetOnMedEnabled and F.setAutoResetOnMed then F.setAutoResetOnMed(false) end end)
NS, CS = 60, 30; S.NS, S.CS = 60, 30; S.LAGGER_SPEED, S.LAGGER_CARRY_SPEED = 15, 24.5; S.autoTPHeight = 20; S.autoCarrySpeedEnabled = false; S.safeModeEnabled = false; S.autoSwingEnabled = true; S.guiLocked = false; S.lockMobileButtons = false; S.moveButtons = false; S.progressBarScale = 100; S.hideMobileButtons = false; S.mobileButtonScale = 0.80; S.autoSaveEnabled = true; S.autoLeftEnabled = false; S.autoRightEnabled = false; S.dropActive = false; S.noPlayerCollisionEnabled = false; S.showTracerEnabled = false; S.ragdollCountdownEnabled = false; S.autoResetOnMedEnabled = false; S.medusaCounterEnabled = false; S.medusaResetEnabled = false; S.batCounterEnabled = false; S.unwalkEnabled = false; S.antiLagEnabled = false; S.stretchRezEnabled = false; S.antiRagdollEnabled = false; S.antiDropEnabled = false; S.autoTPEnabled = false; S.autoBatEnabled = false; S.speedMode = false; S.laggerToggled = false; S.laggerPhase = 0; KB.DropBrainrot = {kb=Enum.KeyCode.H, gp=nil}; KB.AutoLeft = {kb=Enum.KeyCode.Z, gp=nil}; KB.AutoRight = {kb=Enum.KeyCode.C, gp=nil}; KB.AutoBat = {kb=Enum.KeyCode.E, gp=nil}; KB.TPBat = {kb=Enum.KeyCode.V, gp=Enum.KeyCode.ButtonY}; KB.TPFloor = {kb=Enum.KeyCode.F, gp=nil}; KB.InstaReset = {kb=Enum.KeyCode.T, gp=nil}; KB.GuiHide = {kb=Enum.KeyCode.LeftControl, gp=nil}; KB.SpeedToggle = {kb=Enum.KeyCode.Q, gp=nil}; KB.LaggerToggle = {kb=Enum.KeyCode.R, gp=nil}; TP_BAT_KEY = Enum.KeyCode.V; TP_BAT_CONTROLLER = Enum.KeyCode.ButtonY; tpBatMode = 1
pcall(function() selectedStealMode = "Normal" AceStealRadii = AceStealRadii or {Normal=55, Semi=20}; AceStealRadii.Normal = 55; AceStealRadii.Semi = 20; autoStealRadius = 55 if Steal then Steal.StealRadius = 55; Steal.StealDuration = 1.3 end autoGrabStopEnabled = false end) pcall(function() if K7 then K7.lineESPEnabled = false; K7.speedESPEnabled = false; K7.fovEnabled = false; K7.bodyLockEnabled = false; K7.bodyLockRadius = 60; K7.headlessEnabled = false; K7.korbloxEnabled = false; K7.animPackEnabled = false if K7.refreshESP then K7.refreshESP() end end end)
_G.VersincMobileButtonPositions = {} pcall(function() if F.resetMobileButtons then F.resetMobileButtons() end end) pcall(function() if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) pcall(function() if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale(1) end end) pcall(function() local df = delfile or (syn and syn.delfile) if df then if _isfile(CONFIG_FILE) then df(CONFIG_FILE) end if _isfile(CONFIG_FILE_LEGACY) then df(CONFIG_FILE_LEGACY) end elseif _writefile then _writefile(CONFIG_FILE, "{}"); _writefile(CONFIG_FILE_LEGACY, "{}") end end) _savedCfg = nil
pcall(function() if UI.normalBox then UI.normalBox.Text = "60" end if UI.carryBox then UI.carryBox.Text = "30" end if UI.laggerBox then UI.laggerBox.Text = "15" end if UI.laggerCarryBox then UI.laggerCarryBox.Text = "24.5" end if UI.autoTPHeightBox then UI.autoTPHeightBox.Text = "20" end if UI.radInput then UI.radInput.Text = "55" end if UI.stealModeLbl then UI.stealModeLbl.Text = "Normal" end if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = "0.80" end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) local visualOff = {
"setAntiRagVisual","setAntiDropVisual","setInfJumpVisual","setTPBatVisual","setAutoTPVisual","setUnwalkVisual", "setAntiLagVisual","setStretchRezVisual","setShowTracerVisual","setRagdollCdVisual", "setNoPlayerCollisionVisual","setSafeModeVisual","setMedusaVisual","setMedusaResetVisual", "setAutoResetOnMedVisual","setBatCounterVisual", "setAutoSwingVisual","setLockGuiVisual","setHideMobileVisual","setLineESPVisual", "setSpeedESPVisual","setBodyLockVisual","setHeadlessVisual","setKorbloxVisual","setAnimPackVisual", "setFOVVisual", } for _, name in ipairs(visualOff) do
pcall(function() if VS[name] then VS[name](false) end end) end pcall(function() if S.setAutoCarrySpeedVisual then S.setAutoCarrySpeedVisual(false) end end) pcall(function() if S.autoBatSetVisual then S.autoBatSetVisual(false) end end) pcall(function() if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end) pcall(function() if S.autoRightSetVisual then S.autoRightSetVisual(false) end end) pcall(function() if UI.saveStatusLbl then UI.saveStatusLbl.Text = "Config reset" end end) local ok = F.saveConfig(true) if UI and UI.saveStatusLbl then
UI.saveStatusLbl.Text = ok and "Config reset OK" or "Reset done (save fail)"; UI.saveStatusLbl.TextColor3 = ok and Color3.fromRGB(100, 220, 160) or Color3.fromRGB(255, 200, 100) end print("[snow.vs] All configs reset to defaults") return ok end VS = VS or {}; UI = UI or {} function F.refreshSpeedModeLabel() if modeValLbl then modeValLbl.Text=S.laggerToggled and (S.laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (S.speedMode and "Carry" or "Normal") end end function F.getSpeedModeName() if S.laggerToggled then return (S.laggerPhase == 2) and "Lagger Carry" or "Lagger"
elseif S.speedMode then return "Carry" end return "Normal" end function F.setSpeedModeName(mode) if mode == "Lagger Carry" then S.laggerToggled = true; S.speedMode = false; S.laggerPhase = 2 elseif mode == "Lagger" then S.laggerToggled = true; S.speedMode = false; S.laggerPhase = 1 elseif mode == "Carry" then S.laggerToggled = false; S.speedMode = true; S.laggerPhase = 0 else S.laggerToggled = false; S.speedMode = false; S.laggerPhase = 0 end F.refreshSpeedModeLabel() end function F.isCarryName(name) local n = tostring(name or ""):lower()
return n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") end function F.isIgnoredCarryTool(name) local n = tostring(name or ""):lower() return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone") end function F.isCarryingBrainrot(char) if not char then return false end for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do local v = char:FindFirstChild(name, true) if v then if v:IsA("BoolValue") and v.Value then return true end
if v:IsA("ObjectValue") and v.Value then return true end if v:IsA("StringValue") and v.Value ~= "" then return true end end end for _, child in ipairs(char:GetChildren()) do if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end if F.isCarryName(child.Name) then return true end elseif child:IsA("Tool") and not F.isIgnoredCarryTool(child.Name) then return true end end return false end function F.enableCarrySpeedForSteal()
S._autoCarryWaitingPickup = false; S._autoCarryPickupUntil = 0 if not S._autoCarryFromSteal then S._autoCarryReturnMode = F.getSpeedModeName() end S._autoCarryFromSteal = true; S._autoCarryGraceUntil = tick() + 0.75 local wasLagger = (S._autoCarryReturnMode == "Lagger" or S._autoCarryReturnMode == "Lagger Carry" or F.getSpeedModeName() == "Lagger" or F.getSpeedModeName() == "Lagger Carry") if wasLagger then F.setSpeedModeName("Lagger Carry") else F.setSpeedModeName("Carry") end pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.disableAutoCarrySpeed()
if not S._autoCarryFromSteal and not S._autoCarryWaitingPickup then return end local wasAutoApplied = S._autoCarryFromSteal == true; local returnMode = S._autoCarryReturnMode; S._autoCarryFromSteal = false; S._autoCarryWaitingPickup = false; S._autoCarryGraceUntil = 0; S._autoCarryPickupUntil = 0; S._autoCarryReturnMode = nil if not wasAutoApplied then return end if returnMode == "Lagger" or returnMode == "Lagger Carry" then F.setSpeedModeName("Lagger") elseif returnMode == "Carry" then F.setSpeedModeName("Carry") else F.setSpeedModeName("Normal") end
pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.startAutoCarryPickupWatch(seconds) if S.autoCarrySpeedEnabled ~= true then return end S._autoCarryWaitingPickup = true; S._autoCarryPickupUntil = tick() + (seconds or 1.25) end RunService.RenderStepped:Connect(function() if S.autoCarrySpeedEnabled ~= true then if S._autoCarryFromSteal or S._autoCarryWaitingPickup then F.disableAutoCarrySpeed() end return end local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root then F.disableAutoCarrySpeed(); S._stealAttrWasActive = false return end local st = hum:GetState(); local gotHit = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown local stealingAttr = false pcall(function() stealingAttr = (LP:GetAttribute("Stealing") == true) end) local carryingBrainrot = F.isCarryingBrainrot(char) if stealingAttr and not S._stealAttrWasActive then S._stealAttrWasActive = true; F.enableCarrySpeedForSteal() elseif not stealingAttr then S._stealAttrWasActive = false end
if S._autoCarryWaitingPickup then if gotHit or tick() > (S._autoCarryPickupUntil or 0) then S._autoCarryWaitingPickup = false; S._autoCarryPickupUntil = 0 elseif carryingBrainrot then F.enableCarrySpeedForSteal() end end if carryingBrainrot and not S._autoCarryFromSteal then F.enableCarrySpeedForSteal() end if S._autoCarryFromSteal then local graceDone = tick() > (S._autoCarryGraceUntil or 0) if gotHit or (graceDone and not carryingBrainrot and not stealingAttr) then F.disableAutoCarrySpeed() end end end) function F.toggleCarryMode() if S.laggerToggled then
S.laggerToggled=false; S.laggerPhase=0; S.speedMode=true else S.speedMode=not S.speedMode end F.refreshSpeedModeLabel() end function F.toggleLaggerMode() if not S.laggerToggled then S.speedMode=false; S.laggerToggled=true; S.laggerPhase=2 elseif S.laggerPhase==2 then S.laggerPhase=1 else S.laggerPhase=2 end F.refreshSpeedModeLabel() end function F.buildGui() local CRYSTAL_GREEN = Color3.fromRGB(255, 0, 0); local CRYSTAL_GREEN_SOFT = Color3.fromRGB(150, 0, 0); local COLORS = { bg = Color3.fromRGB(35, 0, 0), row = Color3.fromRGB(45, 0, 0), row2 = Color3.fromRGB(60, 0, 0), stroke = CRYSTAL_GREEN_SOFT, strokeSoft = CRYSTAL_GREEN_SOFT, white = Color3.fromRGB(240, 246, 255),
textDim = Color3.fromRGB(240, 246, 255), toggleBg = Color3.fromRGB(45, 0, 0), knob = Color3.fromRGB(255, 255, 255), accent = CRYSTAL_GREEN, accentStrong = Color3.fromRGB(255, 25, 25), on = Color3.fromRGB(255, 25, 25), off = Color3.fromRGB(60, 0, 0), } local THEME_PRESETS = { { name = "RED", color = CRYSTAL_GREEN }, } local BG_EMBED = {
["Neon"] = [[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]],
["Wave"] = [[/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAA8LDA0MCg8NDA0REA8SFyYZFxUVFy8iJBwmODE7OjcxNjU9RVhLPUFUQjU2TWlOVFteY2RjPEpsdGxgc1hhY1//2wBDARARERcUFy0ZGS1fPzY/X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX1//wAARCAGkAaQDASIAAhEBAxEB/8QAHAABA@secret:AWS_ACCESS_KEY_IDAQFAgMGBwEI/8QARxAAAgEDAwIDBQcCAwcEAQIHAQIDAAQRBRIhMUETUWEGFCJxgSMyQpGhscEV0VJi8CQzQ3KC4fEHFlOSYzVEVHODk6Ky4v/EABUBAQEAAAAAAAAAAAAAAAAAAAAB/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A87pSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApWSqWIVeSeAB3q/i9jNflt1mSxOG6KzqrfkTQc9SuhT2K9oWP/AOnkfORR/Nab72V1uwjMk9hIUHJaMhwPnigpKUIxSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUqZpum3ep3S21nCZJG6+SjzJ7CvTdG9htMsole+QXlxj4i/wBwfIf3oPM9P0m/1OUR2NrJMc8lR8I+Z6Cu40n/ANOwAJNXucn/AOKA/ux/gV30UUcMYjijWNF6KowB9KzoKS39k9Bt1AXTYnI7yZc/rUpdB0deml2f/wDZX+1WVKCJFpthAwaGyto2HQpEoI/SpVfaxY4Uk9AM0H3oKjtfWqkhriMEHB571AGo3HimTbvt1cq4WJsgYyMHuc4H1qJGIxtlkG2NBgop2hWJ74oMtS0XQNRgRpreFRL/ALuaEbT88ivMtR9nNSs7i5CWs80EMhTxlQkHHevSpoyAwgbauS6q/O1yMceQ65+dWem3ObcLcSqJSx+Enpk8DPeg8MeKRBlkZQehIIrCvfbyztb+2e2u4VliccqR+3lXBat/6dyLuk0q6DjqIpuD8gw4/Og8/pWc0UkMjxyoUdCVZSOQR1FYUClKUClKUClKUClKUClKUClKUClKUClKUClKUClKUClKUClKUClKUClKUClKUClKUClKUClK6L2Y9l7nXJvEbMNkhw8uOT6L5n9qCjtrae6mENtDJNI3RUUk12WiewF1Oyy6u3u0XXwkILt8+wr0LTtMs9MtxBZQJEgHJA5b1J71MxQQ9O0yz0y38Cxt1hTqcdWPmT3qZX2lApSlArTNcRwAFyeeOBmtpIAJPQVzVwt4C0iP4xYkbdoUjPQ59OP1oOgiuYpSQjcjsRisbufwIt3htISdu0cfv0qgntw2+SWIOXAWNm6BgOVHlk/64rcbpzCiTMypGqr8bBndsdTigyW8aQwLA0kMTQb1TA3Z3EHJ/Ksb0yCTfchgrKGYBfvBDnH5kH6YpGsZj8WJ+ByZFbqB2z5VvgzdxI0+UiPxx7z8Z7gj9+aD61vIpOUf8q1PCWjdfCY5H+Gtn9Qkh3xrKs22TCyEZJXAJGB1Izj61Oif3y0kEu3w3BXKN26H5Ggrpbido0Y5LRopyWKhm7nA/n1qXaXryyJG+34hnPfnpUaKNSUiEiziXcisVI2kDJ3LX2wj8O7l8Q7o4huaQ8fH0/bt24oKr2s9kU1cm8sQsd6PvAnCyj1PY+tcJrPstqejW63FzGjxE4LxNuCHyPlXrSakhlRJE2ByQGLcZ7D61R63q8mlWxa+Rp0mbY6FAyAeXyoPJCCOopV97Q2VjGltf6blbe6Vj4echGB5APXv0PIqhoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFKUoFAMmvqqzMFUEk8ADvXovsl7F+GUv8AWYvjHMdu3b1b+350Fd7K+xj6gEvNTDRWvVI+jSj+B+9emwQRW8KQwRrHGgwqKMACtgGBX2gUpWuaVYYy7sFHTk4yT0FBnVeNS8UP4VtKwyQpYqm7nHGTmtU2qNtWOKPZcM4TbJ0AwSW46jj/AMVCdp47ncxUiQ7iqn4GPcYP3T8jg+VBm1xeSo0KHIXHMmVYjAIBx37H5Ut7lzJKY2dVG0gHqrEcqfPB7+tYarHNb2d0tvmGaTdsk2n75+Xc9q85vJde0t4/eZryDeNyb3PNB6w2pIo2PGd3hq7E8DBz/aqq6ZHQSwSNh3VFJkYJGM4J+EjP1qhg9pppNBt767iMt0kzW/wjb4o25z9DjNWWmznVbR5DbyRs/wBlLEpyOejDy780FhcXbJ/s4ZjAuYXcDADgFshj3BHPaq27u2j0q6vtPMVxKkYdmRg2xsAE48sVE9r9HmurYXGnSiWCAMzRq+cjOS3qfOubsJItHWd5nkZ5oHh8NMYO7/F6Dr86Cw0D2k1CXUYLWUwMs0oDs/wgg9cjoePTNd7HZwyyxvHvNqVymGIHp6/KvJvfLUHiDj1Arv8ASdWT3e209NSgaVI8/YuCevwqCRzgUFqsSPde7IkrOjENI5ztTjHy5yAO+DWmOK7unktWgaCJXLZlwd5HAOAeV7+px5VItmX3iIkKkvikEpx4oK5OR6cZ8uPOrKbAUkAl3GwYOP17UEG2hnt7kLL8MbEjf/jOMDj8PH7VhdwQRSCBjIsbZkJB75HCjHJPn2r5NbzxOghjRfiB3M3BPb1OPLzpftK+n3EM27xUVXR1HJOe2O/b60GpbdZSywLK4yC0Er9vMNzkZAyKyu9NupbW8swIZYbhCVMrH4JDyTjHTJzx0o7Sq8gt4yJWUIjDORk8nyGAM/OvtpdNayywzu2yJGYM3koBOfUZ696DyjVtP1LTmFpfQyKkJIRtvwnJzwe9VVdfa+015q9+bHV7mM6fc7o3GwKEHZh6jiuSkCiRghJXPBIxkUGNKUoA61JkW2FrAYnkaclvFVlwq8/Dg96+SXKvZw24t4VMZYmVV+N89ie+Kj0ClK2m3lFsLkr9kX2BsjrjPTrQaqUpQKUpQKUpQKUpQKUpQKUpQKUpQKUpQKUpQKUpQKUpQKstH0a91m48Gyh3Y+87cKg8yaw0bS59X1GKzth8TnLN2Re5Ne1aVplrpVklpaJtRepPVj5n1oKf2c9kLPRSJ5SLm8/+Rhwn/KP5rpQK+0oFKUoFaLq3S5i2OSpDBlZeqkdDWjVZWitdyzeCoOXfHIUDJx61ydt7X273Qgt5brJYbfHwyv6eYz+9Be3Ns8DZa9kLqMjbACAPI9/yrRJhkzI0rPvDL4QTCcZDqzcfLvnNVmr6pcWV/LDAyeGAJAzjLYYZx9KpNXvZNW0G3uIZcSR3RilUNxyvwkDsMZ/Wg72C5uJLaW38UC6EZMUrrt3E5AJXzB6447iuKXU7iUTab7USJLBvKFyBuhcfiBHrVM8jW0EbSzPI8YwhZidvf4fLmtes3jaq9rLhTdvH9vs6M2SAfmVxmgjHUSqLHAmFXOM9s9cCuk9lr3+nW19e3UweSdAkUAPxZGeSOw561T2tjHAm58M/cntUO7vi7GOM4Qd/Ogu//cbwX8bO2+EkJJHn4dnQgD5VWe0GmDTtYmtIHMkfDxk8nawyBUC1t5LiQFR8IPLHoKt7q5Alee4kaad+rN1P9hQQbTSy8sZuDiPcN4U/Ftzzj1q+sotE0DUGvWvhfbT9hAqHevq2eAappZm25uHMQPSNOv1qNJIYoFmi8FQzEY3guMdyO1B6vompWGqxz3tlD4c/3ZQ/Bzjjny9fSsZby/jjjk+BxvUO3wqoyecZ/vXL+xFvcTRXF81yY0OYWZsBQOCceZ/QetdtOLX+n/EUkh45yCCc+dBAQpvlullkkjG7YzNuwvcj5n9MVItlAuhLLLKB0RG+7np/rNatPvYbjfCkkLBkb7RONuOoIPzzXy08OSJIXlyxQE+IDlvU/P1oLvg1T6xpM+o291FDPHbtMmzxAmWK91PPHzFSbctbTGJzhGXIBOQMeXpj9q+C8dn3oVaLP+Ht8/Og8p1X2U1TT5MLCblP8UIJI+Y6istK9kNY1Mhvd/d4j/xJ/hH0HU163DItwzq0akLjDdQwIzUkADoKDxm+9j9cs2b/AGJp0H44fiBH71QtGyMVdSrDggjBFe53d25t59iSRNGu4NkZx/f0NQpLfTI7j3q50xGmfrPJGMM2PXp0oPGAORmpbx21vqAQyC7tkcbmiyu9e+M9K7S80z2Y1K/eGOZ7W8kbAVH43HoMH+K4ye1msjIs8C8s0QL9VYEZIGeD8/OgwMHvdzMLCCQxjc6pncVQc8n0Fa7aCW7uI7eFQ0jnCjIH6miIPCeTxVUqQNhzls+XpW21sbi6iuJYEDJbJ4khJAwucd+tBFYYYivlZH71ZzGErH4SOpC4fc2ct5jyHSg1UoKUClKUClKUClKUClKUClKUClKUClKUClKUCs4YnmlSKJS7udqqBkkntWAGa9Q9h/Zj3KJNTv4/9qcZiRh/ul8z/mP6CgtvZL2fXQ9P+0AN3N8UreXko9B+9dDXyvtApSlApSlBXa3AJtMuiWICwvwB1+GvG7NYmul8fxdvUeFjJPbk9B617lLGssTxOMo6lWHmDXk99o7aRqc1q67gvxxy/wCND049MGghaxfySyPuJ3yHLck4HYc1OtzLBpkNnN4KLnxmCDJLHpuPmAenbNVGWlmcyOjQpMhMDPtL9uPp1ParOdnWzmSCOULM4QYOQ3kvTk80FPe3HjSnB+EcKKs9HtogjSzeMCACSke7aucEnn5VTwxsbpY3UghsMCMEV1N2nuWnRGfZI0qB4mSYkxoPwFenX9aIqb65UN4GJGBBzs4PpVZaW0l1OsUSlmJxwM1JupkFxBLaePDIYxvdzjLHIJXH4ccVY6XCbdUJMG7fkq7lcgDOc8YH1zmg+XDx2MARCCAB0BHPcc96rVm8Nt7/ABTt59ErXcSNdXYRWABbC7jgD5k0t7ZppiufhU/ERQb7iwufe503LP4RG6WM7kwehz5VZxhLC6mkgaJA3G0YkQDrwWHPzr5NPDZ2arCrIcEPh+JOcjj0qlLyXc6ozqpc4Bdtqj5nsKKvbrWjMgS4unmC/dU9B9OlStO9orazsbm1V5Ha7AXAj+GLsT15OD2rj3BVipwSDjg5qx0iXTraU3OoC4d4iGhiiwA7A5+Jj0FBf6Zey2k+23KyCfCvGBhioONueq5rvIfdpfeLmSTEbS4V84B4HQ9/L6VV6FqB16KG5uokx4rfBjABA7HuOehq+vLdpRGUkWIR5JYrnAx2oI8lv7yRHHLlUXqRnIbPIIPlkVqNuLe5t49q5LH7owCvO7P+vKtljcWsMeQ+95HKkoCQcdwOw5z9a+3SB5y5+1gcYKMx25+Q9POg32rW6DbEzHfyGbv9flW0pKqZWYl1HIKjDH5dqim3t5LQTRQFC6hsIPix5Y71IjeMBicmSQ/EoOTnHT6Cgj28AeeRi7PGDnaccNwcHzwf1rkNc1TVdJ9pTNqDTtpRJ2onKOMcD0Oa664n8NIo7MhEViGUDGMDp6VqklM8KxzIr4+9uUFXHy/Kg8shhudXvb2/tbe58UN4kS26bgrZ4BPbAr7aW8l5qzvrNtfSPMH5RQrs4Gfxcdulew2ttb20ZS1hjhQ8kRqAM/SuUvDq9xc3thf2wurCRWVGQjcpxx1PUHFB5d1PpW+793SdxZSSvBxtMgCseO4HrVhZWd1puv29vd6ck828L7vNwr54HP8ANRtStJINVubd4BblJDujRt4jHXr3ABoI6XG20lt/BjbxGVvEK/EuM8A+Rzz8qWZthKffFlaLa3EZAO7HHXtmsp0tY49kbvJMsjAuBhGXsRnnPXrWVtJYrYXSTwSvdNt8CRWwqc85HfNBqs5IIrmN7mEzwg5eMPtLD59q0tjccDA7UFWV4rWt1HBeWlvuigC7YjgHK5DMR1bkH6YoKylSL2GKC5eOC4S5jGMSopAPHka3Wek319Z3F3awmWK2wZdpGVHnjr2oINKYpQKUpQKUpQKUpQKUpQKUpQKUpQel+x/setuI9S1SPMx+KKBuieRPr6dq7sCmK+0ClYNLGpwzqp8iRRZEb7rqfkaDOlYs6ryzAfM18WRGOFdSfQ0GdKUoFU+u6KNVjRkcRTx5CsRkEHsauK+UHmE3sXqltyYUnIcuZYXySMcLtOO/erF/ZzUdQ0+SWUwae4fxEypU8ADkA4UcZ88131QdSnt40WGWYI78quCSQPQDpQeWW9hH/U4omuhNMwdpZY3Eqk9iOh+eaykuLRJLdNRjdrbcd6xAK5B569+cV3C6Zb2oF7Z2Nq8hYAMBkAnufICuXvtTm1jVBpWr2sBzlRIB4bW5x94EnkDuD1FBzXiNeXkab5Ghj+GISNkpGDkCrK7uTFZyIoX7TAyVBP0PaoelQbZzJNuEGdniIuc4IzjzOP3qVeLajUbeC8mK224GRoiGIU/Lvjt2oirhjRzGVilnkBLPEBgFQM9Rz558qvLG3it9MErhHeYEgLJhosHqw75HSoMcEEl3JFppaRDcBIpWk2uUIPG3+f71Y3gRbCV0kiHhxKCMbCzE4wP8R9aKgz6deXely6woQWcUnh4LfF1A6fWoNxPZvY20NvaGO4TJmmL58QnpgdgKlTx2xlgsrLVGe1fDM06mNI3PXI5/Op2h2VlJfvd3tuWs42YbIWLcgdfPb6+tBUQaZcz4wjcgkAKSTjk1Y29hYSPbi5Z4Y4k+0KJuMrbifPjjAqxKmOFG3yKsbeIdk4+FW6YHZuOap9SuHESz2n2drI7LHukVn48wOn80Hf6VfW0lpcSWcfusdkm5VYDaRg+XTpX2L2osLuf3UXiiTp1wCfQ964myvlv1OkQTQaVaTDfLJKxfxGA6Ent6dK1bbjUJVtYzpu69bxfslCmIpkYz+HIGcd6D0Zkn8D3hAz7Ax3K4wc8knPXoBWcjvJPKsA3W6gK6ofiV8c+fY1F9n/sdKttIa4t3uIkJlCSbupJAB7nzqdG/u1w6Iv2pj2LGo5yDx9OTz0oMnluUIJIjIGETB249fOtkJZbWRlUZYCTPcbuo/TrVTc+0eg2Fz7hPOzTAbZJFUsA3mT51b200EVpCwYTRzgYlVfhbjjjsMUEQr4dwss7osZAJHO70OamyW9ubYvCpkOODkmt5tYmeKUc7OhPPyqM5aGSVQ0oyN7SFABwOg9T/ABQR1MlnPFJKqxx8l8NwqAZJbtxXCT+011e6gI4rz3Kx8Vgs7xl8DkjP6cV03tJBMNC1AykSqsSyKHYkrz5155B4kyTOY4mjL/DZh2Ul3BAZF744/Sg6NrybVbDUbXWbYR3dlB48MpUqydMdecHI49a5G3v7q1eZredkaZDHIepZT1HNWNrpWp6pPeb5Ak9smZRcy7WI8ufl39KpSOaB1rf7ncizF2YJPdy+zxcfDu8s1k1hdR2Md+8DC2kYoknYsO36GtHiyeH4e5tmc7c8Z88UGdtMsEjM8McoKMuHzgEjGfmOtSrD3q3ZdThh8SO0kQszDKg9gfniq+rS7OnJpVqLKe5N2/N0jcIMdMedB9vHm17VpprOxVJJAXMMAyAAOT/NfNHmEMlyr6lLYK8DDdGpPiHspA86g29zPayrLbyvFKvR0Ygj61rJLHJ70E20ubKKyu4bmz8aaVV8GYPgxEencVAPWp4sYzpRvRewbxJsNuT9pjzx3FQKCW2nXK6amoFF93dzGG3DO4enWtMRgEUvihy5X7PaRgHPf0xmvtrGJ54oWljiDsF3yHCrnufSsZo/CmeMOr7WI3Kcg4PUUGsjFbrVYHuEW6keOEn4nRdxH0rKa6aW1gt2SILDu2sqAMcnPJ7+lbL3T57GO2kl2FLmMSxsjZBH8EeVBEPB4r5Spdpp93exTy2sLSJbpvlII+FfP9KCKyMoBZSAwyCR1r5W2a5nnSJJpXkWJdkYZs7V8h5CtVApSlApSlB+h6i30pjhCocM5wCO3nUk1Sne14IJH3Ttk4DZxjnny7UGpvDRtpxuILeuB1P619AXGQBz5VpkjSS7eOZTJtB6Z2Y8j5nrW53iiHxyIgx3OKDVMfCikkRNzKpIUd+OlbbCwzqMV0A5UJuLiQeGxI/CBye/Wo7iQeJIkkhywK7U8QMpHRRkYIPPrVvpIt47MLbSO67iWZwQdxOTkYGOvSgn19qLeuwhATI3HGRUC0uilwYhuBUAsG7jpkflQW0pYRsUAL4O0HuaoLbUrxdoOJ5nJ8RX+AREYyOBx1q9uJEiiLSSLGOm5ux7Vz6TtdTeKAXAJRpfD2E4HCnsSDnp2+dBb2N57yXVvCDJjIRySPnkCvt7aG5kiw7Io++V4JHlmquOaaOd3jibftMak42gEg7ie/yrbaXMkbTATGRYdrSMzZ6+Z7Hj9qCm13Vv/bss0dnBI006BgjjdGqjguTnJPQdunPauV9oruC+XSb6ZY3eW3YTRxPgghiB54r0PX9Ct9ftQni+FPHwkq84B6gjuDiuf0z2CaOSVdSu1e3OPgg4L46ZJGR9KDnvZqw1Jbtbm3jnNuCUNxAoYY6NjPpWu63wa+7pCssFltjY3cOFVTwN4Az1Pz6V39xp2j/0s+z8d0LZGPCrL8ec5PXr8q4/UIIIdVk0rT9Il1CZFzLJdu29lA/DgjAA6GgrdL0+SW5tXvVFtbyQu0MoiyHCn/Lz36n0rO/lt54LXThFDFMZ8m6ZuinjB9P7UtV2GK8s7mSJH3wiBpSzxgAZ54+E5qFqphM6L4Oz4ss6kk7fLB44xQRrlUim92iaKXw3YePHn7X8+1dNZSLa25W0mSBzbbZWAJ8Yk8ryODz8uK523fZdOlsX8KQ7BuA3MueAfXgdKvzCg3kNgL2cbST3GPT+KCrvZVAKArkEKB4gUhj0OD1XzrdfGzC6haRWDT3Us6LHchg4Vj94ArgcnOOP2qmuJpIr6V42KtkjPoRj9jW+4MyWttc21rcWlqdoD72KvKvVgex/ag+XivG1zDLstZBMqvaqDgEAjOeenz719M1umsCW7t4JII5B4kVucI4HHB9cVAklkmmaWV2eRzlmY5JPmTXRzabe29hDp2n3D3D3kXvFxaGLa0e3kHJ5/vig26Ktve+2kN1pdpJBZJIJCp6RgDkkjoM12Nr7Z6PJqRs0Eq7n2rKR8LEmuCjg1K10t1XVYYrdoBcCFbjl9xxjA/F6VBmvLOe4tCtkLVIVVZDCxLSEfi570HR+0GnNZw6vAkFk8cU6zG4kbEw38hV8+9SIfaOaHSrSw06eC4ntYWlllk+FNoH3Fz1bH7VS6jPqGvX02tW9nmC0Cbt2GwF6bgfvetRpDZNi/FztvkJklt5rcbGfcOFA4xgk4PlQeraHqcV9YQT7gvjICqk857gVJu8Z+2kAjb4QqqSzZHIrzi31bV4TYTt7pFa3r7EiiUDYoOOg6DJJrvLyaU6fNLEgkuLeNmVSfvcdP0oPmradZ6xp00U0kxjIHEfVCO+O/wAjXKazpUsF5ZanNK2swW6BZI40EbhBnafh648/StOh+1ko96u9UlhWKOMqsaDDux6ADy9e1c/pl/c6RrkM16biIKwaWM5ztIz0P0oMNQ8GRxLeRXMck0bypK0gkaXJ+Dd5DAwe9fFmKx2+qTCxufDbwPdWABwF4YqMZ+fmOagX9wt1fXFwiBFlkZwo7AnOKjUE62eOWGSC7u5YoUVpIkVSymTyxnjPnW3S7uCDxre7TNtcLtkdEDSLjkbSenOM1WqcMD5VYDUkfUxe3FjbSj8UATZGeMdB086CHD4Xifbb9mD9zGc446+tbtPe0ivI5L+Bri3Gd8aPtJ48/nUYkZOBj0qRe3st60bShAY41jGxAvA88dT60GiUqZWaNSqEnapOcDyzW03k5tBaFz4AfxAmBw2MZz1qPSg2rDK0TyrGxjQgM4U4XPTJrXjJrbHczRwSQLK6xSkF0B4YjpkVp70Eq8tFtXjVLmG4Dxq+6I5Az+E+oqLTNKBX0njFfKUCsldlBCkjIwcHqKxpQKUpQKUpQKUpQfoUMGGVIIPcVQXklpJd3UTgxzIwaRhJhXBAA756YBHSqDXpdWa0gstNt7ggbnllj4zk/dHPT9a5/RNXv7eZo5JWeDcSwYBmU9ypYHBoPQz15yfnWUaNI2I1yx6/96r7DU7e8VoIFdmRMtJJwfoOc+tW1tdr74LdJUc4G5ARlTjyoND2UtjCiR7ZIl+FfiCkeQ5wDWrdudZnR3ktycRsTwR2xnGfKpGo3SzwXFqYA4cbULcAseo57gZNRVUxxODI25skyMec46/68qDdZ6k48SS5uYJkblfDcbmJxtVU6jA655JrfHEW1WZzGY14yDj4sfi/iouhqizKSHz4eEIClCO5Ddc+h8+9TLxp1uklS2LGHJV84XYRg5PbB5x6Cg2Xd3prOgnvYFeGQMB4oBDDI5/M1EuY2bU8hiUZBIoVep+7kn5Hj6+VQ5l2W11ceL7tBbxmQlIwxJ5OOf8AXNVeke1Nq4EKM8TRrEg8YqAUX7xJzx1PA8hQdHPanwftX8JSR8WcYOeM/wDesYdMMSnxsvGp3BFVQM+e0ADPqa0w30OpaLdTW97FIpdvELvtCJnoePh+H0rP+qR3emXP9Nu0vZ4RlxAQCFPZc98A4oNttetBMyTJCkZbaTGDlD23Z/epUmoIpbajuEYq2OoI68d64ew9r7F2eCa0NpGwIVx8YHHVgBn96621ikuV94jXbHKQ6lzyRgAH6gZoI1/paazamKLbB4Z8SGQDIbfyQR/Nc/rXs3rl5rJlgA8IokSy+Ng7QoBLd+eTXZW3gW8rwpKzPnAVuAMdl7dz/oVteRrqyD27MviAEHHIHeg5pfZPR4YTFbOwvVUDxS5I3eo6YNVWo+ybJbSXOp6pBbeGAsecsuPXv17AV1N0nhMzvNHCiJhnJJIBPljk+XNVOszaZ7RJ/T7a7kivlGYkdSokIHAJP1oOPh0iRYxe2tzBd28LgStETuj56lSAcVaGRPAkVZDk4LBlzvOTyD24qi069nsrqaFFwbhDBIG7ZP7jFWNzIIraR+mFOKDnLzwmkd1djIZCCu3jHY5/Ottouo6isem23jTqGLpApyAe5x0FaYmkENwfAEiuAGcoTsOc5B7HipemiOSKa3itrmXUZcC3aF8YH4sjvxQYyx6YNIiaOWddSWQiWNlyhXsQe1R7i8vLmRJJ7iWR0QRqzMchR2zUdhhiMYxW+S9uZLSK0eTMERLImB8JPXnrQTIJDPb2qzW8cdrblopLkQ7iN5zlvMjnFY3GnLbG3nkkZrG4ZvDmRQWZVOM7c8H0NR7Ka2j8cXcDzBoyIwsm3a/Zj5geVWWk6Vc3Om32oJZLdRQIVGZNpRuu4D8WB29aCDcSSi0tB7qLdNjASqpUzjd1J746Vtur6G4N60kTTyzsrJcSnDrjrkDg5rZLdXjPDrLe7BVnwkS42qwAP3OwNQoJ7htQSe2XFwZd0YRc/ETwAKC10h9GjWF2s7681HBCwqBsL54PHNdf7M+0D6hb3r3ZENxaqZG2jAKd+D3FcDPc3NleIwjNre27Nvdchi+SSSOgPOOOKkR6nqEOkyrHcQLHcuVlwF8Z88nJ64oOiWP2d15riz062WC8kBaKRsrluvAzjFc1cq1xrLi6tZFERAnjiYswVBhjlj14NbrGMafaC+Zri3v+JbMiPcki8hvkR51pTSrqfTrzUppVjMO1ikpw8ob8Qz1/mgr7kwG4kNqHEO47A5ywXtnHetOK+jrW+7kimmLwQCBCBiNWLAcc8nn1oI9SYjZ+4zCQTe97l8IrjZt/Fnvmsp9Ou7exgvZYWW3uM+E+RhsdaQQWr2FxNLd+HcRlfCh2E+ID157YoIlfR1rY8aqkbLKrFgSVAOV571KurdNOuoGiuILv4ElO0ZUE87SO9BFnSNJWWGTxYxjDlduePKtRGOtT7PUWttVW/wDd7eRg5bwmT7PnPGPLmocr75Gfaq7iThRwPQUGFKUoFKUoFKUoFKUoFKUoFKUoFKUoPW73S7u+gjm0/UGgu4XyIy3wOBg4I/muIUie6up1hEAllY+EDnYe4/PNd2SYmjui0cREoEZOdzAcHt0IyAO/FRI/Zm0vJ7iaG6e3kkZnaEoDsyTjHpQc22rNYlUsraC0kmIRpyzPtHcgHp51VRapNpl9PJavDLOGdRd4JZwep5P5Vc+1Ok3lqUkltlEan7SSDGzyBC9V48+9QLOyvor6A6farPFe7jb+9xoRIq88g8A8edB6Bo0fvVpFNdQol5NApLqTxwOxPBwB+VZvGHjaN84IKt/NQfZTXDqEd4b6IRT2v3io+Eg+nY5GMVbGSG9Ym3YCbGXiYjI/KghSJdW91C6eCZJUYtKUIZRx2ztyTjtW22vDDBK87iWIhlCPJucvnGMf5qmXtu0og8Nle4hBypbBZSOf4P0qvjCSIsqjqOMjmg+PE8uk6hbQpl5LZgiDnnB4ry17aVIxFJbBJSPFVnbDFemAPn9a9esiI3kmckKi8475rXfWWmXmy8CpFdROGjmVBvDDzHcfOg4S0DWmi6hpds6T3NyoefajAxIByp3Yyf8AvVfo+qvp9rc21vGRNd4RpS3RPIDzPPNd7Zey8M97LqOpXC3byuX2rHsXsMHkkgY6VV+2E2mSTPZTRQxyQ2pltZ4mwQR/wyBxzjig5pZf6fcmK0MCTyt8F4xIVFK4ZSCOnPlwa6S49qJLKzsYLDbNb28SrNKo2l8DHw5HA9T1rlBi8tAerockef8A5qdcXVhcz+7QQpBEoAY27swYd8bscjpQeh2fhahGtwSMlVdZBwHHUEjzBrHVhdWdmjWkkrPGgVcHjjqSO/HauEbUr++222jwNDBp8JZkd1J2r3OeDXRXesaux0yDS0jlkuoTKY3UMMYHcngCgqNf1ZLq809m8WKXZmeJtwRW6AgHvjvVZNef0/VLXUDAJvCyQhbaCw6H6datdZuBqOk3S3dvHHqFk6upQbTsLbWH0NVVxF71pK3J27FcAjcN2fl/NBXXCXMGsBrzYZpGEpKMGB3c9R86sNVVVsmDEOSFbKNkAdx86iXkMF5NcXujWjQWVqqb1kkBYZ4z171ZOqXFhCAIwXjIO08n/m9aCu0l4TdX0dot68bRlo4Qy4cKc4lB4Ix5VGjmuJyLiwt/d57VXllmgbbwT1x2xnHFQZRGqIE3+IMiTOMdeMf962mzdNOW+8aAq0hj8MSDxB6lfKg0wzy290lzE2JY2DqSM8jnv1rXLI0rs7Y3MSTgY61N1C9t7yO3ENhDatFGEZoyftD5n1qBQb7RYWuYxcu6QFh4jIMkLnkgVbWl3Ppt9NDpWotHY3DeF7xJGQhU9yMdRntzVQsoWF4vDQ7iDvI+JcZ6Hy5rd/Ubv+nHThMfdTIJPDIGA3mPKgx3GzvGMEkcnhMQsgXcrY74I6fOsZkns7ja+Y5kIb4W5HcHIrbcx36WNr7ykq2p3NAWGFOeuDURF3uq5C5IGScAUH13aVi7sWYnJZjkk1b2lhea37nFaWUMQXEBmUbQzctlj54BrUrR6RqEUtvNb3ksLNuBj3RHyxnrx8sVNhfSn9pFLahPFYu3iGWFPC2PjsPwjPGetBWm5v8ATLuS38d0kh3wEbsgA8MB6GpOo2yvaafOmqC+uJUEfg87oQOi8/PFR9bhsodTmXTbprq34KyN1JPUZ7896jQWtxLbz3US5it9pkbcBtycD160EiXRtShvhYPZyi6K7hEFySOueK0QypClxHLbLI7rtVmJBjOeo9e3NWdreXN/crOdRuP6sHRLd2YBdvOcsen/AHque3u7nUXgCme6eQghCG3NnnBHWg0vPK8SxNI7Rp91CxIXPXA7V9ikiWGZXh3uwGx9xGznnjvkcVhNFJBK8UqFJEJVlYYII7VhQKl2VmLvxgbmCAxxmQeK2N+Pwj1qJipE7wsYzBC0QCANlt2W7n0z5UGVpYXV74vusLy+EhkfaPuqO9R9pxntVz7/AGgvQNOkudMtZIRHPtJcscHPfnJqvS/uI7CWxWTFtK4dk2jkjpz1oIlKUoFKUoFKUoFKUoFKUoFKUoFKUoPZXkD3Lr4u8DbszgHaVB6fWuatvaC9i1e9glCo+xoYI9vIYsMHPl35qigubqQPqU1wJbgyZ5b48rg8+Q7VP9p/B/8AciXIk8NZrdJdoXOCV4U+WfOglRXdxayzi73NBh45g7ZDEKeM9M1zEccj2LXBu0UW7hUhaQ7+ecqPLzq4u40YKq+EVaNSRHnAOO+e9fNNntyS2oaSb02eyNZInwxBOEDL+Pnp+tB0vsmk39PeS9itrSAkGCJBs8RiPvNnJ8sf+KsHS5hmgPuqRyROWOxhz6A8cHv+1aBL77Es8TzLE6lDGY8nPIIYdiKalqA0+xku7qTYzMoUD4sdAB68A8/Og2CARwv4jobgsZS44YMTkcnnjpk1LigaECKd40dVLt8XCrk9ajWl5o2p3CRRXyeO5DrEY8PkDgjcOuBXLajqd/be2E4tED7mNvGPD8Xg4yQO7f8AjpQdm6skssRIwuBuB65GcH1/7VhFE877YgG9ewrnfZXWpXmey1aTe7zqYBKNrOWJ3E+fT+K6s3cNq1z7sqOWlCqi8Dfj4s+WMZNBq8dZoLixXJVY2G7aeT3BPTnyqu1S1s73dbyW1uss8ZjgZYwGi5HTz7mpMQibxJZjCng/E7s42geeTUG/mmL2Oo6feobGOUeO8XOUyM89cDuKChs/ZmOKa5to9YtH1KJsC3DYUj1J7+g6d6p9YS6spRAxZFhkJMXZXPX8+Ke0CLPfXF/CrKk0pfafw56f3+tbry9i1RmIJ3GKMMW6lgoBP5iiNVtBHeTwTiSKJWYCUy52Ad92O1X2mwQ6xey3mo6o1m8D+FbPAPDiwOmxjx9OtUWn36WwismUyRFi8sMuNhfkcY5xtxW+91m/fSBo0ht47ONPhJjOZMHIGfP+1FfRPLcWl1ZxTlkEh3MP+Jg8Eny/TpW7RXkij+AwwK+6Myu4Z1cAn4R1XI47g1HS5mN/DcX1s0cl0m7aB4cbx4wuAvPb68VgbWeHUJRaJJNdZzG9u2RtH3ug5yKDXZ6NPqWrmytGRCy78yHAC/zV1pFm5e606S5topbRjkuAQxXyP1qs1SFFT3y1u5E8NAYnZCjOeAVGOmMnn0qFpe4XMq3D+E+zeFlBy58h680RFlt5j70sdsZFjId5ApPhr8+gBz+laLi38FISJYpfFQP9m2SvofI+lWmqx7ZEk3ukbkLLtPUfLvS4a0tdJV7RYJJRdkw3PiYmCjpuTsOlFVVrazXUvhQpuk2lsEgcAZPWkrW7QwrFEySqD4jF8hznggY44o/jziW7dWYM/wAcm3jcefkM81HNAoK3G2mEC3BikELMVWTadpI7Zr5c28trM0M8bRypwysORQYtLI0axtIxRfuqTwPkKwzSlBshCvKqySbFJALYztHnismQe8GKJxKN21WAxu54PNaa+r1oLB7BbO+ntNWZ7eSJDwgDndjKj5HPWo1vbTXCTNAhZYU8SQ5xhfP9a3yq97GZ4LWQCCJfHcMXyem4k9M8DFRpIJoI43kjZEmXchP4hnGR9RQas1MZFtYLS7tr5TcMSSkeQ0JB4yfX0qFTNB9dmdi7sWZjkknJJr5SlBKvLlLl4ylvFAEjVMRgjdj8R8yak6td6fdRWYsLL3Vo4Qs3Od7edVlKBSlKBSlKBSlKBSlKBSlKBSlKBSlbIYWmbanYZJJwAKDXSvuKUF9ZOttOyBMyq+4F8MpGOhU9a03UyTQXM92076jJOCHI+Apjn69KsLjTZfeferPMy45iIw+PQfi+lYeCl8BFLJclVRhbxRru+2OOCO2e9EfNNeW98GGMBpWIQDOMmp5tdC2JJezX1ndRcSGIBgWB6g9qqoZzBAlvNpvhC2kIuJ1U7ySejHoMVb3vu80kawGWDT3JERuMkD/EeO2cUV0+g6joclidOsL52kwzkzqd7E8ljkc1yuv3N21hJp94pkdJwzPkcKB2885rDT/cdAuJL6aZLqUKVhityWAz3LEACtYmk1QXM84cylS7AYG3BAxg9gPrQYWWsqntBb3kktxJDaqVgSY7mIxgLkcDr1rO7jlnxLbs7ztumBhRgUbknB9PStJujDPaaNq8aw2dpOWd4o8Sc55J79RVtpmo6QTPFP7zJbxqRCqueWOQWHTGRjg+tBztrJZQamt0WuLhYmV0jdcNK/Xk54G75k12Gmam2ptdPdRi2ljciVMl2GT0AP3Rnr61xt/bfGZIvu+vUVYQOmm2cltDeRyXt4ftJYH3COMdFDeZPX0FB1urRrd6BqC26CWR4gVKckhWBI/T9K53Q7mG2uLQWguUs7iN0vTcH7NnCk/D2yB++K0aTqsui3iyRzXDqyr4iSAMjuWw3PVRjoeuaw10mG51a2aK4Nsl6GiCPiFGOScjzI6UEoyLc6XGWKzsjbpFMZ3BMADc/wDh7AdqpLf3m1vJb62jVFt3BYDBChjgDB6jt3qxTVoZ5rvwEXT7d0H2AkOGHA2+vn+dZGwkaJNVjt1eKCUZO7qQQcEdcUGN6IF97SymQRsinM8GHYjnaOMqc/KrPQ9OvdX90nFsjWkTlmE+RG5xjp3NYQ3F3rvtXJayNbyRXCBJWiTKrGBk4JGc9s+delxRJDEscaBEQBVUdAPKg8+vPY3UdOMd9YTpePDnEDR8KOeFBJyOelQLC9uLWZru2ZIriFSpjcHJzwRjzHXnHSvUqg3uk2N8d1xbqZMY8Rfhb8xQcLqzaTNbwR6beCeNlkZ45nO1Cw5OOzE9vOuaS5vTNczzNFPLHCFJuCCwXgDbnuPSu+n9h4ffPe7S/lWXfvIuEEqsc9+ma5/W/Za+04/1N4re9hjbdJGu4DHqOuPkaCZf2Oiz6DE9vd+JcyIpID55xzkdsVwTW8viSRhGZkyWwM4A7/Kp+mzvG8jgDwlwX5xtBOB86nSQwC5jupXnFucrP7ucOUI5xQQdGtrW7M8N7qQsYRGZBkEh2HQY/wBelVhHNT7uO0FjbSWsdyJGZ1keQfA2D8O31x1rCwube0nSWezS7A3Bo5T8JBHHTkEUGg3dwbYWpmk93DbxFuO0N54861H4up5rMjx58Qx7d7fCg5xk8DmpUr3unJdabKvhbmAmjZATkcjnr+VBAIpUr3qP+nm191h3mTf4+PjxjG35VFoFW1roV3c6Lc6tEYzDbttZM/F6nHpkVU1OsP6g8dxDYGcq0ZaZIicFB1yB2oLCa102P2ahuobq4ivnO2SFlISUbuxxjA486o2YnAJJAGBk9KlS6hdy2MVjJcO1tESyRnop/wBE1hYWU+oXcdrbBTLJnbuYKOBnqaDVbzG3uI5giOY2DBXGVOOxHcUnlM80krKql2LEIMAZ8h2FYMpUkGvlApSlApSlApSlApSlApSlApSlApSlApSt1vaz3T+HbxPK+M4UZoNcaM7qiAlmOAB3q3LQaeY7NgrknN0w5/6R8v3pp1m0JWdphG5B24AJGe4rpNE0uLV5PFuYYxFCArNJgvIo4HyHXnHp2zQUlv7J6jeIZrPwnty2EdnA3DzFK9RihmkjUwLHHEBhAynkDoQB0FKCLs0yCZ7Z7NpHBBLyx5LE9MH6cYxVBqNrZX7vcW0JtGypZ9+4PkgcjsRkVbSNIX2348L4UQlXBYtgjnB+HOe9SmiiwsTxLlV2oicuB8+1B53d/wBX03T57B1PuN0/ilwNwb/q+gzmsLCe2jsCXvHW53FBHs+HYRyd1dlc2jWsivZzhZOQyjGcHsex6dKrZbGBbkSXdrFHOQSssUHHzMZ4OPOgo3iSaMqehHWtyw3Hujaq81kWtGAeOViXuDnO4g9fLHpUk6fc7riWOU6ipO7dHhZEPfdGecY8qi+DE8sYkaHsW3Lu8PP+JfMeVBsiuhBfx39uttJOhLbAuYgT2GD0wfoarEjMt6XhnhS4lyzQFfDUMWPwgnjGOc8eVSrm5kitrO0FnbRRIcLdhCplXJGWPlWgJBffAWVfi2lznC+vyoM4po5sKCATxgmo0kUlpM09qy7gGXs2M5BxXye0ZbpcqsAdxllH2SKcYPUnzNT3uooXubGa5jncOqrLEi+G4Udc9R5cde9ERLO93RmGTJBILIThZMHIBqPcpJOk91LIWuPFzKpYDcG6FR1PfPlxU6SBCFCwRSICWJ5DHIx1HYdcV8Ul7hLS6ula1hcQx33hkrFzuyOmPr60VNnsb/S9QtdXuNAhW3YqFtlbKhsYGRyQT696xmtbqPUHh92aKeYq8dkI2B+InIU8jC46nH0q09+v9ft3sf6nC13azqbcQRkG4Knh2J6KOv8AoV3NpaMhE90yS3bIFeRVwAPJR2GaCt9m9D/pkbXFwFN3KAG28hF/w57+tX9fAMV9oFKUoFfGUMCGAIIwQe9faUHlPtRo40S5EfuyNps83iLKijxU84w3YeVQLB0ma5jtkla0j5UyEFlUnAzj+K9X1exg1HT5ba5O1CMh+6Echh8q8f1CF7C+lW53yXRG7xPuruLZ3D/EpHy6+lBGv3mhkFoZXa2Rt6REnaCeuBS+v1upZ3jtYLeOUqQiJ9zaMYU9s9/Ot90i3tqs8QHjIMOo8qhLe3CWL2IcC3eQSMu0csBxz1oN1npF9e2lxd2kBlit8eJtIyO/TrWEcGoarPI8cc93Kq7nYAsQAMZNSk1O5XTE0qKBYnMhJkTKyOG/CfMdK2anYar7NTeBJN4RuIuTDJwy9wfrQVNusRuI1uGZISw3soyQvcgV8uFjWZ1hcyRhiFYjG4Z4OO1bmtGFkl4ZYSruU2BxvGO5Xy9a+3Nm8FtbTtJGy3CllCtkrg4+IdqCSthaf0Jr9r6Nbrxdi2v4ivGWrPQrvU7KW5n0tdxWBjL8IYCPufpxVTk1tt1klmSKMgNIdoy20c+Z8qCe2k40Aas13AN0pjWDPxn1/wC3lVfCgcSEypHsUsN2fiPkMd6kTW0cC3CS3Ci4ik2CNBuDeZDDitFwIVmYWzO8X4S6gE8eQoPlvDJczrDEAzscAEgVq78UBxW22lWG4SV4o5gpyY5M7W9Digzd7c2sSJC6zhmLyF8hhxgAdsc0s7Vru7htkZVeVwilzgAnzNaWOXLAAZPQdq23Ny9zIrskalUVMIu0YAxn50C6tntbmW3kKs8TFGKHcMjyNa9hD7WG05wd3GKJI6OrocMpBBHY1YSyzazcvcXV3H75I6IA42b88Zz0GOOtBEv7YWd7LbieKcRnHiRHKt8jUes5EMcrRtjKkg4OR+db2spksY7xgvgyOUU7hnI9OtBFpSlApSlApSlApilX2lR6S+l3CXEEst85IR92EiHYjHU9aDC30Oa3ktpdVt5YrebJVVIDtgZ6E8Dkc1cCF/drmeytJbXT5mUMkZJTI4AJPXn6ZqbDYS3+mPqEl6JZYzsSIkEhF8yTx/rzrLT7y6eyOnnwZbdd22N49zYzkkHpjJxn1oIenWNu87XF0A0aLkRbsFmzgA46Dr+RruNOtknZ7pY/Dt5dpCFNpYqMZ/5emB3qu0HRY5IobmW3WKLBYJt5kz0JzzjHbv8Av1IAHSgYFK+0oOFklIuXs1ii955jUE8TqeDjyOOSD5VLifdCkdvOI4v+IoGGXzPmR5jt6iodokF7aoIhiSMjcAfiBHOVPmeoPnmhnlCxYkCXbMHEjLgS9evkf9DyoLi2SCOIS2+Np/8A3EnO7/lH+vrXyWXfEyAFkOcvIMk48h2+n6VGglW4uCg3R3QxmJxkNnucf/7dDxkVIIJujGI5IywCnc4BlUZyFI46kdMdKCvvLBHEPh4VhtBJzuwSuNzD7oxz1Jr5eaVc72a5T3xCAM4+MY9R8X71cx7UXwYQuzvBLkEDyGf9etfGZITxNJAT0jkG8E/5f+xoOTmtbdoYogbhQmVZZPtFGevkRVVJpF3G7e5xpMrL92OboexxkcjPSu0uZTcL9tBEuTt3Dlm7cHHH6/StEmmRyzC23i3cLvzH94+h8/16UHH2moxIGsrqSeCLaTMCN++QdPh4x5c1qezgltHuJQ1u6usYVlxuJGfpx6V3Vzomle7gS2fisBjIXdI5/cnvVXqns6uqz7re5upriJfDKuN20DsSen1OaDlCJLOEGGVpDuO5duVA7EH86lw+JrRis7WE+JI2Wt4chFIGPEYnjnn5V0emewMqMHvtQ2jukA5/+x/tXYabpVlpcJjsoFj3HLN1Zj6nvQQvZzQLfQ7TYhElzJgyy46+g8gKu6UoFKVhI+xGYKzEDO1ep9BQV81/Mk4EcKtEGKsScEetSoLuOZtoBVuwPeq2a78OEm6tQI42GUR88HjvjPXp3rfp1sqvviQJCCSoHTny9KCzr7SlBquYhNbyRE4DqVz5ZFcnqulQ6ta+Fcjw7iPIDjqjdx8j1rsaq9Wth4TXkfEkY+LH4l7g/LqKDye90290acNNGdmeJB91h/rtXy4tYdhu4EWRHU5jyfhJHXjyNeq2yw3MRs7uCNlbOOpDfn0+VU2o+x0UeZtJ+zfqYifgb09KDzItNcNJNLMGdFGTI/xN0AA8/wC1ZqJtQkkae7XckZbdPIeQPwg9z5CrLWtEu7M+N7rKqk/ENpO0/MdqrntozLbxWMr3UkiglREVIc/hHn86COYWECzbkKsxXAYZyPTritdT3a61fUCQkRncfdRVjB2j6DoKjyG3MMPhJIJhnxCzAqeeMDHHFBHxSpUrzajdlo4FMsh/3cMeAeOyj5VFIwcUGcKo8yLK5RCwDMFztHc471uUwRtMGRpkKssb524PZv8At618t5Yo45hJbiUvGVUkkbGyPi/151iJS6xxSSN4KtkDrtzjJA+lBpNK3XQhFxILZnaEMdjOMMV7ZFaQM0ADJrq7L2I1K4tFuJMQ7l3+GVJbb2/6upx/err2K9kiuzU9UiwR8UELj/8AyYfsK9BAoPBru1fTr7wZ0WQKQw5+F16gg+RFabiWOa5lkihWFHYlY1OQg8q9b9qfZmHWLLdbqkV5FkxnGA2eSp+Z/WvIp4JbeZ4pkaORG2srDBBoM51t1jiMEkjsUzIGQAK3kOeR61ozXzmlApSlApSlApSs443kdUjQu7HAVRkn6UFrpNnG6GWUK5P3QTnFdLYabYzWDlJzDe72O3b8O0dAPUj1qdoVpcD2eXSbzTWimD+IrsBg5OQW8vLHU1Zx6LBEsUY5kcncEJBI6kKPLtk9qDnobO3QCdo/EJJwzdV8uB/f6V1GlaMxKTX27Cj4Yievqw/j86sbPTIoXMjKN24sqA5VD6evr+VTLiZLeEyOGIGBhRkkmg2dBWszxCcQeInildwTPOPPFVlxfTysr2cnhqv3lkiOSfI+Q+VRTJPPNJJOip8IXKHvg9D15H5c0F+sivnYQ204ODnB8qVys1s5cGCZ4hgZGTknzPrjFKDlrfVGkvjcLGttJJ8YjUYUqfL0roYJv6v4njNEs0bARblxlSOQT0OT+1cBcWc8RaSNXaNOSyj7nlny5q6ttQjtpY1S6WZto3SBCq8/hIPWg6eRJImaMIzMgxtJ2vjzVu/Toazs5wkZM+Z3faWjGAwz1JXuQe4x1r7Z3aahACbd5/D4KKpYr/yt9OhrddWUbrvCMqkgiOdCgT1Vux+tB8S+Sa3zFIr+SSAsB8j1H1rStwkcLSzsUEZAkEhyQpPYdx+npVXPM6qySKTtIBWX4WxjtIvXGK6AR291p0Pv6RglBkSMMj60HMSa1euZo4CiJI3AaPcVHYEk+nSpn9X8XQ5rO5Ym7aTergHLHdndkcAjp9K2zez/AIpzpryyAnOCmF/+5xVlpnsskbLLqTrM6nIiX7o+Z6n9qCHoWnahfSxXd3czC2iDLH8R3SAjBx6evXyrsYokijWONAqKOAB0r6FAGAMAcYrKg+V9pSgUqJcaha20vhSzKsm0sE7kD/wa2wXCTqSmeOoPagXMxgjMnhySAdQgBIHnUG7vblSGs0iljCeI27OWHXA8uKkXl0YDtaJxEwwZhgqmeORnP1xiot8UtbWXMMjxFSJXC5wMc8DtQRPGtzf3DNHJLA20CIR78tjLfLqMjzFXkEkc0EckRBjdQVIGOKpGjTwVRIi0aRllCyeGi+RJHzz+dbNPvltba3icE24QKJzkHPmR2U9j+dBeUqDd6jHaypG0UjkjcxQcKucZ9fkOamRusiB0YMp5BByDQZViwDKVIBB4IPesWljVlRpEDMcAE8ms6CgSObS7zYrOY2yUDNkOvl6MP1FXkUqyxq6nIasLq3juYWjkz5gjqp7EetVFtOdPvWiuWCBxlzjCnyceQPQ+Rx86C63Rlym5Sw6rnmuL9rPZFboNqOkIEuV+J4U4EnqPJv3q+1WNBPGxba8hwjjjaenXsD0rUqSW4VDuVlAHlmg8cnCidxEsgQHgSfeHz9aygn8JZQY438RCnxrnb6jyPFeia/7Px6nILy22RXwIOSPglP8AmHn6/nXnl9BcQXcsV1EYplY70K7cH5eVBpjkeJw8bsjjkMpwRWPU80pQWdjY6jcWE7WKmSFsJMiEE8HIyOuM1AkikicpIjIw6hhg1L0ma/gvY30zxTcdhGpYkeRHcV6Egs9WWO212wiivsZKK2SPqPu/I0HmlvbzXMywwRPLI3AVFJJr1D2V9jrfTY47zUY1lvj8QU8rF/c+tTNO0/8Ao8Lw6esZifOcgLJ/9+/1FQdS1rWbRHKQSqQdqL4W/IA+8WHGSaDsEdHzsZWwcHBzg1l8q8x0DXZ7L+oahcRs2V2AHgCQndyPz/0a7L2d1X33RIrq5lzIXZWJwMnOQPyoLaOVnlkRoiqp0Yn73yHl61z3tX7Kxa3Gbi32xXyDAY8CQeTfwarr72p901hJECT2zDKOVw2xgCVznsfMV0sOtWc1wIQ5AaHx0c/dZO/yI54oPFL2yubG5a3u4XhlXqrD/WRUevc9S0vTtesFW4VZY2G6OZDyvqprzTWvY+5sGL2UyX0W7GI/94vzH9qDl6AZqz/oGrjw86dcfaHavwdTXSez3shdw3kdzqcFuYlB+xkbdk9sgcUHGRwSyk7ELYGT6Vc6Poa3jkXXjgMmY/d1DkN2LDyrvYvZrTUfdJCJcHIQ8IPkKtkiit4iI0jhiUc4AVRQcJYewssjB76fwY+Ps1wXP16D9a62x0zTdGizbwxw9AZXPxEnzY1It7qS73+6WruA5USudsbD/ED3HyBqalknEl66ylfiwRiNT5gfyc0GuISXABg4j/8AlYcH/lHf59PnU6CBIQcDLHqx5J+ZrMSJtD712t0ORg1A1e5eCONY7lbd3b7xQN0+fzFBY5rGRVkjKt0NVB1KQ2lykoAuIlyTF+Je5UHoR5duKhWWs4ZFW6FzGw/3b8Sr8j3I8jz60HzVnv8AT7gMkSTW+MkAfFVEPaCO1u38Vne3lOVVj8S/Kuga4tIZvBEqxknIRnJI/Oufv5NP1FJbO6gW2+0JSdADhumTQV82v6jbyFIpHljPxIy4YEflx8qVBX2W1ty3g2UkiBiA4IAb1GT0pQdlH7IXDPL4l7HBBJwYYEYjHlljyPnVhYex+j2cvimE3EnUGY5APovSuhpQYqoVQqgADoAMAV9r4XVfvMBnzNfc0Gl7O1kOXt4W78oKJaW8RzFbxIf8qAVvrVNF4ybd7KM5470GMtzFEcM+W8hyaiPfy5JSNQv+bk1HuYpbWX/cmaEjIMSksuOuR0x+vpWBI7E4PpigmRag24CZAFP4l7VYA5GRVEcHirGymVbPLHiM4JoJta5pY4YzJK6og6sxwBUKLVbeVJWjDsY2ICgfE2PIduc9fKvl21reWEU7zeHGGWVWxyCPMfmMUFZKYbueVPFWeFiJkkR85GSMfQgj5GrW0R40kkCEkj4QTjdVZCLeD3i5SImNXGWB4kLYIwew5GfKts13eyTwyx74FCsDGSGUsCDz3IIPB4xig3y37vZXKTwiGZMoVbLqRjrwMkYNR47rZLcrvjZMKZJGHD5QdPJduPnzWMbsxkfawVm3KHPIyOR8s5x6Vrt4mQDeqgCNYgqnI2jPUnqeaDXaht8ABbbBG0bg+eRtHzCjnyz51KkwysG5UjB+VaxIquIYoshcBiuAqA+f71It/dbiYRJeRsx5Cpnn5Gg1wvNdWMDKFKIoTeSfiAHJ/YfPNfdPuGtpo7eQlkkYqsm7v1AYefqOtJb6QPI0bobUZTZ4eMDpnPof0qO6GWDaQdxHRTyGHkfPPSg36iY3mkjFvCFBADM+Czfx+9aJry8iiFm8peaUqIiR8Z5wQfPHXNRvaKyumtYpmUs7Mzug528Zx9AP3rTomstczw2d4QXHEE5+8p8j5g0F7a3E1qRHMzOoOCWHI9al30SsYrgpvMJJK4zlSMMMd+OcelV12J7d3WVjOmNyn8ajuPUfr86t7WVZraORWDAgcigh3clrLGkAZSWX4FxlWXHTy6dq0WV4pAtb3JwPs5H/ABAefqOOe/50vYkt3ZXwkLfGhJwFYckZ7eY+tct7Q376fNaS29wRBICyFMEZzyD59aDsJbF9+IiCjdyenzqPrXs5Ya1bot0pWdFws6feH9x86+ezuqpqFqFLDxEHIH8elVntNd3thqcUiSE27oMIfu5HX69KDltQ9g9WtmY2wS7jHQo21sf8p/vXP3Fhc2EgF5ZzQn/8iFQa9j0jVYb6137wGUfEGPI+dSr4h7NsBXU46gEEUHj669dwQCCzIt4sYxH8Ofnjr9aijUpwgVcAgklh1Oa9BudB0m5z4tigY/ii+Aj8uP0qA/sRp0iZivbmHHVmQOv1xgj9vWg5vTPafUtOIUS+PCP+FLyB8j1FddZe1WmamEjmkaynB4EjfAT5ZHBHzxVRL/6fXxXfZ31rcJ2OSv8Aeq2f2M1+HP8AsPiD/wDHIp/mg6u9hs4mD3WnWcqckBpssw7YzW23mS1szJBpghichliVwhJ7Hrjy5rj4bH2l03aRYXZjT8DR71/nH0q+0+4a+crcwyWswHCSwYz8mIoJc0GmQwkzaVaowPw75FYE5+flW15dPsxHOlrao/IRVk52HggbR656edZmOJ2RJWjSFPwrCCcZzwQOKy8NJZD4s17cBn3KiQbApBBGMeWKDCCeXEaRW0Sxcgr4bsWGeDjAANRxeSOk++e6KgtGceHCik/hwTn+anHSmuHkka1u5HcYDSybcDGO2KkwaJce7+AwgiQtuOBlifPPP70FEty0PhypLbKIcEhp3ndj9MDnNXdvq8MqNvikjkU42Abt3qCOCKmQ+z9qmDIzOR5cf3qdFFaWriOMRRuRwMjcfz5oKwrqN4m23iNopI+1lPxD5L/epcOkQ7xLeSPeSA5Hi/cX5L0H71t1PUY9NtvHlimdSwX7NMkep8hVDb3ZuYmeLUndk5kLZJA/5T0oOhvblrWNWjiMhJxgdhVXLrML6fM9yNm04GAcP8s9/MHpg1qtrv36Mu06ylDglc/selVmo3ypdmzk2SwuBvVVO5c989z3oD6lZyW7shZgm5zayYAJPGR+/HrUd9fZ7AQp4izK2B4mJAUPUZPP51Ej0XUbmQiC0kZQeHYbFI8+atLf2RlADX15HCPJBk/mcCggHW5BFFH4CYXIfB+8pGMen/ioFvaXV5JiytppRnhgOB8z0rs7fStDssHYLmQd5PtD+XSprX7bQsEQQDoW7fQUFJD7OXt1Ep1SaONl6Op3PjyJ6GrS1sdI03DQxiWUfjPxt/YVFv76O2QS3kjMCcDjj+1Vb+02nqPxcdsig6c6gzcrEoH+Zjn9KVyf/u3Txxh/zFKDtbe6WY7SpV8Zx2Nar24dGESHGRkmq/3xbWVX8N5XIO2OPG5sdTz2H9hWy9nWdoJLWdVEsZcNsDZAI8+B1oNStvXcVZT5P1qTZTPHKqbsoxxg9vlUYNKzFpXViQMYXGOOfpXxp4rceNcSLFFH8TOx4AoOgpVfpmsWGrJI9hcCURnDDBBH0NZ3N6YJhGsO8YyW3YxQZXt14C7Uj8WQ9EyAPqewqnhmhKeEtv7tMrHdEG3DH+IHyJP71lc3Ec++SCOSC4MsYfeAQwPHnjoD0rLI5yQB1OaD6AT0rOCYRM6uu6JxhhWKRWWoWxSJ4ZbhPiGWI2evHP1rABxxKqiQcMFORn0oJUtpiIzW7hlxkA1AtoHXLy7VkOSApyEzycfM81Y6fIVm8LPwsCcetZXsAR1aNfvHBAHegrgLi0tCltOcp8W1lUhvQ8eQrNPCLP7uPs3beFwQV3AHGPrUqTT5XiKsqMGGCpbFRbaRgP8AZ9qCNyNxG7fg84z2z36mg2spRtrqQfI19iiaaQIv1PkKkQ3CXcci3KKskPLbScY7Ed+x/Kt9hNbTRsbYMApwwZSp8+h5oI9/aMY193txL+Fk3AZHnzUGSOQgA7oZlwy5IJRh+9XssqRRtJIwVV6k1T6hIs0iFYQj7sLMeqk8AEd1PQ896DTHBJIWUxrumcsUXoM9f7/Wtk8RtZERTyqggjtUnST4uZsY+AceRNVHtjdy209hb27pE94/hmRzgIAR3+tBNu79/dGldN0lv9qNv4gPvD8ia5vV9Pjh8PUrBs28hDgr+A9c/L9qk2s1zZ6g2l6kwL4wrZznI457g1n7Nb1s5Y5vjtXkK4PRD/Y/vQWmmyrqEglDf75Q7Y7PjDD81/WvjXTaebq3cMrj7RcHGU7gfI/pitFpYppt1LC7sLS4UhHBwYmPH5ftgVHe2uNGm2XlxHc2kvVz95M8AkeVBYxXkd9ZkSf7RbSjDI/Uf2Ncrq+neBBJbysz2MjZjlIyYn7Z/Y+Y9RU3TnOnapLYyN9lLzGT38vzHH0q++AgrIiujDDKw4YeRoPOtE1KfRtTVZGIRWw2Dnj08/OvSLuS11OxDTosigbhj8Q8x61x/tP7LyRRf1DTFaa2AO5Ry8Y/kD/XnUP2b173Ui2uiWhJ4I6r6j+1BOingtbn3jTncgfegl4JX0Pf9xXUafew3VuRHIfAmG0+cZPf51xPtHH7jdpPbENby/GhU8fQ/Oo9jq0tnN7zCQ0L8SJ2+tB1FjqDQXMum6i+J4W2Bz+Lyz/Bq9DFGBRmVh3HauZ1eAazZpqmmfHdwLiSPvInkfUfqK16J7QrIiRXX3QMB+pHz8x60HaQtBM2JF8KY9JI/h3f9/nUrZcoBslWQf8A5F5/Mf2qoDqVBBDKRx5EVLtb4odkxynZz+H50G1hqAcsApBz8KuMD5ZFahLqioVe2Zv8wKk/lmp0weWDMEm1jyCveq9by5iYq5D46hlwf0oM1uruLO+1lceQjHH5VlFqMnPi2tx6YhatseoRNxIpjPmeRUtWVl3KQR5g0FObi6c523P0iYfxWZub4xMghn3EYDiPBX8+Kt6+UFHG2up9nHbxsjP/ALyeTLKvfgdT6U1LR5r9JQBDG0hDbmJYjH0qW2oS5IWALg87ia+f1Gb/AONPzNBW2fs7dwKyPqIaF1KvFsJUg/M8Gt9p7M21tIJBcXBfBHUAYP0qwTUVP+8iZflzW5Ly3b/iAfPighR6LYWkT+72gkJ5Ku5O78+K0tcm3yI7aC3x1O3GP2q5DKwyGBHoaxliimQrNGkidw6gigpTqEhBzdRjP+FlFR/Et2O6SeNj5tID/NS59G0GcEtBAue8bbP2NVFx7J6NIT4GozwN/wDzAwH5j+aDA65Zo7IUlG044UEfvWEut2rRkRNMr9j4YOPzNVt37JzIT7tr9qw7CRth/TNQD7LaqzAG/sWB6EXQ5oMNSvri4lIRZZl85iOvoBxVc/vLHloY/QEVexew94/xT6naRL1JDFv7VZ6Z7CQe9JNc3Tz2y87dmzxD+f3f3oOUt9L1W7j8W2ikmjzjciEjPzxSvZY4o4o1jiRURRhVUYAFKChaAW8rSeDNI7AZlVGkyPmO3pWq3ZWLESo5DHhV27SeTkdcnjNcFpk8Q0W5P9R1GC8gPiRJEGMYHrjpnzPSrhfbGGb3aSW0me4hgKzyKFzIeOfl3+tB1lUvtVo+oXmnJNAyCCENJIjttJAHB9e9Q9T1c33szNe2Jkh2yBHBOGA78j5iqnT/AGhFp7NXWnq8011dOVw/KxoRgkeZPlQSPYWVLa8nmWVvHdPDjiIwjd8s3p5V29zb2lvbsxE09zt+0eGT7Q9y2M9vl04xXA6VGYGtlG5WLgZUZOT5Cuut44SwVbdonh2ssmzawPP6+fJBzQb4RHczkqpZouV5zlT0YY4Pz+dbmXfbTNECWjOCXX4GIPK89T2+da7R7a3u4MMqRwqy/e5JOMLjqfOpM94t1bXkNxbbQiblG8HeM4Hbhsj9qCJPG7SwskSyBCxO5sDBUjB9OeR6Vut4XEaRLukKKFz54FZvILaNHeB53kPwRKQOB1JJ7VKj1KKWBxbRN7wi7vd3Gxj8ux+Y4oMre1khLTEBnCnagPf51ptr+d5HSaMo6PsdDjjoeCOvBFWUiu0LCJwjkfCxXIB+VUxNxDd/7aIw8h3J4anYSO2Tznj+1BeYqlkh92u5IUb7IqJFB/DknI+VW5lVYhI3AIBqLd29kyM91GjLIQNzDPPQY8utBXeCwu/F37Rs2FQPvc9zWaObe7SRSMGN948woyP1/c1pjj3SWc7oRceIiliOSvIIPoRya2vHa3t8wR2bavwoRhWHcqe445H8UGiJzb5nZElhnANwgXGSfxAeYz07/SpAjcQPNIw2KT8fTK5ODUhbd5WkRAU28eKR+L0Hf51rmuhbsLKGATxxIBLubBII6DsT35xQabSWWBFCwtCpUMgPKsvb5H061q9pdMXX9Dbw1xcw5eL/AJh1X6j+Kl3F0lxFGYiwXnKMMFSPOt2mSsWeLGVA3A+VB5TZ32mQ3ly88F60DR4hBlBZH8ye/NW41C5tdOa2S9hEUX2u2PJ8XdgkE+nlWj2s0q6sL69jidVsHYXQRnAyScHaOpIJPTtiqq1IntHtZmjgdELxsyndKD0Gf2oPQtF1SDV7EBjubGCD14/kf96rNd0+5hdblHMkSr4Y3dl8v1/10ritO1OfTPHEPDOBtP8AgYHhvyyPrXo2h6zb65YkOqiZRiaH+R6ftQcmspmstjMd8HxRknnaTyP2P51d2utztahmRZfBH2ydGx/jU/uKnXtrbNNtv7VpF2HbPGPi4PfHOQCO3rVZbafFJOk2jX0cjrz4cvDYzj6g/Kg6ewvIii3NrJ4ls/DDuh9R2NVOv+xVtqDG70x0tbk/EVx9m58+Oh+VQLuKfSp2uLISwo/wyR9h6Z6Y8u4qbp/tLNawoLiL3i2zgSpgOvoR0zQchfWV/Zp7nqdvJFn7jnlCfMHpVNFI1tMQwyOjDzr1o+0EDQrJLGJrWQ7SwXO0+TCuc9oPZiPUVN9oLRyA8tADg/8AT/ag57TtSl0u6jmgf7Ing5/Q1Z6vpa3kTa1ogxn4ri3Xqh7so8vMfWuWIntXeCeN0I4aNxgirDStYn0q4V4pC0f+E+VBO0j2iktmVJWzH3Qnj6eVdnY3sF9GXt84BwwPUVyOoWNlrate6SFivDzJbdpPMr6+neqSy1G5sJfgd1K8dcEen/ag9YtriS2wFXMf+Dy+XlU9lhvk3xnDjz6j0NcdpXtJb3UYF0Qj/wCMDg/Pyq9RwQJInyDyGU0G142RirjBFYRl4GLQsy+YHQ/SpHvCTx+FclkJHEicEVy+qTavoUviyytc2bH4Zcbl+vkaDr4dQHAnXaf8Q6VIkuokRXOWQ/iXkCuLsPaa3uDsuVCHsyAkfUdRV1DNHIhaCUMjdSrZBoJ19ZW2qIDHcNHMv3ZI2wR8x3rlr6TW9Ecm4Vri2H/FC71+vcVdyhthaNd7gcAtjP1qqb2rezmMF3E0ZHVHYH9xQa7T2ltZ8CVSnqp3D8utW0NxBcDMMqPnsDz+VUVyfZrV2LyRtZTHpLCNoPzHQ1XTezmoqd2mX9veqOgV9r/kf70HV3VrJL8UN1LA4GPhPwn5iq+VtetPijxcqP8AAMn8uDXMvfe0GmHFxHdxgcfGpx/IrOL2svfxPn/pU0GWq30k7A3Mb2kw7lGAP0P7iqozzk/BcQt9cVer7XyY2zRRuP8AMpFa5dX0m65n0u0J8xlT+goKQm8Y8GLPoRX1IdRkdUTLOxwqoRkn0FWtvp9hqs/g6fp0xk7+HMcL6kkYFd17O+zVtoy+KxE12wwZDzsHkP796CP7NezstlCs2qTvPOcERFspH/c104pWuaaOFN0jYHQetBtpVXJqEpbMaqq9g3JpQeYf1i6jn1G30UmOyu5CdrIM4PH047VFk0uaLTVupSogMvhgqAWLY6eeKnWt5LpqPf6eLcG2KqVfB+9novfp9Kh3Mt3qMrW00XhXBnMgBfw449wGfhPAzgHOaDC+1KSS0TTI7NbWKJyTGCSxbvnPet1hYmJRJNw56DyqzjttARoHa+mtCwHiiSIyFW74boRXbWfs3pESrKVNwMZDSPlT64HFBzWgaa2oXqAhvAiO55FOMHtg+ea6e6jtYUa2m97u3IGdmAV+owAaqbj2w0+CdbTTNjIG2YSPAY57HpX06raf1ae3a5+LjIbJAfvhuw6cGgsIfGVvCZmlOxXRyuGZTnGR2PBzWVxbiJopZY/tXOyPPTIBPPl3rkPaufVNM1iIW80sCyorp4ROWboc+Zz2qXp3tdJNbTW+vwfDFg+KvwSbsjGF7t34xQdE9zPMqwyNAJ4pl2+HxuQjLAjJIwO/yraYJpp0VB8JRl3cfDkYJ8+nQDv1rOwksNVga70yUMCdrErgg+R71hdWYyBcxbh2O44oLmNPDgWNCfhXaC3J4GOarvd7y5eD3tUUQ8ttbO5sYyB9T8s1hYXTWzPbXEmYo4zIkjnkKDyCe+MjnyrTeTpdIJpGmhjH3QWKFecA4B69OtBv1EymZIlnVQRuSPaecefn8qwkuTPZ24ZxHJvIKLyHCnBPy44PnWMs7yLAjTB5IkxME5G/A7+fX860xQpCPhHJ4yTk48vlQatQ9zijN1fOVjRcHLkKfoOtRNL1qx1O9WGBJUaFhIhbjOPLHp28qi+2FtLc6OHhy3gOJHUd1wRn6Vyuh6gdOd7mMoJVBHxDIAI64oO71XW4U1T3cSTKsZ2mVJMBG89vQ+uasLYPd3gZ1VWEQErKPhYgnBH0/LNcBppt9UujCb+GBmPWYkbifLzNXGtaje6Xq6WFvPJEsMSlCP8AicdT50HUz2s8W4lkkUd1GGA9RWyzuwjCJkVVboy+frUDTNQF9dwXJ+F5I1DqOgIJB+nSpc9sy3JjXAV8lD288UGHtFott7QaeYQ6ieIkxSA52t5H0NeTSwXum3QkuYyHgl8Mhzkbl7fLGPpXq1rMYJd69PxDzFc3/wCoOjmZY9atF3rt2z7R2/C38H6UHI6pHG4ju4HRhMu51QYCMfw4qPpl3PZ3sc9tJ4cqng9j6H0NY20wG6GT7jefY1rmhaF/Q9DQel299F7Q6dm32R3Ef+9jcZZD/lPbkcGowgFw3jXb/bRj4hcrsxzzhl/jzri7G9nhuEurSXw7tOD5OPXzrutO1HT9eXw7mIR3irhomPPHOV8xQZKBbb5BI8SjkAn3kEdB6gYrOEW9yrbbRXLDEhtztzz3U9fOpX9Ot1ztjWKcklJF45I8v4qJLYaiEEeIbrapJlkOxicAgDHIGc0GiOxjhnMdtcBvFGGtrkbC48gfPyrQ1lqWmzvJbJMYgeDt3Aj1ArO51GaISxzvc28iZ3q6iVF6YIOAe/Y54rCGeO2a4Ekq206Nk+DIyMT34OV5z+1Bveex1uNbfUYFEw4Afg/9LdR8qpL/ANjJVJfT5t4/+OXg/n0NXE+pNMkRLLMqsNzTwKxxnrlT/FTLC7iu5I1SSGJm3ApFJnp/lYZoPPZrLU9LfM1vLEPPGVP1HFa55hfv4sjYnI5Y/i+Z869ZMEuMCRGHkydfyNV9zoFjd5M9jblj+KMlD+YoPLlaW3k4JVhV7pPtFNZsFJGw9Ub7p/tV7c+xNu/MEk8XoSrj+DVVN7F3qyIkUyOGPVlKhfU9aDprXXbKZVLloie55X8xVurfZsmFkicYZGG5WFeff0O80+2d5pH8fcVjijjLq2COSewOePlSy1m+sHAeOWJR+FlO0/Q/xQW2teykb5uNIJifqbdjx/0t/BrmYb++024KSeJFKhwQeGFdlbe1NlPhWVg3cJ8X6da+aukWsW8UMFi880ufDdoyrIBjJB+o9KCvsPazDYusOp8gFYfwas7jUdB1KAJdlWU9A6HK/IiuXXSC95HYrAFuHfwwr8YPrUjUdJk0e4a2dR03K4Bw4oN0/ssswmudFv0NvEu5zK+AvpkfyKrtJib3pTf3slrCqltyLuYnyGOn1qXaaRqkmmtqLxk2pyfhbkqD1I7is9J02TVdT9295WFQhckjPT/zQWVj7TXFvOkS3DSWjnBe5j+KMfJfvceWKlPe6Ve3dtaxwRajJMxRnlt1jUE9CDgHjv1rmLqM2s8sWVYxuV3L0bnr8qtNN0K/1N45IEMMQ58aQYH07n6UErVtH0awu/CMHvM7kZgh3RhQemDk8+nP0qVpnsbbXQjuLq1ktEznwhOWZx65A2/v8q6XStDtdNJlBee5b708pyx+XlVpQaLS0trKBYLWBIYx+FBivs1zDBw7gN/hHJr5dzRQwM0s6QgjAdiBiud/qOmKSpv1JHVhGxz+lBbSai7kiJNi+bDJ/Kuav/aSGCQh1dm85SV/SrBNU0dSN93I3/LEwqUus6EFI3hv+aIkn8xQcufayLP3IvzaldI2p+zmf9zCfX3Yf2pQeTS2VzC5WWB1YYByOmRkc+orpWuIdO0x7GEQ3IlCO8wiO/dgZUZ8j3qhsLmc4tBKwt2cSMnYsBwane/3mn6hBLYHE2CFG3dnPGMd6DW7x3cqCArYvFFsnM0uN5JwSB24PSuuh9rLWzt5FgikuIQMZI2r9AetcFdJdSXztdpIJ5JDvLqQS2eau7m1itG0tWminiuMF448MV5xggnHf0oIt/psIu4HsZt0FynjKCOYxnGD/rtW5FcZtbCAzTbGYqPIDkmt0Uc8p1C5nkjVbU+GEJVSFBOAoHBx6VTyhoHmSdJRdOF8MpIMAHrnHXIPTPzoLa81RtavbBFa6CWtuqRsgG7xQOWx5ZA9cCtcsieJuv52lkkcu7vkgMepwOnSvpSfRYyDugu48HHRgTUSzivLmwujFdosLSIJoS/xP5NjuAaC5tfaj+jWEttpwSSaSTduxlEAwMjuSf0rtvZvWk9oNNd3iEcqHZKg6ZxwR6V5kYLO12rL8bnzP+sV3fsotvpNhLNPJEhumDJFG/iNgDrhc0Em5jdmMMgUMAyM5JztOM4HrjrUkRSXEZAgMqHgjHB/OraOWGeEThfhweXXBGKhQaxA9z4EsTwBv927EbW9OOh9DQQjthIjaMxY6LjH5Vs2SsNyxyEeYUmuO1PX9T0X2suy0xuIN+4Qu2UKEZGPI+orvNG1m01mzFxascjh42+8h8j/AHoMLa0eUkyqyR47jBNcfrvsNdPqJl0gRe7S8lHfb4Z7j5V3/vdsZPCFxF4hJAXeM5HUfOuK1L21uNL1R7aa3SfYcSIo2bD2APOeKDkdc9nr7Q2i962Oko+F4ySufLnvUnVNViu9K0cvJ4moQKyyMOyA4UN616Hdaha31pa74IprO6i8UiYduMD581zXtJ7N6bPpr3mhJGklqN00SE8r8j0I/UZoLXQCgsLe7iQNbxj7UocurdScdx+vzrXrWq3+layJFlaS0lUOicbcd8f671z/ALKB9Q0e/wBLjkKzhlmiGcb8cEVhquoSn2ftIp3DzW9w0agn4tm0Yz+1B2GnvFqCl4JBkjIB8+4PlVrYo6pLDKvw56HB+YrznQ9U92uop42wjEBx5V2axStmWNWODksvagqdf9g4Lkvc6QywSnkwN9wn0P4f2+VcCwktpXs7+JkKHaysOVNe02N34o2SMPEAyD/iFVvtH7MWeupvY+DdquEmUfow7ig8jmtniO+M7k6gitkN3kr4rMrocpKpwympeo6dqHs/d+BeR/AfusOUceYNRmhiugWgO1+6mg67SPab4RbawQVPC3I6N/zeXzro/toY1a1fxYsZwRuPnkHvXk6STWj7SDjup6GrzSNcuLE4s2DxdWtpDx/0ntQd2t/KygiOKRD5MR/BrCRrKWTxJrEF+Du2qTxVda6xp2pPiKX3S8PWOYY3H9j8xzUtmZHEcqFHPQdj8j3oMXg0aNzOYQhIKkKhHXjOP9YralnaGZGivGynRRKD3GDzz/5rDf61j8LfeVT8xmguefKvuapwqdlx/wApI/aswWByJZh//UNBbZNfM1VDcsjyLNKGfG74s5x061sEs/8A/EN9VX+1BZZPmaE54PPzqt8W5HS4H1jFY+PeCQN48ZABBUxcH160E+SztZc+JbQvnrlBzVHc6deadfm+0aCJMrs2Rrnj1B88DpVj71ddvB/+rf3r499cRkCT3Vc9ASwJ+lBXavpks7PqcskVnMoDsyux2/kOvqPKtT2tzrRD3AnXaAFfw1IwB5nk59eavEk1CZcJZK6kdWBVT/8AapCwXcduHv7iNMcbbdeT9T/AoOcjnfT7V9N99SeJuFhaLcRzyBz/AAa36dod2JJJrSJrN2PwyTYO0ei8k/WreKe0s2d4LaGKRzlpGb4mPqetH1fdn/aol+TAUGVj7NWNs/jXG68uCdzSz88+e3pVpJcwQ8NIM+Q5Nczca3ZIftr4N/1Fv2qvuPaSyjUmFXl9egoOql1TqIYvq5/ioxv7onmQD5AVwt17VzvxCojH+Vcn8zUMe0t4GyZ5v0oLLXdSk98c329XHCrz09KpzqcJ/wAYqxb2jtruIQ6jaxXKf5lwR9aiPb+z1wSY5rm1J7ZDgfzQahqMB/4hH0NZi+g/+esW0SyZS0Osw4//ACRMv7ZqbZexlzfRGW3vI5VA4KowB+ROBQRvf4P/AJAaVcxf+nV4UBm1CBH7qqMwH14pQcbYOEu0J6dKsdahntpIXdJIZAMjIIPmDUK8tmgfxU+6T+Rq6Mn9U05maGWaWNcyzmUnA6KMdgDQVc7MdSiEkkj/AHWPiS+JyQCTkef/AJqVre6aGO5knSWV+CoGGQDgZ4xVTBIbe4D7EYrn4XXI/KrsGK40+RXkcM4XaoGVbzye2KI+2skK2M1pbeHNFIwbxniw4OOQPIZ/aq46dJbCznv1eK0uScOgydoOCQPOlg5hne3c9Tx86sb29u5ghvUa9srWMgRs20R5+EHI564orK+fOiTRpcFmeUMyNHklVHB3fxUHSEXw5JcZYcCsrGdZLbwn5ZRjB7isLFvAnmgPGTlfWiIUnis4d1bMnKkj73y867r2cgMGlxIYfDlcksNuGPPFcnBrGpaVJJBa3BRAxYKyKwGe4yDj6VY6P7V6vDqUUs8kl3CWCvGEHIPlgcGivRDvTTRAhLPnEipguAT0AyKoL7UtLt49t5cxB92BCm4uhB/4g+gPQennVL7Ua9c/+43j0u4V4wEXaqghn7g+vaqr2tVU1tvjUymNfFVTna4GCP2oN2vaHqltO15cN71HJ8XipzwenA6D5cVeewMU0N212bd7a093KySyMdsrBsgjPkM9Knex4vbr2ZkWZS3hsRZljgtx0z5Z4/8AFSYIWhkZS0ZYfC+1cFT5dTQcz7S6jd2EttbQ4jDJ4xygJJLEjr08613trqHtSljc21lIbl1ZZZCoVGAIAbdnn/XWuquPZS21qeO6vLidVRNipHgZGc9frVnc6fNZackGmiV2DIjYcK3hjjAPAGP70ESTTBaLax+8NIYlUBG5IAGMA9AM1zd+2t6brHvlm81zbuSzQDJG0dVZfLHer57VjlryFARgKjvub5kdP1zVjp0UMhCHcssTb0O7PHp6elB5hY3U0WsveaPaTrGr7ljUFyg8jgdOv0rf7QuNQL6jarthcjxoscxOfP0J6Hz4Nem3eoQ2ExijjQE/ExztGT/NQLmxiur+PUbOJZN4MV3bnH2iHqfUj9aDy3T2IkdfNa7se0Eum30UQIeJoIzIh5wSOorl77QtQ027uZlsLkWSO22Qp0TPBP0quu9QafU5LrAAOFCjOAoAAH5Cg9RlmE+Jgi7W/Ev3TWyC7ltz8DZXupORXL6B7RLZxeBcr41m47clam6XqlveXLwXAFuZD9i+cgf5W/vQda8dnq1o0VxCk0TfejcZwf8AXeuP1b/0+jJM2jXBhfr4UpyPo3UfXNXzxXWnsJlKkZwcHg+hq1gvEntmmRSWUfFGOufKg8iv9P1LTyY9VsJNg6SKu5T9RxVf7tDIc28+G/wnrXtFvqVtPgEmNj2fofrXzULXTXt2N9awvEeDuiB6/rQeMsZ1G24iEyjv3qRFqU0cZih1C4iT/A53KPlnpXfv7F6XcZlsby4hQ9FVg6j8+f1qO3sFDJwdS3H1gGf0NBy0WuaoqgCS2nAGMkcmsz7RaqvWzg+gP96vn/8ATiMnK6mU+UP/AP1UV/Yu3glMTa66kHB+wOB+tBSt7S6vnPgxKPLwz/epMPtbMBieyVj5oxH6Guhh9hYyob+sSup7rEvP61Oi9jtOiwJLq5c/8yr/ABQco3tXM3EOnc/5nJ/YVFbXNduJNsC7SeiRRZP8mvRoPZ3Sof8A9qJD5ysW/wC1WkEEMC7YYY4h5IoX9qDzuztvbS6QYgWJf8U6Kh/Lr+lWkXsvr0/N/rohH+GBf54rspZUhjaSQ4UdTVBc3MlzIWckL+FPKgWnsxZW+Dc6heXTd/EuCo/IYq3t7fT7QfYJBEfMYyfr1qhwvkKYHkKDpxLEekiH/qFR7q1F0VYTFdo6dRXP7R5U6dMj5UFb7R6PqEVw9zb2rXUbAZ8Hkggdx1rkJbu4jcrJZyIfJlIP7V6GHYdGb86zE8wORK//ANqDy/wZJjkW1yfkpb+KC2uYzlUuU+cTCvWItTuI+GIkHrwalLrCfiikHyOaDyFYtQc4SOeT5Qsf4rcmja3c8Lpt23zhI/evWTq8faKQ/Mitb6tIfuQr/wBTUHmkPsdr8xH+wGMecjqv81b2f/p5dNhtQvoYV7iIFz+ZwK6x7+6fo6oP8q1Hdnl/3kjP8zQYWOhez2kEMsXvMw/HL8Z+g6CrKTVjjEEQA7Fv7VWbcVkF4oNzahes2fGI9AopWkilBxbRJIhVxlT1FVdmTHcNGv3ScYpSiMNSiRZA68FhzW7SiWRkJ4HIpSgx1OFUdZFyGPepOxZtP3SDJK5zSlBUW5KSqynB3Yqy1BAqpMvDhsZFKUGGqxp4McuPjJwT6YqDBdXECPHDPLGkgG9UcgN88UpRWnJ35B5r6xJOScmlKCRDdXETRNHPIpiO6PDH4T6eVevagFKQXAVRLKo3kDrwD/NKUGvWi4gtYFdliZcsqnG7joT1xWOi70vQollKMpBRnLDzzz0pSgmWlhayrLPPEJpJWYMX546YHpUDTl8K6RFZiEmZBk5OAxH7UpQbtWhRrp1IOJEG4Z61HQmNlKHaR0I7UpQdBC3jWqmQBty/EMcGvFvaK0hsdcvba3BWKOUhQT0HXH60pQQYpHj+6xHpV9bHfGrNjJpSg7L2cuZrmwvbady8cKBkz1HXjPlxU22doZkZDgkgH1FKUGWoxJHdMqLgMASPnS3kcyrasd0MgIKtzj5UpQaYi0TFonZGweVPWtWxSSe5PWlKCRbXdxFcRIJWZGcKVbnit+qxILrcBywyfn0pSggK7wPmGRk+Rr5K7TvvmYs3TJpSg2LNNGoCSuo8ga2rdXAHE7/nSlBi80sxHiyM2PM1rIpSgYpSlB8619xSlB8xzXylKAK+4pSgU70pQfTX0DilKD5jivtKUGJ60pSg/9k=]],
["Bloom"] = [[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]],
["Topo"] = [[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]],
["Blood"] = [[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]],
["Gaze"] = [[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]],
} local BG_RESOLVED = { None = "" } local function b64decode(data) local decoders = { function() return crypt.base64decode(data) end, function() return crypt.base64.decode(data) end, function() return base64_decode(data) end, function() return syn.crypt.base64.decode(data) end, function() local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'; data = data:gsub('[^'..b..'=]','') return (data:gsub('.', function(x) if x=='=' then return '' end local r,f='', (b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end return r
end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if #x~=8 then return '' end local c=0 for i=1,8 do c=c + (x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end, } for _, fn in ipairs(decoders) do local ok, res = pcall(fn) if ok and type(res)=='string' and #res > 0 then return res end end return nil end local function ensureBgAssets() local gca = getcustomasset or getsynasset or nil; local wf = writefile or (syn and syn.writefile) or nil if not gca or not wf then return end for name, b64 in pairs(BG_EMBED) do local fileName = "VersincBG_" .. name .. ".jpg"
local okWrite = pcall(function() local bin = b64decode(b64) if not bin then return end wf(fileName, bin) end) if okWrite then local okPath, path = pcall(gca, fileName) if okPath and type(path)=='string' then BG_RESOLVED[name] = path end end end end pcall(ensureBgAssets) local BG_PRESETS = { { name = "BG1", id = "rbxassetid://100137217709081" }, { name = "VX7", id = "rbxassetid://116587787334634" }, { name = "BG2", id = "rbxassetid://86316992692761" }, } local function resolveBgId(key)
if not key or key == "" or key == "None" then return "" end if type(key)=="string" and (key:find("rbxasset", 1, true) or key:find("rbxthumb", 1, true) or key:find("http", 1, true)) then return key end return BG_RESOLVED[key] or "" end local currentThemeName = "RED"; S.currentThemeName = currentThemeName; S.themeColor = Color3.fromRGB(255, 0, 0); local currentBgId = ""; S.currentBgId = ""; S.bgIntensity = 1 local bgAsset, bgVeil local themeAccentStrokes = {}; local themeAccentFrames = {} local function applyBackground(imageId, skipSave)
currentBgId = imageId or ""; S.currentBgId = currentBgId; local resolved = resolveBgId(currentBgId) if bgAsset then if resolved == "" then bgAsset.Image = ""; bgAsset.ImageTransparency = 1 if bgVeil then bgVeil.BackgroundTransparency = 0.55 end else bgAsset.Image = resolved; bgAsset.ImageTransparency = 0; bgAsset.ImageColor3 = Color3.new(1, 1, 1) if bgVeil then bgVeil.BackgroundTransparency = 1 end end bgAsset.ZIndex = 0; bgAsset.Visible = true end if not skipSave then pcall(function() if F and F.saveConfig then F.saveConfig() end end) end end
_G._VersincApplyBackground = function(imageId, skipSave) applyBackground(imageId, skipSave) end local function applyThemeColor(col, name) if name then currentThemeName = name; S.currentThemeName = name end S.themeColor = col pcall(function() if K7 and K7.updateHeadIndicatorTheme then K7.updateHeadIndicatorTheme() end end) COLORS.stroke = col COLORS.accent = col; COLORS.on = col; COLORS.accentStrong = col; COLORS.strokeSoft = Color3.new(col.R * 0.45 + 0.12, col.G * 0.45 + 0.12, col.B * 0.45 + 0.12) for _, s in ipairs(themeAccentStrokes) do
if s and s.Parent then pcall(function() s.Color = col end) end end if S._mainTryhardBorder and S._mainTryhardBorder.Parent then pcall(function() S._mainTryhardBorder.Color = col end) end if main then for _, d in ipairs(main:GetDescendants()) do if d:IsA("UIStroke") then if d:GetAttribute("ThemeAccent") or d:GetAttribute("ThemeStroke") then d.Color = col end elseif d:IsA("TextButton") then local isHubBtn = d:GetAttribute("ThemeButton") or d.Name == "KeybindButton" or d.Name:find("Btn") or d.Name:find("Button") or d.Name == "PickerPrev" or d.Name == "PickerNext" or d.Name == "PickerValue"
if isHubBtn and d.BackgroundTransparency < 1 then d.BackgroundColor3 = col; d.BackgroundTransparency = math.max(d.BackgroundTransparency, 0.5); local st = d:FindFirstChildOfClass("UIStroke") if st then st.Color = col end end elseif d:IsA("TextBox") then if d.BackgroundTransparency < 1 then local st = d:FindFirstChildOfClass("UIStroke") if st then st.Color = col end end elseif d:IsA("Frame") then if d:GetAttribute("ThemePillOn") then d.BackgroundColor3 = col; d.BackgroundTransparency = 0.22 end end end end pcall(function() if _G._VersincApplyMobileTheme then _G._VersincApplyMobileTheme(col) end
end) pcall(function() if PlayerESP and PlayerESP.playerData then for _, d in pairs(PlayerESP.playerData) do if d.highlight then d.highlight.FillColor = col; d.highlight.OutlineColor = col end if d.billboard then local lbl = d.billboard:FindFirstChildWhichIsA("TextLabel") if lbl then lbl.TextColor3 = col end end end end if TracerESP and TracerESP.drawings then for _, d in pairs(TracerESP.drawings) do if d.line then d.line.BackgroundColor3 = col end end end local legacy = workspace:FindFirstChild("VersincTracers") if legacy then for _, ch in ipairs(legacy:GetDescendants()) do
if ch:IsA("Beam") then ch.Color = ColorSequence.new(col) end end end end) end _G._VersincApplyTheme = function(themeName) for _, preset in ipairs(THEME_PRESETS) do if preset.name == themeName then applyThemeColor(preset.color, preset.name) return end end end local function corner(parent, radius) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 8); c.Parent = parent return c end local function stroke(parent, color, thickness, transparency)
local s = Instance.new("UIStroke"); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Color = color or COLORS.stroke; s.Thickness = thickness or 1; s.Transparency = transparency or 0.55; s.Parent = parent if color == nil or color == COLORS.stroke or color == COLORS.accent then s:SetAttribute("ThemeAccent", true); table.insert(themeAccentStrokes, s) end return s end for _,name in ipairs({"CrystalVSHub","CursedHub"}) do local old = game:GetService("CoreGui"):FindFirstChild(name) if old then old:Destroy() end local pg = LP:FindFirstChild("PlayerGui")
if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end end local gui = Instance.new("ScreenGui"); gui.Name = "CrystalVSHub"; gui.ResetOnSpawn = false; gui.DisplayOrder = 10; gui.IgnoreGuiInset = true; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling pcall(function() if type(syn) == "table" and type(syn.protect_gui) == "function" then syn.protect_gui(gui) elseif type(protect_gui) == "function" then protect_gui(gui) elseif type(protectgui) == "function" then protectgui(gui) end end) local parented = false pcall(function() if type(gethui) == "function" then
gui.Parent = gethui(); parented = gui.Parent ~= nil end end) if not parented then pcall(function() local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 8) if pg then gui.Parent = pg; parented = gui.Parent ~= nil end end) end if not parented then pcall(function() gui.Parent = game:GetService("CoreGui") parented = gui.Parent ~= nil end) end if not parented then warn("[snow.vs] Failed to parent ScreenGui") end
local FULL_SIZE = UDim2.new(0, 356, 0, 536); local main = Instance.new("Frame"); main.Name = "Main"; main.AnchorPoint = Vector2.new(0, 0); main.Size = FULL_SIZE; main.Position = UDim2.new(0, 20, 0, 20) do local isMob = false pcall(function() isMob = UIS.TouchEnabled and not UIS.KeyboardEnabled end) local cam = workspace.CurrentCamera local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) if vp.X < 700 or vp.Y < 500 then isMob = true end if isMob then
main.AnchorPoint = Vector2.new(0.5, 0.5); main.Position = UDim2.new(0.5, 0, 0.5, 0); local sc = Instance.new("UIScale"); sc.Name = "MobileHubScale"; sc.Scale = math.clamp(math.min(vp.X / 400, vp.Y / 620), 0.72, 0.92); sc.Parent = main end end main.BackgroundColor3 = COLORS.bg; main.BackgroundTransparency = 0.32; main.BorderSizePixel = 0; main.Active = true; main.ClipsDescendants = true; main.Parent = gui; corner(main, 16); local mainBorder = stroke(main, COLORS.stroke, 2.2, 0.15); mainBorder.Name = "TryhardBorder"; mainBorder:SetAttribute("ThemeAccent", true)
mainBorder:SetAttribute("TryhardBorder", true); S._mainTryhardBorder = mainBorder task.spawn(function() local t0 = tick() while main and main.Parent and mainBorder and mainBorder.Parent do local t = tick() - t0; local pulse = 0.5 + 0.5 * math.sin(t * 3.2); local pulse2 = 0.5 + 0.5 * math.sin(t * 5.1 + 1.2); local col = S.themeColor or COLORS.stroke; local boost = 0.12 * pulse2 pcall(function() mainBorder.Color = Color3.new( math.clamp(col.R + boost, 0, 1), math.clamp(col.G + boost, 0, 1), math.clamp(col.B + boost, 0, 1) ) mainBorder.Thickness = 1.6 + pulse * 1.8
mainBorder.Transparency = 0.08 + (1 - pulse) * 0.35 end) task.wait(0.03) end end) bgAsset = Instance.new("ImageLabel")
bgAsset.Name = "BackgroundAsset"; bgAsset.Size = UDim2.new(1, 0, 1, 0); bgAsset.BackgroundTransparency = 1; bgAsset.Image = ""; bgAsset.ImageTransparency = 1; bgAsset.ScaleType = Enum.ScaleType.Crop; bgAsset.ZIndex = 0; bgAsset.Parent = main; corner(bgAsset, 16); bgVeil = Instance.new("Frame"); bgVeil.Name = "BackgroundVeil"; bgVeil.Size = UDim2.new(1, 0, 1, 0); bgVeil.BackgroundColor3 = Color3.fromRGB(8, 8, 10); bgVeil.BackgroundTransparency = 0.55; bgVeil.BorderSizePixel = 0; bgVeil.ZIndex = 1; bgVeil.Parent = main; corner(bgVeil, 16); local guiScale = 1.0; local uiScaleObj = Instance.new("UIScale"); uiScaleObj.Scale = guiScale; uiScaleObj.Parent = main
local function applyProgressBarScale(n) S.progressBarScale = math.clamp(math.floor((tonumber(n) or 100) + 0.5), 50, 200); local pb = _G.__VersincProgressBarScaleObj if pb then pb.Scale = (S.progressBarScale / 100) end if _G.__VersincProgressBarSizeLbl then _G.__VersincProgressBarSizeLbl.Text = tostring(S.progressBarScale) .. "%" end end _G._VersincApplyProgressBarScale = applyProgressBarScale local function applyGuiScale(v) v = math.clamp(tonumber(v) or 1, 0.6, 1.6); guiScale = math.floor(v * 100 + 0.5) / 100; uiScaleObj.Scale = guiScale; S.uiScaleValue = math.floor(guiScale * 100 + 0.5)
pcall(function() if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale or 100) end end) if UI.guiScaleLbl then UI.guiScaleLbl.Text = string.format("%.0f%%", guiScale * 100) end pcall(F.saveConfig) return guiScale end _G._VersincApplyGuiScale = applyGuiScale _G._VersincGetGuiScale = function() return guiScale end local function _packPos(p) return { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset } end local function _unpackPos(t) if type(t) ~= "table" then return nil end
return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0) end _G._VersincSetHubPos = function(hub, mini) local a = _unpackPos(hub) if a and main then main.Position = a end local b = _unpackPos(mini) if b and _G.__VersincMiniBtn then _G.__VersincMiniBtn.Position = b end end do local dn, ds, sp, di = false main.InputBegan:Connect(function(i) if S.guiLocked == true then return end if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dn = true; ds = i.Position; sp = main.Position
i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then if dn then dn = false; S.hubPos = _packPos(main.Position) pcall(function() F.saveConfig(true) end) end end end) end end) main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end) UIS.InputChanged:Connect(function(i) if i == di and dn then if S.guiLocked == true then dn = false; return end main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y))
end end) end local miniBtn = Instance.new("Frame")
miniBtn.Name = "CrystalMini"
miniBtn.Active = true
miniBtn.Size = UDim2.new(0, 215, 0, 52)
miniBtn.Position = UDim2.new(0, 20, 0, 70)
miniBtn.BackgroundColor3 = Color3.fromRGB(15, 25, 45)
miniBtn.BackgroundTransparency = 0.08
miniBtn.BorderSizePixel = 0
miniBtn.Visible = false
miniBtn.ZIndex = 20
miniBtn.Parent = gui
corner(miniBtn, 16)
stroke(miniBtn, Color3.fromRGB(255, 0, 0), 1.8, 0)

local miniUIScale = Instance.new("UIScale", miniBtn)
miniUIScale.Name = "MiniScale"
miniUIScale.Scale = S.miniUiScale or 1.00
_G.__VersincMiniScaleObj = miniUIScale

local miniBar = Instance.new("Frame", miniBtn)
miniBar.Name = "AccentBar"
miniBar.Size = UDim2.new(0, 4, 0, 26)
miniBar.Position = UDim2.new(0, 7, 0.5, -13)
miniBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
miniBar.BorderSizePixel = 0
miniBar.ZIndex = 21
corner(miniBar, 3)

local miniBadge = Instance.new("Frame", miniBtn)
miniBadge.Name = "Badge"
miniBadge.Size = UDim2.new(0, 38, 0, 38)
miniBadge.Position = UDim2.new(0, 17, 0.5, -19)
miniBadge.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
miniBadge.BorderSizePixel = 0
miniBadge.ZIndex = 21
corner(miniBadge, 10)

local badgeTxt = Instance.new("TextLabel", miniBadge)
badgeTxt.Size = UDim2.new(1, 0, 1, 0)
badgeTxt.BackgroundTransparency = 1
badgeTxt.Text = "anos.vs"
badgeTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
badgeTxt.Font = Enum.Font.GothamBlack
badgeTxt.TextSize = 9
badgeTxt.ZIndex = 22

local miniTitle = Instance.new("TextLabel", miniBtn)
miniTitle.Size = UDim2.new(0, 95, 0, 16)
miniTitle.Position = UDim2.new(0, 62, 0, 10)
miniTitle.BackgroundTransparency = 1
miniTitle.Text = "snow.vs"
miniTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
miniTitle.Font = Enum.Font.GothamBlack
miniTitle.TextSize = 11
miniTitle.TextXAlignment = Enum.TextXAlignment.Left
miniTitle.ZIndex = 21

local miniSub = Instance.new("TextLabel", miniBtn)
miniSub.Size = UDim2.new(0, 95, 0, 14)
miniSub.Position = UDim2.new(0, 62, 0, 26)
miniSub.BackgroundTransparency = 1
miniSub.Text = "TAP TO OPEN"
miniSub.TextColor3 = Color3.fromRGB(255, 255, 255)
miniSub.Font = Enum.Font.GothamBold
miniSub.TextSize = 8
miniSub.TextXAlignment = Enum.TextXAlignment.Left
miniSub.ZIndex = 21

local openBtn = Instance.new("TextButton", miniBtn)
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(0, 44, 0, 34)
openBtn.Position = UDim2.new(1, -50, 0.5, -17)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
openBtn.BackgroundTransparency = 0.2
openBtn.BorderSizePixel = 0
openBtn.Text = "OPEN"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 9
openBtn.ZIndex = 22
corner(openBtn, 10)
stroke(openBtn, Color3.fromRGB(255, 0, 0), 1, 0.5)

miniBtn.MouseEnter:Connect(function() TS:Create(miniBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(40, 0, 0) }):Play() end) miniBtn.MouseLeave:Connect(function() TS:Create(miniBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(15, 25, 45) }):Play() end) _G.__VersincMiniBtn = miniBtn if type(S.miniPos) == "table" then pcall(function() miniBtn.Position = _unpackPos(S.miniPos) or miniBtn.Position end) end do local dn, ds, sp = false miniBtn.InputBegan:Connect(function(i) if S.guiLocked == true then return end
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dn = true; ds = i.Position; sp = miniBtn.Position i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End and dn then dn = false; S.miniPos = _packPos(miniBtn.Position) pcall(function() F.saveConfig(true) end) end end) end end) UIS.InputChanged:Connect(function(i) if dn and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then if S.guiLocked == true then dn = false; return end
miniBtn.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y)) end end) end local mainUIScale = main:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", main) local function _targetScale() local v = (_G._VersincGetGuiScale and _G._VersincGetGuiScale()) or ((tonumber(S.uiScaleValue) or 100) / 100) return math.clamp(tonumber(v) or 1, 0.5, 1.5) end local function showGui() if not main then return end
main.Visible = true; main.BackgroundTransparency = 0; mainUIScale.Scale = 0.85; TS:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = _targetScale() }):Play(); miniBtn.Visible = false pcall(function() local pg = LP:FindFirstChild("PlayerGui") local g = pg and pg:FindFirstChild("VersincMobileButtons") if g then g.Enabled = not (S.hideMobileButtons == true) end end) end local function hideGui() if not main then return end TS:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 0.85 }):Play()
task.delay(0.2, function() if main then main.Visible = false end if miniBtn then miniBtn.Visible = true end end) pcall(function() if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) end openBtn.MouseButton1Click:Connect(showGui); local avatarBg = Instance.new("Frame"); avatarBg.Size = UDim2.new(0, 36, 0, 36); avatarBg.Position = UDim2.new(0, 14, 0, 16); avatarBg.BackgroundColor3 = Color3.fromRGB(22, 22, 24); avatarBg.BorderSizePixel = 0
avatarBg.ZIndex = 6; avatarBg.Parent = main; corner(avatarBg, 18); stroke(avatarBg, COLORS.stroke, 1.4, 0.35); local avatarImg = Instance.new("ImageLabel"); avatarImg.Size = UDim2.new(1, -4, 1, -4); avatarImg.Position = UDim2.new(0, 2, 0, 2); avatarImg.BackgroundTransparency = 1; avatarImg.Image = ""; avatarImg.ScaleType = Enum.ScaleType.Crop; avatarImg.ZIndex = 7; avatarImg.Parent = avatarBg; corner(avatarImg, 16) task.spawn(function() local ok, thumb = pcall(function() return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
if ok and thumb then avatarImg.Image = thumb end end) LP.CharacterAdded:Connect(function() task.spawn(function() local ok, thumb = pcall(function() return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end) if ok and thumb then avatarImg.Image = thumb end end) end) local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1; title.Size = UDim2.new(1, -100, 0, 18); title.Position = UDim2.new(0, 58, 0, 14); title.Text = "snow.vs"; title.TextColor3 = COLORS.white; title.Font = Enum.Font.GothamBlack; title.TextSize = 15; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 6; title.Parent = main; local subTitle = Instance.new("TextLabel"); subTitle.BackgroundTransparency = 1; subTitle.Size = UDim2.new(1, -100, 0, 14); subTitle.Position = UDim2.new(0, 58, 0, 34); subTitle.Text = "duels"; subTitle.TextColor3 = COLORS.textDim; subTitle.Font = Enum.Font.GothamMedium; subTitle.TextSize = 11; subTitle.TextXAlignment = Enum.TextXAlignment.Left; subTitle.ZIndex = 6; subTitle.Parent = main; local statsLbl = Instance.new("TextLabel"); statsLbl.Name = "FpsPingStats"; statsLbl.BackgroundTransparency = 1; statsLbl.Size = UDim2.new(0, 110, 0, 28); statsLbl.Position = UDim2.new(1, -150, 0, 16)
statsLbl.Text = "FPS --  ·  -- ms" statsLbl.TextColor3 = COLORS.textDim; statsLbl.Font = Enum.Font.GothamBold; statsLbl.TextSize = 11; statsLbl.TextXAlignment = Enum.TextXAlignment.Right; statsLbl.ZIndex = 7; statsLbl.Parent = main; UI.statsLbl = statsLbl task.spawn(function() local frames, last, smoothFps = 0, tick(), 0 local Stats = game:GetService("Stats") RunService.RenderStepped:Connect(function() frames = frames + 1 local now = tick() if now - last >= 0.35 then
local inst = frames / (now - last); smoothFps = (smoothFps == 0) and inst or (smoothFps * 0.6 + inst * 0.4); frames = 0; last = now; local fpsN = math.floor(smoothFps + 0.5); local pingN = 0 pcall(function() local item = Stats.Network.ServerStatsItem["Data Ping"] if item then local s = item:GetValueString(); pingN = tonumber((tostring(s):match("%d+") or "0")) or 0 end end) if pingN == 0 then pcall(function() pingN = math.floor((Stats.Network:FindFirstChild("ServerStatsItem") and 0) or 0) end) end if pingN == 0 then pcall(function() if LP.GetNetworkPing then
pingN = math.floor(LP:GetNetworkPing() * 1000 + 0.5) end end) end local fpsCol = fpsN >= 55 and "g" or (fpsN >= 30 and "w" or "r") if statsLbl and statsLbl.Parent then statsLbl.Text = string.format("FPS %d  ·  %d ms", fpsN, pingN) if fpsN >= 55 and pingN < 120 then statsLbl.TextColor3 = Color3.fromRGB(100, 220, 160) elseif fpsN < 30 or pingN > 200 then statsLbl.TextColor3 = Color3.fromRGB(255, 110, 120) else statsLbl.TextColor3 = COLORS.textDim end end end end) end) local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26); closeBtn.Position = UDim2.new(1, -38, 0, 18); closeBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 24); closeBtn.BackgroundTransparency = 0.15; closeBtn.Text = "×"; closeBtn.TextColor3 = COLORS.accent; closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 16; closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 8; closeBtn.Parent = main; corner(closeBtn, 7)
stroke(closeBtn, COLORS.strokeSoft, 1, 0.45); closeBtn.MouseButton1Click:Connect(hideGui); local headerDiv = Instance.new("Frame"); headerDiv.Size = UDim2.new(1, -32, 0, 1); headerDiv.Position = UDim2.new(0, 16, 0, 60); headerDiv.BackgroundColor3 = COLORS.stroke
headerDiv.BackgroundTransparency = 0.55; headerDiv.BorderSizePixel = 0; headerDiv.ZIndex = 5; headerDiv.Parent = main; local pages = {}; local pageHolder = Instance.new("Frame"); pageHolder.Size = UDim2.new(1, -24, 1, -142); pageHolder.Position = UDim2.new(0, 12, 0, 72); pageHolder.BackgroundTransparency = 1; pageHolder.ClipsDescendants = true; pageHolder.ZIndex = 3; pageHolder.Parent = main local function makePage(name)
local sf = Instance.new("ScrollingFrame"); sf.Name = name; sf.Size = UDim2.new(1, 0, 1, 0); sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0; sf.ScrollBarThickness = 3; sf.ScrollBarImageColor3 = COLORS.accent; sf.CanvasSize = UDim2.new(0, 0, 0, 0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y; sf.Visible = false; sf.ZIndex = 3; sf.Parent = pageHolder; local ll = Instance.new("UIListLayout", sf); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 4); local pad = Instance.new("UIPadding", sf); pad.PaddingTop = UDim.new(0, 4); pad.PaddingBottom = UDim.new(0, 10); pad.PaddingLeft = UDim.new(0, 2); pad.PaddingRight = UDim.new(0, 6); pages[name] = sf
return sf end
local pageMOVE = makePage("MOVEMENT"); local pageTOOLS = makePage("COMBAT"); local pageVIEW = makePage("VISUALS"); local pageSYS = makePage("SETTINGS"); local pageKEYS = makePage("KEYBINDS"); local Tabs = Instance.new("Frame"); Tabs.Name = "Tabs"; Tabs.BackgroundColor3 = COLORS.row; Tabs.BackgroundTransparency = 0.56; Tabs.BorderSizePixel = 0; Tabs.AnchorPoint = Vector2.new(0, 1); Tabs.Position = UDim2.new(0, 12, 1, -10); Tabs.Size = UDim2.new(1, -24, 0, 50); Tabs.ZIndex = 5; Tabs.Parent = main; corner(Tabs, 12); stroke(Tabs, COLORS.strokeSoft, 1, 0.7); local tabPad = Instance.new("UIPadding"); tabPad.PaddingTop = UDim.new(0, 7); tabPad.PaddingBottom = UDim.new(0, 7); tabPad.PaddingLeft = UDim.new(0, 7); tabPad.PaddingRight = UDim.new(0, 7); tabPad.Parent = Tabs; local TabLayout = Instance.new("UIListLayout"); TabLayout.FillDirection = Enum.FillDirection.Horizontal; TabLayout.Padding = UDim.new(0, 5); TabLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center; TabLayout.Parent = Tabs; local tabNames = {"MOVEMENT", "COMBAT", "VISUALS", "SETTINGS", "KEYBINDS"}; local tabDisplay = {MOVEMENT = "main", COMBAT = "combat", VISUALS = "visual", SETTINGS = "sistems", KEYBINDS = "keybind"}; local tabButtons = {}; local activeTab = "MOVEMENT"
local function setTab(name) activeTab = name for n, pg in pairs(pages) do pg.Visible = (n == name) end for n, btn in pairs(tabButtons) do local on = (n == name); btn.BackgroundColor3 = on and COLORS.row2 or COLORS.row; btn.BackgroundTransparency = on and 0.05 or 0.56; btn.TextColor3 = on and COLORS.white or COLORS.textDim; local st = btn:FindFirstChildOfClass("UIStroke") if st then st.Color = on and COLORS.white or COLORS.strokeSoft; st.Transparency = on and 0.35 or 0.7 end end end for i, name in ipairs(tabNames) do
local btn = Instance.new("TextButton"); btn.Name = name; btn.Size = UDim2.new(0.2, -4, 1, 0); btn.BackgroundColor3 = COLORS.row; btn.BackgroundTransparency = 0.56; btn.BorderSizePixel = 0; btn.Text = tabDisplay[name]; btn.TextColor3 = COLORS.textDim; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.AutoButtonColor = false; btn.LayoutOrder = i; btn.ZIndex = 6; btn.Parent = Tabs; corner(btn, 14); stroke(btn, COLORS.strokeSoft, 1, 0.7) btn.MouseButton1Click:Connect(function() setTab(name) end) tabButtons[name] = btn end setTab("MOVEMENT"); task.defer(function() applyThemeColor(CRYSTAL_GREEN, "RED"); applyBackground("rbxassetid://116587787334634", true) end); local lo = 0
local function LO() lo = lo + 1; return lo end local function section(parent, text) local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 22); f.BackgroundTransparency = 1; f.LayoutOrder = LO(); local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -4, 1, 0); l.Position = UDim2.new(0, 4, 0, 0); l.BackgroundTransparency = 1; l.Text = text:upper(); l.TextColor3 = COLORS.accentStrong; l.Font = Enum.Font.GothamBlack; l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left return f end local function mkRow(parent, h)
local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, h or 34); f.BackgroundColor3 = COLORS.row; f.BackgroundTransparency = 0.56; f.BorderSizePixel = 0; f.LayoutOrder = LO(); corner(f, 9); stroke(f, CRYSTAL_GREEN_SOFT, 1, 0.38) local deco = Instance.new("Frame", f); deco.Name = "CrystalLine"; deco.Size = UDim2.new(1, -24, 0, 1); deco.Position = UDim2.new(0, 12, 1, -5); deco.BackgroundColor3 = CRYSTAL_GREEN; deco.BackgroundTransparency = 0.78; deco.BorderSizePixel = 0; deco.ZIndex = 2; f.MouseEnter:Connect(function() TS:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.40, BackgroundColor3 = COLORS.row2}):Play() end) f.MouseLeave:Connect(function() TS:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.56, BackgroundColor3 = COLORS.row}):Play() end) return f end local function mkLabel(row, txt)
local l = Instance.new("TextLabel", row); l.Size = UDim2.new(0.58, 0, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = CRYSTAL_GREEN; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left return l end local function mkPill(row, offset) local pill = Instance.new("Frame", row); pill.Size = UDim2.new(0, 40, 0, 20); pill.Position = UDim2.new(1, -(offset or 52), 0.5, -10); pill.BackgroundColor3 = COLORS.off; pill.BorderSizePixel = 0; pill.ZIndex = 4
corner(pill, 10); local dot = Instance.new("Frame", pill); dot.Size = UDim2.new(0, 14, 0, 14); dot.Position = UDim2.new(0, 3, 0.5, -7); dot.BackgroundColor3 = COLORS.textDim; dot.BorderSizePixel = 0 dot.ZIndex = 5; corner(dot, 7) return pill, dot end local function animPill(pill, dot, on) local onCol = CRYSTAL_GREEN local rowLabel = pill.Parent and pill.Parent:FindFirstChildWhichIsA("TextLabel") if rowLabel then rowLabel.TextColor3 = on and COLORS.white or CRYSTAL_GREEN end if on then pill:SetAttribute("ThemePillOn", true) else pill:SetAttribute("ThemePillOn", false) end TS:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad), { BackgroundColor3 = on and onCol or COLORS.off,
BackgroundTransparency = on and 0.08 or 0.18 }):Play() TS:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), { Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or CRYSTAL_GREEN }):Play() end local function mkToggle(parent, txt, cb) local row = mkRow(parent, 34); mkLabel(row, txt); local pill, dot = mkPill(row, 52); local on = false local function sv(s) on = s; animPill(pill, dot, s) end
local clk = Instance.new("TextButton", pill); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6 clk.Activated:Connect(function() if S._anyKeyListening then return end on = not on; sv(on); if cb then cb(on) end end) return sv end local function mkBox(parent, default, w, xOff, cb)
local tb = Instance.new("TextBox", parent); tb.Size = UDim2.new(0, w or 54, 0, 24); tb.Position = UDim2.new(1, -(xOff or 62), 0.5, -12); tb.BackgroundColor3 = Color3.fromRGB(18, 18, 20); tb.BackgroundTransparency = 0.15; tb.BorderSizePixel = 0; tb.Text = tostring(default); tb.TextColor3 = COLORS.white; tb.Font = Enum.Font.GothamBold; tb.TextSize = 12; tb.ClearTextOnFocus = false; tb.ZIndex = 5; corner(tb, 8); local bs = stroke(tb, COLORS.stroke, 1, 0.78) tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = COLORS.accent}):Play() end) tb.FocusLost:Connect(function()
TS:Create(bs, TweenInfo.new(0.12), {Color = COLORS.strokeSoft}):Play() if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end end) return tb end local GAMEPAD_KEYS = { [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true, [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true, [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true } local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil end local function isBindableInput(inp) if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end if inp.UserInputType == Enum.UserInputType.Keyboard then return true end return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true end local function kbMatch(entry, kc) return kc and (kc == entry.kb or (entry.gp and kc == entry.gp)) end
local function mkKB(parent, kbEntry, cb) local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0, 52, 0, 24); btn.Position = UDim2.new(1, -60, 0.5, -12); btn.BackgroundColor3 = CRYSTAL_GREEN or Color3.fromRGB(18, 18, 20); btn.BackgroundTransparency = 0.55; btn.BorderSizePixel = 0; btn:SetAttribute("ThemeButton", true) local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
btn.Text = getLabel(); btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.ZIndex = 5; corner(btn, 8) stroke(btn, S.themeColor or COLORS.stroke, 1, 0.55); local li, lc, pv, listenStart = false, nil, btn.Text, 0 btn.Activated:Connect(function() if li then li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = COLORS.white; return end pv = btn.Text; li = true; S._anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = COLORS.accent lc = UIS.InputBegan:Connect(function(inp)
if not li then return end if inp.KeyCode == Enum.KeyCode.Escape then li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = COLORS.white; return end local isGp = isGamepadInput(inp) if isGp and tick() - listenStart < 0.15 then return end if not isBindableInput(inp) then return end btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = COLORS.white; li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end if cb then cb(inp.KeyCode, isGp) end end) end) return btn end
local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB) local row = mkRow(parent, 34); mkLabel(row, txt) if kbEntry then mkKB(row, kbEntry, function(k, isGp) if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end if onKB then onKB(k, isGp) end end) end local pill, dot = mkPill(row, kbEntry and 118 or 52); local on = false local function sv(s) on = s; animPill(pill, dot, s) end local clk = Instance.new("TextButton", pill); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6 clk.Activated:Connect(function()
if S._anyKeyListening then return end on = not on; sv(on); if onToggle then onToggle(on) end end) return sv end lo = 0; S.autoCarrySpeedEnabled = false; S.setAutoCarrySpeedVisual = function() end pcall(function() if F.disableAutoCarrySpeed then F.disableAutoCarrySpeed() end end) section(pageMOVE, "Speed") do
local methodRow = mkRow(pageMOVE, 66)
local methodTitle = Instance.new("TextLabel", methodRow); methodTitle.Size = UDim2.new(1, -20, 0, 18); methodTitle.Position = UDim2.new(0, 10, 0, 5); methodTitle.BackgroundTransparency = 1; methodTitle.Text = "Speed Changed Method"; methodTitle.TextColor3 = COLORS.textDim; methodTitle.Font = Enum.Font.GothamMedium; methodTitle.TextSize = 11; methodTitle.TextXAlignment = Enum.TextXAlignment.Left
local methodSwitch = Instance.new("Frame", methodRow); methodSwitch.Size = UDim2.new(1, -20, 0, 30); methodSwitch.Position = UDim2.new(0, 10, 0, 28); methodSwitch.BackgroundColor3 = Color3.fromRGB(18, 18, 20); methodSwitch.BackgroundTransparency = 0.15; methodSwitch.BorderSizePixel = 0; corner(methodSwitch, 8); stroke(methodSwitch, COLORS.stroke, 1, 0.7)
local methodButtons = {}
local function refreshSpeedMethod()
    for name, button in pairs(methodButtons) do local active = name == S.speedMethod; button.BackgroundColor3 = active and (S.themeColor or CRYSTAL_GREEN) or Color3.fromRGB(18, 18, 20); button.BackgroundTransparency = active and 0.15 or 0.55; button.TextColor3 = active and COLORS.white or COLORS.textDim end
end
local function saveActiveSpeedProfile()
    local p = S.speedProfiles[S.speedMethod]; if not p then return end
    p.normalSpeed = NS; p.carrySpeed = CS; p.laggerSpeed = S.LAGGER_SPEED; p.laggerCarrySpeed = S.LAGGER_CARRY_SPEED
end
local function selectSpeedMethod(name)
    if name == S.speedMethod then refreshSpeedMethod(); return end
    saveActiveSpeedProfile(); S.speedMethod = name
    local p = S.speedProfiles[name]; if not p then return end
    NS = p.normalSpeed; CS = p.carrySpeed; S.LAGGER_SPEED = p.laggerSpeed; S.LAGGER_CARRY_SPEED = p.laggerCarrySpeed
    if UI.normalBox then UI.normalBox.Text = tostring(NS) end; if UI.carryBox then UI.carryBox.Text = tostring(CS) end; if UI.laggerBox then UI.laggerBox.Text = tostring(S.LAGGER_SPEED) end; if UI.laggerCarryBox then UI.laggerCarryBox.Text = tostring(S.LAGGER_CARRY_SPEED) end
    refreshSpeedMethod(); F.saveConfig()
end
for i, name in ipairs({"V1", "V2"}) do local button = Instance.new("TextButton", methodSwitch); button.Size = UDim2.new(0.5, -4, 1, -6); button.Position = i == 1 and UDim2.new(0, 3, 0, 3) or UDim2.new(0.5, 1, 0, 3); button.BackgroundColor3 = Color3.fromRGB(18, 18, 20); button.BorderSizePixel = 0; button.Text = name; button.Font = Enum.Font.GothamBold; button.TextSize = 12; button.AutoButtonColor = false; corner(button, 7); methodButtons[name] = button; button.Activated:Connect(function() selectSpeedMethod(name) end) end
UI.refreshSpeedMethod = refreshSpeedMethod; refreshSpeedMethod()
end do local row = mkRow(pageMOVE, 34); mkLabel(row, "Normal Speed"); UI.normalBox = mkBox(row, NS, 54, 62, function(v) if v > 0 and v <= 500 then NS = v; S.speedProfiles[S.speedMethod].normalSpeed = v end; F.saveConfig() end) end
do local row = mkRow(pageMOVE, 34); mkLabel(row, "Carry Speed"); UI.carryBox = mkBox(row, CS, 54, 62, function(v) if v > 0 and v <= 500 then CS = v; S.speedProfiles[S.speedMethod].carrySpeed = v end; F.saveConfig() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "Lagger Normal"); UI.laggerBox = mkBox(row, S.LAGGER_SPEED, 54, 62, function(v) if v > 0 and v <= 500 then S.LAGGER_SPEED = v; S.speedProfiles[S.speedMethod].laggerSpeed = v end; F.saveConfig() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "Lagger Carry"); UI.laggerCarryBox = mkBox(row, S.LAGGER_CARRY_SPEED, 54, 62, function(v) if v > 0 and v <= 500 then S.LAGGER_CARRY_SPEED = v; S.speedProfiles[S.speedMethod].laggerCarrySpeed = v end; F.saveConfig() end) end
do local row = mkRow(pageMOVE, 34); mkLabel(row, "Mode"); modeValLbl = Instance.new("TextLabel", row); modeValLbl.Size = UDim2.new(0, 100, 1, 0); modeValLbl.Position = UDim2.new(1, -110, 0, 0); modeValLbl.BackgroundTransparency = 1; modeValLbl.Text = "Normal"; modeValLbl.TextColor3 = COLORS.accentStrong; modeValLbl.Font = Enum.Font.GothamBlack; modeValLbl.TextSize = 12; modeValLbl.TextXAlignment = Enum.TextXAlignment.Right; local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2
clk.Activated:Connect(function() if S._anyKeyListening then return end F.toggleCarryMode(); F.saveConfig() end) end section(pageMOVE, "Auto Play") do local sv = mkToggleKB(pageMOVE, "Auto Left", KB.AutoLeft, function(on) S.autoLeftEnabled = on if on then F.queueAutoLeftStart() else F.stopAutoLeft() end end, function(k, isGp) if isGp then KB.AutoLeft.gp = k; KB.AutoLeft.kb = nil else KB.AutoLeft.kb = k; KB.AutoLeft.gp = nil end; F.saveConfig() end) S.autoLeftSetVisual = sv end do local sv = mkToggleKB(pageMOVE, "Auto Right", KB.AutoRight, function(on) S.autoRightEnabled = on
if on then F.queueAutoRightStart() else F.stopAutoRight() end end, function(k, isGp) if isGp then KB.AutoRight.gp = k; KB.AutoRight.kb = nil else KB.AutoRight.kb = k; KB.AutoRight.gp = nil end; F.saveConfig() end) S.autoRightSetVisual = sv end section(pageMOVE, "Teleport") do local row = mkRow(pageMOVE, 34); mkLabel(row, "Drop Brainrot") mkKB(row, KB.DropBrainrot, function(k, isGp) if isGp then KB.DropBrainrot.gp = k; KB.DropBrainrot.kb = nil else KB.DropBrainrot.kb = k; KB.DropBrainrot.gp = nil end; F.saveConfig() end)
local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2 clk.Activated:Connect(function() F.runDrop() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "TP Down") mkKB(row, KB.TPFloor, function(k, isGp) if isGp then KB.TPFloor.gp = k; KB.TPFloor.kb = nil else KB.TPFloor.kb = k; KB.TPFloor.gp = nil end; F.saveConfig() end) local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2
clk.Activated:Connect(function() F.runTPFloor() end) end do VS.setAutoTPVisual = mkToggle(pageMOVE, "Auto TP", function(on) S.autoTPEnabled = on if on then F.startAutoTP() else F.stopAutoTP() end F.saveConfig() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "Auto TP Height") UI.autoTPHeightBox = mkBox(row, S.autoTPHeight, 54, 62, function(v) if v >= 0 and v <= 500 then S.autoTPHeight = v elseif UI.autoTPHeightBox then UI.autoTPHeightBox.Text = tostring(S.autoTPHeight) end F.saveConfig() end) end lo = 0; section(pageTOOLS, "Bat") do
local abRow = mkRow(pageTOOLS, 34); mkLabel(abRow, "Auto Bat") mkKB(abRow, KB.AutoBat, function(k, isGp) if isGp then KB.AutoBat.gp = k; KB.AutoBat.kb = nil else KB.AutoBat.kb = k; KB.AutoBat.gp = nil end F.saveConfig() end) local abPill, abDot = mkPill(abRow, 118) local abOn = false local function svAutoBat(s) abOn = s; animPill(abPill, abDot, s) end S.autoBatSetVisual = svAutoBat; local abClk = Instance.new("TextButton", abPill); abClk.Size = UDim2.new(1, 0, 1, 0); abClk.BackgroundTransparency = 1; abClk.Text = ""; abClk.ZIndex = 6 abClk.Activated:Connect(function()
if S._anyKeyListening then return end abOn = not abOn; svAutoBat(abOn) if abOn then F.queueAutoBatStart() else S.autoBatEnabled = false; S.disableAutoBat() end F.saveConfig() end) end VS.setMirrorTPVisual = mkToggle(pageTOOLS, "Mirror TP Down", function(on) F.setMirrorTPDown(on) F.saveConfig() end) do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Aimbot"); local modeBtn = Instance.new("TextButton", row); modeBtn.Size = UDim2.new(0, 78, 0, 22); modeBtn.Position = UDim2.new(1, -134, 0.5, -11); modeBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); modeBtn.BorderSizePixel = 0; modeBtn.Text = ((S.aimbotMode or 1) == 2) and "V2 Bypass" or "V1"; modeBtn.TextColor3 = COLORS.white; modeBtn.Font = Enum.Font.GothamBold; modeBtn.TextSize = 10; modeBtn.ZIndex = 6
corner(modeBtn, 7); stroke(modeBtn, COLORS.stroke, 1, 0.55); UI.aimbotModeBtn = modeBtn; local pill, dot = mkPill(row, 118); local abOn = false local function svAim(s) abOn = s; animPill(pill, dot, s) end VS.setAimbotVisual = svAim VS.setAntiBatBypassVisual = function(on) if (S.aimbotMode or 1) == 2 then svAim(on) end end local clk = Instance.new("TextButton", pill); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6 clk.Activated:Connect(function() if S._anyKeyListening then return end
abOn = not abOn; svAim(abOn); setAimbotState(abOn); F.saveConfig() end) modeBtn.MouseButton1Click:Connect(function() if S._anyKeyListening then return end S.aimbotMode = ((S.aimbotMode or 1) == 2) and 1 or 2; modeBtn.Text = (S.aimbotMode == 2) and "V2 Bypass" or "V1" if abOn then setAimbotState(false); setAimbotState(true); svAim(true) end F.saveConfig() end) end VS.setAutoSwingVisual = mkToggle(pageTOOLS, "Auto Swing", function(on) S.autoSwingEnabled = on F.saveConfig() end) if VS.setAutoSwingVisual then VS.setAutoSwingVisual(S.autoSwingEnabled) end do
VS.setBatCounterVisual = mkToggle(pageTOOLS, "Bat Counter", function(on) S.batCounterEnabled = on if on then S.startBatCounter() else S.stopBatCounter() end F.saveConfig() end) end do
local expanded = false; local headerH, bodyH = 34, 76; local wrap = Instance.new("Frame", pageTOOLS); wrap.Size = UDim2.new(1, 0, 0, headerH); wrap.BackgroundTransparency = 1; wrap.ClipsDescendants = true; wrap.LayoutOrder = LO(); local header = Instance.new("Frame", wrap); header.Size = UDim2.new(1, 0, 0, headerH); header.BackgroundColor3 = COLORS.row; header.BorderSizePixel = 0; corner(header, 9); stroke(header, COLORS.strokeSoft, 1, 0.55) header.MouseEnter:Connect(function() TS:Create(header, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.row2}):Play() end)
header.MouseLeave:Connect(function() TS:Create(header, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.row}):Play() end) local arrow = Instance.new("TextLabel", header)
arrow.Size = UDim2.new(0, 22, 1, 0); arrow.Position = UDim2.new(0, 8, 0, 0); arrow.BackgroundTransparency = 1; arrow.Text = "▶"; arrow.TextColor3 = COLORS.accentStrong; arrow.Font = Enum.Font.GothamBold; arrow.TextSize = 11; arrow.TextXAlignment = Enum.TextXAlignment.Left; local titleLbl = Instance.new("TextLabel", header); titleLbl.Size = UDim2.new(0.5, 0, 1, 0); titleLbl.Position = UDim2.new(0, 28, 0, 0); titleLbl.BackgroundTransparency = 1; titleLbl.Text = "TP Bat"; titleLbl.TextColor3 = COLORS.white; titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 12; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; local modeHint = Instance.new("TextLabel", header); modeHint.Size = UDim2.new(0, 48, 0, 18); modeHint.Position = UDim2.new(1, -110, 0.5, -9); modeHint.BackgroundColor3 = Color3.fromRGB(18, 18, 20); modeHint.Text = ""; modeHint.Visible = false; modeHint.TextColor3 = COLORS.accentStrong; modeHint.Font = Enum.Font.GothamBold; modeHint.TextSize = 10; modeHint.BorderSizePixel = 0; corner(modeHint, 5); local pill, dot = mkPill(header, 52); local tpOn = false
local function svTP(s) tpOn = s; animPill(pill, dot, s) end VS.setTPBatVisual = svTP; local pillClk = Instance.new("TextButton", pill); pillClk.Size = UDim2.new(1, 0, 1, 0); pillClk.BackgroundTransparency = 1; pillClk.Text = ""; pillClk.ZIndex = 6 pillClk.Activated:Connect(function() if S._anyKeyListening then return end tpOn = not tpOn; svTP(tpOn); setTPBatState(tpOn); F.saveConfig() end) local body = Instance.new("Frame", wrap)
body.Size = UDim2.new(1, 0, 0, bodyH); body.Position = UDim2.new(0, 0, 0, headerH); body.BackgroundTransparency = 1; body.Visible = false; local kbRow = Instance.new("Frame", body); kbRow.Size = UDim2.new(1, 0, 0, 32); kbRow.Position = UDim2.new(0, 0, 0, 4); kbRow.BackgroundColor3 = COLORS.row2; kbRow.BorderSizePixel = 0; corner(kbRow, 8); stroke(kbRow, COLORS.strokeSoft, 1, 0.6); local kbLbl = Instance.new("TextLabel", kbRow); kbLbl.Size = UDim2.new(0.5, 0, 1, 0); kbLbl.Position = UDim2.new(0, 12, 0, 0); kbLbl.BackgroundTransparency = 1; kbLbl.Text = "Keybind"; kbLbl.TextColor3 = COLORS.textDim; kbLbl.Font = Enum.Font.GothamBold; kbLbl.TextSize = 11; kbLbl.TextXAlignment = Enum.TextXAlignment.Left
mkKB(kbRow, KB.TPBat, function(k, isGp) if isGp then KB.TPBat.gp = k; KB.TPBat.kb = nil; TP_BAT_CONTROLLER = k else KB.TPBat.kb = k; KB.TPBat.gp = nil; TP_BAT_KEY = k end F.saveConfig() end) local modeRow = Instance.new("Frame", body)
modeRow.Size = UDim2.new(1, 0, 0, 32); modeRow.Position = UDim2.new(0, 0, 0, 38); modeRow.BackgroundColor3 = COLORS.row2; modeRow.BorderSizePixel = 0; corner(modeRow, 8); stroke(modeRow, COLORS.strokeSoft, 1, 0.6); local modeTitle = Instance.new("TextLabel", modeRow); modeTitle.Size = UDim2.new(0.4, 0, 1, 0); modeTitle.Position = UDim2.new(0, 12, 0, 0); modeTitle.BackgroundTransparency = 1; modeTitle.Text = "Mode"; modeTitle.TextColor3 = COLORS.textDim; modeTitle.Font = Enum.Font.GothamBold; modeTitle.TextSize = 11; modeTitle.TextXAlignment = Enum.TextXAlignment.Left; tpBatModeLbl = Instance.new("TextButton", modeRow); tpBatModeLbl.Size = UDim2.new(0, 78, 0, 22); tpBatModeLbl.Position = UDim2.new(1, -90, 0.5, -11); tpBatModeLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); tpBatModeLbl.BorderSizePixel = 0; tpBatModeLbl.Text = (tpBatMode == 3) and "V3" or ((tpBatMode == 3) and "V3" or ((tpBatMode == 2) and "V2" or "V1")); tpBatModeLbl.TextColor3 = COLORS.white; tpBatModeLbl.Font = Enum.Font.GothamBold; tpBatModeLbl.TextSize = 11; tpBatModeLbl.ZIndex = 6; tpBatModeLbl.AutoButtonColor = true; corner(tpBatModeLbl, 7); stroke(tpBatModeLbl, COLORS.stroke, 1, 0.55)
tpBatModeLbl.MouseButton1Click:Connect(function() tpBatMode = (tpBatMode % 3) + 1 tpBatModeLbl.Text = (tpBatMode == 3) and "V3" or ((tpBatMode == 3) and "V3" or ((tpBatMode == 2) and "V2" or "V1")) if modeHint then modeHint.Text = tpBatModeLbl.Text; modeHint.Visible = true end if tpBatEnabled then stopTPBat(); startTPBat() end F.saveConfig() end) modeRow.Visible = true if modeHint then modeHint.Text = tpBatModeLbl.Text; modeHint.Visible = true end bodyH = 76 local function setExpanded(on) expanded = on; arrow.Text = on and "▼" or "▶"; body.Visible = on
TS:Create(wrap, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Size = UDim2.new(1, 0, 0, on and (headerH + bodyH + 2) or headerH) }):Play() end local expandBtn = Instance.new("TextButton", header); expandBtn.Size = UDim2.new(1, -56, 1, 0); expandBtn.Position = UDim2.new(0, 0, 0, 0); expandBtn.BackgroundTransparency = 1; expandBtn.Text = ""; expandBtn.ZIndex = 2 expandBtn.Activated:Connect(function() if S._anyKeyListening then return end setExpanded(not expanded) end) 
VS.setAntiTPBatCombatVisual = mkToggle(pageTOOLS, "ANTI TP BAT", function(on)
    if AntiTPBat and AntiTPBat.set then AntiTPBat.set(on) end
    F.saveConfig()
end)

do
    local expanded = false
    local headerH, bodyH = 34, 112
    local wrap = Instance.new("Frame", pageTOOLS)
    wrap.Size = UDim2.new(1, 0, 0, headerH)
    wrap.BackgroundTransparency = 1
    wrap.ClipsDescendants = true
    wrap.LayoutOrder = LO()

    local header = Instance.new("Frame", wrap)
    header.Size = UDim2.new(1, 0, 0, headerH)
    header.BackgroundColor3 = COLORS.row
    header.BorderSizePixel = 0
    corner(header, 9)
    stroke(header, COLORS.strokeSoft, 1, 0.55)

    local arrow = Instance.new("TextLabel", header)
    arrow.Size = UDim2.new(0, 22, 1, 0)
    arrow.Position = UDim2.new(0, 8, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▶"
    arrow.TextColor3 = COLORS.accentStrong
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 11
    arrow.TextXAlignment = Enum.TextXAlignment.Left

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -38, 1, 0)
    title.Position = UDim2.new(0, 30, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "ANTI TP BAT VERSION"
    title.TextColor3 = COLORS.white
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left

    local body = Instance.new("Frame", wrap)
    body.Size = UDim2.new(1, 0, 0, bodyH)
    body.Position = UDim2.new(0, 0, 0, headerH)
    body.BackgroundTransparency = 1
    body.Visible = false

    local list = Instance.new("UIListLayout", body)
    list.Padding = UDim.new(0, 4)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    local modes = {
        {name = "V1", mode = 1},
        {name = "V2", mode = 2},
        {name = "V3", mode = 3},
        {name = "V4", mode = 4},
    }

    local buttons = {}
    local spamPill, spamDot

    local function refreshVersionButtons()
        local selected = (AntiTPBat and AntiTPBat.getVersion and AntiTPBat.getVersion()) or 1
        for mode, b in pairs(buttons) do
            local active = mode == selected
            b.BackgroundColor3 = active and COLORS.accentStrong or COLORS.row
            b.TextColor3 = active and COLORS.white or COLORS.textDim
        end
    end

    local function setVersion(mode, button)
        if AntiTPBat and AntiTPBat.setVersion then AntiTPBat.setVersion(mode) end
        refreshVersionButtons()
        F.saveConfig()
    end

    for i, info in ipairs(modes) do
        local b = Instance.new("TextButton", body)
        b.Size = UDim2.new(1, 0, 0, 24)
        b.BackgroundColor3 = COLORS.row
        b.BorderSizePixel = 0
        b.Text = info.name
        b.TextColor3 = COLORS.textDim
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.AutoButtonColor = false
        b.LayoutOrder = i
        corner(b, 8)
        stroke(b, COLORS.strokeSoft, 1, 0.55)
        buttons[info.mode] = b
        b.Activated:Connect(function()
            setVersion(info.mode, b)
        end)
    end

    local spamRow = Instance.new("Frame", body)
    spamRow.Size = UDim2.new(1, 0, 0, 24)
    spamRow.BackgroundColor3 = COLORS.row
    spamRow.BorderSizePixel = 0
    spamRow.LayoutOrder = 5
    corner(spamRow, 8)
    stroke(spamRow, COLORS.strokeSoft, 1, 0.55)

    local spamLabel = Instance.new("TextLabel", spamRow)
    spamLabel.Size = UDim2.new(1, -74, 1, 0)
    spamLabel.Position = UDim2.new(0, 10, 0, 0)
    spamLabel.BackgroundTransparency = 1
    spamLabel.Text = "Spam"
    spamLabel.TextColor3 = COLORS.textDim
    spamLabel.Font = Enum.Font.GothamBold
    spamLabel.TextSize = 11
    spamLabel.TextXAlignment = Enum.TextXAlignment.Left

    spamPill, spamDot = mkPill(spamRow, 52)
    local spamOn = (AntiTPBat and AntiTPBat.getSpam and AntiTPBat.getSpam()) or false
    animPill(spamPill, spamDot, spamOn)

    local spamHit = Instance.new("TextButton", spamPill)
    spamHit.Size = UDim2.new(1, 0, 1, 0)
    spamHit.BackgroundTransparency = 1
    spamHit.Text = ""
    spamHit.ZIndex = 6
    spamHit.Activated:Connect(function()
        spamOn = not spamOn
        if AntiTPBat and AntiTPBat.setSpam then AntiTPBat.setSpam(spamOn) end
        animPill(spamPill, spamDot, spamOn)
        F.saveConfig()
    end)

    local selected = (AntiTPBat and AntiTPBat.getVersion and AntiTPBat.getVersion()) or 1
    if buttons[selected] then
        buttons[selected].BackgroundColor3 = COLORS.accentStrong
        buttons[selected].TextColor3 = COLORS.white
    end

    local hit = Instance.new("TextButton", header)
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 5
    hit.Activated:Connect(function()
        expanded = not expanded
        body.Visible = expanded
        wrap.Size = UDim2.new(1, 0, 0, expanded and (headerH + bodyH + 2) or headerH)
        arrow.Text = expanded and "▼" or "▶"
    end)

    _G._CrystalAntiTPBatRefreshUI = function()
        refreshVersionButtons()
        local on = (AntiTPBat and AntiTPBat.getSpam and AntiTPBat.getSpam()) or false
        animPill(spamPill, spamDot, on)
    end
end
end section(pageTOOLS, "Steal") do
local stealRow = mkRow(pageTOOLS, 34); mkLabel(stealRow, "Auto Steal"); local pill, dot = mkPill(stealRow, 52) local function applyStealVis(on) TS:Create(pill, TweenInfo.new(0.15), {BackgroundColor3 = on and COLORS.accent or COLORS.off}):Play() TS:Create(dot, TweenInfo.new(0.15), { Position = on and UDim2.new(1, -22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = on and COLORS.white or COLORS.textDim }):Play() end VS.setInstaGrab = applyStealVis pill.InputBegan:Connect(function(inp)
if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end if S._anyKeyListening then return end local on = not autoStealEnabled if on then startAutoSteal() else stopAutoSteal() end applyStealVis(on); F.saveConfig() end) end do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Steal Mode"); local modeLbl = Instance.new("TextButton", row); modeLbl.Size = UDim2.new(0, 90, 0, 24); modeLbl.Position = UDim2.new(1, -100, 0.5, -12); modeLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); modeLbl.BorderSizePixel = 0; modeLbl.Text = tostring(selectedStealMode or "Normal"); modeLbl.TextColor3 = COLORS.white; modeLbl.Font = Enum.Font.GothamBold; modeLbl.TextSize = 11; modeLbl.ZIndex = 5; corner(modeLbl, 8); UI.stealModeLbl = modeLbl; local modes = {"Normal", "Semi", "V3"} modeLbl.MouseButton1Click:Connect(function()
local cur = selectedStealMode or "Normal" local idx = 1 for i, m in ipairs(modes) do if m == cur then idx = i break end end idx = (idx % #modes) + 1; selectedStealMode = modes[idx]; modeLbl.Text = selectedStealMode if selectedStealMode == "Normal" then autoGrabStopEnabled = false; Steal.AutoGrabStopEnabled = false elseif selectedStealMode == "Semi" then autoGrabStopEnabled = true; Steal.AutoGrabStopEnabled = true else autoGrabStopEnabled = true; Steal.AutoGrabStopEnabled = true; autoStealRadius = math.max(tonumber(autoStealRadius) or 20, 55); Steal.StealRadius = autoStealRadius
if UI.radInput then UI.radInput.Text = tostring(autoStealRadius) end end if autoStealEnabled then pcall(stopAutoSteal); pcall(startAutoSteal) end F.saveConfig() end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Steal Radius") UI.radInput = mkBox(row, Steal.StealRadius, 54, 62, function(v) v = tonumber(v) if v and v > 0 then autoStealRadius = v; Steal.StealRadius = v; AceStealRadii.Normal = v if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.0f", v) end F.saveConfig() end end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Steal Duration")
UI.stealDurInput = mkBox(row, Steal.StealDuration, 54, 62, function(v) v = tonumber(v) if v and v >= 0.1 then Steal.StealDuration = v; F.saveConfig() end end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Stop Time"); local pill, dot = mkPill(row, 52) local function vis(on) TS:Create(pill, TweenInfo.new(0.15), {BackgroundColor3 = on and COLORS.accent or COLORS.off}):Play() TS:Create(dot, TweenInfo.new(0.15), { Position = on and UDim2.new(1, -22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }):Play() end VS.setAutoGrabStopVisual = vis pill.InputBegan:Connect(function(inp)
if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end Steal.AutoGrabStopEnabled = not Steal.AutoGrabStopEnabled; autoGrabStopEnabled = Steal.AutoGrabStopEnabled; vis(Steal.AutoGrabStopEnabled); F.saveConfig() end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Stop Time (s)") UI.stopTimeInput = mkBox(row, Steal.AutoGrabStopTime, 54, 62, function(v) v = tonumber(v) if v and v > 0 then Steal.AutoGrabStopTime = v; autoGrabStopTime = v; F.saveConfig() end end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Stop Time (%)") UI.stopTimePercentInput = mkBox(row, autoGrabStopPercent, 54, 62, function(v) v = tonumber(v) if v and v >= 1 and v <= 100 then autoGrabStopPercent = v; Steal.AutoGrabStopPercent = v; F.saveConfig() end end) end do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Delay Radius") UI.delayRadInput = mkBox(row, Steal.AutoGrabDelayRadius, 54, 62, function(v) v = tonumber(v) if v and v > 0 then Steal.AutoGrabDelayRadius = v; autoGrabDelayRadius = v; F.saveConfig() end end) end section(pageTOOLS, "Combat")
VS.setMedusaVisual = mkToggle(pageTOOLS, "Medusa Counter", function(on) S.medusaCounterEnabled = on F.refreshMedusaWatch(); F.saveConfig() end) do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Instant Reset")
mkKB(row, KB.InstaReset, function(k, isGp) if isGp then KB.InstaReset.gp = k; KB.InstaReset.kb = nil else KB.InstaReset.kb = k; KB.InstaReset.gp = nil end; F.saveConfig() end) local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2 clk.Activated:Connect(function() if cursedInstaReset then cursedInstaReset() end end) end VS.setInfJumpVisual = mkToggle(pageTOOLS, "Infinite Jump", function(on) infJumpEnabled = on if on then F.startInfJump() else F.stopInfJump() end F.saveConfig() end) do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Jump Mode"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = ((S.infJumpMode or "hold") == "manual") and "Manual" or "Hold"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5 corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6); UI.infJumpModeBtn = btn btn.MouseButton1Click:Connect(function()
local nextMode = ((S.infJumpMode or "hold") == "manual") and "hold" or "manual" F.setInfJumpMode(nextMode); btn.Text = (nextMode == "manual") and "Manual" or "Hold" F.saveConfig() end) end VS.setAntiRagVisual = mkToggle(pageTOOLS, "Anti Ragdoll", function(on) S.antiRagdollEnabled = on if on then F.startAntiRagdoll() else F.stopAntiRagdoll() end F.saveConfig() end) do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Ragdoll Mode"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = (S.antiRagdollMode == 2) and "V2" or "V1"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5; corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6) btn.MouseButton1Click:Connect(function() S.antiRagdollMode = (S.antiRagdollMode == 2) and 1 or 2
btn.Text = (S.antiRagdollMode == 2) and "V2" or "V1" if S.antiRagdollEnabled then F.stopAntiRagdoll(); F.startAntiRagdoll() end F.saveConfig() end) end do
local expanded = false; local headerRow = mkRow(pageTOOLS, 34); mkLabel(headerRow, "Anti Die System"); local expandBtn = Instance.new("TextButton", headerRow); expandBtn.Size = UDim2.new(0, 72, 0, 24); expandBtn.Position = UDim2.new(1, -80, 0.5, -12); expandBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); expandBtn.BorderSizePixel = 0; expandBtn.Text = "OPEN"; expandBtn.TextColor3 = COLORS.white; expandBtn.Font = Enum.Font.GothamBold; expandBtn.TextSize = 11; expandBtn.ZIndex = 5; corner(expandBtn, 8); stroke(expandBtn, COLORS.stroke, 1, 0.6)
VS.setAntiDieVisual = mkToggle(pageTOOLS, "Anti Die", function(on) if on then F.startAntiDie() else F.stopAntiDie() end end) VS.setAntiDropVisual = mkToggle(pageTOOLS, "Anti Drop", function(on) if on then local started = F.startAntiDrop() if not started and VS.setAntiDropVisual then task.defer(function() VS.setAntiDropVisual(false) end) end else F.stopAntiDrop() end F.saveConfig() end) VS.setAntiFlingVisual = mkToggle(pageTOOLS, "Fling Shield", function(on) if on then F.startAntiFlingShield() else F.stopAntiFlingShield() end end) local antiDieRow, flingRow = nil, nil local children = pageTOOLS:GetChildren() for i = #children, 1, -1 do local ch = children[i] if ch:IsA("Frame") then local lbl = ch:FindFirstChildWhichIsA("TextLabel") if lbl and lbl.Text == "Fling Shield" and not flingRow then flingRow = ch
elseif lbl and lbl.Text == "Anti Die" and not antiDieRow then antiDieRow = ch end end if antiDieRow and flingRow then break end end if antiDieRow then antiDieRow.Visible = false end if flingRow then flingRow.Visible = false end expandBtn.MouseButton1Click:Connect(function() expanded = not expanded expandBtn.Text = expanded and "CLOSE" or "OPEN" if antiDieRow then antiDieRow.Visible = expanded end if flingRow then flingRow.Visible = expanded end end) end VS.setNoPlayerCollisionVisual = mkToggle(pageTOOLS, "No Player Collision", function(on)
if on then F.enableNoPlayerCollision() else F.disableNoPlayerCollision() end F.saveConfig() end) VS.setSafeModeVisual = mkToggle(pageTOOLS, "Safe Mode", function(on) S.safeModeEnabled = on F.saveConfig() end) VS.setMedusaResetVisual = mkToggle(pageTOOLS, "Medusa Reset", function(on) S.medusaResetEnabled = on F.refreshMedusaWatch(); F.saveConfig() end) VS.setAutoResetOnMedVisual = mkToggle(pageTOOLS, "Auto Reset On Med Fling", function(on) F.setAutoResetOnMed(on) F.saveConfig() end) VS.setBodyLockVisual = mkToggle(pageTOOLS, "Body Lock", function(on) if on then
if K7 and K7.startBodyLock then K7.startBodyLock() elseif startBodyLock then startBodyLock() end else if K7 and K7.stopBodyLock then K7.stopBodyLock(true) elseif stopBodyLock then stopBodyLock(true) end end F.saveConfig() end) do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Lock Radius"); local rad = (K7 and K7.bodyLockRadius) or bodyLockRadius or 60 mkBox(row, rad, 54, 62, function(v) if v >= 5 and v <= 300 then if K7 then K7.bodyLockRadius = v end bodyLockRadius = v end F.saveConfig() end) end lo = 0; section(pageVIEW, "Visual")
VS.setAntiLagVisual = mkToggle(pageVIEW, "FPS Boost (Anti Lag)", function(on) if on then F.enableAntiLag() else F.disableAntiLag() end F.saveConfig() end) VS.setStretchRezVisual = mkToggle(pageVIEW, "Stretch Rez", function(on) if on then enableStretchRez() else disableStretchRez() end F.saveConfig() end) VS.setUnwalkVisual = mkToggle(pageVIEW, "Unwalk", function(on) S.unwalkEnabled = on if on then F.startUnwalk() else F.stopUnwalk() end end) VS.setRemoveAccVisual = mkToggle(pageVIEW, "Remove Accessories", function(on) if on then F.startRemoveAccessories() else F.stopRemoveAccessories() end
end) VS.setKeyboardOverlayVisual = mkToggle(pageVIEW, "Keyboard Overlay", function(on) if on then F.startKeyboardOverlay() else F.stopKeyboardOverlay() end F.saveConfig() end) section(pageVIEW, "ESP") VS.setLineESPVisual = mkToggle(pageVIEW, "Player ESP", function(on) K7.lineESPEnabled = on K7.speedESPEnabled = on; K7.refreshESP(); F.saveConfig() end) VS.setShowTrackerVisual = mkToggle(pageVIEW, "Tracer ESP", function(on) S.showTracerEnabled = on if on then startTracerESP() else stopTracerESP() end pcall(function() if F.setShowTracer then F.setShowTracer(false) end end)
pcall(function() if F.clearTracers then F.clearTracers() end end) S.showTracerEnabled = on; F.saveConfig() end) VS.setShowTracerVisual = VS.setShowTrackerVisual VS.setSpeedESPVisual = function(on) if VS.setLineESPVisual then VS.setLineESPVisual(on) end end VS.setRagdollCdVisual = mkToggle(pageVIEW, "Ragdoll Countdown", function(on) F.setRagdollCountdown(on) F.saveConfig() end) section(pageVIEW, "Sky & Vision") do
local row = mkRow(pageVIEW, 34); mkLabel(row, "Sky Theme"); local skyLbl = Instance.new("TextLabel", row); skyLbl.Size = UDim2.new(0, 90, 0, 24); skyLbl.Position = UDim2.new(1, -100, 0.5, -12); skyLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); skyLbl.Text = K7.currentSkyTheme; skyLbl.TextColor3 = COLORS.white; skyLbl.Font = Enum.Font.GothamBold; skyLbl.TextSize = 11; Instance.new("UICorner", skyLbl).CornerRadius = UDim.new(0, 6); local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 3
clk.Activated:Connect(function() local name = K7.cycleSkyTheme(1) skyLbl.Text = name; F.saveConfig() end) end do local row = mkRow(pageVIEW, 34); mkLabel(row, "FOV") local fovBox = mkBox(row, K7.fovValue or _G._VezyFOV or 70, 54, 62, function(v) if v >= 30 and v <= 180 then K7.fovValue = v; _G._VezyFOV = v if K7.fovEnabled then K7.applyFOV() end local cam = workspace.CurrentCamera if cam and not (State and State.stretchedResEnabled) then pcall(function() cam.FieldOfView = v end) end end F.saveConfig() end) end VS.setFOVVisual = mkToggle(pageVIEW, "Custom FOV", function(on) K7.fovEnabled = on
K7.applyFOV(); F.saveConfig() end) lo = 0 section(pageSYS, "Charter") VS.setHeadlessVisual = mkToggle(pageSYS, "Headless", function(on) if K7.accessoryPackName == "Mario" then K7.headlessEnabled = true; K7.applyHeadless(LP.Character, true) else K7.headlessEnabled = on; K7.applyHeadless(LP.Character, on) end; F.saveConfig() end) VS.setKorbloxVisual = mkToggle(pageSYS, "Korblox", function(on) K7.korbloxEnabled = on K7.applyKorblox(LP.Character, on); F.saveConfig() end) do
local sideNames = {[1] = "Right", [2] = "Left", [3] = "Both"}; local row = mkRow(pageSYS, 34); mkLabel(row, "Korblox Side"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = sideNames[korbloxSide] or "Right"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5; corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6) btn.MouseButton1Click:Connect(function() korbloxSide = (korbloxSide % 3) + 1
K7.korbloxSide = korbloxSide; btn.Text = sideNames[korbloxSide] or "Right" if K7.korbloxEnabled then K7.applyKorblox(LP.Character, true) end F.saveConfig() end) end section(pageSYS, "Animation Pack") VS.setAnimPackVisual = mkToggle(pageSYS, "Animation Pack Enabled", function(on) K7.animPackEnabled = on if on then K7.applyAnimPack(K7.animPackName) else K7.resetAnimPack() end F.saveConfig() end) do
local row = mkRow(pageSYS, 34); mkLabel(row, "Select Pack"); local packLbl = Instance.new("TextLabel", row); packLbl.Size = UDim2.new(0, 100, 0, 24); packLbl.Position = UDim2.new(1, -110, 0.5, -12); packLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); packLbl.Text = K7.animPackName; UI.animPackLbl = packLbl; packLbl.TextColor3 = COLORS.white; packLbl.Font = Enum.Font.GothamBold; packLbl.TextSize = 10; Instance.new("UICorner", packLbl).CornerRadius = UDim.new(0, 6); local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 3
clk.Activated:Connect(function() K7.animPackIndex = K7.animPackIndex % #K7.ANIM_PACK_LIST + 1 K7.animPackName = K7.ANIM_PACK_LIST[K7.animPackIndex]; packLbl.Text = K7.animPackName if K7.animPackEnabled then K7.applyAnimPack(K7.animPackName) end F.saveConfig() end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Current Pack"); local applyBtn = Instance.new("TextButton", row); applyBtn.Size = UDim2.new(0, 60, 0, 24); applyBtn.Position = UDim2.new(1, -70, 0.5, -12); applyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 44); applyBtn.Text = "APPLY"; applyBtn.TextColor3 = COLORS.white; applyBtn.Font = Enum.Font.GothamBold; applyBtn.TextSize = 11; applyBtn.BorderSizePixel = 0; Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6) applyBtn.Activated:Connect(function() if K7.animPackEnabled then K7.applyAnimPack(K7.animPackName) end F.saveConfig() end)
section(pageSYS, "Accessory Pack")
VS.setAccessoryPackVisual = mkToggle(pageSYS, "Accessory Pack Enabled", function(on) K7.accessoryPackEnabled = on if on then K7.applyAccessoryPack(K7.accessoryPackName) else K7.resetAccessoryPack() end pcall(F.saveConfig) end) do
local row = mkRow(pageSYS, 34); mkLabel(row, "Select Skin"); local accLbl = Instance.new("TextLabel", row); accLbl.Size = UDim2.new(0, 100, 0, 24); accLbl.Position = UDim2.new(1, -110, 0.5, -12); accLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); accLbl.Text = K7.accessoryPackName; UI.accessoryPackLbl = accLbl; accLbl.TextColor3 = COLORS.white; accLbl.Font = Enum.Font.GothamBold; accLbl.TextSize = 10; Instance.new("UICorner", accLbl).CornerRadius = UDim.new(0, 6); local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 3
clk.Activated:Connect(function() K7.accessoryPackIndex = K7.accessoryPackIndex % #K7.ACCESSORY_PACK_LIST + 1 K7.accessoryPackName = K7.ACCESSORY_PACK_LIST[K7.accessoryPackIndex]; accLbl.Text = K7.accessoryPackName if K7.accessoryPackEnabled then K7.applyAccessoryPack(K7.accessoryPackName) end pcall(F.saveConfig) end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Current Skin"); local applyBtn = Instance.new("TextButton", row); applyBtn.Size = UDim2.new(0, 60, 0, 24); applyBtn.Position = UDim2.new(1, -70, 0.5, -12); applyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 44); applyBtn.Text = "APPLY"; applyBtn.TextColor3 = COLORS.white; applyBtn.Font = Enum.Font.GothamBold; applyBtn.TextSize = 11; applyBtn.BorderSizePixel = 0; Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6) applyBtn.Activated:Connect(function() K7.accessoryPackEnabled = true if VS.setAccessoryPackVisual then pcall(VS.setAccessoryPackVisual, true) end K7.applyAccessoryPack(K7.accessoryPackName) pcall(F.saveConfig) end) end

end section(pageSYS, "Interface") do local row = mkRow(pageSYS, 34); mkLabel(row, "Hide UI") mkKB(row, KB.GuiHide, function(k, isGp) if isGp then KB.GuiHide.gp = k; KB.GuiHide.kb = nil else KB.GuiHide.kb = k; KB.GuiHide.gp = nil end; F.saveConfig() end) end section(pageSYS, "Appearance") do pcall(ensureBgAssets); local row = mkRow(pageSYS, 72); row.ClipsDescendants = false; mkLabel(row, "Background"); local gallery = Instance.new("ScrollingFrame"); gallery.Name = "BgGallery"
gallery.Size = UDim2.new(1, -110, 0, 52); gallery.Position = UDim2.new(0, 100, 0.5, -26); gallery.BackgroundColor3 = Color3.fromRGB(14, 14, 16); gallery.BackgroundTransparency = 0.25; gallery.BorderSizePixel = 0; gallery.ScrollBarThickness = 2; gallery.ScrollBarImageColor3 = COLORS.stroke; gallery.ScrollingDirection = Enum.ScrollingDirection.X; gallery.CanvasSize = UDim2.new(0, 0, 0, 0); gallery.AutomaticCanvasSize = Enum.AutomaticSize.X; gallery.ZIndex = 6; gallery.Parent = row
corner(gallery, 10); stroke(gallery, COLORS.stroke, 1, 0.7); local list = Instance.new("UIListLayout"); list.FillDirection = Enum.FillDirection.Horizontal; list.Padding = UDim.new(0, 6); list.VerticalAlignment = Enum.VerticalAlignment.Center list.SortOrder = Enum.SortOrder.LayoutOrder; list.Parent = gallery; local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 6); pad.PaddingRight = UDim.new(0, 6); pad.Parent = gallery; local selectedBg = nil for idx, preset in ipairs(BG_PRESETS) do
local thumb = Instance.new("ImageButton"); thumb.Name = "Bg_" .. preset.name; thumb.LayoutOrder = idx; thumb.Size = UDim2.new(0, 44, 0, 40); thumb.BackgroundColor3 = Color3.fromRGB(18, 18, 20); thumb.BorderSizePixel = 0; local resolvedThumb = resolveBgId(preset.id); thumb.Image = resolvedThumb; thumb.ImageTransparency = (resolvedThumb == "" and 1) or 0.1; thumb.ScaleType = Enum.ScaleType.Crop; thumb.ScaleType = Enum.ScaleType.Crop; thumb.AutoButtonColor = false; thumb.ZIndex = 7; thumb.Parent = gallery; corner(thumb, 8); local st = Instance.new("UIStroke"); st.Color = COLORS.stroke; st.Thickness = 1.2; st.Transparency = 0.45; st.Parent = thumb; st:SetAttribute("ThemeAccent", true); table.insert(themeAccentStrokes, st)
if preset.id == "" then local none = Instance.new("TextLabel"); none.Size = UDim2.new(1, 0, 1, 0); none.BackgroundTransparency = 1; none.Text = "NONE"; none.TextColor3 = COLORS.textDim; none.Font = Enum.Font.GothamBold; none.TextSize = 9; none.ZIndex = 8; none.Parent = thumb end thumb.MouseButton1Click:Connect(function() if selectedBg then local os = selectedBg:FindFirstChildOfClass("UIStroke") if os then os.Transparency = 0.45; os.Thickness = 1.2 end end selectedBg = thumb; st.Transparency = 0; st.Thickness = 2; applyBackground(preset.id) end)
if (S.currentBgId or currentBgId or "") == preset.id then selectedBg = thumb; st.Transparency = 0; st.Thickness = 2 end end end do
local row = mkRow(pageSYS, 34); mkLabel(row, "BG Intensity"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local valLbl = Instance.new("TextLabel", row); valLbl.Size = UDim2.new(0, 44, 0, 24); valLbl.Position = UDim2.new(1, -80, 0.5, -12); valLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); valLbl.BackgroundTransparency = 0.15; valLbl.BorderSizePixel = 0; valLbl.Text = "58%"; valLbl.TextColor3 = COLORS.white; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 11; valLbl.ZIndex = 5; corner(valLbl, 8); local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5
corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75); S.bgIntensity = 1 local function setIntensity(v) S.bgIntensity = math.clamp(v, 0.15, 1); valLbl.Text = string.format("%d%%", math.floor(S.bgIntensity * 100 + 0.5)) if bgAsset and bgAsset.Image ~= "" then bgAsset.ImageTransparency = 1 - S.bgIntensity end pcall(function() F.saveConfig() end) end minusBtn.MouseButton1Click:Connect(function() setIntensity(S.bgIntensity - 0.08) end) plusBtn.MouseButton1Click:Connect(function() setIntensity(S.bgIntensity + 0.08) end) setIntensity(S.bgIntensity) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "GUI Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); minusBtn.BackgroundTransparency = 0.1; minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local scaleLbl = Instance.new("TextLabel", row); scaleLbl.Size = UDim2.new(0, 44, 0, 24); scaleLbl.Position = UDim2.new(1, -80, 0.5, -12); scaleLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); scaleLbl.BackgroundTransparency = 0.15; scaleLbl.BorderSizePixel = 0; scaleLbl.Text = "100%"; scaleLbl.TextColor3 = COLORS.white; scaleLbl.Font = Enum.Font.GothamBold; scaleLbl.TextSize = 11; scaleLbl.ZIndex = 5
corner(scaleLbl, 8); UI.guiScaleLbl = scaleLbl local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); plusBtn.BackgroundTransparency = 0.1; plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75) minusBtn.Activated:Connect(function() if S._anyKeyListening then return end
if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale((_G._VersincGetGuiScale and _G._VersincGetGuiScale() or 1) - 0.1) end end) plusBtn.Activated:Connect(function() if S._anyKeyListening then return end if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale((_G._VersincGetGuiScale and _G._VersincGetGuiScale() or 1) + 0.1) end end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Progress Bar Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); minusBtn.BackgroundTransparency = 0.1; minusBtn.BorderSizePixel = 0; minusBtn.Text = "-"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local pbLbl = Instance.new("TextLabel", row); pbLbl.Size = UDim2.new(0, 44, 0, 24); pbLbl.Position = UDim2.new(1, -80, 0.5, -12); pbLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); pbLbl.BackgroundTransparency = 0.15; pbLbl.BorderSizePixel = 0; pbLbl.Text = tostring(S.progressBarScale or 100) .. "%"; pbLbl.TextColor3 = COLORS.white; pbLbl.Font = Enum.Font.GothamBold; pbLbl.TextSize = 11; pbLbl.ZIndex = 5
corner(pbLbl, 8); _G.__VersincProgressBarSizeLbl = pbLbl local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); plusBtn.BackgroundTransparency = 0.1; plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75) local function bump(d) if S._anyKeyListening then return end
local n = math.clamp((tonumber(S.progressBarScale) or 100) + d, 50, 200) if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(n) end pbLbl.Text = tostring(S.progressBarScale or n) .. "%"; F.saveConfig() end minusBtn.Activated:Connect(function() bump(-10) end) plusBtn.Activated:Connect(function() bump(10) end) end VS.setLockGuiVisual = mkToggle(pageSYS, "Lock GUI", function(on) S.guiLocked = on and true or false F.saveConfig() end) if S.autoSaveEnabled == nil then S.autoSaveEnabled = true end VS.setAutoSaveVisual = mkToggle(pageSYS, "Auto Save", function(on)
S.autoSaveEnabled = on and true or false F.saveConfig(true) end) do local row = mkRow(pageSYS, 28); local st = Instance.new("TextLabel", row); st.Size = UDim2.new(1, -12, 1, 0); st.Position = UDim2.new(0, 10, 0, 0); st.BackgroundTransparency = 1; st.Text = "Save: ready"; st.TextColor3 = COLORS.textDim; st.Font = Enum.Font.GothamMedium; st.TextSize = 11; st.TextXAlignment = Enum.TextXAlignment.Left; st.ZIndex = 5; UI.saveStatusLbl = st end task.defer(function() if VS.setAutoSaveVisual then VS.setAutoSaveVisual(S.autoSaveEnabled) end
if VS.setLockGuiVisual then VS.setLockGuiVisual(S.guiLocked) end end) -- ===== CRYSTAL MUSIC PLAYER (copiado do AMBITIOUS) =====
do
    local SoundService = game:GetService("SoundService")
    local TweenService = TS
    local MUSIC_PLAYER_OPTIONS = {
{name="Gelato", url="https://files.catbox.moe/dkci4j.mp3", file="kingnasir.mp3"},
  {name="Meant To Be", url="https://files.catbox.moe/dwjk76.mp3", file="dubist.mp3"},
  {name="Beccaria San Vittore RMX", url="https://files.catbox.moe/2r8auq.mp3", file="AmbitiousHubMusic3.mp3"},
  {name="The Box", url="https://files.catbox.moe/yumqjl.mp3", file="AmbitiousHubMusic4.mp3"},
  {name="Mu Ammar Gheddafi RMX", url="https://files.catbox.moe/qcuden.mp3", file="AmbitiousHubMusic5.mp3"},
  {name="Marocchino RMX", url="https://files.catbox.moe/iyav31.mp3", file="AmbitiousHubMusic6.mp3"},
  {name="Gotham Mashup", url="https://files.catbox.moe/7eof36.mp3", file="AmbitiousHubMusic7.mp3"},
  {name="Goosebumps", url="https://files.catbox.moe/6wqcck.mp3", file="AmbitiousHubMusic8.mp3"},
  {name="Houdini", url="https://files.catbox.moe/gsuxur.mp3", file="AmbitiousHubMusic9.mp3"},
  {name="Magnolia", url="https://files.catbox.moe/ursllw.mp3", file="AmbitiousHubMusic10.mp3"},
  {name="Redemption RMX", url="https://files.catbox.moe/kjxkv7.mp3", file="AmbitiousHubMusic11.mp3"},
  {name="Evicted RMX", url="https://files.catbox.moe/s28bh5.mp3", file="AmbitiousHubMusic12.mp3"},
  {name="Lyfe RMX", url="https://files.catbox.moe/8hciqx.mp3", file="AmbitiousHubMusic13.mp3"},
  {name="No Refunds RMX", url="https://files.catbox.moe/uz9hot.mp3", file="AmbitiousHubMusic14.mp3"},
  {name="8 AM In Manny RMX", url="https://files.catbox.moe/xh4t0r.mp3", file="AmbitiousHubMusic15.mp3"},
  {name="Us Vs Them RMX", url="https://files.catbox.moe/po5fbj.mp3", file="AmbitiousHubMusic16.mp3"},
  {name="Reflection 2 RMX", url="https://files.catbox.moe/kcst57.mp3", file="AmbitiousHubMusic17.mp3"},
  {name="I Know You Care RMX", url="https://files.catbox.moe/c2en1v.mp3", file="AmbitiousHubMusic18.mp3"},
  {name="Bubblegum RMX", url="https://files.catbox.moe/8xf15k.mp3", file="AmbitiousHubMusic19.mp3"},
  {name="Cream RMX", url="https://files.catbox.moe/yfhgqz.mp3", file="AmbitiousHubMusic20.mp3"},
  {name="Panzerknacker.wav", url="https://files.catbox.moe/izcvhm.mp3", file="AmbitiousHubMusic21.mp3"},
  {name="Freaked Out", url="https://files.catbox.moe/dyt2ja.mp3", file="AmbitiousHubMusic22.mp3"},
  {name="Scam Likely", url="https://files.catbox.moe/pr85mz.mp3", file="AmbitiousHubMusic23.mp3"},
  {name="Pure Cocaine", url="https://files.catbox.moe/dvjtjk.mp3", file="AmbitiousHubMusic24.mp3"},
  {name="Tesla", url="https://files.catbox.moe/n85fch.mp3", file="AmbitiousHubMusic25.mp3"},
  {name="Piazza Di Spaccio 2 RMX", url="https://files.catbox.moe/0ompvn.mp3", file="AmbitiousHubMusic26.mp3"},
  {name="Benef RMX", url="https://files.catbox.moe/swcqe5.mp3", file="AmbitiousHubMusic27.mp3"},
  {name="Accavallato RMX", url="https://files.catbox.moe/pme01q.mp3", file="AmbitiousHubMusic28.mp3"},
  {name="Hd RMX", url="https://files.catbox.moe/oa3ylr.mp3", file="AmbitiousHubMusic29.mp3"},
  {name="Vyzee", url="https://files.catbox.moe/gmxz02.mp3", file="AmbitiousHubMusic30.mp3"},
  {name="Addiction", url="https://files.catbox.moe/unkq06.mp3", file="AmbitiousHubMusic31.mp3"},
  {name="America RMX", url="https://files.catbox.moe/k09ioc.mp3", file="AmbitiousHubMusic32.mp3"},
  {name="Sprinter", url="https://files.catbox.moe/0gyb73.mp3", file="AmbitiousHubMusic33.mp3"},
  {name="Band4Band", url="https://files.catbox.moe/47dehm.mp3", file="AmbitiousHubMusic34.mp3"},
  {name="Doja RMX", url="https://files.catbox.moe/8ze5d8.mp3", file="AmbitiousHubMusic35.mp3"},
  {name="Opinel RMX", url="https://files.catbox.moe/hf6pdq.mp3", file="AmbitiousHubMusic36.mp3"},
  {name="Vrp RMX", url="https://files.catbox.moe/hjzkbu.mp3", file="AmbitiousHubMusic37.mp3"},
  {name="Tarantelle RMX", url="https://files.catbox.moe/0e9jwg.mp3", file="AmbitiousHubMusic38.mp3"},
  {name="Hood RMX", url="https://files.catbox.moe/raewna.mp3", file="AmbitiousHubMusic39.mp3"},
  {name="Mask RMX", url="https://files.catbox.moe/ghqz2q.mp3", file="AmbitiousHubMusic40.mp3"},
  {name="Spinnin RMX", url="https://files.catbox.moe/r9achz.mp3", file="AmbitiousHubMusic41.mp3"},
  {name="Dnd RMX", url="https://files.catbox.moe/1d83ju.mp3", file="AmbitiousHubMusic42.mp3"},
  {name="Xnx RMX", url="https://files.catbox.moe/a2e54o.mp3", file="AmbitiousHubMusic43.mp3"},
  {name="Hypebae RMX", url="https://files.catbox.moe/oj6hix.mp3", file="AmbitiousHubMusic44.mp3"},
  {name="Mercedes Nero RMX", url="https://h.uguu.se/dCgHArHt.mp3", file="AmbitiousHubMusic45.mp3", rev=2},
  {name="Dissenatori RMX", url="https://files.catbox.moe/fbjq0w.mp3", file="AmbitiousHubMusic46.mp3"},
  {name="British RMX", url="https://files.catbox.moe/jn9mmr.mp3", file="AmbitiousHubMusic47.mp3"},
  {name="Go Go Jack RMX", url="https://files.catbox.moe/u31krk.mp3", file="AmbitiousHubMusic48.mp3"},
  {name="Darkmoney RMX", url="https://files.catbox.moe/rz4mzu.mp3", file="AmbitiousHubMusic49.mp3"},
  {name="Ghetto RMX", url="https://files.catbox.moe/omj56p.mp3", file="AmbitiousHubMusic50.mp3"},
  {name="Copacabana RMX", url="https://files.catbox.moe/g43412.mp3", file="AmbitiousHubMusic51.mp3"},
    }

    local selectedMusicSong = _G.CrystalMusicSelectedSong or 1
    local musicPlayerVolume = _G.CrystalMusicVolume or 1
    local musicPlayerSpeed = _G.CrystalMusicSpeed or 1
    local musicAutoPlayNext = _G.CrystalMusicAutoPlayNext == true
    local musicShuffleEnabled = _G.CrystalMusicShuffle == true
    local musicLoopEnabled = _G.CrystalMusicLoop == true
    local musicSound = nil
    local musicToken = 0
    local musicCache = {}
    local musicDownloading = {}
    local musicRevCleaned = {}

    local function musicRefresh()
        if _G.CrystalMusicRefreshUI then pcall(_G.CrystalMusicRefreshUI) end
    end

    local function musicName()
        local opt = MUSIC_PLAYER_OPTIONS[selectedMusicSong]
        return opt and opt.name or "No Song"
    end

    local function musicRandomIndex()
        local total = #MUSIC_PLAYER_OPTIONS
        if total <= 1 then return 1 end
        local r = math.random(1, total - 1)
        if r >= selectedMusicSong then r = r + 1 end
        return r
    end

    local function cacheSong(option)
        if not option or not option.url or option.url == "" then return nil end
        if not (writefile and getcustomasset) then return nil end
        local baseName = option.file or ("CrystalMusic_" .. tostring(option.name or "song") .. ".mp3")
        local rev = math.max(math.floor(tonumber(option.rev) or 1), 1)
        local stem = baseName:gsub("%.mp3$", "")
        local fileName = (rev > 1) and (stem .. "_r" .. rev .. ".mp3") or baseName

        if rev > 1 and not musicRevCleaned[baseName] then
            musicRevCleaned[baseName] = true
            for r = 1, rev - 1 do
                local oldName = (r > 1) and (stem .. "_r" .. r .. ".mp3") or baseName
                musicCache[oldName] = nil
                pcall(function()
                    if isfile and isfile(oldName) and delfile then delfile(oldName) end
                end)
            end
        end

        if musicCache[fileName] then return musicCache[fileName] end
        local hasFile = false
        pcall(function() hasFile = isfile and isfile(fileName) end)
        if hasFile then
            local ok = pcall(function() musicCache[fileName] = getcustomasset(fileName) end)
            if ok and musicCache[fileName] then return musicCache[fileName] end
        end
        if musicDownloading[fileName] then
            local started = tick()
            while musicDownloading[fileName] and tick() - started < 15 do task.wait(0.05) end
            if musicCache[fileName] then return musicCache[fileName] end
            pcall(function()
                if isfile and isfile(fileName) then musicCache[fileName] = getcustomasset(fileName) end
            end)
            if musicCache[fileName] then return musicCache[fileName] end
        end

        musicDownloading[fileName] = true
        local ok = pcall(function()
            local data = game:HttpGet(option.url)
            if data and #data > 0 then
                writefile(fileName, data)
                musicCache[fileName] = getcustomasset(fileName)
            end
        end)
        musicDownloading[fileName] = nil
        if ok and musicCache[fileName] then return musicCache[fileName] end
        return nil
    end

    local function stopMusic(fade)
        musicToken = musicToken + 1
        local sound = musicSound
        musicSound = nil
        if sound then
            if fade == false then
                pcall(function() sound:Stop(); sound:Destroy() end)
            else
                pcall(function()
                    TweenService:Create(sound, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()
                end)
                task.delay(1.6, function()
                    pcall(function() if sound and sound.Parent then sound:Stop(); sound:Destroy() end end)
                end)
            end
        end
        musicRefresh()
    end

    local function playMusic(index)
        index = tonumber(index) or selectedMusicSong
        local total = #MUSIC_PLAYER_OPTIONS
        if total <= 0 then return end
        if index < 1 then index = total end
        if index > total then index = 1 end
        selectedMusicSong = index
        _G.CrystalMusicSelectedSong = index
        stopMusic(true)
        local token = musicToken
        musicRefresh()
        task.spawn(function()
            local option = MUSIC_PLAYER_OPTIONS[index]
            local soundId = cacheSong(option)
            if token ~= musicToken then return end
            if not soundId then
                warn("[snow.vs] Music Player: song failed")
                return
            end
            local sound = Instance.new("Sound")
            sound.Name = "CrystalMusicPlayer"
            sound.Volume = musicPlayerVolume
            sound.PlaybackSpeed = musicPlayerSpeed
            sound.Looped = false
            sound.SoundId = soundId
            sound.Parent = SoundService
            musicSound = sound

            local started = tick()
            while sound and sound.Parent and not sound.IsLoaded and tick() - started < 15 do task.wait(0.05) end
            if token ~= musicToken then
                pcall(function() if sound and sound.Parent then sound:Destroy() end end)
                return
            end
            pcall(function() sound.TimePosition = 0; sound:Play() end)
            musicRefresh()

            local endedConn
            endedConn = sound.Ended:Connect(function()
                if endedConn then pcall(function() endedConn:Disconnect() end) end
                if token ~= musicToken then return end
                if musicLoopEnabled then
                    playMusic(selectedMusicSong)
                elseif musicShuffleEnabled then
                    playMusic(musicRandomIndex())
                elseif musicAutoPlayNext then
                    playMusic(selectedMusicSong + 1)
                else
                    stopMusic(false)
                end
            end)

            task.spawn(function()
                while token == musicToken and sound and sound.Parent do
                    local len = sound.TimeLength
                    if len and len > 1 then
                        local remaining = len - sound.TimePosition
                        if remaining <= 1.6 and sound.IsPlaying and sound:GetAttribute("_crystalFaded") ~= true then
                            sound:SetAttribute("_crystalFaded", true)
                            local d = math.clamp(remaining - 0.05, 0.2, 1.5)
                            pcall(function()
                                TweenService:Create(sound, TweenInfo.new(d, Enum.EasingStyle.Linear), {Volume = 0}):Play()
                            end)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end)
    end

    local function toggleMusic()
        local sound = musicSound
        if not sound or not sound.Parent then
            playMusic(selectedMusicSong)
            return
        end
        if sound.IsPlaying then pcall(function() sound:Pause() end) else pcall(function() sound:Resume() end) end
        musicRefresh()
    end

    local function seekMusic(delta)
        local sound = musicSound
        if not sound or not sound.Parent then return end
        local len = sound.TimeLength or 0
        local sp = tonumber(musicPlayerSpeed) or 1
        if sp <= 0 then sp = 1 end
        local newPos = sound.TimePosition + ((tonumber(delta) or 0) * sp)
        if newPos < 0 then newPos = 0 end
        if len > 0 and newPos > len - 0.2 then newPos = math.max(len - 0.2, 0) end
        pcall(function() sound.TimePosition = newPos end)
        if len > 0 and len - newPos > 1.8 then
            pcall(function() sound:SetAttribute("_crystalFaded", false); sound.Volume = musicPlayerVolume end)
        end
        musicRefresh()
    end

    local function saveMusicState()
        _G.CrystalMusicSelectedSong = selectedMusicSong
        _G.CrystalMusicVolume = musicPlayerVolume
        _G.CrystalMusicSpeed = musicPlayerSpeed
        _G.CrystalMusicAutoPlayNext = musicAutoPlayNext
        _G.CrystalMusicShuffle = musicShuffleEnabled
        _G.CrystalMusicLoop = musicLoopEnabled
        if F and F.saveConfig then pcall(F.saveConfig) end
    end

    _G.CrystalMusic = {
        tracks = MUSIC_PLAYER_OPTIONS,
        play = playMusic,
        toggle = toggleMusic,
        next = function()
            if musicShuffleEnabled then playMusic(musicRandomIndex()) else playMusic(selectedMusicSong + 1) end
            saveMusicState()
        end,
        prev = function()
            if musicShuffleEnabled then playMusic(musicRandomIndex()) else playMusic(selectedMusicSong - 1) end
            saveMusicState()
        end,
        seek = seekMusic,
        getName = musicName,
        getIndex = function() return selectedMusicSong end,
        getVolume = function() return musicPlayerVolume end,
        getSpeed = function() return musicPlayerSpeed end,
        isPlaying = function() return musicSound and musicSound.Parent and musicSound.IsPlaying end,
        getSound = function() return musicSound end,
        setVolume = function(v)
            musicPlayerVolume = math.clamp(math.floor((tonumber(v) or 1) * 100 + 0.5) / 100, 0, 2)
            if musicSound and musicSound.Parent and musicSound:GetAttribute("_crystalFaded") ~= true then musicSound.Volume = musicPlayerVolume end
            saveMusicState(); musicRefresh()
        end,
        setSpeed = function(v)
            musicPlayerSpeed = math.clamp(math.floor((tonumber(v) or 1) * 10 + 0.5) / 10, 0.1, 2)
            if musicSound and musicSound.Parent then musicSound.PlaybackSpeed = musicPlayerSpeed end
            saveMusicState(); musicRefresh()
        end,
        setAutoNext = function(v) musicAutoPlayNext = v == true; saveMusicState(); musicRefresh() end,
        setShuffle = function(v) musicShuffleEnabled = v == true; saveMusicState(); musicRefresh() end,
        setLoop = function(v) musicLoopEnabled = v == true; saveMusicState(); musicRefresh() end,
        stop = function() stopMusic(false) end,
    }
end

-- ===== CRYSTAL MUSIC PLAYER UI (logo/estrutura do AMBITIOUS, adaptado ao CRYSTAL) =====
do
    local musicRow = mkRow(pageSYS, 36)
    mkLabel(musicRow, "Music Player")
    local openBtn = Instance.new("TextButton", musicRow)
    openBtn.Size = UDim2.new(0, 82, 0, 24)
    openBtn.Position = UDim2.new(1, -94, 0.5, -12)
    openBtn.BackgroundColor3 = Color3.fromRGB(18,18,20)
    openBtn.BorderSizePixel = 0
    openBtn.Text = "OPEN"
    openBtn.TextColor3 = COLORS.white
    openBtn.Font = Enum.Font.GothamBlack
    openBtn.TextSize = 10
    openBtn.AutoButtonColor = false
    corner(openBtn, 8)
    stroke(openBtn, COLORS.stroke, 1, 0.75)

    local mpGui = nil

    local function fmtTime(t)
        t = math.max(0, math.floor(tonumber(t) or 0))
        return string.format("%d:%02d", math.floor(t/60), t%60)
    end

    local function smallBtn(parent, name, text, size, pos, textSize)
        local b = Instance.new("TextButton")
        b.Name = name
        b.Size = size
        b.Position = pos
        b.BackgroundColor3 = Color3.fromRGB(18,18,20)
        b.BackgroundTransparency = 0.05
        b.BorderSizePixel = 0
        b.Text = text
        b.TextColor3 = COLORS.white
        b.Font = Enum.Font.GothamBlack
        b.TextSize = textSize or 12
        b.AutoButtonColor = false
        b.Parent = parent
        corner(b, 9)
        stroke(b, COLORS.stroke, 1, 0.7)
        return b
    end

    local function toggleRow(parent, label, getVal, setVal, y)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1,-24,0,34)
        row.Position = UDim2.new(0,12,0,y)
        row.BackgroundColor3 = Color3.fromRGB(18,18,20)
        row.BorderSizePixel = 0
        corner(row,8)
        stroke(row, COLORS.stroke, 1, 0.7)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1,-86,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = COLORS.white
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local b = Instance.new("TextButton", row)
        b.Size = UDim2.new(0,58,0,22)
        b.Position = UDim2.new(1,-68,0.5,-11)
        b.BackgroundColor3 = Color3.fromRGB(8,8,10)
        b.BorderSizePixel = 0
        b.TextColor3 = COLORS.white
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 10
        b.AutoButtonColor = false
        corner(b,11)
        stroke(b, COLORS.stroke, 1, 0.6)

        local function apply(v)
            b.Text = v and "ON" or "OFF"
            b.BackgroundColor3 = v and Color3.fromRGB(70,70,75) or Color3.fromRGB(8,8,10)
        end
        apply(getVal() == true)
        b.Activated:Connect(function()
            local v = not (getVal() == true)
            setVal(v)
            apply(v)
        end)
        return function(v) apply(v) end
    end

    local function closeMusicPlayer()
        _G.CrystalMusicRefreshUI = nil
        if mpGui and mpGui.Parent then
            local g = mpGui
            mpGui = nil
            pcall(function() g:Destroy() end)
        else
            mpGui = nil
        end
    end

    local function openMusicPlayer()
        if mpGui and mpGui.Parent then closeMusicPlayer(); return end

        local parent
        pcall(function() if type(gethui) == "function" then parent = gethui() end end)
        if not parent then parent = game:GetService("CoreGui") end
        if not parent then parent = LP:FindFirstChildOfClass("PlayerGui") end

        mpGui = Instance.new("ScreenGui")
        mpGui.Name = "CrystalMusicPlayer"
        mpGui.ResetOnSpawn = false
        mpGui.IgnoreGuiInset = true
        mpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        mpGui.DisplayOrder = 9999
        mpGui.Parent = parent

        local backdrop = Instance.new("Frame", mpGui)
        backdrop.Size = UDim2.new(1,0,1,0)
        backdrop.BackgroundColor3 = Color3.new(0,0,0)
        backdrop.BackgroundTransparency = 0.5
        backdrop.BorderSizePixel = 0
        backdrop.ZIndex = 1

        local W,H = 340, 418
        local frame = Instance.new("Frame", mpGui)
        frame.Size = UDim2.new(0,W,0,H)
        frame.Position = UDim2.new(0.5,-W/2,0.5,-H/2)
        frame.BackgroundColor3 = Color3.fromRGB(10,10,12)
        frame.BorderSizePixel = 0
        frame.ZIndex = 2
        corner(frame,16)
        stroke(frame, COLORS.stroke, 1.2, 0.3)

        local titleBar = Instance.new("Frame", frame)
        titleBar.Size = UDim2.new(1,0,0,48)
        titleBar.BackgroundColor3 = Color3.fromRGB(14,14,17)
        titleBar.BackgroundTransparency = 0.1
        titleBar.BorderSizePixel = 0
        titleBar.ZIndex = 3
        corner(titleBar,16)

        local title = Instance.new("TextLabel", titleBar)
        title.Size = UDim2.new(1,-60,1,0)
        title.Position = UDim2.new(0,16,0,0)
        title.BackgroundTransparency = 1
        title.Text = "MUSIC PLAYER"
        title.TextColor3 = COLORS.white
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 4

        local close = smallBtn(titleBar,"Close","X",UDim2.new(0,32,0,32),UDim2.new(1,-40,0,8),13)
        close.Activated:Connect(closeMusicPlayer)

        local song = Instance.new("TextLabel", frame)
        song.Size = UDim2.new(1,-28,0,26)
        song.Position = UDim2.new(0,14,0,56)
        song.BackgroundTransparency = 1
        song.TextColor3 = COLORS.white
        song.Font = Enum.Font.GothamBlack
        song.TextSize = 16
        song.TextXAlignment = Enum.TextXAlignment.Center
        song.TextTruncate = Enum.TextTruncate.AtEnd
        song.ZIndex = 4

        local counter = Instance.new("TextLabel", frame)
        counter.Size = UDim2.new(1,-28,0,14)
        counter.Position = UDim2.new(0,14,0,83)
        counter.BackgroundTransparency = 1
        counter.TextColor3 = COLORS.textDim
        counter.Font = Enum.Font.GothamBold
        counter.TextSize = 10
        counter.TextXAlignment = Enum.TextXAlignment.Center
        counter.ZIndex = 4

        local barBg = Instance.new("Frame", frame)
        barBg.Size = UDim2.new(1,-28,0,6)
        barBg.Position = UDim2.new(0,14,0,105)
        barBg.BackgroundColor3 = Color3.fromRGB(26,26,32)
        barBg.BorderSizePixel = 0
        barBg.ZIndex = 4
        corner(barBg,3)

        local barFill = Instance.new("Frame", barBg)
        barFill.Size = UDim2.new(0,0,1,0)
        barFill.BackgroundColor3 = COLORS.accent
        barFill.BorderSizePixel = 0
        barFill.ZIndex = 5
        corner(barFill,3)

        local cur = Instance.new("TextLabel", frame)
        cur.Size = UDim2.new(0,60,0,14)
        cur.Position = UDim2.new(0,14,0,114)
        cur.BackgroundTransparency = 1
        cur.Text = "0:00"
        cur.TextColor3 = COLORS.textDim
        cur.Font = Enum.Font.GothamBold
        cur.TextSize = 10
        cur.TextXAlignment = Enum.TextXAlignment.Left
        cur.ZIndex = 4

        local total = Instance.new("TextLabel", frame)
        total.Size = UDim2.new(0,60,0,14)
        total.Position = UDim2.new(1,-74,0,114)
        total.BackgroundTransparency = 1
        total.Text = "0:00"
        total.TextColor3 = COLORS.textDim
        total.Font = Enum.Font.GothamBold
        total.TextSize = 10
        total.TextXAlignment = Enum.TextXAlignment.Right
        total.ZIndex = 4

        local ctrl = Instance.new("Frame", frame)
        ctrl.Size = UDim2.new(1,-24,0,50)
        ctrl.Position = UDim2.new(0,12,0,136)
        ctrl.BackgroundTransparency = 1
        ctrl.ZIndex = 4

        local prev = smallBtn(ctrl,"Prev","<",UDim2.new(0,42,0,38),UDim2.new(0,0,0,6),15)
        local back = smallBtn(ctrl,"Back10","<< 10",UDim2.new(0,48,0,40),UDim2.new(0.5,-84,0,5),11)
        local forward = smallBtn(ctrl,"Fwd10","10 >>",UDim2.new(0,48,0,40),UDim2.new(0.5,36,0,5),11)
        local next = smallBtn(ctrl,"Next",">",UDim2.new(0,42,0,38),UDim2.new(1,-42,0,6),15)
        local play = Instance.new("TextButton", ctrl)
        play.Size = UDim2.new(0,58,0,46)
        play.Position = UDim2.new(0.5,-29,0,2)
        play.BackgroundColor3 = COLORS.accent
        play.BorderSizePixel = 0
        play.TextColor3 = COLORS.white
        play.Font = Enum.Font.GothamBlack
        play.TextSize = 11
        play.AutoButtonColor = false
        play.ZIndex = 6
        corner(play,14)
        stroke(play, COLORS.stroke, 1.5, 0.2)

        local setAutoNext = toggleRow(frame,"Auto Play Next",function() return _G.CrystalMusicAutoPlayNext == true end,function(v) _G.CrystalMusic.setAutoNext(v) end,194)
        local setShuffle = toggleRow(frame,"Shuffle",function() return _G.CrystalMusicShuffle == true end,function(v) _G.CrystalMusic.setShuffle(v) end,236)
        local setLoop = toggleRow(frame,"Loop",function() return _G.CrystalMusicLoop == true end,function(v) _G.CrystalMusic.setLoop(v) end,278)

        local volFrame = Instance.new("Frame", frame)
        volFrame.Size = UDim2.new(1,-24,0,36)
        volFrame.Position = UDim2.new(0,12,1,-90)
        volFrame.BackgroundColor3 = Color3.fromRGB(18,18,22)
        volFrame.BorderSizePixel = 0
        corner(volFrame,9)
        stroke(volFrame,COLORS.stroke,1,0.6)

        local vl = Instance.new("TextLabel", volFrame)
        vl.Size = UDim2.new(1,-140,1,0)
        vl.Position = UDim2.new(0,12,0,0)
        vl.BackgroundTransparency = 1
        vl.Text = "Volume"
        vl.TextColor3 = COLORS.white
        vl.Font = Enum.Font.GothamBold
        vl.TextSize = 12
        vl.TextXAlignment = Enum.TextXAlignment.Left

        local vd = smallBtn(volFrame,"VolDown","<",UDim2.new(0,26,0,24),UDim2.new(1,-120,0.5,-12),13)
        local vv = Instance.new("TextLabel", volFrame)
        vv.Size = UDim2.new(0,46,0,24)
        vv.Position = UDim2.new(1,-88,0.5,-12)
        vv.BackgroundColor3 = Color3.fromRGB(8,8,14)
        vv.BorderSizePixel = 0
        vv.TextColor3 = COLORS.white
        vv.Font = Enum.Font.GothamBlack
        vv.TextSize = 12
        vv.TextXAlignment = Enum.TextXAlignment.Center
        corner(vv,7); stroke(vv,COLORS.stroke,1,0.6)
        local vu = smallBtn(volFrame,"VolUp",">",UDim2.new(0,26,0,24),UDim2.new(1,-36,0.5,-12),13)

        local spFrame = Instance.new("Frame", frame)
        spFrame.Size = UDim2.new(1,-24,0,36)
        spFrame.Position = UDim2.new(0,12,1,-48)
        spFrame.BackgroundColor3 = Color3.fromRGB(18,18,22)
        spFrame.BorderSizePixel = 0
        corner(spFrame,9)
        stroke(spFrame,COLORS.stroke,1,0.6)

        local sl = Instance.new("TextLabel", spFrame)
        sl.Size = UDim2.new(1,-140,1,0)
        sl.Position = UDim2.new(0,12,0,0)
        sl.BackgroundTransparency = 1
        sl.Text = "Speed"
        sl.TextColor3 = COLORS.white
        sl.Font = Enum.Font.GothamBold
        sl.TextSize = 12
        sl.TextXAlignment = Enum.TextXAlignment.Left

        local sd = smallBtn(spFrame,"SpdDown","<",UDim2.new(0,26,0,24),UDim2.new(1,-120,0.5,-12),13)
        local sv = Instance.new("TextLabel", spFrame)
        sv.Size = UDim2.new(0,46,0,24)
        sv.Position = UDim2.new(1,-88,0.5,-12)
        sv.BackgroundColor3 = Color3.fromRGB(8,8,14)
        sv.BorderSizePixel = 0
        sv.TextColor3 = COLORS.white
        sv.Font = Enum.Font.GothamBlack
        sv.TextSize = 12
        sv.TextXAlignment = Enum.TextXAlignment.Center
        corner(sv,7); stroke(sv,COLORS.stroke,1,0.6)
        local su = smallBtn(spFrame,"SpdUp",">",UDim2.new(0,26,0,24),UDim2.new(1,-36,0.5,-12),13)

        prev.Activated:Connect(function() _G.CrystalMusic.prev() end)
        next.Activated:Connect(function() _G.CrystalMusic.next() end)
        back.Activated:Connect(function() _G.CrystalMusic.seek(-10) end)
        forward.Activated:Connect(function() _G.CrystalMusic.seek(10) end)
        play.Activated:Connect(function() _G.CrystalMusic.toggle() end)
        vd.Activated:Connect(function() _G.CrystalMusic.setVolume(_G.CrystalMusic.getVolume()-0.05) end)
        vu.Activated:Connect(function() _G.CrystalMusic.setVolume(_G.CrystalMusic.getVolume()+0.05) end)
        sd.Activated:Connect(function() _G.CrystalMusic.setSpeed(_G.CrystalMusic.getSpeed()-0.1) end)
        su.Activated:Connect(function() _G.CrystalMusic.setSpeed(_G.CrystalMusic.getSpeed()+0.1) end)

        local function refresh()
            if not mpGui or not mpGui.Parent then return end
            local s = _G.CrystalMusic.getSound()
            local alive = s and s.Parent
            song.Text = _G.CrystalMusic.getName()
            counter.Text = "TRACK "..tostring(_G.CrystalMusic.getIndex()).." / "..tostring(#_G.CrystalMusic.tracks)
            vv.Text = string.format("%.2f",_G.CrystalMusic.getVolume())
            sv.Text = string.format("%.1fx",_G.CrystalMusic.getSpeed())
            play.Text = (alive and s.IsPlaying) and "PAUSE" or "PLAY"
            setAutoNext(_G.CrystalMusicAutoPlayNext == true)
            setShuffle(_G.CrystalMusicShuffle == true)
            setLoop(_G.CrystalMusicLoop == true)
            if alive then
                local sp = tonumber(_G.CrystalMusic.getSpeed()) or 1
                if sp <= 0 then sp = 1 end
                local len = (s.TimeLength or 0) / sp
                local pos = (s.TimePosition or 0) / sp
                if len > 0 then
                    barFill.Size = UDim2.new(math.clamp(pos/len,0,1),0,1,0)
                    cur.Text = fmtTime(pos)
                    total.Text = fmtTime(len)
                else
                    barFill.Size = UDim2.new(0,0,1,0)
                    cur.Text = "0:00"; total.Text = "--:--"
                end
            else
                barFill.Size = UDim2.new(0,0,1,0)
                cur.Text = "0:00"; total.Text = "0:00"
            end
        end

        _G.CrystalMusicRefreshUI = refresh
        refresh()

        task.spawn(function()
            while mpGui and mpGui.Parent do
                pcall(refresh)
                task.wait(0.2)
            end
        end)

        backdrop.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                closeMusicPlayer()
            end
        end)
    end

    openBtn.Activated:Connect(openMusicPlayer)
    _G.CrystalMusicCloseUI = closeMusicPlayer
end

section(pageSYS, "Mobile") VS.setMoveButtonsVisual = mkToggle(pageSYS, "Move Buttons", function(on) S.moveButtons = on and true or false S.lockMobileButtons = not S.moveButtons; F.saveConfig() end) VS.setLockMobileButtonsVisual = VS.setMoveButtonsVisual VS.setAllLockVisual = mkToggle(pageSYS, "All Lock Buttons", function(on) S.allLockButtons = on and true or false if S.allLockButtons then S.moveButtons = true; S.lockMobileButtons = false if VS.setMoveButtonsVisual then pcall(function() VS.setMoveButtonsVisual(true) end) end
end F.saveConfig() end) S.setAllLockVisual = VS.setAllLockVisual task.defer(function() if VS.setMoveButtonsVisual then VS.setMoveButtonsVisual(S.moveButtons == true) end if VS.setAllLockVisual then VS.setAllLockVisual(S.allLockButtons == true) end end) VS.setHideMobileVisual = mkToggle(pageSYS, "Hide Mobile Buttons", function(on) S.hideMobileButtons = on and true or false F.applyMobileButtonsHidden(); F.saveConfig() end) do
local row = mkRow(pageSYS, 34); mkLabel(row, "Mobile Buttons Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5
corner(minusBtn, 8); local sizeLbl = Instance.new("TextLabel", row); sizeLbl.Size = UDim2.new(0, 44, 0, 24); sizeLbl.Position = UDim2.new(1, -80, 0.5, -12); sizeLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); sizeLbl.BorderSizePixel = 0
sizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80); sizeLbl.TextColor3 = COLORS.white; sizeLbl.Font = Enum.Font.GothamBold; sizeLbl.TextSize = 11; sizeLbl.ZIndex = 5; corner(sizeLbl, 8); UI.mobileSizeLbl = sizeLbl; local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8)
local function refreshSizeLbl() if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80) end end minusBtn.Activated:Connect(function() S.mobileButtonScale = math.clamp((S.mobileButtonScale or 0.80) - 0.05, 0.30, 1.90) F.applyMobileButtonSize(); refreshSizeLbl(); F.saveConfig() end) plusBtn.Activated:Connect(function() S.mobileButtonScale = math.clamp((S.mobileButtonScale or 0.80) + 0.05, 0.30, 1.90) F.applyMobileButtonSize(); refreshSizeLbl(); F.saveConfig() end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "ui smale SIZE"); local miniMinus = Instance.new("TextButton", row); miniMinus.Size = UDim2.new(0, 28, 0, 24); miniMinus.Position = UDim2.new(1, -112, 0.5, -12); miniMinus.BackgroundColor3 = Color3.fromRGB(18, 18, 20); miniMinus.BorderSizePixel = 0; miniMinus.Text = "−"; miniMinus.TextColor3 = COLORS.white; miniMinus.Font = Enum.Font.GothamBold; miniMinus.TextSize = 16; miniMinus.ZIndex = 5; corner(miniMinus, 8)
local miniSizeLbl = Instance.new("TextLabel", row); miniSizeLbl.Size = UDim2.new(0, 44, 0, 24); miniSizeLbl.Position = UDim2.new(1, -80, 0.5, -12); miniSizeLbl.BackgroundColor3 = Color3.fromRGB(18, 18, 20); miniSizeLbl.BorderSizePixel = 0; miniSizeLbl.Text = string.format("%.2f", S.miniUiScale or 1.00); miniSizeLbl.TextColor3 = COLORS.white; miniSizeLbl.Font = Enum.Font.GothamBold; miniSizeLbl.TextSize = 11; miniSizeLbl.ZIndex = 5; corner(miniSizeLbl, 8); UI.miniSizeLbl = miniSizeLbl
local miniPlus = Instance.new("TextButton", row); miniPlus.Size = UDim2.new(0, 28, 0, 24); miniPlus.Position = UDim2.new(1, -32, 0.5, -12); miniPlus.BackgroundColor3 = Color3.fromRGB(18, 18, 20); miniPlus.BorderSizePixel = 0; miniPlus.Text = "+"; miniPlus.TextColor3 = COLORS.white; miniPlus.Font = Enum.Font.GothamBold; miniPlus.TextSize = 16; miniPlus.ZIndex = 5; corner(miniPlus, 8)
local function refreshMiniLbl() if UI.miniSizeLbl then UI.miniSizeLbl.Text = string.format("%.2f", S.miniUiScale or 1.00) end if _G.__VersincMiniScaleObj then _G.__VersincMiniScaleObj.Scale = S.miniUiScale or 1.00 end end
miniMinus.Activated:Connect(function() S.miniUiScale = math.clamp((S.miniUiScale or 1.00) - 0.05, 0.40, 2.00) refreshMiniLbl(); F.saveConfig() end)
miniPlus.Activated:Connect(function() S.miniUiScale = math.clamp((S.miniUiScale or 1.00) + 0.05, 0.40, 2.00) refreshMiniLbl(); F.saveConfig() end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Reset Mobile Buttons"); local resetBtn = Instance.new("TextButton", row); resetBtn.Size = UDim2.new(0, 72, 0, 24); resetBtn.Position = UDim2.new(1, -82, 0.5, -12); resetBtn.BackgroundColor3 = Color3.fromRGB(238, 238, 238); resetBtn.BorderSizePixel = 0; resetBtn.Text = "RESET"; resetBtn.TextColor3 = Color3.fromRGB(0, 0, 0); resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 11; resetBtn.ZIndex = 5; corner(resetBtn, 8) resetBtn.Activated:Connect(function() F.resetMobileButtons()
if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80) end if VS.setHideMobileVisual then VS.setHideMobileVisual(false) end end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Save Config"); local saveBtn = Instance.new("TextButton", row); saveBtn.Size = UDim2.new(0, 72, 0, 24); saveBtn.Position = UDim2.new(1, -82, 0.5, -12); saveBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20); saveBtn.BackgroundTransparency = 0.1; saveBtn.BorderSizePixel = 0; saveBtn.Text = "SAVE"; saveBtn.TextColor3 = COLORS.white; saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 11; saveBtn.ZIndex = 5; corner(saveBtn, 8); stroke(saveBtn, COLORS.stroke, 1, 0.75) saveBtn.Activated:Connect(function() if S._anyKeyListening then return end
saveBtn.Text = "..."; local ok = F.saveConfig(true) pcall(function() if F.saveMobileButtonsOnly then F.saveMobileButtonsOnly() end end) saveBtn.Text = ok and "SAVED" or "FAIL" if UI.saveStatusLbl then UI.saveStatusLbl.Text = ok and ("Saved " .. os.date("%H:%M:%S")) or "Save failed"; UI.saveStatusLbl.TextColor3 = ok and Color3.fromRGB(100, 220, 160) or Color3.fromRGB(255, 120, 120) end task.delay(1.4, function() if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE" end end) end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Reset All Configs"); local resetCfgBtn = Instance.new("TextButton", row); resetCfgBtn.Size = UDim2.new(0, 72, 0, 24); resetCfgBtn.Position = UDim2.new(1, -82, 0.5, -12); resetCfgBtn.BackgroundColor3 = Color3.fromRGB(238, 80, 80); resetCfgBtn.BackgroundTransparency = 0.05; resetCfgBtn.BorderSizePixel = 0; resetCfgBtn.Text = "RESET"; resetCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255); resetCfgBtn.Font = Enum.Font.GothamBold; resetCfgBtn.TextSize = 11; resetCfgBtn.ZIndex = 5; corner(resetCfgBtn, 8); stroke(resetCfgBtn, Color3.fromRGB(255, 140, 140), 1, 0.45)
resetCfgBtn.Activated:Connect(function() if S._anyKeyListening then return end resetCfgBtn.Text = "..."; local ok = F.resetAllConfig(); resetCfgBtn.Text = ok and "DONE" or "OK" task.delay(1.5, function() if resetCfgBtn and resetCfgBtn.Parent then resetCfgBtn.Text = "RESET" end end) end) end do
local row = mkRow(pageSYS, 28); local st = Instance.new("TextLabel", row); st.Size = UDim2.new(1, -12, 1, 0); st.Position = UDim2.new(0, 10, 0, 0); st.BackgroundTransparency = 1; st.Text = "Save: ready"; st.TextColor3 = COLORS.textDim; st.Font = Enum.Font.GothamMedium; st.TextSize = 11; st.TextXAlignment = Enum.TextXAlignment.Left; st.ZIndex = 5; UI.saveStatusLbl = st end task.defer(function() if UI.saveStatusLbl then UI.saveStatusLbl.Text = "Save: manual only"; UI.saveStatusLbl.TextColor3 = COLORS.textDim end end) lo = 0 section(pageKEYS, "Speed Keybinds")
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Speed Key"); mkKB(row, KB.SpeedToggle, function(k, isGp) if isGp then KB.SpeedToggle.gp = k; KB.SpeedToggle.kb = nil else KB.SpeedToggle.kb = k; KB.SpeedToggle.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Lagger Key"); mkKB(row, KB.LaggerToggle, function(k, isGp) if isGp then KB.LaggerToggle.gp = k; KB.LaggerToggle.kb = nil else KB.LaggerToggle.kb = k; KB.LaggerToggle.gp = nil end; F.saveConfig() end) end section(pageKEYS, "Combat Keybinds")
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Bat Key"); mkKB(row, KB.AutoBat, function(k, isGp) if isGp then KB.AutoBat.gp = k; KB.AutoBat.kb = nil else KB.AutoBat.kb = k; KB.AutoBat.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "TP Bat Key"); mkKB(row, KB.TPBat, function(k, isGp) if isGp then KB.TPBat.gp = k; KB.TPBat.kb = nil; TP_BAT_CONTROLLER = k else KB.TPBat.kb = k; KB.TPBat.gp = nil; TP_BAT_KEY = k end F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Insta Reset Key"); mkKB(row, KB.InstaReset, function(k, isGp) if isGp then KB.InstaReset.gp = k; KB.InstaReset.kb = nil else KB.InstaReset.kb = k; KB.InstaReset.gp = nil end; F.saveConfig() end) end section(pageKEYS, "Movement Keybinds") do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Left Key"); mkKB(row, KB.AutoLeft, function(k, isGp) if isGp then KB.AutoLeft.gp = k; KB.AutoLeft.kb = nil else KB.AutoLeft.kb = k; KB.AutoLeft.gp = nil end; F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Right Key"); mkKB(row, KB.AutoRight, function(k, isGp) if isGp then KB.AutoRight.gp = k; KB.AutoRight.kb = nil else KB.AutoRight.kb = k; KB.AutoRight.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Drop Key"); mkKB(row, KB.DropBrainrot, function(k, isGp) if isGp then KB.DropBrainrot.gp = k; KB.DropBrainrot.kb = nil else KB.DropBrainrot.kb = k; KB.DropBrainrot.gp = nil end; F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "TP Down Key"); mkKB(row, KB.TPFloor, function(k, isGp) if isGp then KB.TPFloor.gp = k; KB.TPFloor.kb = nil else KB.TPFloor.kb = k; KB.TPFloor.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Hide UI Key"); mkKB(row, KB.GuiHide, function(k, isGp) if isGp then KB.GuiHide.gp = k; KB.GuiHide.kb = nil else KB.GuiHide.kb = k; KB.GuiHide.gp = nil end; F.saveConfig() end) end UIS.InputBegan:Connect(function(input, gpe) if S._anyKeyListening then return end if input.UserInputType == Enum.UserInputType.Keyboard then
if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end if not isBindableInput(input) then return end local kc = input.KeyCode if kbMatch(KB.LaggerToggle, kc) then F.toggleLaggerMode(); F.saveConfig() elseif kbMatch(KB.SpeedToggle, kc) then F.toggleCarryMode(); F.saveConfig() elseif kbMatch(KB.DropBrainrot, kc) then F.runDrop() elseif kbMatch(KB.TPFloor, kc) then F.runTPFloor() elseif kbMatch(KB.InstaReset, kc) then if cursedInstaReset then cursedInstaReset() end elseif kbMatch(KB.AutoLeft, kc) then S.autoLeftEnabled = not S.autoLeftEnabled
if S.autoLeftEnabled then F.queueAutoLeftStart() else F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end elseif kbMatch(KB.AutoRight, kc) then S.autoRightEnabled = not S.autoRightEnabled if S.autoRightEnabled then F.queueAutoRightStart() else F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end elseif kbMatch(KB.AutoBat, kc) then if not S.autoBatEnabled then F.queueAutoBatStart() if S.autoBatSetVisual then S.autoBatSetVisual(true) end else S.autoBatEnabled = false; S.disableAutoBat()
if S.autoBatSetVisual then S.autoBatSetVisual(false) end end elseif kbMatch(KB.TPBat, kc) then setTPBatState(not tpBatEnabled) elseif kbMatch(KB.GuiHide, kc) then if main.Visible then hideGui() else showGui() end end end) do local ibGui = Instance.new("ScreenGui"); ibGui.Name = "CrystalVSInfoBar"; ibGui.ResetOnSpawn = false; ibGui.IgnoreGuiInset = true; ibGui.DisplayOrder = 12 local okp = pcall(function() if gethui then ibGui.Parent = gethui() end end) if not ibGui.Parent then pcall(function() ibGui.Parent = game:GetService("CoreGui") end) end
if not ibGui.Parent then ibGui.Parent = LP:WaitForChild("PlayerGui") end local IB_BG = Color3.fromRGB(0, 0, 0); local IB_BORDER = CRYSTAL_GREEN_SOFT; local IB_VAL = CRYSTAL_GREEN; local IB_TRACK = Color3.fromRGB(0, 0, 0); local infoBar = Instance.new("Frame", ibGui); infoBar.Name = "StealBar"; infoBar.Size = UDim2.new(0, 384, 0, 78); infoBar.Position = UDim2.new(0.5, -192, 1, -92) do local sp = S.stealBarPos if type(sp) == "table" and tonumber(sp.xs) and tonumber(sp.ys) then infoBar.Position = UDim2.new(tonumber(sp.xs), tonumber(sp.xo) or 0, tonumber(sp.ys), tonumber(sp.yo) or 0) end
end infoBar.BackgroundColor3 = IB_BG; infoBar.BackgroundTransparency = 0.08; infoBar.BorderSizePixel = 0; infoBar.Active = true; infoBar.Visible = false; corner(infoBar, 10); stroke(infoBar, IB_BORDER, 1, 0.25) do local pbScale = Instance.new("UIScale", infoBar); pbScale.Name = "PBScale"; _G.__VersincProgressBarScaleObj = pbScale if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale or 100) else pbScale.Scale = ((tonumber(S.progressBarScale) or 100) / 100) end end do
local avRing = Instance.new("Frame", infoBar); avRing.Name = "AvatarRing"; avRing.Size = UDim2.new(0, 36, 0, 36); avRing.Position = UDim2.new(0, 8, 0.5, -18); avRing.Visible = false; avRing.BackgroundColor3 = IB_BORDER; avRing.BorderSizePixel = 0; avRing.ZIndex = 3; corner(avRing, 18); local av = Instance.new("ImageLabel", avRing); av.Size = UDim2.new(1, -2, 1, -2); av.Position = UDim2.new(0, 1, 0, 1); av.BackgroundColor3 = IB_BG; av.BorderSizePixel = 0; av.ScaleType = Enum.ScaleType.Crop; av.ZIndex = 4; corner(av, 17) pcall(function()
av.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end) end do local acc = Instance.new("Frame", infoBar); acc.Size = UDim2.new(0, 2, 0.55, 0); acc.Position = UDim2.new(0, 0, 0.225, 0); acc.BackgroundColor3 = IB_VAL; acc.BackgroundTransparency = 0.2; acc.BorderSizePixel = 0; corner(acc, 2) end local function _pingMs() local ms = 0 pcall(function() local Stats = game:GetService("Stats") local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping") if item then local v = item:GetValue()
if type(v) == "number" then ms = math.floor(v + 0.5) elseif type(v) == "string" then ms = math.floor(tonumber((v:match("[%d%.]+")) or 0) + 0.5) end end end) if ms <= 0 then pcall(function() ms = math.floor(((LP:GetNetworkPing() or 0) * 1000) + 0.5) end) end return math.max(0, ms) end local function _clock() local t = os.date("*t"); local h, ampm = t.hour, "AM" if h >= 12 then ampm = "PM"; if h > 12 then h = h - 12 end end if h == 0 then h = 12 end return string.format("%d:%02d %s", h, t.min, ampm) end local _execName = nil local function _executor() if _execName then return _execName end
local name pcall(function() if identifyexecutor then local a, b = identifyexecutor(); name = a or b end end) if not name or name == "" then pcall(function() if getexecutorname then name = getexecutorname() end end) end if type(name) ~= "string" or name == "" then name = "Unknown" end name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "") if #name > 12 then name = name:sub(1, 12) end _execName = name return name end local function _infoText() return "RAD: " .. tostring(Steal.StealRadius) .. "  DUR: " .. tostring(Steal.StealDuration) .. "s  |  "
.. tostring(_pingMs()) .. "ms  |  " .. _clock() .. "  |  " .. _executor() end
do local stealTitle = Instance.new("TextLabel", infoBar); stealTitle.Name = "StealTitle"; stealTitle.Size = UDim2.new(0, 110, 0, 18); stealTitle.Position = UDim2.new(0, 16, 0, 12); stealTitle.BackgroundTransparency = 1; stealTitle.Text = "STEAL"; stealTitle.TextColor3 = IB_VAL; stealTitle.Font = Enum.Font.GothamBlack; stealTitle.TextSize = 14; stealTitle.TextXAlignment = Enum.TextXAlignment.Left; stealTitle.ZIndex = 3
local vDiv = Instance.new("Frame", infoBar); vDiv.Name = "Divider"; vDiv.Size = UDim2.new(0, 2, 0, 50); vDiv.Position = UDim2.new(0, 112, 0, 14); vDiv.BackgroundColor3 = Color3.fromRGB(140, 140, 140); vDiv.BackgroundTransparency = 0.35; vDiv.BorderSizePixel = 0; vDiv.ZIndex = 3 end
progressPct = Instance.new("TextLabel", infoBar); progressPct.Size = UDim2.new(0, 110, 0, 32); progressPct.Position = UDim2.new(0, 16, 0, 34); progressPct.BackgroundTransparency = 1; progressPct.Text = "0%"; progressPct.TextColor3 = IB_VAL; progressPct.Font = Enum.Font.GothamBlack; progressPct.TextSize = 28; progressPct.TextXAlignment = Enum.TextXAlignment.Left; progressPct.ZIndex = 3
progressRadLbl = Instance.new("TextLabel", infoBar); progressRadLbl.Size = UDim2.new(1, -142, 0, 20); progressRadLbl.Position = UDim2.new(0, 130, 0, 44); progressRadLbl.BackgroundTransparency = 1; progressRadLbl.Text = "FPS  0        PING  0ms"; progressRadLbl.TextColor3 = IB_VAL; progressRadLbl.Font = Enum.Font.GothamBold; progressRadLbl.TextSize = 13; progressRadLbl.TextXAlignment = Enum.TextXAlignment.Left; progressRadLbl.ZIndex = 3
do local pTrack = Instance.new("Frame", infoBar); pTrack.Size = UDim2.new(1, -146, 0, 20); pTrack.Position = UDim2.new(0, 130, 0, 16); pTrack.BackgroundColor3 = Color3.fromRGB(62, 64, 66); pTrack.BorderSizePixel = 0; pTrack.ZIndex = 2 corner(pTrack, 10); progressFill = Instance.new("Frame", pTrack); progressFill.Size = UDim2.new(0, 0, 1, 0); progressFill.BackgroundColor3 = CRYSTAL_GREEN; progressFill.BorderSizePixel = 0; progressFill.ZIndex = 3 corner(progressFill, 10) end do local dn, ds, sp, moved = false, nil, nil, false local function persistStealBar()
local p = infoBar.Position; S.stealBarPos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset } pcall(function() if F.saveConfig then F.saveConfig(true) end end) end infoBar.InputBegan:Connect(function(inp) if S.guiLocked == true then return end if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dn = true; moved = false; ds = inp.Position; sp = infoBar.Position inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dn = false if moved then persistStealBar() end end end) end end)
UIS.InputChanged:Connect(function(inp) if dn and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then if S.guiLocked == true then dn = false; return end local d = inp.Position - ds; moved = true; infoBar.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end) end task.spawn(function() local _fr, _lt, _sm = 0, tick(), 0 local _fc = RunService.RenderStepped:Connect(function() _fr = _fr + 1 end) while infoBar and infoBar.Parent do task.wait(0.25) pcall(function() infoBar.Visible = autoStealEnabled == true local now = tick(); local dt = now - _lt if dt >= 0.2 then local inst = _fr / dt; _sm = (_sm == 0) and inst or (_sm * 0.5 + inst * 0.5); _fr = 0; _lt = now end progressRadLbl.Text = string.format("FPS  %d        PING  %dms", math.floor(_sm + 0.5), _pingMs()) end) end pcall(function() _fc:Disconnect() end) end) end end function F.loadConfigKeys() local raw = nil
if _isfile(CONFIG_FILE) then raw = _readfile(CONFIG_FILE) elseif _isfile(CONFIG_FILE_LEGACY) then raw = _readfile(CONFIG_FILE_LEGACY) end if not raw or raw == "" then return end local ok,cfg=pcall(function() return HS:JSONDecode(raw) end) if not ok or not cfg then return end _savedCfg=cfg local function lk(e,d) if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end;if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] end end
lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey); lk(KB.AutoBat,cfg.autoBatKey);lk(KB.TPBat,cfg.tpBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey); lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey) if type(cfg.speedProfiles) == "table" then for _, name in ipairs({"V1", "V2"}) do local p = cfg.speedProfiles[name]; if type(p) == "table" then S.speedProfiles[name] = { normalSpeed = tonumber(p.normalSpeed) or S.speedProfiles[name].normalSpeed, carrySpeed = tonumber(p.carrySpeed) or S.speedProfiles[name].carrySpeed, laggerSpeed = tonumber(p.laggerSpeed) or S.speedProfiles[name].laggerSpeed, laggerCarrySpeed = tonumber(p.laggerCarrySpeed) or S.speedProfiles[name].laggerCarrySpeed } end end end S.speedMethod = (cfg.speedMethod == "V2") and "V2" or "V1" local loadedSpeedProfile = S.speedProfiles[S.speedMethod] if loadedSpeedProfile then NS = loadedSpeedProfile.normalSpeed; CS = loadedSpeedProfile.carrySpeed; S.LAGGER_SPEED = loadedSpeedProfile.laggerSpeed; S.LAGGER_CARRY_SPEED = loadedSpeedProfile.laggerCarrySpeed else if cfg.normalSpeed then NS=cfg.normalSpeed end if cfg.carrySpeed then CS=cfg.carrySpeed end end if cfg.selectedStealMode == "Semi" or cfg.selectedStealMode == "Normal" then selectedStealMode = cfg.selectedStealMode end if type(cfg.aceStealRadii)=="table" then
AceStealRadii.Normal = tonumber(cfg.aceStealRadii.Normal) or AceStealRadii.Normal; AceStealRadii.Semi = tonumber(cfg.aceStealRadii.Semi) or AceStealRadii.Semi end if cfg.grabRadius and type(cfg.grabRadius)=="number" then autoStealRadius=cfg.grabRadius; Steal.StealRadius=cfg.grabRadius elseif selectedStealMode=="Semi" then autoStealRadius=AceStealRadii.Semi; Steal.StealRadius=autoStealRadius else autoStealRadius=AceStealRadii.Normal; Steal.StealRadius=autoStealRadius end if cfg.stealDuration and type(cfg.stealDuration)=="number" and cfg.stealDuration >= 0.1 then
Steal.StealDuration = cfg.stealDuration end if cfg.autoGrabStopEnabled ~= nil then autoGrabStopEnabled = cfg.autoGrabStopEnabled == true; Steal.AutoGrabStopEnabled = autoGrabStopEnabled end if cfg.autoGrabStopTime and type(cfg.autoGrabStopTime)=="number" and cfg.autoGrabStopTime > 0 then autoGrabStopTime = cfg.autoGrabStopTime; Steal.AutoGrabStopTime = cfg.autoGrabStopTime end if cfg.autoGrabDelayRadius and type(cfg.autoGrabDelayRadius)=="number" and cfg.autoGrabDelayRadius > 0 then autoGrabDelayRadius = cfg.autoGrabDelayRadius; Steal.AutoGrabDelayRadius = cfg.autoGrabDelayRadius end
Steal.StealRadius = tonumber(autoStealRadius) or Steal.StealRadius or 20 if type(cfg.speedProfiles) ~= "table" then if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then S.LAGGER_SPEED=cfg.laggerSpeed end if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then S.LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end end if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then S.autoTPHeight=cfg.autoTPHeight end if cfg.autoSwing~=nil then S.autoSwingEnabled=cfg.autoSwing==true end if cfg.guiScale and type(cfg.guiScale)=="number" then task.defer(function()
if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale(cfg.guiScale) end end) end if cfg.autoSaveEnabled ~= nil then S.autoSaveEnabled = cfg.autoSaveEnabled == true else S.autoSaveEnabled = true end if cfg.aimbotSpeed and type(cfg.aimbotSpeed) == "number" and cfg.aimbotSpeed > 0 then AIMBOT_SPEED = cfg.aimbotSpeed end if type(cfg.tpBatMode)=="number" and cfg.tpBatMode>=1 and cfg.tpBatMode<=3 then tpBatMode = math.floor(cfg.tpBatMode) else tpBatMode = 1 end
 if type(cfg.antiTPBatVersion)=="number" and cfg.antiTPBatVersion>=1 and cfg.antiTPBatVersion<=4 then
     AntiTPBat.setVersion(math.floor(cfg.antiTPBatVersion))
 end
 if cfg.antiTPBatSpam ~= nil then AntiTPBat.setSpam(cfg.antiTPBatSpam == true) end
 if KB.TPBat.kb then TP_BAT_KEY = KB.TPBat.kb end if KB.TPBat.gp then TP_BAT_CONTROLLER = KB.TPBat.gp end
if cfg.tpBatLegacyKey and Enum.KeyCode[cfg.tpBatLegacyKey] and not (cfg.tpBatKey and type(cfg.tpBatKey)=="table") then TP_BAT_KEY = Enum.KeyCode[cfg.tpBatLegacyKey]; KB.TPBat.kb = TP_BAT_KEY end if type(cfg.mobileButtonPositions) == "table" then _G.VersincMobileButtonPositions = cfg.mobileButtonPositions end if cfg.mobileButtonScale and type(cfg.mobileButtonScale) == "number" then S.mobileButtonScale = cfg.mobileButtonScale end if cfg.miniUiScale and type(cfg.miniUiScale) == "number" then S.miniUiScale = cfg.miniUiScale end if cfg.hideMobileButtons ~= nil then S.hideMobileButtons = cfg.hideMobileButtons == true end if cfg.allLockButtons ~= nil then
S.allLockButtons = cfg.allLockButtons == true pcall(function() if VS and VS.setAllLockVisual then VS.setAllLockVisual(S.allLockButtons) end end) end if cfg.lockMobileButtons ~= nil then S.lockMobileButtons = cfg.lockMobileButtons == true end if cfg.moveButtons ~= nil then S.moveButtons = cfg.moveButtons == true end if type(cfg.stealBarPos) == "table" then S.stealBarPos = cfg.stealBarPos end if cfg.progressBarScale ~= nil then S.progressBarScale = math.clamp(tonumber(cfg.progressBarScale) or 100, 50, 200)
pcall(function() if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale) end end) end end function F.loadConfigState() local cfg=_savedCfg;if not cfg then return end S.currentBgId = "rbxassetid://116587787334634" if type(cfg.bgId) == "string" and cfg.bgId ~= "" then S.currentBgId = cfg.bgId end if cfg.bgId ~= nil then task.defer(function() if _G._VersincApplyBackground then _G._VersincApplyBackground(S.currentBgId, true) end end) end S.bgIntensity = 1 if true then S.currentThemeName = "GREEN" task.defer(function()
if _G._VersincApplyTheme then _G._VersincApplyTheme("GREEN") end end) end if UI.normalBox then UI.normalBox.Text=tostring(NS) end if UI.carryBox then UI.carryBox.Text=tostring(CS) end if UI.laggerBox then UI.laggerBox.Text=tostring(S.LAGGER_SPEED) end if UI.laggerCarryBox then UI.laggerCarryBox.Text=tostring(S.LAGGER_CARRY_SPEED) end if UI.refreshSpeedMethod then UI.refreshSpeedMethod() end if UI.radInput then UI.radInput.Text = tostring(autoStealRadius or Steal.StealRadius or 20) end if UI.stealDurInput then UI.stealDurInput.Text = tostring(Steal.StealDuration or 1.3) end if UI.stopTimeInput then UI.stopTimeInput.Text = tostring(autoGrabStopTime or Steal.AutoGrabStopTime or 1.00) end
if UI.delayRadInput then UI.delayRadInput.Text = tostring(autoGrabDelayRadius or Steal.AutoGrabDelayRadius or 8) end if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.0f", autoStealRadius or Steal.StealRadius or 20) end if UI.laggerBox then UI.laggerBox.Text=tostring(S.LAGGER_SPEED) end if UI.laggerCarryBox then UI.laggerCarryBox.Text=tostring(S.LAGGER_CARRY_SPEED) end if UI.autoTPHeightBox then UI.autoTPHeightBox.Text=tostring(S.autoTPHeight) end if VS.setAutoGrabStopVisual then pcall(function() VS.setAutoGrabStopVisual(autoGrabStopEnabled == true) end) end
task.spawn(function() task.wait(0.2) if cfg.antiRagdollMode and type(cfg.antiRagdollMode)=="number" then S.antiRagdollMode = (cfg.antiRagdollMode == 2) and 2 or 1 end if cfg.aimbotMode and type(cfg.aimbotMode)=="number" then S.aimbotMode = (cfg.aimbotMode == 2) and 2 or 1 end if cfg.antiRagdoll then S.antiRagdollEnabled=true if VS.setAntiRagVisual then VS.setAntiRagVisual(true) end task.wait(0.3); F.startAntiRagdoll() end if cfg.antiDieEnabled then S.antiDieEnabled = true if VS.setAntiDieVisual then VS.setAntiDieVisual(true) end F.startAntiDie() end if cfg.antiDropEnabled then local started = F.startAntiDrop() if VS.setAntiDropVisual then VS.setAntiDropVisual(started == true) end end if cfg.antiFlingShieldEnabled then
S.antiFlingShieldEnabled = true if VS.setAntiFlingVisual then VS.setAntiFlingVisual(true) end F.startAntiFlingShield() end if cfg.removeAccessories then S.removeAccessoriesEnabled = true if VS.setRemoveAccVisual then VS.setRemoveAccVisual(true) end F.startRemoveAccessories() end if cfg.infJumpMode == "manual" or cfg.infJumpMode == "hold" then S.infJumpMode = cfg.infJumpMode if UI.infJumpModeBtn then UI.infJumpModeBtn.Text = (S.infJumpMode == "manual") and "Manual" or "Hold" end end if cfg.infJump then infJumpEnabled = true if VS.setInfJumpVisual then VS.setInfJumpVisual(true) end
F.startInfJump() end if cfg.mirrorTPDown then F.setMirrorTPDown(true) if VS.setMirrorTPVisual then VS.setMirrorTPVisual(true) end end if cfg.aimbotSpeed and type(cfg.aimbotSpeed) == "number" and cfg.aimbotSpeed > 0 then AIMBOT_SPEED = cfg.aimbotSpeed if UI.aimbotSpeedBox then UI.aimbotSpeedBox.Text = tostring(AIMBOT_SPEED) end end if cfg.aimbot then if setAimbotState then setAimbotState(true) end if VS.setAimbotVisual then VS.setAimbotVisual(true) end end if cfg.antiBatBypass then S.antiBatBypassEnabled = true if F.startAimbotBypassAntiBat then pcall(F.startAimbotBypassAntiBat)
elseif setAimbotState and (S.aimbotMode or 1) == 2 then setAimbotState(true) end if VS.setAntiBatBypassVisual then VS.setAntiBatBypassVisual(true) end if VS.setAimbotVisual and (S.aimbotMode or 1) == 2 then VS.setAimbotVisual(true) end end if cfg.tpBat then if VS.setTPBatVisual then VS.setTPBatVisual(true) end if setTPBatState then setTPBatState(true) end end if cfg.antiTPBatEnabled == true then task.defer(function() AntiTPBat.set(true) end) end if tpBatModeLbl then tpBatModeLbl.Text = (tpBatMode == 3) and "V3" or ((tpBatMode == 3) and "V3" or ((tpBatMode == 2) and "V2" or "V1")) end if cfg.autoLeft then task.defer(function() task.wait(0.4)
if F.queueAutoLeftStart then F.queueAutoLeftStart() end if S.autoLeftSetVisual then S.autoLeftSetVisual(true) end end) end if cfg.autoRight then task.defer(function() task.wait(0.45) if F.queueAutoRightStart then F.queueAutoRightStart() end if S.autoRightSetVisual then S.autoRightSetVisual(true) end end) end if cfg.autoStealEnabled then if VS.setInstaGrab then VS.setInstaGrab(true) end pcall(startAutoSteal) end if cfg.medusaCounter then S.medusaCounterEnabled=true;if VS.setMedusaVisual then VS.setMedusaVisual(true) end end if cfg.medusaReset or cfg.autoResetOnMedEnabled then
S.medusaResetEnabled=true; S.autoResetOnMedEnabled=true if VS.setMedusaResetVisual then VS.setMedusaResetVisual(true) end end if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(LP.Character) end if cfg.batCounter then S.batCounterEnabled=true;if VS.setBatCounterVisual then VS.setBatCounterVisual(true) end;S.startBatCounter() end if cfg.laggerMode then S.laggerToggled=true;S.speedMode=false;S.laggerPhase=cfg.laggerCarryMode and 2 or 1;F.refreshSpeedModeLabel() elseif cfg.carryMode then S.speedMode=false;F.toggleCarryMode() end if cfg.autoCarrySpeedEnabled then
S.autoCarrySpeedEnabled = true if S.setAutoCarrySpeedVisual then S.setAutoCarrySpeedVisual(true) end end if cfg.noPlayerCollisionEnabled then F.enableNoPlayerCollision() if VS.setNoPlayerCollisionVisual then VS.setNoPlayerCollisionVisual(true) end end if cfg.safeModeEnabled then S.safeModeEnabled = true if VS.setSafeModeVisual then VS.setSafeModeVisual(true) end end if cfg.autoTPEnabled then S.autoTPEnabled=true;if VS.setAutoTPVisual then VS.setAutoTPVisual(true) end;F.startAutoTP() end if VS.setAutoSwingVisual then VS.setAutoSwingVisual(S.autoSwingEnabled) end
if cfg.autoBat then S.autoBatEnabled=true;if S.autoBatSetVisual then S.autoBatSetVisual(true) end;F.queueAutoBatStart() end if cfg.unwalkEnabled then S.unwalkEnabled=true;if VS.setUnwalkVisual then VS.setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);F.startUnwalk() end) end if cfg.keyboardOverlay then S.keyboardOverlayEnabled = true if VS.setKeyboardOverlayVisual then VS.setKeyboardOverlayVisual(true) end pcall(function() F.startKeyboardOverlay() end) end if cfg.antiLag then F.enableAntiLag();if VS.setAntiLagVisual then VS.setAntiLagVisual(true) end end
if cfg.stretchRez then enableStretchRez();if VS.setStretchRezVisual then VS.setStretchRezVisual(true) end end if cfg.showTracerEnabled then pcall(function() if F.clearTracers then F.clearTracers() end end) if VS.setShowTracerVisual then VS.setShowTracerVisual(true) end end if cfg.ragdollCountdownEnabled then F.setRagdollCountdown(true) if VS.setRagdollCdVisual then VS.setRagdollCdVisual(true) end end S.guiLocked = cfg.guiLocked and true or false if VS.setLockGuiVisual then VS.setLockGuiVisual(S.guiLocked) end if type(cfg.hubPos) == "table" then S.hubPos = cfg.hubPos end
if type(cfg.miniPos) == "table" then S.miniPos = cfg.miniPos end if (S.hubPos or S.miniPos) and _G._VersincSetHubPos then pcall(function() _G._VersincSetHubPos(S.hubPos, S.miniPos) end) task.defer(function() pcall(function() _G._VersincSetHubPos(S.hubPos, S.miniPos) end) end) end if cfg.lockMobileButtons then S.lockMobileButtons = true if VS.setLockMobileButtonsVisual then VS.setLockMobileButtonsVisual(true) end end if cfg.hideMobileButtons then S.hideMobileButtons = true if VS.setHideMobileVisual then VS.setHideMobileVisual(true) end end if cfg.mobileButtonScale then
S.mobileButtonScale = tonumber(cfg.mobileButtonScale) or 0.80 end if cfg.miniUiScale then S.miniUiScale = tonumber(cfg.miniUiScale) or 1.00 end if type(cfg.mobileButtonPositions) == "table" then _G.VersincMobileButtonPositions = cfg.mobileButtonPositions end if cfg.autoResetOnMedEnabled then F.setAutoResetOnMed(true) if VS.setAutoResetOnMedVisual then VS.setAutoResetOnMedVisual(true) end end if cfg.lineESP or cfg.speedESP then if K7 then K7.lineESPEnabled = true; K7.speedESPEnabled = true end if VS.setLineESPVisual then VS.setLineESPVisual(true) end pcall(function() if K7 and K7.refreshESP then K7.refreshESP() end end) end if cfg.fovEnabled and K7 then
K7.fovEnabled = true if cfg.fovValue then K7.fovValue = tonumber(cfg.fovValue) or K7.fovValue end if VS.setFOVVisual then VS.setFOVVisual(true) end pcall(function() if K7.applyFOV then K7.applyFOV() end end) end if cfg.korbloxSide and type(cfg.korbloxSide)=="number" then korbloxSide = math.clamp(math.floor(cfg.korbloxSide), 1, 3) if K7 then K7.korbloxSide = korbloxSide end end if cfg.headless and K7 then K7.headlessEnabled = true if VS.setHeadlessVisual then VS.setHeadlessVisual(true) end task.spawn(function() local function applyH() local char = LP.Character if char and K7.applyHeadless then
pcall(K7.applyHeadless, char, true) end end task.wait(0.4); applyH(); task.wait(1.0); applyH() end) end if cfg.korblox and K7 then K7.korbloxEnabled = true if VS.setKorbloxVisual then VS.setKorbloxVisual(true) end task.spawn(function() local function applyK() local char = LP.Character if char and K7.applyKorblox then pcall(K7.applyKorblox, char, true) end end task.wait(0.5); applyK(); task.wait(1.2); applyK() end) end if cfg.bodyLock and K7 then K7.bodyLockEnabled = true if cfg.bodyLockRadius then K7.bodyLockRadius = tonumber(cfg.bodyLockRadius) or K7.bodyLockRadius end
if VS.setBodyLockVisual then VS.setBodyLockVisual(true) end pcall(function() if K7.startBodyLock then K7.startBodyLock() end end) end if K7 and cfg.animPack and type(cfg.animPack) == "string" then K7.animPackName = cfg.animPack if K7.ANIM_PACK_LIST then for i, n in ipairs(K7.ANIM_PACK_LIST) do if n == cfg.animPack then K7.animPackIndex = i break end end end if UI.animPackLbl then pcall(function() UI.animPackLbl.Text = K7.animPackName end) end end if cfg.animPackEnabled and K7 then K7.animPackEnabled = true if VS.setAnimPackVisual then VS.setAnimPackVisual(true) end task.spawn(function()
task.wait(0.6) pcall(function() if K7.applyAnimPack then K7.applyAnimPack(K7.animPackName) end end) task.wait(1.2) pcall(function() if K7.animPackEnabled and K7.applyAnimPack then K7.applyAnimPack(K7.animPackName) end end) end) end if K7 and cfg.accessoryPack and type(cfg.accessoryPack) == "string" then local savedSkin = cfg.accessoryPack if savedSkin ~= "Off" and savedSkin ~= "Mario" and savedSkin ~= "MARIO 2" then savedSkin = "Mario" end K7.accessoryPackName = savedSkin if K7.ACCESSORY_PACK_LIST then for i, n in ipairs(K7.ACCESSORY_PACK_LIST) do if n == savedSkin then K7.accessoryPackIndex = i break end end end if UI.accessoryPackLbl then UI.accessoryPackLbl.Text = K7.accessoryPackName end end if cfg.accessoryPackEnabled and K7 then K7.accessoryPackEnabled = true if VS.setAccessoryPackVisual then VS.setAccessoryPackVisual(true) end task.spawn(function() task.wait(0.8) if K7.accessoryPackEnabled and K7.applyAccessoryPack then pcall(K7.applyAccessoryPack, K7.accessoryPackName) end end) end if cfg.skyTheme and K7 and K7.applySkyTheme then pcall(function() K7.applySkyTheme(cfg.skyTheme) end) end end) end S.introEnabled = false function F.playVersicnIntro() if S.introEnabled == false then return end local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5) if not pg then return end
local old = pg:FindFirstChild("VersicnIntro") if old then old:Destroy() end local sg = Instance.new("ScreenGui"); sg.Name = "VersicnIntro"; sg.IgnoreGuiInset = true; sg.DisplayOrder = 9999; sg.ResetOnSpawn = false; sg.Parent = pg; local skipped = false local function skipIntro() if skipped then return end skipped = true; S.introEnabled = false pcall(function() if sg then sg:Destroy() end end) end
local bg = Instance.new("Frame", sg); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0); bg.BorderSizePixel = 0; local skipBtn = Instance.new("TextButton", bg); skipBtn.Name = "SkipIntro"; skipBtn.AnchorPoint = Vector2.new(1, 0); skipBtn.Position = UDim2.new(1, -16, 0, 16); skipBtn.Size = UDim2.new(0, 88, 0, 32); skipBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32); skipBtn.BackgroundTransparency = 0.15; skipBtn.BorderSizePixel = 0; skipBtn.Text = "SKIP"; skipBtn.TextColor3 = Color3.fromRGB(245, 245, 247); skipBtn.Font = Enum.Font.GothamBold; skipBtn.TextSize = 13; skipBtn.ZIndex = 20; Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 8); local skStroke = Instance.new("UIStroke", skipBtn); skStroke.Color = Color3.fromRGB(180, 180, 190); skStroke.Thickness = 1; skStroke.Transparency = 0.35; skipBtn.Activated:Connect(skipIntro); skipBtn.MouseButton1Click:Connect(skipIntro); local title = Instance.new("TextLabel", bg); title.AnchorPoint = Vector2.new(0.5, 0.5); title.Position = UDim2.new(0.5, 0, 0.48, 0); title.Size = UDim2.new(0, 420, 0, 40); title.BackgroundTransparency = 1; title.Text = "snow.vs"; title.TextColor3 = Color3.fromRGB(255, 255, 255); title.Font = Enum.Font.GothamBlack; title.TextSize = 36; title.TextTransparency = 1; local sub = Instance.new("TextLabel", bg); sub.AnchorPoint = Vector2.new(0.5, 0); sub.Position = UDim2.new(0.5, 0, 0.48, 28); sub.Size = UDim2.new(0, 420, 0, 22); sub.BackgroundTransparency = 1; sub.Text = "welcome"; sub.TextColor3 = Color3.fromRGB(180, 190, 210); sub.Font = Enum.Font.GothamBold; sub.TextSize = 14; sub.TextTransparency = 1; local line = Instance.new("Frame", bg); line.AnchorPoint = Vector2.new(0.5, 0); line.Position = UDim2.new(0.5, 0, 0.48, 54); line.Size = UDim2.new(0, 0, 0, 2); line.BackgroundColor3 = Color3.fromRGB(220, 220, 230); line.BorderSizePixel = 0; TS:Create(title, TweenInfo.new(0.7, Enum.EasingStyle.Quad), { TextTransparency = 0 }):Play(); TS:Create(sub, TweenInfo.new(0.85, Enum.EasingStyle.Quad), { TextTransparency = 0.15 }):Play(); TS:Create(line, TweenInfo.new(0.9, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 140, 0, 2) }):Play()
task.delay(2.15, function() if skipped or not sg or not sg.Parent then return end TS:Create(title, TweenInfo.new(0.55), { TextTransparency = 1 }):Play(); TS:Create(sub, TweenInfo.new(0.55), { TextTransparency = 1 }):Play(); TS:Create(line, TweenInfo.new(0.55), { BackgroundTransparency = 1 }):Play(); TS:Create(bg, TweenInfo.new(0.65), { BackgroundTransparency = 1 }):Play() task.delay(0.7, function() if not skipped and sg then sg:Destroy() end end) end) end local okKeys, errKeys = pcall(F.loadConfigKeys) if not okKeys then warn("[snow.vs] F.loadConfigKeys error:", tostring(errKeys)) end
local okGui, errGui = pcall(F.buildGui) if not okGui then warn("[snow.vs] GUI error:", tostring(errGui)); print("[snow.vs] GUI FAILED:", tostring(errGui)) else _genv.__CrystalVSHubLoaded = true; print("[snow.vs] GUI built OK")  end local okState, errState = pcall(F.loadConfigState) if not okState then warn("[snow.vs] F.loadConfigState error:", tostring(errState)) end pcall(function() F.buildMobileButtons() if F.applyMobileButtonSize then F.applyMobileButtonSize() end
if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) print("[snow.vs] Loaded (Delta-compatible build)" .. (_IS_MOBILE and " [MOBILE PERF]" or " [PC]")) task.defer(function() task.wait(1.2) pcall(function() F.saveConfig(true) end) end)

-- ============================================================
-- CRYSTAL: KATANA + MEDUSA (importado do Mystery.Vs)
-- Katana: mesh/textura do Mystery + som de katana
-- Medusa: som de Medusa do Mystery
-- ============================================================
do
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    local KATANA_MESH = "rbxassetid://13528902482"
    local KATANA_TEXTURE = "rbxassetid://13528902373"
    local KATANA_SOUND = "rbxassetid://5713085119"
    local MEDUSA_SOUND = "rbxassetid://3102797479"

    local hookedSounds = setmetatable({}, {__mode = "k"})
    local originalVisuals = setmetatable({}, {__mode = "k"})
    local customSounds = setmetatable({}, {__mode = "k"})

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
    end

    local function isMedusaTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        return tool.Name:lower():find("medusa", 1, true) ~= nil
    end

    local function makeCustomSound(parent, id, name)
        local old = customSounds[parent]
        if old and old.Parent then
            old.SoundId = id
            return old
        end
        local s = Instance.new("Sound")
        s.Name = name
        s.SoundId = id
        s.Volume = 1
        s.Looped = false
        s.Parent = parent
        customSounds[parent] = s
        return s
    end

    local function playCustomSound(parent, id, name, skip, doublePlay, delayTime)
        if not parent or not parent.Parent then return end
        local s = makeCustomSound(parent, id, name)
        pcall(function()
            s:Stop()
            s.TimePosition = skip or 0
            s.Volume = 1
            s:Play()
        end)
        if doublePlay and delayTime then
            task.delay(delayTime, function()
                if s and s.Parent then
                    pcall(function()
                        s:Stop()
                        s.TimePosition = skip or 0
                        s.Volume = 1
                        s:Play()
                    end)
                end
            end)
        end
    end

    local function hookToolSounds(tool, medusa)
        if not tool then return end
        local entry = hookedSounds[tool]
        if entry then return end
        entry = {conns = {}, sounds = {}}
        hookedSounds[tool] = entry

        local soundId = medusa and MEDUSA_SOUND or KATANA_SOUND
        local skip = medusa and 0 or 0.2
        local doublePlay = medusa
        local delayTime = medusa and 0.5 or nil

        local function hookSound(snd)
            if not snd:IsA("Sound") or snd.Name == "CrystalMysteryCustomSound" then return end
            if entry.sounds[snd] then return end
            entry.sounds[snd] = snd.Volume

            local function trigger()
                if not snd.Parent then return end
                if snd.Playing or snd.TimePosition > 0 then
                    pcall(function()
                        snd.Volume = 0
                        snd:Stop()
                    end)
                    playCustomSound(snd.Parent, soundId, "CrystalMysteryCustomSound", skip, doublePlay, delayTime)
                end
            end

            table.insert(entry.conns, snd:GetPropertyChangedSignal("Playing"):Connect(trigger))
            table.insert(entry.conns, snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger))
        end

        for _, d in ipairs(tool:GetDescendants()) do
            hookSound(d)
        end
        table.insert(entry.conns, tool.DescendantAdded:Connect(hookSound))
    end

    local function applyKatana(tool)
        if not isBatTool(tool) then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then return end

        if not originalVisuals[tool] then
            originalVisuals[tool] = {handle = handle, transparency = handle.Transparency}
        end

        local oldReplica = handle:FindFirstChild("CrystalKatanaReplica")
        if oldReplica then oldReplica:Destroy() end

        local model = Instance.new("Model")
        model.Name = "CrystalKatanaReplica"

        local part = Instance.new("Part")
        part.Name = "KatanaPart"
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 0
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.Anchored = false
        part.Parent = model

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = KATANA_MESH
        mesh.TextureId = KATANA_TEXTURE
        mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
        mesh.Parent = part

        model.PrimaryPart = part
        model.Parent = handle
        part.CFrame = handle.CFrame * (CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)))

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = part
        weld.Parent = part

        -- Mantem o Handle original invisivel para mostrar somente a Katana.
        pcall(function() handle.Transparency = 1 end)
        hookToolSounds(tool, false)
    end

    local function applyMedusa(tool)
        if not isMedusaTool(tool) then return end
        hookToolSounds(tool, true)
    end

    local function scan(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then
                if isBatTool(child) then
                    task.defer(applyKatana, child)
                elseif isMedusaTool(child) then
                    task.defer(applyMedusa, child)
                end
            end
        end
        if not container:GetAttribute("CrystalMysteryWatch") then
            container:SetAttribute("CrystalMysteryWatch", true)
            container.ChildAdded:Connect(function(child)
                if not child:IsA("Tool") then return end
                task.wait()
                if isBatTool(child) then
                    applyKatana(child)
                elseif isMedusaTool(child) then
                    applyMedusa(child)
                end
            end)
        end
    end

    local function scanAll()
        scan(LP:FindFirstChildOfClass("Backpack"))
        scan(LP.Character)
    end

    scanAll()
    LP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then scan(child) end
    end)
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        scan(char)
        scanAll()
    end)

    task.spawn(function()
        while task.wait(1) do
            scanAll()
            local char = LP.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if isBatTool(tool) then applyKatana(tool) elseif isMedusaTool(tool) then applyMedusa(tool) end
                end
            end
        end
    end)

    _G.CrystalMysteryKatanaMedusa = {
        apply = scanAll,
        KatanaMesh = KATANA_MESH,
        KatanaTexture = KATANA_TEXTURE,
        KatanaSound = KATANA_SOUND,
        MedusaSound = MEDUSA_SOUND,
    }
end
-- ============================================================
-- FIM CRYSTAL: KATANA + MEDUSA
-- ============================================================
