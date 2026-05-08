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

task.wait(0.1)

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local guiScale = isMobile and 0.55 or 1

local sg = Instance.new("ScreenGui")
sg.Name = "51sDuelHub"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = Player.PlayerGui

local W, H = 560 * guiScale, 600 * guiScale

-- Orange color scheme
local ORANGE_PRIMARY = Color3.fromRGB(255, 140, 0)
local ORANGE_DARK = Color3.fromRGB(200, 100, 0)
local ORANGE_LIGHT = Color3.fromRGB(255, 165, 0)

-- Feature States
local Features = {
    SpeedBoost          = false,
    AntiRagdoll         = false,
    AutoSteal           = false,
    SpamBat             = false,
    SpeedWhileStealing  = false,
    Float               = false,
    Unwalk              = false,
    OptimizerXRay       = false,

}

local Values = {
    BoostSpeed           = 30,
    SpinSpeed            = 10,
    DEFAULT_GRAVITY      = 196.2,
    GalaxyGravityPercent = 70,
    StealingSpeedValue   = 29,
    HOP_POWER            = 35,
    HOP_COOLDOWN         = 0.08,
    STEAL_RADIUS         = 20,
}

local AutoStealValues = { STEAL_RADIUS = 20, STEAL_DURATION = 1.3 }

-- ─── Progress Bar Variables ───────────────────────────────────────────────────
local ProgressBarFill      = nil
local ProgressLabel        = nil
local ProgressPercentLabel = nil
local progressConn         = nil
local stealStartTime       = nil

local function resetProgressBar()
    if ProgressLabel        then ProgressLabel.Text = "Claim" end
    if ProgressPercentLabel then ProgressPercentLabel.Text = "0%" end
    if ProgressBarFill      then ProgressBarFill.Size = UDim2.new(0, 0, 1, 0) end
end

-- ─── Progress Bar ─────────────────────────────────────────────────────────────
local PB_W = 300 * guiScale
local PB_H = 36 * guiScale

local progressBar = Instance.new("Frame", sg)
progressBar.Size = UDim2.new(0, PB_W, 0, PB_H)
progressBar.Position = UDim2.new(0.5, -PB_W / 2, 1, -150 * guiScale)
progressBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
progressBar.BackgroundTransparency = 0.1
progressBar.BorderSizePixel = 0
progressBar.ClipsDescendants = false
progressBar.ZIndex = 10
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 6 * guiScale)

local pStroke = Instance.new("UIStroke", progressBar)
pStroke.Thickness = 1.5 * guiScale
pStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
pStroke.Color = ORANGE_PRIMARY

-- "Claim" label on the left
ProgressLabel = Instance.new("TextLabel", progressBar)
ProgressLabel.Size = UDim2.new(0.28, 0, 0, 18 * guiScale)
ProgressLabel.Position = UDim2.new(0, 8 * guiScale, 0, 4 * guiScale)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Claim"
ProgressLabel.TextColor3 = ORANGE_PRIMARY
ProgressLabel.Font = Enum.Font.GothamBlack
ProgressLabel.TextSize = 12 * guiScale
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.ZIndex = 13
ProgressLabel.Visible = true

-- Percentage label in the center
ProgressPercentLabel = Instance.new("TextLabel", progressBar)
ProgressPercentLabel.Size = UDim2.new(0.4, 0, 0, 18 * guiScale)
ProgressPercentLabel.Position = UDim2.new(0.3, 0, 0, 4 * guiScale)
ProgressPercentLabel.BackgroundTransparency = 1
ProgressPercentLabel.Text = "0%"
ProgressPercentLabel.Font = Enum.Font.GothamBlack
ProgressPercentLabel.TextSize = 12 * guiScale
ProgressPercentLabel.TextXAlignment = Enum.TextXAlignment.Center
ProgressPercentLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
ProgressPercentLabel.ZIndex = 13

-- "Radius:" label on the right
local radiusLabel = Instance.new("TextLabel", progressBar)
radiusLabel.Size = UDim2.new(0.2, 0, 0, 18 * guiScale)
radiusLabel.Position = UDim2.new(0.62, 0, 0, 4 * guiScale)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Radius:"
radiusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
radiusLabel.Font = Enum.Font.GothamBlack
radiusLabel.TextSize = 10 * guiScale
radiusLabel.TextXAlignment = Enum.TextXAlignment.Right
radiusLabel.ZIndex = 13

-- Minus button
local minusBtn = Instance.new("TextButton", progressBar)
minusBtn.Size = UDim2.new(0, 18 * guiScale, 0, 18 * guiScale)
minusBtn.Position = UDim2.new(0.83, 0, 0, 4 * guiScale)
minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minusBtn.Text = "-"
minusBtn.TextColor3 = ORANGE_PRIMARY
minusBtn.Font = Enum.Font.GothamBlack
minusBtn.TextSize = 13 * guiScale
minusBtn.BorderSizePixel = 0
minusBtn.ZIndex = 14
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4 * guiScale)

-- Radius value label (center of the controls)
local radiusValueLabel = Instance.new("TextLabel", progressBar)
radiusValueLabel.Size = UDim2.new(0.08, 0, 0, 18 * guiScale)
radiusValueLabel.Position = UDim2.new(0.865, 0, 0, 4 * guiScale)
radiusValueLabel.BackgroundTransparency = 1
radiusValueLabel.Text = tostring(Values.STEAL_RADIUS)
radiusValueLabel.TextColor3 = ORANGE_PRIMARY
radiusValueLabel.Font = Enum.Font.GothamBlack
radiusValueLabel.TextSize = 12 * guiScale
radiusValueLabel.TextXAlignment = Enum.TextXAlignment.Center
radiusValueLabel.ZIndex = 14

-- Plus button
local plusBtn = Instance.new("TextButton", progressBar)
plusBtn.Size = UDim2.new(0, 18 * guiScale, 0, 18 * guiScale)
plusBtn.Position = UDim2.new(0.935, 0, 0, 4 * guiScale)
plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
plusBtn.Text = "+"
plusBtn.TextColor3 = ORANGE_PRIMARY
plusBtn.Font = Enum.Font.GothamBlack
plusBtn.TextSize = 13 * guiScale
plusBtn.BorderSizePixel = 0
plusBtn.ZIndex = 14
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4 * guiScale)

-- Button logic
local function updateRadius()
    Values.STEAL_RADIUS = math.clamp(Values.STEAL_RADIUS, 5, 100)
    AutoStealValues.STEAL_RADIUS = Values.STEAL_RADIUS
    radiusValueLabel.Text = tostring(Values.STEAL_RADIUS)
end

minusBtn.MouseButton1Click:Connect(function()
    Values.STEAL_RADIUS = Values.STEAL_RADIUS - 5
    updateRadius()
end)

plusBtn.MouseButton1Click:Connect(function()
    Values.STEAL_RADIUS = Values.STEAL_RADIUS + 5
    updateRadius()
end)

