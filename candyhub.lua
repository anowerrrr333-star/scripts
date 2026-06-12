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


repeat task.wait() until game and game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- Cleanup
pcall(function() CoreGui:FindFirstChild("CandyHub"):Destroy() end)
pcall(function() CoreGui:FindFirstChild("CandyHubMobileButtons"):Destroy() end)
pcall(function()
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        pcall(function() pg:FindFirstChild("CandyHub"):Destroy() end)
        pcall(function() pg:FindFirstChild("CandyHubMobileButtons"):Destroy() end)
    end
end)

-- Colors
local CANDY_COLORS = {
    BG = Color3.fromRGB(0,0,0), PANEL = Color3.fromRGB(0,0,0), CARD = Color3.fromRGB(9,9,12),
    ACCENT = Color3.fromRGB(255,92,181), ICE = Color3.fromRGB(0,180,255),
    HOVER = Color3.fromRGB(255,122,200), TEXT = Color3.fromRGB(240,240,240),
    SECONDARY = Color3.fromRGB(170,170,170), STROKE = Color3.fromRGB(24,28,36),
    INPUT = Color3.fromRGB(255,92,181), OFF = Color3.fromRGB(32,32,38)
}

local CANDY_BRAND = "Candy Hub"
local CANDY_DISCORD = "discord.gg/candyhub"

local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local GUI_W, GUI_H = IsMobile and 248 or 360, IsMobile and 360 or 462
local HDR_H = IsMobile and 52 or 58
local PAD = IsMobile and 8 or 10
local PROGRESS_H = 30
local PAGE_TOP = HDR_H + (IsMobile and 10 or 12)
local PAGE_BOTTOM = PAGE_TOP + (IsMobile and 8 or 10)
local ROW_H = IsMobile and 28 or 31
local SECTION_H = IsMobile and 16 or 18

-- ============================================================
--  INTRO ANIMATION (NEW)
-- ============================================================
local showIntroEnabled = true
local function playCandyIntro(gui, main, miniBtn)
    if not showIntroEnabled or not gui or not main then return end
    local originalMainPos = main.Position
    main.Visible = false
    if miniBtn then miniBtn.Visible = false end

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting

    local snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://126107591945718"
    snd.Volume = 0.55
    snd.Looped = false
    snd.TimePosition = 34
    snd.Parent = SoundService
    pcall(function() snd:Play() end)

    local intro = Instance.new("Frame", gui)
    intro.Name = "CandyHubIntro"
    intro.Size = UDim2.new(1,0,1,0)
    intro.Position = UDim2.new(0,0,0,0)
    intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
    intro.BackgroundTransparency = 1
    intro.BorderSizePixel = 0
    intro.ZIndex = 200

    local logo = Instance.new("Frame", intro)
    logo.Size = UDim2.new(0,58,0,58)
    logo.Position = UDim2.new(0.5,-29,0.5,-108)
    logo.BackgroundColor3 = CANDY_COLORS.CARD
    logo.BackgroundTransparency = 1
    logo.BorderSizePixel = 0
    logo.ZIndex = 201
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0,14)

    local logoStroke = Instance.new("UIStroke", logo)
    logoStroke.Color = CANDY_COLORS.ACCENT
    logoStroke.Thickness = 1.2
    logoStroke.Transparency = 0.1

    local mark = Instance.new("TextLabel", logo)
    mark.Size = UDim2.new(1,0,1,0)
    mark.BackgroundTransparency = 1
    mark.Text = "C"
    mark.TextColor3 = CANDY_COLORS.ACCENT
    mark.Font = Enum.Font.GothamBlack
    mark.TextSize = 34
    mark.TextTransparency = 1
    mark.ZIndex = 202

    local title = Instance.new("TextLabel", intro)
    title.Size = UDim2.new(0,520,0,52)
    title.Position = UDim2.new(0.5,-260,0.5,-36)
    title.BackgroundTransparency = 1
    title.Text = CANDY_BRAND
    title.TextColor3 = CANDY_COLORS.TEXT
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 34
    title.TextTransparency = 1
    title.ZIndex = 201
    title.TextXAlignment = Enum.TextXAlignment.Center

    local sub = Instance.new("TextLabel", intro)
    sub.Size = UDim2.new(0,520,0,24)
    sub.Position = UDim2.new(0.5,-260,0.5,12)
    sub.BackgroundTransparency = 1
    sub.Text = "LOADING ASSETS..."
    sub.TextColor3 = CANDY_COLORS.ICE
    sub.Font = Enum.Font.GothamBlack
    sub.TextSize = 16
    sub.TextTransparency = 1
    sub.ZIndex = 201
    sub.TextXAlignment = Enum.TextXAlignment.Center

    local loading = Instance.new("TextLabel", intro)
    loading.Size = UDim2.new(0,520,0,18)
    loading.Position = UDim2.new(0.5,-260,0.5,72)
    loading.BackgroundTransparency = 1
    loading.Text = CANDY_DISCORD
    loading.TextColor3 = CANDY_COLORS.SECONDARY
    loading.Font = Enum.Font.GothamBold
    loading.TextSize = 11
    loading.TextTransparency = 1
    loading.TextXAlignment = Enum.TextXAlignment.Center
    loading.ZIndex = 201

    local barBg = Instance.new("Frame", intro)
    barBg.Size = UDim2.new(0,210,0,3)
    barBg.Position = UDim2.new(0.5,-105,0.5,45)
    barBg.BackgroundColor3 = Color3.fromRGB(20,20,26)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 201
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1,0)

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(0,0,1,0)
    bar.BackgroundColor3 = CANDY_COLORS.TEXT
    bar.BorderSizePixel = 0
    bar.ZIndex = 202
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    local barGrad = Instance.new("UIGradient", bar)
    barGrad.Color = ColorSequence.new(CANDY_COLORS.ACCENT, CANDY_COLORS.ICE)

    TS:Create(blur, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 34}):Play()
    TS:Create(intro, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.32}):Play()
    TS:Create(logo, TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()
    TS:Create(logoStroke, TweenInfo.new(0.28), {Transparency = 0.02}):Play()
    TS:Create(mark, TweenInfo.new(0.22), {TextTransparency = 0}):Play()
    TS:Create(title, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    TS:Create(sub, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    TS:Create(loading, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    TS:Create(bar, TweenInfo.new(2.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,1,0)}):Play()

    local blink = true
    task.spawn(function()
        while blink and intro.Parent do
            task.wait(0.15)
            local hidden = mark.TextTransparency < 0.5
            mark.TextTransparency = hidden and 1 or 0
            title.TextTransparency = hidden and 0.35 or 0
            sub.TextTransparency = hidden and 0.55 or 0
        end
    end)

    task.delay(2.75, function()
        if not intro.Parent then return end
        blink = false
        sub.Text = "READY"
        sub.TextColor3 = CANDY_COLORS.ACCENT
        task.wait(0.45)
        main.Position = UDim2.new(originalMainPos.X.Scale, originalMainPos.X.Offset, originalMainPos.Y.Scale, originalMainPos.Y.Offset + 18)
        main.Visible = true
        TS:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = originalMainPos}):Play()
        TS:Create(blur, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = 0}):Play()
        TS:Create(intro, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        TS:Create(logo, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
        TS:Create(mark, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        TS:Create(title, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        TS:Create(sub, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        TS:Create(loading, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        TS:Create(barBg, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
        TS:Create(bar, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
        TS:Create(snd, TweenInfo.new(0.8), {Volume = 0}):Play()
        task.delay(0.85, function()
            pcall(function() snd:Stop(); snd:Destroy() end)
            pcall(function() blur:Destroy() end)
            if intro then intro:Destroy() end
        end)
    end)
end

-- ============================================================
--  GLOBAL STATE VARIABLES
-- ============================================================
NS = 60; CS = 30
LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
speedMode = false; laggerToggled = false
autoBatEnabled = false; autoSwingEnabled = true
batCounterEnabled = false; medusaCounterEnabled = false
autoLeftEnabled = false; autoRightEnabled = false
antiRagdollEnabled = false; unwalkEnabled = false
autoTPEnabled = false; autoTPHeight = 20
stretchRezEnabled = false; antiLagEnabled = false
uiLocked = false; infJumpEnabled = false
_anyKeyListening = false
modeValLbl = nil
autoBatActive = false

-- Speed label
speedLabel = nil
function setupSpeedIndicator(char)
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("CandyHubSpeedBB")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "CandyHubSpeedBB"
    bb.Size = UDim2.new(0, 190, 0, 54)
    bb.StudsOffset = Vector3.new(0, 3.35, 0)
    bb.AlwaysOnTop = true
    local tag = Instance.new("TextLabel", bb)
    tag.Size = UDim2.new(1,0,0,22); tag.Position = UDim2.new(0,0,0,0)
    tag.BackgroundTransparency = 1; tag.Text = ".gg/candyhub"
    tag.TextColor3 = CANDY_COLORS.ICE; tag.Font = Enum.Font.GothamBlack
    tag.TextSize = 15; tag.TextXAlignment = Enum.TextXAlignment.Center
    local val = Instance.new("TextLabel", bb)
    val.Size = UDim2.new(1,0,0,26); val.Position = UDim2.new(0,0,0,24)
    val.BackgroundTransparency = 1; val.Text = "Speed: 0.0"
    val.TextColor3 = CANDY_COLORS.ACCENT; val.Font = Enum.Font.GothamBlack
    val.TextSize = 17; val.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel = val
end
if LP.Character then setupSpeedIndicator(LP.Character) end
LP.CharacterAdded:Connect(setupSpeedIndicator)

function getActiveMoveSpeed()
    if laggerToggled and speedMode then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS else return NS end
end

-- Movement helpers
lastMoveDir = Vector3.new(0,0,0)
MOVE_KEYS = {[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

RunService.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir = Vector3.new(0,0,0); return end
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
        local md = hum.MoveDirection
        local spd = getActiveMoveSpeed()
        if md.Magnitude > 0 then
            lastMoveDir = md
            hrp.Velocity = Vector3.new(md.X*spd, hrp.Velocity.Y, md.Z*spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld = true; break end end
            if anyHeld then hrp.Velocity = Vector3.new(lastMoveDir.X*spd, hrp.Velocity.Y, lastMoveDir.Z*spd) end
        end
    end
    if speedLabel then
        local actualSpeed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
        if actualSpeed < 0.05 then actualSpeed = 0 end
        speedLabel.Text = string.format("Speed: %.1f", actualSpeed)
    end
end)

-- Auto Left/Right paths
AP_L1, AP_L2 = Vector3.new(-476.47,-6.28,92.73), Vector3.new(-483.12,-4.95,94.81)
AP_R1, AP_R2 = Vector3.new(-476.16,-6.52,25.62), Vector3.new(-483.06,-5.03,25.48)
alConn, arConn = nil, nil
alPhase, arPhase = 1, 1

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then local h = char:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero, false) end end
end
function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then local h = char:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero, false) end end
end
function startAutoLeft()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
        local spd = 60
        if alPhase == 1 then
            local tgt = Vector3.new(AP_L1.X, hrp.Position.Y, AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP_L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                hrp.Velocity = Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd)
                return
            end
            local d = AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.Velocity = Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP_L2.X, hrp.Position.Y, AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); hrp.Velocity = Vector3.zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                return
            end
            local d = AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.Velocity = Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd)
        end
    end)
end
function startAutoRight()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
        local spd = 60
        if arPhase == 1 then
            local tgt = Vector3.new(AP_R1.X, hrp.Position.Y, AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP_R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                hrp.Velocity = Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd)
                return
            end
            local d = AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.Velocity = Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP_R2.X, hrp.Position.Y, AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); hrp.Velocity = Vector3.zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                return
            end
            local d = AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.Velocity = Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd)
        end
    end)
end

-- Infinite Jump
holdJumpPressed, holdJumpActive = false, false
function applyInfJumpBoost(boost)
    if not infJumpEnabled then return end
    local char = LP.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z) end
    end
end
UIS.JumpRequest:Connect(function() applyInfJumpBoost(50) end)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        holdJumpPressed = true
        wait(0.12)
        if holdJumpPressed then holdJumpActive = true; applyInfJumpBoost(50) end
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then holdJumpPressed = false; holdJumpActive = false end
end)
RunService.Heartbeat:Connect(function() if holdJumpActive then applyInfJumpBoost(50) end end)

