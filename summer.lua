repeat task.wait() until game:IsLoaded()
local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService")
local LP = Players.LocalPlayer
local NS,CS = 60,29
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,false
local laggerToggled = false
local laggerPhase = 0
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce,medusaLastUsed,dropActive = false,0,false
local autoLeftEnabled,autoRightEnabled = false,false
local autoLeftSetVisual,autoRightSetVisual = nil,nil
local speedLabel = nil
local autoBatEnabled = false
local autoSwingEnabled = true
local autoBatSetVisual = nil
local _autoBatTarget = nil
local resetAutoBatMotion = nil
local _batSwingCooldown = 0
local BAT_SWING_INTERVAL = 0.08
local AUTO_BAT_SPEED = 60
local setBatCounterVisual = nil
local startBatCounter,stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local antiLagDescConn = nil
local stretchRezEnabled = false
local stretchRezConn = nil
local setStretchRezVisual = nil

local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPConn = nil
local setAutoTPVisual = nil

-- FIX: I-OVERRIDE ang canUseAutoPath para LAGING GUMANA
local function canUseAutoPath()
    return true -- FORCE ENABLED
end

-- FIX: I-force ang WalkSpeed para sigurado
local function forceWalkSpeed()
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed < 30 then
            hum.WalkSpeed = 30
        end
    end
end
game:GetService("RunService").Heartbeat:Connect(forceWalkSpeed)

-- Blacklist check (kept for safety)
task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    local function httpGet(url)
        local methods={
            function() return game:HttpGet(url) end,
            function() return HS:GetAsync(url) end,
            function() return syn.request({Url=url,Method="GET"}).Body end,
            function() return http_request({Url=url,Method="GET"}).Body end,
            function() return request({Url=url,Method="GET"}).Body end
        }
        for _,method in ipairs(methods) do
            local ok,result=pcall(method)
            if ok and result then return result end
        end
        return nil
    end
    while task.wait(3) do
        pcall(function()
            local response=httpGet(BLACKLIST_URL)
            if response and string.find(response,tostring(LP.UserId),1,true) then
                LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
                task.wait(999999)
            end
        end)
    end
end)

-- ============================================================
-- SUMMER INSTA RESET (FrameResetLite)
-- ============================================================
local RESET_MAX_DURATION = 0.05
local resetCooldown = false
local resetThread = nil
local currentCharacter = nil
local resetSuccessful = false
local stopResetSequence = false
local cameraLocked = false
local lockedCameraCFrame = nil

local function ResetPlayer()
    if resetCooldown then return end
    resetCooldown = true
    resetSuccessful = false
    stopResetSequence = false
    cameraLocked = false
    local character = LP.Character
    if not character then resetCooldown = false return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then resetCooldown = false return end
    local camera = workspace.CurrentCamera
    if camera then
        lockedCameraCFrame = camera.CFrame
        cameraLocked = true
        camera.CFrame = lockedCameraCFrame
    end
    currentCharacter = character
    local isRespawning = false
    resetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = humanoid.HipHeight
        while character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning and not stopResetSequence do
            if LP.Character ~= character then
                isRespawning = true
                break
            end
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = false
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)
            if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true
                break
            end
            attempts = attempts + 1
            if attempts >= maxAttempts then break end
            task.wait(RESET_MAX_DURATION)
        end
        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                pcall(function()
                    humanoid.Health = 0
                end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    resetSuccessful = true
                end
            end
        end
        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
        cameraLocked = false
        resetCooldown = false
        resetThread = nil
        currentCharacter = nil
        stopResetSequence = false
    end)
end

local function StopResetSequence()
    stopResetSequence = true
    if resetThread then
        task.cancel(resetThread)
        resetThread = nil
    end
    resetCooldown = false
    currentCharacter = nil
    cameraLocked = false
    local character = LP.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.HipHeight = 2
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
end

LP.CharacterAdded:Connect(function()
    StopResetSequence()
    resetCooldown = false
    currentCharacter = nil
    resetSuccessful = false
    stopResetSequence = false
    cameraLocked = false
end)

task.spawn(function()
    local camera = workspace.CurrentCamera
    while true do
        task.wait(0.016)
        if cameraLocked and lockedCameraCFrame and camera then
            camera.CFrame = lockedCameraCFrame
        end
    end
end)

local function cursedInstaReset()
    ResetPlayer()
end

_G.FrameResetLite = {
    Reset = ResetPlayer,
    Stop = StopResetSequence,
}

local KB = {
    DropBrainrot={kb=Enum.KeyCode.X},
    AutoLeft    ={kb=Enum.KeyCode.Z},
    AutoRight   ={kb=Enum.KeyCode.C},
    AutoBat     ={kb=Enum.KeyCode.E},
    TPFloor     ={kb=Enum.KeyCode.F},
    InstaReset  ={kb=Enum.KeyCode.T},
    GuiHide     ={kb=Enum.KeyCode.LeftControl},
    SpeedToggle ={kb=Enum.KeyCode.Q},
    LaggerToggle={kb=Enum.KeyCode.R},
    Aimbot2={kb=Enum.KeyCode.V},
    AntiDesyncAimbot={kb=Enum.KeyCode.B}
}

local AP_L1,AP_L2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local AP_R1,AP_R2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)

local Steal = {
    AutoStealEnabled=false,StealRadius=60,StealDuration=1.4,
    Data={}
}
local isStealing = false
local stealStartTime = nil
local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil}
local MEDUSA_COOLDOWN = 25
local batCounterDebounce = false
local modeValLbl
local uiScale = 1
uiLocked=false
setLockVisual=nil
exeLaggerPanelKey=Enum.KeyCode.M
exeMainFrame=nil
exeMiniButton=nil
exeGrabBar=nil
local lastMoveDir = Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

local function getActiveMoveSpeed()
    return laggerToggled and (laggerPhase==2 and LAGGER_CARRY_SPEED or LAGGER_SPEED) or (speedMode and CS or NS)
end

local function getAutoPathSpeed()
    return laggerToggled and LAGGER_SPEED or NS
end

local function isRagdollState(hum)
    if not hum then return true end
    local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

local function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot=plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then
        local yb=sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled==true
        end
    end
    return false
end

local function findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do
            local base=pod:FindFirstChild("Base")
            local sp=base and base:FindFirstChild("Spawn")
            if sp then
                local d=(sp.Position-root.Position).Magnitude
                if d<=Steal.StealRadius and d<dist then
                    local found=nil
                    local att=sp:FindFirstChild("PromptAttachment")
                    if att then
                        for _,pr in ipairs(att:GetChildren()) do
                            if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end
                        end
                    end
                    if not found then
                        for _,pr in ipairs(sp:GetDescendants()) do
                            if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end
                        end
                    end
                    if found then nearest,dist=found,d end
                end
            end
        end
    end
    return nearest
end

local function _promptDist(prompt)
    local char=LP.Character
    if not char then return math.huge end
    local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part=prompt.Parent
    if part and part:IsA("Attachment") then part=part.Parent end
    if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end
    local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then return (cf-root.Position).Magnitude end
    return math.huge
end

local function executeSteal(prompt)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
            for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
        end
    end
    local data=Steal.Data[prompt];if not data.ready then return end
    data.ready=false;isStealing=true;stealStartTime=tick()
    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration)
        for _,fn in ipairs(data.trigger) do task.spawn(fn) end
        data.ready=true;isStealing=false
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p=findNearestPrompt();if p then executeSteal(p) end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
    isStealing=false
end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
        local md=hum.MoveDirection
        local spd=getActiveMoveSpeed()
        if md.Magnitude>0 then
            lastMoveDir=md
            hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
            local anyHeld=false
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
            if anyHeld then hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd) end
        end
    end
    if speedLabel then speedLabel.Text=string.format("Speed: %.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end
end)

local alConn,arConn=nil,nil
local alPhase,arPhase=1,1

local function stopAutoLeft()
    autoLeftEnabled=false
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false);h.PlatformStand=false;pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=h end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end

local function stopAutoRight()
    autoRightEnabled=false
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false);h.PlatformStand=false;pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=h end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end

local function startAutoLeft()
    if alConn then alConn:Disconnect() end;alPhase=1
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                alPhase=2
                local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
                return
            end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false);hum.PlatformStand=false;pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=hum;hrp.AssemblyLinearVelocity=Vector3.zero
                autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end
                alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;saveConfig();return
            end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

local function startAutoRight()
    if arConn then arConn:Disconnect() end;arPhase=1
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                arPhase=2
                local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
                return
            end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false);hum.PlatformStand=false;pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=hum;hrp.AssemblyLinearVelocity=Vector3.zero
                autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end
                arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;saveConfig();return
            end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

local function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    local bb=Instance.new("BillboardGui",head)
    bb.Size=UDim2.new(0,160,0,44);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true
    speedLabel=Instance.new("TextLabel",bb)
    speedLabel.Size=UDim2.new(1,0,1,0);speedLabel.BackgroundTransparency=1
    speedLabel.Text="Speed: 0";speedLabel.TextColor3=Color3.fromRGB(0,255,120)
    speedLabel.Font=Enum.Font.GothamBlack;speedLabel.TextScaled=true
    speedLabel.TextStrokeTransparency=0;speedLabel.TextStrokeColor3=Color3.fromRGB(0,40,20)
end

local function startAntiRagdoll()
    if Conns.antiRag then return end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char=LP.Character
        if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state=hum:GetState()
        local isRagdolled = state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown
        if isRagdolled then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                local root=char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity=Vector3.zero
                    root.RotVelocity=Vector3.zero
                    root.AssemblyLinearVelocity=Vector3.zero
                    root.AssemblyAngularVelocity=Vector3.zero
                end
                for _,obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Motor6D") then obj.Enabled=true end
                    if obj:IsA("Constraint") then obj.Enabled=true end
                end
                workspace.CurrentCamera.CameraSubject=hum
                local PM=LP.PlayerScripts:FindFirstChild("PlayerModule")
                if PM then
                    local CM=require(PM:FindFirstChild("ControlModule"))
                    if CM then CM:Enable() end
                end
                hum.AutoRotate=true
                hum.PlatformStand=false
                hum.Sit=false
            end)
        end
    end)
end

local function stopAntiRagdoll()
    if Conns.antiRag then Conns.antiRag:Disconnect();Conns.antiRag=nil end
end

-- INFINITE JUMP
local InfJumpPlatform = nil
local function CreateIJP()
    if InfJumpPlatform then return end
    InfJumpPlatform = Instance.new("Part")
    InfJumpPlatform.Name = "InfJumpPlatform"
    InfJumpPlatform.Size = Vector3.new(8, 0.5, 8)
    InfJumpPlatform.Anchored = true
    InfJumpPlatform.CanCollide = true
    InfJumpPlatform.Transparency = 1
    InfJumpPlatform.Material = Enum.Material.ForceField
    InfJumpPlatform.Parent = workspace
end
CreateIJP()
RunService.Heartbeat:Connect(function()
    if not infJumpEnabled then
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end
        return
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (char and root and hum) then
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end
        return
    end
    local isJumping = UIS:IsKeyDown(Enum.KeyCode.Space)
        or hum:GetState() == Enum.HumanoidStateType.Jumping
        or hum.Jump
    if isJumping then
        if not InfJumpPlatform then CreateIJP() end
        InfJumpPlatform.Position = root.Position - Vector3.new(0, 3.5, 0)
        if root.Velocity.Y < 50 then
            root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
        end
    else
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end
    end
end)

local function startUnwalk()
    local c=LP.Character;if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate")
    if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end

local function stopUnwalk()
    local c=LP.Character
    if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end
end

-- ============================================================
-- JUMP DROP (ascend then teleport) - BAGONG DAGDAG
-- ============================================================
local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil
local jumpDropActive = false