-- Hover effects
minusBtn.MouseEnter:Connect(function()
    TweenService:Create(minusBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
end)
minusBtn.MouseLeave:Connect(function()
    TweenService:Create(minusBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
end)
plusBtn.MouseEnter:Connect(function()
    TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
end)
plusBtn.MouseLeave:Connect(function()
    TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
end)

-- Fill track (orange bar at bottom)
local pTrack = Instance.new("Frame", progressBar)
pTrack.Size = UDim2.new(1, -8 * guiScale, 0, 5 * guiScale)
pTrack.Position = UDim2.new(0, 4 * guiScale, 1, -9 * guiScale)
pTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
pTrack.BorderSizePixel = 0
pTrack.ZIndex = 11
Instance.new("UICorner", pTrack).CornerRadius = UDim.new(1, 0)

ProgressBarFill = Instance.new("Frame", pTrack)
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = ORANGE_PRIMARY
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.ZIndex = 12
Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(1, 0)

-- Keep radius value in sync with the Values table
RunService.Heartbeat:Connect(function()
    radiusValueLabel.Text = tostring(Values.STEAL_RADIUS)
end)

-- ─── Main Window ──────────────────────────────────────────────────────────────
local main = Instance.new("Frame", sg)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = isMobile
    and UDim2.new(0.5, -W/2, 0.5, -H/2)
    or  UDim2.new(1, -W - 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = true
main.Draggable = false
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12 * guiScale)

-- ─── Header ───────────────────────────────────────────────────────────────────
local headerH = 54 * guiScale
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, headerH)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
header.ZIndex = 4
header.Active = true
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12 * guiScale)

local headerBottom = Instance.new("Frame", header)
headerBottom.Size = UDim2.new(1, 0, 0.5, 0)
headerBottom.Position = UDim2.new(0, 0, 0.5, 0)
headerBottom.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
headerBottom.BorderSizePixel = 0
headerBottom.ZIndex = 3

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 0.55, 0)
title.Position = UDim2.new(0, 10 * guiScale, 0.05, 0)
title.BackgroundTransparency = 1
title.Text = ""
title.Font = Enum.Font.GothamBlack
title.TextSize = 15 * guiScale
title.TextColor3 = ORANGE_PRIMARY
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6

-- 51s Logo
local logo = Instance.new("TextLabel", header)
logo.Size = UDim2.new(0, 40 * guiScale, 0, 40 * guiScale)
logo.Position = UDim2.new(0, 8 * guiScale, 0.5, -20 * guiScale)
logo.BackgroundColor3 = ORANGE_PRIMARY
logo.BorderSizePixel = 0
logo.Text = "51s"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 18 * guiScale
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.ZIndex = 6
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 6 * guiScale)

-- Duels text next to logo
local duelsText = Instance.new("TextLabel", header)
duelsText.Size = UDim2.new(1, 0, 0.55, 0)
duelsText.Position = UDim2.new(0, 55 * guiScale, 0.05, 0)
duelsText.BackgroundTransparency = 1
duelsText.Text = "Duels"
duelsText.Font = Enum.Font.GothamBlack
duelsText.TextSize = 20 * guiScale
duelsText.TextColor3 = ORANGE_PRIMARY
duelsText.TextXAlignment = Enum.TextXAlignment.Left
duelsText.ZIndex = 6

-- Orange line below title
local titleLine = Instance.new("Frame", header)
titleLine.Size = UDim2.new(1, 0, 0, 2 * guiScale)
titleLine.Position = UDim2.new(0, 0, 0.95, 0)
titleLine.BackgroundColor3 = ORANGE_PRIMARY
titleLine.BorderSizePixel = 0
titleLine.ZIndex = 5

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 28 * guiScale, 0, 28 * guiScale)
closeBtn.Position = UDim2.new(1, -36 * guiScale, 0.5, -14 * guiScale)
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 13 * guiScale
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 7
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6 * guiScale)
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
end)

-- ─── Header-only Drag Logic ───────────────────────────────────────────────────
do
    local dragging = false
    local dragStart, startPos

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function onInputChanged(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end

    header.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
end

-- ─── Content Area ─────────────────────────────────────────────────────────────
local contentArea = Instance.new("Frame", main)
contentArea.Size = UDim2.new(1, 0, 1, -headerH)
contentArea.Position = UDim2.new(0, 0, 0, headerH)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.ZIndex = 3

-- ─── LEFT COLUMN ──────────────────────────────────────────────────────────────
local leftColumn = Instance.new("Frame", contentArea)
leftColumn.Size = UDim2.new(0.46, 0, 1, -10 * guiScale)
leftColumn.Position = UDim2.new(0.02, 0, 0, 5 * guiScale)
leftColumn.BackgroundTransparency = 1
leftColumn.BorderSizePixel = 0
leftColumn.ClipsDescendants = true

-- Combat header
local combatHeader = Instance.new("TextLabel", leftColumn)
combatHeader.Size = UDim2.new(1, 0, 0, 30 * guiScale)
combatHeader.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
combatHeader.BorderSizePixel = 0
combatHeader.Text = "Combat⚔️"
combatHeader.Font = Enum.Font.GothamBlack
combatHeader.TextSize = 14 * guiScale
combatHeader.TextColor3 = ORANGE_PRIMARY
combatHeader.ZIndex = 3
Instance.new("UICorner", combatHeader).CornerRadius = UDim.new(0, 8 * guiScale)

local leftScroll = Instance.new("ScrollingFrame", leftColumn)
leftScroll.Size = UDim2.new(1, 0, 1, -35 * guiScale)
leftScroll.Position = UDim2.new(0, 0, 0, 35 * guiScale)
leftScroll.BackgroundTransparency = 1
leftScroll.BorderSizePixel = 0
leftScroll.ScrollBarThickness = 6 * guiScale
leftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
leftScroll.ZIndex = 3

-- ─── RIGHT COLUMN ─────────────────────────────────────────────────────────────
local rightColumn = Instance.new("Frame", contentArea)
rightColumn.Size = UDim2.new(0.46, 0, 1, -10 * guiScale)
rightColumn.Position = UDim2.new(0.52, 0, 0, 5 * guiScale)
rightColumn.BackgroundTransparency = 1
rightColumn.BorderSizePixel = 0
rightColumn.ClipsDescendants = true

-- Movements header
local movementsHeader = Instance.new("TextLabel", rightColumn)
movementsHeader.Size = UDim2.new(1, 0, 0, 30 * guiScale)
movementsHeader.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
movementsHeader.BorderSizePixel = 0
movementsHeader.Text = "Movements🚀"
movementsHeader.Font = Enum.Font.GothamBlack
movementsHeader.TextSize = 14 * guiScale
movementsHeader.TextColor3 = ORANGE_PRIMARY
movementsHeader.ZIndex = 3
Instance.new("UICorner", movementsHeader).CornerRadius = UDim.new(0, 8 * guiScale)

local rightScroll = Instance.new("ScrollingFrame", rightColumn)
rightScroll.Size = UDim2.new(1, 0, 1, -35 * guiScale)
rightScroll.Position = UDim2.new(0, 0, 0, 35 * guiScale)
rightScroll.BackgroundTransparency = 1
rightScroll.BorderSizePixel = 0
rightScroll.ScrollBarThickness = 6 * guiScale
rightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
rightScroll.ZIndex = 3

-- ─── UIListLayouts ────────────────────────────────────────────────────────────
local leftLayout = Instance.new("UIListLayout", leftScroll)
leftLayout.Padding = UDim.new(0, 8 * guiScale)
leftLayout.FillDirection = Enum.FillDirection.Vertical
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local rightLayout = Instance.new("UIListLayout", rightScroll)
rightLayout.Padding = UDim.new(0, 8 * guiScale)
rightLayout.FillDirection = Enum.FillDirection.Vertical
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ─── Canvas auto-resize ────────────────────────────────────────────────────────
leftLayout.Changed:Connect(function()
    leftScroll.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 16 * guiScale)
end)
rightLayout.Changed:Connect(function()
    rightScroll.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 16 * guiScale)