-- TP Down
function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if not force then
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= autoTPHeight) then return end
    end
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
    hrp.Velocity = Vector3.zero
end
autoTPConn = nil
function startAutoTP()
    if autoTPConn then coroutine.close(autoTPConn) end
    autoTPConn = coroutine.create(function()
        while autoTPEnabled do
            wait(0.1)
            pcall(function() doAutoTPDown(false) end)
        end
    end)
    coroutine.resume(autoTPConn)
end
function stopAutoTP() autoTPEnabled = false; if autoTPConn then coroutine.close(autoTPConn); autoTPConn = nil end end
function runTPFloor() pcall(function() doAutoTPDown(true) end) end

-- Stretch Rez
function enableStretchRez()
    stretchRezEnabled = true
    workspace.CurrentCamera.FieldOfView = 107
end
function disableStretchRez()
    stretchRezEnabled = false
    workspace.CurrentCamera.FieldOfView = 70
end

-- Anti Lag
function enableAntiLag()
    antiLagEnabled = true
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
end
function disableAntiLag()
    antiLagEnabled = false
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
    Lighting.Brightness = 2
end

-- Unwalk
unwalkSavedAnimate = nil
function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim = c:FindFirstChild("Animate")
    if anim then unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end
function stopUnwalk()
    local c = LP.Character
    if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent = c; unwalkSavedAnimate = nil end
end

-- Drop
dropActive = false
function runDrop()
    if dropActive then return end
    dropActive = true
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(0, 10000, 0)
        wait(0.1)
        root.Velocity = Vector3.zero
    end
    dropActive = false
end

-- Bat Aimbot
aimbotConn = nil
function findBat()
    local char = LP.Character
    if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _,tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end
function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end
function swingCurrentBat()
    if not autoSwingEnabled then return end
    local bat = findBat()
    if bat and bat.Parent == LP.Character and bat:IsA("Tool") then
        pcall(function() bat:Activate() end)
    end
end
function startBatAimbot()
    if aimbotConn then aimbotConn:Disconnect() end
    autoBatEnabled = true
    if autoLeftEnabled then autoLeftEnabled = false; if autoLeftToggle then autoLeftToggle(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled = false; if autoRightToggle then autoRightToggle(false) end; stopAutoRight() end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then swingCurrentBat(); return end
        local targetVel = target.Velocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
        local chaseSpeed = 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.Velocity = root.Velocity:Lerp(desiredVel, 0.8)
        local predictedPos = targetPos + targetVel * math.clamp(targetVel.Magnitude/150, 0.05, 0.2)
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx*42, ry*42, rz*42))
        end
        swingCurrentBat()
    end)
end
function stopBatAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
    autoBatEnabled = false
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum2 = char and char:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

-- Bat Counter
batCounterConn = nil
function startBatCounter()
    if batCounterConn then return end
    batCounterConn = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            local bat = findBat()
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end); wait(0.05) end
                pcall(function() bat:Activate() end); wait(0.15)
                pcall(function() bat:Activate() end)
            end
        end
    end)
end
function stopBatCounter()
    if batCounterConn then batCounterConn:Disconnect(); batCounterConn = nil end
end

-- Medusa Counter
medusaLastUsed = 0
function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head")) then return t end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _,t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head")) then return t end
        end
    end
    return nil
end
function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 and medusaCounterEnabled and tick() - medusaLastUsed > 25 then
            local med = findMedusa()
            if med then
                if med.Parent ~= LP.Character then
                    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(med); wait(0.05) end
                end
                pcall(function() med:Activate() end)
                medusaLastUsed = tick()
            end
        end
    end)
end
function setupMedusa(char)
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then onAnchorChanged(part) end
    end
    char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then onAnchorChanged(part) end
    end)
end

