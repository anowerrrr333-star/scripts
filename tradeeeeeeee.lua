-- Advanced Name & Avatar Changer Script для Roblox
-- Глубокая замена имён и аватарок во всех элементах игры

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Создаём ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NameChangerGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Скрыть/Показать на Левый Ctrl
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Text = "Advanced Changer (L-CTRL)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- User TextBox
local UserLabel = Instance.new("TextLabel")
UserLabel.Size = UDim2.new(0, 80, 0, 30)
UserLabel.Position = UDim2.new(0, 10, 0, 40)
UserLabel.BackgroundTransparency = 1
UserLabel.Text = "User:"
UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UserLabel.TextSize = 14
UserLabel.Font = Enum.Font.Gotham
UserLabel.TextXAlignment = Enum.TextXAlignment.Left
UserLabel.Parent = MainFrame

local UserTextBox = Instance.new("TextBox")
UserTextBox.Name = "UserTextBox"
UserTextBox.Size = UDim2.new(0, 190, 0, 30)
UserTextBox.Position = UDim2.new(0, 100, 0, 40)
UserTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
UserTextBox.BorderSizePixel = 0
UserTextBox.Text = ""
UserTextBox.PlaceholderText = "Введите ник игрока..."
UserTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UserTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
UserTextBox.TextSize = 14
UserTextBox.Font = Enum.Font.Gotham
UserTextBox.Parent = MainFrame

local UserTextBoxCorner = Instance.new("UICorner")
UserTextBoxCorner.CornerRadius = UDim.new(0, 6)
UserTextBoxCorner.Parent = UserTextBox

-- Change To TextBox
local ChangeToLabel = Instance.new("TextLabel")
ChangeToLabel.Size = UDim2.new(0, 80, 0, 30)
ChangeToLabel.Position = UDim2.new(0, 10, 0, 80)
ChangeToLabel.BackgroundTransparency = 1
ChangeToLabel.Text = "Change to:"
ChangeToLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeToLabel.TextSize = 14
ChangeToLabel.Font = Enum.Font.Gotham
ChangeToLabel.TextXAlignment = Enum.TextXAlignment.Left
ChangeToLabel.Parent = MainFrame

local ChangeToTextBox = Instance.new("TextBox")
ChangeToTextBox.Name = "ChangeToTextBox"
ChangeToTextBox.Size = UDim2.new(0, 190, 0, 30)
ChangeToTextBox.Position = UDim2.new(0, 100, 0, 80)
ChangeToTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ChangeToTextBox.BorderSizePixel = 0
ChangeToTextBox.Text = ""
ChangeToTextBox.PlaceholderText = "Новый ник..."
ChangeToTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeToTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
ChangeToTextBox.TextSize = 14
ChangeToTextBox.Font = Enum.Font.Gotham
ChangeToTextBox.Parent = MainFrame

local ChangeToTextBoxCorner = Instance.new("UICorner")
ChangeToTextBoxCorner.CornerRadius = UDim.new(0, 6)
ChangeToTextBoxCorner.Parent = ChangeToTextBox

-- Change Button
local ChangeButton = Instance.new("TextButton")
ChangeButton.Name = "ChangeButton"
ChangeButton.Size = UDim2.new(0, 280, 0, 35)
ChangeButton.Position = UDim2.new(0, 10, 0, 120)
ChangeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ChangeButton.BorderSizePixel = 0
ChangeButton.Text = "Change"
ChangeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeButton.TextSize = 16
ChangeButton.Font = Enum.Font.GothamBold
ChangeButton.Parent = MainFrame

local ChangeButtonCorner = Instance.new("UICorner")
ChangeButtonCorner.CornerRadius = UDim.new(0, 6)
ChangeButtonCorner.Parent = ChangeButton