local function runJumpDrop()
    if jumpDropActive then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    jumpDropActive = true
    if mobBtnRefs and mobBtnRefs.drop then mobBtnRefs.drop(true) end
    local t0 = tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            jumpDropActive = false
            if mobBtnRefs and mobBtnRefs.drop then mobBtnRefs.drop(false) end
            return
        end
        if not jumpDropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            if mobBtnRefs and mobBtnRefs.drop then mobBtnRefs.drop(false) end
            return
        end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
                if rr then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    local off = ((hum and hum.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = Vector3.zero
                end
            end)
            jumpDropActive = false
            if mobBtnRefs and mobBtnRefs.drop then mobBtnRefs.drop(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z)
    end)
end

local _wfConns={}
local function runDrop()
    if dropActive then return end
    if autoBatEnabled then
        autoBatEnabled=false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if autoBatSetVisual then autoBatSetVisual(false) end
    end
    dropActive=true
    local colConn=RunService.Stepped:Connect(function()
        if not dropActive then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                for _,part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
        end
    end)
    table.insert(_wfConns,colConn)
    local flingThread=coroutine.create(function()
        while dropActive do
            RunService.Heartbeat:Wait()
            local c=LP.Character
            local root=c and c:FindFirstChild("HumanoidRootPart")
            if not root then break end
            local vel=root.Velocity
            root.Velocity=vel*10000+Vector3.new(0,10000,0)
            RunService.RenderStepped:Wait()
            if root and root.Parent then root.Velocity=vel end
            RunService.Stepped:Wait()
            if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
        end
    end)
    table.insert(_wfConns,flingThread)
    coroutine.resume(flingThread)
    task.delay(0.1,function()
        dropActive=false
        for _,c in ipairs(_wfConns) do
            if typeof(c)=="RBXScriptConnection" then c:Disconnect()
            elseif type(c)=="thread" then pcall(coroutine.close,c) end
        end
        _wfConns={}
    end)
end

function runDropKeybindBurst()
    task.spawn(function()
        for i=1,3 do
            pcall(runDrop)
            task.wait(0.14)
        end
    end)
end

local function doTPDown(force)
    local char=LP.Character;if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then
        if hum2.FloorMaterial~=Enum.Material.Air then return end
        if hrp.Position.Y<autoTPHeight then return end
    end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)
        *CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
    hrp.AssemblyLinearVelocity=Vector3.zero
    hrp.Velocity=Vector3.zero
end

local function runTPFloor()
    pcall(function() doTPDown(true) end)
end

local defLightBrightness,defLightClock,defLightAmbient
pcall(function()
   if not getgenv().Resolution then
       getgenv().Resolution = { [".gg/scripters"] = 0.65 }
   end
end)

local enableStretchRez, disableStretchRez
do
   local stretchRezOriginalCFrame=nil
   function enableStretchRez()
       stretchRezEnabled=true
       local camera=workspace.CurrentCamera
       if stretchRezConn then stretchRezConn:Disconnect() end
       stretchRezOriginalCFrame=camera.CFrame
       stretchRezConn=RunService.RenderStepped:Connect(function()
           if not stretchRezEnabled then stretchRezConn:Disconnect(); stretchRezConn=nil; return end
           local cam=workspace.CurrentCamera
           local scaleY=(getgenv().Resolution and getgenv().Resolution[".gg/scripters"]) or 0.65
           if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,scaleY,0,0,0,1) end
       end)
   end
   function disableStretchRez()
       stretchRezEnabled=false
       if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end
       if stretchRezOriginalCFrame then local cam=workspace.CurrentCamera; if cam then cam.CFrame=stretchRezOriginalCFrame end end
   end
end

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

local function enableAntiLag()
    removeAccessoriesEnabled=true
    antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness
    defLightClock=defLightClock or Lighting.ClockTime
    defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1
    Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end
        end)
    end
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end

local function disableAntiLag()
    removeAccessoriesEnabled=false
    antiLagEnabled=false
    if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness=defLightBrightness end
        if defLightClock then Lighting.ClockTime=defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end
        Lighting.ExposureCompensation=0
    end)
end

local function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

local function useMedusaCounter()
    if medusaDebounce then return end;if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then useMedusaCounter() end
    end)
end

local function setupMedusa(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end))
end

local function stopMedusaCounter()
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character;if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end

local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end

startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local char=LP.Character;if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5);batCounterDebounce=false
            end)
        end
    end)
end

stopBatCounter=function()
    if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end
    batCounterDebounce=false
end

local function findBat()
    local char=LP.Character; if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end

local function getAutoBatTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")
            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then
                local dist=(tRoot.Position-root.Position).Magnitude
                if dist<minDist then minDist=dist;closest=tRoot end
            end
        end
    end
    return closest
end

resetAutoBatMotion=function()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=Vector3.zero;hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end

local function enableAutoBat()
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    local char=LP.Character
    if char then
        local hum2=char:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2.AutoRotate=false end
    end
    autoBatEnabled=true
end

local function disableAutoBat()
    autoBatEnabled=false
    local char=LP.Character
    if char then
        local hum2=char:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2.AutoRotate=true end
    end
    if resetAutoBatMotion then resetAutoBatMotion() end
end

local function queueAutoLeftStart()
    autoLeftEnabled=true
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
    startAutoLeft()
end

local function queueAutoRightStart()
    autoRightEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
    startAutoRight()
end

local function queueAutoBatStart()
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    enableAutoBat()
end

RunService.Heartbeat:Connect(function()
    if not autoBatEnabled then return end
    local char=LP.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or not hum then return end
    if not char:FindFirstChildOfClass("Tool") then
        local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        local bpBat=bp and bp:FindFirstChild("Bat")
        if bpBat then pcall(function() hum:EquipTool(bpBat) end) end
    end
    local target=getAutoBatTarget()
    if target then
        local targetVel=target.AssemblyLinearVelocity
        local targetPos=target.Position
        local myPos=root.Position
        local predictPos=targetPos+targetVel*0.14
        predictPos=predictPos+target.CFrame.LookVector*0.3
        local direction=predictPos-myPos
        local flatDir=Vector3.new(direction.X,0,direction.Z)
        if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end
        local chaseSpeed=AUTO_BAT_SPEED
        local desiredHeight=targetPos.Y+3.7
        local yVel=(desiredHeight-myPos.Y)*19.5+targetVel.Y*0.8
        if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end
        yVel=math.clamp(yVel,-70,110)
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
        local speed3=targetVel.Magnitude
        local predictTime=math.clamp(speed3/150,0.05,0.2)
        local predictedPos=targetPos+targetVel*predictTime
        local toPredict=predictedPos-myPos
        if toPredict.Magnitude>0.1 then
            hum.AutoRotate=false
            local goalCF=CFrame.lookAt(myPos,predictedPos)
            local diffCF=root.CFrame:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-2.5,2.5); ry=math.clamp(ry,-2.5,2.5); rz=math.clamp(rz,-2.5,2.5)
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42))
        end
    else
        hum.AutoRotate=true
        root.AssemblyAngularVelocity=Vector3.zero
        root.AssemblyLinearVelocity=Vector3.zero
    end
    if autoSwingEnabled then
        local bat=char:FindFirstChild("Bat")
        if bat then
            pcall(function() bat:Activate() end)
        else
            local tool=char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
            end
        end
    end
end)

autoSwitchSpeedEnabled=false
autoTurnOffSpeedEnabled=false
autoSwitchLaggerSpeedEnabled=false
autoSwitchSpeedConn=nil
AUTO_SWITCH_THRESHOLD=25
fpsBoostEnabled=false
fovEnabled=false
fovValue=90
fovConn=nil

setAutoSwitchSpeedVisual,setAutoTurnOffSpeedVisual,setAutoSwitchLaggerSpeedVisual,setFpsBoostVisual,setFovVisual=nil,nil,nil,nil,nil
fovValueBox=nil

function applyFPSBoost()
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
end

-- AIMBOT 2
if aimbot2Enabled==nil then aimbot2Enabled=false end
aimbot2Conn=aimbot2Conn or nil
aimbot2PrevAutoRotate=aimbot2PrevAutoRotate or nil
aimbot2HitCD=aimbot2HitCD or false
setAimbot2Visual=setAimbot2Visual or nil
AIMBOT2_SWING_CD=0.35
AIMBOT2_HIT_DIST=8
AIMBOT2_BAT_SLAP_LIST=AIMBOT2_BAT_SLAP_LIST or {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap"
}

function aimbot2FindBat()
    local char=LP.Character
    if not char then return nil end
    for _,name in ipairs(AIMBOT2_BAT_SLAP_LIST) do
        local t=char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp then
        for _,name in ipairs(AIMBOT2_BAT_SLAP_LIST) do
            local t=bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _,ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
    end
    return nil
end

function aimbot2TrySwing()
    if aimbot2HitCD then return end
    aimbot2HitCD=true
    pcall(function()
        local char=LP.Character
        if not char then return end
        local bat=aimbot2FindBat()
        if bat then
            if bat.Parent~=char then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(AIMBOT2_SWING_CD,function() aimbot2HitCD=false end)
end

function aimbot2GetClosestTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil,math.huge end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")
            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then
                local dist=(tRoot.Position-root.Position).Magnitude
                if dist<minDist then minDist=dist;closest=tRoot end
            end
        end
    end
    return closest,minDist
end

function startAimbot2()
    if aimbot2Conn then aimbot2Conn:Disconnect();aimbot2Conn=nil end
    aimbot2Enabled=true
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if aimbot2PrevAutoRotate==nil then aimbot2PrevAutoRotate=hum.AutoRotate end
        hum.AutoRotate=false
    end
    aimbot2Conn=RunService.RenderStepped:Connect(function()
        if not aimbot2Enabled then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
        local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat=aimbot2FindBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target,targetDist=aimbot2GetClosestTarget()
        if not target then return end
        local myPos=root.Position
        local targetPos=target.Position
        local direction=targetPos-myPos
        local flatDir=Vector3.new(direction.X,0,direction.Z)
        if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end
        local chaseSpeed=58
        local desiredHeight=targetPos.Y+3.7
        local yVel=(desiredHeight-myPos.Y)*19.5
        if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end
        yVel=math.clamp(yVel,-70,110)
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
        local toTarget=targetPos-myPos
        if toTarget.Magnitude>0.1 then
            local goalCF=CFrame.lookAt(myPos,targetPos)
            local diffCF=root.CFrame:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-2.5,2.5);ry=math.clamp(ry,-2.5,2.5);rz=math.clamp(rz,-2.5,2.5)
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42))
        end
        if targetDist<=AIMBOT2_HIT_DIST then aimbot2TrySwing() end
    end)
end

function stopAimbot2()
    aimbot2Enabled=false
    if aimbot2Conn then aimbot2Conn:Disconnect();aimbot2Conn=nil end
    local c=LP.Character
    local root=c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
    end
    local hum=c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate=(aimbot2PrevAutoRotate==nil) and true or aimbot2PrevAutoRotate
        hum.PlatformStand=false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    aimbot2HitCD=false
end

function setAimbot2(on)
    aimbot2Enabled=on
    if on then startAimbot2() else stopAimbot2() end
    if setAimbot2Visual then setAimbot2Visual(on) end
    if mobBtnRefs and mobBtnRefs.aimbot2 then mobBtnRefs.aimbot2(on) end
    pcall(saveConfig)
end

-- ANTI DESYNC AIMBOT
if antiDesyncAimbotEnabled==nil then antiDesyncAimbotEnabled=false end
antiDesyncCooldown=antiDesyncCooldown or false
antiDesyncConn=antiDesyncConn or nil
setAntiDesyncAimbotVisual=setAntiDesyncAimbotVisual or nil

function antiDesyncGetBat()
    local char=LP.Character
    if not char then return nil end
    local tool=char:FindFirstChild("Bat")
    if tool then return tool end
    local bp=LP:FindFirstChild("Backpack")
    if bp then
        tool=bp:FindFirstChild("Bat")
        if tool then tool.Parent=char;return tool end
    end
    return nil