-- ============================================================
--  AUTO STEAL
-- ============================================================
ReplicatedStorage = game:GetService("ReplicatedStorage")
plots = workspace:WaitForChild("Plots")
AnimalsData = {}
syncRemotes = nil
plotAnimalSync = {caches={}, connections={}}
allAnimalsCache = {}
PromptMemoryCache = {}
InternalStealCache = {}
stealConnection = nil
StealState = { active=false, startTime=0, phase="idle", label="", lastResult="", lastResultTime=0, totalSteals=0, failedSteals=0 }
progressRadLbl, progressFill, progressPct = nil, nil, nil
progressLastFill = 0

function initializeAutoStealSync()
    local ok = pcall(function()
        local Packages = ReplicatedStorage:WaitForChild("Packages",10)
        local Datas = ReplicatedStorage:WaitForChild("Datas",10)
        if not Packages or not Datas then return end
        AnimalsData = require(Datas:WaitForChild("Animals"))
        local folder = Packages:WaitForChild("Synchronizer")
        syncRemotes = { channelFolder = folder:WaitForChild("Channel"), routeRemote = folder:WaitForChild("CommunicationRoute"), requestData = folder:FindFirstChild("RequestData") }
    end)
    return ok and syncRemotes ~= nil
end
function splitSyncPath(path)
    if typeof(path)=="table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
    return out
end
function resolveSyncPath(path, root)
    local current = root; local parent = nil; local key = nil
    for _,part in ipairs(splitSyncPath(path)) do parent = current; key = part; current = current and current[part] or nil end
    return current, parent, key
end
function applyPlotSyncDiff(channelName, packet)
    local cache = plotAnimalSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = resolveSyncPath(path, cache)
    if action == "Changed" then
        if parent ~= nil then parent[key] = a end
    elseif action == "ArrayInsert" then
        if current ~= nil then table.insert(current, b, a) end
    elseif action == "ArrayRemoved" then
        if current ~= nil then table.remove(current, b) end
    elseif action == "DictionaryInsert" then
        if current ~= nil then current[b] = a end
    elseif action == "DictionaryRemoved" then
        if current ~= nil then current[b] = nil end
    end
end
function attachPlotChannel(remote)
    if not syncRemotes or plotAnimalSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if syncRemotes.requestData and plotAnimalSync.caches[channelName]==nil then
        local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
        plotAnimalSync.caches[channelName] = (ok and typeof(data)=="table") and data or {}
    elseif plotAnimalSync.caches[channelName]==nil then
        plotAnimalSync.caches[channelName] = {}
    end
    plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _,packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
    end)
end
function detachPlotChannel(channelName)
    for remote, conn in pairs(plotAnimalSync.connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            plotAnimalSync.connections[remote] = nil
            plotAnimalSync.caches[tostring(channelName)] = nil
            break
        end
    end
end
function startAutoStealSync()
    if not initializeAutoStealSync() then return false end
    for _,child in ipairs(syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end
    syncRemotes.channelFolder.ChildAdded:Connect(function(child) if child:IsA("RemoteEvent") then attachPlotChannel(child) end end)
    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _,action in ipairs(actions) do
            local kind, channelName = action[1], tostring(action[2])
            if not plots:FindFirstChild(channelName) then continue end
            if kind == "ListenerAdded" then
                local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
                if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
            elseif kind == "ListenerRemoved" then
                detachPlotChannel(channelName)
            end
        end
    end)
    return true
end
function getPlotChannelData(plotName) return plotAnimalSync.caches[plotName] end
function getPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end
function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    return getPlotOwner(plot) == LP.DisplayName
end
function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = PromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local plot = plots:FindFirstChild(animalData.plot); if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot); if not podium then return nil end
    local base = podium:FindFirstChild("Base"); if not base then return nil end
    local spawn = base:FindFirstChild("Spawn"); if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment"); if not attach then return nil end
    for _,p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then PromptMemoryCache[animalData.uid]=p; return p end
    end
    return nil
end
function getAnimalPosition(animalData)
    local plot = plots:FindFirstChild(animalData.plot); if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot); if not podium then return nil end
    return podium:GetPivot().Position
end
function distToAnimal(animalData)
    local character = LP.Character; if not character then return math.huge end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = getAnimalPosition(animalData); if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end
CONFIG_AUTO_STEAL = { AUTO_STEAL_ENABLED = false, HOLD_MIN = 1.3, HOLD_MAX = 2.6, ENTRY_DELAY = 0.3, COOLDOWN = 0.05, STEAL_RANGE = 9, PRIME_RANGE = 80 }
function pickClosest()
    local character = LP.Character; if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _,animalData in ipairs(allAnimalsCache) do
        if isMyBaseAnimal(animalData) then continue end
        local pos = getAnimalPosition(animalData); if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > CONFIG_AUTO_STEAL.PRIME_RANGE then continue end
        if dist < bestDist then bestDist = dist; best = animalData end
    end
    return best
end
function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    local data = {holdCallbacks={}, triggerCallbacks={}, ready=true}
    local ok1, conns1 = false, nil; if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
    if ok1 and type(conns1)=="table" then
        for _,conn in ipairs(conns1) do if type(conn.Function)=="function" then table.insert(data.holdCallbacks, conn.Function) end end
    end
    local ok2, conns2 = false, nil; if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
    if ok2 and type(conns2)=="table" then
        for _,conn in ipairs(conns2) do if type(conn.Function)=="function" then table.insert(data.triggerCallbacks, conn.Function) end end
    end
    if #data.holdCallbacks>0 or #data.triggerCallbacks>0 then InternalStealCache[prompt] = data end
end
function executeStealAsync(prompt, animalData)
    local data = InternalStealCache[prompt]; if not data or not data.ready then return false end
    data.ready = false
    local label = animalData.name or "Animal"
    StealState.active = true; StealState.startTime = tick(); StealState.phase = "holding"; StealState.label = label
    spawn(function()
        for _,fn in ipairs(data.holdCallbacks) do spawn(fn) end
        wait(CONFIG_AUTO_STEAL.HOLD_MIN)
        StealState.phase = "waitingRange"
        local alreadyInRange = distToAnimal(animalData) <= CONFIG_AUTO_STEAL.STEAL_RANGE
        local fired = false
        while true do
            local elapsed = tick() - StealState.startTime
            if elapsed > CONFIG_AUTO_STEAL.HOLD_MAX then break end
            if not prompt.Parent then break end
            if distToAnimal(animalData) <= CONFIG_AUTO_STEAL.STEAL_RANGE then
                if not alreadyInRange then wait(CONFIG_AUTO_STEAL.ENTRY_DELAY) end
                for _,fn in ipairs(data.triggerCallbacks) do spawn(fn) end
                fired = true; break
            end
            wait()
        end
        if fired then
            StealState.totalSteals = StealState.totalSteals + 1
            StealState.lastResult = "Stole "..label
            StealState.phase = "success"
        else
            StealState.failedSteals = StealState.failedSteals + 1
            StealState.lastResult = "Missed window: "..label
            StealState.phase = "failed"
        end
        StealState.active = false
        StealState.lastResultTime = tick()
        wait(CONFIG_AUTO_STEAL.COOLDOWN)
        data.ready = true
    end)
    return true
end
function attemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    buildStealCallbacks(prompt); if not InternalStealCache[prompt] then return false end
    return executeStealAsync(prompt, animalData)
end
function scanAllPlots()
    local newCache = {}
    for _,plot in ipairs(plots:GetChildren()) do
        local cache = getPlotChannelData(plot.Name); if not cache then continue end
        local animalList = cache.AnimalList; if typeof(animalList)~="table" then continue end
        for slot, animalData in pairs(animalList) do
            if type(animalData)=="table" then
                local animalName = animalData.Index
                local animalInfo = AnimalsData[animalName]
                if not animalInfo then continue end
                table.insert(newCache, {name=animalInfo.DisplayName or animalName, plot=plot.Name, slot=tostring(slot), uid=plot.Name.."_"..tostring(slot)})
            end
        end
    end
    allAnimalsCache = newCache
    return #allAnimalsCache
