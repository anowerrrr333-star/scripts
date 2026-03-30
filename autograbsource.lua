local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local TweenService     = game:GetService("TweenService")

local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")
local Camera       = workspace.CurrentCamera

-- ════════════════════════════════════════════════════════════
-- SYNCHRONIZER
-- ════════════════════════════════════════════════════════════
local function getInternalTable()
    local Packages = ReplicatedStorage:FindFirstChild("Packages"); if not Packages then return nil end
    local SynMod   = Packages:FindFirstChild("Synchronizer");      if not SynMod   then return nil end
    local ok, syn  = pcall(require, SynMod);                       if not ok or not syn then return nil end
    local Get      = syn.Get;                                       if type(Get)~="function" then return nil end
    for i=1,5 do
        local s,u=pcall(getupvalue,Get,i)
        if s and type(u)=="table" then
            if u.___private or u.___channels or u.___data then return u end
            for k,v in pairs(u) do
                if type(k)=="string" and k:match("^Plot_") or type(v)=="table" then return u end
            end
        end
    end
    local s,e=pcall(getfenv,Get); if s and e and e.self then return e.self end
    return nil
end

local SyncInt={_cache={},_data=nil}
task.spawn(function()
    for i=1,10 do SyncInt._data=getInternalTable(); if SyncInt._data then break end; task.wait(1) end
end)

local function stealthGet(n)
    if not n or type(n)~="string" then return nil end
    if SyncInt._cache[n]==false then return nil end
    if SyncInt._data then
        for _,k in ipairs({n,"Plot_"..n,"Plot"..n,n.."_Channel","Channel_"..n}) do
            if SyncInt._data[k] then SyncInt._cache[n]=SyncInt._data[k]; return SyncInt._data[k] end
        end
        for k,v in pairs(SyncInt._data) do
            if type(k)=="string" and (k==n or k:find(n,1,true)) and type(v)=="table" then
                SyncInt._cache[n]=v; return v
            end
        end
    end
    SyncInt._cache[n]=false; return nil
end

local function sProp(ch,p)
    if not ch or type(ch)~="table" then return nil end
    if ch[p] then return ch[p] end
    if type(ch.Get)=="function" then local ok,r=pcall(ch.Get,ch,p); if ok then return r end end
    local alts={Owner={"owner","Owner","plotOwner","PlotOwner"},AnimalList={"animalList","AnimalList","animals","Animals","pets"}}
    if alts[p] then for _,a in ipairs(alts[p]) do if ch[a] then return ch[a] end end end
    return nil
end

-- ════════════════════════════════════════════════════════════
-- MODULES
-- ════════════════════════════════════════════════════════════
local Datas=ReplicatedStorage:WaitForChild("Datas")
local Shared=ReplicatedStorage:WaitForChild("Shared")
local Utils=ReplicatedStorage:WaitForChild("Utils")

local AnimalsData,AnimalsShared,NumberUtils
task.spawn(function()
    for i=1,10 do
        local s1,d=pcall(require,Datas:WaitForChild("Animals"))
        local s2,sh=pcall(require,Shared:WaitForChild("Animals"))
        local s3,nu=pcall(require,Utils:WaitForChild("NumberUtils"))
        if s1 and d  then AnimalsData=d   end
        if s2 and sh then AnimalsShared=sh end
        if s3 and nu then NumberUtils=nu  end
        if AnimalsData and AnimalsShared and NumberUtils then break end
        task.wait(0.5)
    end
end)

-- ════════════════════════════════════════════════════════════
-- STATE
-- ════════════════════════════════════════════════════════════
local allAnimals     = {}
local plotChannels   = {}
local lastHash       = {}
local PromptCache    = {}
local StealCache     = {}

local autoMode       = true
local selIdx         = 1
local enabled        = false
local rotIdx         = 1
local rainbowClock   = 0
local espObjects     = {}

