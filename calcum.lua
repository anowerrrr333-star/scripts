-- clean by prince︱.gg/freesource

do
    local LINK = "discord.gg/freesource"
    local lines = {"LEAK ON .GG/FREESOURCE"}
    for _ = 1, 6 do lines[#lines + 1] = LINK end
    for _, l in ipairs(lines) do pcall(print, l) end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "LEAK ON .GG/FREESOURCE | " .. LINK, Duration = 10 })
    end)
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = "LeakNotice"; g.ResetOnSpawn = false; g.DisplayOrder = 10000
        local ok = false
        if typeof(gethui) == "function" then ok = pcall(function() g.Parent = gethui() end) end
        if not ok then ok = pcall(function() g.Parent = game:GetService("CoreGui") end) end
        if not ok then g.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
        local l = Instance.new("TextLabel", g)
        l.AnchorPoint = Vector2.new(0.5, 0); l.Position = UDim2.new(0.5, 0, 0, 6)
        l.Size = UDim2.new(1, 0, 0, 22); l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold; l.TextSize = 14; l.TextColor3 = Color3.new(1, 1, 1)
        l.TextStrokeTransparency = 0.4
        l.Text = "LEAK ON .GG/FREESOURCE | " .. LINK
        task.delay(15, function() g:Destroy() end)
    end)
end


playIntroAnimation = function()
    local Players2 = game:GetService("Players")
    local TweenService2 = game:GetService("TweenService")
    local SoundService2 = game:GetService("SoundService")
    local Debris2 = game:GetService("Debris")
    local RunService2 = game:GetService("RunService")
    local LP2 = Players2.LocalPlayer
    local guiParent = LP2:WaitForChild("PlayerGui")

    pcall(function()
        for _, parent in ipairs({
            guiParent,
            (gethui and gethui()) or nil,
            game:GetService("CoreGui"),
        }) do
            if parent then
                local old = parent:FindFirstChild("NxcSniperIntro")
                if old then old:Destroy() end
            end
        end
    end)

    local themeAccent = Color3.fromRGB(55, 140, 255)
    local themeDim = Color3.fromRGB(100, 140, 190)
    local themeText = Color3.fromRGB(220, 235, 255)
    local LASER = Color3.fromRGB(255, 45, 45)

    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "NxcSniperIntro"
    splashGui.ResetOnSpawn = false
    splashGui.DisplayOrder = 9999
    splashGui.IgnoreGuiInset = true
    splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    do
        local ok = false
        if typeof(gethui) == "function" then
            ok = pcall(function() splashGui.Parent = gethui() end)
        end
        if not ok then
            ok = pcall(function() splashGui.Parent = game:GetService("CoreGui") end)
        end
        if not ok then
            splashGui.Parent = guiParent
        end
    end

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = splashGui
    local backdrop = Instance.new("ImageLabel")
    backdrop.Name = "NebulaBackdrop"
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundTransparency = 1
    backdrop.Image = "rbxassetid://129085053275432"
    backdrop.ScaleType = Enum.ScaleType.Crop
    backdrop.ImageTransparency = 0.82
    backdrop.ImageColor3 = Color3.fromRGB(60, 110, 255)
    backdrop.ZIndex = 1
    backdrop.Parent = splashGui
    local backdropShade = Instance.new("Frame")
    backdropShade.BackgroundColor3 = Color3.fromRGB(5, 10, 19)
    backdropShade.BackgroundTransparency = 0.28
    backdropShade.Size = UDim2.fromScale(1, 1)
    backdropShade.BorderSizePixel = 0
    backdropShade.ZIndex = 1
    backdropShade.Parent = splashGui
    local backgroundGradient = Instance.new("UIGradient")
    backgroundGradient.Color = ColorSequence.new(Color3.fromRGB(7, 18, 36), Color3.fromRGB(0, 0, 0))
    backgroundGradient.Rotation = 90
    backgroundGradient.Parent = backdropShade
    local introRandom = Random.new(24688)
    for i = 1, 22 do
        local star = Instance.new("Frame")
        local diameter = i % 5 == 0 and 3 or 2
        star.Name = "Star"
        star.Size = UDim2.fromOffset(diameter, diameter)
        star.Position = UDim2.fromScale(introRandom:NextNumber(0.05, 0.95), introRandom:NextNumber(0.08, 0.92))
        star.BackgroundColor3 = Color3.fromRGB(110, 205, 249)
        star.BackgroundTransparency = introRandom:NextNumber(0.55, 0.85)
        star.BorderSizePixel = 0
        star.ZIndex = 2
        star.Parent = splashGui
        Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    end

    local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
    local SCOPE_D = math.floor(math.clamp(math.min(viewport.X, viewport.Y) * 0.36, 132, 200))
    local TUBE = math.floor(SCOPE_D * 0.55)

    local function splashText(value, at, size, tint, alignment, z)
        local textObj = Instance.new("TextLabel")
        textObj.Text = value
        textObj.BackgroundTransparency = 1
        textObj.TextColor3 = tint
        textObj.Font = Enum.Font.GothamBold
        textObj.TextSize = size
        textObj.TextXAlignment = alignment or Enum.TextXAlignment.Center
        textObj.TextTruncate = Enum.TextTruncate.AtEnd
        textObj.Size = UDim2.new(1, -36, 0, size + 12)
        textObj.Position = at
        textObj.ZIndex = z or 20
        textObj.Parent = splashGui
        return textObj
    end
    local topBrand = splashText("C A L C I U M   H U B", UDim2.new(0, 20, 0, 27), 20,
        Color3.fromRGB(220, 245, 255), Enum.TextXAlignment.Left, 20)
    local topDivision = splashText("CALCIUM HUB  /  STARTUP", UDim2.new(0, 20, 0, 61), 11,
        Color3.fromRGB(91, 172, 224), Enum.TextXAlignment.Left, 20)
    local headerRule = Instance.new("Frame")
    headerRule.Size = UDim2.new(1, -40, 0, 1)
    headerRule.Position = UDim2.fromOffset(20, 89)
    headerRule.BackgroundColor3 = Color3.fromRGB(43, 119, 171)
    headerRule.BackgroundTransparency = 0.45
    headerRule.BorderSizePixel = 0
    Instance.new("UICorner",headerRule).CornerRadius=UDim.new(1,0)
    headerRule.ZIndex = 20
    headerRule.Parent = splashGui
    local lowerTitle = splashText("INITIALIZING SYSTEM", UDim2.new(0, 18, 1, -147), 12,
        Color3.fromRGB(171, 221, 251), Enum.TextXAlignment.Center, 20)
    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "LoadingTrack"
    progressTrack.AnchorPoint = Vector2.new(0.5, 0)
    progressTrack.Position = UDim2.new(0.5, 0, 1, -74)
    progressTrack.Size = UDim2.new(0.78, 0, 0, 4)
    progressTrack.BackgroundColor3 = Color3.fromRGB(33, 65, 86)
    progressTrack.BorderSizePixel = 0
    progressTrack.ClipsDescendants = true
    progressTrack.ZIndex = 20
    progressTrack.Parent = splashGui
    Instance.new("UICorner", progressTrack).CornerRadius = UDim.new(1, 0)
    local progressConstraint = Instance.new("UISizeConstraint", progressTrack)
    progressConstraint.MaxSize = Vector2.new(340, 4)
    local progressFill = Instance.new("Frame")
    progressFill.Name = "Progress"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(68, 225, 255)
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 21
    progressFill.Parent = progressTrack
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    local progressGlow = Instance.new("UIStroke", progressFill)
    progressGlow.Color = Color3.fromRGB(120, 225, 255)
    progressGlow.Transparency = 0.3
    progressGlow.Thickness = 1
    TweenService2:Create(progressFill, TweenInfo.new(11.7, Enum.EasingStyle.Linear),
        {Size = UDim2.fromScale(1, 1)}):Play()

    local housing = Instance.new("Frame")
    housing.Size = UDim2.fromOffset(SCOPE_D + TUBE * 2, SCOPE_D + TUBE * 2)
    housing.Position = UDim2.new(0.5, -(SCOPE_D/2 + TUBE), 0.5, -(SCOPE_D/2 + TUBE))
    housing.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    housing.BorderSizePixel = 0
    housing.ZIndex = 2
    housing.Parent = splashGui
    Instance.new("UICorner", housing).CornerRadius = UDim.new(1, 0)
    local halo = Instance.new("Frame")
    halo.Name = "ScopePulse"
    halo.AnchorPoint = Vector2.new(0.5, 0.5)
    halo.Position = UDim2.fromScale(0.5, 0.5)
    halo.Size = UDim2.fromOffset(SCOPE_D + 64, SCOPE_D + 64)
    halo.BackgroundTransparency = 1
    halo.ZIndex = 3
    halo.Parent = splashGui
    Instance.new("UICorner", halo).CornerRadius = UDim.new(1, 0)
    local haloEdge = Instance.new("UIStroke", halo)
    haloEdge.Thickness = 2
    haloEdge.Color = Color3.fromRGB(79, 208, 255)
    haloEdge.Transparency = 0.45
    TweenService2:Create(haloEdge, TweenInfo.new(1.35, Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut, -1, true), {Transparency = 0.87, Thickness = 1}):Play()

    local bevel = Instance.new("Frame")
    bevel.Size = UDim2.fromOffset(SCOPE_D + 18, SCOPE_D + 18)
    bevel.Position = UDim2.new(0.5, -(SCOPE_D + 18)/2, 0.5, -(SCOPE_D + 18)/2)
    bevel.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
    bevel.BorderSizePixel = 0
    bevel.ZIndex = 3
    bevel.Parent = splashGui
    Instance.new("UICorner", bevel).CornerRadius = UDim.new(1, 0)
    do
        local s = Instance.new("UIStroke", bevel)
        s.Color = Color3.fromRGB(70, 70, 75)
        s.Thickness = 2.5
        s.Transparency = 0.25
    end

    local scopeClip = Instance.new("Frame")
    scopeClip.Name = "ScopeClip"
    scopeClip.Size = UDim2.fromOffset(SCOPE_D, SCOPE_D)
    scopeClip.Position = UDim2.new(0.5, -SCOPE_D/2, 0.5, -SCOPE_D/2)
    scopeClip.BackgroundColor3 = Color3.fromRGB(12, 16, 14)
    scopeClip.BorderSizePixel = 0
    scopeClip.ClipsDescendants = true
    scopeClip.ZIndex = 4
    scopeClip.Parent = splashGui
    Instance.new("UICorner", scopeClip).CornerRadius = UDim.new(1, 0)

    local glass = Instance.new("Frame")
    glass.Size = UDim2.fromScale(1, 1)
    glass.BackgroundColor3 = Color3.fromRGB(25, 55, 30)
    glass.BackgroundTransparency = 0.88
    glass.BorderSizePixel = 0
    glass.ZIndex = 5
    glass.Parent = scopeClip
    Instance.new("UICorner", glass).CornerRadius = UDim.new(1, 0)

    local vig = Instance.new("Frame")
    vig.Size = UDim2.fromScale(1, 1)
    vig.BackgroundTransparency = 1
    vig.ZIndex = 6
    vig.Parent = scopeClip
    Instance.new("UICorner", vig).CornerRadius = UDim.new(1, 0)
    do
        local s = Instance.new("UIStroke", vig)
        s.Color = Color3.fromRGB(0, 0, 0)
        s.Thickness = 32
        s.Transparency = 0.12
    end

    local lip = Instance.new("Frame")
    lip.Size = UDim2.fromOffset(SCOPE_D + 4, SCOPE_D + 4)
    lip.Position = UDim2.new(0.5, -(SCOPE_D + 4)/2, 0.5, -(SCOPE_D + 4)/2)
    lip.BackgroundTransparency = 1
    lip.ZIndex = 7
    lip.Parent = splashGui
    Instance.new("UICorner", lip).CornerRadius = UDim.new(1, 0)
    do
        local s = Instance.new("UIStroke", lip)
        s.Color = Color3.fromRGB(110, 110, 115)
        s.Thickness = 2
        s.Transparency = 0.25
    end

    local target = Instance.new("Frame")
    target.Name = "Target"
    target.Size = UDim2.fromOffset(72, 72)
    target.AnchorPoint = Vector2.new(0.5, 0.5)
    target.Position = UDim2.new(0.5, 18, 0.5, -8)
    target.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    target.BorderSizePixel = 0
    target.ZIndex = 8
    target.Parent = scopeClip
    Instance.new("UICorner", target).CornerRadius = UDim.new(1, 0)
    do
        local s = Instance.new("UIStroke", target)
        s.Color = Color3.fromRGB(200, 60, 60)
        s.Thickness = 2
        s.Transparency = 0.3
    end

    local head = Instance.new("ImageLabel")
    head.Name = "Headshot"
    head.Size = UDim2.fromScale(1, 1)
    head.BackgroundTransparency = 1
    head.ScaleType = Enum.ScaleType.Crop
    head.ZIndex = 9
    head.Parent = target
    Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)
    pcall(function()
        head.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LP2.UserId) .. "&w=150&h=150"
    end)

    local nameTag = Instance.new("TextLabel")
    nameTag.Size = UDim2.fromOffset(100, 14)
    nameTag.AnchorPoint = Vector2.new(0.5, 0)
    nameTag.Position = UDim2.new(0.5, 0, 1, 4)
    nameTag.BackgroundTransparency = 1
    nameTag.Text = tostring(LP2.Name or "TARGET")
    nameTag.TextColor3 = Color3.fromRGB(255, 80, 80)
    nameTag.Font = Enum.Font.GothamBold
    nameTag.TextSize = 10
    nameTag.TextTransparency = 0.15
    nameTag.ZIndex = 10
    nameTag.Parent = target

    local function hair(w, h, x, y, color, z)
        local f = Instance.new("Frame")
        f.Size = UDim2.fromOffset(w, h)
        f.Position = UDim2.new(0.5, x, 0.5, y)
        f.BackgroundColor3 = color
        f.BorderSizePixel = 0
        f.ZIndex = z or 11
        f.Parent = scopeClip
        Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
        return f
    end
    local BLACK = Color3.fromRGB(8, 8, 8)
    local span = SCOPE_D * 0.46
    hair(span * 2, 2, -span, -1, BLACK, 11)
    hair(2, span * 2, -1, -span, BLACK, 11)
    local laserHorizontal = hair(26, 2, -13, -1, LASER, 12)
    local laserVertical = hair(2, 26, -1, -13, LASER, 12)
    Instance.new("UICorner",laserHorizontal).CornerRadius=UDim.new(1,0)
    Instance.new("UICorner",laserVertical).CornerRadius=UDim.new(1,0)
    local centerDot = Instance.new("Frame")
    centerDot.Size = UDim2.fromOffset(6, 6)
    centerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    centerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    centerDot.BackgroundColor3 = LASER
    centerDot.BorderSizePixel = 0
    centerDot.ZIndex = 13
    centerDot.Parent = scopeClip
    Instance.new("UICorner", centerDot).CornerRadius = UDim.new(1, 0)

    for i = 1, 4 do
        local y = 18 + i * 14
        local d = Instance.new("Frame")
        d.Size = UDim2.fromOffset(4, 4)
        d.Position = UDim2.new(0.5, -2, 0.5, y - 2)
        d.BackgroundColor3 = LASER
        d.BackgroundTransparency = 0.15
        d.BorderSizePixel = 0
        d.ZIndex = 12
        d.Parent = scopeClip
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    end

    local glare = Instance.new("Frame")
    glare.Size = UDim2.fromOffset(SCOPE_D * 0.65, 9)
    glare.AnchorPoint = Vector2.new(0.5, 0.5)
    glare.Position = UDim2.new(0.5, 0, 0.32, 0)
    glare.Rotation = -26
    glare.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glare.BackgroundTransparency = 0.93
    glare.BorderSizePixel = 0
    glare.ZIndex = 7
    glare.Parent = scopeClip
    Instance.new("UICorner", glare).CornerRadius = UDim.new(1, 0)

    local loadingLbl = Instance.new("TextLabel")
    loadingLbl.Size = UDim2.new(1, 0, 0, 16)
    loadingLbl.Position = UDim2.new(0, 0, 1, -113)
    loadingLbl.BackgroundTransparency = 1
    loadingLbl.Text = "ACQUIRING TARGET..."
    loadingLbl.TextColor3 = themeDim
    loadingLbl.Font = Enum.Font.GothamBold
    loadingLbl.TextSize = 12
    loadingLbl.ZIndex = 20
    loadingLbl.Parent = splashGui

    local tapHint = Instance.new("TextLabel")
    tapHint.Size = UDim2.new(1, 0, 0, 16)
    tapHint.Position = UDim2.new(0, 0, 1, -24)
    tapHint.BackgroundTransparency = 1
    tapHint.Text = "TAP ANYWHERE TO SKIP"
    tapHint.TextColor3 = themeDim
    tapHint.Font = Enum.Font.GothamMedium
    tapHint.TextSize = 10
    tapHint.TextTransparency = 0.3
    tapHint.ZIndex = 20
    tapHint.Parent = splashGui

    local skipZone = Instance.new("TextButton")
    skipZone.Size = UDim2.fromScale(1, 1)
    skipZone.BackgroundTransparency = 1
    skipZone.Text = ""
    skipZone.ZIndex = 19
    skipZone.Parent = splashGui

    local nxcLbl = Instance.new("TextLabel")
    nxcLbl.Size = UDim2.fromOffset(120, 28)
    nxcLbl.AnchorPoint = Vector2.new(0.5, 0.5)
    nxcLbl.Position = UDim2.new(0.5, -52, 0.5, 36)
    nxcLbl.BackgroundTransparency = 1
    nxcLbl.Text = "CALCIUM HUB"
    nxcLbl.TextColor3 = themeText
    nxcLbl.Font = Enum.Font.GothamBlack
    nxcLbl.TextSize = 15
    nxcLbl.TextTransparency = 1
    nxcLbl.TextStrokeTransparency = 0.3
    nxcLbl.ZIndex = 14
    nxcLbl.Parent = scopeClip
    local calcGrad = Instance.new("UIGradient", nxcLbl)
    calcGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, themeAccent),
        ColorSequenceKeypoint.new(0.5, themeText),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 210, 255)),
    })

    local sniperLbl = Instance.new("TextLabel")
    sniperLbl.Size = UDim2.fromOffset(80, 28)
    sniperLbl.AnchorPoint = Vector2.new(0.5, 0.5)
    sniperLbl.Position = UDim2.new(0.5, 56, 0.5, 36)
    sniperLbl.BackgroundTransparency = 1
    sniperLbl.Text = "SNIPER"
    sniperLbl.TextColor3 = themeText
    sniperLbl.Font = Enum.Font.GothamBlack
    sniperLbl.TextSize = 15
    sniperLbl.TextTransparency = 1
    sniperLbl.TextStrokeTransparency = 0.3
    sniperLbl.ZIndex = 14
    sniperLbl.Parent = scopeClip
    local sniperGrad = Instance.new("UIGradient", sniperLbl)
    sniperGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 210, 255)),
        ColorSequenceKeypoint.new(0.5, themeText),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 70, 120)),
    })

    local hitRing = Instance.new("Frame")
    hitRing.AnchorPoint = Vector2.new(0.5, 0.5)
    hitRing.Position = UDim2.new(0.5, 0, 0.5, 0)
    hitRing.Size = UDim2.fromOffset(20, 20)
    hitRing.BackgroundTransparency = 1
    hitRing.ZIndex = 15
    hitRing.Visible = false
    hitRing.Parent = scopeClip
    Instance.new("UICorner", hitRing).CornerRadius = UDim.new(1, 0)
    local hitStroke = Instance.new("UIStroke", hitRing)
    hitStroke.Color = LASER
    hitStroke.Thickness = 3
    hitStroke.Transparency = 0.2

    local introFinished = false
    local introCompleteEvent = Instance.new("BindableEvent")
    local introSound = nil

    local function stopIntroMusic()
        pcall(function()
            if introSound then
                introSound:Stop()
                introSound:Destroy()
                introSound = nil
            end
        end)
    end

    task.spawn(function()
        local url = "https://files.catbox.moe/8ch5qz.mp3"
        local cacheName = "NxcSniperIntro_v2.mp3"
        local function tryCustom(path)
            local asset = nil
            pcall(function() if getcustomasset then asset = getcustomasset(path) end end)
            if (not asset or asset == "") and syn and syn.getcustomasset then
                pcall(function() asset = syn.getcustomasset(path) end)
            end
            return asset
        end
        local assetId = nil
        pcall(function()
            if isfile and isfile(cacheName) then
                assetId = tryCustom(cacheName)
            end
        end)
        if not assetId then
            local content = nil
            pcall(function()
                local req = (syn and syn.request) or (http and http.request) or request or http_request
                if req then
                    local res = req({Url = url, Method = "GET"})
                    content = res and (res.Body or res.body)
                end
            end)
            if (not content or #content == 0) then
                pcall(function() content = game:HttpGet(url) end)
            end
            if content and #content > 0 then
                pcall(function() writefile(cacheName, content) end)
                task.wait(0.05)
                assetId = tryCustom(cacheName)
                if not assetId then
                    task.wait(0.12)
                    assetId = tryCustom(cacheName)
                end
            end
        end
        if introFinished then return end
        if assetId and type(assetId) == "string" and #assetId > 0 then
            pcall(function()
                introSound = Instance.new("Sound")
                introSound.Name = "NxcSniperIntroMusic"
                introSound.SoundId = assetId
                introSound.Volume = 1
                introSound.Looped = false
                introSound.PlaybackSpeed = 1
                local ok = pcall(function() introSound.Parent = SoundService2 end)
                if not ok then introSound.Parent = workspace end
                local t0 = tick()
                while introSound.Parent and not introSound.IsLoaded and (tick() - t0) < 2.5 do
                    task.wait(0.04)
                    if introFinished then return end
                end
                if not introFinished and introSound.Parent then
                    introSound.TimePosition = 0
                    introSound:Play()
                end
            end)
        end
    end)

    local INTRO_DURATION = 13.0
    local exitStarted = false
    local animConn = nil

    local function stopAnim()
        if animConn then pcall(function() animConn:Disconnect() end) animConn = nil end
    end

    local function playSfx(id, pitch, vol, delay)
        task.delay(delay or 0, function()
            if introFinished then return end
            local s = Instance.new("Sound")
            s.SoundId = id
            s.PlaybackSpeed = pitch or 1
            s.Volume = vol or 0.6
            s.Parent = SoundService2
            s:Play()
            Debris2:AddItem(s, 4)
        end)
    end

    local function finishIntro()
        if introFinished then return end
        introFinished = true
        stopAnim()
        stopIntroMusic()
        pcall(function() splashGui:Destroy() end)
        introCompleteEvent:Fire()
    end

    local function playExit()
        if exitStarted then return end
        exitStarted = true
        stopAnim()
        pcall(function()
            if introSound then
                TweenService2:Create(introSound, TweenInfo.new(0.4), {Volume = 0}):Play()
            end
        end)
        loadingLbl.Text = "CALCIUM HUB  /  READY"
        loadingLbl.TextColor3 = themeAccent
        lowerTitle.Text = "SYSTEM ONLINE"
        lowerTitle.TextColor3 = Color3.fromRGB(104, 244, 209)
        TweenService2:Create(progressFill, TweenInfo.new(0.18), {Size = UDim2.fromScale(1, 1)}):Play()
        local closeInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        for _, obj in ipairs({scopeClip, bevel, lip, housing}) do
            pcall(function()
                TweenService2:Create(obj, closeInfo, {
                    Size = UDim2.fromOffset(0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                }):Play()
            end)
        end
        TweenService2:Create(overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService2:Create(loadingLbl, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService2:Create(tapHint, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.delay(0.65, finishIntro)
    end

    skipZone.MouseButton1Click:Connect(function()
        if not introFinished then playExit() end
    end)

    task.spawn(function()
        loadingLbl.Text = "CALIBRATING SCOPE..."
        playSfx("rbxassetid://9113826540", 0.85, 0.25, 0)

        local tTrack = TweenService2:Create(target, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
        })
        tTrack:Play()

        local lastVisualFrame = 0
        animConn = RunService2.RenderStepped:Connect(function()
            if introFinished or exitStarted then return end
            local t = tick()
            if t - lastVisualFrame < (1 / 30) then return end
            lastVisualFrame = t
            scopeClip.Rotation = math.sin(t * 0.7) * 1.2
            local breath = 1 + math.sin(t * 1.1) * 0.008
            local d = SCOPE_D * breath
            if not exitStarted then
                scopeClip.Size = UDim2.fromOffset(d, d)
                scopeClip.Position = UDim2.new(0.5, -d/2, 0.5, -d/2)
            end
            calcGrad.Rotation = (t * 40) % 360
            sniperGrad.Rotation = (-t * 35) % 360
        end)

        task.wait(2.2)
        if introFinished then return end
        loadingLbl.Text = "TARGET LOCKED  /  " .. tostring(LP2.DisplayName or LP2.Name)
        lowerTitle.Text = "OPTICS LINKED"
        loadingLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
        pcall(function()
            local s = target:FindFirstChildOfClass("UIStroke")
            if s then
                TweenService2:Create(s, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 3, true), {
                    Thickness = 4,
                    Transparency = 0.05,
                }):Play()
            end
        end)

        task.wait(1.3)
        if introFinished then return end
        TweenService2:Create(nxcLbl, TweenInfo.new(0.6), {TextTransparency = 0.05}):Play()
        TweenService2:Create(sniperLbl, TweenInfo.new(0.6), {TextTransparency = 0.05}):Play()
        loadingLbl.Text = "SYNCING SYSTEM..."
        lowerTitle.Text = "SYNC  /  02"
        loadingLbl.TextColor3 = themeDim

        task.wait(2.0)
        if introFinished then return end
        loadingLbl.Text = "READY TO LAUNCH"
        lowerTitle.Text = "SYNC  /  03"
        loadingLbl.TextColor3 = Color3.fromRGB(120, 220, 140)

        task.wait(1.5)
        if introFinished then return end
        loadingLbl.Text = "CALCIUM HUB ONLINE"
        lowerTitle.Text = "CALCIUM HUB  /  READY"
        loadingLbl.TextColor3 = LASER
        playSfx("rbxassetid://9120383924", 1.1, 0.7, 0)
        playSfx("rbxassetid://4612414100", 1.8, 0.5, 0.05)

        local flash = Instance.new("Frame")
        flash.Size = UDim2.fromScale(1, 1)
        flash.BackgroundColor3 = Color3.fromRGB(255, 220, 180)
        flash.BackgroundTransparency = 0.35
        flash.BorderSizePixel = 0
        flash.ZIndex = 18
        flash.Parent = scopeClip
        Instance.new("UICorner", flash).CornerRadius = UDim.new(1, 0)
        TweenService2:Create(flash, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
        Debris2:AddItem(flash, 0.3)

        hitRing.Visible = true
        hitRing.Size = UDim2.fromOffset(16, 16)
        hitStroke.Transparency = 0
        TweenService2:Create(hitRing, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(100, 100),
        }):Play()
        TweenService2:Create(hitStroke, TweenInfo.new(0.45), {Transparency = 1}):Play()

        TweenService2:Create(head, TweenInfo.new(0.3), {ImageTransparency = 0.35}):Play()
        TweenService2:Create(target, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 20, 20)}):Play()
        nameTag.Text = "ELIMINATED"
        nameTag.TextColor3 = LASER

        for i = 1, 6 do
            if introFinished then break end
            local ox = (math.random() - 0.5) * 10
            local oy = (math.random() - 0.5) * 10
            scopeClip.Position = UDim2.new(0.5, -SCOPE_D/2 + ox, 0.5, -SCOPE_D/2 + oy)
            housing.Position = UDim2.new(0.5, -(SCOPE_D/2 + TUBE) + ox, 0.5, -(SCOPE_D/2 + TUBE) + oy)
            task.wait(0.03)
        end
        scopeClip.Position = UDim2.new(0.5, -SCOPE_D/2, 0.5, -SCOPE_D/2)

        task.wait(1.2)
        if introFinished then return end
        loadingLbl.Text = "CALCIUM HUB  /  ONLINE"
        loadingLbl.TextColor3 = themeAccent

        task.wait(2.0)
        if introFinished then return end
        playExit()
    end)

    task.delay(INTRO_DURATION + 1.5, function()
        if not introFinished then playExit() end
    end)

    return introCompleteEvent.Event
end

local cloneref = cloneref or function(object) return object end
local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService        = cloneref(game:GetService("RunService"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local HttpService       = cloneref(game:GetService("HttpService"))
local TweenService      = cloneref(game:GetService("TweenService"))
local player = Players.LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 1) or player:WaitForChild("PlayerGui")
local GUI
local _instanceRunning = true
local _keybindListener, _boxFocusedListener, _focusReleasedListener
local _characterListener, _targetWatcherListener, _feedbackAddedListener
local _feedbackListeners = {}

local function getExecutorName()
    local name = nil
    pcall(function()
        if type(identifyexecutor) == "function" then
            local ok, n = pcall(identifyexecutor)
            if ok and type(n) == "string" and n ~= "" then name = n end
        end
        if (not name or name == "") and type(getexecutorname) == "function" then
            local ok, n = pcall(getexecutorname)
            if ok and type(n) == "string" and n ~= "" then name = n end
        end
    end)
    if not name or name == "" then
        local env = (typeof(getgenv) == "function" and getgenv()) or _G
        if type(env) == "table" then
            if env.__FLUXUS or env.fluxus then name = "Fluxus"
            elseif env.__SOLARA or env.solara then name = "Solara"
            elseif env.__WAVE or env.wave then name = "Wave"
            elseif env.__DELTA or env.delta then name = "Delta"
            elseif env.__XENO or env.xeno then name = "Xeno"
            elseif env.__ARCEUS or env.arceus then name = "Arceus X"
            elseif env.__CODEIUM then name = "Codeium"
            elseif env.__VELOCITY then name = "Velocity"
            elseif env.__TRIGON then name = "Trigon"
            elseif env.__ATOM or env.atom then name = "Atom"
            elseif env.__HYDROXIDE then name = "Hydroxide"
            elseif env.__MACSWARE then name = "MacSware"
            end
        end
        if not name then
            if syn then name = "Synapse X"
            elseif secure_load or is_sirhurt_closure then name = "SirHurt"
            elseif KRNL_LOADED then name = "Krnl"
            elseif isElectron then name = "Electron"
            elseif fluxus then name = "Fluxus"
            end
        end
    end
    if not name or name == "" then name = "Unknown Executor" end
    return tostring(name)
end
local EXECUTOR_NAME = getExecutorName()

local _autoFarm
local _cachedBox        = nil
local _cachedBoxTime    = 0
local _cachedSubmitBtn  = nil
local _writingCodeBox   = false

local FRAME_HOOK = (RunService:IsClient() and (RunService.PreRender or RunService.PreSimulation)) or RunService.PreSimulation or RunService.Heartbeat
local _pendingCodeThisFrame = nil
local _frameFlushQueued = false

if getgenv and getgenv().StopAura then pcall(getgenv().StopAura) end

local Workspace = cloneref(game:GetService("Workspace"))
local _ragdollConnection = nil
local _ragdollCooldown = 0
function nxcForceUnragdoll()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        hum.PlatformStand = false
        hum.Sit = false
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end
function startAntiRagdollAlways()
    if _ragdollConnection then return end
    _ragdollConnection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local isRag = (state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown)
        if isRag then
            local now = tick()
            if now - _ragdollCooldown > 0.12 then
                _ragdollCooldown = now
                nxcForceUnragdoll()
            end
        end
    end)
end
startAntiRagdollAlways()
_characterListener = player.CharacterAdded:Connect(function()
    task.wait(0.2)
    startAntiRagdollAlways()
end)

local _autoBuyActive = false
local _autoBuyRange = 22
local _autoBuyPurchaseRemote = nil
local _autoBuyConveyorCache = {}
local _autoBuyBuyLoop = nil
local _autoBuyScanLoop = nil
local _autoBuyAnchorConn = nil
local _autoBuyLockedTarget = nil
local _autoBuyAnchorPos = nil
local BUY_INTERVAL = 0.06

function autoBuyResolveRemote()
    if _autoBuyPurchaseRemote and _autoBuyPurchaseRemote.Parent then return _autoBuyPurchaseRemote end
    pcall(function()
        local pkgs = ReplicatedStorage:FindFirstChild("Packages")
        local net = pkgs and pkgs:FindFirstChild("Net")
        if net then
            for _, v in ipairs(net:GetChildren()) do
                local nl = (v.Name or ""):lower()
                if nl:find("buy") or nl:find("purchase") or nl:find("acquire") then
                    _autoBuyPurchaseRemote = v
                    return
                end
            end
        end
    end)
    return _autoBuyPurchaseRemote
end
function autoBuyFirePurchase(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return end
    pcall(function()
        if fireproximityprompt then fireproximityprompt(prompt) end
    end)
    task.spawn(function()
        local remote = autoBuyResolveRemote()
        if remote then
            pcall(function()
                if remote:IsA("RemoteFunction") then
                    remote:InvokeServer(prompt.Parent)
                elseif remote:IsA("RemoteEvent") then
                    remote:FireServer(prompt.Parent)
                end
            end)
        end
    end)
end

function autoBuyScanConveyor()
    local results = {}
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return results end
    local origin = hrp.Position

    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(origin, _autoBuyRange + 8)
    end)
    if not ok or not parts then return results end

    for _, part in ipairs(parts) do
        if part and part.Parent then
            for _, d in ipairs(part:GetChildren()) do
                if d:IsA("ProximityPrompt") and d.Enabled then
                    local action = (d.ActionText or ""):lower()
                    if action:find("purchase") or action:find("buy") or action:find("comprar") then
                        local dist = (origin - part.Position).Magnitude
                        if dist <= _autoBuyRange then
                            table.insert(results, { prompt = d, part = part, dist = dist })
                        end
                    end
                elseif d:IsA("Attachment") then
                    for _, p in ipairs(d:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.Enabled then
                            local action = (p.ActionText or ""):lower()
                            if action:find("purchase") or action:find("buy") or action:find("comprar") then
                                local dist = (origin - part.Position).Magnitude
                                if dist <= _autoBuyRange then
                                    table.insert(results, { prompt = p, part = part, dist = dist })
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(results, function(a, b) return (a.dist or 0) < (b.dist or 0) end)
    return results
end
function autoBuyRefreshConveyor()
    local ok, found = pcall(autoBuyScanConveyor)
    if ok then _autoBuyConveyorCache = found end
end
function autoBuyAnchorCharacter()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp then return end
    if not _autoBuyAnchorPos then
        _autoBuyAnchorPos = hrp.Position
    end
    pcall(function()
        hrp.Anchored = true
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(_autoBuyAnchorPos) * (hrp.CFrame - hrp.CFrame.Position)
        if hum then
            hum.PlatformStand = false
            hum.Sit = false
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            if hum.UseJumpPower == false then
                hum.JumpHeight = 0
            end
        end
    end)
end
function autoBuyUnanchorCharacter()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    pcall(function()
        if hrp then hrp.Anchored = false end
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            if hum.UseJumpPower == false then
                hum.JumpHeight = 7.2
            end
        end
    end)
    _autoBuyAnchorPos = nil
end
function autoBuyUpdate()
    if not _autoBuyActive then
        _autoBuyLockedTarget = nil
        return
    end
    autoBuyAnchorCharacter()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, entry in ipairs(_autoBuyConveyorCache) do
        if entry.prompt and entry.prompt.Parent and entry.prompt.Enabled and entry.part and entry.part.Parent then
            local dist = (hrp.Position - entry.part.Position).Magnitude
            if dist <= _autoBuyRange then
                _autoBuyLockedTarget = entry
                autoBuyFirePurchase(entry.prompt)
            end
        end
    end
end
function autoBuyStart()
    if _autoBuyActive then return end
    _autoBuyActive = true
    _autoFarm = true
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then _autoBuyAnchorPos = hrp.Position end
    autoBuyAnchorCharacter()
    autoBuyRefreshConveyor()
    if not _autoBuyBuyLoop then
        _autoBuyBuyLoop = task.spawn(function()
            while _instanceRunning do
                task.wait(BUY_INTERVAL)
                if _autoBuyActive then pcall(autoBuyUpdate) end
            end
        end)
    end
    if not _autoBuyScanLoop then
        _autoBuyScanLoop = task.spawn(function()
            while _instanceRunning do
                task.wait(0.9)
                if _autoBuyActive then pcall(autoBuyRefreshConveyor) end
            end
        end)
    end
    if not _autoBuyAnchorConn then
        _autoBuyAnchorConn = RunService.Heartbeat:Connect(function()
            if _autoBuyActive then pcall(autoBuyAnchorCharacter) end
        end)
    end
end
function autoBuyStop()
    if not _autoBuyActive then return end
    _autoBuyActive = false
    _autoFarm = false
    _autoBuyLockedTarget = nil
    if _autoBuyAnchorConn then
        pcall(function() _autoBuyAnchorConn:Disconnect() end)
        _autoBuyAnchorConn = nil
    end
    autoBuyUnanchorCharacter()
end

local CONFIG_FILE = "nxc_code_sniper_auto_redeem_test_config.json"
local savedConfig = {
    codeSniper = true,
    autoSubmit = true,
    submitAfter = 1,
    retypeInvalid = false,
    riddleSolver = false,
    autoFarm = false,
    spamRedeem = true,
    kbCodeSniper = "F1",
    kbAutoSubmit = "F2",
    kbRiddleSolver = "F3",
    kbRetypeInvalid = "F4",
    kbAutoFarm = "F5",
    kbManualSubmit = "F6",
}
pcall(function()
    if type(isfile) == "function" and type(readfile) == "function"
    and isfile(CONFIG_FILE) then
        local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(decoded) == "table" then
            if type(decoded.codeSniper) == "boolean" then savedConfig.codeSniper = decoded.codeSniper end
            if type(decoded.autoSubmit) == "boolean" then savedConfig.autoSubmit = decoded.autoSubmit end
            if type(decoded.submitAfter) == "number" then savedConfig.submitAfter = math.max(1, math.floor(decoded.submitAfter)) end
            if type(decoded.retypeInvalid) == "boolean" then savedConfig.retypeInvalid = decoded.retypeInvalid end
            if type(decoded.riddleSolver) == "boolean" then savedConfig.riddleSolver = decoded.riddleSolver end
            if type(decoded.autoFarm) == "boolean" then savedConfig.autoFarm = decoded.autoFarm end
            if type(decoded.spamRedeem) == "boolean" then savedConfig.spamRedeem = decoded.spamRedeem end
            if type(decoded.kbCodeSniper) == "string" then savedConfig.kbCodeSniper = decoded.kbCodeSniper end
            if type(decoded.kbAutoSubmit) == "string" then savedConfig.kbAutoSubmit = decoded.kbAutoSubmit end
            if type(decoded.kbRiddleSolver) == "string" then savedConfig.kbRiddleSolver = decoded.kbRiddleSolver end
            if type(decoded.kbRetypeInvalid) == "string" then savedConfig.kbRetypeInvalid = decoded.kbRetypeInvalid end
            if type(decoded.kbAutoFarm) == "string" then savedConfig.kbAutoFarm = decoded.kbAutoFarm end
            if type(decoded.kbManualSubmit) == "string" then savedConfig.kbManualSubmit = decoded.kbManualSubmit end
            if decoded.kbCodeSniper == false or decoded.kbCodeSniper == "" then savedConfig.kbCodeSniper = nil end
            if decoded.kbAutoSubmit == false or decoded.kbAutoSubmit == "" then savedConfig.kbAutoSubmit = nil end
            if decoded.kbRiddleSolver == false or decoded.kbRiddleSolver == "" then savedConfig.kbRiddleSolver = nil end
            if decoded.kbRetypeInvalid == false or decoded.kbRetypeInvalid == "" then savedConfig.kbRetypeInvalid = nil end
            if decoded.kbAutoFarm == false or decoded.kbAutoFarm == "" then savedConfig.kbAutoFarm = nil end
            if decoded.kbManualSubmit == false or decoded.kbManualSubmit == "" then savedConfig.kbManualSubmit = nil end
        end
    end
end)

function saveConfig()
    if type(writefile) ~= "function" then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            codeSniper = savedConfig.codeSniper,
            autoSubmit = savedConfig.autoSubmit,
            submitAfter = savedConfig.submitAfter,
            retypeInvalid = savedConfig.retypeInvalid,
            riddleSolver = savedConfig.riddleSolver,
            autoFarm = savedConfig.autoFarm,
            spamRedeem = savedConfig.spamRedeem ~= false,
            kbCodeSniper = savedConfig.kbCodeSniper,
            kbAutoSubmit = savedConfig.kbAutoSubmit,
            kbRiddleSolver = savedConfig.kbRiddleSolver,
            kbRetypeInvalid = savedConfig.kbRetypeInvalid,
            kbAutoFarm = savedConfig.kbAutoFarm,
            kbManualSubmit = savedConfig.kbManualSubmit,
        }))
    end)