end
function startAutoSteal()
    if stealConnection then return end
    stealConnection = RunService.Heartbeat:Connect(function()
        if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then return end
        if StealState.active then return end
        local target = pickClosest()
        if not target then return end
        local prompt = PromptMemoryCache[target.uid]
        if not prompt or not prompt.Parent then prompt = findProximityPromptForAnimal(target) end
        if prompt then attemptSteal(prompt, target) end
    end)
end
function stopAutoSteal()
    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    StealState.active = false; StealState.phase = "idle"
end
function updateCandyStealBar(dt)
    if not progressFill or not progressPct then return end
    local recent = StealState.lastResultTime>0 and (tick()-StealState.lastResultTime)<1.4
    local targetPct, targetColor, status = 0, CANDY_COLORS.ACCENT, CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED and "READY" or "IDLE"
    if StealState.active then
        targetPct = math.clamp((tick()-StealState.startTime)/CONFIG_AUTO_STEAL.HOLD_MAX, 0, 1)
        if StealState.phase == "waitingRange" then
            status = "WAITING RANGE"
            targetColor = CANDY_COLORS.ICE
        else
            status = "STEALING"
            targetColor = CANDY_COLORS.ACCENT
        end
    elseif recent then
        local success = StealState.phase=="success" or string.find(StealState.lastResult, "Stole") ~= nil
        targetPct = 1; status = success and "SUCCESS" or "FAILED"
        targetColor = success and Color3.fromRGB(120,255,190) or Color3.fromRGB(255,90,120)
    elseif StealState.phase ~= "idle" then StealState.phase = "idle" end
    progressLastFill = progressLastFill + (targetPct - progressLastFill) * math.min((dt or 0.016)*14, 1)
    progressFill.Size = UDim2.new(progressLastFill, 0, 1, 0)
    progressFill.BackgroundColor3 = progressFill.BackgroundColor3:Lerp(targetColor, math.min((dt or 0.016)*8, 1))
    progressPct.Text = status.." |"
    progressPct.TextColor3 = targetColor
end
spawn(function()
    if startAutoStealSync() then
        scanAllPlots()
        while wait(5) do scanAllPlots() end
    end
end)
RunService.RenderStepped:Connect(updateCandyStealBar)

-- ============================================================
--  SKY THEME SYSTEM
-- ============================================================
local CANDY_SKY_TAG = "CandyHubSkyTheme"
_G._CandyHubSkyMode = _G._CandyHubSkyMode or "Off"
local candyOriginalLighting = nil

local CANDY_SKY_PRESETS = {
    ["Off"] = {kind = "off"},
    ["Night"] = {clock = 22, brightness = 2, ambient = {110,100,130}, outAmb = {120,110,140}},
    ["Aurora"] = {clock = 14, brightness = 3, ambient = {150,120,150}, outAmb = {160,130,160}},
    ["Sunset"] = {clock = 17.2, brightness = 2.5, ambient = {170,120,100}, outAmb = {180,130,110}},
    ["Galaxy"] = {clock = 0, brightness = 1.5, ambient = {70,60,100}, outAmb = {80,70,110}},
    ["Cyber"] = {clock = 21, brightness = 2.2, ambient = {90,130,170}, outAmb = {100,140,180}},
    ["Sakura"] = {clock = 11, brightness = 3.5, ambient = {170,150,160}, outAmb = {180,160,170}},
    ["Pink Night"] = {clock = 23, brightness = 2.2, ambient = {120,60,110}, outAmb = {140,70,120}},
    ["Blood Moon"] = {clock = 22.5, brightness = 1.6, ambient = {130,40,40}, outAmb = {150,50,50}},
    ["Emerald Dawn"] = {clock = 6.5, brightness = 2.8, ambient = {130,170,140}, outAmb = {140,180,150}},
    ["Volcanic"] = {clock = 19, brightness = 2, ambient = {180,80,40}, outAmb = {200,90,50}},
    ["Arctic"] = {clock = 9, brightness = 3.2, ambient = {200,220,235}, outAmb = {210,230,245}},
    ["Midnight Ocean"] = {clock = 1.5, brightness = 1.7, ambient = {60,90,130}, outAmb = {70,100,140}},
    ["Vaporwave"] = {clock = 19.5, brightness = 2.4, ambient = {180,120,200}, outAmb = {190,130,210}},
    ["Toxic"] = {clock = 13, brightness = 2.5, ambient = {140,180,80}, outAmb = {150,190,90}},
    ["Solar Eclipse"] = {clock = 12, brightness = 0.9, ambient = {50,40,60}, outAmb = {60,50,70}},
    ["Hellscape"] = {clock = 18, brightness = 1.8, ambient = {200,60,30}, outAmb = {220,70,40}},
    ["Heaven"] = {clock = 12, brightness = 4, ambient = {240,235,210}, outAmb = {250,245,220}},
    ["Storm"] = {clock = 15, brightness = 1.4, ambient = {90,90,110}, outAmb = {100,100,120}},
    ["Sunrise"] = {clock = 6.2, brightness = 2.8, ambient = {220,180,130}, outAmb = {230,190,140}},
    ["Deep Space"] = {clock = 0, brightness = 1, ambient = {30,25,50}, outAmb = {40,35,60}},
    ["Lavender Dream"] = {clock = 18.5, brightness = 2.6, ambient = {180,160,220}, outAmb = {190,170,230}},
    ["Inferno"] = {clock = 17.5, brightness = 2.2, ambient = {220,100,40}, outAmb = {235,110,50}},
    ["Mint Sky"] = {clock = 10, brightness = 3.2, ambient = {180,230,210}, outAmb = {190,240,220}},
}
local CandySkyOrder = {
    {"Off","Off"},{"Night","Night"},{"Aurora","Aurora"},{"Sunset","Sunset"},
    {"Galaxy","Galaxy"},{"Cyber","Cyber"},{"Sakura","Sakura"},{"Pink Night","Pink Night"},
    {"Blood Moon","Blood Moon"},{"Emerald Dawn","Emerald Dawn"},{"Volcanic","Volcanic"},
    {"Arctic","Arctic"},{"Midnight Ocean","Midnight Ocean"},{"Vaporwave","Vaporwave"},
    {"Toxic","Toxic"},{"Solar Eclipse","Solar Eclipse"},{"Hellscape","Hellscape"},
    {"Heaven","Heaven"},{"Storm","Storm"},{"Sunrise","Sunrise"},{"Deep Space","Deep Space"},
    {"Lavender Dream","Lavender Dream"},{"Inferno","Inferno"},{"Mint Sky","Mint Sky"}
}

local function candySaveOriginalLighting()
    if candyOriginalLighting then return end
    candyOriginalLighting = {
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
    }
end

local function candyClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(CANDY_SKY_TAG) then
            pcall(function() child:Destroy() end)
        end
    end
end

local function candyColor(rgb) return Color3.fromRGB(rgb[1], rgb[2], rgb[3]) end

local function CandyApplyCustomSky(mode)
    candySaveOriginalLighting()
    candyClearSky()
    local preset = CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        if candyOriginalLighting then
            for k, v in pairs(candyOriginalLighting) do
                pcall(function() Lighting[k] = v end)
            end
        end
        _G._CandyHubSkyMode = "Off"
        return
    end
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = candyColor(preset.ambient) end
    _G._CandyHubSkyMode = mode
end

-- ============================================================
--  GUI CREATION
-- ============================================================
local gui, main, miniBtn, mainPage, lockBtn, lockStroke, aimbotKeyBtn
local autoLeftToggle, autoRightToggle

function drag(f, getLockedFunc)
    local dn, ds, sp, di = false
    local moved = false
    local threshold = 6
    f.InputBegan:Connect(function(i)
        if getLockedFunc and getLockedFunc() then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position; moved = false
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dn = false end
            end)
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if getLockedFunc and getLockedFunc() then return end
            local dx, dy = i.Position.X - ds.X, i.Position.Y - ds.Y
            if (math.abs(dx) > threshold or math.abs(dy) > threshold) and not moved then moved = true end
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dx, sp.Y.Scale, sp.Y.Offset + dy)
        end
    end)
end