end)

-- ─── Helper: make a toggle frame ──────────────────────────────────────────────
local toggleOrder = 0

local function makeToggleHeader(parent, labelText)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10 * guiScale, 0, 40 * guiScale)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.LayoutOrder = toggleOrder
    toggleOrder = toggleOrder + 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8 * guiScale)

    local fStroke = Instance.new("UIStroke", frame)
    fStroke.Thickness = 1.5 * guiScale
    fStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    fStroke.Color = ORANGE_PRIMARY

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8 * guiScale, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 12 * guiScale
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("Frame", frame)
    bg.Size = UDim2.new(0, 44 * guiScale, 0, 22 * guiScale)
    bg.Position = UDim2.new(1, -50 * guiScale, 0.5, -11 * guiScale)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bg.ZIndex = 4
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", bg)
    circle.Size = UDim2.new(0, 18 * guiScale, 0, 18 * guiScale)
    circle.Position = UDim2.new(0, 2 * guiScale, 0.5, -9 * guiScale)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.ZIndex = 5
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 6

    local isOn = false

    local function updateVisual()
        if isOn then
            TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = ORANGE_PRIMARY}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1,-20*guiScale,0.5,-9*guiScale)}):Play()
        else
            TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0,2*guiScale,0.5,-9*guiScale)}):Play()
        end
    end

    return btn, function(state)
        isOn = state
        updateVisual()
    end, function() return isOn end
end

-- ─── Helper: create slider ────────────────────────────────────────────────────
local function createSlider(parent, labelText, minVal, maxVal, valueKey, onChange)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10 * guiScale, 0, 55 * guiScale)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.LayoutOrder = toggleOrder
    toggleOrder = toggleOrder + 1
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8 * guiScale)

    local cStroke = Instance.new("UIStroke", container)
    cStroke.Thickness = 1.5 * guiScale
    cStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cStroke.Color = ORANGE_PRIMARY

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.7, 0, 0, 20 * guiScale)
    label.Position = UDim2.new(0, 8 * guiScale, 0, 4 * guiScale)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11 * guiScale
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Size = UDim2.new(0.28, 0, 0, 20 * guiScale)
    valueLabel.Position = UDim2.new(0.72, 0, 0, 4 * guiScale)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(Values[valueKey] or minVal)
    valueLabel.TextColor3 = ORANGE_PRIMARY
    valueLabel.Font = Enum.Font.GothamBlack
    valueLabel.TextSize = 11 * guiScale
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local sliderBg = Instance.new("Frame", container)
    sliderBg.Size = UDim2.new(1, -16 * guiScale, 0, 6 * guiScale)
    sliderBg.Position = UDim2.new(0, 8 * guiScale, 0, 32 * guiScale)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local initVal = Values[valueKey] or minVal
    local initRel = (initVal - minVal) / (maxVal - minVal)

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new(initRel, 0, 1, 0)
    sliderFill.BackgroundColor3 = ORANGE_PRIMARY
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame", sliderBg)
    thumb.Size = UDim2.new(0, 12 * guiScale, 0, 12 * guiScale)
    thumb.Position = UDim2.new(initRel, -6 * guiScale, 0.5, -6 * guiScale)
    thumb.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function updateSlider(relative)
        relative = math.clamp(relative, 0, 1)
        local value = math.floor(minVal + (maxVal - minVal) * relative)
        Values[valueKey] = value
        valueLabel.Text = tostring(value)
        sliderFill.Size = UDim2.new(relative, 0, 1, 0)
        thumb.Position = UDim2.new(relative, -6 * guiScale, 0.5, -6 * guiScale)
        if onChange then onChange(value) end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            local relative = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            updateSlider(relative)
        end
    end)

    return container
end

-- ─── Helper: make a BIND keybind button ───────────────────────────────────────
local function makeKeybindButton(frame, defaultKey, onKeyChanged)
    local listening = false
    local currentKey = defaultKey

    local kbBtn = Instance.new("TextButton", frame)
    kbBtn.Size = UDim2.new(0, 36 * guiScale, 0, 20 * guiScale)
    kbBtn.Position = UDim2.new(1, -92 * guiScale, 0.5, -10 * guiScale)
    kbBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    kbBtn.TextColor3 = ORANGE_PRIMARY
    kbBtn.Font = Enum.Font.GothamBlack
    kbBtn.TextSize = 9 * guiScale
    kbBtn.Text = "BIND"
    kbBtn.BorderSizePixel = 0
    kbBtn.ZIndex = 8
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 4 * guiScale)

    local kbStroke = Instance.new("UIStroke", kbBtn)
    kbStroke.Thickness = 1.5 * guiScale
    kbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    kbStroke.Color = ORANGE_PRIMARY

    kbBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        kbBtn.Text = "..."
        kbBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            conn:Disconnect()
            currentKey = input.KeyCode
            listening = false
            kbBtn.Text = "BIND"
            kbBtn.TextColor3 = ORANGE_PRIMARY
            if onKeyChanged then onKeyChanged(currentKey) end
        end)
    end)

    return kbBtn, function() return listening end, function() return currentKey end
end

-- ═══════════════════════════════════════════════════════════════
-- ─── FEATURE IMPLEMENTATIONS ───────────────────────────────────
-- ═══════════════════════════════════════════════════════════════

local Connections = {}

-- ─── Speed Boost ──────────────────────────────────────────────
local function getMovementDirection()
    local c = Player.Character
    if not c then return Vector3.zero end
    local hum = c:FindFirstChildOfClass("Humanoid")
    return hum and hum.MoveDirection or Vector3.zero
end

local function startSpeedBoost()
    if Connections.speed then return end
    Connections.speed = RunService.Heartbeat:Connect(function()
        if not Features.SpeedBoost then return end
        pcall(function()
            local c = Player.Character
            if not c then return end
            local h = c:FindFirstChild("HumanoidRootPart")
            if not h then return end
            local md = getMovementDirection()
            if md.Magnitude > 0.1 then
                h.AssemblyLinearVelocity = Vector3.new(
                    md.X * Values.BoostSpeed,
                    h.AssemblyLinearVelocity.Y,
                    md.Z * Values.BoostSpeed
                )
            end
        end)
    end)
end

local function stopSpeedBoost()
    if Connections.speed then Connections.speed:Disconnect() Connections.speed = nil end
end

-- ─── Infinite Jump ────────────────────────────────────────────
local InfiniteJump = {
    Enabled    = false,
    JUMP_POWER = 50,
    COOLDOWN   = 0.15,
    lastJump   = 0,
    JumpConn   = nil
}

local function enableInfJump()
    if InfiniteJump.Enabled then return end
    InfiniteJump.Enabled = true
    InfiniteJump.JumpConn = UserInputService.JumpRequest:Connect(function()
        if not InfiniteJump.Enabled then return end
        local character = Player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid and humanoid.FloorMaterial == Enum.Material.Air then
            local now = tick()
            if now - InfiniteJump.lastJump >= InfiniteJump.COOLDOWN then
                InfiniteJump.lastJump = now
                hrp.AssemblyLinearVelocity = Vector3.new(
                    hrp.AssemblyLinearVelocity.X,
                    InfiniteJump.JUMP_POWER,
                    hrp.AssemblyLinearVelocity.Z
                )
            end
        end
    end)