end

local _enabled              = (savedConfig.codeSniper ~= false)
local _seen                 = {}
local _focused              = nil
local _lastBox              = nil
local _autoAccept           = (savedConfig.autoSubmit ~= false)
local _submitAfter          = math.max(1, tonumber(savedConfig.submitAfter) or 1)
local _capturedParts        = {}
local _lastWatchedBox       = nil
local _boxTextConn          = nil
local _boxAncestryConn      = nil
local _retypeInvalid        = savedConfig.retypeInvalid
local _riddleSolver         = savedConfig.riddleSolver
_autoFarm                   = (savedConfig.autoFarm == true)
local _spamRedeem           = (savedConfig.spamRedeem ~= false)
task.defer(function()
    if _autoFarm then pcall(autoBuyStart) end
end)
local _lastNonBlankBoxText  = ""
local _pendingRejectedText  = nil
local _pendingRejectedBox   = nil
local _pendingRejectedUntil = 0
local _pendingRejectedToken = 0

local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns    = getconnections or (debug and debug.getconnections)
local setupv      = (debug and debug.setupvalue) or setupvalue

local setStatus, flashCode, appendToBox
local rememberPendingSubmission, clearPendingSubmission, handleRedemptionFeedback
local clearNxcCapture
local _lastStatusMsg = nil

function isOurGui(instance)
    local p = instance
    for _ = 1, 10 do
        if not p then break end
        if p.Name == "NxcCodeSniperUI" or p.Name == "SourcesHubRedeemerGui" then return true end
        p = p.Parent
    end
    return false
end

function isVisibleChain(inst)
    local current = inst
    while current do
        if current:IsA("GuiObject") and not current.Visible then return false end
        if current:IsA("ScreenGui") then return current.Enabled end
        current = current.Parent
    end
    return true
end

local RedeemSpeedUI = { label = nil, set = nil }
local _SetClip = (typeof(setclipboard) == "function") and setclipboard
              or (typeof(toclipboard) == "function") and toclipboard
              or (syn and syn.write_clipboard) or nil
local _FireSignal = (typeof(firesignal) == "function") and firesignal or nil
local _FireClick = (typeof(fireclick) == "function") and fireclick or nil
local _GetConns = (typeof(getconnections) == "function") and getconnections
               or (typeof(getconns) == "function") and getconns
               or (debug and debug.getconnections) or nil

local _fastTargets = {}
local _fastTargetKey = nil
local _primaryTarget = nil
local _lastLinkScan = -1e9
local _linkDirty = true
local _linkScanQueued = false
local _lastSubmitCode = nil
local _lastSubmitAt = -1e9
local _lastLinkDescription = "SEARCHING"

local function linkInfo()
    if not _primaryTarget or not _primaryTarget.box or not _primaryTarget.box.Parent then
        return "NO CODEBOX"
    end
    if _primaryTarget.btn and _primaryTarget.btn.Parent then
        return "CODEBOX + SUBMIT LINKED"
    end
    return "CODEBOX LINKED / BUTTON NOT FOUND"
end

local function externalGui(inst)
    if not inst or not inst.Parent then return false end
    if isOurGui(inst) then return false end
    if GUI and inst:IsDescendantOf(GUI) then return false end
    return inst:IsDescendantOf(playerGui)
end

local function codeScore(box)
    local score = 0
    local name = string.lower(box.Name or "")
    local placeholder = string.lower(box.PlaceholderText or "")
    local parent = box.Parent
    local pn = parent and string.lower(parent.Name or "") or ""
    local root = box:FindFirstAncestor("Codes")
    if root then score += 90 end
    if name == "codebox" or name == "codeinput" or name == "code" then score += 90 end
    if name:find("code",1,true) or name:find("redeem",1,true) then score += 45 end
    if name:find("input",1,true) or name:find("promo",1,true) then score += 22 end
    if pn:find("code",1,true) or pn:find("redeem",1,true) then score += 36 end
    if placeholder:find("code",1,true) or placeholder:find("redeem",1,true) then score += 45 end
    if box.Visible then score += 4 end
    if box.TextEditable then score += 1 end
    return score
end

local function buttonScore(btn, box)
    if not btn or not btn.Parent then return -1e9 end
    local name = string.lower(btn.Name or "")
    local bt = ""
    pcall(function() bt = string.lower(btn.Text or "") end)
    local score = 0
    if name:find("redeem",1,true) or name:find("submit",1,true) then score += 100 end
    if bt:find("redeem",1,true) or bt:find("submit",1,true) then score += 110 end
    if name:find("claim",1,true) or bt:find("claim",1,true) then score += 35 end
    if name:find("enter",1,true) or bt:find("enter",1,true) then score += 20 end
    if btn.Parent == box.Parent then score += 70 end
    if btn:FindFirstAncestor("Codes") and box:FindFirstAncestor("Codes") then score += 45 end
    if btn.Visible then score += 2 end
    return score
end

local function getConnections(signal)
    if not _GetConns then return nil end
    local ok, list = pcall(_GetConns, signal)
    if ok and type(list) == "table" then return list end
    return nil
end

local function hasConnection(list)
    if not list then return false end
    for _, connection in ipairs(list) do
        if connection.Enabled ~= false then return true end
    end
    return false
end

local function invokeSignal(signal, args, cachedConnections)
    if _FireSignal then
        local ok = pcall(_FireSignal, signal, table.unpack(args or {}))
        if ok then return true end
    end
    local cons = cachedConnections or getConnections(signal)
    if cons then
        for _, c in ipairs(cons) do
            if c.Enabled ~= false then
                local ok = pcall(function()
                    if c.Fire then c:Fire(table.unpack(args or {}))
                    elseif type(c.Function) == "function" then c.Function(table.unpack(args or {}))
                    else error("no signal function") end
                end)
                if ok then return true end
            end
        end
    end
    return false
end

local function makeTarget(box, btn)
    local t = {box=box, btn=btn}
    t.alive = function()
        return externalGui(box) and (not t.btn or externalGui(t.btn))
    end
    t.setText = function(code)
        local ok = pcall(function() box.Text = code end)
        return ok and box.Text == code
    end
    t.focusConns = getConnections(box.FocusLost)
    if btn then
        t.activateConns = getConnections(btn.Activated)
        t.clickConns = getConnections(btn.MouseButton1Click)
    end
    t.submit = function()
        if btn and not hasConnection(t.activateConns) and not hasConnection(t.clickConns) then
            t.activateConns = getConnections(btn.Activated)
            t.clickConns = getConnections(btn.MouseButton1Click)
        end
        if not hasConnection(t.focusConns) then
            t.focusConns = getConnections(box.FocusLost)
        end
        if btn and externalGui(btn) then
            local signal, cons
            if hasConnection(t.activateConns) then
                signal, cons = btn.Activated, t.activateConns
            elseif hasConnection(t.clickConns) then
                signal, cons = btn.MouseButton1Click, t.clickConns
            else
                signal, cons = btn.MouseButton1Click, t.clickConns
            end
            if invokeSignal(signal, {}, cons) then return true, "button" end
            if _FireClick and pcall(_FireClick, btn) then return true, "click" end
            if pcall(function() btn:Activate() end) then return true, "activate" end
        end
        if hasConnection(t.focusConns) or _FireSignal then
            local focused = false
            pcall(function() focused = box:IsFocused() end)
            if focused and pcall(function() box:ReleaseFocus(true) end) then
                return true, "focus"
            end
            if invokeSignal(box.FocusLost, {true}, t.focusConns) then
                return true, "focus"
            end
        end
        return false, "no working submit handler"
    end
    return t
end