function mkSect(parent, txt)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, SECTION_H)
    f.BackgroundTransparency = 1
    local bullet = Instance.new("Frame", f)
    bullet.Size = UDim2.new(0, 5, 0, 5)
    bullet.Position = UDim2.new(0, 2, 0.5, -2)
    bullet.BackgroundColor3 = CANDY_COLORS.ACCENT
    Instance.new("UICorner", bullet).CornerRadius = UDim.new(0, 2)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -18, 1, 0)
    l.Position = UDim2.new(0, 14, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = txt:upper()
    l.TextColor3 = CANDY_COLORS.ACCENT
    l.Font = Enum.Font.GothamBlack
    l.TextSize = IsMobile and 8 or 9
    l.TextXAlignment = Enum.TextXAlignment.Left
end

function mkRow(parent, h, toggleRow)
    local base = toggleRow and Color3.fromRGB(7,15,23) or CANDY_COLORS.CARD
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, h or ROW_H)
    f.BackgroundColor3 = base
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local st = Instance.new("UIStroke", f)
    st.Color = toggleRow and CANDY_COLORS.ICE or CANDY_COLORS.STROKE
    st.Thickness = 1
    st.Transparency = toggleRow and 0.68 or 0.45
    f.MouseEnter:Connect(function()
        TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = toggleRow and Color3.fromRGB(10,22,34) or Color3.fromRGB(12,12,16)}):Play()
        TS:Create(st, TweenInfo.new(0.12), {Color=CANDY_COLORS.ICE, Transparency=0.12}):Play()
    end)
    f.MouseLeave:Connect(function()
        TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3=base}):Play()
        TS:Create(st, TweenInfo.new(0.12), {Color=toggleRow and CANDY_COLORS.ICE or CANDY_COLORS.STROKE, Transparency=toggleRow and 0.68 or 0.45}):Play()
    end)
    return f
end

function mkLabel(row, txt)
    local l = Instance.new("TextLabel", row)
    l.Size = UDim2.new(0.62, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = CANDY_COLORS.TEXT
    l.Font = Enum.Font.GothamBold
    l.TextSize = IsMobile and 9 or 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 2
    return l
end

function mkPill(row, offset)
    local pill = Instance.new("Frame", row)
    pill.Size = UDim2.new(0, 36, 0, 18)
    pill.Position = UDim2.new(1, -(offset or 44), 0.5, -9)
    pill.BackgroundColor3 = CANDY_COLORS.OFF
    pill.ZIndex = row.ZIndex + 3
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", pill)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = CANDY_COLORS.SECONDARY
    dot.ZIndex = row.ZIndex + 4
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    return pill, dot
end

function animPill(pill, dot, on)
    TS:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = on and CANDY_COLORS.ICE or CANDY_COLORS.OFF}):Play()
    TS:Create(dot, TweenInfo.new(0.18), {
        Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
        BackgroundColor3 = on and Color3.fromRGB(0,0,0) or CANDY_COLORS.SECONDARY
    }):Play()
end

-- mkToggle - full row clickable, correct ZIndex
function mkToggle(parent, txt, cb, initialState)
    local row = mkRow(parent, ROW_H, true)
    mkLabel(row, txt)
    local pill, dot = mkPill(row, 46)
    local on = false
    local sv
    sv = function(s)
        on = s
        animPill(pill, dot, s)
        if cb then cb(s) end
    end
    local clk = Instance.new("TextButton", row)
    clk.Size = UDim2.new(1, 0, 1, 0)
    clk.Position = UDim2.new(0, 0, 0, 0)
    clk.BackgroundTransparency = 1
    clk.Text = ""
    clk.ZIndex = row.ZIndex + 1
    clk.AutoButtonColor = false
    clk.Activated:Connect(function()
        sv(not on)
    end)
    if initialState ~= nil then sv(initialState) end
    return sv
end

function mkBox(parent, default, w, xOff, cb)
    local tb = Instance.new("TextBox", parent)
    tb.Size = UDim2.new(0, w or 58, 0, 22)
    tb.Position = UDim2.new(1, -(xOff or 66), 0.5, -11)
    tb.BackgroundColor3 = CANDY_COLORS.INPUT
    tb.BorderSizePixel = 0
    tb.Text = tostring(default)
    tb.TextColor3 = Color3.fromRGB(0,0,0)
    tb.Font = Enum.Font.GothamBlack
    tb.TextSize = 10
    tb.ZIndex = 5
    Instance.new("UICorner", tb).CornerRadius = UDim.new(1, 0)
    local bs = Instance.new("UIStroke", tb)
    bs.Color = CANDY_COLORS.ACCENT
    bs.Thickness = 1
    bs.Transparency = 0.34
    tb.FocusLost:Connect(function()
        if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
    end)
    return tb
end

function buildMainFrame()
    gui = Instance.new("ScreenGui")
    gui.Name = "CandyHub"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui
    if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 20)
    main.BackgroundColor3 = CANDY_COLORS.BG
    main.BorderSizePixel = 0
    main.ClipsDescendants = false
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = CANDY_COLORS.ICE
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.28
    drag(main, function() return uiLocked end)

    local hdr = Instance.new("Frame", main)
    hdr.Size = UDim2.new(1, 0, 0, HDR_H)
    hdr.BackgroundColor3 = CANDY_COLORS.BG
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 16)

    local logo = Instance.new("ImageLabel", hdr)
    logo.Size = UDim2.new(0, 34, 0, 34)
    logo.Position = UDim2.new(0, 12, 0, IsMobile and 11 or 12)
    logo.BackgroundColor3 = CANDY_COLORS.CARD
    logo.Image = "rbxassetid://132178375106504"
    logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    logo.ScaleType = Enum.ScaleType.Fit
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 10)
    local logoStroke = Instance.new("UIStroke", logo)
    logoStroke.Color = CANDY_COLORS.ACCENT
    logoStroke.Thickness = 1
    logoStroke.Transparency = 0.15

    local ttl = Instance.new("TextLabel", hdr)
    ttl.Size = UDim2.new(1, -(IsMobile and 84 or 98), 0, IsMobile and 19 or 22)
    ttl.Position = UDim2.new(0, IsMobile and 50 or 56, 0, IsMobile and 10 or 11)
    ttl.BackgroundTransparency = 1
    ttl.Text = CANDY_BRAND
    ttl.TextColor3 = CANDY_COLORS.TEXT
    ttl.Font = Enum.Font.GothamBlack
    ttl.TextSize = IsMobile and 14 or 17
    ttl.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel", hdr)
    sub.Size = UDim2.new(1, -(IsMobile and 84 or 98), 0, 15)
    sub.Position = UDim2.new(0, IsMobile and 50 or 56, 0, IsMobile and 29 or 34)
    sub.BackgroundTransparency = 1
    sub.Text = CANDY_DISCORD
    sub.TextColor3 = CANDY_COLORS.ICE
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = IsMobile and 9 or 10
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", hdr)
    closeBtn.Size = UDim2.new(0, IsMobile and 23 or 26, 0, IsMobile and 23 or 26)
    closeBtn.Position = UDim2.new(1, IsMobile and -32 or -38, 0, IsMobile and 11 or 14)
    closeBtn.BackgroundColor3 = CANDY_COLORS.CARD
    closeBtn.Text = "-"
    closeBtn.TextColor3 = CANDY_COLORS.ACCENT
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = IsMobile and 17 or 20
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    lockBtn = Instance.new("TextButton", hdr)
    lockBtn.Size = UDim2.new(0, IsMobile and 34 or 42, 0, IsMobile and 23 or 26)
    lockBtn.Position = UDim2.new(1, IsMobile and -70 or -88, 0, IsMobile and 11 or 14)
    lockBtn.BackgroundColor3 = CANDY_COLORS.CARD
    lockBtn.Text = "🔓"
    lockBtn.TextColor3 = CANDY_COLORS.SECONDARY
    lockBtn.Font = Enum.Font.GothamBlack
    lockBtn.TextSize = IsMobile and 13 or 15
    lockBtn.AutoButtonColor = false
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)
    lockStroke = Instance.new("UIStroke", lockBtn)
    lockStroke.Color = CANDY_COLORS.STROKE
    lockStroke.Thickness = 1
    lockStroke.Transparency = 0.38

    lockBtn.Activated:Connect(function()
        uiLocked = not uiLocked
        if uiLocked then
            lockBtn.BackgroundColor3 = CANDY_COLORS.ICE
            lockBtn.TextColor3 = Color3.fromRGB(0,0,0)
            lockBtn.Text = "🔒"
            lockStroke.Color = CANDY_COLORS.ICE
            lockStroke.Transparency = 0.08
        else
            lockBtn.BackgroundColor3 = CANDY_COLORS.CARD
            lockBtn.TextColor3 = CANDY_COLORS.SECONDARY
            lockBtn.Text = "🔓"
            lockStroke.Color = CANDY_COLORS.STROKE
            lockStroke.Transparency = 0.38
        end
    end)

    local divider = Instance.new("Frame", hdr)
    divider.Size = UDim2.new(1, -24, 0, 1)
    divider.Position = UDim2.new(0, 12, 1, -1)
    divider.BackgroundColor3 = CANDY_COLORS.TEXT
    divider.BackgroundTransparency = 0.15
    local divGrad = Instance.new("UIGradient", divider)
    divGrad.Color = ColorSequence.new(CANDY_COLORS.ACCENT, CANDY_COLORS.ICE)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 116, 0, 32)
    miniBtn.Position = UDim2.new(0, 26, 0, 26)
    miniBtn.BackgroundColor3 = CANDY_COLORS.PANEL
    miniBtn.Text = "Candy Hub"
    miniBtn.TextColor3 = CANDY_COLORS.TEXT
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 12
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = CANDY_COLORS.ACCENT
    miniStroke.Thickness = 1
    miniStroke.Transparency = 0.2
    drag(miniBtn, function() return uiLocked end)

    function showGui() main.Visible = true; miniBtn.Visible = false end
    function hideGui() main.Visible = false; miniBtn.Visible = true end
    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.Activated:Connect(function() showGui() end)

    mainPage = Instance.new("ScrollingFrame", main)
    mainPage.Name = "MainPage"
    mainPage.Size = UDim2.new(1, -(PAD*2), 1, -PAGE_BOTTOM)
    mainPage.Position = UDim2.new(0, PAD, 0, PAGE_TOP)
    mainPage.BackgroundTransparency = 1
    mainPage.ScrollBarThickness = 2
    mainPage.ScrollBarImageColor3 = CANDY_COLORS.ICE
    mainPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    mainPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local pageLayout = Instance.new("UIListLayout", mainPage)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, IsMobile and 5 or 7)

    return mainPage