end

local function disableInfJump()
    if not InfiniteJump.Enabled then return end
    InfiniteJump.Enabled = false
    if InfiniteJump.JumpConn then
        InfiniteJump.JumpConn:Disconnect()
        InfiniteJump.JumpConn = nil
    end
end

-- ─── Anti Ragdoll ─────────────────────────────────────────────
local antiRagdollMode = nil
local ragdollConnections = {}
local cachedCharData = {}
local isBoosting = false
local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16

local function arCacheCharacterData()
    local char = Player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    cachedCharData = { character = char, humanoid = hum, root = root }
    return true
end

local function arDisconnectAll()
    for _, conn in ipairs(ragdollConnections) do pcall(function() conn:Disconnect() end) end
    ragdollConnections = {}
end

local function arIsRagdolled()
    if not cachedCharData.humanoid then return false end
    local state = cachedCharData.humanoid:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics]     = true,
        [Enum.HumanoidStateType.Ragdoll]     = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    if ragdollStates[state] then return true end
    local endTime = Player:GetAttribute("RagdollEndTime")
    if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then return true end
    return false
end

local function arForceExitRagdoll()
    if not cachedCharData.humanoid or not cachedCharData.root then return end
    pcall(function() Player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
    for _, d in ipairs(cachedCharData.character:GetDescendants()) do
        if d:IsA("BallSocketConstraint") or
           (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
            d:Destroy()
        end
    end
    if not isBoosting then
        isBoosting = true
        cachedCharData.humanoid.WalkSpeed = BOOST_SPEED
    end
    if cachedCharData.humanoid.Health > 0 then
        cachedCharData.humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    cachedCharData.root.Anchored = false
end

local function arHeartbeatLoop()
    while antiRagdollMode == "v1" do
        task.wait()
        local cur = arIsRagdolled()
        if cur then
            arForceExitRagdoll()
        elseif isBoosting and not cur then
            isBoosting = false
            if cachedCharData.humanoid then cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end
        end
    end
end

local function startAntiRagdoll()
    if antiRagdollMode == "v1" then return end
    if not arCacheCharacterData() then return end
    antiRagdollMode = "v1"
    local camConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and cachedCharData.humanoid then cam.CameraSubject = cachedCharData.humanoid end
    end)
    table.insert(ragdollConnections, camConn)
    local respawnConn = Player.CharacterAdded:Connect(function()
        isBoosting = false
        task.wait(0.5)
        arCacheCharacterData()
    end)
    table.insert(ragdollConnections, respawnConn)
    task.spawn(arHeartbeatLoop)
end

local function stopAntiRagdoll()
    antiRagdollMode = nil
    if isBoosting and cachedCharData.humanoid then cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end
    isBoosting = false
    arDisconnectAll()
    cachedCharData = {}
end

-- ─── Hit Circle (Melee Aimbot) ─────────────────────────────────
local Cebo = { Conn = nil, Circle = nil, Align = nil, Attach = nil }
local meleeAimbotIsOn = false

local function startMeleeAimbot()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    Cebo.Attach = Instance.new("Attachment", hrp)
    Cebo.Align = Instance.new("AlignOrientation", hrp)
    Cebo.Align.Attachment0 = Cebo.Attach
    Cebo.Align.Mode = Enum.OrientationAlignmentMode.OneAttachment
    Cebo.Align.RigidityEnabled = true
    Cebo.Circle = Instance.new("Part")
    Cebo.Circle.Shape = Enum.PartType.Cylinder
    Cebo.Circle.Material = Enum.Material.Neon
    Cebo.Circle.Size = Vector3.new(0.05, 14.5, 14.5)
    Cebo.Circle.Color = Color3.new(1, 0.55, 0)
    Cebo.Circle.CanCollide = false
    Cebo.Circle.Massless = true
    Cebo.Circle.Parent = workspace
    local weld = Instance.new("Weld")
    weld.Part0 = hrp
    weld.Part1 = Cebo.Circle
    weld.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(0, 0, math.rad(90))
    weld.Parent = Cebo.Circle
    Cebo.Conn = RunService.RenderStepped:Connect(function()
        local target, dmin = nil, 7.25
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d <= dmin then target, dmin = p.Character.HumanoidRootPart, d end
            end
        end
        if target then
            char.Humanoid.AutoRotate = false
            Cebo.Align.Enabled = true
            Cebo.Align.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
            local t = char:FindFirstChild("Bat") or char:FindFirstChild("Medusa")
            if t then t:Activate() end
        else
            Cebo.Align.Enabled = false
            char.Humanoid.AutoRotate = true
        end
    end)
end

local function stopMeleeAimbot()
    if Cebo.Conn   then Cebo.Conn:Disconnect()   Cebo.Conn   = nil end
    if Cebo.Circle then Cebo.Circle:Destroy()     Cebo.Circle = nil end
    if Cebo.Align  then Cebo.Align:Destroy()      Cebo.Align  = nil end
    if Cebo.Attach then Cebo.Attach:Destroy()     Cebo.Attach = nil end
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.AutoRotate = true
    end
end

-- ─── Helicopter ───────────────────────────────────────────────
local helicopterIsOn = false
local helicopterSpinBAV = nil

local function applyHelicopterSpeed()
    if helicopterSpinBAV then
        helicopterSpinBAV.AngularVelocity = Vector3.new(0, Values.SpinSpeed, 0)
    end
end

local function startHelicopter()
    local c = Player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if helicopterSpinBAV then helicopterSpinBAV:Destroy() helicopterSpinBAV = nil end
    for _, v in pairs(hrp:GetChildren()) do
        if v.Name == "HelicopterBAV" then v:Destroy() end
    end
    helicopterSpinBAV = Instance.new("BodyAngularVelocity")
    helicopterSpinBAV.Name = "HelicopterBAV"
    helicopterSpinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
    helicopterSpinBAV.AngularVelocity = Vector3.new(0, Values.SpinSpeed, 0)
    helicopterSpinBAV.Parent = hrp
end

local function stopHelicopter()
    if helicopterSpinBAV then helicopterSpinBAV:Destroy() helicopterSpinBAV = nil end
    local c = Player.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "HelicopterBAV" then v:Destroy() end
            end
        end
    end
end

-- ─── Auto Steal ───────────────────────────────────────────────
local isStealing = false
local StealData = {}

local function isMyPlotByName(pn)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(pn)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    local h = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not h then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local np, nd, nn = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then continue end
        for _, pod in ipairs(podiums:GetChildren()) do
            pcall(function()
                local base  = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - h.Position).Magnitude
                    if dist < nd and dist <= AutoStealValues.STEAL_RADIUS then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, ch in ipairs(att:GetChildren()) do
                                if ch:IsA("ProximityPrompt") then
                                    np, nd, nn = ch, dist, pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return np, nd, nn
end

local function executeSteal(prompt, name)
    if isStealing then return end
    if not StealData[prompt] then
        StealData[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(StealData[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(StealData[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = StealData[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealStartTime = tick()
    if ProgressLabel then ProgressLabel.Text = name or "STEALING..." end
    if progressConn then progressConn:Disconnect() end
    progressConn = RunService.Heartbeat:Connect(function()
        if not isStealing then progressConn:Disconnect() return end
        local prog = math.clamp((tick() - stealStartTime) / AutoStealValues.STEAL_DURATION, 0, 1)
        if ProgressBarFill      then ProgressBarFill.Size = UDim2.new(prog, 0, 1, 0) end
        if ProgressPercentLabel then ProgressPercentLabel.Text = math.floor(prog * 100) .. "%" end
    end)
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        task.wait(AutoStealValues.STEAL_DURATION)
        for _, f in ipairs(data.trigger) do task.spawn(f) end
        if progressConn then progressConn:Disconnect() progressConn = nil end
        resetProgressBar()
        data.ready = true
        isStealing = false
    end)
end

local autoStealConn = nil

local function startAutoSteal()
    if autoStealConn then return end
    autoStealConn = RunService.Heartbeat:Connect(function()
        if not Features.AutoSteal or isStealing then return end
        local p, _, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
end

local function stopAutoSteal()
    if autoStealConn then autoStealConn:Disconnect() autoStealConn = nil end
    if progressConn  then progressConn:Disconnect()  progressConn  = nil end
    isStealing = false
    resetProgressBar()
end

-- ─── Spam Bat ─────────────────────────────────────────────────
local lastBatSwing = 0
local BAT_SWING_COOLDOWN = 0.12

local SlapList = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap"
}

local function findBat()
    local c  = Player.Character
    if not c then return nil end
    local bp = Player:FindFirstChildOfClass("Backpack")
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    for _, name in ipairs(SlapList) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    return nil
end

local spamBatConn = nil

local function startSpamBat()
    if spamBatConn then return end
    spamBatConn = RunService.Heartbeat:Connect(function()
        if not Features.SpamBat then return end
        local c = Player.Character
        if not c then return end
        local bat = findBat()
        if not bat then return end
        if bat.Parent ~= c then bat.Parent = c end
        local now = tick()
        if now - lastBatSwing < BAT_SWING_COOLDOWN then return end
        lastBatSwing = now
        pcall(function() bat:Activate() end)
    end)
end

local function stopSpamBat()
    if spamBatConn then spamBatConn:Disconnect() spamBatConn = nil end
end

-- ─── Thief Speed ──────────────────────────────────────────────
local speedWhileStealingConn = nil

local function startSpeedWhileStealing()
    if speedWhileStealingConn then return end
    speedWhileStealingConn = RunService.Heartbeat:Connect(function()
        if not Features.SpeedWhileStealing or not Player:GetAttribute("Stealing") then return end
        local c = Player.Character
        if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local md = hum and hum.MoveDirection or Vector3.zero
        if md.Magnitude > 0.1 then
            h.AssemblyLinearVelocity = Vector3.new(
                md.X * Values.StealingSpeedValue,
                h.AssemblyLinearVelocity.Y,
                md.Z * Values.StealingSpeedValue
            )
        end
    end)
end

local function stopSpeedWhileStealing()
    if speedWhileStealingConn then speedWhileStealingConn:Disconnect() speedWhileStealingConn = nil end
end

-- ─── Unwalk ───────────────────────────────────────────────────
local savedAnimations = {}

local function startUnwalk()
    local c = Player.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim = c:FindFirstChild("Animate")
    if anim then
        savedAnimations.Animate = anim:Clone()
        anim:Destroy()
    end
end

local function stopUnwalk()
    local c = Player.Character
    if c and savedAnimations.Animate then
        savedAnimations.Animate:Clone().Parent = c
        savedAnimations.Animate = nil
    end
end

-- ─── Optimizer ────────────────────────────────────────────────
local function enableOptimizer()
    if getgenv and getgenv().OPTIMIZER_ACTIVE then return end
    if getgenv then getgenv().OPTIMIZER_ACTIVE = true end
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.Brightness = 3
        Lighting.FogEnd = 9e9
    end)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    obj:Destroy()
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.Plastic
                end
            end)
        end
    end)
end

local function disableOptimizer()
    if getgenv then getgenv().OPTIMIZER_ACTIVE = false end
end

-- ─── XRay ────────────────────────────────────────────────────
local originalTransparency = {}

local function enableXRay()
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Anchored and
               (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
                originalTransparency[obj] = obj.LocalTransparencyModifier
                obj.LocalTransparencyModifier = 0.85
            end
        end
    end)
end

local function disableXRay()
    for part, value in pairs(originalTransparency) do
        if part then part.LocalTransparencyModifier = value end
    end
    originalTransparency = {}
end

-- ─── Float ────────────────────────────────────────────────────
local floatConn = nil
local floatKeybind = Enum.KeyCode.F
local floatListening = false
local FLOAT_TARGET_HEIGHT = 10

local function startFloat()
    local c = Player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    local floatOriginY = hrp.Position.Y + FLOAT_TARGET_HEIGHT
    local floatStartTime = tick()
    local floatDescending = false

    floatConn = RunService.Heartbeat:Connect(function()
        if not Features.Float then return end
        local c2 = Player.Character
        if not c2 then return end
        local h = c2:FindFirstChild("HumanoidRootPart")
        if not h then return end
        local hum2 = c2:FindFirstChildOfClass("Humanoid")
        local moveDir = hum2 and hum2.MoveDirection or Vector3.zero
        if tick() - floatStartTime >= 4 then floatDescending = true end
        local currentY = h.Position.Y
        local vertVel
        if floatDescending then
            vertVel = -20
            if currentY <= floatOriginY - FLOAT_TARGET_HEIGHT + 0.5 then
                h.AssemblyLinearVelocity = Vector3.zero
                Features.Float = false
                if floatConn then floatConn:Disconnect() floatConn = nil end
                if _G.stopFloatVisual then _G.stopFloatVisual() end
                return
            end
        else
            local diff = floatOriginY - currentY
            if diff > 0.3 then vertVel = math.clamp(diff * 8, 5, 50)
            elseif diff < -0.3 then vertVel = math.clamp(diff * 8, -50, -5)
            else vertVel = 0 end
        end
        local horizX = moveDir.Magnitude > 0.1 and moveDir.X * Values.BoostSpeed or 0
        local horizZ = moveDir.Magnitude > 0.1 and moveDir.Z * Values.BoostSpeed or 0
        h.AssemblyLinearVelocity = Vector3.new(horizX, vertVel, horizZ)
    end)
end

local function stopFloat()
    if floatConn then floatConn:Disconnect() floatConn = nil end
    local c = Player.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
    end
end

-- ─── Steal Paths ──────────────────────────────────────────────
local pathActive = false
local lastFlatVel = Vector3.zero
local PATH_VELOCITY_SPEED  = 59.2
local PATH_SECOND_SPEED    = 29.6
local PATH_BASE_STOP       = 1.35
local PATH_MIN_STOP        = 0.65
local PATH_NEXT_POINT_BIAS = 0.45
local PATH_SMOOTH_FACTOR   = 0.12

local stealPath1 = {
    {pos = Vector3.new(-470.6, -5.9, 34.4)},
    {pos = Vector3.new(-484.2, -3.9, 21.4)},
    {pos = Vector3.new(-475.6, -5.8, 29.3)},
    {pos = Vector3.new(-473.4, -5.9, 111)}
}

local stealPath2 = {
    {pos = Vector3.new(-474.7, -5.9, 91.0)},
    {pos = Vector3.new(-483.4, -3.9, 97.3)},
    {pos = Vector3.new(-474.7, -5.9, 91.0)},
    {pos = Vector3.new(-476.1, -5.5, 25.4)}
}

local function pathMoveToPoint(hrp, current, nextPoint, speed)
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not pathActive then conn:Disconnect() hrp.AssemblyLinearVelocity = Vector3.zero return end
        local pos = hrp.Position
        local target = Vector3.new(current.X, pos.Y, current.Z)
        local dir = target - pos
        local dist = dir.Magnitude
        local stopDist = math.clamp(PATH_BASE_STOP - dist * 0.04, PATH_MIN_STOP, PATH_BASE_STOP)
        if dist <= stopDist then conn:Disconnect() hrp.AssemblyLinearVelocity = Vector3.zero return end
        local moveDir = dir.Unit
        if nextPoint then
            local nextDir = (Vector3.new(nextPoint.X, pos.Y, nextPoint.Z) - pos).Unit
            moveDir = (moveDir + nextDir * PATH_NEXT_POINT_BIAS).Unit
        end
        if lastFlatVel.Magnitude > 0.1 then
            moveDir = (moveDir * (1 - PATH_SMOOTH_FACTOR) + lastFlatVel.Unit * PATH_SMOOTH_FACTOR).Unit
        end
        local vel = Vector3.new(moveDir.X * speed, hrp.AssemblyLinearVelocity.Y, moveDir.Z * speed)
        hrp.AssemblyLinearVelocity = vel
        lastFlatVel = Vector3.new(vel.X, 0, vel.Z)
    end)
    while pathActive and
        (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(current.X, 0, current.Z)).Magnitude > PATH_BASE_STOP do
        RunService.Heartbeat:Wait()
    end
end

local function runStealPath(path)
    local hrp = (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
    for i, p in ipairs(path) do
        if not pathActive then return end
        local speed = i > 2 and PATH_SECOND_SPEED or PATH_VELOCITY_SPEED
        local nextP = path[i + 1] and path[i + 1].pos
        pathMoveToPoint(hrp, p.pos, nextP, speed)
        if i == 2 then task.wait(0.2) else task.wait(0.01) end
    end
end

local function startStealPath(path)
    pathActive = true
    task.spawn(function()
        while pathActive do
            runStealPath(path)
            task.wait(0.1)
        end
    end)
end

local function stopStealPath()
    pathActive = false
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
end

-- ═══════════════════════════════════════════════════════════════
-- ─── BUILD UI TOGGLES ──────────────────────────────────────────
-- ═══════════════════════════════════════════════════════════════

-- ──────────────── LEFT COLUMN (Combat⚔️) ────────────────────

-- Speed Boost [E]
do
    local speedKeybind = Enum.KeyCode.E
    local btn, setVisual, getState = makeToggleHeader(leftScroll, "Speed Boost  [E]")
    local frame = btn.Parent
    local lbl = frame:FindFirstChildOfClass("TextLabel")

    local _, getListening, getKey = makeKeybindButton(frame, speedKeybind, function(k)
        speedKeybind = k
        if lbl then lbl.Text = "Speed Boost  [" .. k.Name .. "]" end
    end)

    local function toggle()
        if getListening() then return end
        local on = not getState()
        setVisual(on)
        Features.SpeedBoost = on
        if on then startSpeedBoost() else stopSpeedBoost() end
    end

    btn.MouseButton1Click:Connect(toggle)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if not getListening() and input.KeyCode == speedKeybind then toggle() end
    end)
end

createSlider(leftScroll, "Speed Value", 1, 70, "BoostSpeed")

-- Infinite Jump
do
    local btn, setVisual, getState = makeToggleHeader(leftScroll, "Infinite Jump")
    btn.MouseButton1Click:Connect(function()
        local on = not getState()
        setVisual(on)
        if on then enableInfJump() else disableInfJump() end
    end)
end

-- Anti Ragdoll
do
    local btn, setVisual, getState = makeToggleHeader(leftScroll, "Anti Ragdoll")
    btn.MouseButton1Click:Connect(function()
        local on = not getState()
        setVisual(on)
        Features.AntiRagdoll = on
        if on then startAntiRagdoll() else stopAntiRagdoll() end
    end)
end

-- Hit Circle
do
    local btn, setVisual, getState = makeToggleHeader(leftScroll, "Hit Circle")
    btn.MouseButton1Click:Connect(function()
        meleeAimbotIsOn = not getState()
        setVisual(meleeAimbotIsOn)
        if meleeAimbotIsOn then startMeleeAimbot() else stopMeleeAimbot() end
    end)
end

-- Helicopter
do
    local btn, setVisual, getState = makeToggleHeader(leftScroll, "Helicopter")
    btn.MouseButton1Click:Connect(function()
        helicopterIsOn = not getState()
        setVisual(helicopterIsOn)
        if helicopterIsOn then startHelicopter() else stopHelicopter() end
    end)
end

createSlider(leftScroll, "Helicopter Speed", 5, 50, "SpinSpeed", function(v)
    Values.SpinSpeed = v
    applyHelicopterSpeed()
end)

-- Auto Steal
do
    local btn, setVisual, getState = makeToggleHeader(leftScroll, "Auto Steal")
    btn.MouseButton1Click:Connect(function()
        local on = not getState()
        setVisual(on)
        Features.AutoSteal = on
        if on then startAutoSteal() else stopAutoSteal() end
    end)
end

-- ──────────────── RIGHT COLUMN (Movements🚀) ─────────────────

-- Bat Fucker
do
    local btn, setVisual, getState = makeToggleHeader(rightScroll, "Bat Fucker")
    btn.MouseButton1Click:Connect(function()
        local on = not getState()
        setVisual(on)
        Features.SpamBat = on
        if on then startSpamBat() else stopSpamBat() end
    end)
end

-- Thief Speed
do
    local btn, setVisual, getState = makeToggleHeader(rightScroll, "Thief Speed")
    btn.MouseButton1Click:Connect(function()
        local on = not getState()
        setVisual(on)
        Features.SpeedWhileStealing = on
        if on then startSpeedWhileStealing() else stopSpeedWhileStealing() end
    end)
end

createSlider(rightScroll, "Steal Speed", 10, 50, "StealingSpeedValue")

-- Unwalk
do
    local btn, setVisual, getState = makeToggleHeader(rightScroll, "Unwalk")
    btn.MouseButton1Click:Connect(function()
        local on = not getState()
        setVisual(on)
        Features.Unwalk = on
        if on then startUnwalk() else stopUnwalk() end
    end)
end

-- Optimizer + XRay (combined)
do
    local btn, setVisual, getState = makeToggleHeader(rightScroll, "Optimizer + XRay")
    btn.MouseButton1Click:Connect(function()
        local on = not getState()
        setVisual(on)
        Features.OptimizerXRay = on
        if on then
            enableOptimizer()
            enableXRay()
        else
            disableOptimizer()
            disableXRay()
        end
    end)
end

-- Float [F]
do
    local btn, setVisual, getState = makeToggleHeader(rightScroll, "Float  [F]")
    local frame = btn.Parent
    local lbl = frame:FindFirstChildOfClass("TextLabel")

    local _, getListening, getKey = makeKeybindButton(frame, floatKeybind, function(k)
        floatKeybind = k
        if lbl then lbl.Text = "Float  [" .. k.Name .. "]" end
    end)

    _G.stopFloatVisual = function() setVisual(false) end

    local function toggleFloat()
        if getListening() then return end
        local on = not getState()
        setVisual(on)
        Features.Float = on
        if on then startFloat() else stopFloat() end
    end

    btn.MouseButton1Click:Connect(toggleFloat)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if not getListening() and input.KeyCode == floatKeybind then toggleFloat() end
    end)
end

-- ─── Auto Steal Path Buttons ──────────────────────────────────
do
    local rKey = Enum.KeyCode.E
    local lKey = Enum.KeyCode.Q
    local rOn, lOn = false, false
    local rListening, lListening = false, false

    -- ── Shared popup creator ──
    local function makeStealPopup(title)
        local popup = Instance.new("Frame", sg)
        popup.Size = UDim2.new(0, 200 * guiScale, 0, 130 * guiScale)
        popup.Position = UDim2.new(0.5, -100 * guiScale, 0.5, -65 * guiScale)
        popup.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        popup.BorderSizePixel = 0
        popup.ZIndex = 30
        popup.Visible = false
        popup.Active = true
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 10 * guiScale)

        local stroke = Instance.new("UIStroke", popup)
        stroke.Thickness = 2 * guiScale
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = ORANGE_PRIMARY

        -- Header bar
        local hdr = Instance.new("Frame", popup)
        hdr.Size = UDim2.new(1, 0, 0, 28 * guiScale)
        hdr.BackgroundColor3 = ORANGE_PRIMARY
        hdr.BorderSizePixel = 0
        hdr.ZIndex = 31
        Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 8 * guiScale)
        local hdrFill = Instance.new("Frame", hdr)
        hdrFill.Size = UDim2.new(1, 0, 0.5, 0)
        hdrFill.Position = UDim2.new(0, 0, 0.5, 0)
        hdrFill.BackgroundColor3 = ORANGE_PRIMARY
        hdrFill.BorderSizePixel = 0
        hdrFill.ZIndex = 30

        local hdrTitle = Instance.new("TextLabel", hdr)
        hdrTitle.Size = UDim2.new(1, -36 * guiScale, 1, 0)
        hdrTitle.Position = UDim2.new(0, 8 * guiScale, 0, 0)
        hdrTitle.BackgroundTransparency = 1
        hdrTitle.Text = title
        hdrTitle.Font = Enum.Font.GothamBlack
        hdrTitle.TextSize = 12 * guiScale
        hdrTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        hdrTitle.TextXAlignment = Enum.TextXAlignment.Left
        hdrTitle.ZIndex = 32

        -- Close button on popup
        local closeP = Instance.new("TextButton", hdr)
        closeP.Size = UDim2.new(0, 20 * guiScale, 0, 20 * guiScale)
        closeP.Position = UDim2.new(1, -24 * guiScale, 0.5, -10 * guiScale)
        closeP.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        closeP.Text = "X"
        closeP.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeP.Font = Enum.Font.GothamBlack
        closeP.TextSize = 10 * guiScale
        closeP.BorderSizePixel = 0
        closeP.ZIndex = 33
        Instance.new("UICorner", closeP).CornerRadius = UDim.new(0, 4 * guiScale)

        -- Toggle switch row
        local toggleRow = Instance.new("Frame", popup)
        toggleRow.Size = UDim2.new(1, -16 * guiScale, 0, 36 * guiScale)
        toggleRow.Position = UDim2.new(0, 8 * guiScale, 0, 34 * guiScale)
        toggleRow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        toggleRow.BorderSizePixel = 0
        toggleRow.ZIndex = 31
        Instance.new("UICorner", toggleRow).CornerRadius = UDim.new(0, 6 * guiScale)

        local tLabel = Instance.new("TextLabel", toggleRow)
        tLabel.Size = UDim2.new(0.55, 0, 1, 0)
        tLabel.Position = UDim2.new(0, 8 * guiScale, 0, 0)
        tLabel.BackgroundTransparency = 1
        tLabel.Text = "Enable"
        tLabel.Font = Enum.Font.GothamBlack
        tLabel.TextSize = 11 * guiScale
        tLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.ZIndex = 32

        local tBg = Instance.new("Frame", toggleRow)
        tBg.Size = UDim2.new(0, 44 * guiScale, 0, 22 * guiScale)
        tBg.Position = UDim2.new(1, -50 * guiScale, 0.5, -11 * guiScale)
        tBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tBg.ZIndex = 32
        Instance.new("UICorner", tBg).CornerRadius = UDim.new(1, 0)

        local tCircle = Instance.new("Frame", tBg)
        tCircle.Size = UDim2.new(0, 18 * guiScale, 0, 18 * guiScale)
        tCircle.Position = UDim2.new(0, 2 * guiScale, 0.5, -9 * guiScale)
        tCircle.BackgroundColor3 = Color3.new(1,1,1)
        tCircle.ZIndex = 33
        Instance.new("UICorner", tCircle).CornerRadius = UDim.new(1, 0)

        local tBtn = Instance.new("TextButton", toggleRow)
        tBtn.Size = UDim2.new(1, 0, 1, 0)
        tBtn.BackgroundTransparency = 1
        tBtn.Text = ""
        tBtn.ZIndex = 34

        -- Keybind row
        local bindRow = Instance.new("Frame", popup)
        bindRow.Size = UDim2.new(1, -16 * guiScale, 0, 36 * guiScale)
        bindRow.Position = UDim2.new(0, 8 * guiScale, 0, 76 * guiScale)
        bindRow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        bindRow.BorderSizePixel = 0
        bindRow.ZIndex = 31
        Instance.new("UICorner", bindRow).CornerRadius = UDim.new(0, 6 * guiScale)

        local bLabel = Instance.new("TextLabel", bindRow)
        bLabel.Size = UDim2.new(0.5, 0, 1, 0)
        bLabel.Position = UDim2.new(0, 8 * guiScale, 0, 0)
        bLabel.BackgroundTransparency = 1
        bLabel.Text = "Keybind"
        bLabel.Font = Enum.Font.GothamBlack
        bLabel.TextSize = 11 * guiScale
        bLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        bLabel.TextXAlignment = Enum.TextXAlignment.Left
        bLabel.ZIndex = 32

        local bindBtn = Instance.new("TextButton", bindRow)
        bindBtn.Size = UDim2.new(0, 50 * guiScale, 0, 22 * guiScale)
        bindBtn.Position = UDim2.new(1, -56 * guiScale, 0.5, -11 * guiScale)
        bindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        bindBtn.TextColor3 = ORANGE_PRIMARY
        bindBtn.Font = Enum.Font.GothamBlack
        bindBtn.TextSize = 10 * guiScale
        bindBtn.Text = "BIND"
        bindBtn.BorderSizePixel = 0
        bindBtn.ZIndex = 33
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4 * guiScale)
        local bStroke = Instance.new("UIStroke", bindBtn)
        bStroke.Thickness = 1.5 * guiScale
        bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        bStroke.Color = ORANGE_PRIMARY

        -- Draggable popup
        do
            local dragging = false
            local dragStart, startPos
            hdr.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = popup.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then dragging = false end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    popup.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end

        closeP.MouseButton1Click:Connect(function()
            TweenService:Create(popup, TweenInfo.new(0.15), {Size = UDim2.new(0, 200*guiScale, 0, 0)}):Play()
            task.wait(0.15)
            popup.Visible = false
            popup.Size = UDim2.new(0, 200*guiScale, 0, 130*guiScale)
        end)

        return popup, tBtn, tBg, tCircle, bindBtn, bLabel
    end

    -- ── Build Right Steal popup ──
    local rPopup, rToggleBtn, rToggleBg, rToggleCircle, rBindBtn, rBindLabel =
        makeStealPopup("➡️ Auto Right Steal")

    -- ── Build Left Steal popup ──
    local lPopup, lToggleBtn, lToggleBg, lToggleCircle, lBindBtn, lBindLabel =
        makeStealPopup("⬅️ Auto Left Steal")

    -- ── Visual helpers ──
    local function setRightVisual(on)
        rOn = on
        if on then
            TweenService:Create(rToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = ORANGE_PRIMARY}):Play()
            TweenService:Create(rToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1,-20*guiScale,0.5,-9*guiScale)}):Play()
        else
            TweenService:Create(rToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
            TweenService:Create(rToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0,2*guiScale,0.5,-9*guiScale)}):Play()
        end
    end

    local function setLeftVisual(on)
        lOn = on
        if on then
            TweenService:Create(lToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = ORANGE_PRIMARY}):Play()
            TweenService:Create(lToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1,-20*guiScale,0.5,-9*guiScale)}):Play()
        else
            TweenService:Create(lToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
            TweenService:Create(lToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0,2*guiScale,0.5,-9*guiScale)}):Play()
        end
    end

    -- ── Toggle logic ──
    local function toggleRight()
        if rListening then return end
        local on = not rOn
        setRightVisual(on)
        setLeftVisual(false)
        stopStealPath()
        if on then startStealPath(stealPath1) end
    end

    local function toggleLeft()
        if lListening then return end
        local on = not lOn
        setLeftVisual(on)
        setRightVisual(false)
        stopStealPath()
        if on then startStealPath(stealPath2) end
    end

    rToggleBtn.MouseButton1Click:Connect(toggleRight)
    lToggleBtn.MouseButton1Click:Connect(toggleLeft)

    -- ── Bind logic ──
    rBindBtn.MouseButton1Click:Connect(function()
        if rListening then return end
        rListening = true
        rBindBtn.Text = "..."
        rBindBtn.TextColor3 = Color3.fromRGB(255,255,255)
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            conn:Disconnect()
            rKey = input.KeyCode
            rListening = false
            rBindBtn.Text = rKey.Name
            rBindBtn.TextColor3 = ORANGE_PRIMARY
        end)
    end)

    lBindBtn.MouseButton1Click:Connect(function()
        if lListening then return end
        lListening = true
        lBindBtn.Text = "..."
        lBindBtn.TextColor3 = Color3.fromRGB(255,255,255)
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            conn:Disconnect()
            lKey = input.KeyCode
            lListening = false
            lBindBtn.Text = lKey.Name
            lBindBtn.TextColor3 = ORANGE_PRIMARY
        end)
    end)

    -- ── Global keybind listeners ──
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if not rListening and input.KeyCode == rKey then toggleRight() end
        if not lListening and input.KeyCode == lKey then toggleLeft() end
    end)

    -- ── Two side-by-side buttons in the scroll ──
    local buttonRow = Instance.new("Frame", rightScroll)
    buttonRow.Size = UDim2.new(1, -10 * guiScale, 0, 38 * guiScale)
    buttonRow.BackgroundTransparency = 1
    buttonRow.BorderSizePixel = 0
    buttonRow.LayoutOrder = toggleOrder
    toggleOrder = toggleOrder + 1

    local autoRightBtn = Instance.new("TextButton", buttonRow)
    autoRightBtn.Size = UDim2.new(0.48, 0, 1, 0)
    autoRightBtn.Position = UDim2.new(0, 0, 0, 0)
    autoRightBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    autoRightBtn.Text = "➡️ Auto Right"
    autoRightBtn.TextColor3 = ORANGE_PRIMARY
    autoRightBtn.Font = Enum.Font.GothamBlack
    autoRightBtn.TextSize = 11 * guiScale
    autoRightBtn.BorderSizePixel = 0
    autoRightBtn.ZIndex = 4
    Instance.new("UICorner", autoRightBtn).CornerRadius = UDim.new(0, 8 * guiScale)
    local arStroke = Instance.new("UIStroke", autoRightBtn)
    arStroke.Thickness = 1.5 * guiScale
    arStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    arStroke.Color = ORANGE_PRIMARY

    local autoLeftBtn = Instance.new("TextButton", buttonRow)
    autoLeftBtn.Size = UDim2.new(0.48, 0, 1, 0)
    autoLeftBtn.Position = UDim2.new(0.52, 0, 0, 0)
    autoLeftBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    autoLeftBtn.Text = "⬅️ Auto Left"
    autoLeftBtn.TextColor3 = ORANGE_PRIMARY
    autoLeftBtn.Font = Enum.Font.GothamBlack
    autoLeftBtn.TextSize = 11 * guiScale
    autoLeftBtn.BorderSizePixel = 0
    autoLeftBtn.ZIndex = 4
    Instance.new("UICorner", autoLeftBtn).CornerRadius = UDim.new(0, 8 * guiScale)
    local alStroke = Instance.new("UIStroke", autoLeftBtn)
    alStroke.Thickness = 1.5 * guiScale
    alStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    alStroke.Color = ORANGE_PRIMARY

    -- Open/close popups on button click
    local function openPopup(popup, anchorBtn)
        -- Position popup near the button in screen space
        local absPos = anchorBtn.AbsolutePosition
        local absSize = anchorBtn.AbsoluteSize
        popup.Position = UDim2.new(0, absPos.X, 0, absPos.Y - 140 * guiScale)
        popup.Size = UDim2.new(0, 200*guiScale, 0, 0)
        popup.Visible = true
        TweenService:Create(popup, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 200*guiScale, 0, 130*guiScale)}):Play()
    end

    autoRightBtn.MouseButton1Click:Connect(function()
        if rPopup.Visible then
            TweenService:Create(rPopup, TweenInfo.new(0.15), {Size = UDim2.new(0, 200*guiScale, 0, 0)}):Play()
            task.wait(0.15)
            rPopup.Visible = false
            rPopup.Size = UDim2.new(0, 200*guiScale, 0, 130*guiScale)
        else
            lPopup.Visible = false
            openPopup(rPopup, autoRightBtn)
        end
    end)

    autoLeftBtn.MouseButton1Click:Connect(function()
        if lPopup.Visible then
            TweenService:Create(lPopup, TweenInfo.new(0.15), {Size = UDim2.new(0, 200*guiScale, 0, 0)}):Play()
            task.wait(0.15)
            lPopup.Visible = false
            lPopup.Size = UDim2.new(0, 200*guiScale, 0, 130*guiScale)
        else
            rPopup.Visible = false
            openPopup(lPopup, autoLeftBtn)
        end
    end)

    -- Hover effects
    autoRightBtn.MouseEnter:Connect(function()
        TweenService:Create(autoRightBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
    end)
    autoRightBtn.MouseLeave:Connect(function()
        TweenService:Create(autoRightBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
    end)
    autoLeftBtn.MouseEnter:Connect(function()
        TweenService:Create(autoLeftBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
    end)
    autoLeftBtn.MouseLeave:Connect(function()
        TweenService:Create(autoLeftBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
    end)
end

-- ─── Toggle UI with U ─────────────────────────────────────────────────────────
local visible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.U then
        visible = not visible
        main.Visible = visible
    end
end)