-- ────────────────────────────────────────────────────────────
-- STEAL PROGRESS — V2 : JAMAIS reset à 0 sauf désactivation manuelle
--
--   "idle"      → désactivé
--   "charging"  → monte de pct actuel → 90% (une seule fois au départ)
--   "holding"   → stable à 90%, attend le contact (loop permanent)
--   "dipping"   → recule de ~8% rapidement au contact
--   "rushing"   → rush vers 100% très vite → fire steal → retour "holding"
--
-- Clé : après le steal on revient à "holding" (90%) et non à 0 !
-- ────────────────────────────────────────────────────────────
local TRIGGER_DIST   = 10      -- studs pour déclencher le dip+rush
local CHARGE_SPEED   = 70      -- %/s montée initiale vers 90 (plus rapide qu'avant)
local DIP_AMOUNT     = 8       -- % de recul visible
local DIP_SPEED      = 100     -- %/s vitesse recul
local RUSH_SPEED     = 420     -- %/s vitesse rush vers 100

-- Cooldown anti-spam : délai minimum entre deux steals consécutifs
local STEAL_COOLDOWN = 0.4     -- secondes

local stealPct       = 0
local stealTarget    = nil
local stealPhase     = "idle"
local dipTarget      = 0
local lastStealTime  = 0
local stealFiring    = false   -- verrou pour éviter les double-fires

-- GUI refs
local G={}

-- ════════════════════════════════════════════════════════════
-- MY BASE
-- ════════════════════════════════════════════════════════════
local function isMyBase(ad)
    if not ad or not ad.plot then return false end
    local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot=plots:FindFirstChild(ad.plot);      if not plot  then return false end
    local ch=stealthGet(plot.Name)
    if ch then
        local o=sProp(ch,"Owner")
        if o then
            if typeof(o)=="Instance" and o:IsA("Player") then return o.UserId==LocalPlayer.UserId end
            if type(o)=="table" and o.UserId             then return o.UserId==LocalPlayer.UserId end
            if typeof(o)=="Instance"                     then return o==LocalPlayer              end
        end
    end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled end end
    return false
end

-- ════════════════════════════════════════════════════════════
-- RAINBOW
-- ════════════════════════════════════════════════════════════
local function hsv(h,s,v)
    local i=math.floor(h*6);local f=h*6-i
    local p,q,t=v*(1-s),v*(1-f*s),v*(1-(1-f)*s)
    i=i%6
    local r,g,b
    if i==0 then r,g,b=v,t,p elseif i==1 then r,g,b=q,v,p
    elseif i==2 then r,g,b=p,v,t elseif i==3 then r,g,b=p,q,v
    elseif i==4 then r,g,b=t,p,v else r,g,b=v,p,q end
    return Color3.new(r,g,b)
end
local function rbw() return hsv((rainbowClock%4)/4,1,1) end

-- ════════════════════════════════════════════════════════════
-- FIND PET MODEL / POSITION
-- ════════════════════════════════════════════════════════════
local function findPetModel(ad)
    if not ad then return nil end
    local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
    local plot=plots:FindFirstChild(ad.plot);      if not plot  then return nil end
    local pods=plot:FindFirstChild("AnimalPodiums");if not pods then return nil end
    local pod=pods:FindFirstChild(ad.slot);        if not pod   then return nil end
    local base=pod:FindFirstChild("Base")
    if base then
        local spwn=base:FindFirstChild("Spawn")
        if spwn then
            for _,c in ipairs(spwn:GetChildren()) do
                if c:IsA("Model") or c:IsA("BasePart") then return c end
            end
        end
    end
    local function deepFind(parent)
        for _,c in ipairs(parent:GetChildren()) do
            if c:IsA("Model") or (c:IsA("BasePart") and c.Name~="Base") then return c end
            local r=deepFind(c); if r then return r end
        end
        return nil
    end
    return deepFind(pod)
end

local function getPetPosition(ad)
    local model=findPetModel(ad); if not model then return nil end
    if model:IsA("Model") then
        if model.PrimaryPart then return model.PrimaryPart.Position end
        local ok,cf=pcall(function() return model:GetBoundingBox() end)
        if ok and cf then return cf.Position end
        local part=model:FindFirstChildWhichIsA("BasePart")
        if part then return part.Position end
    elseif model:IsA("BasePart") then
        return model.Position
    end
    return nil
end

local function getPlayerPos()
    local char=LocalPlayer.Character; if not char then return nil end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    return hrp.Position
end

local function distToTarget(ad)
    local petPos=getPetPosition(ad); if not petPos then return math.huge end
    local plrPos=getPlayerPos();     if not plrPos then return math.huge end
    return (petPos-plrPos).Magnitude
end

-- ════════════════════════════════════════════════════════════
-- ESP — Highlight rainbow
-- ════════════════════════════════════════════════════════════
local function clearESP(uid)
    if espObjects[uid] then
        local e=espObjects[uid]
        if e.hl and e.hl.Parent then e.hl:Destroy() end
        if e.bb and e.bb.Parent then e.bb:Destroy() end
        espObjects[uid]=nil
    end
end
local function clearAllESP() for uid in pairs(espObjects) do clearESP(uid) end end

local function applyESP(ad)
    if not ad then return end
    clearESP(ad.uid)
    local model=findPetModel(ad); if not model then return end

    local hl=Instance.new("Highlight")
    hl.FillTransparency=0.3; hl.OutlineTransparency=0
    hl.FillColor=rbw(); hl.OutlineColor=rbw()
    hl.Adornee=model; hl.Parent=workspace

    local anchor=model:IsA("Model")and(model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart"))or model

    local bb=Instance.new("BillboardGui")
    bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,180,0,38)
    bb.StudsOffset=Vector3.new(0,4,0); bb.Adornee=anchor; bb.Parent=workspace

    local lbl=Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13
    lbl.TextColor3=Color3.new(1,1,1); lbl.TextStrokeTransparency=0
    lbl.TextStrokeColor3=Color3.new(0,0,0)
    lbl.Text=(ad.name or "?").."\n"..(ad.genText or ""); lbl.Parent=bb

    espObjects[ad.uid]={hl=hl,bb=bb,lbl=lbl}
end

RunService.Heartbeat:Connect(function(dt)
    rainbowClock=rainbowClock+dt
    local col=rbw()
    for uid,e in pairs(espObjects) do
        if e.hl and e.hl.Parent then e.hl.FillColor=col; e.hl.OutlineColor=col
        else espObjects[uid]=nil end
        if e.lbl then e.lbl.TextColor3=col end
    end
end)

local function refreshESP()
    clearAllESP(); if not enabled then return end
    if autoMode then
        for _,pet in ipairs(allAnimals) do if not isMyBase(pet) then applyESP(pet) end end
    else
        local pet=allAnimals[selIdx]; if pet and not isMyBase(pet) then applyESP(pet) end
    end
end

-- ════════════════════════════════════════════════════════════
-- FIND PROMPT
-- ════════════════════════════════════════════════════════════
local function findPrompt(ad)
    if not ad then return nil end
    local c=PromptCache[ad.uid]; if c and c.Parent then return c end
    local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
    local plot=plots:FindFirstChild(ad.plot);      if not plot  then return nil end
    local pods=plot:FindFirstChild("AnimalPodiums");if not pods then return nil end
    local pod=pods:FindFirstChild(ad.slot);        if not pod   then return nil end
    local base=pod:FindFirstChild("Base");          if not base  then return nil end
    local spwn=base:FindFirstChild("Spawn");        if not spwn  then return nil end
    local att=spwn:FindFirstChild("PromptAttachment");if not att then return nil end
    for _,p in ipairs(att:GetChildren()) do
        if p:IsA("ProximityPrompt") then PromptCache[ad.uid]=p; return p end
    end
    return nil
end

-- ════════════════════════════════════════════════════════════
-- STEAL CALLBACKS
-- ════════════════════════════════════════════════════════════
local function buildCallbacks(prompt)
    if StealCache[prompt] then return end
    local data={hold={},trig={},ready=true}
    local ok1,c1=pcall(getconnections,prompt.PromptButtonHoldBegan)
    if ok1 and type(c1)=="table" then
        for _,c in ipairs(c1) do if type(c.Function)=="function" then table.insert(data.hold,c.Function) end end
    end
    local ok2,c2=pcall(getconnections,prompt.Triggered)
    if ok2 and type(c2)=="table" then
        for _,c in ipairs(c2) do if type(c.Function)=="function" then table.insert(data.trig,c.Function) end end
    end
    if #data.hold>0 or #data.trig>0 then StealCache[prompt]=data end
end

local function runList(list) for _,fn in ipairs(list) do task.spawn(fn) end end

local function fireSteal(prompt)
    local data=StealCache[prompt]; if not data then return end
    if #data.hold>0 then runList(data.hold) end
    task.wait(0.05)
    if #data.trig>0 then runList(data.trig) end
end

-- ════════════════════════════════════════════════════════════
-- PLOT SCANNER
-- ════════════════════════════════════════════════════════════
local function getHash(al)
    if not al then return "" end
    local h=""
    for s,d in pairs(al) do if type(d)=="table" then h=h..tostring(s)..tostring(d.Index)..tostring(d.Mutation) end end
    return h
end

local function scanPlot(plot)
    pcall(function()
        local uid=plot.Name
        local ch=stealthGet(uid); if not ch then return end
        local al=sProp(ch,"AnimalList")
        local hash=getHash(al)
        if lastHash[uid]==hash then return end
        lastHash[uid]=hash
        for i=#allAnimals,1,-1 do if allAnimals[i].plot==uid then table.remove(allAnimals,i) end end
        local owner=sProp(ch,"Owner")
        if not owner or not Players:FindFirstChild(owner.Name) then return end
if owner.UserId == LocalPlayer.UserId then return end
        if not al then return end
        for slot,ad in pairs(al) do
            if type(ad)=="table" then
                local nm=ad.Index
                local info=AnimalsData and AnimalsData[nm]; if not info then continue end
                local gen=AnimalsShared and AnimalsShared:GetGeneration(nm,ad.Mutation,ad.Traits,nil) or 0
                local genT="$"..(NumberUtils and NumberUtils:ToString(gen) or tostring(gen)).."/s"
                table.insert(allAnimals,{
                    name=info.DisplayName or nm,genText=genT,genValue=gen,
                    mutation=ad.Mutation or "None",
                    owner=owner.Name or "?",
                    plot=uid,slot=tostring(slot),uid=uid.."_"..tostring(slot),
                })
            end
        end
        table.sort(allAnimals,function(a,b) return a.genValue>b.genValue end)
    end)
end

local function setupPlot(plot)
    if plotChannels[plot.Name] then return end
    local ch; for i=1,3 do ch=stealthGet(plot.Name); if ch then break end; task.wait(0.3) end
    if not ch then return end
    plotChannels[plot.Name]=true; scanPlot(plot)
    plot.DescendantAdded:Connect(function() task.wait(0.05); scanPlot(plot) end)
    plot.DescendantRemoving:Connect(function() task.wait(0.05); scanPlot(plot) end)
    task.spawn(function() while plot.Parent and plotChannels[plot.Name] do task.wait(1); scanPlot(plot) end end)
end

local function initScanner()
    local plots=workspace:FindFirstChild("Plots")
    if not plots then
        for i=1,30 do plots=workspace:FindFirstChild("Plots"); if plots then break end; task.wait(0.5) end
        if not plots then return end
    end
    for _,p in ipairs(plots:GetChildren()) do task.spawn(setupPlot,p) end
    plots.ChildAdded:Connect(function(p) task.wait(0.2); task.spawn(setupPlot,p) end)
    plots.ChildRemoved:Connect(function(p)
        plotChannels[p.Name]=nil; lastHash[p.Name]=nil
        for i=#allAnimals,1,-1 do if allAnimals[i].plot==p.Name then table.remove(allAnimals,i) end end
    end)
end

-- ════════════════════════════════════════════════════════════
-- GUI — KZR AUTO GRAB
-- ════════════════════════════════════════════════════════════
local W=340
local H_COL=42
local H_EXP=150
local isExpanded=true

local function getPetName()
    if autoMode then return "AUTO" end
    local p=allAnimals[selIdx]; return p and string.upper(p.name) or "NONE"
end

local function updateUI()
    if G.pct then
        G.pct.Text=string.format("%.0f%%",stealPct)
    end
    if G.bar then
        G.bar.Size=UDim2.new(stealPct/100,0,1,0)
    end
    if G.badge then
        if enabled then
            G.badge.Text="актив"
            G.badge.BackgroundColor3=Color3.fromRGB(34,170,34)
        else
            G.badge.Text="не актив"
            G.badge.BackgroundColor3=Color3.fromRGB(195,22,22)
        end
    end
    if G.petLbl then G.petLbl.Text=getPetName() end
end

local function createGUI()
    local old=PlayerGui:FindFirstChild("KZRAutoGrabUI"); if old then old:Destroy() end

    local sg=Instance.new("ScreenGui")
    sg.Name="KZRAutoGrabUI"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder=200; sg.IgnoreGuiInset=true; sg.Parent=PlayerGui

    local shadow=Instance.new("ImageLabel")
    shadow.Name="Shadow"
    shadow.Size=UDim2.new(0,W+30,0,H_EXP+30)
    shadow.Position=UDim2.new(0.5,-W/2-15,0.75,-15)
    shadow.BackgroundTransparency=1
    shadow.Image="rbxassetid://5554236805"
    shadow.ImageColor3=Color3.fromRGB(0,0,0)
    shadow.ImageTransparency=0.5
    shadow.ScaleType=Enum.ScaleType.Slice
    shadow.SliceCenter=Rect.new(23,23,277,277)
    shadow.ZIndex=98
    shadow.Parent=sg

    local mf=Instance.new("Frame")
    mf.Name="MainFrame"
    mf.Size=UDim2.new(0,W,0,H_EXP)
    mf.Position=UDim2.new(0.5,-W/2,0.75,0)
    mf.BackgroundColor3=Color3.fromRGB(15,11,11)
    mf.BorderSizePixel=0
    mf.ZIndex=100
    mf.ClipsDescendants=true
    mf.Parent=sg

    local mfC=Instance.new("UICorner"); mfC.CornerRadius=UDim.new(0,12); mfC.Parent=mf
    local mfS=Instance.new("UIStroke")
    mfS.Color=Color3.fromRGB(45,38,35)
    mfS.Thickness=1
    mfS.Transparency=0.3
    mfS.Parent=mf

    local hf=Instance.new("Frame")
    hf.Size=UDim2.new(1,0,0,44)
    hf.BackgroundTransparency=1
    hf.ZIndex=101; hf.Parent=mf

    local titleLbl=Instance.new("TextLabel")
    titleLbl.Size=UDim2.new(0,155,1,0)
    titleLbl.Position=UDim2.new(0,14,0,0)
    titleLbl.BackgroundTransparency=1
    titleLbl.Text="KZR AUTO GRAB"
    titleLbl.Font=Enum.Font.GothamBold
    titleLbl.TextSize=14
    titleLbl.TextColor3=Color3.fromRGB(228,218,205)
    titleLbl.TextXAlignment=Enum.TextXAlignment.Left
    titleLbl.ZIndex=102; titleLbl.Parent=hf

    local pctLbl=Instance.new("TextLabel")
    pctLbl.Size=UDim2.new(0,44,1,0)
    pctLbl.Position=UDim2.new(0,168,0,0)
    pctLbl.BackgroundTransparency=1
    pctLbl.Text="0%"
    pctLbl.Font=Enum.Font.GothamBold
    pctLbl.TextSize=14
    pctLbl.TextColor3=Color3.fromRGB(178,1,255)
    pctLbl.TextXAlignment=Enum.TextXAlignment.Left
    pctLbl.ZIndex=102; pctLbl.Parent=hf
    G.pct=pctLbl

    local badge=Instance.new("TextButton")
    badge.Size=UDim2.new(0,84,0,24)
    badge.Position=UDim2.new(0,214,0.5,-12)
    badge.BackgroundColor3=Color3.fromRGB(195,22,22)
    badge.BorderSizePixel=0
    badge.Text="DÉSACTIVÉ"
    badge.Font=Enum.Font.GothamBold
    badge.TextSize=11
    badge.TextColor3=Color3.fromRGB(255,255,255)
    badge.AutoButtonColor=false
    badge.ZIndex=103; badge.Parent=hf
    local bC=Instance.new("UICorner"); bC.CornerRadius=UDim.new(0,6); bC.Parent=badge
    G.badge=badge

    local colBtn=Instance.new("TextButton")
    colBtn.Size=UDim2.new(0,24,0,24)
    colBtn.Position=UDim2.new(1,-30,0.5,-12)
    colBtn.BackgroundTransparency=1
    colBtn.Text="–"
    colBtn.Font=Enum.Font.GothamBold
    colBtn.TextSize=18
    colBtn.TextColor3=Color3.fromRGB(160,150,140)
    colBtn.AutoButtonColor=false
    colBtn.ZIndex=103; colBtn.Parent=hf

    local barBg=Instance.new("Frame")
    barBg.Name="BarBg"
    barBg.Size=UDim2.new(1,0,0,4)
    barBg.Position=UDim2.new(0,0,0,44)
    barBg.BackgroundColor3=Color3.fromRGB(30,20,18)
    barBg.BorderSizePixel=0
    barBg.ZIndex=101; barBg.Parent=mf

    local barFill=Instance.new("Frame")
    barFill.Name="BarFill"
    barFill.Size=UDim2.new(0,0,1,0)
    barFill.BackgroundColor3=Color3.fromRGB(210,30,10)
    barFill.BorderSizePixel=0
    barFill.ZIndex=102; barFill.Parent=barBg

    local barGrad=Instance.new("UIGradient")
    barGrad.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(200,20,5)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,120,0)),
    }
    barGrad.Parent=barFill
    G.bar=barFill

    local sep1=Instance.new("Frame")
    sep1.Size=UDim2.new(1,0,0,1)
    sep1.Position=UDim2.new(0,0,0,48)
    sep1.BackgroundColor3=Color3.fromRGB(38,30,27)
    sep1.BorderSizePixel=0
    sep1.ZIndex=101; sep1.Parent=mf

    local selRow=Instance.new("Frame")
    selRow.Size=UDim2.new(1,0,0,60)
    selRow.Position=UDim2.new(0,0,0,50)
    selRow.BackgroundTransparency=1
    selRow.ZIndex=101; selRow.Parent=mf

    local selBg=Instance.new("Frame")
    selBg.Size=UDim2.new(1,-24,1,-14)
    selBg.Position=UDim2.new(0,12,0,7)
    selBg.BackgroundColor3=Color3.fromRGB(22,16,14)
    selBg.BorderSizePixel=0
    selBg.ZIndex=101; selBg.Parent=selRow
    local selC=Instance.new("UICorner"); selC.CornerRadius=UDim.new(0,8); selC.Parent=selBg

    local leftBtn=Instance.new("TextButton")
    leftBtn.Size=UDim2.new(0,38,1,0)
    leftBtn.BackgroundTransparency=1
    leftBtn.Text="<"
    leftBtn.Font=Enum.Font.GothamBold
    leftBtn.TextSize=20
    leftBtn.TextColor3=Color3.fromRGB(175,165,150)
    leftBtn.AutoButtonColor=false
    leftBtn.ZIndex=102; leftBtn.Parent=selBg

    local rightBtn=Instance.new("TextButton")
    rightBtn.Size=UDim2.new(0,38,1,0)
    rightBtn.Position=UDim2.new(1,-38,0,0)
    rightBtn.BackgroundTransparency=1
    rightBtn.Text=">"
    rightBtn.Font=Enum.Font.GothamBold
    rightBtn.TextSize=20
    rightBtn.TextColor3=Color3.fromRGB(175,165,150)
    rightBtn.AutoButtonColor=false
    rightBtn.ZIndex=102; rightBtn.Parent=selBg

    local petLbl=Instance.new("TextLabel")
    petLbl.Size=UDim2.new(1,-80,1,0)
    petLbl.Position=UDim2.new(0,40,0,0)
    petLbl.BackgroundTransparency=1
    petLbl.Text="AUTO"
    petLbl.Font=Enum.Font.GothamBold
    petLbl.TextSize=15
    petLbl.TextColor3=Color3.fromRGB(228,218,205)
    petLbl.TextTruncate=Enum.TextTruncate.AtEnd
    petLbl.ZIndex=102; petLbl.Parent=selBg
    G.petLbl=petLbl

    local sep2=Instance.new("Frame")
    sep2.Size=UDim2.new(1,0,0,1)
    sep2.Position=UDim2.new(0,0,0,110)
    sep2.BackgroundColor3=Color3.fromRGB(38,30,27)
    sep2.BorderSizePixel=0
    sep2.ZIndex=101; sep2.Parent=mf

    local discLbl=Instance.new("TextLabel")
    discLbl.Size=UDim2.new(1,-20,0,34)
    discLbl.Position=UDim2.new(0,10,0,113)
    discLbl.BackgroundTransparency=1
    discLbl.Text="t.me/kurtis_scripts"
    discLbl.Font=Enum.Font.Gotham
    discLbl.TextSize=17
    discLbl.TextColor3=Color3.fromRGB(255, 255, 255)
    discLbl.TextXAlignment=Enum.TextXAlignment.Center
    discLbl.ZIndex=102; discLbl.Parent=mf

    -- ── DRAG ────────────────────────────────────────────────
    local dragging,dInput,mPos,fPos=false,nil,nil,nil
    hf.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; mPos=inp.Position; fPos=mf.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    hf.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then dInput=inp end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp==dInput and dragging then
            local d=inp.Position-mPos
            mf.Position=UDim2.new(fPos.X.Scale,fPos.X.Offset+d.X,fPos.Y.Scale,fPos.Y.Offset+d.Y)
            shadow.Position=UDim2.new(fPos.X.Scale,fPos.X.Offset+d.X-15,fPos.Y.Scale,fPos.Y.Offset+d.Y-15)
        end
    end)

    -- ── EXPAND / COLLAPSE ───────────────────────────────────
    local function setExpand(state)
        isExpanded=state
        colBtn.Text=state and "–" or "+"
        local th=state and H_EXP or H_COL
        local sh_h=state and H_EXP+30 or H_COL+30
        TweenService:Create(mf,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{Size=UDim2.new(0,W,0,th)}):Play()
        TweenService:Create(shadow,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{Size=UDim2.new(0,W+30,0,sh_h)}):Play()
    end
    colBtn.MouseButton1Click:Connect(function() setExpand(not isExpanded) end)

    -- ── TOGGLE BADGE ────────────────────────────────────────
    local function doToggle()
        enabled=not enabled
        if not enabled then
            -- Désactivation complète : tout reset
            clearAllESP()
            stealPct=0; stealTarget=nil; stealPhase="idle"
            dipTarget=0; stealFiring=false
        else
            -- Activation : démarre la charge depuis 0
            stealPhase="charging"
            refreshESP()
        end
        updateUI()
    end
    badge.MouseButton1Click:Connect(doToggle)

    -- ── FLÈCHES ─────────────────────────────────────────────
    leftBtn.MouseButton1Click:Connect(function()
        if autoMode then autoMode=false; selIdx=math.max(1,#allAnimals)
        else
            selIdx=selIdx-1
            if selIdx<1 then autoMode=true; selIdx=1 end
        end
        -- Changement de cible : repart de 0 (choix utilisateur explicite)
        stealPct=0; stealTarget=nil; stealPhase= enabled and "charging" or "idle"
        dipTarget=0; stealFiring=false
        updateUI(); refreshESP()
    end)
    rightBtn.MouseButton1Click:Connect(function()
        if autoMode then autoMode=false; selIdx=1
        else
            selIdx=selIdx+1
            if selIdx>#allAnimals then autoMode=true; selIdx=1 end
        end
        stealPct=0; stealTarget=nil; stealPhase= enabled and "charging" or "idle"
        dipTarget=0; stealFiring=false
        updateUI(); refreshESP()
    end)

    return true
end

-- ════════════════════════════════════════════════════════════
-- STEAL SYSTEM V2
-- ════════════════════════════════════════════════════════════
local function getTargetAnimal()
    if not enabled then return nil end
    if autoMode then
        if #allAnimals==0 then return nil end
        local best,bestDist=nil,math.huge
        for _,pet in ipairs(allAnimals) do
            if not isMyBase(pet) then
                local d=distToTarget(pet)
                if d<bestDist then bestDist=d; best=pet end
            end
        end
        return best
    else
        local pet=allAnimals[selIdx]
        if pet and not isMyBase(pet) then return pet end
        return nil
    end
end

RunService.Heartbeat:Connect(function(dt)
    if not enabled then
        if stealPhase~="idle" then
            stealPct=0; stealTarget=nil; stealPhase="idle"; dipTarget=0; stealFiring=false
            updateUI()
        end
        return
    end

    -- Si on est en train de fire le steal, on ne touche à rien
    if stealFiring then return end

    local target=getTargetAnimal()

    -- ── Gestion du changement de cible ───────────────────────
    -- IMPORTANT : on ne reset PAS le pourcentage si la cible change
    -- en AUTO mode. On garde le pct actuel et on continue depuis là.
    if target~=stealTarget then
        stealTarget=target
        if not target then
            -- Plus de cible : on gèle le pct là où on est
            -- (ne repart pas à 0 !)
            -- Si on était en plein dip/rush on revient à holding
            if stealPhase=="dipping" or stealPhase=="rushing" then
                stealPct=90; stealPhase="holding"
            elseif stealPhase=="idle" then
                stealPhase="charging"
            end
        else
            -- Nouvelle cible trouvée :
            if stealPhase=="idle" then
                stealPhase="charging"
            elseif stealPhase=="holding" or stealPhase=="dipping" or stealPhase=="rushing" then
                -- Déjà chargé, reste en holding pour la nouvelle cible
                stealPct=90; stealPhase="holding"; dipTarget=0
            end
            -- Si "charging" : continue de charger normalement
        end
    end

    if not stealTarget then
        -- Pas de cible : on reste gelé (ne monte/descend pas)
        -- Mais si pct < 90 et phase = charging, on attend juste
        updateUI(); return
    end

    local dist=distToTarget(stealTarget)

    -- ── Phase : Charge initiale vers 90 ──────────────────────
    if stealPhase=="charging" then
        stealPct = stealPct + CHARGE_SPEED * dt
        if stealPct >= 95 then
            stealPct = 95
            stealPhase = "holding"
        end

    -- ── Phase : Stable à 90%, attend le contact ──────────────
    elseif stealPhase=="holding" then
        -- Reste EXACTEMENT à 90, rien ne bouge
        stealPct = 95
        if dist <= TRIGGER_DIST then
            -- Contact ! On prépare le dip
            dipTarget = 95 - DIP_AMOUNT - math.random(0, 3)
            stealPhase = "dipping"
        end

    -- ── Phase : Dip visible ───────────────────────────────────
    elseif stealPhase=="dipping" then
        stealPct = stealPct - DIP_SPEED * dt
        if stealPct <= dipTarget then
            stealPct = dipTarget
            stealPhase = "rushing"
        end

    -- ── Phase : Rush vers 100 ─────────────────────────────────
    elseif stealPhase=="rushing" then
        stealPct = stealPct + RUSH_SPEED * dt
        if stealPct >= 100 then
            stealPct = 100
            updateUI()

            -- Vérifie cooldown anti-spam
            local now=tick()
            if now - lastStealTime >= STEAL_COOLDOWN then
                lastStealTime=now
                stealFiring=true

                -- Fire le steal dans un thread séparé pour pas bloquer le Heartbeat
                task.spawn(function()
                    local prompt = PromptCache[stealTarget and stealTarget.uid or ""] or findPrompt(stealTarget)
                    if prompt then
                        buildCallbacks(prompt)
                        if StealCache[prompt] and StealCache[prompt].ready then
                            fireSteal(prompt)
                        end
                    end
                    task.wait(0.25)

                    -- ══ CLÉ V2 : On revient à 90% "holding", PAS à 0 ══
                    stealPct = 95
                    stealPhase = "holding"
                    dipTarget = 0
                    stealFiring = false

                    refreshESP()
                    updateUI()
                end)
            else
                -- Cooldown pas terminé, on remet à 90 et on attend
                stealPct = 95
                stealPhase = "holding"
                dipTarget = 0
            end
            return
        end
    end

    updateUI()
end)

-- Refresh ESP périodique
task.spawn(function()
    while true do task.wait(3); if enabled then refreshESP() end end
end)

-- ════════════════════════════════════════════════════════════
-- INIT
-- ════════════════════════════════════════════════════════════
task.spawn(function()
    while not AnimalsData or not AnimalsShared or not NumberUtils do task.wait(0.5) end
    task.wait(1.5)
    if not createGUI() then warn("[KZR V2] GUI failed!"); return end
    initScanner()
    task.wait(1)
    updateUI()
end)