end

function buildProgressBar(parent)
    local pbFrame = Instance.new("Frame", parent)
    pbFrame.Name = "AutoStealProgress"
    pbFrame.Size = UDim2.new(0, 260, 0, PROGRESS_H)
    pbFrame.Position = UDim2.new(0.5, -130, 1, -50)
    pbFrame.BackgroundColor3 = CANDY_COLORS.BG
    pbFrame.BackgroundTransparency = 0.2
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)
    local pbs = Instance.new("UIStroke", pbFrame)
    pbs.Color = CANDY_COLORS.ICE; pbs.Thickness = 1; pbs.Transparency = 0.2
    progressPct = Instance.new("TextLabel", pbFrame)
    progressPct.Size = UDim2.new(0,128,0,16); progressPct.Position = UDim2.new(0,10,0,8)
    progressPct.BackgroundTransparency = 1; progressPct.Text = "IDLE |"
    progressPct.TextColor3 = CANDY_COLORS.TEXT; progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 10; progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressRadLbl = Instance.new("TextLabel", pbFrame)
    progressRadLbl.Size = UDim2.new(0,118,0,16); progressRadLbl.Position = UDim2.new(1,-128,0,8)
    progressRadLbl.BackgroundTransparency = 1
    progressRadLbl.Text = string.format("Radius: %.2g", CONFIG_AUTO_STEAL.STEAL_RANGE)
    progressRadLbl.TextColor3 = CANDY_COLORS.ICE; progressRadLbl.Font = Enum.Font.GothamBlack
    progressRadLbl.TextSize = 10; progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right
    local pbg = Instance.new("Frame", pbFrame)
    pbg.Size = UDim2.new(1,-20,0,6); pbg.Position = UDim2.new(0,10,1,-11)
    pbg.BackgroundColor3 = Color3.fromRGB(10,10,14)
    Instance.new("UICorner", pbg).CornerRadius = UDim.new(1,0)
    progressFill = Instance.new("Frame", pbg)
    progressFill.Size = UDim2.new(0,0,1,0)
    progressFill.BackgroundColor3 = CANDY_COLORS.ACCENT
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1,0)
    drag(pbFrame, function() return uiLocked end)
end

function buildSpeedValues(parent)
    mkSect(parent, "Speed Values")
    local row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Normal Speed")
    mkBox(row, NS, 58, 68, function(v) if v>0 and v<=500 then NS = v end end)
    row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Carry Speed")
    mkBox(row, CS, 58, 68, function(v) if v>0 and v<=500 then CS = v end end)
    row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Lagger Speed")
    mkBox(row, LAGGER_SPEED, 58, 68, function(v) if v>0 and v<=500 then LAGGER_SPEED = v end end)
    row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Lagger Carry Speed")
    mkBox(row, LAGGER_CARRY_SPEED, 58, 68, function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED = v end end)
    row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Mode")
    modeValLbl = Instance.new("TextLabel", row)
    modeValLbl.Size = UDim2.new(0, 110, 1, 0)
    modeValLbl.Position = UDim2.new(1, -118, 0, 0)
    modeValLbl.BackgroundTransparency = 1
    modeValLbl.Text = "Normal"
    modeValLbl.TextColor3 = CANDY_COLORS.ACCENT
    modeValLbl.Font = Enum.Font.GothamBlack
    modeValLbl.TextSize = 11
    modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
    modeValLbl.ZIndex = 3
    local modeBtn = Instance.new("TextButton", row)
    modeBtn.Size = UDim2.new(1, 0, 1, 0)
    modeBtn.BackgroundTransparency = 1
    modeBtn.Text = ""
    modeBtn.ZIndex = 2
    modeBtn.Activated:Connect(function()
        speedMode = not speedMode
        if laggerToggled and speedMode then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end)
end

function buildSpeedKeybinds(parent)
    mkSect(parent, "Speed Keybinds")
    local row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Speed Key")
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 58, 0, 22)
    btn.Position = UDim2.new(1, -66, 0.5, -11)
    btn.BackgroundColor3 = CANDY_COLORS.INPUT
    btn.Text = "Q"
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 8
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    btn.Activated:Connect(function()
        speedMode = not speedMode
        if laggerToggled and speedMode then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end)
    row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Lagger Key")
    btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 58, 0, 22)
    btn.Position = UDim2.new(1, -66, 0.5, -11)
    btn.BackgroundColor3 = CANDY_COLORS.INPUT
    btn.Text = "R"
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 8
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    btn.Activated:Connect(function()
        laggerToggled = not laggerToggled
        if laggerToggled and speedMode then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end)
end

function buildBatAimbot(parent)
    mkSect(parent, "Bat Aimbot")
    mkToggle(parent, "Auto Swing", function(on) autoSwingEnabled = on end, true)
    mkToggle(parent, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end, false)
    mkToggle(parent, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then setupMedusa(LP.Character) end
    end, false)
    local row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Aimbot Key")
    aimbotKeyBtn = Instance.new("TextButton", row)
    aimbotKeyBtn.Size = UDim2.new(0, 58, 0, 22)
    aimbotKeyBtn.Position = UDim2.new(1, -66, 0.5, -11)
    aimbotKeyBtn.BackgroundColor3 = CANDY_COLORS.INPUT
    aimbotKeyBtn.Text = "E"
    aimbotKeyBtn.TextColor3 = Color3.fromRGB(0,0,0)
    aimbotKeyBtn.Font = Enum.Font.GothamBlack
    aimbotKeyBtn.TextSize = 8
    aimbotKeyBtn.ZIndex = 3
    Instance.new("UICorner", aimbotKeyBtn).CornerRadius = UDim.new(1, 0)
    aimbotKeyBtn.Activated:Connect(function()
        if not autoBatActive then
            startBatAimbot()
            autoBatActive = true
            aimbotKeyBtn.BackgroundColor3 = CANDY_COLORS.ICE
        else
            stopBatAimbot()
            autoBatActive = false
            aimbotKeyBtn.BackgroundColor3 = CANDY_COLORS.INPUT
        end
    end)