end
function antiDesyncTryHitBat()
    if antiDesyncCooldown then return end
    antiDesyncCooldown=true
    pcall(function()
        local bat=antiDesyncGetBat()
        if bat then
            bat:Activate()
            local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08,function() antiDesyncCooldown=false end)
end
function antiDesyncClosestPlayer(hrp)
    if not hrp then return nil,math.huge end
    local closest,dist=nil,math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local tr=p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d=(hrp.Position-tr.Position).Magnitude
                if d<dist then dist=d;closest=p end
            end
        end
    end
    return closest,dist
end
function startAntiDesyncAimbot()
    if antiDesyncConn then return end
    antiDesyncAimbotEnabled=true
    antiDesyncConn=RunService.Heartbeat:Connect(function()
        if not antiDesyncAimbotEnabled then return end
        local char=LP.Character;if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid")
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        local target=antiDesyncClosestPlayer(hrp)
        if target and target.Character then
            local tr=target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                pcall(function() if sethiddenproperty then sethiddenproperty(hrp,"PhysicsRepRootPart",tr) end end)
                local targetPos=tr.Position+Vector3.new(0,0.9,0)
                if (hrp.Position-targetPos).Magnitude>8 then
                    hrp.CFrame=CFrame.new(targetPos)
                end
                pcall(function()
                    local cam=workspace.CurrentCamera
                    if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,tr.Position) end
                end)
                antiDesyncTryHitBat()
            end
        end
    end)
end
function stopAntiDesyncAimbot()
    antiDesyncAimbotEnabled=false
    if antiDesyncConn then antiDesyncConn:Disconnect();antiDesyncConn=nil end
end
function setAntiDesyncAimbot(on)
    antiDesyncAimbotEnabled=on
    if on then startAntiDesyncAimbot() else stopAntiDesyncAimbot() end
    if setAntiDesyncAimbotVisual then setAntiDesyncAimbotVisual(on) end
    if mobBtnRefs and mobBtnRefs.antiDesync then mobBtnRefs.antiDesync(on) end
    pcall(saveConfig)
end

-- BODY LOCK
if bodyLockEnabled==nil then bodyLockEnabled=false end
bodyLockRadius=bodyLockRadius or 60
bodyLockConn=bodyLockConn or nil
setBodyLockVisual=setBodyLockVisual or nil
bodyLockRadiusBox=bodyLockRadiusBox or nil

function getNearestBodyLockTarget()
    local character=LP.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest=nil
    local shortest=math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tr=plr.Character:FindFirstChild("HumanoidRootPart")
            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health>0 then
                local d=(tr.Position-root.Position).Magnitude
                if d<=bodyLockRadius and d<shortest then
                    shortest=d
                    nearest=plr
                end
            end
        end
    end
    return nearest
end

function startBodyLock()
    if bodyLockConn then return end
    bodyLockEnabled=true
    bodyLockConn=RunService.Heartbeat:Connect(function()
        if not bodyLockEnabled then return end
        local character=LP.Character
        local myRoot=character and character:FindFirstChild("HumanoidRootPart")
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        if not myRoot or not humanoid or humanoid.Health<=0 then return end
        local target=getNearestBodyLockTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos=target.Character.HumanoidRootPart.Position
            local myPos=myRoot.Position
            local offset=Vector3.new(targetPos.X,myPos.Y,targetPos.Z)-myPos
            if offset.Magnitude>0.1 then
                humanoid.AutoRotate=false
                local lookDir=offset.Unit
                local currentDir=myRoot.CFrame.LookVector
                local cross=currentDir:Cross(lookDir)
                local currentVel=myRoot.AssemblyAngularVelocity
                myRoot.AssemblyAngularVelocity=Vector3.new(currentVel.X,cross.Y*40,currentVel.Z)
            end
        else
            humanoid.AutoRotate=true
        end
    end)
end

function stopBodyLock()
    bodyLockEnabled=false
    if bodyLockConn then bodyLockConn:Disconnect();bodyLockConn=nil end
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate=true end
end

function setBodyLock(on)
    bodyLockEnabled=on
    if on then startBodyLock() else stopBodyLock() end
    if setBodyLockVisual then setBodyLockVisual(on) end
    pcall(saveConfig)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
end)
if LP.Character then setupSpeedIndicator(LP.Character) end

-- MOBILE BUTTONS
if mobileButtonsSize==nil then mobileButtonsSize=100 end
if mobileButtonShape==nil then mobileButtonShape="box" end
if mobileDragSmall==nil then mobileDragSmall=false end
if mobileMovingMode==nil then mobileMovingMode=false end
mobBtnRefs=mobBtnRefs or {}
mobLastLiveSave=mobLastLiveSave or 0
mobGuiRef=mobGuiRef or nil
mobBtnSavedContainerPos=mobBtnSavedContainerPos or nil
mobBtnSavedIndPos=mobBtnSavedIndPos or {}
setMobileDragSmallVisual=setMobileDragSmallVisual or nil

function saveMobileButtonPositions()
    if not mobGuiRef then return end
    local container=mobGuiRef:FindFirstChild("Buttons")
    if not container then return end
    mobBtnSavedContainerPos={xs=container.Position.X.Scale,xo=container.Position.X.Offset,ys=container.Position.Y.Scale,yo=container.Position.Y.Offset}
    mobBtnSavedIndPos={}
    for _,b in ipairs(container:GetChildren()) do
        if b:IsA("Frame") and b:GetAttribute("Idx") then
            mobBtnSavedIndPos[tostring(b:GetAttribute("Idx"))]={xs=b.Position.X.Scale,xo=b.Position.X.Offset,ys=b.Position.Y.Scale,yo=b.Position.Y.Offset}
        end
    end
end

function saveMobileButtonsConfigOnly()
    pcall(saveMobileButtonPositions)
    pcall(function()
        if not (writefile and HS) then return end
        local cfg={}
        pcall(function()
            if isfile and isfile("summerMobile.json") and readfile then
                local old=HS:JSONDecode(readfile("summerMobile.json"))
                if type(old)=="table" then cfg=old end
            end
        end)
        cfg.mobileButtonsSize=mobileButtonsSize
        cfg.mobileButtonShape=mobileButtonShape
        cfg.mobileDragSmall=mobileDragSmall
        cfg.mobileMovingMode=mobileMovingMode
        cfg.mobBtnSavedContainerPos=mobBtnSavedContainerPos
        cfg.mobBtnSavedIndPos=mobBtnSavedIndPos
        cfg.uiScale=uiScale
        writefile("summerMobile.json",HS:JSONEncode(cfg))
    end)
end

function destroyMobileButtons()
    if mobGuiRef then pcall(saveMobileButtonPositions);pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"SummerMobileButtons","SummerWhiteMobileButtons","SummerAdaptMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end

function resetMobileButtonPositions()
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"SummerMobileButtons","SummerWhiteMobileButtons","SummerAdaptMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnSavedContainerPos=nil
    mobBtnSavedIndPos={}
    mobileMovingMode=false
    buildMobileButtons()
    pcall(saveConfig);saveMobileButtonsConfigOnly()
    task.delay(0.2,function() pcall(saveConfig);saveMobileButtonsConfigOnly() end)
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            saveMobileButtonPositions()
            saveConfig()
            saveMobileButtonsConfigOnly()
        end)
    end
end)

