-- Optimized Advanced Name & Avatar Changer for Roblox (fixed @@ issue)
-- Исправленная версия: без двойных собачек и с автоматической обработкой

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Секция (без изменений)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NameChangerGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Text = "Advanced Name & Avatar Changer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local UserTextBox = Instance.new("TextBox")
UserTextBox.Name = "UserTextBox"
UserTextBox.Size = UDim2.new(0, 190, 0, 30)
UserTextBox.Position = UDim2.new(0, 100, 0, 40)
UserTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
UserTextBox.Text = ""
UserTextBox.PlaceholderText = "Введите ник..."
UserTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UserTextBox.Parent = MainFrame

local ChangeToTextBox = Instance.new("TextBox")
ChangeToTextBox.Name = "ChangeToTextBox"
ChangeToTextBox.Size = UDim2.new(0, 190, 0, 30)
ChangeToTextBox.Position = UDim2.new(0, 100, 0, 80)
ChangeToTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ChangeToTextBox.Text = ""
ChangeToTextBox.PlaceholderText = "Новый ник..."
ChangeToTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeToTextBox.Parent = MainFrame

local ChangeButton = Instance.new("TextButton")
ChangeButton.Name = "ChangeButton"
ChangeButton.Size = UDim2.new(0, 280, 0, 35)
ChangeButton.Position = UDim2.new(0, 10, 0, 120)
ChangeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ChangeButton.Text = "Change Once"
ChangeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeButton.Parent = MainFrame

local AutoChangeButton = Instance.new("TextButton")
AutoChangeButton.Name = "AutoChangeButton"
AutoChangeButton.Size = UDim2.new(0, 280, 0, 35)
AutoChangeButton.Position = UDim2.new(0, 10, 0, 160)
AutoChangeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
AutoChangeButton.Text = "Auto Change: OFF"
AutoChangeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoChangeButton.Parent = MainFrame

-- Переменные и кэш
local autoChangeEnabled = false
local connections = {}
local thumbnailCache = {}

-- Утилиты
local function sanitizeName(name)
    if not name then return nil end
    -- Убираем пробелы и ВСЕ собачки в начале
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", ""):gsub("^@+", "")
    return name ~= "" and name or nil
end

local function ResolveNameToUserId(name)
    name = sanitizeName(name)
    if not name then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name) == string.lower(name) then
            return p.UserId
        end
    end
    local success, userId = pcall(function() return Players:GetUserIdFromNameAsync(name) end)
    return success and userId or nil
end

local function GetThumbnailCached(userId)
    if not userId then return nil end
    if thumbnailCache[userId] then return thumbnailCache[userId] end
    local ok, url = pcall(function() return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
    if ok then thumbnailCache[userId] = url return url end
    return nil
end

-- Мониторинг
local function SetupContinuousMonitoring(targetUsernameRaw, newNameRaw)
    for _, conn in pairs(connections) do pcall(function() conn:Disconnect() end) end
    connections = {}

    local targetName = sanitizeName(targetUsernameRaw)
    local newNameClean = sanitizeName(newNameRaw) -- Тоже очищаем от @
    
    if not targetName or not newNameClean then return end

    local function HandleObject(obj)
        if not obj or not obj.Parent then return end

        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local function FixText()
                if not obj.Text then return end
                -- Если в тексте есть наш таргет
                if string.find(string.lower(obj.Text), string.lower(targetName), 1, true) then
                    -- Заменяем чистое имя на чистое имя. Собачки в самом UI не пострадают и не удвоятся.
                    obj.Text = string.gsub(obj.Text, targetName, newNameClean)
                end
            end

            FixText()
            local conn = obj:GetPropertyChangedSignal("Text"):Connect(FixText)
            table.insert(connections, conn)
        end

        -- Обработка аватарок
        if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            local tId = ResolveNameToUserId(targetName)
            local nId = ResolveNameToUserId(newNameClean)
            if tId and nId then
                local function FixImage()
                    if string.find(tostring(obj.Image), tostring(tId)) then
                        obj.Image = GetThumbnailCached(nId)
                    end
                end
                FixImage()
                table.insert(connections, obj:GetPropertyChangedSignal("Image"):Connect(FixImage))
            end
        end
    end

    local containers = {
        game:GetService("CoreGui"),
        LocalPlayer:FindFirstChild("PlayerGui"),
        game:GetService("StarterGui"),
        game.Workspace,
        game:GetService("ReplicatedStorage")
    }

    for _, container in ipairs(containers) do
        if container then
            -- Сначала обрабатываем всё что уже есть
            for _, obj in pairs(container:GetDescendants()) do
                HandleObject(obj)
            end
            -- Потом следим за новыми
            local conn = container.DescendantAdded:Connect(function(obj)
                task.defer(function() HandleObject(obj) end)
            end)
            table.insert(connections, conn)
        end
    end
end

-- Логика кнопок
AutoChangeButton.MouseButton1Click:Connect(function()
    autoChangeEnabled = not autoChangeEnabled
    if autoChangeEnabled then
        AutoChangeButton.Text = "Auto Change: ON"
        AutoChangeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        SetupContinuousMonitoring(UserTextBox.Text, ChangeToTextBox.Text)
    else
        AutoChangeButton.Text = "Auto Change: OFF"
        AutoChangeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        for _, conn in pairs(connections) do pcall(function() conn:Disconnect() end) end
        connections = {}
    end
end)

ChangeButton.MouseButton1Click:Connect(function()
    SetupContinuousMonitoring(UserTextBox.Text, ChangeToTextBox.Text)
end)

-- Скрытие на Ctrl
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
