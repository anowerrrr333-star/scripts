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


local t1 = {}
local t2 = {}
local v3 = unpack or table.unpack
t2.value1 = game:GetService("Players")
t2.value2 = game:GetService("TweenService")
t2.value3 = game:GetService("UserInputService")
t2.value4 = game:GetService("RunService")
t2.value5 = game:GetService("Lighting")
t2.value6 = game:GetService("HttpService")
t2.value7 = t2.value1.LocalPlayer
t2.value8 = {}
t2.value8.introSoundEnabled = true
t2.value8.introSongChoice = 3
t2.value8.introGUIEnabled = true
if isfile and isfile("CherryConfig.json") then
  function t1.value2()
    local value6 = t2.value6
    local t3 = { readfile("CherryConfig.json") }

    return value6:JSONDecode(v3(t3))
  end

  local ok, result = pcall(t1.value2)

  t1.value4 = ok
  t1.value1 = result

  if t1.value4 and type(t1.value1) == "table" then
    if t1.value1.introSoundEnabled ~= nil then
      local value8 = t2.value8

      t1.value3 = t1.value1.introSoundEnabled
      value8.introSoundEnabled = t1.value3
    end

    if t1.value1.introSongChoice then
      local value8 = t2.value8

      t1.value3 = t1.value1.introSongChoice
      value8.introSongChoice = t1.value3
    end

    if t1.value1.introGUIEnabled ~= nil then
      local value8 = t2.value8

      t1.value3 = t1.value1.introGUIEnabled
      value8.introGUIEnabled = t1.value3
    end
  end
end
t1.value4 = Color3.fromRGB(232, 52, 68)
t2.value9 = t1.value4
t1.value1 = Color3.fromRGB(180, 40, 50)
t2.value10 = t1.value1
t1.value2 = Color3.fromRGB(14, 4, 6)
t2.value11 = t1.value2
t1.value3 = Color3.fromRGB(24, 10, 12)
t2.value12 = Color3.fromRGB(30, 12, 16)

local color3 = Color3.fromRGB(40, 16, 20)

t2.value13 = Color3.fromRGB(40, 12, 18)
t2.value14 = Color3.fromRGB(8, 2, 4)
t2.value15 = Color3.fromRGB(255, 220, 220)
t2.value16 = Color3.fromRGB(180, 120, 130)

local color3_2 = Color3.fromRGB(255, 80, 80)
local color3_3 = Color3.fromRGB(255, 255, 255)

CHERRY_ACCENT = t2.value9
UI_ACCENT = t2.value9
UI_ACCENT_DIM = t2.value10
UI_BG_DARK = t2.value11
UI_ROW_BG = t1.value3
UI_BTN_BG = t2.value12
UI_TOGGLE_OFF = color3
UI_TOGGLE_KNOB = Color3.fromRGB(200, 160, 160)
UI_KNOB_ON = Color3.fromRGB(255, 255, 255)
UI_TEXT_PRIMARY = t2.value15
UI_TEXT_WHITE = color3_3
UI_TEXT_DIM = t2.value16
UI_TEXT_SECTION = color3_2
UI_CARD_STROKE = t2.value10
UI_GRAD_TOP = t2.value13
UI_GRAD_BOT = t2.value14
t2.value8.CANDY_SKY_TAG = "MoveeSkyTheme"
t2.value8.currentSkyTheme = "Night"
local value8 = t2.value8
local t4 = {
kind = "off"
}
local t5 = {
stars = 4000,
moon = 18,
sun = 0,
moonTex = true
}
local t6 = {
clock = 22,
brightness = 2,
ambient = {
110,
100,
130
},
outAmb = {
120,
110,
140
},
sky = t5,
atm = {
dens = 0.45,
color = {
120,
60,
180
},
decay = {
60,
20,
100
},
glare = 0.5,
haze = 1.2
}
}
local t7 = {
dens = 0.55,
color = {
255,
80,
200
},
decay = {
255,
20,
150
},
glare = 2.5,
haze = 3
}
local t8 = {
clock = 14,
brightness = 3,
ambient = {
150,
120,
150
},
outAmb = {
160,
130,
150
},
atm = t7,
clouds = {
cover = 0.7,
dens = 0.7,
color = {
255,
240,
250
}
}
}
local t9 = {
stars = 0,
sun = 25,
moon = 0
}
local t10 = {
dens = 0.5,
color = {
255,
130,
60
},
decay = {
255,
80,
30
},
glare = 2,
haze = 2.5
}
local t11 = {
clock = 17.2,
brightness = 2.5,
ambient = {
170,
120,
100
},
outAmb = {
180,
130,
110
},
sky = t9,
atm = t10,
clouds = {
cover = 0.55,
dens = 0.55,
color = {
255,
200,
140
}
}
}
local t12 = {
stars = 10000,
moon = 30,
sun = 0
}
local t13 = {
clock = 0,
brightness = 1.5,
ambient = {
70,
60,
100
},
outAmb = {
80,
70,
110
},
sky = t12,
atm = {
dens = 0.15,
color = {
40,
20,
80
},
decay = {
20,
10,
50
},
glare = 0.3,
haze = 0.5
}
}
local t14 = {
stars = 2000,
moon = 12
}
local t15 = {
dens = 0.4,
color = {
0,
200,
255
},
decay = {
150,
0,
255
},
glare = 2,
haze = 2
}
local t16 = {
clock = 21,
brightness = 2.2,
ambient = {
90,
130,
170
},
outAmb = {
100,
140,
180
},
sky = t14,
atm = t15,
clouds = {
cover = 0.4,
dens = 0.6,
color = {
100,
200,
255
}
}
}
local t17 = {
sun = 8
}
local t18 = {
dens = 0.3,
color = {
255,
200,
220
},
decay = {
255,
170,
200
},
glare = 1,
haze = 1.5
}
local t19 = {
clock = 11,
brightness = 3.5,
ambient = {
170,
150,
160
},
outAmb = {
180,
160,
170
},
sky = t17,
atm = t18,
clouds = {
cover = 0.6,
dens = 0.4,
color = {
255,
250,
252
}
}
}
local t20 = {
stars = 5000,
moon = 22,
sun = 0,
moonTex = true
}
local t21 = {
dens = 0.5,
color = {
255,
80,
180
},
decay = {
140,
30,
100
},
glare = 0.7,
haze = 1.4
}
local t22 = {
clock = 23,
brightness = 2.2,
ambient = {
120,
60,
110
},
outAmb = {
140,
70,
120
},
sky = t20,
atm = t21,
clouds = {
cover = 0.3,
dens = 0.5,
color = {
180,
90,
150
}
}
}
local t23 = {
stars = 1500,
moon = 28,
sun = 0,
moonTex = true
}
local t24 = {
dens = 0.6,
color = {
220,
30,
30
},
decay = {
120,
10,
10
},
glare = 1.4,
haze = 2
}
local t25 = {
clock = 22.5,
brightness = 1.6,
ambient = {
130,
40,
40
},
outAmb = {
150,
50,
50
},
sky = t23,
atm = t24,
clouds = {
cover = 0.5,
dens = 0.7,
color = {
120,
30,
30
}
}
}
local t26 = {
sun = 18,
moon = 0,
stars = 0
}
local t27 = {
dens = 0.4,
color = {
80,
200,
140
},
decay = {
40,
150,
90
},
glare = 1.8,
haze = 2.2
}
local t28 = {
clock = 6.5,
brightness = 2.8,
ambient = {
130,
170,
140
},
outAmb = {
140,
180,
150
},
sky = t26,
atm = t27,
clouds = {
cover = 0.5,
dens = 0.5,
color = {
200,
255,
220
}
}
}
local t29 = {
stars = 200,
sun = 12,
moon = 0
}
local t30 = {
dens = 0.75,
color = {
255,
60,
0
},
decay = {
180,
20,
0
},
glare = 3,
haze = 3.5
}
local t31 = {
clock = 19,
brightness = 2,
ambient = {
180,
80,
40
},
outAmb = {
200,
90,
50
},
sky = t29,
atm = t30,
clouds = {
cover = 0.8,
dens = 0.9,
color = {
120,
40,
20
}
}
}
local t32 = {
sun = 10,
stars = 0,
moon = 0
}
local t33 = {
dens = 0.3,
color = {
180,
220,
255
},
decay = {
140,
200,
240
},
glare = 1.5,
haze = 1.8
}
local t34 = {
clock = 9,
brightness = 3.2,
ambient = {
200,
220,
235
},
outAmb = {
210,
230,
245
},
sky = t32,
atm = t33,
clouds = {
cover = 0.7,
dens = 0.6,
color = {
250,
253,
255
}
}
}
local t35 = {
stars = 6000,
moon = 24,
sun = 0,
moonTex = true
}
local t36 = {
clock = 1.5,
brightness = 1.7,
ambient = {
60,
90,
130
},
outAmb = {
70,
100,
140
},
sky = t35,
atm = {
dens = 0.5,
color = {
20,
60,
140
},
decay = {
10,
30,
90
},
glare = 0.6,
haze = 1.5
}
}
local t37 = {
stars = 1000,
moon = 14
}
local t38 = {
dens = 0.45,
color = {
255,
100,
220
},
decay = {
120,
60,
255
},
glare = 2.2,
haze = 2.4
}
local t39 = {
clock = 19.5,
brightness = 2.4,
ambient = {
180,
120,
200
},
outAmb = {
190,
130,
210
},
sky = t37,
atm = t38,
clouds = {
cover = 0.55,
dens = 0.55,
color = {
200,
150,
255
}
}
}
local t40 = {
dens = 0.55,
color = {
100,
220,
40
},
decay = {
60,
150,
20
},
glare = 1.8,
haze = 2.6
}
local t41 = {
clock = 13,
brightness = 2.5,
ambient = {
140,
180,
80
},
outAmb = {
150,
190,
90
},
atm = t40,
clouds = {
cover = 0.65,
dens = 0.7,
color = {
180,
255,
120
}
}
}
local t42 = {
stars = 3500,
sun = 22,
moon = 0
}
local t43 = {
clock = 12,
brightness = 0.9,
ambient = {
50,
40,
60
},
outAmb = {
60,
50,
70
},
sky = t42,
atm = {
dens = 0.5,
color = {
255,
140,
40
},
decay = {
30,
20,
40
},
glare = 2.8,
haze = 1.8
}
}
local t44 = {
stars = 100,
sun = 30,
moon = 0
}
local t45 = {
dens = 0.85,
color = {
255,
30,
0
},
decay = {
120,
0,
0
},
glare = 3.5,
haze = 4
}
local t46 = {
clock = 18,
brightness = 1.8,
ambient = {
200,
60,
30
},
outAmb = {
220,
70,
40
},
sky = t44,
atm = t45,
clouds = {
cover = 0.95,
dens = 0.95,
color = {
80,
20,
10
}
}
}
local t47 = {
sun = 16,
moon = 0,
stars = 0
}
local t48 = {
dens = 0.25,
color = {
255,
250,
220
},
decay = {
255,
240,
200
},
glare = 3,
haze = 1.5
}
local t49 = {
clock = 12,
brightness = 4,
ambient = {
240,
235,
210
},
outAmb = {
250,
245,
220
},
sky = t47,
atm = t48,
clouds = {
cover = 0.85,
dens = 0.5,
color = {
255,
255,
255
}
}
}
local t50 = {
stars = 0,
sun = 6,
moon = 0
}
local t51 = {
dens = 0.65,
color = {
80,
90,
120
},
decay = {
40,
50,
80
},
glare = 0.5,
haze = 3
}
local t52 = {
clock = 15,
brightness = 1.4,
ambient = {
90,
90,
110
},
outAmb = {
100,
100,
120
},
sky = t50,
atm = t51,
clouds = {
cover = 0.95,
dens = 0.95,
color = {
60,
65,
80
}
}
}
local t53 = {
sun = 22,
stars = 0,
moon = 0
}
local t54 = {
dens = 0.45,
color = {
255,
180,
100
},
decay = {
255,
140,
80
},
glare = 2.4,
haze = 2.2
}
local t55 = {
clock = 6.2,
brightness = 2.8,
ambient = {
220,
180,
130
},
outAmb = {
230,
190,
140
},
sky = t53,
atm = t54,
clouds = {
cover = 0.4,
dens = 0.4,
color = {
255,
220,
180
}
}
}
local t56 = {
stars = 15000,
moon = 0,
sun = 0
}
local t57 = {
clock = 0,
brightness = 1,
ambient = {
30,
25,
50
},
outAmb = {
40,
35,
60
},
sky = t56,
atm = {
dens = 0.08,
color = {
15,
5,
40
},
decay = {
5,
0,
20
},
glare = 0.2,
haze = 0.3
}
}
local t58 = {
stars = 800,
moon = 16,
sun = 0
}
local t59 = {
dens = 0.4,
color = {
200,
160,
255
},
decay = {
160,
120,
220
},
glare = 1.4,
haze = 1.8
}
local t60 = {
clock = 18.5,
brightness = 2.6,
ambient = {
180,
160,
220
},
outAmb = {
190,
170,
230
},
sky = t58,
atm = t59,
clouds = {
cover = 0.55,
dens = 0.5,
color = {
220,
200,
255
}
}
}
local t61 = {
sun = 26,
moon = 0,
stars = 0
}
local t62 = {
dens = 0.6,
color = {
255,
90,
20
},
decay = {
200,
40,
0
},
glare = 3,
haze = 3.2
}
local t63 = {
clock = 17.5,
brightness = 2.2,
ambient = {
220,
100,
40
},
outAmb = {
235,
110,
50
},
sky = t61,
atm = t62,
clouds = {
cover = 0.7,
dens = 0.7,
color = {
200,
80,
40
}
}
}
local t64 = {
sun = 10
}
local t65 = {
dens = 0.32,
color = {
150,
255,
210
},
decay = {
100,
220,
180
},
glare = 1.6,
haze = 1.6
}
value8.CANDY_SKY_PRESETS = {
Off = t4,
Night = t6,
Aurora = t8,
Sunset = t11,
Galaxy = t13,
Cyber = t16,
Sakura = t19,
["Pink Night"] = t22,
["Blood Moon"] = t25,
["Emerald Dawn"] = t28,
Volcanic = t31,
Arctic = t34,
["Midnight Ocean"] = t36,
Vaporwave = t39,
Toxic = t41,
["Solar Eclipse"] = t43,
Hellscape = t46,
Heaven = t49,
Storm = t52,
Sunrise = t55,
["Deep Space"] = t57,
["Lavender Dream"] = t60,
Inferno = t63,
["Mint Sky"] = {
clock = 10,
brightness = 3.2,
ambient = {
180,
230,
210
},
outAmb = {
190,
240,
220
},
sky = t64,
atm = t65,
clouds = {
cover = 0.55,
dens = 0.45,
color = {
240,
255,
250
}
}
}
}
t2.value8.SkyOrder = {
"Off",
"Night",
"Aurora",
"Sunset",
"Galaxy",
"Cyber",
"Sakura",
"Pink Night",
"Blood Moon",
"Emerald Dawn",
"Volcanic",
"Arctic",
"Midnight Ocean",
"Vaporwave",
"Toxic",
"Solar Eclipse",
"Hellscape",
"Heaven",
"Storm",
"Sunrise",
"Deep Space",
"Lavender Dream",
"Inferno",
"Mint Sky"
}
task.spawn(function()
  if not t2.value8.introGUIEnabled then
    return
  end

  local PlayerGui = t2.value7:WaitForChild("PlayerGui")
  local ScreenGui = Instance.new("ScreenGui")

  ScreenGui.Name = "KevinHubIntro"
  ScreenGui.IgnoreGuiInset = true
  ScreenGui.ResetOnSpawn = false
  ScreenGui.Parent = PlayerGui

  local Frame = Instance.new("Frame", ScreenGui)

  Frame.Size = UDim2.new(1, 0, 1, 0)
  Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  Frame.BorderSizePixel = 0

  local TextLabel = Instance.new("TextLabel", Frame)

  TextLabel.Size = UDim2.new(1, 0, 0, 52)
  TextLabel.Position = UDim2.new(0, 0, 0.42, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = "KEVIN HUB ON TOP!"
  TextLabel.Font = Enum.Font.GothamBlack
  TextLabel.TextSize = 28
  TextLabel.TextColor3 = t2.value9

  local TextLabel2 = Instance.new("TextLabel", Frame)

  TextLabel2.Size = UDim2.new(1, 0, 0, 34)
  TextLabel2.Position = UDim2.new(0, 0, 0.49, 0)
  TextLabel2.BackgroundTransparency = 1
  TextLabel2.Text = "https://discord.gg/TBBAUZu8cW"
  TextLabel2.Font = Enum.Font.GothamBold
  TextLabel2.TextSize = 18
  TextLabel2.TextColor3 = t2.value15
  task.wait(2.5)
  ScreenGui:Destroy()
end)

function t2.value8.CandyApplyCustomSky(p1)
  for _, child in ipairs(t2.value5:GetChildren()) do
    local v141 = child

    if v141:GetAttribute(t2.value8.CANDY_SKY_TAG) then
      pcall(function()
        v141:Destroy()
      end)
    end
  end

  local Terrain = workspace:FindFirstChildOfClass("Terrain")

  if Terrain then
    local GetChildren = Terrain.GetChildren

    for _, v in ipairs(GetChildren(Terrain)) do
      local v146 = v

      if v146:GetAttribute(t2.value8.CANDY_SKY_TAG) then
        pcall(function()
          v146:Destroy()
        end)
      end
    end
  end

  local v147 = t2.value8.CANDY_SKY_PRESETS[p1]

  if not v147 or v147.kind == "off" then
    t2.value5.ClockTime = 14
    t2.value5.Brightness = 2
    t2.value5.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    t2.value5.Ambient = Color3.fromRGB(127, 127, 127)
    t2.value5.FogEnd = 100000
    t2.value5.GlobalShadows = true

    return
  end

  t2.value5.FogStart = 0
  t2.value5.FogEnd = 100000
  t2.value5.FogColor = Color3.fromRGB(200, 200, 200)
  t2.value5.ColorShift_Top = Color3.fromRGB(0, 0, 0)
  t2.value5.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
  t2.value5.GlobalShadows = true
  t2.value5.ClockTime = v147.clock or 14
  t2.value5.Brightness = v147.brightness or 2

  if v147.outAmb then
    local value5 = t2.value5
    local outAmb = v147.outAmb

    value5.OutdoorAmbient = Color3.fromRGB(outAmb[1], outAmb[2], outAmb[3])
  end

  if v147.ambient then
    local value5 = t2.value5
    local ambient = v147.ambient

    value5.Ambient = Color3.fromRGB(ambient[1], ambient[2], ambient[3])
  end

  if v147.sky then
    local Sky = Instance.new("Sky")

    Sky:SetAttribute(t2.value8.CANDY_SKY_TAG, true)

    if v147.sky.stars then
      Sky.StarCount = v147.sky.stars
    end

    if v147.sky.moon then
      Sky.MoonAngularSize = v147.sky.moon
    end

    if v147.sky.sun then
      Sky.SunAngularSize = v147.sky.sun
    end

    if v147.sky.moonTex then
      Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
    end

    Sky.Parent = t2.value5
  end

  if v147.atm then
    local Atmosphere = Instance.new("Atmosphere")

    Atmosphere:SetAttribute(t2.value8.CANDY_SKY_TAG, true)
    Atmosphere.Density = v147.atm.dens or 0.3

    local color = v147.atm.color

    Atmosphere.Color = Color3.fromRGB(color[1], color[2], color[3])

    local decay = v147.atm.decay

    Atmosphere.Decay = Color3.fromRGB(decay[1], decay[2], decay[3])
    Atmosphere.Glare = v147.atm.glare or 1
    Atmosphere.Haze = v147.atm.haze or 1
    Atmosphere.Parent = t2.value5
  end

  if v147.clouds and Terrain then
    local Clouds = Instance.new("Clouds")

    Clouds:SetAttribute(t2.value8.CANDY_SKY_TAG, true)
    Clouds.Cover = v147.clouds.cover or 0.5
    Clouds.Density = v147.clouds.dens or 0.5

    local color = v147.clouds.color

    Clouds.Color = Color3.fromRGB(color[1], color[2], color[3])
    Clouds.Parent = Terrain
  end
end
local value8_2 = t2.value8
local t66 = {
WalkAnim = 18537392113,
RunAnim = 18537384940,
JumpAnim = 18537380791,
FallAnim = 18537367238,
SwimIdle = 18537387180,
Swim = 18537389531,
Animation1 = 18537376492,
Animation2 = 18537371272,
ClimbAnim = 18537363391
}
local t67 = {
WalkAnim = 122150855457010,
RunAnim = 82598234841035,
JumpAnim = 75290611992385,
FallAnim = 98600215928904,
SwimIdle = 109346520324160,
Swim = 133308483266210,
Animation1 = 122257458498460,
Animation2 = 102357151005770,
ClimbAnim = 88763136693023
}
local t68 = {
WalkAnim = 83842218823011,
RunAnim = 118320322718870,
JumpAnim = 109996626521200,
FallAnim = 95603166884636,
SwimIdle = 94922130551805,
Swim = 134530128383900,
Animation1 = 110211186840350,
Animation2 = 114191137265065,
ClimbAnim = 97824616490448
}
local t69 = {
WalkAnim = 92072849924640,
RunAnim = 72301599441680,
JumpAnim = 104325245285200,
FallAnim = 121152442762480,
Animation1 = 118832222982049,
ClimbAnim = 131326830509780,
SwimIdle = 113199415118200,
Swim = 99384245425157,
Animation2 = 76049494037641
}
local t70 = {
WalkAnim = 10921111375,
RunAnim = 10921104374,
JumpAnim = 10921107367,
FallAnim = 10921105765,
SwimIdle = 10921110146,
Swim = 10921108971,
ClimbAnim = 10921100400,
Animation1 = 10921101664,
Animation2 = 10921102574
}
local t71 = {
WalkAnim = 10921355261,
RunAnim = 616163682,
JumpAnim = 10921351278,
FallAnim = 10921350320,
SwimIdle = 10921353442,
Swim = 10921352344,
Animation1 = 10921344533,
Animation2 = 10921345304,
ClimbAnim = 10921343576
}
local t72 = {
WalkAnim = 10921152678,
RunAnim = 10921148209,
JumpAnim = 10921149743,
FallAnim = 10921148939,
SwimIdle = 10921151661,
Swim = 10921150788,
ClimbAnim = 10921143404,
Animation1 = 10921144709,
Animation2 = 10921145797
}
local t73 = {
WalkAnim = 109168724482748,
RunAnim = 81024476153754,
JumpAnim = 116936326516980,
FallAnim = 92294537340807,
SwimIdle = 98854111361360,
Swim = 134591743181630,
ClimbAnim = 119377220967550,
Animation1 = 133806214992291,
Animation2 = 94970088341563
}
local t74 = {
WalkAnim = 10921046031,
RunAnim = 10921039308,
JumpAnim = 10921042494,
FallAnim = 10921040576,
SwimIdle = 10921045006,
Swim = 10921044000,
ClimbAnim = 10921032124,
Animation1 = 10921034824,
Animation2 = 10921036806
}
local t75 = {
WalkAnim = 73718308412641,
RunAnim = 135515454877970,
JumpAnim = 78508480717326,
FallAnim = 78147885297412,
SwimIdle = 129183123083280,
Swim = 110657013921770,
ClimbAnim = 129447497744818,
Animation1 = 92849173543269,
Animation2 = 132238900951109
}
local t76 = {
WalkAnim = 10921342074,
RunAnim = 10921336997,
JumpAnim = nil,
FallAnim = 10921337907,
SwimIdle = 10921341319,
Swim = 10921340419,
ClimbAnim = 10921329322,
Animation1 = 10921330408,
Animation2 = 10921333667
}
local t77 = {
WalkAnim = 10921298616,
RunAnim = 10921291831,
JumpAnim = 10921294559,
FallAnim = 10921293373,
SwimIdle = 10921297391,
Swim = 10921295495,
ClimbAnim = 10921286911,
Animation1 = 10921288909,
Animation2 = 10921290167
}
local t78 = {
WalkAnim = 10921312010,
RunAnim = 10921306285,
JumpAnim = 10921308158,
FallAnim = 10921307241,
SwimIdle = 10921310341,
Swim = 10921309319,
ClimbAnim = 10921300839,
Animation1 = 10921301576,
Animation2 = nil
}
local t79 = {
WalkAnim = 18747074203,
RunAnim = 18747070484,
JumpAnim = 18747069148,
FallAnim = 18747062535,
SwimIdle = 18747071682,
Swim = 18747073181,
ClimbAnim = 18747060903,
Animation1 = 18747067405,
Animation2 = 18747063918
}
local t80 = {
WalkAnim = 110358958299420,
RunAnim = 117333533048080,
JumpAnim = 119846112151350,
FallAnim = 129773241321030,
SwimIdle = 79090109939093,
Swim = 132697394189921,
ClimbAnim = 134630013742020,
Animation1 = 92080889861410,
Animation2 = 74451233229259
}
local t81 = {
WalkAnim = 90478085024465,
RunAnim = 134824450619860,
JumpAnim = 121454505477200,
FallAnim = 94788218468396,
SwimIdle = 129126268464847,
Swim = 105962919001090,
ClimbAnim = 121145883950230,
Animation1 = 98281136301627,
Animation2 = nil
}
local t82 = {
WalkAnim = 10921326949,
RunAnim = 10921320299,
JumpAnim = 10921322186,
FallAnim = 10921321317,
SwimIdle = 10921325443,
Swim = 10921324408,
ClimbAnim = 10921314188,
Animation1 = 10921315373,
Animation2 = nil
}
local t83 = {
Run = 656118852,
Walk = 656121766,
Jump = 656117878,
Fall = 656115606,
Swim = 656119721,
SwimIdle = 656121397,
Climb = 656114359,
Idle = {
656117400,
656118341,
886742569
}
}
local t84 = {
Run = 616091570,
Walk = 616095330,
Jump = 616090535,
Fall = 616087089,
Swim = 616092998,
SwimIdle = 616094091,
Climb = 616086039,
Idle = {
616088211,
616089559,
885531463
}
}
local t85 = {
Run = 616010382,
Walk = 616013216,
Jump = 616008936,
Fall = 616005863,
Swim = 616011509,
SwimIdle = 616012453,
Climb = 616003713,
Idle = {
616006778,
616008087,
886862142
}
}
local t86 = {
Run = 616140816,
Walk = 616146177,
Jump = 616139451,
Fall = 616134815,
Swim = 616143378,
SwimIdle = 616144772,
Climb = 616133594,
Idle = {
616136790,
616138447,
886888594
}
}
local t87 = {
Run = 910025107,
Walk = 910034870,
Jump = 910016857,
Fall = 910001910,
Swim = 910028158,
SwimIdle = 910030921,
Climb = 909997997,
Idle = {
910004836,
910009958,
1018536639
}
}
value8_2.PACKS = {
["Adidas Sports"] = t66,
["Adidas Community"] = t67,
["Adidas Aura"] = t68,
["Wicked Popular"] = t69,
Elder = t70,
Zombie = t71,
Mage = t72,
["Catwalk Glam"] = t73,
Astronaut = t74,
["Wicked \"Dancing Through Life\""] = t75,
Werewolf = t76,
Superhero = t77,
Toy = t78,
["No Boundaries"] = t79,
NFL = t80,
["Amazon Unboxed"] = t81,
Vampire = t82,
Ninja = t83,
Robot = t84,
Levitation = t85,
Stylish = t86,
Bubbly = t87,
Cartoon = {
Run = 742638842,
Walk = 742640026,
Jump = 742637942,
Fall = 742637151,
Swim = 742639220,
SwimIdle = 742639812,
Climb = 742636889,
Idle = {
742637544,
742638445,
885477856
}
}
}
t2.value8.animPack = "Adidas Sports"
t2.value8.animPackEnabled = true
t2.value8.savedAnimate = nil
t2.value8.headlessEnabled = false
t2.value8.korbloxEnabled = false
t2.value17 = "rbxassetid://1095708"
t2.value18 = "rbxassetid://101851696"
t2.value19 = "rbxassetid://101851254"
t2.value20 = Color3.fromRGB(64, 64, 64)

function t2.value21(p2)
  local face = p2:FindFirstChild("face")

  if face then
    face:Destroy()
  end
end
function t2.value8.applyHeadlessToChar(p3, p4)
  if not p3 then
    return
  end

  local Head = p3:FindFirstChild("Head")

  if not Head then
    return
  end

  if p4 then
    Head.Transparency = 1
    Head.CanCollide = false
    t2.value21(Head)

    for _, child in ipairs(Head:GetChildren()) do
      if child:IsA("SpecialMesh") and child.MeshId == t2.value17 then
        child:Destroy()
      end
    end

    local SpecialMesh = Instance.new("SpecialMesh")

    SpecialMesh.MeshType = Enum.MeshType.FileMesh
    SpecialMesh.MeshId = t2.value17
    SpecialMesh.Scale = Vector3.new(0.001, 0.001, 0.001)
    SpecialMesh.Name = "HeadlessMesh"
    SpecialMesh.Parent = Head
    Head:GetPropertyChangedSignal("Transparency"):Connect(function()
      if Head.Transparency ~= 1 then
        Head.Transparency = 1
      end
    end)
    Head.ChildAdded:Connect(function(child)
      if child.Name == "face" and child:IsA("Decal") then
        child:Destroy()
      end
    end)

    return
  end

  Head.Transparency = 0
  Head.CanCollide = true

  for _, child in ipairs(Head:GetChildren()) do
    if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
      child:Destroy()
    end
  end

  t2.value21(Head)
end
function t2.value8.applyKorbloxToChar(p5, p6)
  if not p5 then
    return
  end

  local Humanoid = p5:FindFirstChildOfClass("Humanoid")

  if not Humanoid then
    return
  end

  if p6 then
    if Humanoid.RigType == Enum.HumanoidRigType.R6 then
      local v171 = p5:FindFirstChild("Right Leg")

      if v171 then
        for _, child in ipairs(v171:GetChildren()) do
          if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
            child:Destroy()
          end
        end

        v171.Color = t2.value20
        v171:GetPropertyChangedSignal("Color"):Connect(function()
          if v171.Color ~= t2.value20 then
            v171.Color = t2.value20
          end
        end)

        local SpecialMesh = Instance.new("SpecialMesh")

        SpecialMesh.MeshType = Enum.MeshType.FileMesh
        SpecialMesh.MeshId = t2.value18
        SpecialMesh.TextureId = t2.value19
        SpecialMesh.Scale = Vector3.new(1, 1, 1)
        SpecialMesh.Name = "KorbloxMesh"
        SpecialMesh.Parent = v171

        return
      end
    elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
      local RightUpperLeg = p5:FindFirstChild("RightUpperLeg")

      if RightUpperLeg then
        RightUpperLeg.Transparency = 1

        local RightLowerLeg = p5:FindFirstChild("RightLowerLeg")
        local RightFoot = p5:FindFirstChild("RightFoot")

        if RightLowerLeg then
          RightLowerLeg.Transparency = 1
        end

        if RightFoot then
          RightFoot.Transparency = 1
        end

        local KorbloxLeg = p5:FindFirstChild("KorbloxLeg")

        if KorbloxLeg then
          KorbloxLeg:Destroy()
        end

        local Part = Instance.new("Part")

        Part.Name = "KorbloxLeg"
        Part.Size = Vector3.new(1, 2, 1)
        Part.Anchored = false
        Part.CanCollide = false
        Part.Color = t2.value20
        Part.Parent = p5

        local SpecialMesh = Instance.new("SpecialMesh")

        SpecialMesh.MeshType = Enum.MeshType.FileMesh
        SpecialMesh.MeshId = t2.value18
        SpecialMesh.TextureId = t2.value19
        SpecialMesh.Scale = Vector3.new(1, 1, 1)
        SpecialMesh.Name = "KorbloxMesh"
        SpecialMesh.Parent = Part

        local Weld = Instance.new("Weld")

        Weld.Part0 = RightUpperLeg
        Weld.Part1 = Part
        Weld.C0 = CFrame.new(0, -0.8, 0)
        Weld.Name = "KorbloxWeld"
        Weld.Parent = Part

        return
      end
    end
  elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
    local v182 = p5:FindFirstChild("Right Leg")

    if v182 then
      local GetChildren = v182.GetChildren

      for _, v in ipairs(GetChildren(v182)) do
        if v:IsA("SpecialMesh") and v.Name == "KorbloxMesh" then
          v:Destroy()
        end
      end

      v182.Color = Color3.fromRGB(255, 255, 255)

      return
    end
  elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
    local RightUpperLeg = p5:FindFirstChild("RightUpperLeg")

    if RightUpperLeg then
      RightUpperLeg.Transparency = 0

      local RightLowerLeg = p5:FindFirstChild("RightLowerLeg")
      local RightFoot = p5:FindFirstChild("RightFoot")

      if RightLowerLeg then
        RightLowerLeg.Transparency = 0
      end

      if RightFoot then
        RightFoot.Transparency = 0
      end

      local KorbloxLeg = p5:FindFirstChild("KorbloxLeg")

      if KorbloxLeg then
        KorbloxLeg:Destroy()
      end
    end
  end
end
function t2.value8.applyCharterToChar(p7)
  if not p7 then
    return
  end

  t2.value8.applyHeadlessToChar(p7, t2.value8.headlessEnabled)
  t2.value8.applyKorbloxToChar(p7, t2.value8.korbloxEnabled)
end
t2.value7.CharacterAdded:Connect(function(character)
  if t2.value8.stopInstaReset then
    t2.value8.stopInstaReset()
  end

  task.wait(0.15)
  t2.value8.applyCharterToChar(character)
end)
t2.value4.Heartbeat:Connect(function()
  local Character = t2.value7.Character

  if Character then
    t2.value8.applyCharterToChar(Character)
  end
end)
t2.value8.NS = 60
t2.value8.CS = 30
t2.value8.LAGGER_SPEED = 15
t2.value8.LAGGER_CARRY_SPEED = 24.5
t2.value8.speedMethod = "Velocity"
t2.value8.speedMethodList = {
"Velocity",
"AssemblyLinearVelocity",
"Velocity Lerp",
"AssemblyLinearVelocity Lerp",
"CFrame",
"CFrame Lerp",
"Hyper CFrame",
"Anchored CFrame",
"PivotTo",
"Model PivotTo",
"Tween CFrame",
"WalkSpeed",
"Humanoid Move",
"Humanoid MoveTo",
"BodyVelocity",
"BodyPosition",
"BodyForce",
"BodyThrust",
"LinearVelocity",
"VectorForce",
"AlignPosition",
"ApplyImpulse",
"RocketPropulsion"
}
t2.value8.hyperMult = 4
t2.value8._lastSpeedMethod = nil
t2.value8._speedHRP = nil
t2.value8._anchoredBySpeed = nil
t2.value8._bodyVel = nil
t2.value8._bodyPosition = nil
t2.value8._bodyForce = nil
t2.value8._bodyThrust = nil
t2.value8._linearVel = nil
t2.value8._vectorForce = nil
t2.value8._alignPos = nil
t2.value8._rocket = nil
t2.value8._rocketTarget = nil
t2.value8._attLinVel = nil
t2.value8._attVecForce = nil
t2.value8._attAlign = nil
t2.value8._speedTween = nil
t2.value8.carrySpeedActive = false
t2.value8.laggerModeEnabled = false
t2.value8.laggerCarryActive = false
t2.value8.antiRagdollEnabled = false
t2.value8.antiRagdollMode = "Splatter"
t2.value8.infJumpEnabled = false
t2.value8.infJumpMode = "manual"
t2.value8.medusaCounterEnabled = false
t2.value8.batCounterEnabled = false
t2.value8.unwalkEnabled = false
t2.value8.medusaResetEnabled = false
t2.value8.medusaDebounce = false
t2.value8.medusaLastUsed = 0
t2.value8.dropActive = false
t2.value8.autoLeftEnabled = false
t2.value8.autoRightEnabled = false
t2.value8.autoBatEnabled = false
t2.value8.autoSwingEnabled = true
t2.value8.autoMoveSwingEnabled = false
t2.value8.autoMoveSwingInterval = 0.3
t2.value8._alSwingDebounce = false
t2.value8._arSwingDebounce = false
t2.value8.antiLagEnabled = false
t2.value8.antiSummerBaseEnabled = false
t2.value8.antiSummerBaseConn = nil
t2.value8._antiSummerCleaned = {}
t2.value8.removeAccessoriesEnabled = false
t2.value8.antiLagDescConn = nil
t2.value8.stretchRezEnabled = false
t2.value8.stretchRezConn = nil
t2.value8.unwalkSavedAnimate = nil
t2.value8._anyKeyListening = false
t2.value8.autoTPEnabled = false
t2.value8.autoTPHeight = 20
t2.value8.autoTPConn = nil
t2.value8.resetCooldown = false
t2.value8.resetThread = nil
t2.value8.currentResetCharacter = nil
t2.value8.resetSuccessful = false
t2.value8.stopResetSequence = false
t2.value8.resetOriginalHipHeight = nil
t2.value8.guiTransparencyEnabled = false
t2.value8.mobileButtonsEnabled = true
t2.value8.mobileButtonsLocked = false
t2.value8.mobileButtonsSize = 100
t2.value8.circleButtonsEnabled = false
t2.value8.mobBtnRefs = {}
t2.value8.mobGuiRef = nil
t2.value8.fovValue = 80
t2.value8.fovOptions = {
80,
120,
180
}
t2.value8.fovIndex = 1
t2.value8.laggerModePillRef = nil
t2.value8.carryModePillRef = nil
t2.value8.autoSwitchSpeedEnabled = false
t2.value8.autoTurnOffSpeedEnabled = false
t2.value8.autoSwitchLaggerSpeedEnabled = false
t2.value8.AUTO_SWITCH_THRESHOLD = 25
t2.value8._autoSwitchSpeedConn = nil
t2.value8.customFontSelected = "None"
t2.value8._fontOrig = {}
t2.value8._fontConn = nil
t2.value8._fontMy = nil
t2.value8.FONT_NAMES = {
"None",
"Coding Font",
"Summer",
"Beachy",
"Scary",
"Bangers"
}
t2.value8.mobBtnTransparencyEnabled = false
t2.value8.perButtonDragEnabled = true
t2.value8.antiKickEnabled = false
t2.value8.brainrotDetected = false
t2.value8.safeModeEnabled = false
t2.value8.mirrorTPDownEnabled = false
t2.value8.mirrorTPPreviousY = {}
t2.value8.mirrorTPLastTeleport = 0
t2.value8.MIRROR_TP_DROP_THRESHOLD = 3
t2.value8.MIRROR_TP_DOWN_Y = -7
t2.value8.activeBatBillboard = nil
t2.value8.activeMedusaBillboard = nil
t2.value8.ragdollGuiEnabled = true
t2.value8.persistentRagdollGui = nil
t2.value8.uiLocked = false
t2.value8.holdInfJumpConn = nil
t2.value8.DROP_ASCEND_DURATION = 0.2
t2.value8.DROP_ASCEND_SPEED = 150
t2.value8.autoResetOnDeath = false
t2.value8.bypassAimbotEnabled = false
t2.value8.bypassAimbotConn = nil
t2.value8._bypassGodConn = nil
t2.value8._bypassGodHealthConn = nil
t2.value8._bypassGodDiedConn = nil
t2.value8._bypassGodCharConn = nil
t2.value8.bypassPrevAutoRotate = nil
t2.value8.bypassHitCD = false
t2.value8.bypassSwingCD = 0.35
t2.value8.bypassHitDist = 8
t2.value8._bypassTarget = nil
t2.value8.stealMode = "V1"
t2.value8.stealBarSize = 450
t2.value8.stealBarScale = 0.6
t2.value8.Steal = {
AutoStealEnabled = false,
StealRadius = 60,
StealDuration = 1.4,
StopTime = 0.35
}
t2.value8.V3 = {
enabled = false,
conn = nil,
progress = 0,
lastInRange = 0,
currentUid = nil,
holding = false,
holdPrompt = nil,
cooldownUntil = 0
}
t2.value8.autoRadiusEnabled = false
function t2.value8.getAutoRadius()
  return math.floor(math.clamp((tonumber(t2.value8.NS) or 60) + 1, 1, 500) * 10 + 0.5) / 10
end
function t2.value8.getActiveStealRadius()
  if t2.value8.stealMode == "Semi" or t2.value8.stealMode == "V2" then
    return math.min(tonumber(t2.value8.Semi.radius) or 10, 10)
  end

  return t2.value8.autoRadiusEnabled and t2.value8.getAutoRadius() or t2.value8.Steal.StealRadius
end
local value8_3 = t2.value8
local t88 = {
caches = {},
connections = {}
}
local t89 = {
active = false,
startTime = 0,
phase = "idle",
label = "",
lastResult = "",
lastResultTime = 0
}
value8_3.Semi = {
enabled = false,
holdMin = 1.3,
holdMax = 2.6,
entryDelay = 0.3,
cooldown = 0.05,
primeRange = 80,
radius = 10,
conn = nil,
scanThread = nil,
plotSync = t88,
animals = {},
promptCache = {},
internalCache = {},
state = t89,
plots = nil,
syncReady = false
}
t2.value8.isStealing = false
t2.value8.stealStartTime = 0
t2.value8.stealConn = nil
t2.value8.progressConn = nil
t2.value8.animalCache = {}
t2.value8.promptCache = {}
t2.value8.stealCache = {}
t2.value8.playerESPEnabled = false
t2.value8.espList = {}
t2.value8.pingPopupActive = false
t2.value8.pingPopupGui = nil
t2.value8.pingCycleTimer = nil
t2.value8.Conns = {
autoSteal = nil,
antiRag = nil,
batCounter = nil,
anchor = {}
}
t2.value8._persistentConns = {}
t2.value8.alConn = nil
t2.value8.arConn = nil
t2.value8.alPhase = 1
t2.value8.arPhase = 1
t2.value8.aimbotConn = nil
t2.value8.lastMoveDir = Vector3.new(0, 0, 0)
t2.value8.batCounterDebounce = false
t2.value8.speedLabel = nil
local value8_4 = t2.value8
local t90 = {
kb = nil,
gp = nil
}
local t91 = {
kb = nil,
gp = nil
}
local t92 = {
kb = nil,
gp = nil
}
local t93 = {
kb = nil,
gp = nil
}
local t94 = {
kb = nil,
gp = nil
}
local t95 = {
kb = nil,
gp = nil
}
local t96 = {
kb = nil,
gp = nil
}
local t97 = {
kb = nil,
gp = nil
}
local t98 = {
kb = nil,
gp = nil
}
value8_4.KB = {
DropBrainrot = t90,
AutoLeft = t91,
AutoRight = t92,
AutoBat = t93,
TPFloor = t94,
InstaReset = t95,
GuiHide = t96,
SpeedToggle = t97,
LaggerToggle = t98,
BypassAimbot = {
kb = nil,
gp = nil
}
}
t2.value8.AP_L1 = Vector3.new(-476.47, -6.28, 92.73)
t2.value8.AP_L2 = Vector3.new(-483.12, -4.95, 94.81)
t2.value8.AP_R1 = Vector3.new(-476.16, -6.52, 25.62)
t2.value8.AP_R2 = Vector3.new(-483.06, -5.03, 25.48)
t2.value8.MEDUSA_COOLDOWN = 25
t2.value8.BAT_COUNTER_SLAP_LIST = {
"Bat",
"Slap",
"Iron Slap",
"Gold Slap",
"Diamond Slap",
"Emerald Slap",
"Ruby Slap",
"Dark Matter Slap",
"Flame Slap",
"Nuclear Slap",
"Galaxy Slap",
"Glitched Slap"
}
t2.value8.fovConn = nil
t2.value8.defLightBrightness = nil
t2.value8.defLightClock = nil
t2.value8.defLightAmbient = nil
t2.value8.mainFrame = nil
t2.value8.normalBox = nil
t2.value8.carryBox = nil
t2.value8.laggerBox = nil
t2.value8.radInput = nil
t2.value8.autoTPHeightBox = nil
t2.value8.durationBox = nil
t2.value8.modeValLbl = nil
t2.value8.setInstaGrab = nil
t2.value8.setInfJumpVisual = nil
t2.value8.setAntiRagVisual = nil
t2.value8.setMedusaVisual = nil
t2.value8.setUnwalkVisual = nil
t2.value8.setAntiLagVisual = nil
t2.value8.setAutoSwingVisual = nil
t2.value8.setTranspVisual = nil
t2.value8.setLockVisual = nil
t2.value8.setMobVisual = nil
t2.value8.setCircleBtnsVisual = nil
t2.value8.setMedusaResetVisual = nil
t2.value8.antiKickSetVisual = nil
t2.value8.autoLeftSetVisual = nil
t2.value8.autoRightSetVisual = nil
t2.value8.autoBatSetVisual = nil
t2.value8.setAutoTPVisual = nil
t2.value8.setStretchRezVisual = nil
t2.value8.setAutoResetOnDeath = nil
t2.value8.setBypassVisual = nil
t2.value8._autoSwitchWasSteal = false
t2.value8.MOB_POS_FILE = "moveeduels_btnpos.json"
local value8_5 = t2.value8
local W = Enum.KeyCode.W
local A = Enum.KeyCode.A
local S = Enum.KeyCode.S
local D = Enum.KeyCode.D
local Up = Enum.KeyCode.Up
local Left = Enum.KeyCode.Left
local Down = Enum.KeyCode.Down
local Right = Enum.KeyCode.Right
value8_5.MOVE_KEYS = {
[W] = true,
[A] = true,
[S] = true,
[D] = true,
[Up] = true,
[Left] = true,
[Down] = true,
[Right] = true
}
t2.value8.showPlayerSpeeds = false
t2.value8.playerSpeedGuis = {}
t2.value8.playerSpeedUpdateConn = nil
t2.value8.removeAccEnabled = false
t2.value8.removeAccConn = nil
t2.value8.removedAccessories = {}
t2.value8.uiScale = 0.8
if t2.value3.TouchEnabled and not t2.value3.KeyboardEnabled then
  t2.value8.uiScale = 0.7
end
t2.value8.uiScaleSliderRef = nil
t2.value8.uiScaleLabelRef = nil
t2.value8.uiScaleBoxRef = nil
t2.value8.lineESPEnabled = false
t2.value8.menuOpen = true
t2.value8.speedESPEnabled = false
t2.value8.statusGui = nil
t2.value8.statusFill = nil
t2.value8.statusPctLbl = nil
t2.value8.statusRadiusLbl = nil
t2.value8.statusDot = nil
t2.value8.statusMain = nil
t2.value8.statusFpsLbl = nil
t2.value8.statusPerfConn = nil
t2.value8.statusDragConn = nil
t2.value8.statusTitleLbl = nil
function t2.value8.addShimmerToLabel(p8, p9, p10)
  local UIGradient = Instance.new("UIGradient", p8)
  local new = ColorSequence.new
  local v198 = p9
  local new2 = ColorSequenceKeypoint.new

  if not p9 then
    v198 = Color3.fromRGB(100, 100, 100)
  end

  local v200 = new2(0, v198)
  local new3 = ColorSequenceKeypoint.new

  if not p10 then
    p10 = Color3.fromRGB(255, 255, 255)
  end

  local v202 = new3(0.5, p10)
  local new4 = ColorSequenceKeypoint.new

  if not p9 then
    p9 = Color3.fromRGB(100, 100, 100)
  end

  local t99 = { new4(1, p9) }

  UIGradient.Color = new({
  v200,
  v202,
  v3(t99)
  })
  UIGradient.Transparency = NumberSequence.new({
  NumberSequenceKeypoint.new(0, 0.3, 0),
  NumberSequenceKeypoint.new(0.5, 0, 0),
  NumberSequenceKeypoint.new(1, 0.3, 0)
  })

  return UIGradient
end
function t2.value8.applyFOV()
  if t2.value8.fovConn then
    t2.value8.fovConn:Disconnect()
  end

  t2.value8.fovConn = t2.value4.RenderStepped:Connect(function()
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
      CurrentCamera.FieldOfView = t2.value8.fovValue
    end
  end)
end
t2.value8.ragdollTimerThread = nil
t2.value8.ragdollTimerRemaining = 0
t2.value8.isRagdollActive = false
function t2.value8.updateRagdollTimer(p11)
  if t2.value8.ragdollTimerThread then
    task.cancel(t2.value8.ragdollTimerThread)
    t2.value8.ragdollTimerThread = nil
  end

  if p11 <= 0 then
    t2.value8.isRagdollActive = false

    if t2.value8.headIndicator and t2.value8.headIndicator.ragdollTimer then
      t2.value8.headIndicator.ragdollTimer.Text = ""
    end

    return
  end

  t2.value8.isRagdollActive = true

  local timestamp = tick()

  t2.value8.ragdollTimerRemaining = p11
  t2.value8.ragdollTimerThread = task.spawn(function()
    while t2.value8.isRagdollActive and t2.value8.ragdollTimerRemaining > 0 do
      local v1355 = tick() - timestamp
      local v1356 = math.max(0, p11 - v1355)

      t2.value8.ragdollTimerRemaining = v1356

      if t2.value8.headIndicator and t2.value8.headIndicator.ragdollTimer then
        t2.value8.headIndicator.ragdollTimer.Text = string.format("%.1fs", v1356)
      end

      if v1356 <= 0 then
        t2.value8.isRagdollActive = false

        if t2.value8.headIndicator and t2.value8.headIndicator.ragdollTimer then
          t2.value8.headIndicator.ragdollTimer.Text = ""
        end

        break
      end

      task.wait(0.05)
    end

    t2.value8.ragdollTimerThread = nil
  end)
end
function t2.value8.onHumanoidStateChanged(_, p13)
  local Character = t2.value7.Character

  if not Character then
    return
  end

  local Humanoid = Character:FindFirstChildOfClass("Humanoid")

  if not Humanoid then
    return
  end

  if p13 == Enum.HumanoidStateType.Physics or (p13 == Enum.HumanoidStateType.Ragdoll or p13 == Enum.HumanoidStateType.FallingDown and not Humanoid.PlatformStand) then
    t2.value8.updateRagdollTimer(2.6)
  end
end
function t2.value8.onMedusaStateChanged()
  local Character = t2.value7.Character

  if not Character then
    return
  end

  local Humanoid = Character:FindFirstChildOfClass("Humanoid")

  if Humanoid and Humanoid.PlatformStand then
    t2.value8.updateRagdollTimer(4.5)
  end
end
function t2.value8.setupRagdollTriggers()
  local Character = t2.value7.Character

  if not Character then
    return
  end

  local Humanoid = Character:FindFirstChildOfClass("Humanoid")

  if Humanoid then
    Humanoid.StateChanged:Connect(t2.value8.onHumanoidStateChanged)
    Humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(t2.value8.onMedusaStateChanged)
  end
end
function t2.value8.waitForAnimate(p14)
  for _ = 1, 40 do
    local Animate = p14:FindFirstChild("Animate")

    if Animate and (Animate:FindFirstChild("idle") and (Animate:FindFirstChild("run") and Animate:FindFirstChild("walk"))) then
      return Animate
    end

    task.wait(0.1)
  end

  return nil
end
function t2.value8.setAnim(p15, p16)
  if p15 and p16 then
    p15.AnimationId = "rbxassetid://" .. tostring(p16)
  end
end
function t2.value8.stopAllTracks(p17)
  if not p17 then
    return
  end

  local GetPlayingAnimationTracks = p17.GetPlayingAnimationTracks

  for _, v in ipairs(GetPlayingAnimationTracks(p17)) do
    local v224 = v

    pcall(function()
      v224:Stop(0)
    end)
  end
end
function t2.value8.ensureAnim(p18, p19)
  if not p18 then
    return nil
  end

  local p19_2 = p18:FindFirstChild(p19)

  if not p19_2 then
    p19_2 = Instance.new("Animation")
    p19_2.Name = p19
    p19_2.Parent = p18
  end

  return p19_2
end
function t2.value8.ensureIdleSlots(p20, p21)
  if not p20 then
    return
  end

  for i = 1, p21 or 2 do
    t2.value8.ensureAnim(p20, "Animation" .. i)
  end
end
function t2.value8.pick(p22, ...)
  for i = 1, select("#", ...) do
    local v233 = p22[select(i, ...)]

    if v233 ~= nil then
      return v233
    end
  end

  return nil
end
function t2.value8.saveOriginalAnimate(p23)
  if not p23 then
    return
  end

  if t2.value8.savedAnimate then
    return
  end

  local Animate = p23:FindFirstChild("Animate")

  if Animate then
    t2.value8.savedAnimate = Animate:Clone()
  end
end
function t2.value8.restoreOriginalAnimate(p24)
  if not p24 then
    return
  end

  local Humanoid = p24:FindFirstChildOfClass("Humanoid")

  if Humanoid then
    t2.value8.stopAllTracks(Humanoid)
  end

  local Animate = p24:FindFirstChild("Animate")

  if Animate then
    Animate:Destroy()
  end

  if t2.value8.savedAnimate then
    local clone = t2.value8.savedAnimate:Clone()

    clone.Parent = p24
    clone.Disabled = true
    task.wait(0.06)
    clone.Disabled = false
  end
end
function t2.value8.resetAnimations(p25)
  if not p25 then
    return
  end

  t2.value8.restoreOriginalAnimate(p25)
end
t2.value22 = false
function t2.value8.applyAnimPack(p26)
  if not t2.value8.animPackEnabled then
    local Character = t2.value7.Character

    if Character then
      t2.value8.resetAnimations(Character)
    end

    return false
  end

  if t2.value22 then
    return false
  end

  local v243 = t2.value8.PACKS[p26]

  if not v243 then
    return false
  end

  local v244 = t2.value7.Character or t2.value7.CharacterAdded:Wait()

  t2.value8.saveOriginalAnimate(v244)

  local v245 = t2.value8.waitForAnimate(v244)

  if not v245 then
    return false
  end

  local Humanoid = v244:FindFirstChildOfClass("Humanoid")

  t2.value8.stopAllTracks(Humanoid)

  local v247 = t2.value8.ensureAnim(v245:FindFirstChild("run"), "RunAnim")
  local v248 = t2.value8.ensureAnim(v245:FindFirstChild("walk"), "WalkAnim")
  local v249 = t2.value8.ensureAnim(v245:FindFirstChild("jump"), "JumpAnim")
  local v250 = t2.value8.ensureAnim(v245:FindFirstChild("fall"), "FallAnim")
  local v251 = t2.value8.ensureAnim(v245:FindFirstChild("climb"), "ClimbAnim")
  local v252 = t2.value8.ensureAnim(v245:FindFirstChild("swim"), "Swim")
  local v253 = t2.value8.ensureAnim(v245:FindFirstChild("swimidle"), "SwimIdle")
  local idle = v245:FindFirstChild("idle")

  t2.value8.setAnim(v248, t2.value8.pick(v243, "WalkAnim", "Walk"))
  t2.value8.setAnim(v247, t2.value8.pick(v243, "RunAnim", "Run"))
  t2.value8.setAnim(v249, t2.value8.pick(v243, "JumpAnim", "Jump"))
  t2.value8.setAnim(v250, t2.value8.pick(v243, "FallAnim", "Fall"))
  t2.value8.setAnim(v251, t2.value8.pick(v243, "ClimbAnim", "Climb"))
  t2.value8.setAnim(v252, t2.value8.pick(v243, "Swim"))
  t2.value8.setAnim(v253, t2.value8.pick(v243, "SwimIdle") or t2.value8.pick(v243, "Swim"))

  if idle then
    local v255 = t2.value8.pick(v243, "Animation1")
    local v256 = t2.value8.pick(v243, "Animation2")

    if v255 or v256 then
      t2.value8.ensureIdleSlots(idle, 2)

      local v257 = v255 or v256
      local v258 = v256 or (v255 or v257)

      t2.value8.setAnim(idle:FindFirstChild("Animation1"), v257)
      t2.value8.setAnim(idle:FindFirstChild("Animation2"), v258)
    elseif v243.Idle and #v243.Idle > 0 then
      t2.value8.ensureIdleSlots(idle, (math.max(2, #v243.Idle)))
      t2.value8.setAnim(idle:FindFirstChild("Animation1"), v243.Idle[1])
      t2.value8.setAnim(idle:FindFirstChild("Animation2"), v243.Idle[2] or v243.Idle[1])

      for i = 3, #v243.Idle do
        local v260 = i
        local v261 = idle:FindFirstChild("Animation" .. v260)

        if v261 then
          t2.value8.setAnim(v261, v243.Idle[v260])
        end
      end
    end
  end

  v245.Disabled = true
  task.wait(0.06)
  v245.Disabled = false

  if Humanoid then
    pcall(function()
      Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
      task.wait(0.03)
      Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end)
  end

  t2.value8.animPack = p26

  return true
end
function t2.value8.createPlayerSpeedGui(p27)
  if p27 == t2.value7 then
    return
  end
  if t2.value8.playerSpeedGuis[p27] then
    return
  end
  local Character = p27.Character
  if not Character then
    return
  end
  local Head = Character:FindFirstChild("Head")
  if not Head then
    return
  end
  local MoveePlayerSpeedBB = Head:FindFirstChild("MoveePlayerSpeedBB")
  if MoveePlayerSpeedBB then
    MoveePlayerSpeedBB:Destroy()
  end
  local BillboardGui = Instance.new("BillboardGui")
  BillboardGui.Name = "MoveePlayerSpeedBB"
  BillboardGui.Size = UDim2.new(0, 80, 0, 24)
  BillboardGui.StudsOffset = Vector3.new(0, 2.2, 0)
  BillboardGui.AlwaysOnTop = true
  BillboardGui.Adornee = Head
  BillboardGui.Parent = Head
  local TextLabel = Instance.new("TextLabel", BillboardGui)
  TextLabel.Size = UDim2.new(1, 0, 1, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = "0"
  TextLabel.TextColor3 = t2.value9
  TextLabel.Font = Enum.Font.GothamBold
  TextLabel.TextScaled = true
  TextLabel.TextStrokeTransparency = 0
  t2.value8.addShimmerToLabel(TextLabel, t2.value9, Color3.fromRGB(255, 255, 255))
  local connection
  connection = Character.AncestryChanged:Connect(function(_, parent)
    if not parent then
      t2.value8.removePlayerSpeedGui(p27)

      if connection then
        connection:Disconnect()
      end
    end
  end)
  local playerSpeedGuis = t2.value8.playerSpeedGuis
  playerSpeedGuis[p27] = {
  gui = BillboardGui,
  label = TextLabel,
  conn = connection
  }
end
function t2.value8.removePlayerSpeedGui(p29)
  local v272 = t2.value8.playerSpeedGuis[p29]

  if v272 then
    if v272.conn then
      v272.conn:Disconnect()
    end

    if v272.gui then
      v272.gui:Destroy()
    end

    t2.value8.playerSpeedGuis[p29] = nil
  end
end
function t2.value8.updatePlayerSpeed(p30)
  if not t2.value8.showPlayerSpeeds then
    return
  end

  local v274 = t2.value8.playerSpeedGuis[p30]

  if not v274 then
    return
  end

  local Character = p30.Character

  if not Character then
    t2.value8.removePlayerSpeedGui(p30)

    return
  end

  local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

  if not HumanoidRootPart then
    return
  end

  local Magnitude = Vector3.new(HumanoidRootPart.Velocity.X, 0, HumanoidRootPart.Velocity.Z).Magnitude

  v274.label.Text = string.format("%.1f", Magnitude)
end
function t2.value8.updateAllPlayerSpeeds()
  for k, _ in pairs(t2.value8.playerSpeedGuis) do
    t2.value8.updatePlayerSpeed(k)
  end
end
function t2.value8.startPlayerSpeedUpdates()
  if t2.value8.playerSpeedUpdateConn then
    return
  end

  t2.value8.playerSpeedUpdateConn = t2.value4.Heartbeat:Connect(function()
    t2.value8.updateAllPlayerSpeeds()
  end)
end
function t2.value8.stopPlayerSpeedUpdates()
  if t2.value8.playerSpeedUpdateConn then
    t2.value8.playerSpeedUpdateConn:Disconnect()
    t2.value8.playerSpeedUpdateConn = nil
  end
end
function t2.value8.togglePlayerSpeeds(p31)
  t2.value8.showPlayerSpeeds = p31

  if p31 then
    for _, player in ipairs(t2.value1:GetPlayers()) do
      if player ~= t2.value7 then
        t2.value8.createPlayerSpeedGui(player)
      end
    end

    t2.value8.startPlayerSpeedUpdates()

    return
  end

  for k, _ in pairs(t2.value8.playerSpeedGuis) do
    t2.value8.removePlayerSpeedGui(k)
  end

  t2.value8.stopPlayerSpeedUpdates()
end
function t2.value8.addESP(p32)
  if p32 == t2.value7 then
    return
  end

  if t2.value8.espList[p32] then
    return
  end

  local Character = p32.Character

  if not Character then
    return
  end

  local Head = Character:FindFirstChild("Head")

  if not Head then
    return
  end

  local BillboardGui = Instance.new("BillboardGui")

  BillboardGui.Size = UDim2.new(0, 120, 0, 30)
  BillboardGui.StudsOffset = Vector3.new(0, 2.8, 0)
  BillboardGui.AlwaysOnTop = true
  BillboardGui.Adornee = Head
  BillboardGui.Parent = Head

  local TextLabel = Instance.new("TextLabel", BillboardGui)

  TextLabel.Size = UDim2.new(1, 0, 1, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = p32.Name
  TextLabel.TextColor3 = t2.value15
  TextLabel.Font = Enum.Font.GothamBold
  TextLabel.TextScaled = true
  TextLabel.TextStrokeTransparency = 0
  TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

  local Highlight = Instance.new("Highlight")

  Highlight.Adornee = Character
  Highlight.FillTransparency = 1
  Highlight.OutlineTransparency = 0.3
  Highlight.OutlineColor = t2.value9
  Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  Highlight.Parent = Character
  t2.value8.espList[p32] = {
  nameBB = BillboardGui,
  highlight = Highlight
  }
end
function t2.value8.removeESP(p33)
  local v292 = t2.value8.espList[p33]

  if v292 then
    if v292.nameBB then
      v292.nameBB:Destroy()
    end

    if v292.highlight then
      v292.highlight:Destroy()
    end

    t2.value8.espList[p33] = nil
  end
end
function t2.value8.clearESP()
  for k, _ in pairs(t2.value8.espList) do
    t2.value8.removeESP(k)
  end
end
function t2.value8.toggleESP(p34)
  t2.value8.playerESPEnabled = p34

  if p34 then

    for v298, v299 in ipairs(t2.value1:GetPlayers()) do

      if v299 ~= t2.value7 then
        t2.value8.addESP(v299)
      end
    end
    if not t2.value8._espPlayerAdded then
      t2.value8._espPlayerAdded = t2.value1.PlayerAdded:Connect(function(player)
        if player ~= t2.value7 and t2.value8.playerESPEnabled then
          player.CharacterAdded:Connect(function()
            task.wait(0.5)
            t2.value8.addESP(player)
          end)

          if player.Character then
            task.wait(0.5)
            t2.value8.addESP(player)
          end
        end
      end)
      t2.value8.trackConn(t2.value8._espPlayerAdded)
    end
    if not t2.value8._espPlayerRemoved then
      t2.value8._espPlayerRemoved = t2.value1.PlayerRemoving:Connect(function(player)
        t2.value8.removeESP(player)
      end)
      t2.value8.trackConn(t2.value8._espPlayerRemoved)

      return
    end
  else
  t2.value8.clearESP()

  if t2.value8._espPlayerAdded then
    t2.value8._espPlayerAdded:Disconnect()
    t2.value8._espPlayerAdded = nil
  end

  if t2.value8._espPlayerRemoved then
    t2.value8._espPlayerRemoved:Disconnect()
    t2.value8._espPlayerRemoved = nil
  end
end
end
t2.value8.headIndicator = nil
function t2.value8.setupHeadIndicator(p35)
  local Head = p35:WaitForChild("Head", 5)

  if not Head then
    return
  end

  if Head:FindFirstChild("MoveeHeadIndicator") then
    Head.MoveeHeadIndicator:Destroy()
  end

  local BillboardGui = Instance.new("BillboardGui", Head)

  BillboardGui.Name = "MoveeHeadIndicator"
  BillboardGui.Size = UDim2.new(0, 250, 0, 90)
  BillboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
  BillboardGui.AlwaysOnTop = true
  BillboardGui.Parent = Head

  local _Instance = Instance
  local value9 = t2.value9
  local v305 = _Instance.new("TextLabel", BillboardGui)

  v305.Name = "RagdollTimer"
  v305.Size = UDim2.new(1, 0, 0.33, 0)
  v305.Position = UDim2.new(0, 0, 0, 0)
  v305.BackgroundTransparency = 1
  v305.Text = ""
  v305.TextColor3 = value9
  v305.Font = Enum.Font.GothamBold
  v305.TextScaled = true
  v305.TextStrokeTransparency = 0

  local TextLabel = Instance.new("TextLabel", BillboardGui)

  TextLabel.Name = "Discord"
  TextLabel.Size = UDim2.new(1, 0, 0.3, 0)
  TextLabel.Position = UDim2.new(0, 0, 0.3, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = "https://discord.gg/TBBAUZu8cW"
  TextLabel.TextColor3 = value9
  TextLabel.Font = Enum.Font.GothamBold
  TextLabel.TextScaled = true
  TextLabel.TextStrokeTransparency = 0

  local Frame = Instance.new("Frame", BillboardGui)

  Frame.Name = "Divider"
  Frame.Size = UDim2.new(0.72, 0, 0, 2)
  Frame.Position = UDim2.new(0.14, 0, 0.635, 0)
  Frame.BackgroundColor3 = value9
  Frame.BackgroundTransparency = 0.15
  Frame.BorderSizePixel = 0
  Frame.ZIndex = 2
  Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)

  local TextLabel3 = Instance.new("TextLabel", BillboardGui)

  TextLabel3.Name = "Speed"
  TextLabel3.Size = UDim2.new(1, 0, 0.3, 0)
  TextLabel3.Position = UDim2.new(0, 0, 0.66, 0)
  TextLabel3.BackgroundTransparency = 1
  TextLabel3.Text = "0.0"
  TextLabel3.TextColor3 = value9
  TextLabel3.Font = Enum.Font.GothamBold
  TextLabel3.TextScaled = true
  TextLabel3.TextStrokeTransparency = 0
  t2.value8.headIndicator = {
  bb = BillboardGui,
  discord = TextLabel,
  speed = TextLabel3,
  ragdollTimer = v305,
  divider = Frame
  }
  t2.value8.updateHeadTheme()
end
function t2.value8.updateHeadTheme()
  if not t2.value8.headIndicator then
    return
  end

  local value9 = t2.value9

  if t2.value8.headIndicator.discord then
    t2.value8.headIndicator.discord.TextColor3 = value9
  end

  if t2.value8.headIndicator.speed then
    t2.value8.headIndicator.speed.TextColor3 = value9
  end

  if t2.value8.headIndicator.ragdollTimer then
    t2.value8.headIndicator.ragdollTimer.TextColor3 = value9
  end

  if t2.value8.headIndicator.divider then
    t2.value8.headIndicator.divider.BackgroundColor3 = value9
  end
end
t2.value23 = nil
function t2.value8.startHeadSpeedUpdates()
  if t2.value23 then
    return
  end

  t2.value23 = t2.value4.Heartbeat:Connect(function()
    if t2.value7.Character and (t2.value8.headIndicator and t2.value8.headIndicator.speed) then
      local v1361 = if not (t2.value8.autoLeftEnabled or t2.value8.autoRightEnabled) then t2.value8.getActiveMoveSpeed() else t2.value8.NS

        t2.value8.headIndicator.speed.Text = string.format("%.1f", v1361)
      end
    end)
  end
  function t2.value8.stopHeadSpeedUpdates()
    if t2.value23 then
      t2.value23:Disconnect()
    end
  end
  function t2.value8.buildStatusUI()
    if t2.value8.statusPerfConn then
      pcall(function()
        t2.value8.statusPerfConn:Disconnect()
      end)
      t2.value8.statusPerfConn = nil
    end
    if t2.value8.statusDragConn then
      pcall(function()
        t2.value8.statusDragConn:Disconnect()
      end)
      t2.value8.statusDragConn = nil
    end
    if t2.value8.statusGui then
      pcall(function()
        t2.value8.statusGui:Destroy()
      end)
      t2.value8.statusGui = nil
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StealProgressWindow"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 5
    local v311 = false
    if gethui then
      v311 = pcall(function()
        ScreenGui.Parent = gethui()
      end)
    elseif syn and syn.protect_gui then
      v311 = pcall(function()
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
      end)
    end
    if not v311 then
      ScreenGui.Parent = t2.value7:WaitForChild("PlayerGui")
    end
    for _, child in ipairs(ScreenGui.Parent:GetChildren()) do
      local v314 = child
      local v315 = v314 ~= ScreenGui

      if v315 then
        v315 = v314:IsA("ScreenGui")

        if v315 then
          v315 = v314.Name == ScreenGui.Name or (v314.Name == "VynxStatusUI" or v314.Name == "K7_StatusUI")
        end
      end

      if v315 then
        pcall(function()
          v314:Destroy()
        end)
      end
    end
    local value9 = t2.value9
    local v317 = math.clamp(tonumber(t2.value8.stealBarSize) or 450, 220, 760)
    local v318 = math.clamp(tonumber(t2.value8.stealBarScale) or 0.6, 0.4, 1.5)
    local UIScale = Instance.new("UIScale")
    UIScale.Scale = v318
    UIScale.Parent = ScreenGui
    local Frame = Instance.new("Frame")
    Frame.Name = "StealBar"
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Size = UDim2.fromOffset(v317, 58)
    Frame.Position = UDim2.new(0.5, 0, 0.12, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.06
    Frame.BorderSizePixel = 0
    Frame.Active = t2.value8.uiLocked ~= true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 30)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = t2.value9
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.3
    UIStroke.Parent = Frame
    local Frame2 = Instance.new("Frame")
    Frame2.Name = "StealProgress"
    Frame2.Size = UDim2.new(0.62, 0, 1, -14)
    Frame2.Position = UDim2.new(0, 7, 0, 7)
    Frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame2.BackgroundTransparency = 0.02
    Frame2.BorderSizePixel = 0
    Frame2.ClipsDescendants = true
    Frame2.Parent = Frame
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 24)
    local UIStroke2 = Instance.new("UIStroke")
    UIStroke2.Color = t2.value10
    UIStroke2.Thickness = 1.25
    UIStroke2.Transparency = 0.25
    UIStroke2.Parent = Frame2
    local Frame3 = Instance.new("Frame")
    Frame3.Name = "Fill"
    Frame3.Size = UDim2.new(0, 0, 1, 0)
    Frame3.BackgroundColor3 = value9
    Frame3.BackgroundTransparency = 0.35
    Frame3.BorderSizePixel = 0
    Frame3.Parent = Frame2
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 24)
    t2.value8.statusFill = Frame3
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "StealTitle"
    TextLabel.Size = UDim2.new(0.58, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 28, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "STEAL"
    TextLabel.TextColor3 = t2.value15
    TextLabel.TextSize = 15
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Frame2
    t2.value8.statusTitleLbl = TextLabel
    t2.value8.statusPctLbl = nil
    local TextLabel4 = Instance.new("TextLabel")
    TextLabel4.Name = "PctOnBar"
    TextLabel4.Size = UDim2.new(0, 52, 0, 1)
    TextLabel4.Position = UDim2.new(1, -62, 0, 0)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = "0%"
    TextLabel4.TextColor3 = t2.value15
    TextLabel4.TextSize = 15
    TextLabel4.Font = Enum.Font.Gotham
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel4.ZIndex = 2
    TextLabel4.Parent = Frame2
    t2.value8.statusBarPctLbl = TextLabel4
    local TextLabel5 = Instance.new("TextLabel")
    TextLabel5.Name = "Performance"
    TextLabel5.Size = UDim2.new(0.36, -12, 1, 0)
    TextLabel5.Position = UDim2.new(0.64, 8, 0, 0)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = "FPS:-- | PING:--ms"
    TextLabel5.TextColor3 = t2.value15
    TextLabel5.TextSize = 14
    TextLabel5.Font = Enum.Font.Gotham
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel5.TextTruncate = Enum.TextTruncate.AtEnd
    TextLabel5.Parent = Frame
    t2.value8.statusFpsLbl = TextLabel5
    local TextLabel6 = Instance.new("TextLabel")
    TextLabel6.Name = "RadiusLbl"
    TextLabel6.Visible = false
    TextLabel6.Size = UDim2.new(0, 1, 0, 1)
    TextLabel6.BackgroundTransparency = 1
    TextLabel6.Text = tostring(t2.value8.getActiveStealRadius())
    TextLabel6.Parent = Frame
    t2.value8.statusRadiusLbl = TextLabel6
    t2.value8.statusDot = nil
    t2.value8.statusRadiusMarker = nil
    t2.value8.statusRadiusMarkerLbl = nil
    function t2.value8.updateRadiusMarker()
      if t2.value8.statusRadiusLbl then
        t2.value8.statusRadiusLbl.Text = tostring(t2.value8.getActiveStealRadius())
      end
    end
    t2.value8.statusGui = ScreenGui
    t2.value8.statusMain = Frame
    function t2.value8.applyStatusUILock()
      if t2.value8.statusMain then
        t2.value8.statusMain.Active = t2.value8.uiLocked ~= true
      end
    end
    local u329 = false
    local inputPosition
    local FramePosition
    Frame.InputBegan:Connect(function(input)
      if t2.value8.uiLocked then
        return
      end

      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        u329 = true
        inputPosition = input.Position
        FramePosition = Frame.Position
        input.Changed:Connect(function()
          if input.UserInputState == Enum.UserInputState.End then
          u329 = false
        end
      end)
    end
  end)
  t2.value8.statusDragConn = t2.value3.InputChanged:Connect(function(input)
    if not u329 or t2.value8.uiLocked then
      if not t2.value8.uiLocked then
      end

      return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
      local v1364 = input.Position - inputPosition

      Frame.Position = UDim2.new(FramePosition.X.Scale, FramePosition.X.Offset + v1364.X, FramePosition.Y.Scale, FramePosition.Y.Offset + v1364.Y)
    end
  end)
  local n1 = 0
  local n2 = 0
  t2.value8.statusPerfConn = t2.value4.RenderStepped:Connect(function(dt)
    if not t2.value8.statusFpsLbl or not t2.value8.statusFpsLbl.Parent then
      return
    end

    n1 += 1
    n2 += dt

    if n2 < 0.5 then
      return
    end

    local v1366 = math.floor(n1 / math.max(n2, 0.001) + 0.5)
    local n3 = 0

    pcall(function()
      local v1863 = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]

      if v1863 then
        n3 = tonumber(v1863:GetValue()) or 0
      end
    end)
    t2.value8.statusFpsLbl.Text = string.format("FPS:%d | PING:%dms", v1366, (math.floor(n3 + 0.5)))
  end)
  pcall(function()
    t2.value8.applyStealBarTheme(t2.value9)
    t2.value8.applyStatusUILock()
  end)
end
function t2.value8.updateStealProgress(p36, p37)
  local v336 = math.clamp(p36 or 0, 0, 1)
  local v337 = math.floor(v336 * 100 + 0.5)
  local value9 = t2.value9

  if t2.value8.statusFill then
    t2.value8.statusFill.Size = UDim2.fromScale(v336, 1)
    t2.value8.statusFill.BackgroundColor3 = value9
  end

  if t2.value8.statusPctLbl then
    if type(p37) == "string" and p37 ~= "" then
      t2.value8.statusPctLbl.Text = p37
    elseif v336 > 0 then
      t2.value8.statusPctLbl.Text = v337 .. "%"
    else
    local v339 = t2.value8.Steal and t2.value8.Steal.AutoStealEnabled

    t2.value8.statusPctLbl.Text = not v339 and "IDLE" or "READY"
  end
end

if t2.value8.statusBarPctLbl then
  t2.value8.statusBarPctLbl.Text = string.format("%d%%", v337)
end

if t2.value8.statusDot then
  t2.value8.statusDot.BackgroundColor3 = value9
end
end
function t2.value8.updateStatusRadius()
  if t2.value8.statusRadiusLbl then
    t2.value8.statusRadiusLbl.Text = "Radius: " .. tostring(t2.value8.getActiveStealRadius())
  end

  if t2.value8.updateRadiusMarker then
    t2.value8.updateRadiusMarker()
  end
end
if not fireproximityprompt then
  fireproximityprompt = getgenv and getgenv().fireproximityprompt or (genv and genv().fireproximityprompt or function(p38)
    local u341 = p38
    pcall(function()
      u341:InputHoldBegin()
      task.wait(0.05)
      u341:InputHoldEnd()
    end)
  end)
end
t2.value24 = nil
function t2.value24(p39)
  local Plots = workspace:FindFirstChild("Plots")

  if not Plots then
    return false
  end

  local p39_2 = Plots:FindFirstChild(p39)

  if not p39_2 then
    return false
  end

  local PlotSign = p39_2:FindFirstChild("PlotSign")

  if PlotSign then
    local YourBase = PlotSign:FindFirstChild("YourBase")

    if YourBase and YourBase:IsA("BillboardGui") then
      return YourBase.Enabled == true
    end
  end

  return false
end
function t2.value25(p40)
  if not p40 or not p40:IsA("Model") then
    return
  end

  if t2.value24(p40.Name) then
    return
  end

  local AnimalPodiums = p40:FindFirstChild("AnimalPodiums")

  if not AnimalPodiums then
    return
  end

  local GetChildren = AnimalPodiums.GetChildren

  for _, v in ipairs(GetChildren(AnimalPodiums)) do
    if v:IsA("Model") and v:FindFirstChild("Base") then
      local v383 = p40.Name .. "_" .. v.Name

      for _, v2 in ipairs(t2.value8.animalCache) do
        if v383 == v2.uid then
          return
        end
      end

      local insert = table.insert
      local animalCache = t2.value8.animalCache
      local vName = v.Name
      local p40Name = p40.Name
      local vName2 = v.Name
      local Position = v:GetPivot().Position

      insert(animalCache, {
      name = vName,
      plot = p40Name,
      slot = vName2,
      worldPosition = Position,
      uid = v383
      })
    end
  end
end
function t2.value26(p41)
  if not p41 then
    return nil
  end
  local v360 = t2.value8.promptCache[p41.uid]
  if v360 and v360.Parent then
    return v360
  end
  local Plots = workspace:FindFirstChild("Plots")
  if not Plots then
    return nil
  end
  local p41plot = Plots:FindFirstChild(p41.plot)
  if not p41plot then
    return nil
  end
  local AnimalPodiums = p41plot:FindFirstChild("AnimalPodiums")
  if not AnimalPodiums then
    return nil
  end
  local p41slot = AnimalPodiums:FindFirstChild(p41.slot)
  if not p41slot then
    return nil
  end
  local Base = p41slot:FindFirstChild("Base")
  if not Base then
    return nil
  end
  local Spawn = Base:FindFirstChild("Spawn")
  if not Spawn then
    return nil
  end
  local PromptAttachment = Spawn:FindFirstChild("PromptAttachment")
  local v368
  if PromptAttachment then
    for _, child in ipairs(PromptAttachment:GetChildren()) do
      if child:IsA("ProximityPrompt") then
        v368 = child

        break
      end
    end
  end
  if not v368 then
    for _, descendant in ipairs(Spawn:GetDescendants()) do
      if descendant:IsA("ProximityPrompt") then
        v368 = descendant

        break
      end
    end
  end
  if v368 then
    t2.value8.promptCache[p41.uid] = v368
  end

  return v368
end
function t2.value27()
  local Character = t2.value7.Character
  if not Character then
    return nil
  end
  local v343 = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("UpperTorso")
  if not v343 then
    return nil
  end
  local v344
  local n4 = 1e999
  for _, v in ipairs(t2.value8.animalCache) do
    if not t2.value24(v.plot) and v.worldPosition then
      local Magnitude = (v343.Position - v.worldPosition).Magnitude

      if Magnitude < n4 then
        n4 = Magnitude
        v344 = v
      end
    end
  end

  return v344, n4
end
function t2.value28(p42)
  if t2.value8.stealCache[p42] then
    return
  end

  local t100 = {
  holdCallbacks = {},
  triggerCallbacks = {},
  ready = true
  }
  local ok, result = pcall(getconnections, p42.PromptButtonHoldBegan)

  if ok then
    ok = type(result) == "table"
  end

  if ok then
    for _, v in ipairs(result) do
      if type(v.Function) == "function" then
        table.insert(t100.holdCallbacks, v.Function)
        end
      end
    end

    local ok2, result2 = pcall(getconnections, p42.Triggered)

    if ok2 then
      ok2 = type(result2) == "table"
    end

    if ok2 then
      for _, v in ipairs(result2) do
        if type(v.Function) == "function" then
          table.insert(t100.triggerCallbacks, v.Function)
          end
        end
      end

      if #t100.holdCallbacks > 0 or #t100.triggerCallbacks > 0 then
        t2.value8.stealCache[p42] = t100
      end
    end
    function t2.value29(p43, _)
      local v394 = t2.value8.stealCache[p43]

      if not v394 or not v394.ready then
        return false
      end

      v394.ready = false
      t2.value8.isStealing = true
      t2.value8.stealStartTime = tick()
      t2.value8.updateStealProgress(0.1)

      if t2.value8.progressConn then
        t2.value8.progressConn:Disconnect()
      end

      t2.value8.progressConn = t2.value4.Heartbeat:Connect(function()
        if not t2.value8.isStealing then
          t2.value8.progressConn:Disconnect()
          t2.value8.progressConn = nil

          return
        end

        local v1368 = math.clamp((tick() - t2.value8.stealStartTime) / t2.value8.Steal.StealDuration, 0, 1)

        t2.value8.updateStealProgress(v1368)
      end)
      task.spawn(function()

        for v1371, v1372 in ipairs(v394.holdCallbacks) do

          task.spawn(v1372)
        end
        local n5 = 0
        while n5 < t2.value8.Steal.StealDuration do
          n5 += task.wait()
        end
        for _, v in ipairs(v394.triggerCallbacks) do
          task.spawn(v)
        end
        task.wait(0.01)
        if t2.value8.progressConn then
          t2.value8.progressConn:Disconnect()
          t2.value8.progressConn = nil
        end
        t2.value8.isStealing = false
        t2.value8.updateStealProgress(0)
        v394.ready = true
      end)

      return true
    end
    function t2.value8.startNormalSteal()
      if t2.value8.stealConn then
        return
      end

      t2.value8.stealConn = t2.value4.Heartbeat:Connect(function()
        if not t2.value8.Steal.AutoStealEnabled or (t2.value8.stealMode ~= "Normal" and t2.value8.stealMode ~= "V1" or t2.value8.isStealing) then
          return
        end

        local v1376, v1377 = t2.value27()

        if not v1376 then
          return
        end

        if v1377 > t2.value8.getActiveStealRadius() then
          return
        end

        local v1378 = t2.value8.promptCache[v1376.uid]

        if not v1378 or not v1378.Parent then
          v1378 = t2.value26(v1376)
        end

        if v1378 then
          t2.value28(v1378)
          t2.value29(v1378, v1376.name)
        end
      end)
    end
    function t2.value8.stopNormalSteal()
      if t2.value8.stealConn then
        t2.value8.stealConn:Disconnect()
        t2.value8.stealConn = nil
      end

      t2.value8.isStealing = false

      if t2.value8.progressConn then
        t2.value8.progressConn:Disconnect()
        t2.value8.progressConn = nil
      end

      t2.value8.updateStealProgress(0)
    end
    t2.value30 = t2.value8.Semi
    if t2.value30.conn then
      pcall(function()
        t2.value30.conn:Disconnect()
      end)
      t2.value30.conn = nil
    end
    t2.value30.enabled = false
    t2.value30.holdMin = tonumber(t2.value30.holdMin) or 1.3
    t2.value30.holdMax = tonumber(t2.value30.holdMax) or 2.6
    t2.value30.entryDelay = tonumber(t2.value30.entryDelay) or 0.3
    t2.value30.cooldown = tonumber(t2.value30.cooldown) or 0.05
    t2.value30.primeRange = tonumber(t2.value30.primeRange) or 80
    t2.value30.radius = math.min(tonumber(t2.value30.radius) or 10, 10)

    local value30 = t2.value30
    local plotSync = t2.value30.plotSync
    if not plotSync then
      plotSync = {
      caches = {},
      connections = {}
      }
    end
    value30.plotSync = plotSync
    t2.value30.animals = t2.value30.animals or {}
    t2.value30.promptCache = t2.value30.promptCache or {}
    t2.value30.internalCache = t2.value30.internalCache or {}
    t2.value30.state = t2.value30.state or {
    active = false,
    startTime = 0,
    phase = "idle",
    label = "",
    lastResult = "",
    lastResultTime = 0
    }
    function t2.value31(p45, p46)
      local v400 = math.clamp(tonumber(p45) or 0, 0, 1)
      local v401 = math.floor(v400 * 100 + 0.5)
      local v402
      if type(p46) == "string" and p46 ~= "" then
        v402 = string.upper(p46)

        if v400 > 0 then
          v402 ..= " " .. tostring(v401) .. "%"
        end
      end
      t2.value8.updateStealProgress(v400, v402)
    end
    function t2.value32()
      t2.value8.updateStealProgress(0)
    end
    function t2.value33()
      local Character = t2.value7.Character

      return Character and Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("UpperTorso") or nil
    end
    function t2.value34(p47)
      if typeof(p47) == "table" then
        return p47
      end

      local t101 = {}

      for match in string.gmatch(tostring(p47), "[^%.]+") do
        local v406 = match

        table.insert(t101, tonumber(v406) or v406)
      end

      return t101
    end
    t2.value35 = nil
    function t2.value35(p48, p49)
      local v410
      local v411
      for _, v in ipairs(t2.value34(p48)) do
        v411 = p49
        v410 = v

        if p49 then
          p49 = p49[v]
        end

        p49 = p49 or nil
      end

      return p49, v411, v410
    end
    t2.value36 = nil
    function t2.value36(p50, p51)
      local v416 = t2.value30.plotSync.caches[p50]

      if typeof(v416) ~= "table" then
        return
      end

      local v417 = p51[1]
      local v418 = p51[2]
      local v419 = p51[3]
      local v420 = p51[4]
      local v421, v422, v423 = t2.value35(v417, v416)

      if v418 == "Changed" then
        if v422 ~= nil then
          v422[v423] = v419

          return
        end
      elseif v418 == "ArrayInsert" then
        if v421 ~= nil then
          table.insert(v421, v420, v419)

          return
        end
      elseif v418 == "ArrayRemoved" then
        if v421 ~= nil then
          table.remove(v421, v420)

          return
        end
      elseif v418 == "DictionaryInsert" then
        if v421 ~= nil then
          v421[v420] = v419

          return
        end
      elseif v418 == "DictionaryRemoved" and v421 ~= nil then
        v421[v420] = nil
      end
    end
    function t2.value37(p52, p53, p54)
      if t2.value30.plotSync.connections[p52] then
        return
      end

      local str = tostring(p52.Name)

      if not p53:FindFirstChild(str) then
        return
      end

      if p54 and t2.value30.plotSync.caches[str] == nil then
        local ok, result = pcall(function()
          return p54:InvokeServer(str)
        end)
        local caches = t2.value30.plotSync.caches

        if ok then
          ok = typeof(result) == "table"
        end

        caches[str] = ok and result or {}
      elseif t2.value30.plotSync.caches[str] == nil then
        t2.value30.plotSync.caches[str] = {}
      end

      t2.value30.plotSync.connections[p52] = p52.OnClientEvent:Connect(function(p55)
        for _, v in ipairs(p55) do
          t2.value36(str, v)
        end
      end)
    end
    function t2.value8.initSemiSync()
      if t2.value30.syncReady then
        return true
      end

      return pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")

        t2.value30.packages = ReplicatedStorage:WaitForChild("Packages", 10)
        t2.value30.datas = ReplicatedStorage:WaitForChild("Datas", 10)
        t2.value30.plots = workspace:WaitForChild("Plots", 10)

        if not t2.value30.packages or (not t2.value30.datas or not t2.value30.plots) then
          return
        end

        t2.value30.animalsData = require(t2.value30.datas:WaitForChild("Animals", 10))

        local Synchronizer = t2.value30.packages:WaitForChild("Synchronizer", 10)

        t2.value30.channelFolder = Synchronizer:WaitForChild("Channel", 10)
        t2.value30.routeRemote = Synchronizer:WaitForChild("CommunicationRoute", 10)
        t2.value30.requestData = Synchronizer:FindFirstChild("RequestData")

        for _, child in ipairs(t2.value30.channelFolder:GetChildren()) do
          if child:IsA("RemoteEvent") then
            t2.value37(child, t2.value30.plots, t2.value30.requestData)
          end
        end

        t2.value30.channelFolder.ChildAdded:Connect(function(child)
          if child:IsA("RemoteEvent") then
            t2.value37(child, t2.value30.plots, t2.value30.requestData)
          end
        end)
        t2.value30.routeRemote.OnClientEvent:Connect(function(p56)
          for _, v in ipairs(p56) do
            local v1868 = v[1]
            local str = tostring(v[2])

            if t2.value30.plots and t2.value30.plots:FindFirstChild(str) then
              if v1868 == "ListenerAdded" then
                local v1870 = t2.value30.channelFolder and t2.value30.channelFolder:FindFirstChild(str)

                if v1870 and v1870:IsA("RemoteEvent") then
                  t2.value37(v1870, t2.value30.plots, t2.value30.requestData)
                end
              elseif v1868 == "ListenerRemoved" then
                for k, v4 in pairs(t2.value30.plotSync.connections) do
                  local v1873 = k

                  if str == tostring(v1873.Name) then
                    pcall(function()
                      v4:Disconnect()
                    end)
                    t2.value30.plotSync.connections[v1873] = nil
                    t2.value30.plotSync.caches[str] = nil

                    break
                  end
                end
              end
            end
          end
        end)
        t2.value30.syncReady = true
      end) and t2.value30.syncReady == true
    end
    function t2.value38(p57)
      local v432 = p57 and p57:FindFirstChild("PlotSign")
      local v433 = v432 and (v432:FindFirstChild("SurfaceGui") and v432.SurfaceGui:FindFirstChild("Frame"))
      local v434 = v433 and v433:FindFirstChild("TextLabel")

      if not v434 or v434.Text == "Empty Base" then
        return nil
      end

      return v434.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end
    local function v122(p58)
      if not p58 or (not p58.plot or not t2.value30.plots) then
        return false
      end

      local p58plot = t2.value30.plots:FindFirstChild(p58.plot)

      if not p58plot then
        return false
      end

      local v437 = t2.value38(p58plot)

      return v437 == t2.value7.DisplayName or v437 == t2.value7.Name
    end
    t2.value39 = nil
    function t2.value39(p59)
      local plots = t2.value30.plots

      if plots then
        plots = t2.value30.plots:FindFirstChild(p59.plot)
      end

      local v397 = plots and plots:FindFirstChild("AnimalPodiums")

      if v397 then
        v397 = v397:FindFirstChild(p59.slot)
      end

      return v397 or nil
    end
    function t2.value40(p60)
      local v439 = t2.value39(p60)

      return v439 and v439:GetPivot().Position or nil
    end
    function t2.value41(p61)
      if not p61 then
        return nil
      end

      local v441 = t2.value30.promptCache[p61.uid]

      if v441 and v441.Parent then
        return v441
      end

      local v442 = t2.value39(p61)
      local v443 = v442 and v442:FindFirstChild("Base")
      local v444 = v443 and v443:FindFirstChild("Spawn")
      local v445 = v444 and v444:FindFirstChild("PromptAttachment")

      if not v445 then
        return nil
      end

      for _, child in ipairs(v445:GetChildren()) do
        if child:IsA("ProximityPrompt") then
          t2.value30.promptCache[p61.uid] = child

          return child
        end
      end

      return nil
    end
    function t2.value8.scanAllPlotsSemi()
      if not t2.value8.initSemiSync() then
        return 0
      end

      local t102 = {}

      for _, child in ipairs(t2.value30.plots:GetChildren()) do
        local v454 = t2.value30.plotSync.caches[child.Name]
        local v455 = v454 and v454.AnimalList

        if typeof(v455) == "table" then
          for k, v in pairs(v455) do
            local v458 = k

            if type(v) == "table" then
              local Index = v.Index
              local v460 = t2.value30.animalsData and t2.value30.animalsData[Index]

              if v460 then
                local insert = table.insert
                local v462 = v460.DisplayName or Index
                local childName = child.Name
                local str = tostring(v458)
                local v465 = child.Name .. "_" .. tostring(v458)

                insert(t102, {
                name = v462,
                plot = childName,
                slot = str,
                uid = v465
                })
              end
            end
          end
        end
      end

      t2.value30.animals = t102

      return #t102
    end
    local function v123()
      local v466 = t2.value33()
      if not v466 then
        return nil
      end
      local v467
      local n6 = 1e999
      for _, v in ipairs(t2.value30.animals) do
        if not v122(v) then
          local v471 = t2.value40(v)
          local v472 = v471 and (v466.Position - v471).Magnitude or 1e999

          if v472 <= (t2.value30.primeRange or 80) and v472 < n6 then
            v467 = v
            n6 = v472
          end
        end
      end

      return v467
    end
    function t2.value42(p62)
      if t2.value30.internalCache[p62] then
        return
      end

      local t103 = {
      holdCallbacks = {},
      triggerCallbacks = {},
      ready = true
      }
      local ok, result = pcall(getconnections, p62.PromptButtonHoldBegan)

      if ok then
        ok = type(result) == "table"
      end

      if ok then
        for _, v in ipairs(result) do
          if type(v.Function) == "function" then
            table.insert(t103.holdCallbacks, v.Function)
            end
          end
        end

        local ok3, result3 = pcall(getconnections, p62.Triggered)

        if ok3 then
          ok3 = type(result3) == "table"
        end

        if ok3 then
          for _, v in ipairs(result3) do
            if type(v.Function) == "function" then
              table.insert(t103.triggerCallbacks, v.Function)
              end
            end
          end

          if #t103.holdCallbacks > 0 or #t103.triggerCallbacks > 0 then
            t2.value30.internalCache[p62] = t103
          end
        end
        function t2.value43(p63, p64)
          if not p63 or (not p63.Parent or not p64) then
            return false
          end

          t2.value42(p63)

          local v485 = t2.value30.internalCache[p63]

          if not v485 or not v485.ready then
            return false
          end

          v485.ready = false
          t2.value30.state.active = true
          t2.value30.state.startTime = tick()
          t2.value30.state.phase = "holding"
          t2.value30.state.label = p64.name or "Animal"
          t2.value8.isStealing = true
          t2.value8.stealStartTime = t2.value30.state.startTime
          task.spawn(function()
            local startTime = t2.value30.state.startTime
            for v1389, v1390 in ipairs(v485.holdCallbacks) do

              local v1391 = v1390

              task.spawn(function()
                pcall(v1391)
              end)
            end
            while t2.value30.enabled and t2.value8.stealMode == "Semi" or t2.value8.stealMode == "V2" and tick() - startTime < (t2.value30.holdMin or 1.3) do
              local v1392 = tick() - startTime

              t2.value30.state.phase = "holding"
              t2.value31(v1392 / (t2.value30.holdMax or 2.6), "HOLDING " .. tostring(t2.value30.state.label))
              task.wait()
            end
            t2.value30.state.phase = "waitingRange"
            local v1393 = p64
            local v1394 = t2.value33()
            local v1395 = t2.value40(v1393)
            if v1394 then
              v1394 = v1395 and (v1394.Position - v1395).Magnitude
            end
            local v1396 = (v1394 or 1e999) <= (tonumber(t2.value30.radius) or 10)
            local v1397 = false
            while t2.value30.enabled and t2.value8.stealMode == "Semi" or t2.value8.stealMode == "V2" and p63.Parent do
              local v1398 = tick() - startTime

              if v1398 > (t2.value30.holdMax or 2.6) then
                break
              end

              t2.value31(v1398 / (t2.value30.holdMax or 2.6), "MOVE CLOSER " .. tostring(t2.value30.state.label))

              local v1399 = p64
              local v1400 = t2.value33()
              local v1401 = t2.value40(v1399)

              if v1400 then
                v1400 = v1401 and (v1400.Position - v1401).Magnitude
              end

              if (v1400 or 1e999) <= (tonumber(t2.value30.radius) or 10) then
                if not v1396 then
                  task.wait(t2.value30.entryDelay or 0.3)
                end

                if t2.value30.enabled and t2.value8.stealMode == "Semi" or t2.value8.stealMode == "V2" then
                  for _, v in ipairs(v485.triggerCallbacks) do
                    local v1404 = v

                    task.spawn(function()
                      pcall(v1404)
                    end)
                  end

                  pcall(function()
                    if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then
                      _G.AutoCarrySpeed.WatchPickup(1.25)
                    end
                  end)
                  v1397 = true
                end

                break
              end

              task.wait()
            end
            t2.value30.state.lastResult = v1397 and "Stole " .. tostring(t2.value30.state.label) or "Missed window: " .. tostring(t2.value30.state.label)
            t2.value30.state.active = false
            t2.value30.state.phase = "idle"
            t2.value30.state.lastResultTime = tick()
            if v1397 then
              t2.value31(1, "STOLE " .. tostring(t2.value30.state.label))
            else
            t2.value31(0, t2.value30.state.lastResult)
          end
          task.wait(t2.value30.cooldown or 0.05)
          v485.ready = true
          t2.value8.isStealing = false
          t2.value32()
        end)

        return true
      end
      function t2.value8.stopSemiSteal()
        t2.value30.enabled = false

        if t2.value30.conn then
          t2.value30.conn:Disconnect()
          t2.value30.conn = nil
        end

        t2.value30.state.active = false
        t2.value30.state.phase = "idle"
        t2.value8.isStealing = false
        t2.value32()
      end
      function t2.value8.startSemiSteal()
        t2.value30.radius = math.min(tonumber(t2.value30.radius) or 10, 10)
        t2.value30.enabled = true
        t2.value8.initSemiSync()
        pcall(t2.value8.scanAllPlotsSemi)

        if t2.value30.conn then
          t2.value30.conn:Disconnect()
          t2.value30.conn = nil
        end

        t2.value30.conn = t2.value4.Heartbeat:Connect(function()
          if not t2.value30.enabled then
            return
          end

          if not t2.value8.Steal.AutoStealEnabled then
            return
          end

          if t2.value8.stealMode ~= "Semi" and t2.value8.stealMode ~= "V2" then
            t2.value8.stopSemiSteal()

            return
          end

          if t2.value30.state.active then
            return
          end

          local v1405 = v123()

          if not v1405 then
            return
          end

          local v1406 = t2.value41(v1405)

          if v1406 then
            t2.value43(v1406, v1405)
          end
        end)
      end
      function t2.value44(p65)
        if not p65 then
          return
        end

        pcall(function()
          if p65.InputHoldEnd then
            p65:InputHoldEnd()
          end
        end)
      end
      local function v124(p66)
        if not p66 or not p66.Parent then
          return false
        end

        if not pcall(function()
          if p66.InputHoldBegin then
            p66:InputHoldBegin()
          end
        end) then
          pcall(function()
            if fireproximityprompt then
              fireproximityprompt(p66)
            end
          end)
        end

        t2.value28(p66)

        local v493 = t2.value8.stealCache[p66]

        if v493 then
          for _, v in ipairs(v493.holdCallbacks) do
            local v496 = v

            task.spawn(function()
              pcall(v496)
            end)
          end
        end

        return true
      end
      function t2.value45(p67)
        if not p67 then
          return
        end

        t2.value28(p67)

        local v487 = t2.value8.stealCache[p67]

        if v487 then
          for _, v in ipairs(v487.triggerCallbacks) do
            local v490 = v

            task.spawn(function()
              pcall(v490)
            end)
          end
        end

        pcall(function()
          if p67.InputHoldEnd then
            p67:InputHoldEnd()
          end
        end)
        pcall(function()
          if fireproximityprompt then
            fireproximityprompt(p67)
          end
        end)
      end
      function t2.value46(p68, p69)
        local v499 = not p68

        if not v499 then
          v499 = not p69
        end

        if v499 then
          return 1e999
        end

        local Plots = workspace:FindFirstChild("Plots")

        if Plots then
          Plots = Plots:FindFirstChild(p68.plot)
        end

        local v501 = Plots and Plots:FindFirstChild("AnimalPodiums")

        if v501 then
          v501 = v501:FindFirstChild(p68.slot)
        end

        local v502 = v501

        if v502 then
          local ok, result = pcall(function()
            return v502:GetPivot().Position
          end)

          if ok and result then
            p68.worldPosition = result

            return (p69.Position - result).Magnitude
          end
        end

        if p68.worldPosition then
          return (p69.Position - p68.worldPosition).Magnitude
        end

        return 1e999
      end
      function t2.value8.startV3Steal()
        if t2.value8.V3.conn then
          return
        end

        t2.value8.V3.enabled = true
        t2.value8.V3.progress = 0
        t2.value8.V3.currentUid = nil
        t2.value8.V3.lastInRange = 0
        t2.value8.V3.holding = false
        t2.value8.V3.holdPrompt = nil
        t2.value8.V3.cooldownUntil = 0
        t2.value8.V3.lastHoldPulse = 0
        t2.value8.V3.conn = t2.value4.Heartbeat:Connect(function(dt)
          if not t2.value8.Steal.AutoStealEnabled or (t2.value8.stealMode ~= "V3" or not t2.value8.V3.enabled) then
            if t2.value8.V3.holdPrompt then
              t2.value44(t2.value8.V3.holdPrompt)
            end

            if t2.value8.V3.progress > 0 or (t2.value8.V3.holding or t2.value8.isStealing) then
              t2.value8.V3.progress = 0
              t2.value8.V3.currentUid = nil
              t2.value8.V3.holding = false
              t2.value8.V3.holdPrompt = nil
              t2.value8.isStealing = false
              t2.value8.updateStealProgress(0)
            end

            return
          end

          local v1408 = math.max(tonumber(t2.value8.Steal.StopTime) or 0.35, 0.05)
          local v1409 = math.max(tonumber(t2.value8.Steal.StealDuration) or 1.4, 0.05)

          if tick() < (t2.value8.V3.cooldownUntil or 0) then
            t2.value8.updateStealProgress(0)

            return
          end

          local Character = t2.value7.Character
          local v1411 = Character and Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("UpperTorso")

          if not v1411 then
            return
          end

          local v1412 = t2.value27()
          local v1413 = v1412 and t2.value46(v1412, v1411) or 1e999
          local v1414 = t2.value8.getActiveStealRadius()
          local v1415 = false

          if v1412 ~= nil then
            v1415 = v1413 <= v1414
          end

          if v1415 then
            t2.value8.V3.lastInRange = tick()

            if t2.value8.V3.currentUid ~= v1412.uid then
              if t2.value8.V3.holdPrompt then
                t2.value44(t2.value8.V3.holdPrompt)
              end

              t2.value8.V3.currentUid = v1412.uid
              t2.value8.V3.progress = 0
              t2.value8.V3.holding = false
              t2.value8.V3.holdPrompt = nil
            end

            local v1416 = t2.value8.promptCache[v1412.uid]

            if not v1416 or not v1416.Parent then
              v1416 = t2.value26(v1412)
            end

            if not v1416 then
              t2.value8.V3.progress = math.clamp(t2.value8.V3.progress + dt / v1409, 0, 1)
              t2.value8.updateStealProgress(t2.value8.V3.progress)
              t2.value8.isStealing = t2.value8.V3.progress > 0

              return
            end

            t2.value8.V3.holdPrompt = v1416
            t2.value8.isStealing = true

            local timestamp = tick()

            if not t2.value8.V3.holding or timestamp - (t2.value8.V3.lastHoldPulse or 0) > 0.1 then
              t2.value8.V3.holding = true
              t2.value8.V3.lastHoldPulse = timestamp
              v124(v1416)
            end

            t2.value8.V3.progress = math.clamp(t2.value8.V3.progress + dt / v1409, 0, 1)
            t2.value8.updateStealProgress(t2.value8.V3.progress)

            if t2.value8.V3.progress >= 1 then
              t2.value45(v1416)
              t2.value8.V3.progress = 0
              t2.value8.V3.currentUid = nil
              t2.value8.V3.holding = false
              t2.value8.V3.holdPrompt = nil
              t2.value8.isStealing = false
              t2.value8.updateStealProgress(0)
              t2.value8.V3.cooldownUntil = tick() + math.max(v1408, 0.25)

              return
            end
          else
          if t2.value8.V3.holding or t2.value8.V3.holdPrompt then
            t2.value44(t2.value8.V3.holdPrompt)
            t2.value8.V3.holding = false
            t2.value8.V3.holdPrompt = nil
          end

          if t2.value8.V3.progress > 0 then
            local value8_6 = t2.value8
            local v1419 = dt / v1408

            value8_6.V3.progress = math.max(0, t2.value8.V3.progress - v1419)
            t2.value8.updateStealProgress(t2.value8.V3.progress)

            if t2.value8.V3.progress <= 0 then
              t2.value8.V3.currentUid = nil
              t2.value8.isStealing = false
              t2.value8.updateStealProgress(0)

              return
            end

            t2.value8.isStealing = true

            return
          end

          t2.value8.isStealing = false
        end
      end)
    end
    function t2.value8.stopV3Steal()
      t2.value8.V3.enabled = false

      if t2.value8.V3.holdPrompt then
        t2.value44(t2.value8.V3.holdPrompt)
      end

      if t2.value8.V3.conn then
        pcall(function()
          t2.value8.V3.conn:Disconnect()
        end)
        t2.value8.V3.conn = nil
      end

      t2.value8.V3.progress = 0
      t2.value8.V3.currentUid = nil
      t2.value8.V3.holding = false
      t2.value8.V3.holdPrompt = nil
      t2.value8.V3.cooldownUntil = 0
      t2.value8.V3.lastInRange = 0
      t2.value8.V3.lastHoldPulse = 0
      t2.value8.isStealing = false
      t2.value8.updateStealProgress(0)
    end
    function t2.value8.startAutoSteal()
      if t2.value8.statusGui then
        t2.value8.statusGui.Enabled = true
      end

      local stealMode = t2.value8.stealMode

      if stealMode == "Semi" or stealMode == "V2" then
        t2.value8.startSemiSteal()

        return
      end

      if stealMode == "V3" then
        t2.value8.startV3Steal()

        return
      end

      t2.value8.startNormalSteal()
    end
    function t2.value8.stopAutoSteal()
      if t2.value8.statusGui then
        t2.value8.statusGui.Enabled = true
      end

      t2.value8.stopNormalSteal()
      t2.value8.stopSemiSteal()
      t2.value8.stopV3Steal()
      t2.value8.isStealing = false
      t2.value8.updateStealProgress(0)
    end
    function t2.value8.setStealRadius(p70)
      t2.value8.Steal.StealRadius = p70
      t2.value8.updateStatusRadius()
    end
    function t2.value8.findBat()
      local Character = t2.value7.Character

      if not Character then
        return nil
      end

      for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("Tool") and child.Name:lower():find("bat") or child.Name:lower():find("slap") then
          return child
        end
      end

      local Backpack = t2.value7:FindFirstChild("Backpack")

      if Backpack then
        for _, child in ipairs(Backpack:GetChildren()) do
          if child:IsA("Tool") and child.Name:lower():find("bat") or child.Name:lower():find("slap") then
            return child
          end
        end
      end

      return nil
    end
    function t2.value8.findMedusa()
      local Character = t2.value7.Character

      if not Character then
        return nil
      end

      for _, child in ipairs(Character:GetChildren()) do
        if not child:IsA("Tool") then
          continue
        end

        local v516 = child.Name:lower()

        if v516:find("medusa") or (v516:find("head") or v516:find("stone")) then
          return child
        end
      end

      local Backpack = t2.value7:FindFirstChild("Backpack")

      if Backpack then
        for _, child in ipairs(Backpack:GetChildren()) do
          if not child:IsA("Tool") then
            continue
          end

          local v520 = child.Name:lower()

          if v520:find("medusa") or (v520:find("head") or v520:find("stone")) then
            return child
          end
        end
      end

      return nil
    end
    function t2.value8.useMedusaCounter()
      if t2.value8.medusaDebounce then
        return
      end

      if t2.value8.MEDUSA_COOLDOWN > tick() - t2.value8.medusaLastUsed then
        return
      end

      local Character = t2.value7.Character

      if not Character then
        return
      end

      t2.value8.medusaDebounce = true

      local v522 = t2.value8.findMedusa()

      if not v522 then
        t2.value8.medusaDebounce = false

        return
      end

      if Character ~= v522.Parent then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
          Humanoid:EquipTool(v522)
        end
      end

      pcall(function()
        v522:Activate()
      end)
      t2.value8.medusaLastUsed = tick()
      t2.value8.medusaDebounce = false
    end
    function t2.value8.onAnchorChanged(p71)
      return p71:GetPropertyChangedSignal("Anchored"):Connect(function()
        if p71.Anchored and p71.Transparency == 1 then
          if t2.value8.medusaResetEnabled then
            t2.value8.instaReset()

            return
          end

          if t2.value8.medusaCounterEnabled then
            t2.value8.useMedusaCounter()
          end
        end
      end)
    end
    function t2.value8.setupMedusa(p72)

      for v528, v529 in pairs(t2.value8.Conns.anchor) do

        local v530 = v529

        pcall(function()
          v530:Disconnect()
        end)
      end
      t2.value8.Conns.anchor = {}
      if not p72 then
        return
      end
      for _, descendant in ipairs(p72:GetDescendants()) do
        if descendant:IsA("BasePart") then
          table.insert(t2.value8.Conns.anchor, t2.value8.onAnchorChanged(descendant))
        end
      end
      table.insert(t2.value8.Conns.anchor, p72.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
          table.insert(t2.value8.Conns.anchor, t2.value8.onAnchorChanged(descendant))
        end
      end))
    end
    function t2.value8.stopMedusaCounter()
      for _, v in pairs(t2.value8.Conns.anchor) do
        local v535 = v

        pcall(function()
          v535:Disconnect()
        end)
      end

      t2.value8.Conns.anchor = {}
    end
    function t2.value8.findBatForCounter()
      local Character = t2.value7.Character

      if not Character then
        return nil
      end

      local Backpack = t2.value7:FindFirstChildOfClass("Backpack")

      for _, v in ipairs(t2.value8.BAT_COUNTER_SLAP_LIST) do
        local v540 = Character:FindFirstChild(v) or Backpack and Backpack:FindFirstChild(v)

        if v540 then
          return v540
        end
      end

      local GetChildren = Character.GetChildren
      local v542, v543, v544 = ipairs(GetChildren(Character))
      local v545

      repeat
        v544, v545 = v542(v543, v544)

        if not v544 then
          if Backpack then
            local GetChildren2 = Backpack.GetChildren

            for _, v in ipairs(GetChildren2(Backpack)) do
              if v:IsA("Tool") and v.Name:lower():find("bat") then
                return v
              end
            end
          end

          return nil
        end
      until v545:IsA("Tool") and v545.Name:lower():find("bat")

      return v545
    end
    function t2.value8.swingBatForCounter(p73, p74)
      local Humanoid = p74:FindFirstChildOfClass("Humanoid")

      if p74 ~= p73.Parent then
        if Humanoid then
          pcall(function()
            Humanoid:EquipTool(p73)
          end)
        end

        task.wait(0.05)
      end

      local v552 = p73:FindFirstChildOfClass("RemoteEvent") or p73:FindFirstChildOfClass("RemoteFunction")

      if v552 and v552:IsA("RemoteEvent") then
        pcall(function()
          v552:FireServer()
        end)
        task.wait(0.15)
        pcall(function()
          v552:FireServer()
        end)

        return
      end

      pcall(function()
        p73:Activate()
      end)
      task.wait(0.15)
      pcall(function()
        p73:Activate()
      end)
    end
    function t2.value8.startBatCounter()
      if t2.value8.Conns.batCounter then
        return
      end

      t2.value8.Conns.batCounter = t2.value4.Heartbeat:Connect(function()
        if not t2.value8.batCounterEnabled or t2.value8.batCounterDebounce then
          return
        end

        local Character = t2.value7.Character

        if not Character then
          return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
          return
        end

        local State = Humanoid:GetState()

        if State == Enum.HumanoidStateType.Physics or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown) then
          t2.value8.batCounterDebounce = true
          task.spawn(function()
            local v1874 = t2.value8.findBatForCounter()

            if v1874 then
              t2.value8.swingBatForCounter(v1874, Character)
            end

            task.wait(0.5)
            t2.value8.batCounterDebounce = false
          end)
        end
      end)
    end
    function t2.value8.stopBatCounter()
      if t2.value8.Conns.batCounter then
        t2.value8.Conns.batCounter:Disconnect()
        t2.value8.Conns.batCounter = nil
      end

      t2.value8.batCounterDebounce = false
    end
    t2.value8.aimbotSpeed = t2.value8.aimbotSpeed or 58
    t2.value8.laggerAimbotSpeed = t2.value8.laggerAimbotSpeed or 40
    t2.value8._aimbotSwingCooldown = false
    t2.value8.aimbotActivateDistance = t2.value8.aimbotActivateDistance or 10
    function t2.value8.findBatForAimbot()
      local Character = t2.value7.Character

      if not Character then
        return nil
      end

      for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("Tool") and child.Name:lower():find("bat") or child.Name:lower():find("slap") then
          return child
        end
      end

      local Backpack = t2.value7:FindFirstChild("Backpack")

      if Backpack then
        for _, child in ipairs(Backpack:GetChildren()) do
          if child:IsA("Tool") and child.Name:lower():find("bat") or child.Name:lower():find("slap") then
            return child
          end
        end
      end

      return nil
    end
    function t2.value8.getClosestTargetAimbot()
      local v559 = t2.value7.Character and t2.value7.Character:FindFirstChild("HumanoidRootPart")
      if not v559 then
        return nil
      end
      local n7 = 1e999
      local v561
      for _, player in ipairs(t2.value1:GetPlayers()) do
        if player ~= t2.value7 and player.Character then
          local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
          local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

          if HumanoidRootPart and (Humanoid and Humanoid.Health > 0) then
            local Magnitude = (HumanoidRootPart.Position - v559.Position).Magnitude

            if Magnitude < n7 then
              n7 = Magnitude
              v561 = HumanoidRootPart
            end
          end
        end
      end

      return v561
    end
    function t2.value8.getNormalAimbotSpeed()
      if t2.value8.laggerModeEnabled or t2.value8.laggerCarryActive then
        return tonumber(t2.value8.laggerAimbotSpeed) or 40
      end

      return tonumber(t2.value8.aimbotSpeed) or 58
    end
    function t2.value8.startBatAimbot()
      local t104 = {}

      if not t2.value8.safeModeTryStart() then
        return
      end

      t104.value3 = t2.value8

      if t104.value3.aimbotConn then
        t2.value8.aimbotConn:Disconnect()
      end

      t104.value4 = t2.value8
      t104.value4.autoBatEnabled = true
      t104.value3 = t2.value8

      if t104.value3.autoLeftEnabled then
        t104.value4 = t2.value8
        t104.value4.autoLeftEnabled = false
        t104.value3 = t2.value8

        if t104.value3.autoLeftSetVisual then
          t2.value8.autoLeftSetVisual(false)
        end

        t2.value8.stopAutoLeft()
      end

      t104.value3 = t2.value8

      if t104.value3.autoRightEnabled then
        t104.value4 = t2.value8
        t104.value4.autoRightEnabled = false
        t104.value3 = t2.value8

        if t104.value3.autoRightSetVisual then
          t2.value8.autoRightSetVisual(false)
        end

        t2.value8.stopAutoRight()
      end

      t104.value4 = t2.value8
      t104.value4._autoTPWasEnabledForBat = false
      t104.value3 = t2.value8

      if t104.value3.autoTPEnabled then
        t104.value4 = t2.value8
        t104.value4._autoTPWasEnabledForBat = true
        t2.value8.stopAutoTP()
        t104.value3 = t2.value8

        if t104.value3.setAutoTPVisual then
          t2.value8.setAutoTPVisual(false)
        end
      end

      local Character = t2.value7.Character

      if not Character then
        return
      end

      t104.value2 = Character:FindFirstChildOfClass("Humanoid")
      t104.value1 = Character:FindFirstChild("HumanoidRootPart")
      t104.value3 = not t104.value2 or not t104.value1

      if t104.value3 then
        return
      end

      local t105 = {}

      t104.value2.AutoRotate = false
      t105.value1 = 1
      t105.value2 = 0.22
      t105.value3 = 3
      t105.value4 = 1.5
      t105.value5 = 8
      t105.value6 = 0.2
      t105.value7 = 0.15
      t105.value8 = 3
      t105.value9 = -8
      t105.value10 = 8
      t105.value11 = 0.15
      t105.value12 = 35
      t105.value13 = 50
      t105.value14 = 0.15
      t105.value15 = 150
      t105.value16 = 0.2
      t105.value17 = 80
      t105.value18 = 3
      t105.value19 = 0.016666666666667
      t105.value20 = 0.3
      t105.value21 = 0.12
      t105.value22 = 1.5
      t105.value23 = 196.2
      t105.value24 = 0.8
      t105.value25 = 0.95
      t105.value26 = 0.6
      t105.value27 = 0.08
      t105.value28 = 0.15
      t105.value29 = 0.7
      t105.value30 = 20
      t105.value31 = -15
      t105.value32 = 1
      t105.value33 = 0.2
      t105.value34 = 10
      t105.value35 = 2.5
      t105.value36 = 3.5
      t105.value37 = nil
      t105.value38 = nil
      t105.value39 = nil
      t104.value3 = Vector3.new(0, 0, 0)
      t105.value40 = t104.value3
      t104.value3 = Vector3
      t104.value4 = t104.value3.new
      t104.value3 = t104.value4(0, 0, 0)
      t105.value41 = t104.value3
      t105.value42 = {}
      t105.value43 = 8
      t105.value44 = 0
      t105.value45 = 0
      t105.value46 = 0
      t105.value47 = 0.1
      t104.value3 = Vector3
      t104.value4 = t104.value3.new
      t104.value4(0, 0, 0)
      t105.value48 = {}
      t105.value49 = 4
      t105.value50 = 0
      t105.value51 = nil
      t105.value52 = {}
      t105.value53 = 6
      t104.value3 = Vector3
      t104.value3 = t104.value3.new(0, 0, 0)
      t105.value54 = t104.value3
      t105.value55 = 0
      t105.value56 = 0
      t105.value57 = 0
      t105.value58 = 0
      t105.value59 = false
      t105.value60 = {}
      t105.value61 = 5

      local function v570()
        local Character2 = t2.value7.Character
        if not Character2 then
          return nil
        end
        local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
          return nil
        end
        local HumanoidRootPartPosition = HumanoidRootPart.Position
        local n8 = 1e999
        local v1428
        for _, player in ipairs(t2.value1:GetPlayers()) do
          if player ~= t2.value7 and player.Character then
            local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart2 then
              local Magnitude = (HumanoidRootPartPosition - HumanoidRootPart2.Position).Magnitude

              if Magnitude < n8 then
                v1428 = player
                n8 = Magnitude
              end
            end
          end
        end

        return v1428
      end
      local function v571()
        if #t105.value42 == 0 then
          return Vector3.new(0, 0, 0)
        end

        local vector3 = Vector3.new(0, 0, 0)

        for _, v in ipairs(t105.value42) do
          vector3 += v
        end

        return vector3 / #t105.value42
      end
      local function v572()
        if #t105.value48 == 0 then
          return Vector3.new(0, 0, 0)
        end

        local vector3 = Vector3.new(0, 0, 0)

        for _, v in ipairs(t105.value48) do
          vector3 += v
        end

        return vector3 / #t105.value48
      end
      local function v573()
        if #t105.value52 == 0 then
          return Vector3.new(0, 0, 0)
        end

        local vector3 = Vector3.new(0, 0, 0)

        for _, v in ipairs(t105.value52) do
          vector3 += Vector3.new(v.X, 0, v.Z)
        end

        return vector3 / #t105.value52
      end

      function t104.value4(p75, p76)
        return p75.Y - t105.value57 > t105.value30 and p76 < t105.value31
      end

      t105.value62 = t104.value4

      local function v574()
        if #t105.value52 < 3 then
          return false
        end

        local n9 = 0

        for i = 2, #t105.value52 do
          local vector3 = Vector3.new(t105.value52[i - 1].X, 0, t105.value52[i - 1].Z)
          local vector3_2 = Vector3.new(t105.value52[i].X, 0, t105.value52[i].Z)

          if vector3.Magnitude > 3 and vector3_2.Magnitude > 3 and vector3.Unit:Dot(vector3_2.Unit) < t105.value29 then
            n9 += 1
          end
        end

        return n9 >= 2
      end
      local function v575(p77)
        local vector3 = Vector3.new(p77.X, 0, p77.Z)

        if vector3.Magnitude < 5 then
          return false
        end

        if t105.value51 and t105.value51:Dot(vector3.Unit) < 0.5 and tick() - t105.value50 < t105.value21 then
          local _ = vector3.Unit

          return true
        end

        local _ = vector3.Unit

        return false
      end
      local function v576()
        if #t105.value42 < 3 then
          return false
        end

        local n10 = 0

        for i = 2, #t105.value42 do
          local vector3 = Vector3.new(t105.value42[i - 1].X, 0, t105.value42[i - 1].Z)
          local vector3_3 = Vector3.new(t105.value42[i].X, 0, t105.value42[i].Z)

          if vector3.Magnitude > 5 and vector3_3.Magnitude > 5 and vector3.Unit:Dot(vector3_3.Unit) < 0.3 then
            n10 += 1
          end
        end

        return n10 >= t105.value18
      end
      local function v577()
        if #t105.value42 < 3 then
          return false
        end

        local n11 = 0

        for i = 2, #t105.value42 do
          if math.abs(t105.value42[i].Y - t105.value42[i - 1].Y) > 15 then
            n11 += 1
          end
        end

        return n11 >= 2
      end

      function t105.value63()
        return math.abs(t105.value40.Y) > t105.value12 and t105.value46 > t105.value14
      end
      function t105.value64()
        return math.abs(t105.value40.Y) > t105.value13
      end
      function t105.value65()
        return t105.value44 > t105.value7 and math.abs(t105.value40.Y) > t105.value8
      end

      local function v578(p78)
        local raycastParams = RaycastParams.new()

        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {
        t105.value38.Character,
        t2.value7.Character
        }

        local raycastResult = workspace:Raycast(p78.Position, Vector3.new(0, -100, 0), raycastParams)

        if raycastResult then
          local _ = raycastResult.Position.Y

          return false
        end

        return true
      end

      function t105.value66(p79, p80, p81)
        return p79:Lerp(p80, p81)
      end
      function t104.value4(p82, p83, p84, p85, p86, p87)
        local vector3 = Vector3.new(p83.X, 0, p83.Z)
        local p83Y = p83.Y
        local v1484

        if p85 then
          local v1483 = v573()

          v1484 = Vector3.new(v1483.X, 0, v1483.Z) * t105.value24
        else
        v1484 = vector3 * t105.value24
      end

      local v1485 = v1484 * t105.value25
      local v1486 = t105.value23 * t105.value32

      if p87 then
        v1486 *= 0.3
        p83Y *= 0.9
      end

      local v1488

      if p86 then
        local v1487 = 0.5 * v1486 * 1.2 * p84

        v1488 = p83Y * p84 - v1487 * p84 - t105.value36 * p84
      else
      v1488 = p83Y * p84 - 0.5 * v1486 * p84 * p84
    end

    if p83Y > t105.value10 and not p87 then
      v1488 += t105.value35 * p84
    end

    return p82 + v1485 * p84 + Vector3.new(0, v1488, 0)
  end

  t105.value67 = t104.value4

  local function v579(p88, p89, p90, p91, p92, p93, p94, p95, p96)
    local v1498 = p91 + t105.value19

    if p92 then
      v1498 *= t105.value22
    end

    if p93 then
      return t105.value67(p88, p89, v1498, p94, p95, p96)
    end

    local v1499 = p88 + p89 * v1498

    if p90.Magnitude > 1 then
      local v1500 = v1498 * v1498 * 0.5

      v1499 += p90 * t105.value20 * v1500
    end

    return v1499
  end

  t105.value68 = 15

  local function v580()
    if t105.value37 then
      t105.value37:Destroy()
    end

    t105.value37 = Instance.new("Part")
    t105.value37.Name = "PredictionSphere"
    t105.value37.Shape = Enum.PartType.Ball
    t105.value37.Size = Vector3.new(2, 2, 2)
    t105.value37.Anchored = true
    t105.value37.CanCollide = false
    t105.value37.Material = Enum.Material.Neon
    t105.value37.Color = Color3.fromRGB(200, 200, 200)
    t105.value37.Transparency = 1

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color3.fromRGB(200, 200, 200)
    PointLight.Range = 8
    PointLight.Brightness = 2
    PointLight.Parent = t105.value37

    local Highlight = Instance.new("Highlight")

    Highlight.FillTransparency = 1
    Highlight.OutlineColor = Color3.fromRGB(180, 180, 180)
    Highlight.OutlineTransparency = 1
    Highlight.Parent = t105.value37
    t105.value37.Parent = workspace

    return t105.value37
  end
  local function v581(p97, p98)
    if not p98 then
      return
    end

    if p97.Magnitude < 0.01 then
      return
    end

    local v1508 = p98.CFrame.LookVector:Cross(p97.Unit)
    local v1509 = math.asin((math.clamp(v1508.Magnitude, -1, 1)))

    if v1508.Magnitude > 0.01 then
      p98.AssemblyAngularVelocity = v1508.Unit * v1509 * 80

      return
    end

    p98.AssemblyAngularVelocity = Vector3.zero
  end

  function t104.value4(p99)
    local Humanoid = p99:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = p99:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not HumanoidRootPart then
      return
    end

    Humanoid.AutoRotate = false

    if not t105.value37 then
      v580()
    end

    if t2.value8.aimbotConn then
      t2.value8.aimbotConn:Disconnect()
    end

    t2.value8.aimbotConn = t2.value4.RenderStepped:Connect(function(dt)
      if not t2.value8.autoBatEnabled then
        if t2.value8.aimbotConn then
          t2.value8.aimbotConn:Disconnect()
          t2.value8.aimbotConn = nil
        end

        return
      end

      t105.value38 = v570()

      if not t105.value38 or not t105.value38.Character then
        if t105.value37 then
          t105.value37.Transparency = 1
        end

        t105.value38 = nil
        t105.value39 = nil
        t105.value40 = Vector3.zero
        t105.value41 = Vector3.zero
        t105.value42 = {}
        t105.value48 = {}
        t105.value52 = {}
        t105.value60 = {}
        t105.value54 = Vector3.zero
        t105.value44 = 0
        t105.value46 = 0
        t105.value55 = 0
        t105.value56 = 0
        t105.value59 = false

        return
      end

      local HumanoidRootPart3 = t105.value38.Character:FindFirstChild("HumanoidRootPart")

      if not HumanoidRootPart3 then
        if t105.value37 then
          t105.value37.Transparency = 1
        end

        return
      end

      if t105.value37 then
        t105.value37.Transparency = 1
      end

      local HumanoidRootPart3Position = HumanoidRootPart3.Position
      local HumanoidRootPartPosition = HumanoidRootPart.Position

      if t105.value39 then
        local v1879 = (HumanoidRootPart3Position - t105.value39) / dt
        local value40 = t105.value40
        local value15 = t105.value15
        local v1882 = v1879 - value40
        local v1883 = if not (value15 < v1882.Magnitude) then v1879 else value40 + v1882.Unit * value15
          local vector3 = Vector3.new(v1883.X, 0, v1883.Z)

          if vector3.Magnitude > t105.value17 then
            local v1885 = vector3.Unit * t105.value17

            v1883 = Vector3.new(v1885.X, v1883.Y, v1885.Z)
          end

          local v1886 = (v1883 - t105.value40) / dt

          table.insert(t105.value48, v1886)

          if #t105.value48 > t105.value49 then
            table.remove(t105.value48, 1)
          end

          table.insert(t105.value60, v1883.Y)

          if #t105.value60 > t105.value61 then
            table.remove(t105.value60, 1)
          end

          t105.value40 = v1883
          t105.value41 = t105.value66(t105.value41, t105.value40, t105.value16)
          table.insert(t105.value42, t105.value40)

          if #t105.value42 > t105.value43 then
            table.remove(t105.value42, 1)
          end
        end

        if math.abs(t105.value40.Y) > t105.value12 then
          local _ = t105.value46 + dt
        end

        local v1888 = v578(HumanoidRootPart3)

        if v1888 then
          t105.value44 = t105.value44 + dt

          if HumanoidRootPart3Position.Y > t105.value56 then
            local _ = HumanoidRootPart3Position.Y
          end

          if t105.value44 >= t105.value27 then
            table.insert(t105.value52, t105.value40)

            if #t105.value52 > t105.value53 then
              table.remove(t105.value52, 1)
            end

            t105.value54 = t105.value66(t105.value54, t105.value40, t105.value28)
          end
        else
        t105.value44 = 0
        t105.value54 = Vector3.zero
      end

      local v1890 = math.abs(t105.value40.Y) > t105.value5
      local v1891 = v577()
      local v1892 = t105.value65()
      local v1893 = t105.value63()
      local v1894 = t105.value64()
      local v1895 = v576()
      local v1896 = v571()
      local v1897 = v572()
      local v1898 = v575(t105.value40)
      local v1899 = v574()
      local v1900 = v1888 and t105.value44 >= t105.value27

      if not (t105.value55 > t105.value10) then
      end

      local v1901 = t105
      local value40Y = t105.value40.Y
      local timestamp = tick()

      v1901.value59 = not not (t105.value55 < -5 and value40Y > t105.value34) and (timestamp - t105.value58 < t105.value33 or true)

      local v1904 = t105.value62(HumanoidRootPart3Position, t105.value40.Y)
      local n12

      if #t105.value60 == 0 then
        n12 = 0
      else
      local n13 = 0

      for _, v in ipairs(t105.value60) do
        n13 += v
      end

      n12 = n13 / #t105.value60
    end

    local v1909 = false
    local _ = t105.value40.Y
    local value40 = t105.value40

    if v1894 then
      v1909 = true
      value40 = Vector3.new(v1896.X, 0, v1896.Z)
      v1897 = Vector3.zero
    elseif v1893 then
      local vector3 = Vector3.new(v1896.X, 0, v1896.Z)

      value40 = Vector3.new(vector3.X, t105.value40.Y * 0.15, vector3.Z)
      v1897 = Vector3.new(v1897.X, 0, v1897.Z)
    elseif v1891 or v1892 then
      local vector3 = Vector3.new(v1896.X, 0, v1896.Z)

      value40 = Vector3.new(vector3.X, t105.value40.Y * 0.5, vector3.Z)
      v1897 = Vector3.new(v1897.X * 0.5, 0, v1897.Z * 0.5)
    elseif v1900 and v1899 then
      local v1914 = v573()

      value40 = Vector3.new(t105.value54.X * t105.value26 + v1914.X * (1 - t105.value26), n12, t105.value54.Z * t105.value26 + v1914.Z * (1 - t105.value26))
      v1897 = Vector3.new(v1897.X * 0.3, 0, v1897.Z * 0.3)
    elseif v1900 then
      value40 = Vector3.new(t105.value54.X, n12, t105.value54.Z)
      v1897 = Vector3.zero
    elseif v1895 then
      value40 = Vector3.new(t105.value41.X, t105.value40.Y, t105.value41.Z)
      v1897 = Vector3.new(v1897.X * 0.7, 0, v1897.Z * 0.7)
    end

    local v1915 = if not v1909 then v579(HumanoidRootPart3Position, value40, v1897, t105.value47, v1898, v1900, v1899, v1904, t105.value59) else HumanoidRootPart3Position
      local v1916 = t105.value2 * 1.1

      if v1895 then
        v1916 *= 0.6
      elseif v1898 then
        v1916 *= 1.2
      elseif v1900 and v1899 then
        v1916 *= 0.7
      elseif v1900 and v1904 then
        v1916 *= 1.3
      elseif v1900 then
        v1916 *= 0.85
      end

      local v1917 = if not v1900 then v1915 + value40 * v1916 else t105.value67(v1915, value40, v1916, v1899, v1904, t105.value59)
        local vector3 = Vector3.new(0, 0, 0)

        if not v1900 and (not v1894 and (not v1893 and not v1891)) then
          if t105.value40.Y < t105.value9 then
            vector3 = Vector3.new(0, t105.value40.Y * t105.value11, 0)
          elseif t105.value40.Y > t105.value10 then
            vector3 = Vector3.new(0, t105.value40.Y * t105.value11, 0)
          end
        end

        local v1919 = v1917 + vector3
        local vector3_4 = Vector3.new(0, 0, 0)
        local vector3_5 = Vector3.new(value40.X, 0, value40.Z)

        if vector3_5.Magnitude > 1 and not v1909 then
          vector3_4 = vector3_5.Unit * t105.value3
        end

        local v1922 = v1919 + vector3_4

        if not not t105.value37 then
          local v1923 = math.min(1, dt * t105.value68)

          t105.value37.CFrame = t105.value37.CFrame:Lerp(CFrame.new(v1922), v1923)
        end

        local v1924 = v1922 - HumanoidRootPartPosition

        if v1924.Magnitude > 0.1 then
          v581(v1924, HumanoidRootPart)
        end

        if (HumanoidRootPart3Position - HumanoidRootPartPosition).Magnitude <= t2.value8.aimbotActivateDistance and tick() - t105.value45 >= 0.3 then
          v1922 = if not (v1909 or v1895 and not v1900) then if not v1900 then v1915 + value40 * t105.value6 else t105.value67(v1915, value40, t105.value6, v1899, v1904, t105.value59) else v1915
            local v1925 = t2.value8.findBatForAimbot()
            local v1926
            for _, child in ipairs(p99:GetChildren()) do
              if child:IsA("Tool") then
                v1926 = child

                break
              end
            end
            if v1925 and not v1926 then
              pcall(function()
                Humanoid:EquipTool(v1925)
              end)
            end
            local Tool = p99:FindFirstChildOfClass("Tool")
            if Tool then
              Tool:Activate()
            end
          end

          local v1930 = v1922 - HumanoidRootPartPosition

          if v1930.Magnitude > t105.value1 then
            local Unit = v1930.Unit
            local aimbotSpeed = t2.value8.aimbotSpeed

            if v1890 then
              aimbotSpeed *= t105.value4
            end

            if v1894 then
              aimbotSpeed *= 1.3
            elseif v1893 or (v1891 or v1892) then
              aimbotSpeed *= 1.15
            end

            if v1895 then
              local _ = aimbotSpeed * 0.9
            elseif v1898 then
              local _ = aimbotSpeed * 1.1
            elseif v1900 and v1899 then
              local _ = aimbotSpeed * 0.95
            elseif v1900 and v1904 then
              local _ = aimbotSpeed * 1.15
            elseif v1900 then
              local _ = aimbotSpeed * 1.05
            end

            HumanoidRootPart.AssemblyLinearVelocity = Unit * t2.value8.getNormalAimbotSpeed()

            return
          end

          HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, HumanoidRootPart.AssemblyLinearVelocity.Y * 0.5, 0)
        end)
      end

      t104.value5 = t104.value4

      function t104.value4()
        if t2.value8.aimbotConn then
          t2.value8.aimbotConn:Disconnect()
          t2.value8.aimbotConn = nil
        end

        if t105.value37 then
          t105.value37:Destroy()
        end

        local Character3 = t2.value7.Character

        if Character3 then
          local Humanoid = Character3:FindFirstChildOfClass("Humanoid")

          if Humanoid then
            Humanoid.AutoRotate = true
          end

          local HumanoidRootPart = Character3:FindFirstChild("HumanoidRootPart")

          if HumanoidRootPart then
            HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
          end
        end

        local _ = Vector3.zero
        local _ = Vector3.zero
        local _ = Vector3.zero
      end

      t104.value5(Character)
      t104.value3 = t2.value8

      if t104.value3.autoBatSetVisual then
        t2.value8.autoBatSetVisual(true)
      end

      t104.value3 = t2.value8.mobBtnRefs

      if t104.value3.autoBat then
        t2.value8.mobBtnRefs.autoBat(true)
      end
    end
    function t2.value8.stopBatAimbot()
      if t2.value8.aimbotConn then
        pcall(function()
          t2.value8.aimbotConn:Disconnect()
        end)
        t2.value8.aimbotConn = nil
      end

      t2.value8._aimbotTarget = nil
      t2.value8._aimbotSwingCooldown = false
      t2.value8.autoBatEnabled = false
      t2.value8.autoBatEquippedThisRun = false

      local Character = t2.value7.Character
      local v583 = Character and Character:FindFirstChild("HumanoidRootPart")

      if v583 then
        v583.AssemblyLinearVelocity = v583.AssemblyLinearVelocity * 0.3
        v583.AssemblyAngularVelocity = Vector3.zero
      end

      local v584 = Character and Character:FindFirstChildOfClass("Humanoid")

      if v584 then
        v584.AutoRotate = true
      end

      if t2.value8._autoTPWasEnabledForBat then
        t2.value8._autoTPWasEnabledForBat = false
        t2.value8.autoTPEnabled = true

        if t2.value8.setAutoTPVisual then
          t2.value8.setAutoTPVisual(true)
        end

        t2.value8.startAutoTP()
      end

      if t2.value8.autoBatSetVisual then
        t2.value8.autoBatSetVisual(false)
      end

      if t2.value8.mobBtnRefs.autoBat then
        t2.value8.mobBtnRefs.autoBat(false)
      end
    end
    function t2.value8.queueAutoBatStart()
      if not t2.value8.safeModeTryStart() then
        return
      end

      if t2.value8.antiKickEnabled and t2.value8.brainrotDetected then
        return
      end

      if t2.value8.autoLeftEnabled then
        t2.value8.autoLeftEnabled = false

        if t2.value8.autoLeftSetVisual then
          t2.value8.autoLeftSetVisual(false)
        end

        t2.value8.stopAutoLeft()
      end

      if t2.value8.autoRightEnabled then
        t2.value8.autoRightEnabled = false

        if t2.value8.autoRightSetVisual then
          t2.value8.autoRightSetVisual(false)
        end

        t2.value8.stopAutoRight()
      end

      t2.value8.startBatAimbot()
    end
    function t2.value8.swingCurrentBatAimbot(p100)
      if not t2.value8.autoSwingEnabled then
        return
      end

      local v586 = t2.value8.findBatForAimbot()

      if v586 and p100 == v586.Parent then
        pcall(function()
          v586:Activate()
        end)
      end
    end
    t2.value8._bypassTarget = nil
    t2.value8._bypassHRP = nil
    t2.value8._bypassHum = nil
    t2.value8.tpBatRange = t2.value8.tpBatRange or 1000000000
    t2.value8.tpBatClose = t2.value8.tpBatClose or 6
    t2.value8.tpBatOffset = t2.value8.tpBatOffset or 2.4
    t2.value8._tpBatLastSwing = 0
    t2.value8._bypassSwingCooldown = false
    function t2.value8._bypassFindBat()
      local Character = t2.value7.Character

      if not Character then
        return nil
      end

      local Bat = Character:FindFirstChild("Bat")

      if Bat then
        return Bat
      end

      local v589 = t2.value7:FindFirstChild("Backpack") or t2.value7:FindFirstChildOfClass("Backpack")

      if v589 then
        local Bat2 = v589:FindFirstChild("Bat")

        if Bat2 then
          Bat2.Parent = Character

          return Bat2
        end
      end

      return nil
    end
    function t2.value8._bypassTryHitBat()
      if t2.value8._bypassSwingCooldown then
        return
      end

      t2.value8._bypassSwingCooldown = true
      pcall(function()
        local v1519 = t2.value8._bypassFindBat()

        if v1519 then
          v1519:Activate()

          local RemoteEvent = v1519:FindFirstChildWhichIsA("RemoteEvent")

          if RemoteEvent then
            RemoteEvent:FireServer()
          end
        end
      end)
      task.delay(0.08, function()
        t2.value8._bypassSwingCooldown = false
      end)
    end
    function t2.value8._bypassGetClosest()
      local v591 = t2.value7.Character and t2.value7.Character:FindFirstChild("HumanoidRootPart")
      if not v591 then
        return nil, 1e999
      end
      local n14 = 1e999
      local v593
      for _, player in ipairs(t2.value1:GetPlayers()) do
        if player ~= t2.value7 and player.Character then
          local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
          local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

          if HumanoidRootPart and (Humanoid and Humanoid.Health > 0) then
            local Magnitude = (HumanoidRootPart.Position - v591.Position).Magnitude

            if Magnitude < n14 then
              n14 = Magnitude
              v593 = HumanoidRootPart
            end
          end
        end
      end

      return v593, n14
    end
    function t2.value8._bypassClearGodConns()
      for _, v in ipairs({
      "_bypassGodConn",
      "_bypassGodHealthConn",
      "_bypassGodDiedConn",
      "_bypassGodCharConn"
      }) do
        local v601 = t2.value8[v]

        if v601 then
          pcall(function()
            v601:Disconnect()
          end)
          t2.value8[v] = nil
        end
      end
    end
    function t2.value8._bypassProtectCharacter(p101)
      if not p101 then
        return
      end

      local Humanoid = p101:FindFirstChildOfClass("Humanoid")

      if not Humanoid then
        return
      end

      pcall(function()
        Humanoid.MaxHealth = math.max(Humanoid.MaxHealth, 100)

        if Humanoid.Health < Humanoid.MaxHealth then
          Humanoid.Health = Humanoid.MaxHealth
        end
      end)

      if t2.value8._bypassGodHealthConn then
        pcall(function()
          t2.value8._bypassGodHealthConn:Disconnect()
        end)
      end

      t2.value8._bypassGodHealthConn = Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not t2.value8.bypassAimbotEnabled then
          return
        end

        if Humanoid.Health < Humanoid.MaxHealth then
          pcall(function()
            Humanoid.Health = Humanoid.MaxHealth
          end)
        end
      end)

      if t2.value8._bypassGodDiedConn then
        pcall(function()
          t2.value8._bypassGodDiedConn:Disconnect()
        end)
      end

      t2.value8._bypassGodDiedConn = Humanoid.Died:Connect(function()
        if not t2.value8.bypassAimbotEnabled then
          return
        end

        pcall(function()
          Humanoid.Health = Humanoid.MaxHealth
          Humanoid:ChangeState(Enum.HumanoidStateType.Running)
          Humanoid.PlatformStand = false
        end)
      end)
    end
    function t2.value8.enableBypassGodmode()
      t2.value8._bypassClearGodConns()

      local Character = t2.value7.Character

      if Character then
        t2.value8._bypassProtectCharacter(Character)
      end

      t2.value8._bypassGodCharConn = t2.value7.CharacterAdded:Connect(function(character)
        if not t2.value8.bypassAimbotEnabled then
          return
        end

        task.wait(0.15)
        t2.value8._bypassProtectCharacter(character)
      end)
      t2.value8._bypassGodConn = t2.value4.Heartbeat:Connect(function()
        if not t2.value8.bypassAimbotEnabled then
          return
        end

        local Character4 = t2.value7.Character
        local v1523 = Character4 and Character4:FindFirstChildOfClass("Humanoid")

        if not v1523 then
          return
        end

        pcall(function()
          if v1523.Health < (v1523.MaxHealth or 100) then
            v1523.Health = v1523.MaxHealth or 100
          end

          if v1523:GetState() == Enum.HumanoidStateType.Dead then
            v1523:ChangeState(Enum.HumanoidStateType.Running)
          end
        end)
      end)
    end
    function t2.value8.disableBypassGodmode()
      t2.value8._bypassClearGodConns()
    end
    function t2.value8.startBypassAimbot()
      if not t2.value8.safeModeTryStart() then
        return
      end

      if t2.value8.bypassAimbotConn then
        pcall(function()
          t2.value8.bypassAimbotConn:Disconnect()
        end)
        t2.value8.bypassAimbotConn = nil
      end

      if t2.value8.autoLeftEnabled then
        t2.value8.autoLeftEnabled = false

        if t2.value8.autoLeftSetVisual then
          t2.value8.autoLeftSetVisual(false)
        end

        t2.value8.stopAutoLeft()
      end

      if t2.value8.autoRightEnabled then
        t2.value8.autoRightEnabled = false

        if t2.value8.autoRightSetVisual then
          t2.value8.autoRightSetVisual(false)
        end

        t2.value8.stopAutoRight()
      end

      t2.value8._autoTPWasEnabledForBypass = false

      if t2.value8.autoTPEnabled then
        t2.value8._autoTPWasEnabledForBypass = true
        t2.value8.stopAutoTP()

        if t2.value8.setAutoTPVisual then
          t2.value8.setAutoTPVisual(false)
        end
      end

      t2.value8.bypassAimbotEnabled = true
      t2.value8.enableBypassGodmode()
      t2.value8._bypassTarget = nil
      t2.value8._bypassSwingCooldown = false
      t2.value8._tpBatLastSwing = 0

      local Character = t2.value7.Character
      local v606 = Character and Character:FindFirstChildOfClass("Humanoid")

      if v606 then
        t2.value8.bypassPrevAutoRotate = v606.AutoRotate
        v606.AutoRotate = false
      end

      t2.value8.bypassAimbotConn = t2.value4.Heartbeat:Connect(function()
        if not t2.value8.bypassAimbotEnabled then
          return
        end

        local Character5 = t2.value7.Character

        if not Character5 then
          return
        end

        local HumanoidRootPart = Character5:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
          return
        end

        local Humanoid = Character5:FindFirstChildOfClass("Humanoid")

        if not Humanoid or Humanoid.Health <= 0 then
          return
        end

        local v1527 = t2.value8._bypassFindBat()
        local v1528, _ = t2.value8._bypassGetClosest()
        local v1530 = v1528

        if not v1530 then
          t2.value8._bypassTarget = nil

          return
        end

        t2.value8._bypassTarget = v1530

        if sethiddenproperty then
          pcall(function()
            sethiddenproperty(HumanoidRootPart, "PhysicsRepRootPart", v1530)
          end)
        end

        local v1531 = v1530.Position + Vector3.new(0, 0.9, 0)

        if (HumanoidRootPart.Position - v1531).Magnitude > 8 then
          HumanoidRootPart.CFrame = CFrame.new(v1531)
        end

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
          pcall(function()
            CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, v1530.Position)
          end)
        end

        if v1527 then
          t2.value8._bypassTryHitBat()
        end
      end)

      if t2.value8.setBypassVisual then
        t2.value8.setBypassVisual(true)
      end

      if t2.value8.mobBtnRefs.bypass then
        t2.value8.mobBtnRefs.bypass(true)
      end
    end
    function t2.value8.stopBypassAimbot()
      if t2.value8.bypassAimbotConn then
        pcall(function()
          t2.value8.bypassAimbotConn:Disconnect()
        end)
        t2.value8.bypassAimbotConn = nil
      end

      t2.value8.bypassAimbotEnabled = false
      t2.value8.disableBypassGodmode()
      t2.value8._bypassTarget = nil
      t2.value8._bypassSwingCooldown = false
      t2.value8.bypassHitCD = false

      local Character = t2.value7.Character
      local v608 = Character and Character:FindFirstChild("HumanoidRootPart")

      if v608 then
        v608.AssemblyLinearVelocity = Vector3.zero
        v608.AssemblyAngularVelocity = Vector3.zero
      end

      local v609 = Character and Character:FindFirstChildOfClass("Humanoid")

      if v609 then
        v609.AutoRotate = t2.value8.bypassPrevAutoRotate == nil or t2.value8.bypassPrevAutoRotate
      end

      if t2.value8._autoTPWasEnabledForBypass then
        t2.value8._autoTPWasEnabledForBypass = false
        t2.value8.autoTPEnabled = true

        if t2.value8.setAutoTPVisual then
          t2.value8.setAutoTPVisual(true)
        end

        t2.value8.startAutoTP()
      end

      if t2.value8.setBypassVisual then
        t2.value8.setBypassVisual(false)
      end

      if t2.value8.mobBtnRefs.bypass then
        t2.value8.mobBtnRefs.bypass(false)
      end
    end
    function t2.value8.toggleBypassAimbot()
      t2.value8.bypassAimbotEnabled = not t2.value8.bypassAimbotEnabled

      if t2.value8.bypassAimbotEnabled then
        t2.value8.startBypassAimbot()
      else
      t2.value8.stopBypassAimbot()
    end

    if t2.value8.setBypassVisual then
      t2.value8.setBypassVisual(t2.value8.bypassAimbotEnabled)
    end

    if t2.value8.mobBtnRefs.bypass then
      t2.value8.mobBtnRefs.bypass(t2.value8.bypassAimbotEnabled)
    end

    saveCherryConfig()

    return t2.value8.bypassAimbotEnabled
  end
  function t2.value8.doAutoTPDown(p102)
    local Character = t2.value7.Character

    if not Character then
      return
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
      return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
      return
    end

    if not p102 then
      if Humanoid.FloorMaterial ~= Enum.Material.Air then
        return
      end

      if not (HumanoidRootPart.Position.Y >= t2.value8.autoTPHeight) then
        return
      end
    end

    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, -7, HumanoidRootPart.Position.Z) * CFrame.Angles(0, select(2, HumanoidRootPart.CFrame:ToEulerAnglesYXZ()), 0)
    HumanoidRootPart.Velocity = Vector3.zero
  end
  function t2.value8.startAutoTP()
    if t2.value8.autoTPConn then
      task.cancel(t2.value8.autoTPConn)
      t2.value8.autoTPConn = nil
    end

    t2.value8.autoTPConn = task.spawn(function()
      while t2.value8.autoTPEnabled do
        task.wait(0.1)
        pcall(function()
          t2.value8.doAutoTPDown(false)
        end)
      end
    end)
  end
  function t2.value8.stopAutoTP()
    t2.value8.autoTPEnabled = false

    if t2.value8.autoTPConn then
      task.cancel(t2.value8.autoTPConn)
      t2.value8.autoTPConn = nil
    end
  end
  function t2.value8.runTPFloor()
    pcall(function()
      t2.value8.doAutoTPDown(true)
    end)
  end
  function t2.value8.enableStretchRez()
    t2.value8.stretchRezEnabled = true

    if t2.value8.stretchRezConn then
      t2.value8.stretchRezConn:Disconnect()
    end

    pcall(function()
      t2.value4:UnbindFromRenderStep("Movee_Stretch")
    end)
    pcall(function()
      t2.value4:BindToRenderStep("Movee_Stretch", Enum.RenderPriority.Last.Value - 1, function()
        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
          CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
        end
      end)
    end)
  end
  function t2.value8.disableStretchRez()
    t2.value8.stretchRezEnabled = false
    pcall(function()
      t2.value4:UnbindFromRenderStep("Movee_Stretch")
    end)
  end
  function t2.value8.isSummerBaseName(p103)
    if not p103 then
      return false
    end

    local v615 = tostring(p103):lower()
    local v616 = v615 == "summerbase"

    if not v616 then
      v616 = v615 == "summer_base" or (v615:find("summerbase", 1, true) ~= nil or v615:find("summer_base", 1, true) ~= nil)
    end

    return v616
  end
  function t2.value8.isAnchorName(p104)
    if not p104 then
      return false
    end

    local v618 = tostring(p104):lower()

    return v618 == "anchor" or v618 == "anchors"
  end
  function t2.value8.stripBlockingAnchor(p105)
    if not p105 or not p105.Parent then
      return
    end

    local str = tostring(p105:GetFullName())

    if t2.value8._antiSummerCleaned[str] then
      return
    end

    t2.value8._antiSummerCleaned[str] = true
    pcall(function()
      if p105:IsA("BasePart") or p105:IsA("MeshPart") then
        p105.CanCollide = false
        p105.CanQuery = false
        p105.CanTouch = false
        p105.Transparency = 1
      end

      p105:Destroy()
    end)
  end
  function t2.value8.cleanSummerBaseAnchors()
    if not t2.value8.antiSummerBaseEnabled then
      return
    end

    local Plots = workspace:FindFirstChild("Plots")

    if not Plots then
      return
    end

    for _, child in ipairs(Plots:GetChildren()) do
      local v624 = t2.value8.isSummerBaseName(child.Name)

      if not v624 then
        for _, descendant in ipairs(child:GetDescendants()) do
          if t2.value8.isSummerBaseName(descendant.Name) then
            v624 = true

            break
          end
        end
      end

      if v624 then
        for _, descendant in ipairs(child:GetDescendants()) do
          if t2.value8.isAnchorName(descendant.Name) then
            t2.value8.stripBlockingAnchor(descendant)
          end
        end
      end
    end
  end
  function t2.value8.enableAntiSummerBase()
    t2.value8.antiSummerBaseEnabled = true
    t2.value8._antiSummerCleaned = {}
    t2.value8.cleanSummerBaseAnchors()

    if t2.value8.antiSummerBaseConn then
      pcall(function()
        t2.value8.antiSummerBaseConn:Disconnect()
      end)
      t2.value8.antiSummerBaseConn = nil
    end

    t2.value8.antiSummerBaseConn = workspace.DescendantAdded:Connect(function(descendant)
      if not t2.value8.antiSummerBaseEnabled then
        return
      end

      if not t2.value8.isAnchorName(descendant.Name) then
        return
      end

      task.defer(function()
        if not t2.value8.antiSummerBaseEnabled or not descendant.Parent then
          return
        end

        local v1939 = descendant
        local v1940 = false
        local v1941 = false

        while v1939 and v1939 ~= workspace do
          if v1939.Name == "Plots" or v1939.Parent and v1939.Parent.Name == "Plots" then
            v1940 = true
          end

          if t2.value8.isSummerBaseName(v1939.Name) then
            v1941 = true
          end

          v1939 = v1939.Parent
        end

        if v1940 and v1941 then
          t2.value8.stripBlockingAnchor(descendant)
        end
      end)
    end)
    task.spawn(function()
      while t2.value8.antiSummerBaseEnabled do
        t2.value8.cleanSummerBaseAnchors()
        task.wait(5)
      end
    end)
  end
  function t2.value8.disableAntiSummerBase()
    t2.value8.antiSummerBaseEnabled = false

    if t2.value8.antiSummerBaseConn then
      pcall(function()
        t2.value8.antiSummerBaseConn:Disconnect()
      end)
      t2.value8.antiSummerBaseConn = nil
    end
  end
  function t2.value8._isUnderPlots(p106)
    while p106 and p106 ~= workspace do
      if p106.Name == "Plots" then
        return true
      end

      p106 = p106.Parent
    end

    return false
  end
  function t2.value8.applyAntiLagDerender(p107)
    if not p107 then
      return
    end

    if t2.value8._isUnderPlots(p107) then
      return
    end

    pcall(function()
      if p107:IsA("Accessory") or p107:IsA("Hat") then
        local Model = p107:FindFirstAncestorOfClass("Model")

        if Model and t2.value1:GetPlayerFromCharacter(Model) then
          p107:Destroy()

          return
        end
      else
      local v1535 = p107:IsA("ParticleEmitter")

      if not v1535 then
        v1535 = p107:IsA("Trail")

        if not v1535 then
          v1535 = p107:IsA("Beam")

          if not v1535 then
            v1535 = p107:IsA("Fire") or (p107:IsA("Smoke") or p107:IsA("Sparkles"))
          end
        end
      end

      if v1535 then
        p107.Enabled = false

        return
      end

      if p107:IsA("BasePart") or p107:IsA("MeshPart") then
        p107.CastShadow = false

        if p107.Reflectance and p107.Reflectance > 0 then
          p107.Reflectance = 0
        end
      end
    end
  end)
end
function t2.value8.enableAntiLag()
  t2.value8.removeAccessoriesEnabled = true
  t2.value8.antiLagEnabled = true
  t2.value8.defLightBrightness = t2.value8.defLightBrightness or t2.value5.Brightness
  t2.value8.defLightClock = t2.value8.defLightClock or t2.value5.ClockTime
  t2.value8.defLightAmbient = t2.value8.defLightAmbient or t2.value5.OutdoorAmbient
  t2.value5.GlobalShadows = false
  t2.value5.FogEnd = 10000000000
  t2.value5.Brightness = 1
  t2.value5.EnvironmentDiffuseScale = 0
  t2.value5.EnvironmentSpecularScale = 0
  for v633, v634 in pairs(t2.value5:GetChildren()) do

    local v635 = v634

    pcall(function()
      local v1536 = v635:IsA("BlurEffect")

      if not v1536 then
        v1536 = v635:IsA("SunRaysEffect")

        if not v1536 then
          v1536 = v635:IsA("ColorCorrectionEffect") or (v635:IsA("BloomEffect") or v635:IsA("DepthOfFieldEffect"))
        end
      end

      if v1536 then
        v635.Enabled = false
      end
    end)
  end
  for _, player in ipairs(t2.value1:GetPlayers()) do
    if player.Character then
      for _, descendant in ipairs(player.Character:GetDescendants()) do
        t2.value8.applyAntiLagDerender(descendant)
      end
    end
  end
  if t2.value8.antiLagDescConn then
    t2.value8.antiLagDescConn:Disconnect()
  end
  t2.value8.antiLagDescConn = workspace.DescendantAdded:Connect(function(descendant)
    if not t2.value8.antiLagEnabled then
      return
    end

    if t2.value8._isUnderPlots(descendant) then
      return
    end

    t2.value8.applyAntiLagDerender(descendant)
  end)
end
function t2.value8.disableAntiLag()
  t2.value8.removeAccessoriesEnabled = false
  t2.value8.antiLagEnabled = false

  if t2.value8.antiLagDescConn then
    t2.value8.antiLagDescConn:Disconnect()
    t2.value8.antiLagDescConn = nil
  end

  pcall(function()
    if t2.value8.defLightBrightness then
      t2.value5.Brightness = t2.value8.defLightBrightness
    end

    if t2.value8.defLightClock then
      t2.value5.ClockTime = t2.value8.defLightClock
    end

    if t2.value8.defLightAmbient then
      t2.value5.OutdoorAmbient = t2.value8.defLightAmbient
    end

    t2.value5.ExposureCompensation = 0
  end)
end
t2.value8.antiRagdollNoSplatterCooldown = 0
function t2.value8.forceNoSplatterReset()
  local Character = t2.value7.Character

  if not Character then
    return
  end

  local Humanoid = Character:FindFirstChildOfClass("Humanoid")
  local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

  if not Humanoid or (not HumanoidRootPart or Humanoid.Health <= 0) then
    return
  end

  pcall(function()
    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    HumanoidRootPart.Velocity = Vector3.zero
    HumanoidRootPart.RotVelocity = Vector3.zero
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero

    for _, descendant in ipairs(Character:GetDescendants()) do
      if descendant:IsA("Motor6D") then
        descendant.Enabled = true
      end

      if descendant:IsA("Constraint") then
        descendant.Enabled = true
      end
    end

    workspace.CurrentCamera.CameraSubject = Humanoid

    local PlayerModule = t2.value7.PlayerScripts:FindFirstChild("PlayerModule")

    if PlayerModule then
      local ControlModule = require(PlayerModule:FindFirstChild("ControlModule"))

      if ControlModule then
        ControlModule:Enable()
      end
    end

    Humanoid.AutoRotate = true
    Humanoid.PlatformStand = false
    Humanoid.Sit = false
  end)
end
function t2.value8.startAntiRagdoll()
  if t2.value8.Conns.antiRag then
    return
  end

  t2.value8.Conns.antiRag = t2.value4.Heartbeat:Connect(function()
    if not t2.value8.antiRagdollEnabled then
      return
    end

    local Character = t2.value7.Character

    if not Character then
      return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local v1544 = not Humanoid
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if not v1544 then
      v1544 = Humanoid.Health <= 0
    end

    if v1544 then
      return
    end

    local State = Humanoid:GetState()
    local v1547 = State == Enum.HumanoidStateType.Physics or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown)

    if t2.value8.antiRagdollMode == "No Splatter" then
      if v1547 then
        local timestamp = tick()

        if timestamp - (t2.value8.antiRagdollNoSplatterCooldown or 0) > 0.15 then
          t2.value8.antiRagdollNoSplatterCooldown = timestamp
          t2.value8.forceNoSplatterReset()
        end
      end

      return
    end

    if not HumanoidRootPart then
      return
    end

    local RagdollEndTime = t2.value7:GetAttribute("RagdollEndTime")

    if RagdollEndTime and RagdollEndTime - workspace:GetServerTimeNow() > 0 then
      v1547 = true
    end

    if v1547 then
      local GetDescendants = Character.GetDescendants
      pcall(function()
        t2.value7:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
      end)
      for v1553, v1554 in ipairs(GetDescendants(Character)) do

        if v1554:IsA("BallSocketConstraint") or v1554:IsA("Attachment") and v1554.Name:find("RagdollAttachment") then
          v1554:Destroy()
        end
      end
      local GetDescendants2 = Character.GetDescendants
      for v1558, v1559 in ipairs(GetDescendants2(Character)) do

        if v1559:IsA("Motor6D") and v1559.Enabled == false then
          v1559.Enabled = true
        end
      end
      if Humanoid.Health > 0 then
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
      end
      workspace.CurrentCamera.CameraSubject = Humanoid
      HumanoidRootPart.Anchored = false
      HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
      HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    end
  end)
end
function t2.value8.stopAntiRagdoll()
  if t2.value8.Conns.antiRag then
    t2.value8.Conns.antiRag:Disconnect()
    t2.value8.Conns.antiRag = nil
  end
end
t2.value8.jumpHeld = false
t2.value8.infJumpThread = nil
t2.value8._infJumpBoosting = false
t2.value8._infJumpLastBoost = 0
t2.value8.INF_JUMP_BOOST_FORCE = 25
t2.value8.INF_JUMP_BOOST_FRAMES = 2
t2.value8.INF_JUMP_BOOST_COOLDOWN = 0.12
function t2.value47(p108)
  if not p108 or t2.value8._infJumpBoosting then
    return
  end
  local timestamp = tick()
  if timestamp - t2.value8._infJumpLastBoost < t2.value8.INF_JUMP_BOOST_COOLDOWN then
    return
  end
  t2.value8._infJumpLastBoost = timestamp
  t2.value8._infJumpBoosting = true
  local BodyVelocity = Instance.new("BodyVelocity")
  BodyVelocity.MaxForce = Vector3.new(0, 1e999, 0)
  BodyVelocity.P = 1250
  BodyVelocity.Velocity = Vector3.new(p108.Velocity.X, t2.value8.INF_JUMP_BOOST_FORCE, p108.Velocity.Z)
  BodyVelocity.Parent = p108
  local n15 = 0
  local connection
  connection = t2.value4.Heartbeat:Connect(function()
    if n15 < t2.value8.INF_JUMP_BOOST_FRAMES then
      n15 += 1

      if BodyVelocity and BodyVelocity.Parent then
        BodyVelocity.Velocity = BodyVelocity.Velocity + Vector3.new(0, 0.01, 0)

        return
      end
    else
    if BodyVelocity then
      pcall(function()
        BodyVelocity:Destroy()
      end)
    end

    if connection then
      connection:Disconnect()
    end

    t2.value8._infJumpBoosting = false
  end
end)
end
task.spawn(function()
  local PlayerGui = t2.value7:WaitForChild("PlayerGui", 10)

  if PlayerGui then
    local GetDescendants = PlayerGui.GetDescendants

    local function v650(p109)
      if p109:IsA("GuiButton") and (p109.Name == "JumpButton" and not p109:GetAttribute("InfJumpHooked")) then
        p109:SetAttribute("InfJumpHooked", true)
        p109.MouseButton1Down:Connect(function()
          if t2.value8.infJumpEnabled then
            t2.value8.jumpHeld = true
          end
        end)
        p109.MouseButton1Up:Connect(function()
          t2.value8.jumpHeld = false
        end)
        p109.MouseLeave:Connect(function()
          t2.value8.jumpHeld = false
        end)
      end
    end

    for _, v in ipairs(GetDescendants(PlayerGui)) do
      v650(v)
    end

    PlayerGui.DescendantAdded:Connect(v650)
  end
end)
t2.value3.JumpRequest:Connect(function()
  if t2.value8.infJumpEnabled and t2.value8.infJumpMode == "manual" then
    t2.value8.jumpHeld = true
    task.delay(0.08, function()
      t2.value8.jumpHeld = false
    end)
  end
end)
t2.value3.InputBegan:Connect(function(input, gameProcessed)
  if gameProcessed then
    return
  end

  if t2.value8.infJumpEnabled and (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space) then
    t2.value8.jumpHeld = true
  end
end)
t2.value3.InputEnded:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
    t2.value8.jumpHeld = false
  end
end)

function t2.value8.startManualInfJumpLoop()
  if t2.value8.infJumpThread then
    t2.value8.infJumpThread:Disconnect()
  end

  t2.value8.infJumpThread = t2.value4.Heartbeat:Connect(function()
    if not t2.value8.infJumpEnabled or t2.value8.infJumpMode ~= "manual" then
      return
    end

    if not t2.value8.jumpHeld then
      return
    end

    local Character = t2.value7.Character

    if not Character then
      return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local v1563 = not Humanoid
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if not v1563 then
      v1563 = not HumanoidRootPart or Humanoid.Health <= 0
    end

    if v1563 then
      return
    end

    t2.value47(HumanoidRootPart)
  end)
end
function t2.value8.stopManualInfJumpLoop()
  if t2.value8.infJumpThread then
    t2.value8.infJumpThread:Disconnect()
    t2.value8.infJumpThread = nil
  end

  t2.value8.jumpHeld = false
  t2.value8._infJumpBoosting = false
end
function t2.value8.startHoldInfJump()
  if t2.value8.holdInfJumpConn then
    t2.value8.holdInfJumpConn:Disconnect()
  end

  t2.value8.holdInfJumpConn = t2.value4.Heartbeat:Connect(function()
    if not t2.value8.infJumpEnabled or t2.value8.infJumpMode ~= "hold" then
      return
    end

    local Character = t2.value7.Character

    if not Character then
      return
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local v1567 = not HumanoidRootPart
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not v1567 then
      v1567 = not Humanoid
    end

    if v1567 then
      return
    end

    local v1569 = t2.value3:IsKeyDown(Enum.KeyCode.Space) or (t2.value8.jumpHeld or Humanoid.Jump == true)
    local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

    if v1569 then
      v1569 = AssemblyLinearVelocity.Y < 35
    end

    if v1569 then
      HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 55, AssemblyLinearVelocity.Z)
    end

    local AssemblyLinearVelocity2 = HumanoidRootPart.AssemblyLinearVelocity

    if AssemblyLinearVelocity2.Y < -120 then
      HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity2.X, -120, AssemblyLinearVelocity2.Z)
    end
  end)
end
function t2.value8.stopHoldInfJump()
  if t2.value8.holdInfJumpConn then
    t2.value8.holdInfJumpConn:Disconnect()
    t2.value8.holdInfJumpConn = nil
  end
end
function t2.value8.startUnwalk()
  local Character = t2.value7.Character

  if not Character then
    return
  end

  local Humanoid = Character:FindFirstChildOfClass("Humanoid")

  if Humanoid then
    for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
      v:Stop()
    end
  end

  local Animate = Character:FindFirstChild("Animate")

  if Animate then
    t2.value8.unwalkSavedAnimate = Animate:Clone()
    Animate:Destroy()
  end
end
function t2.value8.stopUnwalk()
  local Character = t2.value7.Character

  if Character and t2.value8.unwalkSavedAnimate then
    t2.value8.unwalkSavedAnimate:Clone().Parent = Character
    t2.value8.unwalkSavedAnimate = nil
  end
end
function t2.value8.instaReset()
  if t2.value8.resetCooldown then
    return
  end

  t2.value8.resetCooldown = true
  t2.value8.resetSuccessful = false
  t2.value8.stopResetSequence = false

  local Character = t2.value7.Character

  if not Character then
    t2.value8.resetCooldown = false

    return
  end

  local Humanoid = Character:FindFirstChildOfClass("Humanoid")

  if not Humanoid then
    t2.value8.resetCooldown = false

    return
  end

  t2.value8.currentResetCharacter = Character
  t2.value8.resetOriginalHipHeight = Humanoid.HipHeight

  local u664 = false

  t2.value8.resetThread = task.spawn(function()
    local n16 = 0
    local resetOriginalHipHeight = t2.value8.resetOriginalHipHeight

    while true do
      local v1574 = Character

      if v1574 then
        v1574 = Character.Parent

        if v1574 then
          v1574 = Humanoid

          if v1574 then
            v1574 = Humanoid.Health > 0 and (not u664 and not t2.value8.stopResetSequence)
          end
        end
      end

      if not v1574 then
        break
      end

      if t2.value7.Character ~= Character then
        u664 = true

        break
      end

      pcall(function()
        Humanoid.HipHeight = 1E+30
        Humanoid.AutoRotate = true

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
          HumanoidRootPart.CanCollide = false
        end

        for _, child in ipairs(Character:GetChildren()) do
          if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
            child.CanCollide = false
          end
        end
      end)

      local v1575 = not Character

      if not v1575 then
        v1575 = not Character.Parent

        if not v1575 then
          v1575 = not Humanoid or (Humanoid.Health <= 0 or t2.value7.Character ~= Character)
        end
      end

      if v1575 then
        t2.value8.resetSuccessful = true

        break
      end

      n16 += 1

      if n16 >= 40 then
        break
      end

      task.wait(0.05)
    end

    local v1576 = not t2.value8.resetSuccessful

    if v1576 then
      v1576 = Character

      if v1576 then
        v1576 = Character.Parent and (Humanoid and (Humanoid.Health > 0 and not u664))
      end
    end

    if v1576 then
      pcall(function()
        Humanoid.Health = 0
      end)
      task.wait(0.1)

      if not Character.Parent or Humanoid.Health <= 0 then
        t2.value8.resetSuccessful = true
      end
    end

    if not t2.value8.resetSuccessful and (Character and (Character.Parent and Humanoid)) then
      pcall(function()
        Humanoid.HipHeight = resetOriginalHipHeight or 2

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
          HumanoidRootPart.CanCollide = true
        end

        for _, child in ipairs(Character:GetChildren()) do
          if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
            child.CanCollide = true
          end
        end
      end)
    end

    t2.value8.resetCooldown = false
    t2.value8.resetThread = nil
    t2.value8.currentResetCharacter = nil
    t2.value8.resetOriginalHipHeight = nil
    t2.value8.stopResetSequence = false
  end)
end
function t2.value8.stopInstaReset()
  t2.value8.stopResetSequence = true

  if t2.value8.resetThread then
    pcall(function()
      task.cancel(t2.value8.resetThread)
    end)
    t2.value8.resetThread = nil
  end

  t2.value8.resetCooldown = false
  t2.value8.currentResetCharacter = nil

  local Character = t2.value7.Character
  local v666 = Character and Character:FindFirstChildOfClass("Humanoid")

  if v666 then
    pcall(function()
      v666.HipHeight = t2.value8.resetOriginalHipHeight or 2

      local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

      if HumanoidRootPart then
        HumanoidRootPart.CanCollide = true
      end

      for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
          child.CanCollide = true
        end
      end
    end)
  end

  t2.value8.resetOriginalHipHeight = nil
  t2.value8.stopResetSequence = false
end
function t2.value8.hasBrainrotInHand()
  local Character = t2.value7.Character

  if not Character then
    return false
  end

  local GetChildren = Character.GetChildren

  for _, v in ipairs(GetChildren(Character)) do
    if not v:IsA("Tool") then
      continue
    end

    local v671 = v.Name:lower()

    if v671:find("brainrot", 1, true) or (v671:find("skibidi", 1, true) or v671:find("toilet", 1, true)) then
      return true
    end
  end

  return false
end
function t2.value8.forceLaggerCarryWhileHolding()
  if not t2.value8.hasBrainrotInHand() then
    return false
  end

  t2.value8.carrySpeedActive = false
  t2.value8.laggerModeEnabled = false
  t2.value8.laggerCarryActive = true

  return true
end
function t2.value8.toggleCarryMode()
  if t2.value8.forceLaggerCarryWhileHolding() then
    t2.value8.refreshSpeedModeLabel()

    if t2.value8.mobBtnRefs.carrySpeed then
      t2.value8.mobBtnRefs.carrySpeed(false)
    end

    if t2.value8.mobBtnRefs.lagger then
      t2.value8.mobBtnRefs.lagger(false)
    end

    if t2.value8.mobBtnRefs.laggerCarry then
      t2.value8.mobBtnRefs.laggerCarry(true)
    end

    if t2.value8.carryModeBtn then
      t2.value8.carryModeBtn.Text = "Carry Off"
    end

    if t2.value8.laggerModeBtn then
      t2.value8.laggerModeBtn.Text = "Lag Off"
    end

    if t2.value8.laggerCarryBtn then
      t2.value8.laggerCarryBtn.Text = "L.Carry On"
    end

    saveCherryConfig()

    return
  end

  t2.value8.carrySpeedActive = not t2.value8.carrySpeedActive

  if t2.value8.carrySpeedActive then
    t2.value8.laggerCarryActive = false
  end

  t2.value8.refreshSpeedModeLabel()

  if t2.value8.mobBtnRefs.carrySpeed then
    t2.value8.mobBtnRefs.carrySpeed(t2.value8.carrySpeedActive)
  end

  if t2.value8.mobBtnRefs.laggerCarry then
    t2.value8.mobBtnRefs.laggerCarry(t2.value8.laggerCarryActive)
  end

  if t2.value8.carryModeBtn then
    t2.value8.carryModeBtn.Text = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
  end

  if t2.value8.laggerCarryBtn then
    t2.value8.laggerCarryBtn.Text = not t2.value8.laggerCarryActive and "L.Carry Off" or "L.Carry On"
  end

  saveCherryConfig()
end
function t2.value8.toggleLaggerMode()
  if t2.value8.forceLaggerCarryWhileHolding() then
    t2.value8.refreshSpeedModeLabel()

    if t2.value8.mobBtnRefs.lagger then
      t2.value8.mobBtnRefs.lagger(false)
    end

    if t2.value8.mobBtnRefs.laggerCarry then
      t2.value8.mobBtnRefs.laggerCarry(true)
    end

    if t2.value8.laggerModeBtn then
      t2.value8.laggerModeBtn.Text = "Lag Off"
    end

    if t2.value8.laggerCarryBtn then
      t2.value8.laggerCarryBtn.Text = "L.Carry On"
    end

    saveCherryConfig()

    return
  end

  t2.value8.laggerModeEnabled = not t2.value8.laggerModeEnabled

  if t2.value8.laggerModeEnabled then
    t2.value8.laggerCarryActive = false
  end

  t2.value8.refreshSpeedModeLabel()

  if t2.value8.mobBtnRefs.lagger then
    t2.value8.mobBtnRefs.lagger(t2.value8.laggerModeEnabled)
  end

  if t2.value8.mobBtnRefs.laggerCarry then
    t2.value8.mobBtnRefs.laggerCarry(t2.value8.laggerCarryActive)
  end

  if t2.value8.laggerModeBtn then
    t2.value8.laggerModeBtn.Text = not t2.value8.laggerModeEnabled and "Lag Off" or "Lag On"
  end

  if t2.value8.laggerCarryBtn then
    t2.value8.laggerCarryBtn.Text = not t2.value8.laggerCarryActive and "L.Carry Off" or "L.Carry On"
  end

  saveCherryConfig()
end
function t2.value8.cycleLaggerModeBind()
  if t2.value8.forceLaggerCarryWhileHolding() then
    t2.value8.refreshSpeedModeLabel()

    if t2.value8.mobBtnRefs.carrySpeed then
      t2.value8.mobBtnRefs.carrySpeed(false)
    end

    if t2.value8.mobBtnRefs.lagger then
      t2.value8.mobBtnRefs.lagger(false)
    end

    if t2.value8.mobBtnRefs.laggerCarry then
      t2.value8.mobBtnRefs.laggerCarry(true)
    end

    if t2.value8.carryModeBtn then
      t2.value8.carryModeBtn.Text = "Carry Off"
    end

    if t2.value8.laggerModeBtn then
      t2.value8.laggerModeBtn.Text = "Lag Off"
    end

    if t2.value8.laggerCarryBtn then
      t2.value8.laggerCarryBtn.Text = "L.Carry On"
    end

    saveCherryConfig()

    return
  end

  if not t2.value8.laggerCarryActive and not t2.value8.laggerModeEnabled then
    t2.value8.laggerCarryActive = true
    t2.value8.laggerModeEnabled = false
    t2.value8.carrySpeedActive = false
  elseif t2.value8.laggerCarryActive then
    t2.value8.laggerCarryActive = false
    t2.value8.laggerModeEnabled = true
  else
  t2.value8.laggerModeEnabled = false
  t2.value8.laggerCarryActive = true
  t2.value8.carrySpeedActive = false
end

t2.value8.refreshSpeedModeLabel()

if t2.value8.mobBtnRefs.carrySpeed then
  t2.value8.mobBtnRefs.carrySpeed(t2.value8.carrySpeedActive)
end

if t2.value8.mobBtnRefs.lagger then
  t2.value8.mobBtnRefs.lagger(t2.value8.laggerModeEnabled)
end

if t2.value8.mobBtnRefs.laggerCarry then
  t2.value8.mobBtnRefs.laggerCarry(t2.value8.laggerCarryActive)
end

if t2.value8.carryModeBtn then
  t2.value8.carryModeBtn.Text = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
end

if t2.value8.laggerModeBtn then
  t2.value8.laggerModeBtn.Text = not t2.value8.laggerModeEnabled and "Lag Off" or "Lag On"
end

if t2.value8.laggerCarryBtn then
  t2.value8.laggerCarryBtn.Text = not t2.value8.laggerCarryActive and "L.Carry Off" or "L.Carry On"
end

saveCherryConfig()
end
function t2.value8.toggleLaggerCarry()
  t2.value8.laggerCarryActive = not t2.value8.laggerCarryActive

  if t2.value8.laggerCarryActive then
    t2.value8.laggerModeEnabled = false
    t2.value8.carrySpeedActive = false
  end

  t2.value8.refreshSpeedModeLabel()

  if t2.value8.mobBtnRefs.carrySpeed then
    t2.value8.mobBtnRefs.carrySpeed(t2.value8.carrySpeedActive)
  end

  if t2.value8.mobBtnRefs.lagger then
    t2.value8.mobBtnRefs.lagger(t2.value8.laggerModeEnabled)
  end

  if t2.value8.mobBtnRefs.laggerCarry then
    t2.value8.mobBtnRefs.laggerCarry(t2.value8.laggerCarryActive)
  end

  if t2.value8.laggerModeBtn then
    t2.value8.laggerModeBtn.Text = not t2.value8.laggerModeEnabled and "Lag Off" or "Lag On"
  end

  if t2.value8.carryModeBtn then
    t2.value8.carryModeBtn.Text = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
  end

  if t2.value8.laggerCarryBtn then
    t2.value8.laggerCarryBtn.Text = not t2.value8.laggerCarryActive and "L.Carry Off" or "L.Carry On"
  end

  saveCherryConfig()
end
function t2.value8.stopAutoLeft()
  t2.value8.autoLeftEnabled = false

  if t2.value8.alConn then
    t2.value8.alConn:Disconnect()
    t2.value8.alConn = nil
  end

  t2.value8.alPhase = 1

  local Character = t2.value7.Character

  if Character then
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
      Humanoid:Move(Vector3.zero, false)
    end
  end

  if t2.value8.autoLeftSetVisual then
    t2.value8.autoLeftSetVisual(false)
  end

  if t2.value8.mobBtnRefs.autoLeft then
    t2.value8.mobBtnRefs.autoLeft(false)
  end
end
function t2.value8.stopAutoRight()
  t2.value8.autoRightEnabled = false

  if t2.value8.arConn then
    t2.value8.arConn:Disconnect()
    t2.value8.arConn = nil
  end

  t2.value8.arPhase = 1

  local Character = t2.value7.Character

  if Character then
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
      Humanoid:Move(Vector3.zero, false)
    end
  end

  if t2.value8.autoRightSetVisual then
    t2.value8.autoRightSetVisual(false)
  end

  if t2.value8.mobBtnRefs.autoRight then
    t2.value8.mobBtnRefs.autoRight(false)
  end
end
function t2.value8.startAutoLeft()
  if t2.value8.alConn then
    t2.value8.alConn:Disconnect()
  end

  t2.value8.alPhase = 1
  t2.value8.autoLeftEnabled = true
  t2.value8.alConn = t2.value4.Heartbeat:Connect(function()
    if not t2.value8.autoLeftEnabled then
      return
    end

    local Character = t2.value7.Character

    if not Character then
      return
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not HumanoidRootPart or not Humanoid then
      return
    end

    local v1583 = t2.value8.getAutoPathSpeed and t2.value8.getAutoPathSpeed() or (t2.value8.NS or 60)

    if t2.value8.alPhase == 1 then
      if (Vector3.new(t2.value8.AP_L1.X, HumanoidRootPart.Position.Y, t2.value8.AP_L1.Z) - HumanoidRootPart.Position).Magnitude < 1 then
        t2.value8.alPhase = 2

        local v1584 = t2.value8.AP_L2 - HumanoidRootPart.Position
        local vector3 = Vector3.new(v1584.X, 0, v1584.Z)

        if vector3.Magnitude > 0.01 then
          vector3 = vector3.Unit
        end

        Humanoid:Move(vector3, false)
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector3.X * v1583, HumanoidRootPart.AssemblyLinearVelocity.Y, vector3.Z * v1583)

        return
      end

      local v1586 = t2.value8.AP_L1 - HumanoidRootPart.Position
      local vector3 = Vector3.new(v1586.X, 0, v1586.Z)

      if vector3.Magnitude > 0.01 then
        vector3 = vector3.Unit
      end

      Humanoid:Move(vector3, false)
      HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector3.X * v1583, HumanoidRootPart.AssemblyLinearVelocity.Y, vector3.Z * v1583)
    elseif t2.value8.alPhase == 2 then
      if (Vector3.new(t2.value8.AP_L2.X, HumanoidRootPart.Position.Y, t2.value8.AP_L2.Z) - HumanoidRootPart.Position).Magnitude < 1 then
        Humanoid:Move(Vector3.zero, false)
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        t2.value8.autoLeftEnabled = false

        if t2.value8.alConn then
          t2.value8.alConn:Disconnect()
          t2.value8.alConn = nil
        end

        t2.value8.alPhase = 1

        if t2.value8.autoLeftSetVisual then
          t2.value8.autoLeftSetVisual(false)
        end

        if t2.value8.mobBtnRefs.autoLeft then
          t2.value8.mobBtnRefs.autoLeft(false)
        end

        return
      end

      local v1588 = t2.value8.AP_L2 - HumanoidRootPart.Position
      local vector3 = Vector3.new(v1588.X, 0, v1588.Z)

      if vector3.Magnitude > 0.01 then
        vector3 = vector3.Unit
      end

      Humanoid:Move(vector3, false)
      HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector3.X * v1583, HumanoidRootPart.AssemblyLinearVelocity.Y, vector3.Z * v1583)
    end

    if t2.value8.autoMoveSwingEnabled and not t2.value8._alSwingDebounce then
      t2.value8._alSwingDebounce = true

      local v1590 = t2.value8.findBat and t2.value8.findBat() or t2.value8.findBatForAimbot and t2.value8.findBatForAimbot()

      if v1590 then
        if Character ~= v1590.Parent then
          pcall(function()
            Humanoid:EquipTool(v1590)
          end)
        end

        pcall(function()
          v1590:Activate()
        end)
      end

      task.delay(t2.value8.autoMoveSwingInterval or 0.3, function()
        t2.value8._alSwingDebounce = false
      end)
    end
  end)
end
function t2.value8.startAutoRight()
  if t2.value8.arConn then
    t2.value8.arConn:Disconnect()
  end

  t2.value8.arPhase = 1
  t2.value8.autoRightEnabled = true
  t2.value8.arConn = t2.value4.Heartbeat:Connect(function()
    if not t2.value8.autoRightEnabled then
      return
    end

    local Character = t2.value7.Character

    if not Character then
      return
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not HumanoidRootPart or not Humanoid then
      return
    end

    local v1594 = t2.value8.getAutoPathSpeed and t2.value8.getAutoPathSpeed() or (t2.value8.NS or 60)

    if t2.value8.arPhase == 1 then
      if (Vector3.new(t2.value8.AP_R1.X, HumanoidRootPart.Position.Y, t2.value8.AP_R1.Z) - HumanoidRootPart.Position).Magnitude < 1 then
        t2.value8.arPhase = 2

        local v1595 = t2.value8.AP_R2 - HumanoidRootPart.Position
        local vector3 = Vector3.new(v1595.X, 0, v1595.Z)

        if vector3.Magnitude > 0.01 then
          vector3 = vector3.Unit
        end

        Humanoid:Move(vector3, false)
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector3.X * v1594, HumanoidRootPart.AssemblyLinearVelocity.Y, vector3.Z * v1594)

        return
      end

      local v1597 = t2.value8.AP_R1 - HumanoidRootPart.Position
      local vector3 = Vector3.new(v1597.X, 0, v1597.Z)

      if vector3.Magnitude > 0.01 then
        vector3 = vector3.Unit
      end

      Humanoid:Move(vector3, false)
      HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector3.X * v1594, HumanoidRootPart.AssemblyLinearVelocity.Y, vector3.Z * v1594)
    elseif t2.value8.arPhase == 2 then
      if (Vector3.new(t2.value8.AP_R2.X, HumanoidRootPart.Position.Y, t2.value8.AP_R2.Z) - HumanoidRootPart.Position).Magnitude < 1 then
        Humanoid:Move(Vector3.zero, false)
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        t2.value8.autoRightEnabled = false

        if t2.value8.arConn then
          t2.value8.arConn:Disconnect()
          t2.value8.arConn = nil
        end

        t2.value8.arPhase = 1

        if t2.value8.autoRightSetVisual then
          t2.value8.autoRightSetVisual(false)
        end

        if t2.value8.mobBtnRefs.autoRight then
          t2.value8.mobBtnRefs.autoRight(false)
        end

        return
      end

      local v1599 = t2.value8.AP_R2 - HumanoidRootPart.Position
      local vector3 = Vector3.new(v1599.X, 0, v1599.Z)

      if vector3.Magnitude > 0.01 then
        vector3 = vector3.Unit
      end

      Humanoid:Move(vector3, false)
      HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector3.X * v1594, HumanoidRootPart.AssemblyLinearVelocity.Y, vector3.Z * v1594)
    end

    if t2.value8.autoMoveSwingEnabled and not t2.value8._arSwingDebounce then
      t2.value8._arSwingDebounce = true

      local v1601 = t2.value8.findBat and t2.value8.findBat() or t2.value8.findBatForAimbot and t2.value8.findBatForAimbot()

      if v1601 then
        if Character ~= v1601.Parent then
          pcall(function()
            Humanoid:EquipTool(v1601)
          end)
        end

        pcall(function()
          v1601:Activate()
        end)
      end

      task.delay(t2.value8.autoMoveSwingInterval or 0.3, function()
        t2.value8._arSwingDebounce = false
      end)
    end
  end)
end
function t2.value8.enableAntiKick()
  t2.value8.antiKickEnabled = true
  task.spawn(function()
    local g1608
    while t2.value8.antiKickEnabled do
      task.wait(0.5)

      local Character = t2.value7.Character

      if Character then
        local v1603 = false
        local v1604, v1605, v1606 = ipairs(Character:GetChildren())

        repeat
          local v1607
          repeat
            v1606, v1607 = v1604(v1605, v1606)

            if not v1606 then
              g1608 = true
            end

            if g1608 then
              break
            end
          until v1607:IsA("Tool")
          if g1608 then
            break
          end
          v1607.Name:lower()
        until v1609:find("brainrot") or (v1609:find("skibidi") or v1609:find("toilet"))

        if not g1608 then
          v1603 = true
        end

        g1608 = false
        t2.value8.brainrotDetected = v1603

        if v1603 then
          if t2.value8.autoBatEnabled then
            t2.value8.stopBatAimbot()
          end

          if t2.value8.autoLeftEnabled then
            t2.value8.autoLeftEnabled = false

            if t2.value8.autoLeftSetVisual then
              t2.value8.autoLeftSetVisual(false)
            end

            t2.value8.stopAutoLeft()
          end

          if t2.value8.autoRightEnabled then
            t2.value8.autoRightEnabled = false

            if t2.value8.autoRightSetVisual then
              t2.value8.autoRightSetVisual(false)
            end

            t2.value8.stopAutoRight()
          end
        end
      end
    end
  end)
end
function t2.value8.disableAntiKick()
  t2.value8.antiKickEnabled = false
  t2.value8.brainrotDetected = false
end
function t2.value8.safeModeGetCountdownLabel()
  local ok, result = pcall(function()
    local PlayerGui = t2.value7:FindFirstChild("PlayerGui")

    if not PlayerGui then
      return nil
    end

    local DuelsMachineTopFrame = PlayerGui:FindFirstChild("DuelsMachineTopFrame")

    if not DuelsMachineTopFrame then
      return nil
    end

    local DuelsMachineTopFrame2 = DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")

    if not DuelsMachineTopFrame2 then
      return nil
    end

    local Timer = DuelsMachineTopFrame2:FindFirstChild("Timer")

    if not Timer then
      return nil
    end

    return Timer:FindFirstChild("Label")
  end)

  return ok and result or nil
end
function t2.value8.safeModeCountdownNumber(p110)
  local _tostring = tostring

  if not p110 then
    p110 = ""
  end

  local v680 = _tostring(p110):upper():gsub("^%s+", ""):gsub("%s+$", "")

  if v680 == "GO" or (v680 == "START" or v680 == "READY") then
    return true
  end

  local num = tonumber(v680)

  return num ~= nil and (num >= 0 and num <= 10)
end
function t2.value8.safeModeInDuelCountdown()
  local v682 = t2.value8.safeModeGetCountdownLabel()

  return v682 and t2.value8.safeModeCountdownNumber(v682.Text) or false
end
t2.value8.SAFE_MODE_BLOCKED_TOOLS = {
bat = true,
slap = true,
sword = true,
gun = true,
pistol = true,
rifle = true,
medusa = true,
hammer = true,
axe = true,
knife = true,
katana = true,
blade = true,
fist = true
}
function t2.value8.safeModeIsCarryableTool(p111)
  if not p111 or not p111:IsA("Tool") then
    return false
  end

  local v684 = p111.Name:lower()

  for k in pairs(t2.value8.SAFE_MODE_BLOCKED_TOOLS) do
    if v684:find(k, 1, true) then
      return false
    end
  end

  return true
end
function t2.value8.safeModeHoldingBrainrot()
  local ok, result = pcall(function()
    return t2.value7:GetAttribute("Stealing")
  end)

  if ok then
    ok = result == true
  end

  if ok then
    return true
  end

  local ok4, result4 = pcall(function()
    return t2.value7:GetAttribute("AntiKick")
  end)

  if ok4 then
    ok4 = result4 == true
  end

  if ok4 then
    return true
  end

  local Character = t2.value7.Character

  if not Character then
    return false
  end

  local ok5, result5 = pcall(function()
    return Character:GetAttribute("Stealing")
  end)

  if ok5 then
    ok5 = result5 == true
  end

  if ok5 then
    return true
  end

  if t2.value8.brainrotDetected then
    return true
  end

  if t2.value8.hasBrainrotInHand and t2.value8.hasBrainrotInHand() then
    return true
  end

  local v693, v694, v695 = ipairs({
  "Carrying",
  "IsCarrying",
  "Grabbed",
  "Holding",
  "StealHold",
  "HasGrab"
  })

  repeat
    local v701

    repeat
      local v696

      v695, v696 = v693(v694, v695)

      if not v695 then
        for _, child in ipairs(Character:GetChildren()) do
          if not (child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true)) then
            continue
          end

          local v699 = child.Name:lower()
          local v700 = v699:find("brainrot")

          if not v700 then
            v700 = v699:find("animal")

            if not v700 then
              v700 = v699:find("carry")

              if not v700 then
                v700 = v699:find("grab") or (v699:find("steal") or v699:find("hold"))
              end
            end
          end

          if v700 then
            return true
          end
        end

        return false
      end

      v701 = Character:FindFirstChild(v696, true)
    until v701

    if v701:IsA("BoolValue") and v701.Value then
      return true
    end

    if v701:IsA("ObjectValue") and v701.Value then
      return true
    end
  until v701:IsA("StringValue") and v701.Value ~= ""

  return true
end
function t2.value8.safeModeIsLocked()
  if not t2.value8.safeModeEnabled then
    return false
  end

  return t2.value8.safeModeInDuelCountdown() or t2.value8.safeModeHoldingBrainrot()
end
function t2.value8.safeModeForceStop(p112)
  local v703 = false

  if t2.value8.autoBatEnabled then
    t2.value8.stopBatAimbot()
    v703 = true
  end

  if t2.value8.bypassAimbotEnabled then
    t2.value8.stopBypassAimbot()
    v703 = true
  end

  if t2.value8.autoLeftEnabled then
    t2.value8.autoLeftEnabled = false

    if t2.value8.autoLeftSetVisual then
      t2.value8.autoLeftSetVisual(false)
    end

    t2.value8.stopAutoLeft()
    v703 = true
  end

  if t2.value8.autoRightEnabled then
    t2.value8.autoRightEnabled = false

    if t2.value8.autoRightSetVisual then
      t2.value8.autoRightSetVisual(false)
    end

    t2.value8.stopAutoRight()
    v703 = true
  end

  if v703 then
    pcall(function()
      if type(showActionNotification) == "function" then
        showActionNotification(p112 or "SAFE MODE LOCK")
      end
    end)
  end
end
function t2.value8.safeModeTryStart()
  if t2.value8.safeModeIsLocked() then
    t2.value8.safeModeForceStop("SAFE MODE LOCK")

    return false
  end

  return true
end
function t2.value8.enableSafeMode()
  t2.value8.safeModeEnabled = true
end
function t2.value8.disableSafeMode()
  t2.value8.safeModeEnabled = false
end
if not t2.value8._safeModeMonitorStarted then
  t2.value8._safeModeMonitorStarted = true
  t2.value4.Heartbeat:Connect(function()
    if t2.value8.safeModeEnabled and t2.value8.safeModeIsLocked() then
      t2.value8.safeModeForceStop("SAFE MODE LOCK")
    end
  end)
end
function t2.value8.mirrorTPAimbotActive()
  return t2.value8.autoBatEnabled == true or t2.value8.bypassAimbotEnabled == true
end
function t2.value8.mirrorTPTeleportDown()
  local Character = t2.value7.Character
  local v705 = Character and Character:FindFirstChild("HumanoidRootPart")
  local v706 = Character and Character:FindFirstChildOfClass("Humanoid")

  if not v705 or (not v706 or v706.Health <= 0) then
    return
  end

  local timestamp = tick()

  if timestamp - (t2.value8.mirrorTPLastTeleport or 0) < 0.08 then
    return
  end

  t2.value8.mirrorTPLastTeleport = timestamp

  local _, v709 = v705.CFrame:ToEulerAnglesYXZ()
  local v710 = (t2.value8.MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)

  v705.CFrame = CFrame.new(v705.Position.X, v710, v705.Position.Z) * CFrame.Angles(0, v709, 0)
  v705.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end
if not t2.value8._mirrorTPStarted then
  t2.value8._mirrorTPStarted = true
  t2.value4.Heartbeat:Connect(function()
    if not t2.value8.mirrorTPDownEnabled or not t2.value8.mirrorTPAimbotActive() then
      if next(t2.value8.mirrorTPPreviousY) then
        table.clear(t2.value8.mirrorTPPreviousY)
      end

      return
    end

    for _, player in ipairs(t2.value1:GetPlayers()) do
      if not (player ~= t2.value7 and player.Character) then
        continue
      end

      local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

      if not HumanoidRootPart then
        continue
      end

      local PositionY = HumanoidRootPart.Position.Y
      local v715 = t2.value8.mirrorTPPreviousY[player.UserId]

      if v715 and v715 - PositionY >= (t2.value8.MIRROR_TP_DROP_THRESHOLD or 3) then
        pcall(t2.value8.mirrorTPTeleportDown)
        table.clear(t2.value8.mirrorTPPreviousY)

        return
      end

      t2.value8.mirrorTPPreviousY[player.UserId] = PositionY
    end
  end)
end
function t2.value8.setMirrorTPDown(p113)
  t2.value8.mirrorTPDownEnabled = p113 == true

  if not t2.value8.mirrorTPDownEnabled then
    table.clear(t2.value8.mirrorTPPreviousY)
  end

  if t2.value8.setMirrorTPVisual then
    t2.value8.setMirrorTPVisual(t2.value8.mirrorTPDownEnabled)
  end
end
function t2.value8.isStealState()
  local Character = t2.value7.Character

  if not Character then
    return false
  end

  if t2.value8.hasBrainrotInHand() then
    return true
  end

  local Humanoid = Character:FindFirstChildOfClass("Humanoid")

  if Humanoid and Humanoid.WalkSpeed < 25 then
    return true
  end

  local ok, result = pcall(function()
    return t2.value7:GetAttribute("Stealing")
  end)

  if ok then
    ok = result == true
  end

  if ok then
    return true
  end

  local ok6, result6 = pcall(function()
    return Character:GetAttribute("Stealing")
  end)

  if ok6 then
    ok6 = result6 == true
  end

  if ok6 then
    return true
  end

  return false
end
function t2.value8.getActiveMoveSpeed()
  if t2.value8.autoSwitchSpeedEnabled then
    local v723 = t2.value8.isStealState()

    if t2.value8.laggerModeEnabled or t2.value8.laggerCarryActive then
      return v723 and t2.value8.LAGGER_CARRY_SPEED or t2.value8.LAGGER_SPEED
    end

    return v723 and t2.value8.CS or t2.value8.NS
  end

  if t2.value8.hasBrainrotInHand() then
    return t2.value8.LAGGER_CARRY_SPEED
  end

  if t2.value8.laggerCarryActive then
    return t2.value8.LAGGER_CARRY_SPEED
  end

  if t2.value8.laggerModeEnabled then
    return t2.value8.LAGGER_SPEED
  end

  if t2.value8.carrySpeedActive then
    return t2.value8.CS
  end

  return t2.value8.NS
end
function t2.value8.getAutoPathSpeed()
  if t2.value8.laggerModeEnabled or t2.value8.laggerCarryActive then
    return t2.value8.LAGGER_SPEED
  end

  return t2.value8.NS
end
function t2.value8.setModeNormalFlags()
  t2.value8.carrySpeedActive = false
  t2.value8.laggerModeEnabled = false
  t2.value8.laggerCarryActive = false

  if t2.value8.mobBtnRefs.carrySpeed then
    t2.value8.mobBtnRefs.carrySpeed(false)
  end

  if t2.value8.mobBtnRefs.lagger then
    t2.value8.mobBtnRefs.lagger(false)
  end

  if t2.value8.mobBtnRefs.laggerCarry then
    t2.value8.mobBtnRefs.laggerCarry(false)
  end

  if t2.value8.carryModeBtn then
    t2.value8.carryModeBtn.Text = "Carry Off"
  end

  if t2.value8.laggerModeBtn then
    t2.value8.laggerModeBtn.Text = "Lag Off"
  end

  if t2.value8.laggerCarryBtn then
    t2.value8.laggerCarryBtn.Text = "L.Carry Off"
  end

  if t2.value8.refreshSpeedModeLabel then
    t2.value8.refreshSpeedModeLabel()
  end
end
function t2.value8.setModeCarryFlags()
  t2.value8.carrySpeedActive = true
  t2.value8.laggerModeEnabled = false
  t2.value8.laggerCarryActive = false

  if t2.value8.mobBtnRefs.carrySpeed then
    t2.value8.mobBtnRefs.carrySpeed(true)
  end

  if t2.value8.mobBtnRefs.lagger then
    t2.value8.mobBtnRefs.lagger(false)
  end

  if t2.value8.mobBtnRefs.laggerCarry then
    t2.value8.mobBtnRefs.laggerCarry(false)
  end

  if t2.value8.carryModeBtn then
    t2.value8.carryModeBtn.Text = "Carry On"
  end

  if t2.value8.laggerModeBtn then
    t2.value8.laggerModeBtn.Text = "Lag Off"
  end

  if t2.value8.laggerCarryBtn then
    t2.value8.laggerCarryBtn.Text = "L.Carry Off"
  end

  if t2.value8.refreshSpeedModeLabel then
    t2.value8.refreshSpeedModeLabel()
  end
end
function t2.value8.setModeLaggerCarryFlags()
  t2.value8.carrySpeedActive = false
  t2.value8.laggerModeEnabled = false
  t2.value8.laggerCarryActive = true

  if t2.value8.mobBtnRefs.carrySpeed then
    t2.value8.mobBtnRefs.carrySpeed(false)
  end

  if t2.value8.mobBtnRefs.lagger then
    t2.value8.mobBtnRefs.lagger(false)
  end

  if t2.value8.mobBtnRefs.laggerCarry then
    t2.value8.mobBtnRefs.laggerCarry(true)
  end

  if t2.value8.carryModeBtn then
    t2.value8.carryModeBtn.Text = "Carry Off"
  end

  if t2.value8.laggerModeBtn then
    t2.value8.laggerModeBtn.Text = "Lag Off"
  end

  if t2.value8.laggerCarryBtn then
    t2.value8.laggerCarryBtn.Text = "L.Carry On"
  end

  if t2.value8.refreshSpeedModeLabel then
    t2.value8.refreshSpeedModeLabel()
  end
end
function t2.value8.stopWalkSpeedAutoSwitch()
  if t2.value8._autoSwitchSpeedConn then
    pcall(function()
      t2.value8._autoSwitchSpeedConn:Disconnect()
    end)
    t2.value8._autoSwitchSpeedConn = nil
  end
end
function t2.value8.startWalkSpeedAutoSwitch()
  if t2.value8._autoSwitchSpeedConn then
    return
  end

  t2.value8._autoSwitchSpeedConn = t2.value4.Heartbeat:Connect(function()
    if not t2.value8.autoSwitchSpeedEnabled and (not t2.value8.autoTurnOffSpeedEnabled and not t2.value8.autoSwitchLaggerSpeedEnabled) then
      t2.value8.stopWalkSpeedAutoSwitch()

      return
    end

    local Character = t2.value7.Character

    if not Character then
      return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
      return
    end

    local v1616 = Humanoid.WalkSpeed or 16
    local num = tonumber(t2.value8.AUTO_SWITCH_THRESHOLD)
    local value8_7 = t2.value8
    local v1619 = num or 25
    local autoSwitchSpeedEnabled = value8_7.autoSwitchSpeedEnabled

    if autoSwitchSpeedEnabled then
      autoSwitchSpeedEnabled = v1616 <= v1619 and (not t2.value8.carrySpeedActive and not t2.value8.laggerCarryActive)
    end

    if autoSwitchSpeedEnabled then
      t2.value8.setModeCarryFlags()
    elseif t2.value8.autoTurnOffSpeedEnabled and (v1619 < v1616 and t2.value8.carrySpeedActive) then
      t2.value8.setModeNormalFlags()
    end

    local autoSwitchLaggerSpeedEnabled = t2.value8.autoSwitchLaggerSpeedEnabled

    if autoSwitchLaggerSpeedEnabled then
      autoSwitchLaggerSpeedEnabled = v1616 <= v1619 and (not t2.value8.laggerCarryActive and not t2.value8.laggerModeEnabled)
    end

    if autoSwitchLaggerSpeedEnabled then
      t2.value8.setModeLaggerCarryFlags()

      return
    end

    local autoSwitchLaggerSpeedEnabled2 = t2.value8.autoSwitchLaggerSpeedEnabled

    if autoSwitchLaggerSpeedEnabled2 then
      autoSwitchLaggerSpeedEnabled2 = v1619 < v1616 and t2.value8.laggerCarryActive or t2.value8.laggerModeEnabled
    end

    if autoSwitchLaggerSpeedEnabled2 then
      t2.value8.setModeNormalFlags()
    end
  end)
end
function t2.value8.refreshWalkSpeedAutoSwitch()
  if t2.value8.autoSwitchSpeedEnabled or (t2.value8.autoTurnOffSpeedEnabled or t2.value8.autoSwitchLaggerSpeedEnabled) then
    t2.value8.startWalkSpeedAutoSwitch()

    return
  end

  t2.value8.stopWalkSpeedAutoSwitch()
end
function t2.value8.updateAutoSwitchSpeed()
  if t2.value8.autoSwitchSpeedEnabled then
    local v724 = t2.value8.isStealState()

    if v724 ~= t2.value8._autoSwitchWasSteal then
      t2.value8._autoSwitchWasSteal = v724

      local v725 = t2.value8.laggerModeEnabled or t2.value8.laggerCarryActive

      if v724 then
        if v725 then
          if t2.value8.mobBtnRefs.laggerCarry then
            t2.value8.mobBtnRefs.laggerCarry(true)
          end

          if t2.value8.mobBtnRefs.carrySpeed then
            t2.value8.mobBtnRefs.carrySpeed(false)
          end

          if t2.value8.laggerCarryBtn then
            t2.value8.laggerCarryBtn.Text = "L.Carry On"
          end

          if t2.value8.carryModeBtn then
            t2.value8.carryModeBtn.Text = "Carry Off"
          end
        else
        if t2.value8.mobBtnRefs.carrySpeed then
          t2.value8.mobBtnRefs.carrySpeed(true)
        end

        if t2.value8.mobBtnRefs.laggerCarry then
          t2.value8.mobBtnRefs.laggerCarry(false)
        end

        if t2.value8.carryModeBtn then
          t2.value8.carryModeBtn.Text = "Carry On"
        end

        if t2.value8.laggerCarryBtn then
          t2.value8.laggerCarryBtn.Text = "L.Carry Off"
        end
      end
    elseif v725 then
      if t2.value8.mobBtnRefs.laggerCarry then
        t2.value8.mobBtnRefs.laggerCarry(t2.value8.laggerCarryActive)
      end

      if t2.value8.mobBtnRefs.lagger then
        t2.value8.mobBtnRefs.lagger(t2.value8.laggerModeEnabled)
      end

      if t2.value8.laggerCarryBtn then
        t2.value8.laggerCarryBtn.Text = not t2.value8.laggerCarryActive and "L.Carry Off" or "L.Carry On"
      end

      if t2.value8.laggerModeBtn then
        t2.value8.laggerModeBtn.Text = not t2.value8.laggerModeEnabled and "Lag Off" or "Lag On"
      end

      if t2.value8.carryModeBtn then
        t2.value8.carryModeBtn.Text = "Carry Off"
      end
    else
    if t2.value8.mobBtnRefs.carrySpeed then
      t2.value8.mobBtnRefs.carrySpeed(false)
    end

    if t2.value8.carryModeBtn then
      t2.value8.carryModeBtn.Text = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
    end
  end

  if t2.value8.refreshSpeedModeLabel then
    t2.value8.refreshSpeedModeLabel()
  end
end
end
end
function t2.value8.isRagdollState(p114)
  if not p114 then
    return true
  end

  local State = p114:GetState()
  local PlatformStand = p114.PlatformStand

  if not PlatformStand then
    PlatformStand = State == Enum.HumanoidStateType.Physics or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown)
  end

  return PlatformStand
end
function t2.value8.runDrop()
  if t2.value8.dropActive then
    return
  end
  t2.value8.stopAutoTPForAction()
  local Character = t2.value7.Character
  if not Character then
    return
  end
  if not Character:FindFirstChild("HumanoidRootPart") then
    return
  end
  t2.value8.dropActive = true
  local timestamp = tick()
  local connection
  connection = t2.value4.Heartbeat:Connect(function()
    local Character6 = t2.value7.Character
    local v1624 = Character6 and Character6:FindFirstChild("HumanoidRootPart")

    if not Character6 or not v1624 then
      if connection then
        connection:Disconnect()
      end

      t2.value8.dropActive = false

      return
    end

    if tick() - timestamp >= t2.value8.DROP_ASCEND_DURATION then
      if connection then
        connection:Disconnect()
      end

      local raycastParams = RaycastParams.new()

      raycastParams.FilterDescendantsInstances = { Character6 }
      raycastParams.FilterType = Enum.RaycastFilterType.Exclude

      local raycastResult = workspace:Raycast(v1624.Position, Vector3.new(0, -2000, 0), raycastParams)

      if raycastResult then
        local Humanoid = Character6:FindFirstChildOfClass("Humanoid")
        local v1628 = (Humanoid and Humanoid.HipHeight or 2) + v1624.Size.Y / 2

        v1624.CFrame = CFrame.new(v1624.Position.X, raycastResult.Position.Y + v1628, v1624.Position.Z)
        v1624.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        v1624.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
      end

      t2.value8.dropActive = false

      return
    end

    v1624.Velocity = Vector3.new(v1624.Velocity.X, t2.value8.DROP_ASCEND_SPEED, v1624.Velocity.Z)
  end)
end
function t2.value8.stopAutoTPForAction()
  if t2.value8.autoTPEnabled then
    t2.value8.stopAutoTP()
    pcall(function()
      if t2.value8.setAutoTPVisual then
        t2.value8.setAutoTPVisual(false)
      end
    end)
    pcall(function()
      if t2.value8.saveConfig then
        t2.value8.saveConfig()
      end
    end)
  end
end
t2.value48 = nil
function t2.value48()
  if t2.value8.autoResetOnDeath then
    local Character = t2.value7.Character

    if Character then
      local Humanoid = Character:FindFirstChildOfClass("Humanoid")

      if Humanoid then
        if t2.value8._deathResetConn then
          t2.value8._deathResetConn:Disconnect()
        end

        t2.value8._deathResetConn = Humanoid.Died:Connect(function()
          if t2.value8.autoResetOnDeath then
            t2.value8.instaReset()
          end
        end)
      end
    end

    if not t2.value8._deathResetCharAdded then
      t2.value8._deathResetCharAdded = t2.value7.CharacterAdded:Connect(function(_)
        task.wait(0.5)
        t2.value48()
      end)

      return
    end
  else
  if t2.value8._deathResetConn then
    t2.value8._deathResetConn:Disconnect()
    t2.value8._deathResetConn = nil
  end

  if t2.value8._deathResetCharAdded then
    t2.value8._deathResetCharAdded:Disconnect()
    t2.value8._deathResetCharAdded = nil
  end
end
end
function t2.value8.startRemoveAcc()
  if t2.value8.removeAccEnabled then
    return
  end

  t2.value8.removeAccEnabled = true

  local function v734()
    if not t2.value8.removeAccEnabled then
      return
    end

    local Character = t2.value7.Character

    if not Character then
      return
    end

    local GetDescendants = Character.GetDescendants

    for _, v in ipairs(GetDescendants(Character)) do
      local v1634 = v

      if (v1634:IsA("Accessory") or v1634:IsA("Hat")) and not t2.value8.removedAccessories[v1634] then
        t2.value8.removedAccessories[v1634] = true
        pcall(function()
          v1634:Destroy()
        end)
      end
    end
  end

  v734()
  t2.value8.removeAccConn = t2.value7.CharacterAdded:Connect(function()
    task.wait(0.5)

    if t2.value8.removeAccEnabled then
      v734()
    end
  end)
end
function t2.value8.stopRemoveAcc()
  t2.value8.removeAccEnabled = false

  if t2.value8.removeAccConn then
    t2.value8.removeAccConn:Disconnect()
    t2.value8.removeAccConn = nil
  end

  t2.value8.removedAccessories = {}
end
function t2.value8.destroyMobileButtons()
  if t2.value8.mobGuiRef then
    pcall(function()
      t2.value8.mobGuiRef:Destroy()
    end)
    t2.value8.mobGuiRef = nil
  end

  for _, v in ipairs({ "MoveeMobileButtons" }) do
    local v5 = game:GetService("CoreGui"):FindFirstChild(v)

    if v5 then
      v5:Destroy()
    end

    local PlayerGui = t2.value7:FindFirstChild("PlayerGui")

    if PlayerGui then
      local v6 = PlayerGui:FindFirstChild(v)

      if v6 then
        v6:Destroy()
      end
    end
  end

  t2.value8.mobBtnRefs = {}
end
function t2.value8.loadBtnPositions()
  if not isfile or not isfile(t2.value8.MOB_POS_FILE) then
    return {}
  end

  local ok, result = pcall(function()
    local value6 = t2.value6
    local t106 = { readfile(t2.value8.MOB_POS_FILE) }

    return value6:JSONDecode(v3(t106))
  end)

  if ok then
    ok = type(result) == "table"
  end

  if ok then
    return result
  end

  return {}
end
function t2.value8.saveBtnPositions()
  if not writefile then
    return
  end

  if not t2.value8.mobGuiRef then
    return
  end

  local t107 = {}

  for _, descendant in ipairs(t2.value8.mobGuiRef:GetDescendants()) do
    if descendant:IsA("TextButton") and descendant:GetAttribute("BtnKey") then
      local BtnKey = descendant:GetAttribute("BtnKey")
      local XOffset = descendant.Position.X.Offset
      local YOffset = descendant.Position.Y.Offset

      t107[BtnKey] = {
      x = XOffset,
      y = YOffset
      }
    end
  end

  pcall(function()
    writefile(t2.value8.MOB_POS_FILE, t2.value6:JSONEncode(t107))
  end)
end
function t2.value8.resetMobilePositions()
  pcall(function()
    if type(delfile) == "function" then
      delfile(t2.value8.MOB_POS_FILE)

      return
    end

    if type(writefile) == "function" then
      writefile(t2.value8.MOB_POS_FILE, "{}")
    end
  end)
  pcall(function()
    if isfile and (isfile(t2.value8.MOB_POS_FILE) and type(writefile) == "function") then
      writefile(t2.value8.MOB_POS_FILE, "{}")
    end
  end)
  t2.value8._forceDefaultMobPos = true
  t2.value8.buildMobileButtons()
  t2.value8._forceDefaultMobPos = false
  pcall(function()
    if not t2.value8.mobGuiRef then
      return
    end

    local t108 = {}

    for _, descendant in ipairs(t2.value8.mobGuiRef:GetDescendants()) do
      if descendant:IsA("TextButton") and descendant:GetAttribute("BtnKey") then
        local BtnKey = descendant:GetAttribute("BtnKey")
        local DefaultX = descendant:GetAttribute("DefaultX")
        local DefaultY = descendant:GetAttribute("DefaultY")

        if typeof(DefaultX) == "number" and typeof(DefaultY) == "number" then
          descendant.Position = UDim2.new(0, DefaultX, 0, DefaultY)
          t108[BtnKey] = {
          x = DefaultX,
          y = DefaultY
          }
        end
      end
    end

    if writefile then
      writefile(t2.value8.MOB_POS_FILE, t2.value6:JSONEncode(t108))
    end
  end)
end
function t2.value8.buildMobileButtons()
  t2.value8.destroyMobileButtons()

  if not t2.value8.mobileButtonsEnabled then
    return
  end

  local v748 = t2.value8._forceDefaultMobPos and {} or t2.value8.loadBtnPositions()
  local v749 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
  local v750 = math.max(44, (math.floor(t2.value8.mobileButtonsSize * t2.value8.uiScale * 0.65)))
  local v751 = math.floor(v750 * 1.3)
  local n17 = 18

  if t2.value8.circleButtonsEnabled then
    v751 = math.max(v750, (math.floor(v751 * 0.92)))
    v750 = v751
    n17 = math.floor(v751 / 2)
  end

  local ScreenGui = Instance.new("ScreenGui")

  ScreenGui.Name = "MoveeMobileButtons"
  ScreenGui.ResetOnSpawn = false
  ScreenGui.DisplayOrder = 15
  ScreenGui.IgnoreGuiInset = true
  pcall(function()
    if syn and syn.protect_gui then
      syn.protect_gui(ScreenGui)
    end
  end)

  if not pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
  end) then
    ScreenGui.Parent = t2.value7:WaitForChild("PlayerGui")
  end

  t2.value8.mobGuiRef = ScreenGui

  local value9 = t2.value9
  local value12 = t2.value12
  local value9_2 = t2.value9
  local value15 = t2.value15
  local color3_4 = Color3.fromRGB(0, 0, 0)

  if value9.R + value9.G + value9.B < 0.45 then
    color3_4 = Color3.fromRGB(255, 255, 255)
  end

  local n18 = 2
  local n19 = 8
  local v761 = v749.X - 2 * (v751 + 8) - 6

  for i, v in ipairs({
  {
  "drop",
  "DROP\nBRAINROT",
  false
  },
  {
  "autoLeft",
  "AUTO\nLEFT",
  true
  },
  {
  "autoBat",
  "AUTO\nBAT",
  true
  },
  {
  "autoRight",
  "AUTO\nRIGHT",
  true
  },
  {
  "tpDown",
  "TP\nDOWN",
  false
  },
  {
  "carrySpeed",
  "CARRY\nSPEED",
  true
  },
  {
  "lagger",
  "LAGGER\nMODE",
  true
  },
  {
  "instaReset",
  "INSTA\nRESET",
  false
  },
  {
  "laggerCarry",
  "LAGGER\nCARRY",
  true
  },
  {
  "bypass",
  "BAT\nTP",
  true
  }
  }) do
    local v764 = v[1]
    local v765 = v[2]
    local _ = v[3]
    local v767 = math.floor((i - 1) / n18)
    local v768 = v761 + (i - 1) % n18 * (v751 + n19)
    local v769 = 50 + v767 * (v750 + n19)
    local v770 = not t2.value8._forceDefaultMobPos and v748[v764] or nil
    local v771 = v770 and (type(v770.x) == "number" and v770.x) or v768
    local v772 = v770 and (type(v770.y) == "number" and v770.y) or v769
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "Btn_" .. v764
    TextButton.Size = UDim2.new(0, v751, 0, v750)
    TextButton.Position = UDim2.new(0, v771, 0, v772)
    TextButton:SetAttribute("DefaultX", v768)
    TextButton:SetAttribute("DefaultY", v769)
    TextButton.BackgroundColor3 = value12
    TextButton.BackgroundTransparency = 0.05
    TextButton.Text = v765
    TextButton.TextColor3 = value15
    TextButton.TextSize = 10
    TextButton.Font = Enum.Font.GothamBlack
    TextButton.TextWrapped = true
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = 101
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("BtnKey", v764)
    TextButton.Parent = ScreenGui
    local UICorner = Instance.new("UICorner", TextButton)
    if t2.value8.circleButtonsEnabled then
      UICorner.CornerRadius = UDim.new(1, 0)
    else
    UICorner.CornerRadius = UDim.new(0, n17)
  end
  TextButton.TextStrokeTransparency = 1
  local UIStroke = Instance.new("UIStroke")
  UIStroke.Name = "BtnStroke"
  UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  UIStroke.Color = value9
  UIStroke.Thickness = 1.5
  UIStroke.Transparency = 0.3
  UIStroke.Parent = TextButton
  local u776 = false
  local function v777(p116)
    u776 = p116

    local BtnStroke = TextButton:FindFirstChild("BtnStroke")

    if not BtnStroke then
      BtnStroke = Instance.new("UIStroke")
      BtnStroke.Name = "BtnStroke"
      BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      BtnStroke.Parent = TextButton
    end

    if p116 then
      local value2 = t2.value2
      local v1646 = TextButton
      local tweenInfo = TweenInfo.new(0.12)
      local v1648 = value9_2
      local v1649 = color3_4

      value2:Create(v1646, tweenInfo, {
      BackgroundColor3 = v1648,
      TextColor3 = v1649
      }):Play()
      TextButton.TextStrokeColor3 = value9_2
      TextButton.TextStrokeTransparency = 0.35
      BtnStroke.Color = value9_2
      BtnStroke.Thickness = 2
      BtnStroke.Transparency = 0.05

      return
    end

    local value2 = t2.value2
    local v1651 = TextButton
    local tweenInfo = TweenInfo.new(0.12)
    local Create = value2.Create
    local v1654 = value12
    local v1655 = value15

    Create(value2, v1651, tweenInfo, {
    BackgroundColor3 = v1654,
    TextColor3 = v1655
    }):Play()
    TextButton.TextStrokeTransparency = 1
    BtnStroke.Color = value9
    BtnStroke.Thickness = 1.5
    BtnStroke.Transparency = 0.3
  end
  t2.value8.mobBtnRefs[v764] = v777
  TextButton.MouseButton1Down:Connect(function()
    t2.value2:Create(TextButton, TweenInfo.new(0.05), {
    BackgroundColor3 = value9_2,
    TextColor3 = color3_4
    }):Play()
  end)
  TextButton.MouseButton1Up:Connect(function()
    if not u776 then
      local value2 = t2.value2
      local v1657 = TextButton
      local new = TweenInfo.new
      local Create = value2.Create
      local v1660 = new(0.1)
      local v1661 = value12
      local v1662 = value15

      Create(value2, v1657, v1660, {
      BackgroundColor3 = v1661,
      TextColor3 = v1662
      }):Play()
    end
  end)
  local u778 = false
  local inputPosition
  local TextButtonPosition
  TextButton.InputBegan:Connect(function(input)
    if t2.value8.uiLocked then
      return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      u778 = true
      inputPosition = input.Position
      TextButtonPosition = TextButton.Position
      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
        u778 = false
        t2.value8.saveBtnPositions()
      end
    end)
  end
end)
TextButton.InputChanged:Connect(function(input)
  local v1665 = u778

  if v1665 then
    v1665 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
  end

  if v1665 then
    local v1666 = input.Position - inputPosition

    TextButton.Position = UDim2.new(0, TextButtonPosition.X.Offset + v1666.X, 0, TextButtonPosition.Y.Offset + v1666.Y)
  end
end)
t2.value3.InputChanged:Connect(function(_)
  if u778 and t2.value8.uiLocked then
    u778 = false
  end
end)
TextButton.Activated:Connect(function()
  if v764 == "drop" then
    t2.value8.runDrop()

    return
  end

  if v764 == "tpDown" then
    t2.value8.runTPFloor()

    return
  end

  if v764 == "instaReset" then
    t2.value8.instaReset()

    return
  end

  if v764 == "autoLeft" then
    if t2.value8.autoBatEnabled then
      t2.value8.stopBatAimbot()

      if t2.value8.autoBatSetVisual then
        t2.value8.autoBatSetVisual(false)
      end

      if t2.value8.mobBtnRefs.autoBat then
        t2.value8.mobBtnRefs.autoBat(false)
      end
    end

    if t2.value8.autoRightEnabled then
      t2.value8.autoRightEnabled = false
      t2.value8.stopAutoRight()

      if t2.value8.autoRightSetVisual then
        t2.value8.autoRightSetVisual(false)
      end

      if t2.value8.mobBtnRefs.autoRight then
        t2.value8.mobBtnRefs.autoRight(false)
      end
    end

    t2.value8.autoLeftEnabled = not t2.value8.autoLeftEnabled

    if t2.value8.autoLeftEnabled then
      t2.value8.startAutoLeft()
    else
    t2.value8.stopAutoLeft()
  end

  v777(t2.value8.autoLeftEnabled)

  if t2.value8.autoLeftSetVisual then
    t2.value8.autoLeftSetVisual(t2.value8.autoLeftEnabled)
  end

  saveCherryConfig()

  return
end

if v764 == "autoRight" then
  if t2.value8.autoBatEnabled then
    t2.value8.stopBatAimbot()

    if t2.value8.autoBatSetVisual then
      t2.value8.autoBatSetVisual(false)
    end

    if t2.value8.mobBtnRefs.autoBat then
      t2.value8.mobBtnRefs.autoBat(false)
    end
  end

  if t2.value8.autoLeftEnabled then
    t2.value8.autoLeftEnabled = false
    t2.value8.stopAutoLeft()

    if t2.value8.autoLeftSetVisual then
      t2.value8.autoLeftSetVisual(false)
    end

    if t2.value8.mobBtnRefs.autoLeft then
      t2.value8.mobBtnRefs.autoLeft(false)
    end
  end

  t2.value8.autoRightEnabled = not t2.value8.autoRightEnabled

  if t2.value8.autoRightEnabled then
    t2.value8.startAutoRight()
  else
  t2.value8.stopAutoRight()
end

v777(t2.value8.autoRightEnabled)

if t2.value8.autoRightSetVisual then
  t2.value8.autoRightSetVisual(t2.value8.autoRightEnabled)
end

saveCherryConfig()

return
end

if v764 == "autoBat" then
  if t2.value8.autoLeftEnabled then
    t2.value8.autoLeftEnabled = false
    t2.value8.stopAutoLeft()

    if t2.value8.autoLeftSetVisual then
      t2.value8.autoLeftSetVisual(false)
    end

    if t2.value8.mobBtnRefs.autoLeft then
      t2.value8.mobBtnRefs.autoLeft(false)
    end
  end

  if t2.value8.autoRightEnabled then
    t2.value8.autoRightEnabled = false
    t2.value8.stopAutoRight()

    if t2.value8.autoRightSetVisual then
      t2.value8.autoRightSetVisual(false)
    end

    if t2.value8.mobBtnRefs.autoRight then
      t2.value8.mobBtnRefs.autoRight(false)
    end
  end

  if not t2.value8.autoBatEnabled then
    t2.value8.queueAutoBatStart()
  else
  t2.value8.stopBatAimbot()
end

v777(t2.value8.autoBatEnabled)

if t2.value8.autoBatSetVisual then
  t2.value8.autoBatSetVisual(t2.value8.autoBatEnabled)
end

saveCherryConfig()

return
end

if v764 == "lagger" then
  t2.value8.toggleLaggerMode()
  v777(t2.value8.laggerModeEnabled)

  if t2.value8.mobBtnRefs.carrySpeed then
    t2.value8.mobBtnRefs.carrySpeed(t2.value8.carrySpeedActive)
  end

  if t2.value8.laggerModeBtn then
    t2.value8.laggerModeBtn.Text = not t2.value8.laggerModeEnabled and "Lag Off" or "Lag On"
  end

  saveCherryConfig()

  return
end

if v764 == "carrySpeed" then
  t2.value8.toggleCarryMode()
  v777(t2.value8.carrySpeedActive)

  if t2.value8.mobBtnRefs.lagger then
    t2.value8.mobBtnRefs.lagger(t2.value8.laggerModeEnabled)
  end

  if t2.value8.carryModeBtn then
    t2.value8.carryModeBtn.Text = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
  end

  saveCherryConfig()

  return
end

if v764 == "bypass" then
  t2.value8.toggleBypassAimbot()
  v777(t2.value8.bypassAimbotEnabled)

  if t2.value8.setBypassVisual then
    t2.value8.setBypassVisual(t2.value8.bypassAimbotEnabled)
  end

  saveCherryConfig()

  return
end

if v764 == "laggerCarry" then
  t2.value8.toggleLaggerCarry()
  v777(t2.value8.laggerCarryActive)
  saveCherryConfig()
end
end)
end

if t2.value8.mobBtnRefs.autoLeft then
  t2.value8.mobBtnRefs.autoLeft(t2.value8.autoLeftEnabled)
end

if t2.value8.mobBtnRefs.autoRight then
  t2.value8.mobBtnRefs.autoRight(t2.value8.autoRightEnabled)
end

if t2.value8.mobBtnRefs.autoBat then
  t2.value8.mobBtnRefs.autoBat(t2.value8.autoBatEnabled)
end

if t2.value8.mobBtnRefs.lagger then
  t2.value8.mobBtnRefs.lagger(t2.value8.laggerModeEnabled)
end

if t2.value8.mobBtnRefs.carrySpeed then
  t2.value8.mobBtnRefs.carrySpeed(t2.value8.carrySpeedActive)
end

if t2.value8.mobBtnRefs.bypass then
  t2.value8.mobBtnRefs.bypass(t2.value8.bypassAimbotEnabled)
end

if t2.value8.mobBtnRefs.laggerCarry then
  t2.value8.mobBtnRefs.laggerCarry(t2.value8.laggerCarryActive)
end
end
t2.value49 = "CherryConfig.json"
function t2.value50()
  if type(writefile) ~= "function" then
    return
  end
  local function v787(p118)
    if type(p118) ~= "table" then
      return {
      kb = nil,
      gp = nil
      }
    end

    local v1673 = p118.kb and p118.kb.Name or nil
    local v1674 = p118.gp and p118.gp.Name or nil

    return {
    kb = v1673,
    gp = v1674
    }
  end
  local v788 = t2.value8.menuOpen ~= false
  local NS = t2.value8.NS
  local CS = t2.value8.CS
  local LAGGER_SPEED = t2.value8.LAGGER_SPEED
  local LAGGER_CARRY_SPEED = t2.value8.LAGGER_CARRY_SPEED
  local speedMethod = t2.value8.speedMethod
  local StealRadius = t2.value8.Steal.StealRadius
  local StealDuration = t2.value8.Steal.StealDuration
  local StopTime = t2.value8.Steal.StopTime
  local stealMode = t2.value8.stealMode
  local autoTPHeight = t2.value8.autoTPHeight
  local fovValue = t2.value8.fovValue
  local uiScale = t2.value8.uiScale
  local infJumpMode = t2.value8.infJumpMode
  local mobileButtonsSize = t2.value8.mobileButtonsSize
  local currentSkyTheme = t2.value8.currentSkyTheme
  local stealBarSize = t2.value8.stealBarSize
  local stealBarScale = t2.value8.stealBarScale
  local carrySpeedActive = t2.value8.carrySpeedActive
  local laggerModeEnabled = t2.value8.laggerModeEnabled
  local autoSwingEnabled = t2.value8.autoSwingEnabled
  local introSoundEnabled = t2.value8.introSoundEnabled
  local introSongChoice = t2.value8.introSongChoice
  local introGUIEnabled = t2.value8.introGUIEnabled
  local ragdollGuiEnabled = t2.value8.ragdollGuiEnabled
  local circleButtonsEnabled = t2.value8.circleButtonsEnabled
  local perButtonDragEnabled = t2.value8.perButtonDragEnabled
  local mobileButtonsEnabled = t2.value8.mobileButtonsEnabled
  local medusaResetEnabled = t2.value8.medusaResetEnabled
  local autoMoveSwingEnabled = t2.value8.autoMoveSwingEnabled
  local autoSwitchSpeedEnabled = t2.value8.autoSwitchSpeedEnabled
  local autoTurnOffSpeedEnabled = t2.value8.autoTurnOffSpeedEnabled
  local autoSwitchLaggerSpeedEnabled = t2.value8.autoSwitchLaggerSpeedEnabled
  local customFontSelected = t2.value8.customFontSelected
  local showPlayerSpeeds = t2.value8.showPlayerSpeeds
  local removeAccEnabled = t2.value8.removeAccEnabled
  local playerESPEnabled = t2.value8.playerESPEnabled
  local AutoStealEnabled = t2.value8.Steal.AutoStealEnabled
  local autoRadiusEnabled = t2.value8.autoRadiusEnabled
  local antiRagdollEnabled = t2.value8.antiRagdollEnabled
  local antiRagdollMode = t2.value8.antiRagdollMode
  local infJumpEnabled = t2.value8.infJumpEnabled
  local medusaCounterEnabled = t2.value8.medusaCounterEnabled
  local batCounterEnabled = t2.value8.batCounterEnabled
  local unwalkEnabled = t2.value8.unwalkEnabled
  local antiLagEnabled = t2.value8.antiLagEnabled
  local antiSummerBaseEnabled = t2.value8.antiSummerBaseEnabled
  local uiLocked = t2.value8.uiLocked
  local stretchRezEnabled = t2.value8.stretchRezEnabled
  local autoTPEnabled = t2.value8.autoTPEnabled
  local antiKickEnabled = t2.value8.antiKickEnabled
  local safeModeEnabled = t2.value8.safeModeEnabled
  local mirrorTPDownEnabled = t2.value8.mirrorTPDownEnabled
  local autoBatEnabled = t2.value8.autoBatEnabled
  local holdMin = t2.value8.Semi.holdMin
  local holdMax = t2.value8.Semi.holdMax
  local entryDelay = t2.value8.Semi.entryDelay
  local primeRange = t2.value8.Semi.primeRange
  local v846 = math.min(t2.value8.Semi.radius, 10)
  local lineESPEnabled = t2.value8.lineESPEnabled
  local speedESPEnabled = t2.value8.speedESPEnabled
  local autoResetOnDeath = t2.value8.autoResetOnDeath
  local animPack = t2.value8.animPack
  local headlessEnabled = t2.value8.headlessEnabled
  local korbloxEnabled = t2.value8.korbloxEnabled
  local bypassAimbotEnabled = t2.value8.bypassAimbotEnabled
  local animPackEnabled = t2.value8.animPackEnabled
  local v855 = v787(t2.value8.KB.DropBrainrot)
  local v856 = v787(t2.value8.KB.AutoLeft)
  local v857 = v787(t2.value8.KB.AutoRight)
  local v858 = v787(t2.value8.KB.AutoBat)
  local v859 = v787(t2.value8.KB.LaggerToggle)
  local v860 = v787(t2.value8.KB.TPFloor)
  local v861 = v787(t2.value8.KB.InstaReset)
  local v862 = v787(t2.value8.KB.GuiHide)
  local v863 = v787(t2.value8.KB.SpeedToggle)
  local v864 = v787(t2.value8.KB.BypassAimbot)
  local t109 = {
  colorScheme = "Red",
  menuOpen = v788,
  normalSpeed = NS,
  carrySpeed = CS,
  laggerSpeed = LAGGER_SPEED,
  laggerCarrySpeed = LAGGER_CARRY_SPEED,
  speedMethod = speedMethod,
  grabRadius = StealRadius,
  stealDuration = StealDuration,
  stealStopTime = StopTime,
  stealMode = stealMode,
  autoTPHeight = autoTPHeight,
  fovValue = fovValue,
  uiScale = uiScale,
  infJumpMode = infJumpMode,
  mobileButtonsSize = mobileButtonsSize,
  skyTheme = currentSkyTheme,
  stealBarSize = stealBarSize,
  stealBarScale = stealBarScale,
  carrySpeedActive = carrySpeedActive,
  laggerModeEnabled = laggerModeEnabled,
  autoSwing = autoSwingEnabled,
  introSoundEnabled = introSoundEnabled,
  introSongChoice = introSongChoice,
  introGUIEnabled = introGUIEnabled,
  ragdollGui = ragdollGuiEnabled,
  circleButtonsEnabled = circleButtonsEnabled,
  perButtonDrag = perButtonDragEnabled,
  mobileButtonsEnabled = mobileButtonsEnabled,
  medusaReset = medusaResetEnabled,
  autoMoveSwing = autoMoveSwingEnabled,
  autoSwitchSpeed = autoSwitchSpeedEnabled,
  autoTurnOffSpeed = autoTurnOffSpeedEnabled,
  autoSwitchLaggerSpeed = autoSwitchLaggerSpeedEnabled,
  customFont = customFontSelected,
  showPlayerSpeeds = showPlayerSpeeds,
  removeAcc = removeAccEnabled,
  playerESPEnabled = playerESPEnabled,
  autoStealEnabled = AutoStealEnabled,
  autoRadiusEnabled = autoRadiusEnabled,
  antiRagdoll = antiRagdollEnabled,
  antiRagdollMode = antiRagdollMode,
  infiniteJump = infJumpEnabled,
  medusaCounter = medusaCounterEnabled,
  batCounter = batCounterEnabled,
  unwalkEnabled = unwalkEnabled,
  antiLag = antiLagEnabled,
  antiSummerBase = antiSummerBaseEnabled,
  uiLocked = uiLocked,
  stretchRez = stretchRezEnabled,
  autoTPEnabled = autoTPEnabled,
  antiKick = antiKickEnabled,
  safeMode = safeModeEnabled,
  mirrorTPDown = mirrorTPDownEnabled,
  autoBat = autoBatEnabled,
  semiHoldMin = holdMin,
  semiHoldMax = holdMax,
  semiEntryDelay = entryDelay,
  semiPrimeRange = primeRange,
  semiRadius = v846,
  lineESPEnabled = lineESPEnabled,
  speedESPEnabled = speedESPEnabled,
  autoResetOnDeath = autoResetOnDeath,
  animPack = animPack,
  headlessEnabled = headlessEnabled,
  korbloxEnabled = korbloxEnabled,
  bypassAimbotEnabled = bypassAimbotEnabled,
  animPackEnabled = animPackEnabled,
  dropBrainrotKey = v855,
  autoLeftKey = v856,
  autoRightKey = v857,
  autoBatKey = v858,
  laggerToggleKey = v859,
  tpFloorKey = v860,
  instaResetKey = v861,
  guiHideKey = v862,
  speedToggleKey = v863,
  bypassAimbotKey = v864
  }
  local u866 = t109
  pcall(function()
    writefile(t2.value49, t2.value6:JSONEncode(u866))
  end)
end
t2.value8.saveConfig = t2.value50
local RunService = game:GetService("RunService")

t2.value51 = {
LineESP = false,
SpeedESP = false
}
t2.value52 = {}
t2.value53 = nil
t2.value53 = false
pcall(function()
  if Drawing then
    if type(Drawing.new) ~= "function" then
    end
  end
end)

function t2.value54(p119)
  local v874 = t2.value52[p119]

  if not v874 then
    return
  end

  for _, v in pairs(v874) do
    local v877 = v

    pcall(function()
      if typeof(v877) == "Instance" then
        v877:Destroy()

        return
      end

      if v877.Remove then
        v877:Remove()
      end
    end)
  end

  t2.value52[p119] = nil
end
function t2.value55(p120)
  local u879
  pcall(function()
    u879 = p120.AssemblyLinearVelocity
  end)
  if not u879 then
    pcall(function()
      u879 = p120.Velocity
    end)
  end
  if not u879 then
    return 0
  end

  return Vector3.new(u879.X, 0, u879.Z).Magnitude
end
function t2.value56(p121)
  if t2.value52[p121] then
    return t2.value52[p121]
  end

  local t110 = {}
  local Highlight = Instance.new("Highlight")

  Highlight.FillTransparency = 1
  Highlight.OutlineTransparency = 0
  Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  Highlight.Enabled = false
  Highlight.Parent = workspace
  t110.Highlight = Highlight

  local BillboardGui = Instance.new("BillboardGui")

  BillboardGui.Size = UDim2.fromOffset(150, 32)
  BillboardGui.StudsOffset = Vector3.new(0, 3.25, 0)
  BillboardGui.AlwaysOnTop = true
  BillboardGui.Enabled = false
  BillboardGui.ResetOnSpawn = false
  BillboardGui.Parent = t2.value7:WaitForChild("PlayerGui")

  local TextLabel = Instance.new("TextLabel", BillboardGui)

  TextLabel.Size = UDim2.fromScale(1, 1)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = "0.0 spd"
  TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
  TextLabel.TextStrokeTransparency = 0
  TextLabel.Font = Enum.Font.GothamBlack
  TextLabel.TextSize = 18
  TextLabel.TextXAlignment = Enum.TextXAlignment.Center
  TextLabel.TextYAlignment = Enum.TextYAlignment.Center
  t110.Billboard = BillboardGui
  t110.SpeedText = TextLabel

  if t2.value53 then
    local drawing = Drawing.new("Line")

    drawing.Visible = false
    drawing.Thickness = 2.75
    drawing.Transparency = 1
    t110.Line = drawing
  end

  t2.value52[p121] = t110

  return t110
end
t2.value1.PlayerRemoving:Connect(function(player)
  t2.value54(player)
end)
t2.value57 = t2.value9
RunService.RenderStepped:Connect(function()
  local CurrentCamera = workspace.CurrentCamera

  if not CurrentCamera then
    return
  end

  local Character = t2.value7.Character
  local v883 = Character and Character:FindFirstChild("HumanoidRootPart")
  local vector2 = Vector2.new(CurrentCamera.ViewportSize.X * 0.5, CurrentCamera.ViewportSize.Y * 0.82)

  if v883 then
    local v885, v886 = CurrentCamera:WorldToViewportPoint(v883.Position)

    if v886 and v885.Z > 0 then
      vector2 = Vector2.new(v885.X, v885.Y)
    end
  end

  for _, player in ipairs(t2.value1:GetPlayers()) do
    if player ~= t2.value7 then
      local v889 = t2.value56(player)
      local Character7 = player.Character
      local v891 = Character7 and Character7:FindFirstChildOfClass("Humanoid")
      local v892 = Character7 and Character7:FindFirstChild("HumanoidRootPart")
      local v893 = Character7 and Character7:FindFirstChild("Head")

      if not Character7 or (not v891 or (not v892 or not (v891.Health > 0))) then
        if v889.Line then
          v889.Line.Visible = false
        end

        v889.Highlight.Enabled = false
        v889.Billboard.Enabled = false
        v889.Highlight.Adornee = nil
        v889.Billboard.Adornee = nil
      else
      v889.Highlight.Adornee = Character7
      v889.Highlight.Enabled = t2.value51.LineESP
      v889.Highlight.OutlineColor = t2.value57
      v889.Highlight.FillColor = t2.value57
      v889.Highlight.FillTransparency = 0.85

      if v889.Line then
        local v894, v895 = CurrentCamera:WorldToViewportPoint(v892.Position)

        if t2.value51.LineESP and (v895 and v894.Z > 0) then
          v889.Line.From = vector2
          v889.Line.To = Vector2.new(v894.X, v894.Y)
          v889.Line.Color = t2.value57
          v889.Line.Thickness = 2.75
          v889.Line.Visible = true
        else
        v889.Line.Visible = false
      end
    end

    if t2.value51.SpeedESP and v893 then
      v889.Billboard.Adornee = v893
      v889.Billboard.Enabled = true
      v889.SpeedText.Text = string.format("%.1f spd", t2.value55(v892))
      v889.SpeedText.TextColor3 = t2.value57
    else
    v889.Billboard.Enabled = false
    v889.Billboard.Adornee = nil
  end
end
end
end
end)

function t2.value8.trackConn(p122)
  table.insert(t2.value8._persistentConns, p122)

  return p122
end
function t2.value8.clearPersistentConns()
  for _, v in ipairs(t2.value8._persistentConns) do
    local v899 = v

    pcall(function()
      v899:Disconnect()
    end)
  end

  t2.value8._persistentConns = {}
end
function t2.value8.makeNumberCallback(p123, p124, p125, p126)
  local u906 = p124
  local u905 = p125
  local u904 = p126

  return function(p127)
    if u905 and p127 < u905 then
      return
    end

    if u904 and p127 > u904 then
      return
    end

    p123[u906] = p127

    if u906 == "mobileButtonsSize" and t2.value8.mobileButtonsEnabled then
      t2.value8.buildMobileButtons()
    end

    if u906 == "stealBarSize" then
      t2.value8.buildStatusUI()
    end

    t2.value50()
  end
end
UI_ACCENT = t2.value9
UI_ACCENT_DIM = t2.value10
UI_BG_DARK = t2.value11
UI_ROW_BG = t1.value3
UI_CARD_STROKE = t2.value10
UI_TEXT_WHITE = color3_3
UI_TEXT_PRIMARY = t2.value15
UI_TEXT_DIM = t2.value16
UI_TEXT_SECTION = color3_2
UI_BTN_BG = t2.value12
UI_TOGGLE_OFF = color3
UI_TOGGLE_KNOB = Color3.fromRGB(200, 160, 160)
UI_KNOB_ON = Color3.fromRGB(255, 255, 255)
UI_GRAD_TOP = t2.value13
UI_GRAD_BOT = t2.value14
t2.value58 = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function t2.value59(p128)
  local UICorner = Instance.new("UICorner")

  UICorner.CornerRadius = UDim.new(0, 12)
  UICorner.Parent = p128

  local UIStroke = Instance.new("UIStroke")

  UIStroke.Thickness = 1.2
  UIStroke.Color = UI_CARD_STROKE
  UIStroke.Transparency = 0.35
  UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  UIStroke.Parent = p128

  local UIGradient = Instance.new("UIGradient")

  UIGradient.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, UI_GRAD_TOP),
  ColorSequenceKeypoint.new(1, UI_GRAD_BOT)
  })
  UIGradient.Rotation = 45
  UIGradient.Parent = p128
end
function t2.value60(p129)
  local TextButton = Instance.new("TextButton")

  TextButton.Position = p129.Pos or UDim2.new(0, 0, 0, 0)
  TextButton.Size = p129.Size or UDim2.new(0, 40, 0, 23)
  TextButton.BackgroundColor3 = p129.Bg or UI_BTN_BG
  TextButton.BorderSizePixel = 0
  TextButton.Text = p129.Text or ""
  TextButton.TextColor3 = p129.Col or UI_TEXT_DIM
  TextButton.TextSize = p129.TS or 11
  TextButton.Font = Enum.Font.GothamBold
  TextButton.AutoButtonColor = false
  TextButton.ZIndex = p129.Z or 1
  TextButton.Parent = p129.Parent

  local UICorner = Instance.new("UICorner")

  UICorner.CornerRadius = UDim.new(0, p129.CR or 6)
  UICorner.Parent = TextButton

  return TextButton
end
t2.value61 = nil
function t2.value61(p130, p131)
  local Frame = Instance.new("Frame")

  Frame.Position = UDim2.new(0, 0, 0.5, -11)
  Frame.Size = UDim2.new(0, 3, 0, 22)
  Frame.BackgroundColor3 = p131 and UI_ACCENT or UI_TEXT_WHITE
  Frame.BackgroundTransparency = not p131 and 1 or 0
  Frame.BorderSizePixel = 0
  Frame.Parent = p130

  local UICorner = Instance.new("UICorner")

  UICorner.CornerRadius = UDim.new(0, 2)
  UICorner.Parent = Frame

  return Frame
end
function t2.value62(p132)
  local UIListLayout = p132:FindFirstChildOfClass("UIListLayout")
  if not UIListLayout then
    return
  end
  local UIPadding = p132:FindFirstChildOfClass("UIPadding")
  local u922
  local function v923()
    local v1676 = u922 and u922.PaddingBottom.Offset
    local v1677 = u922
    local v1678 = v1676 or 0
    local v1679 = v1677 and u922.PaddingTop.Offset
    local v1680 = UIListLayout
    local v1681 = v1679 or 0
    local v1682 = v1680.AbsoluteContentSize.Y + v1678 + v1681 + 24

    p132.CanvasSize = UDim2.new(0, 0, 0, (math.max(v1682, 1)))
  end
  u922 = UIPadding
  UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(v923)
  task.defer(v923)
  task.delay(0.15, v923)
  task.delay(0.5, v923)
end
function t2.value63(p133, p134)
  local Frame = Instance.new("Frame")

  Frame.Size = UDim2.new(1, 0, 0, 24)
  Frame.BackgroundTransparency = 1
  Frame.Parent = p133

  local Frame4 = Instance.new("Frame")

  Frame4.Position = UDim2.new(0, 0, 0.5, -6)
  Frame4.Size = UDim2.new(0, 3, 0, 13)
  Frame4.BackgroundColor3 = UI_ACCENT
  Frame4.BorderSizePixel = 0
  Frame4.Parent = Frame
  Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 2)

  local TextLabel = Instance.new("TextLabel")

  TextLabel.Position = UDim2.new(0, 12, 0, 0)
  TextLabel.Size = UDim2.new(1, -12, 1, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = p134
  TextLabel.TextColor3 = UI_TEXT_SECTION
  TextLabel.TextSize = 11
  TextLabel.Font = Enum.Font.GothamBold
  TextLabel.TextXAlignment = Enum.TextXAlignment.Left
  TextLabel.Parent = Frame

  return Frame
end
t2.value64 = nil
function t2.value64(p135, p136, p137, p138)
  local Frame = Instance.new("Frame")

  Frame.ClipsDescendants = true
  Frame.Size = UDim2.new(1, 0, 0, 44)
  Frame.BackgroundColor3 = UI_ROW_BG
  Frame.BackgroundTransparency = 0.1
  Frame.BorderSizePixel = 0

  if p138 then
    Frame.Visible = false
  end

  Frame.Parent = p135
  t2.value59(Frame)

  local TextLabel = Instance.new("TextLabel")

  TextLabel.Position = UDim2.new(0, 13, 0, 0)
  TextLabel.Size = UDim2.new(1, -84, 1, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = p136
  TextLabel.TextColor3 = UI_TEXT_PRIMARY
  TextLabel.TextSize = 13
  TextLabel.Font = Enum.Font.GothamMedium
  TextLabel.TextXAlignment = Enum.TextXAlignment.Left
  TextLabel.Parent = Frame

  local TextBox = Instance.new("TextBox")

  TextBox.Position = UDim2.new(1, -66, 0.5, -12)
  TextBox.Size = UDim2.new(0, 56, 0, 25)
  TextBox.BackgroundColor3 = UI_BTN_BG
  TextBox.BorderSizePixel = 0
  TextBox.Text = tostring(p137)
  TextBox.TextColor3 = UI_ACCENT
  TextBox.TextSize = 13
  TextBox.Font = Enum.Font.GothamBold
  TextBox.Parent = Frame
  Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

  return Frame, TextBox
end
function t2.value65(p139, p140, p141, p142)
  local Frame = Instance.new("Frame")

  Frame.ClipsDescendants = true
  Frame.Size = UDim2.new(1, 0, 0, 46)
  Frame.BackgroundColor3 = UI_ROW_BG
  Frame.BackgroundTransparency = 0.1
  Frame.BorderSizePixel = 0
  Frame.Parent = p139
  t2.value59(Frame)

  local v939 = t2.value61(Frame, p141)
  local TextLabel = Instance.new("TextLabel")

  TextLabel.Position = UDim2.new(0, 14, 0, 0)
  TextLabel.Size = UDim2.new(1, -74, 1, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = p140
  TextLabel.TextColor3 = UI_TEXT_PRIMARY
  TextLabel.TextSize = 14
  TextLabel.Font = Enum.Font.GothamMedium
  TextLabel.TextXAlignment = Enum.TextXAlignment.Left
  TextLabel.Parent = Frame

  local TextButton = Instance.new("TextButton")

  TextButton.Position = UDim2.new(1, -54, 0.5, -11)
  TextButton.Size = UDim2.new(0, 44, 0, 22)
  TextButton.BackgroundColor3 = p141 and UI_ACCENT or UI_TOGGLE_OFF
  TextButton.BorderSizePixel = 0
  TextButton.Text = ""
  TextButton.AutoButtonColor = false
  TextButton.Parent = Frame
  Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 11)

  local Frame5 = Instance.new("Frame")

  Frame5.Size = UDim2.new(0, 16, 0, 16)
  Frame5.BorderSizePixel = 0
  Frame5.Position = p141 and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
  Frame5.BackgroundColor3 = p141 and UI_KNOB_ON or UI_TOGGLE_KNOB
  Frame5.Parent = TextButton
  Instance.new("UICorner", Frame5)

  local u943 = p141

  local function v944(p143)
    u943 = p143
    t2.value2:Create(TextButton, t2.value58, {
    BackgroundColor3 = p143 and UI_ACCENT or UI_TOGGLE_OFF
    }):Play()

    local value2 = t2.value2
    local v1685 = Frame5
    local value58 = t2.value58
    local v1687 = p143 and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    local v1688 = p143 and UI_KNOB_ON or UI_TOGGLE_KNOB

    value2:Create(v1685, value58, {
    Position = v1687,
    BackgroundColor3 = v1688
    }):Play()
    t2.value2:Create(v939, t2.value58, {
    BackgroundTransparency = not p143 and 1 or 0
    }):Play()
    v939.BackgroundColor3 = UI_ACCENT
  end

  TextButton.MouseButton1Click:Connect(function()
    v944(not u943)

    if p142 then
      p142(u943)
    end

    t2.value50()
  end)

  return Frame, v944
end
function t2.value66(p144, p145, p146)
  local Frame = Instance.new("Frame")

  Frame.ClipsDescendants = true
  Frame.Size = UDim2.new(1, 0, 0, 42)
  Frame.BackgroundColor3 = UI_ROW_BG
  Frame.BackgroundTransparency = 0.1
  Frame.BorderSizePixel = 0
  Frame.Parent = p144
  t2.value59(Frame)

  local TextButton = Instance.new("TextButton")

  TextButton.Size = UDim2.new(1, 0, 1, 0)
  TextButton.BackgroundTransparency = 1
  TextButton.Text = p145
  TextButton.TextColor3 = UI_TEXT_PRIMARY
  TextButton.TextSize = 14
  TextButton.Font = Enum.Font.GothamBold
  TextButton.Parent = Frame

  local v933 = t2.value61(Frame, false)

  TextButton.MouseButton1Click:Connect(function()
    v933.BackgroundColor3 = UI_ACCENT
    t2.value2:Create(v933, t2.value58, {
    BackgroundTransparency = 0
    }):Play()
    task.delay(0.3, function()
      t2.value2:Create(v933, t2.value58, {
      BackgroundTransparency = 1
      }):Play()
    end)

    if p146 then
      p146()
    end
  end)

  return Frame, TextButton
end
function t2.value67(p147, p148, p149, p150, p151, p152)
  local v958, v959 = t2.value64(p147, p148, p149)
  local v960 = v959

  v960.FocusLost:Connect(function()
    local num = tonumber(v960.Text)

    if num and (num >= p150 and num <= p151) then
      if p152 then
        p152(num)
      end

      t2.value50()

      return
    end

    v960.Text = tostring(p149)
  end)

  return v958, v960
end
function t2.value68(p153, p154, p155, p156, p157)
  local Frame = Instance.new("Frame")

  Frame.ClipsDescendants = true
  Frame.Size = UDim2.new(1, 0, 0, 44)
  Frame.BackgroundColor3 = UI_ROW_BG
  Frame.BackgroundTransparency = 0.1
  Frame.BorderSizePixel = 0
  Frame.Parent = p153
  t2.value59(Frame)

  local TextLabel = Instance.new("TextLabel")

  TextLabel.Position = UDim2.new(0, 13, 0, 0)
  TextLabel.Size = UDim2.new(0.43, 0, 0, 44)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = p154
  TextLabel.TextColor3 = UI_TEXT_PRIMARY
  TextLabel.TextSize = 13
  TextLabel.Font = Enum.Font.GothamMedium
  TextLabel.TextXAlignment = Enum.TextXAlignment.Left
  TextLabel.Parent = Frame

  local value60 = t2.value60
  local uDim2 = UDim2.new(1, -174, 0, 8)
  local uDim2_2 = UDim2.new(0, 29, 0, 27)
  local v971 = value60({
  Parent = Frame,
  Pos = uDim2,
  Size = uDim2_2,
  Text = "<",
  Col = UI_TEXT_PRIMARY,
  TS = 13,
  CR = 7
  })
  local TextLabel7 = Instance.new("TextLabel")

  TextLabel7.Position = UDim2.new(1, -141, 0, 8)
  TextLabel7.Size = UDim2.new(0, 102, 0, 27)
  TextLabel7.BackgroundColor3 = UI_BTN_BG
  TextLabel7.BorderSizePixel = 0
  TextLabel7.Text = p155[p156 or 1]
  TextLabel7.TextColor3 = UI_TEXT_PRIMARY
  TextLabel7.TextSize = 10
  TextLabel7.Font = Enum.Font.GothamBold
  TextLabel7.Parent = Frame
  Instance.new("UICorner", TextLabel7).CornerRadius = UDim.new(0, 7)

  local value60_2 = t2.value60
  local uDim2_3 = UDim2.new(1, -35, 0, 8)
  local uDim2_4 = UDim2.new(0, 29, 0, 27)
  local v976 = value60_2({
  Parent = Frame,
  Pos = uDim2_3,
  Size = uDim2_4,
  Text = ">",
  Col = UI_TEXT_PRIMARY,
  TS = 13,
  CR = 7
  })
  local u977 = p156 or 1

  local function v978()
    TextLabel7.Text = p155[u977]

    if p157 then
      p157(p155[u977])
    end

    t2.value50()
  end

  v971.MouseButton1Click:Connect(function()
    u977 -= 1

    if u977 < 1 then
      u977 = #p155
    end

    v978()
  end)
  v976.MouseButton1Click:Connect(function()
    u977 += 1

    if not (u977 > #p155) then
    end

    v978()
  end)

  return Frame, function(p158)
    for _, v in ipairs(p155) do
      if v == p158 then
        TextLabel7.Text = v

        return
      end
    end
  end
end
t2.value69 = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.82, 0),
NumberSequenceKeypoint.new(0.28, 0.06, 0),
NumberSequenceKeypoint.new(0.52, 0.22, 0),
NumberSequenceKeypoint.new(1, 0.82, 0)
})

local function v126(p159)
  local UIStroke = Instance.new("UIStroke")

  UIStroke.Name = "AnimatedArrowBorder"
  UIStroke.Color = Color3.fromRGB(255, 255, 255)
  UIStroke.Thickness = 1.8
  UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  UIStroke.Transparency = 0.05
  UIStroke.Parent = p159

  local UIGradient = Instance.new("UIGradient")

  UIGradient.Rotation = 135
  UIGradient.Transparency = t2.value69
  UIGradient.Parent = UIStroke

  local UIStroke3 = Instance.new("UIStroke")

  UIStroke3.Name = "AnimatedArrowGlow"
  UIStroke3.Color = Color3.fromRGB(255, 255, 255)
  UIStroke3.Thickness = 3.6
  UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  UIStroke3.Transparency = 0.58
  UIStroke3.Parent = p159

  local UIGradient2 = Instance.new("UIGradient")

  UIGradient2.Name = "GlowGradient"
  UIGradient2.Rotation = 180
  UIGradient2.Transparency = t2.value69
  UIGradient2.Parent = UIStroke3
end
function t2.value70(p160, p161)
  p160.TextColor3 = Color3.fromRGB(0, 0, 0)
  p160.BackgroundColor3 = p161 and UI_ACCENT or Color3.fromRGB(220, 220, 225)

  local UIStroke = p160:FindFirstChildOfClass("UIStroke")

  if not UIStroke then
    UIStroke = Instance.new("UIStroke")
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p160
  end

  UIStroke.Color = Color3.fromRGB(255, 255, 255)
  UIStroke.Thickness = not p161 and 1.4 or 2
  UIStroke.Transparency = 0
  p160.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
  p160.TextStrokeTransparency = 0
end
function t2.value71(p162, p163, p164, p165, p166, p167, p168)
  local Frame = Instance.new("Frame")
  Frame.BackgroundTransparency = 1
  Frame.Size = UDim2.new(1, 0, 0, 46)
  Frame.AutomaticSize = Enum.AutomaticSize.Y
  Frame.ClipsDescendants = false
  Frame.Parent = p162
  local UIListLayout = Instance.new("UIListLayout")
  UIListLayout.FillDirection = Enum.FillDirection.Vertical
  UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
  UIListLayout.Padding = UDim.new(0, 6)
  UIListLayout.Parent = Frame
  local Frame6 = Instance.new("Frame")
  Frame6.LayoutOrder = 1
  Frame6.ClipsDescendants = true
  Frame6.Size = UDim2.new(1, 0, 0, 46)
  Frame6.BackgroundColor3 = UI_ROW_BG
  Frame6.BackgroundTransparency = 0.1
  Frame6.BorderSizePixel = 0
  Frame6.Parent = Frame
  t2.value59(Frame6)
  local v1011 = t2.value61(Frame6, p164)
  local TextLabel = Instance.new("TextLabel")
  TextLabel.Position = UDim2.new(0, 14, 0, 0)
  TextLabel.Size = UDim2.new(1, -110, 1, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = p163
  TextLabel.TextColor3 = UI_TEXT_PRIMARY
  TextLabel.TextSize = 14
  TextLabel.Font = Enum.Font.GothamMedium
  TextLabel.TextXAlignment = Enum.TextXAlignment.Left
  TextLabel.Parent = Frame6
  local u1013 = false
  local TextButton = Instance.new("TextButton")
  TextButton.Name = "ArrowButton"
  TextButton.Position = UDim2.new(1, -100, 0.5, -13)
  TextButton.Size = UDim2.new(0, 36, 0, 26)
  TextButton.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
  TextButton.BackgroundTransparency = 0.1
  TextButton.BorderSizePixel = 0
  TextButton.Text = "▼"
  TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  TextButton.TextSize = 14
  TextButton.Font = Enum.Font.GothamBlack
  TextButton.AutoButtonColor = false
  TextButton.Parent = Frame6
  Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 7)
  v126(TextButton)
  local TextButton2 = Instance.new("TextButton")
  TextButton2.Position = UDim2.new(1, -54, 0.5, -11)
  TextButton2.Size = UDim2.new(0, 44, 0, 22)
  TextButton2.BackgroundColor3 = p164 and UI_ACCENT or UI_TOGGLE_OFF
  TextButton2.BorderSizePixel = 0
  TextButton2.Text = ""
  TextButton2.AutoButtonColor = false
  TextButton2.Parent = Frame6
  Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 11)
  local Frame7 = Instance.new("Frame")
  Frame7.Size = UDim2.new(0, 16, 0, 16)
  Frame7.BorderSizePixel = 0
  Frame7.Position = p164 and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
  Frame7.BackgroundColor3 = p164 and UI_KNOB_ON or UI_TOGGLE_KNOB
  Frame7.Parent = TextButton2
  Instance.new("UICorner", Frame7)
  local _Instance = Instance
  local v1018 = #p165 > 4
  local v1019 = _Instance.new("Frame")
  v1019.LayoutOrder = 2
  v1019.Size = UDim2.new(1, 0, 0, not v1018 and 40 or 140)
  v1019.BackgroundColor3 = UI_ROW_BG
  v1019.BackgroundTransparency = 0.12
  v1019.BorderSizePixel = 0
  v1019.Visible = false
  v1019.ClipsDescendants = true
  v1019.Parent = Frame
  t2.value59(v1019)
  local UIPadding = Instance.new("UIPadding")
  UIPadding.PaddingLeft = UDim.new(0, 8)
  UIPadding.PaddingRight = UDim.new(0, 8)
  UIPadding.PaddingTop = UDim.new(0, 6)
  UIPadding.PaddingBottom = UDim.new(0, 6)
  UIPadding.Parent = v1019
  local v1021 = v1019
  if v1018 then
    v1021 = Instance.new("ScrollingFrame")
    v1021.Name = "OptionsScroll"
    v1021.Size = UDim2.new(1, -4, 1, -4)
    v1021.Position = UDim2.new(0, 2, 0, 2)
    v1021.BackgroundTransparency = 1
    v1021.BorderSizePixel = 0
    v1021.ScrollBarThickness = 5
    v1021.ScrollBarImageColor3 = UI_ACCENT
    v1021.ScrollingDirection = Enum.ScrollingDirection.Y
    v1021.ElasticBehavior = Enum.ElasticBehavior.Always
    v1021.CanvasSize = UDim2.new(0, 0, 0, 0)
    v1021.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v1021.Parent = v1019

    local UIPadding2 = Instance.new("UIPadding")

    UIPadding2.PaddingLeft = UDim.new(0, 6)
    UIPadding2.PaddingRight = UDim.new(0, 8)
    UIPadding2.PaddingTop = UDim.new(0, 4)
    UIPadding2.PaddingBottom = UDim.new(0, 8)
    UIPadding2.Parent = v1021

    local UIListLayout2 = Instance.new("UIListLayout")

    UIListLayout2.FillDirection = Enum.FillDirection.Vertical
    UIListLayout2.Padding = UDim.new(0, 5)
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Parent = v1021
  else
  local UIListLayout3 = Instance.new("UIListLayout")

  UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
  UIListLayout3.Padding = UDim.new(0, 6)
  UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
  UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
  UIListLayout3.Parent = v1019
end
local Frame8 = Instance.new("Frame")
Frame8.Name = "ModeSettings"
Frame8.LayoutOrder = 3
Frame8.Size = UDim2.new(1, 0, 0, 0)
Frame8.AutomaticSize = Enum.AutomaticSize.Y
Frame8.BackgroundTransparency = 1
Frame8.Visible = false
Frame8.Parent = Frame
local UIListLayout4 = Instance.new("UIListLayout")
UIListLayout4.Padding = UDim.new(0, 6)
UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout4.Parent = Frame8
local u1027 = p166 or 1
local t111 = {}
local u1030 = p164
local t112 = {}
local function v1031()
  local v1709 = false

  for k, v in pairs(t112) do
    local v1712 = u1013

    if v1712 then
      v1712 = k == p165[u1027]
    end

    v.Visible = v1712

    if v1712 then
      v1709 = true
    end
  end

  Frame8.Visible = v1709
end
for i, v in ipairs(p165) do
  local v1034 = i
  local TextButton3 = Instance.new("TextButton")

  TextButton3.LayoutOrder = v1034

  if v1018 then
    TextButton3.Size = UDim2.new(1, -4, 0, 30)
  else
  TextButton3.Size = UDim2.new(0, math.max(56, #tostring(v) * 9 + 18), 0, 28)
end

TextButton3.BorderSizePixel = 0
TextButton3.Text = tostring(v)
TextButton3.TextSize = not v1018 and 12 or 12
TextButton3.Font = Enum.Font.GothamBlack
TextButton3.TextXAlignment = v1018 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
TextButton3.AutoButtonColor = false
TextButton3.Parent = v1021
Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 7)

if v1018 then
  local UIPadding3 = Instance.new("UIPadding")

  UIPadding3.PaddingLeft = UDim.new(0, 10)
  UIPadding3.Parent = TextButton3
end

t2.value70(TextButton3, v1034 == u1027)
TextButton3.MouseButton1Click:Connect(function()
  u1027 = v1034

  for i2, v7 in ipairs(t111) do
    t2.value70(v7, i2 == u1027)
  end

  v1031()

  if p168 then
    p168(p165[u1027])
  end

  t2.value50()
end)
t111[v1034] = TextButton3
end
local function v1037(p169)
  u1013 = p169
  v1019.Visible = p169

  local v1718 = TextButton

  if p169 then
    p169 = "▲"
  end

  v1718.Text = p169 or "▼"
  v1031()
end
TextButton.MouseButton1Click:Connect(function()
  v1037(not u1013)
end)
local function v1038(p170)
  u1030 = p170
  t2.value2:Create(TextButton2, t2.value58, {
  BackgroundColor3 = p170 and UI_ACCENT or UI_TOGGLE_OFF
  }):Play()

  local value2 = t2.value2
  local v1721 = Frame7
  local value58 = t2.value58
  local v1723 = p170 and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
  local v1724 = p170 and UI_KNOB_ON or UI_TOGGLE_KNOB

  value2:Create(v1721, value58, {
  Position = v1723,
  BackgroundColor3 = v1724
  }):Play()
  t2.value2:Create(v1011, t2.value58, {
  BackgroundTransparency = not p170 and 1 or 0
  }):Play()
  v1011.BackgroundColor3 = UI_ACCENT
end
TextButton2.MouseButton1Click:Connect(function()
  v1038(not u1030)

  if p167 then
    p167(u1030)
  end

  t2.value50()
end)

return Frame, v1038, function(p171)
  for _, v in ipairs(p165) do
    if v == p171 then
      for i, v8 in ipairs(t111) do
        t2.value70(v8, i == u1027)
      end

      v1031()

      return
    end
  end
end, function(p172, p173)
p173.Parent = Frame8
p173.Visible = false
p173.Size = UDim2.new(1, 0, 0, 0)
p173.AutomaticSize = Enum.AutomaticSize.Y
t112[p172] = p173
task.defer(v1031)
end, function()
return p165[u1027]
end
end
function t2.value72(p174, p175, p176, p177)
  local ScrollingFrame = Instance.new("ScrollingFrame")

  ScrollingFrame.Name = p175
  ScrollingFrame.Visible = p177 ~= false
  ScrollingFrame.LayoutOrder = p176
  ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
  ScrollingFrame.BackgroundTransparency = 1
  ScrollingFrame.BorderSizePixel = 0
  ScrollingFrame.ScrollBarThickness = 8
  ScrollingFrame.ScrollBarImageColor3 = UI_ACCENT
  ScrollingFrame.ScrollBarImageTransparency = 0.15
  ScrollingFrame.ScrollingEnabled = true
  ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
  ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
  ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
  ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
  ScrollingFrame.Parent = p174

  local UIListLayout = Instance.new("UIListLayout")

  UIListLayout.Padding = UDim.new(0, 7)
  UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
  UIListLayout.Parent = ScrollingFrame

  local UIPadding = Instance.new("UIPadding")

  UIPadding.PaddingTop = UDim.new(0, 4)
  UIPadding.PaddingBottom = UDim.new(0, 40)
  UIPadding.PaddingRight = UDim.new(0, 6)
  UIPadding.PaddingLeft = UDim.new(0, 2)
  UIPadding.Parent = ScrollingFrame
  t2.value62(ScrollingFrame)

  return ScrollingFrame
end
function t2.value73(p178, p179, p180, p181, p182)
  local TextButton = Instance.new("TextButton")

  TextButton.Name = p179
  TextButton.ZIndex = 9

  if p181 then
    TextButton.Position = p181
  end

  TextButton.Size = UDim2.new(0, 80, 1, 0)
  TextButton.BackgroundColor3 = p182 and UI_ACCENT or Color3.fromRGB(22, 22, 28)
  TextButton.BackgroundTransparency = not p182 and 0.25 or 0.12
  TextButton.BorderSizePixel = 0
  TextButton.Text = p180
  TextButton.TextColor3 = p182 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(235, 235, 245)
  TextButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
  TextButton.TextStrokeTransparency = not p182 and 1 or 0.15
  TextButton.TextTransparency = 0
  TextButton.TextSize = 12
  TextButton.Font = Enum.Font.GothamBlack
  TextButton.AutoButtonColor = false
  TextButton.Parent = p178
  Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)

  local UIStroke = Instance.new("UIStroke")

  UIStroke.Name = "TabStroke"
  UIStroke.Color = Color3.fromRGB(255, 255, 255)
  UIStroke.Thickness = not p182 and 1 or 2
  UIStroke.Transparency = not p182 and 0.55 or 0
  UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  UIStroke.Parent = TextButton
  TextButton:SetAttribute("IsActiveTab", not not p182)
  TextButton.MouseEnter:Connect(function()
    if not TextButton:GetAttribute("IsActiveTab") then
      local value2 = t2.value2
      local v1694 = TextButton
      local value58 = t2.value58
      local _UI_ACCENT = UI_ACCENT
      local Create = value2.Create
      local color3_5 = Color3.fromRGB(0, 0, 0)

      Create(value2, v1694, value58, {
      BackgroundColor3 = _UI_ACCENT,
      BackgroundTransparency = 0.45,
      TextColor3 = color3_5
      }):Play()

      local TabStroke = TextButton:FindFirstChild("TabStroke")

      if TabStroke then
        TabStroke.Transparency = 0.15
        TabStroke.Thickness = 1.6
      end

      TextButton.TextStrokeTransparency = 0.25
    end
  end)
  TextButton.MouseLeave:Connect(function()
    if not TextButton:GetAttribute("IsActiveTab") then
      local value2 = t2.value2
      local v1701 = TextButton
      local value58 = t2.value58
      local fromRGB = Color3.fromRGB
      local Create = value2.Create
      local v1705 = fromRGB(22, 22, 28)
      local color3_6 = Color3.fromRGB(235, 235, 245)

      Create(value2, v1701, value58, {
      BackgroundColor3 = v1705,
      BackgroundTransparency = 0.25,
      TextColor3 = color3_6
      }):Play()

      local TabStroke = TextButton:FindFirstChild("TabStroke")

      if TabStroke then
        TabStroke.Transparency = 0.55
        TabStroke.Thickness = 1
      end

      TextButton.TextStrokeTransparency = 1
    end
  end)
  TextButton.MouseButton1Down:Connect(function()
    TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.TextStrokeTransparency = 0.1

    local TabStroke = TextButton:FindFirstChild("TabStroke")

    if TabStroke then
      TabStroke.Color = Color3.fromRGB(255, 255, 255)
      TabStroke.Transparency = 0
      TabStroke.Thickness = 2
    end
  end)

  return TextButton
end
function t2.value8.applyCustomBackground(_)
end
function t2.value8.buildGui()
  t2.value8.clearPersistentConns()
  local g1269
  for _, v in ipairs({
  "MoveeDuels",
  "Cherry_Menu",
  "K7HubGUI",
  "VantaHubUI",
  "VynxxHubUI",
  "VynxHubUI",
  "AceDuelsAdaptReconstruct"
  }) do
    do
      local v9 = game:GetService("CoreGui"):FindFirstChild(v)

      if v9 then
        v9:Destroy()
      end
    end

    local PlayerGui = t2.value7:FindFirstChild("PlayerGui")

    if PlayerGui then
      local v10 = PlayerGui:FindFirstChild(v)

      if v10 then
        v10:Destroy()
      end
    end
  end
  t2.value8.buildStatusUI()
  local Frame, u1058, v1073, v1074, Frame9, u1083, u1084, v1088, v1156, v1158, v1189, v1206, n21, n22
  do
    local v1072

    do
      local v1071

      do
        local Frame10

        do
          local v1070

          do
            local v1091

            do
              local ScreenGui = Instance.new("ScreenGui")

              ScreenGui.Name = "VynxHubUI"
              ScreenGui.ResetOnSpawn = false
              ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
              ScreenGui.Parent = t2.value7:WaitForChild("PlayerGui")
              Frame = Instance.new("Frame")
              Frame.Name = "Frame"
              Frame.ClipsDescendants = true
              Frame.Position = UDim2.new(0, 22, 0.5, -150)
              Frame.Size = UDim2.new(0, 420, 0, 528)
              Frame.BackgroundColor3 = t2.value11
              Frame.BorderSizePixel = 0
              Frame.Active = true
              Frame.Parent = ScreenGui
              t2.value8.mainFrame = Frame

              do
                local UIScale = Instance.new("UIScale")

                UIScale.Name = "BDUIScale"
                UIScale.Scale = t2.value8.uiScale or 0.8
                UIScale.Parent = Frame
                t2.value8.uiScaleRef = UIScale

                local UICorner = Instance.new("UICorner")

                UICorner.Name = "MainCorner"
                UICorner.CornerRadius = UDim.new(0, 22)
                UICorner.Parent = Frame

                local UIGradient = Instance.new("UIGradient")

                UIGradient.Name = "MainGradient"

                local value9 = t2.value9
                local value11 = t2.value11

                UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, value11:Lerp(value9, 0.12)),
                ColorSequenceKeypoint.new(0.45, value11),
                ColorSequenceKeypoint.new(1, value11:Lerp(value9, 0.06))
                })
                UIGradient.Rotation = 120
                UIGradient.Parent = Frame

                local UIStroke = Instance.new("UIStroke")

                UIStroke.Name = "MainStroke"
                UIStroke.Color = t2.value9
                UIStroke.Thickness = 1.4
                UIStroke.Transparency = 0.45
                UIStroke.Parent = Frame
              end

              local Frame11 = Instance.new("Frame")

              Frame11.Size = UDim2.new(1, 0, 0, 68)
              Frame11.BackgroundTransparency = 1
              Frame11.Active = true
              Frame11.Parent = Frame

              local TextButton

              do
                local ScrollingFrame

                do
                  local TextLabel = Instance.new("TextLabel")

                  TextLabel.ZIndex = 3
                  TextLabel.Position = UDim2.new(0, 18, 0, 13)
                  TextLabel.Size = UDim2.new(0, 380, 0, 34)
                  TextLabel.BackgroundTransparency = 1
                  TextLabel.Text = "Kevin Hub"
                  TextLabel.TextColor3 = t2.value15
                  TextLabel.TextSize = 28
                  TextLabel.Font = Enum.Font.GothamBlack
                  TextLabel.TextXAlignment = Enum.TextXAlignment.Center
                  TextLabel.RichText = true
                  TextLabel.Parent = Frame11

                  local TextLabel8 = Instance.new("TextLabel")

                  TextLabel8.ZIndex = 3
                  TextLabel8.Position = UDim2.new(0, 18, 0, 45)
                  TextLabel8.Size = UDim2.new(0, 380, 0, 13)
                  TextLabel8.BackgroundTransparency = 1
                  TextLabel8.Text = "https://discord.gg/TBBAUZu8cW"
                  TextLabel8.TextColor3 = t2.value16
                  TextLabel8.TextSize = 11
                  TextLabel8.Font = Enum.Font.GothamMedium
                  TextLabel8.TextXAlignment = Enum.TextXAlignment.Center
                  TextLabel8.Parent = Frame11
                  TextButton = Instance.new("TextButton")
                  TextButton.ZIndex = 3
                  TextButton.Position = UDim2.new(1, -42, 0, 13)
                  TextButton.Size = UDim2.new(0, 30, 0, 30)
                  TextButton.BackgroundColor3 = UI_BTN_BG
                  TextButton.BorderSizePixel = 0
                  TextButton.Text = "-"
                  TextButton.TextColor3 = UI_TEXT_PRIMARY
                  TextButton.TextSize = 13
                  TextButton.Font = Enum.Font.GothamBold
                  TextButton.AutoButtonColor = false
                  TextButton.Parent = Frame11
                  Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)
                  TextButton.MouseButton1Down:Connect(function()
                    t2.value2:Create(TextButton, t2.value58, {
                    BackgroundColor3 = UI_ACCENT
                    }):Play()
                  end)
                  TextButton.MouseButton1Up:Connect(function()
                    t2.value2:Create(TextButton, t2.value58, {
                    BackgroundColor3 = UI_BTN_BG
                    }):Play()
                  end)

                  local TextButton4 = Instance.new("TextButton")

                  TextButton4.Size = UDim2.new(0, 60, 0, 24)
                  TextButton4.Position = UDim2.new(1, -108, 0.5, -12)
                  TextButton4.BackgroundColor3 = UI_BTN_BG
                  TextButton4.BorderSizePixel = 0
                  TextButton4.Text = "UNLOCK"
                  TextButton4.TextColor3 = UI_TEXT_DIM
                  TextButton4.Font = Enum.Font.GothamBold
                  TextButton4.TextSize = 9
                  TextButton4.AutoButtonColor = false
                  TextButton4.ZIndex = 3
                  TextButton4.Parent = Frame11
                  Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 6)
                  u1058 = t2.value8.uiLocked == true
                  TextButton4.Text = not u1058 and "UNLOCK" or "LOCKED"
                  TextButton4.TextColor3 = u1058 and UI_ACCENT or UI_TEXT_DIM
                  TextButton4.Activated:Connect(function()
                    u1058 = not u1058
                    t2.value8.uiLocked = u1058
                    TextButton4.Text = not u1058 and "UNLOCK" or "LOCKED"
                    TextButton4.TextColor3 = u1058 and UI_ACCENT or UI_TEXT_DIM

                    if t2.value8.applyStatusUILock then
                      t2.value8.applyStatusUILock()
                    end

                    t2.value50()
                  end)

                  local Frame12 = Instance.new("Frame")

                  Frame12.Position = UDim2.new(0, 16, 0, 64)
                  Frame12.Size = UDim2.new(1, -32, 0, 1)
                  Frame12.BackgroundColor3 = UI_TEXT_WHITE
                  Frame12.BorderSizePixel = 0
                  Frame12.Parent = Frame

                  local UIGradient = Instance.new("UIGradient")

                  UIGradient.Color = ColorSequence.new(t2.value9, t2.value9)
                  UIGradient.Transparency = NumberSequence.new(0.2, 0.85)
                  UIGradient.Parent = Frame12
                  ScrollingFrame = Instance.new("ScrollingFrame")
                  ScrollingFrame.Name = "TabBar"
                  ScrollingFrame.Position = UDim2.new(0, 10, 0, 72)
                  ScrollingFrame.Size = UDim2.new(1, -20, 0, 34)
                  ScrollingFrame.BackgroundTransparency = 1
                  ScrollingFrame.BorderSizePixel = 0
                  ScrollingFrame.ScrollBarThickness = 3
                  ScrollingFrame.ScrollBarImageColor3 = UI_ACCENT
                  ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
                  ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
                  ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
                  ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
                  ScrollingFrame.Parent = Frame

                  local UIListLayout = Instance.new("UIListLayout")

                  UIListLayout.FillDirection = Enum.FillDirection.Horizontal
                  UIListLayout.Padding = UDim.new(0, 6)
                  UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                  UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                  UIListLayout.Parent = ScrollingFrame

                  local UIPadding = Instance.new("UIPadding")

                  UIPadding.PaddingLeft = UDim.new(0, 2)
                  UIPadding.PaddingRight = UDim.new(0, 8)
                  UIPadding.Parent = ScrollingFrame
                end

                local v1064 = t2.value73(ScrollingFrame, "Tab_SPEED", "SPEED", nil, true)

                v1064.LayoutOrder = 1

                local v1065 = t2.value73(ScrollingFrame, "Tab_MECH", "MECH", nil, false)

                v1065.LayoutOrder = 2

                local v1066 = t2.value73(ScrollingFrame, "Tab_VIS", "VISUALS", nil, false)

                v1066.LayoutOrder = 3

                local v1067 = t2.value73(ScrollingFrame, "Tab_UTIL", "UTILITY", nil, false)

                v1067.LayoutOrder = 4

                local v1068 = t2.value73(ScrollingFrame, "Tab_KB", "KEYBINDS", nil, false)

                v1068.LayoutOrder = 5

                local Frame13 = Instance.new("Frame")

                Frame13.Name = "PagedContent"
                Frame13.Position = UDim2.new(0, 8, 0, 108)
                Frame13.Size = UDim2.new(1, -16, 1, -120)
                Frame13.BackgroundTransparency = 1
                Frame13.Parent = Frame
                v1070 = t2.value72(Frame13, "Page_SPEED", 1, true)
                v1071 = t2.value72(Frame13, "Page_MECHANICS", 2, false)
                v1072 = t2.value72(Frame13, "Page_VISUALS", 3, false)
                v1073 = t2.value72(Frame13, "Page_UTILITY", 4, false)
                v1074 = t2.value72(Frame13, "Page_KEYBINDS", 5, false)

                local t113 = {
                SPEED = v1070,
                MECHANICS = v1071,
                VISUALS = v1072,
                UTILITY = v1073,
                KEYBINDS = v1074
                }
                local t114 = {
                SPEED = v1064,
                MECHANICS = v1065,
                VISUALS = v1066,
                UTILITY = v1067,
                KEYBINDS = v1068
                }

                local function v1077(p184)
                  if p184 == "SPEED" then
                    return
                  end
                  for v1735, v1736 in pairs(t113) do

                    v1736.Visible = v1735 == p184
                  end
                  for k, v in pairs(t114) do
                    local v1739 = k == p184

                    v:SetAttribute("IsActiveTab", v1739)
                    v.BackgroundColor3 = v1739 and UI_ACCENT or Color3.fromRGB(22, 22, 28)
                    v.BackgroundTransparency = not v1739 and 0.25 or 0.12
                    v.TextColor3 = v1739 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(235, 235, 245)
                    v.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
                    v.TextStrokeTransparency = not v1739 and 1 or 0.15

                    local TabStroke = v:FindFirstChild("TabStroke")

                    if TabStroke then
                      TabStroke.Color = Color3.fromRGB(255, 255, 255)
                      TabStroke.Thickness = not v1739 and 1 or 2
                      TabStroke.Transparency = not v1739 and 0.55 or 0
                    end
                  end
                end

                t2.value8.selectTab = v1077
                v1064.MouseButton1Click:Connect(function()
                  v1077("SPEED")
                end)
                v1065.MouseButton1Click:Connect(function()
                  v1077("MECHANICS")
                end)
                v1066.MouseButton1Click:Connect(function()
                  v1077("VISUALS")
                end)
                v1067.MouseButton1Click:Connect(function()
                  v1077("UTILITY")
                end)
                v1068.MouseButton1Click:Connect(function()
                  v1077("KEYBINDS")
                end)
              end

              Frame9 = Instance.new("Frame")
              Frame9.Visible = false
              Frame9.Active = true
              Frame9.ZIndex = 40
              Frame9.AnchorPoint = Vector2.new(0.5, 0)
              Frame9.Position = UDim2.new(0.5, 0, 0, 10)
              Frame9.Size = UDim2.new(0, 150, 0, 36)
              Frame9.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
              Frame9.BackgroundTransparency = 0.02
              Frame9.BorderSizePixel = 0
              Frame9.Parent = ScreenGui
              Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 12)

              local UIStroke = Instance.new("UIStroke")

              UIStroke.Color = t2.value9
              UIStroke.Thickness = 1.2
              UIStroke.Transparency = 0.45
              UIStroke.Parent = Frame9

              local TextLabel = Instance.new("TextLabel")

              TextLabel.Size = UDim2.new(1, 0, 1, 0)
              TextLabel.BackgroundTransparency = 1
              TextLabel.Text = "Kevin Hub"
              TextLabel.TextColor3 = t2.value9
              TextLabel.TextSize = 13
              TextLabel.Font = Enum.Font.GothamBlack
              TextLabel.Parent = Frame9

              local TextButton5 = Instance.new("TextButton")

              TextButton5.ZIndex = 41
              TextButton5.Size = UDim2.new(1, 0, 1, 0)
              TextButton5.BackgroundTransparency = 1
              TextButton5.Text = ""
              TextButton5.AutoButtonColor = false
              TextButton5.Parent = Frame9
              TextButton5.MouseButton1Click:Connect(function()
                Frame9.Visible = false
                Frame.Visible = true
                t2.value8.menuOpen = true
                pcall(t2.value50)
              end)
              TextButton.MouseButton1Click:Connect(function()
                Frame.Visible = false
                Frame9.Visible = true
                t2.value8.menuOpen = false
                pcall(t2.value50)
              end)

              local function v1082(p185, p186)
                local u1752
                local inputPosition
                local p186Position
                p185.InputBegan:Connect(function(input)
                  if t2.value8.uiLocked then
                    return
                  end

                  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    u1752 = true
                    inputPosition = input.Position
                    p186Position = p186.Position
                    input.Changed:Connect(function()
                      if input.UserInputState == Enum.UserInputState.End then
                      u1752 = false
                    end
                  end)
                end
              end)
              p185.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and u1752 then
                  local v1950 = input.Position - inputPosition

                  p186.Position = UDim2.new(p186Position.X.Scale, p186Position.X.Offset + v1950.X, p186Position.Y.Scale, p186Position.Y.Offset + v1950.Y)
                end
              end)
              t2.value3.InputChanged:Connect(function(_)
                if not (u1752 and t2.value8.uiLocked) then
                end
              end)
            end

            v1082(Frame11, Frame)
            v1082(Frame9, Frame9)
            t2.value8._anyKeyListening = false
            u1083 = nil
            t2.value8.keybindButtons = t2.value8.keybindButtons or {}
            u1084 = nil
            u1084 = nil

            local function v1085()
              if u1083 then
                for k, v in pairs(t2.value8.keybindButtons) do
                  local v1761 = k

                  if v == u1083 then
                    local t115 = {}

                    if v1761.kb then
                      table.insert(t115, v1761.kb.Name)
                    end

                    if v1761.gp then
                      table.insert(t115, v1761.gp.Name)
                    end

                    v.Text = #t115 > 0 and table.concat(t115, " / ") or "..."
                    v.TextColor3 = UI_TEXT_DIM

                    break
                  end
                end

                u1083 = nil
                t2.value8._anyKeyListening = false

                if u1084 then
                  task.cancel(u1084)
                  u1084 = nil
                end
              end
            end
            local function v1086(p188)
              if not p188 then
                return "..."
              end

              local t116 = {}

              if p188.kb then
                table.insert(t116, p188.kb.Name)
              end

              if p188.gp then
                table.insert(t116, p188.gp.Name)
              end

              if #t116 == 0 then
                return "..."
              end

              return table.concat(t116, " / ")
            end
            local function v1087(p189)
              local v1764 = p189 == Enum.UserInputType.Gamepad1

              if not v1764 then
                v1764 = p189 == Enum.UserInputType.Gamepad2

                if not v1764 then
                  v1764 = p189 == Enum.UserInputType.Gamepad3

                  if not v1764 then
                    v1764 = p189 == Enum.UserInputType.Gamepad4

                    if not v1764 then
                      v1764 = p189 == Enum.UserInputType.Gamepad5

                      if not v1764 then
                        v1764 = p189 == Enum.UserInputType.Gamepad6 or (p189 == Enum.UserInputType.Gamepad7 or p189 == Enum.UserInputType.Gamepad8)
                      end
                    end
                  end
                end
              end

              return v1764
            end

            function v1088(p190, p191, p192)
              local Frame14 = Instance.new("Frame")

              Frame14.ClipsDescendants = true
              Frame14.Size = UDim2.new(1, 0, 0, 44)
              Frame14.BackgroundColor3 = UI_ROW_BG
              Frame14.BackgroundTransparency = 0.1
              Frame14.BorderSizePixel = 0
              Frame14.Parent = p190
              t2.value59(Frame14)

              local TextLabel9 = Instance.new("TextLabel")

              TextLabel9.Position = UDim2.new(0, 13, 0, 0)
              TextLabel9.Size = UDim2.new(0.42, 0, 0, 44)
              TextLabel9.BackgroundTransparency = 1
              TextLabel9.Text = p191
              TextLabel9.TextColor3 = UI_TEXT_PRIMARY
              TextLabel9.TextSize = 13
              TextLabel9.Font = Enum.Font.GothamMedium
              TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
              TextLabel9.Parent = Frame14

              local value60 = t2.value60
              local uDim2 = UDim2.new(1, -150, 0.5, -12)
              local uDim2_5 = UDim2.new(0, 140, 0, 25)
              local v1773 = v1086(p192)
              local v1774 = value60({
              Parent = Frame14,
              Pos = uDim2,
              Size = uDim2_5,
              Text = v1773,
              Col = UI_TEXT_DIM,
              TS = 10,
              CR = 6
              })

              t2.value8.keybindButtons[p192] = v1774
              v1774.MouseButton1Click:Connect(function()
                if u1083 and u1083 ~= v1774 then
                  v1085()
                end

                u1083 = v1774
                v1774.Text = "Press key / button..."
                v1774.TextColor3 = Color3.fromRGB(150, 150, 150)
                t2.value8._anyKeyListening = true

                if u1084 then
                  task.cancel(u1084)
                end

                u1084 = task.delay(8, v1085)
              end)

              return Frame14
            end

            local function v1089(p193, p194)
              if not p193 or (not p194 or p194 == Enum.KeyCode.Unknown) then
                return false
              end

              if p193.kb and p194 == p193.kb then
                return true
              end

              if p193.gp and p194 == p193.gp then
                return true
              end

              return false
            end

            t2.value8._keybindCaptureConn = t2.value3.InputBegan:Connect(function(input, gameProcessed)
              if t2.value8._anyKeyListening then
                if u1083 then
                  local KeyCode = input.KeyCode

                  if KeyCode == Enum.KeyCode.Escape then
                    v1085()
                    pcall(t2.value50)

                    return
                  end

                  local UserInputType = input.UserInputType

                  if UserInputType == Enum.UserInputType.Keyboard and KeyCode ~= Enum.KeyCode.Unknown then
                    for k, v in pairs(t2.value8.keybindButtons) do
                      local v1781 = k

                      if v == u1083 then
                        v1781.kb = KeyCode
                        v.Text = v1086(v1781)
                        v.TextColor3 = UI_TEXT_DIM
                        u1083 = nil
                        t2.value8._anyKeyListening = false

                        if u1084 then
                          task.cancel(u1084)
                          u1084 = nil
                        end

                        pcall(t2.value50)

                        return
                      end
                    end

                    return
                  end

                  if v1087(UserInputType) and KeyCode ~= Enum.KeyCode.Unknown then
                    for k, v in pairs(t2.value8.keybindButtons) do
                      local v1784 = k

                      if v == u1083 then
                        v1784.gp = KeyCode
                        v.Text = v1086(v1784)
                        v.TextColor3 = UI_TEXT_DIM
                        u1083 = nil
                        t2.value8._anyKeyListening = false

                        if u1084 then
                          task.cancel(u1084)
                          u1084 = nil
                        end

                        pcall(t2.value50)

                        return
                      end
                    end
                  end
                end

                return
              end

              if gameProcessed then
                return
              end

              if input.UserInputType ~= Enum.UserInputType.Keyboard and not v1087(input.UserInputType) then
                return
              end

              local KeyCode = input.KeyCode

              if KeyCode == Enum.KeyCode.Unknown then
                return
              end

              if v1089(t2.value8.KB.LaggerToggle, KeyCode) then
                local timestamp = tick()

                if not t2.value8._lastLaggerBindPress or timestamp - t2.value8._lastLaggerBindPress > 0.15 then
                  t2.value8._lastLaggerBindPress = timestamp
                  t2.value8.cycleLaggerModeBind()
                end

                return
              end

              if v1089(t2.value8.KB.SpeedToggle, KeyCode) then
                t2.value8.toggleCarryMode()
                t2.value50()
              end

              if v1089(t2.value8.KB.DropBrainrot, KeyCode) then
                t2.value8.runDrop()
              end

              if v1089(t2.value8.KB.TPFloor, KeyCode) then
                t2.value8.runTPFloor()
              end

              if v1089(t2.value8.KB.InstaReset, KeyCode) then
                t2.value8.instaReset()
              end

              if v1089(t2.value8.KB.AutoLeft, KeyCode) then
                t2.value8.autoLeftEnabled = not t2.value8.autoLeftEnabled

                if t2.value8.autoLeftEnabled then
                  if t2.value8.autoRightEnabled then
                    t2.value8.autoRightEnabled = false
                    t2.value8.stopAutoRight()
                  end

                  if t2.value8.autoBatEnabled then
                    t2.value8.stopBatAimbot()
                  end

                  t2.value8.startAutoLeft()
                else
                t2.value8.stopAutoLeft()
              end

              if t2.value8.autoLeftSetVisual then
                t2.value8.autoLeftSetVisual(t2.value8.autoLeftEnabled)
              end

              if t2.value8.mobBtnRefs.autoLeft then
                t2.value8.mobBtnRefs.autoLeft(t2.value8.autoLeftEnabled)
              end

              t2.value50()
            end

            if v1089(t2.value8.KB.AutoRight, KeyCode) then
              t2.value8.autoRightEnabled = not t2.value8.autoRightEnabled

              if t2.value8.autoRightEnabled then
                if t2.value8.autoLeftEnabled then
                  t2.value8.autoLeftEnabled = false
                  t2.value8.stopAutoLeft()
                end

                if t2.value8.autoBatEnabled then
                  t2.value8.stopBatAimbot()
                end

                t2.value8.startAutoRight()
              else
              t2.value8.stopAutoRight()
            end

            if t2.value8.autoRightSetVisual then
              t2.value8.autoRightSetVisual(t2.value8.autoRightEnabled)
            end

            if t2.value8.mobBtnRefs.autoRight then
              t2.value8.mobBtnRefs.autoRight(t2.value8.autoRightEnabled)
            end

            t2.value50()
          end

          if v1089(t2.value8.KB.AutoBat, KeyCode) then
            if not t2.value8.autoBatEnabled then
              if t2.value8.autoLeftEnabled then
                t2.value8.autoLeftEnabled = false
                t2.value8.stopAutoLeft()
              end

              if t2.value8.autoRightEnabled then
                t2.value8.autoRightEnabled = false
                t2.value8.stopAutoRight()
              end

              t2.value8.queueAutoBatStart()
            else
            t2.value8.stopBatAimbot()
          end

          if t2.value8.autoBatSetVisual then
            t2.value8.autoBatSetVisual(t2.value8.autoBatEnabled)
          end

          if t2.value8.mobBtnRefs.autoBat then
            t2.value8.mobBtnRefs.autoBat(t2.value8.autoBatEnabled)
          end

          t2.value50()
        end

        if v1089(t2.value8.KB.BypassAimbot, KeyCode) then
          t2.value8.toggleBypassAimbot()

          if t2.value8.setBypassVisual then
            t2.value8.setBypassVisual(t2.value8.bypassAimbotEnabled)
          end

          if t2.value8.mobBtnRefs.bypass then
            t2.value8.mobBtnRefs.bypass(t2.value8.bypassAimbotEnabled)
          end

          t2.value50()
        end

        if v1089(t2.value8.KB.GuiHide, KeyCode) and Frame then
          Frame.Visible = not Frame.Visible
          Frame9.Visible = not Frame.Visible
          t2.value8.menuOpen = Frame.Visible == true
          pcall(t2.value50)
        end
      end)
      t2.value63(v1070, "SPEEDS")

      local v1090

      v1090, v1091 = t2.value67(v1070, "Normal Speed", t2.value8.NS, 1, 500, function(p195)
        t2.value8.NS = p195
      end)
    end

    local _, v1093 = t2.value67(v1070, "Carry Speed", t2.value8.CS, 1, 500, function(p196)
      t2.value8.CS = p196
    end)

    t2.value8.normalBox = v1091
    t2.value8.carryBox = v1093

    local Frame15 = Instance.new("Frame")

    Frame15.ClipsDescendants = true
    Frame15.Size = UDim2.new(1, 0, 0, 46)
    Frame15.BackgroundColor3 = UI_ROW_BG
    Frame15.BackgroundTransparency = 0.03
    Frame15.BorderSizePixel = 0
    Frame15.Parent = v1070
    t2.value59(Frame15)

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Position = UDim2.new(0, 14, 0, 0)
    TextLabel.Size = UDim2.new(1, -74, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Carry Mode"
    TextLabel.TextColor3 = UI_TEXT_PRIMARY
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Frame15

    local value60 = t2.value60
    local uDim2 = UDim2.new(1, -100, 0.5, -13)
    local uDim2_6 = UDim2.new(0, 88, 0, 26)
    local v1099 = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
    local v1100 = value60({
    Parent = Frame15,
    Pos = uDim2,
    Size = uDim2_6,
    Text = v1099,
    Col = UI_TEXT_PRIMARY,
    TS = 12,
    CR = 6,
    SC = UI_ACCENT,
    STr = 0.3
    })

    v1100.MouseButton1Click:Connect(function()
      t2.value8.carrySpeedActive = not t2.value8.carrySpeedActive
      v1100.Text = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
      t2.value8.refreshSpeedModeLabel()

      if t2.value8.mobBtnRefs.carrySpeed then
        t2.value8.mobBtnRefs.carrySpeed(t2.value8.carrySpeedActive)
      end

      if t2.value8.mobBtnRefs.laggerCarry then
        t2.value8.mobBtnRefs.laggerCarry(t2.value8.laggerCarryActive)
      end

      if t2.value8.carryModeBtn then
        t2.value8.carryModeBtn.Text = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
      end

      if t2.value8.laggerCarryBtn then
        t2.value8.laggerCarryBtn.Text = not t2.value8.laggerCarryActive and "L.Carry Off" or "L.Carry On"
      end

      t2.value50()
    end)
    t2.value8.carryModeBtn = v1100

    local _, v1102 = t2.value65(v1070, "Auto Carry Speed", t2.value8.autoSwitchSpeedEnabled, function(p197)
      t2.value8.autoSwitchSpeedEnabled = p197
      t2.value8._autoSwitchWasSteal = nil

      if not p197 then
        if t2.value8.carryModeBtn then
          t2.value8.carryModeBtn.Text = not t2.value8.carrySpeedActive and "Carry Off" or "Carry On"
        end

        if t2.value8.mobBtnRefs.carrySpeed then
          t2.value8.mobBtnRefs.carrySpeed(t2.value8.carrySpeedActive)
        end
      end

      t2.value8.refreshWalkSpeedAutoSwitch()
      t2.value50()
    end)

    t2.value8.setAutoCarryVisual = v1102

    local _, v1104 = t2.value65(v1070, "Auto Turn Off Speed", t2.value8.autoTurnOffSpeedEnabled, function(p198)
      t2.value8.autoTurnOffSpeedEnabled = p198
      t2.value8.refreshWalkSpeedAutoSwitch()
      t2.value50()
    end)

    t2.value8.setAutoTurnOffVisual = v1104
  end

  local _, v1106 = t2.value65(v1070, "Auto Switch Lagger Speed", t2.value8.autoSwitchLaggerSpeedEnabled, function(p199)
    t2.value8.autoSwitchLaggerSpeedEnabled = p199
    t2.value8.refreshWalkSpeedAutoSwitch()
    t2.value50()
  end)

  t2.value8.setAutoSwitchLaggerVisual = v1106
  t2.value63(v1070, "LAGGER")

  local _, _ = t2.value67(v1070, "Lagger Normal", t2.value8.LAGGER_SPEED, 1, 500, function(p200)
    t2.value8.LAGGER_SPEED = p200
  end)
  local _, _ = t2.value67(v1070, "Lagger Carry", math.min(t2.value8.LAGGER_CARRY_SPEED, 23), 1, 23, function(p201)
    t2.value8.LAGGER_CARRY_SPEED = math.min(p201, 23)
  end)
  local Frame16 = Instance.new("Frame")

  Frame16.ClipsDescendants = true
  Frame16.Size = UDim2.new(1, 0, 0, 46)
  Frame16.BackgroundColor3 = UI_ROW_BG
  Frame16.BackgroundTransparency = 0.03
  Frame16.BorderSizePixel = 0
  Frame16.Parent = v1070
  t2.value59(Frame16)

  local TextLabel = Instance.new("TextLabel")

  TextLabel.Position = UDim2.new(0, 14, 0, 0)
  TextLabel.Size = UDim2.new(1, -74, 1, 0)
  TextLabel.BackgroundTransparency = 1
  TextLabel.Text = "Lagger Mode"
  TextLabel.TextColor3 = UI_TEXT_PRIMARY
  TextLabel.TextSize = 14
  TextLabel.Font = Enum.Font.GothamMedium
  TextLabel.TextXAlignment = Enum.TextXAlignment.Left
  TextLabel.Parent = Frame16

  local value60 = t2.value60
  local uDim2 = UDim2.new(1, -100, 0.5, -13)
  local uDim2_7 = UDim2.new(0, 88, 0, 26)
  local v1116 = not t2.value8.laggerModeEnabled and "Lag Off" or "Lag On"
  local v1117 = value60({
  Parent = Frame16,
  Pos = uDim2,
  Size = uDim2_7,
  Text = v1116,
  Col = UI_TEXT_PRIMARY,
  TS = 12,
  CR = 6,
  SC = UI_ACCENT,
  STr = 0.3
  })

  v1117.MouseButton1Click:Connect(function()
    t2.value8.toggleLaggerMode()
    v1117.Text = not t2.value8.laggerModeEnabled and "Lag Off" or "Lag On"
  end)
  t2.value8.laggerModeBtn = v1117
  Frame10 = Instance.new("Frame")
  Frame10.ClipsDescendants = true
  Frame10.Size = UDim2.new(1, 0, 0, 46)
  Frame10.BackgroundColor3 = UI_ROW_BG
  Frame10.BackgroundTransparency = 0.03
  Frame10.BorderSizePixel = 0
  Frame10.Parent = v1070
  t2.value59(Frame10)

  local TextLabel10 = Instance.new("TextLabel")

  TextLabel10.Position = UDim2.new(0, 14, 0, 0)
  TextLabel10.Size = UDim2.new(1, -74, 1, 0)
  TextLabel10.BackgroundTransparency = 1
  TextLabel10.Text = "Lagger Carry Mode"
  TextLabel10.TextColor3 = UI_TEXT_PRIMARY
  TextLabel10.TextSize = 14
  TextLabel10.Font = Enum.Font.GothamMedium
  TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
  TextLabel10.Parent = Frame10
end

local value60 = t2.value60
local uDim2 = UDim2.new(1, -100, 0.5, -13)
local uDim2_8 = UDim2.new(0, 88, 0, 26)
local v1123 = not t2.value8.laggerCarryActive and "L.Carry Off" or "L.Carry On"
local v1124 = value60({
Parent = Frame10,
Pos = uDim2,
Size = uDim2_8,
Text = v1123,
Col = UI_TEXT_PRIMARY,
TS = 12,
CR = 6,
SC = UI_ACCENT,
STr = 0.3
})

v1124.MouseButton1Click:Connect(function()
  t2.value8.toggleLaggerCarry()
  v1124.Text = not t2.value8.laggerCarryActive and "L.Carry Off" or "L.Carry On"
end)
t2.value8.laggerCarryBtn = v1124
t2.value63(v1071, "COMBAT")

local _, v1126 = t2.value65(v1071, "Aimbot", t2.value8.autoBatEnabled, function(p202)
  if p202 then
    t2.value8.queueAutoBatStart()

    return
  end

  t2.value8.stopBatAimbot()
end)

t2.value8.autoBatSetVisual = v1126

local _, v1128 = t2.value65(v1071, "Bat Counter", t2.value8.batCounterEnabled, function(p203)
  t2.value8.batCounterEnabled = p203

  if p203 then
    t2.value8.startBatCounter()

    return
  end

  t2.value8.stopBatCounter()
end)

t2.value8.setBatCounterVisual = v1128

local _, v1130 = t2.value65(v1071, "Bat TP", t2.value8.bypassAimbotEnabled, function(p204)
  t2.value8.bypassAimbotEnabled = p204

  if p204 then
    t2.value8.startBypassAimbot()
  else
  t2.value8.stopBypassAimbot()
end

if t2.value8.setBypassVisual then
  t2.value8.setBypassVisual(p204)
end

if t2.value8.mobBtnRefs.bypass then
  t2.value8.mobBtnRefs.bypass(p204)
end

t2.value50()
end)

t2.value8.setBypassVisual = v1130

local _, v1132 = t2.value65(v1071, "Anti Ragdoll", t2.value8.antiRagdollEnabled, function(p205)
  t2.value8.antiRagdollEnabled = p205

  if p205 then
    t2.value8.startAntiRagdoll()

    return
  end

  t2.value8.stopAntiRagdoll()
end)

t2.value8.setAntiRagVisual = v1132

local _, v1134 = t2.value68(v1071, "Anti Ragdoll Mode", {
"Splatter",
"No Splatter"
}, t2.value8.antiRagdollMode ~= "No Splatter" and 1 or 2, function(p206)
  t2.value8.antiRagdollMode = p206 ~= "No Splatter" and "Splatter" or "No Splatter"

  if t2.value8.antiRagdollEnabled then
    t2.value8.stopAntiRagdoll()
    t2.value8.startAntiRagdoll()
  end
end)

t2.value8.setAntiRagModeUI = v1134
end

do
  local v1152

  do
    local _, v1136 = t2.value65(v1071, "Medusa Counter", t2.value8.medusaCounterEnabled, function(p207)
      t2.value8.medusaCounterEnabled = p207

      if p207 then
        t2.value8.setupMedusa(t2.value7.Character)

        return
      end

      t2.value8.stopMedusaCounter()
    end)

    t2.value8.setMedusaVisual = v1136

    local _, v1138 = t2.value65(v1071, "Medusa Reset", t2.value8.medusaResetEnabled, function(p208)
      t2.value8.medusaResetEnabled = p208
    end)

    t2.value8.setMedusaResetVisual = v1138

    local _, v1140 = t2.value65(v1071, "Auto Swing", t2.value8.autoSwingEnabled, function(p209)
      t2.value8.autoSwingEnabled = p209
    end)

    t2.value8.setAutoSwingVisual = v1140

    local _, v1142 = t2.value65(v1071, "Auto Reset on Death", t2.value8.autoResetOnDeath, function(p210)
      t2.value8.autoResetOnDeath = p210
      t2.value48()
    end)

    t2.value8.setAutoResetOnDeath = v1142
    t2.value63(v1071, "STEAL")

    local t117 = {
    "V1",
    "V2",
    "V3"
    }

    local function v1144(p211)
      if p211 == "V2" then
        return "V2"
      end

      if p211 == "V3" then
        return "V3"
      end

      return "V1"
    end

    local n20 = 1
    local v1146 = (function(p212)
      if p212 == "Semi" or p212 == "V2" then
        return "V2"
      end

      if p212 == "V3" then
        return "V3"
      end

      return "V1"
    end)(t2.value8.stealMode)

    for i, v in ipairs(t117) do
      if v == v1146 then
        n20 = i

        break
      end
    end

    local v1149, v1150, v1151

    v1149, v1150, v1151, v1152 = t2.value71(v1071, "Auto Steal", t2.value8.Steal.AutoStealEnabled, t117, n20, function(p213)
      t2.value8.Steal.AutoStealEnabled = p213

      if p213 then
        t2.value8.startAutoSteal()

        return
      end

      t2.value8.stopAutoSteal()
    end, function(p214)
    local stealMode = t2.value8.stealMode

    t2.value8.stealMode = v1144(p214)

    if stealMode ~= t2.value8.stealMode and t2.value8.Steal.AutoStealEnabled then
      t2.value8.stopAutoSteal()
      t2.value8.startAutoSteal()
    end

    t2.value8.updateStatusRadius()
  end)
  t2.value8.setInstaGrab = v1150
  t2.value8.setStealModeUI = v1151
end

local Frame17

do
  local Frame18 = Instance.new("Frame")

  Frame18.BackgroundTransparency = 1
  Frame18.Size = UDim2.new(1, 0, 0, 0)
  Frame18.AutomaticSize = Enum.AutomaticSize.Y

  local UIListLayout = Instance.new("UIListLayout")

  UIListLayout.Padding = UDim.new(0, 6)
  UIListLayout.Parent = Frame18

  local v1155

  v1155, v1156 = t2.value67(Frame18, "Grab Radius", t2.value8.Steal.StealRadius, 0.5, 300, function(p215)
    t2.value8.Steal.StealRadius = p215
    t2.value8.setStealRadius(p215)
    t2.value8.updateStatusRadius()
  end)
  t2.value8.radInput = v1156

  local v1157

  v1157, v1158 = t2.value67(Frame18, "Hold Duration", t2.value8.Steal.StealDuration, 0.1, 10, function(p216)
    t2.value8.Steal.StealDuration = p216
  end)
  t2.value8.durationBox = v1158

  local _, v1160 = t2.value65(Frame18, "Auto Radius", t2.value8.autoRadiusEnabled, function(p217)
    t2.value8.autoRadiusEnabled = p217
    t2.value8.updateStatusRadius()
  end)

  t2.value8.setAutoRadiusVisual = v1160
  v1152("V1", Frame18)

  local Frame19 = Instance.new("Frame")

  Frame19.BackgroundTransparency = 1
  Frame19.Size = UDim2.new(1, 0, 0, 0)
  Frame19.AutomaticSize = Enum.AutomaticSize.Y

  local UIListLayout5 = Instance.new("UIListLayout")

  UIListLayout5.Padding = UDim.new(0, 6)
  UIListLayout5.Parent = Frame19

  local _, v1164 = t2.value67(Frame19, "Semi Radius (max 10)", math.min(t2.value8.Semi.radius, 10), 0.5, 10, function(p218)
    t2.value8.Semi.radius = math.min(p218, 10)

    if semiRadBox then
      semiRadBox.Text = tostring(t2.value8.Semi.radius)
    end
  end)

  t2.value8.semiRadInput = v1164

  local _, _ = t2.value67(Frame19, "Hold Min", t2.value8.Semi.holdMin or 1.3, 0.1, 5, function(p219)
    t2.value8.Semi.holdMin = p219
  end)
  local _, _ = t2.value67(Frame19, "Hold Max", t2.value8.Semi.holdMax or 2.6, 0.1, 8, function(p220)
    t2.value8.Semi.holdMax = p220
  end)

  v1152("V2", Frame19)
  Frame17 = Instance.new("Frame")
  Frame17.BackgroundTransparency = 1
  Frame17.Size = UDim2.new(1, 0, 0, 0)
  Frame17.AutomaticSize = Enum.AutomaticSize.Y

  local UIListLayout6 = Instance.new("UIListLayout")

  UIListLayout6.Padding = UDim.new(0, 6)
  UIListLayout6.Parent = Frame17

  local _, _ = t2.value67(Frame17, "Grab Radius", t2.value8.Steal.StealRadius, 0.5, 300, function(p221)
    t2.value8.Steal.StealRadius = p221
    t2.value8.setStealRadius(p221)
    t2.value8.updateStatusRadius()
  end)
end

local _, _ = t2.value67(Frame17, "Fill Duration", t2.value8.Steal.StealDuration, 0.1, 10, function(p222)
  t2.value8.Steal.StealDuration = p222
end)
local Frame20 = Instance.new("Frame")

Frame20.ClipsDescendants = true
Frame20.Size = UDim2.new(1, 0, 0, 46)
Frame20.BackgroundColor3 = UI_ROW_BG
Frame20.BackgroundTransparency = 0.1
Frame20.BorderSizePixel = 0
Frame20.Parent = Frame17
t2.value59(Frame20)

local TextLabel = Instance.new("TextLabel")

TextLabel.Position = UDim2.new(0, 14, 0, 0)
TextLabel.Size = UDim2.new(0.42, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Stop Time (s)"
TextLabel.TextColor3 = UI_TEXT_PRIMARY
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamMedium
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame20

local TextBox = Instance.new("TextBox")

TextBox.Name = "StopTimeBox"
TextBox.Position = UDim2.new(1, -118, 0.5, -13)
TextBox.Size = UDim2.new(0, 52, 0, 26)
TextBox.BackgroundColor3 = UI_BTN_BG
TextBox.BorderSizePixel = 0
TextBox.Text = string.format("%.2f", (math.clamp(tonumber(t2.value8.Steal.StopTime) or 0.35, 0.1, 30)))
TextBox.TextColor3 = UI_TEXT_PRIMARY
TextBox.TextSize = 12
TextBox.Font = Enum.Font.GothamBold
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame20
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 7)
TextBox.FocusLost:Connect(function()
  local v1819 = math.clamp(tonumber(TextBox.Text) or 0.35, 0.1, 30)

  t2.value8.Steal.StopTime = v1819
  TextBox.Text = string.format("%.2f", v1819)
  t2.value50()
end)

local value60 = t2.value60
local uDim2 = UDim2.new(1, -158, 0.5, -13)
local uDim2_9 = UDim2.new(0, 28, 0, 26)
local v1181 = value60({
Parent = Frame20,
Pos = uDim2,
Size = uDim2_9,
Text = "-",
Col = UI_TEXT_PRIMARY,
TS = 14,
CR = 7
})
local value60_3 = t2.value60
local uDim2_10 = UDim2.new(1, -54, 0.5, -13)
local uDim2_11 = UDim2.new(0, 28, 0, 26)
local v1185 = value60_3({
Parent = Frame20,
Pos = uDim2_10,
Size = uDim2_11,
Text = "+",
Col = UI_TEXT_PRIMARY,
TS = 14,
CR = 7
})

v1181.MouseButton1Click:Connect(function()
  local v1820 = math.clamp(tonumber((tonumber(t2.value8.Steal.StopTime) or 0.35) - 0.25) or 0.35, 0.1, 30)

  t2.value8.Steal.StopTime = v1820
  TextBox.Text = string.format("%.2f", v1820)
  t2.value50()
end)
v1185.MouseButton1Click:Connect(function()
  local v1821 = math.clamp(tonumber((tonumber(t2.value8.Steal.StopTime) or 0.35) + 0.25) or 0.35, 0.1, 30)

  t2.value8.Steal.StopTime = v1821
  TextBox.Text = string.format("%.2f", v1821)
  t2.value50()
end)
t2.value8.stopTimeBox = TextBox

local _, _ = t2.value65(Frame17, "Auto Radius", t2.value8.autoRadiusEnabled, function(p223)
  t2.value8.autoRadiusEnabled = p223
  t2.value8.updateStatusRadius()
end)

v1152("V3", Frame17)

local v1188

v1188, v1189 = t2.value67(v1071, "Steal Bar Width", t2.value8.stealBarSize, 220, 760, function(p224)
  t2.value8.stealBarSize = p224
  t2.value8.buildStatusUI()
end)

local _, _ = t2.value67(v1071, "Auto Steal Scale", t2.value8.stealBarScale, 0.4, 1.5, function(p225)
  t2.value8.stealBarScale = math.clamp(p225, 0.4, 1.5)
  t2.value8.buildStatusUI()
end)
end

t2.value63(v1071, "MOTION")

local v1192 = t2.value8.infJumpMode == "hold" and 2
local value71 = t2.value71

if not v1192 then
  v1192 = 1
end

local _, v1195, v1196 = value71(v1071, "Infinite Jump", t2.value8.infJumpEnabled, {
"Manual",
"Hold"
}, v1192, function(p226)
  t2.value8.infJumpEnabled = p226

  if p226 and t2.value8.infJumpMode == "manual" then
    t2.value8.startManualInfJumpLoop()

    return
  end

  if p226 and t2.value8.infJumpMode == "hold" then
    t2.value8.startHoldInfJump()

    return
  end

  t2.value8.stopManualInfJumpLoop()
  t2.value8.stopHoldInfJump()
end, function(p227)
local infJumpEnabled = t2.value8.infJumpEnabled

t2.value8.infJumpMode = p227 ~= "Hold" and "manual" or "hold"

if infJumpEnabled then
  t2.value8.stopManualInfJumpLoop()
  t2.value8.stopHoldInfJump()

  if t2.value8.infJumpMode == "manual" then
    t2.value8.startManualInfJumpLoop()

    return
  end

  t2.value8.startHoldInfJump()
end
end)

t2.value8.setInfJumpVisual = v1195
t2.value8.setJumpModeUI = v1196

local _, v1198 = t2.value65(v1071, "Mirror TP Down", t2.value8.mirrorTPDownEnabled, function(p228)
  t2.value8.setMirrorTPDown(p228)
  t2.value50()
end)

t2.value8.setMirrorTPVisual = v1198

local _, v1200 = t2.value65(v1071, "Auto Left", t2.value8.autoLeftEnabled, function(p229)
  if p229 then
    if t2.value8.autoRightEnabled then
      t2.value8.autoRightEnabled = false
      t2.value8.stopAutoRight()

      if t2.value8.autoRightSetVisual then
        t2.value8.autoRightSetVisual(false)
      end
    end

    if t2.value8.autoBatEnabled then
      t2.value8.stopBatAimbot()

      if t2.value8.autoBatSetVisual then
        t2.value8.autoBatSetVisual(false)
      end
    end

    t2.value8.autoLeftEnabled = true
    t2.value8.startAutoLeft()
  else
  t2.value8.autoLeftEnabled = false
  t2.value8.stopAutoLeft()
end

if t2.value8.mobBtnRefs.autoLeft then
  t2.value8.mobBtnRefs.autoLeft(p229)
end
end)

t2.value8.autoLeftSetVisual = v1200

local _, v1202 = t2.value65(v1071, "Auto Right", t2.value8.autoRightEnabled, function(p230)
  if p230 then
    if t2.value8.autoLeftEnabled then
      t2.value8.autoLeftEnabled = false
      t2.value8.stopAutoLeft()

      if t2.value8.autoLeftSetVisual then
        t2.value8.autoLeftSetVisual(false)
      end
    end

    if t2.value8.autoBatEnabled then
      t2.value8.stopBatAimbot()

      if t2.value8.autoBatSetVisual then
        t2.value8.autoBatSetVisual(false)
      end
    end

    t2.value8.autoRightEnabled = true
    t2.value8.startAutoRight()
  else
  t2.value8.autoRightEnabled = false
  t2.value8.stopAutoRight()
end

if t2.value8.mobBtnRefs.autoRight then
  t2.value8.mobBtnRefs.autoRight(p230)
end
end)

t2.value8.autoRightSetVisual = v1202

local _, v1204 = t2.value65(v1071, "Auto TP Down", t2.value8.autoTPEnabled, function(p231)
  t2.value8.autoTPEnabled = p231

  if p231 then
    t2.value8.startAutoTP()

    return
  end

  t2.value8.stopAutoTP()
end)

t2.value8.setAutoTPVisual = v1204

local v1205

v1205, v1206 = t2.value67(v1071, "TP Height", t2.value8.autoTPHeight, 1, 100, function(p232)
  t2.value8.autoTPHeight = p232
end)
t2.value8.autoTPHeightBox = v1206
t2.value63(v1072, "SKY & VISION")

local Frame21 = Instance.new("Frame")

Frame21.ClipsDescendants = true
Frame21.Size = UDim2.new(1, 0, 0, 46)
Frame21.BackgroundColor3 = UI_ROW_BG
Frame21.BackgroundTransparency = 0.03
Frame21.BorderSizePixel = 0
Frame21.Parent = v1072
t2.value59(Frame21)

local TextLabel = Instance.new("TextLabel")

TextLabel.Position = UDim2.new(0, 13, 0, 0)
TextLabel.Size = UDim2.new(0.55, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Sky Theme"
TextLabel.TextColor3 = UI_TEXT_PRIMARY
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamMedium
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame21

local TextLabel11 = Instance.new("TextLabel")

TextLabel11.Position = UDim2.new(0.55, 0, 0, 0)
TextLabel11.Size = UDim2.new(0.45, -10, 1, 0)
TextLabel11.BackgroundTransparency = 1
TextLabel11.Text = t2.value8.currentSkyTheme
TextLabel11.TextColor3 = UI_ACCENT
TextLabel11.Font = Enum.Font.GothamBold
TextLabel11.TextSize = 12
TextLabel11.TextXAlignment = Enum.TextXAlignment.Right
TextLabel11.Parent = Frame21
n21 = 1

for i, v in ipairs(t2.value8.SkyOrder) do
  if v == t2.value8.currentSkyTheme then
    n21 = i

    break
  end
end

local TextButton = Instance.new("TextButton", Frame21)

TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.BackgroundTransparency = 1
TextButton.Text = ""
TextButton.Activated:Connect(function()
  n21 = n21 % #t2.value8.SkyOrder + 1

  local v1833 = t2.value8.SkyOrder[n21]

  TextLabel11.Text = v1833
  t2.value8.currentSkyTheme = v1833
  t2.value8.CandyApplyCustomSky(v1833)
  t2.value50()
end)
end

local Frame22 = Instance.new("Frame")

Frame22.ClipsDescendants = true
Frame22.Size = UDim2.new(1, 0, 0, 46)
Frame22.BackgroundColor3 = UI_ROW_BG
Frame22.BackgroundTransparency = 0.03
Frame22.BorderSizePixel = 0
Frame22.Parent = v1072
t2.value59(Frame22)

local TextLabel = Instance.new("TextLabel")

TextLabel.Position = UDim2.new(0, 13, 0, 0)
TextLabel.Size = UDim2.new(0.55, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "FOV"
TextLabel.TextColor3 = UI_TEXT_PRIMARY
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamMedium
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame22

local TextLabel12 = Instance.new("TextLabel")

TextLabel12.Position = UDim2.new(0.55, 0, 0, 0)
TextLabel12.Size = UDim2.new(0.45, -10, 1, 0)
TextLabel12.BackgroundTransparency = 1
TextLabel12.Text = tostring(t2.value8.fovValue)
TextLabel12.TextColor3 = UI_ACCENT
TextLabel12.Font = Enum.Font.GothamBold
TextLabel12.TextSize = 12
TextLabel12.TextXAlignment = Enum.TextXAlignment.Right
TextLabel12.Parent = Frame22
n22 = 1

local TextButton = Instance.new("TextButton", Frame22)

TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.BackgroundTransparency = 1
TextButton.Text = ""
TextButton.Activated:Connect(function()
  n22 = n22 % #t2.value8.fovOptions + 1
  t2.value8.fovValue = t2.value8.fovOptions[n22]
  TextLabel12.Text = tostring(t2.value8.fovValue)
  t2.value8.applyFOV()
  t2.value50()
end)
t2.value63(v1072, "COLOUR SCHEME")

local Frame23 = Instance.new("Frame")

Frame23.ClipsDescendants = true
Frame23.Size = UDim2.new(1, 0, 0, 46)
Frame23.BackgroundColor3 = UI_ROW_BG
Frame23.BackgroundTransparency = 0.03
Frame23.BorderSizePixel = 0
Frame23.Parent = v1072
t2.value59(Frame23)

local TextLabel13 = Instance.new("TextLabel")

TextLabel13.Position = UDim2.new(0, 13, 0, 0)
TextLabel13.Size = UDim2.new(0.4, 0, 1, 0)
TextLabel13.BackgroundTransparency = 1
TextLabel13.Text = "Theme"
TextLabel13.TextColor3 = UI_TEXT_PRIMARY
TextLabel13.TextSize = 13
TextLabel13.Font = Enum.Font.GothamMedium
TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
TextLabel13.Parent = Frame23

local TextLabel14 = Instance.new("TextLabel")

TextLabel14.Position = UDim2.new(0.4, 0, 0, 0)
TextLabel14.Size = UDim2.new(0.6, -10, 1, 0)
TextLabel14.BackgroundTransparency = 1
TextLabel14.Text = "RED"
TextLabel14.TextColor3 = t2.value9
TextLabel14.Font = Enum.Font.GothamBold
TextLabel14.TextSize = 12
TextLabel14.TextXAlignment = Enum.TextXAlignment.Right
TextLabel14.Parent = Frame23

local Frame24 = Instance.new("Frame")

Frame24.Size = UDim2.new(1, 0, 0, 36)
Frame24.BackgroundTransparency = 1
Frame24.Parent = v1072

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = Frame24

local TextButton6 = Instance.new("TextButton")

TextButton6.Size = UDim2.new(0, 100, 0, 20)
TextButton6.BackgroundColor3 = t2.value9
TextButton6.Text = "RED"
TextButton6.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton6.Font = Enum.Font.GothamBold
TextButton6.TextSize = 10
TextButton6.AutoButtonColor = false
TextButton6.Parent = Frame24
Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 4)
t2.value63(v1072, "ESP")

local _, _ = t2.value65(v1072, "Line ESP", t2.value8.lineESPEnabled, function(p233)
  t2.value8.lineESPEnabled = p233
  t2.value51.LineESP = p233
end)
local _, _ = t2.value65(v1072, "Speed ESP", t2.value8.speedESPEnabled, function(p234)
  t2.value8.speedESPEnabled = p234
  t2.value51.SpeedESP = p234
end)

t2.value63(v1073, "MISC")

local _, v1230 = t2.value65(v1073, "Unwalk", t2.value8.unwalkEnabled, function(p235)
  t2.value8.unwalkEnabled = p235

  if p235 then
    t2.value8.startUnwalk()

    return
  end

  t2.value8.stopUnwalk()
end)

t2.value8.setUnwalkVisual = v1230

local _, v1232 = t2.value65(v1073, "Anti-Lag", t2.value8.antiLagEnabled, function(p236)
  t2.value8.antiLagEnabled = p236

  if p236 then
    t2.value8.enableAntiLag()
  else
  t2.value8.disableAntiLag()
end

t2.value50()
end)

t2.value8.setAntiLagVisual = v1232

local _, v1234 = t2.value65(v1073, "Anti Summer Base", t2.value8.antiSummerBaseEnabled, function(p237)
  t2.value8.antiSummerBaseEnabled = p237

  if p237 then
    t2.value8.enableAntiSummerBase()
  else
  t2.value8.disableAntiSummerBase()
end

t2.value50()
end)

t2.value8.setAntiSummerVisual = v1234

local _, v1236 = t2.value65(v1073, "Stretch Rez", t2.value8.stretchRezEnabled, function(p238)
  t2.value8.stretchRezEnabled = p238

  if p238 then
    t2.value8.enableStretchRez()

    return
  end

  t2.value8.disableStretchRez()
end)

t2.value8.setStretchRezVisual = v1236

local _, _ = t2.value65(v1073, "Remove Accessories", t2.value8.removeAccEnabled, function(p239)
  t2.value8.removeAccEnabled = p239

  if p239 then
    t2.value8.startRemoveAcc()

    return
  end

  t2.value8.stopRemoveAcc()
end)
end
local v1259, t118, n24
do
  local _, v1240 = t2.value65(v1073, "Anti-Kick", t2.value8.antiKickEnabled, function(p240)
    t2.value8.antiKickEnabled = p240

    if p240 then
      t2.value8.enableAntiKick()
    else
    t2.value8.disableAntiKick()
  end

  t2.value50()
end)

t2.value8.antiKickSetVisual = v1240

local _, v1242 = t2.value65(v1073, "Safe Mode", t2.value8.safeModeEnabled, function(p241)
  t2.value8.safeModeEnabled = p241

  if p241 then
    t2.value8.enableSafeMode()
  else
  t2.value8.disableSafeMode()
end

t2.value50()
end)

t2.value8.setSafeModeVisual = v1242

local n23 = 1

for i, v in ipairs(t2.value8.FONT_NAMES) do
  if v == (t2.value8.customFontSelected or "None") then
    n23 = i

    break
  end
end

local _, _ = t2.value68(v1073, "Custom Font", t2.value8.FONT_NAMES, n23, function(p242)
  t2.value8.applyCustomFont(p242)
  t2.value50()
end)
local _, _ = t2.value65(v1073, "Intro Song", t2.value8.introSoundEnabled, function(p243)
  t2.value8.introSoundEnabled = p243

  if not p243 and (introSoundInstance and introSoundInstance.IsPlaying) then
    pcall(function()
      introSoundInstance:Stop()
    end)
  end
end)
local _, _ = t2.value68(v1073, "Intro Song Choice", {
"Song 1",
"Song 2",
"Song 3"
}, t2.value8.introSongChoice or 3, function(p244)
  t2.value8.introSongChoice = ({
  ["Song 1"] = 1,
  ["Song 2"] = 2,
  ["Song 3"] = 3
  })[p244] or 3
end)
local _, _ = t2.value65(v1073, "Intro GUI", t2.value8.introGUIEnabled, function(p245)
  t2.value8.introGUIEnabled = p245
end)
local _, _ = t2.value65(v1073, "Mobile Buttons", t2.value8.mobileButtonsEnabled, function(p246)
  t2.value8.mobileButtonsEnabled = p246

  if p246 then
    t2.value8.buildMobileButtons()
  else
  t2.value8.destroyMobileButtons()
end

t2.value50()
end)
local _, v1257 = t2.value65(v1073, "Circle Buttons", t2.value8.circleButtonsEnabled, function(p247)
  t2.value8.circleButtonsEnabled = p247

  if t2.value8.mobileButtonsEnabled then
    t2.value8.buildMobileButtons()
  end

  t2.value50()
end)

t2.value8.setCircleBtnsVisual = v1257

local v1258

v1258, v1259 = t2.value67(v1073, "Button Size", t2.value8.mobileButtonsSize, 40, 150, function(p248)
  t2.value8.mobileButtonsSize = p248

  if t2.value8.mobileButtonsEnabled then
    t2.value8.buildMobileButtons()
  end
end)

local _, _ = t2.value67(v1073, "Menu Scale", t2.value8.uiScale, 0.5, 2, function(p249)
  t2.value8.uiScale = p249

  if t2.value8.uiScaleRef then
    t2.value8.uiScaleRef.Scale = p249
  end

  t2.value50()
end)

t2.value66(v1073, "Reset Mobile Positions", function()
  t2.value8.resetMobilePositions()
end)
t2.value63(v1073, "CHARTER")
t118 = {}

for k in pairs(t2.value8.PACKS) do
  table.insert(t118, k)
end

table.sort(t118)

local v1264, v1265, v1266 = ipairs(t118)

n24 = 1

repeat
  local v1268

  v1266, v1268 = v1264(v1265, v1266)

  if not v1266 then
    g1269 = true
  end

  if g1269 then
    break
  end
until v1268 == t2.value8.animPack

if not g1269 then
  n24 = v1266
end
end
g1269 = false
local _, _, v1272 = t2.value71(v1073, "Animation Pack", t2.value8.animPackEnabled, t118, n24, function(p250)
  t2.value8.animPackEnabled = p250

  if p250 then
    t2.value8.applyAnimPack(t2.value8.animPack)
  else
  local Character = t2.value7.Character

  if Character then
    t2.value8.resetAnimations(Character)
  end
end

t2.value50()
end, function(p251)
t2.value8.animPack = p251

if t2.value8.animPackEnabled then
  t2.value8.applyAnimPack(p251)
end

t2.value50()
end)
t2.value8.setPackModeUI = v1272
t2.value66(v1073, "Apply Animation Pack", function()
  if t2.value8.animPackEnabled then
    t2.value8.applyAnimPack(t2.value8.animPack)
  end

  t2.value50()
end)
local _, _ = t2.value65(v1073, "Headless", t2.value8.headlessEnabled, function(p252)
  t2.value8.headlessEnabled = p252
  t2.value8.applyHeadlessToChar(t2.value7.Character, p252)
  t2.value50()
end)
local _, _ = t2.value65(v1073, "Korblox", t2.value8.korbloxEnabled, function(p253)
  t2.value8.korbloxEnabled = p253
  t2.value8.applyKorbloxToChar(t2.value7.Character, p253)
  t2.value50()
end)
t2.value63(v1073, "PANELS")
local Frame25 = Instance.new("Frame")
Frame25.ClipsDescendants = true
Frame25.Size = UDim2.new(1, 0, 0, 46)
Frame25.BackgroundColor3 = UI_ROW_BG
Frame25.BackgroundTransparency = 0.03
Frame25.BorderSizePixel = 0
Frame25.Parent = v1073
t2.value59(Frame25)
local TextLabel = Instance.new("TextLabel")
TextLabel.Position = UDim2.new(0, 14, 0, 0)
TextLabel.Size = UDim2.new(1, -74, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Save Config"
TextLabel.TextColor3 = UI_TEXT_PRIMARY
TextLabel.TextSize = 14
TextLabel.Font = Enum.Font.GothamMedium
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame25
local value60 = t2.value60
local uDim2 = UDim2.new(1, -80, 0.5, -13)
local uDim2_12 = UDim2.new(0, 68, 0, 26)
local color3_7 = Color3.fromRGB(200, 200, 200)
local color3_8 = Color3.fromRGB(40, 40, 40)
local v1284 = value60({
Parent = Frame25,
Pos = uDim2,
Size = uDim2_12,
Text = "SAVE",
Col = color3_7,
TS = 12,
CR = 6,
SC = color3_8,
STr = 0.2
})
v1284.Activated:Connect(function()
  t2.value50()
  v1284.Text = "OK"
  task.delay(0.8, function()
    if v1284 and v1284.Parent then
      v1284.Text = "SAVE"
    end
  end)
end)
local Frame26 = Instance.new("Frame")
Frame26.ClipsDescendants = true
Frame26.Size = UDim2.new(1, 0, 0, 46)
Frame26.BackgroundColor3 = UI_ROW_BG
Frame26.BackgroundTransparency = 0.03
Frame26.BorderSizePixel = 0
Frame26.Parent = v1073
t2.value59(Frame26)
local TextLabel15 = Instance.new("TextLabel")
TextLabel15.Position = UDim2.new(0, 14, 0, 0)
TextLabel15.Size = UDim2.new(1, -74, 1, 0)
TextLabel15.BackgroundTransparency = 1
TextLabel15.Text = "Reset All Settings"
TextLabel15.TextColor3 = UI_TEXT_PRIMARY
TextLabel15.TextSize = 14
TextLabel15.Font = Enum.Font.GothamMedium
TextLabel15.TextXAlignment = Enum.TextXAlignment.Left
TextLabel15.Parent = Frame26
local value60_4 = t2.value60
local uDim2_13 = UDim2.new(1, -80, 0.5, -13)
local uDim2_14 = UDim2.new(0, 68, 0, 26)
local color3_9 = Color3.fromRGB(200, 200, 200)
local color3_10 = Color3.fromRGB(40, 40, 40)
value60_4({
Parent = Frame26,
Pos = uDim2_13,
Size = uDim2_14,
Text = "RESET",
Col = color3_9,
TS = 12,
CR = 6,
SC = color3_10,
STr = 0.2
}).Activated:Connect(function()
  t2.value8.resetAllSettings()
end)
t2.value63(v1074, "KEYBINDS")
v1088(v1074, "Hide GUI", t2.value8.KB.GuiHide)
v1088(v1074, "Carry Mode", t2.value8.KB.SpeedToggle)
v1088(v1074, "Lagger Mode", t2.value8.KB.LaggerToggle)
v1088(v1074, "Aimbot", t2.value8.KB.AutoBat)
v1088(v1074, "Bat TP", t2.value8.KB.BypassAimbot)
v1088(v1074, "Auto Left", t2.value8.KB.AutoLeft)
v1088(v1074, "Auto Right", t2.value8.KB.AutoRight)
v1088(v1074, "Drop Brainrot", t2.value8.KB.DropBrainrot)
v1088(v1074, "TP Down", t2.value8.KB.TPFloor)
v1088(v1074, "Insta Reset", t2.value8.KB.InstaReset)
local v1292 = t2.value8.menuOpen ~= false
Frame.Visible = v1292
Frame9.Visible = not v1292
t2.value8.menuOpen = v1292
t2.value8.applyStealBarTheme(t2.value9)
t2.value8.updateHeadTheme()
t2.value8.applyFOV()
t2.value8.autoTPHeightBox = v1206
t2.value8.radInput = v1156
t2.value8.durationBox = v1158
t2.value8.btnSzBox = v1259
t2.value8.sbBox = v1189
if t2.value8.setAntiRagVisual then
  t2.value8.setAntiRagVisual(t2.value8.antiRagdollEnabled)
end
if t2.value8.setSafeModeVisual then
  t2.value8.setSafeModeVisual(t2.value8.safeModeEnabled)
end
if t2.value8.setAutoCarryVisual then
  t2.value8.setAutoCarryVisual(t2.value8.autoSwitchSpeedEnabled)
end
if t2.value8.setCircleBtnsVisual then
  t2.value8.setCircleBtnsVisual(t2.value8.circleButtonsEnabled)
end
if t2.value8.customFontSelected and t2.value8.customFontSelected ~= "None" then
  task.defer(function()
    pcall(function()
      t2.value8.applyCustomFont(t2.value8.customFontSelected)
    end)
  end)
end
if t2.value8.setMirrorTPVisual then
  t2.value8.setMirrorTPVisual(t2.value8.mirrorTPDownEnabled)
end
if t2.value8.safeModeEnabled then
  t2.value8.enableSafeMode()
end
if t2.value8.antiKickEnabled then
  t2.value8.enableAntiKick()
end
if t2.value8.setAntiRagModeUI then
  t2.value8.setAntiRagModeUI(t2.value8.antiRagdollMode ~= "No Splatter" and "Splatter" or "No Splatter")
end
if t2.value8.setInfJumpVisual then
  t2.value8.setInfJumpVisual(t2.value8.infJumpEnabled)
end
if t2.value8.setMedusaVisual then
  t2.value8.setMedusaVisual(t2.value8.medusaCounterEnabled)
end
if t2.value8.setMedusaResetVisual then
  t2.value8.setMedusaResetVisual(t2.value8.medusaResetEnabled)
end
if t2.value8.setBatCounterVisual then
  t2.value8.setBatCounterVisual(t2.value8.batCounterEnabled)
end
if t2.value8.setUnwalkVisual then
  t2.value8.setUnwalkVisual(t2.value8.unwalkEnabled)
end
if t2.value8.setAntiLagVisual then
  t2.value8.setAntiLagVisual(t2.value8.antiLagEnabled)
end
if t2.value8.setAntiSummerVisual then
  t2.value8.setAntiSummerVisual(t2.value8.antiSummerBaseEnabled)
end
if t2.value8.setStretchRezVisual then
  t2.value8.setStretchRezVisual(t2.value8.stretchRezEnabled)
end
if t2.value8.setAutoTPVisual then
  t2.value8.setAutoTPVisual(t2.value8.autoTPEnabled)
end
if t2.value8.antiKickSetVisual then
  t2.value8.antiKickSetVisual(t2.value8.antiKickEnabled)
end
if t2.value8.setInstaGrab then
  t2.value8.setInstaGrab(t2.value8.Steal.AutoStealEnabled)
end
if t2.value8.setAutoRadiusVisual then
  t2.value8.setAutoRadiusVisual(t2.value8.autoRadiusEnabled)
end
if t2.value8.autoBatSetVisual then
  t2.value8.autoBatSetVisual(t2.value8.autoBatEnabled)
end
if t2.value8.autoLeftSetVisual then
  t2.value8.autoLeftSetVisual(t2.value8.autoLeftEnabled)
end
if t2.value8.autoRightSetVisual then
  t2.value8.autoRightSetVisual(t2.value8.autoRightEnabled)
end
if t2.value8.setAutoSwingVisual then
  t2.value8.setAutoSwingVisual(t2.value8.autoSwingEnabled)
end
if t2.value8.setBypassVisual then
  t2.value8.setBypassVisual(t2.value8.bypassAimbotEnabled)
end
if t2.value8.mobBtnRefs.autoBat then
  t2.value8.mobBtnRefs.autoBat(t2.value8.autoBatEnabled)
end
if t2.value8.mobBtnRefs.autoLeft then
  t2.value8.mobBtnRefs.autoLeft(t2.value8.autoLeftEnabled)
end
if t2.value8.mobBtnRefs.autoRight then
  t2.value8.mobBtnRefs.autoRight(t2.value8.autoRightEnabled)
end
if t2.value8.mobBtnRefs.carrySpeed then
  t2.value8.mobBtnRefs.carrySpeed(t2.value8.carrySpeedActive)
end
if t2.value8.mobBtnRefs.lagger then
  t2.value8.mobBtnRefs.lagger(t2.value8.laggerModeEnabled)
end
if t2.value8.mobBtnRefs.bypass then
  t2.value8.mobBtnRefs.bypass(t2.value8.bypassAimbotEnabled)
end
if t2.value8.setAutoResetOnDeath then
  t2.value8.setAutoResetOnDeath(t2.value8.autoResetOnDeath)
end
if t2.value8.headlessEnabled then
  t2.value8.applyHeadlessToChar(t2.value7.Character, true)
end
if t2.value8.korbloxEnabled then
  t2.value8.applyKorbloxToChar(t2.value7.Character, true)
end
if t2.value8.setStealModeUI then
  local s1 = "V1"

  if t2.value8.stealMode == "Semi" or t2.value8.stealMode == "V2" then
    s1 = "V2"
  elseif t2.value8.stealMode == "V3" then
    s1 = "V3"
  end

  t2.value8.setStealModeUI(s1)
end
if t2.value8.setJumpModeUI then
  t2.value8.setJumpModeUI(t2.value8.infJumpMode ~= "hold" and "Manual" or "Hold")
end
if t2.value8.setPackModeUI and t2.value8.animPack then
  t2.value8.setPackModeUI(t2.value8.animPack)
end
if t2.value8.animPackEnabled then
  task.wait(0.5)
  t2.value8.applyAnimPack(t2.value8.animPack)
else
local Character = t2.value7.Character

if Character then
  t2.value8.resetAnimations(Character)
end
end
t2.value51.LineESP = t2.value8.lineESPEnabled
t2.value51.SpeedESP = t2.value8.speedESPEnabled
t2.value8.updateStatusRadius()
t2.value8.startHeadSpeedUpdates()
end
function t2.value8.applyStealBarTheme(p254)
  if not p254 then
    p254 = t2.value9
  end

  if t2.value8.statusFill then
    t2.value8.statusFill.BackgroundColor3 = p254
  end

  if t2.value8.statusDot then
    t2.value8.statusDot.BackgroundColor3 = p254
  end

  if t2.value8.statusMain then
    local UIStroke = t2.value8.statusMain:FindFirstChildOfClass("UIStroke")

    if UIStroke then
      UIStroke.Color = t2.value9
    end

    local StealProgress = t2.value8.statusMain:FindFirstChild("StealProgress")
    local v1298 = StealProgress and StealProgress:FindFirstChildOfClass("UIStroke")

    if v1298 then
      v1298.Color = t2.value10
    end
  end
end
function t2.value8.resetAllSettings()
  t2.value8.NS = 60
  t2.value8.CS = 30
  t2.value8.LAGGER_SPEED = 15
  t2.value8.LAGGER_CARRY_SPEED = 24.5
  t2.value8.speedMethod = "Velocity"
  t2.value8.hyperMult = 4
  t2.value8._lastSpeedMethod = nil
  t2.value8._anchoredBySpeed = nil
  t2.value8.carrySpeedActive = false
  t2.value8.laggerModeEnabled = false
  t2.value8.laggerCarryActive = false
  t2.value8.antiRagdollEnabled = false
  t2.value8.antiRagdollMode = "Splatter"
  t2.value8.infJumpEnabled = false
  t2.value8.infJumpMode = "manual"
  t2.value8.medusaCounterEnabled = false
  t2.value8.batCounterEnabled = false
  t2.value8.unwalkEnabled = false
  t2.value8.medusaResetEnabled = false
  t2.value8.medusaDebounce = false
  t2.value8.medusaLastUsed = 0
  t2.value8.autoLeftEnabled = false
  t2.value8.autoRightEnabled = false
  t2.value8.autoBatEnabled = false
  t2.value8.autoSwingEnabled = true
  t2.value8.autoMoveSwingEnabled = false
  t2.value8.antiLagEnabled = false
  t2.value8.removeAccessoriesEnabled = false
  t2.value8.stretchRezEnabled = false
  t2.value8.autoTPEnabled = false
  t2.value8.autoTPHeight = 20
  t2.value8.guiTransparencyEnabled = false
  t2.value8.mobileButtonsEnabled = true
  t2.value8.mobileButtonsSize = 100
  t2.value8.circleButtonsEnabled = false
  t2.value8.fovValue = 80
  t2.value8.fovIndex = 1
  t2.value8.autoSwitchSpeedEnabled = false
  t2.value8.antiKickEnabled = false
  t2.value8.brainrotDetected = false
  t2.value8.ragdollGuiEnabled = true
  t2.value8.introSoundEnabled = true
  t2.value8.introSongChoice = 3
  t2.value8.introGUIEnabled = true
  t2.value8.Steal.AutoStealEnabled = false
  t2.value8.autoRadiusEnabled = false
  t2.value8.Steal.StealRadius = 60
  t2.value8.Steal.StealDuration = 1.4
  t2.value8.Steal.StopTime = 0.35
  t2.value8.stealMode = "V1"
  t2.value8.Semi.holdMin = 1.3
  t2.value8.Semi.holdMax = 2.6
  t2.value8.Semi.entryDelay = 0.3
  t2.value8.Semi.radius = 10
  t2.value8.Semi.primeRange = 80
  t2.value8.removeAccEnabled = false
  t2.value8.playerESPEnabled = false
  t2.value8.showPlayerSpeeds = false
  t2.value8.uiScale = 0.8
  t2.value8.perButtonDragEnabled = true
  t2.value8.stealBarSize = 450
  t2.value8.stealBarScale = 0.6
  t2.value8.lineESPEnabled = false
  t2.value8.speedESPEnabled = false
  t2.value8.autoResetOnDeath = false
  t2.value8.animPack = "Adidas Sports"
  t2.value8.headlessEnabled = false
  t2.value8.korbloxEnabled = false
  t2.value8.bypassAimbotEnabled = false
  t2.value8.animPackEnabled = true
  t2.value8.stopAutoSteal()
  t2.value8.stopBatAimbot()
  t2.value8.stopAutoLeft()
  t2.value8.stopAutoRight()
  t2.value8.stopAntiRagdoll()
  t2.value8.stopHoldInfJump()
  t2.value8.stopManualInfJumpLoop()
  t2.value8.stopMedusaCounter()
  t2.value8.stopBatCounter()
  t2.value8.stopUnwalk()
  t2.value8.disableAntiLag()
  t2.value8.disableStretchRez()
  t2.value8.stopAutoTP()
  t2.value8.disableAntiKick()
  t2.value8.stopBypassAimbot()
  t2.value8.stopRemoveAcc()
  t2.value8.toggleESP(false)
  t2.value8.togglePlayerSpeeds(false)
  t2.value8.autoResetOnDeath = false
  t2.value48()
  t2.value50()
  t2.value8.buildGui()
end
game:IsLoaded()
repeat
  task.wait()
  t1.value5 = game:IsLoaded()
until t1.value5
task.wait(0.5);
(function()
  if type(readfile) ~= "function" or type(isfile) ~= "function" then
    return
  end

  local ok, result = pcall(function()
    if not isfile(t2.value49) then
      return nil
    end

    local value6 = t2.value6
    local t119 = { readfile(t2.value49) }

    return value6:JSONDecode(v3(t119))
  end)

  if ok then
    ok = type(result) == "table"
  end

  if ok then
    if type(result.normalSpeed) == "number" then
      t2.value8.NS = result.normalSpeed
    end

    if type(result.carrySpeed) == "number" then
      t2.value8.CS = result.carrySpeed
    end

    if type(result.laggerSpeed) == "number" then
      t2.value8.LAGGER_SPEED = result.laggerSpeed
    end

    if type(result.laggerCarrySpeed) == "number" then
      t2.value8.LAGGER_CARRY_SPEED = result.laggerCarrySpeed
    end

    if type(result.speedMethod) == "string" then
      for _, v in ipairs(t2.value8.speedMethodList) do
        if v == result.speedMethod then
          t2.value8.speedMethod = v

          break
        end
      end
    end

    if type(result.grabRadius) == "number" then
      t2.value8.Steal.StealRadius = result.grabRadius
    end

    if type(result.stealDuration) == "number" then
      t2.value8.Steal.StealDuration = result.stealDuration
    end

    if type(result.stealStopTime) == "number" then
      t2.value8.Steal.StopTime = result.stealStopTime
    end

    if type(result.stealMode) == "string" then
      local v785 = result.stealMode == "Semi"

      if not v785 then
        v785 = result.stealMode == "Normal"

        if not v785 then
          v785 = result.stealMode == "V1" or (result.stealMode == "V2" or result.stealMode == "V3")
        end
      end

      if v785 then
        t2.value8.stealMode = result.stealMode
      end
    end

    if type(result.autoTPHeight) == "number" then
      t2.value8.autoTPHeight = result.autoTPHeight
    end

    if type(result.fovValue) == "number" then
      t2.value8.fovValue = result.fovValue
    end

    if type(result.uiScale) == "number" then
      t2.value8.uiScale = result.uiScale
    end

    if type(result.infJumpMode) == "string" then
      t2.value8.infJumpMode = result.infJumpMode
    end

    if type(result.mobileButtonsSize) == "number" then
      t2.value8.mobileButtonsSize = result.mobileButtonsSize
    end

    if type(result.skyTheme) == "string" then
      t2.value8.currentSkyTheme = result.skyTheme
    end

    if type(result.stealBarSize) == "number" then
      t2.value8.stealBarSize = result.stealBarSize
    end

    if type(result.stealBarScale) == "number" then
      t2.value8.stealBarScale = math.clamp(result.stealBarScale, 0.4, 1.5)
    end

    if result.carrySpeedActive ~= nil then
      t2.value8.carrySpeedActive = result.carrySpeedActive
    end

    if result.laggerModeEnabled ~= nil then
      t2.value8.laggerModeEnabled = result.laggerModeEnabled
    end

    if result.autoSwing ~= nil then
      t2.value8.autoSwingEnabled = result.autoSwing == true
    end

    if result.introSoundEnabled ~= nil then
      t2.value8.introSoundEnabled = result.introSoundEnabled == true
    end

    if result.introSongChoice then
      t2.value8.introSongChoice = result.introSongChoice
    end

    if result.introGUIEnabled ~= nil then
      t2.value8.introGUIEnabled = result.introGUIEnabled == true
    end

    if result.ragdollGui ~= nil then
      t2.value8.ragdollGuiEnabled = result.ragdollGui == true
    end

    if result.circleButtonsEnabled ~= nil then
      t2.value8.circleButtonsEnabled = result.circleButtonsEnabled == true
    end

    if result.perButtonDrag ~= nil then
      t2.value8.perButtonDragEnabled = result.perButtonDrag == true
    end

    if result.mobileButtonsEnabled ~= nil then
      t2.value8.mobileButtonsEnabled = result.mobileButtonsEnabled
    end

    if result.medusaReset ~= nil then
      t2.value8.medusaResetEnabled = result.medusaReset == true
    end

    if result.autoMoveSwing ~= nil then
      t2.value8.autoMoveSwingEnabled = result.autoMoveSwing == true
    end

    if result.autoSwitchSpeed ~= nil then
      t2.value8.autoSwitchSpeedEnabled = result.autoSwitchSpeed == true
    end

    if result.autoTurnOffSpeed ~= nil then
      t2.value8.autoTurnOffSpeedEnabled = result.autoTurnOffSpeed == true
    end

    if result.autoSwitchLaggerSpeed ~= nil then
      t2.value8.autoSwitchLaggerSpeedEnabled = result.autoSwitchLaggerSpeed == true
    end

    if type(result.customFont) == "string" then
      t2.value8.customFontSelected = result.customFont
    end

    if result.showPlayerSpeeds ~= nil then
      t2.value8.showPlayerSpeeds = result.showPlayerSpeeds == true
    end

    if result.removeAcc ~= nil then
      t2.value8.removeAccEnabled = result.removeAcc
    end

    if result.playerESPEnabled ~= nil then
      t2.value8.playerESPEnabled = result.playerESPEnabled
    end

    if result.antiRagdoll ~= nil then
      t2.value8.antiRagdollEnabled = result.antiRagdoll
    end

    if type(result.antiRagdollMode) == "string" and result.antiRagdollMode == "Splatter" or result.antiRagdollMode == "No Splatter" then
      t2.value8.antiRagdollMode = result.antiRagdollMode
    end

    if result.autoStealEnabled ~= nil then
      t2.value8.Steal.AutoStealEnabled = result.autoStealEnabled
    end

    if result.autoRadiusEnabled ~= nil then
      t2.value8.autoRadiusEnabled = result.autoRadiusEnabled == true
    end

    if result.infiniteJump ~= nil then
      t2.value8.infJumpEnabled = result.infiniteJump
    end

    if result.medusaCounter ~= nil then
      t2.value8.medusaCounterEnabled = result.medusaCounter
    end

    if result.batCounter ~= nil then
      t2.value8.batCounterEnabled = result.batCounter
    end

    if result.unwalkEnabled ~= nil then
      t2.value8.unwalkEnabled = result.unwalkEnabled
    end

    if result.antiLag ~= nil then
      t2.value8.antiLagEnabled = result.antiLag
    end

    if result.antiSummerBase ~= nil then
      t2.value8.antiSummerBaseEnabled = result.antiSummerBase
    end

    if result.uiLocked ~= nil then
      t2.value8.uiLocked = result.uiLocked == true
    end

    if result.stretchRez ~= nil then
      t2.value8.stretchRezEnabled = result.stretchRez
    end

    if result.autoTPEnabled ~= nil then
      t2.value8.autoTPEnabled = result.autoTPEnabled
    end

    if result.antiKick ~= nil then
      t2.value8.antiKickEnabled = result.antiKick
    end

    if result.safeMode ~= nil then
      t2.value8.safeModeEnabled = result.safeMode
    end

    if result.mirrorTPDown ~= nil then
      t2.value8.mirrorTPDownEnabled = result.mirrorTPDown
    end

    if result.autoBat ~= nil then
      t2.value8.autoBatEnabled = result.autoBat
    end

    if result.semiHoldMin then
      t2.value8.Semi.holdMin = result.semiHoldMin
    end

    if result.semiHoldMax then
      t2.value8.Semi.holdMax = result.semiHoldMax
    end

    if result.semiEntryDelay then
      t2.value8.Semi.entryDelay = result.semiEntryDelay
    end

    if result.semiPrimeRange then
      t2.value8.Semi.primeRange = result.semiPrimeRange
    end

    if type(result.semiRadius) == "number" then
      t2.value8.Semi.radius = math.min(result.semiRadius, 10)
    end

    if result.lineESPEnabled ~= nil then
      t2.value8.lineESPEnabled = result.lineESPEnabled
    end

    if result.menuOpen ~= nil then
      t2.value8.menuOpen = result.menuOpen ~= false
    end

    if result.speedESPEnabled ~= nil then
      t2.value8.speedESPEnabled = result.speedESPEnabled
    end

    if result.autoResetOnDeath ~= nil then
      t2.value8.autoResetOnDeath = result.autoResetOnDeath
    end

    if type(result.animPack) == "string" then
      t2.value8.animPack = result.animPack
    end

    if result.headlessEnabled ~= nil then
      t2.value8.headlessEnabled = result.headlessEnabled
    end

    if result.korbloxEnabled ~= nil then
      t2.value8.korbloxEnabled = result.korbloxEnabled
    end

    if result.bypassAimbotEnabled ~= nil then
      t2.value8.bypassAimbotEnabled = result.bypassAimbotEnabled
    end

    if result.animPackEnabled ~= nil then
      t2.value8.animPackEnabled = result.animPackEnabled
    end

    local function v786(p255, p256)
      if type(p256) ~= "table" then
        return
      end

      if p256.kb and Enum.KeyCode[p256.kb] then
        p255.kb = Enum.KeyCode[p256.kb]
      else
      p255.kb = nil
    end

    if p256.gp and Enum.KeyCode[p256.gp] then
      p255.gp = Enum.KeyCode[p256.gp]

      return
    end

    p255.gp = nil
  end

  if result.dropBrainrotKey then
    v786(t2.value8.KB.DropBrainrot, result.dropBrainrotKey)
  end

  if result.autoLeftKey then
    v786(t2.value8.KB.AutoLeft, result.autoLeftKey)
  end

  if result.autoRightKey then
    v786(t2.value8.KB.AutoRight, result.autoRightKey)
  end

  if result.autoBatKey then
    v786(t2.value8.KB.AutoBat, result.autoBatKey)
  end

  if result.laggerToggleKey then
    v786(t2.value8.KB.LaggerToggle, result.laggerToggleKey)
  end

  if result.tpFloorKey then
    v786(t2.value8.KB.TPFloor, result.tpFloorKey)
  end

  if result.instaResetKey then
    v786(t2.value8.KB.InstaReset, result.instaResetKey)
  end

  if result.guiHideKey then
    v786(t2.value8.KB.GuiHide, result.guiHideKey)
  end

  if result.speedToggleKey then
    v786(t2.value8.KB.SpeedToggle, result.speedToggleKey)
  end

  if result.bypassAimbotKey then
    v786(t2.value8.KB.BypassAimbot, result.bypassAimbotKey)
  end
end
end)()
t2.value8.buildGui()
pcall(function()
  if t2.value8.applyStealBarTheme then
    t2.value8.applyStealBarTheme(t2.value9)
  end

  if t2.value8.updateHeadTheme then
    t2.value8.updateHeadTheme()
  end

  if t2.value8.mainFrame then
    if t2.value8.mainFrame then
      t2.value8.mainFrame.BackgroundColor3 = t2.value11
    end

    local MainStroke = t2.value8.mainFrame:FindFirstChild("MainStroke")

    if MainStroke then
      MainStroke.Color = t2.value9
    end

    local MainGradient = t2.value8.mainFrame:FindFirstChild("MainGradient")

    if MainGradient then
      MainGradient.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, t2.value13),
      ColorSequenceKeypoint.new(0.45, t2.value11),
      ColorSequenceKeypoint.new(1, t2.value14)
      })
    end
  end
end)
t1.value5 = t2.value8
if t1.value5.mobileButtonsEnabled then
  t2.value8.buildMobileButtons()
end
t1.value5 = t2.value8
if t1.value5.antiRagdollEnabled then
  t2.value8.startAntiRagdoll()
end
t1.value5 = t2.value8
if t1.value5.infJumpEnabled then
  t1.value5 = t2.value8.infJumpMode

  if t1.value5 == "manual" then
    t2.value8.startManualInfJumpLoop()
  else
  t1.value5 = t2.value8.infJumpMode

  if t1.value5 == "hold" then
    t2.value8.startHoldInfJump()
  end
end
end
t1.value5 = t2.value8
if t1.value5.medusaCounterEnabled then
  t2.value8.setupMedusa(t2.value7.Character)
end
t1.value5 = t2.value8
if t1.value5.batCounterEnabled then
  t2.value8.startBatCounter()
end
t1.value5 = t2.value8
if t1.value5.unwalkEnabled then
  t2.value8.startUnwalk()
end
t1.value5 = t2.value8
if t1.value5.autoTPEnabled then
  t2.value8.startAutoTP()
end
t1.value5 = t2.value8
if t1.value5.autoBatEnabled then
  t2.value8.queueAutoBatStart()
end
t1.value5 = t2.value8
if t1.value5.autoLeftEnabled then
  t2.value8.startAutoLeft()
end
t1.value5 = t2.value8
if t1.value5.autoRightEnabled then
  t2.value8.startAutoRight()
end
t1.value5 = t2.value8.Steal
if t1.value5.AutoStealEnabled then
  t2.value8.startAutoSteal()
end
t1.value5 = t2.value8
if t1.value5.bypassAimbotEnabled then
  t2.value8.startBypassAimbot()
end
t1.value5 = t2.value8
if t1.value5.antiKickEnabled then
  t2.value8.enableAntiKick()
end
t1.value5 = t2.value8
if t1.value5.antiLagEnabled then
  t2.value8.enableAntiLag()
end
t1.value5 = t2.value8
if t1.value5.antiSummerBaseEnabled then
  t2.value8.enableAntiSummerBase()
end
t1.value5 = t2.value8
if t1.value5.stretchRezEnabled then
  t2.value8.enableStretchRez()
end
t1.value5 = t2.value8
if t1.value5.removeAccEnabled then
  t2.value8.startRemoveAcc()
end
t1.value5 = t2.value8
if t1.value5.autoResetOnDeath then
  t2.value48()
end
if t2.value8.animPackEnabled and (t2.value8.animPack and t2.value8.PACKS[t2.value8.animPack]) then
  task.wait(0.5)
  t2.value8.applyAnimPack(t2.value8.animPack)
else
local Character = t2.value7.Character

if Character then
  t2.value8.resetAnimations(Character)
end
end
if t2.value8.headlessEnabled or t2.value8.korbloxEnabled then
  task.wait(0.3)
  t2.value8.applyCharterToChar(t2.value7.Character)
end
t2.value8.CandyApplyCustomSky(t2.value8.currentSkyTheme)
t1.value5 = t2.value8
if t1.value5.showPlayerSpeeds then
  t2.value8.togglePlayerSpeeds(true)
end
t1.value5 = t2.value8
if t1.value5.playerESPEnabled then
  t2.value8.toggleESP(true)
end
t2.value8.updateStatusRadius()
t2.value8.startHeadSpeedUpdates()
t1.value5 = t2.value7
if t1.value5.Character then
  t2.value8.setupHeadIndicator(t2.value7.Character)
  t2.value8.setupRagdollTriggers()
end
t2.value7.CharacterAdded:Connect(function(character)
  task.wait(0.5)
  t2.value8.setupHeadIndicator(character)
  t2.value8.setupRagdollTriggers()

  if t2.value8.medusaCounterEnabled then
    t2.value8.setupMedusa(character)
  end

  if t2.value8.batCounterEnabled then
    t2.value8.startBatCounter()
  end

  if t2.value8.unwalkEnabled then
    task.wait(0.5)
    t2.value8.startUnwalk()
  end

  if t2.value8.autoResetOnDeath then
    t2.value48()
  end

  if t2.value8.animPackEnabled and (t2.value8.animPack and t2.value8.PACKS[t2.value8.animPack]) then
    task.wait(0.2)
    t2.value8.applyAnimPack(t2.value8.animPack)
  else
  t2.value8.resetAnimations(character)
end

if t2.value8.headlessEnabled or t2.value8.korbloxEnabled then
  task.wait(0.2)
  t2.value8.applyCharterToChar(character)
end

if t2.value8.bypassAimbotEnabled then
  task.wait(0.2)
  t2.value8.startBypassAimbot()
end
end)
t2.value74 = 0
local Heartbeat = t2.value4.Heartbeat
local Connect = Heartbeat.Connect
function t1.value5()
  if t2.value8._anchoredBySpeed then
    pcall(function()
      t2.value8._anchoredBySpeed.Anchored = false
    end)
    t2.value8._anchoredBySpeed = nil
  end

  if t2.value8._bodyVel then
    pcall(function()
      t2.value8._bodyVel:Destroy()
    end)
    t2.value8._bodyVel = nil
  end

  if t2.value8._bodyPosition then
    pcall(function()
      t2.value8._bodyPosition:Destroy()
    end)
    t2.value8._bodyPosition = nil
  end

  if t2.value8._bodyForce then
    pcall(function()
      t2.value8._bodyForce:Destroy()
    end)
    t2.value8._bodyForce = nil
  end

  if t2.value8._bodyThrust then
    pcall(function()
      t2.value8._bodyThrust:Destroy()
    end)
    t2.value8._bodyThrust = nil
  end

  if t2.value8._linearVel then
    pcall(function()
      t2.value8._linearVel:Destroy()
    end)
    t2.value8._linearVel = nil
  end

  if t2.value8._vectorForce then
    pcall(function()
      t2.value8._vectorForce:Destroy()
    end)
    t2.value8._vectorForce = nil
  end

  if t2.value8._alignPos then
    pcall(function()
      t2.value8._alignPos:Destroy()
    end)
    t2.value8._alignPos = nil
  end

  if t2.value8._rocket then
    pcall(function()
      t2.value8._rocket:Destroy()
    end)
    t2.value8._rocket = nil
  end

  if t2.value8._rocketTarget then
    pcall(function()
      t2.value8._rocketTarget:Destroy()
    end)
    t2.value8._rocketTarget = nil
  end

  if t2.value8._attLinVel then
    pcall(function()
      t2.value8._attLinVel:Destroy()
    end)
    t2.value8._attLinVel = nil
  end

  if t2.value8._attVecForce then
    pcall(function()
      t2.value8._attVecForce:Destroy()
    end)
    t2.value8._attVecForce = nil
  end

  if t2.value8._attAlign then
    pcall(function()
      t2.value8._attAlign:Destroy()
    end)
    t2.value8._attAlign = nil
  end

  if t2.value8._speedTween then
    pcall(function()
      t2.value8._speedTween:Cancel()
    end)
    t2.value8._speedTween = nil
  end
end
Connect(Heartbeat, function(p257)
  t2.value74 = t2.value74 + p257

  if t2.value74 < 0.35 then
    return
  end

  for _, player in ipairs(t2.value1:GetPlayers()) do
    if player ~= t2.value7 and player.Character then
      local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

      if HumanoidRootPart then
        HumanoidRootPart.CanCollide = false
      end

      local Head = player.Character:FindFirstChild("Head")

      if Head then
        Head.CanCollide = false
      end
    end
  end
end)
t2.value75 = t1.value5
t2.value76 = nil
function t2.value76(p258, p259, p260)
  local u1310 = t2.value8[p259]

  if not u1310 or p258 ~= u1310.Parent then
    if u1310 then
      pcall(function()
        u1310:Destroy()
      end)
    end

    u1310 = Instance.new("Attachment")

    local v1311 = u1310

    if not p260 then
      p260 = "MoveeSpeedAtt"
    end

    v1311.Name = p260
    u1310.Parent = p258
    t2.value8[p259] = u1310
  end

  return u1310
end
function t2.value77(p261, p262, p263, p264, p265)
  local value8_8 = t2.value8
  local v1318 = p265 or 0.016666666666667
  local speedMethod = value8_8.speedMethod

  if speedMethod ~= t2.value8._lastSpeedMethod then
    t2.value75()

    if speedMethod ~= "WalkSpeed" and p262.WalkSpeed ~= 16 then
      p262.WalkSpeed = 16
    end

    t2.value8._lastSpeedMethod = speedMethod
  end

  local p261Parent = p261.Parent
  local v1321 = p261.Position + p263 * p264 * v1318

  local function v1322(p266, p267)
    local v1858 = p261.AssemblyMass or 1
    local AssemblyLinearVelocity = p261.AssemblyLinearVelocity
    local vector3 = Vector3.new(p266.X * p267, AssemblyLinearVelocity.Y, p266.Z * p267)
    local u1861 = vector3 - AssemblyLinearVelocity
    pcall(function()
      p261:ApplyImpulse(Vector3.new(u1861.X, 0, u1861.Z) * v1858)
    end)
  end

  if speedMethod == "Velocity" then
    v1322(p263, p264)

    return
  end

  if speedMethod == "AssemblyLinearVelocity" then
    v1322(p263, p264)

    return
  end

  if speedMethod == "Velocity Lerp" then
    local AssemblyLinearVelocity = p261.AssemblyLinearVelocity
    local v1324 = AssemblyLinearVelocity:Lerp(Vector3.new(p263.X * p264, AssemblyLinearVelocity.Y, p263.Z * p264), 0.6)
    local v1325 = p261.AssemblyMass or 1

    pcall(function()
      p261:ApplyImpulse(Vector3.new(v1324.X - AssemblyLinearVelocity.X, 0, v1324.Z - AssemblyLinearVelocity.Z) * v1325)
    end)

    return
  end

  if speedMethod == "AssemblyLinearVelocity Lerp" then
    local AssemblyLinearVelocity = p261.AssemblyLinearVelocity
    local v1327 = AssemblyLinearVelocity:Lerp(Vector3.new(p263.X * p264, AssemblyLinearVelocity.Y, p263.Z * p264), 0.6)
    local u1328 = p261.AssemblyMass or 1
    pcall(function()
      p261:ApplyImpulse(Vector3.new(v1327.X - AssemblyLinearVelocity.X, 0, v1327.Z - AssemblyLinearVelocity.Z) * u1328)
    end)

    return
  end

  if speedMethod == "CFrame" then
    p261.CFrame = p261.CFrame + p263 * p264 * v1318

    return
  end

  if speedMethod == "CFrame Lerp" then
    p261.CFrame = p261.CFrame:Lerp(p261.CFrame + p263 * p264 * v1318, 0.5)

    return
  end

  if speedMethod == "Hyper CFrame" then
    p261.CFrame = p261.CFrame + p263 * p264 * (t2.value8.hyperMult or 4) * v1318

    return
  end

  if speedMethod == "Anchored CFrame" then
    if not p261.Anchored then
      p261.Anchored = true
      t2.value8._anchoredBySpeed = p261
    end

    p261.CFrame = p261.CFrame + p263 * p264 * v1318

    return
  end

  if speedMethod == "PivotTo" then
    p261:PivotTo(p261.CFrame + p263 * p264 * v1318)

    return
  end

  if speedMethod == "Model PivotTo" then
    if p261Parent and p261Parent:IsA("Model") then
      p261Parent:PivotTo(p261Parent:GetPivot() + p263 * p264 * v1318)

      return
    end

    p261:PivotTo(p261.CFrame + p263 * p264 * v1318)

    return
  end

  if speedMethod == "Tween CFrame" then
    if t2.value8._speedTween then
      pcall(function()
        t2.value8._speedTween:Cancel()
      end)
    end

    t2.value8._speedTween = t2.value2:Create(p261, TweenInfo.new(v1318, Enum.EasingStyle.Linear), {
    CFrame = p261.CFrame + p263 * p264 * v1318
    })
    t2.value8._speedTween:Play()

    return
  end

  if speedMethod == "WalkSpeed" then
    p262.WalkSpeed = p264

    return
  end

  if speedMethod == "Humanoid Move" then
    p262.WalkSpeed = p264
    p262:Move(p263)

    return
  end

  if speedMethod == "Humanoid MoveTo" then
    p262:MoveTo(v1321, p261)

    return
  end

  if speedMethod == "BodyVelocity" then
    if not t2.value8._bodyVel or p261 ~= t2.value8._bodyVel.Parent then
      if t2.value8._bodyVel then
        pcall(function()
          t2.value8._bodyVel:Destroy()
        end)
      end

      t2.value8._bodyVel = Instance.new("BodyVelocity")
      t2.value8._bodyVel.MaxForce = Vector3.new(1e999, 1e999, 1e999)
      t2.value8._bodyVel.Parent = p261
    end

    t2.value8._bodyVel.Velocity = Vector3.new(p263.X * p264, t2.value8._bodyVel.Velocity.Y, p263.Z * p264)

    return
  end

  if speedMethod == "BodyPosition" then
    if not t2.value8._bodyPosition or p261 ~= t2.value8._bodyPosition.Parent then
      if t2.value8._bodyPosition then
        pcall(function()
          t2.value8._bodyPosition:Destroy()
        end)
      end

      t2.value8._bodyPosition = Instance.new("BodyPosition")
      t2.value8._bodyPosition.MaxForce = Vector3.new(1e999, 1e999, 1e999)
      t2.value8._bodyPosition.P = 500
      t2.value8._bodyPosition.D = 50
      t2.value8._bodyPosition.Parent = p261
    end

    t2.value8._bodyPosition.Position = v1321

    return
  end

  if speedMethod == "BodyForce" then
    if not t2.value8._bodyForce or p261 ~= t2.value8._bodyForce.Parent then
      if t2.value8._bodyForce then
        pcall(function()
          t2.value8._bodyForce:Destroy()
        end)
      end

      t2.value8._bodyForce = Instance.new("BodyForce")
      t2.value8._bodyForce.Parent = p261
    end

    t2.value8._bodyForce.Force = Vector3.new(p263.X * p264, 0, p263.Z * p264) * 100

    return
  end

  if speedMethod == "BodyThrust" then
    if not t2.value8._bodyThrust or p261 ~= t2.value8._bodyThrust.Parent then
      if t2.value8._bodyThrust then
        pcall(function()
          t2.value8._bodyThrust:Destroy()
        end)
      end

      t2.value8._bodyThrust = Instance.new("BodyThrust")
      t2.value8._bodyThrust.Force = Vector3.new(1e999, 1e999, 1e999)
      t2.value8._bodyThrust.Parent = p261
    end

    t2.value8._bodyThrust.Force = Vector3.new(p263.X * p264, 0, p263.Z * p264) * 100

    return
  end

  if speedMethod == "LinearVelocity" then
    if not t2.value8._linearVel or p261 ~= t2.value8._linearVel.Parent then
      if t2.value8._linearVel then
        pcall(function()
          t2.value8._linearVel:Destroy()
        end)
      end

      local v1329 = t2.value76(p261, "_attLinVel", "MoveeLinVelAtt")

      t2.value8._linearVel = Instance.new("LinearVelocity")
      t2.value8._linearVel.Attachment0 = v1329
      t2.value8._linearVel.MaxForce = 100000000
      t2.value8._linearVel.RelativeTo = Enum.ActuatorRelativeTo.World
      t2.value8._linearVel.Parent = p261
    end

    t2.value8._linearVel.VectorVelocity = Vector3.new(p263.X * p264, t2.value8._linearVel.VectorVelocity.Y, p263.Z * p264)

    return
  end

  if speedMethod == "VectorForce" then
    if not t2.value8._vectorForce or p261 ~= t2.value8._vectorForce.Parent then
      if t2.value8._vectorForce then
        pcall(function()
          t2.value8._vectorForce:Destroy()
        end)
      end

      local v1330 = t2.value76(p261, "_attVecForce", "MoveeVecForceAtt")

      t2.value8._vectorForce = Instance.new("VectorForce")
      t2.value8._vectorForce.Attachment0 = v1330
      t2.value8._vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
      t2.value8._vectorForce.Parent = p261
    end

    t2.value8._vectorForce.Force = Vector3.new(p263.X * p264, 0, p263.Z * p264) * 100

    return
  end

  if speedMethod == "AlignPosition" then
    if not t2.value8._alignPos or p261 ~= t2.value8._alignPos.Parent then
      if t2.value8._alignPos then
        pcall(function()
          t2.value8._alignPos:Destroy()
        end)
      end

      local v1331 = t2.value76(p261, "_attAlign", "MoveeAlignAtt")

      t2.value8._alignPos = Instance.new("AlignPosition")
      t2.value8._alignPos.Attachment0 = v1331
      t2.value8._alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
      t2.value8._alignPos.MaxForce = 1e999
      t2.value8._alignPos.Responsiveness = 15
      t2.value8._alignPos.RigidityEnabled = false
      t2.value8._alignPos.Parent = p261
    end

    t2.value8._alignPos.Position = v1321

    return
  end

  if speedMethod == "ApplyImpulse" then
    local v1332 = p261.AssemblyMass or 1
    local AssemblyLinearVelocity = p261.AssemblyLinearVelocity
    local vector3 = Vector3.new(p263.X * p264, AssemblyLinearVelocity.Y, p263.Z * p264)
    local u1335 = vector3 - AssemblyLinearVelocity
    pcall(function()
      p261:ApplyImpulse(Vector3.new(u1335.X, 0, u1335.Z) * v1332)
    end)

    return
  end

  if speedMethod == "RocketPropulsion" then
    if not t2.value8._rocket or (p261 ~= t2.value8._rocket.Parent or not t2.value8._rocketTarget) then
      if t2.value8._rocket then
        pcall(function()
          t2.value8._rocket:Destroy()
        end)
      end

      if t2.value8._rocketTarget then
        pcall(function()
          t2.value8._rocketTarget:Destroy()
        end)
      end

      t2.value8._rocketTarget = Instance.new("Part")
      t2.value8._rocketTarget.Name = "MoveeRocketTarget"
      t2.value8._rocketTarget.Anchored = true
      t2.value8._rocketTarget.CanCollide = false
      t2.value8._rocketTarget.Transparency = 1
      t2.value8._rocketTarget.Size = Vector3.new(1, 1, 1)
      t2.value8._rocketTarget.Parent = workspace
      t2.value8._rocket = Instance.new("RocketPropulsion")
      t2.value8._rocket.MaxThrust = 3000
      t2.value8._rocket.MaxTorque = 1000
      t2.value8._rocket.ThrustP = 100
      t2.value8._rocket.ThrustD = 20
      t2.value8._rocket.TurnP = 100
      t2.value8._rocket.TurnD = 10
      t2.value8._rocket.Target = t2.value8._rocketTarget
      t2.value8._rocket.Parent = p261
    end

    t2.value8._rocketTarget.Position = v1321
    pcall(function()
      t2.value8._rocket:Fire()
    end)
  end
end
t2.value4.RenderStepped:Connect(function(dt)
  local Character = t2.value7.Character

  if not Character then
    return
  end

  local Humanoid = Character:FindFirstChildOfClass("Humanoid")
  local v1339 = not Humanoid
  local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

  if not v1339 then
    v1339 = not HumanoidRootPart
  end

  if v1339 then
    return
  end

  if t2.value8.isRagdollState(Humanoid) then
    t2.value8.lastMoveDir = Vector3.new(0, 0, 0)
    t2.value75()

    return
  end

  if not t2.value8.autoBatEnabled and (not t2.value8.autoLeftEnabled and not t2.value8.autoRightEnabled) then
    t2.value8.updateAutoSwitchSpeed()

    local MoveDirection = Humanoid.MoveDirection
    local v1342 = t2.value8.getActiveMoveSpeed()
    local vector3 = Vector3.new(0, 0, 0)

    if MoveDirection.Magnitude > 0 then
      t2.value8.lastMoveDir = MoveDirection
      vector3 = MoveDirection
    elseif t2.value8.antiRagdollEnabled and t2.value8.lastMoveDir.Magnitude > 0 then
      local v1344 = false

      for k in pairs(t2.value8.MOVE_KEYS) do
        if t2.value3:IsKeyDown(k) then
          v1344 = true

          break
        end
      end

      if v1344 then
        vector3 = t2.value8.lastMoveDir
      end
    end

    if vector3.Magnitude > 0 then
      t2.value77(HumanoidRootPart, Humanoid, vector3, v1342, dt)

      return
    end

    t2.value75()
  end
end)
task.spawn(function()
  while true do
    task.wait(5)
    t2.value50()
  end
end)
t2.value8.applyFOV()
task.spawn(function()
  while true do
    task.wait(3)
    pcall(t2.value8.saveBtnPositions)
  end
end)
task.spawn(function()
  local v1346 = workspace:FindFirstChild("Plots") or workspace:WaitForChild("Plots", 10)

  if v1346 then

    for v1349, v1350 in ipairs(v1346:GetChildren()) do

      if v1350:IsA("Model") then
        t2.value25(v1350)
      end
    end
    v1346.ChildAdded:Connect(function(child)
      if child:IsA("Model") then
        task.wait(0.5)
        t2.value25(child)
      end
    end)
    while true do
      task.wait(5)
      t2.value8.animalCache = {}
      t2.value8.promptCache = {}
      t2.value8.stealCache = {}

      for _, child in ipairs(v1346:GetChildren()) do
        if child:IsA("Model") then
          t2.value25(child)
        end
      end
    end
  end
end)
task.spawn(function()
  t2.value8.initSemiSync()

  while true do
    task.wait(5)

    if t2.value8.Semi.enabled or t2.value8.stealMode == "Semi" then
      pcall(t2.value8.scanAllPlotsSemi)
    end
  end
end)

function t2.value8.refreshSpeedModeLabel()
end
pcall(function()
  t2.value8.refreshWalkSpeedAutoSwitch()

  if t2.value8.customFontSelected and t2.value8.customFontSelected ~= "None" then
    task.spawn(function()
      task.wait(0.4)
      pcall(function()
        t2.value8.applyCustomFont(t2.value8.customFontSelected)
      end)
    end)
  end
end)
print("prince is the best")
print("prince is the best")
print("prince is the best")
print("prince is the best")
print("prince is the best")
print("prince is the best")

return t2.value8