function buildMobileButtons()
    destroyMobileButtons()
    local MB_SIZE=math.floor(56*(mobileButtonsSize or 100)/100)
    local MB_GAP=8
    local COLS=2
    local ROWS=5
    local totalW=COLS*MB_SIZE+(COLS-1)*MB_GAP
    local totalH=ROWS*MB_SIZE+(ROWS-1)*MB_GAP
    local WHITE=Color3.fromRGB(0,255,120)
    local BG=Color3.fromRGB(6,18,28)
    local OFF=Color3.fromRGB(12,40,55)
    local DIM=Color3.fromRGB(60,160,100)
    local W=Color3.fromRGB(0,230,110)
    local ON_BG=Color3.fromRGB(10,60,80)
    local defs={
        {top="DROP",bot="BRAINROT",key="drop",oneShot=true,layout="stacked"},
        {top="AUTO",bot="LEFT",key="autoLeft",layout="sideBySide"},
        {top="BAT",bot="AIMBOT",key="autoBat",layout="stacked"},
        {top="AUTO",bot="RIGHT",key="autoRight",layout="sideBySide"},
        {top="TP",bot="DOWN",key="tpDown",oneShot=true,layout="sideBySide"},
        {top="CARRY",bot="SPEED",key="carrySpeed",layout="stacked"},
        {top="LAGGER",bot="MODE",key="lagger",layout="stacked"},
        {top="AIMBOT 2",bot="(ANTI BAT BYPASS)",key="aimbot2",layout="stacked"},
        {top="ANTI DESYNC",bot="AIMBOT",key="antiDesync",layout="stacked"},
    }
    local function getCorner()
        if mobileButtonShape=="circle" then return UDim.new(1,0)
        elseif mobileButtonShape=="straight" then return UDim.new(0,0)
        else return UDim.new(0,12) end
    end
    local g=Instance.new("ScreenGui");g.Name="Summer";g.ResetOnSpawn=false;g.DisplayOrder=20;g.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(g) end end)
    if not pcall(function() g.Parent=game:GetService("CoreGui") end) then g.Parent=LP:WaitForChild("PlayerGui") end
    mobGuiRef=g
    local container=Instance.new("Frame",g);container.Name="Buttons";container.Size=UDim2.new(0,totalW,0,totalH);container.Position=UDim2.new(1,-(totalW+10),0.5,-totalH/2);container.BackgroundTransparency=1;container.BorderSizePixel=0;container.Active=false
    if mobBtnSavedContainerPos then container.Position=UDim2.new(mobBtnSavedContainerPos.xs,mobBtnSavedContainerPos.xo,mobBtnSavedContainerPos.ys,mobBtnSavedContainerPos.yo) end
    
    -- TANGGALIN YUNG GROUP DRAGGING - para hindi magalaw lahat
    
    for i,def in ipairs(defs) do
        local col=(i-1)%COLS;local row=math.floor((i-1)/COLS)
        local b=Instance.new("Frame",container);b:SetAttribute("Idx",i);b.Size=UDim2.new(0,MB_SIZE,0,MB_SIZE);b.Position=UDim2.new(0,col*(MB_SIZE+MB_GAP),0,row*(MB_SIZE+MB_GAP));b.BackgroundColor3=OFF;b.BorderSizePixel=0;b.ClipsDescendants=true;b.Active=false
        if mobBtnSavedIndPos and mobBtnSavedIndPos[tostring(i)] then local sp=mobBtnSavedIndPos[tostring(i)];b.Position=UDim2.new(sp.xs,sp.xo,sp.ys,sp.yo) end
        Instance.new("UICorner",b).CornerRadius=getCorner()
        
        -- TINANGGAL NA ANG btnBg (LOGO)
        -- local btnBg=Instance.new("ImageLabel",b) ... (REMOVED)
        
        local st=Instance.new("UIStroke",b);st.Color=Color3.fromRGB(70,70,80);st.Thickness=1.4;st.Transparency=0
        local top=Instance.new("TextLabel",b);top.BackgroundTransparency=1;top.Text=def.top;top.TextColor3=W;top.Font=Enum.Font.GothamBlack;top.TextSize=math.max(8,math.floor(11*mobileButtonsSize/100));top.TextStrokeTransparency=0;top.TextStrokeColor3=Color3.fromRGB(0,0,0);top.ZIndex=3
        local bot=Instance.new("TextLabel",b);bot.BackgroundTransparency=1;bot.Text=def.bot;bot.TextColor3=W;bot.Font=Enum.Font.GothamBlack;bot.TextSize=math.max(7,math.floor(9*mobileButtonsSize/100));bot.TextStrokeTransparency=0;bot.TextStrokeColor3=Color3.fromRGB(0,0,0);bot.ZIndex=3
        if def.key=="aimbot2" then bot.TextScaled=true;bot.TextSize=7 end
        if def.layout=="sideBySide" then
            top.Size=UDim2.new(0.48,0,1,0);top.Position=UDim2.new(0.02,0,0,0);top.TextXAlignment=Enum.TextXAlignment.Center
            bot.Size=UDim2.new(0.48,0,1,0);bot.Position=UDim2.new(0.5,0,0,0);bot.TextXAlignment=Enum.TextXAlignment.Center
        else
            top.Size=UDim2.new(1,-4,0,20);top.Position=UDim2.new(0,2,0.5,-14);top.TextXAlignment=Enum.TextXAlignment.Center
            bot.Size=UDim2.new(1,-4,0,16);bot.Position=UDim2.new(0,2,0.5,2);bot.TextXAlignment=Enum.TextXAlignment.Center
        end
        local on=false
        local function setOn(state)
            on=state
            b.BackgroundColor3=state and ON_BG or OFF
            st.Color=state and Color3.fromRGB(0,220,120) or Color3.fromRGB(30,100,120)
            st.Thickness=state and 2.5 or 1.4
            st.Transparency=state and 0.1 or 0
            top.TextColor3=W
            bot.TextColor3=W
        end
        mobBtnRefs[def.key]=setOn
        if def.key=="autoLeft" then setOn(autoLeftEnabled)
        elseif def.key=="autoRight" then setOn(autoRightEnabled)
        elseif def.key=="autoBat" then setOn(autoBatEnabled)
        elseif def.key=="carrySpeed" then setOn(speedMode)
        elseif def.key=="lagger" then setOn(laggerToggled)
        elseif def.key=="aimbot2" then setOn(aimbot2Enabled)
        elseif def.key=="antiDesync" then setOn(antiDesyncAimbotEnabled) end
        local hit=Instance.new("TextButton",b)
        hit.Name="Hitbox";hit.Size=UDim2.new(1,0,1,0);hit.Position=UDim2.new(0,0,0,0);hit.BackgroundTransparency=1;hit.Text="";hit.ZIndex=20;hit.AutoButtonColor=false
        
        -- INDIVIDUAL DRAGGING - ISA-ISA LANG
        local dragging=false
        local dragStart=nil
        local startPos=nil
        local moved=false
        
        hit.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                if not mobileDragSmall and not mobileMovingMode then return end
                dragging=true
                moved=false
                dragStart=input.Position
                startPos=b.Position
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then
                        dragging=false
                    end
                end)
            end
        end)
        
        hit.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
                local d=input.Position-dragStart
                if math.abs(d.X)>5 or math.abs(d.Y)>5 then moved=true end
                if moved then
                    b.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
                    mobBtnSavedIndPos[tostring(i)]={xs=b.Position.X.Scale,xo=b.Position.X.Offset,ys=b.Position.Y.Scale,yo=b.Position.Y.Offset}
                    saveMobileButtonsConfigOnly()
                end
            end
        end)
        
        hit.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                if not moved and not mobileMovingMode then
                    if def.key=="drop" then
                        -- PALITAN: runDropKeybindBurst -> runJumpDrop
                        runJumpDrop()
                        setOn(true)
                        task.delay(0.45,function() setOn(false) end)
                    elseif def.key=="tpDown" then task.spawn(runTPFloor);setOn(true);task.delay(0.35,function() setOn(false) end)
                    elseif def.key=="autoLeft" then autoLeftEnabled=not autoLeftEnabled;if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end;if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end;setOn(autoLeftEnabled);if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end;saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="autoRight" then autoRightEnabled=not autoRightEnabled;if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end;if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end;setOn(autoRightEnabled);if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end;saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="autoBat" then if autoBatEnabled then autoBatEnabled=false;disableAutoBat();setOn(false);if autoBatSetVisual then autoBatSetVisual(false) end else queueAutoBatStart();setOn(autoBatEnabled);if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end end;saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="carrySpeed" then
                            if laggerToggled then laggerToggled=false;laggerPhase=0;speedMode=true else speedMode=not speedMode end
                            if modeValLbl then modeValLbl.Text=laggerToggled and (laggerPhase==2 and "LAGGER CARRY" or "LAGGER NORMAL") or (speedMode and "CARRY" or "NORMAL") end
                            setOn(speedMode);if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerToggled) end;saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="lagger" then
                            if not laggerToggled then speedMode=false;laggerToggled=true;laggerPhase=2 elseif laggerPhase==2 then laggerPhase=1 else laggerPhase=2 end
                            if modeValLbl then modeValLbl.Text=laggerToggled and (laggerPhase==2 and "LAGGER CARRY" or "LAGGER NORMAL") or (speedMode and "CARRY" or "NORMAL") end
                            setOn(laggerToggled);if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode) end;saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="aimbot2" then setAimbot2(not aimbot2Enabled);setOn(aimbot2Enabled);saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="antiDesync" then setAntiDesyncAimbot(not antiDesyncAimbotEnabled);setOn(antiDesyncAimbotEnabled);saveConfig();saveMobileButtonsConfigOnly()
                    end
                end
                dragging=false
                moved=false
            end
        end)
    end
end

function saveConfig()
    pcall(saveMobileButtonPositions)
    local function ks(e) return {kb=e.kb and e.kb.Name or nil} end
    local function ps(o) return o and {xs=o.Position.X.Scale,xo=o.Position.X.Offset,ys=o.Position.Y.Scale,yo=o.Position.Y.Offset} or nil end
    local cfg={
        normalSpeed=NS,carrySpeed=CS,
        dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),
        autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),
        speedToggleKey=ks(KB.SpeedToggle),aimbot2Key=ks(KB.Aimbot2),antiDesyncAimbotKey=ks(KB.AntiDesyncAimbot),laggerPanelKey=exeLaggerPanelKey and exeLaggerPanelKey.Name or nil,
        grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,
        antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,
        infiniteJump=infJumpEnabled,medusaCounter=medusaCounterEnabled,
        batCounter=batCounterEnabled,bodyLockEnabled=bodyLockEnabled,bodyLockRadius=bodyLockRadius,
        carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
        autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,autoBatSpeed=AUTO_BAT_SPEED,aimbot2=aimbot2Enabled,antiDesyncAimbot=antiDesyncAimbotEnabled,
        unwalkEnabled=unwalkEnabled,
        antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,fpsBoostEnabled=fpsBoostEnabled,
        autoSwitchSpeed=autoSwitchSpeedEnabled,autoTurnOffSpeed=autoTurnOffSpeedEnabled,autoSwitchLaggerSpeed=autoSwitchLaggerSpeedEnabled,
        fovEnabled=fovEnabled,fovValue=fovValue,
        uiScale=uiScale,uiLocked=uiLocked,
        mobileButtonsSize=mobileButtonsSize,mobileButtonShape=mobileButtonShape,mobileDragSmall=mobileDragSmall,mobileMovingMode=mobileMovingMode,
        mobBtnSavedContainerPos=mobBtnSavedContainerPos,mobBtnSavedIndPos=mobBtnSavedIndPos,
        guiPos=ps(exeMainFrame),miniPos=ps(exeMiniButton),grabBarPos=ps(exeGrabBar)
    }
    if writefile then pcall(function() writefile("summerMobile.json",HS:JSONEncode(cfg)) end) end
end

task.spawn(function() while task.wait(1) do pcall(saveConfig) end end)
pcall(function() game:BindToClose(function() pcall(saveConfig) end) end)
pcall(function() LP.AncestryChanged:Connect(function(_,parent) if not parent then pcall(saveConfig) end end) end)

local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual
local setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual
local normalBox,carryBox,laggerBox,laggerCarryBox,radInput,durationBox,uiScaleBox
local function refreshSpeedModeLabel()
    if modeValLbl then modeValLbl.Text=laggerToggled and (laggerPhase==2 and "LAGGER CARRY" or "LAGGER NORMAL") or (speedMode and "CARRY" or "NORMAL") end
end

local function toggleCarryMode()
    if laggerToggled then
        laggerToggled=false
        laggerPhase=0
        speedMode=true
    else
        speedMode=not speedMode
    end
    refreshSpeedModeLabel()
end

local function toggleLaggerMode()
    if not laggerToggled then
        speedMode=false
        laggerToggled=true
        laggerPhase=2
    elseif laggerPhase==2 then
        laggerPhase=1
    else
        laggerPhase=2
    end
    refreshSpeedModeLabel()
end

local function setModeNormal()
    speedMode=false;laggerToggled=false;laggerPhase=0;refreshSpeedModeLabel()
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end
    if mobBtnRefs and mobBtnRefs.lagger then mobBtnRefs.lagger(false) end
end
local function setModeCarry()
    speedMode=true;laggerToggled=false;laggerPhase=0;refreshSpeedModeLabel()
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(true) end
    if mobBtnRefs and mobBtnRefs.lagger then mobBtnRefs.lagger(false) end
end

local function stopAutoSwitchSpeed()
    if autoSwitchSpeedConn then autoSwitchSpeedConn:Disconnect();autoSwitchSpeedConn=nil end
end

local function startAutoSwitchSpeed()
    if autoSwitchSpeedConn then return end
    autoSwitchSpeedConn=RunService.Heartbeat:Connect(function()
        if not autoSwitchSpeedEnabled and not autoTurnOffSpeedEnabled and not autoSwitchLaggerSpeedEnabled then stopAutoSwitchSpeed();return end
        local char=LP.Character;if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
        local ws=hum.WalkSpeed or 16
        if autoSwitchSpeedEnabled and ws<=AUTO_SWITCH_THRESHOLD and not speedMode then
            setModeCarry()
        elseif autoTurnOffSpeedEnabled and ws>AUTO_SWITCH_THRESHOLD and speedMode then
            setModeNormal()
        end
        if autoSwitchLaggerSpeedEnabled and ws<=AUTO_SWITCH_THRESHOLD and not laggerToggled then
            speedMode=false
            laggerToggled=true
            laggerPhase=2
            refreshSpeedModeLabel()
            if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end
            if mobBtnRefs and mobBtnRefs.lagger then mobBtnRefs.lagger(true) end
        elseif autoSwitchLaggerSpeedEnabled and ws>AUTO_SWITCH_THRESHOLD and laggerToggled then
            setModeNormal()
        end
    end)
end