-- Auto Change Toggle
local AutoChangeButton = Instance.new("TextButton")
AutoChangeButton.Name = "AutoChangeButton"
AutoChangeButton.Size = UDim2.new(0, 280, 0, 35)
AutoChangeButton.Position = UDim2.new(0, 10, 0, 160)
AutoChangeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
AutoChangeButton.BorderSizePixel = 0
AutoChangeButton.Text = "Auto Change: OFF"
AutoChangeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoChangeButton.TextSize = 16
AutoChangeButton.Font = Enum.Font.GothamBold
AutoChangeButton.Parent = MainFrame

local AutoChangeButtonCorner = Instance.new("UICorner")
AutoChangeButtonCorner.CornerRadius = UDim.new(0, 6)
AutoChangeButtonCorner.Parent = AutoChangeButton

-- Переменные для работы
local autoChangeEnabled = false
local autoChangeConnection = nil
local lastUpdate = 0

-- КЭШ для Аватарок
local cachedTargetUser = ""
local cachedNewName = ""
local targetUserId = 0
local newUserId = 0

-- Получаем ID пользователей для замены аватарок
local function UpdateUserIDs(targetName, newName)
    if targetName ~= cachedTargetUser or newName ~= cachedNewName then
        cachedTargetUser = targetName
        cachedNewName = newName
        pcall(function()
            targetUserId = Players:GetUserIdFromNameAsync(targetName)
            newUserId = Players:GetUserIdFromNameAsync(newName)
        end)
    end
end

-- Функция для проверки совпадения текста
local function TextMatches(text, targetUsername)
    if not text or not targetUsername then return false end
    local lowerText = string.lower(tostring(text))
    local lowerTarget = string.lower(targetUsername)
    
    return lowerText == lowerTarget or 
           string.find(lowerText, lowerTarget, 1, true) or
           lowerText:match(lowerTarget)
end

