loadstring(game:HttpGet("https://gist.githubusercontent.com/angeryy-tvy/e284f6d9b679f604c1eab3c30ad0d51f/raw/GAG2-Kaitun-Vxeze"))()

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