local function buildGui()
    local BG    = Color3.fromRGB(6,18,28)
    local BG2   = Color3.fromRGB(8,28,42)
    local CARD  = Color3.fromRGB(10,36,52)
    local HOV   = Color3.fromRGB(14,48,68)
    local WHITE = Color3.fromRGB(0,255,120)
    local WHITEDIM= Color3.fromRGB(80,200,140)
    local STROKE= Color3.fromRGB(30,140,180)
    local W     = Color3.fromRGB(0,230,110)
    local DIM   = Color3.fromRGB(60,160,100)
    local INP   = Color3.fromRGB(8,24,36)
    local OFF   = Color3.fromRGB(12,40,55)
    local old=game:GetService("CoreGui"):FindFirstChild("SummerHub") or game:GetService("CoreGui"):FindFirstChild("Summer");if old then old:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("SummerHub") or pg:FindFirstChild("Summer");if o then o:Destroy() end end
    local gui=Instance.new("ScreenGui")
    gui.Name="Summer";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end
    local main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,320,0,470);main.Position=UDim2.new(0.5,-160,0.5,-235);exeMainFrame=main
    main.BackgroundColor3=BG;main.BackgroundTransparency=1;main.BorderSizePixel=0;main.ClipsDescendants=true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)
    
    -- Summer background image (no overlay)
    local menuBg=Instance.new("ImageLabel",main)
    menuBg.Name="SummerBg"
    menuBg.Size=UDim2.new(1,0,1,0)
    menuBg.Position=UDim2.new(0,0,0,0)
    menuBg.BackgroundTransparency=1
    menuBg.BorderSizePixel=0
    menuBg.Image="rbxassetid://75641712053405"
    menuBg.ImageTransparency=0
    menuBg.ScaleType=Enum.ScaleType.Crop
    menuBg.ZIndex=0
    Instance.new("UICorner",menuBg).CornerRadius=UDim.new(0,12)
    
    local scaleObj=Instance.new("UIScale",main);scaleObj.Scale=uiScale
    local function drag(f,lockable)
        local dn,ds,sp,di=false
        f.InputBegan:Connect(function(i)
            if lockable and uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dn=true;ds=i.Position;sp=f.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false;pcall(saveConfig) end end)
            end
        end)
        f.InputChanged:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
        end)
        UIS.InputChanged:Connect(function(i)
            if lockable and uiLocked then dn=false;return end
            if i==di and dn then
                local nX=sp.X.Offset+(i.Position.X-ds.X)
                local nY=sp.Y.Offset+(i.Position.Y-ds.Y)
                f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
            end
        end)
    end
    drag(main,true)
    local hdr=Instance.new("Frame",main)
    hdr.Size=UDim2.new(1,0,0,44);hdr.BackgroundColor3=BG2;hdr.BackgroundTransparency=0.35;hdr.BorderSizePixel=0;hdr.ZIndex=3
    Instance.new("UICorner",hdr).CornerRadius=UDim.new(0,12)
    local ttl=Instance.new("TextLabel",hdr)
    ttl.Size=UDim2.new(1,0,1,0);ttl.Position=UDim2.new(0,0,0,0)
    ttl.BackgroundTransparency=1;ttl.Text="SUMMER";ttl.ZIndex=5
    ttl.TextColor3=Color3.fromRGB(0,255,120);ttl.Font=Enum.Font.GothamBlack;ttl.TextSize=28
    ttl.TextXAlignment=Enum.TextXAlignment.Center
    ttl.TextYAlignment=Enum.TextYAlignment.Center
    ttl.TextStrokeTransparency=0.25;ttl.TextStrokeColor3=Color3.fromRGB(0,50,30)

    -- Bottom Navigation Bar (Simple buttons, hindi panel)
    local bottomNav=Instance.new("Frame",main)
    bottomNav.Size=UDim2.new(1,0,0,50);bottomNav.Position=UDim2.new(0,0,1,-50);bottomNav.BackgroundColor3=BG2;bottomNav.BorderSizePixel=0;bottomNav.ZIndex=10;bottomNav.BackgroundTransparency=0.15
    Instance.new("UICorner",bottomNav).CornerRadius=UDim.new(0,12)
    local navStroke=Instance.new("UIStroke",bottomNav);navStroke.Color=STROKE;navStroke.Thickness=1
    
    local pages,tabButtons={},{}
    local function selectPage(id)
        for name,page in pairs(pages) do page.Visible=(name==id) end
        for name,btn in pairs(tabButtons) do
            local active=name==id
            TS:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=active and Color3.fromRGB(16,80,100) or Color3.fromRGB(8,24,36),TextColor3=active and WHITE or DIM}):Play()
        end
    end
    
    local tabs={
        {"menu","MENU"},
        {"lock","LOCK"},
        {"aimbot","AIMBOT"},
        {"keys","KEYBINDS"},
        {"config","CONFIG"}
    }
    
    for i,t in ipairs(tabs) do
        local btn=Instance.new("TextButton",bottomNav)
        btn.Size=UDim2.new(0,60,0,40);btn.Position=UDim2.new(0,5+(i-1)*62,0.5,-20)
        btn.BackgroundColor3=Color3.fromRGB(8,24,36);btn.BackgroundTransparency=0;btn.BorderSizePixel=0;btn.Text=t[2];btn.TextColor3=DIM
        btn.Font=Enum.Font.GothamBlack;btn.TextSize=9;btn.ZIndex=11
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
        Instance.new("UIStroke",btn).Color=Color3.fromRGB(30,120,160)
        tabButtons[t[1]]=btn
        btn.MouseEnter:Connect(function() if not pages[t[1]].Visible then TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=HOV,TextColor3=WHITE}):Play() end end)
        btn.MouseLeave:Connect(function() if not pages[t[1]].Visible then TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(10,10,14),TextColor3=DIM}):Play() end end)
        btn.Activated:Connect(function() selectPage(t[1]) end)
    end

    -- Mini button
    local miniBtn=Instance.new("TextButton",gui)
    miniBtn.Size=UDim2.new(0,108,0,28);miniBtn.Position=UDim2.new(0,26,0,26);exeMiniButton=miniBtn
    miniBtn.BackgroundColor3=BG2;miniBtn.BorderSizePixel=0
    miniBtn.Text="SUMMER";miniBtn.TextColor3=Color3.fromRGB(0,255,120);miniBtn.Font=Enum.Font.GothamBlack;miniBtn.TextSize=12
    miniBtn.ZIndex=20;miniBtn.Visible=false
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,8)
    local miniStroke=Instance.new("UIStroke",miniBtn);miniStroke.Color=STROKE;miniStroke.Thickness=1.2
    drag(miniBtn,false)
    miniBtn.MouseEnter:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=HOV}):Play() end)
    miniBtn.MouseLeave:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=BG2}):Play() end)
    local function showGui() main.Visible=true;miniBtn.Visible=false end
    local function hideGui() main.Visible=false;miniBtn.Visible=true end
    
    -- Close button sa header
    local closeBtn=Instance.new("TextButton",hdr)
    closeBtn.Size=UDim2.new(0,28,0,28);closeBtn.Position=UDim2.new(1,-34,0.5,-14);closeBtn.ZIndex=6
    closeBtn.BackgroundColor3=BG2;closeBtn.BackgroundTransparency=1;closeBtn.BorderSizePixel=0;closeBtn.ZIndex=4
    closeBtn.Text="-";closeBtn.TextColor3=Color3.fromRGB(0,255,120);closeBtn.Font=Enum.Font.GothamBold;closeBtn.TextSize=22
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
    closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(32,32,40),TextColor3=WHITEDIM}):Play() end)
    closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.1),{BackgroundColor3=BG2,TextColor3=WHITEDIM}):Play() end)
    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local function mkPage(id)
        local sf=Instance.new("ScrollingFrame",main)
        sf.Size=UDim2.new(1,0,1,-94);sf.Position=UDim2.new(0,0,0,44)
        sf.BackgroundTransparency=1;sf.BorderSizePixel=0;sf.ClipsDescendants=true;sf.Visible=false;sf.ZIndex=3
        sf.ScrollBarThickness=3;sf.ScrollBarImageColor3=WHITE
        sf.CanvasSize=UDim2.new(0,0,0,0);sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
        local ll=Instance.new("UIListLayout",sf);ll.SortOrder=Enum.SortOrder.LayoutOrder;ll.Padding=UDim.new(0,2)
        local pad=Instance.new("UIPadding",sf)
        pad.PaddingLeft=UDim.new(0,7);pad.PaddingRight=UDim.new(0,7)
        pad.PaddingTop=UDim.new(0,7);pad.PaddingBottom=UDim.new(0,7)
        pages[id]=sf
        return sf
    end
    
    local menuPage,lockPage,aimbotPage,keysPage,configPage=mkPage("menu"),mkPage("lock"),mkPage("aimbot"),mkPage("keys"),mkPage("config")
    local loByPage={}
    local function LO(page) loByPage[page]=(loByPage[page] or 0)+1;return loByPage[page] end
    local function mkSect(page,txt)
        local f=Instance.new("Frame",page);f.Size=UDim2.new(1,0,0,22);f.BackgroundTransparency=1;f.BorderSizePixel=0;f.LayoutOrder=LO(page);f.ZIndex=3
        local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,-8,1,0);l.Position=UDim2.new(0,8,0,0)
        l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=WHITE;l.ZIndex=4
        l.Font=Enum.Font.GothamBlack;l.TextSize=9;l.TextXAlignment=Enum.TextXAlignment.Left
        l.TextStrokeTransparency=0.85;l.TextStrokeColor3=Color3.fromRGB(0,0,0)
    end
    local function mkRow(page,h)
        local f=Instance.new("Frame",page);f.Size=UDim2.new(1,0,0,h or 32)
        f.BackgroundColor3=CARD;f.BackgroundTransparency=0.65;f.BorderSizePixel=0;f.LayoutOrder=LO(page);f.ZIndex=3
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)
        local rowStroke=Instance.new("UIStroke",f);rowStroke.Color=Color3.fromRGB(30,120,140);rowStroke.Thickness=0.7;rowStroke.Transparency=0
        f.MouseEnter:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=HOV,BackgroundTransparency=0.55}):Play() end)
        f.MouseLeave:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=CARD,BackgroundTransparency=0.55}):Play() end)
        return f
    end
    local function mkLabel(row,txt)
        local l=Instance.new("TextLabel",row);l.Size=UDim2.new(0.62,0,1,0);l.Position=UDim2.new(0,9,0,0)
        l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=W;l.ZIndex=4
        l.Font=Enum.Font.GothamBlack;l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left
    end
    local function mkPill(row,offset)
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,36,0,19)
        pill.Position=UDim2.new(1,-(offset or 42),0.5,-9.5)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=3
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,13,0,13);dot.Position=UDim2.new(0,3,0.5,-6.5)
        dot.BackgroundColor3=DIM;dot.BorderSizePixel=0;dot.ZIndex=4
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        return pill,dot
    end
    local function animPill(pill,dot,on)
        TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(20,160,120) or OFF}):Play()
        TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5),
            BackgroundColor3=on and WHITE or DIM
        }):Play()
    end
    local function mkToggle(page,txt,cb)
        local row=mkRow(page,32);mkLabel(row,txt)
        local pill,dot=mkPill(row,42)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);cb(on) end)
        pill.ZIndex=3;dot.ZIndex=4
        return sv
    end
    local function mkBox(parent,default,w,xOff,cb)
        local tb=Instance.new("TextBox",parent)
        tb.Size=UDim2.new(0,w or 50,0,22);tb.Position=UDim2.new(1,-(xOff or 56),0.5,-11)
        tb.BackgroundColor3=INP;tb.BorderSizePixel=0;tb.Text=tostring(default);tb.TextColor3=W
        tb.Font=Enum.Font.GothamBlack;tb.TextSize=10;tb.ClearTextOnFocus=false;tb.ZIndex=5
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5)
        local bs=Instance.new("UIStroke",tb);bs.Color=Color3.fromRGB(30,30,38);bs.Thickness=1
        tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=WHITEDIM}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(30,30,38)}):Play()
            if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
        end)
        return tb
    end
    local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
    local function isBindableInput(inp)
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
        return isGamepadInput(inp)
    end
    local function kbMatch(entry,kc) return kc and (kc==entry.kb) end
    local keyRefs={}
    local function keyLabel(entry) return (entry.kb and entry.kb.Name:upper()) or "NONE" end
    local function refreshKeyRefs(entry)
        for _,r in ipairs(keyRefs) do if r.entry==entry then r.btn.Text=keyLabel(entry) end end
    end
    local function mkKBButton(parent,kbEntry)
        local btn=Instance.new("TextButton",parent)
        btn.Size=UDim2.new(0,70,0,22);btn.Position=UDim2.new(1,-76,0.5,-11)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0
        btn.Text=keyLabel(kbEntry);btn.TextColor3=W
        btn.Font=Enum.Font.GothamBlack;btn.TextSize=9;btn.ZIndex=5
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
        table.insert(keyRefs,{entry=kbEntry,btn=btn})
        local listening=false        local conn=nil
        local previous=btn.Text
        local listenStart=0
        local function stopListen(cancel)
            listening=false
            _anyKeyListening=false
            if conn then conn:Disconnect();conn=nil end
            if cancel then btn.Text=previous else refreshKeyRefs(kbEntry) end
            btn.TextColor3=W
        end
        btn.Activated:Connect(function()
            if listening then stopListen(true);return end
            previous=btn.Text
            listening=true
            _anyKeyListening=true
            listenStart=tick()
            btn.Text="..."
            btn.TextColor3=WHITE
            conn=UIS.InputBegan:Connect(function(inp,gpe)
                if not listening then return end
                if inp.KeyCode==Enum.KeyCode.Escape then stopListen(true);return end
                if inp.KeyCode==Enum.KeyCode.Unknown then return end
                if inp.UserInputType~=Enum.UserInputType.Keyboard then return end
                kbEntry.kb=inp.KeyCode
                stopListen(false)
                pcall(saveConfig)
                pcall(function() if saveMobileButtonsConfigOnly then saveMobileButtonsConfigOnly() end end)
            end)
        end)
        return btn
    end
    local function mkKeyRow(page,txt,kbEntry)
        local row=mkRow(page,32);mkLabel(row,txt);mkKBButton(row,kbEntry)
    end
    local function mkModeRow(page)
        local row=mkRow(page,32);mkLabel(row,"Mode")
        modeValLbl=Instance.new("TextLabel",row)
        modeValLbl.Size=UDim2.new(0,110,1,0);modeValLbl.Position=UDim2.new(1,-116,0,0)
        modeValLbl.BackgroundTransparency=1;modeValLbl.Text="NORMAL";modeValLbl.TextColor3=WHITE
        modeValLbl.Font=Enum.Font.GothamBlack;modeValLbl.TextSize=10;modeValLbl.TextXAlignment=Enum.TextXAlignment.Right
        refreshSpeedModeLabel()
    end
    local function mkActionButton(page,labelTxt,btnTxt,cb)
        local row=mkRow(page,32);mkLabel(row,labelTxt)
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,70,0,22);btn.Position=UDim2.new(1,-76,0.5,-11)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0;btn.Text=btnTxt:upper();btn.TextColor3=WHITE
        btn.Font=Enum.Font.GothamBlack;btn.TextSize=9;btn.ZIndex=5
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
        local bs=Instance.new("UIStroke",btn);bs.Color=STROKE;bs.Thickness=1
        btn.MouseEnter:Connect(function() TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=HOV}):Play() end)
        btn.MouseLeave:Connect(function() TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=INP}):Play() end)
        btn.Activated:Connect(cb)
        return btn
    end

    -- ============================================================
    -- MENU PAGE CONTENTS
    -- ============================================================
    mkSect(menuPage,"Speed Configuration")
    do local row=mkRow(menuPage,32);mkLabel(row,"Normal Speed");normalBox=mkBox(row,NS,55,62,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end) end
    do local row=mkRow(menuPage,32);mkLabel(row,"Carry Speed");carryBox=mkBox(row,CS,55,62,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end) end
    mkKeyRow(menuPage,"Speed Key",KB.SpeedToggle)
    mkModeRow(menuPage)
    mkSect(menuPage,"Auto Speed")
    setAutoSwitchSpeedVisual=mkToggle(menuPage,"Auto Switch Speed",function(on) autoSwitchSpeedEnabled=on;if on or autoTurnOffSpeedEnabled or autoSwitchLaggerSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end)
    setAutoSwitchLaggerSpeedVisual=mkToggle(menuPage,"Auto Switch Lagger Speed",function(on) autoSwitchLaggerSpeedEnabled=on;if on or autoSwitchSpeedEnabled or autoTurnOffSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end)
    setAutoTurnOffSpeedVisual=mkToggle(menuPage,"Auto Turn Off Speed",function(on) autoTurnOffSpeedEnabled=on;if on or autoSwitchSpeedEnabled or autoSwitchLaggerSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end)
    mkSect(menuPage,"Lagger Speed")
    do local row=mkRow(menuPage,32);mkLabel(row,"Lagger Normal Speed");laggerBox=mkBox(row,LAGGER_SPEED,55,62,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end) end
    do local row=mkRow(menuPage,32);mkLabel(row,"Lagger Carry Speed");laggerCarryBox=mkBox(row,LAGGER_CARRY_SPEED,55,62,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end) end
    mkKeyRow(menuPage,"Lagger Key",KB.LaggerToggle)
    mkSect(menuPage,"Jump")
    setInfJumpVisual=mkToggle(menuPage,"Infinite Jump",function(on) infJumpEnabled=on;saveConfig() end)
    setAntiRagVisual=mkToggle(menuPage,"Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
    setUnwalkVisual=mkToggle(menuPage,"Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)

    -- LOCK PAGE (Auto Steal toggle na lang, radius/duration nasa new bar)
    mkSect(lockPage,"Steal Configuration")
    setInstaGrab=mkToggle(lockPage,"Auto Steal",function(on) Steal.AutoStealEnabled=on;if on then if not pcall(startAutoSteal) then Steal.AutoStealEnabled=false;if setInstaGrab then setInstaGrab(false) end end else stopAutoSteal() end;saveConfig() end)
    -- Binalik ko ang Radius at Duration inputs dito para ma-edit pa rin
    do local row=mkRow(lockPage,32);mkLabel(row,"Radius");radInput=mkBox(row,Steal.StealRadius,55,62,function(v) if v>=1 and v<=500 then Steal.StealRadius=v else radInput.Text=tostring(Steal.StealRadius) end;saveConfig() end) end
    do local row=mkRow(lockPage,32);mkLabel(row,"Duration");durationBox=mkBox(row,Steal.StealDuration,55,62,function(v) if v>=0.05 and v<=10 then Steal.StealDuration=v else durationBox.Text=tostring(Steal.StealDuration) end;saveConfig() end) end
    mkSect(lockPage,"Counter")
    setMedusaVisual=mkToggle(lockPage,"Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    setBatCounterVisual=mkToggle(lockPage,"Bat Counter",function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)
    mkSect(lockPage,"Body Lock")
    setBodyLockVisual=mkToggle(lockPage,"Body Lock",function(on) setBodyLock(on) end)
    do local row=mkRow(lockPage,32);mkLabel(row,"Body Lock Radius");bodyLockRadiusBox=mkBox(row,bodyLockRadius,55,62,function(v) if v>=1 and v<=500 then bodyLockRadius=v else bodyLockRadiusBox.Text=tostring(bodyLockRadius) end;saveConfig() end) end

    -- AIMBOT PAGE
    mkSect(aimbotPage,"Bat Aimbot")
    do
        local row=mkRow(aimbotPage,32);mkLabel(row,"Bat Aimbot")
        local pill,dot=mkPill(row,42)
        local abOn=false
        local function svAutoBat(s) abOn=s;animPill(pill,dot,s) end
        autoBatSetVisual=svAutoBat
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function() if _anyKeyListening then return end;abOn=not abOn;svAutoBat(abOn);if abOn then queueAutoBatStart() else autoBatEnabled=false;disableAutoBat() end;saveConfig() end)
    end
    do local row=mkRow(aimbotPage,32);mkLabel(row,"Bat Aimbot Speed");autoBatSpeedBox=mkBox(row,AUTO_BAT_SPEED,55,62,function(v) if v and v>0 and v<=500 then AUTO_BAT_SPEED=v else autoBatSpeedBox.Text=tostring(AUTO_BAT_SPEED) end;saveConfig() end) end
    setAimbot2Visual=mkToggle(aimbotPage,"Aimbot 2 (Anti Bat Bypass)",function(on) setAimbot2(on) end)
    setAntiDesyncAimbotVisual=mkToggle(aimbotPage,"Anti Desync Aimbot",function(on) setAntiDesyncAimbot(on) end)
    setAutoSwingVisual=mkToggle(aimbotPage,"Auto Swing",function(on) autoSwingEnabled=on;saveConfig() end)
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
    mkSect(aimbotPage,"Auto Path")
    autoLeftSetVisual=mkToggle(aimbotPage,"Auto Left",function(on) autoLeftEnabled=on;if on then queueAutoLeftStart() else stopAutoLeft() end;saveConfig() end)
    autoRightSetVisual=mkToggle(aimbotPage,"Auto Right",function(on) autoRightEnabled=on;if on then queueAutoRightStart() else stopAutoRight() end;saveConfig() end)

    -- KEYBINDS PAGE (Binalik ko yung Keybinds tab)
    mkSect(keysPage,"Move Keys")
    mkKeyRow(keysPage,"Speed Key",KB.SpeedToggle)
    mkKeyRow(keysPage,"Lagger Key",KB.LaggerToggle)
    mkKeyRow(keysPage,"Drop Brainrot Key",KB.DropBrainrot)
    mkKeyRow(keysPage,"TP Down Key",KB.TPFloor)
    mkKeyRow(keysPage,"Insta Reset Key",KB.InstaReset)
    mkSect(keysPage,"Combat")
    mkKeyRow(keysPage,"Bat Aimbot Key",KB.AutoBat)
    mkKeyRow(keysPage,"Aimbot 2 Key",KB.Aimbot2)
    mkKeyRow(keysPage,"Anti Desync Aimbot Key",KB.AntiDesyncAimbot)
    mkKeyRow(keysPage,"Auto Right Key",KB.AutoRight)
    mkKeyRow(keysPage,"Auto Left Key",KB.AutoLeft)
    mkSect(keysPage,"Interface")
    mkKeyRow(keysPage,"UI Toggle Key",KB.GuiHide)

    -- CONFIG PAGE
    mkSect(configPage,"Visual")
    setAntiLagVisual=mkToggle(configPage,"Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)
    setFpsBoostVisual=mkToggle(configPage,"FPS Boost",function(on) fpsBoostEnabled=on;if on then applyFPSBoost() end;saveConfig() end)
    setStretchRezVisual=mkToggle(configPage,"Stretch Rez",function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end)
    mkSect(configPage,"Camera")
    setFovVisual=mkToggle(configPage,"FOV Change",function(on) setFovEnabled(on);saveConfig() end)
    do local row=mkRow(configPage,32);mkLabel(row,"FOV Value");fovValueBox=mkBox(row,fovValue,55,62,function(v) if v>=30 and v<=120 then fovValue=v;if fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=v end else fovValueBox.Text=tostring(fovValue) end;saveConfig() end) end
    mkActionButton(configPage,"Reset FOV","Reset",function() resetFovAndCamera();if setFovVisual then setFovVisual(false) end;saveConfig() end)
    mkSect(configPage,"Insta Reset")
    mkActionButton(configPage,"Insta Reset","Open",function() openSummerInstaResetPanel() end)
    mkSect(configPage,"Mobile Buttons")
    do
        local row=mkRow(configPage,32);mkLabel(row,"Move Buttons")
        local moveBtn=Instance.new("TextButton",row)
        moveBtn.Size=UDim2.new(0,96,0,22);moveBtn.Position=UDim2.new(1,-102,0.5,-11)
        moveBtn.BackgroundColor3=INP;moveBtn.BorderSizePixel=0;moveBtn.Text=mobileMovingMode and "LOCK BUTTONS" or "MOVE BUTTONS";moveBtn.TextColor3=WHITE
        moveBtn.Font=Enum.Font.GothamBlack;moveBtn.TextSize=8;moveBtn.ZIndex=5
        Instance.new("UICorner",moveBtn).CornerRadius=UDim.new(0,6)
        local mvStroke=Instance.new("UIStroke",moveBtn);mvStroke.Color=STROKE;mvStroke.Thickness=1
        moveBtn.Activated:Connect(function()
            mobileMovingMode=not mobileMovingMode
            moveBtn.Text=mobileMovingMode and "LOCK BUTTONS" or "MOVE BUTTONS"
            buildMobileButtons()
            saveConfig()
        end)
    end
    mkActionButton(configPage,"Reset Buttons","Reset",function() resetMobileButtonPositions() end)
    do
        local row=mkRow(configPage,32);mkLabel(row,"Btn Scale")
        local sizes={60,75,100,125,150}
        local bw=30
        local startX=-6-(#sizes*(bw+3))
        local refs={}
        local function refresh(sel)
            for _,r in ipairs(refs) do
                local a=r.sz==sel
                r.btn.BackgroundColor3=a and Color3.fromRGB(20,160,120) or INP
                r.btn.TextColor3=a and WHITE or W
            end
        end
        for i,sz in ipairs(sizes) do
            local sb=Instance.new("TextButton",row)
            sb.Size=UDim2.new(0,bw,0,20);sb.Position=UDim2.new(1,startX+(i-1)*(bw+3),0.5,-10)
            sb.BackgroundColor3=(mobileButtonsSize==sz) and Color3.fromRGB(20,160,120) or INP;sb.BorderSizePixel=0
            sb.Text=tostring(sz);sb.TextColor3=(mobileButtonsSize==sz) and WHITE or W;sb.Font=Enum.Font.GothamBlack;sb.TextSize=8;sb.ZIndex=5
            Instance.new("UICorner",sb).CornerRadius=UDim.new(0,5);local st=Instance.new("UIStroke",sb);st.Color=STROKE;st.Thickness=1
            table.insert(refs,{btn=sb,sz=sz})
            sb.Activated:Connect(function() mobileButtonsSize=sz;refresh(sz);buildMobileButtons();pcall(saveConfig);saveMobileButtonsConfigOnly() end)
        end
    end
    setMobileDragSmallVisual=mkToggle(configPage,"Drag Small Menu",function(on) mobileDragSmall=on;pcall(saveConfig);saveMobileButtonsConfigOnly() end)
    if mobileDragSmall and setMobileDragSmallVisual then setMobileDragSmallVisual(true) end
    do
        mkSect(configPage,"Btn Shape")
        local shapes={{"circle","Circle"},{"box","Box"},{"straight","Straight"}}
        local row=mkRow(configPage,42)
        for i,sh in ipairs(shapes) do
            local btn=Instance.new("TextButton",row)
            btn.Size=UDim2.new(0,80,0,28);btn.Position=UDim2.new(0,8+(i-1)*88,0.5,-14)
            btn.BackgroundColor3=(mobileButtonShape==sh[1]) and Color3.fromRGB(20,160,120) or INP
            btn.BorderSizePixel=0;btn.Text=sh[2]:upper();btn.TextColor3=(mobileButtonShape==sh[1]) and WHITE or W;btn.Font=Enum.Font.GothamBlack;btn.TextSize=8;btn.ZIndex=5
            Instance.new("UICorner",btn).CornerRadius=sh[1]=="circle" and UDim.new(1,0) or (sh[1]=="straight" and UDim.new(0,0) or UDim.new(0,8))
            local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
            btn.Activated:Connect(function()
                mobileButtonShape=sh[1]
                for _,sib in ipairs(row:GetChildren()) do
                    if sib:IsA("TextButton") then
                        local active=(sib==btn)
                        sib.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP
                        sib.TextColor3=active and WHITE or W
                    end
                end
                buildMobileButtons();pcall(saveConfig)
            end)
        end
    end
    mkSect(configPage,"Interface")
    setLockVisual=mkToggle(configPage,"Lock UI",function(on) uiLocked=on;saveConfig() end)
    do
        local row=mkRow(configPage,32);mkLabel(row,"UI Scale")
        local UI_SCALES={75,90,100,110,125,150}
        local uiBtnW=28
        local uiStartX=-6-(#UI_SCALES*(uiBtnW+2))
        local refs={}
        local function refreshBtns(selected)
            for _,ref in ipairs(refs) do
                local active=ref.sz==selected
                ref.btn.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP
                ref.btn.TextColor3=active and WHITE or W
            end
        end
        local selected=math.floor((uiScale*100)+0.5)
        for i,sz in ipairs(UI_SCALES) do
            local sb=Instance.new("TextButton",row)
            sb.Size=UDim2.new(0,uiBtnW,0,20);sb.Position=UDim2.new(1,uiStartX+(i-1)*(uiBtnW+2),0.5,-10)
            sb.BackgroundColor3=(selected==sz) and Color3.fromRGB(20,160,120) or INP;sb.BorderSizePixel=0
            sb.Text=tostring(sz);sb.TextColor3=(selected==sz) and WHITE or W;sb.Font=Enum.Font.GothamBlack;sb.TextSize=8;sb.ZIndex=5
            Instance.new("UICorner",sb).CornerRadius=UDim.new(0,5)
            local bs=Instance.new("UIStroke",sb);bs.Color=STROKE;bs.Thickness=1
            table.insert(refs,{btn=sb,sz=sz})
            sb.Activated:Connect(function() uiScale=sz/100;scaleObj.Scale=uiScale;refreshBtns(sz);saveConfig() end)
        end
    end

    -- KEYBINDS
    UIS.InputBegan:Connect(function(input,gpe)
        if _anyKeyListening then return end
        if input.UserInputType==Enum.UserInputType.Keyboard then
            if gpe or UIS:GetFocusedTextBox() then return end
        elseif not isGamepadInput(input) then return end
        if not isBindableInput(input) then return end
        local kc=input.KeyCode
        if kbMatch(KB.LaggerToggle,kc) then
            toggleLaggerMode();saveConfig()
        elseif kbMatch(KB.SpeedToggle,kc) then
            toggleCarryMode();saveConfig()
        elseif kbMatch(KB.DropBrainrot,kc) then runJumpDrop()  -- PALITAN: runDropKeybindBurst -> runJumpDrop
        elseif kbMatch(KB.TPFloor,kc) then runTPFloor()
        elseif kbMatch(KB.InstaReset,kc) then cursedInstaReset()
        elseif kbMatch(KB.AutoLeft,kc) then
            autoLeftEnabled=not autoLeftEnabled
            if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            saveConfig()
        elseif kbMatch(KB.AutoRight,kc) then
            autoRightEnabled=not autoRightEnabled
            if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            saveConfig()
        elseif kbMatch(KB.AutoBat,kc) then
            if autoBatEnabled then
                autoBatEnabled=false;disableAutoBat()
                if autoBatSetVisual then autoBatSetVisual(false) end
                if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
            else
                queueAutoBatStart()
                if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
                if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
            end
            saveConfig()
        elseif kbMatch(KB.GuiHide,kc) then if main.Visible then hideGui() else showGui() end
        end
    end)
    selectPage("menu")
end

local _savedCfg = nil
local function loadConfigKeys()
    if not(isfile and isfile("summerMobile.json")) then return end
    local ok,cfg=pcall(function() return HS:JSONDecode(readfile("summerMobile.json")) end)
    if not ok or not cfg then return end
    _savedCfg=cfg
    local function lk(e,d) if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end end
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.AutoBat,cfg.autoBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey)
    lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey);lk(KB.Aimbot2,cfg.aimbot2Key);lk(KB.AntiDesyncAimbot,cfg.antiDesyncAimbotKey)
    if cfg.laggerPanelKey and Enum.KeyCode[cfg.laggerPanelKey] then exeLaggerPanelKey=Enum.KeyCode[cfg.laggerPanelKey] end
    if cfg.normalSpeed then NS=cfg.normalSpeed end
    if cfg.carrySpeed then CS=cfg.carrySpeed end
    if cfg.grabRadius and type(cfg.grabRadius)=="number" then Steal.StealRadius=cfg.grabRadius else Steal.StealRadius=60 end
    if cfg.stealDuration and type(cfg.stealDuration)=="number" then Steal.StealDuration=cfg.stealDuration else Steal.StealDuration=1.4 end
    if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end
    if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
    if cfg.autoBatSpeed and type(cfg.autoBatSpeed)=="number" then AUTO_BAT_SPEED=math.clamp(cfg.autoBatSpeed,1,500) end
    if cfg.bodyLockRadius and type(cfg.bodyLockRadius)=="number" then bodyLockRadius=math.clamp(cfg.bodyLockRadius,1,500) end
    if cfg.uiScale and type(cfg.uiScale)=="number" then uiScale=math.clamp(cfg.uiScale,0.6,1.6) end
    if cfg.uiLocked~=nil then uiLocked=cfg.uiLocked==true end
    if cfg.fovValue and type(cfg.fovValue)=="number" then fovValue=math.clamp(cfg.fovValue,30,120) end
    if cfg.mobileButtonsSize and type(cfg.mobileButtonsSize)=="number" then mobileButtonsSize=cfg.mobileButtonsSize end
    if cfg.mobileButtonShape and type(cfg.mobileButtonShape)=="string" then mobileButtonShape=cfg.mobileButtonShape end
    if cfg.mobileDragSmall~=nil then mobileDragSmall=cfg.mobileDragSmall==true end
    if cfg.mobileMovingMode~=nil then mobileMovingMode=cfg.mobileMovingMode==true end
    if cfg.mobBtnSavedContainerPos and type(cfg.mobBtnSavedContainerPos)=="table" then mobBtnSavedContainerPos=cfg.mobBtnSavedContainerPos end
    if cfg.mobBtnSavedIndPos and type(cfg.mobBtnSavedIndPos)=="table" then mobBtnSavedIndPos=cfg.mobBtnSavedIndPos end
end

local function loadConfigState()
    local cfg=_savedCfg;if not cfg then return end
    if normalBox then normalBox.Text=tostring(NS) end
    if carryBox then carryBox.Text=tostring(CS) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end
    if durationBox then durationBox.Text=tostring(Steal.StealDuration) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
    if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
    if uiScaleBox then uiScaleBox.Text=tostring(uiScale) end
    if fovValueBox then fovValueBox.Text=tostring(fovValue) end
    if bodyLockRadiusBox then bodyLockRadiusBox.Text=tostring(bodyLockRadius) end
    if autoBatSpeedBox then autoBatSpeedBox.Text=tostring(AUTO_BAT_SPEED) end
    if cfg.guiPos and exeMainFrame then exeMainFrame.Position=UDim2.new(cfg.guiPos.xs or 0.5,cfg.guiPos.xo or -160,cfg.guiPos.ys or 0.5,cfg.guiPos.yo or -235) end
    if cfg.miniPos and exeMiniButton then exeMiniButton.Position=UDim2.new(cfg.miniPos.xs or 0,cfg.miniPos.xo or 26,cfg.miniPos.ys or 0,cfg.miniPos.yo or 26) end
    if cfg.grabBarPos and exeGrabBar then exeGrabBar.Position=UDim2.new(cfg.grabBarPos.xs or 0.5,cfg.grabBarPos.xo or -110,cfg.grabBarPos.ys or 1,cfg.grabBarPos.yo or -50) end
    if setLockVisual then setLockVisual(uiLocked) end
    task.spawn(function()
        task.wait(0.15)
        if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
        if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end end
        if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end
        if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
        if cfg.bodyLockEnabled then bodyLockEnabled=true;if setBodyLockVisual then setBodyLockVisual(true) end;startBodyLock() end
        if cfg.laggerMode then laggerToggled=true;speedMode=false;laggerPhase=cfg.laggerCarryMode and 2 or 1;refreshSpeedModeLabel()
        elseif cfg.carryMode then speedMode=false;toggleCarryMode() end
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
        if cfg.autoBat then autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end;queueAutoBatStart() end
        if cfg.aimbot2 then setAimbot2(true) end
        if cfg.antiDesyncAimbot then setAntiDesyncAimbot(true) end
        if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
        if cfg.autoSwitchSpeed then autoSwitchSpeedEnabled=true;if setAutoSwitchSpeedVisual then setAutoSwitchSpeedVisual(true) end;startAutoSwitchSpeed() end
        if cfg.autoTurnOffSpeed then autoTurnOffSpeedEnabled=true;if setAutoTurnOffSpeedVisual then setAutoTurnOffSpeedVisual(true) end;startAutoSwitchSpeed() end
        if cfg.autoSwitchLaggerSpeed then autoSwitchLaggerSpeedEnabled=true;if setAutoSwitchLaggerSpeedVisual then setAutoSwitchLaggerSpeedVisual(true) end;startAutoSwitchSpeed() end
        if cfg.fpsBoostEnabled then fpsBoostEnabled=true;if setFpsBoostVisual then setFpsBoostVisual(true) end;applyFPSBoost() end
        if cfg.fovEnabled then fovEnabled=true;if setFovVisual then setFovVisual(true) end;setFovEnabled(true) end
        if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
        if cfg.stretchRez then enableStretchRez();if setStretchRezVisual then setStretchRezVisual(true) end end
    end)
end

-- ============================================================
-- AUTO STEAL BAR (BAGONG UI) - CLEAN VERSION (NO GEAR, NO LOGO)
-- ============================================================
local StealBarGui = Instance.new("ScreenGui")
StealBarGui.Name = "SummerStealBar"
StealBarGui.IgnoreGuiInset = true
StealBarGui.ResetOnSpawn = false
StealBarGui.DisplayOrder = 999
StealBarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StealBarGui.Parent = LP:WaitForChild("PlayerGui")

-- Shadow
local StealBarShadow = Instance.new("Frame")
StealBarShadow.Name = "StealBarShadow"
StealBarShadow.ZIndex = 9
StealBarShadow.Position = UDim2.new(0.5, -139, 0, 131)
StealBarShadow.Size = UDim2.new(0, 285, 0, 32)
StealBarShadow.BackgroundColor3 = Color3.fromRGB(0, 40, 30)
StealBarShadow.BackgroundTransparency = 0.55
StealBarShadow.BorderSizePixel = 0
StealBarShadow.Parent = StealBarGui
Instance.new("UICorner", StealBarShadow).CornerRadius = UDim.new(0, 14)

-- Main Bar
local StealBar = Instance.new("TextButton")
StealBar.Name = "StealBar"
StealBar.ZIndex = 10
StealBar.ClipsDescendants = true
StealBar.Position = UDim2.new(0.5, -142, 0, 128)
StealBar.Size = UDim2.new(0, 285, 0, 32)
StealBar.BackgroundColor3 = Color3.fromRGB(6, 22, 32)
StealBar.BackgroundTransparency = 0.04
StealBar.BorderSizePixel = 0
StealBar.Text = ""
StealBar.AutoButtonColor = false
StealBar.Parent = StealBarGui
local barCorner = Instance.new("UICorner", StealBar)
barCorner.CornerRadius = UDim.new(0, 14)

-- Stroke
local barStroke = Instance.new("UIStroke", StealBar)
barStroke.Color = Color3.fromRGB(40, 200, 160)
barStroke.Thickness = 1.4
barStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
barStroke.Transparency = 0.18

-- Gradient
local barGrad = Instance.new("UIGradient", StealBar)
barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 90, 110)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(8, 40, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 20, 30))
})
barGrad.Rotation = 90