-- Функция для замены картинки
local function ReplaceImageCheck(obj)
    if (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and targetUserId > 0 and newUserId > 0 then
        if string.find(tostring(obj.Image), tostring(targetUserId)) then
            -- Меняем на аватарку нового пользователя
            obj.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(newUserId) .. "&w=150&h=150"
            return true
        end
    end
    return false
end

-- Глубокая функция замены везде
local function DeepReplaceEverywhere(targetUsername, newName)
    if targetUsername == "" or newName == "" then return end
    local replacedCount = 0
    
    -- 1. ЗАМЕНА В WORKSPACE
    pcall(function()
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if TextMatches(obj.Text, targetUsername) then
                    obj.Text = newName
                    replacedCount = replacedCount + 1
                end
            end
            if ReplaceImageCheck(obj) then replacedCount = replacedCount + 1 end
            
            if obj:IsA("Humanoid") and TextMatches(obj.DisplayName, targetUsername) then
                obj.DisplayName = newName
                replacedCount = replacedCount + 1
            end
            if obj:IsA("Model") and TextMatches(obj.Name, targetUsername) then
                obj.Name = newName
                replacedCount = replacedCount + 1
            end
        end
    end)
    
    -- 2. ЗАМЕНА В LEADERBOARD
    pcall(function()
        local playerList = game:GetService("CoreGui"):FindFirstChild("PlayerList")
        if playerList then
            for _, obj in pairs(playerList:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    if TextMatches(obj.Text, targetUsername) then
                        obj.Text = newName
                        replacedCount = replacedCount + 1
                    end
                end
                if ReplaceImageCheck(obj) then replacedCount = replacedCount + 1 end
            end
        end
    end)
    
    -- 3. ЗАМЕНА ВО ВСЕХ PlayerGui ВСЕХ ИГРОКОВ
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            local playerGui = player:FindFirstChild("PlayerGui")
            if playerGui then
                for _, obj in pairs(playerGui:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        if TextMatches(obj.Text, targetUsername) then
                            obj.Text = newName
                            replacedCount = replacedCount + 1
                        end
                    end
                    if ReplaceImageCheck(obj) then replacedCount = replacedCount + 1 end
                end
            end
        end
    end)
    
    -- 4. СПЕЦИАЛЬНАЯ ЗАМЕНА ПО ПУТИ TradeLiveTrade
    pcall(function()
        local tradePath = LocalPlayer:FindFirstChild("PlayerGui")
        if tradePath then
            tradePath = tradePath:FindFirstChild("TradeLiveTrade")
            if tradePath then
                tradePath = tradePath:FindFirstChild("TradeLiveTrade")
                if tradePath then
                    tradePath = tradePath:FindFirstChild("Other")
                    if tradePath then
                        local username = tradePath:FindFirstChild("Username")
                        if username and username:IsA("TextLabel") then
                            username.Text = newName
                            replacedCount = replacedCount + 1
                        end
                        -- Проверка аватарок в этом же окне
                        for _, obj in pairs(tradePath.Parent:GetDescendants()) do
                            if ReplaceImageCheck(obj) then replacedCount = replacedCount + 1 end
                        end
                    end
                end
            end
        end
    end)
    
    -- 5. ЗАМЕНА В StarterGui
    pcall(function()
        for _, obj in pairs(game:GetService("StarterGui"):GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if TextMatches(obj.Text, targetUsername) then
                    obj.Text = newName
                    replacedCount = replacedCount + 1
                end
            end
            if ReplaceImageCheck(obj) then replacedCount = replacedCount + 1 end
        end
    end)
    
    -- 6. ЗАМЕНА ВО ВСЕХ BillboardGui и SurfaceGui
    pcall(function()
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                for _, child in pairs(obj:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        if TextMatches(child.Text, targetUsername) then
                            child.Text = newName
                            replacedCount = replacedCount + 1
                        end
                    end
                    if ReplaceImageCheck(child) then replacedCount = replacedCount + 1 end
                end
            end
        end
    end)
    
    -- 7. ЗАМЕНА В CHAT
    pcall(function()
        local chat = game:GetService("CoreGui"):FindFirstChild("ExperienceChat")
        if chat then
            for _, obj in pairs(chat:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    if TextMatches(obj.Text, targetUsername) then
                        obj.Text = newName
                        replacedCount = replacedCount + 1
                    end
                end
                if ReplaceImageCheck(obj) then replacedCount = replacedCount + 1 end
            end
        end
    end)
    
    -- 8. ЗАМЕНА В ReplicatedStorage
    pcall(function()
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if TextMatches(obj.Text, targetUsername) then
                    obj.Text = newName
                    replacedCount = replacedCount + 1
                end
            end
            if ReplaceImageCheck(obj) then replacedCount = replacedCount + 1 end
            
            if obj:IsA("StringValue") or obj:IsA("Configuration") then
                if TextMatches(obj.Value, targetUsername) then
                    obj.Value = newName
                    replacedCount = replacedCount + 1
                end
            end
        end
    end)
    
    -- 9. ЗАМЕНА имён персонажей
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if TextMatches(player.Name, targetUsername) or TextMatches(player.DisplayName, targetUsername) then
                local character = player.Character
                if character then
                    for _, obj in pairs(character:GetDescendants()) do
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                            if TextMatches(obj.Text, targetUsername) then
                                obj.Text = newName
                                replacedCount = replacedCount + 1
                            end
                        end
                        if ReplaceImageCheck(obj) then replacedCount = replacedCount + 1 end
                    end
                    
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.DisplayName = newName
                        replacedCount = replacedCount + 1
                    end
                end
            end
        end
    end)
    
    return replacedCount
end

-- Функция для создания постоянных мониторов новых объектов
local function SetupContinuousMonitoring(targetUsername, newName)
    local connection1 = game.DescendantAdded:Connect(function(obj)
        task.wait(0.1)
        pcall(function()
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if TextMatches(obj.Text, targetUsername) then
                    obj.Text = newName
                end
                obj:GetPropertyChangedSignal("Text"):Connect(function()
                    if TextMatches(obj.Text, targetUsername) then
                        obj.Text = newName
                    end
                end)
            end
            ReplaceImageCheck(obj)
        end)
    end)
    
    local connection2 = RunService.Heartbeat:Connect(function()
        pcall(function()
            local username = LocalPlayer.PlayerGui:FindFirstChild("TradeLiveTrade")
            if username then
                username = username:FindFirstChild("TradeLiveTrade")
                if username then
                    username = username:FindFirstChild("Other")
                    if username then
                        local txt = username:FindFirstChild("Username")
                        if txt and txt:IsA("TextLabel") then
                            if TextMatches(txt.Text, targetUsername) or txt.Text ~= newName then
                                txt.Text = newName
                            end
                        end
                    end
                end
            end
        end)
    end)
    
    return connection1, connection2
end

local monitorConnection1, monitorConnection2

-- Обработчик кнопки Change
ChangeButton.MouseButton1Click:Connect(function()
    local targetUser = UserTextBox.Text
    local newName = ChangeToTextBox.Text
    
    if targetUser == "" or newName == "" then
        warn("Заполните оба поля!")
        return
    end
    
    UpdateUserIDs(targetUser, newName)
    local count = DeepReplaceEverywhere(targetUser, newName)
    print("✅ Заменено элементов (текст + картинки): " .. count)
end)

-- Обработчик кнопки Auto Change
AutoChangeButton.MouseButton1Click:Connect(function()
    autoChangeEnabled = not autoChangeEnabled
    
    if autoChangeEnabled then
        local targetUser = UserTextBox.Text
        local newName = ChangeToTextBox.Text
        
        if targetUser == "" or newName == "" then
            warn("Заполните оба поля перед включением Auto Change!")
            autoChangeEnabled = false
            return
        end
        
        AutoChangeButton.Text = "Auto Change: ON"
        AutoChangeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        
        UpdateUserIDs(targetUser, newName)
        monitorConnection1, monitorConnection2 = SetupContinuousMonitoring(targetUser, newName)
        
        autoChangeConnection = RunService.Heartbeat:Connect(function()
            local currentTime = tick()
            if currentTime - lastUpdate >= 1 then
                lastUpdate = currentTime
                if autoChangeEnabled then
                    local targetUserCurrent = UserTextBox.Text
                    local newNameCurrent = ChangeToTextBox.Text
                    if targetUserCurrent ~= "" and newNameCurrent ~= "" then
                        UpdateUserIDs(targetUserCurrent, newNameCurrent)
                        DeepReplaceEverywhere(targetUserCurrent, newNameCurrent)
                    end
                end
            end
        end)
        print("🔄 Auto Change включен! Замена каждую секунду...")
    else
        AutoChangeButton.Text = "Auto Change: OFF"
        AutoChangeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        if autoChangeConnection then autoChangeConnection:Disconnect() autoChangeConnection = nil end
        if monitorConnection1 then monitorConnection1:Disconnect() monitorConnection1 = nil end
        if monitorConnection2 then monitorConnection2:Disconnect() monitorConnection2 = nil end
        print("⏸️ Auto Change выключен!")
    end
end)

-- Эффекты при наведении
ChangeButton.MouseEnter:Connect(function() ChangeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255) end)
ChangeButton.MouseLeave:Connect(function() ChangeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255) end)
AutoChangeButton.MouseEnter:Connect(function() AutoChangeButton.BackgroundColor3 = autoChangeEnabled and Color3.fromRGB(0, 230, 120) or Color3.fromRGB(255, 100, 100) end)
AutoChangeButton.MouseLeave:Connect(function() AutoChangeButton.BackgroundColor3 = autoChangeEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(255, 70, 70) end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        if autoChangeConnection then autoChangeConnection:Disconnect() end
        if monitorConnection1 then monitorConnection1:Disconnect() end
        if monitorConnection2 then monitorConnection2:Disconnect() end
    end
end)

print("╔════════════════════════════════════╗")
print("║  Advanced Name & Avatar Changer    ║")
print("║  (Левый CTRL для скрытия меню)     ║")
print("╚════════════════════════════════════╝")