local function resolveCodeTarget()
    local roots = {}
    local explicit = playerGui:FindFirstChild("Codes")
    if explicit then
        roots[#roots+1] = {root=explicit, priority=300}
    end
    for _, child in ipairs(playerGui:GetChildren()) do
        if child:IsA("ScreenGui") and child ~= explicit and child.Enabled and not isOurGui(child) then
            roots[#roots+1] = {root=child, priority=0}
        end
    end
    local bestBox, bestButton, bestScore = nil, nil, -1e9
    for _, entry in ipairs(roots) do
        local boxes, buttons = {}, {}
        for _, d in ipairs(entry.root:GetDescendants()) do
            if externalGui(d) then
                if d:IsA("TextBox") then boxes[#boxes+1] = d end
                if d:IsA("TextButton") or d:IsA("ImageButton") then
                    buttons[#buttons+1] = d
                end
            end
        end
        for _, box in ipairs(boxes) do
            local score = codeScore(box) + entry.priority
            if score >= 30 then
                local btn, btnScore = nil, -1e9
                for _, candidate in ipairs(buttons) do
                    local candidateScore = buttonScore(candidate, box)
                    if candidateScore > btnScore then
                        btn, btnScore = candidate, candidateScore
                    end
                end
                if btnScore < 65 then btn = nil end
                local pairScore = score + (btn and 30 or 0)
                if pairScore > bestScore then
                    bestBox, bestButton, bestScore = box, btn, pairScore
                end
            end
        end
    end
    if not bestBox then return nil end
    return makeTarget(bestBox, bestButton)
end

local function refreshFastTargets(force)
    if not _instanceRunning then return end
    local now = os.clock()
    if not force and not _linkDirty and _primaryTarget and _primaryTarget.alive() and _primaryTarget.btn then return end
    if not force and now - _lastLinkScan < 0.07 then return end
    _lastLinkScan = now
    local target = resolveCodeTarget()
    _primaryTarget = target
    _fastTargets = target and {target} or {}
    _fastTargetKey = target and tostring(target.box) .. ":" .. tostring(target.btn) or ""
    _linkDirty = false
    _cachedBox = target and target.box or nil
    _cachedSubmitBtn = target and target.btn or nil
    _cachedBoxTime = now
    local desc = linkInfo()
    if desc ~= _lastLinkDescription then
        _lastLinkDescription = desc
        pcall(function()
            if setStatus then setStatus("Codebox: " .. desc) end
        end)
    end
end

local function scheduleRelink()
    _linkDirty = true
    if _linkScanQueued then return end
    _linkScanQueued = true
    task.defer(function()
        _linkScanQueued = false
        if _instanceRunning then refreshFastTargets(false) end
    end)
end

_targetWatcherListener = playerGui.DescendantAdded:Connect(function(d)
    if d:IsA("TextBox") or d:IsA("TextButton") or d:IsA("ImageButton") then
        scheduleRelink()
    end
end)
local _codeboxRemovedListener = playerGui.DescendantRemoving:Connect(function(d)
    if _primaryTarget and (d == _primaryTarget.box or d == _primaryTarget.btn) then
        _primaryTarget = nil
        _cachedBox, _cachedSubmitBtn = nil, nil
        scheduleRelink()
    end
end)

local _codeboxAutoLinkConn
local _codeboxAutoLinkElapsed = 0
_codeboxAutoLinkConn = RunService.Heartbeat:Connect(function(dt)
    if not _instanceRunning then
        if _codeboxAutoLinkConn then _codeboxAutoLinkConn:Disconnect() end
        return
    end
    _codeboxAutoLinkElapsed += math.min(dt, 0.25)
    if _codeboxAutoLinkElapsed < 1.25 then return end
    _codeboxAutoLinkElapsed = 0
    if not _primaryTarget or not _primaryTarget.alive()
        or not _primaryTarget.btn or _linkDirty then
        refreshFastTargets(false)
    end
end)

function findAllTextBoxes()
    local t = _primaryTarget
    if t and t.alive() then return {t.box} end
    refreshFastTargets(true)
    t = _primaryTarget
    return t and t.alive() and {t.box} or {}
end

function findCodeButtons()
    local t = _primaryTarget
    if t and t.alive() and t.btn then return {t.btn} end
    refreshFastTargets(true)
    t = _primaryTarget
    return t and t.alive() and t.btn and {t.btn} or {}
end

function clickButton(btn)
    if not btn then return false end
    local a = getConnections(btn.Activated)
    local c = getConnections(btn.MouseButton1Click)
    if hasConnection(a) then return invokeSignal(btn.Activated, {}, a) end
    if invokeSignal(btn.MouseButton1Click, {}, c) then return true end
    if _FireClick and pcall(_FireClick, btn) then return true end
    return pcall(function() btn:Activate() end)
end

function fireBoxFocusLost(box)
    if not box then return false end
    local focused = false
    pcall(function() focused = box:IsFocused() end)
    if focused and pcall(function() box:ReleaseFocus(true) end) then return true end
    return invokeSignal(box.FocusLost, {true})
end

function ultraFastSubmit(code, force)
    local start = os.clock()
    code = tostring(code or ""):match("^%s*(.-)%s*$") or ""
    if code == "" then return false, "empty code", 0 end
    if not _instanceRunning then return false, "engine stopped", 0 end

    if (not force) and code == _lastSubmitCode and start - _lastSubmitAt < 0.12 then
        return true, "already submitted", (os.clock() - start) * 1000
    end
    local t = _primaryTarget
    if not t or not t.alive() or _linkDirty then
        refreshFastTargets(true)
        t = _primaryTarget
    end
    if not t or not t.alive() then
        return false, "codebox not connected", (os.clock() - start) * 1000
    end
    if not t.setText(code) then
        scheduleRelink()
        return false, "could not write codebox", (os.clock() - start) * 1000
    end
    _lastBox = t.box
    _lastNonBlankBoxText = code
    local dispatched, method = t.submit()
    if not dispatched then
        return false, method, (os.clock() - start) * 1000
    end
    _lastSubmitCode, _lastSubmitAt = code, os.clock()
    return true, "submitted via " .. tostring(method), (os.clock() - start) * 1000
end

function timedSubmit(code)
    return ultraFastSubmit(code)
end

function nxcCodeBox()
    local t = _primaryTarget
    if t and t.alive() then return t.box end
    refreshFastTargets(true)
    t = _primaryTarget
    return t and t.alive() and t.box or nil
end

_boxFocusedListener = UserInputService.TextBoxFocused:Connect(function(box)
    if GUI and box:IsDescendantOf(GUI) then return end
    if not externalGui(box) then return end
    if box:IsA("TextBox") and (codeScore(box) >= 30) then
        if not _primaryTarget or _primaryTarget.box ~= box then
            _cachedBox = box
            _cachedBoxTime = os.clock()
            scheduleRelink()
        end
        _focused = box
        _lastBox = box
        if watchBoxForBlankReset then watchBoxForBlankReset(box) end
    end
end)

task.defer(function()
    refreshFastTargets(true)
end)

local COLORS = {
    Window = Color3.fromRGB(12, 13, 18),
    Row = Color3.fromRGB(18, 20, 28),
    Control = Color3.fromRGB(26, 28, 36),
    Log = Color3.fromRGB(8, 9, 12),
    Border = Color3.fromRGB(48, 54, 68),
    White = Color3.fromRGB(245, 248, 255),
    Text = Color3.fromRGB(220, 228, 242),
    Dim = Color3.fromRGB(150, 165, 190),
    Accent = Color3.fromRGB(110, 180, 255),
    Green = Color3.fromRGB(80, 220, 130),
    Red = Color3.fromRGB(255, 75, 85),
    Gold = Color3.fromRGB(255, 205, 90),
    Pink = Color3.fromRGB(255, 130, 200),
}

function addCorner(parent, radius)
    local value = Instance.new("UICorner")
    value.CornerRadius = UDim.new(0, radius)
    value.Parent = parent
    return value
end

function addStroke(parent, color, thickness, transparency)
    local value = Instance.new("UIStroke")
    value.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    value.Color = color
    value.Thickness = thickness or 1
    value.Transparency = transparency or 0
    value.Parent = parent
    return value
end

function makeLabel(parent, name, text, size, position, textSize, color, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextSize = textSize
    label.TextColor3 = color
    label.Font = font or Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.55
    label.Parent = parent
    return label
end

pcall(function()
    for _, name in ipairs({"NxcCodeSniperUI", "AutoTypeCodesUI", "NxcPaste"}) do
        local previous = game.CoreGui:FindFirstChild(name)
        if previous then previous:Destroy() end
    end
end)
for _, name in ipairs({"NxcCodeSniperUI", "AutoTypeCodesUI", "NxcPaste"}) do
    local previous = playerGui:FindFirstChild(name)
    if previous then previous:Destroy() end
end

GUI = Instance.new("ScreenGui")
GUI.Name = "NxcCodeSniperUI"
GUI.Enabled = false
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() GUI.Parent = playerGui end) or GUI.Parent ~= playerGui then
    if not pcall(function() GUI.Parent = game.CoreGui end) then
        pcall(function() if gethui then GUI.Parent = gethui() end end)
    end
end

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(310, 620)
Window.AnchorPoint = Vector2.new(1, 0)
Window.Position = UDim2.new(1, -8, 0, 8)
Window.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
Window.BackgroundTransparency = 1
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Visible = false
Window.Parent = GUI
addCorner(Window, 14)

Window.BackgroundTransparency = 1
do
    local bgImg = Instance.new("ImageLabel")
    bgImg.Name = "BgImage"
    bgImg.Size = UDim2.fromScale(1, 1)
    bgImg.Position = UDim2.fromScale(0, 0)
    bgImg.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
    bgImg.BackgroundTransparency = 0
    bgImg.Image = "rbxassetid://129085053275432"
    bgImg.ScaleType = Enum.ScaleType.Crop
    bgImg.ImageTransparency = 0.15
    bgImg.ZIndex = 1
    bgImg.Parent = Window
    addCorner(bgImg, 14)

    local dim = Instance.new("Frame")
    dim.Name = "BgDim"
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.fromRGB(4, 6, 10)
    dim.BackgroundTransparency = 0.42
    dim.BorderSizePixel = 0
    dim.ZIndex = 2
    dim.Parent = Window
    addCorner(dim, 14)
end

local WindowStrokeRef = addStroke(Window, Color3.fromRGB(50, 110, 255), 1.4, 0.5)

do
    local pop = Instance.new("UIScale")
    pop.Name = "OpenPop"
    pop.Scale = 0.88
    pop.Parent = Window
    task.spawn(function()
        pcall(function()
            TweenService:Create(pop, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end)
        task.delay(0.35, function()
            if pop and pop.Parent then pop:Destroy() end
        end)
    end)
end

_G.NxcPulseRefs = _G.NxcPulseRefs or {
    windowStroke  = nil,
    headerAccent  = nil,
    execDot       = nil,
    consoleStroke = nil,
    consolePulse  = nil,
    manualSubmit  = nil,
    miniAvatar    = nil,
    ogBtn         = nil,
    ogDot         = nil,
    mainStars     = nil,
    ogStars       = nil,
    miniStars     = nil,
}

do
    local pulseRefs = _G.NxcPulseRefs
    pulseRefs.windowStroke = WindowStrokeRef

    local _accum = 0
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        _accum = _accum + dt
        if _accum < 0.033 then return end
        local dtEff = _accum
        _accum = 0

        local refs = _G.NxcPulseRefs
        if not refs or not GUI or not GUI.Parent then
            if conn then conn:Disconnect() end
            return
        end
        if not Window or not Window.Visible then return end 

        local t = tick()

        local ws = refs.windowStroke
        if ws and ws.Parent then
            local p = math.sin(t * 1.4) * 0.5 + 0.5
            ws.Transparency = 0.4 + p * 0.25
            ws.Thickness    = 1.2 + p * 0.4
        end

        local ha = refs.headerAccent
        if ha and ha.Parent then
            local p = math.sin(t * 2.2) * 0.5 + 0.5
            ha.BackgroundTransparency = 0.35 + p * 0.4
        end

        local ed = refs.execDot
        if ed and ed.Parent then
            local p = math.sin(t * 3.0) * 0.5 + 0.5
            ed.BackgroundTransparency = 0.05 + p * 0.5
            ed.BackgroundColor3 = Color3.fromRGB(
                math.floor(70 + p * 40),
                math.floor(200 + p * 40),
                math.floor(120 + p * 30)
            )
        end

        local cs = refs.consoleStroke
        if cs and cs.Parent then
            local p = math.sin(t * 1.4) * 0.5 + 0.5
            cs.Transparency = 0.4 + p * 0.35
        end

        local cp = refs.consolePulse
        if cp and cp.Parent then
            local p = math.sin(t * 3.2) * 0.5 + 0.5
            cp.TextTransparency = 0.05 + p * 0.55
            cp.TextStrokeTransparency = 0.35 + p * 0.45
            cp.TextColor3 = Color3.fromRGB(
                math.floor(100 + p * 40),
                math.floor(180 + p * 40),
                255
            )
        end

        local ms = refs.manualSubmit
        if ms and ms.Parent then
            local p = math.sin(t * 2.4) * 0.5 + 0.5
            ms.BackgroundColor3 = Color3.fromRGB(
                math.floor(30 + p * 25),
                math.floor(70 + p * 40),
                math.floor(140 + p * 50)
            )
        end

        local ma = refs.miniAvatar
        if ma and ma.Parent then
            local p = math.sin(t * 2.6) * 0.5 + 0.5
            ma.Transparency = 0.15 + p * 0.45
            ma.Color = COLORS.Accent
        end

        local ob = refs.ogBtn
        if ob and ob.Parent then
            local p = math.sin(t * 2.4) * 0.5 + 0.5
            ob.Transparency = 0.35 + p * 0.4
        end

        local od = refs.ogDot
        if od and od.Parent then
            local isOpen = getgenv and getgenv().NxcOGSniperGui and getgenv().NxcOGSniperGui.Parent
            od.BackgroundColor3 = isOpen and COLORS.Green or COLORS.Dim
        end

        local msLayer = refs.mainStars
        if msLayer and msLayer.layer and msLayer.layer.Parent and Window and Window.Parent and Window.Visible then
            local h = math.max(1, Window.AbsoluteSize.Y)
            local w = math.max(1, Window.AbsoluteSize.X)
            for _, s in ipairs(msLayer.pool) do
                local fr = s.frame
                if fr and fr.Parent then
                    local x = fr.Position.X.Offset + s.drift * dtEff
                    local y = fr.Position.Y.Offset + s.speed * dtEff
                    if y > h + 8 then
                        y = -6 - math.random() * 20
                        x = math.random() * w
                        s.speed = 12 + math.random() * 38
                        s.drift = (math.random() - 0.5) * 18
                    end
                    if x < -8 then x = w + 2 end
                    if x > w + 8 then x = -2 end
                    fr.Position = UDim2.fromOffset(x, y)
                    s.twinkle = s.twinkle + dtEff * s.twSpeed
                    fr.BackgroundTransparency = 0.12 + (math.sin(s.twinkle) * 0.5 + 0.5) * 0.6
                end
            end
        end

        local mnLayer = refs.miniStars
        if mnLayer and mnLayer.layer and mnLayer.layer.Parent and MiniView and MiniView.Visible then
            local h = math.max(1, MiniView.AbsoluteSize.Y)
            local w = math.max(1, MiniView.AbsoluteSize.X)
            for _, s in ipairs(mnLayer.pool) do
                local fr = s.frame
                if fr and fr.Parent then
                    local x = fr.Position.X.Offset + s.drift * dtEff
                    local y = fr.Position.Y.Offset + s.speed * dtEff
                    if y > h + 6 then
                        y = -4 - math.random() * 10
                        x = math.random() * w
                        s.speed = 18 + math.random() * 42
                        s.drift = (math.random() - 0.5) * 12
                    end
                    if x < -6 then x = w + 2 end
                    if x > w + 6 then x = -2 end
                    fr.Position = UDim2.fromOffset(x, y)
                    s.twinkle = s.twinkle + dtEff * 3
                    fr.BackgroundTransparency = 0.2 + (math.sin(s.twinkle) * 0.5 + 0.5) * 0.55
                end
            end
        end

        local ogLayer = refs.ogStars
        if ogLayer and ogLayer.layer and ogLayer.layer.Parent and ogLayer.frame and ogLayer.frame.Parent and ogLayer.frame.Visible then
            local h = math.max(1, ogLayer.frame.AbsoluteSize.Y)
            local w = math.max(1, ogLayer.frame.AbsoluteSize.X)
            for _, s in ipairs(ogLayer.pool) do
                local fr = s.frame
                if fr and fr.Parent then
                    local x = fr.Position.X.Offset + s.drift * dtEff
                    local y = fr.Position.Y.Offset + s.speed * dtEff
                    if y > h + 8 then
                        y = -6 - math.random() * 20
                        x = math.random() * w
                        s.speed = 12 + math.random() * 38
                        s.drift = (math.random() - 0.5) * 18
                    end
                    if x < -8 then x = w + 2 end
                    if x > w + 8 then x = -2 end
                    fr.Position = UDim2.fromOffset(x, y)
                    s.twinkle = s.twinkle + dtEff * s.twSpeed
                    fr.BackgroundTransparency = 0.12 + (math.sin(s.twinkle) * 0.5 + 0.5) * 0.6
                end
            end
        end
    end)
end

do
    local MainStarLayer = Instance.new("Frame")
    MainStarLayer.Name = "MainStarLayer"
    MainStarLayer.Size = UDim2.new(1, 0, 1, 0)
    MainStarLayer.BackgroundTransparency = 1
    MainStarLayer.ZIndex = 2
    MainStarLayer.ClipsDescendants = true
    MainStarLayer.Active = false
    MainStarLayer.Parent = Window

    local pool = {}
    local STAR_COUNT = 16
    for i = 1, STAR_COUNT do
        local star = Instance.new("Frame")
        star.Name = "FxStar" .. i
        star.BorderSizePixel = 0
        local sz = (i % 4 == 0) and (3 + math.random(0, 2)) or (1 + math.random(0, 2))
        star.Size = UDim2.fromOffset(sz, sz)
        star.BackgroundColor3 = (i % 5 == 0)
            and Color3.fromRGB(255, 210, 140)
            or Color3.fromRGB(160 + math.random(0, 40), 200 + math.random(0, 40), 255)
        star.BackgroundTransparency = 0.15 + math.random() * 0.5
        star.Position = UDim2.fromOffset(math.random(0, 290), math.random(-20, 480))
        star.ZIndex = 2
        star.Parent = MainStarLayer
        addCorner(star, 8)
        pool[i] = {
            frame = star,
            speed = 12 + math.random() * 38,
            drift = (math.random() - 0.5) * 18,
            twinkle = math.random() * math.pi * 2,
            twSpeed = 2 + math.random() * 3,
        }
    end

    _G.NxcPulseRefs.mainStars = {
        layer = MainStarLayer,
        pool = pool,
    }
end

local WindowScrim = Instance.new("Frame")
WindowScrim.Name = "ReadabilityScrim"
WindowScrim.Size = UDim2.new(1, 0, 1, 0)
WindowScrim.BackgroundColor3 = Color3.fromRGB(6, 10, 18)
WindowScrim.BackgroundTransparency = 0.72
WindowScrim.BorderSizePixel = 0
WindowScrim.ZIndex = 2
WindowScrim.Parent = Window
addCorner(WindowScrim, 14)

local InterfaceScale = Instance.new("UIScale")
InterfaceScale.Name = "InterfaceScale"
InterfaceScale.Scale = 0.92
InterfaceScale.Parent = Window

local viewportConnection
function updateInterfaceScale()
    local camera = workspace.CurrentCamera
    local viewport = (camera and camera.ViewportSize) or Vector2.new(1280, 720)
    local baseW, baseH = 300, 560
    local fit = math.min((viewport.X - 20) / baseW, (viewport.Y - 24) / baseH)
    local touch = UserInputService.TouchEnabled
    local gamepad = UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled
    local scale
    if touch then
        if viewport.X <= 500 then
            scale = math.clamp(fit * 0.98, 0.55, 0.82)
        elseif viewport.X <= 900 then
            scale = math.clamp(fit * 0.95, 0.62, 0.88)
        else
            scale = math.clamp(fit * 0.92, 0.7, 0.95)
        end
    elseif gamepad then
        scale = math.clamp(fit * 0.9, 0.75, 1)
    else
        scale = math.clamp(math.min(fit, 1.05), 0.85, 1.08)
    end
    InterfaceScale.Scale = scale
end

function watchViewport()
    if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
    local camera = workspace.CurrentCamera
    if camera then viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateInterfaceScale) end
    updateInterfaceScale()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchViewport)
watchViewport()

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Header.BackgroundTransparency = 0.35
Header.BorderSizePixel = 0
Header.Active = true
Header.ZIndex = 5
Header.Parent = Window
addCorner(Header, 12)
do
    local hs = Instance.new("UIStroke")
    hs.Color = COLORS.Accent
    hs.Thickness = 1
    hs.Transparency = 0.75
    hs.Parent = Header
end

local Console, ConsoleOutput, updateConsoleCanvas
local featureStates = {}
local CONSOLE_COLORS = {
    Dim = "rgb(150,170,200)",
    Amber = "rgb(120,200,255)",
    Green = "rgb(80,230,160)",
    Red = "rgb(255,100,120)",
    Cyan = "rgb(140,220,255)",
    Gold = "rgb(255,210,110)",
    Magenta = "rgb(220,140,255)",
    Tag = "rgb(90,120,160)",
}

function scrollConsoleToBottom()
    task.defer(function()
        task.wait()
        if not Console then return end
        if updateConsoleCanvas then updateConsoleCanvas() end
        local canvasY = Console.AbsoluteCanvasSize.Y
        local windowY = Console.AbsoluteWindowSize.Y
        local bottom = math.max(0, canvasY - windowY)
        local nearBottom = (Console.CanvasPosition.Y >= bottom - 40) or bottom <= 0
        if nearBottom then
            Console.CanvasPosition = Vector2.new(0, bottom)
        end
    end)
end

function appendConsoleStatus(name, activated)
    if not ConsoleOutput then return end
    local state = activated and "ON" or "OFF"
    local stateColor = activated and CONSOLE_COLORS.Green or CONSOLE_COLORS.Red
    local t = os.date("*t")
    local ts = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
    local line = table.concat({
        '<font color="', CONSOLE_COLORS.Tag, '">', ts, '</font> ',
        '<font color="', CONSOLE_COLORS.Cyan, '">[CFG]</font> ',
        '<font color="', CONSOLE_COLORS.Amber, '">', tostring(name), '</font> ',
        '<font color="', CONSOLE_COLORS.Dim, '">→</font> ',
        '<font color="', stateColor, '">', state, '</font>',
    })
    if ConsoleOutput.Text == "" then ConsoleOutput.Text = line
    else ConsoleOutput.Text = ConsoleOutput.Text .. "\n" .. line end
    scrollConsoleToBottom()
end

makeLabel(Header, "Title", "CALCIUM HUB", UDim2.fromOffset(150, 18), UDim2.fromOffset(16, 6), 16, COLORS.White, Enum.Font.GothamBlack)
makeLabel(Header, "Subtitle", "CODE SNIPER", UDim2.fromOffset(120, 12), UDim2.fromOffset(16, 24), 11, COLORS.Accent, Enum.Font.GothamBold)

local ExecPulseDot = Instance.new("Frame")
ExecPulseDot.Name = "ExecPulseDot"
ExecPulseDot.Size = UDim2.fromOffset(6, 6)
ExecPulseDot.Position = UDim2.fromOffset(16, 45)
ExecPulseDot.BackgroundColor3 = COLORS.Green
ExecPulseDot.BorderSizePixel = 0
ExecPulseDot.ZIndex = 6
ExecPulseDot.Parent = Header
addCorner(ExecPulseDot, 3)
_G.NxcPulseRefs.execDot = ExecPulseDot

local ExecNameLabel = makeLabel(Header, "ExecName", tostring(EXECUTOR_NAME), UDim2.new(1, -150, 0, 12), UDim2.fromOffset(28, 41), 10, COLORS.White, Enum.Font.GothamBold)
ExecNameLabel.TextXAlignment = Enum.TextXAlignment.Left
ExecNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
ExecNameLabel.ZIndex = 6

local DateTimeLabel = Instance.new("TextLabel")
DateTimeLabel.Name = "DateTime"
DateTimeLabel.Size = UDim2.new(0, 130, 0, 12)
DateTimeLabel.Position = UDim2.new(1, -134, 0, 41)
DateTimeLabel.BackgroundTransparency = 1
DateTimeLabel.Text = os.date("%H:%M:%S  ·  %d/%m/%Y")
DateTimeLabel.TextSize = 10
DateTimeLabel.TextColor3 = COLORS.Dim
DateTimeLabel.Font = Enum.Font.GothamMedium
DateTimeLabel.TextXAlignment = Enum.TextXAlignment.Right
DateTimeLabel.ZIndex = 6
DateTimeLabel.Parent = Header

task.spawn(function()
    while DateTimeLabel and DateTimeLabel.Parent do
        pcall(function()
            DateTimeLabel.Text = os.date("%H:%M:%S  ·  %d/%m/%Y")
        end)
        task.wait(0.5)
    end
end)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "PlayerHeadshot"
AvatarImage.Size = UDim2.fromOffset(34, 34)
AvatarImage.Position = UDim2.new(1, -42, 0, 4)
AvatarImage.BackgroundColor3 = COLORS.Control
AvatarImage.BorderSizePixel = 0
AvatarImage.ZIndex = 5
AvatarImage.ScaleType = Enum.ScaleType.Crop
AvatarImage.Parent = Header
addCorner(AvatarImage, 17)
addStroke(AvatarImage, COLORS.Accent, 1.2, 0.35)

task.spawn(function()
    local uid = player.UserId
    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if ok and content and AvatarImage then
        AvatarImage.Image = content
    elseif AvatarImage then
        AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(uid) .. "&width=48&height=48&format=png"
    end
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Size = UDim2.fromOffset(24, 24)
MinimizeButton.Position = UDim2.new(1, -72, 0, 10)
MinimizeButton.BackgroundColor3 = COLORS.Control
MinimizeButton.BorderSizePixel = 0
MinimizeButton.AutoButtonColor = false
MinimizeButton.Text = "–"
MinimizeButton.TextSize = 16
MinimizeButton.TextColor3 = COLORS.White
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.ZIndex = 5
MinimizeButton.Parent = Header
addCorner(MinimizeButton, 6)
addStroke(MinimizeButton, COLORS.Border, 1, 0.5)

local AutoWriteButton = Instance.new("TextButton")
AutoWriteButton.Name = "AutoWrite"
AutoWriteButton.Size = UDim2.fromOffset(47, 24)
AutoWriteButton.Position = UDim2.new(1, -124, 0, 10)
AutoWriteButton.BackgroundColor3 = COLORS.Accent
AutoWriteButton.BorderSizePixel = 0
AutoWriteButton.AutoButtonColor = false
AutoWriteButton.Active = true
AutoWriteButton.Text = ""
AutoWriteButton.ZIndex = 5
AutoWriteButton.Parent = Header
addCorner(AutoWriteButton, 12)

local AutoWriteStroke = addStroke(AutoWriteButton, COLORS.White, 1, 0.62)
local AutoWriteKnob = Instance.new("Frame")
AutoWriteKnob.Name = "Knob"
AutoWriteKnob.Size = UDim2.fromOffset(20, 20)
AutoWriteKnob.Position = UDim2.new(1, -22, 0.5, -10)
AutoWriteKnob.BackgroundColor3 = COLORS.Window
AutoWriteKnob.BorderSizePixel = 0
AutoWriteKnob.ZIndex = 6
AutoWriteKnob.Parent = AutoWriteButton
addCorner(AutoWriteKnob, 10)

local autoWriteEnabled = (savedConfig.codeSniper ~= false)
_enabled = autoWriteEnabled

AutoWriteButton.BackgroundColor3 = autoWriteEnabled and COLORS.Accent or COLORS.Control
AutoWriteStroke.Transparency = autoWriteEnabled and 0.62 or 0.88
AutoWriteKnob.BackgroundColor3 = autoWriteEnabled and COLORS.Window or COLORS.White
AutoWriteKnob.Position = autoWriteEnabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)

local lastToggleTime = 0
function toggleAutoWrite()
    if tick() - lastToggleTime < 0.08 then return end
    lastToggleTime = tick()

    autoWriteEnabled = not autoWriteEnabled
    _enabled = autoWriteEnabled
    if not autoWriteEnabled and clearNxcCapture then clearNxcCapture() end
    savedConfig.codeSniper = autoWriteEnabled
    saveConfig()
    _lastStatusMsg = nil

    local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(AutoWriteButton, ti, {
        BackgroundColor3 = autoWriteEnabled and COLORS.Accent or COLORS.Control
    }):Play()
    TweenService:Create(AutoWriteStroke, ti, {
        Transparency = autoWriteEnabled and 0.62 or 0.88
    }):Play()
    TweenService:Create(AutoWriteKnob, ti, {
        BackgroundColor3 = autoWriteEnabled and COLORS.Window or COLORS.White,
        Position = autoWriteEnabled
            and UDim2.new(1, -22, 0.5, -10)
            or  UDim2.new(0,   2, 0.5, -10),
    }):Play()

    if ConsoleOutput then
        if autoWriteEnabled then
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Tag .. '">◈</font> <font color="' .. CONSOLE_COLORS.Amber .. '">SCOPE LIVE</font> <font color="' .. CONSOLE_COLORS.Dim .. '">· waiting for targets...</font>'
            for _, featureName in ipairs({"Auto submit", "Riddle solver", "Retype invalid", "Auto farm"}) do
                if featureStates[featureName] then appendConsoleStatus(featureName, true) end
            end
        else
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Tag .. '">◈</font> <font color="' .. CONSOLE_COLORS.Red .. '">SCOPE DOWN</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">sniper paused — CODE IS still armed</font>'
        end
        scrollConsoleToBottom()
    end
end

AutoWriteButton.Activated:Connect(toggleAutoWrite)
AutoWriteButton.MouseButton1Click:Connect(toggleAutoWrite)

local HeaderAccent = Instance.new("Frame")
HeaderAccent.Name = "TitleDivider"
HeaderAccent.Size = UDim2.new(1, -34, 0, 1)
HeaderAccent.Position = UDim2.fromOffset(17, 62)
HeaderAccent.BackgroundColor3 = COLORS.Accent
HeaderAccent.BackgroundTransparency = 0.55
HeaderAccent.BorderSizePixel = 0
HeaderAccent.Parent = Header
_G.NxcPulseRefs.headerAccent = HeaderAccent

Console = Instance.new("ScrollingFrame")
Console.Name = "Console"
Console.Size = UDim2.new(1, -28, 0, 96)
Console.Position = UDim2.fromOffset(14, 82)
Console.BackgroundColor3 = Color3.fromRGB(6, 10, 18)
Console.BackgroundTransparency = 0.22
Console.BorderSizePixel = 0
Console.ClipsDescendants = true
Console.Active = true
Console.ScrollingEnabled = true
Console.ScrollingDirection = Enum.ScrollingDirection.Y
Console.ElasticBehavior = Enum.ElasticBehavior.Always
Console.VerticalScrollBarInset = Enum.ScrollBarInset.Always
Console.CanvasSize = UDim2.new(0, 0, 0, 120)
Console.AutomaticCanvasSize = Enum.AutomaticSize.Y
Console.ScrollBarThickness = 5
Console.ScrollBarImageColor3 = Color3.fromRGB(120, 190, 255)
Console.ScrollBarImageTransparency = 0.25
Console.ZIndex = 3
Console.Parent = Window
addCorner(Console, 10)

local ConsoleStroke = addStroke(Console, Color3.fromRGB(100, 170, 255), 1, 0.55)
_G.NxcPulseRefs.consoleStroke = ConsoleStroke

local ConsolePulse = Instance.new("TextLabel")
ConsolePulse.Name = "PulseGlyph"
ConsolePulse.Size = UDim2.fromOffset(16, 14)
ConsolePulse.Position = UDim2.fromOffset(22, 87)
ConsolePulse.BackgroundTransparency = 1
ConsolePulse.Text = "◈"
ConsolePulse.TextSize = 13
ConsolePulse.Font = Enum.Font.GothamBold
ConsolePulse.TextColor3 = Color3.fromRGB(120, 200, 255)
ConsolePulse.TextStrokeColor3 = Color3.fromRGB(40, 120, 255)
ConsolePulse.TextStrokeTransparency = 0.5
ConsolePulse.ZIndex = 12
ConsolePulse.Parent = Window
_G.NxcPulseRefs.consolePulse = ConsolePulse

ConsoleOutput = Instance.new("TextLabel")
ConsoleOutput.Name = "ConsoleOutput"
ConsoleOutput.Size = UDim2.new(1, -22, 0, 0)
ConsoleOutput.AutomaticSize = Enum.AutomaticSize.Y
ConsoleOutput.Position = UDim2.fromOffset(9, 6)
ConsoleOutput.BackgroundTransparency = 1
ConsoleOutput.RichText = true
if autoWriteEnabled then
    ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Tag .. '">◈</font> <font color="' .. CONSOLE_COLORS.Amber .. '">SCOPE LIVE</font> <font color="' .. CONSOLE_COLORS.Dim .. '">· waiting for targets...</font>'
else
    ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Tag .. '">◈</font> <font color="' .. CONSOLE_COLORS.Red .. '">SCOPE DOWN</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">sniper paused — CODE IS still armed</font>'
end
ConsoleOutput.TextSize = 13
ConsoleOutput.Font = Enum.Font.GothamMedium
ConsoleOutput.TextColor3 = Color3.fromRGB(240, 245, 255)
ConsoleOutput.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
ConsoleOutput.TextStrokeTransparency = 0.45
ConsoleOutput.TextXAlignment = Enum.TextXAlignment.Left
ConsoleOutput.TextYAlignment = Enum.TextYAlignment.Top
ConsoleOutput.TextWrapped = true
ConsoleOutput.ZIndex = 4
ConsoleOutput.Parent = Console

local CONSOLE_BOTTOM_PADDING = 30
updateConsoleCanvas = function()
    if not Console or not ConsoleOutput then return end
    local h = ConsoleOutput.TextBounds.Y
    if h < 1 then h = ConsoleOutput.AbsoluteSize.Y end
    local contentHeight = math.max(Console.AbsoluteWindowSize.Y + 1, ConsoleOutput.Position.Y.Offset + h + CONSOLE_BOTTOM_PADDING)
    Console.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
end
ConsoleOutput:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateConsoleCanvas)
task.defer(updateConsoleCanvas)

local ClearLogsBtn = Instance.new("TextButton")
ClearLogsBtn.Name = "ClearLogs"
ClearLogsBtn.Size = UDim2.fromOffset(52, 18)
ClearLogsBtn.Position = UDim2.new(1, -58, 0, 4)
ClearLogsBtn.BackgroundColor3 = COLORS.Control
ClearLogsBtn.BorderSizePixel = 0
ClearLogsBtn.AutoButtonColor = false
ClearLogsBtn.Active = true
ClearLogsBtn.Text = "Clear"
ClearLogsBtn.TextSize = 10
ClearLogsBtn.TextColor3 = COLORS.White
ClearLogsBtn.Font = Enum.Font.GothamBold
ClearLogsBtn.ZIndex = 6
ClearLogsBtn.Parent = Console
addCorner(ClearLogsBtn, 5)
addStroke(ClearLogsBtn, COLORS.Border, 1, 0.55)

local lastClearTime = 0
function clearLogs()
    if tick() - lastClearTime < 0.2 then return end
    lastClearTime = tick()
    _capturedParts = {}
    if type(clearNxcCapture) == "function" then
        pcall(clearNxcCapture)
    end
    pcall(function()
        local box = (_cachedBox and _cachedBox.Parent) and _cachedBox or (type(nxcCodeBox) == "function" and nxcCodeBox())
        if box then
            _writingCodeBox = true
            box.Text = ""
            _writingCodeBox = false
        end
    end)
    if type(refreshMiniView) == "function" then pcall(refreshMiniView) end
    if not ConsoleOutput then return end
    if autoWriteEnabled then
        ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Tag .. '">◈</font> <font color="' .. CONSOLE_COLORS.Amber .. '">CLEARED</font> <font color="' .. CONSOLE_COLORS.Dim .. '">· buffer reset · waiting...</font>'
    else
        ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Tag .. '">◈</font> <font color="' .. CONSOLE_COLORS.Red .. '">CLEARED</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">buffer wiped · sniper paused</font>'
    end
    _lastStatusMsg = nil
    scrollConsoleToBottom()
end
ClearLogsBtn.Activated:Connect(clearLogs)
ClearLogsBtn.MouseButton1Click:Connect(clearLogs)

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -34, 0, 28)
TabBar.Position = UDim2.fromOffset(17, 182)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex = 4
TabBar.Parent = Window

function makeTabButton(text, xScale, xOffset)
    local b = Instance.new("TextButton")
    b.Name = "Tab_" .. text
    b.Size = UDim2.new(0.5, -4, 1, 0)
    b.Position = UDim2.new(xScale, xOffset, 0, 0)
    b.BackgroundColor3 = COLORS.Control
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = text
    b.TextSize = 12
    b.TextColor3 = COLORS.Dim
    b.Font = Enum.Font.GothamBold
    b.ZIndex = 5
    b.Parent = TabBar
    addCorner(b, 7)
    local stroke = addStroke(b, COLORS.White, 1, 0.75)
    b.MouseEnter:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.15), { Transparency = 0.35 }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), { Transparency = 0.75 }):Play()
    end)
    return b
end

local TabMainBtn = makeTabButton("Main", 0, 0)
local TabKeybindsBtn = makeTabButton("Keybinds", 0.5, 4)

function setTabVisual(active)
    local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function style(btn, on)
        TweenService:Create(btn, ti, {
            BackgroundColor3 = on and COLORS.Accent or COLORS.Control,
            TextColor3 = on and COLORS.Window or COLORS.Dim,
        }):Play()
    end
    style(TabMainBtn, active == "Main")
    style(TabKeybindsBtn, active == "Keybinds")
end
setTabVisual("Main")

local MainPage = Instance.new("Frame")
MainPage.Name = "MainPage"
MainPage.Size = UDim2.new(1, 0, 0, 352)
MainPage.Position = UDim2.fromOffset(0, 214)
MainPage.BackgroundTransparency = 1
MainPage.ZIndex = 3
MainPage.Visible = true
MainPage.ClipsDescendants = true
MainPage.Parent = Window

local KeybindsPage = Instance.new("Frame")
KeybindsPage.Name = "KeybindsPage"
KeybindsPage.Size = UDim2.new(1, 0, 0, 250)
KeybindsPage.Position = UDim2.fromOffset(0, 214)
KeybindsPage.BackgroundTransparency = 1
KeybindsPage.ZIndex = 3
KeybindsPage.Visible = false
KeybindsPage.ClipsDescendants = true
KeybindsPage.Parent = Window

local function popPage(page)
    local sc = page:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", page)
    sc.Scale = 0.94
    TweenService:Create(sc, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end

function showTab(name)
    local isMain = name == "Main"
    local showPage = isMain and MainPage or KeybindsPage
    local hidePage = isMain and KeybindsPage or MainPage
    hidePage.Visible = false
    showPage.Visible = true
    popPage(showPage)
    setTabVisual(name)
end

TabMainBtn.Activated:Connect(function() showTab("Main") end)
TabKeybindsBtn.Activated:Connect(function() showTab("Keybinds") end)

local Settings = MainPage

function makeCard(name, position, size, parentOverride)
    local card = Instance.new("Frame")
    card.Name = name
    card.Position = position
    card.Size = size
    card.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
    card.BackgroundTransparency = 0.25
    card.BorderSizePixel = 0
    card.Parent = parentOverride or Settings
    addCorner(card, 9)
    local stroke = addStroke(card, Color3.fromRGB(140, 190, 255), 1, 0.72)

    local baseBg = card.BackgroundColor3
    local baseTrans = card.BackgroundTransparency
    local hoverTi  = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local leaveTi  = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    card.MouseEnter:Connect(function()
        TweenService:Create(card, hoverTi, {
            BackgroundColor3 = Color3.fromRGB(18, 24, 36),
            BackgroundTransparency = 0.15,
        }):Play()
        if stroke then
            TweenService:Create(stroke, hoverTi, { Transparency = 0.4 }):Play()
        end
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, leaveTi, {
            BackgroundColor3 = baseBg,
            BackgroundTransparency = baseTrans,
        }):Play()
        if stroke then
            TweenService:Create(stroke, leaveTi, { Transparency = 0.72 }):Play()
        end
    end)

    return card
end