-- Progress Fill
local progressFill = Instance.new("Frame")
progressFill.Name = "ProgressFill"
progressFill.ZIndex = 11
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(0, 220, 140)
progressFill.BackgroundTransparency = 0.82
progressFill.BorderSizePixel = 0
progressFill.Parent = StealBar
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 14)

-- Title (Progress Text)
local progressTitle = Instance.new("TextLabel")
progressTitle.Name = "ProgressTitle"
progressTitle.ZIndex = 12
progressTitle.Position = UDim2.new(0, 12, 0, 0)
progressTitle.Size = UDim2.new(1, -42, 1, 0)
progressTitle.BackgroundTransparency = 1
progressTitle.Text = "STEALING  |  0%"
progressTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
progressTitle.TextSize = 12
progressTitle.Font = Enum.Font.GothamBlack
progressTitle.TextStrokeTransparency = 0.45
progressTitle.Parent = StealBar

-- TINANGGAL NA ANG SettingsGear AT Dropdown (NO GEAR)

-- ============================================================
-- PROGRESS UPDATE
-- ============================================================
local _lastPct = 0
local _visualSpeed = 0.35
local _decaySpeed = 1.5
RunService.RenderStepped:Connect(function(dt)
    local targetPct = 0
    if isStealing and stealStartTime then
        local rawPct = math.clamp((tick() - stealStartTime) / math.max(Steal.StealDuration, 0.01), 0, 1)
        targetPct = rawPct
    else
        targetPct = 0
    end

    _lastPct = _lastPct + (targetPct - _lastPct) * math.min(dt * _visualSpeed * 60, 1)
    local f = math.clamp(_lastPct, 0, 1)
    progressFill.Size = UDim2.new(f, 0, 1, 0)
    progressTitle.Text = "STEALING  |  " .. math.floor(f * 100) .. "%"
end)