end

function buildInstaGrab(parent)
    mkSect(parent, "Insta Grab")
    mkToggle(parent, "Auto Steal", function(on)
        CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
    end, false)
    local row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Steal Radius")
    mkBox(row, CONFIG_AUTO_STEAL.STEAL_RANGE, 58, 68, function(v)
        if v >= 0.5 and v <= 300 then
            CONFIG_AUTO_STEAL.STEAL_RANGE = v
            if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.2g", CONFIG_AUTO_STEAL.STEAL_RANGE) end
        end
    end)
end

function buildSkyTheme(parent)
    mkSect(parent, "Sky Theme")
    local row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Theme")
    local skyIndex = 1
    local current = _G._CandyHubSkyMode or "Off"
    for i, entry in ipairs(CandySkyOrder) do
        if entry[2] == current then skyIndex = i; break end
    end
    local skyVal = Instance.new("TextLabel", row)
    skyVal.Size = UDim2.new(0, 150, 1, 0)
    skyVal.Position = UDim2.new(1, -158, 0, 0)
    skyVal.BackgroundTransparency = 1
    skyVal.Text = CandySkyOrder[skyIndex][2]
    skyVal.TextColor3 = CANDY_COLORS.ACCENT
    skyVal.Font = Enum.Font.GothamBlack
    skyVal.TextSize = 11
    skyVal.TextXAlignment = Enum.TextXAlignment.Right
    skyVal.ZIndex = 3
    local skyBtn = Instance.new("TextButton", row)
    skyBtn.Size = UDim2.new(1, 0, 1, 0)
    skyBtn.BackgroundTransparency = 1
    skyBtn.Text = ""
    skyBtn.ZIndex = 2
    skyBtn.Activated:Connect(function()
        skyIndex = skyIndex % #CandySkyOrder + 1
        local label = CandySkyOrder[skyIndex][2]
        skyVal.Text = label
        CandyApplyCustomSky(label)
    end)
end

function buildMovement(parent)
    mkSect(parent, "Movement")
    autoLeftToggle = mkToggle(parent, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
    end, false)
    autoRightToggle = mkToggle(parent, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
    end, false)
    local row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Drop Brainrot")
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0,58,0,22); btn.Position = UDim2.new(1,-66,0.5,-11)
    btn.BackgroundColor3 = CANDY_COLORS.INPUT; btn.Text = "X"; btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBlack; btn.TextSize = 8; btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    btn.Activated:Connect(runDrop)
    row = mkRow(parent, ROW_H, false)
    mkLabel(row, "TP Down")
    btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0,58,0,22); btn.Position = UDim2.new(1,-66,0.5,-11)
    btn.BackgroundColor3 = CANDY_COLORS.INPUT; btn.Text = "F"; btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBlack; btn.TextSize = 8; btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    btn.Activated:Connect(runTPFloor)
    mkToggle(parent, "Auto TP Down", function(on)
        autoTPEnabled = on
        if on then startAutoTP() else stopAutoTP() end
    end, false)
    row = mkRow(parent, ROW_H, false)
    mkLabel(row, "TP Height")
    mkBox(row, autoTPHeight, 64, 74, function(v) if v>=0 and v<=500 then autoTPHeight = v end end)
    mkToggle(parent, "Infinite Jump", function(on) infJumpEnabled = on end, false)
    mkToggle(parent, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end, false)
    mkToggle(parent, "Anti Ragdoll", function(on) antiRagdollEnabled = on end, false)
end

function buildVisuals(parent)
    mkSect(parent, "Visuals")
    mkToggle(parent, "FPS Boost (107 FOV)", function(on)
        if on then enableStretchRez() else disableStretchRez() end
    end, false)
    mkToggle(parent, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end, false)
end

function buildSettings(parent)
    mkSect(parent, "Settings")
    mkToggle(parent, "Lock GUI", function(on)
        uiLocked = on
        if on then
            lockBtn.BackgroundColor3 = CANDY_COLORS.ICE
            lockBtn.TextColor3 = Color3.fromRGB(0,0,0)
            lockBtn.Text = "🔒"
            lockStroke.Color = CANDY_COLORS.ICE
            lockStroke.Transparency = 0.08
        else
            lockBtn.BackgroundColor3 = CANDY_COLORS.CARD
            lockBtn.TextColor3 = CANDY_COLORS.SECONDARY
            lockBtn.Text = "🔓"
            lockStroke.Color = CANDY_COLORS.STROKE
            lockStroke.Transparency = 0.38
        end
    end, false)
    local row = mkRow(parent, ROW_H, false)
    mkLabel(row, "Hide UI Key")
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0,58,0,22); btn.Position = UDim2.new(1,-66,0.5,-11)
    btn.BackgroundColor3 = CANDY_COLORS.INPUT; btn.Text = "LCTRL"
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBlack; btn.TextSize = 8; btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    btn.Activated:Connect(function()
        if main.Visible then hideGui() else showGui() end
    end)

    if IsMobile then
        row = mkRow(parent, ROW_H, false)
        mkLabel(row, "Mobile Btn Size")
        local sizeBox = mkBox(row, 62, 58, 66, function(v)
            if v and v >= 40 and v <= 100 then
                updateMobileButtonSize(v)
            end
        end)
        sizeBox.Text = "62"
    end
end

-- Mobile buttons
local mobileGui, mobileContainer, mobileButtonsRefs = nil, nil, {}
local currentBtnSize = 62

function updateMobileButtonSize(newSize)
    if not mobileContainer then return end
    currentBtnSize = newSize
    local BW, BH = currentBtnSize, currentBtnSize
    local COL_GAP, ROW_GAP = 18, 16
    mobileContainer.Size = UDim2.new(0, (BW * 2) + COL_GAP, 0, (BH * 4) + (ROW_GAP * 3))
    for idx, btnFrame in ipairs(mobileButtonsRefs) do
        local col = ((idx-1) % 2) + 1
        local row = math.floor((idx-1)/2) + 1
        local x = (col-1) * (BW + COL_GAP)
        local y = (row-1) * (BH + ROW_GAP)
        btnFrame.Size = UDim2.new(0, BW, 0, BH)
        btnFrame.Position = UDim2.new(0, x, 0, y)
        local btn = btnFrame:FindFirstChildWhichIsA("TextButton")
        if btn then
            btn.TextSize = math.max(8, math.min(12, math.floor(currentBtnSize/6)))
        end
    end
end

