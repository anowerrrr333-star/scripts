local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local cfg = HttpService:JSONDecode('{"title": "@kurtis_scripts", "toggleName": "Destroy VIP Walls", "target": "VIPWalls"}')
local savedInstance = nil
local state = false

if CoreGui:FindFirstChild("ETFB_Compact") then
    CoreGui.ETFB_Compact:Destroy()
end

local Screen = Instance.new("ScreenGui")
Screen.Name = "ETFB_Compact"
Screen.ResetOnSpawn = false
Screen.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 80) 
Main.Position = UDim2.new(0.5, -110, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = Screen

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 50)
MainStroke.Thickness = 1.6
MainStroke.Parent = Main

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = Main

local TopContainer = Instance.new("Frame")
TopContainer.Size = UDim2.new(1, 0, 0, 24)
TopContainer.BackgroundTransparency = 1
TopContainer.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = cfg.title
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopContainer

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -24, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "x"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 13
CloseBtn.Parent = TopContainer

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -32)
Content.Position = UDim2.new(0, 8, 0, 28)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1, 0, 1, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Toggle.AutoButtonColor = false
Toggle.Text = ""
Toggle.Parent = Content

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 4)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(55, 55, 60)
ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleStroke.Thickness = 1
ToggleStroke.Parent = Toggle

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(1, -40, 1, 0)
ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = cfg.toggleName
ToggleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ToggleLabel.Font = Enum.Font.GothamSemibold
ToggleLabel.TextSize = 12
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = Toggle

local Switch = Instance.new("Frame")
Switch.Size = UDim2.new(0, 28, 0, 14)
Switch.AnchorPoint = Vector2.new(1, 0.5)
Switch.Position = UDim2.new(1, -10, 0.5, 0)
Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Switch.Parent = Toggle

local SwitchCorner = Instance.new("UICorner")
SwitchCorner.CornerRadius = UDim.new(1, 0)
SwitchCorner.Parent = Switch

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 10, 0, 10)
Dot.AnchorPoint = Vector2.new(0, 0.5)
Dot.Position = UDim2.new(0, 2, 0.5, 0)
Dot.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
Dot.Parent = Switch

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = Dot

local function ToggleLogic()
    state = not state
    
    local endColor = state and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(60, 60, 60)
    local endPos = state and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    local txtColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)

    TweenService:Create(Switch, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = endColor}):Play()
    TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = endPos}):Play()
    TweenService:Create(ToggleLabel, TweenInfo.new(0.2), {TextColor3 = txtColor}):Play()

    if state then
        local t = Workspace:FindFirstChild(cfg.target)
        if t then
            savedInstance = t:Clone()
            t:Destroy()
        end
    else
        if savedInstance and not Workspace:FindFirstChild(cfg.target) then
            savedInstance.Parent = Workspace
            savedInstance = nil
        end
    end
end

Toggle.MouseButton1Click:Connect(ToggleLogic)

CloseBtn.MouseButton1Click:Connect(function()
    Screen:Destroy()
end)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
end)
--penis tme/scriptmausrb