-- ============================================================
-- DRAG HANDLING (Tanging bar lang ang nadradrag)
-- ============================================================
local dragging, dragStart, startPos, startShadowPos = false, nil, nil, nil
StealBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = StealBar.Position
        startShadowPos = StealBarShadow.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UIS.InputChanged:Connect(function(inp)
    if not dragging then return end
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1000, 1000)
        local sz = StealBar.AbsoluteSize
        local newXScalePx = startPos.X.Scale * vp.X
        local newX = math.clamp(newXScalePx + startPos.X.Offset + dx, sz.X / 2, vp.X - sz.X / 2)
        local newY = math.clamp(startPos.Y.Scale * vp.Y + startPos.Y.Offset + dy, 0, vp.Y - sz.Y)
        StealBar.Position = UDim2.new(startPos.X.Scale, newX - newXScalePx, startPos.Y.Scale, newY - startPos.Y.Scale * vp.Y)
        StealBarShadow.Position = UDim2.new(startShadowPos.X.Scale, startShadowPos.X.Offset + dx, startShadowPos.Y.Scale, startShadowPos.Y.Offset + dy)
    end
end)

-- ============================================================
-- LOAD CONFIG AND BUILD
-- ============================================================
loadConfigKeys()
buildGui()
loadConfigState()
buildMobileButtons()