function buildMobileButtons()
    mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "CandyHubMobileButtons"
    mobileGui.ResetOnSpawn = false
    mobileGui.DisplayOrder = 998
    mobileGui.IgnoreGuiInset = true
    pcall(function() mobileGui.Parent = CoreGui end)
    if not mobileGui.Parent then mobileGui.Parent = LP:WaitForChild("PlayerGui") end

    local BG_BTN = CANDY_COLORS.CARD
    local ACCENT = CANDY_COLORS.ACCENT
    local TXT_C = CANDY_COLORS.TEXT
    local ICE = CANDY_COLORS.ICE
    local BW, BH = currentBtnSize, currentBtnSize
    local COL_GAP, ROW_GAP = 18, 16

    mobileContainer = Instance.new("Frame", mobileGui)
    mobileContainer.Name = "MobileButtons"
    mobileContainer.AnchorPoint = Vector2.new(1, 0)
    mobileContainer.Size = UDim2.new(0, (BW * 2) + COL_GAP, 0, (BH * 4) + (ROW_GAP * 3))
    mobileContainer.Position = UDim2.new(1, -20, 0.12, 0)
    mobileContainer.BackgroundTransparency = 1
    mobileContainer.Active = false
    drag(mobileContainer, function() return uiLocked end)

    local resizeHandle = Instance.new("Frame", mobileContainer)
    resizeHandle.Size = UDim2.new(0, 16, 0, 16)
    resizeHandle.Position = UDim2.new(1, -18, 1, -18)
    resizeHandle.BackgroundColor3 = CANDY_COLORS.ACCENT
    resizeHandle.BackgroundTransparency = 0.6
    resizeHandle.BorderSizePixel = 0
    Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(1, 0)
    local draggingResize = false
    local startPos, startSize
    resizeHandle.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingResize = true
            startPos = input.Position
            startSize = mobileContainer.AbsoluteSize
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then draggingResize = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if draggingResize and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position.X - startPos.X
            local newWidth = math.clamp(startSize.X + delta, 120, 300)
            local newBtnSize = math.floor(newWidth / 2.5)
            newBtnSize = math.clamp(newBtnSize, 40, 100)
            if newBtnSize ~= currentBtnSize then
                updateMobileButtonSize(newBtnSize)
            end
        end
    end)

    MobileButtonActions = {}
    MobileButtonActions.AutoLeft = function(sa, on)
        sa(not on); autoLeftEnabled = not on
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftToggle then autoLeftToggle(autoLeftEnabled) end
    end
    MobileButtonActions.AutoRight = function(sa, on)
        sa(not on); autoRightEnabled = not on
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightToggle then autoRightToggle(autoRightEnabled) end
    end
    MobileButtonActions.AutoBat = function(sa, on)
        sa(not on)
        if not on then
            startBatAimbot()
            if aimbotKeyBtn then aimbotKeyBtn.BackgroundColor3 = CANDY_COLORS.ICE end
        else
            stopBatAimbot()
            if aimbotKeyBtn then aimbotKeyBtn.BackgroundColor3 = CANDY_COLORS.INPUT end
        end
    end
    MobileButtonActions.CarrySpeed = function(sa, on)
        speedMode = not on; sa(speedMode)
        if laggerToggled and speedMode then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    MobileButtonActions.DropBrainrot = function(sa, on)
        sa(true); runDrop(); task.delay(0.5, function() sa(false) end)
    end
    MobileButtonActions.TPDown = function(sa, on)
        sa(true); runTPFloor(); task.delay(0.1, function() sa(false) end)
    end
    MobileButtonActions.LaggerCarry = function(sa, on)
        local enabled = not (laggerToggled and speedMode)
        laggerToggled = enabled; speedMode = enabled; sa(laggerToggled and speedMode)
        if laggerToggled and speedMode then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    MobileButtonActions.LaggerSpeed = function(sa, on)
        laggerToggled = not on; sa(laggerToggled)
        if laggerToggled and speedMode then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    MobileButtonActions.ToggleGUI = function()
        if main.Visible then hideGui() else showGui() end
    end

    function makeBtn(id, actionKey, label, col, rowN, accentColor)
        local x = (col-1) * (BW + COL_GAP)
        local y = (rowN-1) * (BH + ROW_GAP)
        local f = Instance.new("Frame", mobileContainer)
        f.Size = UDim2.new(0, BW, 0, BH)
        f.Position = UDim2.new(0, x, 0, y)
        f.BackgroundColor3 = BG_BTN
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", f)
        st.Color = ICE; st.Thickness = 1; st.Transparency = 0.34
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundTransparency = 1
        btn.Text = label
        btn.TextColor3 = TXT_C
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = math.max(8, math.min(12, math.floor(currentBtnSize/6)))
        btn.AutoButtonColor = false
        local isOn = false
        function setActive(on)
            isOn = on
            TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = on and Color3.fromRGB(8,18,28) or BG_BTN}):Play()
            TS:Create(st, TweenInfo.new(0.15), {Color = on and accentColor or ICE, Transparency = on and 0.04 or 0.34}):Play()
            TS:Create(btn, TweenInfo.new(0.15), {TextColor3 = on and accentColor or TXT_C}):Play()
        end
        btn.MouseEnter:Connect(function()
            if not isOn then
                TS:Create(st, TweenInfo.new(0.12), {Transparency=0.02, Thickness=1.35}):Play()
                TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(22,22,27)}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not isOn then
                TS:Create(st, TweenInfo.new(0.12), {Transparency=0.34, Thickness=1}):Play()
                TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3=BG_BTN}):Play()
            end
        end)
        btn.Activated:Connect(function()
            local action = MobileButtonActions[actionKey]
            if action then action(setActive, isOn) end
        end)
        table.insert(mobileButtonsRefs, f)
        return setActive
    end

    local setAL = makeBtn("autoLeft",  "AutoLeft",    "AUTO\nLEFT",    1, 1, ACCENT)
    local setAR = makeBtn("autoRight", "AutoRight",   "AUTO\nRIGHT",   2, 1, ICE)
    local setAB = makeBtn("autoBat",   "AutoBat",     "AIMBOT",        1, 2, ICE)
    local setSP = makeBtn("carry",     "CarrySpeed",  "CARRY\nSPEED",  2, 2, ACCENT)
    makeBtn("drop",    "DropBrainrot","DROP\nBR",     1, 3, ACCENT)
    makeBtn("tpDown",  "TPDown",      "TP\nDOWN",     2, 3, ICE)
    local setLC = makeBtn("lagCarry",  "LaggerCarry", "LAGGER\nCARRY", 1, 4, ICE)
    local setLG = makeBtn("lagger",    "LaggerSpeed", "LAGGER\nSPEED", 2, 4, ACCENT)

    RunService.Heartbeat:Connect(function()
        setAL(autoLeftEnabled)
        setAR(autoRightEnabled)
        setAB(autoBatEnabled)
        setLG(laggerToggled)
        setSP(speedMode)
        setLC(laggerToggled and speedMode)
    end)
end

function setupKeybinds()
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe or UIS:GetFocusedTextBox() or _anyKeyListening then return end
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Q then
            speedMode = not speedMode
            if laggerToggled and speedMode then modeValLbl.Text = "Lagger Carry"
            elseif laggerToggled then modeValLbl.Text = "Lagger"
            elseif speedMode then modeValLbl.Text = "Carry"
            else modeValLbl.Text = "Normal" end
        elseif kc == Enum.KeyCode.R then
            laggerToggled = not laggerToggled
            if laggerToggled and speedMode then modeValLbl.Text = "Lagger Carry"
            elseif laggerToggled then modeValLbl.Text = "Lagger"
            elseif speedMode then modeValLbl.Text = "Carry"
            else modeValLbl.Text = "Normal" end
        elseif kc == Enum.KeyCode.X then runDrop()
        elseif kc == Enum.KeyCode.F then runTPFloor()
        elseif kc == Enum.KeyCode.Z then
            autoLeftEnabled = not autoLeftEnabled
            if autoLeftToggle then autoLeftToggle(autoLeftEnabled) end
            if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        elseif kc == Enum.KeyCode.C then
            autoRightEnabled = not autoRightEnabled
            if autoRightToggle then autoRightToggle(autoRightEnabled) end
            if autoRightEnabled then startAutoRight() else stopAutoRight() end
        elseif kc == Enum.KeyCode.E then
            if not autoBatActive then
                startBatAimbot(); autoBatActive = true
                if aimbotKeyBtn then aimbotKeyBtn.BackgroundColor3 = CANDY_COLORS.ICE end
            else
                stopBatAimbot(); autoBatActive = false
                if aimbotKeyBtn then aimbotKeyBtn.BackgroundColor3 = CANDY_COLORS.INPUT end
            end
        elseif kc == Enum.KeyCode.LeftControl then
            if main.Visible then hideGui() else showGui() end
        end
    end)
end

-- ============================================================
--  EXECUTION
-- ============================================================
local page = buildMainFrame()
buildProgressBar(gui)
buildSpeedValues(page)
buildSpeedKeybinds(page)
buildBatAimbot(page)
buildInstaGrab(page)
buildSkyTheme(page)
buildMovement(page)
buildVisuals(page)
buildSettings(page)
buildMobileButtons()
setupKeybinds()
showGui()

-- Play intro animation after everything is built
playCandyIntro(gui, main, miniBtn)

print("Candy Hub loaded with intro!")