function makeStateButton(parent, enabled, consoleName, onToggle, customColor)
    parent.Active = true
    featureStates[consoleName] = enabled
    local button = Instance.new("TextButton")
    button.Name = "State"
    button.Size = UDim2.fromOffset(42, 20)
    button.Position = UDim2.new(1, -50, 0.5, -10)
    button.BackgroundColor3 = enabled and (customColor or COLORS.Accent) or COLORS.Control
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Active = true
    button.Text = enabled and "ON" or "OFF"
    button.TextSize = 8
    button.TextColor3 = enabled and COLORS.Window or COLORS.Dim
    button.Font = Enum.Font.GothamBold
    button.ZIndex = 5
    button.Parent = parent
    addCorner(button, 6)
    local outline = addStroke(button, COLORS.White, 1, enabled and 0.62 or 0.88)
    local lastSubToggle = 0

    local function applyVisual(state)
        featureStates[consoleName] = state
        button.Text = state and "ON" or "OFF"
        local targetBg   = state and (customColor or COLORS.Accent) or COLORS.Control
        local targetTxt  = state and COLORS.Window or COLORS.Dim
        local targetLine = state and 0.62 or 0.88

        local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(button, ti, {
            BackgroundColor3 = targetBg,
            TextColor3 = targetTxt,
        }):Play()
        TweenService:Create(outline, ti, { Transparency = targetLine }):Play()

        local sc = button:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", button)
        sc.Scale = 0.88
        TweenService:Create(sc, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    button:SetAttribute("FeatureName", consoleName)

    local function toggleState()
        if tick() - lastSubToggle < 0.25 then return end
        lastSubToggle = tick()
        local state = not (featureStates[consoleName] == true)
        applyVisual(state)
        if autoWriteEnabled then appendConsoleStatus(consoleName, state) end
        if onToggle then onToggle(state) end
    end

    button.Activated:Connect(toggleState)
    return button
end

local AutoCard = makeCard("AutoSubmit", UDim2.fromOffset(17, 0), UDim2.fromOffset(135, 50))
makeLabel(AutoCard, "Title", "Auto submit", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(AutoCard, _autoAccept, "Auto submit", function(state)
    _autoAccept = state
    savedConfig.autoSubmit = state
    saveConfig()
end)

local AICard = makeCard("AIRiddles", UDim2.fromOffset(158, 0), UDim2.fromOffset(135, 50))
makeLabel(AICard, "Title", "Riddle solver", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(AICard, _riddleSolver, "Riddle solver", function(state)
    _riddleSolver = state
    savedConfig.riddleSolver = state
    saveConfig()
end)

local SpamCard = makeCard("SpamRedeem", UDim2.fromOffset(17, 56), UDim2.fromOffset(276, 40))
makeLabel(SpamCard, "Title", "Spam redeem", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(SpamCard, _spamRedeem, "Spam redeem", function(state)
    _spamRedeem = state
    savedConfig.spamRedeem = state
    saveConfig()
    if setStatus then
        setStatus(state and "Spam redeem ON" or "Spam redeem OFF", state and COLORS.Green or COLORS.Dim)
    end
end, COLORS.Accent)

local DelayCard = makeCard("SubmitAfter", UDim2.fromOffset(17, 102), UDim2.fromOffset(276, 44))
makeLabel(DelayCard, "Title", "Submit after announcements", UDim2.fromOffset(145, 43), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
local CounterShell = Instance.new("Frame")
CounterShell.Name = "Counter"
CounterShell.Size = UDim2.fromOffset(96, 31)
CounterShell.Position = UDim2.new(1, -105, 0.5, -15)
CounterShell.BackgroundColor3 = COLORS.Window
CounterShell.BackgroundTransparency = 0.05
CounterShell.BorderSizePixel = 0
CounterShell.Parent = DelayCard
addCorner(CounterShell, 7)
addStroke(CounterShell, COLORS.White, 1, 0.86)

local Minus = Instance.new("TextButton")
Minus.Name = "Minus"
Minus.Size = UDim2.fromOffset(25, 25)
Minus.Position = UDim2.fromOffset(3, 3)
Minus.BackgroundColor3 = COLORS.Control
Minus.BorderSizePixel = 0
Minus.AutoButtonColor = false
Minus.Active = true
Minus.Text = "-"
Minus.TextSize = 16
Minus.TextColor3 = COLORS.Text
Minus.Font = Enum.Font.GothamBold
Minus.Parent = CounterShell
addCorner(Minus, 5)

local Count = makeLabel(CounterShell, "Count", tostring(_submitAfter), UDim2.fromOffset(28, 25), UDim2.fromOffset(34, 3), 17, COLORS.White, Enum.Font.GothamBold)
Count.TextXAlignment = Enum.TextXAlignment.Center

local Plus = Instance.new("TextButton")
Plus.Name = "Plus"
Plus.Size = UDim2.fromOffset(25, 25)
Plus.Position = UDim2.fromOffset(68, 3)
Plus.BackgroundColor3 = COLORS.Control
Plus.BorderSizePixel = 0
Plus.AutoButtonColor = false
Plus.Active = true
Plus.Text = "+"
Plus.TextSize = 16
Plus.TextColor3 = COLORS.Text
Plus.Font = Enum.Font.GothamBold
Plus.Parent = CounterShell
addCorner(Plus, 5)

function decr()
    _submitAfter = math.max(1, _submitAfter - 1)
    Count.Text = tostring(_submitAfter)
    savedConfig.submitAfter = _submitAfter
    clearNxcCapture()
    if refreshMiniView then refreshMiniView() end
    saveConfig()
end
function incr()
    _submitAfter = _submitAfter + 1
    Count.Text = tostring(_submitAfter)
    savedConfig.submitAfter = _submitAfter
    clearNxcCapture()
    saveConfig()
end

local lastCounterTime = 0
function safeDecr()
    if tick() - lastCounterTime < 0.18 then return end
    lastCounterTime = tick()
    decr()
end
function safeIncr()
    if tick() - lastCounterTime < 0.18 then return end
    lastCounterTime = tick()
    incr()
end

Minus.Activated:Connect(safeDecr)
Plus.Activated:Connect(safeIncr)

local RetypeCard = makeCard("RetypeInvalid", UDim2.fromOffset(17, 152), UDim2.fromOffset(276, 38))
makeLabel(RetypeCard, "Title", "Retype invalid", UDim2.new(1, -65, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
local RetypeState = makeStateButton(RetypeCard, _retypeInvalid, "Retype invalid", function(state)
    _retypeInvalid = state
    savedConfig.retypeInvalid = state
    saveConfig()
end)

local FarmCard = makeCard("AutoFarm", UDim2.fromOffset(17, 196), UDim2.fromOffset(276, 38))
makeLabel(FarmCard, "Title", "Auto farm", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(FarmCard, _autoFarm, "Auto farm", function(state)
    _autoFarm = state
    savedConfig.autoFarm = state
    saveConfig()
    if state then
        pcall(autoBuyStart)
        setStatus("Auto farm ON", COLORS.Gold)
    else
        pcall(autoBuyStop)
        setStatus("Auto farm OFF", COLORS.Dim)
    end
end, COLORS.Gold)

local ManualSubmitBtn = Instance.new("TextButton")
ManualSubmitBtn.Name = "ManualSubmit"
ManualSubmitBtn.Size = UDim2.fromOffset(276, 34)
ManualSubmitBtn.Position = UDim2.fromOffset(17, 240)
ManualSubmitBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 160)
ManualSubmitBtn.BorderSizePixel = 0
ManualSubmitBtn.AutoButtonColor = false
ManualSubmitBtn.Text = "SUBMIT NOW"
ManualSubmitBtn.TextSize = 13
ManualSubmitBtn.TextColor3 = COLORS.White
ManualSubmitBtn.Font = Enum.Font.GothamBlack
ManualSubmitBtn.ZIndex = 5
ManualSubmitBtn.Parent = MainPage
addCorner(ManualSubmitBtn, 9)
addStroke(ManualSubmitBtn, Color3.fromRGB(120, 190, 255), 1.2, 0.4)
_G.NxcPulseRefs.manualSubmit = ManualSubmitBtn

ManualSubmitBtn.Activated:Connect(function()
    if type(manualSubmitNow) == "function" then
        pcall(manualSubmitNow)
    end
end)
ManualSubmitBtn.MouseButton1Click:Connect(function()
    if type(manualSubmitNow) == "function" then
        pcall(manualSubmitNow)
    end
end)

function keyNameFromConfig(v)
    if type(v) ~= "string" or v == "" then return "NONE" end
    return v
end

local _listeningKB = false
function makeKeybindRow(parent, y, title, configKey, onChanged)
    local card = makeCard("KB_" .. configKey, UDim2.fromOffset(17, y), UDim2.fromOffset(266, 34), parent)
    makeLabel(card, "Title", title, UDim2.new(1, -90, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
    local btn = Instance.new("TextButton")
    btn.Name = "Bind"
    btn.Size = UDim2.fromOffset(72, 22)
    btn.Position = UDim2.new(1, -80, 0.5, -11)
    btn.BackgroundColor3 = COLORS.Control
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Text = keyNameFromConfig(savedConfig[configKey])
    btn.TextSize = 10
    btn.TextColor3 = COLORS.White
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 5
    btn.Parent = card
    addCorner(btn, 6)
    addStroke(btn, COLORS.White, 1, 0.7)

    local listening = false
    local conn
    local function stopListen()
        listening = false
        _listeningKB = false
        if conn then pcall(function() conn:Disconnect() end); conn = nil end
        btn.Text = keyNameFromConfig(savedConfig[configKey])
        btn.TextColor3 = COLORS.White
        btn.BackgroundColor3 = COLORS.Control
    end

    local function startListen()
        if _listeningKB and not listening then return end
        if listening then stopListen(); return end
        listening = true
        _listeningKB = true
        btn.Text = "..."
        btn.TextColor3 = COLORS.Accent
        btn.BackgroundColor3 = COLORS.Accent
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if not listening then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if input.KeyCode == Enum.KeyCode.Escape then
                savedConfig[configKey] = nil
                if onChanged then onChanged(nil) end
                saveConfig()
                stopListen()
                return
            end
            if input.KeyCode == Enum.KeyCode.Unknown then return end
            local name = input.KeyCode.Name
            savedConfig[configKey] = name
            if onChanged then onChanged(name) end
            saveConfig()
            stopListen()
        end)
    end

    btn.Activated:Connect(startListen)
    return btn
end

makeLabel(KeybindsPage, "KBHeader", "KEYBINDS  (Esc clears)", UDim2.fromOffset(220, 16), UDim2.fromOffset(17, 4), 10, COLORS.Dim, Enum.Font.GothamBold)

makeKeybindRow(KeybindsPage, 24, "Code Sniper", "kbCodeSniper")
makeKeybindRow(KeybindsPage, 60, "Auto Submit", "kbAutoSubmit")
makeKeybindRow(KeybindsPage, 96, "Riddle Solver", "kbRiddleSolver")
makeKeybindRow(KeybindsPage, 132, "Retype Invalid", "kbRetypeInvalid")
makeKeybindRow(KeybindsPage, 168, "Auto Farm", "kbAutoFarm")
makeKeybindRow(KeybindsPage, 204, "Manual Submit", "kbManualSubmit")

local BottomStrip = Instance.new("Frame")
BottomStrip.Name = "BottomStrip"
BottomStrip.Size = UDim2.new(1, -34, 0, 42)
BottomStrip.Position = UDim2.fromOffset(17, 570)
BottomStrip.BackgroundColor3 = Color3.fromRGB(6, 10, 18)
BottomStrip.BackgroundTransparency = 0.08
BottomStrip.BorderSizePixel = 0
BottomStrip.ZIndex = 8
BottomStrip.Parent = Window
addCorner(BottomStrip, 9)
addStroke(BottomStrip, Color3.fromRGB(100, 170, 255), 1, 0.55)

local DiscordFooter = makeLabel(BottomStrip, "DiscordFooter", "CALCIUM HUB  •  CODE SNIPER", UDim2.new(1, -16, 0, 14), UDim2.fromOffset(10, 4), 10, COLORS.Dim, Enum.Font.GothamMedium)
DiscordFooter.TextXAlignment = Enum.TextXAlignment.Left
DiscordFooter.ZIndex = 9
do
    local sweep = Instance.new("Frame")
    sweep.Name = "AccentSweep"
    sweep.Size = UDim2.fromOffset(40, 2)
    sweep.Position = UDim2.fromOffset(-40, 0)
    sweep.BackgroundColor3 = COLORS.Accent
    sweep.BackgroundTransparency = 0.25
    sweep.BorderSizePixel = 0
    sweep.ZIndex = 10
    sweep.Parent = BottomStrip
    addCorner(sweep, 2)
    task.spawn(function()
        while sweep and sweep.Parent do
            if not Window.Visible then
                task.wait(1.2)
            else
            local w = BottomStrip.AbsoluteSize.X
            if w < 10 then w = 280 end
            sweep.Position = UDim2.fromOffset(-40, 0)
            local tw = TweenService:Create(sweep, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.fromOffset(w + 10, 0),
            })
            tw:Play()
            tw.Completed:Wait()
            task.wait(0.8)
            end
        end
    end)
end

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, -16, 0, 16)
SpeedLabel.Position = UDim2.fromOffset(10, 20)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "last redeem  ·  — ms"
SpeedLabel.TextSize = 12
SpeedLabel.TextColor3 = COLORS.White
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
SpeedLabel.TextStrokeTransparency = 0.4
SpeedLabel.ZIndex = 9
SpeedLabel.Parent = BottomStrip

local _lastRedeemMs = nil
local _lastRedeemCode = nil
local MiniView, MiniMsLabel, MiniCodeLabel, MiniSeqLabel, MiniAvatar, ExpandButton
local _miniVisSnapshot = {}
local refreshMiniView

function setRedeemSpeedMs(ms, code)
    if code and code ~= "" then
        _lastRedeemCode = tostring(code)
    end
    local n = tonumber(ms)
    local col = COLORS.Dim
    local fullTxt = "last redeem  ·  —.——— ms"
    local miniTxt = "—.——— ms"
    if n then
        n = math.max(0, n)
        n = math.floor(n * 1000 + 0.5) / 1000
        _lastRedeemMs = n
        fullTxt = string.format("last redeem  ·  %.3f ms", n)
        miniTxt = string.format("%.3f ms", n)
        if n < 120 then
            col = COLORS.Green
        elseif n < 350 then
            col = COLORS.Accent
        else
            col = COLORS.Text
        end
    else
        _lastRedeemMs = nil
    end
    pcall(function()
        if SpeedLabel and SpeedLabel.Parent then
            SpeedLabel.Text = fullTxt
            SpeedLabel.TextColor3 = col
        end
    end)
    pcall(function()
        if MiniMsLabel and MiniMsLabel.Parent then
            MiniMsLabel.Text = miniTxt
            MiniMsLabel.TextColor3 = col
        end
    end)
    pcall(function()
        if type(refreshMiniView) == "function" then refreshMiniView() end
    end)
end
RedeemSpeedUI.label = SpeedLabel
RedeemSpeedUI.set = setRedeemSpeedMs
_G.NxcSetRedeemMs = setRedeemSpeedMs

local FULL_SIZE = UDim2.fromOffset(310, 620)
local MINI_SIZE = UDim2.fromOffset(300, 72)
local _isMinimized = false

MiniView = Instance.new("Frame")
MiniView.Name = "MiniView"
MiniView.Size = UDim2.new(1, 0, 1, 0)
MiniView.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
MiniView.BackgroundTransparency = 0
MiniView.Visible = false
MiniView.ZIndex = 20
MiniView.Active = true
MiniView.ClipsDescendants = true
MiniView.Parent = Window
addCorner(MiniView, 14)

do
    local bgImg = Instance.new("ImageLabel")
    bgImg.Name = "MiniBgImage"
    bgImg.Size = UDim2.fromScale(1, 1)
    bgImg.BackgroundTransparency = 1
    bgImg.Image = "rbxassetid://129085053275432"
    bgImg.ScaleType = Enum.ScaleType.Crop
    bgImg.ImageTransparency = 0.22
    bgImg.ZIndex = 20
    bgImg.Parent = MiniView
    addCorner(bgImg, 14)
end

local MiniScrim = Instance.new("Frame")
MiniScrim.Name = "MiniScrim"
MiniScrim.Size = UDim2.new(1, 0, 1, 0)
MiniScrim.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
MiniScrim.BackgroundTransparency = 0.38
MiniScrim.BorderSizePixel = 0
MiniScrim.ZIndex = 21
MiniScrim.Parent = MiniView
addCorner(MiniScrim, 14)

local StarLayer = Instance.new("Frame")
StarLayer.Name = "StarLayer"
StarLayer.Size = UDim2.new(1, 0, 1, 0)
StarLayer.BackgroundTransparency = 1
StarLayer.ZIndex = 22
StarLayer.ClipsDescendants = true
StarLayer.Active = false
StarLayer.Parent = MiniView

do
    local pool = {}
    for i = 1, 10 do
        local star = Instance.new("Frame")
        star.Name = "Star" .. i
        star.BackgroundColor3 = Color3.fromRGB(180, 210, 255)
        star.BackgroundTransparency = 0.25 + math.random() * 0.45
        star.BorderSizePixel = 0
        local sz = 2 + math.random(0, 2)
        star.Size = UDim2.fromOffset(sz, sz)
        star.Position = UDim2.fromOffset(math.random(0, 260), -4 - math.random(0, 40))
        star.ZIndex = 20
        star.Parent = StarLayer
        addCorner(star, 8)
        pool[i] = {
            frame = star,
            speed = 18 + math.random() * 42,
            drift = (math.random() - 0.5) * 12,
            twinkle = math.random() * math.pi * 2,
        }
    end
    _G.NxcPulseRefs.miniStars = {
        layer = StarLayer,
        pool = pool,
    }
end

MiniAvatar = Instance.new("ImageLabel")
MiniAvatar.Name = "MiniAvatar"
MiniAvatar.Size = UDim2.fromOffset(42, 42)
MiniAvatar.Position = UDim2.fromOffset(10, 15)
MiniAvatar.BackgroundColor3 = COLORS.Control
MiniAvatar.BorderSizePixel = 0
MiniAvatar.ZIndex = 25
MiniAvatar.ScaleType = Enum.ScaleType.Crop
MiniAvatar.Parent = MiniView
addCorner(MiniAvatar, 21)
local miniAvStroke = addStroke(MiniAvatar, COLORS.Accent, 1.4, 0.25)
_G.NxcPulseRefs.miniAvatar = miniAvStroke

pcall(function()
    if AvatarImage and AvatarImage.Image and AvatarImage.Image ~= "" then
        MiniAvatar.Image = AvatarImage.Image
    else
        local uid = player.UserId
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok and content then
            MiniAvatar.Image = content
        else
            MiniAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(uid) .. "&width=48&height=48&format=png"
        end
    end
end)

MiniMsLabel = Instance.new("TextLabel")
MiniMsLabel.Name = "MiniMs"
MiniMsLabel.Size = UDim2.new(1, -110, 0, 16)
MiniMsLabel.Position = UDim2.fromOffset(58, 6)
MiniMsLabel.BackgroundTransparency = 1
MiniMsLabel.Text = "—.——— ms"
MiniMsLabel.TextSize = 13
MiniMsLabel.TextColor3 = COLORS.Green
MiniMsLabel.Font = Enum.Font.GothamBold
MiniMsLabel.TextXAlignment = Enum.TextXAlignment.Left
MiniMsLabel.TextTruncate = Enum.TextTruncate.AtEnd
MiniMsLabel.ZIndex = 26
MiniMsLabel.Parent = MiniView

MiniCodeLabel = Instance.new("TextLabel")
MiniCodeLabel.Name = "MiniCode"
MiniCodeLabel.Size = UDim2.new(1, -110, 0, 14)
MiniCodeLabel.Position = UDim2.fromOffset(58, 24)
MiniCodeLabel.BackgroundTransparency = 1
MiniCodeLabel.Text = "ready"
MiniCodeLabel.TextSize = 11
MiniCodeLabel.TextColor3 = COLORS.White
MiniCodeLabel.Font = Enum.Font.GothamMedium
MiniCodeLabel.TextXAlignment = Enum.TextXAlignment.Left
MiniCodeLabel.TextTruncate = Enum.TextTruncate.AtEnd
MiniCodeLabel.ZIndex = 26
MiniCodeLabel.Parent = MiniView

MiniSeqLabel = Instance.new("TextLabel")
MiniSeqLabel.Name = "MiniSeq"
MiniSeqLabel.Size = UDim2.new(1, -110, 0, 12)
MiniSeqLabel.Position = UDim2.fromOffset(58, 40)
MiniSeqLabel.BackgroundTransparency = 1
MiniSeqLabel.Text = ""
MiniSeqLabel.TextSize = 10
MiniSeqLabel.TextColor3 = COLORS.Dim
MiniSeqLabel.Font = Enum.Font.Gotham
MiniSeqLabel.TextXAlignment = Enum.TextXAlignment.Left
MiniSeqLabel.TextTruncate = Enum.TextTruncate.AtEnd
MiniSeqLabel.ZIndex = 26
MiniSeqLabel.Parent = MiniView

ExpandButton = Instance.new("TextButton")
ExpandButton.Name = "Expand"
ExpandButton.Size = UDim2.fromOffset(28, 28)
ExpandButton.Position = UDim2.new(1, -36, 0.5, -14)
ExpandButton.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
ExpandButton.BorderSizePixel = 0
ExpandButton.AutoButtonColor = false
ExpandButton.Text = "+"
ExpandButton.TextSize = 16
ExpandButton.TextColor3 = COLORS.White
ExpandButton.Font = Enum.Font.GothamBold
ExpandButton.ZIndex = 26
ExpandButton.Parent = MiniView
addCorner(ExpandButton, 6)
addStroke(ExpandButton, COLORS.Border, 1, 0.5)

refreshMiniView = function()
    if not MiniView or not MiniView.Visible then return end
    local msTxt = _lastRedeemMs and (_lastRedeemMs .. " ms") or "— ms"
    MiniMsLabel.Text = msTxt
    MiniMsLabel.TextColor3 = SpeedLabel and SpeedLabel.TextColor3 or Color3.fromRGB(255, 255, 255)

    local need = math.max(1, tonumber(_submitAfter) or 1)
    local parts = _capturedParts or {}
    local n = #parts

    if n > 0 and n < need then
        local seq = table.concat(parts, " + ")
        local combined = table.concat(parts, "")
        if #seq > 36 then seq = seq:sub(1, 34) .. "…" end
        MiniSeqLabel.Text = string.format("%d/%d  %s", n, need, seq)
        MiniSeqLabel.TextColor3 = Color3.fromRGB(120, 190, 255)
        local show = combined
        if #show > 28 then show = show:sub(1, 26) .. "…" end
        MiniCodeLabel.Text = show
        MiniCodeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif n >= need and n > 0 then
        local combined = table.concat(parts, "")
        if #combined > 28 then combined = combined:sub(1, 26) .. "…" end
        MiniCodeLabel.Text = combined
        MiniCodeLabel.TextColor3 = COLORS.Green
        MiniSeqLabel.Text = string.format("%d/%d announcements", need, need)
        MiniSeqLabel.TextColor3 = COLORS.Green
    else
        local codeTxt = (_lastRedeemCode and #_lastRedeemCode > 0) and _lastRedeemCode or "—"
        if #codeTxt > 28 then codeTxt = codeTxt:sub(1, 26) .. "…" end
        MiniCodeLabel.Text = codeTxt
        MiniCodeLabel.TextColor3 = Color3.fromRGB(235, 240, 255)
        if need > 1 then
            MiniSeqLabel.Text = string.format("0/%d announcements", need)
            MiniSeqLabel.TextColor3 = Color3.fromRGB(190, 210, 240)
        else
            MiniSeqLabel.Text = "ready"
            MiniSeqLabel.TextColor3 = Color3.fromRGB(190, 210, 240)
        end
    end
end

local _miniTween = nil
function setMinimized(on)
    _isMinimized = on
    if _miniTween then
        pcall(function() _miniTween:Cancel() end)
        _miniTween = nil
    end

    local ti = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    if on then
        for k in pairs(_miniVisSnapshot) do _miniVisSnapshot[k] = nil end
        for _, child in ipairs(Window:GetChildren()) do
            if child:IsA("GuiObject") and child ~= MiniView then
                _miniVisSnapshot[child] = child.Visible
                child.Visible = false
            end
        end
        pcall(function()
            if WindowScrim then WindowScrim.Visible = true end
        end)
        MiniView.Visible = true
        StarLayer.Visible = true
        _miniTween = TweenService:Create(Window, ti, {Size = MINI_SIZE})
        _miniTween:Play()
        MinimizeButton.Text = "▢"
        if AvatarImage and AvatarImage.Image ~= "" then
            MiniAvatar.Image = AvatarImage.Image
        end
        refreshMiniView()
    else
        MiniView.Visible = false
        StarLayer.Visible = false
        for child, wasVisible in pairs(_miniVisSnapshot) do
            if child and child.Parent == Window then
                child.Visible = wasVisible
            end
        end
        for k in pairs(_miniVisSnapshot) do _miniVisSnapshot[k] = nil end
        pcall(function()
            if WindowScrim then
                WindowScrim.Visible = true
                WindowScrim.BackgroundTransparency = 0.55
            end
        end)
        _miniTween = TweenService:Create(Window, ti, { Size = FULL_SIZE })
        _miniTween:Play()
        MinimizeButton.Text = "—"
    end
end

MinimizeButton.Activated:Connect(function()
    setMinimized(not _isMinimized)
end)
ExpandButton.Activated:Connect(function()
    setMinimized(false)
end)

do
    local dragging = false
    local activeDragInput
    local dragStart
    local startPosition
    local dragMoved = false
    local DRAG_THRESHOLD = UserInputService.TouchEnabled and 10 or 3

    local function isOverHeaderControl(position)
        local function over(btn)
            if not btn or not btn.Parent then return false end
            local btnPos = btn.AbsolutePosition
            local btnSize = btn.AbsoluteSize
            return position.X >= (btnPos.X - 8)
                and position.X <= (btnPos.X + btnSize.X + 8)
                and position.Y >= (btnPos.Y - 8)
                and position.Y <= (btnPos.Y + btnSize.Y + 8)
        end
        return over(AutoWriteButton) or over(MinimizeButton) or over(AvatarImage) or over(ExpandButton)
    end

    local function stopDragging(input)
        if input ~= activeDragInput then return end
        dragging = false
        activeDragInput = nil
        dragStart = nil
        startPosition = nil
    end

    local function beginDrag(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging or isOverHeaderControl(input.Position) then return end

        dragging = true
        activeDragInput = input
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPosition = Window.Position
        dragMoved = false

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancel then
                stopDragging(input)
            end
        end)
    end

    Header.InputBegan:Connect(beginDrag)
    MiniView.InputBegan:Connect(beginDrag)
    MiniView.Active = true

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not activeDragInput then return end
        local isTrackedTouch = activeDragInput.UserInputType == Enum.UserInputType.Touch and input == activeDragInput
        local isTrackedMouse = activeDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
        if not isTrackedTouch and not isTrackedMouse then return end

        local current = Vector2.new(input.Position.X, input.Position.Y)
        local delta = current - dragStart
        if not dragMoved then
            if delta.Magnitude < DRAG_THRESHOLD then return end
            dragMoved = true
        end

        Window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

function col3ToRich(col)
    if col == COLORS.Green then return CONSOLE_COLORS.Green end
    if col == COLORS.Red then return CONSOLE_COLORS.Red end
    if col == COLORS.Text then return CONSOLE_COLORS.Amber end
    if col == COLORS.White then return CONSOLE_COLORS.Cyan end
    if col == COLORS.Dim then return CONSOLE_COLORS.Dim end
    if col == COLORS.Gold then return CONSOLE_COLORS.Gold end
    return string.format("rgb(%d,%d,%d)", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5))
end

function consoleTime()
    local t = os.date("*t")
    return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end

function consoleTagFor(msg, col)
    local m = tostring(msg or ""):lower()
    if m:find("redeemed") or m:find("success") then
        return "HIT", CONSOLE_COLORS.Green
    end
    if m:find("invalid") or m:find("fail") or m:find("error") or m:find("rejected") then
        return "MISS", CONSOLE_COLORS.Red
    end
    if m:find("code alert") or m:find("[code]") or m:find("pasted") or m:find("target") then
        return "CODE", CONSOLE_COLORS.Gold
    end
    if m:find("solved") or m:find("instant") or m:find("riddle") then
        return "RIDDLE", CONSOLE_COLORS.Magenta
    end
    if m:find("iceridden") or m:find("gemini") or m:find("thinking") then
        return "AI", CONSOLE_COLORS.Cyan
    end
    if m:find("ready") or m:find("scanning") or m:find("scope") then
        return "SYS", CONSOLE_COLORS.Dim
    end
    if col == COLORS.Green then return "OK", CONSOLE_COLORS.Green end
    if col == COLORS.Red then return "ERR", CONSOLE_COLORS.Red end
    if col == COLORS.Gold then return "FARM", CONSOLE_COLORS.Gold end
    return "LOG", CONSOLE_COLORS.Amber
end

function setStatus(msg, col)
    if not ConsoleOutput or not _enabled then return end
    if msg == _lastStatusMsg then return end
    _lastStatusMsg = msg
    col = col or COLORS.Dim
    local tag, tagCol = consoleTagFor(msg, col)
    local bodyCol = col3ToRich(col)
    local line = table.concat({
        '<font color="', CONSOLE_COLORS.Tag, '">', consoleTime(), '</font> ',
        '<font color="', tagCol, '">[', tag, ']</font> ',
        '<font color="', bodyCol, '">', tostring(msg), '</font>',
    })
    local cur = ConsoleOutput.Text or ""
    if cur == "" then
        ConsoleOutput.Text = line
    else
        local combined = cur .. "\n" .. line
        local lines, n = {}, 0
        for ln in (combined .. "\n"):gmatch("(.-)\n") do
            n = n + 1
            lines[n] = ln
        end
        if n > 18 then
            local keep = {}
            for i = n - 17, n do keep[#keep + 1] = lines[i] end
            ConsoleOutput.Text = table.concat(keep, "\n")
        else
            ConsoleOutput.Text = combined
        end
    end
    task.spawn(function()
        if not ConsoleStroke or not ConsoleStroke.Parent then return end
        TweenService:Create(ConsoleStroke, TweenInfo.new(0.12), { Transparency = 0.15 }):Play()
        task.wait(0.15)
        if ConsoleStroke and ConsoleStroke.Parent then
            TweenService:Create(ConsoleStroke, TweenInfo.new(0.4), { Transparency = 0.55 }):Play()
        end
    end)
    scrollConsoleToBottom()
end

function flashCode(code, col)
    if not code or code == "" or code == "—" then return end
    setStatus("target → " .. tostring(code), col or COLORS.White)
end

function resetPasteCounter()
    _capturedParts = {}
    if refreshMiniView then refreshMiniView() end
end
clearNxcCapture = function()
    _capturedParts = {}
    if refreshMiniView then refreshMiniView() end
end

function clearBoxWatchers()
    if _boxTextConn then pcall(function() _boxTextConn:Disconnect() end) end
    if _boxAncestryConn then pcall(function() _boxAncestryConn:Disconnect() end) end
    _boxTextConn = nil
    _boxAncestryConn = nil
    _lastWatchedBox = nil
end

function watchBoxForBlankReset(box)
    if not box or _lastWatchedBox == box then return end
    clearBoxWatchers()
    _lastWatchedBox = box
    if box.Text ~= "" then _lastNonBlankBoxText = box.Text end
    _boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
        if _writingCodeBox then
            if box.Text ~= "" then _lastNonBlankBoxText = box.Text end
            return
        end
        if box.Text == "" then
            local token = #_capturedParts
            task.delay(0.04, function()
                if _writingCodeBox then return end
                if #_capturedParts ~= token then return end
                local b = nxcCodeBox()
                if b and b.Text == "" and #_capturedParts > 0 and #_capturedParts < math.max(1, tonumber(_submitAfter) or 1) then
                    return
                end
            end)
        else
            _lastNonBlankBoxText = box.Text
        end
    end)
    _boxAncestryConn = box.AncestryChanged:Connect(function(_, parent)
        if not parent then resetPasteCounter(); clearBoxWatchers() end
    end)
end

_focusReleasedListener = UserInputService.TextBoxFocusReleased:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    local codeBox = nxcCodeBox()
    if box ~= codeBox and box ~= _lastBox then return end
    if _retypeInvalid and rememberPendingSubmission and (box == codeBox or box == _lastBox) then
        local submittedText = box.Text ~= "" and box.Text or _lastNonBlankBoxText
        rememberPendingSubmission(box, submittedText, false)
    end
    if _focused == box then
        _focused = nil
        if _enabled then
            setStatus((_lastBox and _lastBox.Parent) and "Ready" or "Click code box first", (_lastBox and _lastBox.Parent) and COLORS.Green or COLORS.Dim)
        end
    end
end)

clearPendingSubmission = function()
    _pendingRejectedToken = _pendingRejectedToken + 1
    _pendingRejectedText = nil
    _pendingRejectedBox = nil
    _pendingRejectedUntil = 0
end

rememberPendingSubmission = function(box, text, replaceExisting)
    if not _retypeInvalid or not text or text == "" then return end
    if not replaceExisting and _pendingRejectedText and os.clock() <= _pendingRejectedUntil then return end
    _pendingRejectedToken = _pendingRejectedToken + 1
    local token = _pendingRejectedToken
    _pendingRejectedText = text
    _pendingRejectedBox = box
    _pendingRejectedUntil = os.clock() + 8
    task.delay(8, function()
        if token == _pendingRejectedToken then clearPendingSubmission() end
    end)
end

function restoreRejectedText(box, previousText)
    if not _retypeInvalid or not previousText or previousText == "" then return false end
    RunService.Heartbeat:Wait()
    local repasteBox = nxcCodeBox() or box
    if not repasteBox or not isVisibleChain(repasteBox) then return false end
    local restored = pcall(function() repasteBox.Text = previousText end)
    if restored then
        _lastBox = repasteBox
        watchBoxForBlankReset(repasteBox)
    end
    return restored
end

handleRedemptionFeedback = function(text, feedbackObject)
    if not _retypeInvalid or not _pendingRejectedText then return end
    if os.clock() > _pendingRejectedUntil then clearPendingSubmission(); return end
    if feedbackObject and feedbackObject:IsDescendantOf(GUI) then return end
    local lower = tostring(text or ""):lower()
    local rejected = lower:find("invalid code", 1, true)
        or lower:find("code is invalid", 1, true)
        or lower:find("expired", 1, true)
        or lower:find("already redeemed", 1, true)
        or lower:find("already used", 1, true)
        or lower:find("doesn't exist", 1, true)
        or lower:find("does not exist", 1, true)
        or lower:find("not found", 1, true)
        or lower:find("rejected", 1, true)
    if not rejected then return end
    local previousText = _pendingRejectedText
    local previousBox = _pendingRejectedBox
    local restored = restoreRejectedText(previousBox, previousText)
    clearPendingSubmission()
    if restored then
        setStatus("Invalid - repasted: " .. previousText, COLORS.Text)
        flashCode(previousText, COLORS.Red)
    end
end

function manualSubmitNow()
    local box = (_cachedBox and _cachedBox.Parent and _cachedBox) or (type(nxcCodeBox) == "function" and nxcCodeBox()) or nil
    local code = nil
    if box then
        local t = tostring(box.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if t ~= "" then code = t end
    end
    if (not code or code == "") and _lastNonBlankBoxText and _lastNonBlankBoxText ~= "" then
        code = _lastNonBlankBoxText
    end
    if (not code or code == "") and type(_capturedParts) == "table" and #_capturedParts > 0 then
        code = table.concat(_capturedParts)
    end
    if not code or code == "" then
        if setStatus then setStatus("Nothing to submit", COLORS and COLORS.Dim) end
        return false
    end
    if setStatus then setStatus("Manual submit: " .. tostring(code):sub(1, 36), COLORS and COLORS.Accent) end
    return submitCodeImmediate(code)
end

local function submitNxcShared(code, source)
    code = tostring(code or ""):match("^%s*(.-)%s*$") or ""
    if code == "" then return false, "empty code", 0 end
    local target = _primaryTarget
    local box = (target and target.alive() and target.box) or nxcCodeBox()
    if not box then
        if setStatus then setStatus("Codebox not found", COLORS.Red) end
        return false, "codebox not connected", 0
    end
    rememberPendingSubmission(box, code, true)
    local ok, message, ms = ultraFastSubmit(code)
    if ms then
        pcall(function()
            if RedeemSpeedUI and RedeemSpeedUI.set then
                RedeemSpeedUI.set(ms, code)
            elseif type(_G.NxcSetRedeemMs) == "function" then
                _G.NxcSetRedeemMs(ms, code)
            end
        end)
    end
    if ok then
        setStatus("Submitted: " .. code .. (ms and (" (" .. string.format("%.3f", ms) .. "ms)") or ""), COLORS.Green)
        if _spamRedeem and source ~= "spam" then
            RedeemSpeedUI._spamToken = (RedeemSpeedUI._spamToken or 0) + 1
            local token = RedeemSpeedUI._spamToken
            task.spawn(function()
                for _ = 1, 8 do
                    task.wait(0.05)
                    if not _instanceRunning or not _spamRedeem then return end
                    if RedeemSpeedUI._spamToken ~= token then return end
                    local sOk = ultraFastSubmit(code, true)
                    if not sOk then scheduleRelink() end
                end
            end)
        end
    else
        clearPendingSubmission()
        setStatus("Submit failed: " .. tostring(message), COLORS.Red)
    end
    return ok, message, ms
end

function submitCodeImmediate(code)
    if not code or code == "" then return false end
    clearNxcCapture()
    return submitNxcShared(code, "immediate")
end

function appendToBox(text)
    if not text or text == "" then return end
    text = tostring(text)
    _capturedParts[#_capturedParts + 1] = text
    local combined = table.concat(_capturedParts)
    local received = #_capturedParts
    local needed = math.max(1, tonumber(_submitAfter) or 1)

    if received < needed then
        local box = nxcCodeBox()
        if box then
            _lastBox, _cachedBox = box, box
            _lastNonBlankBoxText = combined
            _writingCodeBox = true
            pcall(function() box.Text = combined end)
            _writingCodeBox = false
        end
        setStatus("Announcement " .. tostring(received) .. "/" .. tostring(needed), COLORS.Green)
        if refreshMiniView then refreshMiniView() end
        return
    end

    _capturedParts = {}
    if _autoAccept then
        local ok = submitNxcShared(combined, "announcements")
        if ok and flashCode then flashCode(combined, COLORS.Green) end
    else
        local box = nxcCodeBox()
        if box then
            _lastBox = box
            _lastNonBlankBoxText = combined
            _writingCodeBox = true
            pcall(function() box.Text = combined end)
            _writingCodeBox = false
        end
        setStatus("Ready: " .. combined, COLORS.Text)
    end
    if refreshMiniView then refreshMiniView() end
end

function watchRedemptionFeedbackObject(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
    if GUI and obj:IsDescendantOf(GUI) then return end 
    local found = false
    local root = obj
    for _ = 1, 6 do
        if not root then break end
        local n = root.Name:lower()
        if n:find("code", 1, true) or n:find("redeem", 1, true)
            or n:find("notif", 1, true) then found = true; break end
        root = root.Parent
    end
    if not found then return end
    handleRedemptionFeedback(obj.Text or "", obj)
    local con = obj:GetPropertyChangedSignal("Text"):Connect(function()
        if _instanceRunning then handleRedemptionFeedback(obj.Text or "", obj) end
    end)
    _feedbackListeners[#_feedbackListeners+1] = con
end

task.spawn(function()
    local roots = playerGui:GetDescendants()
    for i, obj in ipairs(roots) do
        if not _instanceRunning then return end
        watchRedemptionFeedbackObject(obj)
        if i % 100 == 0 then task.wait() end
    end
end)
_feedbackAddedListener = playerGui.DescendantAdded:Connect(function(obj)
    if _instanceRunning then watchRedemptionFeedbackObject(obj) end
end)

local httpRequest = (syn and syn.request) or http_request or request or (http and http.request)
local env = typeof(getgenv) == "function" and getgenv() or _G
local GEMINI_API_KEY = tostring(env.GEMINI_API_KEY or env.GOOGLE_API_KEY or env.GEMINI_KEY or "AQ.Ab8RN6KkwC7nh_mlMr6cwhdL8UBlmLbeyy4lyBxmzlKIVlRSYQ")
local GEMINI_MODEL = tostring(env.GEMINI_MODEL or "gemini-3.5-flash-lite")

function stripRich(s)
    if type(s) ~= "string" then return tostring(s) end
    return (s:gsub("<[^>]->", ""))
end

function trim(s)
    return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local LiveRiddleIntel = {
    animals = {}, mutations = {}, traits = {},
    rankings = {}, ready = false, busy = false, version = 0,
    lastSync = 0, lastError = "Waiting for replicated game data",
    latestAnimal = nil, latestSource = nil, observedNew = {},
    existence = {}, existenceCoverage = 0, countSource = nil,
    counts = {animals = 0, mutations = 0, traits = 0},
    sources = {animals="waiting",mutations="waiting",traits="waiting"},
    moduleErrors = {},
    lastAttempt = 0,
    onUpdated = nil,
}

do
local function intelCleanToken(s)
    return tostring(s or ""):upper():gsub("[^A-Z0-9]", "")
end

local function intelGetModule(name, fallback)
    local datas = ReplicatedStorage:FindFirstChild("Datas")
    if not datas then
        LiveRiddleIntel.moduleErrors[name] = "ReplicatedStorage.Datas missing"
        return nil
    end
    local mod = datas:FindFirstChild(name)
    if not mod and fallback then mod = datas:FindFirstChild(fallback) end
    if not mod or not mod:IsA("ModuleScript") then
        LiveRiddleIntel.moduleErrors[name] = "Datas."..name.." missing"
        return nil
    end
    local ok, data = pcall(require, mod)
    if not ok then
        LiveRiddleIntel.moduleErrors[name] = "require failed: "..tostring(data):sub(1,105)
        return nil
    end
    if type(data) ~= "table" then
        LiveRiddleIntel.moduleErrors[name] = "module did not return table"
        return nil
    end
    local nested = data[name] or (fallback and data[fallback])
    if type(nested)=="table" and next(nested) then
        data=nested
    end
    LiveRiddleIntel.moduleErrors[name] = nil
    return data
end

local function intelFallbackModels()
    local discovered = {}
    local models = ReplicatedStorage:FindFirstChild("Models")
    local assets = ReplicatedStorage:FindFirstChild("Assets")
    local roots={ReplicatedStorage}
    if models then roots[#roots+1]=models end
    if assets then roots[#roots+1]=assets end
    for _,root in ipairs(roots) do
        if root then
            for _,folderName in ipairs({"Animals","Brainrots"}) do
                local folder=root:FindFirstChild(folderName)
                if folder then
                    for _,model in ipairs(folder:GetChildren()) do
                        if model:IsA("Model") and discovered[model.Name]==nil then
                            discovered[model.Name]={
                                Rarity=model:GetAttribute("Rarity"),
                                Generation=model:GetAttribute("Generation") or model:GetAttribute("Income"),
                                Price=model:GetAttribute("Price"),
                                ReleaseOrder=model:GetAttribute("ReleaseOrder"),
                            }
                        end
                    end
                end
            end
        end
    end
    return next(discovered) and discovered or nil
end

local function intelSupplementFromAssets(kind)
    local names={}
    local obj
    if kind=="Mutations" then
        obj=ReplicatedStorage:FindFirstChild("MutationSurfaces")
    else
        local models=ReplicatedStorage:FindFirstChild("Models")
        obj=models and models:FindFirstChild("Traits")
        if not obj then obj=models and models:FindFirstChild("TraitsPerAnimal") end
    end
    if obj then
        for _,child in ipairs(obj:GetChildren()) do
            if child.Name~="None" then names[child.Name]={name=child.Name} end
        end
    end
    return names
end

local function intelSorted(records, field)
    local sorted = {}
    for _, row in pairs(records) do
        if type(row[field]) == "number" and row[field] == row[field] then
            sorted[#sorted+1] = row
        end
    end
    table.sort(sorted, function(a, b)
        if a[field] == b[field] then return a.name < b.name end
        return a[field] > b[field]
    end)
    return sorted
end

local function intelReadNumber(data, fields)
    for _, key in ipairs(fields) do
        local raw = data[key]
        local value = type(raw)=="number" and raw or
            (type(raw)=="string" and tonumber((raw:gsub(",", ""))) or nil)
        if value and value == value and value ~= math.huge and value ~= -math.huge then
            return value
        end
    end
    return nil
end

local RELEASE_FIELDS={"ReleaseTimestamp","ReleaseTime","AddedAt","CreatedAt",
    "ReleaseDate","AddedDate","DateAdded","ReleaseOrder","AddedOrder"}
local function intelReleaseKey(data)
    for _,field in ipairs(RELEASE_FIELDS) do
        local v=data[field]
        if type(v)=="number" and v==v and v>0 then return v,field end
        if type(v)=="string" then
            local year,month,day=v:match("^(%d%d%d%d)[%-/](%d%d?)[%-/](%d%d?)")
            if year then
                return tonumber(year)*10000+tonumber(month)*100+tonumber(day),field
            end
            local n=tonumber(v)
            if n and n>0 then return n,field end
        end
    end
    return nil,nil
end
function LiveRiddleIntel.refresh(force)
    if LiveRiddleIntel.busy then return false end
    local previousRanks=LiveRiddleIntel.rankings
    local fullyRanked=previousRanks.income and #previousRanks.income>0
        and previousRanks.mutations and #previousRanks.mutations>0
        and previousRanks.traits and #previousRanks.traits>0
    if not force and os.clock() - LiveRiddleIntel.lastSync < 90
        and LiveRiddleIntel.ready and fullyRanked then
        return true
    end
    LiveRiddleIntel.busy = true
    LiveRiddleIntel.lastAttempt = os.clock()
    local previousAnimals=LiveRiddleIntel.animals
    local hadPrevious=LiveRiddleIntel.ready and next(previousAnimals)~=nil
    local sourceAnimals = intelGetModule("Animals", "Brainrots")
    local sourceMutations = intelGetModule("Mutations")
    local sourceTraits = intelGetModule("Traits")
    local fallbackAnimals=nil
    if not sourceAnimals or not next(sourceAnimals) then
        fallbackAnimals=intelFallbackModels()
        if fallbackAnimals then sourceAnimals=fallbackAnimals end
    end
    LiveRiddleIntel.sources={
        animals=fallbackAnimals and "Models attributes" or (sourceAnimals and "Datas.Animals" or "Unavailable"),
        mutations=sourceMutations and "Datas.Mutations" or "Unavailable",
        traits=sourceTraits and "Datas.Traits" or "Unavailable",
    }
    if fallbackAnimals then LiveRiddleIntel.moduleErrors.Animals=nil end
    local animals, mutations, traits = {}, {}, {}
    local observedNew={}
    local latest, latestKey, latestField, latestCoverage = nil,nil,nil,0
    local releaseGroups={}
    local processed = 0

    local function yieldSometimes()
        processed += 1
        if processed % 80 == 0 then task.wait() end 
    end

    if sourceAnimals then
        for name, data in pairs(sourceAnimals) do
            if type(name) == "string" and type(data) == "table" then
                local generation = intelReadNumber(data, {"Generation", "Income", "BaseGeneration"})
                local price = intelReadNumber(data, {"Price", "Cost"})
                local releaseKey,releaseField=intelReleaseKey(data)
                animals[name]={name=name,generation=generation,price=price,
                    rarity=tostring(data.Rarity or "Unknown"),
                    releaseKey=releaseKey,releaseField=releaseField}
                if releaseKey~=nil then
                    local group=releaseGroups[releaseField]
                    if not group then
                        group={coverage=0,latestKey=nil,latestName=nil}
                        releaseGroups[releaseField]=group
                    end
                    group.coverage+=1
                    if not group.latestKey or releaseKey>group.latestKey then
                        group.latestKey=releaseKey;group.latestName=name
                    end
                end
                if hadPrevious and previousAnimals[name]==nil then
                    observedNew[#observedNew+1]=name
                end
            end
            yieldSometimes()
        end
    end
    if sourceMutations then
        for name, data in pairs(sourceMutations) do
            if type(name)=="string" and name~="None" and type(data)=="table" then
                local modifier=intelReadNumber(data,{"Modifier","MultiplierModifier","Multiplier","IncomeMultiplier"})
                mutations[name]={name=name,modifier=modifier}
            end
            yieldSometimes()
        end
    end
    if sourceTraits then
        for name, data in pairs(sourceTraits) do
            if type(name)=="string" and type(data)=="table" then
                local modifier=intelReadNumber(data,{"MultiplierModifier","Modifier","Multiplier","IncomeMultiplier"})
                traits[name]={name=name,modifier=modifier}
            end
            yieldSometimes()
        end
    end
    for name,row in pairs(intelSupplementFromAssets("Mutations")) do
        if not mutations[name] then mutations[name]=row end
    end
    for name,row in pairs(intelSupplementFromAssets("Traits")) do
        if not traits[name] then traits[name]=row end
    end
    if not next(animals) and next(LiveRiddleIntel.animals) then
        animals=LiveRiddleIntel.animals
        LiveRiddleIntel.sources.animals="Cached animal metadata"
    end
    if not next(mutations) and next(LiveRiddleIntel.mutations) then
        mutations=LiveRiddleIntel.mutations
        LiveRiddleIntel.sources.mutations="Cached mutation metadata"
    end
    if not next(traits) and next(LiveRiddleIntel.traits) then
        traits=LiveRiddleIntel.traits
        LiveRiddleIntel.sources.traits="Cached trait metadata"
    end
    local function rankedCount(rows)
        local total=0
        for _,item in pairs(rows) do
            if type(item.modifier)=="number" then total+=1 end
        end
        return total
    end
    if rankedCount(mutations)==0 and LiveRiddleIntel.rankings.mutations
        and #LiveRiddleIntel.rankings.mutations>0 then
        mutations=LiveRiddleIntel.mutations
        LiveRiddleIntel.sources.mutations="Cached ranked mutations"
    end
    if rankedCount(traits)==0 and LiveRiddleIntel.rankings.traits
        and #LiveRiddleIntel.rankings.traits>0 then
        traits=LiveRiddleIntel.traits
        LiveRiddleIntel.sources.traits="Cached ranked traits"
    end
    local ranks = {
        income = intelSorted(animals, "generation"),
        prices = intelSorted(animals, "price"),
        mutations = intelSorted(mutations, "modifier"),
        traits = intelSorted(traits, "modifier"),
    }
    table.sort(observedNew)
    local totalAnimals=0
    for _ in pairs(animals) do totalAnimals+=1 end
    for _,field in ipairs(RELEASE_FIELDS) do
        local group=releaseGroups[field]
        if group and group.coverage>latestCoverage then
            latest=group.latestName;latestKey=group.latestKey
            latestField=field;latestCoverage=group.coverage
        end
    end
    if not (totalAnimals>0 or next(mutations) or next(traits)) and hadPrevious then
        LiveRiddleIntel.lastError="Game metadata temporarily missing; cached data retained"
        LiveRiddleIntel.busy=false
        if type(LiveRiddleIntel.onUpdated)=="function" then pcall(LiveRiddleIntel.onUpdated) end
        return true
    end
    LiveRiddleIntel.latestAnimal=latest
    LiveRiddleIntel.latestSource=latest and ((latestCoverage==totalAnimals)
        and ("Complete metadata: "..latestField) or
        ("Partial metadata ("..latestCoverage.."/"..totalAnimals.."): "..latestField)) or nil
    LiveRiddleIntel.observedNew=observedNew
    LiveRiddleIntel.existence={}
    LiveRiddleIntel.existenceCoverage=0
    LiveRiddleIntel.countSource=nil
    LiveRiddleIntel.animals = animals
    LiveRiddleIntel.mutations = mutations
    LiveRiddleIntel.traits = traits
    LiveRiddleIntel.rankings = ranks
    LiveRiddleIntel.counts = {animals = totalAnimals, mutations = #ranks.mutations,
        traits = #ranks.traits}
    local anyRank=(#ranks.income>0 or #ranks.mutations>0 or #ranks.traits>0)
    local anyMetadata=totalAnimals>0 or next(mutations)~=nil or next(traits)~=nil
    LiveRiddleIntel.ready=anyMetadata
    local errors={}
    for _,name in ipairs({"Animals","Mutations","Traits"}) do
        if LiveRiddleIntel.moduleErrors[name] then
            errors[#errors+1]=name..": "..LiveRiddleIntel.moduleErrors[name]
        end
    end
    LiveRiddleIntel.lastError=#errors>0 and table.concat(errors," | ") or
        (not anyRank and "No numeric ranks exposed by the client" or nil)
    LiveRiddleIntel.lastSync = os.clock()
    LiveRiddleIntel.version += 1
    LiveRiddleIntel.busy = false
    if type(LiveRiddleIntel.onUpdated) == "function" then
        pcall(LiveRiddleIntel.onUpdated)
    end
    return LiveRiddleIntel.ready
end

function LiveRiddleIntel.requestRefresh(force)
    if LiveRiddleIntel.busy then return end
    task.spawn(function()
        local ok, err = pcall(LiveRiddleIntel.refresh, force)
        if not ok then
            LiveRiddleIntel.lastError = tostring(err)
            LiveRiddleIntel.busy = false
            if type(LiveRiddleIntel.onUpdated) == "function" then
                pcall(LiveRiddleIntel.onUpdated)
            end
        end
    end)
end

local function intelQuestionCategory(text)
    local s = tostring(text or ""):lower()
    local isMutation = s:find("mutation", 1, true) ~= nil
    local isTrait = s:find("trait", 1, true) ~= nil
    local isAnimal = s:find("brainrot", 1, true) ~= nil or s:find("animal", 1, true) ~= nil
    if not isAnimal and not isMutation and not isTrait then
        if s:find("income", 1, true) or s:find("generation", 1, true) then isAnimal = true end
    end
    local strongest = s:find("best",1,true) or s:find("strongest",1,true)
        or s:find("highest",1,true) or s:find("most",1,true)
        or s:find("richest",1,true) or s:find("greatest",1,true)
        or s:find("priciest",1,true) or s:find("fastest earning",1,true)
    local weakest = s:find("worst",1,true) or s:find("weakest",1,true)
        or s:find("lowest",1,true) or s:find("least",1,true)
        or s:find("cheapest",1,true) or s:find("poorest",1,true)
        or s:find("slowest earning",1,true)
    if not strongest and not weakest then return nil end
    if s:find("favorite",1,true) or s:find("rarity",1,true)
        or s:find("first",1,true) or s:find("latest",1,true)
        or s:find("newest",1,true) then return nil end
    local mode = weakest and "worst" or "best"
    if isMutation then return "mutations", mode end
    if isTrait then return "traits", mode end
    if isAnimal then
        if s:find("price",1,true) or s:find("expensive",1,true)
            or s:find("cheap",1,true) or s:find("cost",1,true)
            or s:find("valuable",1,true) then return "prices", mode end
        return "income", mode
    end
    return nil
end

local function intelFindAnimal(text)
    local q=intelCleanToken(text)
    local matched=nil
    local matchLen=0
    for name in pairs(LiveRiddleIntel.animals) do
        local token=intelCleanToken(name)
        if #token>=4 and #token>matchLen and q:find(token,1,true) then
            matched=name;matchLen=#token
        end
    end
    return matched
end
local function intelHasAny(s,words)
    for _,word in ipairs(words) do
        if s:find(word,1,true) then return true end
    end
    return false
end

function LiveRiddleIntel.answer(text)
    local s=tostring(text or ""):lower()
    local matchedAnimal=intelFindAnimal(s)
    local asksAnimal=intelHasAny(s,{"brainrot","animal"}) or matchedAnimal~=nil
    local latest=intelHasAny(s,{"newest","latest","most recent","last added","recently added"})
    if asksAnimal and latest then
        local source=LiveRiddleIntel.latestSource
        if source and source:find("Complete",1,true) then
            return LiveRiddleIntel.latestAnimal and intelCleanToken(LiveRiddleIntel.latestAnimal) or nil
        end
        return nil 
    end
    if asksAnimal and intelHasAny(s,{"worst","weakest"}) and
       not intelHasAny(s,{"income","generat","price","cost","exists","existence","count"}) then
        return "NOOBINIPIZZANINI"
    end
    if asksAnimal and intelHasAny(s,{"exist","owned globally","global count","how many"}) then
        return nil
    end
    local category, mode = intelQuestionCategory(text)
    if not category then return nil end
    local rows = LiveRiddleIntel.rankings[category]
    if not rows or #rows == 0 then return nil end
    local row = mode == "worst" and rows[#rows] or rows[1]
    return row and intelCleanToken(row.name) or nil
end

LiveRiddleIntel.requestRefresh(false)
task.spawn(function()
    while GUI and GUI.Parent do
        task.wait(LiveRiddleIntel.ready and 90 or 12)
        if GUI and GUI.Parent then LiveRiddleIntel.requestRefresh(false) end
    end
end)
local intelDataModuleWatch=nil
local function scheduleIntelRefresh()
    task.delay(.4,function()
        if GUI and GUI.Parent then LiveRiddleIntel.requestRefresh(true) end
    end)
end
local function attachIntelDataWatch(folder)
    if intelDataModuleWatch then
        intelDataModuleWatch:Disconnect()
        intelDataModuleWatch=nil
    end
    if folder then
        intelDataModuleWatch=folder.ChildAdded:Connect(function(child)
            if child.Name=="Animals" or child.Name=="Brainrots" or
                child.Name=="Mutations" or child.Name=="Traits" then
                scheduleIntelRefresh()
            end
        end)
    end
end
attachIntelDataWatch(ReplicatedStorage:FindFirstChild("Datas"))
local intelDataWatch=ReplicatedStorage.ChildAdded:Connect(function(child)
    if child.Name=="Datas" then attachIntelDataWatch(child) end
    if child.Name=="Datas" or child.Name=="Models" then scheduleIntelRefresh() end
end)
if GUI then
    GUI.Destroying:Connect(function()
        intelDataWatch:Disconnect()
        if intelDataModuleWatch then intelDataModuleWatch:Disconnect() end
    end)
end
end 

local SAB_DB = {
    ["real name"]                   = "SAMMY",
    ["sammy real name"]             = "SAMMY",
    ["sammys real name"]            = "SAMMY",
    ["my real name"]                = "SAMMY",
    ["creator real name"]           = "SAMMY",
    ["owner real name"]             = "SAMMY",
    ["creator name"]                = "SAMMY",
    ["who created sab"]             = "SAMMY",
    ["who made sab"]                = "SAMMY",
    ["who made steal a brainrot"]   = "SAMMY",
    ["who is the owner"]            = "SAMMY",
    ["who owns sab"]                = "SAMMY",
    ["owner"]                       = "SAMMY",
    ["creator"]                     = "SAMMY",
    ["roblox username"]             = "SPYDERSAMMY",
    ["my roblox username"]          = "SPYDERSAMMY",
    ["sammy username"]              = "SPYDERSAMMY",
    ["sammy roblox name"]           = "SPYDERSAMMY",
    ["roblox name"]                 = "SPYDERSAMMY",
    ["username"]                    = "SPYDERSAMMY",
    ["my username"]                 = "SPYDERSAMMY",
    ["how old am i"]                = "24",
    ["how old is sammy"]            = "24",
    ["my age"]                      = "24",
    ["sammy age"]                   = "24",
    ["age"]                         = "24",
    ["birth year"]                  = "2002",
    ["year born"]                   = "2002",
    ["year i was born"]             = "2002",
    ["born year"]                   = "2002",
    ["birth day"]                   = "FRIDAY",
    ["day i was born"]              = "FRIDAY",
    ["day born"]                    = "FRIDAY",
    ["birthday"]                    = "FRIDAY",
    ["born on"]                     = "FRIDAY",
    ["birth month"]                 = "FEBRUARY",
    ["month born"]                  = "FEBRUARY",
    ["month i was born"]            = "FEBRUARY",
    ["where was i born"]            = "ALGERIA",
    ["where was i born at"]         = "ALGERIA",
    ["birthplace"]                  = "ALGERIA",
    ["where i was born"]            = "ALGERIA",
    ["where am i from"]             = "BRAZIL",
    ["where is sammy from"]         = "BRAZIL",
    ["my country"]                  = "BRAZIL",
    ["sammy country"]               = "BRAZIL",
    ["country"]                     = "BRAZIL",
    ["where do i live"]             = "BRAZIL",
    ["where does sammy live"]       = "BRAZIL",
    ["sammy location"]              = "BRAZIL",
    ["nationality"]                 = "BRAZILIAN",
    ["sammy nationality"]           = "BRAZILIAN",
    ["my nationality"]              = "BRAZILIAN",
    ["state"]                       = "SAOPAULO",
    ["my state"]                    = "SAOPAULO",
    ["sammy state"]                 = "SAOPAULO",
    ["city"]                        = "SAOPAULO",
    ["my city"]                     = "SAOPAULO",
    ["sammy city"]                  = "SAOPAULO",
    ["favorite color"]              = "BLUE",
    ["fav color"]                   = "BLUE",
    ["my color"]                    = "BLUE",
    ["sammy color"]                 = "BLUE",
    ["color"]                       = "BLUE",
    ["favourite color"]             = "BLUE",
    ["favorite sport"]              = "FOOTBALL",
    ["fav sport"]                   = "FOOTBALL",
    ["sport"]                       = "FOOTBALL",
    ["my sport"]                    = "FOOTBALL",
    ["favorite football player"]    = "RONALDO",
    ["fav football player"]         = "RONALDO",
    ["favorite food"]               = "PIZZA",
    ["fav food"]                    = "PIZZA",
    ["food"]                        = "PIZZA",
    ["favorite animal"]             = "SPIDER",
    ["fav animal"]                  = "SPIDER",
    ["my pet"]                      = "SPIDER",
    ["favorite game"]               = "ROBLOX",
    ["fav game"]                    = "ROBLOX",
    ["game created on"]             = "FRIDAY",
    ["release month"]               = "MAY",
    ["release year"]                = "2025",
    ["year sab was created"]        = "2025",
    ["when was sab made"]           = "MAY162025",
    ["release date"]                = "MAY162025",
    ["first trait"]                 = "LIGHTNING",
    ["1st trait"]                   = "LIGHTNING",
    ["lightning trait"]             = "MATEO",
    ["first mutation"]              = "BLOODROT",
    ["1st mutation"]                = "BLOODROT",
    ["second mutation"]             = "DIAMOND",
    ["2nd mutation"]                = "DIAMOND",
    ["third mutation"]              = "BLOODROT",
    ["fourth mutation"]             = "RAINBOW",
    ["fifth mutation"]              = "CANDY",
    ["sixth mutation"]              = "LAVA",
    ["seventh mutation"]            = "GALAXY",
    ["eighth mutation"]             = "YINYANG",
    ["ninth mutation"]              = "RADIOACTIVE",
    ["tenth mutation"]              = "CURSED",
    ["eleventh mutation"]           = "DIVINE",
    ["twelfth mutation"]            = "CYBER",
    ["thirteenth mutation"]         = "PHANTOM",
    ["fourteenth mutation"]         = "CRYSTAL",
    ["latest mutation"]             = "CRYSTAL",
    ["evil mutation"]               = "CURSED",
    ["angelic mutation"]            = "DIVINE",
    ["green mutation"]              = "RADIOACTIVE",
    ["purple mutation"]             = "GALAXY",
    ["black and white mutation"]    = "YINYANG",
    ["yellow mutation"]             = "DIVINE",
    ["red mutation"]                = "CURSED",
    ["orange mutation"]             = "LAVA",
    ["first machine"]               = "RAINBOWMACHINE",
    ["second machine"]              = "BUBBLEGUMMACHINE",
    ["third machine"]               = "FUSEMACHINE",
    ["fourth machine"]              = "CRAFTMACHINE",
    ["fifth machine"]               = "WITCHFUSE",
    ["sixth machine"]               = "BRAINROTDEALER",
    ["seventh machine"]             = "BRAINROTTRADER",
    ["eighth machine"]              = "SANTASFUSE",
    ["ninth machine"]               = "SANTASSHOP",
    ["tenth machine"]               = "NEWYEARSMACHINE",
    ["eleventh machine"]            = "DUELSMACHINE",
    ["twelfth machine"]             = "CUPIDSMACHINE",
    ["thirteenth machine"]          = "TRADEMACHINE",
    ["fourteenth machine"]          = "DIVINEFUSE",
    ["fifteenth machine"]           = "EGGINCUBATOR",
    ["sixteenth machine"]           = "CYBERCRAFTMACHINE",
    ["seventeenth machine"]         = "SUMMERFUSE",
    ["eighteenth machine"]          = "LOSTRADERS",
    ["newest machine"]              = "LOSTRADERS",
    ["rarest brainrot"]             = "HEADLESSHORSEMAN",
    ["unobtainable"]                = "HEADLESSHORSEMAN",
    ["first og added"]              = "STRAWBERRYELEPHANT",
    ["1st og"]                      = "STRAWBERRYELEPHANT",
    ["second og"]                   = "MEOWL",
    ["2nd og"]                      = "MEOWL",
    ["third og"]                    = "SKIBIDITOILET",
    ["3rd og"]                      = "SKIBIDITOILET",
    ["fourth og"]                   = "JOHNPORK",
    ["4th og"]                      = "JOHNPORK",
    ["highest rarity"]              = "OG",
    ["lowest rarity"]               = "COMMON",
    ["fire represents"]             = "DRAGON",
    ["world cup winner"]            = "SPAIN",
    ["worst game owner"]            = "SECRETLOKII",
    ["worst game on roblox"]        = "KEYBOARDESCAPE",
    ["worst secret"]                = "KARKERKARKURKUR",
    ["max server size"]             = "EIGHT",
    ["brother of hydra bunny"]      = "CERBERUS",
    ["game name"]                   = "STEALABRAINROT",
    ["sab stands for"]              = "STEALABRAINROT",
    ["head sab dev"]                = "HASTED",
    ["lead sab dev"]                = "HASTED",
    ["hasted"]                      = "HASTED",
    ["admin war opponent"]          = "JANDEL",
    ["who did i fight"]             = "JANDEL",
    ["jandel"]                      = "JANDEL",
    ["who won admin war"]           = "GROWAGARDEN",
    ["admin war winner"]            = "GROWAGARDEN",
    ["my name"]                     = "SAMMY",
    ["what is my name"]             = "SAMMY",
    ["worst brainrot"]              = "NOOBINIPIZZANINI",
    ["worst animal"]                = "NOOBINIPIZZANINI",
    ["favorite brainrot"]           = "MEOWL",
    ["least favorite brainrot"]     = "RACCOONIJANDELINI",
    ["spyder elephant"]             = "SPYDERELEPHANT",
    ["whats my cats name"]          = "NOVA",
    ["cat name"]                    = "NOVA",
    ["cats name"]                   = "NOVA",
    ["my cats name"]                = "NOVA",
    ["favorite number"]             = "SEVEN",
    ["lucky number"]                = "SEVEN",
    ["favorite color twice"]        = "BLUEBLUE",
    ["my name twice"]               = "SAMMYSAMMY",
    ["my age twice"]                = "2424",
}

function localExactAnswer(text)
    if not text or text == "" then return nil end
    local l = text:lower()
    l = l:gsub("[%?%.%,!]", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

    if l:find("admin", 1, true) and (l:find("war", 1, true) or l:find("abuse", 1, true)) then
        if l:find("won", 1, true) or l:find("winner", 1, true) then return "GROWAGARDEN" end
        if l:find("fight", 1, true) or l:find("fought", 1, true) or l:find("against", 1, true)
            or l:find("opponent", 1, true) then
            return "JANDEL"
        end
        return "JANDEL"
    end
    if l:find("head sab", 1, true) or l:find("lead sab", 1, true) then return "HASTED" end
    if l:find("cats name", 1, true) or l:find("cat name", 1, true) or l:find("my cat", 1, true) then return "NOVA" end
    if l:find("first mutation", 1, true) and not l:find("base", 1, true) then return "BLOODROT" end
    if l:find("newest mutation", 1, true) or l:find("latest mutation", 1, true) or l:find("last mutation", 1, true) then return "CRYSTAL" end
    if l:find("spyder elephant", 1, true) then return "SPYDERELEPHANT" end
    local intelAnswer = LiveRiddleIntel.answer(l)
    if intelAnswer then return intelAnswer end

    if SAB_DB[l] then return SAB_DB[l] end

    local clean = l
    clean = clean:gsub("what%s+is", ""):gsub("what%s+are", ""):gsub("who%s+is", "")
    clean = clean:gsub("^my%s+", ""):gsub("^sammy[s]?%s+", "")
    clean = clean:gsub("[%?%.%,!]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    clean = clean:gsub("%s+", " ")
    clean = trim(clean)

    if SAB_DB[clean] then return SAB_DB[clean] end
    return nil
end

local nxcRiddleAnswerCache={}
function queryAI(question, statusCb)
    local function stat(msg) if statusCb then statusCb(msg) end end
    local cached=nxcRiddleAnswerCache[tostring(question or ""):lower()]
    if cached then return cached,nil,nil end
    if not httpRequest then return nil, nil, "no http executor" end
    local key = GEMINI_API_KEY
    if type(key) ~= "string" or key == "" then return nil, nil, "GEMINI_API_KEY empty" end

    local qRaw = tostring(question or "")

    do
        local offline = localExactAnswer(qRaw)
        if offline and offline ~= "" then
            local clean = tostring(offline):upper():gsub("[^A-Z0-9]", "")
            if clean ~= "" then
                stat("DB: " .. clean:sub(1, 40))
                return clean, nil, nil
            end
        end
    end

    local models = {
        tostring(GEMINI_MODEL or "gemini-3.5-flash-lite"),
        "gemini-3.5-flash-lite",
        "gemini-3.8-flash",
        "gemini-3.6-flash",
    }
    local retiredModels = {
        ["gemini-1.5-flash"] = true,
        ["gemini-2.0-flash"] = true,
        ["gemini-2.0-flash-lite"] = true,
    }
    local seenM, order = {}, {}
    for _, m in ipairs(models) do
        if m and m ~= "" and not retiredModels[m] and not seenM[m] then
            seenM[m] = true
            order[#order + 1] = m
        end
    end

    local systemPrompt = table.concat({
        "You solve Steal a Brainrot (SAB) Roblox riddle codes.",
        "Output format: exactly one line starting with CODE: then the token.",
        "- ALL CAPS, no spaces, no punctuation.",
        "- Owner/creator/name/sammy = SAMMY (NOT HASTED).",
        "- HASTED is ONLY for head sab dev / lead sab developer.",
        "- Admin war opponent/fought = JANDEL. Admin war winner = GROWAGARDEN.",
        "- Favorite color = BLUE. Age = 24. Cat name = NOVA.",
    }, "\n")

    local context = ""
    local r = LiveRiddleIntel.rankings
    if LiveRiddleIntel.ready then
        local bits = {}
        for _, category in ipairs({"income", "mutations", "traits"}) do
            local rows = r[category]
            if rows and #rows > 0 then
                bits[#bits+1] = category .. ": highest=" .. rows[1].name
                    .. ", lowest=" .. rows[#rows].name
            end
        end
        if LiveRiddleIntel.latestAnimal and LiveRiddleIntel.latestSource and
            LiveRiddleIntel.latestSource:find("Complete",1,true) then
            bits[#bits+1]="latest (complete replicated metadata): "..LiveRiddleIntel.latestAnimal
        end
        bits[#bits+1]="worst brainrot riddle answer: Noobini Pizzanini"
        if #bits > 0 then context = "Game-sourced rankings: " .. table.concat(bits, "; ") .. "\n" end
    end
    local userPrompt = context .. "Question: " .. qRaw .. "\nReply with one line: CODE: YOURANSWER"
    local lastErr = "no model worked"

    for _, model in ipairs(order) do
        stat("AI thinking…")
        local url = "https://generativelanguage.googleapis.com/v1beta/models/" .. model .. ":generateContent?key=" .. key
        local bodyTable = {
            system_instruction = { parts = { { text = systemPrompt } } },
            contents = { { role = "user", parts = { { text = userPrompt } } } },
            generationConfig = { temperature = 0, maxOutputTokens = 32, topP = 0.8 },
        }
        local body = HttpService:JSONEncode(bodyTable)
        local ok, res = pcall(httpRequest, {
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body,
        })
        if ok and res then
            local bodyStr = res.Body or res.body or ""
            if type(bodyStr) ~= "string" then bodyStr = tostring(bodyStr) end
            local pOk, parsed = pcall(HttpService.JSONDecode, HttpService, bodyStr)
            if pOk and type(parsed) == "table" and type(parsed.error) == "table" then
                local apiErr = tostring(parsed.error.message or "")
                local lowerErr = apiErr:lower()
                if lowerErr:find("api key", 1, true)
                    or lowerErr:find("invalid key", 1, true)
                    or lowerErr:find("permission denied", 1, true) then
                    return nil, nil, "Gemini API key rejected; check GEMINI_API_KEY"
                end
            end
            if pOk and type(parsed) == "table" and not parsed.error then
                local rawAns = ""
                local cands = parsed.candidates
                if type(cands) == "table" and cands[1] then
                    local content = cands[1].content
                    local parts = content and content.parts
                    if type(parts) == "table" then
                        local buf = {}
                        for _, p in ipairs(parts) do
                            if type(p) == "table" and type(p.text) == "string" then
                                buf[#buf + 1] = p.text
                            end
                        end
                        rawAns = table.concat(buf, "")
                    end
                end
                local answer = trim(rawAns):upper()
                local code = answer:match("CODE:%s*([%w%|%s%-]+)")
                if code then answer = code end
                answer = answer:gsub("^CODE%s*:?", ""):gsub("[^A-Z0-9]", "")
                answer = answer:match("([^\n\r]+)") or answer
                if answer ~= "" and #answer <= 48 then
                    GEMINI_MODEL = model
                    nxcRiddleAnswerCache[qRaw:lower()]=answer
                    stat("AI: " .. answer:sub(1, 40))
                    return answer, nil, nil
                end
            end
        end
        lastErr = "fail " .. model
    end

    return nil, nil, lastErr
end

function extractNumber(text)
    if not text then return nil end
    local n = tostring(text):match("(%d+)%s*$")
    if not n then return nil end
    local num = tonumber(n)
    if num and num > 13 then return n end
    return nil
end

function extractTimesMultiplier(text)
    local l = text:lower()
    if l:find("twice")  then return 2 end
    if l:find("thrice") then return 3 end
    local n = l:match("(%d+)%s*times")
    if n then
        n = tonumber(n)
        if n and n >= 2 and n <= 10 then return n end
    end
    return nil
end

function stripMultiplierText(text)
    local s = text
    s = s:gsub("%s*%d+%s*[Tt]imes%s*", " ")
    s = s:gsub("%s*[Tt]wice%s*",        " ")
    s = s:gsub("%s*[Tt]hrice%s*",       " ")
    return trim(s)
end

function stripTrailingNumber(text)
    return trim(text:gsub("%s+%d+%s*$", ""))
end

function isMultiPartQuestion(text)
    local l = tostring(text or ""):lower()
    if l:find("%s+plus%s+") or l:find("%s+%+%s+") or l:find("%s+and%s+") then return true end
    if l:find(",") or l:find("%s+&%s+") then return true end
    return false
end

function splitAllParts(text)
    local raw = trim(tostring(text or ""))
    if raw == "" then return { "" } end

    local startParts, endParts = {}, {}
    local work = raw

    work = work:gsub("([%w%s%-%']+?)%s+at%s+the%s+end", function(subj)
        subj = trim(subj)
        if subj ~= "" then endParts[#endParts + 1] = subj end
        return " "
    end)
    work = work:gsub("([%w%s%-%']+?)%s+at%s+the%s+start", function(subj)
        subj = trim(subj)
        if subj ~= "" then startParts[#startParts + 1] = subj end
        return " "
    end)

    work = work:gsub("%s+plus%s+", " and ")
    work = work:gsub("%s+%+%s+", " and ")
    work = work:gsub("%s+then%s+", " and ")
    work = work:gsub("%s*,%s*", " and ")
    work = work:gsub("%s+&%s+", " and ")

    local mid = {}
    for part in (work .. " and "):gmatch("(.-)%s+and%s+") do
        part = trim(part)
        part = part:gsub("^[%s,]+", ""):gsub("[%s,]+$", "")
        part = part:gsub("^[Ww]hat%s+", "what ")
        local low = part:lower()
        if part ~= "" and low ~= "and" and low ~= "or" then
            mid[#mid + 1] = part
        end
    end

    local parts = {}
    for _, p in ipairs(startParts) do parts[#parts + 1] = p end
    for _, p in ipairs(mid) do parts[#parts + 1] = p end
    for _, p in ipairs(endParts) do parts[#parts + 1] = p end
    if #parts == 0 then parts[1] = raw end
    return parts
end

function resolvePartOffline(part)
    local multiplier = extractTimesMultiplier(part)
    local q = stripMultiplierText(part)
    if not tostring(q):match("^%s*%d+%s*$") then
        q = stripTrailingNumber(q)
    end
    q = trim(q)
    if q == "" then return nil, q end

    local onlyNum = q:match("^%d+$")
    if onlyNum then
        return (multiplier and string.rep(onlyNum, multiplier) or onlyNum), q
    end

    local candidates = { q }
    local ql = q:lower()
    candidates[#candidates + 1] = ql
    candidates[#candidates + 1] = ql:gsub("^what%s+is%s+", ""):gsub("^what%s+are%s+", "")
    candidates[#candidates + 1] = ql:gsub("^who%s+is%s+", ""):gsub("^who%s+did%s+", "")
    candidates[#candidates + 1] = ql:gsub("^my%s+", "")

    local seen = {}
    for _, cand in ipairs(candidates) do
        cand = trim(tostring(cand or ""):gsub("[%?%.%,!]", ""):gsub("%s+", " "))
        if cand ~= "" and not seen[cand] then
            seen[cand] = true
            local a = localExactAnswer(cand)
            if a then
                local clean = tostring(a):upper():gsub("%s+", ""):gsub("[%?%.%,!]", "")
                if clean ~= "" and clean ~= "AND" and clean ~= "OR" then
                    return (multiplier and string.rep(clean, multiplier) or clean), q
                end
            end
            if SAB_DB[cand] then
                local clean = tostring(SAB_DB[cand]):upper():gsub("%s+", "")
                if clean ~= "" then
                    return (multiplier and string.rep(clean, multiplier) or clean), q
                end
            end
        end
    end

    if not q:find("?") and #q <= 24 and not q:match("%s") then
        local lit = q:upper():gsub("[^%w]", "")
        if lit ~= "" and #lit >= 2 then
            return (multiplier and string.rep(lit, multiplier) or lit), q
        end
    end

    return nil, q
end

function solveRiddle(text, statusCb)
    local multi = isMultiPartQuestion(text)

    if not multi then
        local fullHit = localExactAnswer(text)
        if fullHit and fullHit ~= "" then
            local out = tostring(fullHit):upper():gsub("%s+", ""):gsub("[%?%.%,!]", "")
            if statusCb then statusCb("DB: " .. out:sub(1, 48)) end
            return out, nil, nil
        end
    end

    local suffix = extractNumber(text)
    local parts = splitAllParts(text)
    local answers = {}
    local needAI = {}

    for i, part in ipairs(parts) do
        local r, qq = resolvePartOffline(part)
        if r and r ~= "" then
            answers[i] = r
        else
            needAI[#needAI + 1] = { i = i, q = qq or tostring(part) }
        end
    end

    if #needAI == 0 and #parts > 0 then
        local ordered = {}
        for i = 1, #parts do
            if answers[i] then ordered[#ordered + 1] = answers[i] end
        end
        local out = table.concat(ordered, "")
        if suffix and out:sub(-#suffix) ~= suffix then
            local already = false
            for _, a in ipairs(ordered) do
                if a == suffix then already = true break end
            end
            if not already then out = out .. suffix end
        end
        if statusCb then statusCb("DB multi: " .. out:sub(1, 48)) end
        return out, nil, nil
    end

    if #needAI > 1 then
        local batchAnswer = select(1, queryAI(text, statusCb))
        local batchClean = tostring(batchAnswer or ""):upper():gsub("[^A-Z0-9]", "")
        if batchClean ~= "" then
            if suffix and batchClean:sub(-#suffix) ~= suffix then
                batchClean = batchClean .. suffix
            end
            if statusCb then statusCb("AI multi: " .. batchClean:sub(1, 48)) end
            return batchClean, nil, nil
        end
    end

    for i=1,math.min(#needAI,4) do
        local entry=needAI[i]
        local a=select(1,queryAI(entry.q,statusCb))
        if a then
            local clean=tostring(a):upper():gsub("[^A-Z0-9]", "")
            if clean~="" then answers[entry.i]=clean end
        end
    end

    local ordered, missingNames = {}, {}
    for i = 1, #parts do
        if answers[i] then
            ordered[#ordered + 1] = answers[i]
        else
            missingNames[#missingNames + 1] = tostring(parts[i]):sub(1, 30)
        end
    end

    if #missingNames>0 then
        return nil,nil,"Unresolved: "..table.concat(missingNames," | ")
    end

    local out = table.concat(ordered, "")
    if suffix and out:sub(-#suffix) ~= suffix then
        local already = false
        for _, a in ipairs(ordered) do
            if a == suffix then already = true break end
        end
        if not already then out = out .. suffix end
    end
    return out, nil, nil
end

function resolveNotifyRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end
    local ok, Net = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("Net", 5)
    end)
    if not ok or not Net then return nil end
    local getinfo = debug and (debug.getinfo or debug.info)
    if getgc and getinfo and getconnections then
        for _, d in ipairs(Net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local ok2, cs = pcall(getconnections, d.OnClientEvent)
                if ok2 then
                    for _, c in ipairs(cs) do
                        local f, fn = pcall(function() return c.Function end)
                        if f and type(fn) == "function" then
                            local i, info = pcall(getinfo, fn)
                            if i and tostring(info.short_src or info.source or ""):find("NotificationController", 1, true) then
                                return d
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

function nxcStripRich(text)
    if type(text) ~= "string" then return tostring(text) end
    return (text:gsub("<[^>]->", ""))
end

local nxcCollectBuffer = {}
local _riddleSolving = false

function partNeedsRiddle(part)
    local s = trim(tostring(part or ""))
    if s == "" then return false end
    if s:find("%?") then return true end
    if s:match("^%d+$") then return false end
    local compact = s:gsub("%s+", "")
    if compact:match("^[A-Za-z0-9_%-]+$") and #compact >= 2 and #compact <= 48 and not s:find("%s") then
        return false
    end
    local lower = s:lower():gsub("^%s+", "")
    if lower:match("^what[%s']") or lower:match("^who[%s']") or lower:match("^when[%s']")
        or lower:match("^where[%s']") or lower:match("^how[%s']") or lower:match("^which[%s']") then
        return true
    end
    if lower:find("my name", 1, true) or lower:find("my age", 1, true)
        or lower:find("favorite ", 1, true) then
        return true
    end
    return false
end

function lowerHasAnd(t)
    local l = tostring(t or ""):lower()
    return l:find("%sand%s") ~= nil or l:find("%sadd%s") ~= nil
end

function shouldSolveAsRiddle(text)
    if not text or text == "" then return false end
    if text:find("%?") then return true end
    if text:find(",") or lowerHasAnd(text) then
        local parts = splitAllParts(text)
        for _, p in ipairs(parts) do
            if partNeedsRiddle(p) then return true end
        end
        if #parts > 1 then return true end
    end
    if partNeedsRiddle(text) then return true end
    if localExactAnswer(text) then return true end
    return false
end

function isCodePhrase(announcement)
    local upper = tostring(announcement or ""):upper()
    if upper:find("USE%s+CODE") then return true end
    if upper:find("THE%s+CODE%s+IS") then return true end
    if upper:find("CODE%s+IS") then return true end
    if upper:find("REDEEM%s+CODE") then return true end
    if upper:find("ENTER%s+CODE") then return true end
    return false
end

function extractExplicitCode(announcement)
    local t = tostring(announcement or "")
    local upper = t:upper()
    local junk = {
        IS=true, THE=true, CODE=true, USE=true, FOR=true, NOW=true, HERE=true,
        THIS=true, THAT=true, PLEASE=true, REDEEM=true, ENTER=true, YOUR=true,
        A=true, AN=true, TO=true, AND=true, OR=true,
    }
    local patterns = {
        "USE%s+CODE%s*[:%-=]?%s*([%w_%-]+)",
        "THE%s+CODE%s+IS%s*[:%-=]?%s*([%w_%-]+)",
        "CODE%s+IS%s*[:%-=]?%s*([%w_%-]+)",
        "REDEEM%s+CODE%s*[:%-=]?%s*([%w_%-]+)",
        "ENTER%s+CODE%s*[:%-=]?%s*([%w_%-]+)",
        "CODE%s*[:%-=]%s*([%w_%-]+)",
    }
    for _, pat in ipairs(patterns) do
        local code = upper:match(pat)
        if code and #code >= 2 and #code <= 48 and not junk[code] then
            return code:gsub("[^A-Z0-9_%-]", "")
        end
    end
    return nil
end

function onNxcAnnouncement(...)
    local text = nxcStripRich(tostring((...) or ""))
    text = text:match("^%s*(.-)%s*$") or ""
    if text == "" then return end

    do
        local phraseHit = isCodePhrase(text)
        local explicit = extractExplicitCode(text)
        if phraseHit or (explicit and #explicit >= 2) then
            local dedupeKey = explicit or ("phrase:" .. tostring(text):upper():sub(1, 48))
            if _seen[dedupeKey] then return end
            _seen[dedupeKey] = true
            task.delay(2, function() _seen[dedupeKey] = nil end)

            local wasOff = not autoWriteEnabled
            autoWriteEnabled = true
            _enabled = true
            pcall(function()
                savedConfig.codeSniper = true
                if type(saveConfig) == "function" then saveConfig() end
            end)
            pcall(function()
                if AutoWriteButton then
                    local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    TweenService:Create(AutoWriteButton, ti, { BackgroundColor3 = COLORS.Accent }):Play()
                end
                if AutoWriteStroke then
                    TweenService:Create(AutoWriteStroke, TweenInfo.new(0.22), { Transparency = 0.62 }):Play()
                end
                if AutoWriteKnob then
                    local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    TweenService:Create(AutoWriteKnob, ti, {
                        BackgroundColor3 = COLORS.Window,
                        Position = UDim2.new(1, -22, 0.5, -10),
                    }):Play()
                end
            end)
            if wasOff then
                pcall(function()
                    if type(appendConsoleStatus) == "function" then
                        appendConsoleStatus("Code sniper", true)
                    end
                    setStatus("SNIPER ARMED (CODE phrase)", COLORS.Green)
                end)
            end

            if not explicit or #explicit < 2 then return end

            pcall(function()
                setStatus("CODE ALERT: " .. explicit, COLORS.Green)
                flashCode(explicit, COLORS.Green)
            end)

            appendToBox(explicit)
            return
        end
    end

    if not autoWriteEnabled then return end

    if _riddleSolver and shouldSolveAsRiddle(text) then
        if _riddleSolving then return end
        if _seen[text] then return end
        _seen[text] = true
        task.delay(4, function() _seen[text] = nil end)

        _riddleSolving = true
        task.spawn(function()
            setStatus("Riddle: " .. text:sub(1, 48), COLORS.Text)
            local function statusCb(msg)
                setStatus(tostring(msg):sub(1, 60), COLORS.Dim)
            end
            local ok, a, _, e = pcall(solveRiddle, text, statusCb)
            if not ok then
                setStatus("Riddle error: " .. tostring(a):sub(1, 60), COLORS.Red)
                _riddleSolving = false
                return
            end
            local realAnswer, realErr = a, e
            if realAnswer and realAnswer ~= "" then
                realAnswer = tostring(realAnswer):upper():gsub("%s+", ""):gsub("[%?%.%,!]", "")
                local qCompact = text:upper():gsub("%s+", ""):gsub("[%?%.%,!]", "")
                if realAnswer == qCompact or #realAnswer < 2 then
                    setStatus("Riddle rejected (looks like question)", COLORS.Red)
                else
                    setStatus("Solved: " .. realAnswer, COLORS.Green)
                    flashCode(realAnswer, COLORS.Green)
                    submitNxcShared(realAnswer, "riddle")
                end
            else
                setStatus("Riddle fail: " .. tostring(realErr or "no answer"):sub(1, 60), COLORS.Red)
            end
            _riddleSolving = false
        end)
        return
    end

    local captured = text:gsub("%s+", "")
    if captured == "" then return end

    if _seen[captured] then return end
    _seen[captured] = true
    task.delay(0.015, function() _seen[captured] = nil end)

    appendToBox(captured)
end

local NotifyRemote = resolveNotifyRemote()
local ListenConnection

if NotifyRemote then
    if getgenv then
        local previous = getgenv().CodeSniperNotifyConnection
        if previous then pcall(function() previous:Disconnect() end) end
    end

    ListenConnection = NotifyRemote.OnClientEvent:Connect(function(...)
        pcall(onNxcAnnouncement, ...)
    end)

    if getgenv then
        getgenv().CodeSniperNotifyConnection = ListenConnection
    end
end


function keyMatches(configKey, keyCode)
    local name = savedConfig[configKey]
    if type(name) ~= "string" or name == "" then return false end
    local ok, enumVal = pcall(function() return Enum.KeyCode[name] end)
    return ok and enumVal ~= nil and keyCode == enumVal
end

function setCodeSniperEnabled(on)
    if autoWriteEnabled == on then return end
    autoWriteEnabled = not on
    toggleAutoWrite()
end

function setAutoSubmitEnabled(on)
    if _autoAccept == on then return end
    _autoAccept = on
    savedConfig.autoSubmit = on
    featureStates["Auto submit"] = on
    saveConfig()
    if autoWriteEnabled then appendConsoleStatus("Auto submit", on) end
    pcall(function()
        local card = Settings:FindFirstChild("AutoSubmit")
        if not card then return end
        local btn = card:FindFirstChild("State")
        if not btn then return end
        local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(btn, ti, {
            BackgroundColor3 = on and COLORS.Accent or COLORS.Control,
            TextColor3 = on and COLORS.Window or COLORS.Dim,
        }):Play()
        btn.Text = on and "ON" or "OFF"
    end)
end

function setRiddleSolverEnabled(on)
    if _riddleSolver == on then return end
    _riddleSolver = on
    savedConfig.riddleSolver = on
    featureStates["Riddle solver"] = on
    saveConfig()
    if autoWriteEnabled then appendConsoleStatus("Riddle solver", on) end
    pcall(function()
        local card = Settings:FindFirstChild("AIRiddles")
        if not card then return end
        local btn = card:FindFirstChild("State")
        if not btn then return end
        local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(btn, ti, {
            BackgroundColor3 = on and COLORS.Accent or COLORS.Control,
            TextColor3 = on and COLORS.Window or COLORS.Dim,
        }):Play()
        btn.Text = on and "ON" or "OFF"
    end)
end

function setRetypeInvalidEnabled(on)
    if _retypeInvalid == on then return end
    _retypeInvalid = on
    savedConfig.retypeInvalid = on
    featureStates["Retype invalid"] = on
    saveConfig()
    if autoWriteEnabled then appendConsoleStatus("Retype invalid", on) end
    pcall(function()
        local card = Settings:FindFirstChild("RetypeInvalid")
        if not card then return end
        local btn = card:FindFirstChild("State")
        if not btn then return end
        local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(btn, ti, {
            BackgroundColor3 = on and COLORS.Accent or COLORS.Control,
            TextColor3 = on and COLORS.Window or COLORS.Dim,
        }):Play()
        btn.Text = on and "ON" or "OFF"
    end)
end

function setAutoFarmEnabled(on)
    if _autoFarm == on then return end
    _autoFarm = on
    savedConfig.autoFarm = on
    featureStates["Auto farm"] = on
    if on then pcall(autoBuyStart) else pcall(autoBuyStop) end
    saveConfig()
    if autoWriteEnabled then appendConsoleStatus("Auto farm", on) end
    pcall(function()
        local card = Settings:FindFirstChild("AutoFarm")
        if not card then return end
        local btn = card:FindFirstChild("State")
        if not btn then return end
        local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(btn, ti, {
            BackgroundColor3 = on and COLORS.Gold or COLORS.Control,
            TextColor3 = on and COLORS.Window or COLORS.Dim,
        }):Play()
        btn.Text = on and "ON" or "OFF"
    end)
    if on then
        setStatus("Auto farm ON", COLORS.Gold)
    else
        setStatus("Auto farm OFF", COLORS.Dim)
    end
end

_keybindListener = UserInputService.InputBegan:Connect(function(input, gpe)
    if _listeningKB then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if gpe or UserInputService:GetFocusedTextBox() then return end
    local kc = input.KeyCode
    if keyMatches("kbCodeSniper", kc) then
        toggleAutoWrite()
    elseif keyMatches("kbAutoSubmit", kc) then
        setAutoSubmitEnabled(not _autoAccept)
    elseif keyMatches("kbRiddleSolver", kc) then
        setRiddleSolverEnabled(not _riddleSolver)
    elseif keyMatches("kbRetypeInvalid", kc) then
        setRetypeInvalidEnabled(not _retypeInvalid)
    elseif keyMatches("kbAutoFarm", kc) then
        setAutoFarmEnabled(not _autoFarm)
    elseif keyMatches("kbManualSubmit", kc) then
        if type(manualSubmitNow) == "function" then pcall(manualSubmitNow) end
    end
end)

task.spawn(function()
    for _ = 1, 8 do
        pcall(function()
            local pg = playerGui or (player and player:FindFirstChild("PlayerGui"))
            if not pg then return end
            local codesGui = pg:FindFirstChild("Codes")
            if codesGui then
                if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end
                local fr = codesGui:FindFirstChild("Codes")
                if fr and fr:IsA("GuiObject") then fr.Visible = true end
                if type(nxcCodeBox) == "function" then
                    local b = nxcCodeBox()
                    if b then _lastBox = b; _cachedBox = b; _cachedBoxTime = tick() end
                end
            end
        end)
        task.wait(0.1)
    end
end)

if getgenv then
    getgenv().StopAura = function()
        pcall(function()
            if RunService.UnbindFromRenderStep then
                RunService:UnbindFromRenderStep("NxcCodeSniperFlush")
            end
        end)
        if ListenConnection then
            pcall(function() ListenConnection:Disconnect() end)
            ListenConnection = nil
        end
        if getgenv().CodeSniperNotifyConnection then
            pcall(function() getgenv().CodeSniperNotifyConnection:Disconnect() end)
            getgenv().CodeSniperNotifyConnection = nil
        end
        if getgenv().NxcOGSniperGui then
            pcall(function() getgenv().NxcOGSniperGui:Destroy() end)
            getgenv().NxcOGSniperGui = nil
        end
        _instanceRunning = false
        pcall(autoBuyStop)
        if _ragdollConnection then pcall(function() _ragdollConnection:Disconnect() end) end
        if _targetWatcherListener then _targetWatcherListener:Disconnect() end
        if _codeboxRemovedListener then _codeboxRemovedListener:Disconnect() end
        if _codeboxAutoLinkConn then _codeboxAutoLinkConn:Disconnect() end
        if _feedbackAddedListener then _feedbackAddedListener:Disconnect() end
        if _keybindListener then _keybindListener:Disconnect() end
        if _boxFocusedListener then _boxFocusedListener:Disconnect() end
        if _focusReleasedListener then _focusReleasedListener:Disconnect() end
        if _characterListener then _characterListener:Disconnect() end
        for _, c in ipairs(_feedbackListeners) do pcall(function() c:Disconnect() end) end
        table.clear(_feedbackListeners)
        pcall(clearBoxWatchers)
        _G.NxcPulseRefs = nil
        if Window then Window:Destroy() end
        if GUI then GUI:Destroy() end
    end
end


task.defer(function()
  local __novaOk, __novaErr = pcall(function()
    if not _instanceRunning or not GUI or not GUI.Parent then return end
    if Window then Window.Visible = false; Window.Parent = nil end
    local prior = GUI:FindFirstChild("NovaInterface")
    if prior then prior:Destroy() end
    local oldDock = GUI:FindFirstChild("NxcMiniDock")
    if oldDock then oldDock:Destroy() end

    local P = {
        bg=Color3.fromRGB(5,8,16), panel=Color3.fromRGB(10,16,29),
        card=Color3.fromRGB(15,24,41), raised=Color3.fromRGB(25,38,61),
        stroke=Color3.fromRGB(57,82,119), white=Color3.fromRGB(248,251,255),
        quiet=Color3.fromRGB(214,226,245), dim=Color3.fromRGB(132,153,184),
        good=Color3.fromRGB(91,224,183), bad=Color3.fromRGB(255,89,116),
        accent=Color3.fromRGB(55,157,255), red=Color3.fromRGB(255,70,98)
    }
    local ACCENTS={BLUE=Color3.fromRGB(55,157,255),RED=Color3.fromRGB(255,70,98),WHITE=Color3.fromRGB(235,244,255)}
    local DEFAULT_IMG="rbxassetid://129085053275432"
    local NXC_LOGO_ASSET_ID="0"
    local STYLE_PATH="NxcHub_Appearance.json"
    local skin={wallpaper="129085053275432",custom="",accent="BLUE",uiScale=1,particles=true,
        wallpaperOpacity=.60,logo=NXC_LOGO_ASSET_ID}
    pcall(function()
        if type(isfile)=="function" and type(readfile)=="function" and isfile(STYLE_PATH) then
            local read=HttpService:JSONDecode(readfile(STYLE_PATH))
            if type(read)=="table" then
                for k,v in pairs(read) do
                    if skin[k]~=nil and typeof(skin[k])==typeof(v) then skin[k]=v end
                end
            end
        end
    end)
    local function persist()
        pcall(function()
            if type(writefile)=="function" then writefile(STYLE_PATH,HttpService:JSONEncode(skin)) end
        end)
    end
    P.accent=ACCENTS[skin.accent] or ACCENTS.BLUE
    local function mk(kind,parent,properties)
        local object=Instance.new(kind)
        for k,v in pairs(properties or {}) do object[k]=v end
        object.Parent=parent
        return object
    end
    local function curve(o,r)
        mk("UICorner",o,{CornerRadius=UDim.new(0,r or 17)})
        return o
    end
    local function edge(o,c,a,w)
        return mk("UIStroke",o,{Color=c or P.stroke,Transparency=a or .55,Thickness=w or 1})
    end
    local function shade(o,from,to,angle)
        return mk("UIGradient",o,{Color=ColorSequence.new(from,to),Rotation=angle or 90})
    end
    local function tw(o,properties,duration)
        if o and o.Parent then
            TweenService:Create(o,TweenInfo.new(duration or .21,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),properties):Play()
        end
    end
    local function text(parent,value,size,color,font,props)
        local x={BackgroundTransparency=1,Text=value or "",TextColor3=color or P.white,
            Font=font or Enum.Font.GothamMedium,TextSize=size or 13,
            TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,
            TextTruncate=Enum.TextTruncate.AtEnd,Size=UDim2.new(1,0,0,(size or 13)+10)}
        for k,v in pairs(props or {}) do x[k]=v end
        return mk("TextLabel",parent,x)
    end
    local function button(parent,title,fn,filled)
        local b=curve(mk("TextButton",parent,{Text=title,TextSize=12,Font=Enum.Font.GothamBold,
            BackgroundColor3=filled and P.accent or P.raised,TextColor3=filled and P.bg or P.white,
            AutoButtonColor=false,BorderSizePixel=0,ZIndex=44}),11)
        if not filled then edge(b,P.stroke,.67) end
        b.MouseEnter:Connect(function() tw(b,{BackgroundTransparency=.13},.14) end)
        b.MouseLeave:Connect(function() tw(b,{BackgroundTransparency=0},.14) end)
        if fn then b.Activated:Connect(fn) end
        return b
    end
    local fontFace=nil
    local branding={}
    local fontStatus=nil
    local root,dock
    local function applyStarbornTo(object)
        if not fontFace or not object or not object.Parent then return end
        if object:IsA("TextLabel") and object:GetAttribute("NxcStarbornHeading") then
            pcall(function() object.FontFace=fontFace end)
        end
    end
    local function titleFont(label)
        label:SetAttribute("NxcStarbornHeading",true)
        branding[#branding+1]=label
        applyStarbornTo(label)
        return label
    end
    local function setFontStatus(message,color)
        if fontStatus and fontStatus.Parent then
            fontStatus.Text=message
            fontStatus.TextColor3=color or P.dim
        end
    end
    local function loadConfuserStarborn()
        local env=(type(getgenv)=="function" and getgenv()) or _G
        local function api(name)
            if type(env[name])=="function" then return env[name] end
            if type(_G[name])=="function" then return _G[name] end
            return nil
        end
        local writer=api("writefile")
        local reader=api("readfile")
        local existsFn=api("isfile")
        local custom=api("getcustomasset") or api("getsynasset")
        if not custom then
            pcall(function()
                if syn and type(syn.getcustomasset)=="function" then
                    custom=syn.getcustomasset
                end
            end)
        end
        if not writer or not custom then
            setFontStatus("SYSTEM FONT  /  LOCAL ASSETS UNAVAILABLE",P.dim)
            return
        end

        local fontPath="solar_starborn.ttf"
        local manifestPath="solar_starborn_font.json"
        local function validTTF(data)
            if type(data)~="string" or #data<1000 then return false end
            local magic=data:sub(1,4)
            return magic==string.char(0,1,0,0) or magic=="OTTO" or magic=="true"
        end
        local validCache=false
        if reader then
            local ok,result=pcall(reader,fontPath)
            validCache=ok and validTTF(result)
        elseif existsFn then
            local ok,result=pcall(existsFn,fontPath)
            validCache=ok and result==true
        end
        if not validCache then
            setFontStatus("DOWNLOADING STARBORN",P.accent)
            local ok,data=pcall(function()
            end)
            if not ok or not validTTF(data) then
                setFontStatus("STARBORN UNAVAILABLE  /  SYSTEM FONT",P.bad)
                return
            end
            local saved=pcall(writer,fontPath,data)
            if not saved then
                setFontStatus("STARBORN CACHE ERROR  /  SYSTEM FONT",P.bad)
                return
            end
        end
        local ok,face=pcall(function()
            writer(manifestPath,HttpService:JSONEncode({name="Starborn",faces={{
                name="Regular",weight=400,style="normal",assetId=custom(fontPath)
            }}}))
            return Font.new(custom(manifestPath))
        end)
        if not ok or not face then
            setFontStatus("STARBORN LOAD FAILED  /  SYSTEM FONT",P.bad)
            return
        end
        if not root.Parent then return end
        fontFace=face
        for _,heading in ipairs(branding) do
            applyStarbornTo(heading)
        end
        setFontStatus("STARBORN  /  LOADED",P.good)
    end

    root=curve(mk("Frame",GUI,{Name="NovaInterface",Size=UDim2.fromOffset(724,520),
        Position=UDim2.fromScale(.5,.5),AnchorPoint=Vector2.new(.5,.5),
        BackgroundColor3=P.bg,BorderSizePixel=0,ClipsDescendants=true,Active=true,ZIndex=20}),24)
    local __sc=mk("UIScale",root,{Scale=math.clamp(tonumber(skin.uiScale) or 1,.5,1.6)})
    local outerLine=edge(root,Color3.fromRGB(255,255,255),.18,1.5)
    local SC={grads={}}
    do
        local function dual(o)
            local g=mk("UIGradient",o,{Rotation=0,Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,P.accent),ColorSequenceKeypoint.new(.5,Color3.fromRGB(255,255,255)),
                ColorSequenceKeypoint.new(1,P.red)})})
            SC.grads[#SC.grads+1]=g
        end
        dual(outerLine)
        SC.dual=dual
    end
    local wallpaper=mk("ImageLabel",root,{Name="BackgroundImage",Image=DEFAULT_IMG,
        ScaleType=Enum.ScaleType.Crop,ImageTransparency=.60,
        BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=21})
    curve(wallpaper,24)
    local darkOverlay=mk("Frame",root,{Size=UDim2.fromScale(1,1),
        BackgroundColor3=P.bg,BackgroundTransparency=.23,BorderSizePixel=0,ZIndex=22})
    curve(darkOverlay,24)
    shade(darkOverlay,Color3.fromRGB(3,3,7),Color3.fromRGB(12,8,18),25)
    local ambience=mk("Frame",root,{Name="AuroraSheen",Size=UDim2.new(1,0,0,110),
        BackgroundColor3=P.accent,BackgroundTransparency=.94,BorderSizePixel=0,ZIndex=23})
    shade(ambience,Color3.fromRGB(20,50,150),Color3.fromRGB(4,4,10),90)
    local topRule=mk("Frame",root,{Size=UDim2.new(1,-38,0,2),Position=UDim2.fromOffset(19,0),
        BackgroundColor3=P.accent,BorderSizePixel=0,ZIndex=30})
    curve(topRule,2)
    SC.dual(topRule)
    local stars=mk("Frame",root,{Name="Starfield",Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,ClipsDescendants=true,ZIndex=23})
    local starList={}
    local rand=Random.new(2503)
    for i=1,26 do
        local d=(i%6==0) and 3 or 2
        local star=curve(mk("Frame",stars,{Size=UDim2.fromOffset(d,d),
            Position=UDim2.fromScale(rand:NextNumber(.03,.97),rand:NextNumber(.03,.96)),
            BackgroundColor3=P.accent,BackgroundTransparency=rand:NextNumber(.62,.88),
            BorderSizePixel=0,ZIndex=23}),3)
        starList[#starList+1]=star
    end
    stars.Visible=skin.particles

    local rail=curve(mk("Frame",root,{Name="NavigationRail",Size=UDim2.fromOffset(170,520),
        BackgroundColor3=P.panel,BackgroundTransparency=.015,BorderSizePixel=0,ZIndex=31}),21)
    shade(rail,Color3.fromRGB(10,10,18),Color3.fromRGB(3,3,7),90)
    local railPicture=mk("ImageLabel",rail,{Name="RailWallpaper",Image=DEFAULT_IMG,
        Size=UDim2.fromScale(1,1),ImageColor3=Color3.fromRGB(150,160,255),
        ImageTransparency=.90,ScaleType=Enum.ScaleType.Crop,
        BackgroundTransparency=1,ZIndex=31})
    curve(railPicture,21)
    local railFog=mk("Frame",rail,{Size=UDim2.fromScale(1,1),
        BackgroundColor3=P.panel,BackgroundTransparency=.25,
        BorderSizePixel=0,ZIndex=32})
    curve(railFog,21)
    shade(railFog,Color3.fromRGB(6,6,12),Color3.fromRGB(2,2,5),90)
    local railBorder=mk("Frame",rail,{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=P.red,BackgroundTransparency=.45,BorderSizePixel=0,ZIndex=32})
    local avatarUri="rbxthumb://type=AvatarHeadShot&id="..tostring(player.UserId).."&w=150&h=150"
    local emblem=curve(mk("Frame",rail,{Name="AvatarFrame",Size=UDim2.fromOffset(24,24),
        Position=UDim2.fromOffset(41,42),BackgroundColor3=P.raised,
        BorderSizePixel=0,ZIndex=38}),12)
    local avatarEdge=edge(emblem,P.accent,.08,1.65)
    local avatarImage=curve(mk("ImageLabel",emblem,{Name="Headshot",Image=avatarUri,
        Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2,2),
        BackgroundTransparency=1,ScaleType=Enum.ScaleType.Crop,ZIndex=39}),12)
    local brand=titleFont(text(rail,"CALCIUM HUB",16,P.white,Enum.Font.GothamBlack,
        {Size=UDim2.fromOffset(94,22),Position=UDim2.fromOffset(72,16),ZIndex=34,
         TextScaled=true,TextTruncate=Enum.TextTruncate.None}))
    Instance.new("UITextSizeConstraint",brand).MaxTextSize=16
    local brandSub=text(rail,"CODE SNIPER",9,P.accent,Enum.Font.GothamBold,
        {Size=UDim2.fromOffset(96,17),Position=UDim2.fromOffset(73,39),ZIndex=34})
    local brandLogoHolder=curve(mk("Frame",rail,{Name="NxcLogoBadge",
        Position=UDim2.fromOffset(13,13),Size=UDim2.fromOffset(43,43),
        BackgroundColor3=P.accent,BorderSizePixel=0,ZIndex=36}),22)
    local brandLogoImage=curve(mk("ImageLabel",brandLogoHolder,{
        Size=UDim2.new(1,-6,1,-6),Position=UDim2.fromOffset(3,3),
        BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,
        Image="",ZIndex=37}),19)
    local brandLogoFallback=text(brandLogoHolder,"C",23,P.bg,Enum.Font.GothamBlack,
        {Size=UDim2.fromScale(1,1),TextXAlignment=Enum.TextXAlignment.Center,ZIndex=38})
    local miniVersion=text(rail,"CALCIUM HUB  /  V1",10,P.dim,Enum.Font.GothamBold,
        {Position=UDim2.new(0,18,1,-33),Size=UDim2.new(1,-28,0,18),ZIndex=34})
    local navWrap=mk("ScrollingFrame",rail,{Name="Navigation",Size=UDim2.new(1,-14,1,-142),
        Position=UDim2.fromOffset(7,95),BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.Y,
        CanvasSize=UDim2.new(0,0,0,290),ZIndex=33})
    local MENU={{"Home","01"},{"Sniper","02"},{"Intel","03"},{"Settings","04"},{"Logs","05"}}
    local navButtons={}
    local navLabels={}
    local navBars={}
    local current="Home"
    for i,item in ipairs(MENU) do
        local name,symbol=item[1],item[2]
        local nav=curve(mk("TextButton",navWrap,{Name="Go"..name,Text="",
            Size=UDim2.new(1,-6,0,47),Position=UDim2.fromOffset(3,(i-1)*54),
            BackgroundColor3=P.raised,BackgroundTransparency=1,
            BorderSizePixel=0,AutoButtonColor=false,ZIndex=34}),11)
        navButtons[name]=nav
        navLabels[name]=text(nav,name,12,P.quiet,Enum.Font.GothamBold,
            {Position=UDim2.fromOffset(47,0),Size=UDim2.new(1,-53,1,0),ZIndex=36})
        text(nav,symbol,19,P.accent,Enum.Font.GothamBold,
            {Position=UDim2.fromOffset(12,0),Size=UDim2.fromOffset(27,47),TextXAlignment=Enum.TextXAlignment.Center,ZIndex=36})
        navBars[name]=curve(mk("Frame",nav,{Size=UDim2.fromOffset(3,26),
            Position=UDim2.fromOffset(0,11),BackgroundColor3=P.accent,
            BackgroundTransparency=1,BorderSizePixel=0,ZIndex=36}),3)
    end

    local header=mk("Frame",root,{Name="DragHeader",BackgroundTransparency=1,
        Position=UDim2.fromOffset(170,0),Size=UDim2.new(1,-170,0,73),
        Active=true,ZIndex=35})
    local upper=text(header,"CALCIUM HUB  /  CONTROL CENTER",9,P.accent,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(19,10),Size=UDim2.new(1,-220,0,16),ZIndex=36})
    local pageTitle=titleFont(text(header,"Dashboard",23,P.white,Enum.Font.GothamBlack,
        {Position=UDim2.fromOffset(17,29),Size=UDim2.new(1,-220,0,30),ZIndex=36}))
    local statusPill=curve(mk("Frame",header,{Size=UDim2.fromOffset(80,27),
        Position=UDim2.new(1,-206,0,25),BackgroundColor3=P.raised,BorderSizePixel=0,ZIndex=36}),13)
    local pillDot=curve(mk("Frame",statusPill,{Size=UDim2.fromOffset(7,7),
        Position=UDim2.fromOffset(12,10),BackgroundColor3=P.good,BorderSizePixel=0,ZIndex=37}),4)
    local pillText=text(statusPill,"LIVE",10,P.good,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(27,0),Size=UDim2.new(1,-30,1,0),ZIndex=37})
    edge(statusPill,P.stroke,.64,1)
    local minimize=button(header,"−",nil,false)
    minimize.Name="Minimize"
    minimize.Position=UDim2.new(1,-37,0,23)
    minimize.Size=UDim2.fromOffset(29,29)
    local scaleDownBtn=button(header,"−",function() if SC.change then SC.change(-.1) end end,false)
    scaleDownBtn.Name="ScaleDown";scaleDownBtn.Position=UDim2.new(1,-109,0,23)
    scaleDownBtn.Size=UDim2.fromOffset(29,29);scaleDownBtn.TextSize=21
    local scaleUpBtn=button(header,"+",function() if SC.change then SC.change(.1) end end,false)
    scaleUpBtn.Name="ScaleUp";scaleUpBtn.Position=UDim2.new(1,-73,0,23)
    scaleUpBtn.Size=UDim2.fromOffset(29,29);scaleUpBtn.TextSize=19
    minimize.TextSize=21
    local workspaceShell=curve(mk("Frame",root,{Name="WorkspaceShell",
        Position=UDim2.fromOffset(177,70),Size=UDim2.new(1,-185,1,-77),
        BackgroundColor3=P.panel,BackgroundTransparency=.13,
        BorderSizePixel=0,ZIndex=31}),19)
    edge(workspaceShell,P.stroke,.82,1)
    local pagesWrap=mk("Frame",root,{Name="PageWorkspace",BackgroundTransparency=1,
        Position=UDim2.fromOffset(189,85),Size=UDim2.new(1,-201,1,-101),
        ClipsDescendants=true,ZIndex=32})
    local pages={}
    for _,item in ipairs(MENU) do
        local pg=mk("ScrollingFrame",pagesWrap,{Name=item[1],Size=UDim2.fromScale(1,1),
            BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
            ScrollBarImageColor3=P.accent,CanvasSize=UDim2.fromOffset(0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,ZIndex=33})
        mk("UIPadding",pg,{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,15),
            PaddingLeft=UDim.new(0,3),PaddingRight=UDim.new(0,7)})
        mk("UIListLayout",pg,{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder})
        pages[item[1]]=pg
    end
    local function card(parent,height)
        local c=curve(mk("Frame",parent,{BackgroundColor3=P.panel,BackgroundTransparency=0,
            BorderSizePixel=0,Size=UDim2.new(1,-4,0,height),ZIndex=34}),17)
        edge(c,P.stroke,.67)
        shade(c,Color3.fromRGB(24,24,38),Color3.fromRGB(9,9,15),115)
        return c
    end
    local function section(parent,title)
        local c=mk("Frame",parent,{Size=UDim2.new(1,-4,0,27),BackgroundTransparency=1,ZIndex=34})
        curve(mk("Frame",c,{Position=UDim2.fromOffset(0,6),Size=UDim2.fromOffset(3,15),
            BackgroundColor3=P.accent,BorderSizePixel=0,ZIndex=35}),2)
        text(c,title:upper(),11,P.quiet,Enum.Font.GothamBold,
            {Position=UDim2.fromOffset(12,1),Size=UDim2.new(1,-12,0,24),ZIndex=35})
        return c
    end
    local spotlights={}
    local function pageSpotlight(parent,kicker,headline,mark)
        local art=curve(mk("Frame",parent,{Name="PageSpotlight",LayoutOrder=-100,
            Size=UDim2.new(1,-4,0,101),BackgroundColor3=P.card,
            BorderSizePixel=0,ClipsDescendants=true,ZIndex=34}),18)
        edge(art,P.accent,.65,1)
        shade(art,Color3.fromRGB(9,52,105),Color3.fromRGB(24,17,39),0)
        local strip=curve(mk("Frame",art,{Size=UDim2.fromOffset(5,45),
            Position=UDim2.fromOffset(15,27),BackgroundColor3=P.accent,
            BorderSizePixel=0,ZIndex=35}),5)
        text(art,kicker,10,P.accent,Enum.Font.GothamBold,{Position=UDim2.fromOffset(26,17),
            Size=UDim2.new(1,-102,0,21),ZIndex=36})
        titleFont(text(art,headline,21,P.white,Enum.Font.GothamBlack,
            {Position=UDim2.fromOffset(24,43),Size=UDim2.new(1,-125,0,33),ZIndex=36}))
        local stamp=curve(mk("Frame",art,{AnchorPoint=Vector2.new(1,.5),
            Position=UDim2.new(1,-20,.5,0),Size=UDim2.fromOffset(58,58),
            BackgroundColor3=P.accent,BackgroundTransparency=.89,
            BorderSizePixel=0,ZIndex=35}),20)
        edge(stamp,P.accent,.52,1)
        local markText=text(stamp,mark,25,P.accent,Enum.Font.GothamBlack,
            {Size=UDim2.fromScale(1,1),TextXAlignment=Enum.TextXAlignment.Center,ZIndex=36})
        spotlights[#spotlights+1]={strip=strip,frame=art,stamp=stamp,label=markText}
        return art
    end
    local refresh={}
    local themed={}
    local function track(obj,kind) themed[#themed+1]={obj=obj,kind=kind};return obj end
    local function group(parent,titles,entries)
        local height=10+#entries*48
        local c=card(parent,height)
        if titles then text(c,titles:upper(),10,P.dim,Enum.Font.GothamBold,
            {Position=UDim2.fromOffset(14,6),Size=UDim2.new(1,-28,0,15),ZIndex=35}) end
        for i,item in ipairs(entries) do
            local y=(i-1)*48+(titles and 19 or 0)
            if i>1 then
                mk("Frame",c,{Position=UDim2.fromOffset(13,y),Size=UDim2.new(1,-26,0,1),
                    BackgroundColor3=P.stroke,BackgroundTransparency=.79,BorderSizePixel=0,ZIndex=35})
            end
            local btn=mk("TextButton",c,{Position=UDim2.fromOffset(9,y+2),Size=UDim2.new(1,-18,0,43),
                BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=36})
            text(btn,item[1],12,P.white,Enum.Font.GothamBold,
                {Position=UDim2.fromOffset(7,0),Size=UDim2.new(1,-76,1,0),ZIndex=37})
            local switch=curve(mk("Frame",btn,{Size=UDim2.fromOffset(46,25),
                Position=UDim2.new(1,-56,.5,-12),BackgroundColor3=P.raised,BorderSizePixel=0,ZIndex=37}),13)
            local nub=curve(mk("Frame",switch,{Size=UDim2.fromOffset(17,17),
                Position=UDim2.fromOffset(4,4),BackgroundColor3=P.quiet,BorderSizePixel=0,ZIndex=38}),9)
            local last
            local function sync()
                if not btn.Parent then return end
                local v=item[2]() == true
                if v==last then return end
                last=v
                tw(switch,{BackgroundColor3=v and P.accent or P.raised},.17)
                tw(nub,{Position=v and UDim2.fromOffset(25,4) or UDim2.fromOffset(4,4),
                    BackgroundColor3=v and P.bg or P.quiet},.17)
            end
            btn.Activated:Connect(function()
                item[3](not item[2]())
                sync()
            end)
            refresh[#refresh+1]=sync
            sync()
        end
        return c
    end
    local function updateAll()
        for _,fn in ipairs(refresh) do pcall(fn) end
        local online=autoWriteEnabled==true
        local c=online and P.good or P.bad
        pillDot.BackgroundColor3=c
        pillText.Text=online and "LIVE" or "PAUSED"
        pillText.TextColor3=c
    end
    local function navigate(name)
        if not pages[name] then return end
        current=name
        for n,p in pairs(pages) do p.Visible=n==name end
        pageTitle.Text=({Home="Dashboard",Intel="Riddle Intel",Settings="Settings",Sniper="Sniper",Logs="Activity"})[name] or name
        for n,b in pairs(navButtons) do
            local selected=(n==name)
            tw(b,{BackgroundTransparency=selected and .03 or 1,
                BackgroundColor3=selected and P.raised or P.panel},.18)
            navLabels[n].TextColor3=selected and P.white or P.quiet
            navBars[n].BackgroundTransparency=selected and 0 or 1
        end
        updateAll()
    end
    for name,btn in pairs(navButtons) do
        btn.Activated:Connect(function() navigate(name) end)
        btn.MouseEnter:Connect(function()
            if current~=name then tw(btn,{BackgroundTransparency=.58},.14) end
        end)
        btn.MouseLeave:Connect(function()
            if current~=name then tw(btn,{BackgroundTransparency=1},.14) end
        end)
    end

    local home=pages.Home
    local hero=card(home,177)
    hero.ClipsDescendants=true
    local heroArt=mk("ImageLabel",hero,{Size=UDim2.fromScale(1,1),Image=DEFAULT_IMG,
        ScaleType=Enum.ScaleType.Crop,ImageTransparency=.44,BackgroundTransparency=1,ZIndex=35})
    curve(heroArt,17)
    local heroTint=mk("Frame",hero,{Size=UDim2.fromScale(1,1),
        BackgroundColor3=P.panel,BackgroundTransparency=.4,BorderSizePixel=0,ZIndex=36})
    shade(heroTint,Color3.fromRGB(6,10,30),Color3.fromRGB(34,8,16),0)
    text(hero,"CALCIUM SYSTEMS  /  V12",10,P.accent,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(17,15),Size=UDim2.new(1,-36,0,18),ZIndex=39})
    titleFont(text(hero,"CALCIUM HUB",23,P.white,Enum.Font.GothamBlack,
        {Position=UDim2.fromOffset(15,41),Size=UDim2.new(1,-40,0,32),ZIndex=39}))
    local heroLight=mk("Frame",hero,{Size=UDim2.fromOffset(104,2),
        Position=UDim2.fromOffset(18,84),BackgroundColor3=P.accent,
        BorderSizePixel=0,ZIndex=39})
    local crosshair=mk("Frame",hero,{AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.new(1,-77,0,78),Size=UDim2.fromOffset(100,100),
        BackgroundTransparency=1,ZIndex=38})
    curve(crosshair,52)
    local targetEdge=edge(crosshair,P.accent,.38,1.5)
    local bull=curve(mk("Frame",crosshair,{AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(35,35),
        BackgroundTransparency=1,ZIndex=39}),23)
    edge(bull,P.accent,.42)
    local centerPoint=curve(mk("Frame",bull,{AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(7,7),
        BackgroundColor3=P.accent,BorderSizePixel=0,ZIndex=40}),7)
    edge(centerPoint,P.white,.32,1)
    mk("Frame",crosshair,{Position=UDim2.new(.5,0,0,12),Size=UDim2.fromOffset(1,76),
        BackgroundColor3=P.accent,BackgroundTransparency=.4,BorderSizePixel=0,ZIndex=39})
    mk("Frame",crosshair,{Position=UDim2.new(0,12,.5,0),Size=UDim2.fromOffset(76,1),
        BackgroundColor3=P.accent,BackgroundTransparency=.4,BorderSizePixel=0,ZIndex=39})
    local engine=button(hero,"PAUSE SNIPER",function()
        setCodeSniperEnabled(not autoWriteEnabled)
        updateAll()
    end,true)
    track(engine,"primary")
    engine.Position=UDim2.fromOffset(16,119)
    engine.Size=UDim2.fromOffset(167,39)
    refresh[#refresh+1]=function()
        local v=autoWriteEnabled==true
        local str=v and "PAUSE SNIPER" or "START SNIPER"
        if engine.Text~=str then engine.Text=str end
    end
    local heroState=text(hero,"●  ACTIVE",10,P.good,Enum.Font.GothamBold,
        {Position=UDim2.new(1,-106,1,-47),Size=UDim2.fromOffset(100,23),ZIndex=39})
    refresh[#refresh+1]=function()
        heroState.Text=autoWriteEnabled and "●  ACTIVE" or "●  PAUSED"
        heroState.TextColor3=autoWriteEnabled and P.good or P.bad
    end

    section(home,"System")
    local live=card(home,90)
    local telemetry=text(live,"— ms",23,P.accent,Enum.Font.GothamBlack,
        {Position=UDim2.fromOffset(15,18),Size=UDim2.new(.45,-14,0,31),ZIndex=35})
    local teleLabel=text(live,"LOCAL DISPATCH",9,P.dim,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(17,57),Size=UDim2.new(.5,-20,0,18),ZIndex=35})
    local vertical=mk("Frame",live,{Size=UDim2.fromOffset(1,54),Position=UDim2.new(.5,0,0,17),
        BackgroundColor3=P.stroke,BackgroundTransparency=.63,BorderSizePixel=0,ZIndex=36})
    local linkValue=text(live,"SEARCHING",12,P.accent,Enum.Font.GothamBold,
        {Position=UDim2.new(.5,15,0,20),Size=UDim2.new(.5,-25,0,29),ZIndex=36})
    text(live,"CODEBOX LINK",9,P.dim,Enum.Font.GothamBold,
        {Position=UDim2.new(.5,15,0,55),Size=UDim2.new(.5,-22,0,18),ZIndex=36})
    local quick=card(home,89)
    text(quick,"QUICK ACCESS",10,P.dim,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(14,9),Size=UDim2.new(1,-25,0,18),ZIndex=35})
    local quickActions={{"SNIPER","Sniper"},{"INTEL","Intel"},{"LOGS","Logs"}}
    for i,v in ipairs(quickActions) do
        local b=button(quick,v[1].."  ›",function() navigate(v[2]) end)
        b.Position=UDim2.new((i-1)/3,10,0,39)
        b.Size=UDim2.new(1/3,-14,0,34)
        b.TextSize=10
    end

    local sniper=pages.Sniper
    pageSpotlight(sniper,"AUTOMATION  /  01","Sniper Engine","01")
    section(sniper,"Engine")
    group(sniper,nil,{
        {"Code sniper",function()return autoWriteEnabled end,setCodeSniperEnabled},
        {"Auto submit",function()return _autoAccept end,setAutoSubmitEnabled},
        {"Spam redeem",function()return _spamRedeem end,function(on)
            _spamRedeem=on;savedConfig.spamRedeem=on;featureStates["Spam redeem"]=on
            saveConfig()
        end},
    })
    section(sniper,"Submission")
    local after=card(sniper,84)
    text(after,"SUBMIT AFTER",11,P.white,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,11),Size=UDim2.new(1,-120,0,22),ZIndex=35})
    local countText=text(after,"1 ANNOUNCEMENT",13,P.accent,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,37),Size=UDim2.new(1,-125,0,26),ZIndex=35})
    local announceRail=curve(mk("Frame",after,{Position=UDim2.fromOffset(14,73),
        Size=UDim2.new(1,-29,0,3),BackgroundColor3=P.raised,
        BorderSizePixel=0,ZIndex=35}),2)
    local announceFill=curve(mk("Frame",announceRail,{Size=UDim2.fromScale(0,1),
        BackgroundColor3=P.accent,BorderSizePixel=0,ZIndex=36}),2)
    local minus=button(after,"−",function() safeDecr() end)
    minus.Position=UDim2.new(1,-88,0,28);minus.Size=UDim2.fromOffset(33,33);minus.TextSize=19
    local plus=button(after,"+",function() safeIncr() end)
    plus.Position=UDim2.new(1,-48,0,28);plus.Size=UDim2.fromOffset(33,33);plus.TextSize=18
    refresh[#refresh+1]=function()
        local amount=tonumber(_submitAfter) or 1
        local newText=tostring(amount)..(amount==1 and " ANNOUNCEMENT" or " ANNOUNCEMENTS")
        if countText.Text~=newText then countText.Text=newText end
        local filled=math.min(1,(#_capturedParts or 0)/math.max(1,amount))
        announceFill.Size=UDim2.fromScale(filled,1)
    end
    local submit=button(sniper,"SUBMIT NOW",function()
        if type(manualSubmitNow)=="function" then pcall(manualSubmitNow) end
    end,true)
    submit.Size=UDim2.new(1,-4,0,42)
    track(submit,"primary")
    section(sniper,"Automation")
    group(sniper,nil,{
        {"Riddle solver",function()return _riddleSolver end,setRiddleSolverEnabled},
        {"Retype invalid",function()return _retypeInvalid end,setRetypeInvalidEnabled},
        {"Auto farm",function()return _autoFarm end,setAutoFarmEnabled},
    })

    local intelPage=pages.Intel
    pageSpotlight(intelPage,"ANALYSIS  /  02","Riddle Intel","02")
    local intelHeader=card(intelPage,65)
    local intelStatus=text(intelHeader,"SYNCING GAME DATA",12,P.accent,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,9),Size=UDim2.new(1,-26,0,21),ZIndex=35})
    local intelCounts=text(intelHeader,"—",11,P.quiet,Enum.Font.GothamMedium,
        {Position=UDim2.fromOffset(13,35),Size=UDim2.new(1,-26,0,18),ZIndex=35})
    local refreshBtn=button(intelPage,"REFRESH INTEL",function()
        LiveRiddleIntel.requestRefresh(true)
    end,true)
    track(refreshBtn,"primary")
    refreshBtn.Size=UDim2.new(1,-4,0,37)
    local ranks={}
    for _,e in ipairs({{"Brainrots","income","generation","/s"},
            {"Mutations","mutations","modifier","×"},
            {"Traits","traits","modifier","×"}}) do
        local c=card(intelPage,100)
        text(c,e[1]:upper(),11,P.accent,Enum.Font.GothamBold,
            {Position=UDim2.fromOffset(12,7),Size=UDim2.new(1,-25,0,21),ZIndex=35})
        local best=text(c,"BEST   —",12,P.white,Enum.Font.GothamBold,
            {Position=UDim2.fromOffset(13,34),Size=UDim2.new(1,-25,0,23),ZIndex=35})
        local worst=text(c,"WORST   —",11,P.quiet,Enum.Font.GothamMedium,
            {Position=UDim2.fromOffset(13,63),Size=UDim2.new(1,-25,0,22),ZIndex=35})
        ranks[#ranks+1]={key=e[2],field=e[3],suffix=e[4],best=best,worst=worst}
    end
    local diag=card(intelPage,48)
    local diagText=text(diag,"DATA SOURCE: WAITING",10,P.quiet,Enum.Font.GothamMedium,
        {Position=UDim2.fromOffset(12,9),Size=UDim2.new(1,-24,0,30),ZIndex=36,
         TextWrapped=true,TextTruncate=Enum.TextTruncate.None})
    section(intelPage,"Live animal data")
    local liveCard=card(intelPage,108)
    local latestText=text(liveCard,"LATEST   UNAVAILABLE",12,P.white,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,10),Size=UDim2.new(1,-26,0,25),ZIndex=36})
    local dataSourcesText=text(liveCard,"MODULES   CONNECTING",11,P.accent,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,39),Size=UDim2.new(1,-26,0,24),ZIndex=36})
    local observedText=text(liveCard,"NEW IN THIS SESSION   —",10,P.quiet,Enum.Font.GothamMedium,
        {Position=UDim2.fromOffset(13,70),Size=UDim2.new(1,-26,0,22),ZIndex=36})
    section(intelPage,"Riddle lookup")
    local riddleCard=card(intelPage,164)
    local riddleInput=curve(mk("TextBox",riddleCard,{Text="",PlaceholderText="Enter riddle...",
        PlaceholderColor3=P.dim,ClearTextOnFocus=false,TextColor3=P.white,
        TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamMedium,TextSize=12,
        Size=UDim2.new(1,-24,0,38),Position=UDim2.fromOffset(12,11),
        BackgroundColor3=P.raised,BorderSizePixel=0,ZIndex=36}),9)
    mk("UIPadding",riddleInput,{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)})
    local answer=text(riddleCard,"ANSWER  —",12,P.accent,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,108),Size=UDim2.new(1,-24,0,40),ZIndex=36})
    local riddleRun=button(riddleCard,"SOLVE RIDDLE",nil,true)
    riddleRun.Size=UDim2.new(1,-24,0,33)
    riddleRun.Position=UDim2.fromOffset(12,57)
    local riddleGeneration=0
    local riddleBusy=false
    local function testRiddle()
        local query=tostring(riddleInput.Text or ""):match("^%s*(.-)%s*$")
        if query=="" then answer.Text="ANSWER  —";return end
        if riddleBusy then return end
        riddleGeneration+=1
        local generation=riddleGeneration
        riddleBusy=true
        answer.Text="SOLVING..."
        riddleRun.Text="CHECKING..."
        task.spawn(function()
            local ok,result,_,reason=pcall(solveRiddle,query)
            if not riddleCard.Parent or generation~=riddleGeneration then return end
            local token=ok and type(result)=="string" and result:match("^%s*(.-)%s*$") or nil
            if token and token~="" then
                answer.Text="ANSWER  "..token
            else
                answer.Text=reason and tostring(reason):sub(1,85) or "NO VERIFIED MATCH"
            end
            riddleRun.Text="SOLVE RIDDLE"
            riddleBusy=false
        end)
    end
    riddleRun.Activated:Connect(testRiddle)
    riddleInput.FocusLost:Connect(function()
        task.defer(testRiddle)
    end)
    local function updateIntel()
        local intel=LiveRiddleIntel
        if intel.busy then intelStatus.Text="READING GAME DATA..."
        elseif intel.ready then
            local rr=intel.rankings or {}
            local complete=(rr.income and #rr.income>0 and rr.mutations and #rr.mutations>0
                and rr.traits and #rr.traits>0)
            intelStatus.Text=(complete and "RANKINGS READY" or "PARTIAL GAME DATA")
                .."  |  REV "..tostring(intel.version)
        else intelStatus.Text="NO REPLICATED METADATA" end
        local counts=intel.counts or {}
        local src=intel.sources or {}
        intelCounts.Text=("%d animals / %d mutations / %d traits | %s"):
            format(counts.animals or 0,counts.mutations or 0,counts.traits or 0,
                tostring(src.animals or "waiting"))
        latestText.Text=intel.latestAnimal and ("LATEST CANDIDATE  "..intel.latestAnimal)
            or "LATEST   UNAVAILABLE"
        if intel.latestSource and intel.latestSource:find("Complete",1,true) then
            latestText.Text="LATEST  "..intel.latestAnimal
        end
        local active={}
        for _,name in ipairs({"ANIMALS","MUTATIONS","TRAITS"}) do
            local tableName=name:lower()
            if type(intel[tableName])=="table" and next(intel[tableName]) then
                active[#active+1]=name
            end
        end
        dataSourcesText.Text=#active>0 and ("CONNECTED  "..table.concat(active,"  /  ")) or "WAITING FOR GAME MODULES"
        local src=intel.sources or {}
        if intel.lastError then
            diagText.Text=tostring(intel.lastError):sub(1,180)
        else
            diagText.Text="ANIMALS: "..tostring(src.animals).."  |  MUT: "..tostring(src.mutations).."  |  TRAITS: "..tostring(src.traits)
        end
        local new=intel.observedNew or {}
        observedText.Text=#new>0 and ("NEWLY OBSERVED   "..table.concat(new,", "))
            or "NEWLY OBSERVED   —"
        for _,r in ipairs(ranks) do
            local list=intel.rankings[r.key] or {}
            if #list>0 then
                local hi,lo=list[1],list[#list]
                local function formatRank(entry)
                    local n=entry[r.field]
                    return tostring(entry.name)..(type(n)=="number" and ("  ·  "..string.format("%.3g",n)..r.suffix) or "")
                end
                r.best.Text="BEST   "..formatRank(hi)
                r.worst.Text=r.key=="income" and "WORST RIDDLE   Noobini Pizzanini"
                    or ("WORST   "..formatRank(lo))
            else
                r.best.Text="BEST   —"
                r.worst.Text=r.key=="income" and "WORST RIDDLE   Noobini Pizzanini"
                    or "WORST   —"
            end
        end
    end
    LiveRiddleIntel.onUpdated=updateIntel
    updateIntel()

    local settings=pages.Settings
    pageSpotlight(settings,"CUSTOMIZATION  /  03","Your Interface","03")
    section(settings,"Wallpapers")
    local confuserImageIds={"", "129085053275432", "126638309339233", "90211231416942",
        "138472956105442", "114535932585883", "133353928145895", "95372928362733",
        "82986133916631", "71086942427922", "116890020704841", "132870723653986",
        "140145334415261", "126519267203224", "73290556702979", "104138622888695",
        "90631990302263", "109619268613730", "88369503310562", "80708025126373",
        "135181794444219"}
    local imageButtons={}
    local applyWallpaper 
    local wallpaperOptions=card(settings,222)
    local bgCaption=text(wallpaperOptions,"GALLERY  /  20 BACKGROUNDS",10,P.dim,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(14,8),Size=UDim2.new(1,-28,0,19),ZIndex=35})
    local gallery=mk("ScrollingFrame",wallpaperOptions,{Name="ConfuserBackgroundGallery",
        Position=UDim2.fromOffset(12,34),Size=UDim2.new(1,-24,0,166),
        BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
        ScrollBarImageColor3=P.accent,ScrollingDirection=Enum.ScrollingDirection.X,
        CanvasSize=UDim2.new(0,1140,0,0),ZIndex=36})
    mk("UIGridLayout",gallery,{FillDirection=Enum.FillDirection.Vertical,
        FillDirectionMaxCells=2,SortOrder=Enum.SortOrder.LayoutOrder,
        CellSize=UDim2.fromOffset(96,72),CellPadding=UDim2.fromOffset(8,8)})
    for i,id in ipairs(confuserImageIds) do
        local tile=curve(mk("ImageButton",gallery,{Name="Preset"..tostring(i),
            Image=id=="" and "" or "rbxassetid://"..id,
            ImageTransparency=id=="" and 1 or 0,
            BackgroundColor3=P.raised,Size=UDim2.fromOffset(96,72),
            ScaleType=Enum.ScaleType.Crop,BorderSizePixel=0,LayoutOrder=i,
            AutoButtonColor=false,ZIndex=37}),12)
        local tileBorder=edge(tile,P.stroke,.55,1.1)
        local tileFog=curve(mk("Frame",tile,{Size=UDim2.fromScale(1,1),
            BackgroundColor3=P.bg,BackgroundTransparency=.8,
            BorderSizePixel=0,ZIndex=38}),12)
        local tileName=id=="" and "NONE" or ("BG "..string.format("%02d",i-1))
        text(tile,tileName,10,P.white,Enum.Font.GothamBold,
            {Position=UDim2.new(0,0,1,-23),Size=UDim2.new(1,0,0,21),
                TextXAlignment=Enum.TextXAlignment.Center,ZIndex=39})
        imageButtons[id=="" and "NONE" or id]={tile=tile,border=tileBorder}
        tile.Activated:Connect(function()
            skin.wallpaper=id=="" and "NONE" or id
            persist()
            applyWallpaper()
        end)
    end
    local imageCustom=card(settings,77)
    text(imageCustom,"CUSTOM IMAGE ID",10,P.dim,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(12,5),Size=UDim2.new(1,-25,0,17),ZIndex=35})
    local imageInput=curve(mk("TextBox",imageCustom,{Text=skin.custom,
        PlaceholderText="Custom image ID",PlaceholderColor3=P.dim,
        Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=P.white,
        TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,
        BackgroundColor3=P.raised,BorderSizePixel=0,
        Position=UDim2.fromOffset(11,32),Size=UDim2.new(1,-108,0,34),ZIndex=35}),11)
    mk("UIPadding",imageInput,{PaddingLeft=UDim.new(0,10)})
    local applyImage=button(imageCustom,"APPLY",function()
        local value=tostring(imageInput.Text or "")
        local raw=value:match("^%s*rbxassetid://(%d+)%s*$") or value:match("^%s*(%d+)%s*$")
        if not raw then
            imageInput.PlaceholderText="Numbers only"
            return
        end
        skin.custom=raw;skin.wallpaper="CUSTOM";persist();applyWallpaper()
    end,true)
    track(applyImage,"primary")
    applyImage.Position=UDim2.new(1,-87,0,32);applyImage.Size=UDim2.fromOffset(75,34)
    local logoSettingsCard=card(settings,74)
    text(logoSettingsCard,"CALCIUM HUB LOGO ASSET ID",10,P.dim,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,5),Size=UDim2.new(1,-25,0,18),ZIndex=35})
    local logoInput=curve(mk("TextBox",logoSettingsCard,{Text=tostring(skin.logo or "0"),
        PlaceholderText="Roblox logo image ID (0 = C)",PlaceholderColor3=P.dim,
        Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=P.white,
        TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,
        BackgroundColor3=P.raised,BorderSizePixel=0,
        Position=UDim2.fromOffset(11,30),Size=UDim2.new(1,-108,0,33),ZIndex=35}),12)
    mk("UIPadding",logoInput,{PaddingLeft=UDim.new(0,9)})
    local applyNxcLogo
    local logoApply=button(logoSettingsCard,"APPLY",function()
        local raw=logoInput.Text:match("^%s*rbxassetid://(%d+)%s*$")
            or logoInput.Text:match("^%s*(%d+)%s*$")
        if not raw then logoInput.Text="0";raw="0" end
        skin.logo=raw;persist()
        if applyNxcLogo then applyNxcLogo() end
    end,true)
    logoApply.Position=UDim2.new(1,-87,0,30)
    logoApply.Size=UDim2.fromOffset(75,33)
    local opacityCard=card(settings,61)
    text(opacityCard,"IMAGE VISIBILITY",11,P.white,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,7),Size=UDim2.new(1,-164,0,25),ZIndex=35})
    local opacityValue=text(opacityCard,"",11,P.accent,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(13,30),Size=UDim2.new(1,-165,0,22),ZIndex=35})
    local lowerOpacity=button(opacityCard,"−",nil)
    lowerOpacity.Position=UDim2.new(1,-97,0,13)
    lowerOpacity.Size=UDim2.fromOffset(37,34)
    lowerOpacity.TextSize=19
    local raiseOpacity=button(opacityCard,"+",nil)
    raiseOpacity.Position=UDim2.new(1,-51,0,13)
    raiseOpacity.Size=UDim2.fromOffset(37,34)
    raiseOpacity.TextSize=18
    local function changeOpacity(n)
        skin.wallpaperOpacity=math.clamp((tonumber(skin.wallpaperOpacity) or .60)+n,.12,.90)
        persist();applyWallpaper()
    end
    lowerOpacity.Activated:Connect(function() changeOpacity(-.08) end)
    raiseOpacity.Activated:Connect(function() changeOpacity(.08) end)
    section(settings,"Interface Scale")
    do
        local scaleCard=card(settings,63)
        SC.label=text(scaleCard,math.floor((tonumber(skin.uiScale) or 1)*100+.5).."%",18,P.accent,Enum.Font.GothamBlack,
            {Position=UDim2.fromOffset(16,0),Size=UDim2.new(1,-150,1,0),ZIndex=35})
        local sDown=button(scaleCard,"−",function() if SC.change then SC.change(-.1) end end)
        sDown.Position=UDim2.new(1,-97,0,14);sDown.Size=UDim2.fromOffset(37,35);sDown.TextSize=19
        local sUp=button(scaleCard,"+",function() if SC.change then SC.change(.1) end end)
        sUp.Position=UDim2.new(1,-51,0,14);sUp.Size=UDim2.fromOffset(37,35);sUp.TextSize=18
    end
    section(settings,"Accent")
    local accents=card(settings,63)
    local accentButtons={}
    for i,name in ipairs({"BLUE","RED","WHITE"}) do
        local b=button(accents,name,nil)
        b.Position=UDim2.new((i-1)/3,8,0,14)
        b.Size=UDim2.new(1/3,-12,0,35)
        accentButtons[name]=b
    end
    section(settings,"Typography")
    local fontCard=card(settings,55)
    text(fontCard,"STARBORN",13,P.white,Enum.Font.GothamBlack,
        {Position=UDim2.fromOffset(13,5),Size=UDim2.new(1,-26,0,23),ZIndex=35})
    fontStatus=text(fontCard,"LOADING LOCAL FONT",10,P.accent,Enum.Font.GothamMedium,
        {Position=UDim2.fromOffset(13,27),Size=UDim2.new(1,-26,0,18),ZIndex=35})
    group(settings,nil,{{"Starfield",function()return skin.particles end,function(v)
        skin.particles=v;stars.Visible=v;persist()
    end}})
    section(settings,"Hotkeys")
    local bindMap={{"Code sniper","kbCodeSniper"},{"Auto submit","kbAutoSubmit"},
        {"Riddle solver","kbRiddleSolver"},{"Retype invalid","kbRetypeInvalid"},
        {"Auto farm","kbAutoFarm"},{"Submit now","kbManualSubmit"}}
    local bindCard=card(settings,10+#bindMap*44)
    local listeningConn
    local listeningFor=nil
    for i,pair in ipairs(bindMap) do
        local display,key=pair[1],pair[2]
        local y=5+(i-1)*44
        text(bindCard,display,12,P.white,Enum.Font.GothamMedium,
            {Position=UDim2.fromOffset(13,y),Size=UDim2.new(1,-116,0,40),ZIndex=35})
        local bind=button(bindCard,tostring(savedConfig[key] or "NONE"),nil)
        bind.Position=UDim2.new(1,-103,0,y+5)
        bind.Size=UDim2.fromOffset(88,30)
        bind.TextSize=10
        refresh[#refresh+1]=function()
            if listeningFor~=key and bind.Parent then
                local value=tostring(savedConfig[key] or "NONE")
                if bind.Text~=value then bind.Text=value end
            end
        end
        bind.Activated:Connect(function()
            if listeningConn then listeningConn:Disconnect();listeningConn=nil end
            listeningFor=key;bind.Text="PRESS KEY"
            listeningConn=UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType~=Enum.UserInputType.Keyboard then return end
                if input.KeyCode==Enum.KeyCode.Escape then
                    savedConfig[key]=nil
                elseif input.KeyCode~=Enum.KeyCode.Unknown then
                    savedConfig[key]=input.KeyCode.Name
                else
                    return
                end
                saveConfig()
                listeningFor=nil
                bind.Text=tostring(savedConfig[key] or "NONE")
                listeningConn:Disconnect();listeningConn=nil
            end)
        end)
    end

    local logs=pages.Logs
    pageSpotlight(logs,"MONITOR  /  04","Activity Stream","04")
    section(logs,"Recent activity")
    local logPanel=card(logs,298)
    local logScroll=mk("ScrollingFrame",logPanel,{Position=UDim2.fromOffset(13,12),
        Size=UDim2.new(1,-26,1,-23),BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=3,ScrollBarImageColor3=P.accent,
        CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=35})
    local logText=text(logScroll,"Awaiting activity...",12,P.white,Enum.Font.GothamMedium,
        {TextWrapped=true,RichText=true,TextTruncate=Enum.TextTruncate.None,
        TextYAlignment=Enum.TextYAlignment.Top,LineHeight=1.35,
        AutomaticSize=Enum.AutomaticSize.Y,Size=UDim2.new(1,-8,0,0),ZIndex=36})
    local clearLog=button(logs,"CLEAR LOGS",function()
        if type(clearLogs)=="function" then pcall(clearLogs) end
        logText.Text="Activity cleared"
    end)
    clearLog.Size=UDim2.new(1,-4,0,39)

    local function skinOG()
        local ok,env=pcall(function() return (getgenv and getgenv()) or _G end)
        local ogGui=ok and env and env.NxcOGSniperGui
        if not ogGui or not ogGui.Parent then return end
        local ogRoot=ogGui:FindFirstChild("MainFrame")
        if not ogRoot then return end
        local bg=ogRoot:FindFirstChild("BgImage")
        if bg and bg:IsA("ImageLabel") then
            bg.Image=wallpaper.Image
            bg.ImageColor3=wallpaper.ImageColor3
            bg.ImageTransparency=.47
        end
        local dim=ogRoot:FindFirstChild("BgDim")
        if dim then dim.BackgroundColor3=P.bg;dim.BackgroundTransparency=.14 end
        ogRoot.BackgroundColor3=P.bg
        local border=ogRoot:FindFirstChildOfClass("UIStroke")
        if border then border.Color=P.accent;border.Transparency=.35 end
    end


    local dock, dockEdge, dockBg, dockLogo
    applyWallpaper=function()
        local id=tostring(skin.wallpaper or "")
        local img=""
        if id=="NONE" or id=="" then
            img=""
        elseif id=="CUSTOM" then
            local raw=tostring(skin.custom or ""):match("^%d+$" ) and skin.custom or ""
            img=raw~="" and "rbxassetid://"..raw or DEFAULT_IMG
        elseif id:match("^%d+$") then
            img="rbxassetid://"..id
        else
            img=DEFAULT_IMG
        end
        local visibility=math.clamp(tonumber(skin.wallpaperOpacity) or .60,.12,.90)
        wallpaper.Image=img
        wallpaper.ImageTransparency=img=="" and 1 or visibility
        heroArt.Image=img
        heroArt.ImageTransparency=img=="" and 1 or math.max(.40,visibility)
        railPicture.Image=img
        if dockBg then dockBg.Image=img end
        wallpaper.ImageColor3=Color3.fromRGB(236,240,255)
        heroArt.ImageColor3=Color3.fromRGB(236,240,255)
        if dockBg then dockBg.ImageColor3=Color3.fromRGB(236,240,255) end
        opacityValue.Text=tostring(math.floor((1-visibility)*100+.5)).."% VISIBLE"
        for key,entry in pairs(imageButtons) do
            local active=(id==key)
            entry.border.Color=active and P.accent or P.stroke
            entry.border.Thickness=active and 2.6 or 1.1
            entry.border.Transparency=active and .05 or .62
        end
        gallery.ScrollBarImageColor3=P.accent
        skinOG()
    end
    local function applyColors()
        P.accent=ACCENTS[skin.accent] or ACCENTS.BLUE
        outerLine.Color=Color3.fromRGB(255,255,255);topRule.BackgroundColor3=Color3.fromRGB(255,255,255)
        dockEdge.Color=Color3.fromRGB(255,255,255);dockLogo.BackgroundColor3=P.accent
        avatarEdge.Color=P.accent
        brandSub.TextColor3=P.accent;upper.TextColor3=P.accent
        brandLogoHolder.BackgroundColor3=P.accent
        railBorder.BackgroundColor3=P.red
        for _,g in ipairs(SC.grads) do g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,P.accent),ColorSequenceKeypoint.new(.5,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,P.red)}) end
        centerPoint.BackgroundColor3=P.accent
        heroLight.BackgroundColor3=P.accent;targetEdge.Color=P.accent
        heroTint.BackgroundColor3=P.panel
        telemetry.TextColor3=P.accent;linkValue.TextColor3=P.accent
        logScroll.ScrollBarImageColor3=P.accent
        countText.TextColor3=P.accent;intelStatus.TextColor3=P.accent
        announceFill.BackgroundColor3=P.accent
        answer.TextColor3=P.accent
        for _,obj in ipairs(starList) do obj.BackgroundColor3=P.accent end
        for _,o in ipairs(spotlights) do
            o.strip.BackgroundColor3=P.accent;o.label.TextColor3=P.accent
            local ring=o.stamp:FindFirstChildOfClass("UIStroke")
            if ring then ring.Color=P.accent end
        end
        for _,entry in pairs(imageButtons) do
            if entry.border then entry.border.Color=P.stroke end
        end
        for _,bar in pairs(navBars) do bar.BackgroundColor3=P.accent end
        for _,spec in ipairs(themed) do
            if spec.obj.Parent then
                spec.obj.BackgroundColor3=P.accent
                spec.obj.TextColor3=P.bg
            end
        end
        for name,b in pairs(accentButtons) do
            local isSelected=skin.accent==name
            b.BackgroundColor3=isSelected and P.accent or P.raised
            b.TextColor3=isSelected and P.bg or P.white
        end
        for _,pg in pairs(pages) do pg.ScrollBarImageColor3=P.accent end
        logScroll.ScrollBarImageColor3=P.accent
        navigate(current)
        applyWallpaper()
        skinOG()
    end
    for name,b in pairs(accentButtons) do
        b.Activated:Connect(function()
            skin.accent=name;persist();applyColors()
        end)
    end

    dock=curve(mk("Frame",GUI,{Name="NxcMiniDock",Visible=false,
        AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-21,1,-24),
        Size=UDim2.fromOffset(274,57),BackgroundColor3=P.panel,
        BorderSizePixel=0,Active=true,ClipsDescendants=true,ZIndex=80}),28)
    dockEdge=edge(dock,Color3.fromRGB(255,255,255),.18,1.45)
    do
        local dockScale=mk("UIScale",dock,{Scale=__sc.Scale})
        SC.change=function(step)
            local v=math.clamp(math.floor(((tonumber(skin.uiScale) or 1)+step)*100+.5)/100,.5,1.6)
            skin.uiScale=v;persist()
            __sc.Scale=v;dockScale.Scale=v
            if SC.label then SC.label.Text=math.floor(v*100+.5).."%" end
        end
    end
    local dockGlow=mk("UIGradient",dockEdge,{Rotation=0,
        Color=ColorSequence.new({ColorSequenceKeypoint.new(0,P.accent),
            ColorSequenceKeypoint.new(.5,Color3.fromRGB(255,40,56)),
            ColorSequenceKeypoint.new(1,P.accent)})})
    dockBg=curve(mk("ImageLabel",dock,{Size=UDim2.fromScale(1,1),Image=DEFAULT_IMG,
        ImageColor3=Color3.fromRGB(236,240,255),ImageTransparency=.78,
        ScaleType=Enum.ScaleType.Crop,BackgroundTransparency=1,ZIndex=81}),28)
    local dockShade=curve(mk("Frame",dock,{Size=UDim2.fromScale(1,1),BackgroundColor3=P.bg,
        BackgroundTransparency=.32,BorderSizePixel=0,ZIndex=82}),28)
    local dockHandle=mk("Frame",dock,{Name="MoveDock",Size=UDim2.new(1,-54,1,0),
        BackgroundTransparency=1,Active=true,ZIndex=83})
    dockLogo=curve(mk("Frame",dockHandle,{Size=UDim2.fromOffset(40,40),
        Position=UDim2.fromOffset(9,8),BackgroundColor3=P.accent,
        BorderSizePixel=0,ZIndex=84}),21)
    edge(dockLogo,P.white,.60,1.2)
    local dockLogoImg=curve(mk("ImageLabel",dockLogo,{Name="NxcLogo",
        Image="",Position=UDim2.fromOffset(3,3),Size=UDim2.new(1,-6,1,-6),
        BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,ZIndex=85}),16)
    local dockLogoFallback=text(dockLogo,"C",18,P.bg,Enum.Font.GothamBlack,
        {Size=UDim2.fromScale(1,1),TextXAlignment=Enum.TextXAlignment.Center,ZIndex=86})
    local dockAvatarHolder=curve(mk("Frame",dockHandle,{Name="HeadshotRing",
        Position=UDim2.fromOffset(38,34),Size=UDim2.fromOffset(21,21),
        BackgroundColor3=P.white,BorderSizePixel=0,ZIndex=87}),11)
    curve(mk("ImageLabel",dockAvatarHolder,{Image=avatarUri,
        Position=UDim2.fromOffset(2,2),Size=UDim2.new(1,-4,1,-4),
        BackgroundTransparency=1,ScaleType=Enum.ScaleType.Crop,ZIndex=88}),8)
    local dockTitle=titleFont(text(dockHandle,"CALCIUM HUB",14,P.white,Enum.Font.GothamBlack,
        {Position=UDim2.fromOffset(69,7),Size=UDim2.fromOffset(126,22),ZIndex=85,
         TextScaled=true,TextTruncate=Enum.TextTruncate.None}))
    Instance.new("UITextSizeConstraint",dockTitle).MaxTextSize=14
    local dockSub=text(dockHandle,"CODE SNIPER   •   LIVE",9,P.good,Enum.Font.GothamBold,
        {Position=UDim2.fromOffset(69,30),Size=UDim2.fromOffset(139,16),ZIndex=85})
    applyNxcLogo=function()
        local id=tostring(skin.logo or "0")
        local valid=id:match("^%d+$") and tonumber(id) and tonumber(id)>0
        local imageId=valid and ("rbxassetid://"..id) or ""
        dockLogoImg.Image=imageId
        brandLogoImage.Image=imageId
        dockLogoFallback.Visible=not valid
        brandLogoFallback.Visible=not valid
    end
    applyNxcLogo()
    local expand=button(dock,"OPEN",nil,true)
    expand.Name="Expand"
    expand.TextSize=11
    curve(expand,21)
    expand.Size=UDim2.fromOffset(40,40)
    expand.Position=UDim2.new(1,-47,.5,-20)
    expand.ZIndex=86
    local minimized=false
    local mobile=false
    local widthNow=724
    local heightNow=520
    local icons={}
    for _,item in ipairs(MENU) do
        for _,obj in ipairs(navButtons[item[1]]:GetChildren()) do
            if obj:IsA("TextLabel") and obj~=navLabels[item[1]] then
                icons[item[1]]=obj
            end
        end
    end
    local function responsive()
        if not root.Parent then return end
        local camera=workspace.CurrentCamera
        local view=camera and camera.ViewportSize or Vector2.new(1280,720)
        mobile=view.X<645 or (UserInputService.TouchEnabled and view.X<820)
        widthNow=math.max(270,math.min(mobile and 390 or 724,view.X-16))
        heightNow=math.max(285,math.min(520,view.Y-24))
        if not minimized then root.Size=UDim2.fromOffset(widthNow,heightNow) end
        if mobile then
            rail.Visible=false
            navWrap.Parent=root
            navWrap.Position=UDim2.fromOffset(12,76)
            navWrap.Size=UDim2.new(1,-24,0,44)
            navWrap.CanvasSize=UDim2.fromOffset(5*79,0)
            navWrap.ScrollingDirection=Enum.ScrollingDirection.X
            header.Position=UDim2.fromOffset(0,0)
            header.Size=UDim2.new(1,0,0,74)
            workspaceShell.Position=UDim2.fromOffset(7,122)
            workspaceShell.Size=UDim2.new(1,-14,1,-129)
            pagesWrap.Position=UDim2.fromOffset(16,130)
            pagesWrap.Size=UDim2.new(1,-32,1,-140)
            pageTitle.TextSize=20
            upper.TextSize=9
            statusPill.Visible=widthNow>360
            for i,item in ipairs(MENU) do
                local name=item[1]
                local b=navButtons[name]
                b.Position=UDim2.fromOffset((i-1)*79,2)
                b.Size=UDim2.fromOffset(75,38)
                navLabels[name].Position=UDim2.fromOffset(0,0)
                navLabels[name].Size=UDim2.fromScale(1,1)
                navLabels[name].TextXAlignment=Enum.TextXAlignment.Center
                navLabels[name].TextSize=11
                if icons[name] then icons[name].Visible=false end
                navBars[name].Size=UDim2.new(1,-29,0,2)
                navBars[name].Position=UDim2.new(0,15,1,-3)
            end
            crosshair.Visible=widthNow>335
        else
            rail.Visible=true
            rail.Size=UDim2.fromOffset(170,heightNow)
            navWrap.Parent=rail
            navWrap.Position=UDim2.fromOffset(7,95)
            navWrap.Size=UDim2.new(1,-14,1,-142)
            navWrap.CanvasSize=UDim2.fromOffset(0,290)
            navWrap.CanvasPosition=Vector2.zero
            navWrap.ScrollingDirection=Enum.ScrollingDirection.Y
            header.Position=UDim2.fromOffset(170,0)
            header.Size=UDim2.new(1,-170,0,73)
            workspaceShell.Position=UDim2.fromOffset(177,70)
            workspaceShell.Size=UDim2.new(1,-185,1,-77)
            pagesWrap.Position=UDim2.fromOffset(189,85)
            pagesWrap.Size=UDim2.new(1,-201,1,-101)
            pageTitle.TextSize=23
            upper.TextSize=9
            statusPill.Visible=true
            for i,item in ipairs(MENU) do
                local name=item[1]
                local b=navButtons[name]
                b.Position=UDim2.fromOffset(3,(i-1)*54)
                b.Size=UDim2.new(1,-6,0,47)
                navLabels[name].Position=UDim2.fromOffset(47,0)
                navLabels[name].Size=UDim2.new(1,-53,1,0)
                navLabels[name].TextXAlignment=Enum.TextXAlignment.Left
                navLabels[name].TextSize=12
                if icons[name] then icons[name].Visible=true end
                navBars[name].Position=UDim2.fromOffset(0,11)
                navBars[name].Size=UDim2.fromOffset(3,26)
            end
            crosshair.Visible=true
        end
        dock.Size=UDim2.fromOffset(math.min(274,view.X-20),57)
    end
    local camConn
    local function watchCamera()
        if camConn then camConn:Disconnect() end
        if workspace.CurrentCamera then
            camConn=workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(responsive)
        end
        responsive()
    end
    local cameraConn=workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera)

    local dragConnections={}
    local function draggable(handle,object)
        local activeInput,mouseDown,startPos,startFrame
        local began=handle.InputBegan:Connect(function(input)
            if input.UserInputType~=Enum.UserInputType.MouseButton1 and
                input.UserInputType~=Enum.UserInputType.Touch then return end
            activeInput=input
            mouseDown=true
            startPos=input.Position
            startFrame=object.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    mouseDown=false;activeInput=nil
                end
            end)
        end)
        local changed=UserInputService.InputChanged:Connect(function(input)
            if not mouseDown or not activeInput then return end
            if input~=activeInput and
                not (activeInput.UserInputType==Enum.UserInputType.MouseButton1 and
                    input.UserInputType==Enum.UserInputType.MouseMovement) then return end
            local delta=input.Position-startPos
            object.Position=UDim2.new(startFrame.X.Scale,startFrame.X.Offset+delta.X,
                startFrame.Y.Scale,startFrame.Y.Offset+delta.Y)
        end)
        dragConnections[#dragConnections+1]=began
        dragConnections[#dragConnections+1]=changed
    end
    draggable(header,root)
    draggable(dockHandle,dock)

    local function setMinimized(on)
        if minimized==on then return end
        minimized=on
        if on then
            dock.Visible=true
            dock.Size=UDim2.fromOffset(230,51)
            tw(dock,{Size=UDim2.fromOffset(math.min(274,(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 420)-20),57)},.22)
            root.Visible=false
        else
            dock.Visible=false
            root.Visible=true
            root.Size=UDim2.fromOffset(widthNow-16,heightNow-12)
            tw(root,{Size=UDim2.fromOffset(widthNow,heightNow)},.24)
            responsive()
            navigate(current)
        end
    end
    minimize.Activated:Connect(function()setMinimized(true)end)
    expand.Activated:Connect(function()setMinimized(false)end)

    local lastConsole=""
    local lastSpeed=""
    local lastLink=""
    local uiAlive=true
    task.spawn(function()
        while uiAlive and _instanceRunning and root.Parent do
            task.wait(.65)
            if not uiAlive or not root.Parent then break end
            updateAll()
            dockSub.Text=autoWriteEnabled and "CODE SNIPER   •   LIVE" or "CODESNIPER   •   PAUSED"
            dockSub.TextColor3=autoWriteEnabled and P.good or P.bad
            local linked=_primaryTarget and _primaryTarget.alive() and _primaryTarget.btn~=nil
            local status=linked and "CONNECTED" or "SEARCHING"
            if status~=lastLink then
                lastLink=status
                linkValue.Text=status
                linkValue.TextColor3=linked and P.good or P.accent
            end
            if SpeedLabel and SpeedLabel.Parent then
                local val=SpeedLabel.Text
                if val~=lastSpeed then
                    lastSpeed=val
                    local ms=val:match("([%d%.]+)%s*ms")
                    if ms then telemetry.Text=ms.." ms" end
                end
            end
            if current=="Logs" and ConsoleOutput and ConsoleOutput.Parent then
                local content=ConsoleOutput.Text
                if content~=lastConsole then
                    lastConsole=content
                    logText.Text=content
                    task.defer(function()
                        if logScroll.Parent then
                            logScroll.CanvasPosition=Vector2.new(0,math.max(0,
                                logScroll.AbsoluteCanvasSize.Y-logScroll.AbsoluteWindowSize.Y))
                        end
                    end)
                end
            end
        end
    end)

    local ogTaskActive=true
    task.spawn(function()
        while ogTaskActive and _instanceRunning and root.Parent do
            task.wait(2)
            if ogTaskActive then
                local env=(getgenv and getgenv()) or _G
                local og=env.NxcOGSniperGui
                if og and og.Parent and not og:GetAttribute("AuroraStyled") then
                    og:SetAttribute("AuroraStyled",true)
                    skinOG()
                end
            end
        end
    end)

    local priorStop=(getgenv and getgenv().StopAura)
    if getgenv and type(priorStop)=="function" then
        getgenv().StopAura=function(...)
            pcall(function() root:Destroy() end)
            pcall(function() dock:Destroy() end)
            return priorStop(...)
        end
    end
    root.Destroying:Connect(function()
        uiAlive=false
        ogTaskActive=false
        if camConn then camConn:Disconnect() end
        if cameraConn then cameraConn:Disconnect() end
        if listeningConn then listeningConn:Disconnect() end
        for _,conn in ipairs(dragConnections) do conn:Disconnect() end
        if LiveRiddleIntel.onUpdated==updateIntel then LiveRiddleIntel.onUpdated=nil end
        if dock.Parent then dock:Destroy() end
    end)
    task.spawn(function()
        local ok,err=pcall(loadConfuserStarborn)
        if not ok then
            setFontStatus("STARBORN LOAD FAILED  /  SYSTEM FONT",P.bad)
            warn("[CALCIUM HUB] Starborn: "..tostring(err))
        end
    end)
    if wallpaper and heroArt and railPicture and dockBg then
        applyWallpaper()
    end
    if dockEdge and dockLogo and centerPoint then
        applyColors()
    end
    watchCamera()
    navigate("Home")
    GUI.Enabled=true
    task.defer(function()
        if _instanceRunning then refreshFastTargets(true) end
    end)
  end)
  if not __novaOk then
    warn("[CALCIUM HUB] UI build error: "..tostring(__novaErr))
    pcall(function()
      if GUI and GUI.Parent then
        GUI.Enabled = true
        local nova = GUI:FindFirstChild("NovaInterface")
        if nova then nova.Visible = true end
        local lbl = Instance.new("TextLabel")
        lbl.Name = "NxcBuildError"
        lbl.Size = UDim2.new(1,-20,0,90)
        lbl.Position = UDim2.fromOffset(10,10)
        lbl.BackgroundColor3 = Color3.fromRGB(30,0,0)
        lbl.TextColor3 = Color3.fromRGB(255,140,140)
        lbl.TextWrapped = true
        lbl.TextSize = 13
        lbl.Font = Enum.Font.Code
        lbl.ZIndex = 9999
        lbl.Text = "UI build error: "..tostring(__novaErr)
        lbl.Parent = GUI
      end
    end)
  end
end)