UIS.InputBegan:Connect(function(input,gpe)
    if _anyKeyListening then return end
    if UIS:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.Unknown then return end
    local kc=input.KeyCode
    local function matches(entry)
        return entry and (kc==entry.kb)
    end
    if matches(KB.Aimbot2) then
        setAimbot2(not aimbot2Enabled)
        pcall(saveConfig)
    elseif matches(KB.AntiDesyncAimbot) then
        setAntiDesyncAimbot(not antiDesyncAimbotEnabled)
        pcall(saveConfig)
    end
end)

function openSummerLaggerPanel()
    -- removed
end

function openSummerInstaResetPanel()
    local cg=game:GetService("CoreGui")
    local old=cg:FindFirstChild("SummerInstaResetPanel");if old then old:Destroy();return end
    local g=Instance.new("ScreenGui");g.Name="SummerInstaResetPanel";g.ResetOnSpawn=false;g.DisplayOrder=30;g.IgnoreGuiInset=true
    if not pcall(function() g.Parent=cg end) then g.Parent=LP:WaitForChild("PlayerGui") end
    local frame=Instance.new("Frame",g);frame.Size=UDim2.new(0,150,0,76);frame.Position=UDim2.new(0.5,-75,0,60);frame.BackgroundColor3=Color3.fromRGB(6,18,28);frame.BorderSizePixel=0;frame.Active=true
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,10);local st=Instance.new("UIStroke",frame);st.Color=Color3.fromRGB(30,160,140);st.Thickness=1.2
    local top=Instance.new("Frame",frame);top.Size=UDim2.new(1,0,0,24);top.BackgroundColor3=Color3.fromRGB(8,28,42);top.BorderSizePixel=0;Instance.new("UICorner",top).CornerRadius=UDim.new(0,10)
    local title=Instance.new("TextLabel",top);title.Size=UDim2.new(1,-30,1,0);title.Position=UDim2.new(0,8,0,0);title.BackgroundTransparency=1;title.Text="SUMMER INSTA RESET";title.TextColor3=Color3.fromRGB(0,255,140);title.Font=Enum.Font.GothamBlack;title.TextSize=10;title.TextXAlignment=Enum.TextXAlignment.Left
    local x=Instance.new("TextButton",top);x.Size=UDim2.new(0,18,0,18);x.Position=UDim2.new(1,-22,0.5,-9);x.BackgroundColor3=Color3.fromRGB(28,28,35);x.BorderSizePixel=0;x.Text="X";x.TextColor3=Color3.fromRGB(0,255,120);x.Font=Enum.Font.GothamBlack;x.TextSize=9;Instance.new("UICorner",x).CornerRadius=UDim.new(0,5);x.MouseButton1Click:Connect(function() g:Destroy() end)
    local btn=Instance.new("TextButton",frame);btn.Size=UDim2.new(1,-16,0,24);btn.Position=UDim2.new(0,8,0,30);btn.BackgroundColor3=Color3.fromRGB(10,50,70);btn.BorderSizePixel=0;btn.Text="RESET NOW";btn.TextColor3=Color3.fromRGB(0,255,140);btn.Font=Enum.Font.GothamBlack;btn.TextSize=12;Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7);Instance.new("UIStroke",btn).Color=Color3.fromRGB(30,160,140);btn.MouseButton1Click:Connect(cursedInstaReset)
    local kb=Instance.new("TextButton",frame);kb.Size=UDim2.new(0,64,0,10);kb.Position=UDim2.new(0.5,-32,0,60);kb.BackgroundColor3=Color3.fromRGB(10,10,14);kb.BorderSizePixel=0;kb.Text=(KB.InstaReset.kb and KB.InstaReset.kb.Name:upper()) or "SET KEY";kb.TextColor3=Color3.fromRGB(235,235,235);kb.Font=Enum.Font.GothamBlack;kb.TextSize=6;Instance.new("UICorner",kb).CornerRadius=UDim.new(0,5);Instance.new("UIStroke",kb).Color=Color3.fromRGB(90,90,100)
    kb.MouseButton1Click:Connect(function() exeStartKeyListen(kb,function(key) KB.InstaReset.kb=key;saveConfig() end) end)
    local dragOn,ds,sp=false,nil,nil
    frame.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragOn=true;ds=i.Position;sp=frame.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragOn=false end end) end end)
    UIS.InputChanged:Connect(function(i) if dragOn and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then frame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+i.Position.X-ds.X,sp.Y.Scale,sp.Y.Offset+i.Position.Y-ds.Y) end end)
end

function exeStartKeyListen(btn,onSet)
    if not btn or btn:GetAttribute("Listening") then return end
    btn:SetAttribute("Listening",true)
    _anyKeyListening=true
    local prev=btn.Text
    btn.Text="..."
    btn.TextColor3=Color3.fromRGB(0,255,120)
    local started=tick()
    local conn
    conn=UIS.InputBegan:Connect(function(inp)
        if inp.KeyCode==Enum.KeyCode.Escape then
            if conn then conn:Disconnect() end
            btn:SetAttribute("Listening",false);_anyKeyListening=false;btn.Text=prev
            return
        end
        if inp.UserInputType~=Enum.UserInputType.Keyboard then return end
        if conn then conn:Disconnect() end
        btn:SetAttribute("Listening",false);_anyKeyListening=false
        btn.Text=inp.KeyCode.Name:upper()
        if onSet then onSet(inp.KeyCode) end
    end)
end

function setFovEnabled(on)
    fovEnabled=on
    if on then
        if fovConn then fovConn:Disconnect() end
        fovConn=RunService.RenderStepped:Connect(function()
            if not fovEnabled then if fovConn then fovConn:Disconnect();fovConn=nil end;return end
            if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=fovValue end
        end)
    else
        if fovConn then fovConn:Disconnect();fovConn=nil end
        if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=70 end
    end
end

function resetFovAndCamera()
    setFovEnabled(false)
    if stretchRezEnabled then disableStretchRez();if setStretchRezVisual then setStretchRezVisual(false) end end
    if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=70 end
end

print("SUMMER LOADED - ALL FEATURES FIXED")
