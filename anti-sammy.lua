--[[
  ANTI-SAMMY - GUI ONLY (premium)
  Same feature rows as full Anti-Sammy. No gameplay logic.
  Tabs Layout picker.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local introSoundEnabled = true
local introEnabled = true
local PhoneScales = {}
local IS_PHONE, PHONE_SCALE = false, 1
local function refreshPhoneScale()
	local camera=workspace.CurrentCamera
	local viewport=camera and camera.ViewportSize or Vector2.new(1280,720)
	IS_PHONE=UIS.TouchEnabled and (not UIS.KeyboardEnabled or math.min(viewport.X,viewport.Y)<=700)
	PHONE_SCALE=IS_PHONE and math.clamp(math.min(viewport.X/410,viewport.Y/520),.72,.88) or 1
	for scale,multiplier in pairs(PhoneScales) do
		if scale and scale.Parent then scale.Scale=PHONE_SCALE*multiplier else PhoneScales[scale]=nil end
	end
end
local function addPhoneScale(parent,multiplier)
	local scale=Instance.new("UIScale",parent)
	PhoneScales[scale]=multiplier or 1
	scale.Scale=PHONE_SCALE*(multiplier or 1)
	return scale
end
refreshPhoneScale()
task.defer(function()
	local camera=workspace.CurrentCamera
	if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshPhoneScale) end
end)

local function nebula(method, ...)
	local api = getgenv().AntiSammyNebulaAPI
	if api and api[method] then pcall(api[method], ...); return end
	local args = table.pack(...)
	task.spawn(function()
		for _=1,600 do
			local delayedApi=getgenv().AntiSammyNebulaAPI
			if delayedApi and delayedApi[method] then
				pcall(delayedApi[method],table.unpack(args,1,args.n))
				return
			end
			task.wait(.1)
		end
	end)
end

--[[
    NEBULA RUNTIME
    The original Anti-Sammy file only drew controls.  This state and runtime
    layer is deliberately kept separate from the UI so every row below has a
    real action and can safely be restarted after a respawn.
]]
local State = {
	NormalSpeed = 59.5, CarrySpeed = 28.8, LaggerSpeed = 24.5, LaggerCarrySpeed = 15,
	Carry = false, AutoCarry = false, Lagger = false, NetworkLagger = false, AntiRagdoll = false, InfiniteJump = false,
	MedusaCounter = false, BatAimbot = false, BatCounter = false, AntiDesync = false,
	AutoLeft = false, AutoRight = false, AutoSteal = false, AutoSwing = false, Unwalk = false, StealMode = "Normal",
	StealRadius = 60, AntiLag = false, RemoveAccessories = false, Stretch = false,
	Fov = 80, FovEnabled = false, StretchFov = 120, Headless = false, Korblox = false,
	StealPreset = "86", TPBatVersion = "V1", MobileButtonsLocked = false, MobileButtonsShown = true,
	AutoStealScale = 1, AutoPlayRemoved = false, AutoPlayRows = {},
}
local FrontKeys = {
	Speed = "Q", Lagger = "V", Bypass = "B", Aimbot = "F", TPBat = "N",
	AutoLeft = "Z", AutoRight = "X", Drop = "H", TPDown = "T", HideGUI = "LeftControl",
}
local UtilityKeys = {
	SpeedBypass = "RightBracket",
	NetworkLagger = "BackSlash",
}
local UtilityPanelState = {
	SpeedBypass = {open=false, position=nil},
	NetworkLagger = {open=false, position=nil},
}
State.ESP = false
State.NoCamCollision = true
State.AnimationPack = "Adidas Sports"
State.AnimationPackEnabled = false
State.BypassPower = 100000

-- ============================================================
-- NETWORK LAG / SPEED BYPASS ENGINE (logic only, no extra UI)
-- From N5 Speed Bypass + Rainy Lagger, driven by existing panels
-- ============================================================
local NetLag = {
	bypassOn = false,
	laggerOn = false,
	power = 100000,
	bypassThread = nil,
	laggerThread = nil,
	bomb = nil,
}
local NetworkClient = game:GetService("NetworkClient")

local function buildBomb(power)
	power = math.clamp(math.floor(tonumber(power) or 100000), 10000, 150000)
	local DEPTH = 90
	local maintable, spammedtable = {}, {{}}
	local z = spammedtable[1]
	for _ = 1, DEPTH do
		local tableins = {}
		table.insert(z, tableins)
		z = tableins
	end
	local maxRep = math.floor(power / (DEPTH + 2))
	for _ = 1, maxRep do
		table.insert(maintable, spammedtable)
	end
	return maintable
end

local function createLaggerPayload(amount)
	amount = math.clamp(math.floor(tonumber(amount) or 270), 50, 400)
	local main, spam = {}, {{}}
	local current = spam[1]
	for _ = 1, amount do
		local t = {}
		table.insert(current, t)
		current = t
	end
	local max = math.min(499999 / (amount + 2), 1500)
	for _ = 1, max do
		table.insert(main, spam)
	end
	pcall(function()
		game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
	end)
end

local function stopBypassEngine()
	NetLag.bypassOn = false
	if NetLag.bypassThread then
		pcall(task.cancel, NetLag.bypassThread)
		NetLag.bypassThread = nil
	end
	NetLag.bomb = nil
	pcall(function() NetworkClient:SetOutgoingKBPSLimit(0) end)
end

local function startBypassEngine()
	stopBypassEngine()
	NetLag.bypassOn = true
	NetLag.bomb = buildBomb(NetLag.power)
	pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
	NetLag.bypassThread = task.spawn(function()
		while NetLag.bypassOn do
			if NetLag.bomb then
				pcall(function()
					game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(NetLag.bomb)
				end)
			end
			task.wait(0.12)
		end
	end)
end

local function stopLaggerEngine()
	NetLag.laggerOn = false
	if NetLag.laggerThread then
		pcall(task.cancel, NetLag.laggerThread)
		NetLag.laggerThread = nil
	end
	pcall(function() NetworkClient:SetOutgoingKBPSLimit(0) end)
end

local function startLaggerEngine()
	stopLaggerEngine()
	NetLag.laggerOn = true
	NetLag.laggerThread = task.spawn(function()
		while NetLag.laggerOn do
			pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
			createLaggerPayload(270)
			task.wait(.3)
		end
	end)
end

local function setBypassEnabled(on)
	if on then startBypassEngine() else stopBypassEngine() end
end
local function setLaggerNetEnabled(on)
	if on then startLaggerEngine() else stopLaggerEngine() end
end



-- Silent front-state autosave (no prints / no GUI toasts)
local FRONT_CFG_FILE = "AntiSammy_FrontState.json"
local function silentSaveFront()
	pcall(function()
		if not writefile then return end
		local HS = game:GetService("HttpService")
		local payload = {
			NormalSpeed = State.NormalSpeed,
			CarrySpeed = State.CarrySpeed,
			LaggerSpeed = State.LaggerSpeed,
			LaggerCarrySpeed = State.LaggerCarrySpeed,
			Carry = State.Carry,
			AutoCarry = State.AutoCarry,
			Lagger = State.Lagger,
			NetworkLagger = State.NetworkLagger,
			Fov = State.Fov,
			FovEnabled = State.FovEnabled,
			StretchFov = State.StretchFov,
			Stretch = State.Stretch,
			StealMode = State.StealMode,
			StealPreset = State.StealPreset,
			StealRadius = State.StealRadius,
			InfiniteJump = State.InfiniteJump,
			AntiRagdoll = State.AntiRagdoll,
			MedusaCounter = State.MedusaCounter,
			BatAimbot = State.BatAimbot,
			BatCounter = State.BatCounter,
			TPBat = State.AntiDesync,
			TPBatVersion = State.TPBatVersion,
			AutoSwing = State.AutoSwing,
			AutoSteal = State.AutoSteal,
			AutoLeft = State.AutoLeft,
			AutoRight = State.AutoRight,
			Unwalk = State.Unwalk,
			AntiLag = State.AntiLag,
			Stretch = State.Stretch,
			ESP = State.ESP,
			NoCamCollision = State.NoCamCollision,
			AnimationPack = State.AnimationPack,
			AnimationPackEnabled = State.AnimationPackEnabled,
			Headless = State.Headless,
			Korblox = State.Korblox,
			BypassPower = NetLag.power or State.BypassPower,
			Keys = FrontKeys,
			UtilityKeys = UtilityKeys,
			UtilityPanels = UtilityPanelState,
			MobileButtonsLocked = State.MobileButtonsLocked,
			MobileButtonsShown = State.MobileButtonsShown,
			AutoStealScale = State.AutoStealScale,
			AutoPlayRemoved = State.AutoPlayRemoved,
			IntroEnabled = introEnabled,
			IntroSoundEnabled = introSoundEnabled,
		}
		writefile(FRONT_CFG_FILE, HS:JSONEncode(payload))
	end)
end
local function silentLoadFront()
	pcall(function()
		if not (isfile and readfile and isfile(FRONT_CFG_FILE)) then return end
		local HS = game:GetService("HttpService")
		local ok, data = pcall(function() return HS:JSONDecode(readfile(FRONT_CFG_FILE)) end)
		if not ok or type(data) ~= "table" then return end
		if type(data.NormalSpeed) == "number" then State.NormalSpeed = data.NormalSpeed end
		if type(data.CarrySpeed) == "number" then State.CarrySpeed = data.CarrySpeed end
		if type(data.LaggerSpeed) == "number" then State.LaggerSpeed = data.LaggerSpeed end
		if type(data.LaggerCarrySpeed) == "number" then State.LaggerCarrySpeed = data.LaggerCarrySpeed end
		if type(data.Carry) == "boolean" then State.Carry = data.Carry end
		if type(data.AutoCarry) == "boolean" then State.AutoCarry = data.AutoCarry end
		if type(data.Lagger) == "boolean" then State.Lagger = data.Lagger end
		if type(data.NetworkLagger) == "boolean" then State.NetworkLagger = data.NetworkLagger end
if type(data.Fov) == "number" then State.Fov = math.clamp(data.Fov, 80, 120) end
		if type(data.FovEnabled) == "boolean" then State.FovEnabled = data.FovEnabled end
		if type(data.StretchFov) == "number" then State.StretchFov = (data.StretchFov == 120) and 120 or 80 end
		if type(data.Stretch) == "boolean" then State.Stretch = data.Stretch end
		if type(data.StealMode) == "string" then State.StealMode = data.StealMode end
		if type(data.StealPreset) == "string" then State.StealPreset = data.StealPreset end
		if type(data.StealRadius) == "number" then State.StealRadius = data.StealRadius end
		for _, key in ipairs({"InfiniteJump","AntiRagdoll","MedusaCounter","BatAimbot","BatCounter","AutoSwing","AutoSteal","AutoLeft","AutoRight","Unwalk","AntiLag","Stretch"}) do
			if type(data[key]) == "boolean" then State[key] = data[key] end
		end
		if type(data.TPBat) == "boolean" then State.AntiDesync = data.TPBat end
		if data.TPBatVersion == "V1" or data.TPBatVersion == "V2" then State.TPBatVersion = data.TPBatVersion end
		if type(data.Keys) == "table" then
			for id, keyName in pairs(data.Keys) do
				if FrontKeys[id] ~= nil and type(keyName) == "string" then
					if keyName == "NONE" then
						FrontKeys[id] = "NONE"
					elseif Enum.KeyCode[keyName] then
						FrontKeys[id] = keyName
					end
				end
			end
		end
		if type(data.UtilityKeys) == "table" then
			for id, keyName in pairs(data.UtilityKeys) do
				if UtilityKeys[id] ~= nil and type(keyName) == "string" then
					if keyName == "NONE" or keyName == "Unknown" then
						UtilityKeys[id] = "NONE"
					elseif Enum.KeyCode[keyName] then
						UtilityKeys[id] = keyName
					end
				end
			end
		end
		if type(data.UtilityPanels) == "table" then
			for id, saved in pairs(data.UtilityPanels) do
				local panel = UtilityPanelState[id]
				if panel and type(saved) == "table" then
					if type(saved.open) == "boolean" then panel.open = saved.open end
					local pos = saved.position
					if type(pos) == "table"
						and type(pos.xScale) == "number" and type(pos.xOffset) == "number"
						and type(pos.yScale) == "number" and type(pos.yOffset) == "number" then
						panel.position = pos
					end
				end
			end
		end
		if type(data.ESP) == "boolean" then State.ESP = data.ESP end
		if type(data.NoCamCollision) == "boolean" then State.NoCamCollision = data.NoCamCollision end
		if type(data.AnimationPack) == "string" then State.AnimationPack = data.AnimationPack end
		if type(data.AnimationPackEnabled) == "boolean" then State.AnimationPackEnabled = data.AnimationPackEnabled end
		if type(data.Headless) == "boolean" then State.Headless = data.Headless end
		if type(data.Korblox) == "boolean" then State.Korblox = data.Korblox end
		if type(data.MobileButtonsLocked) == "boolean" then State.MobileButtonsLocked = data.MobileButtonsLocked end
		if type(data.MobileButtonsShown) == "boolean" then State.MobileButtonsShown = data.MobileButtonsShown end
		if type(data.AutoStealScale) == "number" then State.AutoStealScale = math.clamp(data.AutoStealScale, .55, 1.5) end
		if type(data.AutoPlayRemoved) == "boolean" then State.AutoPlayRemoved = data.AutoPlayRemoved end
		if type(data.IntroEnabled) == "boolean" then introEnabled = data.IntroEnabled end
		if type(data.IntroSoundEnabled) == "boolean" then introSoundEnabled = data.IntroSoundEnabled end
		if type(data.BypassPower) == "number" then
			State.BypassPower = data.BypassPower
			NetLag.power = data.BypassPower
		end
	end)
	-- Auto paths are manual-session actions. Never revive them merely because a
	-- previous execution ended while one happened to be active.
	State.AutoLeft, State.AutoRight = false, false
	if State.AutoPlayRemoved then
		FrontKeys.AutoLeft, FrontKeys.AutoRight = "NONE", "NONE"
	end
end
silentLoadFront()

task.spawn(function()
	task.wait(1.2)
	if State.ESP then pcall(function() nebula("setESP", true) end) end
	if State.AnimationPackEnabled and State.AnimationPack then
		pcall(function() nebula("setAnimation", State.AnimationPack) end)
	end
	if State.BypassPower then NetLag.power = State.BypassPower end
	if State.AutoCarry then pcall(function() if _GACC then _GACC.autoCarrySpeedEnabled = true end end) end
end)

getgenv().AntiSammySyncSpeedState=function(lagger,carry)
	State.Lagger=lagger==true
	State.Carry=carry==true
	silentSaveFront()
end
task.spawn(function()
	while task.wait(4) do silentSaveFront() end
end)

local UIActions = {}
local Connections, SpeedBodyForce = {}, nil
local OriginalLighting = nil
local StealBar = {}

local function character()
	return LP.Character
end
local function humanoid()
	local c = character()
	return c and c:FindFirstChildOfClass("Humanoid")
end
local function root()
	local c = character()
	return c and c:FindFirstChild("HumanoidRootPart")
end
local function disconnect(name)
	if Connections[name] then Connections[name]:Disconnect(); Connections[name] = nil end
end
local function activeSpeed()
	if State.Lagger then return State.Carry and State.LaggerCarrySpeed or State.LaggerSpeed end
	return State.Carry and State.CarrySpeed or State.NormalSpeed
end

-- Daily's Undetected Speed logic (BodyForce) — no GUI, driven by State speeds
local function destroySpeed()
	if SpeedBodyForce then
		pcall(function() SpeedBodyForce:Destroy() end)
		SpeedBodyForce = nil
	end
end
local function setupSpeed(hrp)
	if not hrp then return end
	if SpeedBodyForce and SpeedBodyForce.Parent == hrp then return end
	destroySpeed()
	SpeedBodyForce = Instance.new("BodyForce")
	SpeedBodyForce.Name = "AntiSammyDailySpeedBF"
	SpeedBodyForce.Force = Vector3.zero
	SpeedBodyForce.Parent = hrp
end
local function refreshSpeed()
	disconnect("Speed")
	Connections.Speed = RunService.RenderStepped:Connect(function()
		local h, hrp = humanoid(), root()
		if not h or not hrp then return end
		setupSpeed(hrp)
		if not SpeedBodyForce then return end
		local moveDir = h.MoveDirection
		if moveDir.Magnitude > 0.1 then
			-- Explicit Carry mode OR Auto Carry detect (WalkSpeed < 25)
			local carrying = State.Carry or (State.AutoCarry and h.WalkSpeed <= 10 and h.WalkSpeed > 0)
			local targetSpeed
			if State.Lagger then
				targetSpeed = carrying and State.LaggerCarrySpeed or State.LaggerSpeed
			else
				targetSpeed = carrying and State.CarrySpeed or State.NormalSpeed
			end
			local currentVel = hrp.AssemblyLinearVelocity
			local targetVel = moveDir * targetSpeed
			local diff = targetVel - currentVel
			local mass = hrp:GetMass() or 2
			local forceAmount = diff * mass / 0.016
			forceAmount = Vector3.new(forceAmount.X, 0, forceAmount.Z)
			SpeedBodyForce.Force = forceAmount
		else
			SpeedBodyForce.Force = Vector3.zero
		end
	end)
end

-- Anti Ragdoll
local function setAntiRagdoll(on)
	State.AntiRagdoll = on == true
	disconnect("AntiRagdoll")
	if not State.AntiRagdoll then return end

	Connections.AntiRagdoll = RunService.Heartbeat:Connect(function()
		if not State.AntiRagdoll then return end
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return end

		local state = hum:GetState()
		local isRagdolled = state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown
		if not isRagdolled then return end

		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)

			local rootPart = char:FindFirstChild("HumanoidRootPart")
			if rootPart then
				rootPart.Velocity = Vector3.zero
				rootPart.RotVelocity = Vector3.zero
				rootPart.AssemblyLinearVelocity = Vector3.zero
				rootPart.AssemblyAngularVelocity = Vector3.zero
			end

			for _, object in ipairs(char:GetDescendants()) do
				if object:IsA("Motor6D") then object.Enabled = true end
				if object:IsA("Constraint") then object.Enabled = true end
			end

			if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end

			local playerScripts = LP:FindFirstChild("PlayerScripts")
			local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
			local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
			if controlModule then
				local controls = require(controlModule)
				if controls then controls:Enable() end
			end

			hum.AutoRotate = true
			hum.PlatformStand = false
			hum.Sit = false
		end)
	end)
end
local function setInfiniteJump(on)
	State.InfiniteJump = on == true
	nebula("setInfiniteJump", State.InfiniteJump)
	disconnect("InfJump")
	if not State.InfiniteJump then return end
	Connections.InfJump = UIS.JumpRequest:Connect(function()
		if not State.InfiniteJump then return end
		local hrp = root()
		if hrp then
			local v = hrp.AssemblyLinearVelocity
			hrp.AssemblyLinearVelocity = Vector3.new(v.X, 55, v.Z)
		end
	end)
end
local _npCache, _npCacheT = nil, 0
local function nearestPlayer(radius)
	local now = tick()
	if _npCache and now - _npCacheT < 0.08 then
		local hrp = root()
		local tr = _npCache.Character and _npCache.Character:FindFirstChild("HumanoidRootPart")
		if hrp and tr and (tr.Position - hrp.Position).Magnitude <= (radius or math.huge) then
			return _npCache
		end
	end
	local hrp = root(); if not hrp then return nil end
	local best, bestDistance = nil, radius or math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then
			local c = p.Character
			local r = c and c:FindFirstChild("HumanoidRootPart")
			local h = c and c:FindFirstChildOfClass("Humanoid")
			if r and h and h.Health > 0 then
				local d = (r.Position - hrp.Position).Magnitude
				if d < bestDistance then best, bestDistance = p, d end
			end
		end
	end
	_npCache, _npCacheT = best, now
	return best
end
-- ============================================================
-- 7UP ACE AIMBOT (full chase + prediction + equip bat)
-- ============================================================
local AIMBOT_SPEED = 50
local LAGGER_AIMBOT_SPEED = 40
local function _aceFindAimbotBat()
	local c = character(); if not c then return nil end
	for _, t in ipairs(c:GetChildren()) do
		if t:IsA("Tool") then
			local n = t.Name:lower()
			if n:find("bat") or n:find("slap") then return t end
		end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") then
				local n = t.Name:lower()
				if n:find("bat") or n:find("slap") then return t end
			end
		end
	end
	return nil
end
local function _aceGetClosestTargetRoot()
	local hrp = root(); if not hrp then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - hrp.Position).Magnitude
				if dist < minDist then minDist = dist; closest = tRoot end
			end
		end
	end
	return closest
end
local function setBatAimbot(on)
	if on and State.AntiDesync then
		State.AntiDesync = false
		nebula("setBatTP", false, State.TPBatVersion)
	end
	State.BatAimbot = on == true
	disconnect("BatAimbot")
	-- stop backend simple aimbot to avoid double control
	nebula("setAimbot", false)
	local h0 = humanoid()
	local r0 = root()
	if not on then
		if r0 then
			r0.AssemblyLinearVelocity = Vector3.zero
			r0.AssemblyAngularVelocity = Vector3.zero
		end
		if h0 then h0.AutoRotate = true end
		return
	end
	if h0 then h0.AutoRotate = false end
	local swingCd = false
	Connections.BatAimbot = RunService.RenderStepped:Connect(function()
		if not State.BatAimbot then return end
		local char = character(); if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
		local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
		local bat = char:FindFirstChildOfClass("Tool") or _aceFindAimbotBat()
		if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
		local target = _aceGetClosestTargetRoot(); if not target then return end
		local targetVel = target.AssemblyLinearVelocity
		local myPos = hrp.Position
		local targetPos = target.Position
		local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
		local direction = predictPos - myPos
		if direction.Magnitude < 0.01 then return end
		local flatDir = Vector3.new(direction.X, 0, direction.Z)
		if flatDir.Magnitude < 0.01 then return end
		flatDir = flatDir.Unit
		local chaseSpeed = State.Lagger and LAGGER_AIMBOT_SPEED or AIMBOT_SPEED
		local desiredHeight = targetPos.Y + 3.7
		local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
		if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
		yVel = math.clamp(yVel, -70, 110)
		hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity:Lerp(
			Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed), 0.8
		)
		local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local diffCF = hrp.CFrame:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			hrp.AssemblyAngularVelocity = hrp.CFrame:VectorToWorldSpace(Vector3.new(
				math.clamp(rx, -2.5, 2.5) * 42,
				math.clamp(ry, -2.5, 2.5) * 42,
				math.clamp(rz, -2.5, 2.5) * 42
			))
		end
		-- integrated auto-swing while aiming (7UP style)
		if State.AutoSwing and State.BatAimbot and bat and not swingCd then
			swingCd = true
			pcall(function() bat:Activate() end)
			task.delay(0.08, function() swingCd = false end)
		end
	end)
end
local _medusaAnchorConns = {}
local _medusaDebounce, _medusaLastUsed = false, 0
local function _findMedusaTool()
	local c = character()
	if not c then return nil end
	for _, t in ipairs(c:GetChildren()) do
		if t:IsA("Tool") then
			local n = t.Name:lower()
			if n:find("medusa") or n:find("head") or n:find("stone") then return t end
		end
	end
	local bp = LP:FindFirstChildOfClass("Backpack")
	if bp then
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") then
				local n = t.Name:lower()
				if n:find("medusa") or n:find("head") or n:find("stone") then return t end
			end
		end
	end
	return nil
end
local function _useMedusaCounter()
	if _medusaDebounce or tick() - _medusaLastUsed < 0.5 then return end
	local c = character(); if not c then return end
	_medusaDebounce = true
	local med = _findMedusaTool()
	if not med then _medusaDebounce = false; return end
	if med.Parent ~= c then
		local h = humanoid(); if h then pcall(function() h:EquipTool(med) end) end
	end
	pcall(function() med:Activate() end)
	_medusaLastUsed = tick()
	_medusaDebounce = false
end
local function setMedusaCounter(on)
	State.MedusaCounter = on == true
	-- local 7UP anchor logic only (backend medusa also heavy)
	for _, c in pairs(_medusaAnchorConns) do pcall(function() c:Disconnect() end) end
	table.clear(_medusaAnchorConns)
	disconnect("Medusa")
	if not on then return end
	local function watchPart(part)
		if not part:IsA("BasePart") then return end
		table.insert(_medusaAnchorConns, part:GetPropertyChangedSignal("Anchored"):Connect(function()
			if part.Anchored and part.Transparency == 1 then _useMedusaCounter() end
		end))
	end
	local function setupChar(char)
		if not char then return end
		for _, part in ipairs(char:GetDescendants()) do watchPart(part) end
		table.insert(_medusaAnchorConns, char.DescendantAdded:Connect(function(part) watchPart(part) end))
	end
	setupChar(character())
	Connections.Medusa = LP.CharacterAdded:Connect(function(char)
		task.wait(0.2)
		for _, c in pairs(_medusaAnchorConns) do pcall(function() c:Disconnect() end) end
		table.clear(_medusaAnchorConns)
		setupChar(char)
	end)
end
local _batCounterDebounce = false
local _cachedBat, _cachedBatT = nil, 0
local function _findBatTool()
	local now = tick()
	if _cachedBat and _cachedBat.Parent and now - _cachedBatT < 0.35 then
		return _cachedBat
	end
	local c = character()
	if c then
		for _, t in ipairs(c:GetChildren()) do
			if t:IsA("Tool") and t.Name:lower():find("bat") then
				_cachedBat, _cachedBatT = t, now
				return t
			end
		end
	end
	local bp = LP:FindFirstChildOfClass("Backpack")
	if bp then
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") and t.Name:lower():find("bat") then
				_cachedBat, _cachedBatT = t, now
				return t
			end
		end
	end
	_cachedBat = nil
	return nil
end
local function setBatCounter(on)
	State.BatCounter = on == true
	disconnect("BatCounter")
	Connections.BatCounterToken = nil
	_batCounterDebounce = false
	if not on then return end
	local token = {}
	Connections.BatCounterToken = token
	task.spawn(function()
		while Connections.BatCounterToken == token and State.BatCounter do
			if not _batCounterDebounce then
				local h = humanoid()
				if h then
					local st = h:GetState()
					local rag = st == Enum.HumanoidStateType.Physics
						or st == Enum.HumanoidStateType.Ragdoll
						or st == Enum.HumanoidStateType.FallingDown
					if rag then
						_batCounterDebounce = true
						local bat = _findBatTool()
						local c = character()
						if bat and c then
							if bat.Parent ~= c then pcall(function() h:EquipTool(bat) end) end
							pcall(function() bat:Activate() end)
							task.wait(0.15)
							pcall(function() bat:Activate() end)
						end
						task.wait(0.45)
						_batCounterDebounce = false
					end
				end
			end
			task.wait(0.12)
		end
	end)
end
local _autoSwingCooldown = false
local function setAutoSwing(on)
	State.AutoSwing = on == true
	nebula("setAutoSwing", State.AutoSwing)
	disconnect("AutoSwing")
	Connections.AutoSwingToken = nil
	_autoSwingCooldown = false
	if not on then return end
	local token = {}
	Connections.AutoSwingToken = token
	task.spawn(function()
		while Connections.AutoSwingToken == token and State.AutoSwing do
			local combatModeActive = State.BatAimbot or State.AntiDesync
			if not combatModeActive then
				_autoSwingCooldown = false
			elseif not _autoSwingCooldown and nearestPlayer(18) then
				local bat = _findBatTool()
				local c = character()
				local h = humanoid()
				if bat and c and h then
					_autoSwingCooldown = true
					if bat.Parent ~= c then pcall(function() h:EquipTool(bat) end) end
					pcall(function() bat:Activate() end)
					task.wait(0.12)
					_autoSwingCooldown = false
				end
			end
			task.wait(0.1)
		end
	end)
end
local SavedAnimate = nil
local function setUnwalk(on)
	State.Unwalk=on
	nebula("setUnwalk", on)
	local c=character(); if not c then return end
	local animate=c:FindFirstChild("Animate")
	if on and animate then SavedAnimate=animate; animate.Parent=nil
	elseif not on and SavedAnimate and not SavedAnimate.Parent then SavedAnimate.Parent=c; SavedAnimate=nil end
end
local function setAntiDesync(on)
	State.AntiDesync = on == true
	disconnect("AntiDesync")
	if not State.AntiDesync then
		-- clear physics rep when turning off
		local hrp = root()
		if hrp and sethiddenproperty then
			pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
		end
		return
	end
	local hittingCooldown = false
	local function grapeGetBat()
		local char = LP.Character
		if not char then return nil end
		local tool = char:FindFirstChild("Bat")
		if tool then return tool end
		local bp = LP:FindFirstChild("Backpack")
		if bp then
			tool = bp:FindFirstChild("Bat")
			if tool then tool.Parent = char; return tool end
		end
		return nil
	end
	local function grapeTryHit()
		if hittingCooldown then return end
		hittingCooldown = true
		pcall(function()
			local bat = grapeGetBat()
			if bat then
				bat:Activate()
				local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
				if ev then ev:FireServer() end
			end
		end)
		task.delay(0.08, function() hittingCooldown = false end)
	end
	local function grapeClosest()
		local hrp = root()
		if not hrp then return nil end
		local best, bestD = nil, math.huge
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local tr = plr.Character:FindFirstChild("HumanoidRootPart")
				if tr then
					local d = (hrp.Position - tr.Position).Magnitude
					if d < bestD then bestD = d; best = plr end
				end
			end
		end
		return best
	end
	-- GRAPE TP Bat logic
	Connections.AntiDesync = RunService.Heartbeat:Connect(function()
		if not State.AntiDesync then return end
		local hrp = root()
		if not hrp then return end
		local target = grapeClosest()
		if target and target.Character then
			local tr = target.Character:FindFirstChild("HumanoidRootPart")
			if tr then
				if sethiddenproperty then
					pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end)
				end
				local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
				if (hrp.Position - targetPos).Magnitude > 3 then
					hrp.CFrame = CFrame.new(targetPos)
				end
				local cam = workspace.CurrentCamera
				if cam then
					cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
				end
				grapeTryHit()
			end
		end
	end)
end
local function setAutoPath(which, on)
	if State.AutoPlayRemoved and on then return end
	State[which] = on; disconnect(which)
	nebula(which == "AutoLeft" and "setAutoLeft" or "setAutoRight", on)
	if not on then return end
	Connections[which] = RunService.Heartbeat:Connect(function()
		local h = humanoid()
		if h then h:Move(which == "AutoLeft" and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0), false) end
	end)
end
local function findPrompt()
	local hrp, best, bestD = root(), nil, State.StealRadius
	if not hrp then return nil end
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and obj.Enabled then
			local part = obj.Parent and (obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart"))
			if part then local d=(part.Position-hrp.Position).Magnitude; if d < bestD then best,bestD=obj,d end end
		end
	end
	return best
end
local function setAutoSteal(on)
	State.AutoSteal = on == true
	disconnect("AutoSteal")
	getgenv()._AS_StealProgress = 0
	if StealBar.setActive then StealBar.setActive(on) end
	-- force backend steal engine
	nebula("setAutoSteal", on, State.StealMode or "Normal")
	if on then
		-- backup: keep prompting progress visible even before first hit
		task.spawn(function()
			task.wait(0.4)
			if State.AutoSteal and (tonumber(rawget(getgenv(), "_AS_StealProgress")) or 0) == 0 then
				-- soft pulse so user sees bar is live
				if StealBar.setProgress then StealBar.setProgress(0) end
			end
		end)
	end
end

-- 7UP Anti Die (break joints off + heal frames)
local AntiDie = { enabled=false, invincibleUntil=0, healthConn=nil, diedConn=nil, charConn=nil }
local function _antiDieHookHumanoid(hum)
	if AntiDie.healthConn then AntiDie.healthConn:Disconnect(); AntiDie.healthConn=nil end
	if AntiDie.diedConn then AntiDie.diedConn:Disconnect(); AntiDie.diedConn=nil end
	if not hum then return end
	pcall(function()
		hum.BreakJointsOnDeath = false
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end)
	AntiDie.healthConn = hum.HealthChanged:Connect(function(hp)
		if not AntiDie.enabled then return end
		if hp <= 0 or tick() < AntiDie.invincibleUntil then
			pcall(function()
				hum.Health = math.max(hum.Health, hum.MaxHealth * 0.35)
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end)
			AntiDie.invincibleUntil = tick() + 1.2
		end
	end)
	AntiDie.diedConn = hum.Died:Connect(function()
		if not AntiDie.enabled then return end
		pcall(function()
			hum.Health = hum.MaxHealth
			hum:ChangeState(Enum.HumanoidStateType.Running)
			hum.BreakJointsOnDeath = false
		end)
		AntiDie.invincibleUntil = tick() + 1.5
	end)
end
local function setAntiDie(on)
	AntiDie.enabled = on == true
	nebula("setAntiDieFling", on)
	if AntiDie.charConn then AntiDie.charConn:Disconnect(); AntiDie.charConn=nil end
	if not on then
		local h = humanoid()
		if h then pcall(function() h.BreakJointsOnDeath=true; h:SetStateEnabled(Enum.HumanoidStateType.Dead,true) end) end
		return
	end
	_antiDieHookHumanoid(humanoid())
	AntiDie.charConn = LP.CharacterAdded:Connect(function(char)
		task.wait(0.25)
		_antiDieHookHumanoid(char:FindFirstChildOfClass("Humanoid"))
	end)
end

local function setAntiLag(on)
	State.AntiLag = on
	nebula("setAntiLag", on)
	if on then
		OriginalLighting = OriginalLighting or {Brightness=game:GetService("Lighting").Brightness, GlobalShadows=game:GetService("Lighting").GlobalShadows}
		local l=game:GetService("Lighting"); l.GlobalShadows=false; l.Brightness=1
		for _, x in ipairs(workspace:GetDescendants()) do if x:IsA("ParticleEmitter") or x:IsA("Trail") then x.Enabled=false end end
	elseif OriginalLighting then
		local l=game:GetService("Lighting"); l.Brightness=OriginalLighting.Brightness; l.GlobalShadows=OriginalLighting.GlobalShadows
	end
end
local function setStretch(on)
	State.Stretch = on
	nebula("setStretch", on)
	-- The bundled backend defines applyFOV later in this file. During saved-state
	-- startup this callback can run before that definition has been reached.
	if type(applyFOV) == "function" then
		applyFOV()
	end
end
local function tpDown()
	nebula("tpDown")
end
local function drop()
	nebula("drop")
	local h=humanoid(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end
local setESP = (function()
	local highlights, connections, currentMode = {}, {}, "Off"

	local function clear()
		for _, connection in pairs(connections) do
			pcall(function() connection:Disconnect() end)
		end
		for _, highlight in pairs(highlights) do
			pcall(function() highlight:Destroy() end)
		end
		table.clear(connections)
		table.clear(highlights)
		for _, player in ipairs(Players:GetPlayers()) do
			local character = player.Character
			local stale = character and character:FindFirstChild("AntiSammyESP")
			if stale then stale:Destroy() end
		end
	end

	local function attach(player, character)
		if currentMode == "Off" or player == LP or not character then return end
		local previous = highlights[player]
		if previous then previous:Destroy() end
		local stale = character:FindFirstChild("AntiSammyESP")
		if stale then stale:Destroy() end
		local highlight = Instance.new("Highlight")
		highlight.Name = "AntiSammyESP"
		highlight.Adornee = character
		highlight.FillColor = Color3.fromRGB(112, 0, 18)
		highlight.OutlineColor = Color3.fromRGB(255, 38, 64)
		highlight.FillTransparency = currentMode == "Outline" and 1 or .68
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = character
		highlights[player] = highlight
	end

	local function watch(player)
		if player == LP then return end
		attach(player, player.Character)
		connections[player] = player.CharacterAdded:Connect(function(character)
			task.defer(attach, player, character)
		end)
	end

	return function(mode)
		currentMode = mode or "Off"
		clear()
		-- The front interface owns these highlights; disabling the older backend
		-- prevents duplicate outlines and stale adornments after respawn.
		nebula("setESP", false)
		if currentMode == "Off" then return end
		for _, player in ipairs(Players:GetPlayers()) do watch(player) end
		connections.PlayerAdded = Players.PlayerAdded:Connect(watch)
	end
end)()
local function applyCharacterCosmetics()
	local c=character(); if not c then return end
	local head=c:FindFirstChild("Head")
	if head then
		head.Transparency=State.Headless and 1 or 0
		for _,d in ipairs(head:GetDescendants()) do
			if d:IsA("Decal") or d:IsA("Texture") then d.Transparency=State.Headless and 1 or 0 end
		end
	end
	local leg=c:FindFirstChild("RightLowerLeg") or c:FindFirstChild("Right Leg")
	if leg then leg.Transparency=State.Korblox and .45 or 0 end
end

LP.CharacterAdded:Connect(function()
	task.wait(.35)
	refreshSpeed()
	if State.AntiRagdoll then setAntiRagdoll(true) end
	if State.BatAimbot then setBatAimbot(true) end
	if State.AutoSteal then setAutoSteal(true) end
	if State.MedusaCounter then setMedusaCounter(true) end
	if State.BatCounter then setBatCounter(true) end
	-- Always synchronize this setting, including OFF, so Aimbot cannot inherit
	-- the backend's previous/default Auto Swing state.
	setAutoSwing(State.AutoSwing)
	if AntiDie and AntiDie.enabled then setAntiDie(true) end
	applyCharacterCosmetics()
end)
refreshSpeed()

-- Prefer gethui() for exploit UI (hidden from game detection of PlayerGui)
local function getHud()
	-- Always prefer gethui() for exploit UI (hidden from game)
	if typeof(gethui) == "function" then
		local ok, h = pcall(gethui)
		if ok and h then return h end
	end
	local ok2, h2 = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok2 and h2 then return h2 end
	return PlayerGui
end

local function parentGui(sg)
	local hud = getHud()
	local ok = pcall(function() sg.Parent = hud end)
	if not ok then
		pcall(function() sg.Parent = PlayerGui end)
	end
	return sg
end

for _, n in ipairs({"AntiSammyGUI","AntiSammyDuels","AntiSammy_StealBar","AntiSammyBypassModal","AntiSammyLaggerModal","N5MobileControls","ImpulseMobileControls"}) do
	pcall(function()
		local hud = getHud()
		local g = hud:FindFirstChild(n)
		if g then g:Destroy() end
		if PlayerGui and PlayerGui ~= hud then
			local g2 = PlayerGui:FindFirstChild(n)
			if g2 then g2:Destroy() end
		end
		pcall(function()
			local cg = game:GetService("CoreGui")
			local g3 = cg:FindFirstChild(n)
			if g3 then g3:Destroy() end
		end)
	end)
end

local T = {
	bg = Color3.fromRGB(13, 3, 6),
	card = Color3.fromRGB(31, 8, 13),
	hover = Color3.fromRGB(56, 12, 20),
	stroke = Color3.fromRGB(132, 35, 49),
	text = Color3.fromRGB(226, 226, 232),
	dim = Color3.fromRGB(192, 178, 183),
	mute = Color3.fromRGB(174, 72, 86),
	white = Color3.fromRGB(218, 220, 226),
	green = Color3.fromRGB(220, 42, 62),
	danger = Color3.fromRGB(245, 58, 76),
}
local greenTheme = false
local function ACC() return T.green end

local function corner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 12); c.Parent = p; return c
end
local function stroke(p, col, th, tr)
	local s = Instance.new("UIStroke"); s.Color = col or T.stroke; s.Thickness = th or 1; s.Transparency = tr or 0.3; s.Parent = p; return s
end
local function tween(o, ti, props)
	local t = TweenService:Create(o, ti or TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
	t:Play(); return t
end
local function lbl(parent, props)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1; l.Font = Enum.Font.GothamMedium; l.TextColor3 = T.text
	l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = parent
	for k,v in pairs(props or {}) do l[k] = v end
	return l
end
local function drag(frame, handle, movedCallback)
	handle = handle or frame
	local dragging, moved, start, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; moved = false; start = input.Position; startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if moved and movedCallback then movedCallback(frame.Position) end
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - start
			if d.Magnitude > 1 then moved = true end
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "AntiSammyGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 100
parentGui(gui)

------------------------------------------------------------------
local WIN_W, WIN_H, TITLE_H = 360, 460, 46
local shell = Instance.new("Frame", gui)
shell.Size = UDim2.fromOffset(WIN_W, WIN_H)
shell.AnchorPoint = Vector2.new(.5,.5)
shell.Position = UDim2.fromScale(.5,.5)
shell.BackgroundColor3 = T.bg
shell.BackgroundTransparency = 1
shell.BorderSizePixel = 0
shell.ClipsDescendants = false
corner(shell, 14)
stroke(shell, Color3.fromRGB(220,42,62), 1.35, 0.12)
drag(shell)
do
	local sc = addPhoneScale(shell)
	sc.Scale = PHONE_SCALE*.9
	tween(sc, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = PHONE_SCALE})
end

local bgFill = Instance.new("Frame", shell)
bgFill.Size = UDim2.fromScale(1,1)
bgFill.BackgroundColor3 = T.bg
bgFill.BackgroundTransparency = 1
bgFill.BorderSizePixel = 0
bgFill.ZIndex = 0
corner(bgFill, 14)
local bgG = Instance.new("UIGradient", bgFill)
bgG.Rotation = 140
bgG.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(52,7,15)),
	ColorSequenceKeypoint.new(0.52, Color3.fromRGB(24,6,11)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(6,6,8)),
})

local customBg = Instance.new("ImageLabel", shell)
customBg.Size = UDim2.fromScale(1,1)
customBg.BackgroundTransparency = 1
customBg.ScaleType = Enum.ScaleType.Crop
customBg.ImageTransparency = 1
customBg.Visible = false
customBg.ZIndex = 1
corner(customBg, 16)

do
	local sheen = Instance.new("Frame", shell)
	sheen.Size = UDim2.new(1,-28,0,1)
	sheen.Position = UDim2.fromOffset(14,0)
	sheen.BackgroundColor3 = Color3.fromRGB(255,255,255)
	sheen.BorderSizePixel = 0
	sheen.ZIndex = 40
	local sg = Instance.new("UIGradient", sheen)
	sg.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.4,0.3),
		NumberSequenceKeypoint.new(0.6,0.3), NumberSequenceKeypoint.new(1,1),
	})
end

-- title
local titleBar = Instance.new("Frame", shell)
titleBar.Size = UDim2.new(1,0,0,TITLE_H)
titleBar.BackgroundColor3 = Color3.fromRGB(34,5,11)
titleBar.BackgroundTransparency = 0.58
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 10
corner(titleBar, 14)

do
	local titleAccent = Instance.new("Frame", titleBar)
	titleAccent.Size = UDim2.fromOffset(3, 22)
	titleAccent.Position = UDim2.fromOffset(8, 12)
	titleAccent.BackgroundColor3 = ACC()
	titleAccent.BackgroundTransparency = 0.08
	titleAccent.BorderSizePixel = 0
	titleAccent.ZIndex = 13
	corner(titleAccent, 2)

	local headerRule = Instance.new("Frame", titleBar)
	headerRule.Position = UDim2.new(0,14,1,-1)
	headerRule.Size = UDim2.new(1,-28,0,1)
	headerRule.BackgroundColor3 = Color3.fromRGB(220,42,62)
	headerRule.BackgroundTransparency = .42
	headerRule.BorderSizePixel = 0
	headerRule.ZIndex = 13
	local headerRuleGradient = Instance.new("UIGradient", headerRule)
	headerRuleGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(.18,.12),
		NumberSequenceKeypoint.new(.72,.45), NumberSequenceKeypoint.new(1,1),
	})
end

-- Anti-Sammy icon (left of title)
local titleIcon = Instance.new("ImageLabel", titleBar)
titleIcon.Size = UDim2.fromOffset(30, 30)
titleIcon.Position = UDim2.fromOffset(16, 8)
titleIcon.BackgroundTransparency = 1
titleIcon.BorderSizePixel = 0
titleIcon.ScaleType = Enum.ScaleType.Fit
titleIcon.ZIndex = 12
titleIcon.Image = ""
pcall(function()
	if getcustomasset and isfile and isfile("AntiSammyIcon.png") then
		titleIcon.Image = getcustomasset("AntiSammyIcon.png")
	elseif getcustomasset then
		titleIcon.Image = getcustomasset("AntiSammyIcon.png")
	end
end)
-- if steal bar not run yet, try after short delay
task.defer(function()
	task.wait(0.15)
	pcall(function()
		if (not titleIcon.Image or titleIcon.Image == "") and getcustomasset then
			titleIcon.Image = getcustomasset("AntiSammyIcon.png")
		end
	end)
end)

do
	local titleText=lbl(titleBar, {
		Position=UDim2.fromOffset(54,8), Size=UDim2.fromOffset(200,21),
		Text="ANTI-SAMMY", Font=Enum.Font.GothamBold, TextSize=16,
		TextColor3=Color3.fromRGB(255,255,255), ZIndex=12,
	})
	local titleGradient=Instance.new("UIGradient",titleText)
	titleGradient.Rotation=0
	titleGradient.Color=ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.fromRGB(255,54,78)),
		ColorSequenceKeypoint.new(.32,Color3.fromRGB(255,112,126)),
		ColorSequenceKeypoint.new(.62,Color3.fromRGB(205,28,72)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(255,42,58)),
	})
end
local sub = lbl(titleBar, {
	Position=UDim2.fromOffset(54,25), Size=UDim2.fromOffset(200,12),
	Text="", TextColor3=T.dim, TextSize=10, ZIndex=12,
})
local brandIcon = sub -- stub so theme toggle still works

local function hbtn(x, txt, danger)
	local b = Instance.new("TextButton", titleBar)
	b.Size = UDim2.fromOffset(26,26)
	b.Position = UDim2.new(1,x,0.5,-13)
	b.BackgroundColor3 = danger and Color3.fromRGB(0,0,0) or T.card
	b.BackgroundTransparency = danger and 1 or 0
	b.BorderSizePixel = 0
	b.Text = txt
	b.TextColor3 = danger and T.danger or T.dim
	b.Font = Enum.Font.GothamBold
	b.TextSize = danger and 16 or 12
	b.AutoButtonColor = false
	b.ZIndex = 15
	if not danger then
		corner(b, 8)
		stroke(b, T.stroke, 1, 0.4)
	end
	b.MouseEnter:Connect(function()
		if danger then
			b.TextColor3 = Color3.fromRGB(255, 60, 80)
		else
			tween(b, nil, {BackgroundColor3=T.hover, TextColor3=T.text})
		end
	end)
	b.MouseLeave:Connect(function()
		if danger then
			b.TextColor3 = T.danger
		else
			tween(b, nil, {BackgroundColor3=T.card, TextColor3=T.dim})
		end
	end)
	return b
end
local closeBtn = hbtn(-30, "X", false)
closeBtn.TextColor3 = T.text
closeBtn.TextSize = 14
closeBtn.ZIndex = 30
closeBtn.Active = true

------------------------------------------------------------------
-- CONTENT + TABS
------------------------------------------------------------------
local content = Instance.new("Frame", shell)
content.Size = UDim2.new(1,-16,1,-(TITLE_H+56))
content.Position = UDim2.fromOffset(8, TITLE_H+5)
content.BackgroundColor3 = Color3.fromRGB(24,5,10)
content.BackgroundTransparency = 0.72
content.BorderSizePixel = 0
content.ZIndex = 5
corner(content, 10)
stroke(content, Color3.fromRGB(151,32,49), 1, 0.30)

local scroll = Instance.new("ScrollingFrame", content)
scroll.Size = UDim2.fromScale(1,1)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = T.stroke
scroll.CanvasSize = UDim2.fromOffset(0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ZIndex = 6
local pad = Instance.new("UIPadding", scroll)
pad.PaddingTop = UDim.new(0,7); pad.PaddingBottom = UDim.new(0,10)
pad.PaddingLeft = UDim.new(0,8); pad.PaddingRight = UDim.new(0,8)

local tabBar = Instance.new("Frame", shell)
tabBar.Size = UDim2.new(1,-16,0,40)
tabBar.Position = UDim2.new(0,8,1,-46)
tabBar.BackgroundColor3 = Color3.fromRGB(16,5,9)
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 12
corner(tabBar, 11)
stroke(tabBar, Color3.fromRGB(103,27,39), 1, 0.62)
local tabList = Instance.new("UIListLayout", tabBar)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0,4)
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.VerticalAlignment = Enum.VerticalAlignment.Center
local tabPad = Instance.new("UIPadding", tabBar)
tabPad.PaddingLeft = UDim.new(0,6); tabPad.PaddingRight = UDim.new(0,6)

local TABS = {"Main","Combat","Opt","Config","Other","Binds"}
local TAB_LABELS = {Main="HOME", Combat="COMBAT", Opt="TOOLS", Config="CONFIG", Other="MORE", Binds="BINDS"}
local pages, tabBtns, current = {}, {}, "Main"
local LO = 0
local function nextLO() LO += 1; return LO end

local function makePage(name)
	local p = Instance.new("Frame", scroll)
	p.Name = name
	p.Size = UDim2.new(1,-2,0,0)
	p.AutomaticSize = Enum.AutomaticSize.Y
	p.BackgroundTransparency = 1
	p.Visible = false
	p.ZIndex = 7
	local lay = Instance.new("UIListLayout", p)
	lay.Padding = UDim.new(0,6)
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	pages[name] = p
	return p
end
for _, n in ipairs(TABS) do makePage(n) end

local function selectTab(name)
	current = name
	for _, n in ipairs(TABS) do
		local on = n == name
		if pages[n] then
			pages[n].Visible = on
			if on then
				local pageScale=pages[n]:FindFirstChild("PageScale") or Instance.new("UIScale",pages[n])
				pageScale.Name="PageScale"; pageScale.Scale=.975
				tween(pageScale,TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Scale=1})
			end
		end
		local b = tabBtns[n]
		if b then
			tween(b, nil, {
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BackgroundTransparency = 1,
			})
			local L = b:FindFirstChild("L")
			if L then tween(L,TweenInfo.new(.18),{TextColor3=on and Color3.fromRGB(255,244,247) or T.mute}) end
			local I = b:FindFirstChild("Indicator")
			if I then tween(I, TweenInfo.new(.22), {BackgroundTransparency=on and 0 or 1, Size=on and UDim2.new(.48,0,0,2) or UDim2.new(0,0,0,2)}) end
			local S = b:FindFirstChild("TabStroke")
			if S then tween(S,TweenInfo.new(.18),{Color=on and Color3.fromRGB(255,76,99) or Color3.fromRGB(91,27,38),Transparency=on and .08 or .82,Thickness=on and 1.3 or 1}) end
			local Z=b:FindFirstChild("TabScale")
			if Z then tween(Z,TweenInfo.new(.18),{Scale=on and 1.025 or 1}) end
		end
	end
end

for i, name in ipairs(TABS) do
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(1/#TABS,-4,0,31)
	b.BackgroundColor3 = Color3.fromRGB(255,255,255)
	b.BackgroundTransparency = 1
	b.BorderSizePixel = 0
	b.Text = ""
	b.AutoButtonColor = false
	b.LayoutOrder = i
	b.ZIndex = 13
	corner(b, 8)
	local tabStroke = stroke(b, Color3.fromRGB(91,27,38), 1, .72)
	tabStroke.Name = "TabStroke"
	local tabScale=Instance.new("UIScale",b);tabScale.Name="TabScale";tabScale.Scale=1
	lbl(b, {
		Name="L", Position=UDim2.fromOffset(3,0), Size=UDim2.new(1,-6,1,0), Text=TAB_LABELS[name] or name:upper(), Font=Enum.Font.GothamBold,
		TextSize=9, TextColor3=T.mute, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=14,
	})
	local indicator = Instance.new("Frame", b)
	indicator.Name = "Indicator"; indicator.AnchorPoint = Vector2.new(.5,1)
	indicator.Position = UDim2.new(.5,0,1,-2); indicator.Size = UDim2.new(0,0,0,2)
	indicator.BackgroundColor3 = ACC(); indicator.BackgroundTransparency = 1
	indicator.BorderSizePixel = 0; indicator.ZIndex = 15; corner(indicator,2)
	b.MouseEnter:Connect(function()
		if current ~= name then
			tween(b, TweenInfo.new(.16), {BackgroundTransparency=1})
			tween(tabScale,TweenInfo.new(.16),{Scale=1.025})
			local label=b:FindFirstChild("L"); if label then tween(label,TweenInfo.new(.16),{TextColor3=Color3.fromRGB(255,105,123)}) end
		end
	end)
	b.MouseLeave:Connect(function()
		if current ~= name then
			tween(b, TweenInfo.new(.18), {BackgroundColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=1})
			tween(tabScale,TweenInfo.new(.18),{Scale=1})
			local label=b:FindFirstChild("L"); if label then tween(label,TweenInfo.new(.18),{TextColor3=T.mute}) end
		end
	end)
	b.MouseButton1Click:Connect(function() selectTab(name) end)
	tabBtns[name] = b
end

------------------------------------------------------------------
-- BUILDERS
------------------------------------------------------------------
local function section(page, text)
	local holder = Instance.new("Frame", page)
	holder.Size = UDim2.new(1,0,0,24)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.LayoutOrder = nextLO()
	holder.ZIndex = 8
	local mark = Instance.new("Frame", holder)
	mark.Position = UDim2.fromOffset(3,9); mark.Size = UDim2.fromOffset(6,6)
	mark.BackgroundColor3 = ACC(); mark.BorderSizePixel = 0; mark.ZIndex = 9; corner(mark,4)
	lbl(holder, {
		Position=UDim2.fromOffset(15,0), Size=UDim2.fromOffset(126,24), Text=string.upper(text), TextSize=9,
		Font=Enum.Font.GothamBold, TextColor3=Color3.fromRGB(223,139,151), ZIndex=9,
	})
	local divider=Instance.new("Frame",holder)
	divider.Position=UDim2.fromOffset(142,12);divider.Size=UDim2.new(1,-146,0,1)
	divider.BackgroundColor3=Color3.fromRGB(137,34,50);divider.BackgroundTransparency=.52
	divider.BorderSizePixel=0;divider.ZIndex=9
	local fade=Instance.new("UIGradient",divider)
	fade.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.12),NumberSequenceKeypoint.new(1,1)})
	return holder
end

local function card(page, h)
	local r = Instance.new("Frame", page)
	r.Size = UDim2.new(1,-2,0,h or 38)
	r.BackgroundColor3 = T.card
	r.BackgroundTransparency = 0.56
	r.BorderSizePixel = 0
	r.LayoutOrder = nextLO()
	r.ZIndex = 8
	corner(r, 10)
	local rowStroke = stroke(r, Color3.fromRGB(132,30,45), 1, 0.38)
	local edge = Instance.new("Frame", r)
	edge.Name = "RedEdge"; edge.Size = UDim2.fromOffset(3,16); edge.Position = UDim2.new(0,0,.5,-8)
	edge.BackgroundColor3 = ACC(); edge.BackgroundTransparency = .34; edge.BorderSizePixel = 0; edge.ZIndex = 10
	corner(edge,2)
	r.Active = true
	r.MouseEnter:Connect(function()
		tween(r,TweenInfo.new(.16),{BackgroundColor3=T.hover,BackgroundTransparency=.34})
		tween(rowStroke,TweenInfo.new(.16),{Color=ACC(),Transparency=.04})
		tween(edge,TweenInfo.new(.16),{Size=UDim2.fromOffset(3,24),Position=UDim2.new(0,0,.5,-12),BackgroundTransparency=0})
	end)
	r.MouseLeave:Connect(function()
		tween(r,TweenInfo.new(.20),{BackgroundColor3=T.card,BackgroundTransparency=.56})
		tween(rowStroke,TweenInfo.new(.20),{Color=Color3.fromRGB(132,30,45),Transparency=.38})
		tween(edge,TweenInfo.new(.20),{Size=UDim2.fromOffset(3,16),Position=UDim2.new(0,0,.5,-8),BackgroundTransparency=.34})
	end)

	return r
end

local function toggle(page, name, on, changed)
	local state = on and true or false
	local r = card(page, 42)
	lbl(r, {
		Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-58,1,0),
		Text=name, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=9,
	})
	local pill = Instance.new("Frame", r)
	pill.Size = UDim2.fromOffset(40,20)
	pill.Position = UDim2.new(1,-50,0.5,-10)
	pill.BackgroundColor3 = state and ACC() or Color3.fromRGB(48,10,18)
	pill.BackgroundTransparency = .28
	pill.BorderSizePixel = 0
	pill.ZIndex = 10
	corner(pill, 10)
	local pillStroke=stroke(pill,state and Color3.fromRGB(255,111,126) or Color3.fromRGB(113,30,43),1,state and .12 or .44)
	local dot = Instance.new("Frame", pill)
	dot.Size = UDim2.fromOffset(16,16)
	dot.Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.fromOffset(2,2)
	dot.BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,210)
	dot.BorderSizePixel = 0
	dot.ZIndex = 11
	corner(dot, 8)
	local hit = Instance.new("TextButton", r)
	hit.Size = UDim2.fromScale(1,1); hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=12
	hit.MouseButton1Click:Connect(function()
		state = not state
		tween(pill, TweenInfo.new(0.2), {BackgroundColor3 = state and ACC() or Color3.fromRGB(48,10,18)})
		tween(pillStroke,TweenInfo.new(.2),{Color=state and Color3.fromRGB(255,111,126) or Color3.fromRGB(113,30,43),Transparency=state and .12 or .44})
		tween(dot, TweenInfo.new(0.22, Enum.EasingStyle.Back), {
			Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.fromOffset(2,2),
			BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,210),
		})
		if changed then changed(state) end
		silentSaveFront()
	end)
	return r
end

-- Toggle with an expandable V1/V2 selector directly below its row.
local function expandableToggle(page, name, initialOn, versions, initialVersion, changed, versionChanged)
	local state, selected, open = initialOn == true, initialVersion or versions[1], false
	local r = card(page, 42)
	lbl(r, {Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-94,1,0), Text=name, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=9})
	local arrow=Instance.new("TextButton",r); arrow.Size=UDim2.fromOffset(28,24); arrow.Position=UDim2.new(1,-80,.5,-12); arrow.BackgroundColor3=Color3.fromRGB(45,8,15); arrow.BackgroundTransparency=.14; arrow.BorderSizePixel=0; arrow.Text="▼"; arrow.TextColor3=T.text; arrow.Font=Enum.Font.GothamBold; arrow.TextSize=11; arrow.ZIndex=11; corner(arrow,7); stroke(arrow,T.stroke,1,.35)
	arrow.ZIndex=13
	local pill=Instance.new("Frame",r); pill.Size=UDim2.fromOffset(36,18); pill.Position=UDim2.new(1,-46,.5,-9); pill.BackgroundColor3=state and ACC() or Color3.fromRGB(48,10,18); pill.BackgroundTransparency=.28; pill.BorderSizePixel=0; pill.ZIndex=10; corner(pill,9); stroke(pill,state and Color3.fromRGB(255,111,126) or Color3.fromRGB(113,30,43),1,state and .12 or .44)
	local dot=Instance.new("Frame",pill); dot.Size=UDim2.fromOffset(14,14); dot.Position=state and UDim2.new(1,-16,.5,-7) or UDim2.fromOffset(2,2); dot.BackgroundColor3=state and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,210); dot.BorderSizePixel=0; dot.ZIndex=11; corner(dot,7)
	local hit=Instance.new("TextButton",r); hit.Size=UDim2.new(1,-84,1,0); hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=12
	local pillHit=Instance.new("TextButton",pill); pillHit.Size=UDim2.fromScale(1,1); pillHit.BackgroundTransparency=1; pillHit.Text=""; pillHit.ZIndex=13
	local drop=Instance.new("Frame",page); drop.Size=UDim2.new(1,-2,0,0); drop.BackgroundTransparency=1; drop.BorderSizePixel=0; drop.ClipsDescendants=true; drop.LayoutOrder=nextLO(); drop.ZIndex=8
	local panel=Instance.new("Frame",drop); panel.Size=UDim2.new(1,0,0,34); panel.BackgroundColor3=T.card; panel.BackgroundTransparency=.15; panel.BorderSizePixel=0; panel.ZIndex=9; corner(panel,9); stroke(panel,T.stroke,1,.3)
	local count=#versions
	local versionButtons, versionStrokes = {}, {}
	local function refreshVersionGlow()
		for version, button in pairs(versionButtons) do
			local active = version == selected
			-- Active version uses a clean glowing outline only, never a filled box.
			tween(button, TweenInfo.new(.16, Enum.EasingStyle.Quint), {BackgroundTransparency=1})
			local text=button:FindFirstChild("Label")
			if text then tween(text, TweenInfo.new(.16), {TextColor3=active and ACC() or T.text}) end
			local s=versionStrokes[version]
			if s then tween(s, TweenInfo.new(.16), {Color=active and ACC() or T.stroke, Transparency=active and .02 or .35, Thickness=active and 1.5 or 1}) end
		end
	end
	for index,version in ipairs(versions) do
		local box=Instance.new("Frame",panel); box.Size=UDim2.new(1/count,-8,1,-8); box.Position=UDim2.new((index-1)/count,4,0,4); box.BackgroundTransparency=1; box.BorderSizePixel=0; box.ZIndex=14; corner(box,7)
		local b=Instance.new("TextButton",box); b.Name="Label"; b.Size=UDim2.fromScale(1,1); b.BackgroundTransparency=1; b.BorderSizePixel=0; b.Text=version; b.TextColor3=T.text; b.Font=Enum.Font.GothamBold; b.TextSize=11; b.ZIndex=15
		versionButtons[version]=box; versionStrokes[version]=stroke(box,T.stroke,1,.28)
		b.MouseButton1Click:Connect(function() selected=version; refreshVersionGlow(); if versionChanged then versionChanged(version,state) end end)
	end
	refreshVersionGlow()
	local function toggleState()
		state=not state
		tween(pill,TweenInfo.new(.2),{BackgroundColor3=state and ACC() or Color3.fromRGB(48,10,18)})
		tween(dot,TweenInfo.new(.2),{Position=state and UDim2.new(1,-16,.5,-7) or UDim2.fromOffset(2,2),BackgroundColor3=state and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,210)})
		if changed then changed(state,selected) end
	end
	hit.MouseButton1Click:Connect(toggleState)
	pillHit.MouseButton1Click:Connect(toggleState)
	arrow.MouseButton1Click:Connect(function() open=not open; arrow.Text=open and "▲" or "▼"; tween(drop,TweenInfo.new(.2),{Size=open and UDim2.new(1,-2,0,36) or UDim2.new(1,-2,0,0)}) end)
	return r
end

-- Arrow-driven choice row used by Auto Steal preset and Auto Play.
local fovValue=80
local fovOptions={80,120}
local fovIndex=1
local function expandableChoiceRow(page, name, options, initial, changed)
	local selected, open = initial or options[1], false
	local r=card(page,42)
	lbl(r,{Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-135,1,0),Text=name,Font=Enum.Font.GothamBold,TextSize=12,ZIndex=9})
	local value=Instance.new("TextLabel",r); value.Size=UDim2.fromOffset(52,22); value.Position=UDim2.new(1,-92,.5,-11); value.BackgroundTransparency=1; value.Text=selected; value.TextColor3=T.text; value.Font=Enum.Font.GothamBold; value.TextSize=11; value.ZIndex=11
	local arrow=Instance.new("TextButton",r); arrow.Size=UDim2.fromOffset(28,24); arrow.Position=UDim2.new(1,-42,.5,-12); arrow.BackgroundColor3=Color3.fromRGB(48,8,16); arrow.BackgroundTransparency=.28; arrow.BorderSizePixel=0; arrow.Text="▼"; arrow.TextColor3=T.text; arrow.Font=Enum.Font.GothamBold; arrow.TextSize=11; arrow.ZIndex=13; corner(arrow,7); stroke(arrow,T.stroke,1,.35)
	local drop=Instance.new("Frame",page); drop.Size=UDim2.new(1,-2,0,0); drop.BackgroundTransparency=1; drop.BorderSizePixel=0; drop.ClipsDescendants=true; drop.LayoutOrder=nextLO(); drop.ZIndex=8
	local panel=Instance.new("Frame",drop); panel.Size=UDim2.new(1,0,0,34); panel.BackgroundColor3=T.card; panel.BackgroundTransparency=.15; panel.BorderSizePixel=0; panel.ZIndex=9; corner(panel,9); stroke(panel,T.stroke,1,.3)
	local buttons, strokes = {}, {}
	local function refresh()
		for option,box in pairs(buttons) do local active=option==selected; local s=strokes[option]; if s then s.Color=active and ACC() or T.stroke; s.Transparency=active and .02 or .35; s.Thickness=active and 1.5 or 1 end; local tx=box:FindFirstChild("Text"); if tx then tx.TextColor3=active and ACC() or T.text end end
	end
	for index,option in ipairs(options) do
		local box=Instance.new("Frame",panel); box.Size=UDim2.new(1/#options,-8,1,-8); box.Position=UDim2.new((index-1)/#options,4,0,4); box.BackgroundTransparency=1; box.BorderSizePixel=0; box.ZIndex=14; corner(box,7); buttons[option]=box; strokes[option]=stroke(box,T.stroke,1,.35)
		local b=Instance.new("TextButton",box); b.Name="Text"; b.Size=UDim2.fromScale(1,1); b.BackgroundTransparency=1; b.Text=option; b.TextColor3=T.text; b.Font=Enum.Font.GothamBold; b.TextSize=10; b.ZIndex=15
		b.MouseButton1Click:Connect(function() selected=option; value.Text=option; refresh(); if changed then changed(option) end end)
	end
	refresh()
	arrow.MouseButton1Click:Connect(function() open=not open; arrow.Text=open and "▲" or "▼"; tween(drop,TweenInfo.new(.2),{Size=open and UDim2.new(1,-2,0,36) or UDim2.new(1,-2,0,0)}) end)
	return r
end

local function fovControlRow(page)
	local open=false
	local r=card(page,42)
	lbl(r,{Position=UDim2.fromOffset(46,0),Size=UDim2.new(1,-150,1,0),Text="FOV",Font=Enum.Font.GothamBold,TextSize=12,ZIndex=9})
	local toggleBtn=Instance.new("TextButton",r)
	toggleBtn.Size=UDim2.fromOffset(30,22); toggleBtn.Position=UDim2.fromOffset(12,10)
	toggleBtn.BorderSizePixel=0; toggleBtn.Font=Enum.Font.GothamBold; toggleBtn.TextSize=8; toggleBtn.ZIndex=13
	corner(toggleBtn,6)
	local value=Instance.new("TextLabel",r)
	value.Size=UDim2.fromOffset(52,22); value.Position=UDim2.new(1,-92,.5,-11)
	value.BackgroundTransparency=1; value.Text=tostring(fovValue); value.TextColor3=T.text
	value.Font=Enum.Font.GothamBold; value.TextSize=11; value.ZIndex=11
	local arrow=Instance.new("TextButton",r)
	arrow.Size=UDim2.fromOffset(28,24); arrow.Position=UDim2.new(1,-42,.5,-12)
	arrow.BackgroundColor3=Color3.fromRGB(48,8,16); arrow.BackgroundTransparency=.28; arrow.BorderSizePixel=0; arrow.Text="▼"
	arrow.TextColor3=T.text; arrow.Font=Enum.Font.GothamBold; arrow.TextSize=11; arrow.ZIndex=13
	corner(arrow,7); stroke(arrow,T.stroke,1,.35)
	local drop=Instance.new("Frame",page)
	drop.Size=UDim2.new(1,-2,0,0); drop.BackgroundTransparency=1; drop.BorderSizePixel=0
	drop.ClipsDescendants=true; drop.LayoutOrder=nextLO(); drop.ZIndex=8
	local panel=Instance.new("Frame",drop)
	panel.Size=UDim2.new(1,0,0,34); panel.BackgroundColor3=T.card; panel.BackgroundTransparency=.15
	panel.BorderSizePixel=0; panel.ZIndex=9; corner(panel,9); stroke(panel,T.stroke,1,.3)
	local function refresh()
		toggleBtn.Text=State.FovEnabled and "ON" or "OFF"
		toggleBtn.BackgroundColor3=State.FovEnabled and ACC() or Color3.fromRGB(30,30,36)
		toggleBtn.TextColor3=State.FovEnabled and Color3.fromRGB(255,255,255) or T.mute
		value.Text=tostring(fovValue)
	end
	for index,option in ipairs({"80","120"}) do
		local b=Instance.new("TextButton",panel)
		b.Size=UDim2.new(.5,-8,1,-8); b.Position=UDim2.new((index-1)/2,4,0,4)
		b.BackgroundColor3=Color3.fromRGB(18,18,24); b.BackgroundTransparency=.1; b.BorderSizePixel=0
		b.Text=option; b.TextColor3=T.text; b.Font=Enum.Font.GothamBold; b.TextSize=10; b.ZIndex=15
		corner(b,7); stroke(b,T.stroke,1,.35)
		b.MouseButton1Click:Connect(function()
			fovValue=tonumber(option) or 80; State.Fov=fovValue; State.FovEnabled=true
			refresh(); applyFOV(); silentSaveFront()
		end)
	end
	toggleBtn.MouseButton1Click:Connect(function()
		State.FovEnabled=not State.FovEnabled; refresh(); applyFOV(); silentSaveFront()
	end)
	arrow.MouseButton1Click:Connect(function()
		open=not open; arrow.Text=open and "▲" or "▼"
		tween(drop,TweenInfo.new(.2),{Size=open and UDim2.new(1,-2,0,36) or UDim2.new(1,-2,0,0)})
	end)
	refresh()
	return r
end

local function openBtn(page, name, chipText, cb)
	local r = card(page, 46)
	lbl(r, {
		Position=UDim2.fromOffset(14,0), Size=UDim2.new(0.55,0,1,0),
		Text=name, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=9,
	})
	local b = Instance.new("TextButton", r)
	b.AnchorPoint = Vector2.new(1,0.5)
	b.Position = UDim2.new(1,-12,0.5,0)
	b.Size = UDim2.fromOffset(84,28)
	b.BackgroundColor3 = Color3.fromRGB(45,8,15)
	b.BackgroundTransparency = .42
	b.BorderSizePixel = 0
	b.Text = chipText or "Open"
	b.TextColor3 = T.text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 9
	b.AutoButtonColor = false
	b.ZIndex = 10
	corner(b, 8)
	stroke(b, T.stroke, 1, 0.35)
	b.MouseButton1Click:Connect(function() if cb then cb() end end)
	b.MouseEnter:Connect(function() tween(b, nil, {BackgroundColor3=Color3.fromRGB(92,12,26),BackgroundTransparency=0,TextColor3=T.text}) end)
	b.MouseLeave:Connect(function() tween(b, nil, {BackgroundColor3=Color3.fromRGB(45,8,15),BackgroundTransparency=.42,TextColor3=T.text}) end)
end

local Keybinds = {}
local KeybindOwners = {}
local KeybindVisuals = {}
local KeyCapture = {active=false, connection=nil}
-- keyboard + controller display names
local KEY_DISPLAY = {
	ButtonA="A", ButtonB="B", ButtonX="X", ButtonY="Y",
	ButtonR1="RB", ButtonR2="RT", ButtonL1="LB", ButtonL2="LT",
	ButtonR3="R3", ButtonL3="L3",
	DPadUp="D-Up", DPadDown="D-Down", DPadLeft="D-Left", DPadRight="D-Right",
	ButtonStart="Start", ButtonSelect="Select",
	Thumbstick1="LStick", Thumbstick2="RStick",
	LeftShift="LShift", RightShift="RShift",
	LeftControl="LCtrl", RightControl="RCtrl",
	LeftAlt="LAlt", RightAlt="RAlt",
	Return="Enter", BackSpace="Backspace", Escape="Esc", Space="Space",
	PageUp="PgUp", PageDown="PgDn",
}
local function prettyBindName(name)
	if not name or name == "" or name == "NONE" or name == "Unknown" then return "NONE" end
	return KEY_DISPLAY[name] or name
end
local function isBindInput(input)
	if not input or input.KeyCode == Enum.KeyCode.Unknown then return false end
	local name = input.KeyCode.Name
	-- ignore analog sticks / mouse wheel noise
	if name == "Thumbstick1" or name == "Thumbstick2" then return false end
	local ut = input.UserInputType
	if ut == Enum.UserInputType.Keyboard then return true end
	-- Some desktop/mobile controller drivers report the button KeyCode before
	-- UserInputType is updated, so recognize digital controller KeyCodes too.
	if name:match("^Button") or name:match("^DPad") then return true end
	-- any connected gamepad (Gamepad1..8)
	if tostring(ut):find("Gamepad") then return true end
	return false
end
local function clearOwnedKeybind(id)
	for bound, owner in pairs(KeybindOwners) do
		if owner == id then
			KeybindOwners[bound] = nil
			Keybinds[bound] = nil
		end
	end
end
local function assignOwnedKeybind(id, keyName, action)
	clearOwnedKeybind(id)
	if not keyName or keyName == "NONE" or keyName == "Unknown" then return false end
	local code = Enum.KeyCode[keyName]
	if not code or code == Enum.KeyCode.Unknown then return false end
	local previousOwner = KeybindOwners[code]
	if previousOwner and previousOwner ~= id then
		clearOwnedKeybind(previousOwner)
		if FrontKeys[previousOwner] ~= nil then FrontKeys[previousOwner] = "NONE" end
		if UtilityKeys[previousOwner] ~= nil then UtilityKeys[previousOwner] = "NONE" end
		local previousVisual = KeybindVisuals[previousOwner]
		if previousVisual then previousVisual("NONE") end
	end
	KeybindOwners[code] = id
	Keybinds[code] = action
	return true
end
local function keyRow(page, name, id, key, action)
	key = FrontKeys[id] or key
	local isNone = (key == "NONE" or key == "")
	local r = card(page, 42)
	lbl(r, {
		Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-108,1,0),
		Text=name, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=9,
	})

	-- X clear button (tasta X, fara background, just text)
	local clearBtn = Instance.new("TextButton", r)
	clearBtn.AnchorPoint = Vector2.new(1,0.5)
	clearBtn.Position = UDim2.new(1,-70,0.5,0)
	clearBtn.Size = UDim2.fromOffset(20,20)
	clearBtn.BackgroundTransparency = 1
	clearBtn.BorderSizePixel = 0
	clearBtn.Text = "X"
	clearBtn.TextColor3 = Color3.fromRGB(100,100,100)
	clearBtn.Font = Enum.Font.GothamBlack
	clearBtn.TextSize = 11
	clearBtn.ZIndex = 10
	clearBtn.AutoButtonColor = false
	clearBtn.Visible = not isNone

	clearBtn.MouseEnter:Connect(function()
		clearBtn.TextColor3 = Color3.fromRGB(200,80,80)
	end)
	clearBtn.MouseLeave:Connect(function()
		clearBtn.TextColor3 = Color3.fromRGB(100,100,100)
	end)

	-- Chip (key display)
	local chip = Instance.new("TextButton", r)
	chip.AnchorPoint = Vector2.new(1,0.5)
	chip.Position = UDim2.new(1,-12,0.5,0)
	chip.Size = UDim2.fromOffset(64,24)
	chip.BorderSizePixel = 0
	chip.Font = Enum.Font.GothamBold
	chip.TextSize = 11
	chip.ZIndex = 10
	chip.AutoButtonColor = false
	corner(chip, 7)

	local chipStroke = stroke(chip, T.stroke, 1, 0.35)

	local function setNoneState()
		-- same look as a normal keybind, only the text is NONE
		chip.Text = "NONE"
		chip.TextColor3 = T.text
		chip.BackgroundColor3 = Color3.fromRGB(46,8,15)
		chip.BackgroundTransparency = 0.38
		chipStroke.Transparency = 0.35
		clearBtn.Visible = false
	end

	local function setKeyState(keyName)
		chip.Text = prettyBindName(keyName)
		chip.TextColor3 = T.text
		chip.BackgroundColor3 = Color3.fromRGB(46,8,15)
		chip.BackgroundTransparency = 0.38
		chipStroke.Transparency = 0.35
		clearBtn.Visible = true
	end
	KeybindVisuals[id] = function(keyName)
		if keyName == "NONE" or keyName == "Unknown" then setNoneState() else setKeyState(keyName) end
	end

	if isNone then setNoneState() else setKeyState(key) end

	if not isNone then
		assignOwnedKeybind(id, key, action)
	end

	-- X clears the keybind
	clearBtn.Activated:Connect(function()
		clearOwnedKeybind(id)
		FrontKeys[id] = "NONE"
		nebula("setKeybind", id, "NONE")
		silentSaveFront()
		setNoneState()
	end)

	-- Chip click = rebind
	chip.Activated:Connect(function()
		if KeyCapture.connection then KeyCapture.connection:Disconnect(); KeyCapture.connection=nil end
		KeyCapture.active = true
		chip.Text = "..."
		chip.TextColor3 = Color3.fromRGB(180,180,180)
		chipStroke.Transparency = 0.1
		local c; c = UIS.InputBegan:Connect(function(input)
			if not isBindInput(input) then return end
			if input.KeyCode == Enum.KeyCode.Unknown then return end
			if input.KeyCode == Enum.KeyCode.Escape then
				if FrontKeys[id] == "NONE" then setNoneState() else setKeyState(FrontKeys[id] or key) end
				KeyCapture.active=false; KeyCapture.connection=nil; c:Disconnect(); return
			end
			assignOwnedKeybind(id, input.KeyCode.Name, action)
			FrontKeys[id] = input.KeyCode.Name
			nebula("setKeybind", id, input.KeyCode.Name)
			silentSaveFront()
			setKeyState(input.KeyCode.Name)
			KeyCapture.active=false; KeyCapture.connection=nil; c:Disconnect()
		end)
		KeyCapture.connection = c
	end)
	return r
end

-- Spidey-style numeric input row (visual only)
local function inputRow(page, name, default, changed)
	local r = card(page, 42)
	lbl(r, {
		Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-100,1,0),
		Text=name, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=9,
	})
	local wrap = Instance.new("Frame", r)
	wrap.AnchorPoint = Vector2.new(1, 0.5)
	wrap.Position = UDim2.new(1, -12, 0.5, 0)
	wrap.Size = UDim2.fromOffset(70, 28)
	wrap.BackgroundColor3 = Color3.fromRGB(48, 8, 16)
	wrap.BackgroundTransparency = 0.34
	wrap.BorderSizePixel = 0
	wrap.ZIndex = 10
	corner(wrap, 8)
	local ws = stroke(wrap, T.stroke, 1.1, 0.3)
	local box = Instance.new("TextBox", wrap)
	box.Size = UDim2.new(1, -8, 1, 0)
	box.Position = UDim2.fromOffset(4, 0)
	box.BackgroundTransparency = 1
	box.Text = tostring(default)
	box.TextColor3 = T.text
	box.Font = Enum.Font.GothamBold
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.ZIndex = 11
	box.Focused:Connect(function()
		tween(wrap,TweenInfo.new(.15),{BackgroundTransparency=.08,BackgroundColor3=Color3.fromRGB(68,9,21)})
		ws.Color = ACC()
		ws.Transparency = 0.05
	end)
	box.FocusLost:Connect(function()
		tween(wrap,TweenInfo.new(.18),{BackgroundTransparency=.34,BackgroundColor3=Color3.fromRGB(48,8,16)})
		ws.Color = T.stroke
		ws.Transparency = 0.3
		local n = tonumber(box.Text)
		if n then box.Text = tostring(n); if changed then changed(n) end else box.Text = tostring(default) end
	end)
	return box
end

-- Mode selector row (like SPEED/LAGGER MODE in image)
-- Auto Steal mode dropdown (Normal / Semi)
local function stealDropdown(page, changed)
	local open = false
	local mode = "Normal"
	local state = false
	local r = card(page, 42)
	lbl(r, {
		Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-110,1,0),
		Text="Auto Steal", Font=Enum.Font.GothamBold, TextSize=12, ZIndex=9,
	})
	local arrow = Instance.new("TextButton", r)
	arrow.AnchorPoint = Vector2.new(1, 0.5)
	arrow.Position = UDim2.new(1, -58, 0.5, 0)
	arrow.Size = UDim2.fromOffset(34, 28)
	arrow.BackgroundColor3 = Color3.fromRGB(48,8,16)
	arrow.BackgroundTransparency = .28
	arrow.BorderSizePixel = 0
	arrow.Text = "v"
	arrow.TextColor3 = T.text
	arrow.Font = Enum.Font.GothamBlack
	arrow.TextSize = 14
	arrow.AutoButtonColor = false
	arrow.ZIndex = 12
	corner(arrow, 7)
	stroke(arrow, T.stroke, 1, 0.3)
	local pill = Instance.new("Frame", r)
	pill.Size = UDim2.fromOffset(36, 18)
	pill.Position = UDim2.new(1, -46, 0.5, -9)
	pill.BackgroundColor3 = Color3.fromRGB(48,10,18)
	pill.BackgroundTransparency = .28
	pill.BorderSizePixel = 0
	pill.ZIndex = 10
	corner(pill, 9)
	local dot = Instance.new("Frame", pill)
	dot.Size = UDim2.fromOffset(14, 14)
	dot.Position = UDim2.fromOffset(2, 2)
	dot.BackgroundColor3 = Color3.fromRGB(200,200,210)
	dot.BorderSizePixel = 0
	dot.ZIndex = 11
	corner(dot, 7)
	local hit = Instance.new("TextButton", pill)
	hit.Size = UDim2.fromScale(1,1)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.ZIndex = 13
	hit.MouseButton1Click:Connect(function()
		state = not state
		tween(pill, TweenInfo.new(0.2), {BackgroundColor3 = state and ACC() or Color3.fromRGB(48,10,18)})
		tween(dot, TweenInfo.new(0.22, Enum.EasingStyle.Back), {
			Position = state and UDim2.new(1,-16,0.5,-7) or UDim2.fromOffset(2,2),
			BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,210),
		})
	end)
	local drop = Instance.new("Frame", page)
	drop.Size = UDim2.new(1, -2, 0, 0)
	drop.BackgroundTransparency = 1
	drop.BorderSizePixel = 0
	drop.ClipsDescendants = true
	drop.LayoutOrder = nextLO()
	drop.ZIndex = 8
	local bar = Instance.new("Frame", drop)
	bar.Size = UDim2.new(1, 0, 0, 32)
	bar.BackgroundColor3 = T.card
	bar.BackgroundTransparency = 0.2
	bar.BorderSizePixel = 0
	bar.ZIndex = 9
	corner(bar, 9)
	stroke(bar, T.stroke, 1, 0.3)
	local highlight = Instance.new("Frame", bar)
	highlight.Size = UDim2.new(0.5, -6, 1, -6)
	highlight.Position = UDim2.new(0, 3, 0, 3)
	highlight.BackgroundColor3 = ACC()
	highlight.BackgroundTransparency = 0.82
	highlight.BorderSizePixel = 0
	highlight.ZIndex = 10
	corner(highlight, 7)
	local function setMode(name)
		mode = name
		if changed then changed(name) end
		tween(highlight, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
			Position = UDim2.new(name == "Semi" and 0.5 or 0, 3, 0, 3),
		})
	end
	local function mkMode(name, xScale)
		local b = Instance.new("TextButton", bar)
		b.Size = UDim2.new(0.5, 0, 1, 0)
		b.Position = UDim2.new(xScale, 0, 0, 0)
		b.BackgroundTransparency = 1
		b.Text = name
		b.TextColor3 = T.text
		b.Font = Enum.Font.GothamBold
		b.TextSize = 11
		b.AutoButtonColor = false
		b.ZIndex = 11
		b.MouseButton1Click:Connect(function() setMode(name) end)
	end
	mkMode("Normal", 0)
	mkMode("Semi", 0.5)
	arrow.MouseButton1Click:Connect(function()
		open = not open
		arrow.Text = open and "^" or "v"
		tween(drop, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
			Size = open and UDim2.new(1,-2,0,34) or UDim2.new(1,-2,0,0),
		})
	end)
	return r
end

-- One-shot action (TP Down / Drop) - flash only, no RUN label
local function actionBtn(page, name, action)
	local r = card(page, 42)
	local nameLbl = lbl(r, {
		Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-20,1,0),
		Text=name, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=9,
	})
	local flash = Instance.new("Frame", r)
	flash.Size = UDim2.new(0, 3, 0.55, 0)
	flash.Position = UDim2.new(0, 0, 0.225, 0)
	flash.BackgroundColor3 = Color3.fromRGB(255,255,255)
	flash.BackgroundTransparency = 1
	flash.BorderSizePixel = 0
	flash.ZIndex = 11
	corner(flash, 2)
	local b = Instance.new("TextButton", r)
	b.Size = UDim2.fromScale(1,1)
	b.BackgroundTransparency = 1
	b.Text = ""
	b.ZIndex = 12
	b.MouseButton1Click:Connect(function()
		if action then action() end
		flash.BackgroundColor3 = ACC()
		flash.BackgroundTransparency = 0
		r.BackgroundTransparency = 0.05
		nameLbl.TextColor3 = ACC()
		tween(flash, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
		tween(r, TweenInfo.new(0.5), {BackgroundTransparency = 0.56})
		task.delay(0.25, function()
			tween(nameLbl, TweenInfo.new(0.25), {TextColor3 = T.text})
		end)
	end)
	return r
end

local function modeRow(page, label, options, defaultIndex, changed)
	options = options or {"NORMAL"}
	local idx = defaultIndex or 1
	local r = card(page, 42)
	lbl(r, {
		Position=UDim2.fromOffset(14,0), Size=UDim2.new(0.4,0,1,0),
		Text=label, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=9,
	})
	local chip = Instance.new("TextButton", r)
	chip.AnchorPoint = Vector2.new(1, 0.5)
	chip.Position = UDim2.new(1, -12, 0.5, 0)
	chip.Size = UDim2.fromOffset(120, 26)
	chip.BackgroundColor3 = Color3.fromRGB(50,8,16)
	chip.BackgroundTransparency = .34
	chip.BorderSizePixel = 0
	chip.Text = options[idx]
	chip.TextColor3 = T.text
	chip.Font = Enum.Font.GothamBold
	chip.TextSize = 11
	chip.AutoButtonColor = false
	chip.ZIndex = 10
	corner(chip, 8)
	local cs = stroke(chip, T.stroke, 1, 0.3)
	chip.MouseEnter:Connect(function()
		tween(chip,TweenInfo.new(.16),{BackgroundColor3=Color3.fromRGB(92,12,26),BackgroundTransparency=0})
		tween(cs,TweenInfo.new(.16),{Color=ACC(),Transparency=.04})
	end)
	chip.MouseLeave:Connect(function()
		tween(chip,TweenInfo.new(.18),{BackgroundColor3=Color3.fromRGB(50,8,16),BackgroundTransparency=.34})
		tween(cs,TweenInfo.new(.18),{Color=T.stroke,Transparency=.3})
	end)
	chip.MouseButton1Click:Connect(function()
		idx = idx % #options + 1
		chip.Text = options[idx]
		if changed then changed(options[idx], idx) end
	end)
	-- no hover light
	return chip
end

------------------------------------------------------------------
-- MODAL FACTORY
------------------------------------------------------------------
local function makeModal(name, title, w, h)
	-- Premium floating panel (Mist-style chrome, visual only)
	local visibilityCallback, movedCallback
	local dim = Instance.new("TextButton", gui)
	dim.Name = name.."Dim"
	dim.Size = UDim2.fromScale(1,1)
	dim.BackgroundColor3 = Color3.fromRGB(0,0,0)
	dim.BackgroundTransparency = 0.55
	dim.BorderSizePixel = 0
	dim.Text = ""
	dim.AutoButtonColor = false
	dim.Visible = false
	dim.ZIndex = 180

	local m = Instance.new("Frame", gui)
	m.Name = name
	m.Size = UDim2.fromOffset(w, h)
	m.AnchorPoint = Vector2.new(.5,.5)
	m.Position = UDim2.fromScale(.5,.5)
	m.BackgroundColor3 = T.bg
	m.BackgroundTransparency = 0
	m.BorderSizePixel = 0
	m.Visible = false
	m.ZIndex = 200
	m.ClipsDescendants = true
	m.Active = true
	addPhoneScale(m)
	corner(m, 14)
	local mStroke = stroke(m, T.stroke, 1.25, 0.2)

	local mGrad = Instance.new("UIGradient", m)
	mGrad.Rotation = 125
	mGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(43, 6, 14)),
		ColorSequenceKeypoint.new(.45, Color3.fromRGB(20, 5, 10)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 5, 8)),
	})

	-- top accent glow
	local topLine = Instance.new("Frame", m)
	topLine.Size = UDim2.new(0.55, 0, 0, 2)
	topLine.Position = UDim2.new(0.225, 0, 0, 0)
	topLine.BackgroundColor3 = ACC()
	topLine.BorderSizePixel = 0
	topLine.ZIndex = 210
	corner(topLine, 2)
	local tg = Instance.new("UIGradient", topLine)
	tg.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(1, 1),
	})

	local header = Instance.new("Frame", m)
	header.Size = UDim2.new(1, 0, 0, 48)
	header.BackgroundTransparency = 1
	header.ZIndex = 201
	header.Active = true
	local headerDivider=Instance.new("Frame",header)
	headerDivider.AnchorPoint=Vector2.new(.5,1);headerDivider.Position=UDim2.new(.5,0,1,0)
	headerDivider.Size=UDim2.new(1,-28,0,1);headerDivider.BackgroundColor3=ACC()
	headerDivider.BackgroundTransparency=.48;headerDivider.BorderSizePixel=0;headerDivider.ZIndex=203
	local headerFade=Instance.new("UIGradient",headerDivider)
	headerFade.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.25,.1),NumberSequenceKeypoint.new(.75,.1),NumberSequenceKeypoint.new(1,1)})

	local titleLbl = lbl(header, {
		Position=UDim2.fromOffset(16, 14), Size=UDim2.new(1, -56, 0, 20),
		Text=title, Font=Enum.Font.GothamBlack, TextSize=15, ZIndex=202,
	})

	local close = Instance.new("TextButton", header)
	close.Size = UDim2.fromOffset(28, 28)
	close.Position = UDim2.new(1, -38, 0.5, -14)
	close.BackgroundColor3 = Color3.fromRGB(48, 7, 15)
	close.BorderSizePixel = 0
	close.Text = "X"
	close.TextColor3 = T.dim
	close.Font = Enum.Font.GothamBold
	close.TextSize = 12
	close.ZIndex = 210
	close.AutoButtonColor = false
	corner(close, 8)
	stroke(close, T.stroke, 1, 0.4)
	close.MouseEnter:Connect(function()
		tween(close, nil, {BackgroundColor3=Color3.fromRGB(115,12,31), TextColor3=Color3.fromRGB(255,240,243)})
	end)
	close.MouseLeave:Connect(function()
		tween(close, nil, {BackgroundColor3=Color3.fromRGB(48,7,15), TextColor3=T.dim})
	end)

	local body = Instance.new("ScrollingFrame", m)
	body.Name = "Body"
	body.Size = UDim2.new(1, -20, 1, -58)
	body.Position = UDim2.fromOffset(10, 50)
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.ScrollBarThickness = 3
	body.ScrollBarImageColor3 = T.stroke
	body.CanvasSize = UDim2.fromOffset(0, 0)
	body.AutomaticCanvasSize = Enum.AutomaticSize.Y
	body.ZIndex = 201
	local bodyPad = Instance.new("UIPadding", body)
	bodyPad.PaddingTop = UDim.new(0, 4)
	bodyPad.PaddingBottom = UDim.new(0, 12)
	bodyPad.PaddingLeft = UDim.new(0, 2)
	bodyPad.PaddingRight = UDim.new(0, 6)
	local bodyLay = Instance.new("UIListLayout", body)
	bodyLay.Padding = UDim.new(0, 7)
	bodyLay.SortOrder = Enum.SortOrder.LayoutOrder

	local function openFn()
		dim.Visible = true
		m.Visible = true
		m.Size = UDim2.fromOffset(math.floor(w*0.92), math.floor(h*0.92))
		tween(m, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {Size=UDim2.fromOffset(w,h)})
		if visibilityCallback then visibilityCallback(true) end
	end
	local function closeFn()
		dim.Visible = false
		m.Visible = false
		if visibilityCallback then visibilityCallback(false) end
	end
	close.MouseButton1Click:Connect(closeFn)
	-- dimmer does not close (Mist-style: only X)
	drag(m, header, function(position)
		if movedCallback then movedCallback(position) end
	end)
	return {
		m=m, body=body, open=openFn, close=closeFn, dim=dim, stroke=mStroke, topLine=topLine,
		setVisibilityCallback=function(callback) visibilityCallback=callback end,
		setMovedCallback=function(callback) movedCallback=callback end,
	}
end

-- Avatar preview helper (ViewportFrame with local character clone)
local function makeAvatarPreview(parent, height, layoutOrder)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, -4, 0, height or 140)
	frame.BackgroundColor3 = Color3.fromRGB(18,4,9)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = layoutOrder or 0
	frame.ZIndex = 202
	frame.ClipsDescendants = true
	corner(frame, 12)
	stroke(frame, ACC(), 1, 0.28)
	local previewGradient=Instance.new("UIGradient",frame)
	previewGradient.Rotation=135
	previewGradient.Color=ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.fromRGB(58,7,17)),
		ColorSequenceKeypoint.new(.48,Color3.fromRGB(22,5,10)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(6,6,9)),
	})

	local vp = Instance.new("ViewportFrame", frame)
	vp.Size = UDim2.fromScale(1,1)
	vp.BackgroundTransparency = 1
	vp.BorderSizePixel = 0
	vp.ZIndex = 203
	vp.Ambient = Color3.fromRGB(180,180,190)
	vp.LightColor = Color3.fromRGB(255,255,255)
	vp.LightDirection = Vector3.new(-0.5, -1, -0.4)
	local liveBadge=lbl(frame,{Position=UDim2.fromOffset(10,9),Size=UDim2.fromOffset(42,18),Text="  LIVE",Font=Enum.Font.GothamBold,TextSize=8,TextColor3=Color3.fromRGB(255,220,225),ZIndex=206})
	liveBadge.BackgroundTransparency=.12;liveBadge.BackgroundColor3=Color3.fromRGB(122,10,30);corner(liveBadge,6)
	local liveDot=Instance.new("Frame",liveBadge);liveDot.Size=UDim2.fromOffset(5,5);liveDot.Position=UDim2.fromOffset(6,7)
	liveDot.BackgroundColor3=ACC();liveDot.BorderSizePixel=0;liveDot.ZIndex=207;corner(liveDot,4)

	local cam = Instance.new("Camera")
	cam.Parent = vp
	vp.CurrentCamera = cam

	local world = Instance.new("WorldModel", vp)
	local currentClone = nil
	local lastPreviewOptions = {}

	local function refresh(opts)
		opts = opts or lastPreviewOptions
		lastPreviewOptions = {headless=opts.headless==true, korblox=opts.korblox==true}
		opts = lastPreviewOptions
		pcall(function()
			if currentClone then currentClone:Destroy(); currentClone = nil end
			local char = LP.Character
			if not char then return end
			char.Archivable = true
			local clone = char:Clone()
			char.Archivable = false
			clone.Parent = world
			for _, d in ipairs(clone:GetDescendants()) do
				if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end
				if d:IsA("Humanoid") then
					d.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				end
			end
			-- headless visual
			if opts.headless then
				local head = clone:FindFirstChild("Head")
				if head then
					head.Transparency = 1
					for _, f in ipairs(head:GetChildren()) do
						if f:IsA("Decal") then f.Transparency = 1 end
					end
				end
			end
			-- korblox visual: dark right leg
			if opts.korblox then
				for _, name in ipairs({"RightLowerLeg","RightUpperLeg","RightFoot","Right Leg"}) do
					local part = clone:FindFirstChild(name, true)
					if part and part:IsA("BasePart") then
						part.Color = Color3.fromRGB(20,20,24)
						part.Material = Enum.Material.SmoothPlastic
					end
				end
			end
			local hrp = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("Torso") or clone.PrimaryPart
			if hrp then
				cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 1.2, -5.5), hrp.Position + Vector3.new(0, 1, 0))
			end
			currentClone = clone
		end)
	end

	task.defer(function() refresh(lastPreviewOptions) end)
	LP.CharacterAdded:Connect(function()
		task.wait(0.5)
		refresh(lastPreviewOptions)
	end)

	return {frame=frame, refresh=refresh, vp=vp}
end

local function studioToggle(parent, name, defaultOn, onChange)
	local state = defaultOn and true or false
	local r = Instance.new("Frame", parent)
	r.Size = UDim2.new(1,-4,0,40)
	r.BackgroundColor3 = Color3.fromRGB(25, 5, 10)
	r.BackgroundTransparency = 0.14
	r.BorderSizePixel = 0
	r.LayoutOrder = #parent:GetChildren()
	r.ZIndex = 202
	corner(r, 10)
	local studioStroke=stroke(r, T.stroke, 1, 0.35)
	local edge=Instance.new("Frame",r);edge.Size=UDim2.fromOffset(3,20);edge.Position=UDim2.new(0,0,.5,-10)
	edge.BackgroundColor3=ACC();edge.BackgroundTransparency=state and .05 or .62;edge.BorderSizePixel=0;edge.ZIndex=204;corner(edge,2)
	lbl(r, {
		Position=UDim2.fromOffset(12,0), Size=UDim2.new(1,-60,1,0),
		Text=name, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=203,
	})
	local pill = Instance.new("Frame", r)
	pill.Size = UDim2.fromOffset(34,17)
	pill.Position = UDim2.new(1,-44,0.5,-8.5)
	pill.BackgroundColor3 = state and ACC() or Color3.fromRGB(28,28,34)
	pill.BorderSizePixel = 0
	pill.ZIndex = 204
	corner(pill, 9)
	local dot = Instance.new("Frame", pill)
	dot.Size = UDim2.fromOffset(13,13)
	dot.Position = state and UDim2.new(1,-15,0.5,-6.5) or UDim2.fromOffset(2,2)
	dot.BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(190,190,200)
	dot.BorderSizePixel = 0
	dot.ZIndex = 205
	corner(dot, 7)
	local hit = Instance.new("TextButton", r)
	hit.Size = UDim2.fromScale(1,1); hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=206
	hit.MouseButton1Click:Connect(function()
		state = not state
		tween(pill, TweenInfo.new(0.2), {BackgroundColor3 = state and ACC() or Color3.fromRGB(28,28,34)})
		tween(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
			Position = state and UDim2.new(1,-15,0.5,-6.5) or UDim2.fromOffset(2,2),
			BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(190,190,200),
		})
		tween(edge,TweenInfo.new(.2),{BackgroundTransparency=state and .05 or .62,Size=state and UDim2.fromOffset(3,28) or UDim2.fromOffset(3,20),Position=state and UDim2.new(0,0,.5,-14) or UDim2.new(0,0,.5,-10)})
		tween(studioStroke,TweenInfo.new(.2),{Color=state and ACC() or T.stroke,Transparency=state and .08 or .35})
		if onChange then onChange(state) end
	end)
	return function() return state end
end

-- CUSTOM BACKGROUND (with real image previews)
------------------------------------------------------------------
local PRESETS = {{id="", name="CUSTOM"}} -- add the one approved image asset id here
local bgOpacity = 1
local selectedBg = ""

local function applyBg(id, op)
	selectedBg = id or ""
	bgOpacity = op or bgOpacity
	if selectedBg ~= "" then
		customBg.Image = "rbxassetid://"..selectedBg
		customBg.ImageTransparency = math.clamp(1-bgOpacity,.05,.85)
		customBg.Visible = true
		bgFill.BackgroundTransparency = 1
		pcall(function() ContentProvider:PreloadAsync({customBg.Image}) end)
	else
		customBg.Image = ""
		customBg.ImageTransparency = 1
		customBg.Visible = false
		bgFill.BackgroundTransparency = 1
	end
end

local bgUI = makeModal("CustomBgModal", "Custom Background", 300, 170)

-- grid of image previews
local grid = Instance.new("Frame", bgUI.body)
grid.Size = UDim2.new(1,-4,0,0)
grid.AutomaticSize = Enum.AutomaticSize.Y
grid.BackgroundTransparency = 1
grid.LayoutOrder = 1
grid.ZIndex = 202
local gridLay = Instance.new("UIGridLayout", grid)
gridLay.CellSize = UDim2.fromOffset(84, 68)
gridLay.CellPadding = UDim2.fromOffset(6, 6)
gridLay.SortOrder = Enum.SortOrder.LayoutOrder
gridLay.HorizontalAlignment = Enum.HorizontalAlignment.Center

local bgCards = {}
for i, pr in ipairs(PRESETS) do
	local cell = Instance.new("TextButton", grid)
	cell.BackgroundColor3 = Color3.fromRGB(16,16,22)
	cell.BorderSizePixel = 0
	cell.Text = ""
	cell.AutoButtonColor = false
	cell.LayoutOrder = i
	cell.ZIndex = 203
	corner(cell, 12)
	local st = stroke(cell, T.stroke, 1.2, 0.35)

	if pr.id ~= "" then
		local img = Instance.new("ImageLabel", cell)
		img.Size = UDim2.new(1,-6,1,-22)
		img.Position = UDim2.fromOffset(3,3)
		img.BackgroundColor3 = Color3.fromRGB(10,10,14)
		img.BorderSizePixel = 0
		img.Image = "rbxassetid://"..pr.id
		img.ScaleType = Enum.ScaleType.Crop
		img.ZIndex = 204
		corner(img, 9)
		pcall(function() ContentProvider:PreloadAsync({img.Image}) end)
	else
		local none = lbl(cell, {
			Size=UDim2.new(1,0,1,-18), Text="NONE", Font=Enum.Font.GothamBlack, TextSize=11,
			TextColor3=T.mute, TextXAlignment=Enum.TextXAlignment.Center,
			TextYAlignment=Enum.TextYAlignment.Center, ZIndex=204,
		})
	end

	lbl(cell, {
		AnchorPoint=Vector2.new(0.5,1), Position=UDim2.new(0.5,0,1,-2),
		Size=UDim2.new(1,-4,0,16), Text=pr.name, Font=Enum.Font.GothamBold, TextSize=10,
		TextColor3=T.dim, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=205,
	})

	cell.MouseButton1Click:Connect(function()
		applyBg(pr.id, bgOpacity)
		for _, other in pairs(bgCards) do
			other.stroke.Color = T.stroke
			other.stroke.Transparency = 0.35
		end
		st.Color = ACC()
		st.Transparency = 0.05
	end)
	bgCards[i] = {btn=cell, stroke=st, id=pr.id}
end

-- opacity slider visual
local opCard = Instance.new("Frame", bgUI.body)
opCard.Size = UDim2.new(1,-4,0,64)
opCard.Visible = false
opCard.BackgroundColor3 = T.card
opCard.BorderSizePixel = 0
opCard.LayoutOrder = 2
opCard.ZIndex = 202
corner(opCard, 12)
stroke(opCard, T.stroke, 1, 0.35)
lbl(opCard, {
	Position=UDim2.fromOffset(14,8), Size=UDim2.new(0.6,0,0,16),
	Text="Opacity", Font=Enum.Font.GothamBold, TextSize=12, ZIndex=203,
})
local opVal = lbl(opCard, {
	AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-14,0,8), Size=UDim2.fromOffset(48,16),
	Text="78%", TextXAlignment=Enum.TextXAlignment.Right, TextColor3=T.dim,
	Font=Enum.Font.GothamBold, TextSize=11, ZIndex=203,
})
local bar = Instance.new("Frame", opCard)
bar.Position = UDim2.fromOffset(14,40)
bar.Size = UDim2.new(1,-28,0,8)
bar.BackgroundColor3 = Color3.fromRGB(28,28,36)
bar.BorderSizePixel = 0
bar.ZIndex = 203
corner(bar, 4)
local fill = Instance.new("Frame", bar)
fill.Size = UDim2.fromScale(bgOpacity, 1)
fill.BackgroundColor3 = ACC()
fill.BorderSizePixel = 0
fill.ZIndex = 204
corner(fill, 4)
local draggingOp = false
bar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingOp = true
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingOp = false
	end
end)
UIS.InputChanged:Connect(function(input)
	if not draggingOp then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
	local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0.15, 1)
	fill.Size = UDim2.fromScale(rel, 1)
	bgOpacity = rel
	opVal.Text = math.floor(rel*100+0.5).."%"
	applyBg(selectedBg, bgOpacity)
end)

------------------------------------------------------------------
-- TABS LAYOUT (visual previews)
------------------------------------------------------------------
local layUI = makeModal("TabsLayoutModal", "Tabs Layout", 280, 320)
local layoutDefs = {
	{id=2, name="Top Bar", desc="Tabs in one bar across the top"},
	{id=3, name="Sidebar", desc="Vertical strip on the left"},
	{id=1, name="Bottom Bar", desc="Clean bar along the bottom"},
}

local function drawLayoutPreview(parent, id)
	-- mini window sketch
	local box = Instance.new("Frame", parent)
	box.Size = UDim2.fromOffset(64, 48)
	box.Position = UDim2.fromOffset(12, 10)
	box.BackgroundColor3 = Color3.fromRGB(20,20,26)
	box.BorderSizePixel = 0
	box.ZIndex = 210
	corner(box, 6)
	local title = Instance.new("Frame", box)
	title.Size = UDim2.new(1,0,0,8)
	title.BackgroundColor3 = Color3.fromRGB(32,32,40)
	title.BorderSizePixel = 0
	title.ZIndex = 211
	corner(title, 6)
	local tabs = Instance.new("Frame", box)
	tabs.BackgroundColor3 = ACC()
	tabs.BorderSizePixel = 0
	tabs.ZIndex = 212
	corner(tabs, 3)
	if id == 1 or id == 5 then
		tabs.Size = UDim2.new(0.7,0,0,5)
		tabs.Position = UDim2.new(0.15,0,1,-7)
	elseif id == 2 or id == 4 then
		tabs.Size = UDim2.new(0.7,0,0,5)
		tabs.Position = UDim2.new(0.15,0,0,10)
	else
		tabs.Size = UDim2.new(0,6,0.55,0)
		tabs.Position = UDim2.fromOffset(3,14)
	end
end

local function applyLayout(id)
	if id == 2 then
		tabBar.Position = UDim2.fromOffset(8, TITLE_H+6)
		content.Position = UDim2.fromOffset(8, TITLE_H+52)
		content.Size = UDim2.new(1,-16,1,-(TITLE_H+60))
		tabList.FillDirection = Enum.FillDirection.Horizontal
		for _, b in pairs(tabBtns) do b.Size = UDim2.new(1/#TABS,-4,0,31) end
		tabBar.Size = UDim2.new(1,-16,0,40)
	elseif id == 3 then
		tabBar.Size = UDim2.new(0,92,1,-(TITLE_H+16))
		tabBar.Position = UDim2.fromOffset(8, TITLE_H+8)
		tabList.FillDirection = Enum.FillDirection.Vertical
		for _, b in pairs(tabBtns) do b.Size = UDim2.new(1,-4,0,31) end
		content.Position = UDim2.fromOffset(106, TITLE_H+8)
		content.Size = UDim2.new(1,-114,1,-(TITLE_H+16))
	else
		tabBar.Size = UDim2.new(1,-16,0,40)
		tabBar.Position = UDim2.new(0,8,1,-46)
		tabList.FillDirection = Enum.FillDirection.Horizontal
		for _, b in pairs(tabBtns) do b.Size = UDim2.new(1/#TABS,-4,0,31) end
		content.Position = UDim2.fromOffset(8, TITLE_H+5)
		content.Size = UDim2.new(1,-16,1,-(TITLE_H+56))
	end
end

for i, L in ipairs(layoutDefs) do
	local row = Instance.new("TextButton", layUI.body)
	row.Size = UDim2.new(1,-4,0,56)
	row.BackgroundColor3 = T.card
	row.BorderSizePixel = 0
	row.Text = ""
	row.AutoButtonColor = false
	row.LayoutOrder = i
	row.ZIndex = 202
	corner(row, 14)
	local st = stroke(row, T.stroke, 1.15, 0.3)
	drawLayoutPreview(row, L.id)
	lbl(row, {
		Position=UDim2.fromOffset(90,16), Size=UDim2.new(1,-110,0,18),
		Text=L.name, Font=Enum.Font.GothamBlack, TextSize=14, ZIndex=210,
	})
	lbl(row, {
		Position=UDim2.fromOffset(90,38), Size=UDim2.new(1,-110,0,16),
		Text=L.desc, TextColor3=T.dim, TextSize=11, ZIndex=210,
	})
	row.MouseButton1Click:Connect(function()
		applyLayout(L.id)
		layUI.close()
	end)
	row.MouseEnter:Connect(function()
		tween(row, nil, {BackgroundColor3=T.hover})
		st.Color = ACC(); st.Transparency = 0.1
	end)
	row.MouseLeave:Connect(function()
		tween(row, nil, {BackgroundColor3=T.card})
		st.Color = T.stroke; st.Transparency = 0.3
	end)
end

------------------------------------------------------------------
-- Studios
------------------------------------------------------------------
local animUI, charUI
do
local espUI = makeModal("AntiSammyESPModal", "ESP", 300, 214)
lbl(espUI.body, {
	Size=UDim2.new(1,0,0,14), Text="PLAYER ESP", TextSize=10,
	Font=Enum.Font.GothamBold, TextColor3=T.mute, LayoutOrder=1, ZIndex=202,
})

local espMode = 1
local espNames = {"Off", "Outline", "Full"}
local espCards = {}
local espGrid = Instance.new("Frame", espUI.body)
espGrid.Size = UDim2.new(1, -4, 0, 44)
espGrid.BackgroundTransparency = 1
espGrid.LayoutOrder = 2
espGrid.ZIndex = 202
local eg = Instance.new("UIGridLayout", espGrid)
eg.CellSize = UDim2.new(1/3, -6, 0, 40)
eg.CellPadding = UDim2.fromOffset(8, 8)
eg.SortOrder = Enum.SortOrder.LayoutOrder

local function refreshEspCards()
	for i, card in ipairs(espCards) do
		local on = (i == espMode)
		card.BackgroundColor3 = on and Color3.fromRGB(16,16,20) or Color3.fromRGB(12,12,16)
		local st = card:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = on and ACC() or T.stroke
			st.Transparency = on and 0.05 or 0.4
		end
		local badge = card:FindFirstChild("Badge")
		if badge then badge.Visible = on end
	end
end

for i, name in ipairs(espNames) do
	local card = Instance.new("TextButton", espGrid)
	card.BackgroundColor3 = Color3.fromRGB(12,12,16)
	card.BorderSizePixel = 0
	card.Text = ""
	card.AutoButtonColor = false
	card.LayoutOrder = i
	card.ZIndex = 203
	corner(card, 9)
	stroke(card, T.stroke, 1, 0.4)
	lbl(card, {
		Position=UDim2.fromOffset(10,0), Size=UDim2.new(1,-36,1,0),
		Text=name, Font=Enum.Font.GothamBlack, TextSize=11, ZIndex=204,
	})
	local badge = Instance.new("TextLabel", card)
	badge.Name = "Badge"
	badge.Size = UDim2.fromOffset(24, 14)
	badge.Position = UDim2.new(1, -30, 0.5, -7)
	badge.BackgroundColor3 = Color3.fromRGB(0,0,0)
	badge.Text = "ON"
	badge.TextColor3 = ACC()
	badge.Font = Enum.Font.GothamBlack
	badge.TextSize = 8
	badge.Visible = false
	badge.ZIndex = 205
	corner(badge, 5)
	card.MouseButton1Click:Connect(function()
		espMode = i
		refreshEspCards()
		setESP(espNames[i])
	end)
	espCards[i] = card
end
refreshEspCards()

end

do
animUI = makeModal("AnimPackModal", "Animation Studio", 324, 410)
lbl(animUI.body, {
	Size=UDim2.new(1,0,0,14), Text="PACK LIBRARY", TextSize=10,
	Font=Enum.Font.GothamBold, TextColor3=T.mute, LayoutOrder=1, ZIndex=202,
})
local animPacks = {
	"Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular",
	"Elder", "Zombie", "Mage", "Catwalk Glam", "Astronaut",
	'Wicked "Dancing Through Life"', "Werewolf", "Superhero", "Toy",
	"No Boundaries", "NFL", "Amazon Unboxed", "Vampire", "Ninja",
	"Robot", "Levitation", "Stylish", "Bubbly", "Cartoon",
}
local animSelected = 0
for i, name in ipairs(animPacks) do
	if State.AnimationPackEnabled and name == State.AnimationPack then
		animSelected = i
		break
	end
end
local animRows = {}
local animStatus = Instance.new("Frame", animUI.body)
animStatus.Size = UDim2.new(1,-4,0,44)
animStatus.BackgroundColor3 = Color3.fromRGB(40,6,13)
animStatus.BackgroundTransparency = .18
animStatus.BorderSizePixel = 0
animStatus.LayoutOrder = 2
animStatus.ZIndex = 202
corner(animStatus,10)
stroke(animStatus,ACC(),1,.24)
lbl(animStatus,{Position=UDim2.fromOffset(12,5),Size=UDim2.new(1,-24,0,13),Text="CURRENT PACK",Font=Enum.Font.GothamBold,TextSize=8,TextColor3=T.mute,ZIndex=203})
local animStatusText = lbl(animStatus,{Position=UDim2.fromOffset(12,18),Size=UDim2.new(1,-24,0,20),Text="None selected",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=T.text,ZIndex=203})

local animSearchWrap = Instance.new("Frame",animUI.body)
animSearchWrap.Size=UDim2.new(1,-4,0,36);animSearchWrap.BackgroundColor3=Color3.fromRGB(18,5,10)
animSearchWrap.BackgroundTransparency=.16;animSearchWrap.BorderSizePixel=0;animSearchWrap.LayoutOrder=3;animSearchWrap.ZIndex=202
corner(animSearchWrap,9);stroke(animSearchWrap,T.stroke,1,.38)
lbl(animSearchWrap,{Position=UDim2.fromOffset(11,0),Size=UDim2.fromOffset(48,36),Text="FIND",Font=Enum.Font.GothamBold,TextSize=9,TextColor3=T.mute,ZIndex=203})
local animSearch=Instance.new("TextBox",animSearchWrap)
animSearch.Position=UDim2.fromOffset(54,4);animSearch.Size=UDim2.new(1,-60,0,28);animSearch.BackgroundTransparency=1
animSearch.BorderSizePixel=0;animSearch.ClearTextOnFocus=false;animSearch.PlaceholderText="Search animation packs..."
animSearch.PlaceholderColor3=Color3.fromRGB(128,91,99);animSearch.Text="";animSearch.TextColor3=T.text
animSearch.TextXAlignment=Enum.TextXAlignment.Left;animSearch.Font=Enum.Font.GothamMedium;animSearch.TextSize=11;animSearch.ZIndex=204
local function refreshAnim()
	for i, row in ipairs(animRows) do
		local on = (i == animSelected)
		row.BackgroundColor3 = on and Color3.fromRGB(54,7,16) or Color3.fromRGB(16,5,9)
		row.BackgroundTransparency = on and .06 or .18
		local st = row:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = on and ACC() or T.stroke
			st.Transparency = on and 0.05 or 0.4
		end
		local tag = row:FindFirstChild("OnTag")
		if tag then tag.Visible = on end
	end
	animStatusText.Text = (animSelected > 0 and animPacks[animSelected]) or "None selected"
end
for i, name in ipairs(animPacks) do
	local row = Instance.new("TextButton", animUI.body)
	row.Size = UDim2.new(1, -4, 0, 36)
	row.BackgroundColor3 = Color3.fromRGB(16,5,9)
	row.BackgroundTransparency = .18
	row.BorderSizePixel = 0
	row.Text = ""
	row.AutoButtonColor = false
	row.LayoutOrder = i + 3
	row.ZIndex = 202
	corner(row, 9)
	stroke(row, T.stroke, 1, 0.4)
	lbl(row, {
		Position=UDim2.fromOffset(12,0), Size=UDim2.new(1,-50,1,0),
		Text=name, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=203,
	})
	local tag = Instance.new("TextLabel", row)
	tag.Name = "OnTag"
	tag.Size = UDim2.fromOffset(28, 16)
	tag.Position = UDim2.new(1, -36, 0.5, -8)
	tag.BackgroundTransparency = 1
	tag.Text = "ON"
	tag.TextColor3 = ACC()
	tag.Font = Enum.Font.GothamBlack
	tag.TextSize = 10
	tag.Visible = false
	tag.ZIndex = 204
	row.MouseButton1Click:Connect(function()
		animSelected = i
		refreshAnim()
		State.AnimationPack = name
		State.AnimationPackEnabled = true
		silentSaveFront()
		nebula("setAnimation",name)
	end)
	row.MouseEnter:Connect(function()
		if animSelected ~= i then tween(row,TweenInfo.new(.16),{BackgroundColor3=Color3.fromRGB(45,8,16),BackgroundTransparency=.04}) end
	end)
	row.MouseLeave:Connect(function()
		if animSelected ~= i then tween(row,TweenInfo.new(.18),{BackgroundColor3=Color3.fromRGB(16,5,9),BackgroundTransparency=.18}) end
	end)
	animRows[i] = row
end
animSearch:GetPropertyChangedSignal("Text"):Connect(function()
	local query=animSearch.Text:lower():gsub("^%s+",""):gsub("%s+$","")
	for i,row in ipairs(animRows) do row.Visible=query=="" or animPacks[i]:lower():find(query,1,true)~=nil end
end)
refreshAnim()

end

do
charUI = makeModal("CharterModal", "Character Studio", 324, 420)
lbl(charUI.body, {
	Size=UDim2.new(1,0,0,14), Text="LIVE AVATAR PREVIEW", TextSize=9,
	Font=Enum.Font.GothamBold, TextColor3=T.mute, LayoutOrder=-1, ZIndex=202,
})
local charPreview = makeAvatarPreview(charUI.body, 176, 0)
local headlessOn, korbloxOn = State.Headless == true, State.Korblox == true
local function refreshCharPrev()
	charPreview.refresh({headless = headlessOn, korblox = korbloxOn})
end
studioToggle(charUI.body, "Headless", headlessOn, function(on)
	headlessOn = on
	State.Headless = on
	applyCharacterCosmetics()
	nebula("setHeadless",on)
	refreshCharPrev()
	silentSaveFront()
end)
studioToggle(charUI.body, "Korblox", korbloxOn, function(on)
	korbloxOn = on
	State.Korblox = on
	applyCharacterCosmetics()
	nebula("setKorblox",on)
	refreshCharPrev()
	silentSaveFront()
end)
task.defer(refreshCharPrev)

end

local bypassUI, laggerUI
do
	local function decorateUtilityPanel(ui, featureName, defaultKey, kind)
		local utilityKeyId = kind=="bypass" and "SpeedBypass" or "NetworkLagger"
		local savedKey = UtilityKeys[utilityKeyId] or defaultKey
		local panelState = UtilityPanelState[utilityKeyId]
		if panelState and panelState.position then
			local pos = panelState.position
			ui.m.Position = UDim2.new(pos.xScale,pos.xOffset,pos.yScale,pos.yOffset)
		end
		if ui.setMovedCallback then
			ui.setMovedCallback(function(position)
				panelState.position = {
					xScale=position.X.Scale, xOffset=position.X.Offset,
					yScale=position.Y.Scale, yOffset=position.Y.Offset,
				}
				silentSaveFront()
			end)
		end
		if ui.setVisibilityCallback then
			ui.setVisibilityCallback(function(isOpen)
				panelState.open = isOpen == true
				silentSaveFront()
			end)
		end
		local modalOpen=ui.open
		ui.open=function()
			modalOpen()
			-- Utility panels float independently so both can remain open and usable.
			ui.dim.Visible=false
		end
		ui.m.BackgroundColor3 = Color3.fromRGB(20,2,7)
		ui.m.BackgroundTransparency = .58
		ui.dim.BackgroundTransparency = .86
		ui.stroke.Color = Color3.fromRGB(225,31,57)
		ui.stroke.Transparency = .08
		ui.topLine.BackgroundColor3 = Color3.fromRGB(244,38,64)
		local utilityLayout=ui.body:FindFirstChildOfClass("UIListLayout")
		if utilityLayout then utilityLayout.Padding=UDim.new(0,5) end

		local core = Instance.new("Frame", ui.body)
		core.Size = UDim2.new(1,-4,0,kind=="bypass" and 58 or 48)
		core.BackgroundColor3 = Color3.fromRGB(34,3,10)
		core.BackgroundTransparency = .52
		core.BorderSizePixel = 0
		core.LayoutOrder = 1
		core.ZIndex = 202
		corner(core, 11)
		stroke(core, Color3.fromRGB(151,25,43), 1, .24)
		local coreGrad = Instance.new("UIGradient", core)
		coreGrad.Rotation = 12
		coreGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,Color3.fromRGB(76,5,18)),
			ColorSequenceKeypoint.new(.52,Color3.fromRGB(28,3,9)),
			ColorSequenceKeypoint.new(1,Color3.fromRGB(9,3,6)),
		})
		local signal = Instance.new("Frame", core)
		signal.Position = kind=="bypass" and UDim2.fromOffset(12,13) or UDim2.fromOffset(10,10)
		signal.Size = kind=="bypass" and UDim2.fromOffset(34,32) or UDim2.fromOffset(44,28)
		signal.BackgroundColor3 = Color3.fromRGB(52,5,15); signal.BackgroundTransparency = .44
		signal.BorderSizePixel = 0; signal.ZIndex = 204; corner(signal,9)
		local signalStroke = stroke(signal, Color3.fromRGB(244,38,64), 1.1, .18)
		local bars = {}
		local barCount=kind=="bypass" and 3 or 5
		for i=1,barCount do
			local bar=Instance.new("Frame",signal)
			bar.AnchorPoint=Vector2.new(.5,.5);bar.Position=UDim2.new(i/(barCount+1),0,.5,0)
			bar.Size=UDim2.fromOffset(kind=="bypass" and 3 or 2,kind=="bypass" and (8+i*3) or (6+(i%3)*4));bar.BackgroundColor3=Color3.fromRGB(244,38,64)
			bar.BorderSizePixel=0;bar.ZIndex=205;corner(bar,2);bars[i]=bar
		end
		lbl(core, {
			Position=UDim2.fromOffset(kind=="bypass" and 56 or 64,0), Size=UDim2.new(1,kind=="bypass" and -130 or -136,1,0),
			Text=featureName, Font=Enum.Font.GothamBold, TextSize=12,
			TextColor3=Color3.fromRGB(244,238,240), TextYAlignment=Enum.TextYAlignment.Center, ZIndex=204,
		})
		local active=kind=="lagger" and State.NetworkLagger or false
		local activeButton=Instance.new("TextButton",core)
		activeButton.AnchorPoint=Vector2.new(1,.5);activeButton.Position=UDim2.new(1,-9,.5,0)
		activeButton.Size=UDim2.fromOffset(56,26);activeButton.BackgroundColor3=Color3.fromRGB(59,7,17)
		activeButton.BackgroundTransparency=.40;activeButton.BorderSizePixel=0;activeButton.Text="OFF"
		activeButton.TextColor3=Color3.fromRGB(208,135,146);activeButton.Font=Enum.Font.GothamBold
		activeButton.TextSize=10;activeButton.AutoButtonColor=false;activeButton.ZIndex=207;corner(activeButton,8)
		local activeStroke=stroke(activeButton,Color3.fromRGB(142,27,44),1,.3)
		local statusLight=Instance.new("Frame",core)
		statusLight.AnchorPoint=Vector2.new(1,.5);statusLight.Position=UDim2.new(1,-72,.5,0);statusLight.Size=UDim2.fromOffset(7,7)
		statusLight.BackgroundColor3=Color3.fromRGB(126,36,50);statusLight.BackgroundTransparency=.38
		statusLight.BorderSizePixel=0;statusLight.ZIndex=207;corner(statusLight,5)
		local statusStroke=stroke(statusLight,Color3.fromRGB(211,48,70),1,.46)
		local liveRail=Instance.new("Frame",core)
		liveRail.AnchorPoint=Vector2.new(.5,1);liveRail.Position=UDim2.new(.5,0,1,-3)
		liveRail.Size=UDim2.new(0,0,0,2);liveRail.BackgroundColor3=Color3.fromRGB(244,38,64)
		liveRail.BackgroundTransparency=.08;liveRail.BorderSizePixel=0;liveRail.ZIndex=207;corner(liveRail,2)
		local function setActive(value)
			active=value and true or false
			activeButton.Text=active and "ON" or "OFF"
			tween(activeButton,TweenInfo.new(.18),{
				BackgroundColor3=active and Color3.fromRGB(132,10,32) or Color3.fromRGB(59,7,17),
				BackgroundTransparency=active and .24 or .40,
				TextColor3=active and Color3.fromRGB(255,236,240) or Color3.fromRGB(208,135,146),
			})
			tween(activeStroke,TweenInfo.new(.18),{Color=active and Color3.fromRGB(244,38,64) or Color3.fromRGB(142,27,44),Transparency=active and .02 or .3})
			tween(statusLight,TweenInfo.new(.18),{BackgroundColor3=active and Color3.fromRGB(255,48,75) or Color3.fromRGB(126,36,50),BackgroundTransparency=active and 0 or .38,Size=active and UDim2.fromOffset(9,9) or UDim2.fromOffset(7,7)})
			tween(statusStroke,TweenInfo.new(.18),{Color=active and Color3.fromRGB(255,145,157) or Color3.fromRGB(211,48,70),Transparency=active and .08 or .46})
			tween(liveRail,TweenInfo.new(.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=active and UDim2.new(.72,0,0,2) or UDim2.new(0,0,0,2)})
			if kind=="bypass" then
				setBypassEnabled(active)
			elseif kind=="lagger" then
				setLaggerNetEnabled(active)
				State.NetworkLagger = active
			end
			silentSaveFront()
		end
		activeButton.MouseButton1Click:Connect(function() setActive(not active) end)
		activeButton.MouseEnter:Connect(function() tween(activeButton,TweenInfo.new(.15),{BackgroundTransparency=active and .05 or .16}) end)
		activeButton.MouseLeave:Connect(function() tween(activeButton,TweenInfo.new(.18),{BackgroundTransparency=active and .24 or .40}) end)
		if active then task.defer(function() setActive(true) end) end

		if kind=="bypass" then
			local powerRow=Instance.new("Frame",ui.body)
			powerRow.Size=UDim2.new(1,-4,0,38);powerRow.BackgroundColor3=Color3.fromRGB(24,3,8)
			powerRow.BackgroundTransparency=.56;powerRow.BorderSizePixel=0;powerRow.LayoutOrder=2;powerRow.ZIndex=202
			corner(powerRow,10);stroke(powerRow,Color3.fromRGB(127,24,40),1,.34)
			lbl(powerRow,{Position=UDim2.fromOffset(13,0),Size=UDim2.new(1,-112,1,0),Text="POWER",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=Color3.fromRGB(230,220,223),ZIndex=204})
			do
				for i,height in ipairs({7,12,17}) do
					local meter=Instance.new("Frame",powerRow);meter.AnchorPoint=Vector2.new(0,.5)
					meter.Position=UDim2.fromOffset(58+(i-1)*6,19);meter.Size=UDim2.fromOffset(3,height)
					meter.BackgroundColor3=Color3.fromRGB(226,37,63);meter.BackgroundTransparency=.18+(3-i)*.16
					meter.BorderSizePixel=0;meter.ZIndex=205;corner(meter,2)
				end
			end
			local powerBox=Instance.new("TextBox",powerRow)
			powerBox.AnchorPoint=Vector2.new(1,.5);powerBox.Position=UDim2.new(1,-8,.5,0);powerBox.Size=UDim2.fromOffset(88,24)
			powerBox.BackgroundColor3=Color3.fromRGB(48,6,15);powerBox.BackgroundTransparency=.40;powerBox.BorderSizePixel=0
			powerBox.Text=tostring(NetLag.power or State.BypassPower or 100000);powerBox.PlaceholderText="Enter power";powerBox.PlaceholderColor3=Color3.fromRGB(137,74,86);powerBox.ClearTextOnFocus=false;powerBox.TextColor3=Color3.fromRGB(246,230,234)
			powerBox.Font=Enum.Font.GothamBold;powerBox.TextSize=10;powerBox.ZIndex=205;corner(powerBox,8);stroke(powerBox,Color3.fromRGB(164,28,48),1,.28)
			powerBox.Focused:Connect(function() tween(powerBox,TweenInfo.new(.15),{BackgroundTransparency=.12,BackgroundColor3=Color3.fromRGB(71,7,20)}) end)
			powerBox.FocusLost:Connect(function() tween(powerBox,TweenInfo.new(.18),{BackgroundTransparency=.40,BackgroundColor3=Color3.fromRGB(48,6,15)}) end)
			powerBox.FocusLost:Connect(function()
				local value=powerBox.Text:gsub("[^%d%.%-]","")
				local n=tonumber(value) or 100000
				n=math.clamp(math.floor(n),10000,150000)
				powerBox.Text=tostring(n)
				NetLag.power=n; State.BypassPower=n; silentSaveFront()
				if NetLag.bypassOn then startBypassEngine() end
			end)
		end

		local keyRowFrame = Instance.new("Frame", ui.body)
		keyRowFrame.Size = UDim2.new(1,-4,0,38)
		keyRowFrame.BackgroundColor3 = Color3.fromRGB(27,3,8)
		keyRowFrame.BackgroundTransparency = .56
		keyRowFrame.BorderSizePixel = 0
		keyRowFrame.LayoutOrder = kind=="bypass" and 3 or 2
		keyRowFrame.ZIndex = 202
		corner(keyRowFrame, 10)
		stroke(keyRowFrame, Color3.fromRGB(127,24,40), 1, .34)
		lbl(keyRowFrame, {
			Position=UDim2.fromOffset(13,0),Size=UDim2.new(1,-94,1,0),Text="KEYBIND",
			Font=Enum.Font.GothamBold,TextSize=10,TextColor3=Color3.fromRGB(230,220,223),ZIndex=204,
		})
		do
			for i=1,3 do
				local keyCap=Instance.new("Frame",keyRowFrame);keyCap.Position=UDim2.fromOffset(62+(i-1)*7,15)
				keyCap.Size=UDim2.fromOffset(5,8);keyCap.BackgroundColor3=Color3.fromRGB(177,32,53)
				keyCap.BackgroundTransparency=.28+(i-1)*.16;keyCap.BorderSizePixel=0;keyCap.ZIndex=204;corner(keyCap,2)
			end
		end
		local keyButton=Instance.new("TextButton",keyRowFrame)
		keyButton.AnchorPoint=Vector2.new(1,.5);keyButton.Position=UDim2.new(1,-8,.5,0)
		keyButton.Size=UDim2.fromOffset(68,24);keyButton.BackgroundColor3=Color3.fromRGB(66,7,19)
		keyButton.BackgroundTransparency=.40;keyButton.BorderSizePixel=0;keyButton.Text=prettyBindName(savedKey)
		keyButton.TextColor3=Color3.fromRGB(245,226,231);keyButton.Font=Enum.Font.GothamBold
		keyButton.TextSize=10;keyButton.AutoButtonColor=false;keyButton.ZIndex=205;corner(keyButton,8)
		local keyStroke=stroke(keyButton,Color3.fromRGB(225,31,57),1,.24)
		keyButton.MouseEnter:Connect(function() tween(keyButton,TweenInfo.new(.15),{BackgroundTransparency=.12,BackgroundColor3=Color3.fromRGB(91,9,26)}) end)
		keyButton.MouseLeave:Connect(function() tween(keyButton,TweenInfo.new(.18),{BackgroundTransparency=.40,BackgroundColor3=Color3.fromRGB(66,7,19)}) end)

		local function toggleFeature() setActive(not active) end
		KeybindVisuals[utilityKeyId]=function(keyName)
			keyButton.Text=prettyBindName(keyName)
		end
		local initialKeyCode = (savedKey ~= "NONE" and Enum.KeyCode[savedKey]) or nil
		if initialKeyCode then assignOwnedKeybind(utilityKeyId,savedKey,toggleFeature) end
		keyButton.Activated:Connect(function()
			if KeyCapture.connection then KeyCapture.connection:Disconnect(); KeyCapture.connection=nil end
			KeyCapture.active=true
			local previousText=keyButton.Text
			keyButton.Text="..."
			keyStroke.Transparency=.02
			local connection
			connection=UIS.InputBegan:Connect(function(input)
				if not isBindInput(input) then return end
				if input.KeyCode==Enum.KeyCode.Escape then
					keyButton.Text=previousText
					KeyCapture.active=false; KeyCapture.connection=nil; keyStroke.Transparency=.24
					connection:Disconnect(); return
				end
				assignOwnedKeybind(utilityKeyId,input.KeyCode.Name,toggleFeature)
				keyButton.Text=prettyBindName(input.KeyCode.Name)
				UtilityKeys[utilityKeyId]=input.KeyCode.Name
				silentSaveFront()
				KeyCapture.active=false; KeyCapture.connection=nil; keyStroke.Transparency=.24
				connection:Disconnect()
			end)
			KeyCapture.connection=connection
		end)
		task.spawn(function()
			local phase=0
			while signal and signal.Parent do
				phase=phase+1
				for i,bar in ipairs(bars) do
					local height
					if active then
						height=kind=="bypass" and (8+((phase+i)%4)*4) or (6+((phase+i*2)%4)*3)
					else
						height=kind=="bypass" and (8+math.abs(i-2)*3) or (6+math.abs(i-3)*2)
					end
					tween(bar,TweenInfo.new(.28,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
						Size=UDim2.fromOffset(kind=="bypass" and 3 or 2,height),
						BackgroundTransparency=active and (((phase+i)%3==0) and .30 or .02) or .48,
					})
				end
				tween(signalStroke,TweenInfo.new(.35),{Transparency=active and (phase%2==0 and .06 or .24) or .42})
				task.wait(.34)
			end
		end)
	end

	bypassUI = makeModal("AntiSammyBypassModal", "Anti-Sammy Bypass", 300, 220)
	bypassUI.m.Position=IS_PHONE and UDim2.fromScale(.5,.34) or UDim2.fromScale(.34,.5)
	decorateUtilityPanel(bypassUI, "SPEED BYPASS", "RightBracket", "bypass")
	laggerUI = makeModal("AntiSammyLaggerModal", "Anti-Sammy Lagger", 260, 176)
	laggerUI.m.Position=IS_PHONE and UDim2.fromScale(.5,.70) or UDim2.fromScale(.72,.5)
	decorateUtilityPanel(laggerUI, "LAGGER", "BackSlash", "lagger")
	if UtilityPanelState.SpeedBypass.open then task.defer(bypassUI.open) end
	if UtilityPanelState.NetworkLagger.open then task.defer(laggerUI.open) end
end

-- Tab contents
------------------------------------------------------------------
do
	local p = pages.Main
	-- Like image: SPEED CONFIG + MODE, LAGGER CONFIG + MODE
	section(p, "Speed Configuration")
	inputRow(p, "Normal Speed", State.NormalSpeed, function(v) State.NormalSpeed=v; nebula("setSpeedValues",State.NormalSpeed,State.CarrySpeed,State.LaggerSpeed,State.LaggerCarrySpeed); silentSaveFront() end)
	inputRow(p, "Carry Speed", State.CarrySpeed, function(v) State.CarrySpeed=v; nebula("setSpeedValues",State.NormalSpeed,State.CarrySpeed,State.LaggerSpeed,State.LaggerCarrySpeed); silentSaveFront() end)
	toggle(p, "Auto Carry", State.AutoCarry, function(on)
		State.AutoCarry = on == true
		if on then
			-- enable backend auto carry watch if available
			pcall(function() if _GACC then _GACC.autoCarrySpeedEnabled = true end end)
			nebula("setSpeedState", State.Lagger, State.Carry)
		else
			pcall(function() if _GACC then _GACC.autoCarrySpeedEnabled = false end end)
		end
		silentSaveFront()
	end)
	section(p, "Lagger Configuration")
	inputRow(p, "Lagger Normal Speed", State.LaggerSpeed, function(v) State.LaggerSpeed=v; nebula("setSpeedValues",State.NormalSpeed,State.CarrySpeed,State.LaggerSpeed,State.LaggerCarrySpeed); silentSaveFront() end)
	inputRow(p, "Lagger Carry Speed", State.LaggerCarrySpeed, function(v) State.LaggerCarrySpeed=v; nebula("setSpeedValues",State.NormalSpeed,State.CarrySpeed,State.LaggerSpeed,State.LaggerCarrySpeed); silentSaveFront() end)
end

do
	local p = pages.Combat
	section(p, "Combat Tools")
	toggle(p, "Anti Ragdoll", State.AntiRagdoll, setAntiRagdoll)
	toggle(p, "Infinite Jump", State.InfiniteJump, setInfiniteJump)
	toggle(p, "Medusa Counter", State.MedusaCounter, setMedusaCounter)
	toggle(p, "Unwalk", State.Unwalk, setUnwalk)
	actionBtn(p, "TP Down", tpDown)
	actionBtn(p, "Drop", drop)
	section(p, "Aimbot")
	toggle(p, "Bat Aimbot", State.BatAimbot, setBatAimbot)
	toggle(p, "Bat Counter", State.BatCounter, setBatCounter)
	local tpBatVersion = State.TPBatVersion
	expandableToggle(p, "TP Bat", State.AntiDesync, {"V1", "V2"}, tpBatVersion, function(on, version)
		tpBatVersion = version or "V1"
		State.TPBatVersion = tpBatVersion
		if on and State.BatAimbot then
			State.BatAimbot = false
			nebula("setAimbot", false)
		end
		State.AntiDesync = on == true
		-- local GRAPE TP Bat + backend bridge
		pcall(function() setAntiDesync(State.AntiDesync) end)
		nebula("setBatTP", on, tpBatVersion)
		silentSaveFront()
	end, function(version)
		tpBatVersion = version or "V1"
		State.TPBatVersion = tpBatVersion
		if State.AntiDesync then
			nebula("setBatTP", true, tpBatVersion)
		end
		silentSaveFront()
	end)
	toggle(p, "Auto Swing", State.AutoSwing, setAutoSwing)
	toggle(p, "Anti Die & Fling", false, setAntiDie)
	section(p, "Auto Steal")
	toggle(p, "Auto Steal", State.AutoSteal, setAutoSteal)
	expandableChoiceRow(p, "Steal Preset", {"75", "80", "86", "90"}, State.StealPreset, function(value) State.StealPreset=value; nebula("setStealPreset",value) end)
	inputRow(p, "Steal Radius", 60, function(v) State.StealRadius=math.clamp(v, 1, 250) end)
	section(p, "Movement")
	table.insert(State.AutoPlayRows, expandableChoiceRow(p, "Auto Play", {"SEMI", "FULL"}, "SEMI", function(mode)
		if State.AutoPlayRemoved then return end
		State.StealMode=mode == "SEMI" and "Semi" or "Normal"; silentSaveFront()
	end))
	table.insert(State.AutoPlayRows, actionBtn(p, "Remove Auto Play", function()
		if State.AutoPlayRemoved then return end
		setAutoPath("AutoLeft", false); setAutoPath("AutoRight", false)
		State.AutoPlayRemoved = true
		FrontKeys.AutoLeft, FrontKeys.AutoRight = "NONE", "NONE"
		clearOwnedKeybind("AutoLeft"); clearOwnedKeybind("AutoRight")
		if KeybindVisuals.AutoLeft then KeybindVisuals.AutoLeft("NONE") end
		if KeybindVisuals.AutoRight then KeybindVisuals.AutoRight("NONE") end
		for _, row in ipairs(State.AutoPlayRows) do if row then row.Visible = false end end
		nebula("setAutoPlayRemoved", true)
		silentSaveFront()
	end))
	table.insert(State.AutoPlayRows, toggle(p, "Auto Left", State.AutoLeft, function(on) if on then setAutoPath("AutoRight",false) end; setAutoPath("AutoLeft",on); silentSaveFront() end))
	table.insert(State.AutoPlayRows, toggle(p, "Auto Right", State.AutoRight, function(on) if on then setAutoPath("AutoLeft",false) end; setAutoPath("AutoRight",on) end))
	for _, row in ipairs(State.AutoPlayRows) do row.Visible = not State.AutoPlayRemoved end
	toggle(p, "Auto TP", false, function(on) nebula("setAutoTP",on) end)
	inputRow(p, "TP Height", 20, function(v) nebula("setTPHeight",v) end)
end

do
	local p = pages.Opt
	section(p, "Optimizer")
	toggle(p, "No Cam Collision", State.NoCamCollision ~= false, function(on)
		State.NoCamCollision = on == true
		silentSaveFront()
	end)
	toggle(p, "ESP / Highlight", State.ESP, function(on)
		State.ESP = on == true
		nebula("setESP", on)
		silentSaveFront()
	end)
	toggle(p, "Anti Lag", State.AntiLag, setAntiLag)
	toggle(p, "Remove Accessories", false, function(on) State.RemoveAccessories=on; if on then for _,x in ipairs(character() and character():GetChildren() or {}) do if x:IsA("Accessory") then x:Destroy() end end end end)
	expandableToggle(p, "FOV", State.FovEnabled, {"80", "120"}, tostring(fovValue), function(on)
		State.FovEnabled=on==true
		applyFOV()
		silentSaveFront()
	end, function(value)
		fovValue=math.clamp(tonumber(value) or 80,80,120)
		State.Fov=fovValue
		applyFOV()
		silentSaveFront()
	end)
	expandableToggle(p, "Stretch FOV", State.Stretch, {"80", "120"}, tostring(State.StretchFov == 120 and 120 or 80), function(on)
		State.Stretch=on==true
		setStretch(State.Stretch)
		silentSaveFront()
	end, function(value)
		State.StretchFov=math.clamp(tonumber(value) or 80,80,120)
		if State.Stretch then setStretch(true) end
		silentSaveFront()
	end)
end

do
	local p = pages.Config
	section(p, "Studios & UI")
	openBtn(p, "Animation Studio", "Open", function() animUI.open() end)
	openBtn(p, "Character Studio", "Open", function() charUI.open() end)
	openBtn(p, "Tabs Layout", "Open", function() layUI.open() end)
	modeRow(p, "Sky Theme", {"OFF", "NIGHT", "AURORA", "GALAXY"}, 1, function(name) nebula("setSky",name == "OFF" and "Off" or name:sub(1,1)..name:sub(2):lower()) end)
	section(p, "Interface")
	inputRow(p, "UI Scale", 1.0)
	inputRow(p, "Auto Steal Scale", State.AutoStealScale, function(value)
		State.AutoStealScale = math.clamp(tonumber(value) or 1, .55, 1.5)
		if StealBar.setScale then StealBar.setScale(State.AutoStealScale) end
		silentSaveFront()
	end)
	toggle(p, "Show Buttons", State.MobileButtonsShown, function(on)
		State.MobileButtonsShown = on == true
		nebula("setMobileButtons", State.MobileButtonsShown)
		silentSaveFront()
	end)
	toggle(p, "Lock Buttons", State.MobileButtonsLocked, function(on)
		State.MobileButtonsLocked = on == true
		nebula("setMobileLock", State.MobileButtonsLocked)
		silentSaveFront()
	end)
	toggle(p, "Show Intro", introEnabled, function(on)
		introEnabled = on == true
		nebula("setIntroEnabled", introEnabled)
		silentSaveFront()
	end)
end

do
	local p = pages.Other
	section(p, "Utilities")
	openBtn(p, "Speed Bypass", "Open", function() bypassUI.open() end)
	openBtn(p, "Lagger", "Open", function() laggerUI.open() end)
end

do
	local p = pages.Binds
	section(p, "Speed")
	keyRow(p, "Speed Key", "Speed", "Q", function()
		if State.Lagger then
			State.Lagger = false
			State.Carry = true
		else
			State.Carry = not State.Carry
		end
		local targetLagger,targetCarry=State.Lagger,State.Carry
		task.defer(function()
			State.Lagger,State.Carry=targetLagger,targetCarry
			nebula("setSpeedState",targetLagger,targetCarry)
			silentSaveFront()
		end)
		silentSaveFront()
	end)
	keyRow(p, "Lagger Key", "Lagger", "V", function()
		if not State.Lagger then
			State.Lagger = true
			State.Carry = false
		else
			State.Carry = not State.Carry
		end
		local targetLagger,targetCarry=State.Lagger,State.Carry
		task.defer(function()
			State.Lagger,State.Carry=targetLagger,targetCarry
			nebula("setSpeedState",targetLagger,targetCarry)
			silentSaveFront()
		end)
		silentSaveFront()
	end)
	section(p, "Combat")
	keyRow(p, "Aimbot Key", "Aimbot", "F", function() setBatAimbot(not State.BatAimbot); silentSaveFront() end)
	keyRow(p, "TP Bat Key", "TPBat", "B", function()
		State.AntiDesync = not State.AntiDesync
		if State.AntiDesync and State.BatAimbot then
			State.BatAimbot = false
			nebula("setAimbot", false)
		end
		pcall(function() setAntiDesync(State.AntiDesync) end)
		nebula("setBatTP", State.AntiDesync, State.TPBatVersion)
		silentSaveFront()
	end)
	local autoLeftKeyRow = keyRow(p, "Auto Left Key", "AutoLeft", "Z", function() if not State.AutoPlayRemoved then setAutoPath("AutoLeft",not State.AutoLeft) end end)
	local autoRightKeyRow = keyRow(p, "Auto Right Key", "AutoRight", "X", function() if not State.AutoPlayRemoved then setAutoPath("AutoRight",not State.AutoRight) end end)
	for _, row in ipairs({autoLeftKeyRow, autoRightKeyRow}) do
		table.insert(State.AutoPlayRows, row)
		row.Visible = not State.AutoPlayRemoved
	end
	keyRow(p, "Drop Key", "Drop", "H", drop)
	keyRow(p, "TP Down Key", "TPDown", "T", tpDown)
	section(p, "Interface")
	keyRow(p, "Hide GUI", "HideGUI", "LeftControl", function() if UIActions.hide then UIActions.hide() end end)
end

selectTab("Main")

if State.BatAimbot and State.AntiDesync then State.AntiDesync = false end
task.defer(function()
	for id,keyName in pairs(FrontKeys) do nebula("setKeybind",id,keyName) end
	nebula("setAutoPlayRemoved", State.AutoPlayRemoved)
	nebula("setMobileButtons", State.MobileButtonsShown)
	nebula("setMobileLock", State.MobileButtonsLocked)
	nebula("setIntroEnabled", introEnabled)
	nebula("setHeadless", State.Headless == true)
	nebula("setKorblox", State.Korblox == true)
	nebula("setSpeedValues",State.NormalSpeed,State.CarrySpeed,State.LaggerSpeed,State.LaggerCarrySpeed)
	nebula("setSpeedState",State.Lagger,State.Carry)
	if State.AntiRagdoll then setAntiRagdoll(true) end
	if State.InfiniteJump then setInfiniteJump(true) end
	if State.MedusaCounter then setMedusaCounter(true) end
	if State.BatAimbot then setBatAimbot(true) end
	if State.BatCounter then setBatCounter(true) end
	if State.AntiDesync then pcall(function() setAntiDesync(true) end); nebula("setBatTP", true, State.TPBatVersion) end
	-- Synchronize both ON and OFF after loading the saved front-end state.
	setAutoSwing(State.AutoSwing)
	if State.AutoSteal then setAutoSteal(true) end
	if State.AutoLeft then setAutoPath("AutoLeft", true) end
	if State.AutoRight then setAutoPath("AutoRight", true) end
	if State.Unwalk then setUnwalk(true) end
	if State.AntiLag then setAntiLag(true) end
	if State.Stretch then setStretch(true) end
	-- Network lagger intentionally NOT auto-started on load (causes server lag)
	-- User must toggle it on from Utility panel.
	if State.NetworkLagger then State.NetworkLagger = false end
end)

------------------------------------------------------------------
-- reopen pill (created BEFORE close handler so X works)
do
local openBtn2 = Instance.new("TextButton", gui)
openBtn2.Name = "AntiSammyReopen"
openBtn2.Size = UDim2.fromOffset(154, 36)
openBtn2.Position = UDim2.fromOffset(20, 120)
openBtn2.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
openBtn2.BorderSizePixel = 0
openBtn2.Text = ""
openBtn2.AutoButtonColor = false
openBtn2.Visible = false
openBtn2.ZIndex = 100
openBtn2.Active = true
addPhoneScale(openBtn2)
corner(openBtn2, 18)
stroke(openBtn2, T.stroke, 1, 0.25)

local reopenIcon = Instance.new("ImageLabel", openBtn2)
reopenIcon.Size = UDim2.fromOffset(26, 26)
reopenIcon.Position = UDim2.fromOffset(8, 5)
reopenIcon.BackgroundTransparency = 1
reopenIcon.ScaleType = Enum.ScaleType.Fit
reopenIcon.ZIndex = 101
pcall(function()
	if getcustomasset then
		reopenIcon.Image = getcustomasset("AntiSammyIcon.png")
	end
end)

local reopenLbl = Instance.new("TextLabel", openBtn2)
reopenLbl.Size = UDim2.new(1, -40, 1, 0)
reopenLbl.Position = UDim2.fromOffset(36, 0)
reopenLbl.BackgroundTransparency = 1
reopenLbl.Text = "Anti-Sammy  •  "..prettyBindName(FrontKeys.HideGUI)
reopenLbl.TextColor3 = T.text
reopenLbl.Font = Enum.Font.GothamBold
reopenLbl.TextSize = 12
reopenLbl.TextXAlignment = Enum.TextXAlignment.Left
reopenLbl.ZIndex = 101

drag(openBtn2)

do
	local previousVisual=KeybindVisuals.HideGUI
	KeybindVisuals.HideGUI=function(keyName)
		if previousVisual then previousVisual(keyName) end
		reopenLbl.Text="Anti-Sammy  •  "..prettyBindName(keyName)
	end
end

local function closeAllModals()
	for _, child in ipairs(gui:GetChildren()) do
		if child:IsA("Frame") and child ~= shell and child.Name:find("Modal") then
			child.Visible = false
		end
		if child:IsA("Frame") and child.Name:find("Dim") then
			child.Visible = false
		end
		if child:IsA("TextButton") and child.Name:find("Dim") then
			child.Visible = false
		end
	end
end

local mainGuiHidden = false
local function hideGui()
	mainGuiHidden = true
	shell.Visible = false
	openBtn2.Visible = true
end

local function showGui()
	mainGuiHidden = false
	shell.Visible = true
	openBtn2.Visible = false
end

-- The bind toggles only the main window. Utility panels and the steal bar
-- remain untouched, and the floating reopen button also remains available.
UIActions.hide = function()
	if mainGuiHidden or not shell.Visible then showGui() else hideGui() end
end

closeBtn.MouseButton1Click:Connect(hideGui)
openBtn2.MouseButton1Click:Connect(showGui)

UIS.InputBegan:Connect(function(input, gp)
	if KeyCapture.active then return end
	if UIS:GetFocusedTextBox() then return end
	if not isBindInput(input) then return end
	local action = Keybinds[input.KeyCode]
	if action then
		local ok,err=pcall(action)
		if not ok and warn then warn("[Anti-Sammy] keybind failed: "..tostring(err)) end
		-- auto-persist binds periodically already; also nudge save on use of utility toggles
		task.defer(silentSaveFront)
	end
end)

end


------------------------------------------------------------------
-- Auto Steal bar
------------------------------------------------------------------
do
	-- own ScreenGui so it always shows even if main shell is hidden
	local barGui = Instance.new("ScreenGui")
	barGui.Name = "AntiSammy_StealBar"
	barGui.ResetOnSpawn = false
	barGui.IgnoreGuiInset = true
	barGui.DisplayOrder = 200
	barGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	barGui.Enabled = true
	parentGui(barGui)

	local infoBar = Instance.new("Frame")
	infoBar.Name = "InfoBar"
	infoBar.Parent = barGui
	infoBar.AnchorPoint = Vector2.new(0.5, 1)
	infoBar.Position = UDim2.new(0.5, 0, 1, -34)
	infoBar.Size = UDim2.fromOffset(224, 46)
	infoBar.BackgroundColor3 = Color3.fromRGB(17, 8, 12)
	infoBar.BackgroundTransparency = 0.56
	infoBar.BorderSizePixel = 0
	infoBar.Visible = true
	infoBar.ZIndex = 10
	infoBar.Active = true
	local stealScale = addPhoneScale(infoBar, State.AutoStealScale)
	corner(infoBar, 10)
	local barStroke = stroke(infoBar, Color3.fromRGB(170, 48, 66), 1.1, 0.42)
	local barGradient = Instance.new("UIGradient", infoBar)
	barGradient.Rotation = 12
	barGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(37, 10, 17)),
		ColorSequenceKeypoint.new(.55, Color3.fromRGB(16, 12, 15)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10)),
	})
	-- draggable steal bar
	do
		local dragging, start, startPos
		infoBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				start = input.Position
				startPos = infoBar.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if not dragging then return end
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
			local d = input.Position - start
			infoBar.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end)
	end

	local badge = Instance.new("Frame", infoBar)
	badge.Size = UDim2.fromOffset(38, 38)
	badge.AnchorPoint = Vector2.new(0, 0.5)
	badge.Position = UDim2.new(0, 5, 0.5, 0)
	badge.BackgroundTransparency = 1
	badge.BorderSizePixel = 0
	badge.ZIndex = 11

	-- Anti-Sammy icon (embedded)
	local ICON_B64 = "iVBORw0KGgoAAAANSUhEUgAAAF4AAABgCAYAAACUosWzAAAzUUlEQVR42t19d3hd1ZXvb+19zrlVuuqSLfcGtjEYbMDYgDEQakhIgpwGCZAMmTcJeZMKmcxEFo9USP2YEEgPpEkQQgAHiIMxNQFRggvG4F5l1avbTtt7vT/OOdKVEeAiAjPn++6ndnXuPmuv/Vt9LcLb+GKAELzEyF+DR3l79N7y9zCN/t63/KK3IaFFuC41KtGIACEA5pG/03rk74bvKcJ7MgD9dtkI421CbBkSRQNQwcoMDCxfXo2XX5wuC8VZlC9NE67boF23QQhRJ5RrsGaQEIBh+gDt16bsYim3qUzldlTVbipcddV2uuKKApTSZZ8nw2/f0k2gt5DgMlxAQGgpkb/0vU3GM2tPQbawDIXCQtilmabSdUJrQOngv5hH5WwQhaeBACHhSsFsmntgxdbrdPpxVCRWJ7757afowgud6P85YDz1VmwAvUUED7iNCIWLzhpvrH/lQj2Qe4+0S6eYnlcFzweYoQF4EUQQjQCX0W8dfcckAGlGP0sBSAOuZW3mVPJBrqpuX79x4+MLibyyNXF44v53XWVHHDAM5I47bpnbUPsLJ5HoZ8NgBlgBbAO+Q+Q5RL5NpB0iHvHCyJ9tgB3C8M/DX7VNpGxBvk3k2YBmgJmI2bLYrcqsdydN+GLvu989EURDa+S3mdw7EoILjrQSZirOmNHiZCof5liMmYg9gEuAb78Wod/gZZcR/fXfR2wTKZvIK0WbICU7qeSAM67pptyF7zjmf80GrI6Et2GgMG/eu53q6r+zaTID7ACqSOSXDiS2eBXBdEgw3ybyHILnEDwbB7wInk3khe9Ttgjua4vhUzDiviLYBB9gFoLdVNKxm5pu6j3nnInR+tvLT+n/FC6nEIrzS5Yc5zTU3c+WxRxCiU3kR9wacGzAtW5AEG0T+aWAuEoNi9MAJqRkNozgFX0vDWYhmGn4vV74WSUirySCjbBHPwnaJvKcQDKwm0z22pMmfLGT2SwTwG9/4cqAQYDfymxcM3Hil4ze3i+bpVKsFAhIiJHGUCQRAwHKDBOQFGo5MAw4hpEny9qh4/HtQsptnmHsMSoqCq7vl2J93QN+44QGFLMSnl9j+nq87zqTpe9PY8dtjinfgucDWsMLJLTPBCEAcaAeo4M1KJPZkFLCq6x8xp8z69+TTzz1WCuzWDHGxhi9GUTvOfXUOZkN6241srklrlLQRIoASeARH8kEDYY2mA0JAJYF17L6kUw9xZnKR7i68kk1/+iN6Vtu3wfD4Ncykg40rtj3rez73jnB3LzrWNHfdyrl8qeTbR9vua4BpeAEGpUO+CBYEIegzgAzs4oDhp9MaK+uvjW5d8/18HxwwBTqbWVxMiBAhOLsWZe6qWSWAS6BvEBgYgTO2kSqBPhDAi6dzjvjxt3hLFjwwdynP90IORJaWwB5C2CuBox2QEYvBkT0fSdgrgOsdYDFB5wqmCbss8+eXZwx4xq7puaZcsFuE/mOeLVsKREpG9BsGOzU16/c09JS/2ZCz+FqLQTDQGHChG+wZQ0/EBFHRA/wPMBTBphNg73Kyi32tGn/2X9py9RyYjMgOgFzBCcbBihmgZmNUV4SpjkkWcpV2PAUjtiE0sknn+E1N//WS8QdFsTOiPVSKHPAJSIuAR4T2KmoeKX/xBPnjxXxaQyEqL6ls9P8yAXn3x7v7VtuK6UgSAgeeW8d4KeUhoSfTm11xzV/v3j55T+rv+aa3IGmfLgw/m1r66yBJx8/x+3uPdbL5yeTUvUukJFKIee7SEqJejOO6oo0VyeTfcl4ojtJ2GPV1PzN/7d/+/3cZcsK0b0inw0BPgBACOROPvkYc/Pmz4rBwctN2yYHUBAkiJkAGgJ0Bvw4s+EnEtni9OkfyqxbtzKC1X8+p7e2CgDoue22ymJV1Z+ZBNuAa4+mNYSw4iZTeWfq1La+b3wjUy4XWsugoTW8b/vHPz7/h1OmFr+RSPLXrBh/VUpuFYL/Lwn+lBD8OWnw12Ixvjmd5vaqGl7TNJ6fGz+BXxo3jnsnT+ZnFi/+7giV9tUnQUYbUFiyZJFTV/8XNk1WAJdC+LHL7IQSke8D7MbjfmHixHcfKecf1j+2AkK0tenOW25JJr547f2JwcFTHGiPiMwDHlBLZmGYpnRrqlfm5h37+bpVq17EtdeW+0lGcM3cDRsIALxdu8aLnp5E3rFd1zBEUUoqMShGQDUJVBkGamMxVAqJTDyOSsvkJAMJX3vxUsGsK5UaXueYqyHPpdZEjz/+NxjGOwozZlxl7tx5fbxQqHcAHyCDQpErQNIj0tK2hbVv352D48ZdQnv3/vFwOV8cjiBdAWDtunXWnC9dc0dy7+5THNYeYZjooXagYsyCU8lSccqUq2O9fRfWrVr1IgMGB6jtv556lqio6MlJg3tB5n6GkQ20djGRhGgyDFFrmqIuFhfVsZioTSRFdUVGVlRmZCqRMJLSkmnT9ADgjNfHWU2AYkCw74vUxo235pctW2jX1t8bk4Yx7B2KiM9CEzF7nkj09d2RnTv3IgpOs/GmEx6AJCn1lLPP/mViYPB8h+ARyOQyGmqwHyNIryqzsXjMvNNSL798E/u+CGWCfzD68GAmo3YJQVkwDCLUk0AzEZpiFjLCQLU0UJuIozqVQm06jeqqamQqq5CKxwHDhMlEhyDoNAVuBKPm3nt3JLL9F5UmTWoVsZhHYB1EVQjMBAKEJmI4jkhu3fq7npNOWkSAzy0t8k0jPAMGEfnZpqa2VHf3BxxdBi8MBMRnPyak4dTUPli84solVX//+zPhcdQH4/1bP2cOA4BZV9fvmIZfSYKmS8kNQqDOEMgYJiqlQMY0UWHGkTLjSCaSMJNJGPE4IA3AtECGPBxNw2eA2Pet5JYt15WmTbvOFFKA2R+KHATvEz4Ry2IxWbFx412FlpZm6uhQfAj0FIdAdEmA3z99+iWV3d1fcZXyQWQEvBuCB8O3SBh2dfWv/9TdfUHVd7/bF/3fwX7ORXv3yvaWFpme3lQYJ2VpohSoFAJ1UqLGMJAUBlLSQFIaiAkJaA1VssG5QajBQbDvB2s5SDcLAxQpCgDwcLBet3/OcfMTW7de4WnFmkgCEdojMgOFS+Rbg4NN8q9//T0zGwjsGRoz4RpChOpatGhG8vl//NR3Xc1EggJNLTyG7MelNEoVFT9P9vZeyUQRtByKpUcLb73VA4CNF1+sui3TU9LQKcPkuFZkMcNQKuAW32d2Sswk4PgeEqUCDF9DKN+H4wAGqYPkckZbW2C4Ll0qac0av+eCC2annnj8AcO2G2wiLcAiVC/1AbFdwwb8+EB2Sam5+YYk0WfCDfCPmOOjgHM7s6zYuPF2yy5V+kRMQ/4OAgA/TsIoZDJ/Svb3f4yZo+iSPvhTDsA0eeNVH3v/tssvXyw+9KFcjRDp8b4vxrslmXEcUem6IlXMC7OQF2mnJGOlkpFwikbSKRlWsWgkHduIOXYc2jds368CgGdegwN5yFXAVuG6/1pABKY1a/z+d587pWLNmnvNgWyDTVA0bJbpGLOgA1w2RGR4WvmJnu5/H5g9+7wQruQRc/zDgFwG+AMTJ/5nYnDwZBvwRfR/NKS9GE5F5VPd3776/UxEhxjNoVaALt+6NfbbS977yx1//NPyY5sn2fK3d5yMBSesjE+bUu/GE1JZlsmGVEqKgmIoE9SnBrI7Pd+3i4ODfXkhkJAmEnFLpySJohV/AQDuCbQW6gDE8mE1klYAUsYs/3vHzv3lEtf7gPqXj/+mIM3rrd/99h6rWJhWAimBgIEYpGLMslRVtZny+anS96EJAswgIigiIVyPE9u338pXXTWv49Zb80PgeyTugJ7jj5/tWDHbDdysutzn4gPaTaf37Vy6dEJZVP/gP4OZAOCR9vb66xsbc9cC3tO1Ddxz+unPb2Tv3Wv7+j7yfE/PlS/kspc+39Pzsb9v3fzZzh3bPvlcd/fFfcwZZo6FL6vsa5J7eiphWaCYBVgjzAtcBZgQAt888cQbvhoz+TOA/+jkyWzX1hYY4CJIRZEtm8hjEmxXZJ7a1NpamWtq+DoLwSXAs8tc2zbBYyLO19X9KIQledguAw5UR5WvrFyV6u8/q0QBFwRChlgyK1iWHJg69az6l15avRowlh2GMdEKiDOYxYZFi9o3d3a+K0PQRyeTpjOuKe8xOENMSSKltSbNFDcI2oQmSEMQwMQMkwQShgnTkCx8XwrTKsVj1mYUbU4LKvY0TfjDMQ+s/E770UdbyzdscH+4bNlVpaf+fku2UPSVIPlBzTwXECWClgwR4CSpOLP0Mpm1fR/96DvG/eAHXZpZFGtqHkj2959tEyliSBADICZmLUyT3KOPXpJau/Zvr+fNpDfQYlR2zpx3Vb788t225ykCSRCDAmGqYlLKXGNja+WePdd1AuZCwDtkore2ira2Nv27T33quIH2jud793fBFRIlrXUMLADACjUJN1ywCoWTW/aVEXjVFAgSjHEAMlIgTgZmQGPfzKNeembDujltRPqHLS3v6nnwgbuT2UHlCxIXA3QUADvYRKIyeHGrqrYOLD5ucePKNft46VJDrFnjd73n3HGZP6/5h7DtWp8INCx8VZxZOpmqJ+O5wcWstXgtyH09wUPr160zpi5Z8lwym51tE2kKMQ/hopyauqf/1Nt9SktgqxxWngozExHhL1/7Wk32jjtvS5QKDfu7e48xtY6pVBJw++H5iosaECAQFBwiuIJhWoBhCmiDkDQBZQCuBc5kEtRbaNhb9BMvSM/trktX5M2mpjuuvOuuh3566aUn99z/54f9nl7LEUTvB9McJtjgIYyMiO6nUjv7liw5s/HBB1+JGDFyEeSOOqolvXlLu+N7iojKXKusLCml09x8UXzHjntfi+vp9QIa2TlHf7Ry0yu/sH1fCSIZRYsEMyMeV85xCxdW/P2xFyIv5RF73gwDMAz84KKLPlg5/7gbp5+86FubVn+qzS11ZwqOwb4CeUrD14A0BMbVGUjEJMY3mKjLCMRjjNoMVKa2Sa7a/aG7znvX1e8NjkgQQPnx1742o++mHzyW3LOvsUikzyIWCwCUeDh9TYO0xSx0KtWbO/7kM2see+iFAyGUAYOE8PO1NX9Idfe+xyYoAUgwwBS4SkqZzLrEwMDxCDRAfbDqpGZmaeze+zn4fqioDPlgtCmEcGtrfxAS3RijfBRq930J26be9vaObFW1yLn2mVaK8pQQiKUFKE6w0hKxpEBRM7rzGrmSjz37FfIFhf4BD/0DWmzd0qd3bi9cuOq+NctafWW0MlsrV66s7/vZT+/L7dnX2C1InUkQC0CwQylIIGiQNpmFTiYLhalTz6t57KEXeHS5pVlr8k5Y8FknES8YzMSBVwEESBfQiUJhnjNt8vmhK0K+IeFXh4TMHX/8O5PF4jwngBAZeRtNZuGkUvv9yy77asgoYxUK4xZmDYAX3HOPtX/nTrl3194LY1a6FsqHVkwSQHePRnZQI2kwenp9WBLYttvGC6+4SCcFbFdTrughNzhg9Q12/fcKZt1mmu4Ln//c7ys3b5nFRP5pgFzIgBOEzco9qcTxmFOYPv3iqnXrOl/L8xgymqx+4IFtqrb2ewYJwWA9FEAmAnyfMZD9Yhjg4Tck/BmAhpQQu3dfDc/jcl8Tg1lKSV59/dervvGN/jCwMHYBYCJmZrroootKGry1u7dXOr6wWDOkCKLUN98xgJ/enYWvCZk0sK9X49a7svjN/Vls28d4ZZcCyBKO6/H2Hdtn//XHt1z1/ZnTf6JeeWXZfmb/bIJxNjPs6InA0CAWzCxiMS5Nn/HhqrVrVx2Eu1e1AiJ5wQU3OPFYl8kQEENBHOkBbBSdUwsnnLBwNK4Xo0WUus8++ygzn18aahEBdgHaYgg7ldpT/Oxnf8LDCsaYXitWrCAiwoSJTZf7Sm0iaBhSaAIwMKgwb4aByeMEirZGb5ahtMLc6QkMFiSeeN6B0hqWKRCLpag3n+Ptv/jFzbGNL32sy/P1sUTGUmY4GI4vhWqxNuNxmR8//iOV69ffyYD5Rv4lAngFIOjWW7NeQ8MtUggKsw4DLCLS0nWIdu34OEZxlIrRfo5v2vQhy3EMBaiIK8DQQghSVVU/avzUp/IIpPWYJ3u2tbXp1tZW+clPfubFWCzeIaUURIFr9hf3DmLGeBMfuSCDqrRAXUYilTJw3FEWkjFg4jgDjbUCWisIKZFJJCm1ebOWmtUZROJdZapnGdGVaRgy11j3yapt237dGRD9oNTiFQEnU/HCC292EsmcwSyjPAgGpGaGkS++p+d736sMNSJ6LcKr1cyG6B9ogdYgIhFKapZg6cZihdL8+T/lSAF4k665c+dya2urSKUSDymlWWkhLAtIxAi3P5DFjb8ZwJ1rirj/qTxWPpLDvY9k8dymAmxXw3EZYB+yJgNjfzeKff1itjTkuWD44KE0DoAgmH1TSiM7btyXK7fv+mEn8yHZIm0BDUTjzTfv01WZOyQREaBC8508QJm23ZD+8Y/OPJDeRnm6GgGqf+nSeaZdOtoN/C2Rg0gZgFFIpu6vv+eePW92fsny5ctVqOM/0nHjLTttU04yDeijZsaEvd3GuXsd7Njr4iUAW0P+Pe34FMbVCyTigGCN6js7IJ/bipRmLGANycGCg1NPALNnGaaZb2z4VtWuXV/jQ+D00WyRXFPTz3R39xXkumIIWogYnsfoHXgPiP5YnhMkynJXCADMXdvPNV2XOIiHAkSBsWqaoPqmXzMzPfwmJXQyM3Frq2CAOm+5ylyxAjptOM/VVQi4Hvi0E5JYuqACJoD5YCwKiX701CSWn1cF3wX6SsQ7XhrgLfc9gtieXTgLBKkZCjzE6czsx6Q0SzXVN1V0dV1zsK7c14vfVnR2/s1PJl+2Av+WLqMvUaFwxtYtD8XL4YZGCFYhdLGq8s+JvoHzHCIlAKkBtpjJTSX7ip+6elrNN7+ZPSLP2xukihz4+/a7v/L1caWOa/fv7FfKI2mzwD/WO+jf7mBbTqF+XAxHTYmDDLBvgZN2SWQ218PaLr1LXn7JrOCAjQUCVweYPUuQWWga99t0V9eHWCmJI6wOiTSgQnPzjck9ez7nBOFNI+ImIx4ndcK8E60nnu6M0MIoix/pTf/1X5X0ne8sCFcgOMB3TUSSE8lHa264IftmwQwBenV/f9Wc9vbahvOX9Hf+9cnZ/xjIXVHz2+evrNau9k6FVPUSritw+tI0FFIYzDNKLjBQBHO/TdO6NdVtq9kXm3P2P07Z+pfTYpoNTwiSHMSMNLOOC2G6NTV3jhXRy1NAdWPjSnR3fw5lcMOAEp5neHt7TgPQGTG7AQAdoSFUc//9sy3Xq/cCfKfAEmMGScCy7ofWY59v2doq6Lrr9DMXXvivc04+uW3ALlatvU4PZt9xTl3inHMw5747gVyBEo8lkZ9tINdkghICnmJkHICzmmt7XUK8cZdx1odWNc/K3FX5jdavU7GQtInYYB1EyABtSUl2ZeUd+zo6LuNly8QKgNvG5uRqAPCWL3/G2bSp13TdWheh54wI0ApULC4G0XfBZUAfpScMTp36cZaSbcAbrsCA9i1L5+fMnB8J4TcD2387ZfL2PSBeBdJ/AfiOCRP0DT/+iX330qX6aYCfFSZ3QvJTkPwcJD8Hg9cC+kUQP7vwlK33P/jIl+/8/DUri6nEi0zgohAq8pWXiNgFfJ1Oc/d5F3w1MJNb5FhDJaRAsaZmFYdJUVExBANcymReCmXJq9VJUSwdAx1YvuG+aBMg35RduSuuejkUwmOmRkZZY49cf/0UPztYv5LA+6VA1pAau3dT1dNP+S+97xJ378QJ6NIeuqGQh0KfAXTDx576Wl77pS/mHvnyF7K53/zsvPNv+sH5iULp6BKIJWsRuncRB6MopeyVUtetX/sf2av/z2Lq6FBjTHwBpcHJ5NMQAhSgRuDKBSA8b1Lxve9tiuIPxtBREQLke7MCRZcotFaDfzaszeOuvbYw1kL1jIcfFm2A7vnb4yfX2k5iF7Par7UUIowf/uHOVCEew8tXXw2rvQNWTw8qCCh2d6NwwgJ4Z54pPNNIpD77+ePO2LoFMUCXiCBDP74GIQagiwRWETDN87iur4/Nx//+VRjGMnR0jLkBSLHYc5AS8L1InJMHcEypOO3YMQXArhUAGUNQq5RAdfXE8uA7B6EVwDBeDvFdYiwTNdesAYhg7Ok61XQd+ATOAhCaYQiC0dOLeHsHsuefC/u88yEtCwZrdru7ychkwJs2QTxwv3FJbx/XkWAHWshIZQwDKANEeACM/YpR6dpytzR08649Z/RddtlS+vnP13BLi6SOjiNWFjpChnQba7ZYu3cDnifL8nAUKWX4ueJUAI8BoCidjp+/7bYkfFU7VDpAUY6tgDbNba9bEHCY1zJAwTSgBgcXaKUgBVGSw7gbM1gIxPftg/j5L5Fpea/KC0PuN2JUaxlIrv4r8utfxCUAZkhBJcUkw9gRM8EgwCXCX8GwGUgC6GLGdhDXDw4g0dn5VWY+DURj8mARBMvapp0+1uYNIO2H9Q6BysMQdmHcqzB+xu9+V0HKr1Aoz5kKNoDj1t4xF6ihe3/TukcrOTc4swjABIkkCAkC4gASYFhSIplKcf3+bmdiwsqO37tzZ3LdC5zYvQeXEOE4KWArPVwzj4DoDhH2hfyfAJAkoMDALt+X25RS8f37l+QuvfR9BOjVS5eOWbFB/5e+NAjLyorhxKfQXGaw59WXE54AQKlShsApXRaZIiDwxcZjPeX66lhcHS0tAgBtuuFHx8Qcp9YN/eFmqOOaAAwiWKxhGJKL06br7mkzU9Uf/HApsXCBXmrFcBwAWwcWKVHgh7HAyAP4CwAfhFiUsgPAZKBHa3QRU7G/n41nnl/RzizPWLNGjRUzTTrlFJu17qGyvKIgMKoBSQ2Rfj/E8bRxC8Hz6QBFPVDjC/nuMceZjg5ACN7x7Np/GczlYRFpK1yQDAllAbCYQZYpBnduTxeyg0ZBiKmLNmz0j+nuhh2WD4S6QMDpINwHxn4wTGZoUBBh4oDzFYAupcV2hk5075t73jvfeSUBfKRcTxGDmyarWLw46nsKhTJ1sqUlyEefMaPaMk3wSHWRQARPCnes9fblgHry9lsa9Y7t73tFa3QTJId2thESy2AGSCDVn0Vqw0bW/b04paMDJ615xHQBEIcZDwAkCArASgC9CKBKgVHBGjLULyRCrNfALlYoFfNsbtl6NTPTGHE9gRns+4OvggciwFMcycqhHaCKCksEXuCRpikREI+LsST8ijPOkAD8TT+67X2UHawA4O8DDIuBxlCX8mm4h4rh+yiOG09n33MPlnT3mrYQEKyHkkijfMHVAPYzkALBZYYmRi0EeqHDuGpwOnxmaCkFpTMkSm7jxp6N6dlAbkzUZaVgFAp5jIrNuiyFL9Jlt20b8HwvjNeWOyA00N8/tr73NWs0WRYGd+/+SMl1IUTQIUIxwycgRQHMRFGiIhEW/+M5nKI1HCFAQ0SnIIGTCA8xsJeATKjvughgp5YCmOkFwwn1+vGC0Gha0CQg2K/K/OiOGgC50IY5MpiXEqqyohZ9fa/25khzSFsc4mSZTNo6sLgiNw2iDhsiU5ceS2u1DdD3fvKT89Dbc2IJYB2UEyNJBCZCMUguggahyMAMAk7SDJ+DRUfwQiEsPQVgdwgvRAyDAI8BlwPB20+EXgBZBBmlIMDVGgXfZ+F5lnzllWoA6Fi+fExONvsqMdqecCqpy7UaBgCjuTkPQSUJjCx4Y4bpO5VjGNsTALD/0UeXUy4nFAURGxOAFarUHgMlAHsZqCNgUejC0Dxckk0gmAQ8QoSdAKoAJBhIg1ABQFKQpORCI641BDiEm+A+nmbylK8N1qC+fbMBoH7/fjp8Vg/cYa2+LyTrzKvyloQASHRHGD+0w6VTT82xYeREKP2GCa/BttP4eglQh7K4NsDvZE4Wdu+8Mqs0pBTCEoApAEMGqYEGMzwGphJwfqiRcGTThSBjAHiYgReYMcBAdyhU9zEwCGAmESqYgWRax+pqfGZAhDCiGPA1wycwlIIo2lPCDIsjvq5esSINpWr1sIQctodisa6hfQjtU6r79KdzILGPygVCxB6uP3mMfO7c3tIiFwA24lXrYpYB+BpaMbRiuB6jUkqp0glMLCO6OmDHLSI8TsBaAKkyFTQSXyVm1BJxhhk8pXk3T5iwywxDcRwWYQEMDQZcH9yfnzLkwjiixwPMv/61SWhdE605KJgJPAAqldp1YMyVYBiaa2v3ADh26P0IFWTXnxEKhSOS+EE6eYda9/ANTXPapnVlXypyvKD14HMl8npKlJlSU+iJL7pxwpbNHz37+eenGETsAzRkBVIASY8DWBdapLrsAblsAzxmykOgfvvO5mTJZkcQC9akIwuXAV8FRQZmvlALIQCt+UgJL3p7J8aUkmEimAhvKFlK6HR6W+BfaBnyDwsopYloA4jOK1Opgm9ZzW7VWhCROhKhCmrj9pv+bcZDq25/VHJPU97RHE+RccwVjVg0y4CujVndd/uzqu5cO9EQgM+RsY0h6/MZAM9yoPmoMsJHioMRajMOA/VSQBQdQYaA8H04AOKSYAgGSYIWAmANg1QdpBwTwsNx5oUORR2Ux4JNgDwpi3LatK148kms6OjgkVK8qmo9pBxyxhNAPgDyvelfPP/88UMO/8O6HhYEcLZ/7cel7mnq6XXdCtOghNX8j6efHvQ39wKDTwyYU7//4AfTpKQXalZRLaFFwJMAHmaGAMMJozcxAuKh+mmFhHcZ0IK4gZj7a6pzuOCCOyc1jx+ckEjAVIxBjzFge+gZdCmXc1HKFSZ3uq4ZZnzRYYswIohicSGUCpvTBcAR5Jqb21O3394VpYUY5Zq9amh4Xm3bDvh+lBlMClAxX8WdzZuPA7Dr8AVsgJ+eLlU110ItmZvWDTVxP1N3zv/77h/v+tq+53tnTb+pRztdLliQID3s7IgDWA9gDQfqYx6MEjggNBNiIQTFQ+FbRYwmaSgJGIWJk35x0T33fJo9P/HoZ9/1g1zu6Y+7ylNOH+S2Atge9OEUxu08PzAj6DCfjgDoVq0FqqqOH0KRIICqQRA6Fl9HQugRwe7oNGe/8IWN4sMf3hd37CY3wigihlKgbPZUAPcdLuHnzm1hoAOTJ8y6d3B/zyeSCS3HTZbYnN26aJzX+MBJv9wyK9blsitJijAJIiA64WUAjzBQG8INh+6B6OUhUD/zAGxmHG8ZXKFZbq2u7k585rJv4bJO/PRbF52baN56PsNQkkydShli7tG1NK3Ox54Xp5iPfWlt5tQYsihLeTpUVXLg7LOnSsed4ZU5JsEMSAE/kfp7iCQ0pE5Gnvfmiy8uIh5/NmqYMwQtWkO79rlhvdJh4fzy5R2qtRXigit/vdIR43/ala3at27b+G92PWH85srvdy7O7HbYFUQR0RlAnAhbCXgoch0AcBHkPooQXlKhDl8HoJ6BZgA7PV/v81ySVZl/zPrIv+/604031tmDW39VGOhu7tunZL7PM19an6UHVu6m9ZtsNf74XYsmLLn1/1AbNFafcTjhQMEAGTt2nBXzXEuHilhYHyi1aUGPb3q8nMnFiJih1uBkehWEHNJgotCVtN15ztJFM8pakByG7QRNRPqKa/728b1H3zvtmAsf/M+FX/7Dj+DlF5SIWGgWobNEx0G8k4HVYZptAkAlERpIookCd68fqoY+AC/KOQm+kgkgGTPqWWty8PQs0yhWVKV8TBhXt7eidvbvmxprwKTo8aezWucd3dC0rXQkWQYkBHM2e3GI7zRUogmQa1m7+m6//nmUuYrFgR4cPW3Kg17M1CJoLTKE86brGnhl+0WjBckPNRqvocWi7y6HU5151PJLJ5UYvghlkAJ0nCH2AfSXEHLN8AMHmGEzYxoJpENY8UK/jMvhVwQhYwKgPF+TaXKm6uhthkw5wqi1U1VHf/oDn13zgWPmXnx8OjPxb0L6Yu/OInV1aQUADx+mxdp12WVNRj5/miqnDwc5OzqVWj112plRDcRIjo8kevqhhzaomPW8FchkHQQZiKA1ULQvPRK4GWr7xUx1q1+5LzYwuKiktS+IDGIAglSCIZy6um2P1NbsN1hHjczKnKUMl8v8HWUdbyP93AutV+1rDUPinI+37Zk0fekyXfvOk879WMcdra3aGMCSbY7r1kvhyZf2WLSvOHV1EIA/41AdghIAUk88cVHcdSv8YccqACZYFunGxnvK8X00zpVExFxZdReEAMA6TDqWLqCNUml+6aSTFoUPKQ+D6GIFM5VqqjsSvb3LAk6HQWAwkYpplp5lbSl8/vPvLJimFwlSGoGHwc9W6EQrzw4abpvN8KMjzIxWQLzjw//95PIrv7u2vXWO1dZG/u7N3/9ZXbpvuqdrnT3Fmf+6ePkP17a2QlBb26ESXsMwQH19lyPoozCUoWEC0rNi+9NXXPFA5DR+LcIHGVHz53e4sZgvGTKoCKEw0d4l2rnzU3SIAeKI6CSEuqa65ieJ7OB7bGZPEIyo9ijGLP2Kih577vHv/NdrrtkoNVeoMn8dYbjcMvBAUmitDtt6Q00GQs1AFnIMpbEC4Pb2Ftna2irWY4MPAHEzfj+s6T+pnnTuoss+c9ctra0s2toOLWcogo7eE09cHMvnF7tR2RIxwKwEEfxU8o/0f/99kN+onoABASGQr69/sDwjqkSkXUC7yWSp9P73Tx/qvHcQRGfAgJQoNI2/lcVwC60wy0spgN1Esj8/Z858AHjyNz9u/GVTY99tAP9CCP1LIr6NiP+biO8Vkjul5PuF4O8R+CYC/zcR/5CIbxbENxPx9wSpRwHeOnHC+nbmN2xX295yeNlxDEgQIVdX18FBQznPDTPwXEB5sZgeOPHEhaMhhBjVGNAaaGz8HkwLUZciYpAiKLNUitOTT34h5Ho6CE6XROQXqqu/nuzu+hdXaw9hjxsGaclMOhEv5OfOuTi9YcPzDIiu5zZVKcfJ6DKOdgGkAdQgqF+qJIFaEBSP8AVFCjTZAHxXjTv6sccqaRTlnFshWlthtLa2iuUdhy6zQqbTg/NPmm3lcu92Q49FuBxlAuSnUk9UPfts52hdTMQoJphiQKTWrr3fTqbWxsoq+wgkfWYte3ouz15wwUxELvLXtuYkSekXJk/8erJ/4FpXKY+JzLCchCUzUSrFhSkzL67p7FyzacaMGAFaDg5mYoFuzABIh1GlOILqgQQJVJNACjSEDUwjN8AHIHxX+M8+O2oQm9qg29rgtx06pg/LeSGYdmxpsxzHVEQaZd50GCbp6roboBQeHoVGr0U0QUTaH9/0LRgGMQfeKgJIEbFRKsWszs5vkhCvyfUBppGfmzKlLbln77WO8v2A6AwNsMmsRSymStOntFRtXLeKAeP544/3AYAdh0NH09DNNYCkEKgQBgQAjzUcivrhjgxu6khYkYCOx8c8Eysy+3uPnb04nsu2OIAWQewFDCiLIexE/B/JV166lwExWn+H1yK8YkC8tGHD7+10xYthlUNkn0iXWcUHBt5jH3vs+eEJkQcszCQh/NzkSZ9Lb9/+Fcf1fBBJCksbJbM2EglZmjLlo5UvrP9DJ/OIKjsn18dK6SGiR0Fvh4F8WSA86pdDB8TmdajjCUkkqo1h033sErHAzCKxfff3DddFWL0drIUZME3STU3Xhd7cUWksXi9HZCGR5zaOu1YYBpUvXBORdhymLZt/yLe0JkcsKKwlyk2d+sn0vn03er7vc0B00lGVnWnKwvjxV1Vs2vQbHqX5RK6v3yKlgozbECAFGE6ox8iwT0yMwEE6CA8vnIOssQQAT7NH9dO8MWZ4SYAanDjxc4nB3EInLKenQBopC5BOIvFEctOmu7i8wehBcnyE9TLz8sY/FSsr/xoLynIUB/qycIm0lctPKXzlh98hIvUMYHQCJhF52YkTL0/t2H6T6zhKEUkBJg6KeJVpmkZhyqQvpDdv/jEzG6MVfEmWpgDDDYPegZAhpMrybsjXLLUmnxl+mSoZng5OAVDCzD51xhmFA4JwRwoxfu/Chccke3qu85RSDBJh6iATM3zLYmfSpM+/kfLxRuogs9ZUOmbm1W487koOMog5iN5Ll9lP9Q18YmDa5OULAW8h4A3MnLm8orv7557na00kQqKDwMoyTaNQW/uf6c1bb3y9Il7ruNn7vVicjwLRTNOErYMwXRIEE8Sm77OoTFOxrrZg0jDEcJn6IEFIVqb6PxGPe2ORLxOd6B3f/nYi8dKmX0vbjqugHXd0a2UJId1M5seZ9euffKOSJfEGTmYNQNQ98vcXnerqNlMICWYVcY8mkr7n6dSefT/Lnn/WrNzs2Wclt2273bdtrYlAQXMFELNnkTCKjY3fSe/f/1XW2ni90sbSi5tPGe+6mC5IL6upx+LmiWEyquCE72ozXUHuOef+y+DkSfclAqqqiL1U0OGfE8TwTNkPpaJSoyO9DBJC1X7zm7ck8rljXYIvhno8kDaYpZNI7Pbe8Y5rmVngSAs4QgNIMrOwa2qeYICLUZkJgnbfGuBiRXp3KZnMq+Dv2o66aAMuS8nFceNuCUO4xmsYNBTsERvfmDBh090Ab4rFVGHcBOaj5/Kfk2n9IODtzVTx4+eccw2I8KuZM/74c4C/R+TfCPAPAL6JiG8ieC8JoTcuWPgLEI3aX/hQrqiz92Bz87VsGCNKleygXMljy+LszJkXHqw75Q05ITxHLIh0ad68D3nxRL/JTDqANRAgHCKO5/LjjWIx5RFYcKRVsx8TwixWV/862dPzibAGaNS5S62trQSAn7j++markJ+ynUjtA6HLLvDAnl1qXrGgmyorjb1LT//SklWrvslaS9KcrABwrJRYYsUxNR5HkhkNRGQnU2Q31P8ZzMDSpUfCeOZCIi87c+blFd37v+75vo+yxkAM9i0hjGJ9/Xcyr7xyX1h6OXZVkdEu9s+efTHHYuwAXtQYLiqyKhHpsBc7l8JTX2qovzc02wW/fisuAkDrurrSt0yevOf7AP8c4IcA3kDEL2aq+JFTT22FlLgFMGGauGnihMfvB3i7NHxdXcfe/IX8woTJqoOIH5k4+eXdvDvJh9CEczSiA8DAnDkf1Ikku4AfDX0Jn9tjgIvVNas5eMaDnqZz0NgXtYWq3rjxj7mmpv+wDMMA8xC2hhP4KMR/bQlBbl3Dg/vOv+CSFiK9Yvj0vObJagXomMbGfHzx4uVVR83620B9XXZLU9Pg9lkzHtt83lkXn/74422rlTI+AfidT67M2K47dQBAL5iKgqAhMC9VoWcZFhfqan7dTM3Fhw+j2UXkXyLAyx4z54rU5s23eaWi9okEwtMcdmIy3MrKbdkLl74fFGSOvGlT1BgwIARy48ffUu7wKu8Z7wLKTySc7ne9K3IQWYecJmFZePxXv2pYdffdjVH7wnZAtoeVeh2XXbbwOxVp/haR/rNp8vZMFReaJ7BdVeMXKqr4sfddfA4Aaj/Eyr4hfJYSxWlTvsAxi21AF4M++EGrQ0HKB9hNpQb6Tj993uG4yQ9b2EJKFMePv4OFYJvILZ+xYRNpD9BuMrEvO/eoi0BDfXkPanGtZZUq0WdGBIxKNFd9++bmn9TXO18F9I+lcB+Lx/xNyZTbDdKbm8a569rbm0IL82BhhqJ6391/+lOy0DzuF2yZbAfzqnQpqpkVYa/NVMrtmzfvdABHLLwPlfhiNbNRamq6i6Vkm+AeOClBA6xiMXamTPrqOmYrOjEHi4PMTKMRrqWlRYII7eec/eXbamr4B4L4DgI/KSW/UFvLjy5b9qVQgxKHxOUABhYvXmhXVz/LgtgO5NjQ5IRi0OCUvUTCzR634MIhBPhnXpHQameWhQkTfs9SshN0H9Vlk2W0DSiWkr36+s7iWaefUlbjbxzJWDcGCFLivssvPfPnc+d+52dz53bcMf/Y7957xWVnQwgczL2jyToAsI7ZsidP/pKbTNjRRJ/h4TLgEgXjNrxkMpedP/+Ct4ToBxIf0kBx/PjvsGmyA6gSkSqfbFYKwqDsJRO+M3ni9/Mf/WhTucw43KyF8tki5VN1Wl/nfkN2SfQew0Dh+GMvcmuqnw3bCXAxGHE3NEKpROH6Kyr2ZE84YdFbSvRXYb4QyE2Z9mkvnlBh5Mqzh1VNLhEpJ5yr51Wk99qTJ1+b/eQna8sDC4cz3LC9pUW2hvOhVgPGaMI0gsYRxDIkiifMO81pbFjJ8Rjz8LDHA0+sx0RsV1c/s++ss6a9LYh+gGCSAJA76aQzvcrKrRxYrX44zJDLXp4CmKXBbkV6lzNl0tftCy+ceeAcqPAkHNaUyTJCywMF39atW+OFBfMvsRvr/+LFhgiuSiI4pWUyyvcAZtNku7HxV8/fcEPqn6K9HLaqCWBPS0u9XV//OzYN1gCXKDC2yrhflwBfRZPPksmi09T0x+Jxx3049+mPvWryWfTA4Wa83ku+CraIwMxy4JRTTixNmXR9qaZ6UzTwsRj0PvAPnMrmhOOTvERioDBt2r9G6+Gx8fm8acQfmq+UmzbtA146vYOFYKe8lQgwfJQJnhulx1gW2+l0n9NQf09x+vTPF5csOXVv6+cagqlmB/HM4YS03Z1/SmbPXXZUcfbs5cUJE24u1VS/6MXjzFJEBFclIr+EslmvIlgLA8yGwU5NzcruxYuPKtv0Me3TQ28W7iP00O654or6mgcf/Iro7b3KtG0rGN8JDZAISs0omsStiRlGJCalBCwTJcPMkmltg2VuE0LsUKn4fldQ1lB+AdIEXA9KUE3c13Xs+ROU704WjjsVntcU93wJP+go4AZmpc+gIK4ynBaiAdYmwxBSwk8mt3gNtW3Jbbt+BeXjcFuzvz24nwi5k08+1m1qavcSCWYK560SPHsIW4dPQcCN8IqA9oeSxYhZlM1zNctexqvnubrDs2O9QM5gaOJxiaBLBN8uG/ToptNdxSlTWntaWyvL5IzA/9SLywQvpIR74okL7ZrqX3mJeJGFGJpmHE4fVja9/gRjG/BKr3pRNL3YK0UTjEdOdghhjXybEAzNDSHFTae32JMn/se+j32gcTSD6n/8NYKDhIB9+ukzvebm67zKypfYNIPpxMEmcDAKmrxS5PEUo87fHjEc/cC/RScn3KxAQwGYpWAnHnOcmppVzoypH+5qbU0fIMD/KbO66a3YgFAMKgDYtGlTbPzFlywz+7vejVzhTOn7s6TnAVohaqzgRR1RgvHRGJFRyQgjuiOeSUYZxoHAlXBNsyhM82kVi9+NyZPviz/77CYoVa6NqTfNs/h2IPwBGzAchSdCp9bm7NNOO1bs2rVYFvKL4Dhzla+mWsqvFJqDGnCty5oDH1ACLyVABFcIsJT7yTQ3IRZ7DpWVj6pZs55KPvDA9jJiR1kj+p9J8Lec8AdqQCFv+iNUQymR+8AHGmIbNkzU+fwE4Tjj4Xn1ZNspX/kxamis0f39WdMyiszUp+LxHmWae7iycqd31lk7a268MVs+bjpKKcRBjr/7X0340aJQ4UbwG4bQotSC179fVAzAbzWx37aEf4PNoINcL5cRmt+uz/X/AWMBCigKeBqFAAAAAElFTkSuQmCC"
	local iconImg = Instance.new("ImageLabel", badge)
	iconImg.Name = "AntiSammyIcon"
	iconImg.Size = UDim2.fromScale(1, 1)
	iconImg.BackgroundTransparency = 1
	iconImg.BorderSizePixel = 0
	iconImg.ScaleType = Enum.ScaleType.Fit
	iconImg.ZIndex = 12
	iconImg.Image = ""
	pcall(function()
		local fname = "AntiSammyIcon.png"
		local bin
		if crypt and crypt.base64 and crypt.base64.decode then
			bin = crypt.base64.decode(ICON_B64)
		elseif base64_decode then
			bin = base64_decode(ICON_B64)
		elseif syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then
			bin = syn.crypt.base64.decode(ICON_B64)
		else
			-- pure Lua base64
			local b = ICON_B64:gsub("%s","")
			local alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
			local t = {}
			for i=1,#alpha do t[alpha:sub(i,i)] = i-1 end
			local out = {}
			local buf, nbuf = 0, 0
			for i=1,#b do
				local c = b:sub(i,i)
				if c ~= "=" then
					buf = buf * 64 + (t[c] or 0)
					nbuf = nbuf + 6
					if nbuf >= 8 then
						nbuf = nbuf - 8
						out[#out+1] = string.char(math.floor(buf / 2^nbuf) % 256)
					end
				end
			end
			bin = table.concat(out)
		end
		if bin and #bin > 100 and writefile then
			writefile(fname, bin)
		end
		local asset
		if getcustomasset then
			asset = getcustomasset(fname)
		end
		if asset then
			iconImg.Image = asset
			if titleIcon then titleIcon.Image = asset end
		end
	end)
	-- fallback glyph if image failed
	if iconImg.Image == "" then
		local fb = Instance.new("TextLabel", badge)
		fb.Size = UDim2.fromScale(1,1)
		fb.BackgroundTransparency = 1
		fb.Text = "X"
		fb.TextSize = 18
		fb.ZIndex = 12
	end

	local title = Instance.new("TextLabel", infoBar)
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 48, 0, 6)
	title.Size = UDim2.new(1, -104, 0, 16)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 11
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = "ANTI-SAMMY"
	title.ZIndex = 11

	local modeLbl = Instance.new("TextLabel", infoBar)
	modeLbl.BackgroundTransparency = 1
	modeLbl.Visible = false
	modeLbl.Text = ""
	modeLbl.ZIndex = 11

	local chip = Instance.new("Frame", infoBar)
	chip.AnchorPoint = Vector2.new(1, 0)
	chip.Position = UDim2.new(1, -7, 0, 5)
	chip.Size = UDim2.fromOffset(43, 18)
	chip.BackgroundColor3 = Color3.fromRGB(55, 20, 30)
	chip.BackgroundTransparency = .34
	chip.BorderSizePixel = 0
	chip.ZIndex = 11
	corner(chip, 8)
	local pct = Instance.new("TextLabel", chip)
	pct.Size = UDim2.fromScale(1, 1)
	pct.BackgroundTransparency = 1
	pct.Font = Enum.Font.GothamBlack
	pct.TextSize = 9
	pct.TextColor3 = Color3.fromRGB(226, 226, 232)
	pct.Text = "0%"
	pct.ZIndex = 12

	local track = Instance.new("Frame", infoBar)
	track.Position = UDim2.new(0, 48, 1, -9)
	track.Size = UDim2.new(1, -58, 0, 4)
	track.BackgroundColor3 = Color3.fromRGB(31, 22, 26)
	track.BackgroundTransparency = .34
	track.BorderSizePixel = 0
	track.ClipsDescendants = true
	track.ZIndex = 11
	corner(track, 2)
	local fill = Instance.new("Frame", track)
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = Color3.fromRGB(220, 42, 62)
	fill.BorderSizePixel = 0
	fill.ZIndex = 12
	corner(fill, 2)
	-- Visible bar; progress driven by backend steal progress
	infoBar.BackgroundTransparency = 0.56
	barStroke.Transparency = 0.42

	local targetProgress, shownProgress = 0, 0
	local resetAfter = nil
	local lastRendered = -1
	StealBar.setScale = function(value)
		value = math.clamp(tonumber(value) or 1, .55, 1.5)
		PhoneScales[stealScale] = value
		stealScale.Scale = PHONE_SCALE * value
	end
	StealBar.setProgress = function(ratio)
		ratio = math.clamp(tonumber(ratio) or 0, 0, 1)
		-- Hold completion briefly instead of snapping from 100% to zero between
		-- backend samples. RenderStepped below eases every visual change.
		if ratio <= .001 and (targetProgress > .04 or shownProgress > .04) then
			resetAfter = resetAfter or (os.clock() + .22)
		else
			resetAfter = nil
			targetProgress = ratio
		end
		infoBar.Visible = true
		infoBar.BackgroundTransparency = 0.56
	end

	StealBar.setActive = function(active)
		infoBar.Visible = true
		infoBar.BackgroundTransparency = 0.56
		resetAfter = nil
		targetProgress, shownProgress, lastRendered = 0, 0, -1
		fill.Size = UDim2.fromScale(0, 1)
		pct.Text = "0%"
		if modeLbl then
			modeLbl.Text = ""
			modeLbl.Visible = false
		end
	end
	StealBar.setScale(State.AutoStealScale)
	StealBar.setActive(State.AutoSteal)

	RunService.RenderStepped:Connect(function(dt)
		if not infoBar.Parent then return end
		if resetAfter and os.clock() >= resetAfter then
			resetAfter = nil
			targetProgress = 0
		end
		local alpha = 1 - math.exp(-math.clamp(dt, 0, .1) * 13)
		shownProgress = shownProgress + (targetProgress - shownProgress) * alpha
		if math.abs(shownProgress - targetProgress) < .001 then shownProgress = targetProgress end
		if math.abs(shownProgress - lastRendered) >= .001 then
			lastRendered = shownProgress
			fill.Size = UDim2.fromScale(math.clamp(shownProgress, 0, 1), 1)
			pct.Text = tostring(math.floor(shownProgress * 100 + .5)) .. "%"
		end
	end)

	-- Poll steal progress (backend writes getgenv()._AS_StealProgress)
	task.spawn(function()
		while infoBar and infoBar.Parent do
			local stealOn = State.AutoSteal == true
			if stealOn then
				local ratio = 0
				local gv = getgenv()
				if gv._AS_StealProgress ~= nil then
					ratio = tonumber(gv._AS_StealProgress) or 0
				end
				if ratio == 0 and type(gv.AntiSammyGetStealProgress) == "function" then
					pcall(function() ratio = tonumber(gv.AntiSammyGetStealProgress()) or 0 end)
				end
				StealBar.setProgress(ratio)
				infoBar.Visible = true
			elseif targetProgress ~= 0 or shownProgress ~= 0 then
				StealBar.setProgress(0)
			end
			task.wait(0.03)
		end
	end)
end

--[[ COMPLETE NEBULA RUNTIME — embedded; the Sammy GUI above is the only intended interface. ]]--
task.spawn(function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

-- Anti-Sammy build powered by the complete Nebula feature runtime.
local ConfigShare={FILE="AntiSammy_Nebula.json",startupConfig={},applying=false}
do
    function readJSONFile(path)
        if not(isfile and readfile and isfile(path)) then return nil end
        local ok,data=pcall(function() return HS:JSONDecode(readfile(path)) end)
        return ok and type(data)=="table" and data or nil
    end
    ConfigShare.startupConfig=readJSONFile(ConfigShare.FILE) or {}
    ConfigShare.appearanceVersion="ANTI_SAMMY_COMPACT_GLASS_V3"
    if ConfigShare.startupConfig.n5AppearanceVersion~=ConfigShare.appearanceVersion then
        ConfigShare.startupConfig.uiWidth=380
        ConfigShare.startupConfig.colorThemeName="MONOCHROME"
        ConfigShare.startupConfig.n5AppearanceVersion=ConfigShare.appearanceVersion
    end
    local camera=workspace.CurrentCamera
    local viewport=camera and camera.ViewportSize or Vector2.new(390,700)
    local viewportX,viewportY=tonumber(viewport.X) or 390,tonumber(viewport.Y) or 700
    ConfigShare.mobile=UIS.TouchEnabled and (not UIS.KeyboardEnabled or math.min(viewportX,viewportY)<=700)
    ConfigShare.maxWidth=ConfigShare.mobile and math.max(280,math.min(370,viewportX-12)) or 500
    ConfigShare.minWidth=ConfigShare.mobile and math.min(280,ConfigShare.maxWidth) or 350
    ConfigShare.uiHeight=ConfigShare.mobile and math.max(300,math.min(410,viewportY-24)) or 450
    ConfigShare.mobileWidth=ConfigShare.mobile and math.max(ConfigShare.minWidth,math.min(math.min(ConfigShare.maxWidth,350),viewportX-22)) or 420
    ConfigShare.uiHeight=math.floor(ConfigShare.uiHeight/2)*2
    ConfigShare.mobileWidth=math.floor(ConfigShare.mobileWidth/2)*2
end


-- Shared with the front configuration so disabling the intro persists and is
-- already known before the cinematic startup check below.
introSoundEnabled = introSoundEnabled ~= false
introEnabled = introEnabled ~= false
do
    local data=ConfigShare.startupConfig
    if type(data)=="table" and data.introSoundEnabled~=nil then introSoundEnabled=data.introSoundEnabled end
    if type(data)=="table" and data.introEnabled~=nil then introEnabled=data.introEnabled end
end

local animEnabled = false
local currentColorTheme = "MONOCHROME"
local themeIntensity = 1


local THEME_DEFS = {
    IMPULSE = {accent=Color3.fromRGB(158,72,255), accentDark=Color3.fromRGB(75,28,132), accentBg=Color3.fromRGB(24,8,42), accentHover=Color3.fromRGB(46,15,76), accentRowHover=Color3.fromRGB(20,7,34), bg=Color3.fromRGB(4,2,7), bgDark=Color3.fromRGB(1,0,2), row=Color3.fromRGB(9,6,12), input=Color3.fromRGB(12,8,16), divider=Color3.fromRGB(42,27,56)},
    NEON = {accent=Color3.fromRGB(194,74,255), accentDark=Color3.fromRGB(103,25,170), accentBg=Color3.fromRGB(35,5,57), accentHover=Color3.fromRGB(68,10,106), accentRowHover=Color3.fromRGB(30,5,48), bg=Color3.fromRGB(5,0,9), bgDark=Color3.fromRGB(1,0,3), row=Color3.fromRGB(12,4,18), input=Color3.fromRGB(17,5,24), divider=Color3.fromRGB(60,22,82)},
    MIDNIGHT = {accent=Color3.fromRGB(116,82,214), accentDark=Color3.fromRGB(48,34,101), accentBg=Color3.fromRGB(13,10,31), accentHover=Color3.fromRGB(28,20,57), accentRowHover=Color3.fromRGB(13,10,28), bg=Color3.fromRGB(2,3,9), bgDark=Color3.fromRGB(0,1,4), row=Color3.fromRGB(6,7,15), input=Color3.fromRGB(9,10,20), divider=Color3.fromRGB(28,29,56)},
    MINIMAL = {accent=Color3.fromRGB(151,126,181), accentDark=Color3.fromRGB(70,58,86), accentBg=Color3.fromRGB(19,16,23), accentHover=Color3.fromRGB(36,30,42), accentRowHover=Color3.fromRGB(17,15,20), bg=Color3.fromRGB(5,5,6), bgDark=Color3.fromRGB(2,2,3), row=Color3.fromRGB(10,10,11), input=Color3.fromRGB(13,13,14), divider=Color3.fromRGB(39,36,43)},
    ["HIGH CONTRAST"] = {accent=Color3.fromRGB(217,139,255), accentDark=Color3.fromRGB(111,43,156), accentBg=Color3.fromRGB(38,7,52), accentHover=Color3.fromRGB(76,17,96), accentRowHover=Color3.fromRGB(27,5,37), bg=Color3.fromRGB(0,0,0), bgDark=Color3.fromRGB(0,0,0), row=Color3.fromRGB(7,4,9), input=Color3.fromRGB(12,7,15), divider=Color3.fromRGB(77,45,91)},
    CRIMSON = {accent=Color3.fromRGB(224,66,98), accentDark=Color3.fromRGB(112,24,45), accentBg=Color3.fromRGB(39,7,14), accentHover=Color3.fromRGB(73,14,28), accentRowHover=Color3.fromRGB(31,7,13), bg=Color3.fromRGB(7,2,3), bgDark=Color3.fromRGB(2,0,1), row=Color3.fromRGB(13,5,7), input=Color3.fromRGB(18,6,9), divider=Color3.fromRGB(62,24,31)},
    EMERALD = {accent=Color3.fromRGB(62,208,143), accentDark=Color3.fromRGB(20,101,66), accentBg=Color3.fromRGB(5,34,22), accentHover=Color3.fromRGB(10,63,41), accentRowHover=Color3.fromRGB(5,27,18), bg=Color3.fromRGB(2,7,5), bgDark=Color3.fromRGB(0,2,1), row=Color3.fromRGB(5,13,10), input=Color3.fromRGB(6,18,13), divider=Color3.fromRGB(22,58,43)},
    AMBER = {accent=Color3.fromRGB(238,164,63), accentDark=Color3.fromRGB(120,71,20), accentBg=Color3.fromRGB(39,23,5), accentHover=Color3.fromRGB(70,39,8), accentRowHover=Color3.fromRGB(30,18,5), bg=Color3.fromRGB(7,5,2), bgDark=Color3.fromRGB(2,1,0), row=Color3.fromRGB(14,10,5), input=Color3.fromRGB(19,13,6), divider=Color3.fromRGB(63,43,20)},
    ROSE = {accent=Color3.fromRGB(239,91,167), accentDark=Color3.fromRGB(120,34,78), accentBg=Color3.fromRGB(41,8,25), accentHover=Color3.fromRGB(75,15,46), accentRowHover=Color3.fromRGB(31,7,20), bg=Color3.fromRGB(7,2,5), bgDark=Color3.fromRGB(2,0,1), row=Color3.fromRGB(14,5,10), input=Color3.fromRGB(19,6,13), divider=Color3.fromRGB(66,25,47)},
    MONOCHROME = {accent=Color3.fromRGB(218,218,224), accentDark=Color3.fromRGB(91,91,99), accentBg=Color3.fromRGB(25,25,28), accentHover=Color3.fromRGB(47,47,52), accentRowHover=Color3.fromRGB(22,22,25), bg=Color3.fromRGB(5,5,6), bgDark=Color3.fromRGB(1,1,2), row=Color3.fromRGB(11,11,13), input=Color3.fromRGB(15,15,17), divider=Color3.fromRGB(48,48,54)},
}

function intensityTheme(base,intensity)
    intensity=math.clamp(tonumber(intensity) or 1,.35,1.5)
    function scaled(color,mult)
        return Color3.new(math.clamp(color.R*mult,0,1),math.clamp(color.G*mult,0,1),math.clamp(color.B*mult,0,1))
    end
    return {
        accent=scaled(base.accent,.55+.45*intensity),
        accentDark=scaled(base.accentDark,.62+.38*intensity),
        accentBg=scaled(base.accentBg,.64+.36*intensity),
        accentHover=scaled(base.accentHover,.58+.42*intensity),
        accentRowHover=scaled(base.accentRowHover,.66+.34*intensity),
        bg=base.bg or Color3.fromRGB(4,4,4), bgDark=base.bgDark or Color3.fromRGB(1,1,1),
        row=base.row or Color3.fromRGB(8,8,8), input=base.input or Color3.fromRGB(10,10,10),
        divider=base.divider or Color3.fromRGB(33,33,33),
    }
end



local _GACC = {}
_GACC.playerHighlightEnabled=false
do local _t0=THEME_DEFS[currentColorTheme] or THEME_DEFS.IMPULSE
    _GACC.accent=_t0.accent; _GACC.accentDark=_t0.accentDark
    _GACC.accentBg=_t0.accentBg; _GACC.accentHover=_t0.accentHover
    _GACC.accentRowHover=_t0.accentRowHover
end

local _themeExtRefs = {}
local _themeStealPills = {}

function _gAccentGrad(t)
    local a=_GACC.accent; local d=_GACC.accentDark
    local pulse=math.sin(t*0.7)*0.14
    local aR=math.clamp(math.floor(a.R*255*(1+pulse)),0,255)
    local aG=math.clamp(math.floor(a.G*255*(1+pulse)),0,255)
    local aB=math.clamp(math.floor(a.B*255*(1+pulse)),0,255)
    local dR=math.clamp(math.floor(d.R*255*(0.75+pulse*0.25)),0,255)
    local dG=math.clamp(math.floor(d.G*255*(0.75+pulse*0.25)),0,255)
    local dB=math.clamp(math.floor(d.B*255*(0.75+pulse*0.25)),0,255)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(dR,dG,dB)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(aR,aG,aB)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.82,Color3.fromRGB(aR,aG,aB)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(dR,dG,dB))
    })
end

do
    local d2=ConfigShare.startupConfig
    if type(d2.animEnabled)=="boolean" then animEnabled=d2.animEnabled end
    if type(d2.colorThemeName)=="string" and THEME_DEFS[d2.colorThemeName] then currentColorTheme=d2.colorThemeName end
    if type(d2.themeIntensity)=="number" then themeIntensity=math.clamp(d2.themeIntensity,.35,1.5) end
end
do
    local loadedTheme=intensityTheme(THEME_DEFS[currentColorTheme] or THEME_DEFS.IMPULSE,themeIntensity)
    _GACC.accent=loadedTheme.accent; _GACC.accentDark=loadedTheme.accentDark
    _GACC.accentBg=loadedTheme.accentBg; _GACC.accentHover=loadedTheme.accentHover
    _GACC.accentRowHover=loadedTheme.accentRowHover
end


local introSoundInstance = nil
	if false and introSoundEnabled then
    task.spawn(function()
        
        local urlIntro = "https://files.catbox.moe/66xaq4.mp3"
        local numeFisier = "impulseduels_intro.mp3"
        if not (isfile and isfile(numeFisier)) then
            local ok, data = pcall(function() return game:HttpGet(urlIntro) end)
            if ok and data then pcall(function() writefile(numeFisier, data) end) end
        end
        introSoundInstance = Instance.new("Sound")
        pcall(function()
            introSoundInstance.SoundId = getcustomasset(numeFisier)
            introSoundInstance.Volume = 3
            introSoundInstance.Looped = false
            introSoundInstance.Parent = game:GetService("CoreGui")
            introSoundInstance:Play()
        end)
    end)
end

if false then
    task.spawn(function()
        
        task.wait(1.7)

        
        local shaking = true
        local shakeConn = RunService.RenderStepped:Connect(function()
            if not shaking then return end
            local cam = workspace.CurrentCamera
            if cam then
                local ox = (math.random() * 2 - 1) * 1.8
                local oy = (math.random() * 2 - 1) * 1.8
                cam.CFrame = cam.CFrame * CFrame.new(ox, oy, 0)
            end
        end)
        task.wait(1.6)

        
        shaking = false
        shakeConn:Disconnect()

        
        local introGui = Instance.new("ScreenGui")
        introGui.Name = "ImpulseDuelsIntroTitle"
        introGui.ResetOnSpawn = false
        introGui.IgnoreGuiInset = true
        introGui.DisplayOrder = 9999
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(introGui) end end)
        parentGui(introGui)

        local pokerLbl = Instance.new("TextLabel")
        pokerLbl.Size = UDim2.new(0.8, 0, 0, 130)
        pokerLbl.AnchorPoint = Vector2.new(0.5, 0.5)
        pokerLbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        pokerLbl.BackgroundTransparency = 1
        pokerLbl.RichText = true
        pokerLbl.Text = 'N5 Duels'
        pokerLbl.TextColor3 = Color3.fromRGB(255,255,255)
        pokerLbl.TextScaled = true
        pokerLbl.Font = Enum.Font.FredokaOne
        pokerLbl.TextTransparency = 1
        pokerLbl.TextStrokeTransparency = 1
        pokerLbl.ZIndex = 10
        pokerLbl.Parent = introGui
        local introGradient=Instance.new("UIGradient",pokerLbl)
        introGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,_GACC.accentDark),ColorSequenceKeypoint.new(.35,_GACC.accent),ColorSequenceKeypoint.new(.62,_GACC.accent:Lerp(Color3.fromRGB(250,250,252),.82)),ColorSequenceKeypoint.new(1,_GACC.accent)})
        introGradient.Rotation=8

        
        for i = 1, 25 do
            pokerLbl.TextTransparency = 1 - (i / 25)
            pokerLbl.TextStrokeTransparency = 1 - (i / 25)
            task.wait(0.016)
        end
        pokerLbl.TextTransparency = 0
        pokerLbl.TextStrokeTransparency = 0

        
        task.wait(2.5)

        
        for i = 1, 30 do
            local a = i / 30
            pokerLbl.TextTransparency = a
            pokerLbl.TextStrokeTransparency = a
            task.wait(0.03)
        end

        pokerLbl.TextTransparency = 1
        task.wait(0.05)
        pcall(function() introGui:Destroy() end)
        pcall(function() introGui.Parent = nil end)
    end)
end

-- Anti-Sammy cinematic intro (integrated, isolated to avoid top-level register pressure).
if introEnabled then
task.spawn(function()
    local TS=game:GetService("TweenService")
    local RS=game:GetService("RunService")
    local Lighting=game:GetService("Lighting")
    local SoundService=game:GetService("SoundService")
    local BASE_URL="https://tr.rbxcdn.com/180DAY-1ffe6a28ae92ab050b5682f5c64fe1d0/420/420/Image/Png/noFilter"
    local FLASH_URL="https://tr.rbxcdn.com/180DAY-0a0b91ee8ccdd45aada7898fae70b4b8/420/420/Image/Png/noFilter"
    local AUDIO_URL="https://files.catbox.moe/dpuuw9.mp3"
    local END_TIME=13.30

    local function asset(url,fileName)
        if not (isfile and isfile(fileName)) then
            local ok,body=pcall(function() return game:HttpGet(url) end)
            if not ok or type(body)~="string" or #body==0 then return nil end
            pcall(function() writefile(fileName,body) end)
        end
        local ok,value=pcall(function() return getcustomasset(fileName) end)
        return ok and value or nil
    end
    local baseAsset=asset(BASE_URL,"anti_sammy_base.png")
    local flashAsset=asset(FLASH_URL,"anti_sammy_flash.png")
    local audioAsset=asset(AUDIO_URL,"anti_sammy_intro.mp3")
    if not baseAsset or not flashAsset or not audioAsset then return end

    local host
    pcall(function() if gethui then host=gethui() end end)
    host=host or game:GetService("CoreGui")
    local old=host:FindFirstChild("AntiSammyIntro");if old then old:Destroy() end
    local oldBlur=Lighting:FindFirstChild("AntiSammyIntroBlur");if oldBlur then oldBlur:Destroy() end

    local function tw(object,duration,goal,style,direction)
        local value=TS:Create(object,TweenInfo.new(duration,style or Enum.EasingStyle.Quint,direction or Enum.EasingDirection.Out),goal)
        value:Play();return value
    end
    local function round(parent,radius)
        local value=Instance.new("UICorner",parent);value.CornerRadius=UDim.new(0,radius);return value
    end

    local blur=Instance.new("BlurEffect",Lighting);blur.Name="AntiSammyIntroBlur";blur.Size=0
    local gui=Instance.new("ScreenGui",host)
    gui.Name="AntiSammyIntro";gui.IgnoreGuiInset=true;gui.ResetOnSpawn=false;gui.DisplayOrder=999999;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    local bg=Instance.new("Frame",gui)
    bg.Size=UDim2.fromScale(1,1);bg.BackgroundColor3=Color3.fromRGB(5,5,7);bg.BackgroundTransparency=1;bg.BorderSizePixel=0
    local bgGrad=Instance.new("UIGradient",bg);bgGrad.Rotation=110
    bgGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(2,2,4)),ColorSequenceKeypoint.new(.58,Color3.fromRGB(8,7,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(25,4,8))})

    local content=Instance.new("CanvasGroup",bg)
    content.AnchorPoint=Vector2.new(.5,.5);content.Position=UDim2.fromScale(.5,.49);content.Size=UDim2.fromOffset(460,570)
    content.BackgroundTransparency=1;content.GroupTransparency=1
    local responsive=Instance.new("UIScale",content)

    local aura=Instance.new("Frame",content)
    aura.AnchorPoint=Vector2.new(.5,.5);aura.Position=UDim2.new(.5,0,0,220);aura.Size=UDim2.fromOffset(460,460)
    aura.BackgroundColor3=Color3.fromRGB(174,20,35);aura.BackgroundTransparency=.96;aura.BorderSizePixel=0;aura.ZIndex=1;round(aura,999)
    local auraGrad=Instance.new("UIGradient",aura)
    auraGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.80),NumberSequenceKeypoint.new(.55,.93),NumberSequenceKeypoint.new(1,1)})

    local sub=Instance.new("TextLabel",content)
    sub.AnchorPoint=Vector2.new(.5,0);sub.Position=UDim2.new(.5,0,0,-4);sub.Size=UDim2.fromOffset(220,32)
    sub.BackgroundTransparency=1;sub.Font=Enum.Font.GothamBold;sub.Text="SUB 5";sub.TextColor3=Color3.fromRGB(250,250,252)
    sub.TextSize=28;sub.TextTransparency=1;sub.ZIndex=8
    local subStroke=Instance.new("UIStroke",sub);subStroke.Color=Color3.new();subStroke.Thickness=1.5;subStroke.Transparency=.20

    local art=Instance.new("Frame",content)
    art.AnchorPoint=Vector2.new(.5,0);art.Position=UDim2.new(.5,0,0,28);art.Size=UDim2.fromOffset(440,440)
    art.BackgroundTransparency=1;art.BorderSizePixel=0;art.ZIndex=2
    local base=Instance.new("ImageLabel",art)
    base.AnchorPoint=Vector2.new(.5,.5);base.Position=UDim2.fromScale(.5,.5);base.Size=UDim2.fromOffset(230,230)
    base.BackgroundTransparency=1;base.Image=baseAsset;base.ImageTransparency=1;base.ScaleType=Enum.ScaleType.Fit;base.ZIndex=3
    local baseScale=Instance.new("UIScale",base);baseScale.Scale=.94
    local flash=Instance.new("ImageLabel",art)
    flash.AnchorPoint=Vector2.new(.5,.5);flash.Position=UDim2.fromScale(.5,.5);flash.Size=UDim2.fromOffset(420,420)
    flash.BackgroundTransparency=1;flash.Image=flashAsset;flash.ImageTransparency=1;flash.ScaleType=Enum.ScaleType.Fit;flash.ZIndex=4

    local brackets=Instance.new("CanvasGroup",art)
    brackets.AnchorPoint=Vector2.new(.5,.5);brackets.Position=UDim2.fromScale(.5,.5);brackets.Size=UDim2.fromOffset(405,405)
    brackets.BackgroundTransparency=1;brackets.GroupTransparency=1;brackets.ZIndex=5
    local bracketScale=Instance.new("UIScale",brackets);bracketScale.Scale=.94
    local function bracket(position,size)
        local line=Instance.new("Frame",brackets);line.Position=position;line.Size=size;line.BackgroundColor3=Color3.fromRGB(245,54,70)
        line.BackgroundTransparency=.12;line.BorderSizePixel=0;line.ZIndex=5;round(line,2)
    end
    bracket(UDim2.fromOffset(0,0),UDim2.fromOffset(32,2));bracket(UDim2.fromOffset(0,0),UDim2.fromOffset(2,32))
    bracket(UDim2.new(1,-32,0,0),UDim2.fromOffset(32,2));bracket(UDim2.new(1,-2,0,0),UDim2.fromOffset(2,32))
    bracket(UDim2.new(0,0,1,-2),UDim2.fromOffset(32,2));bracket(UDim2.new(0,0,1,-32),UDim2.fromOffset(2,32))
    bracket(UDim2.new(1,-32,1,-2),UDim2.fromOffset(32,2));bracket(UDim2.new(1,-2,1,-32),UDim2.fromOffset(2,32))

    local identity=Instance.new("CanvasGroup",content)
    identity.AnchorPoint=Vector2.new(.5,0);identity.Position=UDim2.new(.5,0,0,477);identity.Size=UDim2.fromOffset(370,90)
    identity.BackgroundTransparency=1;identity.GroupTransparency=1;identity.ZIndex=6
    local identityScale=Instance.new("UIScale",identity);identityScale.Scale=.92
    local title=Instance.new("TextLabel",identity)
    title.Size=UDim2.new(1,0,0,42);title.BackgroundTransparency=1;title.Font=Enum.Font.GothamBold
    title.Text="ANTI | SAMMY";title.TextColor3=Color3.fromRGB(246,246,248);title.TextSize=36;title.ZIndex=6
    local titleStroke=Instance.new("UIStroke",title);titleStroke.Color=Color3.new();titleStroke.Thickness=1.5;titleStroke.Transparency=.24
    local titleGrad=Instance.new("UIGradient",title);titleGrad.Offset=Vector2.new(-1,0)
    titleGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(190,190,198)),ColorSequenceKeypoint.new(.45,Color3.new(1,1,1)),ColorSequenceKeypoint.new(.62,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.fromRGB(175,175,184))})
    local mogged=Instance.new("TextLabel",identity)
    mogged.AnchorPoint=Vector2.new(.5,0);mogged.Position=UDim2.new(.5,0,0,51);mogged.Size=UDim2.fromOffset(220,18)
    mogged.BackgroundTransparency=1;mogged.Font=Enum.Font.GothamBold;mogged.Text="MOGGED";mogged.TextColor3=Color3.fromRGB(255,61,77);mogged.TextSize=16;mogged.ZIndex=6
    local mogStroke=Instance.new("UIStroke",mogged);mogStroke.Color=Color3.new();mogStroke.Thickness=1.25;mogStroke.Transparency=.28

    local skipHint=Instance.new("TextLabel",content)
    skipHint.AnchorPoint=Vector2.new(.5,0);skipHint.Position=UDim2.new(.5,0,0,548);skipHint.Size=UDim2.fromOffset(180,20)
    skipHint.BackgroundTransparency=1;skipHint.Font=Enum.Font.GothamMedium;skipHint.Text="TAP TO SKIP"
    skipHint.TextColor3=Color3.fromRGB(205,205,212);skipHint.TextSize=10;skipHint.TextTransparency=.42;skipHint.ZIndex=9
    local skip=Instance.new("TextButton",gui)
    skip.Size=UDim2.fromScale(1,1);skip.BackgroundTransparency=1;skip.Text="";skip.AutoButtonColor=false;skip.Active=true;skip.Modal=true;skip.ZIndex=50

    local sound=Instance.new("Sound",SoundService)
    sound.Name="AntiSammyIntroSound";sound.SoundId=audioAsset;sound.Volume=0;introSoundInstance=sound
    -- Play silently when the sound toggle is off so the cinematic timeline
    -- still advances and the intro closes normally.
    sound:Play()
    local loadDeadline=os.clock()+8
    while sound.TimeLength<=0 and os.clock()<loadDeadline do task.wait(.05) end
    if sound.TimeLength<=0 then sound:Destroy();blur:Destroy();gui:Destroy();return end

    local activeFlashTween
    local function flashCut(quick,exactDuration)
        local attack=exactDuration and .020 or (quick and .020 or .065)
        local release=exactDuration and .030 or (quick and .030 or .30)
        local delay=exactDuration and math.max(attack,exactDuration-release) or (quick and .170 or .075)
        if activeFlashTween then activeFlashTween:Cancel() end
        flash.ImageTransparency=1
        tw(flash,attack,{ImageTransparency=.12},Enum.EasingStyle.Sine)
        task.delay(delay,function()
            if gui.Parent then activeFlashTween=tw(flash,release,{ImageTransparency=1}) end
        end)
    end
    local cues={{1.80},{2.80},{3.10},{3.50,true},{4.80},{5.30},{5.60,false,.50},{6.20,false,.30},{6.60,false,.20},{6.90,false,.10}}
    local cueIndex,revealed,exiting,finished=1,false,false,false
    local connection
    local function destroyIntro()
        if finished then return end;finished=true
        if connection then connection:Disconnect();connection=nil end
        if sound.Parent then sound:Destroy() end;if blur.Parent then blur:Destroy() end;if gui.Parent then gui:Destroy() end
        if introSoundInstance==sound then introSoundInstance=nil end
    end
    skip.Activated:Connect(function()
        if finished then return end;exiting=true
        if connection then connection:Disconnect();connection=nil end
        tw(sound,.16,{Volume=0},Enum.EasingStyle.Sine,Enum.EasingDirection.In);tw(content,.16,{GroupTransparency=1})
        tw(bg,.18,{BackgroundTransparency=1});tw(blur,.18,{Size=0});task.delay(.20,destroyIntro)
    end)

    if introSoundEnabled then tw(sound,.65,{Volume=2.4},Enum.EasingStyle.Sine) end
    tw(bg,.62,{BackgroundTransparency=.15});tw(blur,.72,{Size=6})
    tw(content,.55,{GroupTransparency=0});tw(sub,.48,{TextTransparency=0});tw(base,.62,{ImageTransparency=0});tw(baseScale,.72,{Scale=1})
    connection=RS.RenderStepped:Connect(function()
        local camera=workspace.CurrentCamera;local viewport=camera and camera.ViewportSize or Vector2.new(1280,720)
        responsive.Scale=math.clamp(math.min(viewport.X/590,viewport.Y/700),.62,1)
        local t=sound.TimePosition
        if not exiting and t>=.62 then bg.BackgroundTransparency=.15 end
        bgGrad.Offset=Vector2.new(math.sin(t*.18)*.08,math.cos(t*.14)*.035);bgGrad.Rotation=110+math.sin(t*.12)*3
        aura.Position=UDim2.new(.5,math.sin(t*.32)*3,0,220+math.cos(t*.28)*2)
        while cues[cueIndex] and t>=cues[cueIndex][1] do
            flashCut(cues[cueIndex][2],cues[cueIndex][3]);cueIndex=cueIndex+1
        end
        if not revealed then base.Position=UDim2.new(.5,0,.5,math.sin(t*1.15)*.8) end
        if t>=7.20 and not revealed then
            revealed=true;sub.TextTransparency=1;subStroke.Transparency=1;base.Position=UDim2.fromScale(.5,.5)
            titleGrad.Offset=Vector2.new(-1,0);identityScale.Scale=.92;bracketScale.Scale=.94
            tw(base,.42,{ImageTransparency=1});tw(flash,.58,{ImageTransparency=0});tw(brackets,.58,{GroupTransparency=0})
            tw(bracketScale,.72,{Scale=1});tw(identity,.64,{GroupTransparency=0,Position=UDim2.new(.5,0,0,465)})
            tw(identityScale,.72,{Scale=1});tw(titleGrad,.95,{Offset=Vector2.new(1,0)});tw(blur,.70,{Size=3})
        end
        if t>=12.55 and not exiting then
            exiting=true;if introSoundEnabled then tw(sound,.68,{Volume=0},Enum.EasingStyle.Sine,Enum.EasingDirection.In) end;tw(blur,.65,{Size=0})
            tw(content,.62,{GroupTransparency=1});tw(bg,.70,{BackgroundTransparency=1})
        end
        if t>=END_TIME or (not sound.IsPlaying and t>1) then destroyIntro() end
    end)
end)
end

repeat task.wait() until game:IsLoaded()


local CANDY_SKY_TAG = "MoveeSkyTheme"
local currentSkyTheme = "Night"
local CANDY_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Gray Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local SkyOrder={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Gray Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
function candyColor(rgb)
    local gray=math.clamp(math.floor((rgb[1]*.2126)+(rgb[2]*.7152)+(rgb[3]*.0722)+.5),0,255)
    return Color3.fromRGB(gray,gray,gray)
end
function CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end


local TS=TweenService
local LP=Players.LocalPlayer
local NS,CS=59,29
local LAGGER_SPEED=30
local LAGGER_CARRY_SPEED=15
local carrySpeedActive = false
local laggerModeEnabled = false

local antiRagdollEnabled,infJumpEnabled=false,false
local antiDieFlingEnabled=false
local medusaCounterEnabled,unwalkEnabled=false,false
_GACC.unwalkSetVisual=nil
local medusaDebounce,medusaLastUsed,dropActive=false,0,false
local autoLeftEnabled,autoRightEnabled=false,false
_GACC.autoPlayRemoved = false
local autoLeftSetVisual,autoRightSetVisual=nil,nil
local speedLabel=nil
local speedModeLabel=nil
local autoBatEnabled=false
local batDesyncTpEnabled=false
local batDesyncTpV3Enabled=false
local batDesyncTpSetVisual=nil
local batDesyncTpVersion="V1"
local autoSwingEnabled=false
local autoMoveSwingEnabled=false
local autoMoveSwingInterval=0.3
local _alSwingDebounce=false
local _arSwingDebounce=false
local autoBatSetVisual=nil
local resetAutoBatMotion=nil
local antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
local stretchRezEnabled,stretchRezConn,setStretchRezVisual=false,nil,nil
local unwalkSavedAnimate,_anyKeyListening=nil,false
local autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,20,nil,nil
local guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
local clickSoundsEnabled=false
local tabPosition="LEFT"
local navigationStyle="TABS"
local uiWidth=ConfigShare.mobile and ConfigShare.mobileWidth or 360
local uiPositionX,uiPositionY=20,60
local searchHistory={}
local mobileButtonsSize=56
local circleButtonsEnabled=false
local stealBarFrame
local mobBtnRefs={}
local mobGuiRef=nil
_GACC.mobileButtonPositions=_GACC.mobileButtonPositions or {}
_GACC.mobileGroupPosition=_GACC.mobileGroupPosition or {x=.86,y=.5}
if _GACC.mobileButtonsGrouped==nil then _GACC.mobileButtonsGrouped=false end
_GACC.autoPlayMode=_GACC.autoPlayMode or "FULL"
_GACC.autoStealIconAsset="rbxassetid://140558875773585"
local fovOriginalCameras=setmetatable({}, {__mode="k"})
local laggerModePillRef=nil
local carryModePillRef=nil
local autoSwitchSpeedEnabled=false
local mobBtnTransparencyEnabled=false
local perButtonDragEnabled=false
_GACC.autoCarrySpeedEnabled=false
local activeBatBillboard=nil
local activeMedusaBillboard=nil
local espEnabled=false
local espObjects={}
local espConnections={}
local ragdollGuiEnabled=true
local persistentRagdollGui=nil
local uiLocked=false
local infJumpMode="single"
local holdInfJumpConn=nil
local DROP_ASCEND_DURATION=0.2
local DROP_ASCEND_SPEED=150
local _GuiKeys = nil
local pingNotification = nil
local _perfFps,_perfPing=0,0


local bgGradientRef = nil
local innerPanelRef = nil

local RembembiAnims = {
    WalkAnim  = 73718308412641,
    RunAnim   = 135515454877967,
    JumpAnim  = 78508480717326,
    FallAnim  = 78147885297412,
    SwimIdle  = 129183123083281,
    Swim      = 110657013921774,
    ClimbAnim = 129447497744818,
    Animation1 = 92849173543269,
    Animation2 = 132238900951109,
}

local startAnimToggle, stopAnimToggle

do
    local AnimRefs = { heartbeat=nil, savedAnimate=nil, originalAnims=nil }
    local LP_anim = Players.LocalPlayer
    function isRembembiAnim(id)
        if not id then return false end
        for _,v in pairs(RembembiAnims) do if v == id then return true end end
        return false
    end
    function saveOriginalAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function g(obj) return obj and obj.AnimationId or nil end
        local ids = {
            walk=g(animate.walk and animate.walk.WalkAnim),
            run=g(animate.run and animate.run.RunAnim),
            jump=g(animate.jump and animate.jump.JumpAnim),
            fall=g(animate.fall and animate.fall.FallAnim),
            climb=g(animate.climb and animate.climb.ClimbAnim),
            swim=g(animate.swim and animate.swim.Swim),
            swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),
            idle1=g(animate.idle and animate.idle.Animation1),
            idle2=g(animate.idle and animate.idle.Animation2),
        }
        if not isRembembiAnim(ids.walk) then AnimRefs.originalAnims = ids end
    end
    function applyRembembiAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj then obj.AnimationId = "rbxassetid://" .. id end end
        s(animate.walk and animate.walk.WalkAnim, RembembiAnims.WalkAnim)
        s(animate.run and animate.run.RunAnim, RembembiAnims.RunAnim)
        s(animate.jump and animate.jump.JumpAnim, RembembiAnims.JumpAnim)
        s(animate.fall and animate.fall.FallAnim, RembembiAnims.FallAnim)
        s(animate.climb and animate.climb.ClimbAnim, RembembiAnims.ClimbAnim)
        s(animate.swim and animate.swim.Swim, RembembiAnims.Swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, RembembiAnims.SwimIdle)
        s(animate.idle and animate.idle.Animation1, RembembiAnims.Animation1)
        s(animate.idle and animate.idle.Animation2, RembembiAnims.Animation2)
    end
    function restoreOriginalAnims(char)
        local orig = AnimRefs.originalAnims
        if not orig then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj and id then obj.AnimationId = id end end
        s(animate.walk and animate.walk.WalkAnim, orig.walk)
        s(animate.run and animate.run.RunAnim, orig.run)
        s(animate.jump and animate.jump.JumpAnim, orig.jump)
        s(animate.fall and animate.fall.FallAnim, orig.fall)
        s(animate.climb and animate.climb.ClimbAnim, orig.climb)
        s(animate.swim and animate.swim.Swim, orig.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, orig.swimidle)
        s(animate.idle and animate.idle.Animation1, orig.idle1)
        s(animate.idle and animate.idle.Animation2, orig.idle2)
    end
    function startAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then saveOriginalAnims(char); applyRembembiAnims(char) end
        AnimRefs.heartbeat = RunService.Heartbeat:Connect(function()
            if not animEnabled then return end
            local c = LP_anim.Character
            if c then applyRembembiAnims(c) end
        end)
    end
    function stopAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then restoreOriginalAnims(char) end
    end
end

_GACC.extras={}
do
local ANIMATION_PACKS={
    ["Adidas Sports"]={WalkAnim=18537392113,RunAnim=18537384940,JumpAnim=18537380791,FallAnim=18537367238,SwimIdle=18537387180,Swim=18537389531,Animation1=18537376492,Animation2=18537371272,ClimbAnim=18537363391},
    ["Adidas Community"]={WalkAnim=122150855457006,RunAnim=82598234841035,JumpAnim=75290611992385,FallAnim=98600215928904,SwimIdle=109346520324160,Swim=133308483266208,Animation1=122257458498464,Animation2=102357151005774,ClimbAnim=88763136693023},
    ["Adidas Aura"]={WalkAnim=83842218823011,RunAnim=118320322718866,JumpAnim=109996626521204,FallAnim=95603166884636,SwimIdle=94922130551805,Swim=134530128383903,Animation1=110211186840347,Animation2=114191137265065,ClimbAnim=97824616490448},
    ["Wicked Popular"]={WalkAnim=92072849924640,RunAnim=72301599441680,JumpAnim=104325245285198,FallAnim=121152442762481,Animation1=118832222982049,ClimbAnim=131326830509784,SwimIdle=113199415118199,Swim=99384245425157,Animation2=76049494037641},
    Elder={WalkAnim=10921111375,RunAnim=10921104374,JumpAnim=10921107367,FallAnim=10921105765,SwimIdle=10921110146,Swim=10921108971,ClimbAnim=10921100400,Animation1=10921101664,Animation2=10921102574},
    Zombie={WalkAnim=10921355261,RunAnim=616163682,JumpAnim=10921351278,FallAnim=10921350320,SwimIdle=10921353442,Swim=10921352344,Animation1=10921344533,Animation2=10921345304,ClimbAnim=10921343576},
    Mage={WalkAnim=10921152678,RunAnim=10921148209,JumpAnim=10921149743,FallAnim=10921148939,SwimIdle=10921151661,Swim=10921150788,ClimbAnim=10921143404,Animation1=10921144709,Animation2=10921145797},
    ["Catwalk Glam"]={WalkAnim=109168724482748,RunAnim=81024476153754,JumpAnim=116936326516985,FallAnim=92294537340807,SwimIdle=98854111361360,Swim=134591743181628,ClimbAnim=119377220967554,Animation1=133806214992291,Animation2=94970088341563},
    Astronaut={WalkAnim=10921046031,RunAnim=10921039308,JumpAnim=10921042494,FallAnim=10921040576,SwimIdle=10921045006,Swim=10921044000,ClimbAnim=10921032124,Animation1=10921034824,Animation2=10921036806},
    ['Wicked "Dancing Through Life"']={WalkAnim=73718308412641,RunAnim=135515454877967,JumpAnim=78508480717326,FallAnim=78147885297412,SwimIdle=129183123083281,Swim=110657013921774,ClimbAnim=129447497744818,Animation1=92849173543269,Animation2=132238900951109},
    Werewolf={WalkAnim=10921342074,RunAnim=10921336997,JumpAnim=10921339758,FallAnim=10921337907,SwimIdle=10921341319,Swim=10921340419,ClimbAnim=10921329322,Animation1=10921330408,Animation2=10921333667},
    Superhero={WalkAnim=10921298616,RunAnim=10921291831,JumpAnim=10921294559,FallAnim=10921293373,SwimIdle=10921297391,Swim=10921295495,ClimbAnim=10921286911,Animation1=10921288909,Animation2=10921290167},
    Toy={WalkAnim=10921312010,RunAnim=10921306285,JumpAnim=10921308158,FallAnim=10921307241,SwimIdle=10921310341,Swim=10921309319,ClimbAnim=10921300839,Animation1=10921301576},
    ["No Boundaries"]={WalkAnim=18747074203,RunAnim=18747070484,JumpAnim=18747069148,FallAnim=18747062535,SwimIdle=18747071682,Swim=18747073181,ClimbAnim=18747060903,Animation1=18747067405,Animation2=18747063918},
    NFL={WalkAnim=110358958299415,RunAnim=117333533048078,JumpAnim=119846112151352,FallAnim=129773241321032,SwimIdle=79090109939093,Swim=132697394189921,ClimbAnim=134630013742019,Animation1=92080889861410,Animation2=74451233229259},
    ["Amazon Unboxed"]={WalkAnim=90478085024465,RunAnim=134824450619865,JumpAnim=121454505477205,FallAnim=94788218468396,SwimIdle=129126268464847,Swim=105962919001086,ClimbAnim=121145883950231,Animation1=98281136301627},
    Vampire={WalkAnim=10921326949,RunAnim=10921320299,JumpAnim=10921322186,FallAnim=10921321317,SwimIdle=10921325443,Swim=10921324408,ClimbAnim=10921314188,Animation1=10921315373},
    Ninja={Run=656118852,Walk=656121766,Jump=656117878,Fall=656115606,Swim=656119721,SwimIdle=656121397,Climb=656114359,Idle={656117400,656118341,886742569}},
    Robot={Run=616091570,Walk=616095330,Jump=616090535,Fall=616087089,Swim=616092998,SwimIdle=616094091,Climb=616086039,Idle={616088211,616089559,885531463}},
    Levitation={Run=616010382,Walk=616013216,Jump=616008936,Fall=616005863,Swim=616011509,SwimIdle=616012453,Climb=616003713,Idle={616006778,616008087,886862142}},
    Stylish={Run=616140816,Walk=616146177,Jump=616139451,Fall=616134815,Swim=616143378,SwimIdle=616144772,Climb=616133594,Idle={616136790,616138447,886888594}},
    Bubbly={Run=910025107,Walk=910034870,Jump=910016857,Fall=910001910,Swim=910028158,SwimIdle=910030921,Climb=909997997,Idle={910004836,910009958,1018536639}},
    Cartoon={Run=742638842,Walk=742640026,Jump=742637942,Fall=742637151,Swim=742639220,SwimIdle=742639812,Climb=742636889,Idle={742637544,742638445,885477856}},
}
local selectedAnimPack="Adidas Sports"
local animationPackActive=false
local headlessEnabled=false
local korbloxEnabled=false
local HEADLESS_MESH_ID="rbxassetid://1095708"
local KORBLOX_MESH_ID="rbxassetid://101851696"
local KORBLOX_TEXTURE_ID="rbxassetid://101851254"
local cosmeticState=setmetatable({},{__mode="k"})

function animPick(pack,...)
    for i=1,select("#",...) do local v=pack[select(i,...)]; if v~=nil then return v end end
end
function ensureAnimation(folder,name)
    if not folder then return nil end
    local obj=folder:FindFirstChild(name)
    if not obj then obj=Instance.new("Animation"); obj.Name=name; obj.Parent=folder end
    return obj
end
local animApplyGeneration=0
function applyAnimationPack(packName,char)
    local pack=ANIMATION_PACKS[packName]; if not pack then return false end
    animApplyGeneration=animApplyGeneration+1
    local requestGeneration=animApplyGeneration
    char=char or LP.Character
    if not char then return false end
    local animate,animateReady
    for _=1,40 do
        animate=char:FindFirstChild("Animate")
        if animate and animate:FindFirstChild("idle") and animate:FindFirstChild("run") and animate:FindFirstChild("walk") then animateReady=true; break end
        task.wait(.1)
    end
    if not animateReady or requestGeneration~=animApplyGeneration then return false end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local animator=hum and hum:FindFirstChildOfClass("Animator")
    local canToggle=animate:IsA("LocalScript") or animate:IsA("Script")
    if canToggle then pcall(function() animate.Disabled=true end) end
    RunService.Heartbeat:Wait()
    local tracks=animator and animator:GetPlayingAnimationTracks() or (hum and hum:GetPlayingAnimationTracks() or {})
    for _,track in ipairs(tracks) do
        if track.Priority==Enum.AnimationPriority.Core or track.Priority==Enum.AnimationPriority.Idle or track.Priority==Enum.AnimationPriority.Movement then
            pcall(function() track:Stop(.12) end)
        end
    end
    function assetId(id)
        if not id then return nil end
        local digits=tostring(id):match("%d+")
        return digits and ("rbxassetid://"..digits) or nil
    end
    function set(folder,objName,id)
        local obj=ensureAnimation(animate:FindFirstChild(folder),objName)
        local resolved=assetId(id)
        if obj and resolved and obj.AnimationId~=resolved then obj.AnimationId=resolved end
    end
    set("walk","WalkAnim",animPick(pack,"WalkAnim","Walk")); set("run","RunAnim",animPick(pack,"RunAnim","Run"))
    set("jump","JumpAnim",animPick(pack,"JumpAnim","Jump")); set("fall","FallAnim",animPick(pack,"FallAnim","Fall"))
    set("climb","ClimbAnim",animPick(pack,"ClimbAnim","Climb")); set("swim","Swim",animPick(pack,"Swim"))
    set("swimidle","SwimIdle",animPick(pack,"SwimIdle") or animPick(pack,"Swim"))
    local idle=animate:FindFirstChild("idle")
    if idle then
        local ids=pack.Idle or {animPick(pack,"Animation1"),animPick(pack,"Animation2")}
        if ids[1] or ids[2] then
            local id1=ids[1] or ids[2]; local id2=ids[2] or ids[1]
            local a1=ensureAnimation(idle,"Animation1"); local a2=ensureAnimation(idle,"Animation2")
            if a1 then a1.AnimationId=assetId(id1) end
            if a2 then a2.AnimationId=assetId(id2) end
            for _,child in ipairs(idle:GetChildren()) do
                if child:IsA("Animation") and child~=a1 and child~=a2 then child:Destroy() end
            end
            if a1 and not a1:FindFirstChild("Weight") then local weight=Instance.new("NumberValue",a1); weight.Name="Weight"; weight.Value=9 end
            if a2 and not a2:FindFirstChild("Weight") then local weight=Instance.new("NumberValue",a2); weight.Name="Weight"; weight.Value=1 end
        end
    end
    RunService.Heartbeat:Wait()
    if requestGeneration~=animApplyGeneration or not animate.Parent then return false end
    if canToggle then
        local replacement
        pcall(function() replacement=animate:Clone() end)
        if replacement then
            replacement.Name="N5AnimateReload"; replacement.Disabled=true; replacement.Parent=char
            animate:Destroy(); replacement.Name="Animate"; animate=replacement
            RunService.Heartbeat:Wait()
            if requestGeneration~=animApplyGeneration or not animate.Parent then return false end
            animate.Disabled=false
        else
            pcall(function() animate.Disabled=false end)
        end
    end
    RunService.Heartbeat:Wait()
    local applied=requestGeneration==animApplyGeneration and selectedAnimPack==packName
    if applied then animationPackActive=true end
    return applied
end

function applyHeadless(char,enabled)
    local head=char and char:FindFirstChild("Head"); if not head then return end
    local state=cosmeticState[char] or {}; cosmeticState[char]=state
    if enabled then
        if state.headTransparency==nil then state.headTransparency=head.Transparency; state.headCanCollide=head.CanCollide; local face=head:FindFirstChild("face"); state.face=face and face:Clone() or nil end
        head.Transparency=1; head.CanCollide=false
        local face=head:FindFirstChild("face"); if face then face:Destroy() end
        local old=head:FindFirstChild("ImpulseDuelsHeadlessMesh"); if old then old:Destroy() end
        local mesh=Instance.new("SpecialMesh",head); mesh.Name="ImpulseDuelsHeadlessMesh"; mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId=HEADLESS_MESH_ID; mesh.Scale=Vector3.new(.001,.001,.001)
    else
        local mesh=head:FindFirstChild("ImpulseDuelsHeadlessMesh"); if mesh then mesh:Destroy() end
        if state.headTransparency~=nil then
            head.Transparency=state.headTransparency; head.CanCollide=state.headCanCollide
            if state.face and not head:FindFirstChild("face") then state.face:Clone().Parent=head end
            state.headTransparency=nil; state.headCanCollide=nil; state.face=nil
        end
    end
end

function applyKorblox(char,enabled)
    local hum=char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local state=cosmeticState[char] or {}; cosmeticState[char]=state
    if hum.RigType==Enum.HumanoidRigType.R6 then
        local leg=char:FindFirstChild("Right Leg"); if not leg then return end
        if enabled then
            if not state.r6LegColor then state.r6LegColor=leg.Color; state.r6Meshes={}; for _,v in ipairs(leg:GetChildren()) do if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then table.insert(state.r6Meshes,v:Clone()); v:Destroy() end end end
            leg.Color=Color3.fromRGB(64,64,64); local old=leg:FindFirstChild("ImpulseDuelsKorbloxMesh"); if old then old:Destroy() end
            local mesh=Instance.new("SpecialMesh",leg); mesh.Name="ImpulseDuelsKorbloxMesh"; mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId=KORBLOX_MESH_ID; mesh.TextureId=KORBLOX_TEXTURE_ID
        else
            local mesh=leg:FindFirstChild("ImpulseDuelsKorbloxMesh"); if mesh then mesh:Destroy() end
            if state.r6LegColor then leg.Color=state.r6LegColor end
            if state.r6Meshes then for _,v in ipairs(state.r6Meshes) do v:Clone().Parent=leg end end
            state.r6LegColor=nil; state.r6Meshes=nil
        end
    else
        local upper=char:FindFirstChild("RightUpperLeg"); local lower=char:FindFirstChild("RightLowerLeg"); local foot=char:FindFirstChild("RightFoot")
        if not upper then return end
        if enabled then
            if not state.r15Transparency then state.r15Transparency={upper.Transparency,lower and lower.Transparency or 0,foot and foot.Transparency or 0} end
            upper.Transparency=1; if lower then lower.Transparency=1 end; if foot then foot.Transparency=1 end
            local old=char:FindFirstChild("ImpulseDuelsKorbloxLeg"); if old then old:Destroy() end
            local leg=Instance.new("Part",char); leg.Name="ImpulseDuelsKorbloxLeg"; leg.Size=Vector3.new(1,2,1); leg.Anchored=false; leg.CanCollide=false; leg.Massless=true; leg.Color=Color3.fromRGB(64,64,64)
            local mesh=Instance.new("SpecialMesh",leg); mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId=KORBLOX_MESH_ID; mesh.TextureId=KORBLOX_TEXTURE_ID
            local weld=Instance.new("Weld",leg); weld.Name="ImpulseDuelsKorbloxWeld"; weld.Part0=upper; weld.Part1=leg; weld.C0=CFrame.new(0,-.8,0)
        else
            local vals=state.r15Transparency
            if vals then upper.Transparency=vals[1]; if lower then lower.Transparency=vals[2] end; if foot then foot.Transparency=vals[3] end end
            local leg=char:FindFirstChild("ImpulseDuelsKorbloxLeg"); if leg then leg:Destroy() end; state.r15Transparency=nil
        end
    end
end

_GACC.extras.packs=ANIMATION_PACKS
_GACC.extras.getPack=function() return selectedAnimPack end
_GACC.extras.getPackActive=function() return animationPackActive end
_GACC.extras.setPackActive=function(on) animationPackActive=on==true end
_GACC.extras.setPack=function(name,applyNow,char)
    if ANIMATION_PACKS[name] then selectedAnimPack=name; if applyNow then return applyAnimationPack(name,char) end; return true end
    return false
end
_GACC.extras.applyPack=applyAnimationPack
_GACC.extras.getHeadless=function() return headlessEnabled end
_GACC.extras.setHeadless=function(on,char) headlessEnabled=on==true; if char then applyHeadless(char,headlessEnabled) end end
_GACC.extras.getKorblox=function() return korbloxEnabled end
_GACC.extras.setKorblox=function(on,char) korbloxEnabled=on==true; if char then applyKorblox(char,korbloxEnabled) end end
_GACC.extras.onCharacter=function(char)
    applyHeadless(char,headlessEnabled); applyKorblox(char,korbloxEnabled)
    if animationPackActive and selectedAnimPack and ANIMATION_PACKS[selectedAnimPack] then task.spawn(function() task.wait(.2); applyAnimationPack(selectedAnimPack,char) end) end
end
_GACC.extras.reset=function(char)
    selectedAnimPack="Adidas Sports"; animationPackActive=false; headlessEnabled=false; korbloxEnabled=false
    if char then applyHeadless(char,false); applyKorblox(char,false) end
end
end

local refreshSpeedModeLabel,saveConfig
local startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter
local startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
local startAntiDieFling,stopAntiDieFling
local startAutoTP,stopAutoTP,enableAntiLag,disableAntiLag,enableStretchRez,disableStretchRez
local startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor
local startBatDesyncTp,stopBatDesyncTp
local startAutoSteal,stopAutoSteal,toggleCarryMode,toggleLaggerMode


findBat=function()
    local c = LP.Character; if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _,ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _,ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end


local isNearPodiumWithPrompt

function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,  color1 or Color3.fromRGB(150,150,150)),
        ColorSequenceKeypoint.new(0.3,Color3.fromRGB(230,230,230)),
        ColorSequenceKeypoint.new(0.6,color2 or Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1,  color1 or Color3.fromRGB(150,150,150))
    })
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

local fovConn=nil
function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=nil
    if not State.FovEnabled then
        for cam, original in pairs(fovOriginalCameras) do
            if cam and cam.Parent then cam.FieldOfView=original end
        end
        return
    end
    fovConn=RunService.RenderStepped:Connect(function()
        local cam=workspace.CurrentCamera
        if cam then
            if fovOriginalCameras[cam]==nil then fovOriginalCameras[cam]=cam.FieldOfView end
            cam.FieldOfView=State.Stretch and State.StretchFov or fovValue
        end
    end)
    local cam=workspace.CurrentCamera
    if cam then
        if fovOriginalCameras[cam]==nil then fovOriginalCameras[cam]=cam.FieldOfView end
        cam.FieldOfView=State.Stretch and State.StretchFov or fovValue
    end
end
applyFOV()


function createPingNotificationLegacy()
    if pingNotification then
        pcall(function() pingNotification:Destroy() end)
        pingNotification = nil
    end
    local sg=Instance.new("ScreenGui")
    sg.Name="PingNotification"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=999
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    parentGui(sg)
    local shadow=Instance.new("Frame",sg); shadow.Size=UDim2.fromOffset(316,92); shadow.Position=UDim2.new(1,28,0,29)
    shadow.BackgroundColor3=Color3.fromRGB(0,0,0); shadow.BackgroundTransparency=.52; shadow.BorderSizePixel=0; shadow.ZIndex=8; Instance.new("UICorner",shadow).CornerRadius=UDim.new(0,16)
    local card=Instance.new("Frame",sg); card.Size=UDim2.fromOffset(316,92); card.Position=UDim2.new(1,24,0,22)
    addPhoneScale(shadow);addPhoneScale(card)
    card.BackgroundColor3=Color3.fromRGB(10,10,10); card.BackgroundTransparency=.04; card.BorderSizePixel=0; card.ZIndex=10; card.ClipsDescendants=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,16)
    local cStroke=Instance.new("UIStroke",card); cStroke.Color=_GACC.accent; cStroke.Thickness=1; cStroke.Transparency=.38
    local cardGrad=Instance.new("UIGradient",card); cardGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(19,19,19)),ColorSequenceKeypoint.new(.55,Color3.fromRGB(11,11,11)),ColorSequenceKeypoint.new(1,Color3.fromRGB(14,14,14))}); cardGrad.Rotation=12
    local rail=Instance.new("Frame",card); rail.Size=UDim2.new(0,4,1,-18); rail.Position=UDim2.fromOffset(0,9); rail.BackgroundColor3=_GACC.accent; rail.BorderSizePixel=0; rail.ZIndex=12; Instance.new("UICorner",rail).CornerRadius=UDim.new(1,0)
    local badge=Instance.new("Frame",card); badge.Size=UDim2.fromOffset(58,58); badge.Position=UDim2.fromOffset(15,17); badge.BackgroundColor3=_GACC.accent; badge.BorderSizePixel=0; badge.ZIndex=12; badge.Rotation=-7; Instance.new("UICorner",badge).CornerRadius=UDim.new(0,14)
    local badgeDepth=Instance.new("UIStroke",badge); badgeDepth.Color=_GACC.accentDark; badgeDepth.Thickness=2; badgeDepth.Transparency=.08
    local badgeGrad=Instance.new("UIGradient",badge); badgeGrad.Color=ColorSequence.new(_GACC.accent:Lerp(Color3.fromRGB(248,248,250),.58),_GACC.accentDark); badgeGrad.Rotation=45
    for _,pt in ipairs({{.24,.24},{.76,.24},{.24,.76},{.76,.76}}) do
        local pip=Instance.new("Frame",badge); pip.AnchorPoint=Vector2.new(.5,.5); pip.Position=UDim2.fromScale(pt[1],pt[2]); pip.Size=UDim2.fromOffset(7,7); pip.BackgroundColor3=Color3.fromRGB(29,29,29); pip.BorderSizePixel=0; pip.ZIndex=13; Instance.new("UICorner",pip).CornerRadius=UDim.new(1,0)
    end
    local bang=Instance.new("TextLabel",badge); bang.AnchorPoint=Vector2.new(.5,.5); bang.Position=UDim2.fromScale(.5,.5); bang.Size=UDim2.fromOffset(22,28); bang.BackgroundTransparency=1; bang.Text="!"; bang.TextColor3=Color3.fromRGB(98,98,98); bang.Font=Enum.Font.FredokaOne; bang.TextSize=25; bang.ZIndex=14
    local warnLbl=Instance.new("TextLabel",card); warnLbl.Size=UDim2.fromOffset(112,18); warnLbl.Position=UDim2.fromOffset(87,11); warnLbl.BackgroundTransparency=1; warnLbl.Text="HIGH PING"; warnLbl.TextColor3=Color3.fromRGB(241,241,241); warnLbl.Font=Enum.Font.FredokaOne; warnLbl.TextSize=13; warnLbl.TextXAlignment=Enum.TextXAlignment.Left; warnLbl.ZIndex=12
    local pingLbl=Instance.new("TextLabel",card); pingLbl.Size=UDim2.fromOffset(125,35); pingLbl.Position=UDim2.fromOffset(85,28); pingLbl.BackgroundTransparency=1; pingLbl.Text="-- ms"; pingLbl.TextColor3=_GACC.accent; pingLbl.Font=Enum.Font.FredokaOne; pingLbl.TextSize=24; pingLbl.TextXAlignment=Enum.TextXAlignment.Left; pingLbl.ZIndex=12
    local duelPill=Instance.new("Frame",card); duelPill.Size=UDim2.fromOffset(104,24); duelPill.Position=UDim2.fromOffset(85,61); duelPill.BackgroundColor3=_GACC.accentBg; duelPill.BackgroundTransparency=.12; duelPill.BorderSizePixel=0; duelPill.ZIndex=12; duelPill.Visible=false; Instance.new("UICorner",duelPill).CornerRadius=UDim.new(1,0)
    local duelStroke=Instance.new("UIStroke",duelPill); duelStroke.Color=_GACC.accent; duelStroke.Transparency=.45; duelStroke.Thickness=1
    local duelDot=Instance.new("Frame",duelPill); duelDot.AnchorPoint=Vector2.new(.5,.5); duelDot.Position=UDim2.new(0,12,.5,0); duelDot.Size=UDim2.fromOffset(6,6); duelDot.BackgroundColor3=_GACC.accent; duelDot.BorderSizePixel=0; duelDot.ZIndex=13; Instance.new("UICorner",duelDot).CornerRadius=UDim.new(1,0)
    local duelLbl=Instance.new("TextLabel",duelPill); duelLbl.Size=UDim2.new(1,-24,1,0); duelLbl.Position=UDim2.fromOffset(22,0); duelLbl.BackgroundTransparency=1; duelLbl.Text=""; duelLbl.TextColor3=Color3.fromRGB(212,212,212); duelLbl.Font=Enum.Font.FredokaOne; duelLbl.TextSize=9; duelLbl.TextXAlignment=Enum.TextXAlignment.Left; duelLbl.ZIndex=13
    local meter=Instance.new("Frame",card); meter.Size=UDim2.fromOffset(72,38); meter.Position=UDim2.fromOffset(213,34); meter.BackgroundTransparency=1; meter.ZIndex=12
    local bars={}
    for i=1,5 do
        local bar=Instance.new("Frame",meter); bar.AnchorPoint=Vector2.new(0,1); bar.Position=UDim2.fromOffset((i-1)*14,38); bar.Size=UDim2.fromOffset(8,8+i*5); bar.BackgroundColor3=Color3.fromRGB(135,135,135); bar.BackgroundTransparency=.72; bar.BorderSizePixel=0; bar.ZIndex=13; Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0); bars[i]=bar
    end
    local closeBtn=Instance.new("TextButton",card); closeBtn.Size=UDim2.fromOffset(22,22); closeBtn.Position=UDim2.new(1,-28,0,7); closeBtn.BackgroundColor3=Color3.fromRGB(27,27,27); closeBtn.BorderSizePixel=0; closeBtn.ZIndex=15; Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(1,0); closeBtn.Text="X"; closeBtn.TextColor3=Color3.fromRGB(161,161,161); closeBtn.Font=Enum.Font.FredokaOne; closeBtn.TextSize=13
    closeBtn.MouseButton1Click:Connect(function()
        if pingNotification then pcall(function() pingNotification:Destroy() end); pingNotification=nil end
    end)
    TweenService:Create(card,TweenInfo.new(.58,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(1,-336,0,22)}):Play()
    TweenService:Create(shadow,TweenInfo.new(.58,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(1,-332,0,29)}):Play()
    TweenService:Create(badge,TweenInfo.new(.72,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Rotation=0}):Play()
    task.spawn(function()
        local t=0
        while card and card.Parent do
            t=t+0.04
            pcall(function()
                local ping=math.floor(Players.LocalPlayer:GetNetworkPing()*1000)
                pingLbl.Text=tostring(ping).." ms"
                local severity=math.clamp((ping-80)/120,0,1)
                local hot=Color3.fromRGB(math.floor(158+35*severity),math.floor(72-35*severity),255); pingLbl.TextColor3=hot; rail.BackgroundColor3=hot; badgeDepth.Color=hot
                local active=math.clamp(math.ceil(ping/45),1,5)
                for i,bar in ipairs(bars) do bar.BackgroundColor3=hot; bar.BackgroundTransparency=i<=active and .08 or .76 end
            end)
            local pulse=math.abs(math.sin(t*3.2)); cStroke.Transparency=.3+pulse*.32; duelDot.BackgroundTransparency=.05+pulse*.45; badge.Rotation=math.sin(t*2.4)*2
            task.wait(0.08)
        end
    end)
    task.delay(7,function()
        if card and card.Parent then
            TweenService:Create(card,TweenInfo.new(.38,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(1,24,0,22)}):Play()
            TweenService:Create(shadow,TweenInfo.new(.38,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(1,28,0,29),BackgroundTransparency=1}):Play()
            task.delay(0.4,function()
                if sg then pcall(function() sg:Destroy() end) end
                pingNotification=nil
            end)
        end
    end)
    pingNotification=sg
    return sg
end

function createPingNotification()
    if pingNotification then pcall(function() pingNotification:Destroy() end);pingNotification=nil end
    local sg=Instance.new("ScreenGui");sg.Name="PingNotification";sg.ResetOnSpawn=false;sg.IgnoreGuiInset=true;sg.DisplayOrder=999
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    parentGui(sg)
    local shadow=Instance.new("Frame",sg);shadow.Size=UDim2.fromOffset(226,56);shadow.Position=UDim2.new(1,18,0,20);shadow.BackgroundColor3=Color3.fromRGB(80,0,14);shadow.BackgroundTransparency=.72;shadow.BorderSizePixel=0;shadow.ZIndex=8;Instance.new("UICorner",shadow).CornerRadius=UDim.new(0,13);addPhoneScale(shadow)
    local card=Instance.new("Frame",sg);card.Size=UDim2.fromOffset(226,56);card.Position=UDim2.new(1,14,0,14);card.BackgroundColor3=Color3.fromRGB(24,2,7);card.BackgroundTransparency=.08;card.BorderSizePixel=0;card.ZIndex=10;card.ClipsDescendants=true;Instance.new("UICorner",card).CornerRadius=UDim.new(0,13);addPhoneScale(card)
    local cardGradient=Instance.new("UIGradient",card);cardGradient.Rotation=10;cardGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(60,4,14)),ColorSequenceKeypoint.new(.48,Color3.fromRGB(25,3,8)),ColorSequenceKeypoint.new(1,Color3.fromRGB(8,3,6))})
    local stroke=Instance.new("UIStroke",card);stroke.Color=Color3.fromRGB(238,31,59);stroke.Thickness=1.25;stroke.Transparency=.08
    local rail=Instance.new("Frame",card);rail.Size=UDim2.new(0,3,1,-14);rail.Position=UDim2.fromOffset(0,7);rail.BackgroundColor3=Color3.fromRGB(238,31,59);rail.BorderSizePixel=0;rail.ZIndex=12;Instance.new("UICorner",rail).CornerRadius=UDim.new(1,0)
    local dot=Instance.new("Frame",card);dot.Size=UDim2.fromOffset(7,7);dot.Position=UDim2.fromOffset(15,12);dot.BackgroundColor3=Color3.fromRGB(244,40,68);dot.BorderSizePixel=0;dot.ZIndex=12;Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local warn=Instance.new("TextLabel",card);warn.Size=UDim2.fromOffset(108,17);warn.Position=UDim2.fromOffset(29,6);warn.BackgroundTransparency=1;warn.Text="HIGH PING";warn.TextColor3=Color3.fromRGB(244,238,240);warn.Font=Enum.Font.GothamBold;warn.TextSize=11;warn.TextXAlignment=Enum.TextXAlignment.Left;warn.ZIndex=12
    local pingLbl=Instance.new("TextLabel",card);pingLbl.Size=UDim2.fromOffset(112,24);pingLbl.Position=UDim2.fromOffset(14,24);pingLbl.BackgroundTransparency=1;pingLbl.Text="-- ms";pingLbl.TextColor3=Color3.fromRGB(244,40,68);pingLbl.Font=Enum.Font.GothamBold;pingLbl.TextSize=18;pingLbl.TextXAlignment=Enum.TextXAlignment.Left;pingLbl.ZIndex=12
    local meter=Instance.new("Frame",card);meter.Size=UDim2.fromOffset(62,27);meter.Position=UDim2.new(1,-87,0,19);meter.BackgroundTransparency=1;meter.ZIndex=12
    local bars={}
    for i=1,4 do local bar=Instance.new("Frame",meter);bar.AnchorPoint=Vector2.new(0,1);bar.Position=UDim2.fromOffset((i-1)*14,27);bar.Size=UDim2.fromOffset(8,7+i*4);bar.BackgroundColor3=Color3.fromRGB(244,40,68);bar.BackgroundTransparency=.72;bar.BorderSizePixel=0;bar.ZIndex=13;Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0);bars[i]=bar end
    local close=Instance.new("TextButton",card);close.Size=UDim2.fromOffset(20,20);close.Position=UDim2.new(1,-24,0,5);close.BackgroundColor3=Color3.fromRGB(76,7,18);close.BackgroundTransparency=.18;close.BorderSizePixel=0;close.ZIndex=15;close.Text="X";close.TextColor3=Color3.fromRGB(236,196,202);close.Font=Enum.Font.GothamBold;close.TextSize=10;Instance.new("UICorner",close).CornerRadius=UDim.new(0,7)
    close.MouseButton1Click:Connect(function() if pingNotification then pcall(function() pingNotification:Destroy() end);pingNotification=nil end end)
    TweenService:Create(card,TweenInfo.new(.42,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.new(1,-242,0,14)}):Play()
    TweenService:Create(shadow,TweenInfo.new(.42,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.new(1,-238,0,20)}):Play()
    task.spawn(function()
        while card and card.Parent do
            pcall(function()
                local ping=math.floor(Players.LocalPlayer:GetNetworkPing()*1000)
                pingLbl.Text=tostring(ping).." ms"
                local severity=math.clamp((ping-100)/220,0,1)
                local hot=Color3.fromRGB(232+math.floor(23*severity),28-math.floor(12*severity),55-math.floor(18*severity))
                pingLbl.TextColor3=hot;rail.BackgroundColor3=hot;dot.BackgroundColor3=hot;stroke.Color=hot
                local active=math.clamp(math.ceil(ping/70),1,4)
                for i,bar in ipairs(bars) do bar.BackgroundColor3=hot;bar.BackgroundTransparency=i<=active and .06 or .72 end
                dot.BackgroundTransparency=.08+math.abs(math.sin(os.clock()*4))*.46
            end)
            task.wait(.2)
        end
    end)
    task.delay(7,function()
        if card and card.Parent then
            TweenService:Create(card,TweenInfo.new(.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(1,14,0,14)}):Play()
            TweenService:Create(shadow,TweenInfo.new(.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(1,18,0,20),BackgroundTransparency=1}):Play()
            task.delay(.34,function() if sg then pcall(function() sg:Destroy() end) end;pingNotification=nil end)
        end
    end)
    pingNotification=sg
    return sg
end


task.spawn(function()
    while true do
        task.wait(1.5)
        pcall(function()
            local ping = math.floor(Players.LocalPlayer:GetNetworkPing()*1000)
            if ping > 100 then
                if not pingNotification then
                    createPingNotification()
                end
            else
                if pingNotification then
                    pcall(function() pingNotification:Destroy() end)
                    pingNotification = nil
                end
            end
        end)
    end
end)


function createRagdollBillboard(duration,labelText,color)
    do
        if not ragdollGuiEnabled then return nil end

        local guiName="ImpulseDuelsRecovery_"..labelText
        for _,oldName in ipairs({guiName,"MoveeRagdollTimer_"..labelText}) do
            pcall(function()
                local old=game:GetService("CoreGui"):FindFirstChild(oldName)
                if old then old:Destroy() end
            end)
            pcall(function()
                local pgui=LP:FindFirstChild("PlayerGui")
                local old=pgui and pgui:FindFirstChild(oldName)
                if old then old:Destroy() end
            end)
        end

        local accent=labelText=="STONE" and Color3.fromRGB(190,34,58) or Color3.fromRGB(232,28,55)
        local sg=Instance.new("ScreenGui")
        sg.Name=guiName
        sg.ResetOnSpawn=false
        sg.IgnoreGuiInset=true
        sg.DisplayOrder=40
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
        parentGui(sg)

        local card=Instance.new("Frame",sg)
        card.Name="RecoveryTimer"
        card.AnchorPoint=Vector2.new(.5,0)
        card.Position=UDim2.new(.5,0,0,58)
        card.Size=UDim2.fromOffset(196,48)
        card.BackgroundColor3=Color3.fromRGB(28,3,8)
        card.BackgroundTransparency=.16
        card.BorderSizePixel=0
        addPhoneScale(card)
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,11)
        local cardStroke=Instance.new("UIStroke",card)
        cardStroke.Color=accent
        cardStroke.Thickness=1.2
        cardStroke.Transparency=.18

        local accentBar=Instance.new("Frame",card)
        accentBar.Position=UDim2.fromOffset(0,7);accentBar.Size=UDim2.fromOffset(3,34)
        accentBar.BackgroundColor3=accent;accentBar.BorderSizePixel=0
        Instance.new("UICorner",accentBar).CornerRadius=UDim.new(1,0)

        local icon=Instance.new("Frame",card)
        icon.Position=UDim2.fromOffset(10,8);icon.Size=UDim2.fromOffset(27,27)
        icon.BackgroundColor3=accent;icon.BackgroundTransparency=.62;icon.BorderSizePixel=0
        Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)
        local iconStroke=Instance.new("UIStroke",icon);iconStroke.Color=accent;iconStroke.Transparency=.24
        local iconText=Instance.new("TextLabel",icon)
        iconText.Size=UDim2.fromScale(1,1);iconText.BackgroundTransparency=1
        iconText.Text=labelText=="STONE" and "S" or "!";iconText.TextColor3=accent
        iconText.Font=Enum.Font.GothamBold;iconText.TextSize=labelText=="STONE" and 12 or 16

        local status=Instance.new("TextLabel",card)
        status.Position=UDim2.fromOffset(45,7)
        status.Size=UDim2.new(1,-100,0,18)
        status.BackgroundTransparency=1
        status.Text=labelText
        status.TextColor3=Color3.fromRGB(239,231,234)
        status.Font=Enum.Font.GothamBold
        status.TextSize=10
        status.TextXAlignment=Enum.TextXAlignment.Left

        local detail=Instance.new("TextLabel",card)
        detail.Position=UDim2.fromOffset(45,22);detail.Size=UDim2.new(1,-58,0,10)
        detail.BackgroundTransparency=1;detail.Text=""
        detail.TextColor3=Color3.fromRGB(200,92,108);detail.Font=Enum.Font.GothamMedium
        detail.TextSize=8;detail.TextXAlignment=Enum.TextXAlignment.Left;detail.Visible=false

        local timerLbl=Instance.new("TextLabel",card)
        timerLbl.AnchorPoint=Vector2.new(1,0)
        timerLbl.Position=UDim2.new(1,-10,0,7)
        timerLbl.Size=UDim2.fromOffset(48,18)
        timerLbl.BackgroundTransparency=1
        timerLbl.Text=string.format("%.1fs",duration)
        timerLbl.TextColor3=accent
        timerLbl.Font=Enum.Font.GothamBold
        timerLbl.TextSize=12
        timerLbl.TextXAlignment=Enum.TextXAlignment.Right

        local track=Instance.new("Frame",card)
        track.Position=UDim2.fromOffset(45,34)
        track.Size=UDim2.new(1,-56,0,5)
        track.BackgroundColor3=Color3.fromRGB(54,9,17)
        track.BackgroundTransparency=.12
        track.BorderSizePixel=0
        Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
        local fill=Instance.new("Frame",track)
        fill.Size=UDim2.fromScale(1,1)
        fill.BackgroundColor3=accent
        fill.BorderSizePixel=0
        Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

        TweenService:Create(card,TweenInfo.new(.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
            Position=UDim2.new(.5,0,0,68)
        }):Play()

        local startTime=os.clock()
        local conn
        local finishing=false
        local function closeTimer()
            if finishing then return end
            finishing=true
            if conn then conn:Disconnect();conn=nil end
            timerLbl.Text="0.0s"
            TweenService:Create(fill,TweenInfo.new(.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,0,1,0)}):Play()
            task.delay(.12,function()
                if not sg.Parent then return end
                TweenService:Create(card,TweenInfo.new(.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
                    Position=UDim2.new(.5,0,0,58)
                }):Play()
                task.delay(.24,function() if sg.Parent then sg:Destroy() end end)
            end)
        end
        conn=RunService.Heartbeat:Connect(function(dt)
            local remaining=math.max(0,duration-(os.clock()-startTime))
            if not sg.Parent then
                if conn then conn:Disconnect();conn=nil end
                return
            end
            if remaining<=0 then closeTimer();return end
            local ratio=math.clamp(remaining/duration,0,1)
            timerLbl.Text=string.format("%.1fs",remaining)
            fill.Size=fill.Size:Lerp(UDim2.new(ratio,0,1,0),math.clamp(dt*14,0,1))
        end)
        return sg
    end

    if not ragdollGuiEnabled then return nil end
    local guiName="ImpulseDuelsRecovery_"..labelText
    for _,oldName in ipairs({guiName,"MoveeRagdollTimer_"..labelText}) do
        pcall(function() local old=game:GetService("CoreGui"):FindFirstChild(oldName); if old then old:Destroy() end end)
        pcall(function() local pgui=LP:FindFirstChild("PlayerGui"); local old=pgui and pgui:FindFirstChild(oldName); if old then old:Destroy() end end)
    end
    local sg=Instance.new("ScreenGui"); sg.Name=guiName; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=40
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    parentGui(sg)
    local holder=Instance.new("Frame",sg)
    holder.Name="ImpulseDuelsRecovery"; holder.AnchorPoint=Vector2.new(.5,.5); holder.Position=UDim2.new(.5,0,.22,0)
    holder.Size=UDim2.fromOffset(286,92); holder.BackgroundTransparency=1
    addPhoneScale(holder)
    local shadow=Instance.new("Frame",holder); shadow.Size=UDim2.new(1,-8,1,-5); shadow.Position=UDim2.fromOffset(4,10)
    shadow.BackgroundColor3=Color3.fromRGB(1,1,1); shadow.BackgroundTransparency=.42; shadow.BorderSizePixel=0; Instance.new("UICorner",shadow).CornerRadius=UDim.new(0,22)
    local shadowStroke=Instance.new("UIStroke",shadow); shadowStroke.Color=Color3.fromRGB(50,50,50); shadowStroke.Thickness=5; shadowStroke.Transparency=.78
    local card=Instance.new("Frame",holder); card.Size=UDim2.new(1,0,1,0); card.BackgroundColor3=Color3.fromRGB(5,5,5); card.BackgroundTransparency=.025; card.BorderSizePixel=0; card.ZIndex=2; card.ClipsDescendants=true; Instance.new("UICorner",card).CornerRadius=UDim.new(0,20)
    local accent=_GACC.accent
    local cardStroke=Instance.new("UIStroke",card); cardStroke.Color=accent; cardStroke.Thickness=1.4; cardStroke.Transparency=.12
    local cardGrad=Instance.new("UIGradient",card); cardGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(3,3,3)),ColorSequenceKeypoint.new(.42,Color3.fromRGB(16,16,16)),ColorSequenceKeypoint.new(.72,Color3.fromRGB(10,10,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(1,1,1))}); cardGrad.Rotation=18
    local sheen=Instance.new("Frame",card); sheen.Size=UDim2.new(.46,0,1.7,0); sheen.Position=UDim2.new(-.6,0,-.35,0); sheen.Rotation=18; sheen.BackgroundColor3=Color3.fromRGB(212,212,212); sheen.BackgroundTransparency=.9; sheen.BorderSizePixel=0; sheen.ZIndex=3
    local sheenGrad=Instance.new("UIGradient",sheen); sheenGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.5,.45),NumberSequenceKeypoint.new(1,1)})
    local topLine=Instance.new("Frame",card); topLine.Position=UDim2.fromOffset(22,0); topLine.Size=UDim2.new(1,-44,0,2); topLine.BackgroundColor3=accent; topLine.BorderSizePixel=0; topLine.ZIndex=5
    local topFade=Instance.new("UIGradient",topLine); topFade.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.25,.1),NumberSequenceKeypoint.new(.7,.1),NumberSequenceKeypoint.new(1,1)})
    local statusPane=Instance.new("Frame",card); statusPane.Position=UDim2.fromOffset(10,11); statusPane.Size=UDim2.fromOffset(66,66); statusPane.BackgroundColor3=Color3.fromRGB(9,9,9); statusPane.BackgroundTransparency=.04; statusPane.BorderSizePixel=0; statusPane.ZIndex=4; Instance.new("UICorner",statusPane).CornerRadius=UDim.new(0,17)
    local paneStroke=Instance.new("UIStroke",statusPane); paneStroke.Color=accent; paneStroke.Thickness=1; paneStroke.Transparency=.3
    local pulse=Instance.new("Frame",statusPane); pulse.AnchorPoint=Vector2.new(.5,.5); pulse.Position=UDim2.fromScale(.5,.5); pulse.Size=UDim2.fromOffset(30,30); pulse.BackgroundColor3=accent; pulse.BackgroundTransparency=.16; pulse.BorderSizePixel=0; pulse.ZIndex=5; Instance.new("UICorner",pulse).CornerRadius=UDim.new(1,0)
    local pulseCore=Instance.new("Frame",pulse); pulseCore.AnchorPoint=Vector2.new(.5,.5); pulseCore.Position=UDim2.fromScale(.5,.5); pulseCore.Size=UDim2.fromOffset(12,12); pulseCore.BackgroundColor3=Color3.fromRGB(233,233,233); pulseCore.BorderSizePixel=0; pulseCore.ZIndex=6; Instance.new("UICorner",pulseCore).CornerRadius=UDim.new(1,0)
    local titleLbl=Instance.new("TextLabel",card); titleLbl.Position=UDim2.fromOffset(88,14); titleLbl.Size=UDim2.fromOffset(126,19); titleLbl.BackgroundTransparency=1; titleLbl.Text=labelText; titleLbl.TextColor3=Color3.fromRGB(238,238,238); titleLbl.Font=Enum.Font.FredokaOne; titleLbl.TextSize=12; titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.ZIndex=5
    local subLbl=Instance.new("TextLabel",card); subLbl.Position=UDim2.fromOffset(88,34); subLbl.Size=UDim2.fromOffset(126,14); subLbl.BackgroundTransparency=1; subLbl.Text=""; subLbl.Visible=false; subLbl.TextColor3=Color3.fromRGB(145,145,145); subLbl.Font=Enum.Font.FredokaOne; subLbl.TextSize=8; subLbl.TextXAlignment=Enum.TextXAlignment.Left; subLbl.ZIndex=5
    local timerPill=Instance.new("Frame",card); timerPill.AnchorPoint=Vector2.new(1,0); timerPill.Position=UDim2.new(1,-12,0,15); timerPill.Size=UDim2.fromOffset(56,28); timerPill.BackgroundColor3=_GACC.accentBg; timerPill.BackgroundTransparency=.08; timerPill.BorderSizePixel=0; timerPill.ZIndex=5; Instance.new("UICorner",timerPill).CornerRadius=UDim.new(0,9)
    local timerStroke=Instance.new("UIStroke",timerPill); timerStroke.Color=accent; timerStroke.Transparency=.45; timerStroke.Thickness=1
    local timerLbl=Instance.new("TextLabel",timerPill); timerLbl.Size=UDim2.fromScale(1,1); timerLbl.BackgroundTransparency=1; timerLbl.Text=string.format("%.1fs",duration); timerLbl.TextColor3=accent; timerLbl.Font=Enum.Font.FredokaOne; timerLbl.TextSize=16; timerLbl.ZIndex=6
    local track=Instance.new("Frame",card); track.Position=UDim2.fromOffset(88,61); track.Size=UDim2.new(1,-102,0,6); track.BackgroundColor3=Color3.fromRGB(18,18,18); track.BorderSizePixel=0; track.ZIndex=5; Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame",track); fill.Size=UDim2.fromScale(1,1); fill.BackgroundColor3=accent; fill.BorderSizePixel=0; fill.ZIndex=5; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local startTime=tick();local conn
    conn=RunService.Heartbeat:Connect(function()
        local remaining=math.max(0,duration-(tick()-startTime))
        if remaining<=0 then
            conn:Disconnect(); TweenService:Create(holder,TweenInfo.new(.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(.5,0,.19,0)}):Play()
            task.delay(.31,function() pcall(function() sg:Destroy() end) end)
        elseif timerLbl and timerLbl.Parent then
            timerLbl.Text=string.format("%.1fs",remaining); fill.Size=UDim2.new(remaining/duration,0,1,0)
            local elapsed=tick()-startTime
            local pulseSize=30+math.sin(elapsed*4)*4
            pulse.Size=UDim2.fromOffset(pulseSize,pulseSize)
            sheen.Position=UDim2.new(-.6+((elapsed*.35)%1.8),0,-.35,0)
            cardStroke.Color=_GACC.accent; paneStroke.Color=_GACC.accent; timerStroke.Color=_GACC.accent; topLine.BackgroundColor3=_GACC.accent; fill.BackgroundColor3=_GACC.accent; timerLbl.TextColor3=_GACC.accent
            if remaining<1 then cardStroke.Transparency=.02; timerLbl.TextColor3=Color3.fromRGB(245,245,245) end
        end
    end)
    return sg
end

function onHumanoidStateChanged(old,new)
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand and not activeBatBillboard then
        activeBatBillboard=createRagdollBillboard(2.6,"RAGDOLL",Color3.fromRGB(255,255,255))
        task.delay(2.98,function() if activeBatBillboard then pcall(function() activeBatBillboard:Destroy() end);activeBatBillboard=nil end end)
    end
end

function onMedusaStateChanged()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand and not activeMedusaBillboard then
        activeMedusaBillboard=createRagdollBillboard(4.5,"STONE",Color3.fromRGB(255,255,255))
        task.delay(4.88,function() if activeMedusaBillboard then pcall(function() activeMedusaBillboard:Destroy() end);activeMedusaBillboard=nil end end)
    end
end

function setupRagdollTriggers()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then hum.StateChanged:Connect(onHumanoidStateChanged);hum:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged) end
end

do
function removePlayerHighlight(targetPlayer)
    local obj=espObjects[targetPlayer]
    if obj then
        if obj.marker then pcall(function() obj.marker:Destroy() end)
        elseif obj.highlight then pcall(function() obj.highlight:Destroy() end) end
    end
    espObjects[targetPlayer]=nil
end

function attachPlayerHighlight(targetPlayer,character)
    if not espEnabled or targetPlayer==LP or not character then return end
    local root=character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart",5)
    if not root or not espEnabled or character~=targetPlayer.Character then return end
    removePlayerHighlight(targetPlayer)
    local marker=Instance.new("Part")
    marker.Name="ImpulseDuelsPlayerLocation"; marker.Size=Vector3.new(2.6,5.2,2.1); marker.CFrame=root.CFrame
    marker.Transparency=.99; marker.CanCollide=false; marker.CanTouch=false; marker.CanQuery=false
    marker.CastShadow=false; marker.Massless=true; marker.Parent=character
    local weld=Instance.new("WeldConstraint",marker); weld.Part0=root; weld.Part1=marker
    local highlight=Instance.new("Highlight")
    highlight.Name="ImpulseDuelsPlayerHighlight"
    highlight.Adornee=marker
    highlight.FillColor=Color3.fromRGB(88,0,16)
    highlight.OutlineColor=Color3.fromRGB(242,30,58)
    highlight.FillTransparency=.72
    highlight.OutlineTransparency=0
    highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent=marker
    espObjects[targetPlayer]={highlight=highlight,marker=marker}
end

function setupPlayerHighlight(targetPlayer)
    if targetPlayer==LP then return end
    if targetPlayer.Character then task.spawn(attachPlayerHighlight,targetPlayer,targetPlayer.Character) end
    table.insert(espConnections,targetPlayer.CharacterAdded:Connect(function(character)
        if espEnabled then task.spawn(attachPlayerHighlight,targetPlayer,character) end
    end))
end

_GACC.startESP=function()
    if espEnabled then return end
    _GACC.playerHighlightEnabled=true
    espEnabled=true
    for _,targetPlayer in ipairs(Players:GetPlayers()) do setupPlayerHighlight(targetPlayer) end
    table.insert(espConnections,Players.PlayerAdded:Connect(function(targetPlayer)
        if espEnabled then setupPlayerHighlight(targetPlayer) end
    end))
    table.insert(espConnections,Players.PlayerRemoving:Connect(removePlayerHighlight))
end

_GACC.stopESP=function()
    _GACC.playerHighlightEnabled=false
    espEnabled=false
    for _,connection in ipairs(espConnections) do pcall(function() connection:Disconnect() end) end
    espConnections={}
    for _,obj in pairs(espObjects) do
        if obj.marker then pcall(function() obj.marker:Destroy() end)
        elseif obj.highlight then pcall(function() obj.highlight:Destroy() end) end
    end
    espObjects={}
end
end

function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeSpeedBB") then head.MoveeSpeedBB:Destroy() end
    speedLabel=nil
    speedModeLabel=nil
    local overlayName="MoveeSpeedOverlay"
    pcall(function() local old=game:GetService("CoreGui"):FindFirstChild(overlayName);if old then old:Destroy() end end)
    pcall(function() local pg=LP:FindFirstChild("PlayerGui");local old=pg and pg:FindFirstChild(overlayName);if old then old:Destroy() end end)
    local bb=Instance.new("BillboardGui",head);bb.Name="MoveeSpeedBB";bb.Size=UDim2.fromOffset(430,62);bb.StudsOffset=Vector3.new(0,3.35,0);bb.AlwaysOnTop=true;bb.LightInfluence=0;bb.MaxDistance=180
    speedLabel=Instance.new("TextLabel",bb);speedLabel.Size=UDim2.new(.5,-8,0,37);speedLabel.Position=UDim2.fromOffset(0,0);speedLabel.BackgroundTransparency=1;speedLabel.Text="0.0 SPEED";speedLabel.TextColor3=Color3.fromRGB(255,255,255);speedLabel.Font=Enum.Font.FredokaOne;speedLabel.TextSize=26;speedLabel.TextXAlignment=Enum.TextXAlignment.Right;speedLabel.TextStrokeColor3=Color3.fromRGB(18,0,4);speedLabel.TextStrokeTransparency=.02
    local redSilverGradient=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(126,0,19)),ColorSequenceKeypoint.new(.28,Color3.fromRGB(255,39,67)),ColorSequenceKeypoint.new(.52,Color3.fromRGB(232,232,238)),ColorSequenceKeypoint.new(.76,Color3.fromRGB(255,47,72)),ColorSequenceKeypoint.new(1,Color3.fromRGB(112,0,18))})
    local bbSpeedGrad=Instance.new("UIGradient",speedLabel);bbSpeedGrad.Color=redSilverGradient
    speedModeLabel=Instance.new("TextLabel",bb);speedModeLabel.Size=UDim2.new(.5,-8,0,37);speedModeLabel.Position=UDim2.new(.5,8,0,0);speedModeLabel.BackgroundTransparency=1;speedModeLabel.Text="NORMAL SPEED";speedModeLabel.TextColor3=Color3.fromRGB(255,255,255);speedModeLabel.Font=Enum.Font.FredokaOne;speedModeLabel.TextSize=17;speedModeLabel.TextXAlignment=Enum.TextXAlignment.Left;speedModeLabel.TextStrokeColor3=Color3.fromRGB(18,0,4);speedModeLabel.TextStrokeTransparency=.04
    local modeGrad=Instance.new("UIGradient",speedModeLabel);modeGrad.Color=redSilverGradient
    local discordLabel=Instance.new("TextLabel",bb);discordLabel.Size=UDim2.new(1,0,0,22);discordLabel.Position=UDim2.fromOffset(0,36);discordLabel.BackgroundTransparency=1;discordLabel.Text="discord.gg/anti-sammy";discordLabel.TextColor3=Color3.fromRGB(194,194,194);discordLabel.Font=Enum.Font.FredokaOne;discordLabel.TextSize=15;discordLabel.TextXAlignment=Enum.TextXAlignment.Center;discordLabel.TextStrokeColor3=Color3.fromRGB(2,2,2);discordLabel.TextStrokeTransparency=.12
    local discGrad=Instance.new("UIGradient",discordLabel);discGrad.Color=redSilverGradient
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function()
        bbSpeedGrad.Color=redSilverGradient
        modeGrad.Color=redSilverGradient
        discGrad.Color=redSilverGradient
        speedModeLabel.TextColor3=Color3.fromRGB(255,255,255)
    end) end})
    task.spawn(function()
        local t=0
        while bb and bb.Parent do
            t=t+.04;local sweep=math.sin(t*.85)*.55;bbSpeedGrad.Offset=Vector2.new(sweep,0);modeGrad.Offset=Vector2.new(-sweep*.8,0);discGrad.Offset=Vector2.new(-sweep*.7,0)
            task.wait(.05)
        end
    end)
end

function getActiveMoveSpeed()
    if laggerModeEnabled then return carrySpeedActive and LAGGER_CARRY_SPEED or LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

function getAutoPathSpeed()
    if laggerModeEnabled then return carrySpeedActive and LAGGER_CARRY_SPEED or LAGGER_SPEED end
    return carrySpeedActive and CS or NS
end

do 
local _autoSwitchWasSteal=false
function updateAutoSwitchSpeed()
    if not autoSwitchSpeedEnabled then return end
    local char=LP.Character;if not char then return end
    local h=char:FindFirstChildOfClass("Humanoid");if not h then return end
    local isStealSpeed=h.WalkSpeed<25
    if isStealSpeed==_autoSwitchWasSteal then return end
    _autoSwitchWasSteal=isStealSpeed
    if isStealSpeed then carrySpeedActive = true else carrySpeedActive = false end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
end
task.spawn(function() while true do task.wait(0.1);updateAutoSwitchSpeed() end end)
end 

-- ============================================================
-- INFINITE JUMP (JUMP REQUEST)
-- ============================================================
-- ============================================================
-- INFINITE JUMP (JUMP REQUEST)
-- ============================================================
UIS.JumpRequest:Connect(function()
    if not infJumpEnabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

-- ============================================================
-- INFINITE JUMP (HOLD MODE)
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not infJumpEnabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump == true)
    if jumpHeld and root.Velocity.Y < 30 then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

function startHoldInfJump()
    -- Jump handling is now done via direct connections above
end

function stopHoldInfJump() 
    -- Jump handling is now done via direct connections above
end

task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    while task.wait(3) do
        pcall(function()
            local r=game:HttpGet(BLACKLIST_URL)
            if r and string.find(r,tostring(LP.UserId),1,true) then LP:Kick("You have been removed for cheating | CODE: BAC-1633") end
        end)
    end
end)

local KB={DropBrainrot={kb=nil,gp=nil},AutoLeft={kb=nil,gp=nil},AutoRight={kb=nil,gp=nil},AutoBat={kb=nil,gp=nil},TPFloor={kb=nil,gp=nil},GuiHide={kb=nil,gp=nil},SpeedToggle={kb=nil,gp=nil},LaggerToggle={kb=nil,gp=nil}}
local AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_L3,AP_L4=Vector3.new(-476.12,-6.59,92.24),Vector3.new(-467.23,-6.99,22.54)
local AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local AP_R3,AP_R4=Vector3.new(-476.58,-6.49,28.32),Vector3.new(-468.26,-6.99,97.54)
local Steal={AutoStealEnabled=false,StealRadius=61,StealDuration=1.3,Data={}}
local stealMode="normal" 
local normalStealVersion="86"
local NORMAL_STEAL_PERCENT={
    ["75"]=0.75,
    ["80"]=0.80,
    ["86"]=0.86,
    ["90"]=0.90,
}
local SemiSteal={State={active=false,startTime=0,duration=1.4,progress=0,inRange=false,paused=false,phase="idle",label="",lastResult="",lastResultTime=0,totalSteals=0,failedSteals=0},CONFIG={HOLD_MIN=1.3,HOLD_MAX=2.6,ENTRY_DELAY=0.3,COOLDOWN=.05,STEAL_RANGE=9,PRIME_RANGE=80,RADIUS=60,DURATION=1.4,DELAY_RADIUS=8,STOP_TIME=1.29,STOP_TIME_ENABLED=false}}
local startSemiAutoSteal,stopSemiAutoSteal
local isStealing,stealStartTime=false,nil
local normalStealProgress=0
local normalStealPaused=false
local Conns={autoSteal=nil,antiRag=nil,anchor={}}
local MEDUSA_COOLDOWN=25
local modeValLbl

function isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

do 
function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    local plot=plots:FindFirstChild(plotName);if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase");if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end

isNearPodiumWithPrompt = function()
    local char=LP.Character;local hrpL=char and char:FindFirstChild("HumanoidRootPart");if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums=plot:FindFirstChild("AnimalPodiums");if not podiums then continue end
        for _,podium in ipairs(podiums:GetChildren()) do
            local base=podium:FindFirstChild("Base");if not base then continue end
            local sp=base:FindFirstChild("Spawn");if not sp then continue end
            local d=(hrpL.Position-sp.Position).Magnitude;if d>Steal.StealRadius then continue end
            local att=sp:FindFirstChild("PromptAttachment");if not att then continue end
            for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
        end
    end
    return false,math.huge
end

function findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do
            local base=pod:FindFirstChild("Base");local sp=base and base:FindFirstChild("Spawn")
            if sp then
                local d=(sp.Position-root.Position).Magnitude
                if d<=Steal.StealRadius and dist>d then
                    local att=sp:FindFirstChild("PromptAttachment")
                    if att then for _,prompt in ipairs(att:GetChildren()) do if prompt:IsA("ProximityPrompt") and prompt.ActionText:find("Steal") then nearest,dist=prompt,d end end end
                end
            end
        end
    end
    return nearest
end

function getPromptSpawnPosition(prompt)
    if not prompt then return nil end
    local parent=prompt.Parent
    if parent and parent.Name=="PromptAttachment" then parent=parent.Parent end
    if parent and parent.Name=="Spawn" and parent:IsA("BasePart") then return parent.Position end
    return nil
end

function isStealTargetClose(spawnPosition)
    if not spawnPosition then return false end
    local character=LP.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    return root~=nil and (spawnPosition-root.Position).Magnitude<=9
end

function executeSteal(prompt)
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
    local spawnPosition=getPromptSpawnPosition(prompt)
    local duration=math.max(tonumber(Steal.StealDuration) or 1.3,.05)
    local stopRatio=NORMAL_STEAL_PERCENT[normalStealVersion] or NORMAL_STEAL_PERCENT["86"]
    local stopPoint=duration*stopRatio
    normalStealProgress=0;normalStealPaused=false
    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        local started=tick()
        while isStealing and Steal.AutoStealEnabled and prompt.Parent do
            local elapsed=tick()-started
            normalStealProgress=math.clamp(elapsed/duration,0,stopRatio); getgenv()._AS_StealProgress=normalStealProgress
            if elapsed>=stopPoint then break end
            task.wait()
        end
        normalStealProgress=stopRatio; getgenv()._AS_StealProgress=stopRatio
        normalStealPaused=true
        local closeEnough=isStealTargetClose(spawnPosition)
        local waitDeadline=tick()+2
        while isStealing and Steal.AutoStealEnabled and prompt.Parent and not closeEnough and tick()<waitDeadline do
            closeEnough=isStealTargetClose(spawnPosition)
            task.wait()
        end
        if closeEnough and isStealing and Steal.AutoStealEnabled and prompt.Parent then
            normalStealPaused=false
            local remaining=math.max(duration-stopPoint,.01)
            local finishStarted=tick()
            while isStealing and Steal.AutoStealEnabled and prompt.Parent do
                local finishAlpha=math.clamp((tick()-finishStarted)/remaining,0,1)
                normalStealProgress=stopRatio+finishAlpha*(1-stopRatio); getgenv()._AS_StealProgress=normalStealProgress
                if finishAlpha>=1 then break end
                task.wait()
            end
            if isStealing and Steal.AutoStealEnabled and prompt.Parent then
                for _,fn in ipairs(data.trigger) do task.spawn(fn) end
                if _GACC.autoCarryWatch then _GACC.autoCarryWatch(1.25) end
            end
        end
        task.wait(.06)
        data.ready=true;isStealing=false;stealStartTime=nil;normalStealProgress=0;normalStealPaused=false; getgenv()._AS_StealProgress=0
    end)
end

startAutoSteal=function()
    stealMode="normal"; getgenv()._AS_StealProgress=0
    if Conns.autoSteal then return end
    local nextScan=0
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local now=os.clock()
        if now<nextScan then return end
        nextScan=now+.15
        local p=findNearestPrompt();if p then executeSteal(p) end
    end)
end

stopAutoSteal=function()
    if stopSemiAutoSteal then stopSemiAutoSteal() end
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
    isStealing=false;stealStartTime=nil;normalStealProgress=0;normalStealPaused=false; getgenv()._AS_StealProgress=0
end
end 




do
function _unusedSemiSynchronizerLogic()
local RS = game:GetService("ReplicatedStorage")
local SEMI_CONFIG = SemiSteal.CONFIG 


local syncRemotes = nil
local plots = nil
pcall(function()
    plots = workspace:WaitForChild("Plots", 8)
    local folder = RS:WaitForChild("Packages", 8):WaitForChild("Synchronizer", 8)
    syncRemotes = {
        channelFolder = folder:WaitForChild("Channel", 8),
        routeRemote   = folder:WaitForChild("CommunicationRoute", 8),
        requestData   = folder:FindFirstChild("RequestData"),
    }
end)

local AnimalsData = nil
pcall(function()
    AnimalsData = require(RS:WaitForChild("Datas", 8):WaitForChild("Animals", 8))
end)

local plotAnimalSync = { caches = {}, connections = {} }
local allAnimalsCache = {}
local SemiPromptCache = {}
local SemiCallbackCache = {}

function splitSyncPath(path)
    if type(path)=="table" then return path end
    local out={}
    for part in string.gmatch(tostring(path),"[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

function resolveSyncPath(path, root)
    local current,parent,key=root,nil,nil
    for _,part in ipairs(splitSyncPath(path)) do
        parent=current; key=part
        current=current and current[part] or nil
    end
    return current,parent,key
end

function applyPlotSyncDiff(channelName, packet)
    local cache=plotAnimalSync.caches[channelName]
    if type(cache)~="table" then return end
    local path,action,a,b=packet[1],packet[2],packet[3],packet[4]
    local current,parent,key=resolveSyncPath(path,cache)
    if action=="Changed" then if parent then parent[key]=a end
    elseif action=="ArrayInsert" then if current then table.insert(current,b,a) end
    elseif action=="ArrayRemoved" then if current then table.remove(current,b) end
    elseif action=="DictionaryInsert" then if current then current[b]=a end
    elseif action=="DictionaryRemoved" then if current then current[b]=nil end
    end
end

function attachPlotChannel(remote)
    if not plots or not syncRemotes then return end
    if plotAnimalSync.connections[remote] then return end
    local channelName=tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if syncRemotes.requestData and plotAnimalSync.caches[channelName]==nil then
        local ok,data=pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
        plotAnimalSync.caches[channelName]=(ok and type(data)=="table") and data or {}
    elseif plotAnimalSync.caches[channelName]==nil then
        plotAnimalSync.caches[channelName]={}
    end
    plotAnimalSync.connections[remote]=remote.OnClientEvent:Connect(function(queue)
        for _,packet in ipairs(queue) do applyPlotSyncDiff(channelName,packet) end
    end)
end

function detachPlotChannel(channelName)
    for remote,conn in pairs(plotAnimalSync.connections) do
        if tostring(remote.Name)==tostring(channelName) then
            conn:Disconnect()
            plotAnimalSync.connections[remote]=nil
            plotAnimalSync.caches[tostring(channelName)]=nil
            break
        end
    end
end

pcall(function()
    if not syncRemotes then return end
    for _,child in ipairs(syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end
    syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end)
    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _,action in ipairs(actions) do
            local kind,channelName=action[1],tostring(action[2])
            if not plots:FindFirstChild(channelName) then continue end
            if kind=="ListenerAdded" then
                local r=syncRemotes.channelFolder:FindFirstChild(channelName)
                if r and r:IsA("RemoteEvent") then attachPlotChannel(r) end
            elseif kind=="ListenerRemoved" then detachPlotChannel(channelName) end
        end
    end)
end)


function getPlotOwner(plot)
    local sign=plot:FindFirstChild("PlotSign")
    local frame=sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label=frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text=="Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$",""):gsub("%s+$","")
end

function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot=plots and plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    
    return getPlotOwner(plot)==LP.DisplayName
end


function scanAllPlots()
    if not plots then return end
    local newCache={}
    for _,plot in ipairs(plots:GetChildren()) do
        local cache=plotAnimalSync.caches[plot.Name]
        if not cache then continue end
        local animalList=cache.AnimalList
        if type(animalList)~="table" then continue end
        for slot,animalData in pairs(animalList) do
            if type(animalData)=="table" then
                local animalName=animalData.Index
                local displayName=animalName
                if AnimalsData then
                    local info=AnimalsData[animalName]
                    if info then displayName=info.DisplayName or animalName end
                end
                table.insert(newCache,{
                    name=displayName, plot=plot.Name,
                    slot=tostring(slot), uid=plot.Name.."_"..tostring(slot),
                })
            end
        end
    end
    allAnimalsCache=newCache
end

task.spawn(function() while true do task.wait(5); pcall(scanAllPlots) end end)
pcall(scanAllPlots)


function getAnimalPosition(animalData)
    if not plots then return nil end
    local plot=plots:FindFirstChild(animalData.plot); if not plot then return nil end
    local podiums=plot:FindFirstChild("AnimalPodiums"); if not podiums then return nil end
    local podium=podiums:FindFirstChild(animalData.slot); if not podium then return nil end
    return podium:GetPivot().Position
end

function distToAnimal(animalData)
    local char=LP.Character; if not char then return math.huge end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return math.huge end
    local pos=getAnimalPosition(animalData); if not pos then return math.huge end
    return (hrp.Position-pos).Magnitude
end

function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached=SemiPromptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    if not plots then return nil end
    local plot=plots:FindFirstChild(animalData.plot); if not plot then return nil end
    local podiums=plot:FindFirstChild("AnimalPodiums"); if not podiums then return nil end
    local podium=podiums:FindFirstChild(animalData.slot); if not podium then return nil end
    local base=podium:FindFirstChild("Base"); if not base then return nil end
    local spawn=base:FindFirstChild("Spawn"); if not spawn then return nil end
    local attach=spawn:FindFirstChild("PromptAttachment"); if not attach then return nil end
    for _,p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then SemiPromptCache[animalData.uid]=p; return p end
    end
    return nil
end

function pickClosest()
    local char=LP.Character; if not char then return nil end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local best,bestDist=nil,math.huge
    for _,animalData in ipairs(allAnimalsCache) do
        if isMyBaseAnimal(animalData) then continue end
        local pos=getAnimalPosition(animalData); if not pos then continue end
        local dist=(hrp.Position-pos).Magnitude
        if dist>SEMI_CONFIG.PRIME_RANGE then continue end
        if dist<bestDist then bestDist=dist; best=animalData end
    end
    return best
end


function buildSemiCallbacks(prompt)
    if SemiCallbackCache[prompt] then return end
    local data={holdCallbacks={},triggerCallbacks={},ready=true}
    local ok1,conns1=pcall(getconnections,prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1)=="table" then
        for _,conn in ipairs(conns1) do if type(conn.Function)=="function" then table.insert(data.holdCallbacks,conn.Function) end end
    end
    local ok2,conns2=pcall(getconnections,prompt.Triggered)
    if ok2 and type(conns2)=="table" then
        for _,conn in ipairs(conns2) do if type(conn.Function)=="function" then table.insert(data.triggerCallbacks,conn.Function) end end
    end
    if #data.holdCallbacks>0 or #data.triggerCallbacks>0 then SemiCallbackCache[prompt]=data end
end

function executeSemiStealAsync(prompt, animalData)
    local data=SemiCallbackCache[prompt]
    if not data or not data.ready then return false end
    data.ready=false
    SemiSteal.State.active=true
    SemiSteal.State.startTime=tick()
    SemiSteal.State.inRange=false
    SemiSteal.State.phase="holding"
    SemiSteal.State.label=animalData.name or "Animal"
    isStealing=true
    task.spawn(function()
        for _,fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        task.wait(SEMI_CONFIG.HOLD_MIN)
        SemiSteal.State.phase="waitingRange"
        local alreadyInRange=distToAnimal(animalData)<=SEMI_CONFIG.STEAL_RANGE
        local fired=false
        while true do
            local elapsed=tick()-SemiSteal.State.startTime
            if elapsed>SEMI_CONFIG.HOLD_MAX then break end
            if not prompt.Parent then break end
            if distToAnimal(animalData)<=SEMI_CONFIG.STEAL_RANGE then
                SemiSteal.State.inRange=true
                if not alreadyInRange then task.wait(SEMI_CONFIG.ENTRY_DELAY) end
                for _,fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                if _GACC.autoCarryWatch then _GACC.autoCarryWatch(1.25) end
                fired=true
                break
            end
            task.wait()
        end
        if fired then
            SemiSteal.State.totalSteals=SemiSteal.State.totalSteals+1
            SemiSteal.State.lastResult="Stole "..SemiSteal.State.label
        else
            SemiSteal.State.failedSteals=SemiSteal.State.failedSteals+1
            SemiSteal.State.lastResult="Missed window: "..SemiSteal.State.label
        end
        SemiSteal.State.active=false
        SemiSteal.State.inRange=false
        SemiSteal.State.phase="idle"
        SemiSteal.State.lastResultTime=tick()
        task.wait(SEMI_CONFIG.COOLDOWN)
        isStealing=false
        data.ready=true
    end)
    return true
end

function attemptSemiSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    buildSemiCallbacks(prompt)
    if not SemiCallbackCache[prompt] then return false end
    return executeSemiStealAsync(prompt, animalData)
end


local semiConn=nil

startSemiAutoSteal=function()
    if semiConn then return end
    pcall(scanAllPlots)
    semiConn=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or stealMode~="op" or isStealing then return end
        if SemiSteal.State.active then return end
        local target=pickClosest(); if not target then return end
        local prompt=SemiPromptCache[target.uid]
        if not prompt or not prompt.Parent then prompt=findProximityPromptForAnimal(target) end
        if prompt then attemptSemiSteal(prompt,target) end
    end)
end

stopSemiAutoSteal=function()
    if semiConn then semiConn:Disconnect(); semiConn=nil end
    SemiSteal.State.active=false
    SemiSteal.State.inRange=false
    SemiSteal.State.phase="idle"
    isStealing=false
end

end
end

do
local opConnection=nil
local opPromptData={}

function opIsMyPlot(plot)
    local sign=plot and plot:FindFirstChild("PlotSign")
    local yourBase=sign and sign:FindFirstChild("YourBase")
    return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled==true
end

function opPromptPosition(prompt)
    local attachment=prompt and prompt.Parent
    local spawn=attachment and attachment.Parent
    return spawn and spawn:IsA("BasePart") and spawn.Position or nil
end

function findNearestOPPrompt()
    local character=LP.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local plotsFolder=workspace:FindFirstChild("Plots")
    if not root or not plotsFolder then return nil end
    local nearest,minDistance=nil,math.huge
    for _,plot in ipairs(plotsFolder:GetChildren()) do
        if not opIsMyPlot(plot) then
            local podiums=plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _,podium in ipairs(podiums:GetChildren()) do
                    local base=podium:FindFirstChild("Base")
                    local spawn=base and base:FindFirstChild("Spawn")
                    local attachment=spawn and spawn:FindFirstChild("PromptAttachment")
                    if spawn and attachment then
                        local distance=(spawn.Position-root.Position).Magnitude
                        if distance<=SemiSteal.CONFIG.RADIUS and distance<minDistance then
                            for _,child in ipairs(attachment:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.Enabled and child.ActionText:find("Steal") then
                                    nearest,minDistance=child,distance
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

function finishOPSteal(data,fired)
    if fired then
        SemiSteal.State.totalSteals=SemiSteal.State.totalSteals+1
        SemiSteal.State.lastResult="OP steal completed"
        if _GACC.autoCarryWatch then _GACC.autoCarryWatch(1.25) end
    else
        SemiSteal.State.failedSteals=SemiSteal.State.failedSteals+1
        SemiSteal.State.lastResult="OP steal cancelled"
    end
    SemiSteal.State.lastResultTime=tick()
    SemiSteal.State.active=false;SemiSteal.State.progress=0;SemiSteal.State.inRange=false;SemiSteal.State.paused=false;SemiSteal.State.phase="idle"
    isStealing=false;stealStartTime=nil
    data.ready=true
end

function executeOPSteal(prompt)
    if isStealing or not prompt or not prompt.Parent then return end
    if not opPromptData[prompt] then
        local data={hold={},trigger={},ready=true}
        if getconnections then
            local okHold,holdConnections=pcall(getconnections,prompt.PromptButtonHoldBegan)
            if okHold then for _,connection in ipairs(holdConnections) do if connection.Function then table.insert(data.hold,connection.Function) end end end
            local okTrigger,triggerConnections=pcall(getconnections,prompt.Triggered)
            if okTrigger then for _,connection in ipairs(triggerConnections) do if connection.Function then table.insert(data.trigger,connection.Function) end end end
        end
        opPromptData[prompt]=data
    end
    local data=opPromptData[prompt]
    if not data.ready then return end
    data.ready=false;isStealing=true;stealStartTime=tick()
    local duration=math.max(tonumber(SemiSteal.CONFIG.DURATION) or 1.4,.05)
    SemiSteal.State.active=true;SemiSteal.State.startTime=stealStartTime;SemiSteal.State.duration=duration;SemiSteal.State.progress=0;SemiSteal.State.paused=false;SemiSteal.State.phase="holding";SemiSteal.State.inRange=false
    task.spawn(function()
        for _,callback in ipairs(data.hold) do task.spawn(callback) end
        local fired=false
        local cancelled=false
        local function distanceFromPrompt()
            local position=opPromptPosition(prompt)
            local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not position or not root then return nil end
            return (root.Position-position).Magnitude
        end
        local function stillRunning()
            return isStealing and Steal.AutoStealEnabled and stealMode=="op" and prompt.Parent~=nil
        end
        if SemiSteal.CONFIG.STOP_TIME_ENABLED then
            local stopAt=math.clamp(tonumber(SemiSteal.CONFIG.STOP_TIME) or 1.29,.05,duration)
            local started=tick()
            while stillRunning() do
                local elapsed=tick()-started
                local distance=distanceFromPrompt()
                if not distance or distance>SemiSteal.CONFIG.RADIUS then cancelled=true;break end
                SemiSteal.State.inRange=true
                SemiSteal.State.progress=math.clamp(elapsed/duration,0,1); getgenv()._AS_StealProgress=SemiSteal.State.progress
                if elapsed>=stopAt then break end
                task.wait()
            end
            if not stillRunning() then cancelled=true end
            if not cancelled then
                local stopProgress=math.clamp(stopAt/duration,0,1)
                SemiSteal.State.progress=stopProgress;SemiSteal.State.paused=true;SemiSteal.State.phase="waiting"
                local delayTime=math.max(2.99-stopAt-math.max(duration-stopAt,0),.05)
                local delayStarted=tick()
                local enteredDelayRadius=false
                while stillRunning() and tick()-delayStarted<delayTime do
                    local distance=distanceFromPrompt()
                    if not distance or distance>SemiSteal.CONFIG.RADIUS then cancelled=true;break end
                    SemiSteal.State.inRange=distance<=SemiSteal.CONFIG.DELAY_RADIUS
                    if SemiSteal.State.inRange then enteredDelayRadius=true;break end
                    task.wait()
                end
                if not stillRunning() then cancelled=true end
                if enteredDelayRadius and not cancelled then
                    SemiSteal.State.paused=false;SemiSteal.State.phase="finishing"
                    local finishStarted=tick()
                    local remaining=math.max(duration-stopAt,.05)
                    while stillRunning() do
                        local finishProgress=math.clamp((tick()-finishStarted)/remaining,0,1)
                        SemiSteal.State.progress=stopProgress+finishProgress*(1-stopProgress)
                        if finishProgress>=1 then break end
                        task.wait()
                    end
                    if stillRunning() then
                        for _,callback in ipairs(data.trigger) do task.spawn(callback) end
                        fired=true;SemiSteal.State.progress=1
                    end
                end
            end
        else
            local started=tick()
            while stillRunning() do
                local elapsed=tick()-started
                local distance=distanceFromPrompt()
                if not distance or distance>SemiSteal.CONFIG.RADIUS then cancelled=true;break end
                SemiSteal.State.inRange=true;SemiSteal.State.progress=math.clamp(elapsed/duration,0,1); getgenv()._AS_StealProgress=SemiSteal.State.progress
                if elapsed>=duration then
                    for _,callback in ipairs(data.trigger) do task.spawn(callback) end
                    fired=true;SemiSteal.State.progress=1
                    break
                end
                task.wait()
            end
        end
        task.wait(.05)
        finishOPSteal(data,fired)
    end)
end

startSemiAutoSteal=function()
    if opConnection then return end
    opConnection=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or stealMode~="op" or isStealing or SemiSteal.State.active then return end
        local prompt=findNearestOPPrompt()
        if prompt then executeOPSteal(prompt) end
    end)
end

stopSemiAutoSteal=function()
    if opConnection then opConnection:Disconnect();opConnection=nil end
    for _,data in pairs(opPromptData) do data.ready=true end
    SemiSteal.State.active=false;SemiSteal.State.progress=0;SemiSteal.State.inRange=false;SemiSteal.State.paused=false;SemiSteal.State.phase="idle"
    isStealing=false;stealStartTime=nil
end
end




do
    function showRoundResultMessage(text)
        local guiName="MoveeRoundResult"
        pcall(function() local old=game:GetService("CoreGui"):FindFirstChild(guiName); if old then old:Destroy() end end)
        pcall(function() local pgui=LP:FindFirstChild("PlayerGui"); local old=pgui and pgui:FindFirstChild(guiName); if old then old:Destroy() end end)
        local sg=Instance.new("ScreenGui"); sg.Name=guiName; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=90
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
        parentGui(sg)
        local lbl=Instance.new("TextLabel",sg)
        lbl.AnchorPoint=Vector2.new(0.5,0.5); lbl.Position=UDim2.new(0.5,0,0.38,0); lbl.Size=UDim2.new(0,500,0,70)
        lbl.BackgroundTransparency=1; lbl.Text=text; lbl.Font=Enum.Font.FredokaOne; lbl.TextSize=44
        lbl.TextColor3=Color3.fromRGB(255,255,255); lbl.TextStrokeTransparency=0.15; lbl.TextTransparency=1
        local grad=Instance.new("UIGradient",lbl)
        grad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(230,230,230)),
            ColorSequenceKeypoint.new(0.35,Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.65,Color3.fromRGB(150,150,150)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(10,10,10))
        })
        task.spawn(function()
            local t=0
            while grad and grad.Parent do t=t+0.05; grad.Rotation=math.sin(t*0.6)*25; task.wait(0.04) end
        end)
        TweenService:Create(lbl,TweenInfo.new(0.25),{TextTransparency=0}):Play()
        task.delay(1.6,function()
            if lbl and lbl.Parent then
                TweenService:Create(lbl,TweenInfo.new(0.4),{TextTransparency=1,Position=UDim2.new(0.5,0,0.34,0)}):Play()
            end
        end)
        task.delay(2.2,function() pcall(function() sg:Destroy() end) end)
    end

    local lastRoundText,lastRoundTime="",0
    function handleRoundText(txt)
        if type(txt)~="string" or txt=="" then return end
        local trimmed=txt:gsub("^%s+",""):gsub("%s+$","")
        local name=trimmed:match("^@?([%w_]+)%s+[Ww][Oo][Nn]%s+[Tt][Hh][Ii][Ss]%s+[Rr][Oo][Uu][Nn][Dd]!?$")
        if not name then return end
        local now=tick()
        if trimmed==lastRoundText and (now-lastRoundTime)<3 then return end
        lastRoundText=trimmed; lastRoundTime=now
        if string.lower(name)==string.lower(LP.Name) then
            showRoundResultMessage("Good job!")
        else
            showRoundResultMessage("Lock In")
        end
    end

    function isOwnGui(inst)
        local cur=inst
        while cur do
            local n=cur.Name
            if type(n)=="string" and n:sub(1,5)=="Movee" then return true end
            cur=cur.Parent
        end
        return false
    end

    function watchInstance(inst)
        if not (inst:IsA("TextLabel") or inst:IsA("TextButton")) then return end
        if isOwnGui(inst) then return end
        handleRoundText(inst.Text)
        inst:GetPropertyChangedSignal("Text"):Connect(function() handleRoundText(inst.Text) end)
    end

    function watchGuiRoot(root)
        if not root then return end
        for _,d in ipairs(root:GetDescendants()) do pcall(watchInstance,d) end
        root.DescendantAdded:Connect(function(d) pcall(watchInstance,d) end)
    end

    task.spawn(function()
        watchGuiRoot(LP:WaitForChild("PlayerGui"))
        pcall(function() watchGuiRoot(game:GetService("CoreGui")) end)
    end)
end

-- No camera / player collision (from Impulse source): pass through other players
-- Controlled by State.NoCamCollision (saved). Default ON.
RunService.Stepped:Connect(function()
    if State and State.NoCamCollision == false then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end
end)

;(function()
local SPEED_LV_NAME="MuzanBoostLV"
local SPEED_ATTACHMENT_NAME="_ImpulseVelocityAttachment"
local LV_MAX_FORCE=2200
local LV_FREE_FORCE=500
local _lvBoost,_lvAtt=nil,nil
local _lvOwnedTick,_blockedTime=0,0

local function _lvDestroy()
    if _lvBoost and _lvBoost.Parent then pcall(function() _lvBoost:Destroy() end) end
    if _lvAtt and _lvAtt.Parent then pcall(function() _lvAtt:Destroy() end) end
    _lvBoost=nil; _lvAtt=nil
end

local function noCollideCarried()
    local char=LP.Character; if not char then return end
    for _,model in ipairs(char:GetChildren()) do
        if model:IsA("Model") then
            for _,part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end
        end
    end
    for _,name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
        local value=char:FindFirstChild(name)
        if value and value:IsA("ObjectValue") and value.Value and value.Value:IsA("Model") then
            for _,part in ipairs(value.Value:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end
        end
    end
end

local function _lvSetup(hrp)
    if _lvBoost and _lvBoost.Parent==hrp then return end
    _lvDestroy()
    local att=Instance.new("Attachment"); att.Name=SPEED_ATTACHMENT_NAME; att.Parent=hrp
    local lv=Instance.new("LinearVelocity")
    lv.Name=SPEED_LV_NAME; lv.Attachment0=att
    lv.VelocityConstraintMode=Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis=Vector3.new(1,0,0); lv.SecondaryTangentAxis=Vector3.new(0,0,1)
    lv.MaxForce=LV_MAX_FORCE; lv.PlaneVelocity=Vector2.zero
    lv.RelativeTo=Enum.ActuatorRelativeTo.World; lv.Parent=hrp
    _lvAtt=att; _lvBoost=lv
    pcall(function() hrp:SetNetworkOwner(LP) end)
end

-- Retained for the auto-path controllers; they now use the same supplied LV.
local function _speedLVSet(hrp,x,z)
    _lvSetup(hrp)
    if _lvBoost then _lvBoost.Enabled=true; _lvBoost.PlaneVelocity=Vector2.new(x,z) end
end
local function _speedLVClear(hrp)
    if _lvBoost and (not hrp or _lvBoost.Parent==hrp) then
        _lvBoost.PlaneVelocity=Vector2.zero; _lvBoost.Enabled=false
    end
end

RunService.Heartbeat:Connect(function(dt)
    local char=LP.Character; if not char then _lvDestroy(); return end
    local hum=char:FindFirstChildOfClass("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then _lvDestroy(); return end
    local speed=getActiveMoveSpeed()
    local moveDir=hum.MoveDirection
    local moving=moveDir.Magnitude>.1
    local horizontalVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z)
    local wallNormalFlat=nil
    if moving then
        local flatDir=Vector3.new(moveDir.X,0,moveDir.Z).Unit
        local rayParams=RaycastParams.new(); rayParams.FilterType=Enum.RaycastFilterType.Exclude
        local filter={char}
        for _,otherPlayer in ipairs(Players:GetPlayers()) do if otherPlayer.Character then filter[#filter+1]=otherPlayer.Character end end
        rayParams.FilterDescendantsInstances=filter
        local hit=workspace:Raycast(hrp.Position+Vector3.new(0,1,0),flatDir*2.5,rayParams)
        if hit and hit.Instance and hit.Instance.CanCollide then
            local normal=Vector3.new(hit.Normal.X,0,hit.Normal.Z)
            if normal.Magnitude>.7 then wallNormalFlat=normal.Unit end
        end
    end
    local blocked=wallNormalFlat~=nil or (moving and horizontalVelocity.Magnitude<2)
    if blocked then pcall(noCollideCarried) end
    local state=hum:GetState()
    local ragdolled=state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown
    local moverBlocked=ragdolled or dropActive or autoBatEnabled or batDesyncTpEnabled
        or _G.AceAntiDesyncAimbotOn or _G.AceNormalAimbotOn
    if not moverBlocked then
        _lvSetup(hrp)
        if _lvBoost then
            _lvBoost.Enabled=true; _lvOwnedTick=_lvOwnedTick+1
            if _lvOwnedTick%300==0 then pcall(function() hrp:SetNetworkOwner(LP) end) end
            if moving then
                local flat=Vector3.new(moveDir.X,0,moveDir.Z).Unit
                if wallNormalFlat then
                    local wanted=flat*speed
                    local along=wanted-wallNormalFlat*wanted:Dot(wallNormalFlat)
                    _lvBoost.PlaneVelocity=along.Magnitude<.5 and Vector2.zero or Vector2.new(along.X,along.Z)
                else
                    _lvBoost.PlaneVelocity=Vector2.new(flat.X*speed,flat.Z*speed)
                end
            else
                _lvBoost.PlaneVelocity=Vector2.zero
            end
            _blockedTime=blocked and (_blockedTime+(dt or .016)) or 0
            _lvBoost.MaxForce=_blockedTime>.35 and LV_FREE_FORCE or LV_MAX_FORCE
        end
    elseif _lvBoost then
        _lvBoost.PlaneVelocity=Vector2.zero; _lvBoost.Enabled=false
    end
    if speedLabel then speedLabel.Text=string.format("%.1f SPEED",horizontalVelocity.Magnitude) end
    if speedModeLabel then
        if laggerModeEnabled then speedModeLabel.Text=carrySpeedActive and "LAGGER CARRY SPEED" or "LAGGER NORMAL SPEED"
        elseif carrySpeedActive then speedModeLabel.Text="CARRY SPEED"
        else speedModeLabel.Text="NORMAL SPEED" end
    end
    if not dropActive and blocked and hrp.AssemblyLinearVelocity.Y>2 and hum.FloorMaterial~=Enum.Material.Air then
        hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z)
    end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5);setupSpeedIndicator(char);setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    _GACC.extras.onCharacter(char)
end)

if LP.Character then setupSpeedIndicator(LP.Character);setupRagdollTriggers() end

;(function()
local alConn,arConn=nil,nil;local alPhase,arPhase=1,1

function setAutoPathCarryState(useCarry)
    autoSwitchSpeedEnabled=false
    laggerModeEnabled=false
    carrySpeedActive=useCarry==true
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if _GACC.safeLaggerVisual then _GACC.safeLaggerVisual(false) end
    if _GACC.safeCarryVisual then _GACC.safeCarryVisual(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(false) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if saveConfig then saveConfig() end
end

function moveRootToPoint(hrp,hum,point,speed,arrivalRadius)
    local delta=point-hrp.Position
    local flatDelta=Vector3.new(delta.X,0,delta.Z)
    if flatDelta.Magnitude<=(arrivalRadius or 1) then
        hum:Move(Vector3.zero,false)
        _speedLVClear(hrp)
        return true
    end
    local direction=flatDelta.Unit
    hum:Move(direction,false)
    _speedLVSet(hrp,direction.X*speed,direction.Z*speed)
    return false
end

stopAutoLeft=function()
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end

stopAutoRight=function()
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end

startAutoLeft=function()
    if alConn then alConn:Disconnect() end;alPhase=1;setAutoPathCarryState(false)
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local point=alPhase==1 and AP_L1 or (alPhase==2 and AP_L2 or (alPhase==3 and AP_L3 or AP_L4))
        local speed=alPhase<=2 and NS or CS
        if moveRootToPoint(hrp,hum,point,speed,.75) then
            if alPhase==1 then alPhase=2
            elseif alPhase==2 then
                if _GACC.autoPlayMode=="SEMI" then
                    hum:Move(Vector3.zero,false);_speedLVClear(hrp);autoLeftEnabled=false
                    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
                    if autoLeftSetVisual then autoLeftSetVisual(false) end
                    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                    return
                end
                setAutoPathCarryState(true);alPhase=3
            elseif alPhase==3 then alPhase=4
            else
                hum:Move(Vector3.zero,false);_speedLVClear(hrp);autoLeftEnabled=false
                if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                return
            end
        end
        if autoMoveSwingEnabled and not _alSwingDebounce then
            _alSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _alSwingDebounce=false end)
        end
    end)
end

startAutoRight=function()
    if arConn then arConn:Disconnect() end;arPhase=1;setAutoPathCarryState(false)
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local point=arPhase==1 and AP_R1 or (arPhase==2 and AP_R2 or (arPhase==3 and AP_R3 or AP_R4))
        local speed=arPhase<=2 and NS or CS
        if moveRootToPoint(hrp,hum,point,speed,.75) then
            if arPhase==1 then arPhase=2
            elseif arPhase==2 then
                if _GACC.autoPlayMode=="SEMI" then
                    hum:Move(Vector3.zero,false);_speedLVClear(hrp);autoRightEnabled=false
                    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
                    if autoRightSetVisual then autoRightSetVisual(false) end
                    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                    return
                end
                setAutoPathCarryState(true);arPhase=3
            elseif arPhase==3 then arPhase=4
            else
                hum:Move(Vector3.zero,false);_speedLVClear(hrp);autoRightEnabled=false
                if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                return
            end
        end
        if autoMoveSwingEnabled and not _arSwingDebounce then
            _arSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _arSwingDebounce=false end)
        end
    end)
end
end)()


runDrop=function()
    if dropActive then return end
    if autoBatEnabled then
        autoBatEnabled=false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if autoBatSetVisual then autoBatSetVisual(false) end
    end
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    dropActive = true
    local t0 = tick()
    local dc
    dc = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect();dropActive = false;return end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {char}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
            if rr then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                local off = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
            dropActive = false
            return
        end
        r.Velocity = Vector3.new(r.Velocity.X, DROP_ASCEND_SPEED, r.Velocity.Z)
    end)
end

end)()

;(function()
local function doAutoTPDown(force)
    local char=LP.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end;if not(hrp.Position.Y>=autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end

startAutoTP=function()
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
    autoTPConn=task.spawn(function() while autoTPEnabled do task.wait(0.1);pcall(function() doAutoTPDown(false) end) end end)
end

stopAutoTP=function() autoTPEnabled=false;if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end end
runTPFloor=function() pcall(function() doAutoTPDown(true) end) end
end)()

;(function()
local STRETCH_NAME="Movee_Stretch"
enableStretchRez=function()
    stretchRezEnabled=true;if stretchRezConn then stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function() RunService:BindToRenderStep(STRETCH_NAME,Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end

disableStretchRez=function() stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end) end

local defLightBrightness,defLightClock,defLightAmbient
function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end

enableAntiLag=function()
    removeAccessoriesEnabled=true;antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness;defLightClock=defLightClock or Lighting.ClockTime;defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1;Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end end) end
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) if removeAccessoriesEnabled then applyAntiLagDerender(obj) end end)
end

disableAntiLag=function()
    removeAccessoriesEnabled=false;antiLagEnabled=false;if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
    pcall(function() if defLightBrightness then Lighting.Brightness=defLightBrightness end;if defLightClock then Lighting.ClockTime=defLightClock end;if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end;Lighting.ExposureCompensation=0 end)
end
end)()

;(function()
function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end;if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if medusaCounterEnabled then useMedusaCounter() end
        end
    end)
end

setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end

stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} end
end)()

do 
local BAT_TOOL_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
_GACC.BAT_TOOL_LIST=BAT_TOOL_LIST

_GACC.equipPreferredBatTool=function()
    local char=LP.Character;if not char then return nil end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    local tool=char:FindFirstChild("Bat") or (bp and bp:FindFirstChild("Bat"))
    if tool and not tool:IsA("Tool") then tool=nil end
    if not tool then
        for _,name in ipairs(BAT_TOOL_LIST) do
            tool=char:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
            if tool and tool:IsA("Tool") then break end
            tool=nil
        end
    end
    if not tool then return nil end
    if tool.Parent~=char then
        pcall(function() hum:EquipTool(tool) end)
        if tool.Parent~=char then pcall(function() tool.Parent=char end) end
    end
    return tool
end

end 


;(function()
local CONFIG = {
    FollowSpeed = 55, MaxSpeed = 59, ActivateDistance = 13, MinFollowDistance = 1,
    PredictionTime = 0.18, PredictAhead = 1.75, JumpSpeedBoost = 1.5, ActivationDelay = 0.2,
    ServerTickrate = 1/60, PingSampleSize = 10, MinPingComp = 0.03, MaxPingComp = 0.25,
    VelocityHistorySize = 8, AccelHistorySize = 4, AerialHistorySize = 6, VerticalHistorySize = 5,
    VelocitySmoothing = 0.2, AerialSmoothing = 0.15, MaxVelocityChange = 150, MaxHorizontalVel = 80,
    AccelerationWeight = 0.3, Gravity = 196.2, AirControlFactor = 0.8, AerialVelocityDecay = 0.95,
    AerialDirectionWeight = 0.6, MinAirborneTime = 0.08,
}

local State = {
    TargetPlayer = nil, LastTargetPos = nil, TargetVelocity = Vector3.zero, SmoothedVelocity = Vector3.zero,
    VelocityHistory = {}, AirborneTime = 0, LastActivationTime = 0, HighYVelocityTime = 0,
    PingHistory = {}, CurrentPing = 0.1, AccelerationHistory = {}, LastDirectionChangeTime = 0,
    PreviousDirection = nil, WasAirborne = false, AerialVelocityHistory = {}, AerialSmoothVelocity = Vector3.zero,
    LastGroundedPosition = nil, LastYVelocity = 0, PeakHeight = 0, GroundHeight = 0,
    LastJumpTime = 0, IsMultiJumping = false, VerticalVelocityHistory = {}, RealPingMs = 0,
}

task.spawn(function()
    while true do
        pcall(function()
            local ok, val = pcall(function() return LP.Ping end)
            if ok and type(val) == "number" and val > 0 then State.RealPingMs = val; return end
            local stats = game:GetService("Stats")
            local ok2, val2 = pcall(function() return stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ok2 and type(val2) == "number" then State.RealPingMs = math.floor(val2) end
        end)
        task.wait(0.5)
    end
end)

function updatePing()
    local pingSeconds = State.RealPingMs / 1000
    table.insert(State.PingHistory, pingSeconds)
    if #State.PingHistory > CONFIG.PingSampleSize then table.remove(State.PingHistory, 1) end
    local sum = 0
    for _, p in ipairs(State.PingHistory) do sum = sum + p end
    State.CurrentPing = sum / #State.PingHistory
    State.CurrentPing = math.clamp(State.CurrentPing, CONFIG.MinPingComp, CONFIG.MaxPingComp)
end

task.spawn(function() while true do task.wait(0.5);pcall(updatePing) end end)

function getNearestPlayer()
    local char = LP.Character; if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local myPos = root.Position; local nearestDist = math.huge; local nearestPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local otherRoot = p.Character:FindFirstChild("HumanoidRootPart")
            local otherHumanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
                local dist = (myPos - otherRoot.Position).Magnitude
                if dist < nearestDist then nearestDist = dist; nearestPlayer = p end
            end
        end
    end
    return nearestPlayer
end

function getAverageVelocity()
    if #State.VelocityHistory == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, vel in ipairs(State.VelocityHistory) do sum = sum + vel end
    return sum / #State.VelocityHistory
end

function getAverageAcceleration()
    if #State.AccelerationHistory == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, a in ipairs(State.AccelerationHistory) do sum = sum + a end
    return sum / #State.AccelerationHistory
end

function getAverageAerialVelocity()
    if #State.AerialVelocityHistory == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, vel in ipairs(State.AerialVelocityHistory) do sum = sum + Vector3.new(vel.X, 0, vel.Z) end
    return sum / #State.AerialVelocityHistory
end

function getAverageVerticalVelocity()
    if #State.VerticalVelocityHistory == 0 then return 0 end
    local sum = 0
    for _, y in ipairs(State.VerticalVelocityHistory) do sum = sum + y end
    return sum / #State.VerticalVelocityHistory
end

function detectMultiJump(currentYVel, wasRising)
    local t = tick()
    if State.LastYVelocity < -5 and currentYVel > 10 then
        if t - State.LastJumpTime < 0.2 then return true end
        State.LastJumpTime = t; return true
    end
    return false
end

function isFallingFromHeight(currentPos, yVel) return (currentPos.Y - State.GroundHeight > 20) and yVel < -15 end

function isAerialStrafing()
    if #State.AerialVelocityHistory < 3 then return false end
    local dc = 0
    for i = 2, #State.AerialVelocityHistory do
        local v1 = Vector3.new(State.AerialVelocityHistory[i-1].X, 0, State.AerialVelocityHistory[i-1].Z)
        local v2 = Vector3.new(State.AerialVelocityHistory[i].X, 0, State.AerialVelocityHistory[i].Z)
        if v1.Magnitude > 3 and v2.Magnitude > 3 then
            if v1.Unit:Dot(v2.Unit) < 0.7 then dc = dc + 1 end
        end
    end
    return dc >= 2
end

function detectDirectionChange(currentVel)
    local horizontal = Vector3.new(currentVel.X, 0, currentVel.Z)
    if horizontal.Magnitude < 5 then return false end
    if State.PreviousDirection then
        local dot = State.PreviousDirection:Dot(horizontal.Unit)
        if dot < 0.5 then
            local t = tick()
            if t - State.LastDirectionChangeTime < 0.12 then
                State.PreviousDirection = horizontal.Unit; State.LastDirectionChangeTime = t; return true
            end
            State.LastDirectionChangeTime = t
        end
    end
    State.PreviousDirection = horizontal.Unit
    return false
end

function isErraticMovement()
    if #State.VelocityHistory < 3 then return false end
    local changes = 0
    for i = 2, #State.VelocityHistory do
        local v1 = Vector3.new(State.VelocityHistory[i-1].X, 0, State.VelocityHistory[i-1].Z)
        local v2 = Vector3.new(State.VelocityHistory[i].X, 0, State.VelocityHistory[i].Z)
        if v1.Magnitude > 5 and v2.Magnitude > 5 then
            if v1.Unit:Dot(v2.Unit) < 0.3 then changes = changes + 1 end
        end
    end
    return changes >= 3
end

function isInfiniteJumping()
    if #State.VelocityHistory < 3 then return false end
    local yc = 0
    for i = 2, #State.VelocityHistory do
        if math.abs(State.VelocityHistory[i].Y - State.VelocityHistory[i-1].Y) > 15 then yc = yc + 1 end
    end
    return yc >= 2
end

function isJumpBoostCheat() return math.abs(State.TargetVelocity.Y) > 35 and State.HighYVelocityTime > 0.15 end
function isExtremeJumpBoost() return math.abs(State.TargetVelocity.Y) > 50 end
function isFloating() return State.AirborneTime > 0.15 and math.abs(State.TargetVelocity.Y) > 3 end

function checkAirborne(targetRoot, targetPlayer)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {targetPlayer.Character, LP.Character}
    local rayResult = workspace:Raycast(targetRoot.Position, Vector3.new(0, -100, 0), params)
    if rayResult then State.GroundHeight = rayResult.Position.Y; return false end
    return true
end

function clampVelocityChange(newVel, oldVel, maxChange)
    local delta = newVel - oldVel
    if delta.Magnitude > maxChange then return oldVel + (delta.Unit * maxChange) end
    return newVel
end

function smoothVelocity(current, target, alpha) return current:Lerp(target, alpha) end

function predictAerialPosition(currentPos, velocity, dt, isStrafing, isFastFalling, isMultiJump)
    local horizVel = Vector3.new(velocity.X, 0, velocity.Z)
    local vertVel = velocity.Y
    if isStrafing then
        local avgAerial = getAverageAerialVelocity()
        horizVel = Vector3.new(avgAerial.X, 0, avgAerial.Z) * CONFIG.AirControlFactor
    else
        horizVel = horizVel * CONFIG.AirControlFactor
    end
    horizVel = horizVel * CONFIG.AerialVelocityDecay
    local gravityEffect = CONFIG.Gravity
    if isMultiJump then gravityEffect = gravityEffect * 0.3; vertVel = vertVel * 0.9 end
    local verticalDisplacement
    if isFastFalling then
        verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * 1.2 * dt * dt) - (3.5 * dt)
    else
        verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * dt * dt)
    end
    if vertVel > 8 and not isMultiJump then verticalDisplacement = verticalDisplacement + (2.5 * dt) end
    return currentPos + horizVel * dt + Vector3.new(0, verticalDisplacement, 0)
end

function predictServerPosition(currentPos, velocity, acceleration, ping, isQuickTurn, isAerial, isStrafing, isFastFalling, isMultiJump)
    local serverDelay = ping + CONFIG.ServerTickrate
    if isQuickTurn then serverDelay = serverDelay * 1.5 end
    if isAerial then return predictAerialPosition(currentPos, velocity, serverDelay, isStrafing, isFastFalling, isMultiJump) end
    local predictedPos = currentPos + velocity * serverDelay
    if acceleration.Magnitude > 1 then predictedPos = predictedPos + (acceleration * CONFIG.AccelerationWeight) * (serverDelay * serverDelay * 0.5) end
    return predictedPos
end

function updateRotationAngular(lookDirection, rootPart)
    if not rootPart then return end
    local flatDirection = Vector3.new(lookDirection.X, 0, lookDirection.Z)
    if flatDirection.Magnitude < 0.01 then
        rootPart.AssemblyAngularVelocity = Vector3.zero
        return
    end
    local flatLook = Vector3.new(rootPart.CFrame.LookVector.X, 0, rootPart.CFrame.LookVector.Z)
    if flatLook.Magnitude < 0.01 then return end
    local currentDirection = flatLook.Unit
    local targetDirection = flatDirection.Unit
    local signedYaw = math.atan2(currentDirection:Cross(targetDirection).Y, currentDirection:Dot(targetDirection))
    rootPart.AssemblyAngularVelocity = Vector3.new(0, math.clamp(signedYaw * 28, -45, 45), 0)
end

local rootPart = nil
local humanoid = nil

function targetIsValid(targetPlayer)
    if not targetPlayer or targetPlayer == LP or targetPlayer.Parent ~= Players then return false end
    local character = targetPlayer.Character
    local targetHumanoid = character and character:FindFirstChildOfClass("Humanoid")
    local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
    return targetRoot ~= nil and targetHumanoid ~= nil and targetHumanoid.Health > 0
end

function resetTargetTracking(targetPlayer, targetRoot)
    State.TargetPlayer = targetPlayer
    State.LastTargetPos = targetRoot and targetRoot.Position or nil
    State.TargetVelocity = Vector3.zero
    State.SmoothedVelocity = Vector3.zero
    State.VelocityHistory = {}
    State.AccelerationHistory = {}
    State.AerialVelocityHistory = {}
    State.VerticalVelocityHistory = {}
    State.AerialSmoothVelocity = Vector3.zero
    State.AirborneTime = 0
    State.HighYVelocityTime = 0
    State.PreviousDirection = nil
    State.WasAirborne = false
    State.LastYVelocity = 0
    State.PeakHeight = 0
    State.IsMultiJumping = false
end

function updateTargetInfo(dt)
    if not targetIsValid(State.TargetPlayer) then
        local newTarget = getNearestPlayer()
        if targetIsValid(newTarget) then
            local newRoot = newTarget.Character:FindFirstChild("HumanoidRootPart")
            resetTargetTracking(newTarget, newRoot)
        else
            resetTargetTracking(nil, nil)
        end
    end
    if not State.TargetPlayer or not State.TargetPlayer.Character then
        State.TargetPlayer = nil; State.LastTargetPos = nil; State.TargetVelocity = Vector3.zero
        State.SmoothedVelocity = Vector3.zero; State.VelocityHistory = {}; State.AccelerationHistory = {}
        State.AerialVelocityHistory = {}; State.VerticalVelocityHistory = {}; State.AerialSmoothVelocity = Vector3.zero
        State.AirborneTime = 0; State.HighYVelocityTime = 0; State.PreviousDirection = nil
        State.WasAirborne = false; State.LastYVelocity = 0; State.PeakHeight = 0; State.IsMultiJumping = false
        return nil
    end
    local targetRoot = State.TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return nil end
    dt = math.clamp(tonumber(dt) or (1 / 60), 1 / 240, 1 / 15)
    local targetPos = targetRoot.Position
    if State.LastTargetPos then
        local deltaPos = targetPos - State.LastTargetPos
        local rawVelocity = deltaPos / dt
        rawVelocity = clampVelocityChange(rawVelocity, State.TargetVelocity, CONFIG.MaxVelocityChange)
        local horizontalVel = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
        if horizontalVel.Magnitude > CONFIG.MaxHorizontalVel then
            horizontalVel = horizontalVel.Unit * CONFIG.MaxHorizontalVel
            rawVelocity = Vector3.new(horizontalVel.X, rawVelocity.Y, horizontalVel.Z)
        end
        local currentAcceleration = (rawVelocity - State.TargetVelocity) / dt
        table.insert(State.AccelerationHistory, currentAcceleration)
        if #State.AccelerationHistory > CONFIG.AccelHistorySize then table.remove(State.AccelerationHistory, 1) end
        table.insert(State.VerticalVelocityHistory, rawVelocity.Y)
        if #State.VerticalVelocityHistory > CONFIG.VerticalHistorySize then table.remove(State.VerticalVelocityHistory, 1) end
        State.TargetVelocity = rawVelocity
        State.SmoothedVelocity = smoothVelocity(State.SmoothedVelocity, State.TargetVelocity, CONFIG.VelocitySmoothing)
        table.insert(State.VelocityHistory, State.TargetVelocity)
        if #State.VelocityHistory > CONFIG.VelocityHistorySize then table.remove(State.VelocityHistory, 1) end
    end
    State.LastTargetPos = targetPos
    if math.abs(State.TargetVelocity.Y) > 35 then State.HighYVelocityTime = State.HighYVelocityTime + dt
    else State.HighYVelocityTime = 0 end
    local isAirborne = checkAirborne(targetRoot, State.TargetPlayer)
    if isAirborne then
        State.AirborneTime = State.AirborneTime + dt
        if targetPos.Y > State.PeakHeight then State.PeakHeight = targetPos.Y end
        if State.AirborneTime >= CONFIG.MinAirborneTime then
            table.insert(State.AerialVelocityHistory, State.TargetVelocity)
            if #State.AerialVelocityHistory > CONFIG.AerialHistorySize then table.remove(State.AerialVelocityHistory, 1) end
            State.AerialSmoothVelocity = smoothVelocity(State.AerialSmoothVelocity, State.TargetVelocity, CONFIG.AerialSmoothing)
        end
        State.WasAirborne = true
    else
        State.AirborneTime = 0; State.WasAirborne = false; State.AerialVelocityHistory = {}
        State.AerialSmoothVelocity = Vector3.zero; State.LastGroundedPosition = targetPos; State.PeakHeight = 0
    end
    return targetRoot
end

function computePrediction(targetRoot, dt)
    local targetPos = targetRoot.Position; local myPos = rootPart.Position
    local isJumping = math.abs(State.TargetVelocity.Y) > 8
    local isInfJump = isInfiniteJumping()
    local isFloater = isFloating()
    local isJumpBoost = isJumpBoostCheat()
    local isExtremeBoost = isExtremeJumpBoost()
    local isErratic = isErraticMovement()
    local avgVelocity = getAverageVelocity()
    local avgAcceleration = getAverageAcceleration()
    local isQuickTurn = detectDirectionChange(State.TargetVelocity)
    local isStrafing = isAerialStrafing()
    local isTrulyAirborne = (State.AirborneTime >= CONFIG.MinAirborneTime)
    local wasRising = State.LastYVelocity > 8
    State.IsMultiJumping = detectMultiJump(State.TargetVelocity.Y, wasRising)
    local isFastFalling = isFallingFromHeight(targetPos, State.TargetVelocity.Y)
    local avgYVel = getAverageVerticalVelocity()
    State.LastYVelocity = State.TargetVelocity.Y
    local predictionVel = State.TargetVelocity
    local predictionAccel = avgAcceleration
    local useCurrentPos = false
    if isExtremeBoost then
        useCurrentPos = true
        predictionVel = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
        predictionAccel = Vector3.zero
    elseif isJumpBoost then
        local avgH = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
        predictionVel = Vector3.new(avgH.X, State.TargetVelocity.Y * 0.15, avgH.Z)
        predictionAccel = Vector3.new(avgAcceleration.X, 0, avgAcceleration.Z)
    elseif isInfJump or isFloater then
        local avgH = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
        predictionVel = Vector3.new(avgH.X, State.TargetVelocity.Y * 0.5, avgH.Z)
        predictionAccel = Vector3.new(avgAcceleration.X * 0.5, 0, avgAcceleration.Z * 0.5)
    elseif isTrulyAirborne and isStrafing then
        local avgAerial = getAverageAerialVelocity()
        predictionVel = Vector3.new(
            State.AerialSmoothVelocity.X * CONFIG.AerialDirectionWeight + avgAerial.X * (1 - CONFIG.AerialDirectionWeight),
            avgYVel,
            State.AerialSmoothVelocity.Z * CONFIG.AerialDirectionWeight + avgAerial.Z * (1 - CONFIG.AerialDirectionWeight)
        )
        predictionAccel = Vector3.new(avgAcceleration.X * 0.3, 0, avgAcceleration.Z * 0.3)
    elseif isTrulyAirborne then
        predictionVel = Vector3.new(State.AerialSmoothVelocity.X, avgYVel, State.AerialSmoothVelocity.Z)
        predictionAccel = Vector3.zero
    elseif isErratic then
        predictionVel = Vector3.new(State.SmoothedVelocity.X, State.TargetVelocity.Y, State.SmoothedVelocity.Z)
        predictionAccel = Vector3.new(avgAcceleration.X * 0.7, 0, avgAcceleration.Z * 0.7)
    end
    local serverPredictedPos
    if useCurrentPos then serverPredictedPos = targetPos
    else
        serverPredictedPos = predictServerPosition(
            targetPos, predictionVel, predictionAccel, State.CurrentPing,
            isQuickTurn, isTrulyAirborne, isStrafing, isFastFalling, State.IsMultiJumping
        )
    end
    local predTime = CONFIG.PredictionTime * 1.1
    if isErratic then predTime = predTime * 0.6
    elseif isQuickTurn then predTime = predTime * 1.2
    elseif isTrulyAirborne and isStrafing then predTime = predTime * 0.7
    elseif isTrulyAirborne and isFastFalling then predTime = predTime * 1.3
    elseif isTrulyAirborne then predTime = predTime * 0.85 end
    local predictedPos
    if isTrulyAirborne then
        predictedPos = predictAerialPosition(serverPredictedPos, predictionVel, predTime, isStrafing, isFastFalling, State.IsMultiJumping)
    else
        predictedPos = serverPredictedPos + predictionVel * predTime
    end
    local verticalOffset = Vector3.zero
    if not isTrulyAirborne and not isExtremeBoost and not isJumpBoost and not isInfJump then
        if State.TargetVelocity.Y < -8 or State.TargetVelocity.Y > 8 then verticalOffset = Vector3.new(0, State.TargetVelocity.Y * 0.15, 0) end
    end
    predictedPos = predictedPos + verticalOffset
    local interceptOffset = Vector3.zero
    local horizontalVel = Vector3.new(predictionVel.X, 0, predictionVel.Z)
    if horizontalVel.Magnitude > 1 and not useCurrentPos then interceptOffset = horizontalVel.Unit * CONFIG.PredictAhead end
    local interceptPoint = predictedPos + interceptOffset
    return interceptPoint, targetPos, myPos, isJumping, isExtremeBoost, isJumpBoost, isInfJump, isFloater,
           isErratic, isQuickTurn, isTrulyAirborne, isStrafing, isFastFalling
end

function applyMovementAndRotation(interceptPoint, targetPos, myPos, isJumping, isExtremeBoost, isJumpBoost, isInfJump, isFloater,
                                        isErratic, isQuickTurn, isTrulyAirborne, isStrafing, isFastFalling)
    local liveMyPos = rootPart and rootPart.Position or myPos
    local toTarget = targetPos - liveMyPos
    if toTarget.Magnitude > 0.1 then updateRotationAngular(toTarget, rootPart) end
    local actualDistance = (targetPos - myPos).Magnitude
    if autoSwingEnabled and autoBatEnabled and actualDistance <= CONFIG.ActivateDistance then
        local currentTime = tick()
        if currentTime - State.LastActivationTime >= 0.3 then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            State.LastActivationTime = currentTime
        end
    end
    local direction = interceptPoint - myPos
    if direction.Magnitude > CONFIG.MinFollowDistance then
        local dirUnit = direction.Unit
        local currentSpeed = CONFIG.FollowSpeed
        if isJumping then currentSpeed = currentSpeed * CONFIG.JumpSpeedBoost end
        if isExtremeBoost then currentSpeed = currentSpeed * 1.3
        elseif isJumpBoost or isInfJump or isFloater then currentSpeed = currentSpeed * 1.15 end
        if isErratic then currentSpeed = currentSpeed * 0.9
        elseif isQuickTurn then currentSpeed = currentSpeed * 1.1
        elseif isTrulyAirborne and isStrafing then currentSpeed = currentSpeed * 0.95
        elseif isTrulyAirborne and isFastFalling then currentSpeed = currentSpeed * 1.15
        elseif isTrulyAirborne then currentSpeed = currentSpeed * 1.05 end
        currentSpeed = math.min(currentSpeed, CONFIG.MaxSpeed)
        rootPart.AssemblyLinearVelocity = dirUnit * currentSpeed
    else
        rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
    end
end

function aimbotUpdate(dt)
    if not autoBatEnabled then stopBatAimbot(); return end
    local currentCharacter = LP.Character
    local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
    local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
    if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then return end
    if rootPart ~= currentRoot then
        rootPart = currentRoot
        humanoid = currentHumanoid
        humanoid.AutoRotate = false
        resetTargetTracking(nil, nil)
    end
    local targetRoot = updateTargetInfo(dt)
    if not targetRoot then return end
    local interceptPoint, targetPos, myPos, isJumping, isExtremeBoost, isJumpBoost, isInfJump, isFloater,
          isErratic, isQuickTurn, isTrulyAirborne, isStrafing, isFastFalling = computePrediction(targetRoot, dt)
    applyMovementAndRotation(interceptPoint, targetPos, myPos, isJumping, isExtremeBoost, isJumpBoost, isInfJump, isFloater,
                             isErratic, isQuickTurn, isTrulyAirborne, isStrafing, isFastFalling)
end

local aimbotConn = nil

function startBatAimbot()
    if aimbotConn then return end
    autoBatEnabled = true
    local char = LP.Character
    if not char then return end
    humanoid = char:FindFirstChildOfClass("Humanoid")
    rootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    _GACC.equipPreferredBatTool()
    humanoid.AutoRotate = false
    aimbotConn = RunService.RenderStepped:Connect(aimbotUpdate)
end

function stopBatAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
    autoBatEnabled = false
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    end
    State.TargetPlayer = nil; State.LastTargetPos = nil; State.TargetVelocity = Vector3.zero
    State.SmoothedVelocity = Vector3.zero; State.VelocityHistory = {}; State.AccelerationHistory = {}
    State.AerialVelocityHistory = {}; State.VerticalVelocityHistory = {}; State.AerialSmoothVelocity = Vector3.zero
    State.AirborneTime = 0; State.HighYVelocityTime = 0; State.PreviousDirection = nil
    State.WasAirborne = false; State.LastYVelocity = 0; State.PeakHeight = 0
    State.GroundHeight = 0; State.IsMultiJumping = false; State.LastActivationTime = 0
end

-- ============================================================
-- ANTI-DESYNC / TP BAT V2 (Ace port - hardened)
-- ============================================================
local AceAntiDesyncState={
    conn=nil, hittingCooldown=false, h=nil, hrp=nil,
    lastSafeCFrame=nil, lastPosition=nil, lastSampleTime=0,
    voidRecoverUntil=0, targetSamples={}, targetPlayer=nil,
    safeEngagementCFrame=nil,
}
local AceAntiDesyncSlapList={
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap",
    "Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap",
}

function aceGetBat()
    local char=LP.Character
    if not char then return nil end
    for _,name in ipairs(AceAntiDesyncSlapList) do
        local t=char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    for _,ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") then
            local n=ch.Name:lower()
            if n:find("bat") or n:find("slap") then return ch end
        end
    end
    local bp=LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _,name in ipairs(AceAntiDesyncSlapList) do
            local t=bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
        for _,ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") then
                local n=ch.Name:lower()
                if n:find("bat") or n:find("slap") then
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(ch) end) end
                    return ch
                end
            end
        end
    end
    return nil
end

function aceTrySwing()
    if not AceAntiDesyncState then return end
    if AceAntiDesyncState.hittingCooldown then return end
    AceAntiDesyncState.hittingCooldown=true
    pcall(function()
        local char=LP.Character
        if not char then return end
        local bat=aceGetBat()
        if not bat then return end
        if bat.Parent~=char then
            local hum=char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(bat) end) end
        end
        pcall(function() bat:Activate() end)
        local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then pcall(function() ev:FireServer() end) end
    end)
    task.delay(0.08,function()
        if AceAntiDesyncState then AceAntiDesyncState.hittingCooldown=false end
    end)
end

function aceGetClosestPlayer()
    local hrp=AceAntiDesyncState and AceAntiDesyncState.hrp
    if not hrp or not hrp.Parent then
        local c=LP.Character
        hrp=c and c:FindFirstChild("HumanoidRootPart")
        if hrp then AceAntiDesyncState.hrp=hrp end
    end
    if not hrp then return nil,math.huge end
    local cp,cd=nil,math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local tr=p.Character:FindFirstChild("HumanoidRootPart")
            local hum=p.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health>0 then
                local targetY=tr.Position.Y
                if targetY>=-30 and targetY<=1200 then
                    local d=(hrp.Position-tr.Position).Magnitude
                    if d<cd then cd=d; cp=p end
                end
            end
        end
    end
    return cp,cd
end

function aceSetupChar(char)
    if not char then return end
    if not AceAntiDesyncState then return end
    local hum=char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",5)
    local root=char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5)
    AceAntiDesyncState.h=hum
    AceAntiDesyncState.hrp=root
    if root and root.Position.Y>-30 then
        AceAntiDesyncState.lastSafeCFrame=root.CFrame
        AceAntiDesyncState.lastPosition=root.Position
        AceAntiDesyncState.lastSampleTime=tick()
    end
end

function aceFiniteVector3(v)
    return v.X==v.X and v.Y==v.Y and v.Z==v.Z
        and math.abs(v.X)<1e7 and math.abs(v.Y)<1e7 and math.abs(v.Z)<1e7
end

function aceInspectTarget(player,targetRoot,myRoot)
    if not player or not targetRoot or not targetRoot.Parent then return true,nil end
    local guard=AceAntiDesyncState; guard.targetSamples=guard.targetSamples or {}
    local sample=guard.targetSamples[player] or {}; guard.targetSamples[player]=sample
    local now=tick(); local pos=targetRoot.Position; local vel=targetRoot.AssemblyLinearVelocity
    local destroyHeight=workspace.FallenPartsDestroyHeight or -500
    local voidFloor=math.max(destroyHeight+90,-50)
    local dt=sample.time and math.max(now-sample.time,1/240) or math.huge
    local delta=sample.position and (pos-sample.position) or Vector3.zero
    local impossibleStep=sample.position~=nil and dt<0.4 and (delta.Magnitude>90 or math.abs(delta.Y)>38)
    local badVelocity=not aceFiniteVector3(vel) or vel.Magnitude>650 or math.abs(vel.Y)>150
    local badPosition=not aceFiniteVector3(pos) or pos.Y<=voidFloor or pos.Y>650
        or (myRoot and (pos-myRoot.Position).Magnitude>4000)
    if badPosition or badVelocity or impossibleStep then sample.suspiciousUntil=now+1.35
    elseif now>=(sample.suspiciousUntil or 0) then sample.safePosition=pos; sample.safeCFrame=targetRoot.CFrame end
    sample.position=pos; sample.time=now
    return now<(sample.suspiciousUntil or 0),sample
end

function aceGuardVoid(root,hum,targetRoot)
    if not root or not hum or not AceAntiDesyncState then return false end
    local guard=AceAntiDesyncState
    local now=tick()
    local position=root.Position
    local velocity=root.AssemblyLinearVelocity
    local destroyHeight=workspace.FallenPartsDestroyHeight or -500
    local voidFloor=math.max(destroyHeight+80,-55)
    local dt=now-(guard.lastSampleTime or now)
    local suddenDrop=guard.lastPosition and dt<=0.35 and position.Y<guard.lastPosition.Y-40
    local suddenRise=guard.lastPosition and dt<=0.35 and position.Y>guard.lastPosition.Y+25
    local safeRise=guard.lastSafeCFrame and position.Y>guard.lastSafeCFrame.Position.Y+30
    local forcedLaunch=math.abs(velocity.Y)>90 or velocity.Magnitude>450
    local inVoid=position.Y<=voidFloor
    local resetHeight=position.Y>400
    local recovering=now<(guard.voidRecoverUntil or 0)

    if inVoid or suddenDrop or suddenRise or safeRise or forcedLaunch or resetHeight then
        if sethiddenproperty then
            pcall(function() sethiddenproperty(root,"PhysicsRepRootPart",root) end)
        end
        local recoveryCFrame=guard.safeEngagementCFrame or guard.lastSafeCFrame
        if targetRoot and targetRoot.Parent and targetRoot.Position.Y>voidFloor+10 and targetRoot.Position.Y<350 then
            local tp=targetRoot.Position
            local recoveryPos=Vector3.new(tp.X,tp.Y+0.9,tp.Z)
            local facing=Vector3.new(targetRoot.CFrame.LookVector.X,0,targetRoot.CFrame.LookVector.Z)
            if facing.Magnitude<0.01 then facing=Vector3.new(0,0,-1) end
            recoveryCFrame=CFrame.lookAt(recoveryPos,recoveryPos+facing.Unit)
        end
        pcall(function()
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            pcall(function() root.Velocity=Vector3.zero end)
            pcall(function() root.RotVelocity=Vector3.zero end)
            hum.PlatformStand=false
            hum.Sit=false
            hum.AutoRotate=true
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            if recoveryCFrame then root.CFrame=recoveryCFrame end
        end)
        guard.voidRecoverUntil=now+0.55
        guard._physPulseUntil=now+0.2
        recovering=true
    elseif not recovering and position.Y>voidFloor+15 and math.abs(velocity.Y)<85 and position.Y<250 then
        guard.lastSafeCFrame=root.CFrame
    end

    if recovering then
        pcall(function()
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            if targetRoot and targetRoot.Parent and targetRoot.Position.Y>voidFloor+10 and targetRoot.Position.Y<350 then
                local tp=targetRoot.Position+Vector3.new(0,0.9,0)
                root.CFrame=CFrame.new(tp)
            end
        end)
        if sethiddenproperty then
            pcall(function() sethiddenproperty(root,"PhysicsRepRootPart",root) end)
        end
    end
    guard.lastPosition=root.Position
    guard.lastSampleTime=now
    return recovering
end

function startAceAntiDesync()
    pcall(function() if stopBatAimbot then stopBatAimbot() end end)
    if AceAntiDesyncState and AceAntiDesyncState.conn then
        pcall(function() AceAntiDesyncState.conn:Disconnect() end)
        AceAntiDesyncState.conn=nil
    end
    AceAntiDesyncState.hittingCooldown=false
    AceAntiDesyncState.targetSamples=AceAntiDesyncState.targetSamples or {}

    function getBat()
        return aceGetBat()
    end
    function tryHit()
        if AceAntiDesyncState.hittingCooldown then return end
        AceAntiDesyncState.hittingCooldown=true
        pcall(function()
            local bat=getBat()
            if not bat then return end
            local char=LP.Character
            if bat.Parent~=char then
                local hum=char and char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
            local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end)
        task.delay(0.08,function()
            if AceAntiDesyncState then AceAntiDesyncState.hittingCooldown=false end
        end)
    end
    function closestRoot()
        local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local locked=AceAntiDesyncState.targetPlayer
        if locked and locked.Parent==Players and locked.Character then
            local lr=locked.Character:FindFirstChild("HumanoidRootPart")
            local lh=locked.Character:FindFirstChildOfClass("Humanoid")
            if lr and lh and lh.Health>0 then return lr,locked end
        end
        local best,bd=nil,math.huge
        local bestPlayer=nil
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local tr=p.Character:FindFirstChild("HumanoidRootPart")
                local hum=p.Character:FindFirstChildOfClass("Humanoid")
                if tr and hum and hum.Health>0 then
                    local suspicious,sample=aceInspectTarget(p,tr,hrp)
                    local pos=suspicious and sample and sample.safePosition or tr.Position
                    if pos then local d=(hrp.Position-pos).Magnitude
                        if d<bd then bd=d; best=tr; bestPlayer=p end end
                end
            end
        end
        AceAntiDesyncState.targetPlayer=bestPlayer
        return best,bestPlayer
    end

    AceAntiDesyncState.conn=RunService.Heartbeat:Connect(function()
        if not batDesyncTpEnabled or batDesyncTpVersion~="V2" then return end
        local char=LP.Character
        if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local tr,targetPlayer=closestRoot()
        if not tr then return end
        local suspicious,sample=aceInspectTarget(targetPlayer,tr,hrp)
        if aceGuardVoid(hrp,hum,suspicious and nil or tr) then tryHit(); return end
        if suspicious then
            local recovery=AceAntiDesyncState.safeEngagementCFrame or AceAntiDesyncState.lastSafeCFrame
            if sethiddenproperty then pcall(function() sethiddenproperty(hrp,"PhysicsRepRootPart",hrp) end) end
            local safePos=sample and sample.safePosition
            local anchor=recovery and recovery.Position or hrp.Position
            local targetXZ=safePos or anchor
            if aceFiniteVector3(tr.Position) then
                local reference=safePos or anchor
                local horizontalDelta=Vector3.new(tr.Position.X-reference.X,0,tr.Position.Z-reference.Z).Magnitude
                if horizontalDelta<=180 then targetXZ=tr.Position end
            end
            local sanitizedPos=Vector3.new(targetXZ.X,anchor.Y,targetXZ.Z)
            local facing=Vector3.new(tr.CFrame.LookVector.X,0,tr.CFrame.LookVector.Z)
            if facing.Magnitude<0.01 then facing=Vector3.new(0,0,-1) end
            local sanitizedCFrame=CFrame.lookAt(sanitizedPos,sanitizedPos+facing.Unit)
            pcall(function()
                hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero
                if (hrp.Position-sanitizedPos).Magnitude>5 then hrp.CFrame=sanitizedCFrame end
            end)
            local cam=workspace.CurrentCamera
            if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,sanitizedPos) end
            tryHit(); return
        end
        local guard=AceAntiDesyncState
        local now=tick()
        local tvel=tr.AssemblyLinearVelocity
        local predict=Vector3.new(tvel.X,0,tvel.Z)*0.05
        local rawTarget=tr.Position+Vector3.new(0,0.9,0)+predict
        local targetPos=rawTarget
        if targetPos.Y<-20 then
            targetPos=Vector3.new(targetPos.X,hrp.Position.Y,targetPos.Z)
        end
        local facing=Vector3.new(tr.CFrame.LookVector.X,0,tr.CFrame.LookVector.Z)
        if facing.Magnitude<0.01 then
            local flat=Vector3.new(tr.Position.X-hrp.Position.X,0,tr.Position.Z-hrp.Position.Z)
            facing=flat.Magnitude>0.01 and flat.Unit or Vector3.new(0,0,-1)
        end
        guard.safeEngagementCFrame=CFrame.lookAt(targetPos,targetPos+facing.Unit)

        pcall(function()
            hrp.CFrame=guard.safeEngagementCFrame
            hrp.AssemblyLinearVelocity=Vector3.new(tvel.X,0,tvel.Z)
            hrp.AssemblyAngularVelocity=Vector3.zero
        end)

        if sethiddenproperty and now>=(guard._physPulseUntil or 0) then
            pcall(function() sethiddenproperty(hrp,"PhysicsRepRootPart",tr) end)
        end

        local cam=workspace.CurrentCamera
        if cam then
            cam.CFrame=CFrame.new(cam.CFrame.Position,tr.Position)
        end
        tryHit()
    end)
end

function stopAceAntiDesync()
    if AceAntiDesyncState and AceAntiDesyncState.conn then
        pcall(function() AceAntiDesyncState.conn:Disconnect() end)
        AceAntiDesyncState.conn=nil
    end

    local char=LP.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
        if sethiddenproperty then pcall(function() sethiddenproperty(root,"PhysicsRepRootPart",root) end) end
    end

    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end

    if AceAntiDesyncState then
        AceAntiDesyncState.hittingCooldown=false
        AceAntiDesyncState.targetPlayer=nil
        AceAntiDesyncState.safeEngagementCFrame=nil
    end
end

-- ============================================================
-- TP BAT V1 = attached original logic / TP BAT V2 = previous GRAPE logic
-- ============================================================
local batDesyncTpConn = nil
local batDesyncTpConnV2 = nil
local hittingCooldownDesync = false
local grapeH, grapeHrp = nil, nil

local function grapeSetupChar(char)
    if not char then return end
    task.wait(0.1)
    grapeH = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    grapeHrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
end

if not _G._GrapeTpBatCharHooked then
    _G._GrapeTpBatCharHooked = true
    LP.CharacterAdded:Connect(function(char)
        task.spawn(function() grapeSetupChar(char) end)
    end)
    if LP.Character then
        task.spawn(function() grapeSetupChar(LP.Character) end)
    end
end

function getBatDesync()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

function tryHitBatDesync()
    if hittingCooldownDesync then return end
    hittingCooldownDesync = true
    pcall(function()
        local bat = getBatDesync()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() hittingCooldownDesync = false end)
end

function getClosestPlayerDesync()
    local hrp = grapeHrp
    if not hrp or not hrp.Parent then
        local char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then grapeHrp = hrp end
    end
    if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < cd then
                    cd = d
                    cp = p
                end
            end
        end
    end
    return cp, cd
end

-- Exact TP Bat V1 behavior extracted from the attached source.
function attachedTpBatV1Update()
    if not batDesyncTpEnabled then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target, closestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (hrp.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    target = player
                end
            end
        end
    end

    local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    if sethiddenproperty then
        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", targetRoot) end)
    end
    local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
    if (hrp.Position - targetPos).Magnitude > 8 then
        hrp.CFrame = CFrame.new(targetPos)
    end
    local cam = workspace.CurrentCamera
    if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position) end
    tryHitBatDesync()
end

-- Previous TP Bat V1 (GRAPE) now used as TP Bat V2.
function batDesyncTpUpdate()
    if not batDesyncTpEnabled then return end
    if not (grapeH and grapeHrp) then
        local char = LP.Character
        if char then
            grapeH = char:FindFirstChildOfClass("Humanoid")
            grapeHrp = char:FindFirstChild("HumanoidRootPart")
        end
    end
    if not (grapeH and grapeHrp) then return end

    local target = getClosestPlayerDesync()
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            if sethiddenproperty then
                sethiddenproperty(grapeHrp, "PhysicsRepRootPart", tr)
            end
            local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
            if (grapeHrp.Position - targetPos).Magnitude > 3 then
                grapeHrp.CFrame = CFrame.new(targetPos)
            end
            workspace.CurrentCamera.CFrame = CFrame.new(
                workspace.CurrentCamera.CFrame.Position, tr.Position
            )
            tryHitBatDesync()
        end
    end
end

function startBatDesyncTp()
    batDesyncTpEnabled = true
    -- stop both loops first
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    if batDesyncTpConnV2 then
        batDesyncTpConnV2:Disconnect()
        batDesyncTpConnV2 = nil
    end
    pcall(function() if stopAceAntiDesync then stopAceAntiDesync() end end)

    if batDesyncTpVersion == "V2" then
        -- V2 = the previous GRAPE V1 logic (distance 3).
        if LP.Character then
            task.spawn(function() grapeSetupChar(LP.Character) end)
        end
        batDesyncTpConnV2 = RunService.Heartbeat:Connect(batDesyncTpUpdate)
    else
        -- V1 = original implementation extracted from the attached script.
        batDesyncTpConn = RunService.Heartbeat:Connect(attachedTpBatV1Update)
    end
end

function stopBatDesyncTp()
    batDesyncTpEnabled = false
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    if batDesyncTpConnV2 then
        batDesyncTpConnV2:Disconnect()
        batDesyncTpConnV2 = nil
    end
    pcall(function() if stopAceAntiDesync then stopAceAntiDesync() end end)
    local hrp = grapeHrp or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    if hrp and sethiddenproperty then
        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
    end
end

-- ============================================================
-- TP BAT V3 (CANDY SAFE VERSION) IMPLEMENTATION
-- ============================================================

local tpBatV3State = {
    enabled = false,
    loop = nil,
    range = 100,
    hitCooldown = 0.08,
    lastHit = 0,
}

function _v3FindClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local closest = nil
    local closestDist = tpBatV3State.range
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local targetChar = player.Character
            if targetChar then
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local dist = (root.Position - targetRoot.Position).Magnitude
                    if dist < closestDist then
                        closest = targetRoot
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

function _v3FindBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:FindFirstChildOfClass("Humanoid") and char:GetChildren() or {}) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("bat") then
                return tool
            end
        end
    end
    return nil
end

function startBatDesyncTpV3()
    batDesyncTpV3Enabled = true
    if tpBatV3State.loop then return end
    
    tpBatV3State.loop = RunService.Heartbeat:Connect(function()
        if not batDesyncTpV3Enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        
        local now = tick()
        if now - tpBatV3State.lastHit < tpBatV3State.hitCooldown then return end
        
        local target = _v3FindClosestTarget()
        if not target then return end
        
        local bat = _v3FindBat()
        if not bat then return end
        
        local targetPos = target.Position
        local rootPos = root.Position
        local direction = (targetPos - rootPos).Unit
        
        -- TP near target
        local tpPos = targetPos - direction * 3
        pcall(function()
            root.CFrame = CFrame.new(tpPos)
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)
        
        -- Swing bat
        pcall(function()
            bat:Activate()
        end)
        
        tpBatV3State.lastHit = now
    end)
end

function stopBatDesyncTpV3()
    batDesyncTpV3Enabled = false
    if tpBatV3State.loop then
        tpBatV3State.loop:Disconnect()
        tpBatV3State.loop = nil
    end
end

function queueAutoBatStart() startBatAimbot() end

function resetAutoBatMotion()
    local char = LP.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if root then root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3; root.AssemblyAngularVelocity = Vector3.zero end
        if hum then hum.AutoRotate = true end
    end
end

startAutoSwingLoop = function() end
stopAutoSwingLoop = function() end
swingCurrentBat = function() end

LP.CharacterAdded:Connect(function(char)
    if autoBatEnabled then task.wait(0.5); startBatAimbot() end
end)
end)() 

;(function()
    local state={applied=false,waiting=false,watchUntil=0,graceUntil=0,savedMode=nil,stealWasActive=false}

    function modeName()
        if laggerModeEnabled then return carrySpeedActive and "Lagger Carry" or "Lagger" end
        return carrySpeedActive and "Carry" or "Normal"
    end

    function setModes(lagger,carry)
        laggerModeEnabled=lagger
        carrySpeedActive=carry
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        if _GACC.safeLaggerVisual then _GACC.safeLaggerVisual(lagger) end
        if _GACC.safeCarryVisual then _GACC.safeCarryVisual(carry) end
        if mobBtnRefs.lagger then mobBtnRefs.lagger(lagger) end
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carry) end
    end

    function isIgnoredTool(name)
        local lower=tostring(name or ""):lower()
        return lower:find("bat",1,true) or lower:find("slap",1,true) or lower:find("medusa",1,true) or lower:find("head",1,true) or lower:find("stone",1,true)
    end

    _GACC.autoCarryDetect=function()
        local char=LP.Character;if not char then return false end
        for _,name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local value=char:FindFirstChild(name,true)
            if value and ((value:IsA("BoolValue") and value.Value) or (value:IsA("ObjectValue") and value.Value) or (value:IsA("StringValue") and value.Value~="")) then return true end
        end
        for _,child in ipairs(char:GetChildren()) do
            local lower=child.Name:lower()
            if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart",true) then
                if (child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart")) or lower:find("brainrot") or lower:find("animal") or lower:find("carry") or lower:find("grab") or lower:find("steal") or lower:find("hold") then return true end
            elseif child:IsA("Tool") and not isIgnoredTool(child.Name) then return true end
        end
        return false
    end

    function enableCarry()
        state.waiting=false;state.watchUntil=0
        if not state.applied then state.savedMode=modeName() end
        state.applied=true;state.graceUntil=tick()+.75
        local wasLagger=state.savedMode=="Lagger" or state.savedMode=="Lagger Carry" or laggerModeEnabled
        if wasLagger then setModes(true,true) else setModes(false,true) end
    end

    function disableCarry()
        if not state.applied and not state.waiting then return end
        local wasApplied=state.applied;local saved=state.savedMode
        state.applied=false;state.waiting=false;state.watchUntil=0;state.graceUntil=0;state.savedMode=nil
        if not wasApplied then return end
        if saved=="Lagger" or saved=="Lagger Carry" then setModes(true,false)
        elseif saved=="Carry" then setModes(false,true)
        else setModes(false,false) end
    end

    _GACC.autoCarryWatch=function(seconds)
        if not _GACC.autoCarrySpeedEnabled then return end
        state.waiting=true;state.watchUntil=tick()+(seconds or 1.25)
    end
    _GACC.disableAutoCarry=disableCarry

    RunService.RenderStepped:Connect(function()
        if not _GACC.autoCarrySpeedEnabled then disableCarry();return end
        local char=LP.Character;local hum=char and char:FindFirstChildOfClass("Humanoid");local root=char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root then disableCarry();state.stealWasActive=false;return end
        local humanoidState=hum:GetState()
        local gotHit=humanoidState==Enum.HumanoidStateType.Physics or humanoidState==Enum.HumanoidStateType.Ragdoll or humanoidState==Enum.HumanoidStateType.FallingDown
        local stealing=LP:GetAttribute("Stealing")==true or char:GetAttribute("Stealing")==true
        local carrying=_GACC.autoCarryDetect()
        if stealing and not state.stealWasActive then state.stealWasActive=true;enableCarry()
        elseif not stealing then state.stealWasActive=false end
        if state.waiting then
            if gotHit or tick()>state.watchUntil then state.waiting=false;state.watchUntil=0
            elseif carrying then enableCarry() end
        end
        if carrying and not state.applied then enableCarry() end
        if state.applied and (gotHit or (tick()>state.graceUntil and not carrying and not stealing)) then disableCarry() end
    end)
end)()

-- Compact E01 carry safety countdown. This replaces the source's large
-- screen-wide warning with a small timer attached above the local head.
;(function()
    local activeBillboard=nil
    local timerConnection=nil
    local wasCarrying=false
    local lastTriggered=-math.huge
    local timerGeneration=0

    -- Preserve the pasted source's carry trigger logic. The existing detector
    -- remains an extra signal, but is no longer required for the timer to run.
    local function isCarryingForE01()
        local char=LP.Character
        if not char then return false end

        for _,child in ipairs(char:GetChildren()) do
            local lower=child.Name:lower()
            if lower:find("brainrot",1,true) or lower:find("brain",1,true)
                or lower:find("animal",1,true) or lower:find("carry",1,true)
                or lower:find("stolen",1,true) or lower:find("held",1,true)
                or lower:find("steal",1,true) then
                return true
            end
        end

        for attributeName,attributeValue in pairs(char:GetAttributes()) do
            local lower=tostring(attributeName):lower()
            if attributeValue==true and (lower:find("carrying",1,true)
                or lower:find("carry",1,true) or lower:find("stealing",1,true)
                or lower:find("isstealing",1,true) or lower:find("hasbrainrot",1,true)) then
                return true
            end
        end

        if _GACC.autoCarryDetect then
            local ok,result=pcall(_GACC.autoCarryDetect)
            if ok and result==true then return true end
        end

        local humanoid=char:FindFirstChildOfClass("Humanoid")
        return humanoid~=nil and humanoid.WalkSpeed>0 and humanoid.WalkSpeed<=25 and humanoid.WalkSpeed~=16
    end

    local function clearTimer()
        timerGeneration=timerGeneration+1
        if timerConnection then timerConnection:Disconnect(); timerConnection=nil end
        if activeBillboard then pcall(function() activeBillboard:Destroy() end); activeBillboard=nil end
    end

    local function startHeadCountdown()
        local char=LP.Character
        local head=char and char:FindFirstChild("Head")
        if not head then return end
        clearTimer()
        local generation=timerGeneration

        local billboard=Instance.new("BillboardGui")
        billboard.Name="AntiSammy_E01Timer"
        billboard.Adornee=head
        billboard.Size=UDim2.fromOffset(292,46)
        billboard.StudsOffset=Vector3.new(0,4.95,0)
        billboard.AlwaysOnTop=true
        billboard.LightInfluence=0
        billboard.MaxDistance=150
        billboard.Parent=head
        activeBillboard=billboard

        local label=Instance.new("TextLabel")
        label.Name="Countdown"
        label.Size=UDim2.fromScale(1,1)
        label.BackgroundColor3=Color3.fromRGB(22,2,7)
        label.BackgroundTransparency=.46
        label.BorderSizePixel=0
        label.Text="E01 SAFE IN 3.00s"
        label.TextColor3=Color3.fromRGB(255,66,85)
        label.TextStrokeColor3=Color3.fromRGB(18,0,4)
        label.TextStrokeTransparency=.48
        label.Font=Enum.Font.GothamMedium
        label.TextSize=19
        label.Parent=billboard
        local labelCorner=Instance.new("UICorner",label); labelCorner.CornerRadius=UDim.new(0,12)
        local labelStroke=Instance.new("UIStroke",label)
        labelStroke.Color=Color3.fromRGB(232,31,58)
        labelStroke.Thickness=1.15
        labelStroke.Transparency=.28

        local duration=3
        local started=os.clock()
        timerConnection=RunService.RenderStepped:Connect(function()
            if generation~=timerGeneration or not billboard.Parent then
                if timerConnection then timerConnection:Disconnect(); timerConnection=nil end
                return
            end
            local remaining=math.max(0,duration-(os.clock()-started))
            if remaining>0 then
                label.Text=string.format("E01 SAFE IN %.2fs",remaining)
                local progress=1-(remaining/duration)
                if progress>.66 then
                    label.TextColor3=Color3.fromRGB(255,203,72)
                    labelStroke.Color=Color3.fromRGB(240,145,40)
                end
                return
            end

            timerConnection:Disconnect(); timerConnection=nil
            label.Text="SAFE TO STEAL"
            label.TextColor3=Color3.fromRGB(73,255,145)
            labelStroke.Color=Color3.fromRGB(42,218,112)
            TweenService:Create(label,TweenInfo.new(.16,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                BackgroundTransparency=.32
            }):Play()
            task.delay(1.5,function()
                if generation==timerGeneration then clearTimer() end
            end)
        end)
    end

    task.spawn(function()
        while task.wait(.08) do
            local carrying=isCarryingForE01()
            if carrying and not wasCarrying and os.clock()-lastTriggered>3.25 then
                lastTriggered=os.clock()
                startHeadCountdown()
            end
            wasCarrying=carrying
        end
    end)

    LP.CharacterAdded:Connect(function()
        wasCarrying=false
        clearTimer()
    end)
end)()

ConfigShare.capture=function()
    function ks(e)
        if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
        elseif e.gp then return {gp=e.gp.Name}
        else return {kb=nil,gp=nil} end
    end
	local cfg={normalSpeed=NS,carrySpeed=CS,dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,stealMode=stealMode,antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,medusaCounter=medusaCounterEnabled,carrySpeedActive=carrySpeedActive,laggerModeEnabled=laggerModeEnabled,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,autoBat=autoBatEnabled,batDesyncTpEnabled=batDesyncTpEnabled,batDesyncTpVersion=batDesyncTpVersion,autoLeftEnabled=autoLeftEnabled,autoRightEnabled=autoRightEnabled,autoPlayRemoved=_GACC.autoPlayRemoved==true,autoSwing=autoSwingEnabled,unwalkEnabled=unwalkEnabled,antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,guiTransparencyEnabled=guiTransparencyEnabled,mobileButtonsEnabled=mobileButtonsEnabled,mobileButtonsLocked=mobileButtonsLocked,mobileButtonsSize=mobileButtonsSize,circleButtonsEnabled=circleButtonsEnabled,autoSwitchSpeed=autoSwitchSpeedEnabled,fovValue=fovValue,perButtonDrag=perButtonDragEnabled,skyTheme=currentSkyTheme,medusaReset=medusaResetEnabled,autoMoveSwing=autoMoveSwingEnabled,autoMoveSwingInterval=autoMoveSwingInterval,ragdollGui=ragdollGuiEnabled,introSoundEnabled=introSoundEnabled,introEnabled=introEnabled,animEnabled=false,animationPack=_GACC.extras.getPack(),headlessEnabled=_GACC.extras.getHeadless(),korbloxEnabled=_GACC.extras.getKorblox(),colorThemeName=currentColorTheme,keys=(function() if not _GuiKeys then return {} end;local t={};for k,v in pairs(_GuiKeys) do t[k]=v.Name end;return t end)()}
    cfg.unwalkEnabled=false
    cfg.grabRadius=61
    cfg.autoPlayMode=_GACC.autoPlayMode
    cfg.n5AppearanceVersion=ConfigShare.appearanceVersion
    cfg.normalStealVersion=normalStealVersion
    cfg.animationPackEnabled=_GACC.extras.getPackActive()
    cfg.minimizeKey=_GuiKeys and _GuiKeys.guiHide and _GuiKeys.guiHide.Name or "RightControl"
    cfg.clickSoundsEnabled=clickSoundsEnabled
    cfg.tabPosition=tabPosition
    cfg.navigationStyle=navigationStyle
    cfg.uiWidth=uiWidth
    cfg.uiPositionX=uiPositionX; cfg.uiPositionY=uiPositionY
    cfg.searchHistory=searchHistory
    cfg.antiDieFlingEnabled=antiDieFlingEnabled
    cfg.themeIntensity=themeIntensity
    cfg.fovIndex=fovIndex
    cfg.mobileButtonPositions=_GACC.mobileButtonPositions
    cfg.mobileGroupPosition=_GACC.mobileGroupPosition
    cfg.mobileButtonsGrouped=_GACC.mobileButtonsGrouped
    cfg.playerHighlightEnabled=_GACC.playerHighlightEnabled
    cfg.autoCarrySpeedEnabled=_GACC.autoCarrySpeedEnabled
    cfg.opRadius=SemiSteal.CONFIG.RADIUS
    cfg.opDuration=SemiSteal.CONFIG.DURATION
    cfg.opDelayRadius=SemiSteal.CONFIG.DELAY_RADIUS
    cfg.opStopTime=SemiSteal.CONFIG.STOP_TIME
    cfg.opStopTimeEnabled=SemiSteal.CONFIG.STOP_TIME_ENABLED
    return cfg
end

saveConfig=function()
    if ConfigShare.applying then return end
    local cfg=ConfigShare.capture()
    if writefile then pcall(function() writefile(ConfigShare.FILE,HS:JSONEncode(cfg)) end) end
end

ConfigShare.export=function()
    saveConfig()
    local payload={format="ImpulseDuelsConfig",version=1,config=ConfigShare.capture()}
    return "N5-DUELS::"..HS:JSONEncode(payload)
end

ConfigShare.import=function(serialized)
    local raw=tostring(serialized or ""):gsub("^%s+",""):gsub("%s+$","")
    raw=raw:gsub("^N5%-DUELS::",""):gsub("^IMPULSE%-DUELS::","")
    local ok,payload=pcall(function() return HS:JSONDecode(raw) end)
    if not ok or type(payload)~="table" then return nil,"Invalid config string" end
    local config=payload.config or payload
    if type(config)~="table" or (config.normalSpeed==nil and config.colorThemeName==nil and config.keys==nil) then return nil,"This is not an N5 Duels config" end
    if type(config.keys)=="table" then
        local assigned={}
        for _,keyName in pairs(config.keys) do
            if type(keyName)=="string" and assigned[keyName] then return nil,"Config contains duplicate keybinds" end
            if type(keyName)=="string" then assigned[keyName]=true end
        end
    end
    ConfigShare.applying=true
    local applied=pcall(function() if ConfigShare.apply then ConfigShare.apply(config,true) end end)
    ConfigShare.applying=false
    if not applied then return nil,"Config could not be applied" end
    saveConfig()
    return true
end

task.spawn(function() while task.wait(5) do saveConfig() end end)

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerModeEnabled then 
            modeValLbl.Text = carrySpeedActive and "Lagger Carry" or "Lagger Mode"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local WHITE=Color3.fromRGB(255,255,255);local OFF=Color3.fromRGB(30,30,30);local GRAY=Color3.fromRGB(157,157,157)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        local WHITE=Color3.fromRGB(255,255,255);local OFF=Color3.fromRGB(30,30,30);local GRAY=Color3.fromRGB(157,157,157)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
end

toggleCarryMode=function()
    if laggerModeEnabled then laggerModeEnabled = false; carrySpeedActive = true
    else carrySpeedActive = not carrySpeedActive end
    local sync=getgenv().AntiSammySyncSpeedState;if sync then pcall(sync,laggerModeEnabled,carrySpeedActive) end
    refreshSpeedModeLabel()
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
end

toggleLaggerMode=function()
    if not laggerModeEnabled then laggerModeEnabled = true; carrySpeedActive = false
    else carrySpeedActive = not carrySpeedActive end
    local sync=getgenv().AntiSammySyncSpeedState;if sync then pcall(sync,laggerModeEnabled,carrySpeedActive) end
    refreshSpeedModeLabel()
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
end

-- ============================================================
-- ANTI-RAGDOLL
-- ============================================================
;(function()
    local antiRagdollConn=nil

    startAntiRagdoll=function()
        if antiRagdollConn then return end

        antiRagdollConn=RunService.Heartbeat:Connect(function()
            if not antiRagdollEnabled then return end
            local char=LP.Character
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health<=0 then return end

            local state=hum:GetState()
            local isRagdolled=state==Enum.HumanoidStateType.Physics
                or state==Enum.HumanoidStateType.Ragdoll
                or state==Enum.HumanoidStateType.FallingDown
            if not isRagdolled then return end

            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)

                local rootPart=char:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.Velocity=Vector3.zero
                    rootPart.RotVelocity=Vector3.zero
                    rootPart.AssemblyLinearVelocity=Vector3.zero
                    rootPart.AssemblyAngularVelocity=Vector3.zero
                end

                for _,object in ipairs(char:GetDescendants()) do
                    if object:IsA("Motor6D") then object.Enabled=true end
                    if object:IsA("Constraint") then object.Enabled=true end
                end

                if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=hum end

                local playerScripts=LP:FindFirstChild("PlayerScripts")
                local playerModule=playerScripts and playerScripts:FindFirstChild("PlayerModule")
                local controlModule=playerModule and playerModule:FindFirstChild("ControlModule")
                if controlModule then
                    local controls=require(controlModule)
                    if controls then controls:Enable() end
                end

                hum.AutoRotate=true
                hum.PlatformStand=false
                hum.Sit=false
            end)
        end)
    end

    stopAntiRagdoll=function()
        if antiRagdollConn then
            antiRagdollConn:Disconnect()
            antiRagdollConn=nil
        end
    end
end)()

;(function()
    local AntiDie={enabled=false,loop=nil,healthConn=nil,charConn=nil,lastHealTime=0,invincibleUntil=0,config={healthThreshold=50,invincibilityFrames=.75,ragdollProtection=true,autoRevive=true}}
    local AntiFlingShield={enabled=false,loop=nil,velocityThreshold=80}

    AntiDie.superHeal=function(hum)
        if not hum or not hum.Parent then return end
        local maxHealth=hum.MaxHealth or 100; if maxHealth<=0 then maxHealth=100 end
        pcall(function() hum.Health=maxHealth; if hum.MaxHealth<maxHealth then hum.MaxHealth=maxHealth end end)
        AntiDie.invincibleUntil=tick()+AntiDie.config.invincibilityFrames; AntiDie.lastHealTime=tick()
        pcall(function()
            local char=hum.Parent; if not char then return end
            for _,child in ipairs(char:GetChildren()) do
                if child:IsA("NumberValue") then
                    local name=child.Name:lower()
                    if name:find("health") or name:find("hp") or name:find("life") then child.Value=maxHealth end
                elseif child:IsA("BoolValue") and child.Name:lower():find("dead") then
                    child.Value=false
                end
            end
        end)
    end

    AntiDie.autoRevive=function()
        if not AntiDie.config.autoRevive then return end
        local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart"); if not hum or hum.Health>0 then return end
        AntiDie.superHeal(hum)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) end)
        if root then pcall(function() root.CFrame=CFrame.new(root.Position+Vector3.new(0,3,0)); root.AssemblyLinearVelocity=Vector3.zero end) end
    end

    AntiDie.preventDamage=function(root,hum)
        if not hum then return end
        if hum.Health<(hum.MaxHealth or 100) then AntiDie.superHeal(hum) end
        if tick()<AntiDie.invincibleUntil and hum.Health<(hum.MaxHealth or 100) then hum.Health=hum.MaxHealth or 100 end
        if AntiDie.config.ragdollProtection then
            local state=hum:GetState()
            if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll
                or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Dead then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) end)
                AntiDie.superHeal(hum)
                if root then pcall(function() root.AssemblyAngularVelocity=Vector3.zero end) end
            end
        end
        if hum.Health<=0 then
            AntiDie.superHeal(hum)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) end)
            if root then pcall(function() root.CFrame=CFrame.new(root.Position+Vector3.new(0,2,0)); root.AssemblyLinearVelocity=Vector3.zero end) end
        end
    end

    AntiDie.attachHealth=function(char)
        if AntiDie.healthConn then AntiDie.healthConn:Disconnect(); AntiDie.healthConn=nil end
        local hum=char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",3)); if not hum then return end
        AntiDie.healthConn=hum:GetPropertyChangedSignal("Health"):Connect(function()
            if not AntiDie.enabled then return end
            if hum.Health<(hum.MaxHealth or 100) then AntiDie.superHeal(hum) end
            if hum.Health<=0 then AntiDie.autoRevive() end
        end)
        if hum.Health<(hum.MaxHealth or 100) then AntiDie.superHeal(hum) end
    end

    AntiDie.start=function()
        AntiDie.enabled=true
        if AntiDie.loop then AntiDie.loop:Disconnect() end
        AntiDie.loop=RunService.Heartbeat:Connect(function()
            if not AntiDie.enabled then return end
            local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            local root=char and char:FindFirstChild("HumanoidRootPart"); if not hum then return end
            if hum.Health<=0 then AntiDie.autoRevive()
            elseif hum.Health<=AntiDie.config.healthThreshold or hum.Health<(hum.MaxHealth or 100) then AntiDie.superHeal(hum) end
            AntiDie.preventDamage(root,hum)
        end)
        if LP.Character then AntiDie.attachHealth(LP.Character) end
        if AntiDie.charConn then AntiDie.charConn:Disconnect() end
        AntiDie.charConn=LP.CharacterAdded:Connect(function(char)
            if not AntiDie.enabled then return end
            task.wait(.05); AntiDie.attachHealth(char)
            local hum=char:FindFirstChildOfClass("Humanoid"); if hum then AntiDie.superHeal(hum) end
        end)
    end

    AntiDie.stop=function()
        AntiDie.enabled=false
        for _,connectionName in ipairs({"loop","healthConn","charConn"}) do
            local connection=AntiDie[connectionName]
            if connection then connection:Disconnect(); AntiDie[connectionName]=nil end
        end
    end

    AntiFlingShield.stabilizeRoot=function(root)
        if not root or not root.Parent then return end
        local velocity
        local ok=pcall(function() velocity=root.AssemblyLinearVelocity end)
        if not ok or typeof(velocity)~="Vector3" then
            ok,velocity=pcall(function() return root.Velocity end)
            if not ok or typeof(velocity)~="Vector3" then return end
        end
        if velocity.Magnitude<=AntiFlingShield.velocityThreshold then return end
        local stabilized=Vector3.new(0,velocity.Y,0)
        pcall(function() root.AssemblyLinearVelocity=stabilized end)
        pcall(function() root.AssemblyAngularVelocity=Vector3.zero end)
        pcall(function() root.Velocity=stabilized end)
        pcall(function() root.RotVelocity=Vector3.zero end)
    end

    AntiFlingShield.start=function()
        AntiFlingShield.enabled=true
        if AntiFlingShield.loop then AntiFlingShield.loop:Disconnect() end
        AntiFlingShield.loop=RunService.Heartbeat:Connect(function()
            if not AntiFlingShield.enabled then return end
            local char=LP.Character; AntiFlingShield.stabilizeRoot(char and char:FindFirstChild("HumanoidRootPart"))
        end)
    end
    AntiFlingShield.stop=function()
        AntiFlingShield.enabled=false
        if AntiFlingShield.loop then AntiFlingShield.loop:Disconnect(); AntiFlingShield.loop=nil end
    end

    startAntiDieFling=function()
        antiDieFlingEnabled=true; AntiDie.start(); AntiFlingShield.start()
    end
    stopAntiDieFling=function()
        antiDieFlingEnabled=false; AntiDie.stop(); AntiFlingShield.stop()
    end
end)()

startUnwalk=function()
    if _GACC.extras and _GACC.extras.getPackActive and _GACC.extras.getPackActive() then
        unwalkEnabled=false
        if _GACC.unwalkSetVisual then _GACC.unwalkSetVisual(false) end
        return
    end
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end

stopUnwalk=function()
    local c=LP.Character
    if c and unwalkSavedAnimate and not c:FindFirstChild("Animate") then
        local restored=unwalkSavedAnimate:Clone(); restored.Name="Animate"
        if restored:IsA("LocalScript") or restored:IsA("Script") then restored.Disabled=false end
        restored.Parent=c
    end
    unwalkSavedAnimate=nil
end

;(function()
    for _,n in ipairs({"MoveeStealBar"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    local SB_W,SB_H=188,40
    local stealGui=Instance.new("ScreenGui");stealGui.Name="MoveeStealBar";stealGui.ResetOnSpawn=false;stealGui.IgnoreGuiInset=true;stealGui.DisplayOrder=8;stealGui.Enabled=false -- front AntiSammy_StealBar is primary
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(stealGui) end end)
    parentGui(stealGui)

    
    stealBarFrame=Instance.new("Frame",stealGui)
    stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H)
    stealBarFrame.Position=UDim2.new(0.5,-SB_W/2,0.89,0)
    stealBarFrame.BackgroundColor3=Color3.fromRGB(4,3,7)
    stealBarFrame.BackgroundTransparency=0.28
    stealBarFrame.BorderSizePixel=0; stealBarFrame.ZIndex=20; stealBarFrame.ClipsDescendants=true
    Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(0,8)
    local sbStroke=Instance.new("UIStroke",stealBarFrame)
    sbStroke.Color=_GACC.accent; sbStroke.Thickness=1; sbStroke.Transparency=0.46
    local sbBgGrad=Instance.new("UIGradient",stealBarFrame)
    sbBgGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(24,12,38)),ColorSequenceKeypoint.new(.48,Color3.fromRGB(9,7,13)),ColorSequenceKeypoint.new(1,Color3.fromRGB(2,2,3))})
    sbBgGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.08),NumberSequenceKeypoint.new(.55,.18),NumberSequenceKeypoint.new(1,.28)})
    sbBgGrad.Rotation=12
    local topRail=Instance.new("Frame",stealBarFrame)
    topRail.Size=UDim2.new(1,-16,0,1); topRail.Position=UDim2.new(0,8,0,0)
    topRail.BackgroundColor3=_GACC.accent; topRail.BackgroundTransparency=.18; topRail.BorderSizePixel=0; topRail.ZIndex=22
    Instance.new("UICorner",topRail).CornerRadius=UDim.new(0,2)
    local topRailFade=Instance.new("UIGradient",topRail)
    topRailFade.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.18,.2),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(.82,.2),NumberSequenceKeypoint.new(1,1)})

    local statusCore=Instance.new("Frame",stealBarFrame)
    statusCore.Size=UDim2.fromOffset(18,18); statusCore.Position=UDim2.fromOffset(7,5)
    statusCore.BackgroundColor3=Color3.fromRGB(8,6,12); statusCore.BackgroundTransparency=.12
    statusCore.BorderSizePixel=0; statusCore.ZIndex=22; Instance.new("UICorner",statusCore).CornerRadius=UDim.new(0,6)
    local coreStroke=Instance.new("UIStroke",statusCore); coreStroke.Color=_GACC.accentDark; coreStroke.Thickness=1; coreStroke.Transparency=.28
    local coreIcon=Instance.new("ImageLabel",statusCore)
    coreIcon.AnchorPoint=Vector2.new(.5,.5); coreIcon.Position=UDim2.fromScale(.5,.5); coreIcon.Size=UDim2.fromOffset(12,12)
    coreIcon.BackgroundTransparency=1; coreIcon.BorderSizePixel=0; coreIcon.Image=_GACC.autoStealIconAsset
    coreIcon.ImageColor3=Color3.fromRGB(255,255,255); coreIcon.ScaleType=Enum.ScaleType.Fit; coreIcon.ZIndex=23
    local coreScale=Instance.new("UIScale",coreIcon)

    local stealLbl=Instance.new("TextLabel",stealBarFrame)
    stealLbl.Size=UDim2.new(0,82,0,11); stealLbl.Position=UDim2.new(0,30,0,3)
    stealLbl.BackgroundTransparency=1; stealLbl.Text="AUTO STEAL"
    stealLbl.TextColor3=Color3.fromRGB(240,240,242); stealLbl.Font=Enum.Font.GothamBold; stealLbl.TextSize=9
    stealLbl.TextXAlignment=Enum.TextXAlignment.Left; stealLbl.ZIndex=22

    local stateLbl=Instance.new("TextLabel",stealBarFrame)
    stateLbl.Size=UDim2.new(0,94,0,9); stateLbl.Position=UDim2.new(0,30,0,14)
    stateLbl.BackgroundTransparency=1; stateLbl.Text="OFF"
    stateLbl.TextColor3=Color3.fromRGB(158,158,164); stateLbl.TextSize=7; stateLbl.Font=Enum.Font.GothamMedium
    stateLbl.TextXAlignment=Enum.TextXAlignment.Left; stateLbl.ZIndex=22

    local modePill=Instance.new("Frame",stealBarFrame)
    modePill.Size=UDim2.fromOffset(44,14); modePill.Position=UDim2.new(1,-51,0,4)
    modePill.BackgroundColor3=_GACC.accentBg; modePill.BackgroundTransparency=.18; modePill.BorderSizePixel=0; modePill.ZIndex=22
    Instance.new("UICorner",modePill).CornerRadius=UDim.new(0,5)
    local modeStroke=Instance.new("UIStroke",modePill); modeStroke.Color=_GACC.accentDark; modeStroke.Transparency=.45
    local modeLabel=Instance.new("TextLabel",modePill)
    modeLabel.Size=UDim2.fromScale(1,1); modeLabel.BackgroundTransparency=1; modeLabel.Text="86% PRESET"
    modeLabel.TextColor3=_GACC.accent; modeLabel.Font=Enum.Font.GothamBold; modeLabel.TextSize=6; modeLabel.ZIndex=23

    local pctLbl=Instance.new("TextLabel",stealBarFrame)
    pctLbl.Size=UDim2.new(0,44,0,10); pctLbl.Position=UDim2.new(1,-51,0,17)
    pctLbl.BackgroundTransparency=1; pctLbl.Text="0%"
    pctLbl.TextColor3=_GACC.accent; pctLbl.Font=Enum.Font.GothamBold; pctLbl.TextSize=9
    pctLbl.TextXAlignment=Enum.TextXAlignment.Right; pctLbl.ZIndex=22
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function() pctLbl.TextColor3=thm.accent end) end})

    local progressTrack=Instance.new("Frame",stealBarFrame)
    progressTrack.Size=UDim2.new(1,-14,0,4); progressTrack.Position=UDim2.new(0,7,1,-6)
    progressTrack.BackgroundColor3=Color3.fromRGB(13,13,16); progressTrack.BackgroundTransparency=.08
    progressTrack.BorderSizePixel=0; progressTrack.ZIndex=21; progressTrack.ClipsDescendants=true
    Instance.new("UICorner",progressTrack).CornerRadius=UDim.new(1,0)
    local trackStroke=Instance.new("UIStroke",progressTrack); trackStroke.Color=_GACC.accentDark; trackStroke.Transparency=.72
    local progressFill=Instance.new("Frame",progressTrack)
    progressFill.Size=UDim2.new(0,0,1,0); progressFill.BackgroundColor3=_GACC.accent
    progressFill.BorderSizePixel=0; progressFill.ZIndex=22
    Instance.new("UICorner",progressFill).CornerRadius=UDim.new(1,0)
    local fillGradient=Instance.new("UIGradient",progressFill)
    fillGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,_GACC.accentDark),ColorSequenceKeypoint.new(1,_GACC.accent)})
    local progressTip=Instance.new("Frame",progressTrack)
    progressTip.AnchorPoint=Vector2.new(.5,.5); progressTip.Position=UDim2.new(0,0,.5,0); progressTip.Size=UDim2.fromOffset(4,4)
    progressTip.BackgroundColor3=Color3.fromRGB(245,245,245); progressTip.BorderSizePixel=0; progressTip.ZIndex=23
    Instance.new("UICorner",progressTip).CornerRadius=UDim.new(1,0)
    local presetMarker=Instance.new("Frame",progressTrack)
    presetMarker.AnchorPoint=Vector2.new(.5,.5); presetMarker.Position=UDim2.new(.86,0,.5,0); presetMarker.Size=UDim2.fromOffset(2,8)
    presetMarker.BackgroundColor3=Color3.fromRGB(245,245,245); presetMarker.BackgroundTransparency=.18; presetMarker.BorderSizePixel=0; presetMarker.ZIndex=24
    Instance.new("UICorner",presetMarker).CornerRadius=UDim.new(1,0)
    table.insert(_themeExtRefs,{callback=function(thm)
        pcall(function() stealBarFrame.BackgroundColor3=thm.bg end)
        pcall(function()
            topRail.BackgroundColor3=thm.accent; coreStroke.Color=thm.accentDark
            modePill.BackgroundColor3=thm.accentBg; modeStroke.Color=thm.accentDark; modeLabel.TextColor3=thm.accent
            statusCore.BackgroundColor3=thm.input; progressTrack.BackgroundColor3=thm.input; trackStroke.Color=thm.accentDark; progressFill.BackgroundColor3=thm.accent
            fillGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,thm.accentDark),ColorSequenceKeypoint.new(1,thm.accent)})
            sbBgGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,thm.accentBg),ColorSequenceKeypoint.new(.48,thm.bg),ColorSequenceKeypoint.new(1,thm.bgDark)})
        end)
    end})

    task.spawn(function()
        local lastPct=0; local completionLatched=false; local pulseClock=0
        while progressTrack and progressTrack.Parent do
            local pct=0
            local ready=false
            if Steal.AutoStealEnabled then
                if stealMode=="op" and SemiSteal.State.active then
                    pct=math.clamp(tonumber(SemiSteal.State.progress) or 0,0,1); ready=true
                elseif stealMode=="normal" and isStealing and stealStartTime then
                    pct=math.clamp(normalStealProgress,0,1); ready=true
                end
            end
            lastPct=lastPct+(pct-lastPct)*0.24
            if math.abs(lastPct-pct)<0.002 then lastPct=pct end
            progressFill.Size=UDim2.new(lastPct,0,1,0)
            progressTip.Position=UDim2.new(lastPct,0,.5,0); progressTip.Visible=lastPct>.015
            pctLbl.Text=math.floor(lastPct*100+.5).."%"
            if not Steal.AutoStealEnabled then
                stateLbl.Text="DISABLED"
            elseif ready then
                stateLbl.Text=stealMode=="op" and (SemiSteal.State.paused and "WAITING FOR RANGE" or "STEALING") or (normalStealPaused and ("PAUSED AT "..normalStealVersion.."%") or "STEALING")
            else
                stateLbl.Text="READY - SEARCHING"
            end
            stateLbl.TextColor3=ready and Color3.fromRGB(187,187,187) or Color3.fromRGB(133,133,133)
            modeLabel.Text=stealMode=="op" and "OP MODE" or (normalStealVersion.."% PRESET")
            presetMarker.Position=UDim2.new(stealMode=="op" and 1 or (NORMAL_STEAL_PERCENT[normalStealVersion] or .86),0,.5,0)
            pulseClock=pulseClock+.12
            coreScale.Scale=ready and (1+math.sin(pulseClock)*.12) or 1
            coreIcon.ImageTransparency=ready and .02 or .42
            coreStroke.Color=ready and _GACC.accent or _GACC.accentDark
            sbStroke.Color=ready and _GACC.accent or _GACC.accentDark
            topRail.BackgroundTransparency=ready and (.10+math.sin(tick()*5)*.08) or .48
            if lastPct>=.995 and not completionLatched then
                completionLatched=true
                TweenService:Create(stealBarFrame,TweenInfo.new(.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=.02}):Play()
                task.delay(.14,function() if stealBarFrame and stealBarFrame.Parent then TweenService:Create(stealBarFrame,TweenInfo.new(.28),{BackgroundTransparency=.28}):Play() end end)
            elseif lastPct<.12 then completionLatched=false end
            RunService.RenderStepped:Wait()
        end
    end)

    
    local dragStart2,dragStartPos2,dragging2=nil,nil,false
    stealBarFrame.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging2=true;dragStart2=input.Position;dragStartPos2=stealBarFrame.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging2=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if uiLocked then dragging2=false;return end
        if dragging2 and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart2
            stealBarFrame.Position=UDim2.new(dragStartPos2.X.Scale,dragStartPos2.X.Offset+delta.X,dragStartPos2.Y.Scale,dragStartPos2.Y.Offset+delta.Y)
        end
    end)
end)()



ConfigShare.apply=function(d,live)
    if type(d)~="table" then return end
    if type(d.normalSpeed)=="number" and d.normalSpeed>0 then NS=d.normalSpeed end
    if type(d.carrySpeed)=="number" and d.carrySpeed>0 then CS=d.carrySpeed end
    if type(d.laggerSpeed)=="number" and d.laggerSpeed>0 then LAGGER_SPEED=d.laggerSpeed end
    if type(d.laggerCarrySpeed)=="number" and d.laggerCarrySpeed>0 then LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
    if type(d.carrySpeedActive)=="boolean" then carrySpeedActive=d.carrySpeedActive end
    if type(d.laggerModeEnabled)=="boolean" then laggerModeEnabled=d.laggerModeEnabled end
    if type(d.antiRagdoll)=="boolean" then antiRagdollEnabled=d.antiRagdoll end
    if type(d.infiniteJump)=="boolean" then infJumpEnabled=d.infiniteJump end
    if type(d.infJumpMode)=="string" then
        local savedJumpMode=string.lower(d.infJumpMode)
        if savedJumpMode=="hold" then infJumpMode="hold" else infJumpMode="single" end
    end
    if type(d.antiDieFlingEnabled)=="boolean" then antiDieFlingEnabled=d.antiDieFlingEnabled end
    if type(d.medusaCounter)=="boolean" then medusaCounterEnabled=d.medusaCounter end
    if type(d.autoStealEnabled)=="boolean" then Steal.AutoStealEnabled=d.autoStealEnabled end
    stealMode="normal"
    if type(d.normalStealVersion)=="string" and NORMAL_STEAL_PERCENT[d.normalStealVersion] then normalStealVersion=d.normalStealVersion end
    Steal.StealRadius=61
    if type(d.autoPlayMode)=="string" then
        local savedAutoPlay=string.upper(d.autoPlayMode)
        if savedAutoPlay=="SEMI" or savedAutoPlay=="FULL" then _GACC.autoPlayMode=savedAutoPlay end
    end
    if type(d.stealDuration)=="number" then Steal.StealDuration=d.stealDuration end
    local savedOPRadius=d.opRadius or d.opPrimeRange or d.semiPrimeRange
    if type(savedOPRadius)=="number" then SemiSteal.CONFIG.RADIUS=math.clamp(savedOPRadius,1,500) end
    if type(d.opDuration)=="number" then SemiSteal.CONFIG.DURATION=math.clamp(d.opDuration,.05,10) end
    local savedOPDelayRadius=d.opDelayRadius or d.delayRadius
    if type(savedOPDelayRadius)=="number" then SemiSteal.CONFIG.DELAY_RADIUS=math.clamp(savedOPDelayRadius,1,500) end
    if type(d.opStopTime)=="number" then SemiSteal.CONFIG.STOP_TIME=math.clamp(d.opStopTime,.05,10) end
    if type(d.opStopTimeEnabled)=="boolean" then SemiSteal.CONFIG.STOP_TIME_ENABLED=d.opStopTimeEnabled end
    if type(d.autoSwing)=="boolean" then autoSwingEnabled=d.autoSwing end
    if type(d.autoBat)=="boolean" then autoBatEnabled=d.autoBat end
    if type(d.batDesyncTpEnabled)=="boolean" then batDesyncTpEnabled=d.batDesyncTpEnabled end
    if autoBatEnabled and batDesyncTpEnabled then batDesyncTpEnabled=false end
    if type(d.batDesyncTpVersion)=="string" then
        local savedVersion=string.upper(d.batDesyncTpVersion)
        if savedVersion=="V1" or savedVersion=="V2" then batDesyncTpVersion=savedVersion end
    end
	if type(d.autoLeftEnabled)=="boolean" then autoLeftEnabled=d.autoLeftEnabled end
	if type(d.autoRightEnabled)=="boolean" then autoRightEnabled=d.autoRightEnabled end
	if type(d.autoPlayRemoved)=="boolean" then _GACC.autoPlayRemoved=d.autoPlayRemoved end
	if _GACC.autoPlayRemoved then autoLeftEnabled=false; autoRightEnabled=false end
	if not live then autoLeftEnabled=false; autoRightEnabled=false end
    unwalkEnabled=false
    if type(d.antiLag)=="boolean" then antiLagEnabled=d.antiLag end
    if type(d.stretchRez)=="boolean" then stretchRezEnabled=d.stretchRez end
    if type(d.autoTPEnabled)=="boolean" then autoTPEnabled=d.autoTPEnabled end
    if type(d.autoTPHeight)=="number" then autoTPHeight=d.autoTPHeight end
                    if type(d.fovValue)=="number" then fovValue=math.clamp(d.fovValue,80,120); State.Fov=fovValue end
    if type(d.fovIndex)=="number" then fovIndex=math.clamp(math.floor(d.fovIndex),1,#fovOptions)
    else for index,value in ipairs(fovOptions) do if value==fovValue then fovIndex=index; break end end end
    if type(d.skyTheme)=="string" then currentSkyTheme=d.skyTheme end
    if type(d.autoMoveSwing)=="boolean" then autoMoveSwingEnabled=d.autoMoveSwing end
    if type(d.autoMoveSwingInterval)=="number" then autoMoveSwingInterval=d.autoMoveSwingInterval end
    if type(d.ragdollGui)=="boolean" then ragdollGuiEnabled=d.ragdollGui end
    if type(d.mobileButtonsEnabled)=="boolean" then mobileButtonsEnabled=d.mobileButtonsEnabled end
    if type(d.mobileButtonsLocked)=="boolean" then
        mobileButtonsLocked=d.mobileButtonsLocked
        State.MobileButtonsLocked=mobileButtonsLocked
    end
    if type(d.mobileButtonsSize)=="number" then mobileButtonsSize=d.mobileButtonsSize end
    if type(d.mobileButtonPositions)=="table" then _GACC.mobileButtonPositions=d.mobileButtonPositions end
    if type(d.mobileGroupPosition)=="table" then _GACC.mobileGroupPosition=d.mobileGroupPosition end
    if type(d.mobileButtonsGrouped)=="boolean" then _GACC.mobileButtonsGrouped=d.mobileButtonsGrouped end
    if type(d.circleButtonsEnabled)=="boolean" then circleButtonsEnabled=d.circleButtonsEnabled end
    if type(d.perButtonDrag)=="boolean" then perButtonDragEnabled=d.perButtonDrag end
    if type(d.guiTransparencyEnabled)=="boolean" then guiTransparencyEnabled=d.guiTransparencyEnabled end
    if type(d.medusaReset)=="boolean" then medusaResetEnabled=d.medusaReset end
	if type(d.introSoundEnabled)=="boolean" then introSoundEnabled=d.introSoundEnabled end
	if type(d.introEnabled)=="boolean" then introEnabled=d.introEnabled end
    if type(d.clickSoundsEnabled)=="boolean" then clickSoundsEnabled=d.clickSoundsEnabled end
    if type(d.tabPosition)=="string" then
        local savedTabPosition=string.upper(d.tabPosition)
        if savedTabPosition=="LEFT" or savedTabPosition=="RIGHT" or savedTabPosition=="TOP" then tabPosition=savedTabPosition end
    end
    if type(d.navigationStyle)=="string" then
        local savedNavigationStyle=string.upper(d.navigationStyle)
        if savedNavigationStyle=="TABS" or savedNavigationStyle=="SCROLLING" then navigationStyle=savedNavigationStyle end
    end
    if type(d.uiWidth)=="number" then uiWidth=math.clamp(math.floor(d.uiWidth+.5),ConfigShare.minWidth,ConfigShare.maxWidth) end
    if type(d.uiPositionX)=="number" then uiPositionX=math.floor(d.uiPositionX+.5) end
    if type(d.uiPositionY)=="number" then uiPositionY=math.floor(d.uiPositionY+.5) end
    if type(d.searchHistory)=="table" then
        searchHistory={}; for _,entry in ipairs(d.searchHistory) do if type(entry)=="string" and entry~="" and #searchHistory<6 then table.insert(searchHistory,entry) end end
    end
    animEnabled=false
    local savedPack=type(d.animationPack)=="string" and d.animationPack or d.animPack
    if type(savedPack)=="string" then _GACC.extras.setPack(savedPack,false) end
    if type(d.animationPackEnabled)=="boolean" then _GACC.extras.setPackActive(d.animationPackEnabled) end
    if type(d.headlessEnabled)=="boolean" then _GACC.extras.setHeadless(d.headlessEnabled) end
    if type(d.korbloxEnabled)=="boolean" then _GACC.extras.setKorblox(d.korbloxEnabled) end
    if type(d.playerHighlightEnabled)=="boolean" then _GACC.playerHighlightEnabled=d.playerHighlightEnabled end
    if type(d.colorThemeName)=="string" and THEME_DEFS[d.colorThemeName] then currentColorTheme=d.colorThemeName end
    if type(d.themeIntensity)=="number" then themeIntensity=math.clamp(d.themeIntensity,.35,1.5) end
    if type(d.autoSwitchSpeed)=="boolean" then autoSwitchSpeedEnabled=d.autoSwitchSpeed end
    if type(d.autoCarrySpeedEnabled)=="boolean" then _GACC.autoCarrySpeedEnabled=d.autoCarrySpeedEnabled end
    if ConfigShare.mobile and not live then tabPosition="TOP"; navigationStyle="TABS"; uiWidth=ConfigShare.mobileWidth; mobileButtonsEnabled=true end
    if live and _GuiKeys then
        if type(d.keys)=="table" then
            for key,value in pairs(d.keys) do
                local ok,keyCode=pcall(function() return Enum.KeyCode[value] end)
                if ok and keyCode and keyCode~=Enum.KeyCode.Unknown and _GuiKeys[key]~=nil then _GuiKeys[key]=keyCode end
            end
        end
        if type(d.minimizeKey)=="string" then
            local ok,keyCode=pcall(function() return Enum.KeyCode[d.minimizeKey] end)
            if ok and keyCode and keyCode~=Enum.KeyCode.Unknown then _GuiKeys.guiHide=keyCode end
        end
    end
    if live then
        local function safely(action) pcall(action) end
        safely(function() if Steal.AutoStealEnabled then if startAutoSteal then startAutoSteal() end elseif stopAutoSteal then stopAutoSteal() end end)
        safely(function() if antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end end)
        safely(function() if infJumpEnabled and infJumpMode=="hold" then startHoldInfJump() else stopHoldInfJump() end end)
        safely(function() if antiDieFlingEnabled then startAntiDieFling() else stopAntiDieFling() end end)
        safely(function() if medusaCounterEnabled then setupMedusa(LP.Character) else stopMedusaCounter() end end)
        safely(function() if autoTPEnabled then startAutoTP() else stopAutoTP() end end)
        safely(function() if autoBatEnabled then startBatAimbot() else stopBatAimbot() end end)
        safely(function() if batDesyncTpEnabled then startBatDesyncTp() else stopBatDesyncTp() end end)
		safely(function() if not _GACC.autoPlayRemoved and autoLeftEnabled then startAutoLeft() else autoLeftEnabled=false; stopAutoLeft() end end)
		safely(function() if not _GACC.autoPlayRemoved and autoRightEnabled then startAutoRight() else autoRightEnabled=false; stopAutoRight() end end)
        safely(function() if unwalkEnabled then startUnwalk() else stopUnwalk() end end)
        safely(function() if antiLagEnabled then enableAntiLag() else disableAntiLag() end end)
        safely(function() if stretchRezEnabled then enableStretchRez() else disableStretchRez() end end)
        safely(function() if _GACC.playerHighlightEnabled then _GACC.startESP() else _GACC.stopESP() end end)
        safely(function() if _GACC.extras.getPackActive() then _GACC.extras.applyPack(_GACC.extras.getPack(),LP.Character) end end)
        safely(function() _GACC.extras.setHeadless(_GACC.extras.getHeadless(),LP.Character) end)
        safely(function() _GACC.extras.setKorblox(_GACC.extras.getKorblox(),LP.Character) end)
        safely(function() if CandyApplyCustomSky then CandyApplyCustomSky(currentSkyTheme) end end)
        safely(function() if refreshSpeedModeLabel then refreshSpeedModeLabel() end end)
        safely(function() if _GACC.applyLoadedConfigUI then _GACC.applyLoadedConfigUI(d) end end)
    end
end
pcall(function() ConfigShare.apply(ConfigShare.startupConfig,false) end)


pcall(function()
    if _GACC.extras.getPackActive() then task.spawn(function() task.wait(.5); _GACC.extras.applyPack(_GACC.extras.getPack()) end) end
    if _GACC.extras.getHeadless() or _GACC.extras.getKorblox() then task.spawn(function() task.wait(.3); local char=LP.Character; if char then _GACC.extras.onCharacter(char) end end) end
    if antiLagEnabled then task.spawn(function() task.wait(1); if enableAntiLag then enableAntiLag() end end) end
    if stretchRezEnabled then task.spawn(function() task.wait(0.5); if enableStretchRez then enableStretchRez() end end) end
    if antiRagdollEnabled then task.spawn(function() task.wait(0.5); if startAntiRagdoll then startAntiRagdoll() end end) end
    if infJumpEnabled and infJumpMode=="hold" then task.spawn(function() task.wait(0.5); startHoldInfJump() end) end
    if antiDieFlingEnabled then task.spawn(function() task.wait(0.5); if startAntiDieFling then startAntiDieFling() end end) end
    if Steal.AutoStealEnabled then task.spawn(function() task.wait(1); if startAutoSteal then startAutoSteal() end end) end
    if medusaCounterEnabled then task.spawn(function() task.wait(1); local char=LP.Character; if char and setupMedusa then setupMedusa(char) end end) end
    if autoTPEnabled then task.spawn(function() task.wait(0.5); if startAutoTP then startAutoTP() end end) end
    if autoBatEnabled then task.spawn(function() task.wait(.7); startBatAimbot() end) end
    if batDesyncTpEnabled then task.spawn(function() task.wait(.7); startBatDesyncTp() end) end
	if not _GACC.autoPlayRemoved and autoLeftEnabled then task.spawn(function() task.wait(.7); if not _GACC.autoPlayRemoved then startAutoLeft() end end) end
	if not _GACC.autoPlayRemoved and autoRightEnabled then task.spawn(function() task.wait(.7); if not _GACC.autoPlayRemoved then startAutoRight() end end) end
    if unwalkEnabled then task.spawn(function() task.wait(.7); startUnwalk() end) end
    if currentSkyTheme and currentSkyTheme ~= "" then task.spawn(function() task.wait(1); if CandyApplyCustomSky then CandyApplyCustomSky(currentSkyTheme) end end) end
end)


_GACC.GuiToggleSetters = {}


;(function()

    local GuiRefs = {}
    
    local _thm0 = intensityTheme(THEME_DEFS[currentColorTheme] or THEME_DEFS.IMPULSE,themeIntensity)
    local _ACC = {accent=_thm0.accent,accentDark=_thm0.accentDark,accentBg=_thm0.accentBg,accentHover=_thm0.accentHover,accentRowHover=_thm0.accentRowHover}
    
    local _themeSeps,_themeScrollbars,_themeSectRefs,_themeTabBtns={},{},{},{}
    local _themeTabInds,_themeActBtns,_themeKbLabels,_themeSwatchStrokes={},{},{},{}
    local _themeToggleRefs={}  
    local applyColorTheme 
    local applyNavigationLayout
    local applyUIWidth
    local refreshSearchHistoryUI
    local configInputSetters,configSliderSetters,configToggleSetters,configDropdownSetters={},{},{},{}
    function clampUIPosition(x,y)
        local camera=workspace.CurrentCamera
        local viewport=camera and camera.ViewportSize or Vector2.new(1920,1080)
        local maxX=math.max(viewport.X-uiWidth,0)
        local maxY=math.max(viewport.Y-ConfigShare.uiHeight,0)
        x=tonumber(x) or 20; y=tonumber(y) or 60
        return math.clamp(math.floor(x+.5),0,maxX),math.clamp(math.floor(y+.5),0,maxY)
    end
    uiPositionX,uiPositionY=clampUIPosition(uiPositionX,uiPositionY)
    local C={
        bg=_thm0.bg, bgDark=_thm0.bgDark, row=_thm0.row,
        input=_thm0.input, neutral=_ACC.accent, neutralDim=Color3.fromRGB(93,93,93),
        neutralDark=Color3.fromRGB(13,13,13), text=Color3.fromRGB(242,242,242), textDim=Color3.fromRGB(176,176,176),
        textMuted=Color3.fromRGB(103,103,103), white=Color3.fromRGB(255,255,255), divider=_thm0.divider,
        lightGray=Color3.fromRGB(183,183,183),
        brightGray=Color3.fromRGB(212,212,212), midGray=Color3.fromRGB(127,127,127),
        accent=_ACC.accent, accentDark=_ACC.accentDark, accentBg=_ACC.accentBg,
        accentHover=_ACC.accentHover, accentRowHover=_ACC.accentRowHover,
    }

    function guiCorner(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 10);c.Parent=p;return c end
    function guiStroke(p,col,t) local s=Instance.new("UIStroke");s.Color=col or Color3.fromRGB(61,61,61);s.Thickness=t or 1;s.Parent=p;return s end
    function tw(obj,props,ti) TweenService:Create(obj,ti or TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play() end
    
    function _accentGrad(t)
        local a=_ACC.accent; local d=_ACC.accentDark
        local pulse=math.sin(t*0.7)*0.14
        local aR=math.clamp(math.floor(a.R*255*(1+pulse)),0,255)
        local aG=math.clamp(math.floor(a.G*255*(1+pulse)),0,255)
        local aB=math.clamp(math.floor(a.B*255*(1+pulse)),0,255)
        local dR=math.clamp(math.floor(d.R*255*(0.75+pulse*0.25)),0,255)
        local dG=math.clamp(math.floor(d.G*255*(0.75+pulse*0.25)),0,255)
        local dB=math.clamp(math.floor(d.B*255*(0.75+pulse*0.25)),0,255)
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(dR,dG,dB)),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(aR,aG,aB)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.82,Color3.fromRGB(aR,aG,aB)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(dR,dG,dB)),
        })
    end

    function makeDraggable_cyber(dragTarget, moveTarget, onEnded)
        moveTarget = moveTarget or dragTarget
        local dragging, dragInput, dragStart, startPos,dragMoved = false,nil,nil,nil,false
        dragTarget.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true; dragMoved=false; dragStart=input.Position; startPos=moveTarget.Position
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then
                        dragging=false
                        if dragMoved and onEnded then task.defer(onEnded,moveTarget.Position) end
                    end
                end)
            end
        end)
        dragTarget.InputChanged:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
        end)
        UIS.InputChanged:Connect(function(input)
            if input==dragInput and dragging then
                local delta=input.Position-dragStart
                if delta.Magnitude>3 then dragMoved=true end
                moveTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            end
        end)
    end

    local Keys={
        circle=Enum.KeyCode.E, speed=Enum.KeyCode.Q, carryMode=Enum.KeyCode.C,
        laggerToggle=Enum.KeyCode.K, guiHide=Enum.KeyCode.RightControl,
        dropBrainrot=Enum.KeyCode.H, tpDown=Enum.KeyCode.T,
        autoLeft=Enum.KeyCode.J, autoRight=Enum.KeyCode.L,
        batDesyncTp=Enum.KeyCode.X
    }

    pcall(function()
        local d=ConfigShare.startupConfig
        if type(d)=="table" then
            if type(d.keys)=="table" then
                for k,v in pairs(d.keys) do
                    local ok2,kc=pcall(function() return Enum.KeyCode[v] end)
                    if v=="NONE" or v=="None" then
                        if Keys[k]~=nil then Keys[k]=Enum.KeyCode.Unknown end
                    elseif ok2 and kc and kc~=Enum.KeyCode.Unknown then
                        Keys[k]=kc
                    end
                end
            end
            if type(d.minimizeKey)=="string" then
                local ok2,kc=pcall(function() return Enum.KeyCode[d.minimizeKey] end)
                if ok2 and kc and kc~=Enum.KeyCode.Unknown then Keys.guiHide=kc end
            end
        end
    end)
    _GuiKeys = Keys

    
    local PlayerGui = LP:WaitForChild("PlayerGui")

    local GuiHub=Instance.new("ScreenGui")
    GuiHub.Name="N5 Duels"; GuiHub.ResetOnSpawn=false
    GuiHub.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; parentGui(GuiHub)
    -- The Sammy build uses this file as a logic backend; its own GUI stays hidden.
    GuiHub.Enabled=false
    GuiRefs.hub=GuiHub

    local UI_CLICK_SOUND_ID="rbxassetid://102702078778790"
    local KEYBIND_SOUND_ID="rbxassetid://113108830240353"
    function playImpulseClick(fromKeybind)
        if not clickSoundsEnabled then return end
        local sound=Instance.new("Sound")
        sound.Name=fromKeybind and "ImpulseKeybindSound" or "ImpulseClickSound"
        sound.SoundId=fromKeybind and KEYBIND_SOUND_ID or UI_CLICK_SOUND_ID
        sound.Volume=fromKeybind and .55 or .42
        sound.PlaybackSpeed=1; sound.Parent=SoundService
        local ok=pcall(function() sound:Play() end)
        task.delay(ok and 4 or .1,function() if sound then pcall(function() sound:Destroy() end) end end)
    end
    GuiRefs.playClickSound=playImpulseClick
    _GACC.playClickSound=playImpulseClick

    local Outer=Instance.new("Frame")
    Outer.Name="Outer"; Outer.Size=UDim2.new(0,uiWidth,0,ConfigShare.uiHeight); Outer.Position=UDim2.new(0,uiPositionX,0,uiPositionY+16)
    Outer.BackgroundTransparency=1; Outer.BorderSizePixel=0; Outer.ClipsDescendants=true; Outer.Parent=GuiHub
    Outer:GetPropertyChangedSignal("Size"):Connect(function()
        local expected=UDim2.fromOffset(uiWidth,ConfigShare.uiHeight)
        if Outer.Size~=expected then Outer.Size=expected end
    end)
    GuiRefs.outer=Outer

    local Inner=Instance.new("Frame")
    Inner.Name="Inner"; Inner.ClipsDescendants=true; Inner.Size=UDim2.new(1,0,1,0)
    Inner.BackgroundColor3=C.bg; Inner.BackgroundTransparency=1; Inner.BorderSizePixel=0; Inner.Parent=Outer
    innerPanelRef=Inner
    guiCorner(Inner,12)
    local _innerStroke=guiStroke(Inner,_ACC.accentDark,1.5); GuiRefs.inner=Inner
    _innerStroke.Color=_ACC.accentDark
    _innerStroke.Thickness=1.2
    local innerPulseRail=Instance.new("Frame",Inner)
    innerPulseRail.Name="ContainedPulseRail"; innerPulseRail.Position=UDim2.fromOffset(2,18); innerPulseRail.Size=UDim2.new(0,2,1,-36)
    innerPulseRail.BackgroundColor3=_ACC.accent; innerPulseRail.BackgroundTransparency=.18; innerPulseRail.BorderSizePixel=0; innerPulseRail.ZIndex=9
    guiCorner(innerPulseRail,2)
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function() innerPulseRail.BackgroundColor3=thm.accent end) end})
    local startupVeil=Instance.new("Frame",Inner)
    startupVeil.Name="StartupReveal"; startupVeil.Size=UDim2.fromScale(1,1); startupVeil.BackgroundColor3=Color3.fromRGB(1,1,1)
    startupVeil.BackgroundTransparency=.04; startupVeil.BorderSizePixel=0; startupVeil.ZIndex=100; guiCorner(startupVeil,14)
    task.defer(function()
        TweenService:Create(Outer,TweenInfo.new(.46,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.new(0,uiPositionX,0,uiPositionY)}):Play()
        local reveal=TweenService:Create(startupVeil,TweenInfo.new(.34,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=1})
        reveal:Play(); reveal.Completed:Connect(function() if startupVeil then startupVeil:Destroy() end end)
    end)
    local cornerL=Instance.new("Frame",Inner)
    cornerL.Size=UDim2.new(0,18,0,2); cornerL.Position=UDim2.new(0,8,1,-9)
    cornerL.BackgroundColor3=_GACC.accentDark; cornerL.BackgroundTransparency=0.25; cornerL.BorderSizePixel=0; cornerL.ZIndex=10; cornerL.Visible=false
    local cornerLV=Instance.new("Frame",Inner)
    cornerLV.Size=UDim2.new(0,2,0,8); cornerLV.Position=UDim2.new(0,8,1,-15)
    cornerLV.BackgroundColor3=_GACC.accentDark; cornerLV.BackgroundTransparency=0.25; cornerLV.BorderSizePixel=0; cornerLV.ZIndex=10; cornerLV.Visible=false
    local cornerR=Instance.new("Frame",Inner)
    cornerR.Size=UDim2.new(0,18,0,2); cornerR.Position=UDim2.new(1,-26,1,-9)
    cornerR.BackgroundColor3=_GACC.accentDark; cornerR.BackgroundTransparency=0.25; cornerR.BorderSizePixel=0; cornerR.ZIndex=10; cornerR.Visible=false
    local cornerRV=Instance.new("Frame",Inner)
    cornerRV.Size=UDim2.new(0,2,0,8); cornerRV.Position=UDim2.new(1,-10,1,-15)
    cornerRV.BackgroundColor3=_GACC.accentDark; cornerRV.BackgroundTransparency=0.25; cornerRV.BorderSizePixel=0; cornerRV.ZIndex=10; cornerRV.Visible=false
    table.insert(_themeExtRefs,{callback=function(thm)
        pcall(function()
            cornerL.BackgroundColor3=thm.accentDark; cornerLV.BackgroundColor3=thm.accentDark
            cornerR.BackgroundColor3=thm.accentDark; cornerRV.BackgroundColor3=thm.accentDark
        end)
    end})
    task.spawn(function()
        local bright=false
        while Inner and Inner.Parent do
            bright=not bright
            TweenService:Create(_innerStroke,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
                Transparency=bright and .34 or .68,
                Color=bright and _GACC.accent or _GACC.accentDark
            }):Play()
            task.wait(1.4)
        end
    end)
    do 
    local BgCont=Instance.new("Frame")
    BgCont.Name="BackgroundContainer"; BgCont.Size=UDim2.new(1,0,1,0)
    BgCont.BackgroundTransparency=1; BgCont.ZIndex=0; BgCont.ClipsDescendants=true; BgCont.Parent=Inner

    local BgGrad=Instance.new("Frame")
    BgGrad.Name="BgGrad"; BgGrad.Size=UDim2.new(1,0,1,0); BgGrad.BackgroundColor3=C.bgDark
    BgGrad.BackgroundTransparency=.30; BgGrad.BorderSizePixel=0; BgGrad.ZIndex=0; BgGrad.Parent=BgCont; guiCorner(BgGrad,12)
    bgGradientRef=BgGrad
    GuiRefs.bgGrad=BgGrad
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function()
        BgGrad.BackgroundColor3=thm.bgDark
    end) end})

    local HF=Instance.new("Frame")
    HF.Name="HeaderFrame"; HF.Size=UDim2.new(1,0,0,64); HF.BackgroundTransparency=1
    HF.BorderSizePixel=0; HF.Parent=Inner; HF.ZIndex=2
    makeDraggable_cyber(HF,Outer,function(position)
        uiPositionX,uiPositionY=clampUIPosition(position.X.Offset,position.Y.Offset)
        Outer.Position=UDim2.fromOffset(uiPositionX,uiPositionY)
        if saveConfig then saveConfig() end
    end)

    do
        local headerPlate=Instance.new("Frame",HF)
        headerPlate.Name="PrivateHeaderPlate"; headerPlate.Position=UDim2.new(0,6,0,5); headerPlate.Size=UDim2.new(1,-12,0,51)
        headerPlate.BackgroundColor3=Color3.fromRGB(6,6,6); headerPlate.BackgroundTransparency=.76; headerPlate.BorderSizePixel=0; headerPlate.ZIndex=2
        guiCorner(headerPlate,9)
        local plateStroke=guiStroke(headerPlate,_ACC.accentDark,1); plateStroke.Transparency=.46
        local topLine=Instance.new("Frame",HF)
        topLine.Position=UDim2.new(0,24,0,6); topLine.Size=UDim2.new(0,88,0,1); topLine.BackgroundColor3=_ACC.accent; topLine.BackgroundTransparency=.42; topLine.BorderSizePixel=0; topLine.ZIndex=3
        guiCorner(topLine,2)
        table.insert(_themeExtRefs,{callback=function(thm) pcall(function()
            topLine.BackgroundColor3=thm.accent; headerPlate.BackgroundColor3=thm.bg
            plateStroke.Color=thm.accentDark
        end) end})
    end

    local TL=Instance.new("TextLabel")
    TL.Position=UDim2.new(0,22,0,11); TL.Size=UDim2.new(0,190,0,24); TL.BackgroundTransparency=1
    TL.RichText=true; TL.Text='N5  /  DUELS'; TL.TextColor3=C.text; TL.TextSize=16; TL.Font=Enum.Font.GothamBold
    TL.TextXAlignment=Enum.TextXAlignment.Left; TL.Parent=HF; TL.ZIndex=3
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function() TL.TextColor3=thm.accent end) end})
    task.spawn(function()
            local titleStates={"ANTI-SAMMY","A N T I-SAMMY","ANTI-SAMMY / NEBULA","ANTI-SAMMY / NEBULA"}
        while TL and TL.Parent do
            task.wait(5)
            for index=1,#titleStates do TL.Text=titleStates[index]; task.wait(.08) end
            task.wait(1.4)
            for index=#titleStates-1,1,-1 do TL.Text=titleStates[index]; task.wait(.07) end
            TL.Text="N5  /  DUELS"
        end
    end)

    local hFpsLbl=Instance.new("TextLabel")
    hFpsLbl.Size=UDim2.new(0,175,0,13); hFpsLbl.Position=UDim2.new(0,14,0,48)
    hFpsLbl.BackgroundTransparency=1; hFpsLbl.Text=""; hFpsLbl.Visible=false
    hFpsLbl.TextColor3=Color3.fromRGB(160,160,160); hFpsLbl.Font=Enum.Font.FredokaOne
    hFpsLbl.TextSize=9; hFpsLbl.TextXAlignment=Enum.TextXAlignment.Left
    hFpsLbl.ZIndex=3; hFpsLbl.Parent=HF
    do
        local RING_SZ=20; local ring={}; for i=1,RING_SZ do ring[i]=1/60 end
        local ridx=1; local rsum=RING_SZ/60; local cpng=0
        task.spawn(function()
            while hFpsLbl and hFpsLbl.Parent do
                pcall(function() cpng=math.floor(Players.LocalPlayer:GetNetworkPing()*1000) end)
                task.wait(0.5)
            end
        end)
        RunService.RenderStepped:Connect(function(dt)
            rsum=rsum-ring[ridx]+dt; ring[ridx]=dt; ridx=ridx%RING_SZ+1
            local fps=math.floor(1/math.max(rsum/RING_SZ,0.001))
            _perfFps=fps; _perfPing=cpng
            local fc; if fps>=55 then fc=Color3.fromRGB(179,179,179) elseif fps>=30 then fc=Color3.fromRGB(193,193,193) else fc=Color3.fromRGB(113,113,113) end
            local pc; if cpng<80 then pc=Color3.fromRGB(179,179,179) elseif cpng<150 then pc=Color3.fromRGB(193,193,193) else pc=Color3.fromRGB(113,113,113) end
            if hFpsLbl and hFpsLbl.Parent then
                hFpsLbl.Text="FPS: "..tostring(fps).." | PING: "..tostring(cpng).."ms"
                
                
                local worstR=math.min(fc.R,pc.R); local worstG=math.min(fc.G,pc.G); local worstB=math.min(fc.B,pc.B)
                hFpsLbl.TextColor3=Color3.fromRGB(math.max(worstR*255,0),math.max(worstG*255,0),math.max(worstB*255,0))
            end
        end)
    end

    
    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Size=UDim2.new(0,26,0,26); CloseBtn.Position=UDim2.new(1,-36,0,8)
    CloseBtn.BackgroundColor3=C.bgDark; CloseBtn.BackgroundTransparency=1; CloseBtn.BorderSizePixel=0
    CloseBtn.Text="-"; CloseBtn.TextColor3=C.textMuted; CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.TextSize=14
    CloseBtn.ZIndex=5; CloseBtn.Parent=HF
    guiCorner(CloseBtn,7); local closeBtnStroke=guiStroke(CloseBtn,Color3.fromRGB(94,94,94),1);closeBtnStroke.Transparency=.72
    CloseBtn.MouseEnter:Connect(function()
        tw(CloseBtn,{TextColor3=Color3.fromRGB(142,142,142),BackgroundTransparency=1})
        tw(closeBtnStroke,{Transparency=.38})
    end)
    CloseBtn.MouseLeave:Connect(function()
        tw(CloseBtn,{TextColor3=C.textMuted,BackgroundTransparency=1})
        tw(closeBtnStroke,{Transparency=.72})
    end)

    
    local MiniBtn=Instance.new("TextButton")
    MiniBtn.Size=UDim2.new(0,120,0,30); MiniBtn.Position=UDim2.new(0,20,0,100)
    MiniBtn.BackgroundColor3=C.bgDark; MiniBtn.BackgroundTransparency=1; MiniBtn.BorderSizePixel=0
    MiniBtn.RichText=true; MiniBtn.Text='N5 Duels'; MiniBtn.TextColor3=C.text; MiniBtn.Font=Enum.Font.GothamBold; MiniBtn.TextSize=11
    MiniBtn.ZIndex=20; MiniBtn.Visible=false; MiniBtn.Parent=GuiRefs.hub
    guiCorner(MiniBtn,8); local miniBtnStroke=guiStroke(MiniBtn,Color3.fromRGB(94,94,94),1.2);miniBtnStroke.Transparency=.72
    makeDraggable_cyber(MiniBtn, MiniBtn)
    MiniBtn.MouseEnter:Connect(function() 
        tw(MiniBtn,{BackgroundTransparency=1})
        tw(miniBtnStroke,{Transparency=.38})
    end)
    MiniBtn.MouseLeave:Connect(function() 
        tw(MiniBtn,{BackgroundTransparency=1})
        tw(miniBtnStroke,{Transparency=.72})
    end)
    local minimizeToken=0
    function showGui()
        minimizeToken=minimizeToken+1
        uiPositionX,uiPositionY=clampUIPosition(uiPositionX,uiPositionY)
        MiniBtn.Visible=false; Outer.Visible=true
        Outer.Position=UDim2.new(0,uiPositionX-60,0,uiPositionY)
        TweenService:Create(Outer,TweenInfo.new(0.38,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.new(0,uiPositionX,0,uiPositionY)}):Play()
    end
    function hideGui()
        minimizeToken=minimizeToken+1; local token=minimizeToken
        TweenService:Create(Outer,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(0,-(uiWidth+40),0,uiPositionY)}):Play()
        task.delay(0.3,function() if token==minimizeToken then Outer.Visible=false; MiniBtn.Visible=true end end)
    end
    GuiRefs.minimize=hideGui; GuiRefs.restore=showGui; GuiRefs.mini=MiniBtn
    CloseBtn.MouseButton1Click:Connect(hideGui)
    MiniBtn.MouseButton1Click:Connect(showGui)

    end 

    
    do local HSep=Instance.new("Frame")
    HSep.Position=UDim2.new(0,0,0,64); HSep.Size=UDim2.new(1,0,0,1); HSep.BorderSizePixel=0
    HSep.BackgroundColor3=_ACC.accentDark; HSep.BackgroundTransparency=.82
    HSep.Parent=Inner; HSep.ZIndex=4
    end 

    
    local CF=Instance.new("ScrollingFrame")
    CF.Name="ContentFrame"; CF.Size=UDim2.new(1,-108,1,-176); CF.Position=UDim2.new(0,98,0,138)
    CF.BackgroundTransparency=1; CF.BorderSizePixel=0; CF.ScrollBarThickness=0; CF.ScrollBarImageColor3=C.neutral
    table.insert(_themeScrollbars,CF)
    CF.CanvasSize=UDim2.new(0,0,0,0); CF.AutomaticCanvasSize=Enum.AutomaticSize.None
    CF.ScrollingDirection=Enum.ScrollingDirection.Y; CF.ScrollingEnabled=true; CF.Active=true
    CF.ElasticBehavior=Enum.ElasticBehavior.Never; CF.Parent=Inner; GuiRefs.contentFrame=CF
    local scrollTrack=Instance.new("Frame",Inner)
    scrollTrack.Size=UDim2.new(0,2,1,-184); scrollTrack.Position=UDim2.new(1,-5,0,142)
    scrollTrack.BackgroundColor3=Color3.fromRGB(29,29,29); scrollTrack.BackgroundTransparency=.74
    scrollTrack.BorderSizePixel=0; scrollTrack.ZIndex=8; scrollTrack.Visible=false; guiCorner(scrollTrack,2)
    local scrollFill=Instance.new("Frame",scrollTrack)
    scrollFill.Size=UDim2.new(1,0,0.15,0); scrollFill.BackgroundColor3=_ACC.accent
    scrollFill.BackgroundTransparency=0.1; scrollFill.BorderSizePixel=0; scrollFill.ZIndex=9; guiCorner(scrollFill,2)
    local scrollFadeToken=0
    function updateScrollRail()
        local total=CF.AbsoluteCanvasSize.Y
        local visible=CF.AbsoluteWindowSize.Y
        local ratio=math.clamp(visible/math.max(total,1),0.08,1)
        local progress=math.clamp(CF.CanvasPosition.Y/math.max(total-visible,1),0,1)
        scrollFill.Size=UDim2.new(1,0,ratio,0)
        scrollFill.Position=UDim2.new(0,0,progress*(1-ratio),0)
        if total<=visible+2 then scrollTrack.Visible=false end
    end
    function revealScrollRail()
        local total=CF.AbsoluteCanvasSize.Y
        local visible=CF.AbsoluteWindowSize.Y
        if total<=visible+2 then scrollTrack.Visible=false; return end
        scrollFadeToken=scrollFadeToken+1
        local token=scrollFadeToken
        scrollTrack.Visible=true
        TweenService:Create(scrollTrack,TweenInfo.new(.12),{BackgroundTransparency=.58}):Play()
        TweenService:Create(scrollFill,TweenInfo.new(.12),{BackgroundTransparency=.02}):Play()
        task.delay(.8,function()
            if token~=scrollFadeToken or not scrollTrack.Parent then return end
            TweenService:Create(scrollTrack,TweenInfo.new(.24),{BackgroundTransparency=1}):Play()
            local fade=TweenService:Create(scrollFill,TweenInfo.new(.24),{BackgroundTransparency=1})
            fade:Play(); fade.Completed:Connect(function() if token==scrollFadeToken then scrollTrack.Visible=false end end)
        end)
    end
    CF:GetPropertyChangedSignal("CanvasPosition"):Connect(function() updateScrollRail(); revealScrollRail() end)
    CF:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateScrollRail)
    CF:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateScrollRail)
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function() scrollFill.BackgroundColor3=thm.accent end) end})
    task.defer(updateScrollRail)
    do
    local CPad=Instance.new("UIPadding"); CPad.PaddingLeft=UDim.new(0,0); CPad.PaddingRight=UDim.new(0,0)
    CPad.PaddingTop=UDim.new(0,4); CPad.PaddingBottom=UDim.new(0,8); CPad.Parent=CF
    end 

    
    
    local SidebarDiv=Instance.new("Frame",Inner)
    SidebarDiv.Name="SidebarDiv"
    SidebarDiv.Size=UDim2.new(0,1,0,112); SidebarDiv.Position=UDim2.new(0,90,0,72)
    SidebarDiv.BackgroundColor3=_ACC.accentDark; SidebarDiv.BackgroundTransparency=.48
    SidebarDiv.BorderSizePixel=0; SidebarDiv.ZIndex=3; SidebarDiv.Visible=true
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function() SidebarDiv.BackgroundColor3=thm.accentDark end) end})
    local TabRail=Instance.new("Frame",Inner)
    TabRail.Name="TabRail"
    TabRail.Size=UDim2.new(0,74,0,112); TabRail.Position=UDim2.new(0,10,0,72)
    TabRail.BackgroundColor3=Color3.fromRGB(4,4,4); TabRail.BackgroundTransparency=.58
    TabRail.BorderSizePixel=0; TabRail.ZIndex=5; TabRail.ClipsDescendants=true; TabRail.Visible=true
    guiCorner(TabRail,8); local tabRailStroke=guiStroke(TabRail,_ACC.accentDark,1); tabRailStroke.Transparency=.64
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function() tabRailStroke.Color=thm.accentDark end) end})
    do
        local rLay=Instance.new("UIListLayout",TabRail)
        rLay.FillDirection=Enum.FillDirection.Vertical
        rLay.SortOrder=Enum.SortOrder.LayoutOrder
        rLay.HorizontalAlignment=Enum.HorizontalAlignment.Center
        rLay.VerticalAlignment=Enum.VerticalAlignment.Center
        rLay.Padding=UDim.new(0,4)
    end

    local StatusBar=Instance.new("Frame",Inner)
    StatusBar.Name="StatusStrip"; StatusBar.Position=UDim2.new(0,98,0,72); StatusBar.Size=UDim2.new(1,-108,0,24)
    StatusBar.BackgroundColor3=Color3.fromRGB(5,5,7); StatusBar.BackgroundTransparency=.38; StatusBar.BorderSizePixel=0; StatusBar.ZIndex=5
    guiCorner(StatusBar,7); local statusBarStroke=guiStroke(StatusBar,_ACC.accentDark,1); statusBarStroke.Transparency=.62
    local statusLayout=Instance.new("UIListLayout",StatusBar)
    statusLayout.FillDirection=Enum.FillDirection.Horizontal; statusLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    statusLayout.VerticalAlignment=Enum.VerticalAlignment.Center; statusLayout.Padding=UDim.new(0,5)
    local statusLabels={}
    function makeStatusChip(key)
        local chip=Instance.new("Frame",StatusBar)
        chip.Name=key.."Chip"; chip.Size=UDim2.new(.25,-5,1,0); chip.BackgroundTransparency=1
        chip.BorderSizePixel=0
        local dot=Instance.new("Frame",chip); dot.Size=UDim2.fromOffset(3,3); dot.Position=UDim2.new(0,6,.5,-1)
        dot.BackgroundColor3=_ACC.accent; dot.BackgroundTransparency=.18; dot.BorderSizePixel=0; guiCorner(dot,2)
        local label=Instance.new("TextLabel",chip)
        label.Size=UDim2.new(1,-14,1,0); label.Position=UDim2.new(0,12,0,0); label.BackgroundTransparency=1
        label.Text=key.." --"; label.TextColor3=Color3.fromRGB(179,179,179); label.Font=Enum.Font.FredokaOne
        label.TextSize=8; label.TextXAlignment=Enum.TextXAlignment.Left; label.TextTruncate=Enum.TextTruncate.AtEnd
        statusLabels[key]=label
        table.insert(_themeExtRefs,{callback=function(thm) pcall(function() dot.BackgroundColor3=thm.accent; statusBarStroke.Color=thm.accentDark end) end})
    end
    for _,key in ipairs({"SPD","FPS","PING","MODE"}) do makeStatusChip(key) end

    task.spawn(function()
        while StatusBar and StatusBar.Parent do
            local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
            local velocity=hrp and hrp.AssemblyLinearVelocity or Vector3.zero
            local horizontalSpeed=Vector3.new(velocity.X,0,velocity.Z).Magnitude
            local fps=tonumber(_perfFps) or 0; local ping=tonumber(_perfPing) or 0
            statusLabels.SPD.Text=string.format("SPD %.0f",horizontalSpeed)
            statusLabels.FPS.Text="FPS "..tostring(fps)
            statusLabels.PING.Text=tostring(ping).." MS"
            local mode
            if laggerModeEnabled then mode=carrySpeedActive and "LAG CARRY" or "LAGGER"
            elseif carrySpeedActive then mode="CARRY" else mode="NORMAL" end
            statusLabels.MODE.Text=mode
            local muted=_ACC.accentDark:Lerp(Color3.fromRGB(92,92,96),.48); local soft=_ACC.accent:Lerp(Color3.fromRGB(232,232,236),.52)
            local speedRatio=math.clamp(horizontalSpeed/math.max(getActiveMoveSpeed(),1),0,1)
            local fpsRatio=math.clamp((fps-20)/40,0,1)
            local pingRatio=1-math.clamp((ping-45)/180,0,1)
            local function statusColor(ratio) return muted:Lerp(soft,ratio*.38):Lerp(_ACC.accent,ratio*.62) end
            statusLabels.SPD.TextColor3=statusLabels.SPD.TextColor3:Lerp(statusColor(speedRatio),.22)
            statusLabels.FPS.TextColor3=statusLabels.FPS.TextColor3:Lerp(statusColor(fpsRatio),.22)
            statusLabels.PING.TextColor3=statusLabels.PING.TextColor3:Lerp(statusColor(pingRatio),.22)
            statusLabels.MODE.TextColor3=statusLabels.MODE.TextColor3:Lerp(mode=="NORMAL" and soft or _ACC.accent,.22)
            task.wait(.2)
        end
    end)

    local SearchFrame=Instance.new("Frame",Inner)
    SearchFrame.Name="SearchBar"; SearchFrame.Position=UDim2.new(0,98,0,104); SearchFrame.Size=UDim2.new(1,-108,0,26)
    SearchFrame.BackgroundColor3=Color3.fromRGB(5,5,5); SearchFrame.BackgroundTransparency=.08
    SearchFrame.BorderSizePixel=0; SearchFrame.ZIndex=6; guiCorner(SearchFrame,8)
    local searchStroke=guiStroke(SearchFrame,_ACC.accentDark,1); searchStroke.Transparency=.48
    local searchAccent=Instance.new("Frame",SearchFrame)
    searchAccent.Size=UDim2.new(0,3,0,14); searchAccent.Position=UDim2.new(0,9,.5,-7)
    searchAccent.BackgroundColor3=_ACC.accent; searchAccent.BorderSizePixel=0; guiCorner(searchAccent,2)
    local SearchBox=Instance.new("TextBox",SearchFrame)
    SearchBox.Size=UDim2.new(1,-31,1,0); SearchBox.Position=UDim2.new(0,23,0,0); SearchBox.BackgroundTransparency=1
    SearchBox.Text=""; SearchBox.PlaceholderText="Search current tab"; SearchBox.PlaceholderColor3=Color3.fromRGB(113,113,113)
    SearchBox.TextColor3=Color3.fromRGB(233,233,233); SearchBox.Font=Enum.Font.FredokaOne; SearchBox.TextSize=10
    SearchBox.TextXAlignment=Enum.TextXAlignment.Left; SearchBox.ClearTextOnFocus=false; SearchBox.ZIndex=7
    SearchBox.Focused:Connect(function() tw(SearchFrame,{BackgroundColor3=_ACC.accentBg,BackgroundTransparency=.02}); searchStroke.Color=_ACC.accent end)
    SearchBox.FocusLost:Connect(function() tw(SearchFrame,{BackgroundColor3=Color3.fromRGB(5,5,5),BackgroundTransparency=.08}); searchStroke.Color=_ACC.accentDark end)
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function() searchAccent.BackgroundColor3=thm.accent; searchStroke.Color=thm.accentDark end) end})

    local searchHistoryPanel=Instance.new("Frame",SearchFrame)
    searchHistoryPanel.Name="SearchHistory"; searchHistoryPanel.Position=UDim2.new(0,0,1,4); searchHistoryPanel.Size=UDim2.new(1,0,0,110)
    searchHistoryPanel.BackgroundColor3=Color3.fromRGB(5,4,7); searchHistoryPanel.BackgroundTransparency=.02
    searchHistoryPanel.BorderSizePixel=0; searchHistoryPanel.ZIndex=31; searchHistoryPanel.Visible=false; searchHistoryPanel.ClipsDescendants=true
    guiCorner(searchHistoryPanel,9); local historyStroke=guiStroke(searchHistoryPanel,_ACC.accentDark,1); historyStroke.Transparency=.24
    local historyTitle=Instance.new("TextLabel",searchHistoryPanel)
    historyTitle.Size=UDim2.new(1,-16,0,20); historyTitle.Position=UDim2.fromOffset(8,2); historyTitle.BackgroundTransparency=1
    historyTitle.Text="RECENT SEARCHES"; historyTitle.TextColor3=C.textMuted; historyTitle.TextSize=8; historyTitle.Font=Enum.Font.FredokaOne
    historyTitle.TextXAlignment=Enum.TextXAlignment.Left; historyTitle.ZIndex=32
    local historyButtons={}
    for index=1,4 do
        local button=Instance.new("TextButton",searchHistoryPanel)
        button.Size=UDim2.new(1,-12,0,19); button.Position=UDim2.fromOffset(6,20+(index-1)*21)
        button.BackgroundColor3=C.row; button.BackgroundTransparency=.12; button.BorderSizePixel=0
        button.Text=""; button.TextColor3=C.textDim; button.TextSize=9; button.Font=Enum.Font.FredokaOne
        button.TextXAlignment=Enum.TextXAlignment.Left; button.ZIndex=32; button.Visible=false; guiCorner(button,5)
        local padding=Instance.new("UIPadding",button); padding.PaddingLeft=UDim.new(0,8); padding.PaddingRight=UDim.new(0,8)
        button.MouseButton1Click:Connect(function()
            if button.Text~="" then SearchBox.Text=button.Text; searchHistoryPanel.Visible=false end
        end)
        historyButtons[index]=button
    end
    refreshSearchHistoryUI=function()
        for index,button in ipairs(historyButtons) do
            local value=searchHistory[index]
            button.Text=value or ""; button.Visible=value~=nil
        end
    end
    function addSearchHistory(value)
        value=tostring(value or ""):gsub("^%s+",""):gsub("%s+$","")
        if value=="" then return end
        for index=#searchHistory,1,-1 do if string.lower(searchHistory[index])==string.lower(value) then table.remove(searchHistory,index) end end
        table.insert(searchHistory,1,value); while #searchHistory>6 do table.remove(searchHistory) end
        refreshSearchHistoryUI(); if saveConfig then saveConfig() end
    end
    SearchBox.Focused:Connect(function()
        refreshSearchHistoryUI(); searchHistoryPanel.Visible=SearchBox.Text=="" and #searchHistory>0
    end)
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchHistoryPanel.Visible=SearchBox:IsFocused() and SearchBox.Text=="" and #searchHistory>0
    end)
    SearchBox.FocusLost:Connect(function()
        if SearchBox.Text~="" then addSearchHistory(SearchBox.Text) end
        task.delay(.12,function() if not SearchBox:IsFocused() then searchHistoryPanel.Visible=false end end)
    end)
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function()
        historyStroke.Color=thm.accentDark; searchHistoryPanel.BackgroundColor3=thm.bg
        for _,button in ipairs(historyButtons) do button.BackgroundColor3=thm.row end
    end) end})
    refreshSearchHistoryUI()

    local Footer=Instance.new("Frame",Inner)
    Footer.Name="Footer"; Footer.Position=UDim2.new(0,10,1,-29); Footer.Size=UDim2.new(1,-20,0,20)
    Footer.BackgroundTransparency=1; Footer.BorderSizePixel=0; Footer.ZIndex=5
    guiCorner(Footer,7); local footerStroke=guiStroke(Footer,Color3.fromRGB(30,30,30),1); footerStroke.Transparency=1
    local versionLabel=Instance.new("TextLabel",Footer)
    versionLabel.Size=UDim2.new(.5,-8,1,0); versionLabel.Position=UDim2.new(0,8,0,0); versionLabel.BackgroundTransparency=1
    versionLabel.Text=""; versionLabel.TextColor3=Color3.fromRGB(145,136,180)
    versionLabel.Font=Enum.Font.GothamBold; versionLabel.TextSize=8; versionLabel.TextXAlignment=Enum.TextXAlignment.Left
    local statusFooter=Instance.new("TextLabel",Footer)
    statusFooter.Size=UDim2.new(.5,-8,1,0); statusFooter.Position=UDim2.new(.5,0,0,0); statusFooter.BackgroundTransparency=1
    statusFooter.Text=""; statusFooter.TextColor3=_ACC.accent
    statusFooter.Font=Enum.Font.GothamBold; statusFooter.TextSize=8; statusFooter.TextXAlignment=Enum.TextXAlignment.Right
    statusFooter.TextTruncate=Enum.TextTruncate.AtEnd
    table.insert(_themeExtRefs,{callback=function(thm) pcall(function() footerStroke.Color=thm.accentDark; statusFooter.TextColor3=thm.accent end) end})

    
    local KeyListen={cb=nil,label=nil,active=false,suppressUntil=0}
    local KEY_ALIASES={
        ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",ButtonR1="RB",ButtonR2="RT",ButtonL1="LB",ButtonL2="LT",
        DPadUp="D-Up",DPadDown="D-Down",DPadLeft="D-Left",DPadRight="D-Right",ButtonStart="Start",ButtonSelect="Select",
        LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",
        LeftSuper="LSuper",RightSuper="RSuper",Return="Enter",BackSpace="Backspace",Tab="Tab",CapsLock="CapsLock",
        Escape="Esc",Space="Space",PageUp="PgUp",PageDown="PgDn",End="End",Home="Home",Insert="Ins",Delete="Del",
        Up="Up",Down="Down",Left="Left",Right="Right",F1="F1",F2="F2",F3="F3",F4="F4",F5="F5",F6="F6",F7="F7",F8="F8",
        F9="F9",F10="F10",F11="F11",F12="F12",Print="PrtScn",ScrollLock="ScrLk",Pause="Pause",
        Minus="-",Equals="=",LeftBracket="[",RightBracket="]",BackSlash="\\",Semicolon=";",Quote="'",
        Comma=",",Period=".",Slash="/",Backquote="`"
    }
    function prettyKey(kc)
        if not kc or kc==Enum.KeyCode.Unknown then return "NONE" end
        local name=typeof(kc)=="EnumItem" and kc.Name or tostring(kc)
        return KEY_ALIASES[name] or name
    end
    function cancelKL()
        if KeyListen.label then KeyListen.label.BackgroundColor3=C.neutral; KeyListen.label.BackgroundTransparency=0.5 end
        KeyListen.cb=nil; KeyListen.label=nil; KeyListen.active=false
    end
    function startKL(lbl,onSet)
        cancelKL(); local originalText=lbl.Text; KeyListen.cb=onSet; KeyListen.label=lbl; KeyListen.active=true
        lbl.Text="..."; lbl.BackgroundColor3=Color3.fromRGB(183,183,183); lbl.BackgroundTransparency=0.3
        local cap=lbl; task.delay(8,function() if KeyListen.label==cap and KeyListen.active then cancelKL(); if lbl and lbl.Parent then lbl.Text=originalText; lbl.BackgroundColor3=C.neutral; lbl.BackgroundTransparency=0.5 end end end)
    end
	UIS.InputBegan:Connect(function(inp,gp)
		if not KeyListen.active then return end
		local ut=inp.UserInputType
		local k=inp.KeyCode
		if k==Enum.KeyCode.Unknown then return end
		if k.Name=="Thumbstick1" or k.Name=="Thumbstick2" then return end
		if ut~=Enum.UserInputType.Keyboard and not tostring(ut):find("Gamepad") and not k.Name:match("^Button") and not k.Name:match("^DPad") then return end
        if k==Enum.KeyCode.Escape then cancelKL(); return end
        local cb=KeyListen.cb; local lb=KeyListen.label; cancelKL(); KeyListen.suppressUntil=tick()+.2
        if lb and lb.Parent then lb.Text=prettyKey(k); lb.BackgroundColor3=C.neutral; lb.BackgroundTransparency=0.5 end
        if cb then task.spawn(cb,k) end
    end)

    
    function addSectLbl(parent,text,order)
        local w=Instance.new("Frame",parent); w.Size=UDim2.new(1,0,0,26); w.BackgroundTransparency=1; w.LayoutOrder=order
        local L=Instance.new("TextLabel",w); L.Size=UDim2.new(1,0,0,22); L.BackgroundTransparency=1
        L.Text=text; L.TextColor3=C.textDim; L.TextSize=12; L.Font=Enum.Font.FredokaOne; L.TextXAlignment=Enum.TextXAlignment.Left
        return L
    end

    
    function mkSection(parent,title,order)
        local outer=Instance.new("Frame",parent); outer.LayoutOrder=order; outer.Size=UDim2.new(1,0,0,0); outer.AutomaticSize=Enum.AutomaticSize.Y; outer.BackgroundTransparency=1; outer.BorderSizePixel=0
        outer:SetAttribute("ImpulseSection",true); outer:SetAttribute("SectionTitle",title); outer:SetAttribute("ImpulseCollapsed",false)
        local outerLay=Instance.new("UIListLayout",outer); outerLay.SortOrder=Enum.SortOrder.LayoutOrder; outerLay.Padding=UDim.new(0,3)
        
        
        local hdr=Instance.new("TextButton",outer); hdr.LayoutOrder=0; hdr.Size=UDim2.new(1,0,0,24); hdr.BackgroundTransparency=1; hdr.BorderSizePixel=0
        hdr.Text=""; hdr.AutoButtonColor=false
        local accentBar=Instance.new("Frame",hdr); accentBar.Size=UDim2.new(0,2,0,14); accentBar.Position=UDim2.new(0,2,0.5,-7)
        accentBar.BackgroundColor3=_ACC.accent; accentBar.BorderSizePixel=0; guiCorner(accentBar,1)
        table.insert(_themeTabInds,accentBar)
        local lbl=Instance.new("TextLabel",hdr); lbl.Size=UDim2.new(1,-42,1,0); lbl.Position=UDim2.new(0,8,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=title; lbl.TextColor3=Color3.fromRGB(146,146,146)
        lbl.TextSize=10; lbl.Font=Enum.Font.FredokaOne; lbl.TextXAlignment=Enum.TextXAlignment.Left
        local mark=Instance.new("TextLabel",hdr)
        mark.Size=UDim2.new(0,22,1,0); mark.Position=UDim2.new(1,-24,0,0)
        mark.BackgroundTransparency=1; mark.Text="-"; mark.TextColor3=_ACC.accent; mark.Visible=true
        mark.TextSize=12; mark.Font=Enum.Font.FredokaOne; mark.TextXAlignment=Enum.TextXAlignment.Center
        table.insert(_themeSectRefs,{lbl=lbl,arrow=mark})
        local sectionMark=Instance.new("Frame",hdr)
        sectionMark.AnchorPoint=Vector2.new(1,.5); sectionMark.Position=UDim2.new(1,-28,.5,0); sectionMark.Size=UDim2.fromOffset(18,6)
        sectionMark.BackgroundColor3=_ACC.accentBg; sectionMark.BackgroundTransparency=.08; sectionMark.BorderSizePixel=0; guiCorner(sectionMark,4)
        local sectionDot=Instance.new("Frame",sectionMark)
        sectionDot.AnchorPoint=Vector2.new(.5,.5); sectionDot.Position=UDim2.fromScale(.5,.5); sectionDot.Size=UDim2.fromOffset(7,7)
        sectionDot.BackgroundColor3=_ACC.accent; sectionDot.BorderSizePixel=0; guiCorner(sectionDot,4)
        table.insert(_themeExtRefs,{callback=function(thm)
            pcall(function() sectionMark.BackgroundColor3=thm.accentBg; sectionDot.BackgroundColor3=thm.accent end)
        end})
        
        local body=Instance.new("Frame",outer); body.Name="SectBody"; body.LayoutOrder=1
        body.Size=UDim2.new(1,0,0,0); body.AutomaticSize=Enum.AutomaticSize.Y; body.BackgroundTransparency=1; body.BorderSizePixel=0
        body.ClipsDescendants=true
        local bodyLay=Instance.new("UIListLayout",body); bodyLay.SortOrder=Enum.SortOrder.LayoutOrder; bodyLay.Padding=UDim.new(0,4)
        local collapseToken=0
        local function setCollapsed(collapsed,animate)
            collapseToken=collapseToken+1; local token=collapseToken
            outer:SetAttribute("ImpulseCollapsed",collapsed==true)
            mark.Text=collapsed and "+" or "-"
            if not animate then
                body.Visible=not collapsed
                body.AutomaticSize=collapsed and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
                body.Size=UDim2.new(1,0,0,collapsed and 0 or bodyLay.AbsoluteContentSize.Y)
                return
            end
            if collapsed then
                local currentHeight=math.max(body.AbsoluteSize.Y,bodyLay.AbsoluteContentSize.Y)
                body.Visible=true; body.AutomaticSize=Enum.AutomaticSize.None; body.Size=UDim2.new(1,0,0,currentHeight)
                TweenService:Create(body,TweenInfo.new(.2,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Size=UDim2.new(1,0,0,0)}):Play()
                task.delay(.21,function() if token==collapseToken then body.Visible=false end end)
            else
                body.Visible=true; body.AutomaticSize=Enum.AutomaticSize.None; body.Size=UDim2.new(1,0,0,0)
                local targetHeight=bodyLay.AbsoluteContentSize.Y
                TweenService:Create(body,TweenInfo.new(.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,targetHeight)}):Play()
                task.delay(.25,function()
                    if token==collapseToken then body.AutomaticSize=Enum.AutomaticSize.Y; body.Size=UDim2.new(1,0,0,0) end
                end)
            end
        end
        hdr.MouseEnter:Connect(function() tw(lbl,{TextColor3=Color3.fromRGB(221,221,221)}); tw(sectionMark,{BackgroundTransparency=0}) end)
        hdr.MouseLeave:Connect(function() tw(lbl,{TextColor3=_ACC.accentDark}); tw(sectionMark,{BackgroundTransparency=.08}) end)
        hdr.MouseButton1Click:Connect(function() setCollapsed(not outer:GetAttribute("ImpulseCollapsed"),true) end)
        
        body:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            local contentLay=CF:FindFirstChildOfClass("UIListLayout")
            if contentLay then task.defer(function() CF.CanvasSize=UDim2.new(0,0,0,contentLay.AbsoluteContentSize.Y+30) end) end
        end)
        return body
    end

    function recordRecentSetting() end

    function addInputRow(parent,label,value,order,cb)
        local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,40); Row.BackgroundColor3=C.row
        Row.BackgroundTransparency=.10; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,9); local rowStroke=guiStroke(Row,C.divider,1); rowStroke.Transparency=.48
        local aBar=Instance.new("Frame",Row); aBar.Name="ThemeAccentRail"; aBar.Size=UDim2.new(0,3,0,22); aBar.AnchorPoint=Vector2.new(0,0.5)
        aBar.Position=UDim2.new(0,0,0.5,0); aBar.BackgroundColor3=_ACC.accent; aBar.BackgroundTransparency=1
        aBar.BorderSizePixel=0; guiCorner(aBar,2)
        local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.58,0,0,18); Lb.Position=UDim2.new(0,14,0,12)
        Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(211,211,211); Lb.TextSize=10; Lb.Font=Enum.Font.FredokaOne; Lb.TextXAlignment=Enum.TextXAlignment.Left
        local BC=Instance.new("Frame",Row); BC.ZIndex=6; BC.Position=UDim2.new(1,-62,0.5,-12); BC.Size=UDim2.new(0,52,0,24)
        BC.BackgroundColor3=C.input; BC.BackgroundTransparency=0.45; BC.BorderSizePixel=0; guiCorner(BC,8); guiStroke(BC,Color3.fromRGB(56,56,56),1)
        local Box=Instance.new("TextBox",BC); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
        Box.Text=tostring(value); Box.TextColor3=C.text; Box.TextSize=11; Box.Font=Enum.Font.FredokaOne; Box.ClearTextOnFocus=false
        local currentValue=tonumber(value) or 0; local numberAnimationToken=0
        local animateValue=string.find(string.lower(label),"speed",1,true) or string.find(string.lower(label),"radius",1,true) or string.find(string.lower(label),"duration",1,true)
        local function formattedNumber(number,target)
            local decimals=tostring(target):match("%.(%d+)"); local places=decimals and math.min(#decimals,3) or 0
            if places>0 then return string.format("%."..places.."f",number) end
            return tostring(math.floor(number+.5))
        end
        local function animateNumber(fromValue,toValue)
            numberAnimationToken=numberAnimationToken+1; local token=numberAnimationToken
            if not animateValue or math.abs(toValue-fromValue)<.0001 then Box.Text=tostring(toValue); return end
            task.spawn(function()
                local started=tick(); local duration=.32
                while token==numberAnimationToken and Box and Box.Parent do
                    local alpha=math.clamp((tick()-started)/duration,0,1)
                    local eased=1-(1-alpha)^3
                    Box.Text=formattedNumber(fromValue+(toValue-fromValue)*eased,toValue)
                    if alpha>=1 then break end
                    RunService.RenderStepped:Wait()
                end
                if token==numberAnimationToken and Box and Box.Parent then Box.Text=tostring(toValue) end
            end)
        end
        Box.FocusLost:Connect(function()
            local n=tonumber(Box.Text)
            if n and n>0 then local previous=currentValue; currentValue=n; recordRecentSetting(label,Row); cb(n); animateNumber(previous,n)
            else Box.Text=tostring(currentValue) end
        end)
        Box.Focused:Connect(function() numberAnimationToken=numberAnimationToken+1; tw(BC,{BackgroundTransparency=0.2}) end)
        Box.FocusLost:Connect(function() tw(BC,{BackgroundTransparency=0.45}) end)
        local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
        hov.MouseEnter:Connect(function()
            tw(Row,{BackgroundTransparency=0.18,BackgroundColor3=_ACC.accentRowHover})
            tw(aBar,{BackgroundTransparency=0.15})
        end)
        hov.MouseLeave:Connect(function()
            tw(Row,{BackgroundTransparency=.10,BackgroundColor3=C.row})
            tw(aBar,{BackgroundTransparency=1})
        end)
        configInputSetters[label]=function(nextValue)
            local number=tonumber(nextValue)
            if number then currentValue=number; numberAnimationToken=numberAnimationToken+1; Box.Text=tostring(number) end
        end
        return Row,Box
    end

    function addSliderRow(parent,label,minValue,maxValue,value,step,order,onChanged,formatter)
        local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,48); Row.BackgroundColor3=C.row
        Row.BackgroundTransparency=.10; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,9)
        local rowStroke=guiStroke(Row,C.divider,1); rowStroke.Transparency=.48
        local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(1,-82,0,18); Lb.Position=UDim2.new(0,14,0,7)
        Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(199,199,199)
        Lb.TextSize=10; Lb.Font=Enum.Font.FredokaOne; Lb.TextXAlignment=Enum.TextXAlignment.Left
        local valuePill=Instance.new("Frame",Row); valuePill.Size=UDim2.fromOffset(58,20); valuePill.Position=UDim2.new(1,-70,0,5)
        valuePill.BackgroundColor3=_ACC.accentBg; valuePill.BackgroundTransparency=.18; valuePill.BorderSizePixel=0; guiCorner(valuePill,7)
        local valueStroke=guiStroke(valuePill,_ACC.accentDark,1); valueStroke.Transparency=.42
        local valueLabel=Instance.new("TextLabel",valuePill); valueLabel.Size=UDim2.fromScale(1,1); valueLabel.BackgroundTransparency=1
        valueLabel.TextColor3=_ACC.accent; valueLabel.TextSize=9; valueLabel.Font=Enum.Font.FredokaOne
        local track=Instance.new("Frame",Row); track.Size=UDim2.new(1,-28,0,4); track.Position=UDim2.new(0,14,0,35)
        track.BackgroundColor3=Color3.fromRGB(24,24,24); track.BackgroundTransparency=.16; track.BorderSizePixel=0; guiCorner(track,3)
        local fill=Instance.new("Frame",track); fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=_ACC.accent
        fill.BackgroundTransparency=.04; fill.BorderSizePixel=0; guiCorner(fill,3)
        local knob=Instance.new("Frame",track); knob.AnchorPoint=Vector2.new(.5,.5); knob.Size=UDim2.fromOffset(12,12)
        knob.BackgroundColor3=Color3.fromRGB(229,229,229); knob.BorderSizePixel=0; knob.ZIndex=4; guiCorner(knob,7)
        local knobStroke=guiStroke(knob,_ACC.accent,2); knobStroke.Transparency=.1
        local sliderBtn=Instance.new("TextButton",Row); sliderBtn.Size=UDim2.new(1,-20,0,22); sliderBtn.Position=UDim2.new(0,10,0,25)
        sliderBtn.BackgroundTransparency=1; sliderBtn.Text=""; sliderBtn.ZIndex=6; sliderBtn.AutoButtonColor=false
        local current=value; local dragging=false
        local function format(v)
            if formatter then return formatter(v) end
            return tostring(math.floor(v*100+.5)).."%"
        end
        local function setValue(nextValue,notify,finished)
            nextValue=math.clamp(tonumber(nextValue) or minValue,minValue,maxValue)
            if step and step>0 then nextValue=minValue+math.floor(((nextValue-minValue)/step)+.5)*step end
            nextValue=math.clamp(nextValue,minValue,maxValue); current=nextValue
            local alpha=(nextValue-minValue)/math.max(maxValue-minValue,.001)
            fill.Size=UDim2.new(alpha,0,1,0); knob.Position=UDim2.new(alpha,0,.5,0); valueLabel.Text=format(nextValue)
            if notify and onChanged then
                if finished then recordRecentSetting(label,Row) end
                onChanged(nextValue,finished==true)
            end
        end
        local function setFromX(x,finished)
            local alpha=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
            setValue(minValue+(maxValue-minValue)*alpha,true,finished)
        end
        sliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true; setFromX(input.Position.X,false)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then setFromX(input.Position.X,false) end
        end)
        UIS.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then
                dragging=false; setFromX(input.Position.X,true)
            end
        end)
        sliderBtn.MouseEnter:Connect(function() tw(Row,{BackgroundColor3=_ACC.accentRowHover,BackgroundTransparency=.04}); tw(knobStroke,{Transparency=0}) end)
        sliderBtn.MouseLeave:Connect(function() if not dragging then tw(Row,{BackgroundColor3=C.row,BackgroundTransparency=.10}); tw(knobStroke,{Transparency=.1}) end end)
        table.insert(_themeExtRefs,{callback=function(thm) pcall(function()
            fill.BackgroundColor3=thm.accent; knobStroke.Color=thm.accent; valuePill.BackgroundColor3=thm.accentBg
            valueStroke.Color=thm.accentDark; valueLabel.TextColor3=thm.accent
        end) end})
        setValue(value,false,false)
        configSliderSetters[label]=function(nextValue) setValue(nextValue,false,true) end
        return Row,setValue
    end

    function playFeatureEffect(row)
        if not row or not row.Parent then return end
        local flash=Instance.new("Frame",row)
        flash.AnchorPoint=Vector2.new(0.5,0.5); flash.Position=UDim2.new(0.5,0,0.5,0)
        flash.Size=UDim2.new(0,4,0,4); flash.BackgroundColor3=_ACC.accent
        flash.BackgroundTransparency=0.68; flash.BorderSizePixel=0; flash.ZIndex=4
        guiCorner(flash,8)
        local flashStroke=guiStroke(flash,_ACC.accent,1); flashStroke.Transparency=0.18
        TweenService:Create(flash,TweenInfo.new(0.34,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
            Size=UDim2.new(1,-4,1,-4),BackgroundTransparency=1
        }):Play()
        TweenService:Create(flashStroke,TweenInfo.new(0.34),{Transparency=1}):Play()
        for i=1,4 do
            local particle=Instance.new("Frame",row)
            particle.AnchorPoint=Vector2.new(0.5,0.5); particle.Position=UDim2.new(1,-30,0.5,0)
            particle.Size=UDim2.new(0,3,0,3); particle.BackgroundColor3=_ACC.accent
            particle.BackgroundTransparency=0.05; particle.BorderSizePixel=0; particle.ZIndex=8
            particle.Rotation=45; guiCorner(particle,1)
            local angle=((i-1)/4)*math.pi*2
            local dx=math.cos(angle)*(12+i*2); local dy=math.sin(angle)*(9+i)
            TweenService:Create(particle,TweenInfo.new(0.38,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
                Position=UDim2.new(1,-30+dx,0.5,dy),BackgroundTransparency=1,Rotation=135,Size=UDim2.new(0,1,0,1)
            }):Play()
            task.delay(0.4,function() pcall(function() particle:Destroy() end) end)
        end
        task.delay(0.4,function() pcall(function() flash:Destroy() end) end)
    end

    function addToggleRow(parent,label,enabled,order,kbKey,onToggle)
        local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,40); Row.BackgroundColor3=C.row
        Row.BackgroundTransparency=.10; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,9); local rowStroke=guiStroke(Row,C.divider,1); rowStroke.Transparency=.48
        Row:SetAttribute("ImpulseToggle",true); Row:SetAttribute("ImpulseEnabled",enabled==true)
        
        local aBar=Instance.new("Frame",Row); aBar.Name="ThemeAccentRail"; aBar.Size=UDim2.new(0,3,0,22); aBar.AnchorPoint=Vector2.new(0,0.5)
        aBar.Position=UDim2.new(0,0,0.5,0); aBar.BackgroundColor3=_ACC.accent; aBar.BackgroundTransparency=1
        aBar.BorderSizePixel=0; guiCorner(aBar,2)
        local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.62,0,0,18); Lb.Position=UDim2.new(0,14,0,12)
        Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(211,211,211); Lb.TextSize=10; Lb.Font=Enum.Font.FredokaOne; Lb.TextXAlignment=Enum.TextXAlignment.Left
        local OFF_TRACK=Color3.fromRGB(29,29,29); local OFF_TRACK_STROKE=Color3.fromRGB(59,59,59); local OFF_KNOB=Color3.fromRGB(73,73,73)
        local TI_KNOB=TweenInfo.new(0.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        local TI_FADE=TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,42,0,22); Track.Position=UDim2.new(1,-54,0.5,-11)
        Track.BackgroundColor3=enabled and _ACC.accentBg or OFF_TRACK; Track.BackgroundTransparency=0.12; Track.BorderSizePixel=0; guiCorner(Track,12); local TrkStroke=guiStroke(Track,enabled and _ACC.accentDark or OFF_TRACK_STROKE,1)
        local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,18,0,18)
        Knob.Position=enabled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
        Knob.BackgroundColor3=enabled and _ACC.accent or OFF_KNOB; Knob.BackgroundTransparency=enabled and 0 or 0.18; Knob.BorderSizePixel=0; guiCorner(Knob,9)
        local KGlow=guiStroke(Knob,enabled and _ACC.accent or OFF_KNOB,1.5); KGlow.Transparency=enabled and 0.25 or 1
        local st=enabled
        table.insert(_themeToggleRefs,{track=Track,trkStroke=TrkStroke,knob=Knob,offTrack=OFF_TRACK,offKnob=OFF_KNOB,offStroke=OFF_TRACK_STROKE,getSt=function() return st end})
        local function setV(on)
            st=on
            Row:SetAttribute("ImpulseEnabled",on==true)
            if on then playFeatureEffect(Row) end
            TweenService:Create(Knob,TI_KNOB,{Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
            TweenService:Create(Knob,TI_FADE,{BackgroundColor3=on and _ACC.accent or OFF_KNOB,BackgroundTransparency=on and 0 or 0.18}):Play()
            TweenService:Create(Track,TI_FADE,{BackgroundColor3=on and _ACC.accentBg or OFF_TRACK,BackgroundTransparency=on and 0.1 or 0.12}):Play()
            TweenService:Create(KGlow,TI_FADE,{Color=on and _ACC.accent or OFF_KNOB,Transparency=on and 0.25 or 1}):Play()
            if TrkStroke then TrkStroke.Color=on and _ACC.accentDark or OFF_TRACK_STROKE end
        end
        local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,42,0,22); Btn.Position=UDim2.new(1,-54,0.5,-11); Btn.BackgroundTransparency=1; Btn.Text=""; Btn.ZIndex=5
        Btn.MouseButton1Click:Connect(function() st=not st; setV(st); recordRecentSetting(label,Row); if onToggle then onToggle(st) end end)
        local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
        hov.MouseEnter:Connect(function()
            tw(Row,{BackgroundTransparency=0.25,BackgroundColor3=_ACC.accentRowHover})
            tw(aBar,{BackgroundTransparency=0.15})
        end)
        hov.MouseLeave:Connect(function()
            tw(Row,{BackgroundTransparency=.10,BackgroundColor3=C.row})
            tw(aBar,{BackgroundTransparency=1})
        end)
        if kbKey then _GACC.GuiToggleSetters[kbKey]=setV end
        configToggleSetters[label]=setV
        return Row,setV
    end

    function addActionRow(parent,label,kbKey,onAction,order)
        local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,40); Row.BackgroundColor3=C.row
        Row.BackgroundTransparency=.10; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,9); local rowStroke=guiStroke(Row,C.divider,1); rowStroke.Transparency=.48
        local aBar=Instance.new("Frame",Row); aBar.Name="ThemeAccentRail"; aBar.Size=UDim2.new(0,3,0,22); aBar.AnchorPoint=Vector2.new(0,0.5)
        aBar.Position=UDim2.new(0,0,0.5,0); aBar.BackgroundColor3=_ACC.accent; aBar.BackgroundTransparency=1
        aBar.BorderSizePixel=0; guiCorner(aBar,2)
        local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.7,0,0,18); Lb.Position=UDim2.new(0,14,0,12)
        Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(211,211,211); Lb.TextSize=10; Lb.Font=Enum.Font.FredokaOne; Lb.TextXAlignment=Enum.TextXAlignment.Left
        local AB=Instance.new("TextButton",Row); AB.Size=UDim2.new(1,0,1,0); AB.BackgroundTransparency=1; AB.Text=""
        AB.MouseButton1Click:Connect(function() playFeatureEffect(Row); recordRecentSetting(label,Row); onAction() end)
        local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
        hov.MouseEnter:Connect(function()
            tw(Row,{BackgroundTransparency=0.25,BackgroundColor3=_ACC.accentRowHover})
            tw(aBar,{BackgroundTransparency=0.15})
        end)
        hov.MouseLeave:Connect(function()
            tw(Row,{BackgroundTransparency=.10,BackgroundColor3=C.row})
            tw(aBar,{BackgroundTransparency=1})
        end)
        return Row
    end

    _GACC.extras.addDropdownRow=function(parent,label,options,current,order,onSelect)
        local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,44); Row.LayoutOrder=order
        Row.BackgroundColor3=C.row; Row.BackgroundTransparency=.10; Row.BorderSizePixel=0; Row.ClipsDescendants=true; guiCorner(Row,9); local rowStroke=guiStroke(Row,C.divider,1); rowStroke.Transparency=.48
        local accent=Instance.new("Frame",Row); accent.Name="ThemeAccentRail"; accent.Size=UDim2.new(0,3,0,24); accent.Position=UDim2.new(0,0,0,10)
        accent.BackgroundColor3=_ACC.accent; accent.BackgroundTransparency=.25; accent.BorderSizePixel=0; guiCorner(accent,2)
        local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0,92,0,42); Lb.Position=UDim2.new(0,14,0,1)
        Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(225,225,225); Lb.TextSize=11
        Lb.Font=Enum.Font.GothamMedium; Lb.TextXAlignment=Enum.TextXAlignment.Left
        local valueBtn=Instance.new("TextButton",Row); valueBtn.Size=UDim2.new(1,-120,0,28); valueBtn.Position=UDim2.new(0,108,0,8)
        valueBtn.BackgroundColor3=_ACC.accentBg; valueBtn.BackgroundTransparency=.48; valueBtn.BorderSizePixel=0
        valueBtn.Text=tostring(current).."  +"; valueBtn.TextColor3=_ACC.accent; valueBtn.TextSize=10; valueBtn.Font=Enum.Font.GothamBold
        valueBtn.TextTruncate=Enum.TextTruncate.AtEnd; valueBtn.ZIndex=8; guiCorner(valueBtn,7); local valueStroke=guiStroke(valueBtn,_ACC.accentDark,1); valueStroke.Transparency=.44
        local drop=Instance.new("ScrollingFrame",Row); drop.Position=UDim2.new(0,8,0,48); drop.Size=UDim2.new(1,-16,0,0)
        drop.BackgroundColor3=Color3.fromRGB(7,7,9); drop.BackgroundTransparency=.58; drop.BorderSizePixel=0
        drop.ScrollBarThickness=2; drop.ScrollBarImageColor3=_ACC.accent; drop.CanvasSize=UDim2.new(0,0,0,math.ceil(#options/2)*30+6)
        drop.Visible=false; drop.ZIndex=9; guiCorner(drop,8); local dropStroke=guiStroke(drop,_ACC.accentDark,1); dropStroke.Transparency=.42
        local grid=Instance.new("UIGridLayout",drop); grid.SortOrder=Enum.SortOrder.LayoutOrder
        grid.CellSize=UDim2.new(.5,-4,0,27); grid.CellPadding=UDim2.fromOffset(4,3)
        local pad=Instance.new("UIPadding",drop); pad.PaddingTop=UDim.new(0,4); pad.PaddingLeft=UDim.new(0,4); pad.PaddingRight=UDim.new(0,4)
        local built=false; local open=false; local choiceButtons={}
        local function refreshChoices()
            for name,choice in pairs(choiceButtons) do
                local selected=tostring(name)==tostring(current)
                choice.BackgroundColor3=selected and _ACC.accent or _ACC.accentBg
                choice.BackgroundTransparency=selected and .20 or .68
                choice.TextColor3=selected and Color3.fromRGB(8,8,8) or Color3.fromRGB(220,220,220)
            end
        end
        local function setOpen(on)
            open=on
            if on and not built then
                built=true
                for i,name in ipairs(options) do
                    local choice=Instance.new("TextButton",drop); choice.LayoutOrder=i
                    choice.BackgroundColor3=_ACC.accentBg; choice.BackgroundTransparency=.68; choice.BorderSizePixel=0
                    choice.Text=name; choice.TextColor3=Color3.fromRGB(220,220,220); choice.TextSize=10; choice.Font=Enum.Font.GothamMedium
                    choice.ZIndex=10; guiCorner(choice,7); choiceButtons[name]=choice
                    choice.MouseEnter:Connect(function() tw(choice,{BackgroundColor3=_ACC.accentHover}) end)
                    choice.MouseLeave:Connect(refreshChoices)
                    choice.MouseButton1Click:Connect(function()
                        current=name; refreshChoices(); valueBtn.Text=name.."  +"; if onSelect then onSelect(name) end; setOpen(false)
                    end)
                end
                refreshChoices()
            end
            local visibleHeight=math.min(math.ceil(#options/2)*30+8,104)
            if on then drop.Visible=true end
            tw(Row,{Size=UDim2.new(1,0,0,on and 54+visibleHeight or 44)},TweenInfo.new(.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
            tw(drop,{Size=UDim2.new(1,-16,0,on and visibleHeight or 0)},TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
            valueBtn.Text=tostring(current)..(on and "  -" or "  +")
            tw(valueStroke,{Transparency=on and .12 or .44},TweenInfo.new(.18))
            if not on then task.delay(.23,function() if not open and drop then drop.Visible=false end end) end
        end
        valueBtn.MouseButton1Click:Connect(function() setOpen(not open) end)
        table.insert(_themeActBtns,valueBtn); table.insert(_themeScrollbars,drop)
        configDropdownSetters[label]=function(v) current=v; refreshChoices(); valueBtn.Text=tostring(v)..(open and "  -" or "  +") end
        table.insert(_themeExtRefs,{callback=function(thm) pcall(function() rowStroke.Color=thm.divider; valueStroke.Color=thm.accentDark; dropStroke.Color=thm.accentDark; refreshChoices() end) end})
        return Row,function(v) current=v; refreshChoices(); valueBtn.Text=tostring(v)..(open and "  -" or "  +") end
    end

    local keybindRowRefs={}
    function showKeybindConflict(primaryKey,otherKey)
        local warningColor=Color3.fromRGB(224,72,151)
        for _,entry in ipairs({keybindRowRefs[primaryKey],keybindRowRefs[otherKey]}) do
            if entry then
                entry.warningToken=(entry.warningToken or 0)+1; local token=entry.warningToken
                entry.stroke.Color=warningColor; entry.stroke.Transparency=.02
                entry.keyBtn.TextColor3=Color3.fromRGB(255,205,232)
                entry.keyBtn.BackgroundColor3=Color3.fromRGB(54,8,34); entry.keyBtn.BackgroundTransparency=.02
                entry.keyBtn.Text=entry.key==primaryKey and "CONFLICT" or "IN USE"
                TweenService:Create(entry.row,TweenInfo.new(.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=Color3.fromRGB(31,5,20),BackgroundTransparency=.02}):Play()
                task.delay(1.35,function()
                    if entry.warningToken~=token or not entry.row.Parent then return end
                    entry.keyBtn.Text=prettyKey(Keys[entry.key]); entry.keyBtn.TextColor3=_ACC.accent
                    entry.keyBtn.BackgroundColor3=_ACC.accentBg; entry.keyBtn.BackgroundTransparency=.3
                    entry.stroke.Color=C.divider; entry.stroke.Transparency=.48
                    TweenService:Create(entry.row,TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundColor3=C.row,BackgroundTransparency=.10}):Play()
                end)
            end
        end
    end

    function addKeybindRow(parent,label,kbKey,order)
        local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,40); Row.LayoutOrder=order
        Row.BackgroundColor3=C.row; Row.BackgroundTransparency=.10; Row.BorderSizePixel=0; guiCorner(Row,9); local rowStroke=guiStroke(Row,C.divider,1); rowStroke.Transparency=.48
        local accent=Instance.new("Frame",Row); accent.Name="ThemeAccentRail"; accent.Size=UDim2.new(0,3,0,22); accent.Position=UDim2.new(0,0,.5,-11)
        accent.BackgroundColor3=_ACC.accent; accent.BackgroundTransparency=1; accent.BorderSizePixel=0; guiCorner(accent,2)
        local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(.58,0,1,0); Lb.Position=UDim2.new(0,14,0,0)
        Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(211,211,211)
        Lb.TextSize=10; Lb.Font=Enum.Font.FredokaOne; Lb.TextXAlignment=Enum.TextXAlignment.Left
        local keyBtn=Instance.new("TextButton",Row); keyBtn.AnchorPoint=Vector2.new(1,.5)
        keyBtn.Size=UDim2.new(0,44,0,24); keyBtn.Position=UDim2.new(1,-12,.5,0); keyBtn.AutomaticSize=Enum.AutomaticSize.X
        keyBtn.BackgroundColor3=_ACC.accentBg; keyBtn.BackgroundTransparency=.3; keyBtn.BorderSizePixel=0
        keyBtn.Text=prettyKey(Keys[kbKey]); keyBtn.TextColor3=_ACC.accent; keyBtn.TextSize=10; keyBtn.Font=Enum.Font.FredokaOne
        guiCorner(keyBtn,6); local keyPad=Instance.new("UIPadding",keyBtn); keyPad.PaddingLeft=UDim.new(0,10); keyPad.PaddingRight=UDim.new(0,10)
        table.insert(_themeKbLabels,keyBtn)
        keybindRowRefs[kbKey]={key=kbKey,row=Row,keyBtn=keyBtn,stroke=rowStroke,warningToken=0}
         local clearBtn=Instance.new("TextButton",Row)
         clearBtn.Name="ClearKeybind"
         clearBtn.AnchorPoint=Vector2.new(1,.5); clearBtn.Size=UDim2.fromOffset(18,22)
         clearBtn.Position=UDim2.new(1,-60,.5,0); clearBtn.BackgroundTransparency=1
         clearBtn.BorderSizePixel=0; clearBtn.Text="X"; clearBtn.TextColor3=Color3.fromRGB(100,100,100)
         clearBtn.TextSize=10; clearBtn.Font=Enum.Font.GothamBlack; clearBtn.AutoButtonColor=false
         clearBtn.ZIndex=12
         clearBtn.MouseEnter:Connect(function() clearBtn.TextColor3=Color3.fromRGB(200,80,80) end)
         clearBtn.MouseLeave:Connect(function() clearBtn.TextColor3=Color3.fromRGB(100,100,100) end)
         local function paintKey(kc)
             local none=(not kc or kc==Enum.KeyCode.Unknown)
             keyBtn.Text=prettyKey(kc)
             -- NONE uses same colors as bound keys
             keyBtn.TextColor3=_ACC.accent
             keyBtn.BackgroundColor3=_ACC.accentBg
             keyBtn.BackgroundTransparency=.3
             clearBtn.Visible=not none
         end
         paintKey(Keys[kbKey])
         clearBtn.MouseButton1Click:Connect(function()
             KeyListen.active=false; KeyListen.cb=nil; KeyListen.label=nil
             Keys[kbKey]=Enum.KeyCode.Unknown
             paintKey(Keys[kbKey])
             recordRecentSetting(label,Row)
             saveConfig()
         end)
        keyBtn.MouseButton1Click:Connect(function()
            startKL(keyBtn,function(nk)
                local conflictKey=nil
                for otherKey,assigned in pairs(Keys) do
                    if otherKey~=kbKey and assigned~=Enum.KeyCode.Unknown and nk~=Enum.KeyCode.Unknown and assigned==nk then conflictKey=otherKey; break end
                end
                if conflictKey then
                    keyBtn.Text=prettyKey(Keys[kbKey]); showKeybindConflict(kbKey,conflictKey); return
                end
                Keys[kbKey]=nk; paintKey(nk); recordRecentSetting(label,Row); saveConfig()
            end)
        end)
        keyBtn.MouseEnter:Connect(function()
            tw(keyBtn,{BackgroundTransparency=.05,BackgroundColor3=_ACC.accentHover}); tw(Row,{BackgroundTransparency=.15,BackgroundColor3=_ACC.accentRowHover}); tw(accent,{BackgroundTransparency=.1})
        end)
        keyBtn.MouseLeave:Connect(function()
            tw(keyBtn,{BackgroundTransparency=.3,BackgroundColor3=_ACC.accentBg})
            tw(Row,{BackgroundTransparency=.10,BackgroundColor3=C.row}); tw(accent,{BackgroundTransparency=1})
        end)
        return Row,keyBtn
    end

    
    local Categories={"Main","Movement","Visual"}
    local CategoryMeta={Main="MN",Movement="MV",Visual="VS"}
    local CategoryRefs={contents={},btns={},strokes={},badges={},active="Main"}
    local TabPages={}
    local TabScrollMemory={Main=0,Movement=0,Visual=0}
    local scrollingPageLayout=Instance.new("UIListLayout")
    scrollingPageLayout.SortOrder=Enum.SortOrder.LayoutOrder; scrollingPageLayout.Padding=UDim.new(0,10)

    function updateTabCanvas(targetY)
        local preservedY=type(targetY)=="number" and targetY or CF.CanvasPosition.Y
        task.defer(function()
            local canvasHeight
            if navigationStyle=="SCROLLING" then
                canvasHeight=scrollingPageLayout.AbsoluteContentSize.Y+24
            else
                local page=TabPages[CategoryRefs.active]
                local layout=page and page:FindFirstChildOfClass("UIListLayout")
                canvasHeight=(layout and layout.AbsoluteContentSize.Y or 0)+24
            end
            CF.CanvasSize=UDim2.new(0,0,0,canvasHeight)
            local maxY=math.max(canvasHeight-CF.AbsoluteWindowSize.Y,0)
            CF.CanvasPosition=Vector2.new(0,math.clamp(preservedY,0,maxY))
            updateScrollRail()
        end)
    end

    for pageIndex,name in ipairs(Categories) do
        local page=Instance.new("Frame")
        page.Name=name.."Page"
        page.Size=UDim2.new(1,0,0,0); page.AutomaticSize=Enum.AutomaticSize.Y
        page.Position=UDim2.fromOffset(0,0); page.BackgroundTransparency=1
        page.Visible=name=="Main"; page.LayoutOrder=pageIndex; page.Parent=CF
        TabPages[name]=page
        local layout=Instance.new("UIListLayout",page)
        layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,7)
        local padding=Instance.new("UIPadding",page)
        padding.PaddingLeft=UDim.new(0,4); padding.PaddingRight=UDim.new(0,4)
        padding.PaddingTop=UDim.new(0,5); padding.PaddingBottom=UDim.new(0,8)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if navigationStyle=="SCROLLING" or CategoryRefs.active==name then updateTabCanvas() end
        end)
    end
    scrollingPageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if navigationStyle=="SCROLLING" then updateTabCanvas() end
    end)

    function makeTabGroup(page,name,order)
        local group=Instance.new("Frame",page)
        group.Name=name.."Group"; group.LayoutOrder=order; group.Size=UDim2.new(1,0,0,0)
        group.AutomaticSize=Enum.AutomaticSize.Y; group.BackgroundTransparency=1; group.BorderSizePixel=0
        local layout=Instance.new("UIListLayout",group)
        layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,7)
        return group
    end

    CategoryRefs.contents.Main=TabPages.Main
    CategoryRefs.contents.Speed=makeTabGroup(TabPages.Main,"Speed",1)
    CategoryRefs.contents.Combat=makeTabGroup(TabPages.Main,"Combat",2)
    CategoryRefs.contents.Movement=makeTabGroup(TabPages.Movement,"Movement",1)
    CategoryRefs.contents.Visual=makeTabGroup(TabPages.Visual,"Visual",1)
    CategoryRefs.contents.Settings=makeTabGroup(TabPages.Visual,"Settings",2)
    CategoryRefs.contents.Keybinds=makeTabGroup(TabPages.Visual,"Keybinds",3)

    local featureCardRefs={}
    function makeFeatureDeck(page,definitions)
        local deck=Instance.new("Frame",page)
        deck.Name="FeatureDeck"; deck.LayoutOrder=-20; deck.Size=UDim2.new(1,0,0,66)
        deck.BackgroundTransparency=1; deck.BorderSizePixel=0
        local layout=Instance.new("UIListLayout",deck)
        layout.FillDirection=Enum.FillDirection.Horizontal; layout.SortOrder=Enum.SortOrder.LayoutOrder
        layout.Padding=UDim.new(0,6); layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
        for order,definition in ipairs(definitions) do
            local card=Instance.new("Frame",deck)
            card.Name=definition[1].."Card"; card.LayoutOrder=order; card.Size=UDim2.new(1/#definitions,-4,1,0)
            card.BackgroundColor3=C.row; card.BackgroundTransparency=.13; card.BorderSizePixel=0
            guiCorner(card,9); local stroke=guiStroke(card,C.divider,1); stroke.Transparency=.34
            local edge=Instance.new("Frame",card)
            edge.Size=UDim2.new(0,2,0,22); edge.Position=UDim2.fromOffset(0,9); edge.BackgroundColor3=_ACC.accent
            edge.BorderSizePixel=0; guiCorner(edge,3)
            local title=Instance.new("TextLabel",card)
            title.Size=UDim2.new(1,-16,0,12); title.Position=UDim2.fromOffset(9,7); title.BackgroundTransparency=1
            title.Text=definition[2]; title.TextColor3=C.textMuted; title.TextSize=7; title.Font=Enum.Font.GothamBold
            title.TextXAlignment=Enum.TextXAlignment.Left
            local value=Instance.new("TextLabel",card)
            value.Size=UDim2.new(1,-16,0,18); value.Position=UDim2.fromOffset(9,21); value.BackgroundTransparency=1
            value.Text="--"; value.TextColor3=C.text; value.TextSize=10; value.Font=Enum.Font.FredokaOne
            value.TextXAlignment=Enum.TextXAlignment.Left; value.TextTruncate=Enum.TextTruncate.AtEnd
            local track=Instance.new("Frame",card)
            track.Size=UDim2.new(1,-18,0,2); track.Position=UDim2.new(0,9,1,-10); track.BackgroundColor3=C.divider
            track.BackgroundTransparency=.25; track.BorderSizePixel=0; guiCorner(track,3)
            local fill=Instance.new("Frame",track)
            fill.Size=UDim2.fromScale(.08,1); fill.BackgroundColor3=_ACC.accent; fill.BorderSizePixel=0; guiCorner(fill,3)
            featureCardRefs[definition[1]]={card=card,stroke=stroke,edge=edge,value=value,track=track,fill=fill,last=""}
        end
    end
    -- Compact layout: summary cards removed so tabs open directly to their controls.

    function updateFeatureCard(key,value,ratio,active)
        local ref=featureCardRefs[key]; if not ref then return end
        value=tostring(value)
        if ref.last~=value then
            ref.last=value; ref.value.TextTransparency=.45; ref.value.Text=value
            tw(ref.value,{TextTransparency=0},TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out))
        end
        ratio=math.clamp(tonumber(ratio) or 0,0,1)
        tw(ref.fill,{Size=UDim2.fromScale(math.max(ratio,.035),1),BackgroundColor3=active and _ACC.accent or _ACC.accentDark},TweenInfo.new(.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
        tw(ref.edge,{BackgroundTransparency=active and 0 or .55},TweenInfo.new(.22))
    end
    task.spawn(function()
        while GuiHub and GuiHub.Parent do
            local character=LP.Character; local root=character and character:FindFirstChild("HumanoidRootPart")
            local velocity=root and root.AssemblyLinearVelocity or Vector3.zero
            local horizontal=Vector3.new(velocity.X,0,velocity.Z).Magnitude
            updateFeatureCard("speed",tostring(math.floor(horizontal+.5)).." SPD",horizontal/math.max(getActiveMoveSpeed(),1),horizontal>1)
            local grabProgress=0
            if stealMode=="op" then grabProgress=SemiSteal.State.active and (SemiSteal.State.progress or 0) or 0
            elseif isStealing and stealStartTime then grabProgress=normalStealProgress end
            updateFeatureCard("grab",Steal.AutoStealEnabled and "ACTIVE" or "OFF",grabProgress,Steal.AutoStealEnabled)
            updateFeatureCard("mode",string.upper(stealMode),stealMode=="op" and 1 or .48,true)
            local pathName=autoLeftEnabled and "LEFT" or (autoRightEnabled and "RIGHT" or "OFF")
            updateFeatureCard("paths",pathName,(autoLeftEnabled or autoRightEnabled) and 1 or 0,autoLeftEnabled or autoRightEnabled)
            updateFeatureCard("jump",infJumpEnabled and string.upper(infJumpMode) or "OFF",infJumpEnabled and 1 or 0,infJumpEnabled)
            updateFeatureCard("tp",autoTPEnabled and (tostring(autoTPHeight).." STUDS") or "OFF",autoTPEnabled and math.clamp(autoTPHeight/100,0,1) or 0,autoTPEnabled)
            updateFeatureCard("fov",tostring(fovValue).." DEG",fovValue/120,true)
            updateFeatureCard("theme",currentColorTheme,themeIntensity/1.5,true)
            updateFeatureCard("sound",clickSoundsEnabled and "ON" or "OFF",clickSoundsEnabled and 1 or 0,clickSoundsEnabled)
            task.wait(.25)
        end
    end)
    table.insert(_themeExtRefs,{callback=function(thm)
        for _,ref in pairs(featureCardRefs) do pcall(function()
            ref.card.BackgroundColor3=thm.row; ref.stroke.Color=thm.divider; ref.track.BackgroundColor3=thm.divider
            ref.edge.BackgroundColor3=thm.accent; ref.fill.BackgroundColor3=thm.accent
        end) end
    end})

    function escapeRichText(value)
        local escaped=tostring(value or ""):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
        return escaped
    end

    function highlightSearchMatches(row,query,showHighlight)
        for _,object in ipairs(row:GetDescendants()) do
            if object:IsA("TextLabel") then
                local original=object:GetAttribute("ImpulseSearchOriginal")
                if query=="" or not showHighlight then
                    if original~=nil then
                        object.Text=original
                        object.RichText=object:GetAttribute("ImpulseSearchWasRich")==true
                        object:SetAttribute("ImpulseSearchOriginal",nil); object:SetAttribute("ImpulseSearchWasRich",nil)
                    end
                elseif object.RichText==false or original~=nil then
                    if original==nil then
                        original=object.Text
                        object:SetAttribute("ImpulseSearchOriginal",original)
                        object:SetAttribute("ImpulseSearchWasRich",object.RichText)
                    end
                    local lower=string.lower(original); local cursor=1; local pieces={}; local found=false
                    while cursor<=#original do
                        local first,last=string.find(lower,query,cursor,true)
                        if not first then table.insert(pieces,escapeRichText(string.sub(original,cursor))); break end
                        found=true
                        if first>cursor then table.insert(pieces,escapeRichText(string.sub(original,cursor,first-1))) end
                        local highlightColor=string.format("rgb(%d,%d,%d)",math.floor(_ACC.accent.R*255+.5),math.floor(_ACC.accent.G*255+.5),math.floor(_ACC.accent.B*255+.5))
                        table.insert(pieces,'<font color="'..highlightColor..'">'..escapeRichText(string.sub(original,first,last))..'</font>')
                        cursor=last+1
                    end
                    if found then object.RichText=true; object.Text=table.concat(pieces) end
                end
            end
        end
    end

    function rowContainsQuery(row,query)
        if query=="" then return true end
        for _,object in ipairs(row:GetDescendants()) do
            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                local value=string.lower(tostring(object:GetAttribute("ImpulseSearchOriginal") or object.Text or ""))
                if string.find(value,query,1,true) then return true end
            end
        end
        return false
    end

    function resetPageSearch(page)
        if not page then return end
        local featureDeck=page:FindFirstChild("FeatureDeck")
        if featureDeck then featureDeck.Visible=true end
        for _,section in ipairs(page:GetDescendants()) do
            if section:IsA("GuiObject") and section:GetAttribute("ImpulseSection")==true then
                section.Visible=true
                local body=section:FindFirstChild("SectBody")
                if body and body:IsA("GuiObject") then
                    local collapsed=section:GetAttribute("ImpulseCollapsed")==true
                    body.Visible=not collapsed
                    body.AutomaticSize=collapsed and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
                    body.Size=UDim2.new(1,0,0,0)
                    for _,row in ipairs(body:GetChildren()) do
                        if row:IsA("GuiObject") then
                            local modeVisible=row:GetAttribute("ImpulseModeVisible")~=false
                            row.Visible=modeVisible
                            highlightSearchMatches(row,"",false)
                        end
                    end
                end
            end
        end
    end

    function applySearchFilter()
        local query=string.lower((SearchBox.Text or ""):gsub("^%s+",""):gsub("%s+$",""))
        if query=="" then
            for _,name in ipairs(Categories) do
                local page=TabPages[name]
                resetPageSearch(page)
                page.Position=UDim2.fromOffset(0,0)
                local shouldShow=navigationStyle=="SCROLLING" or name==CategoryRefs.active
                page.Visible=shouldShow
            end
            updateTabCanvas()
            return
        end
        for _,name in ipairs(Categories) do
            local page=TabPages[name]
            local shouldFilter=navigationStyle=="SCROLLING" or name==CategoryRefs.active
            if shouldFilter then
                local featureDeck=page:FindFirstChild("FeatureDeck"); if featureDeck then featureDeck.Visible=false end
                local pageMatched=false
                for _,section in ipairs(page:GetDescendants()) do
                    if section:IsA("GuiObject") and section:GetAttribute("ImpulseSection")==true then
                        local body=section:FindFirstChild("SectBody")
                        if body and body:IsA("GuiObject") then
                            local matched=false
                            local titleMatch=string.find(string.lower(section:GetAttribute("SectionTitle") or ""),query,1,true)~=nil
                            for _,row in ipairs(body:GetChildren()) do
                                if row:IsA("GuiObject") then
                                    local modeVisible=row:GetAttribute("ImpulseModeVisible")~=false
                                    local visible=modeVisible and (titleMatch or rowContainsQuery(row,query))
                                    row.Visible=visible
                                    highlightSearchMatches(row,query,visible)
                                    if visible then matched=true end
                                end
                            end
                            section.Visible=matched
                            if matched then
                                pageMatched=true; body.Visible=true
                                body.AutomaticSize=Enum.AutomaticSize.Y; body.Size=UDim2.new(1,0,0,0)
                            end
                        end
                    end
                end
                page.Visible=navigationStyle=="SCROLLING" and pageMatched or true
                page.Position=UDim2.fromOffset(0,0)
            elseif navigationStyle~="SCROLLING" then
                page.Visible=false
            end
        end
        updateTabCanvas(0)
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(applySearchFilter)

    function setTabIndicatorGeometry(indicator,active)
        if tabPosition=="TOP" then
            indicator.AnchorPoint=Vector2.new(.5,1); indicator.Position=UDim2.new(.5,0,1,-1)
            indicator.Size=active and UDim2.new(1,-14,0,3) or UDim2.new(.34,0,0,3)
        else
            indicator.AnchorPoint=Vector2.new(0,.5); indicator.Position=UDim2.new(0,1,.5,0)
            indicator.Size=active and UDim2.new(0,3,1,-12) or UDim2.new(0,3,.34,0)
        end
    end

    function activateTab(name)
        if not TabPages[name] then return end
        local previousName=CategoryRefs.active
        local previousPage=TabPages[previousName]
        local nextPage=TabPages[name]
        local targetScroll=nil
        if previousName~=name then
            TabScrollMemory[previousName]=CF.CanvasPosition.Y
            targetScroll=TabScrollMemory[name] or 0
        end
        CategoryRefs.active=name
        for _,pageName in ipairs(Categories) do
            local page=TabPages[pageName]
            if page~=previousPage and page~=nextPage then
                page.Visible=false; page.Position=UDim2.fromOffset(0,0)
            end
        end
        if previousPage and previousPage~=nextPage then
            TweenService:Create(previousPage,TweenInfo.new(.14,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.fromOffset(-12,0)}):Play()
            task.delay(.15,function()
                if previousPage~=TabPages[CategoryRefs.active] then
                    previousPage.Visible=false; previousPage.Position=UDim2.fromOffset(0,0)
                end
            end)
        else
            for _,pageName in ipairs(Categories) do if pageName~=name then TabPages[pageName].Visible=false end end
        end
        nextPage.Visible=true; nextPage.Position=UDim2.fromOffset(previousPage==nextPage and 0 or 12,0)
        TweenService:Create(nextPage,TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(0,0)}):Play()
        if previousName~=name then SearchBox.Text="" end
        SearchBox.PlaceholderText="Search "..string.lower(name).." tab"
        for tabName,button in pairs(CategoryRefs.btns) do
            local active=tabName==name
            local row=button.Parent
            local indicator=row:FindFirstChild("Indicator")
            tw(row,{BackgroundColor3=active and _ACC.accentBg or Color3.fromRGB(6,6,6),BackgroundTransparency=active and .08 or .5},TweenInfo.new(.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
            tw(button,{TextColor3=active and Color3.fromRGB(240,240,240) or Color3.fromRGB(146,146,146)},TweenInfo.new(.18))
            if indicator then
                setTabIndicatorGeometry(indicator,active)
                tw(indicator,{BackgroundTransparency=active and 0 or 1},TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
            end
            local stroke=CategoryRefs.strokes[tabName]
            if stroke then stroke.Color=active and _ACC.accentDark or Color3.fromRGB(29,29,29); stroke.Transparency=active and .12 or .62 end
        end
        applySearchFilter()
        updateTabCanvas(targetScroll)
    end

    for index,name in ipairs(Categories) do
        local active=name=="Main"
        local row=Instance.new("Frame",TabRail)
        row.Name="Tab_"..name; row.LayoutOrder=index; row.Size=UDim2.new(1,-8,0,30)
        row.BackgroundColor3=active and _ACC.accentBg or Color3.fromRGB(6,6,6)
        row.BackgroundTransparency=active and .08 or .5; row.BorderSizePixel=0; guiCorner(row,7)
        local stroke=guiStroke(row,active and _ACC.accentDark or Color3.fromRGB(29,29,29),1)
        stroke.Transparency=active and .12 or .62; CategoryRefs.strokes[name]=stroke
        local indicator=Instance.new("Frame",row)
        indicator.Name="Indicator"; setTabIndicatorGeometry(indicator,active)
        indicator.BackgroundColor3=_ACC.accent; indicator.BackgroundTransparency=active and 0 or 1; indicator.BorderSizePixel=0; guiCorner(indicator,2)
        table.insert(_themeTabInds,indicator)
        local button=Instance.new("TextButton",row)
        button.Size=UDim2.new(1,-22,1,0); button.Position=UDim2.fromOffset(7,0); button.BackgroundTransparency=1; button.BorderSizePixel=0; button.ZIndex=2
        button.Text=string.upper(name); button.TextColor3=active and Color3.fromRGB(240,240,240) or Color3.fromRGB(146,146,146)
        button.Font=Enum.Font.GothamBold; button.TextSize=8; button.TextXAlignment=Enum.TextXAlignment.Left; button.AutoButtonColor=false
        CategoryRefs.btns[name]=button; table.insert(_themeTabBtns,{btn=button,name=name})
        local countBadge=Instance.new("Frame",row)
        countBadge.Name="EnabledBadge"; countBadge.AnchorPoint=Vector2.new(1,.5); countBadge.Position=UDim2.new(1,-4,.5,0)
        countBadge.Size=UDim2.fromOffset(14,14); countBadge.BackgroundColor3=active and _ACC.accent or Color3.fromRGB(23,23,23)
        countBadge.BackgroundTransparency=active and .05 or .28; countBadge.BorderSizePixel=0; countBadge.ZIndex=3; guiCorner(countBadge,6)
        local countText=Instance.new("TextLabel",countBadge)
        countText.Size=UDim2.fromScale(1,1); countText.BackgroundTransparency=1; countText.Text="0"
        countText.TextColor3=active and Color3.fromRGB(7,7,7) or Color3.fromRGB(160,160,160)
        countText.Font=Enum.Font.GothamBold; countText.TextSize=7; countText.ZIndex=4
        CategoryRefs.badges[name]={frame=countBadge,label=countText}
        button.MouseEnter:Connect(function()
            if CategoryRefs.active~=name then tw(row,{BackgroundColor3=_ACC.accentRowHover,BackgroundTransparency=.12}) end
        end)
        button.MouseLeave:Connect(function()
            if CategoryRefs.active~=name then tw(row,{BackgroundColor3=Color3.fromRGB(6,6,6),BackgroundTransparency=.5}) end
        end)
        button.MouseButton1Click:Connect(function() activateTab(name) end)
        table.insert(_themeExtRefs,{callback=function(thm)
            pcall(function()
                local selected=CategoryRefs.active==name
                indicator.BackgroundColor3=thm.accent; row.BackgroundColor3=selected and thm.accentBg or Color3.fromRGB(6,6,6)
                stroke.Color=selected and thm.accentDark or Color3.fromRGB(29,29,29)
                countBadge.BackgroundColor3=selected and thm.accent or Color3.fromRGB(23,23,23)
            end)
        end})
    end

    applyNavigationLayout=function(skipSave)
        local scrolling=navigationStyle=="SCROLLING"
        local railLayout=TabRail:FindFirstChildOfClass("UIListLayout")
        TabRail.Visible=not scrolling; SidebarDiv.Visible=not scrolling
        if scrolling then
            scrollingPageLayout.Parent=CF
            StatusBar.Position=UDim2.new(0,10,0,72); StatusBar.Size=UDim2.new(1,-20,0,24)
            SearchFrame.Position=UDim2.new(0,10,0,104); SearchFrame.Size=UDim2.new(1,-20,0,26)
            CF.Position=UDim2.new(0,10,0,138); CF.Size=UDim2.new(1,-20,1,-176)
            scrollTrack.Position=UDim2.new(1,-5,0,142); scrollTrack.Size=UDim2.new(0,2,1,-184)
            SearchBox.PlaceholderText="Search all settings"
            for _,name in ipairs(Categories) do
                local page=TabPages[name]
                page.Visible=true; page.Position=UDim2.fromOffset(0,0)
            end
        else
            scrollingPageLayout.Parent=nil
            local topTabs=tabPosition=="TOP"
            if topTabs then
                TabRail.Position=UDim2.new(0,10,0,72); TabRail.Size=UDim2.new(1,-20,0,36)
                SidebarDiv.Position=UDim2.new(0,10,0,113); SidebarDiv.Size=UDim2.new(1,-20,0,1)
                StatusBar.Position=UDim2.new(0,10,0,118); StatusBar.Size=UDim2.new(1,-20,0,24)
                SearchFrame.Position=UDim2.new(0,10,0,150); SearchFrame.Size=UDim2.new(1,-20,0,26)
                CF.Position=UDim2.new(0,10,0,184); CF.Size=UDim2.new(1,-20,1,-222)
                scrollTrack.Position=UDim2.new(1,-5,0,188); scrollTrack.Size=UDim2.new(0,2,1,-230)
            else
                local railOnRight=tabPosition=="RIGHT"
                TabRail.Position=railOnRight and UDim2.new(1,-84,0,72) or UDim2.new(0,10,0,72)
                TabRail.Size=UDim2.new(0,74,0,112)
                SidebarDiv.Position=railOnRight and UDim2.new(1,-92,0,72) or UDim2.new(0,90,0,72)
                SidebarDiv.Size=UDim2.new(0,1,0,112)
                local contentX=railOnRight and 10 or 98
                StatusBar.Position=UDim2.new(0,contentX,0,72); StatusBar.Size=UDim2.new(1,-108,0,24)
                SearchFrame.Position=UDim2.new(0,contentX,0,104); SearchFrame.Size=UDim2.new(1,-108,0,26)
                CF.Position=UDim2.new(0,contentX,0,138); CF.Size=UDim2.new(1,-108,1,-176)
                scrollTrack.Position=railOnRight and UDim2.new(1,-97,0,142) or UDim2.new(1,-5,0,142)
                scrollTrack.Size=UDim2.new(0,2,1,-184)
            end
            if railLayout then
                railLayout.FillDirection=topTabs and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
                railLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
                railLayout.VerticalAlignment=Enum.VerticalAlignment.Center
            end
            for _,name in ipairs(Categories) do
                local row=CategoryRefs.btns[name].Parent
                local indicator=row:FindFirstChild("Indicator")
                row.Size=topTabs and UDim2.new(1/3,-6,1,-6) or UDim2.new(1,-8,0,30)
                CategoryRefs.btns[name].TextXAlignment=topTabs and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
                setTabIndicatorGeometry(indicator,name==CategoryRefs.active)
                TabPages[name].Position=UDim2.fromOffset(0,0)
            end
            SearchBox.PlaceholderText="Search "..string.lower(CategoryRefs.active).." tab"
            activateTab(CategoryRefs.active)
        end
        CF.CanvasPosition=Vector2.zero
        applySearchFilter(); updateTabCanvas(0); updateScrollRail()
        if not skipSave then saveConfig() end
    end

    applyUIWidth=function(value,skipSave)
        uiWidth=math.clamp(math.floor((tonumber(value) or 360)/10+.5)*10,ConfigShare.minWidth,ConfigShare.maxWidth)
        uiPositionX,uiPositionY=clampUIPosition(uiPositionX,uiPositionY)
        Outer.Size=UDim2.fromOffset(uiWidth,ConfigShare.uiHeight)
        Outer.Position=UDim2.fromOffset(uiPositionX,uiPositionY)
        updateTabCanvas(); updateScrollRail()
        if not skipSave then saveConfig() end
    end

    function updateTabBadges()
        for _,name in ipairs(Categories) do
            local count=0
            for _,object in ipairs(TabPages[name]:GetDescendants()) do
                if object:IsA("GuiObject") and object:GetAttribute("ImpulseToggle")==true and object:GetAttribute("ImpulseEnabled")==true then count=count+1 end
            end
            local badge=CategoryRefs.badges[name]
            if badge then
                badge.label.Text=tostring(count)
                local active=CategoryRefs.active==name
                badge.frame.BackgroundColor3=active and _ACC.accent or Color3.fromRGB(23,23,23)
                badge.label.TextColor3=active and Color3.fromRGB(7,7,7) or Color3.fromRGB(160,160,160)
            end
        end
    end

    task.spawn(function()
        while TabRail and TabRail.Parent do updateTabBadges(); task.wait(.25) end
    end)

    applyNavigationLayout(true)

    do
        local signalModule=Instance.new("Frame",Inner)
        signalModule.Name="PlayerWelcome"; signalModule.ZIndex=4; signalModule.ClipsDescendants=true
        signalModule.Size=UDim2.new(0,132,0,42); signalModule.Position=UDim2.new(1,-172,0,9)
        signalModule.BackgroundColor3=Color3.fromRGB(7,7,9); signalModule.BackgroundTransparency=.38; signalModule.BorderSizePixel=0
        guiCorner(signalModule,9)
        local signalStroke=guiStroke(signalModule,_ACC.accentDark,1); signalStroke.Transparency=.24

        local waveform=Instance.new("Frame",signalModule)
        waveform.Name="AvatarFrame"; waveform.Position=UDim2.fromOffset(6,6); waveform.Size=UDim2.fromOffset(30,30)
        waveform.BackgroundColor3=Color3.fromRGB(2,2,3); waveform.BackgroundTransparency=.28; waveform.BorderSizePixel=0; waveform.ZIndex=5
        guiCorner(waveform,7); local waveformStroke=guiStroke(waveform,_ACC.accentDark,1); waveformStroke.Transparency=.28
        local avatarImage=Instance.new("ImageLabel",waveform)
        avatarImage.Size=UDim2.new(1,-4,1,-4); avatarImage.Position=UDim2.fromOffset(2,2)
        avatarImage.BackgroundTransparency=1; avatarImage.BorderSizePixel=0; avatarImage.ScaleType=Enum.ScaleType.Crop; avatarImage.ZIndex=6
        avatarImage.ImageColor3=Color3.new(1,1,1); avatarImage:SetAttribute("N5PreserveImageColor",true)
        guiCorner(avatarImage,6)
        task.spawn(function()
            local ok,image=pcall(function()
                return Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
            end)
            if ok and avatarImage and avatarImage.Parent then avatarImage.Image=image end
        end)
        local bars={}
        for i=1,0 do
            local bar=Instance.new("Frame",waveform)
            bar.AnchorPoint=Vector2.new(0,1); bar.Position=UDim2.new(0,5+(i-1)*5,1,-5); bar.Size=UDim2.fromOffset(3,8+(i%3)*5)
            bar.BackgroundColor3=i==3 and _ACC.accent:Lerp(Color3.fromRGB(248,248,250),.72) or _ACC.accent; bar.BackgroundTransparency=i==3 and .04 or .20
            bar.BorderSizePixel=0; bar.ZIndex=6; guiCorner(bar,2); bars[i]=bar
        end

        local impulseLabel=Instance.new("TextLabel",signalModule)
        impulseLabel.Position=UDim2.fromOffset(43,5); impulseLabel.Size=UDim2.new(1,-48,0,14); impulseLabel.BackgroundTransparency=1
        impulseLabel.Text="Hey! "..LP.Name; impulseLabel.TextColor3=Color3.fromRGB(242,235,250); impulseLabel.Font=Enum.Font.GothamBold
        impulseLabel.TextSize=8; impulseLabel.TextXAlignment=Enum.TextXAlignment.Left; impulseLabel.TextTruncate=Enum.TextTruncate.AtEnd; impulseLabel.ZIndex=6
        local stateLine=Instance.new("Frame",signalModule)
        stateLine.Position=UDim2.fromOffset(43,23); stateLine.Size=UDim2.fromOffset(2,10); stateLine.BackgroundColor3=_ACC.accent
        stateLine.BorderSizePixel=0; stateLine.ZIndex=6; guiCorner(stateLine,2)
        local stateLabel=Instance.new("TextLabel",signalModule)
        stateLabel.Position=UDim2.fromOffset(49,20); stateLabel.Size=UDim2.new(1,-53,0,17); stateLabel.BackgroundTransparency=1
        stateLabel.Text=""; stateLabel.Visible=false; stateLine.Visible=false; stateLabel.TextColor3=_ACC.accent; stateLabel.Font=Enum.Font.FredokaOne
        stateLabel.TextSize=7; stateLabel.TextWrapped=true; stateLabel.TextXAlignment=Enum.TextXAlignment.Left; stateLabel.ZIndex=6

        signalModule.MouseEnter:Connect(function()
            tw(signalStroke,{Transparency=.05},TweenInfo.new(.18)); tw(signalModule,{BackgroundTransparency=.26},TweenInfo.new(.18))
        end)
        signalModule.MouseLeave:Connect(function()
            tw(signalStroke,{Transparency=.24},TweenInfo.new(.18)); tw(signalModule,{BackgroundTransparency=.38},TweenInfo.new(.18))
        end)
        table.insert(_themeExtRefs,{callback=function(thm)
            pcall(function()
                signalStroke.Color=thm.accentDark; waveformStroke.Color=thm.accentDark; stateLine.BackgroundColor3=thm.accent
                stateLabel.TextColor3=thm.accent
                for i,bar in ipairs(bars) do bar.BackgroundColor3=i==3 and thm.accent:Lerp(Color3.fromRGB(248,248,250),.72) or thm.accent end
            end)
        end})
    end

    
    do
    local sp=CategoryRefs.contents["Speed"]
    local b=mkSection(sp,"SPEED CONFIGURATION",0)
    addInputRow(b,"Normal Speed",NS,1,function(v) NS=v; saveConfig() end)
    addInputRow(b,"Carry Speed",CS,2,function(v) CS=v; saveConfig() end)
    addInputRow(b,"Lagger Normal",LAGGER_SPEED,3,function(v) LAGGER_SPEED=v; saveConfig() end)
    addInputRow(b,"Lagger Carry",LAGGER_CARRY_SPEED,4,function(v) LAGGER_CARRY_SPEED=v; saveConfig() end)
    local _,safeCarryVisual=addToggleRow(b,"Carry Mode",carrySpeedActive,5,"carryMode",function(on)
        carrySpeedActive = on
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        saveConfig()
    end)
    _GACC.safeCarryVisual=safeCarryVisual
    local _,safeLaggerVisual=addToggleRow(b,"Lagger Mode",laggerModeEnabled,6,"laggerToggle",function(on)
        laggerModeEnabled=on; if mobBtnRefs.lagger then mobBtnRefs.lagger(on) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end; saveConfig()
    end)
    _GACC.safeLaggerVisual=safeLaggerVisual
    local _,autoCarryVisual=addToggleRow(b,"Auto Carry Speed",_GACC.autoCarrySpeedEnabled,7,nil,function(on)
        _GACC.autoCarrySpeedEnabled=on
        if not on and _GACC.disableAutoCarry then _GACC.disableAutoCarry() end
        saveConfig()
    end)
    _GACC.autoCarryVisual=autoCarryVisual
    end 

    
    task.spawn(function()

    do
    local cp=CategoryRefs.contents["Combat"]
    do local b=mkSection(cp,"BAT CONTROLS",0)
    local _,svAutoBat=addToggleRow(b,"Bat Aimbot",autoBatEnabled,1,"circle",function(on)
        if on then
            if batDesyncTpEnabled then batDesyncTpEnabled=false;stopBatDesyncTp();if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end;if mobBtnRefs.batDesync then mobBtnRefs.batDesync(false) end end
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
        else stopBatAimbot();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        saveConfig()
    end)
    autoBatSetVisual=svAutoBat
    local _,svBatDesyncTp=addToggleRow(b,"Bat Desync TP",batDesyncTpEnabled,2,"batDesyncTp",function(on)
        if on then
            if autoBatEnabled then autoBatEnabled=false;stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            startBatDesyncTp()
        else
            stopBatDesyncTp()
        end
        if mobBtnRefs.batDesync then mobBtnRefs.batDesync(batDesyncTpEnabled) end
        saveConfig()
    end)
    batDesyncTpSetVisual=svBatDesyncTp
    _GACC.extras.addDropdownRow(b,"TP Bat Version",{"V1","V2"},batDesyncTpVersion,3,function(version)
        if version~=batDesyncTpVersion then
            local wasEnabled=batDesyncTpEnabled
            if wasEnabled then stopBatDesyncTp() end
            batDesyncTpVersion=version
            if wasEnabled then startBatDesyncTp() end
            saveConfig()
        end
    end)
    addToggleRow(b,"Auto Swing",autoSwingEnabled,4,nil,function(on) autoSwingEnabled=on;saveConfig(); end)
    end

    do local b=mkSection(cp,"RAGDOLL",1)
    local _,svRagdoll=addToggleRow(b,"Anti Ragdoll",antiRagdollEnabled,1,nil,function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
    if antiRagdollEnabled then svRagdoll(true) end
    addToggleRow(b,"Anti Die & Fling",antiDieFlingEnabled,2,nil,function(on)
        if on then startAntiDieFling() else stopAntiDieFling() end
        saveConfig()
    end)
    local _,svMedusa=addToggleRow(b,"Medusa Counter",medusaCounterEnabled,3,nil,function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    local _,svUnwalk=addToggleRow(b,"Unwalk",unwalkEnabled,4,nil,function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)
    _GACC.unwalkSetVisual=svUnwalk
    end

    do local b=mkSection(cp,"STEAL",2)
    local normalVersionRow,radiusRow,durationRow
    local radiusBox,durationBox
    local refreshNormalVersionButtons,updateAutoStealSubtitle
    function syncStealSettingRows(animate)
        stealMode="normal"
        for _,entry in ipairs({{normalVersionRow,true},{radiusRow,true},{durationRow,true}}) do
            local settingRow=entry[1];local wantsNormal=entry[2];local show=(stealMode=="normal")==wantsNormal
            if settingRow then
                local targetHeight=settingRow==normalVersionRow and 54 or 42
                settingRow:SetAttribute("ImpulseModeVisible",show)
                if show then
                    settingRow.Visible=true
                    if animate then
                        settingRow.Size=UDim2.new(1,0,0,0)
                        tw(settingRow,{Size=UDim2.new(1,0,0,targetHeight)},TweenInfo.new(0.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
                    else
                        settingRow.Size=UDim2.new(1,0,0,targetHeight)
                    end
                elseif animate then
                    tw(settingRow,{Size=UDim2.new(1,0,0,0)},TweenInfo.new(0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.In))
                    task.delay(0.19,function() if settingRow and ((stealMode=="normal")~=wantsNormal) then settingRow.Visible=false end end)
                else
                    settingRow.Visible=false
                end
            end
        end
    end

    
    do
        local Row=Instance.new("Frame",b)
        Row.Size=UDim2.new(1,0,0,54); Row.BackgroundColor3=C.row
        Row.BackgroundTransparency=.08; Row.BorderSizePixel=0; Row.LayoutOrder=1
        guiCorner(Row,10); local autoStealStroke=guiStroke(Row,Color3.fromRGB(40,40,40),1)
        Row:SetAttribute("ImpulseToggle",true); Row:SetAttribute("ImpulseEnabled",Steal.AutoStealEnabled==true)
        local topGlow=Instance.new("Frame",Row)
        topGlow.Size=UDim2.new(1,-24,0,1); topGlow.Position=UDim2.new(0,12,0,0)
        topGlow.BackgroundColor3=_ACC.accent; topGlow.BackgroundTransparency=1; topGlow.BorderSizePixel=0; topGlow.Visible=false

        
        local Lb=Instance.new("TextLabel",Row)
        Lb.Size=UDim2.new(0,130,0,18); Lb.Position=UDim2.new(0,14,0,7)
        Lb.BackgroundTransparency=1; Lb.Text="Auto Steal"
        Lb.TextColor3=Color3.fromRGB(235,235,235); Lb.TextSize=12; Lb.Font=Enum.Font.GothamBold
        Lb.TextXAlignment=Enum.TextXAlignment.Left
        local stealDesc=Instance.new("TextLabel",Row)
        stealDesc.Size=UDim2.new(1,-86,0,16); stealDesc.Position=UDim2.new(0,14,0,28)
        stealDesc.BackgroundTransparency=1; stealDesc.Visible=true
        stealDesc.TextColor3=Color3.fromRGB(162,162,168); stealDesc.TextSize=9; stealDesc.Font=Enum.Font.GothamMedium
        stealDesc.TextXAlignment=Enum.TextXAlignment.Left
        updateAutoStealSubtitle=function() stealDesc.Text="NORMAL  /  "..tostring(normalStealVersion).." PRESET  /  61 STUDS" end
        updateAutoStealSubtitle()

        
        
        local modeBtn=Instance.new("TextButton",Row)
        modeBtn.Size=UDim2.new(0,84,0,22); modeBtn.Position=UDim2.new(0,104,0,10)
        modeBtn.BackgroundColor3=_ACC.accentBg; modeBtn.BackgroundTransparency=0.30
        modeBtn.BorderSizePixel=0; modeBtn.ZIndex=6
        modeBtn.Visible=false
        modeBtn.Font=Enum.Font.FredokaOne; modeBtn.TextSize=8
        modeBtn.TextColor3=Color3.fromRGB(159,159,159)
        guiCorner(modeBtn,7)
        local modeBtnStroke=guiStroke(modeBtn,_ACC.accentDark,1)

        local function updateModeBtn()
            if stealMode=="op" then
                modeBtn.Text="OP  +"
                tw(modeBtn,{BackgroundColor3=_ACC.accentBg,BackgroundTransparency=0.05})
                modeBtn.TextColor3=_ACC.accent
                if modeBtnStroke then modeBtnStroke.Color=_ACC.accentDark end
            else
                modeBtn.Text="NORMAL  +"
                tw(modeBtn,{BackgroundColor3=_ACC.accentBg,BackgroundTransparency=0.16})
                modeBtn.TextColor3=Color3.fromRGB(159,159,159)
                if modeBtnStroke then modeBtnStroke.Color=_ACC.accentDark end
            end
        end
        updateModeBtn()

        modeBtn.MouseEnter:Connect(function() tw(modeBtn,{BackgroundTransparency=0}) end)
        modeBtn.MouseLeave:Connect(function() updateModeBtn() end)

        local arrowBtn=Instance.new("TextButton",Row)
        arrowBtn.Size=UDim2.new(0,84,0,22); arrowBtn.Position=UDim2.new(0,104,0,10)
        arrowBtn.BackgroundTransparency=1
        arrowBtn.Visible=false
        arrowBtn.BorderSizePixel=0; arrowBtn.Text=""; arrowBtn.TextColor3=_ACC.accent
        arrowBtn.Font=Enum.Font.FredokaOne; arrowBtn.TextSize=10; arrowBtn.ZIndex=8
        guiCorner(arrowBtn,7); local arrowStroke=guiStroke(arrowBtn,_ACC.accentDark,1); arrowStroke.Transparency=1

        local modeDrop=Instance.new("Frame",Row)
        modeDrop.Size=UDim2.new(0,84,0,0); modeDrop.Position=UDim2.new(0,104,0,40)
        modeDrop.BackgroundColor3=Color3.fromRGB(5,5,7); modeDrop.BackgroundTransparency=0.20
        modeDrop.BorderSizePixel=0; modeDrop.ClipsDescendants=true; modeDrop.ZIndex=7; modeDrop.Visible=false
        guiCorner(modeDrop,8); guiStroke(modeDrop,_ACC.accentDark,1)
        local normalChoice=Instance.new("TextButton",modeDrop)
        normalChoice.Size=UDim2.new(1,-6,0,23); normalChoice.Position=UDim2.new(0,3,0,3)
        normalChoice.BackgroundColor3=_ACC.accentBg; normalChoice.BackgroundTransparency=0.12
        normalChoice.BorderSizePixel=0; normalChoice.Text="NORMAL"; normalChoice.TextColor3=_ACC.accent
        normalChoice.Font=Enum.Font.FredokaOne; normalChoice.TextSize=8; normalChoice.ZIndex=9; guiCorner(normalChoice,6)
        local semiChoice=Instance.new("TextButton",modeDrop)
        semiChoice.Size=UDim2.new(1,-6,0,23); semiChoice.Position=UDim2.new(0,3,0,29)
        semiChoice.BackgroundColor3=Color3.fromRGB(11,11,11); semiChoice.BackgroundTransparency=0.12
        semiChoice.BorderSizePixel=0; semiChoice.Text="OP"; semiChoice.TextColor3=Color3.fromRGB(147,147,147)
        semiChoice.Font=Enum.Font.FredokaOne; semiChoice.TextSize=8; semiChoice.ZIndex=9; guiCorner(semiChoice,6)
        local dropOpen=false
        local function setDropOpen(on)
            dropOpen=on
            modeBtn.Text=(stealMode=="op" and "OP" or "NORMAL")..(on and "  -" or "  +")
            tw(modeDrop,{Size=UDim2.new(0,84,0,on and 55 or 0)},TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))
            tw(modeBtnStroke,{Transparency=on and .05 or .44},TweenInfo.new(0.18))
        end
        local function chooseStealMode(nextMode)
            nextMode="normal"
            if stealMode~=nextMode then
                local wasOn=Steal.AutoStealEnabled
                if wasOn then stopAutoSteal() end
                stealMode=nextMode; updateModeBtn(); syncStealSettingRows(true); task.delay(.25,applySearchFilter); saveConfig()
                if wasOn then startAutoSteal() end
            end
            normalChoice.BackgroundColor3=stealMode=="normal" and _ACC.accentBg or Color3.fromRGB(11,11,11)
            normalChoice.TextColor3=stealMode=="normal" and _ACC.accent or Color3.fromRGB(147,147,147)
            semiChoice.BackgroundColor3=stealMode=="op" and _ACC.accentBg or Color3.fromRGB(11,11,11)
            semiChoice.TextColor3=stealMode=="op" and _ACC.accent or Color3.fromRGB(147,147,147)
            setDropOpen(false)
        end
        arrowBtn.MouseButton1Click:Connect(function() setDropOpen(not dropOpen) end)
        normalChoice.MouseButton1Click:Connect(function() chooseStealMode("normal") end)
        arrowBtn.MouseEnter:Connect(function()
            tw(modeBtn,{BackgroundTransparency=.12},TweenInfo.new(0.16))
        end)
        arrowBtn.MouseLeave:Connect(function()
            tw(modeBtn,{BackgroundTransparency=dropOpen and .12 or .30},TweenInfo.new(0.18))
        end)
        normalChoice.MouseEnter:Connect(function() tw(normalChoice,{BackgroundColor3=_ACC.accentHover},TweenInfo.new(0.14)) end)
        normalChoice.MouseLeave:Connect(function() tw(normalChoice,{BackgroundColor3=stealMode=="normal" and _ACC.accentBg or Color3.fromRGB(11,11,11)},TweenInfo.new(0.16)) end)
        semiChoice.MouseEnter:Connect(function() tw(semiChoice,{BackgroundColor3=_ACC.accentHover},TweenInfo.new(0.14)) end)
        semiChoice.MouseLeave:Connect(function() tw(semiChoice,{BackgroundColor3=stealMode=="op" and _ACC.accentBg or Color3.fromRGB(11,11,11)},TweenInfo.new(0.16)) end)
        chooseStealMode(stealMode)

        
        table.insert(_themeExtRefs,{callback=function(thm)
            pcall(function()
                if stealMode=="op" then
                    tw(modeBtn,{BackgroundColor3=thm.accentBg})
                    modeBtn.TextColor3=thm.accent
                    if modeBtnStroke then modeBtnStroke.Color=thm.accentDark end
                end
            end)
        end})

        
        local OFF_TRACK=Color3.fromRGB(11,11,11); local OFF_KNOB=Color3.fromRGB(73,73,73)
        local Track=Instance.new("Frame",Row)
        Track.Size=UDim2.new(0,42,0,22); Track.Position=UDim2.new(1,-54,0,16)
        Track.BackgroundColor3=Steal.AutoStealEnabled and _ACC.accentBg or OFF_TRACK
        Track.BackgroundTransparency=0.2; Track.BorderSizePixel=0
        guiCorner(Track,10)
        local TrkStroke=guiStroke(Track,_ACC.accentDark,1)
        local Knob=Instance.new("Frame",Track)
        Knob.Size=UDim2.new(0,18,0,18)
        Knob.Position=Steal.AutoStealEnabled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
        Knob.BackgroundColor3=Steal.AutoStealEnabled and _ACC.accent or OFF_KNOB
        Knob.BackgroundTransparency=Steal.AutoStealEnabled and 0.05 or 0.15
        Knob.BorderSizePixel=0; guiCorner(Knob,9)

        local statusDot=Instance.new("Frame",Row)
        statusDot.Size=UDim2.new(0,6,0,6); statusDot.Position=UDim2.new(0,0,0,0)
        statusDot.BorderSizePixel=0; statusDot.Visible=false; guiCorner(statusDot,3)
        local statusLbl=Instance.new("TextLabel",Row)
        statusLbl.Size=UDim2.new(0,0,0,0); statusLbl.Position=UDim2.new(0,0,0,0)
        statusLbl.BackgroundTransparency=1; statusLbl.TextSize=8; statusLbl.Font=Enum.Font.FredokaOne; statusLbl.Visible=false
        statusLbl.TextXAlignment=Enum.TextXAlignment.Left

        local stealToggleSt=Steal.AutoStealEnabled
        local function setStealV(on)
            stealToggleSt=on
            Row:SetAttribute("ImpulseEnabled",on==true)
            if on then playFeatureEffect(Row) end
            tw(Knob,{Position=on and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)})
            tw(Knob,{BackgroundColor3=on and _ACC.accent or OFF_KNOB,BackgroundTransparency=on and 0.05 or 0.15})
            tw(Track,{BackgroundColor3=on and _ACC.accentBg or OFF_TRACK})
            statusDot.BackgroundColor3=on and _ACC.accent or _ACC.accentDark
            statusLbl.Text=on and "ON" or "OFF"
            statusLbl.TextColor3=on and Color3.fromRGB(192,192,192) or Color3.fromRGB(126,126,126)
            if TrkStroke then TrkStroke.Color=_ACC.accentDark end
        end
        configToggleSetters["Auto Steal"]=setStealV
        table.insert(_themeToggleRefs,{track=Track,trkStroke=TrkStroke,knob=Knob,
            offTrack=OFF_TRACK,offKnob=OFF_KNOB,offStroke=_ACC.accentDark,
            getSt=function() return stealToggleSt end})

        setStealV(stealToggleSt)
        table.insert(_themeExtRefs,{callback=function(thm)
            pcall(function()
                topGlow.BackgroundColor3=thm.accent; arrowBtn.TextColor3=thm.accent; arrowStroke.Color=thm.accentDark
            end)
        end})

        local ToggleBtn=Instance.new("TextButton",Row)
        ToggleBtn.Size=UDim2.new(0,42,0,22); ToggleBtn.Position=UDim2.new(1,-54,0,16)
        ToggleBtn.BackgroundTransparency=1; ToggleBtn.Text=""; ToggleBtn.ZIndex=8
        ToggleBtn.MouseButton1Click:Connect(function()
            stealToggleSt=not stealToggleSt; setStealV(stealToggleSt)
            Steal.AutoStealEnabled=stealToggleSt
            if stealToggleSt then startAutoSteal() else stopAutoSteal() end
            saveConfig()
        end)

        local hov=Instance.new("TextButton",Row)
        hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
        hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.18,BackgroundColor3=_ACC.accentRowHover}); autoStealStroke.Color=_ACC.accentDark end)
        hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=.08,BackgroundColor3=C.row}); autoStealStroke.Color=C.divider end)
    end

    do
        normalVersionRow=Instance.new("Frame",b)
        normalVersionRow.Name="NormalStealVersion"; normalVersionRow.Size=UDim2.new(1,0,0,54); normalVersionRow.LayoutOrder=2
        normalVersionRow.BackgroundColor3=C.row; normalVersionRow.BackgroundTransparency=.10; normalVersionRow.BorderSizePixel=0
        guiCorner(normalVersionRow,8); local versionStroke=guiStroke(normalVersionRow,C.divider,1); versionStroke.Transparency=.48
        local versionLabel=Instance.new("TextLabel",normalVersionRow)
        versionLabel.Size=UDim2.new(0,76,1,0); versionLabel.Position=UDim2.fromOffset(12,0); versionLabel.BackgroundTransparency=1
        versionLabel.Text="STEAL PRESET"; versionLabel.TextColor3=Color3.fromRGB(222,222,225); versionLabel.TextSize=9
        versionLabel.Font=Enum.Font.GothamBold; versionLabel.TextXAlignment=Enum.TextXAlignment.Left
        local choiceHolder=Instance.new("Frame",normalVersionRow)
        choiceHolder.Size=UDim2.new(1,-98,0,30); choiceHolder.Position=UDim2.new(0,90,.5,-15)
        choiceHolder.BackgroundTransparency=1; choiceHolder.BorderSizePixel=0
        local choiceLayout=Instance.new("UIListLayout",choiceHolder)
        choiceLayout.FillDirection=Enum.FillDirection.Horizontal; choiceLayout.HorizontalAlignment=Enum.HorizontalAlignment.Right
        choiceLayout.VerticalAlignment=Enum.VerticalAlignment.Center; choiceLayout.Padding=UDim.new(0,4)
        local versionButtons={}
        refreshNormalVersionButtons=function()
            for version,button in pairs(versionButtons) do
                local selected=version==normalStealVersion
                button.BackgroundColor3=selected and _ACC.accent or _ACC.accentBg
                button.BackgroundTransparency=selected and .28 or .75
                button.TextColor3=selected and Color3.fromRGB(8,8,8) or Color3.fromRGB(218,218,222)
            end
        end
        for index,version in ipairs({"75","80","86","90"}) do
            local button=Instance.new("TextButton",choiceHolder)
            button.Name="Version"..version; button.Size=UDim2.new(.25,-3,1,0); button.LayoutOrder=index
            button.BorderSizePixel=0; button.Text=version; button.Font=Enum.Font.GothamBold; button.TextSize=10
            button:SetAttribute("N5VersionChoice",true); guiCorner(button,7); versionButtons[version]=button
            button.MouseButton1Click:Connect(function()
                normalStealVersion=version; Steal.StealRadius=61; refreshNormalVersionButtons(); if updateAutoStealSubtitle then updateAutoStealSubtitle() end; saveConfig()
            end)
            button.MouseEnter:Connect(function() if normalStealVersion~=version then button.BackgroundColor3=_ACC.accentHover end end)
            button.MouseLeave:Connect(refreshNormalVersionButtons)
        end
        refreshNormalVersionButtons()
        table.insert(_themeExtRefs,{callback=function(thm) pcall(function()
            versionStroke.Color=thm.divider; refreshNormalVersionButtons()
        end) end})
    end

    radiusRow,radiusBox=addInputRow(b,"Grab Radius",61,3,function() Steal.StealRadius=61; if radiusBox then radiusBox.Text="61" end; saveConfig() end)
    radiusBox.Text="61"; radiusBox.TextEditable=false; radiusBox.ClearTextOnFocus=false
    durationRow,durationBox=addInputRow(b,"Steal Duration",Steal.StealDuration,4,function(v) Steal.StealDuration=tonumber(v) or 1.3; saveConfig() end)
    syncStealSettingRows(false)
    _GACC.syncStealConfigUI=function()
        setStealV(Steal.AutoStealEnabled); chooseStealMode(stealMode)
        if refreshNormalVersionButtons then refreshNormalVersionButtons() end
        if updateAutoStealSubtitle then updateAutoStealSubtitle() end
        if radiusBox then radiusBox.Text=tostring(Steal.StealRadius) end
        if durationBox then durationBox.Text=tostring(Steal.StealDuration) end
    end
    end

    do local b=mkSection(cp,"ACTIONS",4)
    addActionRow(b,"Drop Brainrot","dropBrainrot",function() runDrop() end,1)
    addActionRow(b,"TP Down","tpDown",function() runTPFloor() end,2)
    end

    do local b=mkSection(cp,"HIGHLIGHT",5)
    addToggleRow(b,"Player Highlight",_GACC.playerHighlightEnabled,1,nil,function(on)
        _GACC.playerHighlightEnabled=on
        if on then _GACC.startESP() else _GACC.stopESP() end
        saveConfig()
    end)
    end

    end 

    
    do
    local mv=CategoryRefs.contents["Movement"]
    do local b=mkSection(mv,"AUTO PATHS",0)
    _GACC.extras.addDropdownRow(b,"Auto Play",{"SEMI","FULL"},_GACC.autoPlayMode,1,function(mode)
        _GACC.autoPlayMode=mode=="SEMI" and "SEMI" or "FULL"
        saveConfig()
    end)
    local _,svAutoLeft=addToggleRow(b,"Auto Left",autoLeftEnabled,2,"autoLeft",function(on)
        if on then
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true;startAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
        else autoLeftEnabled=false;stopAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        saveConfig()
    end)
    autoLeftSetVisual=svAutoLeft
    local _,svAutoRight=addToggleRow(b,"Auto Right",autoRightEnabled,3,"autoRight",function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true;startAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
        else autoRightEnabled=false;stopAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        saveConfig()
    end)
    autoRightSetVisual=svAutoRight
    end

    do local b=mkSection(mv,"SETTINGS",1)
    local _,svAutoTP=addToggleRow(b,"Auto TP",autoTPEnabled,1,nil,function(on) autoTPEnabled=on;if on then startAutoTP() else stopAutoTP() end;saveConfig() end)
    setAutoTPVisual=svAutoTP
    addInputRow(b,"TP Height",autoTPHeight,2,function(v) if v>=0 and v<=500 then autoTPHeight=v end;saveConfig() end)
    local _,svInfJump=addToggleRow(b,"Infinite Jump",infJumpEnabled,3,nil,function(on)
        infJumpEnabled=on
        if on and infJumpMode=="hold" then startHoldInfJump() else stopHoldInfJump() end
        saveConfig()
    end)
    _GACC.extras.addDropdownRow(b,"Jump Mode",{"SINGLE","HOLD"},string.upper(infJumpMode),4,function(mode)
        stopHoldInfJump(); infJumpMode=string.lower(mode)
        if infJumpEnabled and infJumpMode=="hold" then startHoldInfJump() end
        saveConfig()
    end)
    end

    end 

    
    applyColorTheme = function(name,skipSave)
        local baseTheme = THEME_DEFS[name]; if not baseTheme then return end
        local thm=intensityTheme(baseTheme,themeIntensity)
        local previousTheme={accent=_ACC.accent,accentDark=_ACC.accentDark,accentBg=_ACC.accentBg,accentHover=_ACC.accentHover,accentRowHover=_ACC.accentRowHover,bg=C.bg,bgDark=C.bgDark,row=C.row,input=C.input,divider=C.divider}
        currentColorTheme = name
        
        _ACC.accent=thm.accent; _ACC.accentDark=thm.accentDark
        _ACC.accentBg=thm.accentBg; _ACC.accentHover=thm.accentHover
        _ACC.accentRowHover=thm.accentRowHover
        
        _GACC.accent=thm.accent; _GACC.accentDark=thm.accentDark
        _GACC.accentBg=thm.accentBg; _GACC.accentHover=thm.accentHover
        _GACC.accentRowHover=thm.accentRowHover
        
        for _,_r in ipairs(_themeExtRefs) do pcall(_r.callback,thm) end
        for _,entry in pairs(espObjects or {}) do pcall(function()
            if entry.highlight then
                entry.highlight.FillColor=Color3.fromRGB(88,0,16)
                entry.highlight.OutlineColor=Color3.fromRGB(242,30,58)
            end
        end) end
        
        C.neutral=thm.accent; C.accent=thm.accent; C.accentDark=thm.accentDark
        C.accentBg=thm.accentBg; C.accentHover=thm.accentHover; C.accentRowHover=thm.accentRowHover
        C.bg=thm.bg; C.bgDark=thm.bgDark; C.row=thm.row; C.input=thm.input; C.divider=thm.divider

        local function colorNear(a,b)
            return math.abs(a.R-b.R)+math.abs(a.G-b.G)+math.abs(a.B-b.B)<.035
        end
        local function themeColor(color,includeNeutralSurface)
            for _,key in ipairs({"accent","accentDark","accentBg","accentHover","accentRowHover","bg","bgDark","row","input","divider"}) do
                if thm[key] and math.abs(color.R-thm[key].R)+math.abs(color.G-thm[key].G)+math.abs(color.B-thm[key].B)<.006 then return color end
            end
            for _,key in ipairs({"accent","accentDark","accentBg","accentHover","accentRowHover","bg","bgDark","row","input","divider"}) do
                if previousTheme[key] and colorNear(color,previousTheme[key]) then return thm[key] or color end
            end
            if color.B>color.G*1.08 and color.R>color.G*1.04 and color.B>.32 then
                local brightness=(color.R+color.G+color.B)/3
                return thm.accent:Lerp(Color3.fromRGB(248,248,250),math.clamp((brightness-.38)/.55,0,.82))
            end
            if includeNeutralSurface then
                local maximum=math.max(color.R,color.G,color.B); local minimum=math.min(color.R,color.G,color.B)
                if maximum-minimum<.018 and maximum<.105 then
                    if maximum<.018 then return thm.bgDark elseif maximum<.05 then return thm.bg else return thm.row end
                end
            end
            return color
        end
        for _,object in ipairs(GuiHub:GetDescendants()) do
            pcall(function()
                if object:IsA("GuiObject") then
                    if object.Name=="ThemeAccentRail" then object.BackgroundColor3=thm.accent
                    elseif object.BackgroundTransparency<1 then object.BackgroundColor3=themeColor(object.BackgroundColor3,true) end
                end
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then object.TextColor3=themeColor(object.TextColor3,false) end
                if (object:IsA("ImageLabel") or object:IsA("ImageButton")) and object:GetAttribute("N5PreserveImageColor")~=true then object.ImageColor3=themeColor(object.ImageColor3,false) end
                if object:IsA("UIStroke") then
                    local mapped=themeColor(object.Color,false)
                    local maximum=math.max(mapped.R,mapped.G,mapped.B); local minimum=math.min(mapped.R,mapped.G,mapped.B)
                    if mapped==object.Color and maximum-minimum<.018 and maximum<.30 then mapped=thm.divider end
                    object.Color=mapped
                elseif object:IsA("UIGradient") then
                    local points={}
                    for _,point in ipairs(object.Color.Keypoints) do table.insert(points,ColorSequenceKeypoint.new(point.Time,themeColor(point.Value,false))) end
                    object.Color=ColorSequence.new(points)
                elseif object:IsA("ScrollingFrame") then
                    object.ScrollBarImageColor3=themeColor(object.ScrollBarImageColor3,false)
                end
            end)
        end
        pcall(function() Inner.BackgroundColor3=thm.bg end)
        pcall(function() if bgGradientRef then bgGradientRef.BackgroundColor3=thm.bgDark end end)
        pcall(function() TabRail.BackgroundColor3=thm.bgDark end)
        pcall(function() SearchFrame.BackgroundColor3=thm.input end)
        pcall(function() Footer.BackgroundColor3=thm.bgDark end)
        for _,object in ipairs(GuiHub:GetDescendants()) do
            pcall(function()
                if object:IsA("GuiObject") and object.Parent and object.Parent.Name=="SectBody" and object.BackgroundTransparency<1 then
                    object.BackgroundColor3=thm.row
                end
            end)
        end
        
        for _,f in ipairs(_themeSeps)       do pcall(function() f.BackgroundColor3=thm.accent end) end
        for _,f in ipairs(_themeScrollbars) do pcall(function() f.ScrollBarImageColor3=thm.accent end) end
        for _,r in ipairs(_themeSectRefs)   do
            pcall(function() r.arrow.TextColor3=thm.accent end)
            pcall(function() r.lbl.TextColor3=thm.accentDark end)
        end
        for _,tb in ipairs(_themeTabBtns) do
            pcall(function()
                local ac=(CategoryRefs.active==tb.name)
                tb.btn.TextColor3 = ac and thm.accent or Color3.fromRGB(69,69,69)
            end)
        end
        for _,ind in ipairs(_themeTabInds) do pcall(function() ind.BackgroundColor3=thm.accent end) end
        
        for _,tgl in ipairs(_themeToggleRefs) do pcall(function()
            if tgl.getSt() then
                tgl.track.BackgroundColor3=thm.accentBg
                tgl.knob.BackgroundColor3=thm.accent
                if tgl.trkStroke then tgl.trkStroke.Color=thm.accentDark end
            end
        end) end
        for _,ab in ipairs(_themeActBtns)  do
            pcall(function() ab.BackgroundColor3=thm.accentBg end)
            pcall(function() ab.TextColor3=thm.accent end)
        end
        for _,kb in ipairs(_themeKbLabels) do
            pcall(function()
                kb.BackgroundColor3=thm.accentBg
                kb.TextColor3=thm.accent
                kb.BackgroundTransparency=.3
            end)
        end
        
        for _,s in ipairs(_themeSwatchStrokes) do
            local ac=(s.name==name)
            TweenService:Create(s.stroke,TweenInfo.new(0.15),{
                Color=ac and Color3.fromRGB(255,255,255) or Color3.fromRGB(61,61,61),
                Transparency=ac and 0.05 or 0.5, Thickness=ac and 2.5 or 1
            }):Play()
        end
        pcall(applySearchFilter)
        if not skipSave then saveConfig() end
    end

    
    do
    local vi=CategoryRefs.contents["Visual"]

    do local b=mkSection(vi,"AVATAR",0)
    local packNames={}; for name in pairs(_GACC.extras.packs) do table.insert(packNames,name) end; table.sort(packNames)
    _GACC.extras.addDropdownRow(b,"Anim Pack",packNames,_GACC.extras.getPack(),1,function(name)
        if unwalkEnabled or unwalkSavedAnimate then
            unwalkEnabled=false; stopUnwalk(); if _GACC.unwalkSetVisual then _GACC.unwalkSetVisual(false) end
        end
        if not _GACC.extras.setPack(name,false) then return end
        task.spawn(function()
            local applied=_GACC.extras.applyPack(name,LP.Character)
            if not applied and _GACC.extras.getPack()==name then
                task.wait(.25)
                if _GACC.extras.getPack()==name then _GACC.extras.applyPack(name,LP.Character) end
            end
            saveConfig()
        end)
    end)
    addToggleRow(b,"Headless",_GACC.extras.getHeadless(),2,nil,function(on) _GACC.extras.setHeadless(on,LP.Character); saveConfig() end)
    addToggleRow(b,"Korblox",_GACC.extras.getKorblox(),3,nil,function(on) _GACC.extras.setKorblox(on,LP.Character); saveConfig() end)
    end

    do local b=mkSection(vi,"VISUAL",1)
    addToggleRow(b,"Intro Song",introSoundEnabled,1,nil,function(on)
        introSoundEnabled=on
        if not on and introSoundInstance and introSoundInstance.IsPlaying then pcall(function() introSoundInstance:Stop() end) end
        saveConfig()
    end)
    addToggleRow(b,"Show Intro",introEnabled,2,nil,function(on)
        introEnabled=on==true
        saveConfig()
        silentSaveFront()
    end)
    addToggleRow(b,"Anti Lag",antiLagEnabled,3,nil,function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)
    addToggleRow(b,"Stretch Rez",stretchRezEnabled,4,nil,function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end)
    addToggleRow(b,"Ragdoll GUI",ragdollGuiEnabled,5,nil,function(on) ragdollGuiEnabled=on;saveConfig() end)
    addToggleRow(b,"Lock Mobile Buttons",mobileButtonsLocked,6,nil,function(on)
        mobileButtonsLocked=on==true
        State.MobileButtonsLocked=mobileButtonsLocked
        if _GACC.refreshMobileLock then _GACC.refreshMobileLock() end
        silentSaveFront()
        saveConfig()
    end)
    end





    local viFovBody=mkSection(vi,"FOV",3)
    do 
    local fovRow=Instance.new("Frame"); fovRow.Size=UDim2.new(1,0,0,38); fovRow.BackgroundColor3=C.row
    fovRow.BackgroundTransparency=0.5; fovRow.BorderSizePixel=0; fovRow.LayoutOrder=1; fovRow.Parent=viFovBody
    guiCorner(fovRow,10); guiStroke(fovRow,C.divider,1)
    local fovLbl=Instance.new("TextLabel",fovRow); fovLbl.Size=UDim2.new(0.5,0,0,16); fovLbl.Position=UDim2.new(0,12,0,6)
    fovLbl.BackgroundTransparency=1; fovLbl.Text="FOV"; fovLbl.TextColor3=C.text; fovLbl.TextSize=11; fovLbl.Font=Enum.Font.FredokaOne; fovLbl.TextXAlignment=Enum.TextXAlignment.Left
    local fovBtn=Instance.new("TextButton",fovRow); fovBtn.Size=UDim2.new(0,52,0,22)
    fovBtn.AnchorPoint=Vector2.new(1,0.5); fovBtn.Position=UDim2.new(1,-12,0.5,0); fovBtn.AutomaticSize=Enum.AutomaticSize.X
    fovBtn.BackgroundColor3=_ACC.accentBg; fovBtn.BackgroundTransparency=0.3; fovBtn.BorderSizePixel=0
    fovBtn.Text=tostring(fovValue); fovBtn.TextColor3=_ACC.accent
    table.insert(_themeActBtns,fovBtn); fovBtn.TextSize=11; fovBtn.Font=Enum.Font.FredokaOne; guiCorner(fovBtn,5)
    do local fovBtnPad=Instance.new("UIPadding",fovBtn); fovBtnPad.PaddingLeft=UDim.new(0,10); fovBtnPad.PaddingRight=UDim.new(0,10) end
    fovBtn.MouseButton1Click:Connect(function()
        fovIndex=fovIndex%#fovOptions+1
        fovValue=fovOptions[fovIndex]
        State.Fov=fovValue
        fovBtn.Text=tostring(fovValue)
        applyFOV()
        saveConfig()
    end)
    fovBtn.MouseEnter:Connect(function() tw(fovBtn,{BackgroundTransparency=0.05}); tw(fovBtn,{BackgroundColor3=_ACC.accentHover}) end)
    fovBtn.MouseLeave:Connect(function() tw(fovBtn,{BackgroundTransparency=0.3}); tw(fovBtn,{BackgroundColor3=_ACC.accentBg}) end)
    configDropdownSetters["FOV"]=function(value) fovBtn.Text=tostring(value) end
    local hov3=Instance.new("TextButton",fovRow); hov3.Size=UDim2.new(1,0,1,0); hov3.BackgroundTransparency=1; hov3.Text=""; hov3.ZIndex=0
    hov3.MouseEnter:Connect(function() tw(fovRow,{BackgroundTransparency=0.2}); tw(fovRow,{BackgroundColor3=_ACC.accentRowHover}) end)
    hov3.MouseLeave:Connect(function() tw(fovRow,{BackgroundTransparency=0.5}); tw(fovRow,{BackgroundColor3=C.row}) end)
    end 


    end 

    do
        local settingsPage=CategoryRefs.contents["Settings"]

        local configNoticeToken=0
        local function configNotice(message)
            configNoticeToken=configNoticeToken+1; local token=configNoticeToken
            statusFooter.Text=""
        end

        local function openConfigDialog(title,initial,placeholder,confirmText,readOnly,onConfirm)
            local old=Inner:FindFirstChild("ConfigDialog"); if old then old:Destroy() end
            local shade=Instance.new("TextButton",Inner); shade.Name="ConfigDialog"; shade.Size=UDim2.fromScale(1,1)
            shade.BackgroundColor3=Color3.fromRGB(0,0,0); shade.BackgroundTransparency=.18; shade.BorderSizePixel=0
            shade.Text=""; shade.AutoButtonColor=false; shade.ZIndex=80
            local card=Instance.new("Frame",shade); card.AnchorPoint=Vector2.new(.5,.5); card.Position=UDim2.fromScale(.5,.5)
            card.Size=UDim2.new(1,-54,0,readOnly and 248 or 196); card.BackgroundColor3=C.bg; card.BackgroundTransparency=.01
            card.BorderSizePixel=0; card.ZIndex=81; guiCorner(card,13); local cardStroke=guiStroke(card,_ACC.accentDark,1.3); cardStroke.Transparency=.08
            local titleLabel=Instance.new("TextLabel",card); titleLabel.Size=UDim2.new(1,-34,0,38); titleLabel.Position=UDim2.fromOffset(17,8)
            titleLabel.BackgroundTransparency=1; titleLabel.Text=title; titleLabel.TextColor3=C.text; titleLabel.TextSize=14
            titleLabel.Font=Enum.Font.FredokaOne; titleLabel.TextXAlignment=Enum.TextXAlignment.Left; titleLabel.ZIndex=82
            local box=Instance.new("TextBox",card); box.Size=UDim2.new(1,-34,0,readOnly and 134 or 82); box.Position=UDim2.fromOffset(17,49)
            box.BackgroundColor3=C.input; box.BackgroundTransparency=.06; box.BorderSizePixel=0; box.Text=tostring(initial or "")
            box.PlaceholderText=placeholder or ""; box.PlaceholderColor3=C.textMuted; box.TextColor3=C.textDim; box.TextSize=10
            box.Font=Enum.Font.FredokaOne; box.ClearTextOnFocus=false; box.MultiLine=true; box.TextWrapped=true
            box.TextXAlignment=Enum.TextXAlignment.Left; box.TextYAlignment=Enum.TextYAlignment.Top
            pcall(function() box.TextEditable=true end)
            box.ZIndex=82; guiCorner(box,9); local boxStroke=guiStroke(box,C.divider,1); boxStroke.Transparency=.28
            local boxPad=Instance.new("UIPadding",box); boxPad.PaddingLeft=UDim.new(0,10); boxPad.PaddingRight=UDim.new(0,10)
            boxPad.PaddingTop=UDim.new(0,8); boxPad.PaddingBottom=UDim.new(0,8)
            local cancel=Instance.new("TextButton",card); cancel.Size=UDim2.new(.5,-21,0,34); cancel.Position=UDim2.new(0,17,1,-48)
            cancel.BackgroundColor3=C.row; cancel.BackgroundTransparency=.04; cancel.BorderSizePixel=0; cancel.Text="CANCEL"
            cancel.TextColor3=C.textMuted; cancel.TextSize=9; cancel.Font=Enum.Font.FredokaOne; cancel.ZIndex=82; guiCorner(cancel,8)
            local confirm=Instance.new("TextButton",card); confirm.Size=UDim2.new(.5,-21,0,34); confirm.Position=UDim2.new(.5,4,1,-48)
            confirm.BackgroundColor3=_ACC.accentBg; confirm.BackgroundTransparency=.02; confirm.BorderSizePixel=0; confirm.Text=confirmText or "SAVE"
            confirm.TextColor3=_ACC.accent; confirm.TextSize=9; confirm.Font=Enum.Font.FredokaOne; confirm.ZIndex=82; guiCorner(confirm,8)
            local confirmStroke=guiStroke(confirm,_ACC.accentDark,1); confirmStroke.Transparency=.16
            local closing=false
            local function close()
                if closing then return end; closing=true
                TweenService:Create(shade,TweenInfo.new(.12),{BackgroundTransparency=1}):Play()
                task.delay(.13,function() if shade then shade:Destroy() end end)
            end
            cancel.MouseButton1Click:Connect(close)
            confirm.MouseButton1Click:Connect(function()
                local ok,message=onConfirm and onConfirm(box.Text)
                if ok==false then
                    titleLabel.Text=string.upper(tostring(message or "INVALID CONFIG")); titleLabel.TextColor3=Color3.fromRGB(241,92,150)
                    cardStroke.Color=Color3.fromRGB(210,55,121); return
                end
                close()
            end)
            task.defer(function()
                box:CaptureFocus()
                if readOnly then pcall(function() box.CursorPosition=1; box.SelectionStart=#box.Text+1 end) end
            end)
            table.insert(_themeExtRefs,{callback=function(thm) pcall(function()
                card.BackgroundColor3=thm.bg; cardStroke.Color=thm.accentDark; box.BackgroundColor3=thm.input
                boxStroke.Color=thm.divider; confirm.BackgroundColor3=thm.accentBg; confirm.TextColor3=thm.accent; confirmStroke.Color=thm.accentDark
            end) end})
        end

        local configActions=mkSection(settingsPage,"CONFIG SHARING",-2)
        addActionRow(configActions,"Generate Share Config",nil,function()
            local exported=ConfigShare.export()
            openConfigDialog("SHARE CONFIG",exported,"","COPY",true,function(value)
                local copied=false
                if setclipboard then copied=pcall(setclipboard,value) elseif toclipboard then copied=pcall(toclipboard,value) end
                if not copied then return false,"PRESS CTRL+A, THEN CTRL+C" end
                configNotice("Config copied"); return true
            end)
        end,1)
        addActionRow(configActions,"Import Shared Config",nil,function()
            openConfigDialog("IMPORT CONFIG","","Paste an N5 Duels config here","IMPORT",false,function(value)
                local ok,message=ConfigShare.import(value); if not ok then return false,message end
                configNotice("Config imported"); return true
            end)
        end,2)

        local interfaceBody=mkSection(settingsPage,"INTERFACE",0)
        local themeOptions={"IMPULSE","NEON","MIDNIGHT","MINIMAL","HIGH CONTRAST","CRIMSON","EMERALD","AMBER","ROSE","MONOCHROME"}
        _GACC.extras.addDropdownRow(interfaceBody,"Theme",themeOptions,currentColorTheme,1,function(name)
            if THEME_DEFS[name] then applyColorTheme(name,false) end
        end)
        addSliderRow(interfaceBody,"Theme Intensity",.35,1.5,themeIntensity,.05,2,function(value,finished)
            themeIntensity=value
            applyColorTheme(currentColorTheme,true)
            if finished then saveConfig() end
        end)
        addKeybindRow(interfaceBody,"Minimize UI","guiHide",3)
        addToggleRow(interfaceBody,"Click Sounds",clickSoundsEnabled,4,nil,function(on)
            clickSoundsEnabled=on
            saveConfig()
        end)
        addToggleRow(interfaceBody,"Lock Mobile Buttons",mobileButtonsLocked,8,nil,function(on)
            mobileButtonsLocked=on==true
            State.MobileButtonsLocked=mobileButtonsLocked
            if _GACC.refreshMobileLock then _GACC.refreshMobileLock() end
            silentSaveFront()
            saveConfig()
        end)
        addSliderRow(interfaceBody,"UI Width",ConfigShare.minWidth,ConfigShare.maxWidth,uiWidth,10,5,function(value,finished)
            if applyUIWidth then applyUIWidth(value,true) end
            if finished then saveConfig() end
        end,function(value) return tostring(math.floor(value+.5)).." PX" end)
        _GACC.extras.addDropdownRow(interfaceBody,"Tab Position",{"LEFT","TOP","RIGHT"},tabPosition,6,function(position)
            tabPosition=position
            if applyNavigationLayout then applyNavigationLayout(false) else saveConfig() end
        end)
        _GACC.extras.addDropdownRow(interfaceBody,"Tab Selector",{"TABS","SCROLLING"},navigationStyle,7,function(style)
            navigationStyle=style
            if applyNavigationLayout then applyNavigationLayout(false) else saveConfig() end
        end)
    end

    do
        local kbPage=CategoryRefs.contents["Keybinds"]
    local kbBody=mkSection(kbPage,"BINDS",0)
    addKeybindRow(kbBody,"Speed Toggle",         "speed",       2)
    addKeybindRow(kbBody,"Carry Mode",           "carryMode",   3)
    addKeybindRow(kbBody,"Lagger Mode",          "laggerToggle",4)
    addKeybindRow(kbBody,"Bat Aimbot",           "circle",      5)
    addKeybindRow(kbBody,"Bat Desync TP",        "batDesyncTp", 6)
    addKeybindRow(kbBody,"Auto Left",            "autoLeft",    7)
    addKeybindRow(kbBody,"Auto Right",           "autoRight",   8)
    addKeybindRow(kbBody,"Drop Brainrot",        "dropBrainrot",9)
    addKeybindRow(kbBody,"TP Down",              "tpDown",      10)
    end

    _GACC.applyLoadedConfigUI=function()
        local function setValue(registry,label,value) if registry[label] and value~=nil then pcall(registry[label],value) end end
        setValue(configInputSetters,"Normal Speed",NS)
        setValue(configInputSetters,"Carry Speed",CS)
        setValue(configInputSetters,"Lagger Normal",LAGGER_SPEED)
        setValue(configInputSetters,"Lagger Carry",LAGGER_CARRY_SPEED)
        setValue(configInputSetters,"TP Height",autoTPHeight)
        setValue(configSliderSetters,"Theme Intensity",themeIntensity)
        setValue(configSliderSetters,"UI Width",uiWidth)
        for label,value in pairs({
            ["Carry Mode"]=carrySpeedActive,["Lagger Mode"]=laggerModeEnabled,["Auto Carry Speed"]=_GACC.autoCarrySpeedEnabled,
            ["Bat Aimbot"]=autoBatEnabled,["Bat Desync TP"]=batDesyncTpEnabled,["Auto Swing"]=autoSwingEnabled,
            ["Anti Ragdoll"]=antiRagdollEnabled,["Anti Die & Fling"]=antiDieFlingEnabled,["Medusa Counter"]=medusaCounterEnabled,
            ["Unwalk"]=unwalkEnabled,["Stop Time Enabled"]=SemiSteal.CONFIG.STOP_TIME_ENABLED,
            ["Player Highlight"]=_GACC.playerHighlightEnabled,["Auto Left"]=autoLeftEnabled,["Auto Right"]=autoRightEnabled,
            ["Auto TP"]=autoTPEnabled,["Infinite Jump"]=infJumpEnabled,["Headless"]=_GACC.extras.getHeadless(),
            ["Korblox"]=_GACC.extras.getKorblox(),["Intro Song"]=introSoundEnabled,["Show Intro"]=introEnabled,["Anti Lag"]=antiLagEnabled,
            ["Stretch Rez"]=stretchRezEnabled,["Ragdoll GUI"]=ragdollGuiEnabled,["Lock Mobile Buttons"]=mobileButtonsLocked,["Click Sounds"]=clickSoundsEnabled,
        }) do setValue(configToggleSetters,label,value) end
        setValue(configDropdownSetters,"Jump Mode",string.upper(infJumpMode))
        setValue(configDropdownSetters,"TP Bat Version",batDesyncTpVersion)
        setValue(configDropdownSetters,"Anim Pack",_GACC.extras.getPack())
        setValue(configDropdownSetters,"Auto Play",_GACC.autoPlayMode)
        setValue(configDropdownSetters,"Theme",currentColorTheme)
        setValue(configDropdownSetters,"Tab Position",tabPosition)
        setValue(configDropdownSetters,"Tab Selector",navigationStyle)
        setValue(configDropdownSetters,"FOV",fovValue)
        if _GACC.syncStealConfigUI then _GACC.syncStealConfigUI() end
        if mobBtnRefs.batDesync then mobBtnRefs.batDesync(batDesyncTpEnabled) end
        for key,entry in pairs(keybindRowRefs) do if entry.keyBtn and Keys[key] then entry.keyBtn.Text=prettyKey(Keys[key]) end end
        if applyColorTheme then applyColorTheme(currentColorTheme,true) end
        if applyUIWidth then applyUIWidth(uiWidth,true) end
        if applyNavigationLayout then applyNavigationLayout(true) end
        applyFOV()
        if refreshSearchHistoryUI then refreshSearchHistoryUI() end
        updateTabBadges(); updateTabCanvas()
    end

    do
        local navOutline=Instance.new("Frame",Inner)
        navOutline.Name="KeyboardSelection"; navOutline.BackgroundTransparency=1; navOutline.BorderSizePixel=0
        navOutline.Visible=false; navOutline.Active=false; navOutline.ZIndex=40; guiCorner(navOutline,9)
        local navStroke=guiStroke(navOutline,_ACC.accent,1.6); navStroke.Transparency=.08
        local navEdge=Instance.new("Frame",navOutline)
        navEdge.Size=UDim2.new(0,3,1,-12); navEdge.Position=UDim2.new(0,2,0,6); navEdge.BackgroundColor3=_ACC.accent
        navEdge.BorderSizePixel=0; navEdge.ZIndex=41; guiCorner(navEdge,2)
        local selectedByTab={Main=0,Movement=0,Visual=0,SCROLLING=0}; local selectedObject=nil

        local function fullyVisible(object,page)
            local current=object
            while current and current~=page do
                if current:IsA("GuiObject") and current.Visible==false then return false end
                current=current.Parent
            end
            return current==page
        end

        local function navigationRows()
            local rows={}
            local pageNames=navigationStyle=="SCROLLING" and Categories or {CategoryRefs.active}
            for _,pageName in ipairs(pageNames) do
                local page=TabPages[pageName]
                if page and page.Visible then
                    for _,body in ipairs(page:GetDescendants()) do
                        if body:IsA("GuiObject") and body.Name=="SectBody" and fullyVisible(body,page) then
                            for _,row in ipairs(body:GetChildren()) do
                                if row:IsA("GuiObject") and row:GetAttribute("ImpulseModeVisible")~=false and fullyVisible(row,page) and row.AbsoluteSize.Y>4 then
                                    table.insert(rows,row)
                                end
                            end
                        end
                    end
                end
            end
            table.sort(rows,function(a,b)
                if math.abs(a.AbsolutePosition.Y-b.AbsolutePosition.Y)<2 then return a.AbsolutePosition.X<b.AbsolutePosition.X end
                return a.AbsolutePosition.Y<b.AbsolutePosition.Y
            end)
            return rows
        end

        local function updateNavigationOutline()
            if not navOutline or not navOutline.Parent then return end
            if not selectedObject or not selectedObject.Parent or not GuiRefs.outer.Visible then navOutline.Visible=false; return end
            local page=TabPages[CategoryRefs.active]
            if navigationStyle=="SCROLLING" then
                for _,candidate in pairs(TabPages) do if selectedObject:IsDescendantOf(candidate) then page=candidate; break end end
            end
            if not page or not fullyVisible(selectedObject,page) then navOutline.Visible=false; return end
            local top=selectedObject.AbsolutePosition.Y; local bottom=top+selectedObject.AbsoluteSize.Y
            local viewTop=CF.AbsolutePosition.Y; local viewBottom=viewTop+CF.AbsoluteWindowSize.Y
            if bottom<viewTop or top>viewBottom then navOutline.Visible=false; return end
            local relative=selectedObject.AbsolutePosition-Inner.AbsolutePosition
            navOutline.Position=UDim2.fromOffset(relative.X-2,relative.Y-2)
            navOutline.Size=UDim2.fromOffset(selectedObject.AbsoluteSize.X+4,selectedObject.AbsoluteSize.Y+4)
            navOutline.Visible=true
        end

        local function selectNavigationRow(direction)
            local rows=navigationRows(); if #rows==0 then selectedObject=nil; navOutline.Visible=false; return end
            local memoryKey=navigationStyle=="SCROLLING" and "SCROLLING" or CategoryRefs.active
            local index=selectedByTab[memoryKey] or 0
            if selectedObject then
                for i,row in ipairs(rows) do if row==selectedObject then index=i; break end end
            end
            index=((index-1+direction)%#rows)+1; selectedByTab[memoryKey]=index; selectedObject=rows[index]
            local top=selectedObject.AbsolutePosition.Y; local bottom=top+selectedObject.AbsoluteSize.Y
            local viewTop=CF.AbsolutePosition.Y+5; local viewBottom=CF.AbsolutePosition.Y+CF.AbsoluteWindowSize.Y-5
            local targetY=CF.CanvasPosition.Y
            if top<viewTop then targetY=targetY-(viewTop-top)
            elseif bottom>viewBottom then targetY=targetY+(bottom-viewBottom) end
            local maxY=math.max(CF.AbsoluteCanvasSize.Y-CF.AbsoluteWindowSize.Y,0)
            CF.CanvasPosition=Vector2.new(0,math.clamp(targetY,0,maxY)); TabScrollMemory[CategoryRefs.active]=CF.CanvasPosition.Y
            task.defer(updateNavigationOutline)
        end

        UIS.InputBegan:Connect(function(input,gp)
            if gp or tick()<(KeyListen.suppressUntil or 0) or KeyListen.active or UIS:GetFocusedTextBox() then return end
            if not GuiRefs.outer.Visible then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 then selectedObject=nil; navOutline.Visible=false; return end
            local code=input.KeyCode
            if code==Enum.KeyCode.Up or code==Enum.KeyCode.Left or code==Enum.KeyCode.Down or code==Enum.KeyCode.Right then
                GuiRefs.keyboardNavigationUntil=tick()+.08
                selectNavigationRow((code==Enum.KeyCode.Up or code==Enum.KeyCode.Left) and -1 or 1)
            end
        end)
        RunService.RenderStepped:Connect(updateNavigationOutline)
        task.spawn(function()
            local bright=false
            while navOutline and navOutline.Parent do
                bright=not bright
                TweenService:Create(navStroke,TweenInfo.new(.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=bright and .02 or .34}):Play()
                task.wait(.7)
            end
        end)
        table.insert(_themeExtRefs,{callback=function(thm) pcall(function() navStroke.Color=thm.accent; navEdge.BackgroundColor3=thm.accent end) end})
    end

    
    UIS.InputBegan:Connect(function(inp,gp)
        if tick()<(KeyListen.suppressUntil or 0) then return end
        if tick()<(GuiRefs.keyboardNavigationUntil or 0) then return end
        if KeyListen.active then return end
        if UIS:GetFocusedTextBox() then return end
        local isBoundKey=inp.KeyCode==Keys.guiHide or inp.KeyCode==Keys.speed or inp.KeyCode==Keys.carryMode
            or inp.KeyCode==Keys.laggerToggle or inp.KeyCode==Keys.circle or inp.KeyCode==Keys.batDesyncTp
            or inp.KeyCode==Keys.dropBrainrot or inp.KeyCode==Keys.tpDown or inp.KeyCode==Keys.autoLeft or inp.KeyCode==Keys.autoRight
        -- allow controller binds even if gameProcessed (gp) is true for gamepad buttons
        if gp and not isBoundKey then return end
        if isBoundKey then playImpulseClick(true) end
        if inp.KeyCode==Keys.guiHide then
            if GuiRefs.outer and GuiRefs.outer.Visible then
                if GuiRefs.minimize then GuiRefs.minimize() else GuiRefs.outer.Visible=false end
            elseif GuiRefs.restore then GuiRefs.restore()
            elseif GuiRefs.outer then GuiRefs.outer.Visible=true end
        elseif inp.KeyCode==Keys.speed then toggleCarryMode(); saveConfig()
        elseif inp.KeyCode==Keys.carryMode then toggleCarryMode(); saveConfig()
        elseif inp.KeyCode==Keys.laggerToggle then toggleLaggerMode(); saveConfig()
        elseif inp.KeyCode==Keys.circle then
            autoBatEnabled=not autoBatEnabled
            if autoBatEnabled then
                if batDesyncTpEnabled then batDesyncTpEnabled=false;stopBatDesyncTp();if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end;if mobBtnRefs.batDesync then mobBtnRefs.batDesync(false) end end
                startBatAimbot()
            else stopBatAimbot() end
            if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
            saveConfig()
        elseif inp.KeyCode==Keys.batDesyncTp then
            batDesyncTpEnabled=not batDesyncTpEnabled
            if batDesyncTpEnabled then
                if autoBatEnabled then autoBatEnabled=false;stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                startBatDesyncTp()
            else stopBatDesyncTp() end
            if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
            if mobBtnRefs.batDesync then mobBtnRefs.batDesync(batDesyncTpEnabled) end
            saveConfig()
        elseif inp.KeyCode==Keys.dropBrainrot then runDrop()
        elseif inp.KeyCode==Keys.tpDown then runTPFloor()
		elseif inp.KeyCode==Keys.autoLeft then
			if _GACC.autoPlayRemoved then return end
			if autoLeftEnabled then
                autoLeftEnabled=false; stopAutoLeft()
            else
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                autoLeftEnabled=true; startAutoLeft()
            end
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
		elseif inp.KeyCode==Keys.autoRight then
			if _GACC.autoPlayRemoved then return end
			if autoRightEnabled then
                autoRightEnabled=false; stopAutoRight()
            else
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                autoRightEnabled=true; startAutoRight()
            end
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
        end
    end)
    end) 

    
    function applyReadableFont(object)
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            if object.TextSize<10 then object.TextSize=10 end
            object.Font=object.TextSize>=14 and Enum.Font.GothamBold or Enum.Font.GothamMedium
        end
    end
    for _,object in ipairs(GuiHub:GetDescendants()) do applyReadableFont(object) end
    local glassBound={}
    function bindGlassSurface(object)
        if not object:IsA("GuiObject") or glassBound[object] then return end
        local color=object.BackgroundColor3
        local luminance=color.R*.2126+color.G*.7152+color.B*.0722
        if object.BackgroundTransparency>=1 or luminance>.24 then return end
        glassBound[object]=true
        local changing=false
        local function enforceGlass()
            if changing or not object.Parent then return end
            local currentColor=object.BackgroundColor3
            local currentLuminance=currentColor.R*.2126+currentColor.G*.7152+currentColor.B*.0722
            if currentLuminance<=.24 and object.BackgroundTransparency<.62 then
                changing=true; object.BackgroundTransparency=.62; changing=false
            end
        end
        enforceGlass()
        object:GetPropertyChangedSignal("BackgroundTransparency"):Connect(enforceGlass)
    end
    for _,object in ipairs(Inner:GetDescendants()) do bindGlassSurface(object) end
    Inner.DescendantAdded:Connect(function(object) task.defer(bindGlassSurface,object) end)
    function bindClickSound(object)
        if not object:IsA("GuiButton") or object:GetAttribute("ImpulseClickSoundBound")==true then return end
        object:SetAttribute("ImpulseClickSoundBound",true)
        object.MouseButton1Click:Connect(function() playImpulseClick(false) end)
    end
    for _,object in ipairs(GuiHub:GetDescendants()) do bindClickSound(object) end
    GuiHub.DescendantAdded:Connect(function(object)
        task.defer(bindClickSound,object)
        task.defer(applyReadableFont,object)
    end)
    task.defer(function()
        if applyColorTheme then applyColorTheme(currentColorTheme,true) end
        applySearchFilter(); updateTabCanvas()
    end)
    
end)()

ConfigShare.buildMobilePad=function()
    if not ConfigShare.mobile or not mobileButtonsEnabled then return end
    local playerGui=LP:WaitForChild("PlayerGui")
    local old=playerGui:FindFirstChild("ImpulseMobileControls"); if old then old:Destroy() end
    local screen=Instance.new("ScreenGui"); screen.Name="ImpulseMobileControls"; screen.ResetOnSpawn=false
    screen.IgnoreGuiInset=false; screen.DisplayOrder=55; screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; parentGui(screen)
    mobGuiRef=screen

    local panel=Instance.new("Frame",screen); panel.Name="ControlPad"; panel.AnchorPoint=Vector2.new(1,.5)
    panel.Position=UDim2.new(1,-14,.5,0); panel.Size=UDim2.fromOffset(150,291)
    panel.BackgroundColor3=Color3.fromRGB(3,2,6); panel.BackgroundTransparency=.08; panel.BorderSizePixel=0
    panel.ClipsDescendants=true; Instance.new("UICorner",panel).CornerRadius=UDim.new(0,14)
    local panelStroke=Instance.new("UIStroke",panel); panelStroke.Color=_GACC.accentDark; panelStroke.Thickness=1.3; panelStroke.Transparency=.12
    local panelGradient=Instance.new("UIGradient",panel); panelGradient.Rotation=22
    panelGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,_GACC.accentBg),ColorSequenceKeypoint.new(.35,Color3.fromRGB(7,5,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(1,1,2))})

    local header=Instance.new("Frame",panel); header.Size=UDim2.new(1,0,0,31); header.BackgroundColor3=Color3.fromRGB(6,4,9)
    header.BackgroundTransparency=.02; header.BorderSizePixel=0; header.Active=true; header.ZIndex=3
    local title=Instance.new("TextLabel",header); title.Size=UDim2.new(1,-38,1,0); title.Position=UDim2.fromOffset(11,0)
    title.BackgroundTransparency=1; title.Text="N5 CONTROLS"; title.TextColor3=Color3.fromRGB(224,221,231)
    title.TextSize=8; title.Font=Enum.Font.FredokaOne; title.TextXAlignment=Enum.TextXAlignment.Left; title.ZIndex=4
    local headerDot=Instance.new("Frame",header); headerDot.AnchorPoint=Vector2.new(1,.5); headerDot.Position=UDim2.new(1,-12,.5,0)
    headerDot.Size=UDim2.fromOffset(7,7); headerDot.BackgroundColor3=_GACC.accent; headerDot.BorderSizePixel=0; headerDot.ZIndex=4
    Instance.new("UICorner",headerDot).CornerRadius=UDim.new(1,0)
    local topRail=Instance.new("Frame",panel); topRail.Size=UDim2.new(1,-24,0,2); topRail.Position=UDim2.fromOffset(12,0)
    topRail.BackgroundColor3=_GACC.accent; topRail.BorderSizePixel=0; topRail.ZIndex=5; Instance.new("UICorner",topRail).CornerRadius=UDim.new(0,2)
    local railFade=Instance.new("UIGradient",topRail); railFade.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.22,.12),NumberSequenceKeypoint.new(.78,.12),NumberSequenceKeypoint.new(1,1)})

    local buttonRefs={}
    function makeButton(id,textValue,x,y,width,onPressed)
        local button=Instance.new("TextButton",panel); button.Name=id; button.Position=UDim2.fromOffset(x,y)
        button.Size=UDim2.fromOffset(width or 62,43); button.BackgroundColor3=Color3.fromRGB(8,7,11)
        button.BackgroundTransparency=.04; button.BorderSizePixel=0; button.AutoButtonColor=false
        button.Text=textValue; button.TextColor3=Color3.fromRGB(192,189,199); button.TextSize=8
        button.TextWrapped=true; button.Font=Enum.Font.FredokaOne; button.ZIndex=3
        Instance.new("UICorner",button).CornerRadius=UDim.new(0,10)
        local stroke=Instance.new("UIStroke",button); stroke.Color=Color3.fromRGB(46,38,55); stroke.Thickness=1; stroke.Transparency=.28
        local edge=Instance.new("Frame",button); edge.Size=UDim2.new(0,3,1,-14); edge.Position=UDim2.fromOffset(0,7)
        edge.BackgroundColor3=_GACC.accent; edge.BackgroundTransparency=.78; edge.BorderSizePixel=0; edge.ZIndex=4
        Instance.new("UICorner",edge).CornerRadius=UDim.new(0,2)
        local active=false
        local function setActive(on,newText)
            active=on==true
            if newText then button.Text=newText end
            button.BackgroundColor3=active and _GACC.accentBg or Color3.fromRGB(8,7,11)
            button.TextColor3=active and _GACC.accent or Color3.fromRGB(192,189,199)
            stroke.Color=active and _GACC.accentDark or Color3.fromRGB(46,38,55)
            stroke.Transparency=active and .04 or .28; edge.BackgroundTransparency=active and .08 or .78
        end
        button.MouseButton1Click:Connect(function()
            if _GACC.playClickSound then _GACC.playClickSound(false) end
            TweenService:Create(button,TweenInfo.new(.08),{BackgroundTransparency=.22}):Play()
            task.delay(.09,function() if button.Parent then TweenService:Create(button,TweenInfo.new(.14),{BackgroundTransparency=.04}):Play() end end)
            onPressed()
        end)
        buttonRefs[id]={button=button,stroke=stroke,edge=edge,set=setActive,get=function() return active end}
        return setActive
    end

    makeButton("Drop","DROP\nBR",9,38,63,function() runDrop() end)
    mobBtnRefs.autoLeft=makeButton("AutoLeft","AUTO\nLEFT",78,38,63,function()
        if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft()
        else
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
            if autoBatEnabled then autoBatEnabled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            autoLeftEnabled=true; startAutoLeft()
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
        saveConfig()
    end)
    mobBtnRefs.autoBat=makeButton("BatAimbot","BAT\nAIMBOT",9,87,63,function()
        autoBatEnabled=not autoBatEnabled
        if autoBatEnabled then
            if batDesyncTpEnabled then batDesyncTpEnabled=false; stopBatDesyncTp(); if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end; if mobBtnRefs.batDesync then mobBtnRefs.batDesync(false) end end
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
            startBatAimbot()
        else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
        saveConfig()
    end)
    mobBtnRefs.autoRight=makeButton("AutoRight","AUTO\nRIGHT",78,87,63,function()
        if autoRightEnabled then autoRightEnabled=false; stopAutoRight()
        else
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
            if autoBatEnabled then autoBatEnabled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            autoRightEnabled=true; startAutoRight()
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
        saveConfig()
    end)
    makeButton("TPDown","TP\nDOWN",9,136,63,function() runTPFloor() end)
    local normalSet=makeButton("NormalSpeed","NORMAL\nSPEED",78,136,63,function()
        laggerModeEnabled=false; carrySpeedActive=false
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        if _GACC.safeLaggerVisual then _GACC.safeLaggerVisual(false) end
        if _GACC.safeCarryVisual then _GACC.safeCarryVisual(false) end
        if mobBtnRefs.lagger then mobBtnRefs.lagger(false) end
        saveConfig()
    end)
    local normalCarrySet=makeButton("NormalCarry","NORMAL\nCARRY",9,185,63,function()
        laggerModeEnabled=false; carrySpeedActive=true
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        if _GACC.safeLaggerVisual then _GACC.safeLaggerVisual(false) end
        if _GACC.safeCarryVisual then _GACC.safeCarryVisual(true) end
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(true) end
        saveConfig()
    end)
    local laggerSpeedSet=makeButton("LaggerSpeed","LAGGER\nSPEED",78,185,63,function()
        laggerModeEnabled=true; carrySpeedActive=false
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        if _GACC.safeLaggerVisual then _GACC.safeLaggerVisual(true) end
        if _GACC.safeCarryVisual then _GACC.safeCarryVisual(false) end
        if mobBtnRefs.lagger then mobBtnRefs.lagger(true) end
        saveConfig()
    end)
    local laggerCarrySet=makeButton("LaggerCarry","LAGGER\nCARRY",9,234,63,function()
        laggerModeEnabled=true; carrySpeedActive=true
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        if _GACC.safeLaggerVisual then _GACC.safeLaggerVisual(true) end
        if _GACC.safeCarryVisual then _GACC.safeCarryVisual(true) end
        if mobBtnRefs.lagger then mobBtnRefs.lagger(true) end
        saveConfig()
    end)
    function refreshSpeedButtons()
        normalSet(not laggerModeEnabled and not carrySpeedActive)
        normalCarrySet(not laggerModeEnabled and carrySpeedActive)
        laggerSpeedSet(laggerModeEnabled and not carrySpeedActive)
        laggerCarrySet(laggerModeEnabled and carrySpeedActive)
    end
    mobBtnRefs.lagger=function() refreshSpeedButtons() end
    mobBtnRefs.carrySpeed=function() refreshSpeedButtons() end
    mobBtnRefs.batDesync=makeButton("TPBat","TP BAT",78,234,63,function()
        batDesyncTpEnabled=not batDesyncTpEnabled
        if batDesyncTpEnabled then
            if autoBatEnabled then autoBatEnabled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
            startBatDesyncTp()
        else stopBatDesyncTp() end
        if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
        if mobBtnRefs.batDesync then mobBtnRefs.batDesync(batDesyncTpEnabled) end
        saveConfig()
    end)

    mobBtnRefs.autoLeft(autoLeftEnabled); mobBtnRefs.autoRight(autoRightEnabled); mobBtnRefs.autoBat(autoBatEnabled)
    mobBtnRefs.batDesync(batDesyncTpEnabled); refreshSpeedButtons()

    local dragging,dragStart,startPosition=false,nil,nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; dragStart=input.Position; startPosition=panel.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
            local delta=input.Position-dragStart
            panel.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    function applyMobileTheme(thm)
        panel.BackgroundColor3=thm.bg; panelStroke.Color=thm.accentDark; header.BackgroundColor3=thm.bgDark
        headerDot.BackgroundColor3=thm.accent; topRail.BackgroundColor3=thm.accent
        panelGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,thm.accentBg),ColorSequenceKeypoint.new(.35,thm.bg),ColorSequenceKeypoint.new(1,thm.bgDark)})
        for _,entry in pairs(buttonRefs) do entry.set(entry.get()) end
        refreshSpeedButtons()
    end
    table.insert(_themeExtRefs,{callback=applyMobileTheme}); applyMobileTheme(intensityTheme(THEME_DEFS[currentColorTheme] or THEME_DEFS.IMPULSE,themeIntensity))
end

-- Floating mobile controls, matching the compact source layout while calling N5's current logic.
ConfigShare.buildMobilePad=function()
    if not ConfigShare.mobile or not mobileButtonsEnabled then return end
    local hud=getHud()
    for _,name in ipairs({"ImpulseMobileControls","N5MobileControls","RainyMobileControls"}) do
        local old=hud:FindFirstChild(name); if old then old:Destroy() end
        pcall(function()
            local pg=LP:FindFirstChild("PlayerGui")
            local o=pg and pg:FindFirstChild(name)
            if o then o:Destroy() end
        end)
    end
    local screen=Instance.new("ScreenGui"); screen.Name="N5MobileControls"; screen.ResetOnSpawn=false
    screen.IgnoreGuiInset=true; screen.DisplayOrder=70; screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    parentGui(screen)
    mobGuiRef=screen

    local size=math.clamp(math.floor(tonumber(mobileButtonsSize) or 52),44,64)
    -- right side, 2 columns (3-4 each), vertically centered mid-screen
	local specs={
        {id="drop",label="DROP",x=.84,y=.40,action=function() runDrop() end},
        {id="tpDown",label="TP DOWN",x=.94,y=.40,action=function() runTPFloor() end},
        {id="autoLeft",label="AUTO LEFT",x=.84,y=.52,state=function() return autoLeftEnabled end,action=function()
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() else
                if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
                if autoBatEnabled then autoBatEnabled=false; stopBatAimbot() end
                if batDesyncTpEnabled then batDesyncTpEnabled=false; stopBatDesyncTp() end
                if batDesyncTpV3Enabled then batDesyncTpV3Enabled=false; stopBatDesyncTpV3() end
                autoLeftEnabled=true; startAutoLeft()
            end
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
        end},
        {id="autoRight",label="AUTO RIGHT",x=.94,y=.52,state=function() return autoRightEnabled end,action=function()
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight() else
                if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
                if autoBatEnabled then autoBatEnabled=false; stopBatAimbot() end
                if batDesyncTpEnabled then batDesyncTpEnabled=false; stopBatDesyncTp() end
                if batDesyncTpV3Enabled then batDesyncTpV3Enabled=false; stopBatDesyncTpV3() end
                autoRightEnabled=true; startAutoRight()
            end
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
        end},
        {id="autoBat",label="AIMBOT",x=.84,y=.64,state=function() return autoBatEnabled end,action=function()
            autoBatEnabled=not autoBatEnabled
            if autoBatEnabled then
                if batDesyncTpEnabled then batDesyncTpEnabled=false; stopBatDesyncTp() end
                if batDesyncTpV3Enabled then batDesyncTpV3Enabled=false; stopBatDesyncTpV3() end
                if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
                if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
                startBatAimbot()
            else stopBatAimbot() end
            if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
        end},
        {id="batDesync",label="TP BAT",x=.94,y=.64,state=function() return batDesyncTpEnabled end,action=function()
            batDesyncTpEnabled=not batDesyncTpEnabled
            if batDesyncTpEnabled then
                if batDesyncTpV3Enabled then batDesyncTpV3Enabled=false; stopBatDesyncTpV3() end
                if autoBatEnabled then autoBatEnabled=false; stopBatAimbot() end
                if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft() end
                if autoRightEnabled then autoRightEnabled=false; stopAutoRight() end
                startBatDesyncTp()
            else stopBatDesyncTp() end
            if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
        end},
        {id="lagger",label="LAGGER SPEED",x=.84,y=.76,state=function() return laggerModeEnabled end,action=function() toggleLaggerMode() end},
		{id="carry",label="CARRY SPEED",x=.94,y=.76,state=function() return carrySpeedActive end,action=function() toggleCarryMode() end},
	}
	if _GACC.autoPlayRemoved then
		for index=#specs,1,-1 do
			if specs[index].id=="autoLeft" or specs[index].id=="autoRight" then table.remove(specs,index) end
		end
	end
    local paints={}
    function refreshAll() for _,paint in pairs(paints) do paint() end end
    function makeButton(spec)
        local button=Instance.new("TextButton",screen); button.Name="Mobile_"..spec.id; button.AnchorPoint=Vector2.new(.5,.5)
        local saved=_GACC.mobileButtonPositions[spec.id]
        button.Position=UDim2.fromScale(math.clamp(type(saved)=="table" and tonumber(saved.x) or spec.x,.04,.96),math.clamp(type(saved)=="table" and tonumber(saved.y) or spec.y,.08,.94))
        button.Size=UDim2.fromOffset(size,size); button.BackgroundColor3=Color3.fromRGB(7,7,10); button.BackgroundTransparency=.12
        button.BorderSizePixel=0; button.Text=spec.label; button.TextColor3=Color3.fromRGB(226,226,232)
        button.Font=Enum.Font.GothamBold; button.TextSize=math.clamp(math.floor(size*.17),8,11); button.TextWrapped=true
        button.AutoButtonColor=false; button.Active=true; button.ZIndex=22
        Instance.new("UICorner",button).CornerRadius=UDim.new(0,12)
        local stroke=Instance.new("UIStroke",button); stroke.Color=_GACC.accentDark; stroke.Thickness=1; stroke.Transparency=.18
        local accent=Instance.new("Frame",button); accent.AnchorPoint=Vector2.new(.5,1); accent.Position=UDim2.new(.5,0,1,-5)
        accent.Size=UDim2.new(.42,0,0,2); accent.BackgroundColor3=_GACC.accent; accent.BackgroundTransparency=.58
        accent.BorderSizePixel=0; accent.ZIndex=23; Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)
        local scale=Instance.new("UIScale",button)
        local function paint()
            local active=spec.state and spec.state() or false
            if mobileButtonsLocked then
                button.BackgroundColor3=active and Color3.fromRGB(174,18,48) or Color3.fromRGB(112,9,28)
                button.BackgroundTransparency=.06
                button.TextColor3=Color3.fromRGB(255,238,242)
                stroke.Color=Color3.fromRGB(244,38,64); stroke.Thickness=active and 1.8 or 1.4; stroke.Transparency=.02
                accent.BackgroundColor3=Color3.fromRGB(255,72,96)
                accent.Size=UDim2.new(.68,0,0,2); accent.BackgroundTransparency=active and 0 or .18
            else
                button.BackgroundColor3=Color3.fromRGB(7,7,10)
                button.BackgroundTransparency=.24
                button.TextColor3=Color3.fromRGB(226,226,232)
                stroke.Color=_GACC.accentDark; stroke.Thickness=1.6; stroke.Transparency=.03
                accent.BackgroundColor3=_GACC.accent
                accent.Size=UDim2.new(.68,0,0,2); accent.BackgroundTransparency=.58
            end
        end
        paints[spec.id]=paint
        local dragging,moved,dragStart,startPos=false,false,nil,nil
        button.InputBegan:Connect(function(input)
            if not mobileButtonsLocked and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1) then
                dragging=true; moved=false; dragStart=input.Position; startPos=button.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
                if mobileButtonsLocked then dragging=false; return end
                local delta=input.Position-dragStart; moved=moved or delta.Magnitude>6
                local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
                button.Position=UDim2.fromScale(math.clamp(startPos.X.Scale+delta.X/viewport.X,.04,.96),math.clamp(startPos.Y.Scale+delta.Y/viewport.Y,.08,.94))
            end
        end)
        button.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1) then
                dragging=false; _GACC.mobileButtonPositions[spec.id]={x=button.Position.X.Scale,y=button.Position.Y.Scale}; saveConfig()
            end
        end)
        button.Activated:Connect(function()
            if not mobileButtonsLocked then moved=false; return end
            if moved then moved=false; return end
            if _GACC.playClickSound then _GACC.playClickSound(false) end
            TweenService:Create(scale,TweenInfo.new(.06),{Scale=.88}):Play()
            task.delay(.07,function() if scale.Parent then TweenService:Create(scale,TweenInfo.new(.16,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play() end end)
            spec.action(); refreshAll(); saveConfig()
        end)
        paint()
    end
    for _,spec in ipairs(specs) do makeButton(spec) end
	mobBtnRefs.autoLeft=paints.autoLeft; mobBtnRefs.autoRight=paints.autoRight; mobBtnRefs.autoBat=paints.autoBat
    mobBtnRefs.batDesync=paints.batDesync; mobBtnRefs.lagger=paints.lagger; mobBtnRefs.carrySpeed=paints.carry
    _GACC.refreshMobileLock=refreshAll; _GACC.refreshMobileGroup=refreshAll; _GACC.refreshMobileSize=refreshAll
    table.insert(_themeExtRefs,{callback=refreshAll})
    refreshAll()
end

ConfigShare.buildMobilePad()


if infJumpEnabled then startHoldInfJump() end
if antiRagdollEnabled then startAntiRagdoll() end
if medusaCounterEnabled then setupMedusa(LP.Character) end
if _GACC.playerHighlightEnabled then _GACC.startESP() end
CandyApplyCustomSky(currentSkyTheme)

-- Public bridge used by the Anti-Sammy interface.
getgenv().AntiSammyNebulaAPI={
    setRagdoll=function(on) antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end,
    setKeybind=function(id) local map={Speed="speed",Lagger="laggerToggle",Aimbot="circle",TPBat="batDesyncTp",AutoLeft="autoLeft",AutoRight="autoRight",Drop="dropBrainrot",TPDown="tpDown",HideGUI="guiHide"}; local slot=map[id]; if slot and _GuiKeys then _GuiKeys[slot]=Enum.KeyCode.Unknown; if saveConfig then saveConfig() end end end,
    setSpeedValues=function(normal,carry,lagger,laggerCarry) NS=tonumber(normal) or NS; CS=tonumber(carry) or CS; LAGGER_SPEED=tonumber(lagger) or LAGGER_SPEED; LAGGER_CARRY_SPEED=tonumber(laggerCarry) or LAGGER_CARRY_SPEED; if saveConfig then saveConfig() end end,
    setSpeedState=function(lagger,carry) laggerModeEnabled=lagger==true; carrySpeedActive=carry==true; if refreshSpeedModeLabel then refreshSpeedModeLabel() end; if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end; if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end; if saveConfig then saveConfig() end end,
    setInfiniteJump=function(on) infJumpEnabled=on==true; if infJumpEnabled and infJumpMode=="hold" then startHoldInfJump() else stopHoldInfJump() end; if saveConfig then saveConfig() end end,
    setAimbot=function(on) autoBatEnabled=on==true; if autoBatEnabled then batDesyncTpEnabled=false; stopBatDesyncTp(); startBatAimbot() else stopBatAimbot() end; if saveConfig then saveConfig() end end,
    setBatTP=function(on,version) batDesyncTpVersion=version or batDesyncTpVersion; batDesyncTpEnabled=on==true; if batDesyncTpEnabled then autoBatEnabled=false; stopBatAimbot(); startBatDesyncTp() else stopBatDesyncTp() end; if saveConfig then saveConfig() end end,
    setAutoSteal=function(on,mode) stealMode=(mode or stealMode):lower(); Steal.AutoStealEnabled=on; if on then startAutoSteal() else stopAutoSteal() end end,
    setStealPreset=function(value) value=tostring(value); if NORMAL_STEAL_PERCENT[value] then normalStealVersion=value end end,
	setAutoLeft=function(on) if _GACC.autoPlayRemoved then on=false end; autoLeftEnabled=on; if on then startAutoLeft() else stopAutoLeft() end end,
	setAutoRight=function(on) if _GACC.autoPlayRemoved then on=false end; autoRightEnabled=on; if on then startAutoRight() else stopAutoRight() end end,
	setAutoPlayRemoved=function(on)
		_GACC.autoPlayRemoved=on==true
		if _GACC.autoPlayRemoved then
			autoLeftEnabled=false; autoRightEnabled=false
			stopAutoLeft(); stopAutoRight()
			if _GuiKeys then _GuiKeys.autoLeft=Enum.KeyCode.Unknown; _GuiKeys.autoRight=Enum.KeyCode.Unknown end
		end
		if _GACC.rebuildMobilePad then _GACC.rebuildMobilePad() elseif ConfigShare.buildMobilePad then ConfigShare.buildMobilePad() end
		if saveConfig then saveConfig() end
	end,
    setAutoTP=function(on) autoTPEnabled=on; if on then startAutoTP() else stopAutoTP() end end,
    setMedusa=function(on) medusaCounterEnabled=on; if on then setupMedusa(LP.Character) else stopMedusaCounter() end end,
    setUnwalk=function(on) unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end end,
    setAntiLag=function(on) if on then enableAntiLag() else disableAntiLag() end end,
    setStretch=function(on) if on then enableStretchRez() else disableStretchRez() end end,
    setESP=function(on) _GACC.playerHighlightEnabled=on; if on then _GACC.startESP() else _GACC.stopESP() end end,
    setCarry=function() toggleCarryMode() end, setLagger=function() toggleLaggerMode() end,
    setAntiDieFling=function(on) antiDieFlingEnabled=on; if on then startAntiDieFling() else stopAntiDieFling() end end,
    setAutoSwing=function(on) autoSwingEnabled=on end,
    setAutoMoveSwing=function(on) autoMoveSwingEnabled=on end,
    setTPHeight=function(height) autoTPHeight=math.clamp(tonumber(height) or autoTPHeight,0,500) end,
    setFOV=function(value) fovValue=math.clamp(tonumber(value) or fovValue,80,120); State.Fov=fovValue; applyFOV() end,
    setFOVEnabled=function(on) State.FovEnabled=on==true; applyFOV(); silentSaveFront() end,
    setSky=function(name) currentSkyTheme=name; CandyApplyCustomSky(name) end,
    setAnimation=function(name)
        if unwalkEnabled or unwalkSavedAnimate then
            unwalkEnabled=false; stopUnwalk()
            if _GACC.unwalkSetVisual then _GACC.unwalkSetVisual(false) end
        end
        if not _GACC.extras.setPack(name,false) then return false end
        task.spawn(function()
            local applied=_GACC.extras.applyPack(name,LP.Character)
            if not applied and _GACC.extras.getPack()==name then
                task.wait(.3)
                if _GACC.extras.getPack()==name then _GACC.extras.applyPack(name,LP.Character) end
            end
            if saveConfig then saveConfig() end
        end)
        return true
    end,
    setHeadless=function(on) _GACC.extras.setHeadless(on,LP.Character) end,
    setKorblox=function(on) _GACC.extras.setKorblox(on,LP.Character) end,
	setMobileButtons=function(on)
		mobileButtonsEnabled=on==true
		if mobGuiRef then pcall(function() mobGuiRef:Destroy() end); mobGuiRef=nil end
		if mobileButtonsEnabled and ConfigShare.buildMobilePad then ConfigShare.buildMobilePad() end
		if saveConfig then saveConfig() end
	end,
    setMobileLock=function(on)
        mobileButtonsLocked=on==true
        State.MobileButtonsLocked=mobileButtonsLocked
        if _GACC.refreshMobileLock then _GACC.refreshMobileLock() end
        if saveConfig then saveConfig() end
    end,
    setIntroEnabled=function(on)
        introEnabled=on==true
        if saveConfig then saveConfig() end
    end,
    drop=function() runDrop() end, tpDown=function() runTPFloor() end,
}

end)
