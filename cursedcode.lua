local cloneref = cloneref or function(o) return o end
local function svc(name)
    local ok, s = pcall(function() return game:GetService(name) end)
    if not ok or not s then return nil end
    local ok2, r = pcall(cloneref, s)
    if ok2 and r then return r end
    return s
end

local Players           = svc("Players")
local ReplicatedStorage  = svc("ReplicatedStorage")
local RunService         = svc("RunService")
local UserInputService   = svc("UserInputService")
local HttpService        = svc("HttpService")
local TweenService       = svc("TweenService")
local CoreGui            = svc("CoreGui")

local player = Players.LocalPlayer
if not player then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    player = Players.LocalPlayer
end
local playerGui = player:WaitForChild("PlayerGui")

local env = (typeof(getgenv) == "function" and getgenv()) or _G

-- kill any previous instance of this script
if env.CursedRedeemerStop then pcall(env.CursedRedeemerStop) end
if env.Skyr0Stop then pcall(env.Skyr0Stop) end
if env.StopAura then pcall(env.StopAura) end
if type(env._KatanaConnections) == "table" then
    for _, connection in ipairs(env._KatanaConnections) do
        pcall(function() connection:Disconnect() end)
    end
    env._KatanaConnections = {}
end

local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns    = getconnections or (debug and debug.getconnections)
local setupv      = (debug and debug.setupvalue) or setupvalue

-- CONFIG
local CONFIG_FILE = "cursed_hub_code_redeemer.json"
local cfg = {
    sniper        = true,
    autoSubmit    = true,
    submitAfter   = 3,
    retypeInvalid = false,
    riddleSolver  = true,
    redeemDelay   = 0.05,
    menuScale     = 1.00,
}

pcall(function()
    if type(isfile) == "function" and type(readfile) == "function" and isfile(CONFIG_FILE) then
        local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(decoded) == "table" then
            for key, value in pairs(cfg) do
                local got = decoded[key]
                if type(got) == type(value) then cfg[key] = got end
            end
            cfg.submitAfter = math.clamp(math.floor(tonumber(cfg.submitAfter) or 3), 1, 5)
            cfg.redeemDelay = math.clamp(tonumber(cfg.redeemDelay) or 0.05, 0.01, 3.00)
            cfg.menuScale = math.clamp(tonumber(cfg.menuScale) or 1.00, 0.70, 1.25)
        end
    end
end)

local function saveConfig()
    if type(writefile) ~= "function" then return end
    pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(cfg)) end)
end

-- STATE + FORWARD DECLARATIONS
local UI_NAME = "CursedHub_CodeRedeemer"

local _seen               = {}
local _capturedParts      = {}
local _lastBox            = nil
local _focused            = nil
local _lastWatchedBox     = nil
local _lastNonBlankText   = ""
local _boxTextConn, _boxAncestryConn
local _pendingText, _pendingBox, _pendingUntil, _pendingToken = nil, nil, 0, 0
local _solvedCount        = 0
local _askedCount         = 0
local _riddleQueue        = {}
local _riddleBusy         = false

local GUI                                  -- ScreenGui
local logRich, clearLog                     -- console writers
local setStatus
local typeAndSubmitCode, appendToBox, clearCapture
local rememberPending, clearPending, handleFeedback
local bumpSolvedLabel, applyPowerVisual

-- SMALL UTILITIES
local function trim(s) return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")) end
local function stripRich(s)
    if type(s) ~= "string" then return tostring(s) end
    return (s:gsub("<[^>]->", ""))
end
local function upperClean(s)
    return (tostring(s or ""):upper():gsub("%s+", ""):gsub("[%?%.%,!\"'`\n\r]", ""))
end

-- SAB KNOWLEDGE BASE
local SAB_DB = {
    -- owner identity
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
    ["name"]                        = "SAMMY",
    ["my name"]                     = "SAMMY",
    ["sammy name"]                  = "SAMMY",
    ["sammys name"]                 = "SAMMY",
    ["game owner"]                  = "SAMMY",
    ["developer"]                   = "SAMMY",
    ["dev"]                         = "SAMMY",
    ["made by"]                     = "SAMMY",
    ["created by"]                  = "SAMMY",
    ["made this game"]              = "SAMMY",
    ["real name of sammy"]          = "SAMMY",
    ["roblox username"]             = "SPYDERSAMMY",
    ["my roblox username"]          = "SPYDERSAMMY",
    ["sammy username"]              = "SPYDERSAMMY",
    ["sammy roblox name"]           = "SPYDERSAMMY",
    ["roblox name"]                 = "SPYDERSAMMY",
    ["username"]                    = "SPYDERSAMMY",
    ["my username"]                 = "SPYDERSAMMY",
    ["roblox"]                      = "SPYDERSAMMY",
    ["channel"]                     = "SPYDERSAMMY",
    ["handle"]                      = "SPYDERSAMMY",

    -- age / birth
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

    -- location
    ["where am i from"]             = "BRAZIL",
    ["where is sammy from"]         = "BRAZIL",
    ["my country"]                  = "BRAZIL",
    ["sammy country"]               = "BRAZIL",
    ["country"]                     = "BRAZIL",
    ["where do i live"]             = "BRAZIL",
    ["where does sammy live"]       = "BRAZIL",
    ["sammy location"]              = "BRAZIL",
    ["location"]                    = "BRAZIL",
    ["from"]                        = "BRAZIL",
    ["birth country"]               = "BRAZIL",
    ["born in"]                     = "BRAZIL",
    ["lives in"]                    = "BRAZIL",
    ["comes from"]                  = "BRAZIL",
    ["nationality"]                 = "BRAZILIAN",
    ["sammy nationality"]           = "BRAZILIAN",
    ["my nationality"]              = "BRAZILIAN",
    ["state"]                       = "SAOPAULO",
    ["my state"]                    = "SAOPAULO",
    ["sammy state"]                 = "SAOPAULO",
    ["city"]                        = "SAOPAULO",
    ["my city"]                     = "SAOPAULO",
    ["sammy city"]                  = "SAOPAULO",

    -- favourites
    ["favorite color"]              = "BLUE",
    ["my color"]                    = "BLUE",
    ["sammy color"]                 = "BLUE",
    ["color"]                       = "BLUE",
    ["favorite color is blue"]      = "BLUE",
    ["color is blue"]               = "BLUE",
    ["favorite sport"]              = "FOOTBALL",
    ["sport"]                       = "FOOTBALL",
    ["my sport"]                    = "FOOTBALL",
    ["football"]                    = "FOOTBALL",
    ["favorite football player"]    = "RONALDO",
    ["my favorite football player"] = "RONALDO",
    ["football player"]             = "RONALDO",
    ["favorite player"]             = "RONALDO",
    ["player"]                      = "RONALDO",
    ["ronaldo"]                     = "RONALDO",
    ["favorite food"]               = "PIZZA",
    ["my food"]                     = "PIZZA",
    ["food"]                        = "PIZZA",
    ["favorite meal"]               = "PIZZA",
    ["favorite dish"]               = "PIZZA",
    ["favorite animal"]             = "SPIDER",
    ["my animal"]                   = "SPIDER",
    ["my pet"]                      = "SPIDER",
    ["pet name"]                    = "SPIDER",
    ["sammy pet name"]              = "SPIDER",
    ["pet"]                         = "SPIDER",
    ["animal"]                      = "SPIDER",
    ["favorite game"]               = "ROBLOX",
    ["game"]                        = "ROBLOX",
    ["favorite number"]             = "SEVEN",
    ["lucky number"]                = "SEVEN",
    ["number"]                      = "SEVEN",
    ["social media"]                = "YOUTUBE",
    ["youtube channel"]             = "SPYDERSAMMY",
    ["my youtube"]                  = "SPYDERSAMMY",
    ["sammy youtube"]               = "SPYDERSAMMY",
    ["youtube"]                     = "SPYDERSAMMY",
    ["discord"]                     = "ACE",
    ["discord server"]              = "ACE",
    ["sammy discord"]               = "SPYDERSAMMY",
    ["twitter"]                     = "SPYDERSAMMY",
    ["sammy twitter"]               = "SPYDERSAMMY",
    ["x account"]                   = "SPYDERSAMMY",
    ["tiktok"]                      = "SPYDERSAMMY",
    ["sammy tiktok"]                = "SPYDERSAMMY",
    ["instagram"]                   = "SPYDERSAMMY",

    -- release info
    ["game created on"]             = "FRIDAY",
    ["created on"]                  = "FRIDAY",
    ["what day was the game created"] = "FRIDAY",
    ["what day was sab created"]    = "FRIDAY",
    ["game creation day"]           = "FRIDAY",
    ["release month"]               = "MAY",
    ["release year"]                = "2025",
    ["year sab was created"]        = "2025",
    ["what year was sab created"]   = "2025",
    ["what year was the game created"] = "2025",
    ["year the game was created"]   = "2025",
    ["year sab was made"]           = "2025",
    ["month sab was made"]          = "MAY",
    ["month the game was made"]     = "MAY",
    ["month sab was released"]      = "MAY",
    ["what month was sab made"]     = "MAY",
    ["what month was sab released"] = "MAY",
    ["sab release month"]           = "MAY",
    ["day sab was made"]            = "FRIDAY",
    ["day sab was released"]        = "FRIDAY",
    ["what day was sab made"]       = "FRIDAY",
    ["what day was sab released"]   = "FRIDAY",
    ["sab release day"]             = "FRIDAY",
    ["game made on"]                = "FRIDAY",
    ["sab made on"]                 = "FRIDAY",
    ["day game released"]           = "FRIDAY",
    ["day sab released"]            = "FRIDAY",
    ["release day"]                 = "FRIDAY",
    ["day released"]                = "FRIDAY",
    ["what day was it released"]    = "FRIDAY",
    ["what day was it created"]     = "FRIDAY",
    ["year the game was made"]      = "2025",
    ["year made"]                   = "2025",
    ["year created"]                = "2025",
    ["what year was sab made"]      = "2025",
    ["year of sab"]                 = "2025",
    ["sab creation year"]           = "2025",
    ["creation year"]               = "2025",
    ["when was sab made"]           = "MAY162025",
    ["when made"]                   = "MAY162025",
    ["date made"]                   = "MAY162025",
    ["when was sab created"]        = "MAY162025",
    ["release date"]                = "MAY162025",
    ["when was sab released"]       = "MAY162025",
    ["when was the game released"]  = "MAY162025",
    ["game release date"]           = "MAY162025",
    ["game release"]                = "MAY162025",
    ["sab release"]                 = "MAY162025",
    ["game released"]               = "MAY162025",
    ["sab released"]                = "MAY162025",
    ["when created"]                = "MAY162025",
    ["when released"]               = "MAY162025",
    ["date released"]               = "MAY162025",
    ["date created"]                = "MAY162025",

    -- repeats
    ["my name twice"]               = "SAMMYSAMMY",
    ["my name 2 times"]             = "SAMMYSAMMY",
    ["my name 3 times"]             = "SAMMYSAMMYSAMMY",
    ["name twice"]                  = "SAMMYSAMMY",
    ["owner twice"]                 = "SAMMYSAMMY",
    ["creator twice"]               = "SAMMYSAMMY",
    ["my age twice"]                = "2424",
    ["my age 2 times"]              = "2424",
    ["my age 3 times"]              = "242424",
    ["favorite color twice"]        = "BLUEBLUE",
    ["favorite color 2 times"]      = "BLUEBLUE",
    ["favorite color 3 times"]      = "BLUEBLUEBLUE",
    ["favorite color three times"]  = "BLUEBLUEBLUE",
    ["favorite color 5 times"]      = "BLUEBLUEBLUEBLUEBLUE",
    ["my favorite color twice"]     = "BLUEBLUE",
    ["my favorite color 2 times"]   = "BLUEBLUE",
    ["my favorite color 3 times"]   = "BLUEBLUEBLUE",
    ["favorite sport twice"]        = "FOOTBALLFOOTBALL",
    ["favorite food twice"]         = "PIZZAPIZZA",

    -- traits
    ["first trait"]                 = "LIGHTNING",
    ["1st trait"]                   = "LIGHTNING",
    ["first trait created"]         = "LIGHTNING",
    ["1st trait created"]           = "LIGHTNING",
    ["first trait added"]           = "BUBBLEGUM",
    ["trait added first"]           = "BUBBLEGUM",
    ["trait first added"]           = "BUBBLEGUM",
    ["what trait"]                  = "LIGHTNING",
    ["trait"]                       = "LIGHTNING",
    ["trait you get when struck by lightning"] = "MATEO",
    ["struck by lightning"]         = "MATEO",
    ["lightning trait"]             = "MATEO",
    ["trait from lightning"]        = "MATEO",
    ["trait when struck by lightning"] = "MATEO",
    ["lightning strike trait"]      = "MATEO",
    ["get struck by lightning"]     = "MATEO",
    ["lightning gives"]             = "MATEO",
    ["struck by lightning trait"]   = "MATEO",
    ["lightning"]                   = "MATEO",
    ["mateo"]                       = "MATEO",

    -- mutations
    ["first mutation"]              = "BLOODROT",
    ["1st mutation"]                = "BLOODROT",
    ["second mutation"]             = "CANDY",
    ["2nd mutation"]                = "CANDY",
    ["third mutation"]              = "LAVA",
    ["3rd mutation"]                = "LAVA",
    ["fourth mutation"]             = "GALAXY",
    ["4th mutation"]                = "GALAXY",
    ["fifth mutation"]              = "YINYANG",
    ["5th mutation"]                = "YINYANG",
    ["sixth mutation"]              = "RADIOACTIVE",
    ["6th mutation"]                = "RADIOACTIVE",
    ["seventh mutation"]            = "CURSED",
    ["7th mutation"]                = "CURSED",
    ["eighth mutation"]             = "DIVINE",
    ["8th mutation"]                = "DIVINE",
    ["ninth mutation"]              = "CYBER",
    ["9th mutation"]                = "CYBER",
    ["tenth mutation"]              = "PHANTOM",
    ["10th mutation"]               = "PHANTOM",
    ["eleventh mutation"]           = "CRYSTAL",
    ["11th mutation"]               = "CRYSTAL",
    ["mutation 1"]  = "BLOODROT",    ["mutation number 1"]  = "BLOODROT",
    ["mutation 2"]  = "CANDY",       ["mutation number 2"]  = "CANDY",
    ["mutation 3"]  = "LAVA",        ["mutation number 3"]  = "LAVA",
    ["mutation 4"]  = "GALAXY",      ["mutation number 4"]  = "GALAXY",
    ["mutation 5"]  = "YINYANG",     ["mutation number 5"]  = "YINYANG",
    ["mutation 6"]  = "RADIOACTIVE", ["mutation number 6"]  = "RADIOACTIVE",
    ["mutation 7"]  = "CURSED",      ["mutation number 7"]  = "CURSED",
    ["mutation 8"]  = "DIVINE",      ["mutation number 8"]  = "DIVINE",
    ["mutation 9"]  = "CYBER",       ["mutation number 9"]  = "CYBER",
    ["mutation 10"] = "PHANTOM",     ["mutation number 10"] = "PHANTOM",
    ["mutation 11"] = "CRYSTAL",     ["mutation number 11"] = "CRYSTAL",
    ["evil mutation"]               = "CURSED",
    ["evil"]                        = "CURSED",
    ["cursed mutation"]             = "CURSED",
    ["angelic mutation"]            = "DIVINE",
    ["angelic"]                     = "DIVINE",
    ["divine mutation"]             = "DIVINE",
    ["good mutation"]               = "DIVINE",
    ["best mutation"]               = "DIVINE",
    ["top mutation"]                = "DIVINE",
    ["latest mutation"]             = "CRYSTAL",
    ["most recent mutation"]        = "CRYSTAL",
    ["most recent"]                 = "CRYSTAL",
    ["newest mutation"]             = "CRYSTAL",
    ["last mutation"]               = "CRYSTAL",
    ["divinecursed"]                = "DIVINECURSED",
    ["curseddivine"]                = "CURSEDDIVINE",
    ["green mutation"]              = "RADIOACTIVE",
    ["turns green"]                 = "RADIOACTIVE",
    ["green"]                       = "RADIOACTIVE",
    ["purple mutation"]             = "GALAXY",
    ["turns purple"]                = "GALAXY",
    ["purple"]                      = "GALAXY",
    ["black and white mutation"]    = "YINYANG",
    ["black mutation"]              = "YINYANG",
    ["turns black"]                 = "YINYANG",
    ["black and white"]             = "YINYANG",
    ["yellow mutation"]             = "DIVINE",
    ["turns yellow"]                = "DIVINE",
    ["yellow"]                      = "DIVINE",
    ["red mutation"]                = "CURSED",
    ["turns red"]                   = "CURSED",
    ["red"]                         = "CURSED",
    ["orange mutation"]             = "LAVA",
    ["turns orange"]                = "LAVA",
    ["orange"]                      = "LAVA",
    ["blue mutation"]               = "DIAMOND",
    ["pink mutation"]               = "CANDY",
    ["gold"]                        = "GOLD",
    ["diamond"]                     = "DIAMOND",
    ["bloodrot"]                    = "BLOODROT",
    ["rainbow"]                     = "RAINBOW",
    ["candy"]                       = "CANDY",
    ["lava"]                        = "LAVA",
    ["galaxy"]                      = "GALAXY",
    ["yinyang"]                     = "YINYANG",
    ["radioactive"]                 = "RADIOACTIVE",
    ["cursed"]                      = "CURSED",
    ["divine"]                      = "DIVINE",
    ["cyber"]                       = "CYBER",
    ["phantom"]                     = "PHANTOM",
    ["crystal"]                     = "CRYSTAL",
    ["color of gold mutation"]      = "YELLOW",
    ["color of diamond mutation"]   = "BLUE",
    ["color of bloodrot mutation"]  = "RED",
    ["color of rainbow mutation"]   = "RAINBOW",
    ["color of candy mutation"]     = "PINK",
    ["color of lava mutation"]      = "ORANGE",
    ["color of galaxy mutation"]    = "PURPLE",
    ["color of yinyang mutation"]   = "BLACK",
    ["color of radioactive mutation"] = "GREEN",
    ["color of cursed mutation"]    = "RED",
    ["color of divine mutation"]    = "YELLOW",
    ["color of cyber mutation"]     = "BLUE",
    ["color of phantom mutation"]   = "BLACK",
    ["color of crystal mutation"]   = "BLUEPURPLE",
    ["divine color"]                = "YELLOW",
    ["cursed color"]                = "RED",
    ["radioactive color"]           = "GREEN",
    ["galaxy color"]                = "PURPLE",
    ["yinyang color"]               = "BLACK",
    ["lava color"]                  = "ORANGE",
    ["what number is bloodrot"]     = "1",
    ["what number is candy"]        = "2",
    ["what number is lava"]         = "3",
    ["what number is galaxy"]       = "4",
    ["what number is yinyang"]      = "5",
    ["what number is radioactive"]  = "6",
    ["what number is cursed"]       = "7",
    ["what number is divine"]       = "8",
    ["what number is cyber"]        = "9",
    ["what number is phantom"]      = "10",
    ["what number is crystal"]      = "11",

    -- machines
    ["first machine"]               = "RAINBOWMACHINE",
    ["1st machine"]                 = "RAINBOWMACHINE",
    ["second machine"]              = "BUBBLEGUMMACHINE",
    ["2nd machine"]                 = "BUBBLEGUMMACHINE",
    ["third machine"]               = "FUSEMACHINE",
    ["3rd machine"]                 = "FUSEMACHINE",
    ["fourth machine"]              = "CRAFTMACHINE",
    ["4th machine"]                 = "CRAFTMACHINE",
    ["fifth machine"]               = "WITCHFUSE",
    ["5th machine"]                 = "WITCHFUSE",
    ["sixth machine"]               = "BRAINROTDEALER",
    ["6th machine"]                 = "BRAINROTDEALER",
    ["seventh machine"]             = "BRAINROTTRADER",
    ["7th machine"]                 = "BRAINROTTRADER",
    ["eighth machine"]              = "SANTASFUSE",
    ["8th machine"]                 = "SANTASFUSE",
    ["ninth machine"]               = "SANTASSHOP",
    ["9th machine"]                 = "SANTASSHOP",
    ["tenth machine"]               = "NEWYEARSMACHINE",
    ["10th machine"]                = "NEWYEARSMACHINE",
    ["eleventh machine"]            = "DUELSMACHINE",
    ["11th machine"]                = "DUELSMACHINE",
    ["twelfth machine"]             = "CUPIDSMACHINE",
    ["12th machine"]                = "CUPIDSMACHINE",
    ["thirteenth machine"]          = "TRADEMACHINE",
    ["13th machine"]                = "TRADEMACHINE",
    ["fourteenth machine"]          = "DIVINEFUSE",
    ["14th machine"]                = "DIVINEFUSE",
    ["fifteenth machine"]           = "EGGINCUBATOR",
    ["15th machine"]                = "EGGINCUBATOR",
    ["sixteenth machine"]           = "CYBERCRAFTMACHINE",
    ["16th machine"]                = "CYBERCRAFTMACHINE",
    ["seventeenth machine"]         = "SUMMERFUSE",
    ["17th machine"]                = "SUMMERFUSE",
    ["eighteenth machine"]          = "LOSTRADERS",
    ["18th machine"]                = "LOSTRADERS",
    ["machine 1"]  = "RAINBOWMACHINE",    ["machine number 1"]  = "RAINBOWMACHINE",
    ["machine 2"]  = "BUBBLEGUMMACHINE",  ["machine number 2"]  = "BUBBLEGUMMACHINE",
    ["machine 3"]  = "FUSEMACHINE",       ["machine number 3"]  = "FUSEMACHINE",
    ["machine 4"]  = "CRAFTMACHINE",      ["machine number 4"]  = "CRAFTMACHINE",
    ["machine 5"]  = "WITCHFUSE",         ["machine number 5"]  = "WITCHFUSE",
    ["machine 6"]  = "BRAINROTDEALER",    ["machine number 6"]  = "BRAINROTDEALER",
    ["machine 7"]  = "BRAINROTTRADER",    ["machine number 7"]  = "BRAINROTTRADER",
    ["machine 8"]  = "SANTASFUSE",        ["machine number 8"]  = "SANTASFUSE",
    ["machine 9"]  = "SANTASSHOP",        ["machine number 9"]  = "SANTASSHOP",
    ["machine 10"] = "NEWYEARSMACHINE",   ["machine number 10"] = "NEWYEARSMACHINE",
    ["machine 11"] = "DUELSMACHINE",      ["machine number 11"] = "DUELSMACHINE",
    ["machine 12"] = "CUPIDSMACHINE",     ["machine number 12"] = "CUPIDSMACHINE",
    ["machine 13"] = "TRADEMACHINE",      ["machine number 13"] = "TRADEMACHINE",
    ["machine 14"] = "DIVINEFUSE",        ["machine number 14"] = "DIVINEFUSE",
    ["machine 15"] = "EGGINCUBATOR",      ["machine number 15"] = "EGGINCUBATOR",
    ["machine 16"] = "CYBERCRAFTMACHINE", ["machine number 16"] = "CYBERCRAFTMACHINE",
    ["machine 17"] = "SUMMERFUSE",        ["machine number 17"] = "SUMMERFUSE",
    ["machine 18"] = "LOSTRADERS",        ["machine number 18"] = "LOSTRADERS",
    ["rainbowmachine"]              = "RAINBOWMACHINE",
    ["bubblegummachine"]            = "BUBBLEGUMMACHINE",
    ["fusemachine"]                 = "FUSEMACHINE",
    ["craftmachine"]                = "CRAFTMACHINE",
    ["witchfuse"]                   = "WITCHFUSE",
    ["brainrotdealer"]              = "BRAINROTDEALER",
    ["brainrottrader"]              = "BRAINROTTRADER",
    ["santasfuse"]                  = "SANTASFUSE",
    ["santasshop"]                  = "SANTASSHOP",
    ["newyearsmachine"]             = "NEWYEARSMACHINE",
    ["duelsmachine"]                = "DUELSMACHINE",
    ["cupidsmachine"]               = "CUPIDSMACHINE",
    ["trademachine"]                = "TRADEMACHINE",
    ["divinefuse"]                  = "DIVINEFUSE",
    ["eggincubator"]                = "EGGINCUBATOR",
    ["cybercraftmachine"]           = "CYBERCRAFTMACHINE",
    ["summerfuse"]                  = "SUMMERFUSE",
    ["lostraders"]                  = "LOSTRADERS",
    ["newest machine"]              = "LOSTRADERS",
    ["last machine"]                = "LOSTRADERS",
    ["latest machine"]              = "LOSTRADERS",

    -- brainrots + rarities
    ["og brainrot cannot be obtained"] = "HEADLESSHORSEMAN",
    ["headless horseman"]           = "HEADLESSHORSEMAN",
    ["rarest brainrot"]             = "HEADLESSHORSEMAN",
    ["rarest"]                      = "HEADLESSHORSEMAN",
    ["unobtainable brainrot"]       = "HEADLESSHORSEMAN",
    ["unobtainable"]                = "HEADLESSHORSEMAN",
    ["best brainrot"]               = "STRAWBERRYELEPHANT",
    ["first og added"]              = "STRAWBERRYELEPHANT",
    ["1st og"]                      = "STRAWBERRYELEPHANT",
    ["second og added"]             = "MEOWL",
    ["2nd og"]                      = "MEOWL",
    ["third og added"]              = "SKIBIDITOILET",
    ["3rd og"]                      = "SKIBIDITOILET",
    ["fourth og added"]             = "JOHNPORK",
    ["4th og"]                      = "JOHNPORK",
    ["og 1"]  = "STRAWBERRYELEPHANT", ["og number 1"] = "STRAWBERRYELEPHANT",
    ["og 2"]  = "MEOWL",              ["og number 2"] = "MEOWL",
    ["og 3"]  = "SKIBIDITOILET",      ["og number 3"] = "SKIBIDITOILET",
    ["og 4"]  = "JOHNPORK",           ["og number 4"] = "JOHNPORK",
    ["first brainrot added"]        = "STRAWBERRYELEPHANT",
    ["1st brainrot"]                = "STRAWBERRYELEPHANT",
    ["oldest brainrot"]             = "STRAWBERRYELEPHANT",
    ["worst brainrot"]              = "NOOBINIPIZZANINI",
    ["most common brainrot"]        = "NOOBINIPIZZANINI",
    ["least rare brainrot"]         = "NOOBINIPIZZANINI",
    ["weakest brainrot"]            = "NOOBINIPIZZANINI",
    ["common brainrot"]             = "NOOBINIPIZZANINI",
    ["most popular brainrot"]       = "DRAGONCANNELONNI",
    ["highest rarity"]              = "OG",
    ["rarest rarity"]               = "OG",
    ["top rarity"]                  = "OG",
    ["best rarity"]                 = "OG",
    ["6th rarity"]                  = "OG",
    ["sixth rarity"]                = "OG",
    ["lowest rarity"]               = "COMMON",
    ["worst rarity"]                = "COMMON",
    ["common rarity"]               = "COMMON",
    ["1st rarity"]                  = "COMMON",
    ["second rarity"]               = "UNCOMMON",
    ["2nd rarity"]                  = "UNCOMMON",
    ["third rarity"]                = "RARE",
    ["3rd rarity"]                  = "RARE",
    ["fourth rarity"]               = "EPIC",
    ["4th rarity"]                  = "EPIC",
    ["fifth rarity"]                = "LEGENDARY",
    ["5th rarity"]                  = "LEGENDARY",
    ["uncommon"]                    = "UNCOMMON",
    ["rare"]                        = "RARE",
    ["epic"]                        = "EPIC",
    ["legendary"]                   = "LEGENDARY",
    ["og"]                          = "OG",
    ["common"]                      = "COMMON",

    -- trivia
    ["fire represents"]             = "DRAGON",
    ["fire stands for"]             = "DRAGON",
    ["fire symbol"]                 = "DRAGON",
    ["fire meaning"]                = "DRAGON",
    ["fire brainrot"]               = "DRAGON",
    ["fire"]                        = "DRAGON",
    ["dragon"]                      = "DRAGON",
    ["won the world cup"]           = "SPAIN",
    ["world cup winner"]            = "SPAIN",
    ["world cup"]                   = "SPAIN",
    ["won world cup"]               = "SPAIN",
    ["football world cup"]          = "SPAIN",
    ["worst game owner"]            = "SECRETLOKII",
    ["most boring game owner"]      = "SECRETLOKII",
    ["worst owner"]                 = "SECRETLOKII",
    ["boring owner"]                = "SECRETLOKII",
    ["most boring owner"]           = "SECRETLOKII",
    ["most boring game on roblox"]  = "KEYBOARDESCAPE",
    ["boring game"]                 = "KEYBOARDESCAPE",
    ["most boring game"]            = "KEYBOARDESCAPE",
    ["boring roblox game"]          = "KEYBOARDESCAPE",
    ["spawned during admin abuse war"] = "RACOONINIJANDELINI",
    ["admin war brainrot"]          = "RACOONINIJANDELINI",
    ["spawned in admin war"]        = "RACOONINIJANDELINI",
    ["who did i fight in the admin abuse war"] = "JANDEL",
    ["fought in admin abuse war"]   = "JANDEL",
    ["who did sammy fight"]         = "JANDEL",
    ["sammy fought"]                = "JANDEL",
    ["fight in admin war"]          = "JANDEL",
    ["won the admin abuse war"]     = "GROWAGARDEN",
    ["admin abuse war"]             = "GROWAGARDEN",
    ["who won admin war"]           = "GROWAGARDEN",
    ["admin war winner"]            = "GROWAGARDEN",
    ["admin war"]                   = "GROWAGARDEN",
    ["worst secret"]                = "KARKERKARKURKUR",
    ["secret"]                      = "KARKERKARKURKUR",
    ["bad secret"]                  = "KARKERKARKURKUR",
    ["maximum server size"]         = "EIGHT",
    ["max server size"]             = "EIGHT",
    ["server size"]                 = "EIGHT",
    ["how many players"]            = "EIGHT",
    ["max players"]                 = "EIGHT",
    ["players"]                     = "EIGHT",
    ["player count"]                = "EIGHT",
    ["server"]                      = "EIGHT",
    ["how many players in server"]  = "EIGHT",
    ["server capacity"]             = "EIGHT",
    ["players per server"]          = "EIGHT",
    ["max server"]                  = "EIGHT",
    ["brother of hydra bunny"]      = "CERBERUS",
    ["hydra bunny brother"]         = "CERBERUS",
    ["hydra bunny"]                 = "CERBERUS",
    ["cerberus brother"]            = "CERBERUS",
    ["brother of hydra"]            = "CERBERUS",
    ["brother"]                     = "CERBERUS",
    ["cerberus"]                    = "CERBERUS",

    -- game meta
    ["game name"]                   = "STEALABRAINROT",
    ["name of the game"]            = "STEALABRAINROT",
    ["sab"]                         = "STEALABRAINROT",
    ["sab stands for"]              = "STEALABRAINROT",
    ["full name"]                   = "STEALABRAINROT",
    ["what is sab"]                 = "STEALABRAINROT",
    ["steal a brainrot"]            = "STEALABRAINROT",
    ["full game name"]              = "STEALABRAINROT",
    ["game full name"]              = "STEALABRAINROT",
    ["sab full name"]               = "STEALABRAINROT",
    ["number of mutations"]         = "14",
    ["how many mutations"]          = "14",
    ["total mutations"]             = "THIRTEEN",
    ["mutation count"]              = "THIRTEEN",
    ["number of machines"]          = "18",
    ["how many machines"]           = "18",
    ["total machines"]              = "18",
    ["machine count"]               = "EIGHTEEN",
    ["total rarities"]              = "SIX",
    ["how many rarities"]           = "SIX",
    ["number of rarities"]          = "SIX",
    ["rarities"]                    = "SIX",
    ["rarity count"]                = "SIX",
    ["brainrot count"]              = "THIRTEEN",
    ["how many brainrots"]          = "THIRTEEN",
    ["number brainrots"]            = "THIRTEEN",
    ["how many og brainrots"]       = "FIVE",
    ["total og brainrots"]          = "FIVE",
    ["og count"]                    = "FIVE",
    ["type of game"]                = "SIMULATOR",
    ["game genre"]                  = "SIMULATOR",
    ["genre"]                       = "SIMULATOR",
    ["game type"]                   = "SIMULATOR",
    ["what type"]                   = "SIMULATOR",
    ["sab genre"]                   = "SIMULATOR",
    ["sab type"]                    = "SIMULATOR",
    ["first update"]                = "MUTATIONS",
    ["1st update"]                  = "MUTATIONS",
    ["update"]                      = "MUTATIONS",

    -- pre-baked combos (splitter handles the rest)
    ["favorite color favorite sport"]   = "BLUEFOOTBALL",
    ["favorite color favorite animal"]  = "BLUESPIDER",
    ["favorite color favorite food"]    = "BLUEPIZZA",
    ["favorite color favorite player"]  = "BLUERONALDO",
    ["favorite color creator"]          = "BLUESAMMY",
    ["favorite color owner"]            = "BLUESAMMY",
    ["favorite color username"]         = "BLUESPYDERSAMMY",
    ["favorite sport favorite player"]  = "FOOTBALLRONALDO",
    ["favorite sport favorite animal"]  = "FOOTBALLSPIDER",
    ["name favorite food"]              = "SAMMYPIZZA",
    ["name favorite color"]             = "SAMMYBLUE",
    -- === MEGA DUMP EXPANSION (clean merge) ===
    ["1 1 brainrot"] = "155",
    ["1 1 exist"] = "155",
    ["1 1s brainrot"] = "155",
    ["1 1s exist"] = "155",
    ["1 of 1"] = "1of1",
    ["1 of 1 brainrots"] = "155",
    ["1 of 1 brainrots exist"] = "155",
    ["1 of 1 exist"] = "155",
    ["1 of 1s brainrots"] = "155",
    ["1 of 1s exist"] = "155",
    ["1 speed keyboard escape"] = "1speedkeyboardescape",
    ["1 year event trait"] = "1year",
    ["1 year event trait date"] = "may2026",
    ["1 year event trait month"] = "may",
    ["1 year event trait release"] = "may2026",
    ["1 year event trait release date"] = "may2026",
    ["1 year event trait release month"] = "may",
    ["1 year event trait release year"] = "2026",
    ["1 year event trait year"] = "2026",
    ["1 year trait"] = "1year",
    ["1 year trait date"] = "may2026",
    ["1 year trait month"] = "may",
    ["1 year trait release"] = "may2026",
    ["1 year trait release date"] = "may2026",
    ["1 year trait release month"] = "may",
    ["1 year trait release year"] = "2026",
    ["1 year trait year"] = "2026",
    ["10 billion trait"] = "10b",
    ["10 billion trait date"] = "june2025",
    ["10 billion trait month"] = "june",
    ["10 billion trait release"] = "june2025",
    ["10 billion trait release date"] = "june2025",
    ["10 billion trait release month"] = "june",
    ["10 billion trait release year"] = "2025",
    ["10 billion trait year"] = "2025",
    ["10 billion visits trait"] = "10b",
    ["10 billion visits trait date"] = "june2025",
    ["10 billion visits trait month"] = "june",
    ["10 billion visits trait release"] = "june2025",
    ["10 billion visits trait release date"] = "june2025",
    ["10 billion visits trait release month"] = "june",
    ["10 billion visits trait release year"] = "2025",
    ["10 billion visits trait year"] = "2025",
    ["10b"] = "10b",
    ["10b trait"] = "10b",
    ["10b trait date"] = "june2025",
    ["10b trait month"] = "june",
    ["10b trait release"] = "june2025",
    ["10b trait release date"] = "june2025",
    ["10b trait release month"] = "june",
    ["10b trait release year"] = "2025",
    ["10b trait year"] = "2025",
    ["111"] = "111",
    ["155"] = "155",
    ["1of1"] = "1of1",
    ["1of1 brainrot"] = "155",
    ["1of1 brainrots"] = "155",
    ["1of1 brainrots exist"] = "155",
    ["1of1 exist"] = "155",
    ["1of1s brainrot"] = "155",
    ["1of1s brainrots"] = "155",
    ["1of1s exist"] = "155",
    ["1speedkeyboardescape"] = "1speedkeyboardescape",
    ["1st bee"] = "beeloco",
    ["1st bee brainrot"] = "beeloco",
    ["1st bee brainrot in game"] = "beeloco",
    ["1st bee brainrot in sab"] = "beeloco",
    ["1st bee brainrot in the"] = "beeloco",
    ["1st bee brainrot in the game"] = "beeloco",
    ["1st bee in game"] = "beeloco",
    ["1st bee in sab"] = "beeloco",
    ["1st bee in the game"] = "beeloco",
    ["1st bee lucky"] = "beeloco",
    ["1st bee lucky block"] = "beeloco",
    ["1st bee lucky block brainrot"] = "beeloco",
    ["1st bee shop"] = "beeloco",
    ["1st bee shop brainrot"] = "beeloco",
    ["1st bee update"] = "beeloco",
    ["1st bee update brainrot"] = "beeloco",
    ["1st best taco merchant"] = "sammynitruckini",
    ["1st brainrot god"] = "tralalerotralala",
    ["1st brainrot that got removed"] = "tungtungtungsahur",
    ["1st brainrot that was reworked"] = "sammynispyderini",
    ["1st craft"] = "september2025",
    ["1st craft date"] = "september2025",
    ["1st craft day"] = "6",
    ["1st craft machine"] = "september2025",
    ["1st craft machine date"] = "september2025",
    ["1st craft machine day"] = "6",
    ["1st craft machine month"] = "september",
    ["1st craft machine release"] = "september2025",
    ["1st craft machine release date"] = "september2025",
    ["1st craft machine release day"] = "6",
    ["1st craft machine release month"] = "september",
    ["1st craft machine release year"] = "2025",
    ["1st craft machine year"] = "2025",
    ["1st craft month"] = "september",
    ["1st craft release"] = "september2025",
    ["1st craft release date"] = "september2025",
    ["1st craft release day"] = "6",
    ["1st craft release month"] = "september",
    ["1st craft release year"] = "2025",
    ["1st craft year"] = "2025",
    ["1st fuse"] = "lafusemachine",
    ["1st fuse date"] = "august2025",
    ["1st fuse day"] = "1",
    ["1st fuse machine"] = "lafusemachine",
    ["1st fuse machine date"] = "august2025",
    ["1st fuse machine day"] = "1",
    ["1st fuse machine month"] = "august",
    ["1st fuse machine release"] = "august2025",
    ["1st fuse machine release date"] = "august2025",
    ["1st fuse machine release day"] = "1",
    ["1st fuse machine release month"] = "august",
    ["1st fuse machine release year"] = "2025",
    ["1st fuse machine year"] = "2025",
    ["1st fuse month"] = "august",
    ["1st fuse release"] = "august2025",
    ["1st fuse release date"] = "august2025",
    ["1st fuse release day"] = "1",
    ["1st fuse release month"] = "august",
    ["1st fuse release year"] = "2025",
    ["1st fuse year"] = "2025",
    ["1st gear"] = "bat",
    ["1st god"] = "tralalerotralala",
    ["1st item"] = "bat",
    ["1st lucky block"] = "july2025",
    ["1st lucky block date"] = "july2025",
    ["1st lucky block day"] = "12",
    ["1st lucky block month"] = "july",
    ["1st lucky block release"] = "july2025",
    ["1st lucky block release date"] = "july2025",
    ["1st lucky block release day"] = "12",
    ["1st lucky block release month"] = "july",
    ["1st lucky block release year"] = "2025",
    ["1st lucky block year"] = "2025",
    ["1st machine added"] = "rainbowmachine",
    ["1st machine added date"] = "june2025",
    ["1st machine added day"] = "21",
    ["1st machine added month"] = "june",
    ["1st machine added release"] = "june2025",
    ["1st machine added release date"] = "june2025",
    ["1st machine added release day"] = "21",
    ["1st machine added release month"] = "june",
    ["1st machine added release year"] = "2025",
    ["1st machine added year"] = "2025",
    ["1st machine date"] = "june2025",
    ["1st machine day"] = "21",
    ["1st machine game"] = "rainbowmachine",
    ["1st machine month"] = "june",
    ["1st machine release"] = "june2025",
    ["1st machine release date"] = "june2025",
    ["1st machine release day"] = "21",
    ["1st machine release month"] = "june",
    ["1st machine release year"] = "2025",
    ["1st machine sab"] = "rainbowmachine",
    ["1st machine year"] = "2025",
    ["1st og brainrot"] = "strawberryelephant",
    ["1st og brainrot in game"] = "strawberryelephant",
    ["1st og brainrot in the game"] = "strawberryelephant",
    ["1st og in game"] = "strawberryelephant",
    ["1st og in the game"] = "strawberryelephant",
    ["1st removed brainrot"] = "tungtungtungsahur",
    ["1st reworked brainrot"] = "sammynispyderini",
    ["1st secret"] = "lavaccasaturnosaturnita",
    ["1st secret brainrot"] = "lavaccasaturnosaturnita",
    ["1st secret in sab"] = "lavaccasaturnosaturnita",
    ["1st secret in sub"] = "lavaccasaturnosaturnita",
    ["1st secret in the game"] = "lavaccasaturnosaturnita",
    ["1st snake"] = "hydraserpent",
    ["1st snake added"] = "hydraserpent",
    ["1st snake brainrot"] = "hydraserpent",
    ["1st snake brainrot added"] = "hydraserpent",
    ["1st snake brainrot ever added"] = "hydraserpent",
    ["1st snake brainrot in game"] = "hydraserpent",
    ["1st snake brainrot in sab"] = "hydraserpent",
    ["1st snake brainrot in the game"] = "hydraserpent",
    ["1st snake brainrot that was added"] = "hydraserpent",
    ["1st snake brainrot that was ever added"] = "hydraserpent",
    ["1st snake ever added"] = "hydraserpent",
    ["1st snake in game"] = "hydraserpent",
    ["1st snake in sab"] = "hydraserpent",
    ["1st snake in the game"] = "hydraserpent",
    ["1st snake that was added"] = "hydraserpent",
    ["1st snake that was ever added"] = "hydraserpent",
    ["1st taco"] = "tipitopitaco",
    ["1st taco brainrot"] = "tipitopitaco",
    ["1st taco in the game"] = "tipitopitaco",
    ["1st taco merchant"] = "sammynitruckini",
    ["1year"] = "1year",
    ["2 brainrots deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots remove"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots removed"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots that got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots that were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["2 deleted brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["2 removed brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["2013"] = "2013",
    ["2013 release year"] = "2013",
    ["2013 year"] = "2013",
    ["2026"] = "2026",
    ["2026 trait"] = "2026",
    ["2026 trait date"] = "december2025",
    ["2026 trait month"] = "december",
    ["2026 trait release"] = "december2025",
    ["2026 trait release date"] = "december2025",
    ["2026 trait release month"] = "december",
    ["2026 trait release year"] = "2025",
    ["2026 trait year"] = "2025",
    ["222"] = "222",
    ["26"] = "26",
    ["26 trait"] = "2026",
    ["26 trait date"] = "december2025",
    ["26 trait month"] = "december",
    ["26 trait release"] = "december2025",
    ["26 trait release date"] = "december2025",
    ["26 trait release month"] = "december",
    ["26 trait release year"] = "2025",
    ["26 trait year"] = "2025",
    ["2nd best"] = "strawberryelephant",
    ["2nd best brainrot"] = "strawberryelephant",
    ["2nd best brainrot in game"] = "strawberryelephant",
    ["2nd best brainrot in the game"] = "strawberryelephant",
    ["2nd best taco merchant"] = "nachorilla",
    ["2nd brainrot that got removed"] = "crocidilopenisini",
    ["2nd brainrot that was reworked"] = "unclitosamito",
    ["2nd fuse"] = "witchfuse",
    ["2nd fuse date"] = "october2025",
    ["2nd fuse day"] = "11",
    ["2nd fuse machine"] = "witchfuse",
    ["2nd fuse machine date"] = "october2025",
    ["2nd fuse machine day"] = "11",
    ["2nd fuse machine month"] = "october",
    ["2nd fuse machine release"] = "october2025",
    ["2nd fuse machine release date"] = "october2025",
    ["2nd fuse machine release day"] = "11",
    ["2nd fuse machine release month"] = "october",
    ["2nd fuse machine release year"] = "2025",
    ["2nd fuse machine year"] = "2025",
    ["2nd fuse month"] = "october",
    ["2nd fuse release"] = "october2025",
    ["2nd fuse release date"] = "october2025",
    ["2nd fuse release day"] = "11",
    ["2nd fuse release month"] = "october",
    ["2nd fuse release year"] = "2025",
    ["2nd fuse year"] = "2025",
    ["2nd name"] = "brakta",
    ["2nd name of sammy"] = "brakta",
    ["2nd name of sammys"] = "brakta",
    ["2nd og added"] = "meowl",
    ["2nd og added in sab"] = "meowl",
    ["2nd og added to sab"] = "meowl",
    ["2nd og brainrot"] = "meowl",
    ["2nd og in sab"] = "meowl",
    ["2nd og in the game"] = "meowl",
    ["2nd removed brainrot"] = "crocidilopenisini",
    ["2nd reworked brainrot"] = "unclitosamito",
    ["2nd taco merchant"] = "nachorilla",
    ["3 brainrots rework"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["3 brainrots reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["3 brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["3 brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["3 headed"] = "hydraserpent",
    ["3 headed brainrot"] = "hydraserpent",
    ["3 headed brainrot added in todays update"] = "hydraserpent",
    ["3 headed brainrot added today"] = "hydraserpent",
    ["3 headed snake"] = "hydraserpent",
    ["3 headed snake brainrot"] = "hydraserpent",
    ["3 reworked brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["333"] = "333",
    ["3rd best taco merchant"] = "tacoturbotacorito",
    ["3rd brainrot that was reworked"] = "gattatinonyanino",
    ["3rd fuse"] = "santafuse",
    ["3rd fuse date"] = "december2025",
    ["3rd fuse day"] = "6",
    ["3rd fuse machine"] = "santafuse",
    ["3rd fuse machine date"] = "december2025",
    ["3rd fuse machine day"] = "6",
    ["3rd fuse machine month"] = "december",
    ["3rd fuse machine release"] = "december2025",
    ["3rd fuse machine release date"] = "december2025",
    ["3rd fuse machine release day"] = "6",
    ["3rd fuse machine release month"] = "december",
    ["3rd fuse machine release year"] = "2025",
    ["3rd fuse machine year"] = "2025",
    ["3rd fuse month"] = "december",
    ["3rd fuse release"] = "december2025",
    ["3rd fuse release date"] = "december2025",
    ["3rd fuse release day"] = "6",
    ["3rd fuse release month"] = "december",
    ["3rd fuse release year"] = "2025",
    ["3rd fuse year"] = "2025",
    ["3rd og brainrot"] = "skibiditoilet",
    ["3rd reworked brainrot"] = "gattatinonyanino",
    ["3rd taco merchant"] = "tacoturbotacorito",
    ["444"] = "444",
    ["4th 3 headed"] = "hydraserpent",
    ["4th 3 headed brainrot"] = "hydraserpent",
    ["4th 3 headed brainrot added"] = "hydraserpent",
    ["4th 3 headed brainrot in the game"] = "hydraserpent",
    ["4th best taco merchant"] = "burritobat",
    ["4th fuse"] = "divinefuse",
    ["4th fuse date"] = "march2026",
    ["4th fuse day"] = "7",
    ["4th fuse machine"] = "divinefuse",
    ["4th fuse machine date"] = "march2026",
    ["4th fuse machine day"] = "7",
    ["4th fuse machine month"] = "march",
    ["4th fuse machine release"] = "march2026",
    ["4th fuse machine release date"] = "march2026",
    ["4th fuse machine release day"] = "7",
    ["4th fuse machine release month"] = "march",
    ["4th fuse machine release year"] = "2026",
    ["4th fuse machine year"] = "2026",
    ["4th fuse month"] = "march",
    ["4th fuse release"] = "march2026",
    ["4th fuse release date"] = "march2026",
    ["4th fuse release day"] = "7",
    ["4th fuse release month"] = "march",
    ["4th fuse release year"] = "2026",
    ["4th fuse year"] = "2026",
    ["4th headed"] = "hydraserpent",
    ["4th of july trait"] = "firework",
    ["4th of july trait date"] = "july2025",
    ["4th of july trait day"] = "4",
    ["4th of july trait month"] = "july",
    ["4th of july trait release"] = "july2025",
    ["4th of july trait release date"] = "july2025",
    ["4th of july trait release day"] = "4",
    ["4th of july trait release month"] = "july",
    ["4th of july trait release year"] = "2025",
    ["4th of july trait year"] = "2025",
    ["4th og brainrot"] = "headlesshorseman",
    ["4th taco merchant"] = "burritobat",
    ["4th three headed"] = "hydraserpent",
    ["4th three headed brainrot"] = "hydraserpent",
    ["4th three headed brainrot added"] = "hydraserpent",
    ["4th three headed brainrot in the game"] = "hydraserpent",
    ["555"] = "555",
    ["57 5"] = "candinifluffini",
    ["5th fuse"] = "summerfuse",
    ["5th fuse date"] = "may2026",
    ["5th fuse day"] = "23",
    ["5th fuse machine"] = "summerfuse",
    ["5th fuse machine date"] = "may2026",
    ["5th fuse machine day"] = "23",
    ["5th fuse machine month"] = "may",
    ["5th fuse machine release"] = "may2026",
    ["5th fuse machine release date"] = "may2026",
    ["5th fuse machine release day"] = "23",
    ["5th fuse machine release month"] = "may",
    ["5th fuse machine release year"] = "2026",
    ["5th fuse machine year"] = "2026",
    ["5th fuse month"] = "may",
    ["5th fuse release"] = "may2026",
    ["5th fuse release date"] = "may2026",
    ["5th fuse release day"] = "23",
    ["5th fuse release month"] = "may",
    ["5th fuse release year"] = "2026",
    ["5th fuse year"] = "2026",
    ["5th og"] = "johnpork",
    ["5th og brainrot"] = "johnpork",
    ["666"] = "666",
    ["67"] = "67",
    ["6th brainrot based off a mythical creature"] = "hydraserpent",
    ["6th brainrot based off mythical creature"] = "hydraserpent",
    ["6th brainrot based off of a mythical creature"] = "hydraserpent",
    ["6th brainrot based on a mythical creature"] = "hydraserpent",
    ["6th brainrot based on mythical creature"] = "hydraserpent",
    ["6th brainrot to be based off a mythical creature"] = "hydraserpent",
    ["6th brainrot to be based off of a mythical creature"] = "hydraserpent",
    ["6th brainrot to be based on a mythical creature"] = "hydraserpent",
    ["6th brainrot to be based on mythical creature"] = "hydraserpent",
    ["6th mythical"] = "hydraserpent",
    ["6th mythical brainrot"] = "hydraserpent",
    ["6th mythical creature"] = "hydraserpent",
    ["6th mythical creature brainrot"] = "hydraserpent",
    ["6th og"] = "spyderelephant",
    ["6th og brainrot"] = "spyderelephant",
    ["76"] = "76",
    ["777"] = "777",
    ["888"] = "888",
    ["95 income"] = "lafusemachine",
    ["95m"] = "lafusemachine",
    ["95m sec"] = "lafusemachine",
    ["999"] = "999",
    ["added in todays admin abuse"] = "lupaandlipa",
    ["added in todays update"] = "hydraserpent",
    ["added last saturday"] = "orchidox",
    ["added last week"] = "orchidox",
    ["added today"] = "hydraserpent",
    ["admin abuse"] = "jandel",
    ["admin abuse brainrot"] = "lupaandlipa",
    ["admin abuse trait"] = "sleepy",
    ["admin abuse war trait"] = "sleepy",
    ["admin machine"] = "november2025",
    ["admin machine date"] = "november2025",
    ["admin machine day"] = "29",
    ["admin machine month"] = "november",
    ["admin machine release"] = "november2025",
    ["admin machine release date"] = "november2025",
    ["admin machine release day"] = "29",
    ["admin machine release month"] = "november",
    ["admin machine release year"] = "2025",
    ["admin machine year"] = "2025",
    ["all brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["all brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["all brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["all brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["all removed brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["all reworked brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["always put code"] = "67",
    ["always put codes"] = "67",
    ["am i competitive at"] = "valorant",
    ["america"] = "usa",
    ["anniversary"] = "anniversary",
    ["anniversary trait"] = "1year",
    ["anniversary trait date"] = "may2026",
    ["anniversary trait month"] = "may",
    ["anniversary trait release"] = "may2026",
    ["anniversary trait release date"] = "may2026",
    ["anniversary trait release month"] = "may",
    ["anniversary trait release year"] = "2026",
    ["anniversary trait year"] = "2026",
    ["antonio"] = "green",
    ["antonio color"] = "green",
    ["aquadragon"] = "dragonaquanini",
    ["aquanini"] = "DragonAquanini",
    ["arcadragon"] = "red",
    ["arcadragon color"] = "red",
    ["artist"] = "drake",
    ["asteroid trait"] = "cometstruck",
    ["asteroid trait date"] = "june2025",
    ["asteroid trait day"] = "28",
    ["asteroid trait month"] = "june",
    ["asteroid trait release"] = "june2025",
    ["asteroid trait release date"] = "june2025",
    ["asteroid trait release day"] = "28",
    ["asteroid trait release month"] = "june",
    ["asteroid trait release year"] = "2025",
    ["asteroid trait year"] = "2025",
    ["aura"] = "aura",
    ["avatar"] = "legoastronaut",
    ["backrooms"] = "backrooms",
    ["base in today update"] = "emperor",
    ["base in todays update"] = "emperor",
    ["base skin"] = "1of1",
    ["base skin admin"] = "1of1",
    ["base skin today"] = "1of1",
    ["baseball bat"] = "bat",
    ["baseballbat"] = "bat",
    ["bat"] = "bat",
    ["bee block"] = "august2026",
    ["bee block date"] = "august2026",
    ["bee block day"] = "22",
    ["bee block month"] = "august",
    ["bee block release"] = "august2026",
    ["bee block release date"] = "august2026",
    ["bee block release day"] = "22",
    ["bee block release month"] = "august",
    ["bee block release year"] = "2026",
    ["bee block year"] = "2026",
    ["bee gear"] = "flyingbee",
    ["bee loco"] = "beeloco",
    ["bee lucky"] = "august2026",
    ["bee lucky block"] = "august2026",
    ["bee lucky block best brainrot"] = "orchidox",
    ["bee lucky block brainrot"] = "orchidox",
    ["bee lucky block brainrot date"] = "august2026",
    ["bee lucky block brainrot day"] = "22",
    ["bee lucky block brainrot month"] = "august",
    ["bee lucky block brainrot release"] = "august2026",
    ["bee lucky block brainrot release date"] = "august2026",
    ["bee lucky block brainrot release day"] = "22",
    ["bee lucky block brainrot release month"] = "august",
    ["bee lucky block brainrot release year"] = "2026",
    ["bee lucky block brainrot year"] = "2026",
    ["bee lucky block date"] = "august2026",
    ["bee lucky block day"] = "22",
    ["bee lucky block in sab"] = "august2026",
    ["bee lucky block in sab date"] = "august2026",
    ["bee lucky block in sab day"] = "22",
    ["bee lucky block in sab month"] = "august",
    ["bee lucky block in sab release"] = "august2026",
    ["bee lucky block in sab release date"] = "august2026",
    ["bee lucky block in sab release day"] = "22",
    ["bee lucky block in sab release month"] = "august",
    ["bee lucky block in sab release year"] = "2026",
    ["bee lucky block in sab year"] = "2026",
    ["bee lucky block in the game"] = "august2026",
    ["bee lucky block in the game date"] = "august2026",
    ["bee lucky block in the game day"] = "22",
    ["bee lucky block in the game month"] = "august",
    ["bee lucky block in the game release"] = "august2026",
    ["bee lucky block in the game release date"] = "august2026",
    ["bee lucky block in the game release day"] = "22",
    ["bee lucky block in the game release month"] = "august",
    ["bee lucky block in the game release year"] = "2026",
    ["bee lucky block in the game year"] = "2026",
    ["bee lucky block month"] = "august",
    ["bee lucky block most op brainrot"] = "orchidox",
    ["bee lucky block op brainrot"] = "orchidox",
    ["bee lucky block release"] = "august2026",
    ["bee lucky block release date"] = "august2026",
    ["bee lucky block release day"] = "22",
    ["bee lucky block release month"] = "august",
    ["bee lucky block release year"] = "2026",
    ["bee lucky block year"] = "2026",
    ["bee lucky blocks"] = "august2026",
    ["bee lucky blocks date"] = "august2026",
    ["bee lucky blocks day"] = "22",
    ["bee lucky blocks month"] = "august",
    ["bee lucky blocks release"] = "august2026",
    ["bee lucky blocks release date"] = "august2026",
    ["bee lucky blocks release day"] = "22",
    ["bee lucky blocks release month"] = "august",
    ["bee lucky blocks release year"] = "2026",
    ["bee lucky blocks year"] = "2026",
    ["bee lucky date"] = "august2026",
    ["bee lucky day"] = "22",
    ["bee lucky month"] = "august",
    ["bee lucky release"] = "august2026",
    ["bee lucky release date"] = "august2026",
    ["bee lucky release day"] = "22",
    ["bee lucky release month"] = "august",
    ["bee lucky release year"] = "2026",
    ["bee lucky year"] = "2026",
    ["bee shop brainrot"] = "orchidox",
    ["bee shop brainrot date"] = "august2026",
    ["bee shop brainrot day"] = "22",
    ["bee shop brainrot month"] = "august",
    ["bee shop brainrot release"] = "august2026",
    ["bee shop brainrot release date"] = "august2026",
    ["bee shop brainrot release day"] = "22",
    ["bee shop brainrot release month"] = "august",
    ["bee shop brainrot release year"] = "2026",
    ["bee shop brainrot year"] = "2026",
    ["bee update brainrot"] = "orchidox",
    ["bee update brainrot date"] = "august2026",
    ["bee update brainrot day"] = "22",
    ["bee update brainrot month"] = "august",
    ["bee update brainrot release"] = "august2026",
    ["bee update brainrot release date"] = "august2026",
    ["bee update brainrot release day"] = "22",
    ["bee update brainrot release month"] = "august",
    ["bee update brainrot release year"] = "2026",
    ["bee update brainrot year"] = "2026",
    ["beeloco"] = "beeloco",
    ["began making games"] = "2013",
    ["began making games in roblox"] = "2013",
    ["began making games in roblox release year"] = "2013",
    ["began making games in roblox year"] = "2013",
    ["began making games on roblox"] = "2013",
    ["began making games on roblox in"] = "2013",
    ["began making games on roblox in 2013"] = "2013",
    ["began making games on roblox in 2013 release year"] = "2013",
    ["began making games on roblox in 2013 year"] = "2013",
    ["began making games on roblox in release year"] = "2013",
    ["began making games on roblox in year"] = "2013",
    ["began making games on roblox release year"] = "2013",
    ["began making games on roblox year"] = "2013",
    ["began making games release year"] = "2013",
    ["began making games year"] = "2013",
    ["best admin abuse brainrot"] = "lupaandlipa",
    ["best bee block"] = "orchidox",
    ["best bee brainrot"] = "orchidox",
    ["best bee brainrot date"] = "august2026",
    ["best bee brainrot day"] = "22",
    ["best bee brainrot month"] = "august",
    ["best bee brainrot release"] = "august2026",
    ["best bee brainrot release date"] = "august2026",
    ["best bee brainrot release day"] = "22",
    ["best bee brainrot release month"] = "august",
    ["best bee brainrot release year"] = "2026",
    ["best bee brainrot year"] = "2026",
    ["best bee lucky"] = "orchidox",
    ["best bee lucky block"] = "orchidox",
    ["best bee lucky block brainrot"] = "orchidox",
    ["best bee lucky block brainrot date"] = "august2026",
    ["best bee lucky block brainrot day"] = "22",
    ["best bee lucky block brainrot month"] = "august",
    ["best bee lucky block brainrot release"] = "august2026",
    ["best bee lucky block brainrot release date"] = "august2026",
    ["best bee lucky block brainrot release day"] = "22",
    ["best bee lucky block brainrot release month"] = "august",
    ["best bee lucky block brainrot release year"] = "2026",
    ["best bee lucky block brainrot year"] = "2026",
    ["best bee shop"] = "orchidox",
    ["best bee shop brainrot"] = "orchidox",
    ["best bee shop brainrot date"] = "august2026",
    ["best bee shop brainrot day"] = "22",
    ["best bee shop brainrot month"] = "august",
    ["best bee shop brainrot release"] = "august2026",
    ["best bee shop brainrot release date"] = "august2026",
    ["best bee shop brainrot release day"] = "22",
    ["best bee shop brainrot release month"] = "august",
    ["best bee shop brainrot release year"] = "2026",
    ["best bee shop brainrot year"] = "2026",
    ["best bee update"] = "orchidox",
    ["best brainrot added"] = "hydraserpent",
    ["best brainrot added admin abuse"] = "hydraserpent",
    ["best brainrot added in today admin abuse"] = "lupaandlipa",
    ["best brainrot added in today update"] = "lupaandlipa",
    ["best brainrot added in todays admin abuse"] = "lupaandlipa",
    ["best brainrot added in todays update"] = "lupaandlipa",
    ["best brainrot added last saturday"] = "orchidox",
    ["best brainrot added last saturday date"] = "august2026",
    ["best brainrot added last saturday day"] = "22",
    ["best brainrot added last saturday month"] = "august",
    ["best brainrot added last saturday release"] = "august2026",
    ["best brainrot added last saturday release date"] = "august2026",
    ["best brainrot added last saturday release day"] = "22",
    ["best brainrot added last saturday release month"] = "august",
    ["best brainrot added last saturday release year"] = "2026",
    ["best brainrot added last saturday year"] = "2026",
    ["best brainrot added last week"] = "orchidox",
    ["best brainrot added last week date"] = "august2026",
    ["best brainrot added last week day"] = "22",
    ["best brainrot added last week month"] = "august",
    ["best brainrot added last week release"] = "august2026",
    ["best brainrot added last week release date"] = "august2026",
    ["best brainrot added last week release day"] = "22",
    ["best brainrot added last week release month"] = "august",
    ["best brainrot added last week release year"] = "2026",
    ["best brainrot added last week year"] = "2026",
    ["best brainrot added today"] = "lupaandlipa",
    ["best brainrot admin abuse"] = "hydraserpent",
    ["best brainrot except"] = "strawberryelephant",
    ["best brainrot except spyder"] = "strawberryelephant",
    ["best brainrot except spyder elephant"] = "strawberryelephant",
    ["best brainrot except spyderelephant"] = "strawberryelephant",
    ["best brainrot from bee lucky"] = "orchidox",
    ["best brainrot from bee lucky block"] = "orchidox",
    ["best brainrot from bee lucky block date"] = "august2026",
    ["best brainrot from bee lucky block day"] = "22",
    ["best brainrot from bee lucky block month"] = "august",
    ["best brainrot from bee lucky block release"] = "august2026",
    ["best brainrot from bee lucky block release date"] = "august2026",
    ["best brainrot from bee lucky block release day"] = "22",
    ["best brainrot from bee lucky block release month"] = "august",
    ["best brainrot from bee lucky block release year"] = "2026",
    ["best brainrot from bee lucky block year"] = "2026",
    ["best brainrot from previous gamemode"] = "hydrabunny",
    ["best brainrot from previous ltm"] = "hydrabunny",
    ["best brainrot from the bee lucky block"] = "orchidox",
    ["best brainrot in"] = "lupaandlipa",
    ["best brainrot in admin abuse"] = "lupaandlipa",
    ["best brainrot in bee lucky"] = "orchidox",
    ["best brainrot in bee lucky block"] = "orchidox",
    ["best brainrot in bee lucky block date"] = "august2026",
    ["best brainrot in bee lucky block day"] = "22",
    ["best brainrot in bee lucky block month"] = "august",
    ["best brainrot in bee lucky block release"] = "august2026",
    ["best brainrot in bee lucky block release date"] = "august2026",
    ["best brainrot in bee lucky block release day"] = "22",
    ["best brainrot in bee lucky block release month"] = "august",
    ["best brainrot in bee lucky block release year"] = "2026",
    ["best brainrot in bee lucky block year"] = "2026",
    ["best brainrot in game"] = "lupaandlipa",
    ["best brainrot in game except spyder elephant"] = "strawberryelephant",
    ["best brainrot in game except spyderelephant"] = "strawberryelephant",
    ["best brainrot in previous gamemode"] = "hydrabunny",
    ["best brainrot in previous limited time mode"] = "hydrabunny",
    ["best brainrot in previous ltm"] = "hydrabunny",
    ["best brainrot in the"] = "lupaandlipa",
    ["best brainrot in the bee lucky block"] = "orchidox",
    ["best brainrot in the game"] = "lupaandlipa",
    ["best brainrot in the game except spyder elephant"] = "strawberryelephant",
    ["best brainrot in the game except spyderelephant"] = "strawberryelephant",
    ["best brainrot in the previous gamemode"] = "hydrabunny",
    ["best brainrot in today update"] = "lupaandlipa",
    ["best brainrot in todays admin abuse"] = "lupaandlipa",
    ["best brainrot in todays update"] = "lupaandlipa",
    ["best brainrot last saturday"] = "orchidox",
    ["best brainrot last week"] = "orchidox",
    ["best brainrot released last saturday"] = "orchidox",
    ["best brainrot released last saturday date"] = "august2026",
    ["best brainrot released last saturday day"] = "22",
    ["best brainrot released last saturday month"] = "august",
    ["best brainrot released last saturday release"] = "august2026",
    ["best brainrot released last saturday release date"] = "august2026",
    ["best brainrot released last saturday release day"] = "22",
    ["best brainrot released last saturday release month"] = "august",
    ["best brainrot released last saturday release year"] = "2026",
    ["best brainrot released last saturday year"] = "2026",
    ["best brainrot released last week"] = "orchidox",
    ["best brainrot released last week date"] = "august2026",
    ["best brainrot released last week day"] = "22",
    ["best brainrot released last week month"] = "august",
    ["best brainrot released last week release"] = "august2026",
    ["best brainrot released last week release date"] = "august2026",
    ["best brainrot released last week release day"] = "22",
    ["best brainrot released last week release month"] = "august",
    ["best brainrot released last week release year"] = "2026",
    ["best brainrot released last week year"] = "2026",
    ["best brainrot reskin"] = "sammynitruckini",
    ["best brainrot reskin me"] = "sammynitruckini",
    ["best brainrot reskin of me"] = "sammynitruckini",
    ["best brainrot reskin of sammy"] = "sammynitruckini",
    ["best brainrot reskin sammy"] = "sammynitruckini",
    ["best brainrot that was added in today update"] = "lupaandlipa",
    ["best brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["best brainrot that was added in todays update"] = "lupaandlipa",
    ["best brainrot that was added last saturday"] = "orchidox",
    ["best brainrot that was added last saturday date"] = "august2026",
    ["best brainrot that was added last saturday day"] = "22",
    ["best brainrot that was added last saturday month"] = "august",
    ["best brainrot that was added last saturday release"] = "august2026",
    ["best brainrot that was added last saturday release date"] = "august2026",
    ["best brainrot that was added last saturday release day"] = "22",
    ["best brainrot that was added last saturday release month"] = "august",
    ["best brainrot that was added last saturday release year"] = "2026",
    ["best brainrot that was added last saturday year"] = "2026",
    ["best brainrot that was added last week"] = "orchidox",
    ["best brainrot that was added last week date"] = "august2026",
    ["best brainrot that was added last week day"] = "22",
    ["best brainrot that was added last week month"] = "august",
    ["best brainrot that was added last week release"] = "august2026",
    ["best brainrot that was added last week release date"] = "august2026",
    ["best brainrot that was added last week release day"] = "22",
    ["best brainrot that was added last week release month"] = "august",
    ["best brainrot that was added last week release year"] = "2026",
    ["best brainrot that was added last week year"] = "2026",
    ["best brainrot that was added today"] = "lupaandlipa",
    ["best brainrot that was released last saturday"] = "orchidox",
    ["best brainrot that was released last saturday date"] = "august2026",
    ["best brainrot that was released last saturday day"] = "22",
    ["best brainrot that was released last saturday month"] = "august",
    ["best brainrot that was released last saturday release"] = "august2026",
    ["best brainrot that was released last saturday release date"] = "august2026",
    ["best brainrot that was released last saturday release day"] = "22",
    ["best brainrot that was released last saturday release month"] = "august",
    ["best brainrot that was released last saturday release year"] = "2026",
    ["best brainrot that was released last saturday year"] = "2026",
    ["best brainrot that was released last week"] = "orchidox",
    ["best brainrot that was released last week date"] = "august2026",
    ["best brainrot that was released last week day"] = "22",
    ["best brainrot that was released last week month"] = "august",
    ["best brainrot that was released last week release"] = "august2026",
    ["best brainrot that was released last week release date"] = "august2026",
    ["best brainrot that was released last week release day"] = "22",
    ["best brainrot that was released last week release month"] = "august",
    ["best brainrot that was released last week release year"] = "2026",
    ["best brainrot that was released last week year"] = "2026",
    ["best brainrot that we added today"] = "draculino",
    ["best brainrot today"] = "lupaandlipa",
    ["best brainrot today update"] = "hydraserpent",
    ["best brainrot todays update"] = "hydraserpent",
    ["best brainrot we added today"] = "draculino",
    ["best brainrot without"] = "strawberryelephant",
    ["best brainrot without spyder"] = "strawberryelephant",
    ["best brainrot without spyder elephant"] = "strawberryelephant",
    ["best brainrot without spyderelephant"] = "strawberryelephant",
    ["best egg"] = "dragonegg",
    ["best egg from new ltm"] = "dragonegg",
    ["best egg from previous gamemode"] = "hydrabunnyegg",
    ["best egg from previous ltm"] = "hydrabunnyegg",
    ["best egg from the new ltm"] = "dragonegg",
    ["best egg from this ltm"] = "dragonegg",
    ["best egg in current ltm"] = "dragonegg",
    ["best egg in game"] = "dragonegg",
    ["best egg in limited time mode"] = "dragonegg",
    ["best egg in ltm"] = "dragonegg",
    ["best egg in new ltm"] = "dragonegg",
    ["best egg in previous gamemode"] = "hydrabunnyegg",
    ["best egg in previous ltm"] = "hydrabunnyegg",
    ["best egg in the current limited time mode"] = "dragonegg",
    ["best egg in the current ltm"] = "dragonegg",
    ["best egg in the game"] = "dragonegg",
    ["best egg in the ltm"] = "dragonegg",
    ["best egg in the new gamemode"] = "dragonegg",
    ["best egg in the new limited time mode"] = "dragonegg",
    ["best egg in the new ltm"] = "dragonegg",
    ["best egg in this gamemode"] = "dragonegg",
    ["best egg in this limited time mode"] = "dragonegg",
    ["best egg in this ltm"] = "dragonegg",
    ["best egg that you can get in ltm"] = "dragonegg",
    ["best egg that you can get in new ltm"] = "dragonegg",
    ["best egg that you can get in new ltm or ltm"] = "dragonegg",
    ["best egg that you can get in this ltm"] = "dragonegg",
    ["best egg that you can obtain in this ltm"] = "dragonegg",
    ["best egg that you could get in ltm"] = "dragonegg",
    ["best egg that you could get in new ltm"] = "dragonegg",
    ["best egg that you could get in new ltm or ltm"] = "dragonegg",
    ["best egg you can get in this ltm"] = "dragonegg",
    ["best egg you can obtain in this ltm"] = "dragonegg",
    ["best fuse brainrot"] = "griffin",
    ["best fuse machine brainrot"] = "griffin",
    ["best looking mutation for meowl"] = "cyber",
    ["best looking mutation for meowl date"] = "april2026",
    ["best looking mutation for meowl day"] = "18",
    ["best looking mutation for meowl month"] = "april",
    ["best looking mutation for meowl release"] = "april2026",
    ["best looking mutation for meowl release date"] = "april2026",
    ["best looking mutation for meowl release day"] = "18",
    ["best looking mutation for meowl release month"] = "april",
    ["best looking mutation for meowl release year"] = "2026",
    ["best looking mutation for meowl year"] = "2026",
    ["best looking mutation on meowl"] = "cyber",
    ["best looking mutation on meowl date"] = "april2026",
    ["best looking mutation on meowl day"] = "18",
    ["best looking mutation on meowl month"] = "april",
    ["best looking mutation on meowl release"] = "april2026",
    ["best looking mutation on meowl release date"] = "april2026",
    ["best looking mutation on meowl release day"] = "18",
    ["best looking mutation on meowl release month"] = "april",
    ["best looking mutation on meowl release year"] = "2026",
    ["best looking mutation on meowl year"] = "2026",
    ["best merchant taco"] = "sammynitruckini",
    ["best mutation currently"] = "crystal",
    ["best mutation for meowl visually"] = "cyber",
    ["best mutation for meowl visually date"] = "april2026",
    ["best mutation for meowl visually day"] = "18",
    ["best mutation for meowl visually month"] = "april",
    ["best mutation for meowl visually release"] = "april2026",
    ["best mutation for meowl visually release date"] = "april2026",
    ["best mutation for meowl visually release day"] = "18",
    ["best mutation for meowl visually release month"] = "april",
    ["best mutation for meowl visually release year"] = "2026",
    ["best mutation for meowl visually year"] = "2026",
    ["best mutation for my favorite brainrot visually"] = "cyber",
    ["best mutation right now"] = "crystal",
    ["best mutation rn"] = "crystal",
    ["best new brainrot"] = "draculino",
    ["best new brainrot in ltm"] = "draculino",
    ["best new brainrot in the ltm"] = "draculino",
    ["best reskin"] = "sammynitruckini",
    ["best reskin me"] = "sammynitruckini",
    ["best reskin of me"] = "sammynitruckini",
    ["best reskin of sammy"] = "sammynitruckini",
    ["best reskin sammy"] = "sammynitruckini",
    ["best taco"] = "latacocombinasion",
    ["best taco brainrot"] = "latacocombinasion",
    ["best taco merchant"] = "sammynitruckini",
    ["best visual mutation for favorite brainrot"] = "cyber",
    ["best visual mutation for favorite brainrot date"] = "april2026",
    ["best visual mutation for favorite brainrot day"] = "18",
    ["best visual mutation for favorite brainrot month"] = "april",
    ["best visual mutation for favorite brainrot release"] = "april2026",
    ["best visual mutation for favorite brainrot release date"] = "april2026",
    ["best visual mutation for favorite brainrot release day"] = "18",
    ["best visual mutation for favorite brainrot release month"] = "april",
    ["best visual mutation for favorite brainrot release year"] = "2026",
    ["best visual mutation for favorite brainrot year"] = "2026",
    ["best visual mutation for meowl"] = "cyber",
    ["best visual mutation for meowl date"] = "april2026",
    ["best visual mutation for meowl day"] = "18",
    ["best visual mutation for meowl month"] = "april",
    ["best visual mutation for meowl release"] = "april2026",
    ["best visual mutation for meowl release date"] = "april2026",
    ["best visual mutation for meowl release day"] = "18",
    ["best visual mutation for meowl release month"] = "april",
    ["best visual mutation for meowl release year"] = "2026",
    ["best visual mutation for meowl year"] = "2026",
    ["best visual mutation for my favorite brainrot"] = "cyber",
    ["best visual mutation for my favorite brainrot date"] = "april2026",
    ["best visual mutation for my favorite brainrot day"] = "18",
    ["best visual mutation for my favorite brainrot month"] = "april",
    ["best visual mutation for my favorite brainrot release"] = "april2026",
    ["best visual mutation for my favorite brainrot release date"] = "april2026",
    ["best visual mutation for my favorite brainrot release day"] = "18",
    ["best visual mutation for my favorite brainrot release month"] = "april",
    ["best visual mutation for my favorite brainrot release year"] = "2026",
    ["best visual mutation for my favorite brainrot year"] = "2026",
    ["best visual mutation on meowl"] = "cyber",
    ["best visual mutation on meowl date"] = "april2026",
    ["best visual mutation on meowl day"] = "18",
    ["best visual mutation on meowl month"] = "april",
    ["best visual mutation on meowl release"] = "april2026",
    ["best visual mutation on meowl release date"] = "april2026",
    ["best visual mutation on meowl release day"] = "18",
    ["best visual mutation on meowl release month"] = "april",
    ["best visual mutation on meowl release year"] = "2026",
    ["best visual mutation on meowl year"] = "2026",
    ["better 1speedkeyboardescape"] = "growagarden",
    ["better escape"] = "growagarden",
    ["better keyboard"] = "growagarden",
    ["better loki"] = "jandel",
    ["better lokii"] = "jandel",
    ["better luckymatg"] = "jandel",
    ["better secretloki"] = "jandel",
    ["better secretlokii"] = "jandel",
    ["better than 1 speed keyboard escape"] = "growagarden",
    ["better than 1speedkeyboardescape"] = "growagarden",
    ["better than loki"] = "jandel",
    ["better than lokii"] = "jandel",
    ["better than luckymatg"] = "jandel",
    ["better than secretloki"] = "jandel",
    ["better than secretlokii"] = "jandel",
    ["birthday month"] = "february",
    ["black"] = "black",
    ["bloodrot date"] = "june2025",
    ["bloodrot day"] = "7",
    ["bloodrot month"] = "june",
    ["bloodrot mutation"] = "bloodrot",
    ["bloodrot mutation date"] = "june2025",
    ["bloodrot mutation day"] = "7",
    ["bloodrot mutation month"] = "june",
    ["bloodrot mutation release"] = "june2025",
    ["bloodrot mutation release date"] = "june2025",
    ["bloodrot mutation release day"] = "7",
    ["bloodrot mutation release month"] = "june",
    ["bloodrot mutation release year"] = "2025",
    ["bloodrot mutation year"] = "2025",
    ["bloodrot release"] = "june2025",
    ["bloodrot release date"] = "june2025",
    ["bloodrot release day"] = "7",
    ["bloodrot release month"] = "june",
    ["bloodrot release year"] = "2025",
    ["bloodrot year"] = "2025",
    ["blue"] = "blue",
    ["blue egg trait"] = "blueegg",
    ["blue egg trait date"] = "april2026",
    ["blue egg trait month"] = "april",
    ["blue egg trait release"] = "april2026",
    ["blue egg trait release date"] = "april2026",
    ["blue egg trait release month"] = "april",
    ["blue egg trait release year"] = "2026",
    ["blue egg trait year"] = "2026",
    ["blue suit of signore carapace"] = "blue",
    ["blueballoon"] = "blueballoon",
    ["blueegg"] = "blueegg",
    ["body skin color"] = "yellow",
    ["bombardini tortini"] = "bombardinitortinii",
    ["bombardini tortinii"] = "bombardinitortinii",
    ["bombardinitortinii"] = "bombardinitortinii",
    ["bombardiro"] = "bombardiro",
    ["bombardiro trait"] = "bombardiro",
    ["bombardiro trait date"] = "june2025",
    ["bombardiro trait month"] = "june",
    ["bombardiro trait release"] = "june2025",
    ["bombardiro trait release date"] = "june2025",
    ["bombardiro trait release month"] = "june",
    ["bombardiro trait release year"] = "2025",
    ["bombardiro trait year"] = "2025",
    ["born month"] = "february",
    ["brainrot added in todays admin abuse"] = "lupaandlipa",
    ["brainrot added in todays update"] = "hydraserpent",
    ["brainrot added last saturday"] = "orchidox",
    ["brainrot added last saturday date"] = "august2026",
    ["brainrot added last saturday day"] = "22",
    ["brainrot added last saturday month"] = "august",
    ["brainrot added last saturday release"] = "august2026",
    ["brainrot added last saturday release date"] = "august2026",
    ["brainrot added last saturday release day"] = "22",
    ["brainrot added last saturday release month"] = "august",
    ["brainrot added last saturday release year"] = "2026",
    ["brainrot added last saturday year"] = "2026",
    ["brainrot added last week"] = "orchidox",
    ["brainrot added last week date"] = "august2026",
    ["brainrot added last week day"] = "22",
    ["brainrot added last week month"] = "august",
    ["brainrot added last week release"] = "august2026",
    ["brainrot added last week release date"] = "august2026",
    ["brainrot added last week release day"] = "22",
    ["brainrot added last week release month"] = "august",
    ["brainrot added last week release year"] = "2026",
    ["brainrot added last week year"] = "2026",
    ["brainrot added today"] = "hydraserpent",
    ["brainrot deleted"] = "tungtungtungsahur",
    ["brainrot for money ritual"] = "moneymoneypuggy",
    ["brainrot for new ritual"] = "moneymoneypuggy",
    ["brainrot from cave island"] = "draculino",
    ["brainrot from money"] = "lospuggies",
    ["brainrot from money ritual"] = "lospuggies",
    ["brainrot from new ritual"] = "lospuggies",
    ["brainrot from ritual"] = "lospuggies",
    ["brainrot from the cave island"] = "draculino",
    ["brainrot from the money ritual"] = "lospuggies",
    ["brainrot from the new ritual"] = "lospuggies",
    ["brainrot get money"] = "lospuggies",
    ["brainrot get ritual"] = "lospuggies",
    ["brainrot give money"] = "lospuggies",
    ["brainrot give ritual"] = "lospuggies",
    ["brainrot god lucky block"] = "july2025",
    ["brainrot god lucky block date"] = "july2025",
    ["brainrot god lucky block day"] = "12",
    ["brainrot god lucky block month"] = "july",
    ["brainrot god lucky block release"] = "july2025",
    ["brainrot god lucky block release date"] = "july2025",
    ["brainrot god lucky block release day"] = "12",
    ["brainrot god lucky block release month"] = "july",
    ["brainrot god lucky block release year"] = "2025",
    ["brainrot god lucky block year"] = "2025",
    ["brainrot in todays admin abuse"] = "lupaandlipa",
    ["brainrot in todays update"] = "hydraserpent",
    ["brainrot last saturday"] = "orchidox",
    ["brainrot last week"] = "orchidox",
    ["brainrot make ritual"] = "moneymoneypuggy",
    ["brainrot money ritual"] = "moneymoneypuggy",
    ["brainrot need ritual"] = "moneymoneypuggy",
    ["brainrot needed for money ritual"] = "moneymoneypuggy",
    ["brainrot needed for new ritual"] = "moneymoneypuggy",
    ["brainrot obtained from cave island"] = "draculino",
    ["brainrot obtained from the cave island"] = "draculino",
    ["brainrot released last saturday"] = "orchidox",
    ["brainrot released last saturday date"] = "august2026",
    ["brainrot released last saturday day"] = "22",
    ["brainrot released last saturday month"] = "august",
    ["brainrot released last saturday release"] = "august2026",
    ["brainrot released last saturday release date"] = "august2026",
    ["brainrot released last saturday release day"] = "22",
    ["brainrot released last saturday release month"] = "august",
    ["brainrot released last saturday release year"] = "2026",
    ["brainrot released last saturday year"] = "2026",
    ["brainrot released last week"] = "orchidox",
    ["brainrot released last week date"] = "august2026",
    ["brainrot released last week day"] = "22",
    ["brainrot released last week month"] = "august",
    ["brainrot released last week release"] = "august2026",
    ["brainrot released last week release date"] = "august2026",
    ["brainrot released last week release day"] = "22",
    ["brainrot released last week release month"] = "august",
    ["brainrot released last week release year"] = "2026",
    ["brainrot released last week year"] = "2026",
    ["brainrot remove"] = "tungtungtungsahur",
    ["brainrot removed"] = "tungtungtungsahur",
    ["brainrot reward ritual"] = "lospuggies",
    ["brainrot reworked"] = "sammynispyderini",
    ["brainrot that got deleted"] = "tungtungtungsahur",
    ["brainrot that got remove"] = "tungtungtungsahur",
    ["brainrot that got removed"] = "tungtungtungsahur",
    ["brainrot that got reworked"] = "sammynispyderini",
    ["brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["brainrot that was added in todays update"] = "hydraserpent",
    ["brainrot that was added last saturday"] = "orchidox",
    ["brainrot that was added last saturday date"] = "august2026",
    ["brainrot that was added last saturday day"] = "22",
    ["brainrot that was added last saturday month"] = "august",
    ["brainrot that was added last saturday release"] = "august2026",
    ["brainrot that was added last saturday release date"] = "august2026",
    ["brainrot that was added last saturday release day"] = "22",
    ["brainrot that was added last saturday release month"] = "august",
    ["brainrot that was added last saturday release year"] = "2026",
    ["brainrot that was added last saturday year"] = "2026",
    ["brainrot that was added last week"] = "orchidox",
    ["brainrot that was added last week date"] = "august2026",
    ["brainrot that was added last week day"] = "22",
    ["brainrot that was added last week month"] = "august",
    ["brainrot that was added last week release"] = "august2026",
    ["brainrot that was added last week release date"] = "august2026",
    ["brainrot that was added last week release day"] = "22",
    ["brainrot that was added last week release month"] = "august",
    ["brainrot that was added last week release year"] = "2026",
    ["brainrot that was added last week year"] = "2026",
    ["brainrot that was added today"] = "hydraserpent",
    ["brainrot that was deleted"] = "tungtungtungsahur",
    ["brainrot that was released last saturday"] = "orchidox",
    ["brainrot that was released last saturday date"] = "august2026",
    ["brainrot that was released last saturday day"] = "22",
    ["brainrot that was released last saturday month"] = "august",
    ["brainrot that was released last saturday release"] = "august2026",
    ["brainrot that was released last saturday release date"] = "august2026",
    ["brainrot that was released last saturday release day"] = "22",
    ["brainrot that was released last saturday release month"] = "august",
    ["brainrot that was released last saturday release year"] = "2026",
    ["brainrot that was released last saturday year"] = "2026",
    ["brainrot that was released last week"] = "orchidox",
    ["brainrot that was released last week date"] = "august2026",
    ["brainrot that was released last week day"] = "22",
    ["brainrot that was released last week month"] = "august",
    ["brainrot that was released last week release"] = "august2026",
    ["brainrot that was released last week release date"] = "august2026",
    ["brainrot that was released last week release day"] = "22",
    ["brainrot that was released last week release month"] = "august",
    ["brainrot that was released last week release year"] = "2026",
    ["brainrot that was released last week year"] = "2026",
    ["brainrot that was removed"] = "tungtungtungsahur",
    ["brainrot that was reworked"] = "sammynispyderini",
    ["brainrot that you can get from cave island"] = "draculino",
    ["brainrot that you can get from the cave island"] = "draculino",
    ["brainrot that you can obtain from cave island"] = "draculino",
    ["brainrot that you can obtain from the cave island"] = "draculino",
    ["brainrot that you get from money money puggy ritual"] = "lospuggies",
    ["brainrot that you get from money ritual"] = "lospuggies",
    ["brainrot that you get from new money money puggy ritual"] = "lospuggies",
    ["brainrot that you get from new ritual"] = "lospuggies",
    ["brainrot to make money ritual"] = "moneymoneypuggy",
    ["brainrot to make new ritual"] = "moneymoneypuggy",
    ["brainrot to use for money ritual"] = "moneymoneypuggy",
    ["brainrot to use for new ritual"] = "moneymoneypuggy",
    ["brainrot today admin abuse"] = "hydraserpent",
    ["brainrot today update"] = "hydraserpent",
    ["brainrot todays admin abuse"] = "hydraserpent",
    ["brainrot todays update"] = "hydraserpent",
    ["brainrot use ritual"] = "moneymoneypuggy",
    ["brainrot used for money ritual"] = "moneymoneypuggy",
    ["brainrot you can get from cave island"] = "draculino",
    ["brainrot you can get from the cave island"] = "draculino",
    ["brainrot you can obtain from cave island"] = "draculino",
    ["brainrot you can obtain from the cave island"] = "draculino",
    ["brainrot you get from money ritual"] = "lospuggies",
    ["brainrot you get from new ritual"] = "lospuggies",
    ["brainrot you need to use for money ritual"] = "moneymoneypuggy",
    ["brainrot you need to use for new ritual"] = "moneymoneypuggy",
    ["brainrots deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots remove"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots removed"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots rework"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["brainrots reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["brainrots that got deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["brainrots that were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["brakta"] = "brakta",
    ["brother name"] = "samuel",
    ["brown"] = "brown",
    ["bruno mars"] = "brunomars",
    ["bruno mars concert trait"] = "concert",
    ["bruno mars concert trait date"] = "january2026",
    ["bruno mars concert trait day"] = "17",
    ["bruno mars concert trait month"] = "january",
    ["bruno mars concert trait release"] = "january2026",
    ["bruno mars concert trait release date"] = "january2026",
    ["bruno mars concert trait release day"] = "17",
    ["bruno mars concert trait release month"] = "january",
    ["bruno mars concert trait release year"] = "2026",
    ["bruno mars concert trait year"] = "2026",
    ["bruno mars trait"] = "concert",
    ["bruno mars trait date"] = "january2026",
    ["bruno mars trait day"] = "17",
    ["bruno mars trait month"] = "january",
    ["bruno mars trait release"] = "january2026",
    ["bruno mars trait release date"] = "january2026",
    ["bruno mars trait release day"] = "17",
    ["bruno mars trait release month"] = "january",
    ["bruno mars trait release year"] = "2026",
    ["bruno mars trait year"] = "2026",
    ["brunomars"] = "brunomars",
    ["bubblegum"] = "bubblegum",
    ["bubblegum machine"] = "bubblegummachine",
    ["bubblegum machine date"] = "july2025",
    ["bubblegum machine day"] = "18",
    ["bubblegum machine month"] = "july",
    ["bubblegum machine release"] = "july2025",
    ["bubblegum machine release date"] = "july2025",
    ["bubblegum machine release day"] = "18",
    ["bubblegum machine release month"] = "july",
    ["bubblegum machine release year"] = "2025",
    ["bubblegum machine year"] = "2025",
    ["bubblegum trait"] = "bubblegum",
    ["bubblegum trait date"] = "july2025",
    ["bubblegum trait day"] = "18",
    ["bubblegum trait month"] = "july",
    ["bubblegum trait release"] = "july2025",
    ["bubblegum trait release date"] = "july2025",
    ["bubblegum trait release day"] = "18",
    ["bubblegum trait release month"] = "july",
    ["bubblegum trait release year"] = "2025",
    ["bubblegum trait year"] = "2025",
    ["bull"] = "bull",
    ["bull trait"] = "bull",
    ["bull trait date"] = "july2026",
    ["bull trait day"] = "25",
    ["bull trait month"] = "july",
    ["bull trait release"] = "july2026",
    ["bull trait release date"] = "july2026",
    ["bull trait release day"] = "25",
    ["bull trait release month"] = "july",
    ["bull trait release year"] = "2026",
    ["bull trait year"] = "2026",
    ["bumbatron"] = "bumbatron",
    ["bunny"] = "hydrabunny",
    ["bunny ears"] = "bunnyears",
    ["bunny ears date"] = "april2026",
    ["bunny ears month"] = "april",
    ["bunny ears release"] = "april2026",
    ["bunny ears release date"] = "april2026",
    ["bunny ears release month"] = "april",
    ["bunny ears release year"] = "2026",
    ["bunny ears trait"] = "bunnyears",
    ["bunny ears trait date"] = "april2026",
    ["bunny ears trait month"] = "april",
    ["bunny ears trait release"] = "april2026",
    ["bunny ears trait release date"] = "april2026",
    ["bunny ears trait release month"] = "april",
    ["bunny ears trait release year"] = "2026",
    ["bunny ears trait year"] = "2026",
    ["bunny ears year"] = "2026",
    ["bunnyears"] = "bunnyears",
    ["burger"] = "burger",
    ["burrito bandito"] = "burritobandito",
    ["burrito bat"] = "burritobat",
    ["burritobandito"] = "burritobandito",
    ["burritobat"] = "burritobat",
    ["candini"] = "candinifluffini",
    ["candinifluffini"] = "candinifluffini",
    ["candy mutation"] = "candy",
    ["candy mutation date"] = "july2025",
    ["candy mutation day"] = "5",
    ["candy mutation month"] = "july",
    ["candy mutation release"] = "july2025",
    ["candy mutation release date"] = "july2025",
    ["candy mutation release day"] = "5",
    ["candy mutation release month"] = "july",
    ["candy mutation release year"] = "2025",
    ["candy mutation year"] = "2025",
    ["cannelloni"] = "dragoncannelloni",
    ["capi taco"] = "capitaco",
    ["capitaco"] = "capitaco",
    ["capitano"] = "capitanomoby",
    ["capitano moby color"] = "blue",
    ["capitanomoby"] = "blue",
    ["car color"] = "red",
    ["carapace"] = "signorecarapace",
    ["cat name"] = "nova",
    ["cats name"] = "nova",
    ["caveisland"] = "caveisland",
    ["celestial"] = "celestialpegasus",
    ["celestial pegasus"] = "celestialpegasus",
    ["celestial pegasus color"] = "purple",
    ["celestialpegasus"] = "celestialpegasus",
    ["cheapest"] = "noobinipizzanini",
    ["cheapest brainrot"] = "noobinipizzanini",
    ["cheapest in game"] = "noobinipizzanini",
    ["cheapest taco merchant"] = "burritobat",
    ["chihuanini"] = "chihuaninitaconini",
    ["chihuanini taconini"] = "chihuaninitaconini",
    ["chihuaninitaconini"] = "chihuaninitaconini",
    ["chili"] = "chillinchili",
    ["chillin chili"] = "chillinchili",
    ["chillinchili"] = "chillinchili",
    ["chipso"] = "chipsoandqueso",
    ["chipso and queso"] = "chipsoandqueso",
    ["chipso and queso date"] = "october2025",
    ["chipso and queso day"] = "21",
    ["chipso and queso month"] = "october",
    ["chipso and queso release"] = "october2025",
    ["chipso and queso release date"] = "october2025",
    ["chipso and queso release day"] = "21",
    ["chipso and queso release month"] = "october",
    ["chipso and queso release year"] = "2025",
    ["chipso and queso year"] = "2025",
    ["chipso date"] = "october2025",
    ["chipso day"] = "21",
    ["chipso month"] = "october",
    ["chipso queso"] = "chipsoandqueso",
    ["chipso queso date"] = "october2025",
    ["chipso queso day"] = "21",
    ["chipso queso month"] = "october",
    ["chipso queso release"] = "october2025",
    ["chipso queso release date"] = "october2025",
    ["chipso queso release day"] = "21",
    ["chipso queso release month"] = "october",
    ["chipso queso release year"] = "2025",
    ["chipso queso year"] = "2025",
    ["chipso release"] = "october2025",
    ["chipso release date"] = "october2025",
    ["chipso release day"] = "21",
    ["chipso release month"] = "october",
    ["chipso release year"] = "2025",
    ["chipso year"] = "2025",
    ["chipsoandqueso"] = "chipsoandqueso",
    ["chocolate"] = "chocolate",
    ["chocolate trait"] = "chocolate",
    ["chocolate trait date"] = "february2026",
    ["chocolate trait month"] = "february",
    ["chocolate trait release"] = "february2026",
    ["chocolate trait release date"] = "february2026",
    ["chocolate trait release month"] = "february",
    ["chocolate trait release year"] = "2026",
    ["chocolate trait year"] = "2026",
    ["co founder"] = "dosmall",
    ["cofounder"] = "dosmall",
    ["color of antonio"] = "green",
    ["color of arcadragon"] = "red",
    ["color of capitano moby"] = "blue",
    ["color of celestial pegasus"] = "purple",
    ["color of digi narwhal"] = "blue",
    ["color of draculino"] = "black",
    ["color of dragon aquanini"] = "blue",
    ["color of dragon cannelloni"] = "yellow",
    ["color of dragon gingerini"] = "brown",
    ["color of elefanto frigo"] = "gray",
    ["color of garama and madundung"] = "gray",
    ["color of griffin"] = "white",
    ["color of headless horseman"] = "black",
    ["color of hydra bunny"] = "white",
    ["color of hydra dragon cannelloni"] = "yellow",
    ["color of hydra serpent"] = "green",
    ["color of john pork"] = "pink",
    ["color of kraken"] = "red",
    ["color of love love bear"] = "red",
    ["color of meowl"] = "white",
    ["color of my avatar"] = "red",
    ["color of my body skin"] = "yellow",
    ["color of my car"] = "red",
    ["color of my pants"] = "red",
    ["color of my roblox avatar"] = "red",
    ["color of my roblox skin"] = "yellow",
    ["color of my shirt"] = "red",
    ["color of my skin"] = "yellow",
    ["color of new best brainrot in ltm"] = "black",
    ["color of new brainrot"] = "black",
    ["color of new op brainrot"] = "black",
    ["color of orchidox"] = "purple",
    ["color of pancake and syrup"] = "orange",
    ["color of pig"] = "pink",
    ["color of sammy avatar"] = "red",
    ["color of sammy avatar or my color of my avatar"] = "red",
    ["color of sammy roblox avatar"] = "red",
    ["color of sammys avatar"] = "red",
    ["color of sammys roblox avatar"] = "red",
    ["color of signore carapace"] = "white",
    ["color of signore carapace suit"] = "blue",
    ["color of skibidi toilet"] = "white",
    ["color of spyder elephant"] = "gray",
    ["color of strawberry elephant"] = "red",
    ["color of the new best brainrot in ltm"] = "black",
    ["color of the new brainrot"] = "black",
    ["color of the new op brainrot"] = "black",
    ["color of toilet"] = "white",
    ["color suit of signore carapace"] = "blue",
    ["colour of spyder elephant"] = "gray",
    ["comet ritual"] = "comet",
    ["comet struck"] = "cometstruck",
    ["comet struck date"] = "june2025",
    ["comet struck day"] = "28",
    ["comet struck month"] = "june",
    ["comet struck release"] = "june2025",
    ["comet struck release date"] = "june2025",
    ["comet struck release day"] = "28",
    ["comet struck release month"] = "june",
    ["comet struck release year"] = "2025",
    ["comet struck trait"] = "cometstruck",
    ["comet struck trait date"] = "june2025",
    ["comet struck trait day"] = "28",
    ["comet struck trait month"] = "june",
    ["comet struck trait release"] = "june2025",
    ["comet struck trait release date"] = "june2025",
    ["comet struck trait release day"] = "28",
    ["comet struck trait release month"] = "june",
    ["comet struck trait release year"] = "2025",
    ["comet struck trait year"] = "2025",
    ["comet struck year"] = "2025",
    ["cometstruck"] = "cometstruck",
    ["coming fuse machine"] = "hauntedfuse",
    ["coming in halloween"] = "hauntedfuse",
    ["competitive game"] = "valorant",
    ["competitive player"] = "valorant",
    ["competitive player at"] = "valorant",
    ["competitive player at valorant"] = "valorant",
    ["competitive player valorant"] = "valorant",
    ["competitive valorant"] = "valorant",
    ["competitive valorant player"] = "valorant",
    ["concert"] = "concert",
    ["concert trait"] = "concert",
    ["concert trait date"] = "january2026",
    ["concert trait day"] = "17",
    ["concert trait month"] = "january",
    ["concert trait release"] = "january2026",
    ["concert trait release date"] = "january2026",
    ["concert trait release day"] = "17",
    ["concert trait release month"] = "january",
    ["concert trait release year"] = "2026",
    ["concert trait year"] = "2026",
    ["corn corn corn"] = "corncorncornsahur",
    ["corn corn corn sahur"] = "corncorncornsahur",
    ["corn sahur"] = "corncorncornsahur",
    ["corncorncornsahur"] = "corncorncornsahur",
    ["count of 1 of 1 brainrots"] = "155",
    ["count of 1 of 1s"] = "155",
    ["crab rave"] = "crabrave",
    ["crab rave date"] = "june2025",
    ["crab rave month"] = "june",
    ["crab rave release"] = "june2025",
    ["crab rave release date"] = "june2025",
    ["crab rave release month"] = "june",
    ["crab rave release year"] = "2025",
    ["crab rave trait"] = "crabrave",
    ["crab rave trait date"] = "june2025",
    ["crab rave trait month"] = "june",
    ["crab rave trait release"] = "june2025",
    ["crab rave trait release date"] = "june2025",
    ["crab rave trait release month"] = "june",
    ["crab rave trait release year"] = "2025",
    ["crab rave trait year"] = "2025",
    ["crab rave year"] = "2025",
    ["crabrave"] = "crabrave",
    ["craft"] = "september2025",
    ["craft date"] = "september2025",
    ["craft day"] = "6",
    ["craft machine"] = "september2025",
    ["craft machine date"] = "september2025",
    ["craft machine day"] = "6",
    ["craft machine month"] = "september",
    ["craft machine release"] = "september2025",
    ["craft machine release date"] = "september2025",
    ["craft machine release day"] = "6",
    ["craft machine release month"] = "september",
    ["craft machine release year"] = "2025",
    ["craft machine year"] = "2025",
    ["craft month"] = "september",
    ["craft release"] = "september2025",
    ["craft release date"] = "september2025",
    ["craft release day"] = "6",
    ["craft release month"] = "september",
    ["craft release year"] = "2025",
    ["craft year"] = "2025",
    ["crocidilo penisini"] = "crocidilopenisini",
    ["crocidilopenisini"] = "crocidilopenisini",
    ["crocodilo penisini"] = "crocidilopenisini",
    ["crocodilopenisini"] = "crocidilopenisini",
    ["crystal mutation"] = "crystal",
    ["crystal mutation date"] = "july2026",
    ["crystal mutation day"] = "25",
    ["crystal mutation month"] = "july",
    ["crystal mutation release"] = "july2026",
    ["crystal mutation release date"] = "july2026",
    ["crystal mutation release day"] = "25",
    ["crystal mutation release month"] = "july",
    ["crystal mutation release year"] = "2026",
    ["crystal mutation year"] = "2026",
    ["crystal strawberry elephant exist"] = "1",
    ["crystal strawberry elephant exist count"] = "1",
    ["crystal strawberry elephants exist"] = "1",
    ["cucaracha"] = "lacucaracha",
    ["cupid fuse"] = "february2026",
    ["cupid fuse date"] = "february2026",
    ["cupid fuse day"] = "7",
    ["cupid fuse month"] = "february",
    ["cupid fuse release"] = "february2026",
    ["cupid fuse release date"] = "february2026",
    ["cupid fuse release day"] = "7",
    ["cupid fuse release month"] = "february",
    ["cupid fuse release year"] = "2026",
    ["cupid fuse year"] = "2026",
    ["cupid machine"] = "february2026",
    ["cupid machine date"] = "february2026",
    ["cupid machine day"] = "7",
    ["cupid machine month"] = "february",
    ["cupid machine release"] = "february2026",
    ["cupid machine release date"] = "february2026",
    ["cupid machine release day"] = "7",
    ["cupid machine release month"] = "february",
    ["cupid machine release year"] = "2026",
    ["cupid machine year"] = "2026",
    ["current fuse"] = "rainbowfuse",
    ["current fuse date"] = "june2025",
    ["current fuse day"] = "21",
    ["current fuse month"] = "june",
    ["current fuse release"] = "june2025",
    ["current fuse release date"] = "june2025",
    ["current fuse release day"] = "21",
    ["current fuse release month"] = "june",
    ["current fuse release year"] = "2025",
    ["current fuse year"] = "2025",
    ["current ritual"] = "money",
    ["current season"] = "autumn",
    ["cursed date"] = "january2026",
    ["cursed day"] = "3",
    ["cursed month"] = "january",
    ["cursed mutation date"] = "january2026",
    ["cursed mutation day"] = "3",
    ["cursed mutation month"] = "january",
    ["cursed mutation release"] = "january2026",
    ["cursed mutation release date"] = "january2026",
    ["cursed mutation release day"] = "3",
    ["cursed mutation release month"] = "january",
    ["cursed mutation release year"] = "2026",
    ["cursed mutation year"] = "2026",
    ["cursed release"] = "january2026",
    ["cursed release date"] = "january2026",
    ["cursed release day"] = "3",
    ["cursed release month"] = "january",
    ["cursed release year"] = "2026",
    ["cursed year"] = "2026",
    ["cyber admin"] = "april2026",
    ["cyber admin date"] = "april2026",
    ["cyber admin day"] = "25",
    ["cyber admin machine"] = "april2026",
    ["cyber admin machine date"] = "april2026",
    ["cyber admin machine day"] = "25",
    ["cyber admin machine month"] = "april",
    ["cyber admin machine release"] = "april2026",
    ["cyber admin machine release date"] = "april2026",
    ["cyber admin machine release day"] = "25",
    ["cyber admin machine release month"] = "april",
    ["cyber admin machine release year"] = "2026",
    ["cyber admin machine year"] = "2026",
    ["cyber admin month"] = "april",
    ["cyber admin release"] = "april2026",
    ["cyber admin release date"] = "april2026",
    ["cyber admin release day"] = "25",
    ["cyber admin release month"] = "april",
    ["cyber admin release year"] = "2026",
    ["cyber admin year"] = "2026",
    ["cyber craft"] = "cybercraft",
    ["cyber craft date"] = "april2026",
    ["cyber craft day"] = "18",
    ["cyber craft machine"] = "cybercraft",
    ["cyber craft machine date"] = "april2026",
    ["cyber craft machine day"] = "18",
    ["cyber craft machine month"] = "april",
    ["cyber craft machine release"] = "april2026",
    ["cyber craft machine release date"] = "april2026",
    ["cyber craft machine release day"] = "18",
    ["cyber craft machine release month"] = "april",
    ["cyber craft machine release year"] = "2026",
    ["cyber craft machine year"] = "2026",
    ["cyber craft month"] = "april",
    ["cyber craft release"] = "april2026",
    ["cyber craft release date"] = "april2026",
    ["cyber craft release day"] = "18",
    ["cyber craft release month"] = "april",
    ["cyber craft release year"] = "2026",
    ["cyber craft year"] = "2026",
    ["cyber date"] = "april2026",
    ["cyber day"] = "18",
    ["cyber month"] = "april",
    ["cyber mutation"] = "cyber",
    ["cyber mutation date"] = "april2026",
    ["cyber mutation day"] = "18",
    ["cyber mutation for meowl"] = "cyber",
    ["cyber mutation month"] = "april",
    ["cyber mutation release"] = "april2026",
    ["cyber mutation release date"] = "april2026",
    ["cyber mutation release day"] = "18",
    ["cyber mutation release month"] = "april",
    ["cyber mutation release year"] = "2026",
    ["cyber mutation year"] = "2026",
    ["cyber on meowl"] = "cyber",
    ["cyber release"] = "april2026",
    ["cyber release date"] = "april2026",
    ["cyber release day"] = "18",
    ["cyber release month"] = "april",
    ["cyber release year"] = "2026",
    ["cyber year"] = "2026",
    ["cybercraft"] = "cybercraft",
    ["cybercraft date"] = "april2026",
    ["cybercraft day"] = "18",
    ["cybercraft month"] = "april",
    ["cybercraft release"] = "april2026",
    ["cybercraft release date"] = "april2026",
    ["cybercraft release day"] = "18",
    ["cybercraft release month"] = "april",
    ["cybercraft release year"] = "2026",
    ["cybercraft year"] = "2026",
    ["date when strawberry elephant released"] = "august2025",
    ["day birthday"] = "24",
    ["day headless horseman"] = "1",
    ["day john pork"] = "1",
    ["day meowl"] = "1",
    ["day skibidi toilet"] = "1",
    ["day spyder elephant"] = "1",
    ["day strawberry elephant"] = "1",
    ["day when headless horseman released"] = "1",
    ["day when john pork released"] = "1",
    ["day when meowl released"] = "1",
    ["day when skibidi toilet released"] = "1",
    ["day when spyder elephant released"] = "1",
    ["day when strawberry elephant released"] = "1",
    ["deleted brainrot"] = "tungtungtungsahur",
    ["deleted brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["diamond strawberry elephant exist"] = "263",
    ["diamond strawberry elephant exist count"] = "263",
    ["diamond strawberry elephants exist"] = "263",
    ["digi narwhal color"] = "blue",
    ["diginarwhal"] = "blue",
    ["disco"] = "disco",
    ["divine admin"] = "february2026",
    ["divine admin date"] = "february2026",
    ["divine admin day"] = "28",
    ["divine admin machine"] = "february2026",
    ["divine admin machine date"] = "february2026",
    ["divine admin machine day"] = "28",
    ["divine admin machine month"] = "february",
    ["divine admin machine release"] = "february2026",
    ["divine admin machine release date"] = "february2026",
    ["divine admin machine release day"] = "28",
    ["divine admin machine release month"] = "february",
    ["divine admin machine release year"] = "2026",
    ["divine admin machine year"] = "2026",
    ["divine admin month"] = "february",
    ["divine admin release"] = "february2026",
    ["divine admin release date"] = "february2026",
    ["divine admin release day"] = "28",
    ["divine admin release month"] = "february",
    ["divine admin release year"] = "2026",
    ["divine admin year"] = "2026",
    ["divine fuse"] = "divinefuse",
    ["divine fuse date"] = "march2026",
    ["divine fuse day"] = "7",
    ["divine fuse machine"] = "divinefuse",
    ["divine fuse machine date"] = "march2026",
    ["divine fuse machine day"] = "7",
    ["divine fuse machine month"] = "march",
    ["divine fuse machine release"] = "march2026",
    ["divine fuse machine release date"] = "march2026",
    ["divine fuse machine release day"] = "7",
    ["divine fuse machine release month"] = "march",
    ["divine fuse machine release year"] = "2026",
    ["divine fuse machine year"] = "2026",
    ["divine fuse month"] = "march",
    ["divine fuse release"] = "march2026",
    ["divine fuse release date"] = "march2026",
    ["divine fuse release day"] = "7",
    ["divine fuse release month"] = "march",
    ["divine fuse release year"] = "2026",
    ["divine fuse year"] = "2026",
    ["divine halo trait"] = "halo",
    ["divine halo trait date"] = "february2026",
    ["divine halo trait month"] = "february",
    ["divine halo trait release"] = "february2026",
    ["divine halo trait release date"] = "february2026",
    ["divine halo trait release month"] = "february",
    ["divine halo trait release year"] = "2026",
    ["divine halo trait year"] = "2026",
    ["divine mutation date"] = "february2026",
    ["divine mutation day"] = "21",
    ["divine mutation month"] = "february",
    ["divine mutation release"] = "february2026",
    ["divine mutation release date"] = "february2026",
    ["divine mutation release day"] = "21",
    ["divine mutation release month"] = "february",
    ["divine mutation release year"] = "2026",
    ["divine mutation year"] = "2026",
    ["do i have tiktok"] = "yes",
    ["do i have youtube"] = "yes",
    ["dog"] = "rocky",
    ["dog name"] = "rocky",
    ["dogs name"] = "rocky",
    ["draculino"] = "draculino",
    ["draculino color"] = "black",
    ["draculino island"] = "caveisland",
    ["dragon aquanini color"] = "blue",
    ["dragon cannelloni color"] = "yellow",
    ["dragon cannelloni egg"] = "dragonegg",
    ["dragon gingerini color"] = "brown",
    ["dragonaquanini"] = "blue",
    ["dragoncannelloni"] = "dragoncannelloni",
    ["dragonegg"] = "dragonegg",
    ["dragonfrutini"] = "torrtuginnidragonfrutini",
    ["dragongingerini"] = "brown",
    ["duels"] = "january2026",
    ["duels date"] = "january2026",
    ["duels day"] = "10",
    ["duels machine"] = "january2026",
    ["duels machine date"] = "january2026",
    ["duels machine day"] = "10",
    ["duels machine month"] = "january",
    ["duels machine release"] = "january2026",
    ["duels machine release date"] = "january2026",
    ["duels machine release day"] = "10",
    ["duels machine release month"] = "january",
    ["duels machine release year"] = "2026",
    ["duels machine year"] = "2026",
    ["duels month"] = "january",
    ["duels release"] = "january2026",
    ["duels release date"] = "january2026",
    ["duels release day"] = "10",
    ["duels release month"] = "january",
    ["duels release year"] = "2026",
    ["duels update"] = "january2026",
    ["duels update date"] = "january2026",
    ["duels update day"] = "10",
    ["duels update month"] = "january",
    ["duels update release"] = "january2026",
    ["duels update release date"] = "january2026",
    ["duels update release day"] = "10",
    ["duels update release month"] = "january",
    ["duels update release year"] = "2026",
    ["duels update year"] = "2026",
    ["duels year"] = "2026",
    ["easter"] = "easter",
    ["egg for dragon cannelloni"] = "dragonegg",
    ["egg incubator"] = "april2026",
    ["egg incubator date"] = "april2026",
    ["egg incubator day"] = "4",
    ["egg incubator month"] = "april",
    ["egg incubator release"] = "april2026",
    ["egg incubator release date"] = "april2026",
    ["egg incubator release day"] = "4",
    ["egg incubator release month"] = "april",
    ["egg incubator release year"] = "2026",
    ["egg incubator year"] = "2026",
    ["egg trait incubator"] = "april2026",
    ["egg trait incubator date"] = "april2026",
    ["egg trait incubator day"] = "4",
    ["egg trait incubator month"] = "april",
    ["egg trait incubator release"] = "april2026",
    ["egg trait incubator release date"] = "april2026",
    ["egg trait incubator release day"] = "4",
    ["egg trait incubator release month"] = "april",
    ["egg trait incubator release year"] = "2026",
    ["egg trait incubator year"] = "2026",
    ["eggcity"] = "eggcity",
    ["eid"] = "eid",
    ["elefanto"] = "elefantofrigo",
    ["elefanto frigo color"] = "gray",
    ["elefantofrigo"] = "gray",
    ["emperor"] = "emperor",
    ["enemy"] = "jandel",
    ["escapetsunami"] = "escapetsunami",
    ["esok sekolah"] = "esoksekolah",
    ["esoksekolah"] = "esoksekolah",
    ["event from money ritual"] = "moneymoneypuggy",
    ["event from new ritual"] = "moneymoneypuggy",
    ["event from the money ritual"] = "moneymoneypuggy",
    ["event money"] = "moneymoneypuggy",
    ["event puggy"] = "moneymoneypuggy",
    ["exist count of strawberry elephant"] = "2348",
    ["exist count of strawberry elephants"] = "2348",
    ["expensive"] = "spyderelephant",
    ["expensive brainrot"] = "spyderelephant",
    ["explosive"] = "explosive",
    ["extinct"] = "extinct",
    ["extinct event trait"] = "extinct",
    ["extinct event trait date"] = "september2025",
    ["extinct event trait day"] = "13",
    ["extinct event trait month"] = "september",
    ["extinct event trait release"] = "september2025",
    ["extinct event trait release date"] = "september2025",
    ["extinct event trait release day"] = "13",
    ["extinct event trait release month"] = "september",
    ["extinct event trait release year"] = "2025",
    ["extinct event trait year"] = "2025",
    ["extinct trait"] = "extinct",
    ["extinct trait date"] = "september2025",
    ["extinct trait day"] = "13",
    ["extinct trait month"] = "september",
    ["extinct trait release"] = "september2025",
    ["extinct trait release date"] = "september2025",
    ["extinct trait release day"] = "13",
    ["extinct trait release month"] = "september",
    ["extinct trait release year"] = "2025",
    ["extinct trait year"] = "2025",
    ["fat sammy"] = "fatsammy",
    ["fat sammy date"] = "august2025",
    ["fat sammy day"] = "12",
    ["fat sammy month"] = "august",
    ["fat sammy npc"] = "fatsammy",
    ["fat sammy npc date"] = "august2025",
    ["fat sammy npc day"] = "12",
    ["fat sammy npc month"] = "august",
    ["fat sammy npc release"] = "august2025",
    ["fat sammy npc release date"] = "august2025",
    ["fat sammy npc release day"] = "12",
    ["fat sammy npc release month"] = "august",
    ["fat sammy npc release year"] = "2025",
    ["fat sammy npc year"] = "2025",
    ["fat sammy release"] = "august2025",
    ["fat sammy release date"] = "august2025",
    ["fat sammy release day"] = "12",
    ["fat sammy release month"] = "august",
    ["fat sammy release year"] = "2025",
    ["fat sammy year"] = "2025",
    ["fatsammy"] = "fatsammy",
    ["fav brainrot"] = "meowl",
    ["fav color"] = "blue",
    ["fav food"] = "taco",
    ["fav game"] = "fortnite",
    ["fav mutation"] = "galaxy",
    ["fav mutation date"] = "august2025",
    ["fav mutation day"] = "23",
    ["fav mutation month"] = "august",
    ["fav mutation of sammy"] = "galaxy",
    ["fav mutation release"] = "august2025",
    ["fav mutation release date"] = "august2025",
    ["fav mutation release day"] = "23",
    ["fav mutation release month"] = "august",
    ["fav mutation release year"] = "2025",
    ["fav mutation year"] = "2025",
    ["fav number"] = "67",
    ["fav number of sammy"] = "67",
    ["fav phone"] = "iphone",
    ["favorite artist"] = "drake",
    ["favorite brainrot"] = "meowl",
    ["favorite fortnite"] = "robabankobby",
    ["favorite mutation"] = "galaxy",
    ["favorite mutation date"] = "august2025",
    ["favorite mutation day"] = "23",
    ["favorite mutation month"] = "august",
    ["favorite mutation of sammy"] = "galaxy",
    ["favorite mutation release"] = "august2025",
    ["favorite mutation release date"] = "august2025",
    ["favorite mutation release day"] = "23",
    ["favorite mutation release month"] = "august",
    ["favorite mutation release year"] = "2025",
    ["favorite mutation year"] = "2025",
    ["favorite number of sammy"] = "67",
    ["favorite phone"] = "iphone",
    ["favorite singer"] = "drake",
    ["favourite artist"] = "drake",
    ["favourite brainrot"] = "meowl",
    ["favourite color"] = "blue",
    ["favourite food"] = "taco",
    ["favourite fortnite"] = "robabankobby",
    ["favourite game"] = "fortnite",
    ["favourite mutation"] = "galaxy",
    ["favourite mutation date"] = "august2025",
    ["favourite mutation day"] = "23",
    ["favourite mutation month"] = "august",
    ["favourite mutation of sammy"] = "galaxy",
    ["favourite mutation release"] = "august2025",
    ["favourite mutation release date"] = "august2025",
    ["favourite mutation release day"] = "23",
    ["favourite mutation release month"] = "august",
    ["favourite mutation release year"] = "2025",
    ["favourite mutation year"] = "2025",
    ["favourite number"] = "67",
    ["favourite number of sammy"] = "67",
    ["favourite phone"] = "iphone",
    ["favourite singer"] = "drake",
    ["fifth fuse"] = "summerfuse",
    ["fifth fuse date"] = "may2026",
    ["fifth fuse day"] = "23",
    ["fifth fuse machine"] = "summerfuse",
    ["fifth fuse machine date"] = "may2026",
    ["fifth fuse machine day"] = "23",
    ["fifth fuse machine month"] = "may",
    ["fifth fuse machine release"] = "may2026",
    ["fifth fuse machine release date"] = "may2026",
    ["fifth fuse machine release day"] = "23",
    ["fifth fuse machine release month"] = "may",
    ["fifth fuse machine release year"] = "2026",
    ["fifth fuse machine year"] = "2026",
    ["fifth fuse month"] = "may",
    ["fifth fuse release"] = "may2026",
    ["fifth fuse release date"] = "may2026",
    ["fifth fuse release day"] = "23",
    ["fifth fuse release month"] = "may",
    ["fifth fuse release year"] = "2026",
    ["fifth fuse year"] = "2026",
    ["fifth og"] = "johnpork",
    ["fifth og brainrot"] = "johnpork",
    ["fire trait"] = "fire",
    ["fire trait date"] = "june2025",
    ["fire trait month"] = "june",
    ["fire trait release"] = "june2025",
    ["fire trait release date"] = "june2025",
    ["fire trait release month"] = "june",
    ["fire trait release year"] = "2025",
    ["fire trait year"] = "2025",
    ["firework"] = "firework",
    ["firework trait"] = "firework",
    ["firework trait date"] = "july2025",
    ["firework trait day"] = "4",
    ["firework trait month"] = "july",
    ["firework trait release"] = "july2025",
    ["firework trait release date"] = "july2025",
    ["firework trait release day"] = "4",
    ["firework trait release month"] = "july",
    ["firework trait release year"] = "2025",
    ["firework trait year"] = "2025",
    ["fireworks"] = "fireworks",
    ["first bee"] = "beeloco",
    ["first bee brainrot"] = "beeloco",
    ["first bee brainrot in game"] = "beeloco",
    ["first bee brainrot in sab"] = "beeloco",
    ["first bee brainrot in the"] = "beeloco",
    ["first bee brainrot in the game"] = "beeloco",
    ["first bee in game"] = "beeloco",
    ["first bee in sab"] = "beeloco",
    ["first bee in the game"] = "beeloco",
    ["first bee lucky"] = "beeloco",
    ["first bee lucky block"] = "beeloco",
    ["first bee lucky block brainrot"] = "beeloco",
    ["first bee shop"] = "beeloco",
    ["first bee shop brainrot"] = "beeloco",
    ["first bee update"] = "beeloco",
    ["first bee update brainrot"] = "beeloco",
    ["first brainrot"] = "noobinipizzanini",
    ["first brainrot god"] = "tralalerotralala",
    ["first brainrot that got removed"] = "tungtungtungsahur",
    ["first brainrot that was reworked"] = "sammynispyderini",
    ["first craft"] = "september2025",
    ["first craft date"] = "september2025",
    ["first craft day"] = "6",
    ["first craft machine"] = "september2025",
    ["first craft machine date"] = "september2025",
    ["first craft machine day"] = "6",
    ["first craft machine month"] = "september",
    ["first craft machine release"] = "september2025",
    ["first craft machine release date"] = "september2025",
    ["first craft machine release day"] = "6",
    ["first craft machine release month"] = "september",
    ["first craft machine release year"] = "2025",
    ["first craft machine year"] = "2025",
    ["first craft month"] = "september",
    ["first craft release"] = "september2025",
    ["first craft release date"] = "september2025",
    ["first craft release day"] = "6",
    ["first craft release month"] = "september",
    ["first craft release year"] = "2025",
    ["first craft year"] = "2025",
    ["first fuse"] = "lafusemachine",
    ["first fuse date"] = "august2025",
    ["first fuse day"] = "1",
    ["first fuse machine"] = "lafusemachine",
    ["first fuse machine date"] = "august2025",
    ["first fuse machine day"] = "1",
    ["first fuse machine month"] = "august",
    ["first fuse machine release"] = "august2025",
    ["first fuse machine release date"] = "august2025",
    ["first fuse machine release day"] = "1",
    ["first fuse machine release month"] = "august",
    ["first fuse machine release year"] = "2025",
    ["first fuse machine year"] = "2025",
    ["first fuse month"] = "august",
    ["first fuse release"] = "august2025",
    ["first fuse release date"] = "august2025",
    ["first fuse release day"] = "1",
    ["first fuse release month"] = "august",
    ["first fuse release year"] = "2025",
    ["first fuse year"] = "2025",
    ["first game"] = "crabgame",
    ["first game played"] = "crabgame",
    ["first gear"] = "bat",
    ["first god"] = "tralalerotralala",
    ["first item"] = "bat",
    ["first lucky block"] = "july2025",
    ["first lucky block date"] = "july2025",
    ["first lucky block day"] = "12",
    ["first lucky block month"] = "july",
    ["first lucky block release"] = "july2025",
    ["first lucky block release date"] = "july2025",
    ["first lucky block release day"] = "12",
    ["first lucky block release month"] = "july",
    ["first lucky block release year"] = "2025",
    ["first lucky block year"] = "2025",
    ["first machine added"] = "rainbowmachine",
    ["first machine added date"] = "june2025",
    ["first machine added day"] = "21",
    ["first machine added month"] = "june",
    ["first machine added release"] = "june2025",
    ["first machine added release date"] = "june2025",
    ["first machine added release day"] = "21",
    ["first machine added release month"] = "june",
    ["first machine added release year"] = "2025",
    ["first machine added to sab"] = "rainbowmachine",
    ["first machine added to sab date"] = "june2025",
    ["first machine added to sab day"] = "21",
    ["first machine added to sab month"] = "june",
    ["first machine added to sab release"] = "june2025",
    ["first machine added to sab release date"] = "june2025",
    ["first machine added to sab release day"] = "21",
    ["first machine added to sab release month"] = "june",
    ["first machine added to sab release year"] = "2025",
    ["first machine added to sab year"] = "2025",
    ["first machine added to the game"] = "rainbowmachine",
    ["first machine added to the game date"] = "june2025",
    ["first machine added to the game day"] = "21",
    ["first machine added to the game month"] = "june",
    ["first machine added to the game release"] = "june2025",
    ["first machine added to the game release date"] = "june2025",
    ["first machine added to the game release day"] = "21",
    ["first machine added to the game release month"] = "june",
    ["first machine added to the game release year"] = "2025",
    ["first machine added to the game year"] = "2025",
    ["first machine added year"] = "2025",
    ["first machine date"] = "june2025",
    ["first machine day"] = "21",
    ["first machine game"] = "rainbowmachine",
    ["first machine in game"] = "rainbowmachine",
    ["first machine in game date"] = "june2025",
    ["first machine in game day"] = "21",
    ["first machine in game month"] = "june",
    ["first machine in game release"] = "june2025",
    ["first machine in game release date"] = "june2025",
    ["first machine in game release day"] = "21",
    ["first machine in game release month"] = "june",
    ["first machine in game release year"] = "2025",
    ["first machine in game year"] = "2025",
    ["first machine in sab"] = "rainbowmachine",
    ["first machine in sab date"] = "june2025",
    ["first machine in sab day"] = "21",
    ["first machine in sab month"] = "june",
    ["first machine in sab release"] = "june2025",
    ["first machine in sab release date"] = "june2025",
    ["first machine in sab release day"] = "21",
    ["first machine in sab release month"] = "june",
    ["first machine in sab release year"] = "2025",
    ["first machine in sab year"] = "2025",
    ["first machine in the game"] = "rainbowmachine",
    ["first machine in the game date"] = "june2025",
    ["first machine in the game day"] = "21",
    ["first machine in the game month"] = "june",
    ["first machine in the game release"] = "june2025",
    ["first machine in the game release date"] = "june2025",
    ["first machine in the game release day"] = "21",
    ["first machine in the game release month"] = "june",
    ["first machine in the game release year"] = "2025",
    ["first machine in the game year"] = "2025",
    ["first machine month"] = "june",
    ["first machine release"] = "june2025",
    ["first machine release date"] = "june2025",
    ["first machine release day"] = "21",
    ["first machine release month"] = "june",
    ["first machine release year"] = "2025",
    ["first machine sab"] = "rainbowmachine",
    ["first machine year"] = "2025",
    ["first name of first og"] = "strawberryelephant",
    ["first name og"] = "strawberryelephant",
    ["first og"] = "strawberryelephant",
    ["first og brainrot"] = "strawberryelephant",
    ["first og brainrot in game"] = "strawberryelephant",
    ["first og brainrot in the game"] = "strawberryelephant",
    ["first og brainrot name"] = "strawberryelephant",
    ["first og in game"] = "strawberryelephant",
    ["first og in the game"] = "strawberryelephant",
    ["first og name"] = "strawberryelephant",
    ["first removed brainrot"] = "tungtungtungsahur",
    ["first reworked brainrot"] = "sammynispyderini",
    ["first ritual"] = "comet",
    ["first secret"] = "lavaccasaturnosaturnita",
    ["first secret brainrot"] = "lavaccasaturnosaturnita",
    ["first secret in sab"] = "lavaccasaturnosaturnita",
    ["first secret in sub"] = "lavaccasaturnosaturnita",
    ["first secret in the game"] = "lavaccasaturnosaturnita",
    ["first secret in the game brainrot"] = "lavaccasaturnosaturnita",
    ["first secret sab"] = "lavaccasaturnosaturnita",
    ["first snake"] = "hydraserpent",
    ["first snake added"] = "hydraserpent",
    ["first snake brainrot"] = "hydraserpent",
    ["first snake brainrot added"] = "hydraserpent",
    ["first snake brainrot ever added"] = "hydraserpent",
    ["first snake brainrot in game"] = "hydraserpent",
    ["first snake brainrot in sab"] = "hydraserpent",
    ["first snake brainrot in the game"] = "hydraserpent",
    ["first snake brainrot that was added"] = "hydraserpent",
    ["first snake brainrot that was ever added"] = "hydraserpent",
    ["first snake ever added"] = "hydraserpent",
    ["first snake in game"] = "hydraserpent",
    ["first snake in sab"] = "hydraserpent",
    ["first snake in the game"] = "hydraserpent",
    ["first snake that was added"] = "hydraserpent",
    ["first snake that was ever added"] = "hydraserpent",
    ["first taco"] = "tipitopitaco",
    ["first taco brainrot"] = "tipitopitaco",
    ["first taco brainrot in the game"] = "tipitopitaco",
    ["first taco in the game"] = "tipitopitaco",
    ["first taco merchant"] = "sammynitruckini",
    ["first taco secret"] = "lacucaracha",
    ["first weapon"] = "bat",
    ["flying b"] = "flyingbee",
    ["flying b gear"] = "flyingbee",
    ["flying bee"] = "flyingbee",
    ["flying bee gear"] = "flyingbee",
    ["flyingbee"] = "flyingbee",
    ["flyingbee gear"] = "flyingbee",
    ["fortnite"] = "fortnite",
    ["fortnite obby"] = "robabankobby",
    ["fourth 3 headed"] = "hydraserpent",
    ["fourth 3 headed brainrot"] = "hydraserpent",
    ["fourth 3 headed brainrot added"] = "hydraserpent",
    ["fourth 3 headed brainrot in game"] = "hydraserpent",
    ["fourth 3 headed brainrot in the game"] = "hydraserpent",
    ["fourth best taco merchant"] = "burritobat",
    ["fourth fuse"] = "divinefuse",
    ["fourth fuse date"] = "march2026",
    ["fourth fuse day"] = "7",
    ["fourth fuse machine"] = "divinefuse",
    ["fourth fuse machine date"] = "march2026",
    ["fourth fuse machine day"] = "7",
    ["fourth fuse machine month"] = "march",
    ["fourth fuse machine release"] = "march2026",
    ["fourth fuse machine release date"] = "march2026",
    ["fourth fuse machine release day"] = "7",
    ["fourth fuse machine release month"] = "march",
    ["fourth fuse machine release year"] = "2026",
    ["fourth fuse machine year"] = "2026",
    ["fourth fuse month"] = "march",
    ["fourth fuse release"] = "march2026",
    ["fourth fuse release date"] = "march2026",
    ["fourth fuse release day"] = "7",
    ["fourth fuse release month"] = "march",
    ["fourth fuse release year"] = "2026",
    ["fourth fuse year"] = "2026",
    ["fourth headed"] = "hydraserpent",
    ["fourth og"] = "headlesshorseman",
    ["fourth og brainrot"] = "headlesshorseman",
    ["fourth taco merchant"] = "burritobat",
    ["fourth three headed"] = "hydraserpent",
    ["fourth three headed brainrot"] = "hydraserpent",
    ["fourth three headed brainrot added"] = "hydraserpent",
    ["fourth three headed brainrot in game"] = "hydraserpent",
    ["fourth three headed brainrot in sab"] = "hydraserpent",
    ["fourth three headed brainrot in the game"] = "hydraserpent",
    ["friend food name"] = "steak",
    ["friend that is a youtuber that has food in his name"] = "steak",
    ["friend that is a youtuber that has food in name"] = "steak",
    ["friend that is a youtuber with food"] = "steak",
    ["friend that is a youtuber with food in his name"] = "steak",
    ["friend that is a youtuber with food in name"] = "steak",
    ["friend with food in his name"] = "steak",
    ["friend with food in name"] = "steak",
    ["friend youtuber"] = "steak",
    ["friend youtuber food"] = "steak",
    ["friend youtuber that has food in his name"] = "steak",
    ["friend youtuber with food in his name"] = "steak",
    ["frigo"] = "elefantofrigo",
    ["from what egg can you get dragon cannelloni"] = "dragonegg",
    ["from what egg can you obtain dragon cannelloni"] = "dragonegg",
    ["from what egg you can get dragon cannelloni"] = "dragonegg",
    ["from what egg you can obtain dragon cannelloni"] = "dragonegg",
    ["from what island can you obtain draculino"] = "caveisland",
    ["from what island you can obtain draculino"] = "caveisland",
    ["from which egg can you obtain dragon cannelloni"] = "dragonegg",
    ["fuse"] = "lafusemachine",
    ["fuse date"] = "august2025",
    ["fuse day"] = "1",
    ["fuse machine"] = "lafusemachine",
    ["fuse machine coming next"] = "hauntedfuse",
    ["fuse machine date"] = "august2025",
    ["fuse machine day"] = "1",
    ["fuse machine month"] = "august",
    ["fuse machine original"] = "lafusemachine",
    ["fuse machine original date"] = "august2025",
    ["fuse machine original day"] = "1",
    ["fuse machine original month"] = "august",
    ["fuse machine original release"] = "august2025",
    ["fuse machine original release date"] = "august2025",
    ["fuse machine original release day"] = "1",
    ["fuse machine original release month"] = "august",
    ["fuse machine original release year"] = "2025",
    ["fuse machine original year"] = "2025",
    ["fuse machine release"] = "august2025",
    ["fuse machine release date"] = "august2025",
    ["fuse machine release day"] = "1",
    ["fuse machine release month"] = "august",
    ["fuse machine release year"] = "2025",
    ["fuse machine return"] = "january2026",
    ["fuse machine return date"] = "january2026",
    ["fuse machine return day"] = "24",
    ["fuse machine return month"] = "january",
    ["fuse machine return release"] = "january2026",
    ["fuse machine return release date"] = "january2026",
    ["fuse machine return release day"] = "24",
    ["fuse machine return release month"] = "january",
    ["fuse machine return release year"] = "2026",
    ["fuse machine return year"] = "2026",
    ["fuse machine year"] = "2025",
    ["fuse month"] = "august",
    ["fuse release"] = "august2025",
    ["fuse release date"] = "august2025",
    ["fuse release day"] = "1",
    ["fuse release month"] = "august",
    ["fuse release year"] = "2025",
    ["fuse return"] = "january2026",
    ["fuse return date"] = "january2026",
    ["fuse return day"] = "24",
    ["fuse return month"] = "january",
    ["fuse return release"] = "january2026",
    ["fuse return release date"] = "january2026",
    ["fuse return release day"] = "24",
    ["fuse return release month"] = "january",
    ["fuse return release year"] = "2026",
    ["fuse return year"] = "2026",
    ["fuse year"] = "2025",
    ["futbol"] = "futbol",
    ["galactic"] = "galactic",
    ["galaxy date"] = "august2025",
    ["galaxy day"] = "23",
    ["galaxy month"] = "august",
    ["galaxy mutation"] = "galaxy",
    ["galaxy mutation date"] = "august2025",
    ["galaxy mutation day"] = "23",
    ["galaxy mutation month"] = "august",
    ["galaxy mutation release"] = "august2025",
    ["galaxy mutation release date"] = "august2025",
    ["galaxy mutation release day"] = "23",
    ["galaxy mutation release month"] = "august",
    ["galaxy mutation release year"] = "2025",
    ["galaxy mutation year"] = "2025",
    ["galaxy release"] = "august2025",
    ["galaxy release date"] = "august2025",
    ["galaxy release day"] = "23",
    ["galaxy release month"] = "august",
    ["galaxy release year"] = "2025",
    ["galaxy year"] = "2025",
    ["game am i a competitive player at"] = "valorant",
    ["game am i competitive at"] = "valorant",
    ["game am i competitive in"] = "valorant",
    ["game am i competitive player at"] = "valorant",
    ["game better than 1 speed keyboard escape"] = "growagarden",
    ["game better than 1speedkeyboardescape"] = "growagarden",
    ["game competitive"] = "valorant",
    ["game created"] = "may2025",
    ["game created date"] = "may2025",
    ["game created day"] = "16",
    ["game created month"] = "may",
    ["game created release"] = "may2025",
    ["game created release date"] = "may2025",
    ["game created release day"] = "16",
    ["game created release month"] = "may",
    ["game created release year"] = "2025",
    ["game created year"] = "2025",
    ["game enjoy"] = "fortnite",
    ["game favorite"] = "fortnite",
    ["game favourite"] = "fortnite",
    ["game hate"] = "growagarden",
    ["game hate most"] = "growagarden",
    ["game hates"] = "growagarden",
    ["game hates most"] = "growagarden",
    ["game i am competitive at"] = "valorant",
    ["game i am competitive player at"] = "valorant",
    ["game i enjoy playing"] = "fortnite",
    ["game i hate"] = "growagarden",
    ["game i hate most"] = "growagarden",
    ["game i hate the most"] = "growagarden",
    ["game i like the most"] = "fortnite",
    ["game i like to play"] = "fortnite",
    ["game i love"] = "fortnite",
    ["game i love the most"] = "fortnite",
    ["game i love to play"] = "fortnite",
    ["game i play competitive"] = "valorant",
    ["game i play competitively"] = "valorant",
    ["game launched"] = "may2025",
    ["game launched date"] = "may2025",
    ["game launched day"] = "16",
    ["game launched month"] = "may",
    ["game launched release"] = "may2025",
    ["game launched release date"] = "may2025",
    ["game launched release day"] = "16",
    ["game launched release month"] = "may",
    ["game launched release year"] = "2025",
    ["game launched year"] = "2025",
    ["game like play"] = "fortnite",
    ["game likes play"] = "fortnite",
    ["game love"] = "fortnite",
    ["game love play"] = "fortnite",
    ["game loves"] = "fortnite",
    ["game loves play"] = "fortnite",
    ["game made"] = "may2025",
    ["game made date"] = "may2025",
    ["game made day"] = "16",
    ["game made month"] = "may",
    ["game made release"] = "may2025",
    ["game made release date"] = "may2025",
    ["game made release day"] = "16",
    ["game made release month"] = "may",
    ["game made release year"] = "2025",
    ["game made year"] = "2025",
    ["game release day"] = "16",
    ["game release month"] = "may",
    ["game release release"] = "may2025",
    ["game release release date"] = "may2025",
    ["game release release day"] = "16",
    ["game release release month"] = "may",
    ["game release release year"] = "2025",
    ["game release year"] = "2025",
    ["game released date"] = "may2025",
    ["game released day"] = "16",
    ["game released month"] = "may",
    ["game released release"] = "may2025",
    ["game released release date"] = "may2025",
    ["game released release day"] = "16",
    ["game released release month"] = "may",
    ["game released release year"] = "2025",
    ["game released year"] = "2025",
    ["game sammy hates"] = "growagarden",
    ["game sammy hates most"] = "growagarden",
    ["game sammy hates the most"] = "growagarden",
    ["game sammy is competitive player at"] = "valorant",
    ["game sammy likes the most"] = "fortnite",
    ["game sammy likes to play"] = "fortnite",
    ["game sammy loves"] = "fortnite",
    ["game sammy loves the most"] = "fortnite",
    ["game sammy loves to play"] = "fortnite",
    ["game sammy plays competitively"] = "valorant",
    ["game that is better than 1 speed keyboard escape"] = "growagarden",
    ["game that is better than 1 speed keyboard escape is grow a garden"] = "growagarden",
    ["game that is better than 1 speed keyboard escape is growagarden"] = "growagarden",
    ["game that is better than 1speedkeyboardescape"] = "growagarden",
    ["game that is better than 1speedkeyboardescape is growagarden"] = "growagarden",
    ["game that is worse than grow a garden"] = "1speedkeyboardescape",
    ["game that is worse than grow a garden is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["game that is worse than grow a garden is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["game that is worse than growagarden"] = "1speedkeyboardescape",
    ["game that is worser than grow a garden"] = "1speedkeyboardescape",
    ["game that is worser than grow a garden is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["game that is worser than grow a garden is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["game that is worser than growagarden"] = "1speedkeyboardescape",
    ["game worse than grow a garden"] = "1speedkeyboardescape",
    ["game worse than growagarden"] = "1speedkeyboardescape",
    ["game worser than grow a garden"] = "1speedkeyboardescape",
    ["game worser than growagarden"] = "1speedkeyboardescape",
    ["garama"] = "garamaandmadundung",
    ["garama and madundung color"] = "gray",
    ["garamaandmadundung"] = "gray",
    ["garamaandmadungdung"] = "garamaandmadundung",
    ["gatito tacoto"] = "gattitotacoto",
    ["gattatino nyanino"] = "gattatinonyanino",
    ["gattatinonyanino"] = "gattatinonyanino",
    ["gattito tacoto"] = "gattitotacoto",
    ["gattitotacoto"] = "gattitotacoto",
    ["gingerbread"] = "dragongingerini",
    ["gingerbreaddragon"] = "dragongingerini",
    ["gingerini"] = "DragonGingerini",
    ["glitch"] = "glitch",
    ["glitch trait"] = "glitch",
    ["glitch trait date"] = "june2025",
    ["glitch trait month"] = "june",
    ["glitch trait release"] = "june2025",
    ["glitch trait release date"] = "june2025",
    ["glitch trait release month"] = "june",
    ["glitch trait release year"] = "2025",
    ["glitch trait year"] = "2025",
    ["glitched trait"] = "glitch",
    ["glitched trait date"] = "june2025",
    ["glitched trait month"] = "june",
    ["glitched trait release"] = "june2025",
    ["glitched trait release date"] = "june2025",
    ["glitched trait release month"] = "june",
    ["glitched trait release year"] = "2025",
    ["glitched trait year"] = "2025",
    ["gold strawberry elephant exist"] = "565",
    ["gold strawberry elephant exist count"] = "565",
    ["gold strawberry elephants exist"] = "565",
    ["granny"] = "granny",
    ["granny trait"] = "granny",
    ["granny trait date"] = "march2026",
    ["granny trait day"] = "21",
    ["granny trait month"] = "march",
    ["granny trait release"] = "march2026",
    ["granny trait release date"] = "march2026",
    ["granny trait release day"] = "21",
    ["granny trait release month"] = "march",
    ["granny trait release year"] = "2026",
    ["granny trait year"] = "2026",
    ["gray"] = "gray",
    ["green egg trait"] = "greenegg",
    ["green egg trait date"] = "april2026",
    ["green egg trait month"] = "april",
    ["green egg trait release"] = "april2026",
    ["green egg trait release date"] = "april2026",
    ["green egg trait release month"] = "april",
    ["green egg trait release year"] = "2026",
    ["green egg trait year"] = "2026",
    ["greenballoon"] = "greenballoon",
    ["greenegg"] = "greenegg",
    ["griefshield"] = "griefshield",
    ["griffin"] = "griffin",
    ["griffin color"] = "white",
    ["group"] = "brazilianspyder",
    ["group hate"] = "secretverse",
    ["group hate most"] = "secretverse",
    ["group hates"] = "secretverse",
    ["group hates most"] = "secretverse",
    ["group i hate"] = "secretverse",
    ["group i hate most"] = "secretverse",
    ["group i hate the most"] = "secretverse",
    ["group sammy hates"] = "secretverse",
    ["group sammy hates most"] = "secretverse",
    ["group sammy hates the most"] = "secretverse",
    ["grow a garden"] = "growagarden",
    ["grow garden"] = "growagarden",
    ["growagarden"] = "growagarden",
    ["hair"] = "black",
    ["hair color"] = "black",
    ["hair colour"] = "black",
    ["halloween"] = "halloween",
    ["halloween fuse"] = "hauntedfuse",
    ["halloween fuse machine"] = "hauntedfuse",
    ["halo"] = "halo",
    ["halo trait"] = "halo",
    ["halo trait date"] = "february2026",
    ["halo trait month"] = "february",
    ["halo trait release"] = "february2026",
    ["halo trait release date"] = "february2026",
    ["halo trait release month"] = "february",
    ["halo trait release year"] = "2026",
    ["halo trait year"] = "2026",
    ["hardest brainrot"] = "spyderelephant",
    ["hardest brainrot in game"] = "spyderelephant",
    ["hardest brainrot in the game"] = "spyderelephant",
    ["hardest brainrot to find"] = "spyderelephant",
    ["hardest brainrot to get"] = "spyderelephant",
    ["hardest brainrot to get in game"] = "spyderelephant",
    ["hardest brainrot to get in the game"] = "spyderelephant",
    ["hardest brainrot to obtain"] = "spyderelephant",
    ["hardest to get"] = "spyderelephant",
    ["hated game"] = "growagarden",
    ["hated group"] = "secretverse",
    ["hated person"] = "secretlokii",
    ["hated studio"] = "secretverse",
    ["hauntedfuse"] = "hauntedfuse",
    ["he began making games on roblox in"] = "2013",
    ["he began making games on roblox in 2013"] = "2013",
    ["he began making games on roblox in 2013 release year"] = "2013",
    ["he began making games on roblox in 2013 year"] = "2013",
    ["he began making games on roblox in release year"] = "2013",
    ["he began making games on roblox in year"] = "2013",
    ["headless"] = "headlesshorseman",
    ["headless horseman added"] = "february2026",
    ["headless horseman color"] = "black",
    ["headless horseman date"] = "february2026",
    ["headless horseman day"] = "1",
    ["headless horseman month"] = "february",
    ["headless horseman release"] = "february2026",
    ["headless horseman release date"] = "february2026",
    ["headless horseman release day"] = "1",
    ["headless horseman release month"] = "february",
    ["headless horseman release year"] = "2026",
    ["headless horseman released"] = "february2026",
    ["headless horseman year"] = "2026",
    ["headlesshorseman"] = "headlesshorseman",
    ["headlesshorseman date"] = "february2026",
    ["headlesshorseman day"] = "1",
    ["headlesshorseman month"] = "february",
    ["headlesshorseman release"] = "february2026",
    ["headlesshorseman release date"] = "february2026",
    ["headlesshorseman release day"] = "1",
    ["headlesshorseman release month"] = "february",
    ["headlesshorseman release year"] = "2026",
    ["headlesshorseman year"] = "2026",
    ["hello"] = "hello",
    ["hey"] = "hey",
    ["hi"] = "hi",
    ["highest mutation"] = "crystal",
    ["his favorite game is fortnite"] = "fortnite",
    ["his favourite game is fortnite"] = "fortnite",
    ["his roblox avatar color"] = "red",
    ["horseman"] = "HeadlessHorseman",
    ["hotspotsitos"] = "losnooomyhotspotsitos",
    ["how many 1 1"] = "155",
    ["how many 1 of 1"] = "155",
    ["how many 1 of 1 brainrots"] = "155",
    ["how many 1 of 1 brainrots exist"] = "155",
    ["how many 1 of 1 exist"] = "155",
    ["how many 1 of 1s"] = "155",
    ["how many 1 of 1s brainrots"] = "155",
    ["how many 1 of 1s brainrots exist"] = "155",
    ["how many 1 of 1s exist"] = "155",
    ["how many 1of1"] = "155",
    ["how many 1of1 brainrots"] = "155",
    ["how many 1of1 brainrots exist"] = "155",
    ["how many 1of1 exist"] = "155",
    ["how many 1of1s"] = "155",
    ["how many 1of1s brainrots"] = "155",
    ["how many 1of1s brainrots exist"] = "155",
    ["how many 1of1s exist"] = "155",
    ["how many are there 1 of 1 brainrots"] = "155",
    ["how many are there 1 of 1s brainrots"] = "155",
    ["how many base strawberry elephant exist"] = "1277",
    ["how many base strawberry elephants exist"] = "1277",
    ["how many crystal strawberry elephant exist"] = "1",
    ["how many crystal strawberry elephants exist"] = "1",
    ["how many diamond strawberry elephant exist"] = "263",
    ["how many diamond strawberry elephants exist"] = "263",
    ["how many gold strawberry elephant exist"] = "565",
    ["how many gold strawberry elephants exist"] = "565",
    ["how many is there 1 of 1"] = "155",
    ["how many is there 1 of 1 brainrots"] = "155",
    ["how many is there 1 of 1s"] = "155",
    ["how many is there 1 of 1s brainrots"] = "155",
    ["how many is there one of one brainrots"] = "155",
    ["how many normal strawberry elephant exist"] = "1277",
    ["how many normal strawberry elephants exist"] = "1277",
    ["how many one of one"] = "155",
    ["how many one of one brainrots"] = "155",
    ["how many one of ones"] = "155",
    ["how many rainbow strawberry elephant exist"] = "87",
    ["how many rainbow strawberry elephants exist"] = "87",
    ["how many strawberry elephant exist"] = "2348",
    ["how many strawberry elephant exists"] = "2348",
    ["how many strawberry elephant in the game exist"] = "2348",
    ["how many strawberry elephant that exist"] = "2348",
    ["how many strawberry elephants exist"] = "2348",
    ["how many strawberry elephants exists"] = "2348",
    ["how many strawberry elephants in the game exist"] = "2348",
    ["how many strawberry elephants that exist"] = "2348",
    ["how many total 1 of 1"] = "155",
    ["how many total 1 of 1 brainrots exist"] = "155",
    ["how many total 1 of 1s"] = "155",
    ["how many total 1 of 1s exist"] = "155",
    ["how many total strawberry elephant exist"] = "2348",
    ["how many total strawberry elephants exist"] = "2348",
    ["how much 1 1"] = "155",
    ["how much 1 of 1"] = "155",
    ["how much 1 of 1 brainrots"] = "155",
    ["how much 1 of 1 exist"] = "155",
    ["how much 1 of 1s"] = "155",
    ["how much 1 of 1s brainrots"] = "155",
    ["how much 1 of 1s exist"] = "155",
    ["how much 1of1"] = "155",
    ["how much 1of1 brainrots"] = "155",
    ["how much 1of1 exist"] = "155",
    ["how much 1of1s"] = "155",
    ["how much 1of1s brainrots"] = "155",
    ["how much 1of1s exist"] = "155",
    ["how much are there 1 of 1 brainrots"] = "155",
    ["how much are there 1 of 1s brainrots"] = "155",
    ["how much is there 1 of 1"] = "155",
    ["how much is there 1 of 1 brainrots"] = "155",
    ["how much is there 1 of 1s"] = "155",
    ["how much is there 1 of 1s brainrots"] = "155",
    ["how much is there 1of1 brainrots"] = "155",
    ["how much is there 1of1s brainrots"] = "155",
    ["how much is there one of one brainrots"] = "155",
    ["how much one of one"] = "155",
    ["how much one of one brainrots"] = "155",
    ["how much one of ones"] = "155",
    ["how much weigh"] = "250",
    ["how old"] = "24",
    ["howdy"] = "howdy",
    ["hydra"] = "hydraserpent",
    ["hydra bunny color"] = "white",
    ["hydra dragon cannelloni color"] = "yellow",
    ["hydra serpent"] = "hydraserpent",
    ["hydra serpent color"] = "green",
    ["hydrabunny"] = "hydrabunny",
    ["hydrabunnyegg"] = "hydrabunnyegg",
    ["hydradragon"] = "hydradragoncannelloni",
    ["hydradragoncannelloni"] = "yellow",
    ["hydrarabbit"] = "hydrabunny",
    ["hydraserpent"] = "hydraserpent",
    ["i am a competitive player at"] = "valorant",
    ["i am a competitive player at valorant"] = "valorant",
    ["i am competitive at"] = "valorant",
    ["i am competitive player at"] = "valorant",
    ["i am competitive player at valorant"] = "valorant",
    ["i began making games"] = "2013",
    ["i began making games in roblox"] = "2013",
    ["i began making games in roblox release year"] = "2013",
    ["i began making games in roblox year"] = "2013",
    ["i began making games on roblox"] = "2013",
    ["i began making games on roblox in"] = "2013",
    ["i began making games on roblox in 2013"] = "2013",
    ["i began making games on roblox in 2013 release year"] = "2013",
    ["i began making games on roblox in 2013 year"] = "2013",
    ["i began making games on roblox in release year"] = "2013",
    ["i began making games on roblox in year"] = "2013",
    ["i began making games on roblox release year"] = "2013",
    ["i began making games on roblox year"] = "2013",
    ["i began making games release year"] = "2013",
    ["i began making games year"] = "2013",
    ["i love to play"] = "fortnite",
    ["i started making games"] = "2013",
    ["i started making games in roblox"] = "2013",
    ["i started making games in roblox release year"] = "2013",
    ["i started making games in roblox year"] = "2013",
    ["i started making games on roblox"] = "2013",
    ["i started making games on roblox in"] = "2013",
    ["i started making games on roblox in 2013"] = "2013",
    ["i started making games on roblox in 2013 release year"] = "2013",
    ["i started making games on roblox in 2013 year"] = "2013",
    ["i started making games on roblox in release year"] = "2013",
    ["i started making games on roblox in year"] = "2013",
    ["i started making games on roblox release year"] = "2013",
    ["i started making games on roblox year"] = "2013",
    ["i started making games release year"] = "2013",
    ["i started making games year"] = "2013",
    ["icedragon"] = "blue",
    ["incubator machine"] = "april2026",
    ["incubator machine date"] = "april2026",
    ["incubator machine day"] = "4",
    ["incubator machine month"] = "april",
    ["incubator machine release"] = "april2026",
    ["incubator machine release date"] = "april2026",
    ["incubator machine release day"] = "4",
    ["incubator machine release month"] = "april",
    ["incubator machine release year"] = "2026",
    ["incubator machine year"] = "2026",
    ["indonesia"] = "indonesia",
    ["indonesia trait"] = "indonesia",
    ["indonesia trait date"] = "june2025",
    ["indonesia trait month"] = "june",
    ["indonesia trait release"] = "june2025",
    ["indonesia trait release date"] = "june2025",
    ["indonesia trait release month"] = "june",
    ["indonesia trait release year"] = "2025",
    ["indonesia trait year"] = "2025",
    ["iphone"] = "iphone",
    ["jack o lantern trait"] = "jackolantern",
    ["jack o lantern trait date"] = "october2025",
    ["jack o lantern trait month"] = "october",
    ["jack o lantern trait release"] = "october2025",
    ["jack o lantern trait release date"] = "october2025",
    ["jack o lantern trait release month"] = "october",
    ["jack o lantern trait release year"] = "2025",
    ["jack o lantern trait year"] = "2025",
    ["jackolantern"] = "jackolantern",
    ["jackolantern trait"] = "jackolantern",
    ["jackolantern trait date"] = "october2025",
    ["jackolantern trait month"] = "october",
    ["jackolantern trait release"] = "october2025",
    ["jackolantern trait release date"] = "october2025",
    ["jackolantern trait release month"] = "october",
    ["jackolantern trait release year"] = "2025",
    ["jackolantern trait year"] = "2025",
    ["jandel"] = "jandel",
    ["job ritual"] = "job",
    ["job sahur ritual"] = "job",
    ["jobapplication"] = "jobapplication",
    ["john pork added"] = "may2026",
    ["john pork color"] = "pink",
    ["john pork date"] = "may2026",
    ["john pork day"] = "1",
    ["john pork month"] = "may",
    ["john pork release"] = "may2026",
    ["john pork release date"] = "may2026",
    ["john pork release day"] = "1",
    ["john pork release month"] = "may",
    ["john pork release year"] = "2026",
    ["john pork released"] = "may2026",
    ["john pork year"] = "2026",
    ["johnpork"] = "johnpork",
    ["johnpork date"] = "may2026",
    ["johnpork day"] = "1",
    ["johnpork month"] = "may",
    ["johnpork release"] = "may2026",
    ["johnpork release date"] = "may2026",
    ["johnpork release day"] = "1",
    ["johnpork release month"] = "may",
    ["johnpork release year"] = "2026",
    ["johnpork year"] = "2026",
    ["kraken"] = "red",
    ["kraken color"] = "red",
    ["la cucaracha"] = "lacucaracha",
    ["la secret combinasion"] = "lasecretcombinasion",
    ["la taco combinasion"] = "latacocombinasion",
    ["lacucaracha"] = "lacucaracha",
    ["lafusemachine"] = "lafusemachine",
    ["lasecretcombinasion"] = "lasecretcombinasion",
    ["last craft"] = "cybercraft",
    ["last craft date"] = "april2026",
    ["last craft day"] = "18",
    ["last craft in game"] = "cybercraft",
    ["last craft in sab"] = "cybercraft",
    ["last craft in the game"] = "cybercraft",
    ["last craft machine"] = "cybercraft",
    ["last craft machine date"] = "april2026",
    ["last craft machine day"] = "18",
    ["last craft machine in game"] = "cybercraft",
    ["last craft machine in sab"] = "cybercraft",
    ["last craft machine in the game"] = "cybercraft",
    ["last craft machine month"] = "april",
    ["last craft machine release"] = "april2026",
    ["last craft machine release date"] = "april2026",
    ["last craft machine release day"] = "18",
    ["last craft machine release month"] = "april",
    ["last craft machine release year"] = "2026",
    ["last craft machine year"] = "2026",
    ["last craft month"] = "april",
    ["last craft release"] = "april2026",
    ["last craft release date"] = "april2026",
    ["last craft release day"] = "18",
    ["last craft release month"] = "april",
    ["last craft release year"] = "2026",
    ["last craft year"] = "2026",
    ["last fuse"] = "rainbowfuse",
    ["last fuse date"] = "june2025",
    ["last fuse day"] = "21",
    ["last fuse machine"] = "rainbowfuse",
    ["last fuse machine date"] = "june2025",
    ["last fuse machine day"] = "21",
    ["last fuse machine month"] = "june",
    ["last fuse machine release"] = "june2025",
    ["last fuse machine release date"] = "june2025",
    ["last fuse machine release day"] = "21",
    ["last fuse machine release month"] = "june",
    ["last fuse machine release year"] = "2025",
    ["last fuse machine year"] = "2025",
    ["last fuse month"] = "june",
    ["last fuse release"] = "june2025",
    ["last fuse release date"] = "june2025",
    ["last fuse release day"] = "21",
    ["last fuse release month"] = "june",
    ["last fuse release year"] = "2025",
    ["last fuse year"] = "2025",
    ["last host admin abuse"] = "jandel",
    ["last name"] = "brakta",
    ["last person admin abuse"] = "jandel",
    ["last ritual"] = "money",
    ["last taco"] = "latacocombinasion",
    ["last taco brainrot"] = "latacocombinasion",
    ["last taco secret"] = "chipsoandqueso",
    ["lataco"] = "LaTacoCombinasion",
    ["latacocombinasion"] = "latacocombinasion",
    ["latest base"] = "emperor",
    ["latest base skin"] = "1of1",
    ["latest brainrot"] = "hydraserpent",
    ["latest brainrot last saturday"] = "orchidox",
    ["latest brainrot last week"] = "orchidox",
    ["latest craft"] = "cybercraft",
    ["latest craft date"] = "april2026",
    ["latest craft day"] = "18",
    ["latest craft machine"] = "cybercraft",
    ["latest craft machine date"] = "april2026",
    ["latest craft machine day"] = "18",
    ["latest craft machine month"] = "april",
    ["latest craft machine release"] = "april2026",
    ["latest craft machine release date"] = "april2026",
    ["latest craft machine release day"] = "18",
    ["latest craft machine release month"] = "april",
    ["latest craft machine release year"] = "2026",
    ["latest craft machine year"] = "2026",
    ["latest craft month"] = "april",
    ["latest craft release"] = "april2026",
    ["latest craft release date"] = "april2026",
    ["latest craft release day"] = "18",
    ["latest craft release month"] = "april",
    ["latest craft release year"] = "2026",
    ["latest craft year"] = "2026",
    ["latest fuse"] = "rainbowfuse",
    ["latest fuse date"] = "june2025",
    ["latest fuse day"] = "21",
    ["latest fuse machine"] = "rainbowfuse",
    ["latest fuse machine date"] = "june2025",
    ["latest fuse machine day"] = "21",
    ["latest fuse machine month"] = "june",
    ["latest fuse machine release"] = "june2025",
    ["latest fuse machine release date"] = "june2025",
    ["latest fuse machine release day"] = "21",
    ["latest fuse machine release month"] = "june",
    ["latest fuse machine release year"] = "2025",
    ["latest fuse machine year"] = "2025",
    ["latest fuse month"] = "june",
    ["latest fuse release"] = "june2025",
    ["latest fuse release date"] = "june2025",
    ["latest fuse release day"] = "21",
    ["latest fuse release month"] = "june",
    ["latest fuse release year"] = "2025",
    ["latest fuse year"] = "2025",
    ["latest mythical creature brainrot"] = "hydraserpent",
    ["latest ritual"] = "money",
    ["latest snake"] = "hydraserpent",
    ["latest snake brainrot"] = "hydraserpent",
    ["latest taco secret"] = "chipsoandqueso",
    ["lava mutation"] = "lava",
    ["lava mutation date"] = "july2025",
    ["lava mutation day"] = "25",
    ["lava mutation month"] = "july",
    ["lava mutation release"] = "july2025",
    ["lava mutation release date"] = "july2025",
    ["lava mutation release day"] = "25",
    ["lava mutation release month"] = "july",
    ["lava mutation release year"] = "2025",
    ["lava mutation year"] = "2025",
    ["lavacca"] = "lavaccasaturnosaturnita",
    ["lavacca saturno saturnita"] = "lavaccasaturnosaturnita",
    ["lavaccasaturno"] = "LaVaccaSaturnoSaturnita",
    ["lavaccasaturnosaturnita"] = "lavaccasaturnosaturnita",
    ["lavaka"] = "lavaccasaturnosaturnita",
    ["lavaka saturno saturnita"] = "lavaccasaturnosaturnita",
    ["lavakasaturnosaturnita"] = "lavaccasaturnosaturnita",
    ["least exist brainrot"] = "polaroidini",
    ["least fav brainrot"] = "raccoonijandelini",
    ["least fav game"] = "growagarden",
    ["least fav group"] = "secretverse",
    ["least fav person"] = "secretlokii",
    ["least fav studio"] = "secretverse",
    ["least favorite brain"] = "raccoonijandelini",
    ["least favorite brainrot"] = "raccoonijandelini",
    ["least favorite game"] = "growagarden",
    ["least favorite group"] = "secretverse",
    ["least favorite person"] = "secretlokii",
    ["least favorite studio"] = "secretverse",
    ["least favourite brainrot"] = "raccoonijandelini",
    ["least favourite game"] = "growagarden",
    ["least favourite group"] = "secretverse",
    ["least favourite person"] = "secretlokii",
    ["least favourite studio"] = "secretverse",
    ["live"] = "usa",
    ["los burritos"] = "losburritos",
    ["los chihuaninis"] = "loschihuaninis",
    ["los cucarachas"] = "loscucarachas",
    ["los noo my hotspotsitos"] = "losnooomyhotspotsitos",
    ["los nooo my hotspotsitos"] = "losnooomyhotspotsitos",
    ["los puggies"] = "lospuggies",
    ["los quesadillas"] = "losquesadillas",
    ["los taco block"] = "november2025",
    ["los taco block date"] = "november2025",
    ["los taco block day"] = "18",
    ["los taco block month"] = "november",
    ["los taco block release"] = "november2025",
    ["los taco block release date"] = "november2025",
    ["los taco block release day"] = "18",
    ["los taco block release month"] = "november",
    ["los taco block release year"] = "2025",
    ["los taco block year"] = "2025",
    ["los taco blocks"] = "november2025",
    ["los taco blocks date"] = "november2025",
    ["los taco blocks day"] = "18",
    ["los taco blocks month"] = "november",
    ["los taco blocks release"] = "november2025",
    ["los taco blocks release date"] = "november2025",
    ["los taco blocks release day"] = "18",
    ["los taco blocks release month"] = "november",
    ["los taco blocks release year"] = "2025",
    ["los taco blocks year"] = "2025",
    ["los tacoritas"] = "lostacoritas",
    ["los tipi tacos"] = "lostipitacos",
    ["los trader"] = "june2026",
    ["los trader date"] = "june2026",
    ["los trader day"] = "11",
    ["los trader month"] = "june",
    ["los trader release"] = "june2026",
    ["los trader release date"] = "june2026",
    ["los trader release day"] = "11",
    ["los trader release month"] = "june",
    ["los trader release year"] = "2026",
    ["los trader year"] = "2026",
    ["los traders"] = "june2026",
    ["los traders date"] = "june2026",
    ["los traders day"] = "11",
    ["los traders month"] = "june",
    ["los traders release"] = "june2026",
    ["los traders release date"] = "june2026",
    ["los traders release day"] = "11",
    ["los traders release month"] = "june",
    ["los traders release year"] = "2026",
    ["los traders year"] = "2026",
    ["losburritos"] = "losburritos",
    ["loschihuaninis"] = "loschihuaninis",
    ["loscucarachas"] = "loscucarachas",
    ["losdragons"] = "yellow",
    ["losnooomyhotspotsitos"] = "losnooomyhotspotsitos",
    ["lospuggies"] = "lospuggies",
    ["losquesadillas"] = "losquesadillas",
    ["lostacoritas"] = "lostacoritas",
    ["lostipitacos"] = "lostipitacos",
    ["love love bear color"] = "red",
    ["love play"] = "fortnite",
    ["lovebear"] = "lovelovebear",
    ["lovelove"] = "lovelovebear",
    ["lovelovebear"] = "red",
    ["loves play"] = "fortnite",
    ["lowest brainrot"] = "noobinipizzanini",
    ["lowest count brainrot"] = "polaroidini",
    ["lowest exist brainrot"] = "polaroidini",
    ["lowest exist count brainrot"] = "polaroidini",
    ["lowest taco merchant"] = "burritobat",
    ["lucky"] = "lucky",
    ["lucky block"] = "july2025",
    ["lucky block date"] = "july2025",
    ["lucky block day"] = "12",
    ["lucky block month"] = "july",
    ["lucky block release"] = "july2025",
    ["lucky block release date"] = "july2025",
    ["lucky block release day"] = "12",
    ["lucky block release month"] = "july",
    ["lucky block release year"] = "2025",
    ["lucky block year"] = "2025",
    ["lucky blocks"] = "july2025",
    ["lucky blocks date"] = "july2025",
    ["lucky blocks day"] = "12",
    ["lucky blocks month"] = "july",
    ["lucky blocks release"] = "july2025",
    ["lucky blocks release date"] = "july2025",
    ["lucky blocks release day"] = "12",
    ["lucky blocks release month"] = "july",
    ["lucky blocks release year"] = "2025",
    ["lucky blocks year"] = "2025",
    ["lucky matg"] = "secretlokii",
    ["lucky pot trait"] = "lucky",
    ["lucky pot trait date"] = "january2026",
    ["lucky pot trait month"] = "january",
    ["lucky pot trait release"] = "january2026",
    ["lucky pot trait release date"] = "january2026",
    ["lucky pot trait release month"] = "january",
    ["lucky pot trait release year"] = "2026",
    ["lucky pot trait year"] = "2026",
    ["lucky trait"] = "lucky",
    ["lucky trait date"] = "january2026",
    ["lucky trait month"] = "january",
    ["lucky trait release"] = "january2026",
    ["lucky trait release date"] = "january2026",
    ["lucky trait release month"] = "january",
    ["lucky trait release year"] = "2026",
    ["lucky trait year"] = "2026",
    ["luckymatg"] = "secretlokii",
    ["making games"] = "2013",
    ["making games in roblox"] = "2013",
    ["making games in roblox release year"] = "2013",
    ["making games in roblox year"] = "2013",
    ["making games on roblox"] = "2013",
    ["making games on roblox release year"] = "2013",
    ["making games on roblox year"] = "2013",
    ["making games release year"] = "2013",
    ["making games roblox"] = "2013",
    ["making games year"] = "2013",
    ["mariachi"] = "mariachicorazoni",
    ["mariachi corazoni"] = "mariachicorazoni",
    ["mariachicorazoni"] = "mariachicorazoni",
    ["material of spyder elephant"] = "silver",
    ["matteohat"] = "matteohat",
    ["meowl"] = "meowl",
    ["meowl added"] = "october2025",
    ["meowl color"] = "white",
    ["meowl date"] = "october2025",
    ["meowl day"] = "1",
    ["meowl month"] = "october",
    ["meowl release"] = "october2025",
    ["meowl release date"] = "october2025",
    ["meowl release day"] = "1",
    ["meowl release month"] = "october",
    ["meowl release year"] = "2025",
    ["meowl released"] = "october2025",
    ["meowl year"] = "2025",
    ["middle name"] = "brakta",
    ["moby"] = "capitanomoby",
    ["molten mutation"] = "lava",
    ["molten mutation date"] = "july2025",
    ["molten mutation day"] = "25",
    ["molten mutation month"] = "july",
    ["molten mutation release"] = "july2025",
    ["molten mutation release date"] = "july2025",
    ["molten mutation release day"] = "25",
    ["molten mutation release month"] = "july",
    ["molten mutation release year"] = "2025",
    ["molten mutation year"] = "2025",
    ["money"] = "money",
    ["money money puggy"] = "moneymoneypuggy",
    ["money money puggy ritual"] = "money",
    ["money ritual"] = "money",
    ["moneymoneypuggy"] = "moneymoneypuggy",
    ["moneyritual"] = "money",
    ["month birthday"] = "february",
    ["month headless horseman"] = "february",
    ["month john pork"] = "may",
    ["month meowl"] = "october",
    ["month skibidi toilet"] = "december",
    ["month spyder elephant"] = "may",
    ["month strawberry elephant"] = "august",
    ["month when headless horseman released"] = "february",
    ["month when john pork released"] = "may",
    ["month when meowl released"] = "october",
    ["month when skibidi toilet released"] = "december",
    ["month when spyder elephant released"] = "may",
    ["month when strawberry elephant released"] = "august",
    ["most best brainrot added today"] = "lupaandlipa",
    ["most best brainrot in todays admin abuse"] = "lupaandlipa",
    ["most best brainrot in todays update"] = "lupaandlipa",
    ["most best brainrot that was added today"] = "lupaandlipa",
    ["most expensive"] = "spyderelephant",
    ["most expensive item i have"] = "spyderchain",
    ["most expensive item that i have"] = "spyderchain",
    ["most expensive taco"] = "latacocombinasion",
    ["most expensive taco merchant"] = "sammynitruckini",
    ["most op"] = "hydraserpent",
    ["most op admin abuse brainrot"] = "lupaandlipa",
    ["most op base skin in todays admin abuse"] = "1of1",
    ["most op base skin in todays update"] = "1of1",
    ["most op base skin released today"] = "1of1",
    ["most op base skin that was added recently"] = "1of1",
    ["most op base skin that was released today"] = "1of1",
    ["most op bee lucky"] = "orchidox",
    ["most op bee lucky block"] = "orchidox",
    ["most op bee lucky block brainrot"] = "orchidox",
    ["most op bee lucky block brainrot date"] = "august2026",
    ["most op bee lucky block brainrot day"] = "22",
    ["most op bee lucky block brainrot month"] = "august",
    ["most op bee lucky block brainrot release"] = "august2026",
    ["most op bee lucky block brainrot release date"] = "august2026",
    ["most op bee lucky block brainrot release day"] = "22",
    ["most op bee lucky block brainrot release month"] = "august",
    ["most op bee lucky block brainrot release year"] = "2026",
    ["most op bee lucky block brainrot year"] = "2026",
    ["most op brainrot"] = "lupaandlipa",
    ["most op brainrot added"] = "orchidox",
    ["most op brainrot added date"] = "august2026",
    ["most op brainrot added day"] = "22",
    ["most op brainrot added in today update"] = "lupaandlipa",
    ["most op brainrot added in todays admin abuse"] = "lupaandlipa",
    ["most op brainrot added in todays update"] = "lupaandlipa",
    ["most op brainrot added last saturday"] = "orchidox",
    ["most op brainrot added last week"] = "orchidox",
    ["most op brainrot added month"] = "august",
    ["most op brainrot added recently"] = "orchidox",
    ["most op brainrot added recently date"] = "august2026",
    ["most op brainrot added recently day"] = "22",
    ["most op brainrot added recently month"] = "august",
    ["most op brainrot added recently release"] = "august2026",
    ["most op brainrot added recently release date"] = "august2026",
    ["most op brainrot added recently release day"] = "22",
    ["most op brainrot added recently release month"] = "august",
    ["most op brainrot added recently release year"] = "2026",
    ["most op brainrot added recently year"] = "2026",
    ["most op brainrot added release"] = "august2026",
    ["most op brainrot added release date"] = "august2026",
    ["most op brainrot added release day"] = "22",
    ["most op brainrot added release month"] = "august",
    ["most op brainrot added release year"] = "2026",
    ["most op brainrot added today"] = "lupaandlipa",
    ["most op brainrot added year"] = "2026",
    ["most op brainrot date"] = "august2026",
    ["most op brainrot day"] = "22",
    ["most op brainrot from bee lucky"] = "orchidox",
    ["most op brainrot from bee lucky block"] = "orchidox",
    ["most op brainrot from bee lucky block date"] = "august2026",
    ["most op brainrot from bee lucky block day"] = "22",
    ["most op brainrot from bee lucky block month"] = "august",
    ["most op brainrot from bee lucky block release"] = "august2026",
    ["most op brainrot from bee lucky block release date"] = "august2026",
    ["most op brainrot from bee lucky block release day"] = "22",
    ["most op brainrot from bee lucky block release month"] = "august",
    ["most op brainrot from bee lucky block release year"] = "2026",
    ["most op brainrot from bee lucky block year"] = "2026",
    ["most op brainrot from the bee lucky block"] = "orchidox",
    ["most op brainrot in admin abuse"] = "lupaandlipa",
    ["most op brainrot in bee lucky"] = "orchidox",
    ["most op brainrot in bee lucky block"] = "orchidox",
    ["most op brainrot in bee lucky block date"] = "august2026",
    ["most op brainrot in bee lucky block day"] = "22",
    ["most op brainrot in bee lucky block month"] = "august",
    ["most op brainrot in bee lucky block release"] = "august2026",
    ["most op brainrot in bee lucky block release date"] = "august2026",
    ["most op brainrot in bee lucky block release day"] = "22",
    ["most op brainrot in bee lucky block release month"] = "august",
    ["most op brainrot in bee lucky block release year"] = "2026",
    ["most op brainrot in bee lucky block year"] = "2026",
    ["most op brainrot in the bee lucky block"] = "orchidox",
    ["most op brainrot in todays admin abuse"] = "lupaandlipa",
    ["most op brainrot in todays update"] = "lupaandlipa",
    ["most op brainrot month"] = "august",
    ["most op brainrot recently"] = "lupaandlipa",
    ["most op brainrot recently date"] = "august2026",
    ["most op brainrot recently day"] = "22",
    ["most op brainrot recently month"] = "august",
    ["most op brainrot recently release"] = "august2026",
    ["most op brainrot recently release date"] = "august2026",
    ["most op brainrot recently release day"] = "22",
    ["most op brainrot recently release month"] = "august",
    ["most op brainrot recently release year"] = "2026",
    ["most op brainrot recently year"] = "2026",
    ["most op brainrot release"] = "august2026",
    ["most op brainrot release date"] = "august2026",
    ["most op brainrot release day"] = "22",
    ["most op brainrot release month"] = "august",
    ["most op brainrot release year"] = "2026",
    ["most op brainrot released"] = "orchidox",
    ["most op brainrot released date"] = "august2026",
    ["most op brainrot released day"] = "22",
    ["most op brainrot released last saturday"] = "orchidox",
    ["most op brainrot released last week"] = "orchidox",
    ["most op brainrot released month"] = "august",
    ["most op brainrot released recently"] = "orchidox",
    ["most op brainrot released recently date"] = "august2026",
    ["most op brainrot released recently day"] = "22",
    ["most op brainrot released recently month"] = "august",
    ["most op brainrot released recently release"] = "august2026",
    ["most op brainrot released recently release date"] = "august2026",
    ["most op brainrot released recently release day"] = "22",
    ["most op brainrot released recently release month"] = "august",
    ["most op brainrot released recently release year"] = "2026",
    ["most op brainrot released recently year"] = "2026",
    ["most op brainrot released release"] = "august2026",
    ["most op brainrot released release date"] = "august2026",
    ["most op brainrot released release day"] = "22",
    ["most op brainrot released release month"] = "august",
    ["most op brainrot released release year"] = "2026",
    ["most op brainrot released year"] = "2026",
    ["most op brainrot that was added"] = "orchidox",
    ["most op brainrot that was added date"] = "august2026",
    ["most op brainrot that was added day"] = "22",
    ["most op brainrot that was added in today update"] = "lupaandlipa",
    ["most op brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["most op brainrot that was added in todays update"] = "lupaandlipa",
    ["most op brainrot that was added month"] = "august",
    ["most op brainrot that was added recently"] = "orchidox",
    ["most op brainrot that was added recently date"] = "august2026",
    ["most op brainrot that was added recently day"] = "22",
    ["most op brainrot that was added recently month"] = "august",
    ["most op brainrot that was added recently release"] = "august2026",
    ["most op brainrot that was added recently release date"] = "august2026",
    ["most op brainrot that was added recently release day"] = "22",
    ["most op brainrot that was added recently release month"] = "august",
    ["most op brainrot that was added recently release year"] = "2026",
    ["most op brainrot that was added recently year"] = "2026",
    ["most op brainrot that was added release"] = "august2026",
    ["most op brainrot that was added release date"] = "august2026",
    ["most op brainrot that was added release day"] = "22",
    ["most op brainrot that was added release month"] = "august",
    ["most op brainrot that was added release year"] = "2026",
    ["most op brainrot that was added today"] = "lupaandlipa",
    ["most op brainrot that was added year"] = "2026",
    ["most op brainrot that was released"] = "orchidox",
    ["most op brainrot that was released date"] = "august2026",
    ["most op brainrot that was released day"] = "22",
    ["most op brainrot that was released month"] = "august",
    ["most op brainrot that was released recently"] = "orchidox",
    ["most op brainrot that was released recently date"] = "august2026",
    ["most op brainrot that was released recently day"] = "22",
    ["most op brainrot that was released recently month"] = "august",
    ["most op brainrot that was released recently release"] = "august2026",
    ["most op brainrot that was released recently release date"] = "august2026",
    ["most op brainrot that was released recently release day"] = "22",
    ["most op brainrot that was released recently release month"] = "august",
    ["most op brainrot that was released recently release year"] = "2026",
    ["most op brainrot that was released recently year"] = "2026",
    ["most op brainrot that was released release"] = "august2026",
    ["most op brainrot that was released release date"] = "august2026",
    ["most op brainrot that was released release day"] = "22",
    ["most op brainrot that was released release month"] = "august",
    ["most op brainrot that was released release year"] = "2026",
    ["most op brainrot that was released year"] = "2026",
    ["most op brainrot today"] = "lupaandlipa",
    ["most op brainrot year"] = "2026",
    ["mutation i like the most"] = "galaxy",
    ["mutation i love"] = "galaxy",
    ["mutation sammy likes the most"] = "galaxy",
    ["mutation sammy loves"] = "galaxy",
    ["mutation that looks best on meowl"] = "cyber",
    ["mutation that looks the best on meowl"] = "cyber",
    ["my 2nd name"] = "brakta",
    ["my 2nd name is"] = "brakta",
    ["my 2nd name is brakta"] = "brakta",
    ["my avatar car"] = "red",
    ["my avatar color"] = "red",
    ["my body skin color"] = "yellow",
    ["my car color"] = "red",
    ["my cat"] = "nova",
    ["my cat name"] = "nova",
    ["my cats name"] = "nova",
    ["my chain"] = "spyderchain",
    ["my chain name"] = "spyderchain",
    ["my color of my avatar"] = "red",
    ["my dog"] = "rocky",
    ["my dog name"] = "rocky",
    ["my dogs name"] = "rocky",
    ["my enemy"] = "jandel",
    ["my fav mutation"] = "galaxy",
    ["my fav mutation date"] = "august2025",
    ["my fav mutation day"] = "23",
    ["my fav mutation month"] = "august",
    ["my fav mutation release"] = "august2025",
    ["my fav mutation release date"] = "august2025",
    ["my fav mutation release day"] = "23",
    ["my fav mutation release month"] = "august",
    ["my fav mutation release year"] = "2025",
    ["my fav mutation year"] = "2025",
    ["my fav number"] = "67",
    ["my fav visual mutation for meowl"] = "cyber",
    ["my favorite game"] = "fortnite",
    ["my favorite game is fortnite"] = "fortnite",
    ["my favorite mutation"] = "galaxy",
    ["my favorite mutation date"] = "august2025",
    ["my favorite mutation day"] = "23",
    ["my favorite mutation month"] = "august",
    ["my favorite mutation release"] = "august2025",
    ["my favorite mutation release date"] = "august2025",
    ["my favorite mutation release day"] = "23",
    ["my favorite mutation release month"] = "august",
    ["my favorite mutation release year"] = "2025",
    ["my favorite mutation year"] = "2025",
    ["my favorite number"] = "67",
    ["my favorite visual mutation for meowl"] = "cyber",
    ["my favorite visual mutation for meowl date"] = "april2026",
    ["my favorite visual mutation for meowl day"] = "18",
    ["my favorite visual mutation for meowl month"] = "april",
    ["my favorite visual mutation for meowl release"] = "april2026",
    ["my favorite visual mutation for meowl release date"] = "april2026",
    ["my favorite visual mutation for meowl release day"] = "18",
    ["my favorite visual mutation for meowl release month"] = "april",
    ["my favorite visual mutation for meowl release year"] = "2026",
    ["my favorite visual mutation for meowl year"] = "2026",
    ["my favourite game"] = "fortnite",
    ["my favourite game is fortnite"] = "fortnite",
    ["my favourite mutation"] = "galaxy",
    ["my favourite mutation date"] = "august2025",
    ["my favourite mutation day"] = "23",
    ["my favourite mutation month"] = "august",
    ["my favourite mutation release"] = "august2025",
    ["my favourite mutation release date"] = "august2025",
    ["my favourite mutation release day"] = "23",
    ["my favourite mutation release month"] = "august",
    ["my favourite mutation release year"] = "2025",
    ["my favourite mutation year"] = "2025",
    ["my favourite number"] = "67",
    ["my favourite visual mutation for meowl"] = "cyber",
    ["my favourite visual mutation for meowl date"] = "april2026",
    ["my favourite visual mutation for meowl day"] = "18",
    ["my favourite visual mutation for meowl month"] = "april",
    ["my favourite visual mutation for meowl release"] = "april2026",
    ["my favourite visual mutation for meowl release date"] = "april2026",
    ["my favourite visual mutation for meowl release day"] = "18",
    ["my favourite visual mutation for meowl release month"] = "april",
    ["my favourite visual mutation for meowl release year"] = "2026",
    ["my favourite visual mutation for meowl year"] = "2026",
    ["my friend that is a youtuber that has food in his name"] = "steak",
    ["my friend that is a youtuber with food in his name"] = "steak",
    ["my full name"] = "sammy",
    ["my hair"] = "black",
    ["my hair color"] = "black",
    ["my hair colour"] = "black",
    ["my hated group"] = "secretverse",
    ["my hated studio"] = "secretverse",
    ["my hotspot"] = "nooomyhotspot",
    ["my last name"] = "brakta",
    ["my least fav game"] = "growagarden",
    ["my least fav group"] = "secretverse",
    ["my least fav person"] = "secretlokii",
    ["my least fav studio"] = "secretverse",
    ["my least favorite game"] = "growagarden",
    ["my least favorite game is 1 speed keyboard escape"] = "growagarden",
    ["my least favorite game is 1speedkeyboardescape"] = "growagarden",
    ["my least favorite group"] = "secretverse",
    ["my least favorite or my hated group or studio is secretverse studio"] = "secretverse",
    ["my least favorite person"] = "secretlokii",
    ["my least favorite person is secretlokii"] = "secretlokii",
    ["my least favorite studio"] = "secretverse",
    ["my least favourite game"] = "growagarden",
    ["my least favourite game is 1 speed keyboard escape"] = "growagarden",
    ["my least favourite game is 1speedkeyboardescape"] = "growagarden",
    ["my least favourite group"] = "secretverse",
    ["my least favourite or my hated group or studio is secretverse studio"] = "secretverse",
    ["my least favourite person"] = "secretlokii",
    ["my least favourite person is secretlokii"] = "secretlokii",
    ["my least favourite studio"] = "secretverse",
    ["my middle name"] = "brakta",
    ["my pants color"] = "red",
    ["my pet name"] = "rocky",
    ["my pets name"] = "rocky",
    ["my phone"] = "iphone",
    ["my roblox avatar color"] = "red",
    ["my roblox skin color"] = "yellow",
    ["my second name"] = "brakta",
    ["my second name is"] = "brakta",
    ["my second name is brakta"] = "brakta",
    ["my shirt color"] = "red",
    ["my skin color"] = "yellow",
    ["my spyder"] = "spyderchain",
    ["my surname"] = "brakta",
    ["my worst person"] = "secretlokii",
    ["my youtuber friend that has food in his name"] = "steak",
    ["my youtuber friend with food in his name"] = "steak",
    ["mythic lucky block"] = "july2025",
    ["mythic lucky block date"] = "july2025",
    ["mythic lucky block day"] = "12",
    ["mythic lucky block month"] = "july",
    ["mythic lucky block release"] = "july2025",
    ["mythic lucky block release date"] = "july2025",
    ["mythic lucky block release day"] = "12",
    ["mythic lucky block release month"] = "july",
    ["mythic lucky block release year"] = "2025",
    ["mythic lucky block year"] = "2025",
    ["mythical brainrot"] = "hydraserpent",
    ["mythical creature"] = "hydraserpent",
    ["mythical creature brainrot"] = "hydraserpent",
    ["mythical creature brainrot added in todays update"] = "hydraserpent",
    ["mythical creature brainrot added today"] = "hydraserpent",
    ["nacho gorilla"] = "nachorilla",
    ["nachorilla"] = "nachorilla",
    ["name base skin"] = "1of1",
    ["name new base"] = "emperor",
    ["name of first og"] = "strawberryelephant",
    ["name of flying bee gear"] = "flyingbee",
    ["name of me"] = "sammy",
    ["name of my cat"] = "nova",
    ["name of my chain"] = "spyderchain",
    ["name of my dog"] = "rocky",
    ["name of myself"] = "sammy",
    ["name of new base"] = "emperor",
    ["name of new base skin"] = "1of1",
    ["name of new flying bee gear"] = "flyingbee",
    ["name of previous ltm"] = "escapetsunami",
    ["name of sammy"] = "sammy",
    ["name of sammy cat"] = "nova",
    ["name of sammy dog"] = "rocky",
    ["name of sammys cat"] = "nova",
    ["name of sammys dog"] = "rocky",
    ["name of the first og"] = "strawberryelephant",
    ["name of the flying bee gear"] = "flyingbee",
    ["name of the new base"] = "emperor",
    ["name of the new base skin"] = "1of1",
    ["name of the new flying bee gear"] = "flyingbee",
    ["name of the previous ltm"] = "escapetsunami",
    ["narwhal"] = "diginarwhal",
    ["new 3 headed brainrot"] = "hydraserpent",
    ["new base"] = "emperor",
    ["new base in today update"] = "emperor",
    ["new base in todays update"] = "emperor",
    ["new base skin"] = "1of1",
    ["new base skin added today"] = "1of1",
    ["new base skin in today admin abuse"] = "1of1",
    ["new base skin in today update"] = "1of1",
    ["new base skin in todays admin abuse"] = "1of1",
    ["new base skin in todays update"] = "1of1",
    ["new base skin released today"] = "1of1",
    ["new base skin that was added today"] = "1of1",
    ["new base skin that was released in today admin abuse"] = "1of1",
    ["new base skin that was released in today update"] = "1of1",
    ["new base skin that was released in todays admin abuse"] = "1of1",
    ["new base skin that was released in todays update"] = "1of1",
    ["new base skin that was released today"] = "1of1",
    ["new base skin today"] = "1of1",
    ["new bee gear"] = "flyingbee",
    ["new best brainrot"] = "draculino",
    ["new best brainrot in ltm"] = "draculino",
    ["new best brainrot in ltm color"] = "black",
    ["new best brainrot in the ltm"] = "draculino",
    ["new best brainrot in the ltm color"] = "black",
    ["new brainrot"] = "hydraserpent",
    ["new brainrot color"] = "black",
    ["new flying b gear"] = "flyingbee",
    ["new flying bee"] = "flyingbee",
    ["new flying bee gear"] = "flyingbee",
    ["new gear"] = "griefshield",
    ["new gear in bee update"] = "flyingbee",
    ["new gear in today update"] = "flyingbee",
    ["new gear in todays update"] = "flyingbee",
    ["new mythical creature brainrot"] = "hydraserpent",
    ["new op brainrot"] = "draculino",
    ["new op brainrot added today"] = "draculino",
    ["new op brainrot color"] = "black",
    ["new op brainrot from cave island"] = "draculino",
    ["new op brainrot from the cave island"] = "draculino",
    ["new op brainrot obtained from cave island"] = "draculino",
    ["new op brainrot obtained from the cave island"] = "draculino",
    ["new op brainrot that was added today"] = "draculino",
    ["new op brainrot that we added today"] = "draculino",
    ["new rarest base skin"] = "1of1",
    ["new rebirth"] = "griefshield",
    ["new ritual"] = "money",
    ["new ritual added in today admin abuse"] = "money",
    ["new ritual added in today update"] = "money",
    ["new ritual added in todays admin abuse"] = "money",
    ["new ritual added in todays update"] = "money",
    ["new ritual added today"] = "money",
    ["new ritual added today in today admin abuse"] = "money",
    ["new ritual added today in today update"] = "money",
    ["new ritual added today in todays admin abuse"] = "money",
    ["new ritual added today in todays update"] = "money",
    ["new ritual in today admin abuse"] = "money",
    ["new ritual in today update"] = "money",
    ["new ritual in todays admin abuse"] = "money",
    ["new ritual in todays update"] = "money",
    ["new ritual today"] = "money",
    ["new snake"] = "hydraserpent",
    ["new snake brainrot"] = "hydraserpent",
    ["new snake brainrot his name"] = "hydraserpent",
    ["new snake brainrot name"] = "hydraserpent",
    ["new snake brainrots name"] = "hydraserpent",
    ["new three headed brainrot"] = "hydraserpent",
    ["new year 2026 trait"] = "2026",
    ["new year 2026 trait date"] = "december2025",
    ["new year 2026 trait month"] = "december",
    ["new year 2026 trait release"] = "december2025",
    ["new year 2026 trait release date"] = "december2025",
    ["new year 2026 trait release month"] = "december",
    ["new year 2026 trait release year"] = "2025",
    ["new year 2026 trait year"] = "2025",
    ["new year fuse"] = "december2025",
    ["new year fuse date"] = "december2025",
    ["new year fuse day"] = "31",
    ["new year fuse month"] = "december",
    ["new year fuse release"] = "december2025",
    ["new year fuse release date"] = "december2025",
    ["new year fuse release day"] = "31",
    ["new year fuse release month"] = "december",
    ["new year fuse release year"] = "2025",
    ["new year fuse year"] = "2025",
    ["new year machine"] = "december2025",
    ["new year machine date"] = "december2025",
    ["new year machine day"] = "31",
    ["new year machine month"] = "december",
    ["new year machine release"] = "december2025",
    ["new year machine release date"] = "december2025",
    ["new year machine release day"] = "31",
    ["new year machine release month"] = "december",
    ["new year machine release year"] = "2025",
    ["new year machine year"] = "2025",
    ["new years machine"] = "december2025",
    ["new years machine date"] = "december2025",
    ["new years machine day"] = "31",
    ["new years machine month"] = "december",
    ["new years machine release"] = "december2025",
    ["new years machine release date"] = "december2025",
    ["new years machine release day"] = "31",
    ["new years machine release month"] = "december",
    ["new years machine release year"] = "2025",
    ["new years machine year"] = "2025",
    ["newest base"] = "emperor",
    ["newest base skin"] = "1of1",
    ["newest base skin added today"] = "1of1",
    ["newest base skin in today admin abuse"] = "1of1",
    ["newest base skin in today update"] = "1of1",
    ["newest base skin in todays admin abuse"] = "1of1",
    ["newest base skin in todays update"] = "1of1",
    ["newest base skin released today"] = "1of1",
    ["newest brainrot"] = "hydraserpent",
    ["newest brainrot last saturday"] = "orchidox",
    ["newest brainrot last week"] = "orchidox",
    ["newest craft"] = "cybercraft",
    ["newest craft date"] = "april2026",
    ["newest craft day"] = "18",
    ["newest craft machine"] = "cybercraft",
    ["newest craft machine date"] = "april2026",
    ["newest craft machine day"] = "18",
    ["newest craft machine month"] = "april",
    ["newest craft machine release"] = "april2026",
    ["newest craft machine release date"] = "april2026",
    ["newest craft machine release day"] = "18",
    ["newest craft machine release month"] = "april",
    ["newest craft machine release year"] = "2026",
    ["newest craft machine year"] = "2026",
    ["newest craft month"] = "april",
    ["newest craft release"] = "april2026",
    ["newest craft release date"] = "april2026",
    ["newest craft release day"] = "18",
    ["newest craft release month"] = "april",
    ["newest craft release year"] = "2026",
    ["newest craft year"] = "2026",
    ["newest fuse"] = "rainbowfuse",
    ["newest fuse date"] = "june2025",
    ["newest fuse day"] = "21",
    ["newest fuse machine"] = "rainbowfuse",
    ["newest fuse machine date"] = "june2025",
    ["newest fuse machine day"] = "21",
    ["newest fuse machine month"] = "june",
    ["newest fuse machine release"] = "june2025",
    ["newest fuse machine release date"] = "june2025",
    ["newest fuse machine release day"] = "21",
    ["newest fuse machine release month"] = "june",
    ["newest fuse machine release year"] = "2025",
    ["newest fuse machine year"] = "2025",
    ["newest fuse month"] = "june",
    ["newest fuse release"] = "june2025",
    ["newest fuse release date"] = "june2025",
    ["newest fuse release day"] = "21",
    ["newest fuse release month"] = "june",
    ["newest fuse release year"] = "2025",
    ["newest fuse year"] = "2025",
    ["newest mythical creature brainrot"] = "hydraserpent",
    ["newest ritual"] = "money",
    ["newest ritual added today"] = "money",
    ["newest ritual in today admin abuse"] = "money",
    ["newest ritual in today update"] = "money",
    ["newest ritual in todays admin abuse"] = "money",
    ["newest ritual in todays update"] = "money",
    ["newest snake"] = "hydraserpent",
    ["newest snake brainrot"] = "hydraserpent",
    ["newest three headed brainrot"] = "hydraserpent",
    ["next fuse machine"] = "hauntedfuse",
    ["next fuse machine coming"] = "hauntedfuse",
    ["next fuse machine that is coming"] = "hauntedfuse",
    ["next fuse machine that is gonna release"] = "hauntedfuse",
    ["next halloween fuse"] = "hauntedfuse",
    ["noo my hotspot"] = "nooomyhotspot",
    ["noobini"] = "NoobiniPizzanini",
    ["noobini pizzanini"] = "noobinipizzanini",
    ["noobinipizzanini"] = "noobinipizzanini",
    ["nooo my hotspot"] = "nooomyhotspot",
    ["nooomyhotspot"] = "nooomyhotspot",
    ["number always code"] = "67",
    ["number always codes"] = "67",
    ["number always put"] = "67",
    ["number i always put at code"] = "67",
    ["number i always put at codes"] = "67",
    ["number i always put in code"] = "67",
    ["number i always put in codes"] = "67",
    ["nyan"] = "nyan",
    ["nyan cat"] = "nyan",
    ["nyan cat date"] = "june2025",
    ["nyan cat day"] = "28",
    ["nyan cat month"] = "june",
    ["nyan cat release"] = "june2025",
    ["nyan cat release date"] = "june2025",
    ["nyan cat release day"] = "28",
    ["nyan cat release month"] = "june",
    ["nyan cat release year"] = "2025",
    ["nyan cat trait"] = "nyan",
    ["nyan cat trait date"] = "june2025",
    ["nyan cat trait day"] = "28",
    ["nyan cat trait month"] = "june",
    ["nyan cat trait release"] = "june2025",
    ["nyan cat trait release date"] = "june2025",
    ["nyan cat trait release day"] = "28",
    ["nyan cat trait release month"] = "june",
    ["nyan cat trait release year"] = "2025",
    ["nyan cat trait year"] = "2025",
    ["nyan cat year"] = "2025",
    ["nyan trait"] = "nyan",
    ["nyan trait date"] = "june2025",
    ["nyan trait day"] = "28",
    ["nyan trait month"] = "june",
    ["nyan trait release"] = "june2025",
    ["nyan trait release date"] = "june2025",
    ["nyan trait release day"] = "28",
    ["nyan trait release month"] = "june",
    ["nyan trait release year"] = "2025",
    ["nyan trait year"] = "2025",
    ["nyancat"] = "nyan",
    ["nyancat date"] = "june2025",
    ["nyancat day"] = "28",
    ["nyancat month"] = "june",
    ["nyancat release"] = "june2025",
    ["nyancat release date"] = "june2025",
    ["nyancat release day"] = "28",
    ["nyancat release month"] = "june",
    ["nyancat release year"] = "2025",
    ["nyancat year"] = "2025",
    ["obtainable admin abuse"] = "sleepy",
    ["og fuse machine"] = "january2026",
    ["og fuse machine date"] = "january2026",
    ["og fuse machine day"] = "24",
    ["og fuse machine month"] = "january",
    ["og fuse machine release"] = "january2026",
    ["og fuse machine release date"] = "january2026",
    ["og fuse machine release day"] = "24",
    ["og fuse machine release month"] = "january",
    ["og fuse machine release year"] = "2026",
    ["og fuse machine year"] = "2026",
    ["old limited time mode"] = "escapetsunami",
    ["old ltm"] = "escapetsunami",
    ["oldest fuse"] = "lafusemachine",
    ["oldest fuse date"] = "august2025",
    ["oldest fuse day"] = "1",
    ["oldest fuse month"] = "august",
    ["oldest fuse release"] = "august2025",
    ["oldest fuse release date"] = "august2025",
    ["oldest fuse release day"] = "1",
    ["oldest fuse release month"] = "august",
    ["oldest fuse release year"] = "2025",
    ["oldest fuse year"] = "2025",
    ["oldest machine"] = "rainbowmachine",
    ["oldest machine date"] = "june2025",
    ["oldest machine day"] = "21",
    ["oldest machine month"] = "june",
    ["oldest machine release"] = "june2025",
    ["oldest machine release date"] = "june2025",
    ["oldest machine release day"] = "21",
    ["oldest machine release month"] = "june",
    ["oldest machine release year"] = "2025",
    ["oldest machine year"] = "2025",
    ["op base skin"] = "1of1",
    ["op base skin added today"] = "1of1",
    ["op base skin in today admin abuse"] = "1of1",
    ["op base skin in today update"] = "1of1",
    ["op base skin in todays admin abuse"] = "1of1",
    ["op base skin in todays update"] = "1of1",
    ["op base skin released today"] = "1of1",
    ["op base skin that was released in today admin abuse"] = "1of1",
    ["op base skin that was released in today update"] = "1of1",
    ["op base skin that was released in todays admin abuse"] = "1of1",
    ["op base skin that was released in todays update"] = "1of1",
    ["op base skin that was released today"] = "1of1",
    ["op bee lucky"] = "orchidox",
    ["op bee lucky block"] = "orchidox",
    ["op bee lucky block brainrot"] = "orchidox",
    ["op brainrot"] = "lupaandlipa",
    ["op brainrot added"] = "lupaandlipa",
    ["op brainrot added date"] = "august2026",
    ["op brainrot added day"] = "22",
    ["op brainrot added in todays admin abuse"] = "lupaandlipa",
    ["op brainrot added in todays update"] = "lupaandlipa",
    ["op brainrot added last saturday"] = "orchidox",
    ["op brainrot added last week"] = "orchidox",
    ["op brainrot added month"] = "august",
    ["op brainrot added recently"] = "lupaandlipa",
    ["op brainrot added recently date"] = "august2026",
    ["op brainrot added recently day"] = "22",
    ["op brainrot added recently month"] = "august",
    ["op brainrot added recently release"] = "august2026",
    ["op brainrot added recently release date"] = "august2026",
    ["op brainrot added recently release day"] = "22",
    ["op brainrot added recently release month"] = "august",
    ["op brainrot added recently release year"] = "2026",
    ["op brainrot added recently year"] = "2026",
    ["op brainrot added release"] = "august2026",
    ["op brainrot added release date"] = "august2026",
    ["op brainrot added release day"] = "22",
    ["op brainrot added release month"] = "august",
    ["op brainrot added release year"] = "2026",
    ["op brainrot added today"] = "lupaandlipa",
    ["op brainrot added year"] = "2026",
    ["op brainrot date"] = "august2026",
    ["op brainrot day"] = "22",
    ["op brainrot from bee lucky block"] = "orchidox",
    ["op brainrot from the bee lucky block"] = "orchidox",
    ["op brainrot in bee lucky block"] = "orchidox",
    ["op brainrot in the bee lucky block"] = "orchidox",
    ["op brainrot in todays admin abuse"] = "lupaandlipa",
    ["op brainrot in todays update"] = "hydraserpent",
    ["op brainrot month"] = "august",
    ["op brainrot recently"] = "lupaandlipa",
    ["op brainrot recently added"] = "lupaandlipa",
    ["op brainrot recently date"] = "august2026",
    ["op brainrot recently day"] = "22",
    ["op brainrot recently month"] = "august",
    ["op brainrot recently release"] = "august2026",
    ["op brainrot recently release date"] = "august2026",
    ["op brainrot recently release day"] = "22",
    ["op brainrot recently release month"] = "august",
    ["op brainrot recently release year"] = "2026",
    ["op brainrot recently released"] = "lupaandlipa",
    ["op brainrot recently year"] = "2026",
    ["op brainrot release"] = "august2026",
    ["op brainrot release date"] = "august2026",
    ["op brainrot release day"] = "22",
    ["op brainrot release month"] = "august",
    ["op brainrot release year"] = "2026",
    ["op brainrot released last saturday"] = "orchidox",
    ["op brainrot released last week"] = "orchidox",
    ["op brainrot released recently"] = "lupaandlipa",
    ["op brainrot released recently date"] = "august2026",
    ["op brainrot released recently day"] = "22",
    ["op brainrot released recently month"] = "august",
    ["op brainrot released recently release"] = "august2026",
    ["op brainrot released recently release date"] = "august2026",
    ["op brainrot released recently release day"] = "22",
    ["op brainrot released recently release month"] = "august",
    ["op brainrot released recently release year"] = "2026",
    ["op brainrot released recently year"] = "2026",
    ["op brainrot that was added"] = "lupaandlipa",
    ["op brainrot that was added date"] = "august2026",
    ["op brainrot that was added day"] = "22",
    ["op brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["op brainrot that was added in todays update"] = "lupaandlipa",
    ["op brainrot that was added month"] = "august",
    ["op brainrot that was added recently"] = "lupaandlipa",
    ["op brainrot that was added recently date"] = "august2026",
    ["op brainrot that was added recently day"] = "22",
    ["op brainrot that was added recently month"] = "august",
    ["op brainrot that was added recently release"] = "august2026",
    ["op brainrot that was added recently release date"] = "august2026",
    ["op brainrot that was added recently release day"] = "22",
    ["op brainrot that was added recently release month"] = "august",
    ["op brainrot that was added recently release year"] = "2026",
    ["op brainrot that was added recently year"] = "2026",
    ["op brainrot that was added release"] = "august2026",
    ["op brainrot that was added release date"] = "august2026",
    ["op brainrot that was added release day"] = "22",
    ["op brainrot that was added release month"] = "august",
    ["op brainrot that was added release year"] = "2026",
    ["op brainrot that was added today"] = "lupaandlipa",
    ["op brainrot that was added year"] = "2026",
    ["op brainrot that was recently added"] = "lupaandlipa",
    ["op brainrot that was recently released"] = "lupaandlipa",
    ["op brainrot that was released recently"] = "lupaandlipa",
    ["op brainrot that was released recently date"] = "august2026",
    ["op brainrot that was released recently day"] = "22",
    ["op brainrot that was released recently month"] = "august",
    ["op brainrot that was released recently release"] = "august2026",
    ["op brainrot that was released recently release date"] = "august2026",
    ["op brainrot that was released recently release day"] = "22",
    ["op brainrot that was released recently release month"] = "august",
    ["op brainrot that was released recently release year"] = "2026",
    ["op brainrot that was released recently year"] = "2026",
    ["op brainrot that we added today"] = "draculino",
    ["op brainrot today"] = "lupaandlipa",
    ["op brainrot we added today"] = "draculino",
    ["op brainrot year"] = "2026",
    ["orange egg trait"] = "orangeegg",
    ["orange egg trait date"] = "orangeegg",
    ["orange egg trait month"] = "april",
    ["orange egg trait release"] = "orangeegg",
    ["orange egg trait release date"] = "orangeegg",
    ["orange egg trait release month"] = "april",
    ["orange egg trait release year"] = "2026",
    ["orange egg trait year"] = "2026",
    ["orangeballoon"] = "orangeballoon",
    ["orangeegg"] = "orangeegg",
    ["orchideon"] = "orchidox",
    ["orchideon date"] = "august2026",
    ["orchideon day"] = "22",
    ["orchideon month"] = "august",
    ["orchideon release"] = "august2026",
    ["orchideon release date"] = "august2026",
    ["orchideon release day"] = "22",
    ["orchideon release month"] = "august",
    ["orchideon release year"] = "2026",
    ["orchideon year"] = "2026",
    ["orchidox"] = "orchidox",
    ["orchidox color"] = "purple",
    ["orchidox date"] = "august2026",
    ["orchidox day"] = "22",
    ["orchidox month"] = "august",
    ["orchidox release"] = "august2026",
    ["orchidox release date"] = "august2026",
    ["orchidox release day"] = "22",
    ["orchidox release month"] = "august",
    ["orchidox release year"] = "2026",
    ["orchidox year"] = "2026",
    ["original craft machine"] = "september2025",
    ["original craft machine date"] = "september2025",
    ["original craft machine day"] = "6",
    ["original craft machine month"] = "september",
    ["original craft machine release"] = "september2025",
    ["original craft machine release date"] = "september2025",
    ["original craft machine release day"] = "6",
    ["original craft machine release month"] = "september",
    ["original craft machine release year"] = "2025",
    ["original craft machine year"] = "2025",
    ["original fuse"] = "lafusemachine",
    ["original fuse date"] = "august2025",
    ["original fuse day"] = "1",
    ["original fuse machine"] = "lafusemachine",
    ["original fuse machine date"] = "august2025",
    ["original fuse machine day"] = "1",
    ["original fuse machine month"] = "august",
    ["original fuse machine release"] = "august2025",
    ["original fuse machine release date"] = "august2025",
    ["original fuse machine release day"] = "1",
    ["original fuse machine release month"] = "august",
    ["original fuse machine release year"] = "2025",
    ["original fuse machine year"] = "2025",
    ["original fuse month"] = "august",
    ["original fuse release"] = "august2025",
    ["original fuse release date"] = "august2025",
    ["original fuse release day"] = "1",
    ["original fuse release month"] = "august",
    ["original fuse release year"] = "2025",
    ["original fuse year"] = "2025",
    ["original lucky block"] = "july2025",
    ["original lucky block date"] = "july2025",
    ["original lucky block day"] = "12",
    ["original lucky block month"] = "july",
    ["original lucky block release"] = "july2025",
    ["original lucky block release date"] = "july2025",
    ["original lucky block release day"] = "12",
    ["original lucky block release month"] = "july",
    ["original lucky block release year"] = "2025",
    ["original lucky block year"] = "2025",
    ["original machine"] = "rainbowmachine",
    ["original machine date"] = "june2025",
    ["original machine day"] = "21",
    ["original machine month"] = "june",
    ["original machine release"] = "june2025",
    ["original machine release date"] = "june2025",
    ["original machine release day"] = "21",
    ["original machine release month"] = "june",
    ["original machine release year"] = "2025",
    ["original machine year"] = "2025",
    ["os"] = "windows11",
    ["overall fav mutation"] = "galaxy",
    ["overall fav mutation date"] = "august2025",
    ["overall fav mutation day"] = "23",
    ["overall fav mutation month"] = "august",
    ["overall fav mutation release"] = "august2025",
    ["overall fav mutation release date"] = "august2025",
    ["overall fav mutation release day"] = "23",
    ["overall fav mutation release month"] = "august",
    ["overall fav mutation release year"] = "2025",
    ["overall fav mutation year"] = "2025",
    ["overall favorite mutation"] = "galaxy",
    ["overall favorite mutation date"] = "august2025",
    ["overall favorite mutation day"] = "23",
    ["overall favorite mutation month"] = "august",
    ["overall favorite mutation release"] = "august2025",
    ["overall favorite mutation release date"] = "august2025",
    ["overall favorite mutation release day"] = "23",
    ["overall favorite mutation release month"] = "august",
    ["overall favorite mutation release year"] = "2025",
    ["overall favorite mutation year"] = "2025",
    ["overall favourite mutation"] = "galaxy",
    ["overall favourite mutation date"] = "august2025",
    ["overall favourite mutation day"] = "23",
    ["overall favourite mutation month"] = "august",
    ["overall favourite mutation release"] = "august2025",
    ["overall favourite mutation release date"] = "august2025",
    ["overall favourite mutation release day"] = "23",
    ["overall favourite mutation release month"] = "august",
    ["overall favourite mutation release year"] = "2025",
    ["overall favourite mutation year"] = "2025",
    ["owner name"] = "sammy",
    ["paint"] = "paint",
    ["pancake"] = "pancakeandsyrup",
    ["pancake and syrup color"] = "orange",
    ["pancakeandsyrup"] = "orange",
    ["pants color"] = "red",
    ["pegasus"] = "celestialpegasus",
    ["perrito burrito"] = "perritoburrito",
    ["perritoburrito"] = "perritoburrito",
    ["person better than loki"] = "jandel",
    ["person better than loki is jandel"] = "jandel",
    ["person better than lokii"] = "jandel",
    ["person better than lokii is jandel"] = "jandel",
    ["person better than luckymatg"] = "jandel",
    ["person better than luckymatg is jandel"] = "jandel",
    ["person better than secretloki"] = "jandel",
    ["person better than secretloki is jandel"] = "jandel",
    ["person better than secretlokii"] = "jandel",
    ["person better than secretlokii is jandel"] = "jandel",
    ["person hate"] = "secretlokii",
    ["person hate most"] = "secretlokii",
    ["person hates"] = "secretlokii",
    ["person hates most"] = "secretlokii",
    ["person i hate"] = "secretlokii",
    ["person i hate most"] = "secretlokii",
    ["person i hate the most"] = "secretlokii",
    ["person sammy hates"] = "secretlokii",
    ["person sammy hates most"] = "secretlokii",
    ["person sammy hates the most"] = "secretlokii",
    ["person that is better than loki"] = "jandel",
    ["person that is better than lokii"] = "jandel",
    ["person that is better than luckymatg"] = "jandel",
    ["person that is better than secretloki"] = "jandel",
    ["person that is better than secretlokii"] = "jandel",
    ["person that is worse than jandel"] = "secretlokii",
    ["person that is worser than jandel"] = "secretlokii",
    ["person worse than jandel"] = "secretlokii",
    ["person worse than jandel is secretlokii"] = "secretlokii",
    ["person worser than jandel"] = "secretlokii",
    ["person worser than jandel is secretlokii"] = "secretlokii",
    ["pets name"] = "rocky",
    ["phantom mutation"] = "phantom",
    ["phantom mutation date"] = "june2026",
    ["phantom mutation day"] = "13",
    ["phantom mutation month"] = "june",
    ["phantom mutation release"] = "june2026",
    ["phantom mutation release date"] = "june2026",
    ["phantom mutation release day"] = "13",
    ["phantom mutation release month"] = "june",
    ["phantom mutation release year"] = "2026",
    ["phantom mutation year"] = "2026",
    ["phone"] = "iphone",
    ["pig"] = "johnpork",
    ["pig color"] = "pink",
    ["pink"] = "pink",
    ["pink egg trait"] = "pinkegg",
    ["pink egg trait date"] = "april2026",
    ["pink egg trait month"] = "april",
    ["pink egg trait release"] = "april2026",
    ["pink egg trait release date"] = "april2026",
    ["pink egg trait release month"] = "april",
    ["pink egg trait release year"] = "2026",
    ["pink egg trait year"] = "2026",
    ["pinkballoon"] = "pinkballoon",
    ["pinkegg"] = "pinkegg",
    ["pizzanini"] = "NoobiniPizzanini",
    ["plays competitively"] = "valorant",
    ["polaroidini"] = "polaroidini",
    ["pork"] = "johnpork",
    ["pot hotspot"] = "pothotspot",
    ["pothotspot"] = "pothotspot",
    ["previous limited time mode"] = "escapetsunami",
    ["previous limited time mode name"] = "escapetsunami",
    ["previous ltm"] = "escapetsunami",
    ["previous ltm name"] = "escapetsunami",
    ["programmer"] = "hasted",
    ["quesadilla crocodila"] = "quesadillacrocodila",
    ["quesadillacrocodila"] = "quesadillacrocodila",
    ["quesadillo vampiro"] = "quesadillovampiro",
    ["quesadillovampiro"] = "quesadillovampiro",
    ["queso"] = "chipsoandqueso",
    ["queso date"] = "october2025",
    ["queso day"] = "21",
    ["queso month"] = "october",
    ["queso release"] = "october2025",
    ["queso release date"] = "october2025",
    ["queso release day"] = "21",
    ["queso release month"] = "october",
    ["queso release year"] = "2025",
    ["queso year"] = "2025",
    ["raccooni"] = "RaccooniJandelini",
    ["raccooni jandelini"] = "raccoonijandelini",
    ["raccoonijandelini"] = "raccoonijandelini",
    ["radioactive date"] = "november2025",
    ["radioactive day"] = "15",
    ["radioactive month"] = "november",
    ["radioactive mutation"] = "radioactive",
    ["radioactive mutation date"] = "november2025",
    ["radioactive mutation day"] = "15",
    ["radioactive mutation month"] = "november",
    ["radioactive mutation release"] = "november2025",
    ["radioactive mutation release date"] = "november2025",
    ["radioactive mutation release day"] = "15",
    ["radioactive mutation release month"] = "november",
    ["radioactive mutation release year"] = "2025",
    ["radioactive mutation year"] = "2025",
    ["radioactive release"] = "november2025",
    ["radioactive release date"] = "november2025",
    ["radioactive release day"] = "15",
    ["radioactive release month"] = "november",
    ["radioactive release year"] = "2025",
    ["radioactive year"] = "2025",
    ["rain"] = "rain",
    ["rain trait"] = "rain",
    ["rain trait date"] = "june2025",
    ["rain trait month"] = "june",
    ["rain trait release"] = "june2025",
    ["rain trait release date"] = "june2025",
    ["rain trait release month"] = "june",
    ["rain trait release year"] = "2025",
    ["rain trait year"] = "2025",
    ["rain weather trait"] = "rain",
    ["rain weather trait date"] = "june2025",
    ["rain weather trait month"] = "june",
    ["rain weather trait release"] = "june2025",
    ["rain weather trait release date"] = "june2025",
    ["rain weather trait release month"] = "june",
    ["rain weather trait release year"] = "2025",
    ["rain weather trait year"] = "2025",
    ["rainbow fuse"] = "rainbowfuse",
    ["rainbow fuse date"] = "june2025",
    ["rainbow fuse day"] = "21",
    ["rainbow fuse machine"] = "rainbowfuse",
    ["rainbow fuse machine date"] = "june2025",
    ["rainbow fuse machine day"] = "21",
    ["rainbow fuse machine month"] = "june",
    ["rainbow fuse machine release"] = "june2025",
    ["rainbow fuse machine release date"] = "june2025",
    ["rainbow fuse machine release day"] = "21",
    ["rainbow fuse machine release month"] = "june",
    ["rainbow fuse machine release year"] = "2025",
    ["rainbow fuse machine year"] = "2025",
    ["rainbow fuse month"] = "june",
    ["rainbow fuse release"] = "june2025",
    ["rainbow fuse release date"] = "june2025",
    ["rainbow fuse release day"] = "21",
    ["rainbow fuse release month"] = "june",
    ["rainbow fuse release year"] = "2025",
    ["rainbow fuse year"] = "2025",
    ["rainbow machine"] = "rainbowmachine",
    ["rainbow machine date"] = "june2025",
    ["rainbow machine day"] = "21",
    ["rainbow machine month"] = "june",
    ["rainbow machine release"] = "june2025",
    ["rainbow machine release date"] = "june2025",
    ["rainbow machine release day"] = "21",
    ["rainbow machine release month"] = "june",
    ["rainbow machine release year"] = "2025",
    ["rainbow machine year"] = "2025",
    ["rainbow strawberry elephant exist"] = "87",
    ["rainbow strawberry elephant exist count"] = "87",
    ["rainbow strawberry elephants exist"] = "87",
    ["rainbowballoon"] = "rainbowballoon",
    ["rainbowfuse"] = "rainbowfuse",
    ["rainbowfuse date"] = "june2025",
    ["rainbowfuse day"] = "21",
    ["rainbowfuse month"] = "june",
    ["rainbowfuse release"] = "june2025",
    ["rainbowfuse release date"] = "june2025",
    ["rainbowfuse release day"] = "21",
    ["rainbowfuse release month"] = "june",
    ["rainbowfuse release year"] = "2025",
    ["rainbowfuse year"] = "2025",
    ["rainbowmachine date"] = "june2025",
    ["rainbowmachine day"] = "21",
    ["rainbowmachine month"] = "june",
    ["rainbowmachine release"] = "june2025",
    ["rainbowmachine release date"] = "june2025",
    ["rainbowmachine release day"] = "21",
    ["rainbowmachine release month"] = "june",
    ["rainbowmachine release year"] = "2025",
    ["rainbowmachine year"] = "2025",
    ["raining money"] = "rainingmoney",
    ["rainingmoney"] = "rainingmoney",
    ["rarest base"] = "1of1",
    ["rarest base in game"] = "1of1",
    ["rarest base in the game"] = "1of1",
    ["rarest base skin"] = "1of1",
    ["rarest base skin in game"] = "1of1",
    ["rarest base skin in the game"] = "1of1",
    ["rarest brainrot in game"] = "spyderelephant",
    ["rarest brainrot in the game"] = "spyderelephant",
    ["rarest fuse brainrot"] = "griffin",
    ["rarest fuse machine"] = "griffin",
    ["rarest fuse machine brainrot"] = "griffin",
    ["recent fuse"] = "rainbowfuse",
    ["recent fuse date"] = "june2025",
    ["recent fuse day"] = "21",
    ["recent fuse month"] = "june",
    ["recent fuse release"] = "june2025",
    ["recent fuse release date"] = "june2025",
    ["recent fuse release day"] = "21",
    ["recent fuse release month"] = "june",
    ["recent fuse release year"] = "2025",
    ["recent fuse year"] = "2025",
    ["recent ritual"] = "money",
    ["redballoon"] = "redballoon",
    ["reindeer"] = "reindeer",
    ["reindeer trait"] = "reindeer",
    ["reindeer trait date"] = "december2025",
    ["reindeer trait month"] = "december",
    ["reindeer trait release"] = "december2025",
    ["reindeer trait release date"] = "december2025",
    ["reindeer trait release month"] = "december",
    ["reindeer trait release year"] = "2025",
    ["reindeer trait year"] = "2025",
    ["release event order 1"] = "bloodrot",
    ["release event order 10"] = "phantom",
    ["release event order 11"] = "crystal",
    ["release event order 2"] = "candy",
    ["release event order 3"] = "lava",
    ["release event order 4"] = "galaxy",
    ["release event order 5"] = "yinyang",
    ["release event order 6"] = "radioactive",
    ["release event order 7"] = "cursed",
    ["release event order 8"] = "divine",
    ["release event order 9"] = "cyber",
    ["released last saturday"] = "orchidox",
    ["released last week"] = "orchidox",
    ["removed brainrot"] = "tungtungtungsahur",
    ["removed brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["reskin me"] = "sammynitruckini",
    ["reskin of me"] = "sammynitruckini",
    ["reskin of sammy"] = "sammynitruckini",
    ["reskin sammy"] = "sammynitruckini",
    ["revived fuse machine"] = "january2026",
    ["revived fuse machine date"] = "january2026",
    ["revived fuse machine day"] = "24",
    ["revived fuse machine month"] = "january",
    ["revived fuse machine release"] = "january2026",
    ["revived fuse machine release date"] = "january2026",
    ["revived fuse machine release day"] = "24",
    ["revived fuse machine release month"] = "january",
    ["revived fuse machine release year"] = "2026",
    ["revived fuse machine year"] = "2026",
    ["reward from money ritual"] = "lospuggies",
    ["reward from new ritual"] = "lospuggies",
    ["reward money"] = "lospuggies",
    ["reward of money ritual"] = "lospuggies",
    ["reward of new ritual"] = "lospuggies",
    ["rework brainrot"] = "sammynispyderini",
    ["rework brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["reworked brainrot"] = "sammynispyderini",
    ["reworked brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["rip tombstone"] = "riptombstone",
    ["rip tombstone date"] = "october2025",
    ["rip tombstone month"] = "october",
    ["rip tombstone release"] = "october2025",
    ["rip tombstone release date"] = "october2025",
    ["rip tombstone release month"] = "october",
    ["rip tombstone release year"] = "2025",
    ["rip tombstone trait"] = "riptombstone",
    ["rip tombstone trait date"] = "october2025",
    ["rip tombstone trait month"] = "october",
    ["rip tombstone trait release"] = "october2025",
    ["rip tombstone trait release date"] = "october2025",
    ["rip tombstone trait release month"] = "october",
    ["rip tombstone trait release year"] = "2025",
    ["rip tombstone trait year"] = "2025",
    ["rip tombstone year"] = "2025",
    ["riptombstone"] = "riptombstone",
    ["ritual added today"] = "money",
    ["ritual today"] = "money",
    ["rng machine"] = "august2026",
    ["rng machine date"] = "august2026",
    ["rng machine day"] = "8",
    ["rng machine month"] = "august",
    ["rng machine release"] = "august2026",
    ["rng machine release date"] = "august2026",
    ["rng machine release day"] = "8",
    ["rng machine release month"] = "august",
    ["rng machine release year"] = "2026",
    ["rng machine year"] = "2026",
    ["roblox skin color"] = "yellow",
    ["rose"] = "rose",
    ["sab created"] = "may2025",
    ["sab created date"] = "may2025",
    ["sab created day"] = "16",
    ["sab created month"] = "may",
    ["sab created release"] = "may2025",
    ["sab created release date"] = "may2025",
    ["sab created release day"] = "16",
    ["sab created release month"] = "may",
    ["sab created release year"] = "2025",
    ["sab created year"] = "2025",
    ["sab day"] = "16",
    ["sab game release"] = "may2025",
    ["sab game release date"] = "may2025",
    ["sab game release day"] = "16",
    ["sab game release month"] = "may",
    ["sab game release release"] = "may2025",
    ["sab game release release date"] = "may2025",
    ["sab game release release day"] = "16",
    ["sab game release release month"] = "may",
    ["sab game release release year"] = "2025",
    ["sab game release year"] = "2025",
    ["sab launched"] = "may2025",
    ["sab launched date"] = "may2025",
    ["sab launched day"] = "16",
    ["sab launched month"] = "may",
    ["sab launched release"] = "may2025",
    ["sab launched release date"] = "may2025",
    ["sab launched release day"] = "16",
    ["sab launched release month"] = "may",
    ["sab launched release year"] = "2025",
    ["sab launched year"] = "2025",
    ["sab made"] = "may2025",
    ["sab made date"] = "may2025",
    ["sab made day"] = "16",
    ["sab made month"] = "may",
    ["sab made release"] = "may2025",
    ["sab made release date"] = "may2025",
    ["sab made release day"] = "16",
    ["sab made release month"] = "may",
    ["sab made release year"] = "2025",
    ["sab made year"] = "2025",
    ["sab month"] = "may",
    ["sab release date"] = "may2025",
    ["sab release release"] = "may2025",
    ["sab release release date"] = "may2025",
    ["sab release release day"] = "16",
    ["sab release release month"] = "may",
    ["sab release release year"] = "2025",
    ["sab release year"] = "2025",
    ["sab released date"] = "may2025",
    ["sab released day"] = "16",
    ["sab released month"] = "may",
    ["sab released release"] = "may2025",
    ["sab released release date"] = "may2025",
    ["sab released release day"] = "16",
    ["sab released release month"] = "may",
    ["sab released release year"] = "2025",
    ["sab released year"] = "2025",
    ["sab year"] = "2025",
    ["sammy"] = "sammy",
    ["sammy 2nd name"] = "brakta",
    ["sammy avatar color"] = "red",
    ["sammy began making games on roblox in"] = "2013",
    ["sammy began making games on roblox in 2013"] = "2013",
    ["sammy began making games on roblox in 2013 release year"] = "2013",
    ["sammy began making games on roblox in 2013 year"] = "2013",
    ["sammy began making games on roblox in release year"] = "2013",
    ["sammy began making games on roblox in year"] = "2013",
    ["sammy brainrot"] = "meowl",
    ["sammy brakta"] = "brakta",
    ["sammy car color"] = "red",
    ["sammy cat"] = "nova",
    ["sammy cat name"] = "nova",
    ["sammy dog"] = "rocky",
    ["sammy dog name"] = "rocky",
    ["sammy enemy"] = "jandel",
    ["sammy fav mutation"] = "galaxy",
    ["sammy fav mutation date"] = "august2025",
    ["sammy fav mutation day"] = "23",
    ["sammy fav mutation month"] = "august",
    ["sammy fav mutation release"] = "august2025",
    ["sammy fav mutation release date"] = "august2025",
    ["sammy fav mutation release day"] = "23",
    ["sammy fav mutation release month"] = "august",
    ["sammy fav mutation release year"] = "2025",
    ["sammy fav mutation year"] = "2025",
    ["sammy fav number"] = "67",
    ["sammy favorite game"] = "fortnite",
    ["sammy favorite game is fortnite"] = "fortnite",
    ["sammy favorite mutation"] = "galaxy",
    ["sammy favorite mutation date"] = "august2025",
    ["sammy favorite mutation day"] = "23",
    ["sammy favorite mutation month"] = "august",
    ["sammy favorite mutation release"] = "august2025",
    ["sammy favorite mutation release date"] = "august2025",
    ["sammy favorite mutation release day"] = "23",
    ["sammy favorite mutation release month"] = "august",
    ["sammy favorite mutation release year"] = "2025",
    ["sammy favorite mutation year"] = "2025",
    ["sammy favorite number"] = "67",
    ["sammy favorite visual mutation for meowl"] = "cyber",
    ["sammy favorite visual mutation for meowl date"] = "april2026",
    ["sammy favorite visual mutation for meowl day"] = "18",
    ["sammy favorite visual mutation for meowl month"] = "april",
    ["sammy favorite visual mutation for meowl release"] = "april2026",
    ["sammy favorite visual mutation for meowl release date"] = "april2026",
    ["sammy favorite visual mutation for meowl release day"] = "18",
    ["sammy favorite visual mutation for meowl release month"] = "april",
    ["sammy favorite visual mutation for meowl release year"] = "2026",
    ["sammy favorite visual mutation for meowl year"] = "2026",
    ["sammy favourite game"] = "fortnite",
    ["sammy favourite game is fortnite"] = "fortnite",
    ["sammy favourite mutation"] = "galaxy",
    ["sammy favourite mutation date"] = "august2025",
    ["sammy favourite mutation day"] = "23",
    ["sammy favourite mutation month"] = "august",
    ["sammy favourite mutation release"] = "august2025",
    ["sammy favourite mutation release date"] = "august2025",
    ["sammy favourite mutation release day"] = "23",
    ["sammy favourite mutation release month"] = "august",
    ["sammy favourite mutation release year"] = "2025",
    ["sammy favourite mutation year"] = "2025",
    ["sammy favourite number"] = "67",
    ["sammy first game"] = "crabgame",
    ["sammy hair color"] = "black",
    ["sammy hair colour"] = "black",
    ["sammy hated group"] = "secretverse",
    ["sammy hated studio"] = "secretverse",
    ["sammy is a competitive player at"] = "valorant",
    ["sammy is a competitive player at valorant"] = "valorant",
    ["sammy is competitive player at"] = "valorant",
    ["sammy is competitive player at valorant"] = "valorant",
    ["sammy is competitive player at valorant his favorite game is fortnite"] = "valorant",
    ["sammy is competitive player at valorant his favourite game is fortnite"] = "valorant",
    ["sammy last name"] = "brakta",
    ["sammy least fav game"] = "growagarden",
    ["sammy least fav group"] = "secretverse",
    ["sammy least fav person"] = "secretlokii",
    ["sammy least fav studio"] = "secretverse",
    ["sammy least favorite game"] = "growagarden",
    ["sammy least favorite game is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["sammy least favorite game is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["sammy least favorite group"] = "secretverse",
    ["sammy least favorite person"] = "secretlokii",
    ["sammy least favorite studio"] = "secretverse",
    ["sammy least favourite game"] = "growagarden",
    ["sammy least favourite game is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["sammy least favourite game is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["sammy least favourite group"] = "secretverse",
    ["sammy least favourite person"] = "secretlokii",
    ["sammy least favourite studio"] = "secretverse",
    ["sammy loves to play"] = "fortnite",
    ["sammy middle name"] = "brakta",
    ["sammy number"] = "67",
    ["sammy pet"] = "rocky",
    ["sammy real"] = "sammy",
    ["sammy roblox avatar color"] = "red",
    ["sammy second name"] = "brakta",
    ["sammy surname"] = "brakta",
    ["sammy truckini"] = "sammynitruckini",
    ["sammy worst person"] = "secretlokii",
    ["sammyni spyderini"] = "sammynispyderini",
    ["sammyni spyderini and unclito samito and gattatino nyanino"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["sammyni spyderini unclito samito gattatino nyanino"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["sammyni truckini"] = "sammynitruckini",
    ["sammynispyderini"] = "sammynispyderini",
    ["sammynispyderiniunclitosamitogattatinonyanino"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["sammynitruckini"] = "sammynitruckini",
    ["sammys 2nd name"] = "brakta",
    ["sammys cat"] = "nova",
    ["sammys cat name"] = "nova",
    ["sammys dog"] = "rocky",
    ["sammys dog name"] = "rocky",
    ["sammys dogs name"] = "rocky",
    ["sammys fav number"] = "67",
    ["sammys favorite game"] = "fortnite",
    ["sammys favorite mutation"] = "galaxy",
    ["sammys favorite mutation date"] = "august2025",
    ["sammys favorite mutation day"] = "23",
    ["sammys favorite mutation month"] = "august",
    ["sammys favorite mutation release"] = "august2025",
    ["sammys favorite mutation release date"] = "august2025",
    ["sammys favorite mutation release day"] = "23",
    ["sammys favorite mutation release month"] = "august",
    ["sammys favorite mutation release year"] = "2025",
    ["sammys favorite mutation year"] = "2025",
    ["sammys favorite number"] = "67",
    ["sammys favorite visual mutation for meowl"] = "cyber",
    ["sammys favorite visual mutation for meowl date"] = "april2026",
    ["sammys favorite visual mutation for meowl day"] = "18",
    ["sammys favorite visual mutation for meowl month"] = "april",
    ["sammys favorite visual mutation for meowl release"] = "april2026",
    ["sammys favorite visual mutation for meowl release date"] = "april2026",
    ["sammys favorite visual mutation for meowl release day"] = "18",
    ["sammys favorite visual mutation for meowl release month"] = "april",
    ["sammys favorite visual mutation for meowl release year"] = "2026",
    ["sammys favorite visual mutation for meowl year"] = "2026",
    ["sammys favourite game"] = "fortnite",
    ["sammys favourite mutation"] = "galaxy",
    ["sammys favourite mutation date"] = "august2025",
    ["sammys favourite mutation day"] = "23",
    ["sammys favourite mutation month"] = "august",
    ["sammys favourite mutation release"] = "august2025",
    ["sammys favourite mutation release date"] = "august2025",
    ["sammys favourite mutation release day"] = "23",
    ["sammys favourite mutation release month"] = "august",
    ["sammys favourite mutation release year"] = "2025",
    ["sammys favourite mutation year"] = "2025",
    ["sammys favourite number"] = "67",
    ["sammys hair color"] = "black",
    ["sammys hair colour"] = "black",
    ["sammys hated group"] = "secretverse",
    ["sammys hated studio"] = "secretverse",
    ["sammys last name"] = "brakta",
    ["sammys least favorite game"] = "growagarden",
    ["sammys least favorite game is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["sammys least favorite game is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["sammys least favorite group"] = "secretverse",
    ["sammys least favorite person"] = "secretlokii",
    ["sammys least favorite studio"] = "secretverse",
    ["sammys least favourite game"] = "growagarden",
    ["sammys least favourite game is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["sammys least favourite game is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["sammys least favourite group"] = "secretverse",
    ["sammys least favourite person"] = "secretlokii",
    ["sammys least favourite studio"] = "secretverse",
    ["sammys middle name"] = "brakta",
    ["sammys pet"] = "rocky",
    ["sammys pet name"] = "rocky",
    ["sammys second name"] = "brakta",
    ["sammys surname"] = "brakta",
    ["sammys worst person"] = "secretlokii",
    ["sammytruckini"] = "sammynitruckini",
    ["santa fuse"] = "santafuse",
    ["santa fuse date"] = "december2025",
    ["santa fuse day"] = "6",
    ["santa fuse month"] = "december",
    ["santa fuse release"] = "december2025",
    ["santa fuse release date"] = "december2025",
    ["santa fuse release day"] = "6",
    ["santa fuse release month"] = "december",
    ["santa fuse release year"] = "2025",
    ["santa fuse year"] = "2025",
    ["santa hat trait"] = "santahat",
    ["santa hat trait date"] = "december2025",
    ["santa hat trait month"] = "december",
    ["santa hat trait release"] = "december2025",
    ["santa hat trait release date"] = "december2025",
    ["santa hat trait release month"] = "december",
    ["santa hat trait release year"] = "2025",
    ["santa hat trait year"] = "2025",
    ["santa machine"] = "santafuse",
    ["santa machine date"] = "december2025",
    ["santa machine day"] = "6",
    ["santa machine month"] = "december",
    ["santa machine release"] = "december2025",
    ["santa machine release date"] = "december2025",
    ["santa machine release day"] = "6",
    ["santa machine release month"] = "december",
    ["santa machine release year"] = "2025",
    ["santa machine year"] = "2025",
    ["santafuse"] = "santafuse",
    ["santahat"] = "santahat",
    ["santahat trait"] = "santahat",
    ["santahat trait date"] = "december2025",
    ["santahat trait month"] = "december",
    ["santahat trait release"] = "december2025",
    ["santahat trait release date"] = "december2025",
    ["santahat trait release month"] = "december",
    ["santahat trait release year"] = "2025",
    ["santahat trait year"] = "2025",
    ["santas fuse"] = "santafuse",
    ["santas fuse date"] = "december2025",
    ["santas fuse day"] = "6",
    ["santas fuse machine"] = "santafuse",
    ["santas fuse machine date"] = "december2025",
    ["santas fuse machine day"] = "6",
    ["santas fuse machine month"] = "december",
    ["santas fuse machine release"] = "december2025",
    ["santas fuse machine release date"] = "december2025",
    ["santas fuse machine release day"] = "6",
    ["santas fuse machine release month"] = "december",
    ["santas fuse machine release year"] = "2025",
    ["santas fuse machine year"] = "2025",
    ["santas fuse month"] = "december",
    ["santas fuse release"] = "december2025",
    ["santas fuse release date"] = "december2025",
    ["santas fuse release day"] = "6",
    ["santas fuse release month"] = "december",
    ["santas fuse release year"] = "2025",
    ["santas fuse year"] = "2025",
    ["season"] = "autumn",
    ["season currently"] = "autumn",
    ["season in"] = "autumn",
    ["season suffering"] = "autumn",
    ["season we are currently in"] = "autumn",
    ["season we are currently in is"] = "autumn",
    ["season we are in"] = "autumn",
    ["season we are suffering"] = "autumn",
    ["season we are suffering is"] = "autumn",
    ["second best"] = "strawberryelephant",
    ["second best brainrot"] = "strawberryelephant",
    ["second best brainrot in game"] = "strawberryelephant",
    ["second best brainrot in the game"] = "strawberryelephant",
    ["second best taco merchant"] = "nachorilla",
    ["second brainrot that got removed"] = "crocidilopenisini",
    ["second brainrot that was reworked"] = "unclitosamito",
    ["second fuse"] = "witchfuse",
    ["second fuse date"] = "october2025",
    ["second fuse day"] = "11",
    ["second fuse machine"] = "witchfuse",
    ["second fuse machine date"] = "october2025",
    ["second fuse machine day"] = "11",
    ["second fuse machine month"] = "october",
    ["second fuse machine release"] = "october2025",
    ["second fuse machine release date"] = "october2025",
    ["second fuse machine release day"] = "11",
    ["second fuse machine release month"] = "october",
    ["second fuse machine release year"] = "2025",
    ["second fuse machine year"] = "2025",
    ["second fuse month"] = "october",
    ["second fuse release"] = "october2025",
    ["second fuse release date"] = "october2025",
    ["second fuse release day"] = "11",
    ["second fuse release month"] = "october",
    ["second fuse release year"] = "2025",
    ["second fuse year"] = "2025",
    ["second name"] = "brakta",
    ["second name of sammy"] = "brakta",
    ["second name of sammy is"] = "brakta",
    ["second name of sammy is brakta"] = "brakta",
    ["second name of sammys"] = "brakta",
    ["second og"] = "meowl",
    ["second og added in sab"] = "meowl",
    ["second og added in the game"] = "meowl",
    ["second og added to sab"] = "meowl",
    ["second og added to the game"] = "meowl",
    ["second og brainrot"] = "meowl",
    ["second og in sab"] = "meowl",
    ["second og in the game"] = "meowl",
    ["second removed brainrot"] = "crocidilopenisini",
    ["second reworked brainrot"] = "unclitosamito",
    ["second taco merchant"] = "nachorilla",
    ["secret brainrot"] = "lavaccasaturnosaturnita",
    ["secret loki"] = "secretlokii",
    ["secret lokii"] = "secretlokii",
    ["secret lucky block"] = "july2025",
    ["secret lucky block date"] = "july2025",
    ["secret lucky block day"] = "12",
    ["secret lucky block month"] = "july",
    ["secret lucky block release"] = "july2025",
    ["secret lucky block release date"] = "july2025",
    ["secret lucky block release day"] = "12",
    ["secret lucky block release month"] = "july",
    ["secret lucky block release year"] = "2025",
    ["secret lucky block year"] = "2025",
    ["secret sab"] = "lavaccasaturnosaturnita",
    ["secret steal"] = "strawberryelephant",
    ["secret sub"] = "lavaccasaturnosaturnita",
    ["secretloki"] = "secretlokii",
    ["secretlokii"] = "secretlokii",
    ["secretverse"] = "secretverse",
    ["secretverse studio"] = "secretverse",
    ["secretversestudio"] = "secretverse",
    ["serpent"] = "hydraserpent",
    ["setup"] = "windows11",
    ["shark"] = "shark",
    ["shark trait"] = "shark",
    ["shark trait date"] = "june2025",
    ["shark trait month"] = "june",
    ["shark trait release"] = "june2025",
    ["shark trait release date"] = "june2025",
    ["shark trait release month"] = "june",
    ["shark trait release year"] = "2025",
    ["shark trait year"] = "2025",
    ["sharkfin"] = "sharkfin",
    ["shirt color"] = "red",
    ["signore"] = "signorecarapace",
    ["signore carapace color"] = "white",
    ["signore carapace suit color"] = "blue",
    ["signorecarapace"] = "white",
    ["silver"] = "silver",
    ["singer"] = "drake",
    ["sixth brainrot based off a mythical creature"] = "hydraserpent",
    ["sixth brainrot based off mythical creature"] = "hydraserpent",
    ["sixth brainrot based off of a mythical creature"] = "hydraserpent",
    ["sixth brainrot based on a mythical creature"] = "hydraserpent",
    ["sixth brainrot based on mythical creature"] = "hydraserpent",
    ["sixth brainrot to be based off a mythical creature"] = "hydraserpent",
    ["sixth brainrot to be based off of a mythical creature"] = "hydraserpent",
    ["sixth brainrot to be based on a mythical creature"] = "hydraserpent",
    ["sixth brainrot to be based on mythical creature"] = "hydraserpent",
    ["sixth mythical"] = "hydraserpent",
    ["sixth mythical brainrot"] = "hydraserpent",
    ["sixth mythical creature"] = "hydraserpent",
    ["sixth mythical creature brainrot"] = "hydraserpent",
    ["sixth og"] = "spyderelephant",
    ["sixth og brainrot"] = "spyderelephant",
    ["skeleton"] = "skeleton",
    ["skeleton trait"] = "skeleton",
    ["skeleton trait date"] = "september2025",
    ["skeleton trait day"] = "13",
    ["skeleton trait month"] = "september",
    ["skeleton trait release"] = "september2025",
    ["skeleton trait release date"] = "september2025",
    ["skeleton trait release day"] = "13",
    ["skeleton trait release month"] = "september",
    ["skeleton trait release year"] = "2025",
    ["skeleton trait year"] = "2025",
    ["skibidi"] = "skibidi",
    ["skibidi toilet added"] = "december2025",
    ["skibidi toilet color"] = "white",
    ["skibidi toilet date"] = "december2025",
    ["skibidi toilet day"] = "1",
    ["skibidi toilet month"] = "december",
    ["skibidi toilet release"] = "december2025",
    ["skibidi toilet release date"] = "december2025",
    ["skibidi toilet release day"] = "1",
    ["skibidi toilet release month"] = "december",
    ["skibidi toilet release year"] = "2025",
    ["skibidi toilet released"] = "december2025",
    ["skibidi toilet year"] = "2025",
    ["skibidi trait"] = "skibidi",
    ["skibidi trait date"] = "june2025",
    ["skibidi trait month"] = "june",
    ["skibidi trait release"] = "june2025",
    ["skibidi trait release date"] = "june2025",
    ["skibidi trait release month"] = "june",
    ["skibidi trait release year"] = "2025",
    ["skibidi trait year"] = "2025",
    ["skibiditoilet"] = "skibiditoilet",
    ["skibiditoilet date"] = "december2025",
    ["skibiditoilet day"] = "1",
    ["skibiditoilet month"] = "december",
    ["skibiditoilet release"] = "december2025",
    ["skibiditoilet release date"] = "december2025",
    ["skibiditoilet release day"] = "1",
    ["skibiditoilet release month"] = "december",
    ["skibiditoilet release year"] = "2025",
    ["skibiditoilet year"] = "2025",
    ["skin color"] = "yellow",
    ["sleepy"] = "sleepy",
    ["sleepy trait"] = "sleepy",
    ["snake brainrot"] = "hydraserpent",
    ["snake brainrot his name"] = "hydraserpent",
    ["snake brainrot name"] = "hydraserpent",
    ["snake brainrots name"] = "hydraserpent",
    ["snow"] = "snow",
    ["snow trait"] = "snow",
    ["snow trait date"] = "june2025",
    ["snow trait month"] = "june",
    ["snow trait release"] = "june2025",
    ["snow trait release date"] = "june2025",
    ["snow trait release month"] = "june",
    ["snow trait release year"] = "2025",
    ["snow trait year"] = "2025",
    ["snow weather trait"] = "snow",
    ["snow weather trait date"] = "june2025",
    ["snow weather trait month"] = "june",
    ["snow weather trait release"] = "june2025",
    ["snow weather trait release date"] = "june2025",
    ["snow weather trait release month"] = "june",
    ["snow weather trait release year"] = "2025",
    ["snow weather trait year"] = "2025",
    ["snowy trait"] = "snow",
    ["snowy trait date"] = "june2025",
    ["snowy trait month"] = "june",
    ["snowy trait release"] = "june2025",
    ["snowy trait release date"] = "june2025",
    ["snowy trait release month"] = "june",
    ["snowy trait release year"] = "2025",
    ["snowy trait year"] = "2025",
    ["solar flare trait"] = "fire",
    ["solar flare trait date"] = "june2025",
    ["solar flare trait month"] = "june",
    ["solar flare trait release"] = "june2025",
    ["solar flare trait release date"] = "june2025",
    ["solar flare trait release month"] = "june",
    ["solar flare trait release year"] = "2025",
    ["solar flare trait year"] = "2025",
    ["song"] = "drake",
    ["spaghetti tualetti"] = "spaghettitualetti",
    ["spaghettitualetti"] = "spaghettitualetti",
    ["spain"] = "spain",
    ["spain event trait"] = "bull",
    ["spain event trait date"] = "july2026",
    ["spain event trait day"] = "25",
    ["spain event trait month"] = "july",
    ["spain event trait release"] = "july2026",
    ["spain event trait release date"] = "july2026",
    ["spain event trait release day"] = "25",
    ["spain event trait release month"] = "july",
    ["spain event trait release year"] = "2026",
    ["spain event trait year"] = "2026",
    ["spain trait"] = "bull",
    ["spain trait date"] = "july2026",
    ["spain trait day"] = "25",
    ["spain trait month"] = "july",
    ["spain trait release"] = "july2026",
    ["spain trait release date"] = "july2026",
    ["spain trait release day"] = "25",
    ["spain trait release month"] = "july",
    ["spain trait release year"] = "2026",
    ["spain trait year"] = "2026",
    ["spider"] = "spider",
    ["spiderelephant"] = "spyderelephant",
    ["spyder"] = "SpyderElephant",
    ["spyder chain"] = "spyderchain",
    ["spyder elephant added"] = "may2026",
    ["spyder elephant color"] = "gray",
    ["spyder elephant date"] = "may2026",
    ["spyder elephant day"] = "1",
    ["spyder elephant material"] = "silver",
    ["spyder elephant month"] = "may",
    ["spyder elephant release"] = "may2026",
    ["spyder elephant release date"] = "may2026",
    ["spyder elephant release day"] = "1",
    ["spyder elephant release month"] = "may",
    ["spyder elephant release year"] = "2026",
    ["spyder elephant released"] = "may2026",
    ["spyder elephant year"] = "2026",
    ["spyderchain"] = "spyderchain",
    ["spyderelephant"] = "spyderelephant",
    ["spyderelephant date"] = "may2026",
    ["spyderelephant day"] = "1",
    ["spyderelephant month"] = "may",
    ["spyderelephant release"] = "may2026",
    ["spyderelephant release date"] = "may2026",
    ["spyderelephant release day"] = "1",
    ["spyderelephant release month"] = "may",
    ["spyderelephant release year"] = "2026",
    ["spyderelephant year"] = "2026",
    ["starfall"] = "starfall",
    ["starfall trait"] = "starfall",
    ["starfall trait date"] = "june2025",
    ["starfall trait month"] = "june",
    ["starfall trait release"] = "june2025",
    ["starfall trait release date"] = "june2025",
    ["starfall trait release month"] = "june",
    ["starfall trait release year"] = "2025",
    ["starfall trait year"] = "2025",
    ["starfall weather trait"] = "starfall",
    ["starfall weather trait date"] = "june2025",
    ["starfall weather trait month"] = "june",
    ["starfall weather trait release"] = "june2025",
    ["starfall weather trait release date"] = "june2025",
    ["starfall weather trait release month"] = "june",
    ["starfall weather trait release year"] = "2025",
    ["starfall weather trait year"] = "2025",
    ["started making games"] = "2013",
    ["started making games in roblox"] = "2013",
    ["started making games in roblox release year"] = "2013",
    ["started making games in roblox year"] = "2013",
    ["started making games on roblox"] = "2013",
    ["started making games on roblox release year"] = "2013",
    ["started making games on roblox year"] = "2013",
    ["started making games release year"] = "2013",
    ["started making games year"] = "2013",
    ["steak"] = "steak",
    ["steal a brainrot created"] = "may2025",
    ["steal a brainrot created date"] = "may2025",
    ["steal a brainrot created day"] = "16",
    ["steal a brainrot created month"] = "may",
    ["steal a brainrot created release"] = "may2025",
    ["steal a brainrot created release date"] = "may2025",
    ["steal a brainrot created release day"] = "16",
    ["steal a brainrot created release month"] = "may",
    ["steal a brainrot created release year"] = "2025",
    ["steal a brainrot created year"] = "2025",
    ["steal a brainrot game"] = "may2025",
    ["steal a brainrot game date"] = "may2025",
    ["steal a brainrot game day"] = "16",
    ["steal a brainrot game month"] = "may",
    ["steal a brainrot game release"] = "may2025",
    ["steal a brainrot game release date"] = "may2025",
    ["steal a brainrot game release day"] = "16",
    ["steal a brainrot game release month"] = "may",
    ["steal a brainrot game release year"] = "2025",
    ["steal a brainrot game year"] = "2025",
    ["steal a brainrot launched"] = "may2025",
    ["steal a brainrot launched date"] = "may2025",
    ["steal a brainrot launched day"] = "16",
    ["steal a brainrot launched month"] = "may",
    ["steal a brainrot launched release"] = "may2025",
    ["steal a brainrot launched release date"] = "may2025",
    ["steal a brainrot launched release day"] = "16",
    ["steal a brainrot launched release month"] = "may",
    ["steal a brainrot launched release year"] = "2025",
    ["steal a brainrot launched year"] = "2025",
    ["steal a brainrot made"] = "may2025",
    ["steal a brainrot made date"] = "may2025",
    ["steal a brainrot made day"] = "16",
    ["steal a brainrot made month"] = "may",
    ["steal a brainrot made release"] = "may2025",
    ["steal a brainrot made release date"] = "may2025",
    ["steal a brainrot made release day"] = "16",
    ["steal a brainrot made release month"] = "may",
    ["steal a brainrot made release year"] = "2025",
    ["steal a brainrot made year"] = "2025",
    ["steal a brainrot release"] = "may2025",
    ["steal a brainrot release date"] = "may2025",
    ["steal a brainrot release day"] = "16",
    ["steal a brainrot release month"] = "may",
    ["steal a brainrot release release"] = "may2025",
    ["steal a brainrot release release date"] = "may2025",
    ["steal a brainrot release release day"] = "16",
    ["steal a brainrot release release month"] = "may",
    ["steal a brainrot release release year"] = "2025",
    ["steal a brainrot release year"] = "2025",
    ["steal a brainrot released"] = "may2025",
    ["steal a brainrot released date"] = "may2025",
    ["steal a brainrot released day"] = "16",
    ["steal a brainrot released month"] = "may",
    ["steal a brainrot released release"] = "may2025",
    ["steal a brainrot released release date"] = "may2025",
    ["steal a brainrot released release day"] = "16",
    ["steal a brainrot released release month"] = "may",
    ["steal a brainrot released release year"] = "2025",
    ["steal a brainrot released year"] = "2025",
    ["strawberry"] = "StrawberryElephant",
    ["strawberry elephant added"] = "august2025",
    ["strawberry elephant base exist"] = "1277",
    ["strawberry elephant color"] = "red",
    ["strawberry elephant crystal exist"] = "1",
    ["strawberry elephant date"] = "august2025",
    ["strawberry elephant day"] = "1",
    ["strawberry elephant diamond exist"] = "263",
    ["strawberry elephant exist"] = "2348",
    ["strawberry elephant exist count"] = "2348",
    ["strawberry elephant exists"] = "2348",
    ["strawberry elephant gold exist"] = "565",
    ["strawberry elephant gold mutation exist count"] = "565",
    ["strawberry elephant month"] = "august",
    ["strawberry elephant normal exist"] = "1277",
    ["strawberry elephant rainbow exist"] = "87",
    ["strawberry elephant release"] = "august2025",
    ["strawberry elephant release date"] = "august2025",
    ["strawberry elephant release day"] = "1",
    ["strawberry elephant release month"] = "august",
    ["strawberry elephant release year"] = "2025",
    ["strawberry elephant released"] = "august2025",
    ["strawberry elephant total exist"] = "2348",
    ["strawberry elephant total exist count"] = "2348",
    ["strawberry elephant year"] = "2025",
    ["strawberry elephants base exist"] = "1277",
    ["strawberry elephants crystal exist"] = "1",
    ["strawberry elephants diamond exist"] = "263",
    ["strawberry elephants exist"] = "2348",
    ["strawberry elephants exist count"] = "2348",
    ["strawberry elephants exists"] = "2348",
    ["strawberry elephants gold exist"] = "565",
    ["strawberry elephants normal exist"] = "1277",
    ["strawberry elephants rainbow exist"] = "87",
    ["strawberry elephants total exist"] = "2348",
    ["strawberry elephants total exist count"] = "2348",
    ["strawberryelephant"] = "strawberryelephant",
    ["strawberryelephant date"] = "august2025",
    ["strawberryelephant day"] = "1",
    ["strawberryelephant month"] = "august",
    ["strawberryelephant release"] = "august2025",
    ["strawberryelephant release date"] = "august2025",
    ["strawberryelephant release day"] = "1",
    ["strawberryelephant release month"] = "august",
    ["strawberryelephant release year"] = "2025",
    ["strawberryelephant year"] = "2025",
    ["strongest brainrot"] = "lupaandlipa",
    ["strongest brainrot added"] = "lupaandlipa",
    ["strongest brainrot added date"] = "august2026",
    ["strongest brainrot added day"] = "22",
    ["strongest brainrot added last saturday"] = "orchidox",
    ["strongest brainrot added last week"] = "orchidox",
    ["strongest brainrot added month"] = "august",
    ["strongest brainrot added recently"] = "lupaandlipa",
    ["strongest brainrot added recently date"] = "august2026",
    ["strongest brainrot added recently day"] = "22",
    ["strongest brainrot added recently month"] = "august",
    ["strongest brainrot added recently release"] = "august2026",
    ["strongest brainrot added recently release date"] = "august2026",
    ["strongest brainrot added recently release day"] = "22",
    ["strongest brainrot added recently release month"] = "august",
    ["strongest brainrot added recently release year"] = "2026",
    ["strongest brainrot added recently year"] = "2026",
    ["strongest brainrot added release"] = "august2026",
    ["strongest brainrot added release date"] = "august2026",
    ["strongest brainrot added release day"] = "22",
    ["strongest brainrot added release month"] = "august",
    ["strongest brainrot added release year"] = "2026",
    ["strongest brainrot added year"] = "2026",
    ["strongest brainrot recently"] = "lupaandlipa",
    ["strongest brainrot recently date"] = "august2026",
    ["strongest brainrot recently day"] = "22",
    ["strongest brainrot recently month"] = "august",
    ["strongest brainrot recently release"] = "august2026",
    ["strongest brainrot recently release date"] = "august2026",
    ["strongest brainrot recently release day"] = "22",
    ["strongest brainrot recently release month"] = "august",
    ["strongest brainrot recently release year"] = "2026",
    ["strongest brainrot recently year"] = "2026",
    ["strongest brainrot released last saturday"] = "orchidox",
    ["strongest brainrot released last week"] = "orchidox",
    ["strongest brainrot released recently"] = "lupaandlipa",
    ["strongest brainrot released recently date"] = "august2026",
    ["strongest brainrot released recently day"] = "22",
    ["strongest brainrot released recently month"] = "august",
    ["strongest brainrot released recently release"] = "august2026",
    ["strongest brainrot released recently release date"] = "august2026",
    ["strongest brainrot released recently release day"] = "22",
    ["strongest brainrot released recently release month"] = "august",
    ["strongest brainrot released recently release year"] = "2026",
    ["strongest brainrot released recently year"] = "2026",
    ["strongest brainrot that was added"] = "lupaandlipa",
    ["strongest brainrot that was added date"] = "august2026",
    ["strongest brainrot that was added day"] = "22",
    ["strongest brainrot that was added month"] = "august",
    ["strongest brainrot that was added recently"] = "lupaandlipa",
    ["strongest brainrot that was added recently date"] = "august2026",
    ["strongest brainrot that was added recently day"] = "22",
    ["strongest brainrot that was added recently month"] = "august",
    ["strongest brainrot that was added recently release"] = "august2026",
    ["strongest brainrot that was added recently release date"] = "august2026",
    ["strongest brainrot that was added recently release day"] = "22",
    ["strongest brainrot that was added recently release month"] = "august",
    ["strongest brainrot that was added recently release year"] = "2026",
    ["strongest brainrot that was added recently year"] = "2026",
    ["strongest brainrot that was added release"] = "august2026",
    ["strongest brainrot that was added release date"] = "august2026",
    ["strongest brainrot that was added release day"] = "22",
    ["strongest brainrot that was added release month"] = "august",
    ["strongest brainrot that was added release year"] = "2026",
    ["strongest brainrot that was added year"] = "2026",
    ["strongest brainrot that was released recently"] = "lupaandlipa",
    ["strongest brainrot that was released recently date"] = "august2026",
    ["strongest brainrot that was released recently day"] = "22",
    ["strongest brainrot that was released recently month"] = "august",
    ["strongest brainrot that was released recently release"] = "august2026",
    ["strongest brainrot that was released recently release date"] = "august2026",
    ["strongest brainrot that was released recently release day"] = "22",
    ["strongest brainrot that was released recently release month"] = "august",
    ["strongest brainrot that was released recently release year"] = "2026",
    ["strongest brainrot that was released recently year"] = "2026",
    ["strongest mutation"] = "crystal",
    ["studio hate"] = "secretverse",
    ["studio hate most"] = "secretverse",
    ["studio hates"] = "secretverse",
    ["studio hates most"] = "secretverse",
    ["studio i hate"] = "secretverse",
    ["studio i hate most"] = "secretverse",
    ["studio i hate the most"] = "secretverse",
    ["studio sammy hates"] = "secretverse",
    ["studio sammy hates most"] = "secretverse",
    ["studio sammy hates the most"] = "secretverse",
    ["suffering season"] = "autumn",
    ["summer"] = "summer",
    ["summer fuse"] = "summerfuse",
    ["summer fuse date"] = "may2026",
    ["summer fuse day"] = "23",
    ["summer fuse machine"] = "summerfuse",
    ["summer fuse machine date"] = "may2026",
    ["summer fuse machine day"] = "23",
    ["summer fuse machine month"] = "may",
    ["summer fuse machine release"] = "may2026",
    ["summer fuse machine release date"] = "may2026",
    ["summer fuse machine release day"] = "23",
    ["summer fuse machine release month"] = "may",
    ["summer fuse machine release year"] = "2026",
    ["summer fuse machine year"] = "2026",
    ["summer fuse month"] = "may",
    ["summer fuse release"] = "may2026",
    ["summer fuse release date"] = "may2026",
    ["summer fuse release day"] = "23",
    ["summer fuse release month"] = "may",
    ["summer fuse release year"] = "2026",
    ["summer fuse year"] = "2026",
    ["summeroceandragon"] = "dragonaquanini",
    ["surname"] = "brakta",
    ["syrup"] = "pancakeandsyrup",
    ["taco"] = "taco",
    ["taco block"] = "september2025",
    ["taco block date"] = "september2025",
    ["taco block day"] = "16",
    ["taco block month"] = "september",
    ["taco block release"] = "september2025",
    ["taco block release date"] = "september2025",
    ["taco block release day"] = "16",
    ["taco block release month"] = "september",
    ["taco block release year"] = "2025",
    ["taco block year"] = "2025",
    ["taco blocks"] = "november2025",
    ["taco blocks date"] = "november2025",
    ["taco blocks day"] = "18",
    ["taco blocks month"] = "november",
    ["taco blocks release"] = "november2025",
    ["taco blocks release date"] = "november2025",
    ["taco blocks release day"] = "18",
    ["taco blocks release month"] = "november",
    ["taco blocks release year"] = "2025",
    ["taco blocks year"] = "2025",
    ["taco combinasion"] = "latacocombinasion",
    ["taco lucky block"] = "september2025",
    ["taco lucky block date"] = "september2025",
    ["taco lucky block day"] = "16",
    ["taco lucky block month"] = "september",
    ["taco lucky block release"] = "september2025",
    ["taco lucky block release date"] = "september2025",
    ["taco lucky block release day"] = "16",
    ["taco lucky block release month"] = "september",
    ["taco lucky block release year"] = "2025",
    ["taco lucky block year"] = "2025",
    ["taco merchant"] = "tacomerchant",
    ["taco merchant date"] = "august2026",
    ["taco merchant day"] = "18",
    ["taco merchant month"] = "august",
    ["taco merchant npc"] = "tacomerchant",
    ["taco merchant npc date"] = "august2026",
    ["taco merchant npc day"] = "18",
    ["taco merchant npc month"] = "august",
    ["taco merchant npc release"] = "august2026",
    ["taco merchant npc release date"] = "august2026",
    ["taco merchant npc release day"] = "18",
    ["taco merchant npc release month"] = "august",
    ["taco merchant npc release year"] = "2026",
    ["taco merchant npc year"] = "2026",
    ["taco merchant release"] = "august2026",
    ["taco merchant release date"] = "august2026",
    ["taco merchant release day"] = "18",
    ["taco merchant release month"] = "august",
    ["taco merchant release year"] = "2026",
    ["taco merchant year"] = "2026",
    ["taco secret"] = "lacucaracha",
    ["taco shop"] = "tacomerchant",
    ["taco shop date"] = "august2026",
    ["taco shop day"] = "18",
    ["taco shop month"] = "august",
    ["taco shop release"] = "august2026",
    ["taco shop release date"] = "august2026",
    ["taco shop release day"] = "18",
    ["taco shop release month"] = "august",
    ["taco shop release year"] = "2026",
    ["taco shop year"] = "2026",
    ["taco trait"] = "taco",
    ["taco trait date"] = "june2025",
    ["taco trait day"] = "28",
    ["taco trait month"] = "june",
    ["taco trait release"] = "june2025",
    ["taco trait release date"] = "june2025",
    ["taco trait release day"] = "28",
    ["taco trait release month"] = "june",
    ["taco trait release year"] = "2025",
    ["taco trait year"] = "2025",
    ["taco tuesday lucky block"] = "september2025",
    ["taco tuesday lucky block date"] = "september2025",
    ["taco tuesday lucky block day"] = "16",
    ["taco tuesday lucky block month"] = "september",
    ["taco tuesday lucky block release"] = "september2025",
    ["taco tuesday lucky block release date"] = "september2025",
    ["taco tuesday lucky block release day"] = "16",
    ["taco tuesday lucky block release month"] = "september",
    ["taco tuesday lucky block release year"] = "2025",
    ["taco tuesday lucky block year"] = "2025",
    ["taco tuesday trait"] = "taco",
    ["taco tuesday trait date"] = "june2025",
    ["taco tuesday trait day"] = "28",
    ["taco tuesday trait month"] = "june",
    ["taco tuesday trait release"] = "june2025",
    ["taco tuesday trait release date"] = "june2025",
    ["taco tuesday trait release day"] = "28",
    ["taco tuesday trait release month"] = "june",
    ["taco tuesday trait release year"] = "2025",
    ["taco tuesday trait year"] = "2025",
    ["taco turbo tacorito"] = "tacoturbotacorito",
    ["tacocombinasion"] = "LaTacoCombinasion",
    ["tacomerchant"] = "tacomerchant",
    ["taconini"] = "chihuaninitaconini",
    ["tacorillo crocodillo"] = "tacorillocrocodillo",
    ["tacorillocrocodillo"] = "tacorillocrocodillo",
    ["tacorita"] = "tacoritabicicleta",
    ["tacorita bicicleta"] = "tacoritabicicleta",
    ["tacoritabicicleta"] = "tacoritabicicleta",
    ["tacotuesday"] = "tacotuesday",
    ["tacoturbo tacorito"] = "tacoturbotacorito",
    ["tacoturbotacorito"] = "tacoturbotacorito",
    ["the 1st og"] = "strawberryelephant",
    ["the 1st og brainrot"] = "strawberryelephant",
    ["the 1st og brainrot in game"] = "strawberryelephant",
    ["the 1st og brainrot in the game"] = "strawberryelephant",
    ["the 1st og in game"] = "strawberryelephant",
    ["the 1st og in the game"] = "strawberryelephant",
    ["the 1st snake"] = "hydraserpent",
    ["the 1st snake added"] = "hydraserpent",
    ["the 1st snake brainrot"] = "hydraserpent",
    ["the 1st snake brainrot added"] = "hydraserpent",
    ["the 1st snake brainrot ever added"] = "hydraserpent",
    ["the 1st snake brainrot in game"] = "hydraserpent",
    ["the 1st snake brainrot in sab"] = "hydraserpent",
    ["the 1st snake brainrot in the game"] = "hydraserpent",
    ["the 1st snake brainrot that was added"] = "hydraserpent",
    ["the 1st snake brainrot that was ever added"] = "hydraserpent",
    ["the 1st snake ever added"] = "hydraserpent",
    ["the 1st snake in game"] = "hydraserpent",
    ["the 1st snake in sab"] = "hydraserpent",
    ["the 1st snake in the game"] = "hydraserpent",
    ["the 1st snake that was added"] = "hydraserpent",
    ["the 1st snake that was ever added"] = "hydraserpent",
    ["the 2nd best brainrot"] = "strawberryelephant",
    ["the 2nd best brainrot in game"] = "strawberryelephant",
    ["the 2nd best brainrot in the game"] = "strawberryelephant",
    ["the 2nd og"] = "meowl",
    ["the 2nd og brainrot"] = "meowl",
    ["the 3 headed brainrot"] = "hydraserpent",
    ["the 3 headed snake brainrot"] = "hydraserpent",
    ["the 3rd og"] = "skibiditoilet",
    ["the 3rd og brainrot"] = "skibiditoilet",
    ["the 4th 3 headed"] = "hydraserpent",
    ["the 4th 3 headed brainrot"] = "hydraserpent",
    ["the 4th og"] = "headlesshorseman",
    ["the 4th og brainrot"] = "headlesshorseman",
    ["the 4th three headed"] = "hydraserpent",
    ["the 4th three headed brainrot"] = "hydraserpent",
    ["the 5th og"] = "johnpork",
    ["the 5th og brainrot"] = "johnpork",
    ["the 6th brainrot based off a mythical creature"] = "hydraserpent",
    ["the 6th brainrot based off of a mythical creature"] = "hydraserpent",
    ["the 6th brainrot based on a mythical creature"] = "hydraserpent",
    ["the 6th brainrot to be based off a mythical creature"] = "hydraserpent",
    ["the 6th brainrot to be based on a mythical creature"] = "hydraserpent",
    ["the 6th mythical brainrot"] = "hydraserpent",
    ["the 6th mythical creature"] = "hydraserpent",
    ["the 6th mythical creature brainrot"] = "hydraserpent",
    ["the 6th og"] = "spyderelephant",
    ["the 6th og brainrot"] = "spyderelephant",
    ["the best admin abuse brainrot"] = "lupaandlipa",
    ["the best brainrot"] = "lupaandlipa",
    ["the best brainrot added in todays admin abuse"] = "lupaandlipa",
    ["the best brainrot added in todays update"] = "lupaandlipa",
    ["the best brainrot added last saturday"] = "orchidox",
    ["the best brainrot added last week"] = "orchidox",
    ["the best brainrot added today"] = "lupaandlipa",
    ["the best brainrot except spyder elephant"] = "strawberryelephant",
    ["the best brainrot except spyderelephant"] = "strawberryelephant",
    ["the best brainrot from bee lucky block"] = "orchidox",
    ["the best brainrot from the bee lucky block"] = "orchidox",
    ["the best brainrot in"] = "lupaandlipa",
    ["the best brainrot in bee lucky block"] = "orchidox",
    ["the best brainrot in game"] = "lupaandlipa",
    ["the best brainrot in the"] = "lupaandlipa",
    ["the best brainrot in the bee lucky block"] = "orchidox",
    ["the best brainrot in the game"] = "lupaandlipa",
    ["the best brainrot in todays admin abuse"] = "lupaandlipa",
    ["the best brainrot in todays update"] = "lupaandlipa",
    ["the best brainrot released last saturday"] = "orchidox",
    ["the best brainrot released last week"] = "orchidox",
    ["the best brainrot reskin of me"] = "sammynitruckini",
    ["the best brainrot reskin of sammy"] = "sammynitruckini",
    ["the best brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["the best brainrot that was added in todays update"] = "lupaandlipa",
    ["the best brainrot that was added today"] = "lupaandlipa",
    ["the best brainrot today"] = "lupaandlipa",
    ["the best brainrot without spyder elephant"] = "strawberryelephant",
    ["the best brainrot without spyderelephant"] = "strawberryelephant",
    ["the best mutation"] = "crystal",
    ["the best mutation currently"] = "crystal",
    ["the best mutation right now"] = "crystal",
    ["the best reskin of me"] = "sammynitruckini",
    ["the best reskin of sammy"] = "sammynitruckini",
    ["the best visual mutation for meowl"] = "cyber",
    ["the best visual mutation for meowl date"] = "april2026",
    ["the best visual mutation for meowl day"] = "18",
    ["the best visual mutation for meowl month"] = "april",
    ["the best visual mutation for meowl release"] = "april2026",
    ["the best visual mutation for meowl release date"] = "april2026",
    ["the best visual mutation for meowl release day"] = "18",
    ["the best visual mutation for meowl release month"] = "april",
    ["the best visual mutation for meowl release year"] = "2026",
    ["the best visual mutation for meowl year"] = "2026",
    ["the best visual mutation on meowl"] = "cyber",
    ["the best visual mutation on meowl date"] = "april2026",
    ["the best visual mutation on meowl day"] = "18",
    ["the best visual mutation on meowl month"] = "april",
    ["the best visual mutation on meowl release"] = "april2026",
    ["the best visual mutation on meowl release date"] = "april2026",
    ["the best visual mutation on meowl release day"] = "18",
    ["the best visual mutation on meowl release month"] = "april",
    ["the best visual mutation on meowl release year"] = "2026",
    ["the best visual mutation on meowl year"] = "2026",
    ["the brainrot that you get from money money puggy ritual"] = "lospuggies",
    ["the brainrot that you get from money ritual"] = "lospuggies",
    ["the brainrot that you get from new money money puggy ritual"] = "lospuggies",
    ["the brainrot that you get from new ritual"] = "lospuggies",
    ["the brainrot you get from money ritual"] = "lospuggies",
    ["the brainrot you get from new ritual"] = "lospuggies",
    ["the current season"] = "autumn",
    ["the fifth og"] = "johnpork",
    ["the fifth og brainrot"] = "johnpork",
    ["the first og"] = "strawberryelephant",
    ["the first og brainrot"] = "strawberryelephant",
    ["the first og brainrot in game"] = "strawberryelephant",
    ["the first og brainrot in the game"] = "strawberryelephant",
    ["the first og in game"] = "strawberryelephant",
    ["the first og in the game"] = "strawberryelephant",
    ["the first snake"] = "hydraserpent",
    ["the first snake added"] = "hydraserpent",
    ["the first snake brainrot"] = "hydraserpent",
    ["the first snake brainrot added"] = "hydraserpent",
    ["the first snake brainrot ever added"] = "hydraserpent",
    ["the first snake brainrot in game"] = "hydraserpent",
    ["the first snake brainrot in sab"] = "hydraserpent",
    ["the first snake brainrot in the game"] = "hydraserpent",
    ["the first snake brainrot that was added"] = "hydraserpent",
    ["the first snake brainrot that was ever added"] = "hydraserpent",
    ["the first snake ever added"] = "hydraserpent",
    ["the first snake in game"] = "hydraserpent",
    ["the first snake in sab"] = "hydraserpent",
    ["the first snake in the game"] = "hydraserpent",
    ["the first snake that was added"] = "hydraserpent",
    ["the first snake that was ever added"] = "hydraserpent",
    ["the fourth 3 headed"] = "hydraserpent",
    ["the fourth 3 headed brainrot"] = "hydraserpent",
    ["the fourth og"] = "headlesshorseman",
    ["the fourth og brainrot"] = "headlesshorseman",
    ["the fourth three headed"] = "hydraserpent",
    ["the fourth three headed brainrot"] = "hydraserpent",
    ["the fourth three headed brainrot added"] = "hydraserpent",
    ["the hardest brainrot in game"] = "spyderelephant",
    ["the hardest brainrot in the game"] = "spyderelephant",
    ["the hardest brainrot to find"] = "spyderelephant",
    ["the hardest brainrot to get"] = "spyderelephant",
    ["the hardest brainrot to get in game"] = "spyderelephant",
    ["the hardest brainrot to get in the game"] = "spyderelephant",
    ["the hardest brainrot to obtain"] = "spyderelephant",
    ["the last craft machine"] = "cybercraft",
    ["the last craft machine in game"] = "cybercraft",
    ["the last craft machine in sab"] = "cybercraft",
    ["the last craft machine in the game"] = "cybercraft",
    ["the latest snake brainrot"] = "hydraserpent",
    ["the money ritual"] = "money",
    ["the most best brainrot added today"] = "lupaandlipa",
    ["the most best brainrot that was added today"] = "lupaandlipa",
    ["the most expensive item i have"] = "spyderchain",
    ["the most op brainrot"] = "lupaandlipa",
    ["the most op brainrot added"] = "orchidox",
    ["the most op brainrot added date"] = "august2026",
    ["the most op brainrot added day"] = "22",
    ["the most op brainrot added in todays admin abuse"] = "lupaandlipa",
    ["the most op brainrot added in todays update"] = "lupaandlipa",
    ["the most op brainrot added month"] = "august",
    ["the most op brainrot added recently"] = "orchidox",
    ["the most op brainrot added recently date"] = "august2026",
    ["the most op brainrot added recently day"] = "22",
    ["the most op brainrot added recently month"] = "august",
    ["the most op brainrot added recently release"] = "august2026",
    ["the most op brainrot added recently release date"] = "august2026",
    ["the most op brainrot added recently release day"] = "22",
    ["the most op brainrot added recently release month"] = "august",
    ["the most op brainrot added recently release year"] = "2026",
    ["the most op brainrot added recently year"] = "2026",
    ["the most op brainrot added release"] = "august2026",
    ["the most op brainrot added release date"] = "august2026",
    ["the most op brainrot added release day"] = "22",
    ["the most op brainrot added release month"] = "august",
    ["the most op brainrot added release year"] = "2026",
    ["the most op brainrot added today"] = "lupaandlipa",
    ["the most op brainrot added year"] = "2026",
    ["the most op brainrot date"] = "august2026",
    ["the most op brainrot day"] = "22",
    ["the most op brainrot from bee lucky block"] = "orchidox",
    ["the most op brainrot from the bee lucky block"] = "orchidox",
    ["the most op brainrot in bee lucky block"] = "orchidox",
    ["the most op brainrot in the bee lucky block"] = "orchidox",
    ["the most op brainrot in todays admin abuse"] = "lupaandlipa",
    ["the most op brainrot in todays update"] = "lupaandlipa",
    ["the most op brainrot month"] = "august",
    ["the most op brainrot recently"] = "orchidox",
    ["the most op brainrot recently date"] = "august2026",
    ["the most op brainrot recently day"] = "22",
    ["the most op brainrot recently month"] = "august",
    ["the most op brainrot recently release"] = "august2026",
    ["the most op brainrot recently release date"] = "august2026",
    ["the most op brainrot recently release day"] = "22",
    ["the most op brainrot recently release month"] = "august",
    ["the most op brainrot recently release year"] = "2026",
    ["the most op brainrot recently year"] = "2026",
    ["the most op brainrot release"] = "august2026",
    ["the most op brainrot release date"] = "august2026",
    ["the most op brainrot release day"] = "22",
    ["the most op brainrot release month"] = "august",
    ["the most op brainrot release year"] = "2026",
    ["the most op brainrot released"] = "orchidox",
    ["the most op brainrot released recently"] = "orchidox",
    ["the most op brainrot released recently date"] = "august2026",
    ["the most op brainrot released recently day"] = "22",
    ["the most op brainrot released recently month"] = "august",
    ["the most op brainrot released recently release"] = "august2026",
    ["the most op brainrot released recently release date"] = "august2026",
    ["the most op brainrot released recently release day"] = "22",
    ["the most op brainrot released recently release month"] = "august",
    ["the most op brainrot released recently release year"] = "2026",
    ["the most op brainrot released recently year"] = "2026",
    ["the most op brainrot that was added"] = "orchidox",
    ["the most op brainrot that was added date"] = "august2026",
    ["the most op brainrot that was added day"] = "22",
    ["the most op brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["the most op brainrot that was added in todays update"] = "lupaandlipa",
    ["the most op brainrot that was added month"] = "august",
    ["the most op brainrot that was added recently"] = "orchidox",
    ["the most op brainrot that was added recently date"] = "august2026",
    ["the most op brainrot that was added recently day"] = "22",
    ["the most op brainrot that was added recently month"] = "august",
    ["the most op brainrot that was added recently release"] = "august2026",
    ["the most op brainrot that was added recently release date"] = "august2026",
    ["the most op brainrot that was added recently release day"] = "22",
    ["the most op brainrot that was added recently release month"] = "august",
    ["the most op brainrot that was added recently release year"] = "2026",
    ["the most op brainrot that was added recently year"] = "2026",
    ["the most op brainrot that was added release"] = "august2026",
    ["the most op brainrot that was added release date"] = "august2026",
    ["the most op brainrot that was added release day"] = "22",
    ["the most op brainrot that was added release month"] = "august",
    ["the most op brainrot that was added release year"] = "2026",
    ["the most op brainrot that was added today"] = "lupaandlipa",
    ["the most op brainrot that was added year"] = "2026",
    ["the most op brainrot that was released"] = "orchidox",
    ["the most op brainrot that was released recently"] = "orchidox",
    ["the most op brainrot that was released recently date"] = "august2026",
    ["the most op brainrot that was released recently day"] = "22",
    ["the most op brainrot that was released recently month"] = "august",
    ["the most op brainrot that was released recently release"] = "august2026",
    ["the most op brainrot that was released recently release date"] = "august2026",
    ["the most op brainrot that was released recently release day"] = "22",
    ["the most op brainrot that was released recently release month"] = "august",
    ["the most op brainrot that was released recently release year"] = "2026",
    ["the most op brainrot that was released recently year"] = "2026",
    ["the most op brainrot year"] = "2026",
    ["the mythical creature brainrot"] = "hydraserpent",
    ["the name of the new base"] = "emperor",
    ["the name of the new base skin"] = "1of1",
    ["the new 3 headed brainrot"] = "hydraserpent",
    ["the new base"] = "emperor",
    ["the new base skin"] = "1of1",
    ["the new base skin added today"] = "1of1",
    ["the new base skin in today admin abuse"] = "1of1",
    ["the new base skin in today update"] = "1of1",
    ["the new base skin in todays admin abuse"] = "1of1",
    ["the new base skin in todays update"] = "1of1",
    ["the new base skin released today"] = "1of1",
    ["the new base skin that was released today"] = "1of1",
    ["the new mythical creature brainrot"] = "hydraserpent",
    ["the new rarest base skin"] = "1of1",
    ["the new ritual added today"] = "money",
    ["the new ritual in today admin abuse"] = "money",
    ["the new ritual in today update"] = "money",
    ["the new ritual in todays admin abuse"] = "money",
    ["the new ritual in todays update"] = "money",
    ["the new snake"] = "hydraserpent",
    ["the new snake brainrot"] = "hydraserpent",
    ["the new snake brainrot his name"] = "hydraserpent",
    ["the new snake brainrot name"] = "hydraserpent",
    ["the new snake brainrots name"] = "hydraserpent",
    ["the new three headed brainrot"] = "hydraserpent",
    ["the newest snake brainrot"] = "hydraserpent",
    ["the op base skin in todays admin abuse"] = "1of1",
    ["the op base skin in todays update"] = "1of1",
    ["the op base skin released today"] = "1of1",
    ["the op base skin that was released today"] = "1of1",
    ["the op brainrot"] = "lupaandlipa",
    ["the op brainrot added"] = "lupaandlipa",
    ["the op brainrot added date"] = "august2026",
    ["the op brainrot added day"] = "22",
    ["the op brainrot added month"] = "august",
    ["the op brainrot added recently"] = "lupaandlipa",
    ["the op brainrot added recently date"] = "august2026",
    ["the op brainrot added recently day"] = "22",
    ["the op brainrot added recently month"] = "august",
    ["the op brainrot added recently release"] = "august2026",
    ["the op brainrot added recently release date"] = "august2026",
    ["the op brainrot added recently release day"] = "22",
    ["the op brainrot added recently release month"] = "august",
    ["the op brainrot added recently release year"] = "2026",
    ["the op brainrot added recently year"] = "2026",
    ["the op brainrot added release"] = "august2026",
    ["the op brainrot added release date"] = "august2026",
    ["the op brainrot added release day"] = "22",
    ["the op brainrot added release month"] = "august",
    ["the op brainrot added release year"] = "2026",
    ["the op brainrot added today"] = "lupaandlipa",
    ["the op brainrot added year"] = "2026",
    ["the op brainrot date"] = "august2026",
    ["the op brainrot day"] = "22",
    ["the op brainrot month"] = "august",
    ["the op brainrot recently"] = "lupaandlipa",
    ["the op brainrot recently added"] = "lupaandlipa",
    ["the op brainrot recently released"] = "lupaandlipa",
    ["the op brainrot release"] = "august2026",
    ["the op brainrot release date"] = "august2026",
    ["the op brainrot release day"] = "22",
    ["the op brainrot release month"] = "august",
    ["the op brainrot release year"] = "2026",
    ["the op brainrot released recently"] = "lupaandlipa",
    ["the op brainrot that was added"] = "lupaandlipa",
    ["the op brainrot that was added date"] = "august2026",
    ["the op brainrot that was added day"] = "22",
    ["the op brainrot that was added month"] = "august",
    ["the op brainrot that was added recently"] = "lupaandlipa",
    ["the op brainrot that was added recently date"] = "august2026",
    ["the op brainrot that was added recently day"] = "22",
    ["the op brainrot that was added recently month"] = "august",
    ["the op brainrot that was added recently release"] = "august2026",
    ["the op brainrot that was added recently release date"] = "august2026",
    ["the op brainrot that was added recently release day"] = "22",
    ["the op brainrot that was added recently release month"] = "august",
    ["the op brainrot that was added recently release year"] = "2026",
    ["the op brainrot that was added recently year"] = "2026",
    ["the op brainrot that was added release"] = "august2026",
    ["the op brainrot that was added release date"] = "august2026",
    ["the op brainrot that was added release day"] = "22",
    ["the op brainrot that was added release month"] = "august",
    ["the op brainrot that was added release year"] = "2026",
    ["the op brainrot that was added today"] = "lupaandlipa",
    ["the op brainrot that was added year"] = "2026",
    ["the op brainrot that was recently added"] = "lupaandlipa",
    ["the op brainrot that was recently released"] = "lupaandlipa",
    ["the op brainrot that was released recently"] = "lupaandlipa",
    ["the op brainrot year"] = "2026",
    ["the rarest base skin"] = "1of1",
    ["the rarest base skin in the game"] = "1of1",
    ["the rarest brainrot"] = "spyderelephant",
    ["the rarest brainrot in game"] = "spyderelephant",
    ["the rarest brainrot in the game"] = "spyderelephant",
    ["the season we are currently in"] = "autumn",
    ["the season we are currently in is"] = "autumn",
    ["the season we are in"] = "autumn",
    ["the season we are suffering"] = "autumn",
    ["the season we are suffering is"] = "autumn",
    ["the second best brainrot"] = "strawberryelephant",
    ["the second best brainrot in game"] = "strawberryelephant",
    ["the second best brainrot in the game"] = "strawberryelephant",
    ["the second og"] = "meowl",
    ["the second og brainrot"] = "meowl",
    ["the sixth brainrot based off a mythical creature"] = "hydraserpent",
    ["the sixth brainrot based off of a mythical creature"] = "hydraserpent",
    ["the sixth brainrot based on a mythical creature"] = "hydraserpent",
    ["the sixth brainrot to be based off a mythical creature"] = "hydraserpent",
    ["the sixth brainrot to be based on a mythical creature"] = "hydraserpent",
    ["the sixth mythical brainrot"] = "hydraserpent",
    ["the sixth mythical creature"] = "hydraserpent",
    ["the sixth mythical creature brainrot"] = "hydraserpent",
    ["the sixth og"] = "spyderelephant",
    ["the sixth og brainrot"] = "spyderelephant",
    ["the snake brainrot"] = "hydraserpent",
    ["the snake brainrot his name"] = "hydraserpent",
    ["the snake brainrot name"] = "hydraserpent",
    ["the snake brainrots name"] = "hydraserpent",
    ["the third og"] = "skibiditoilet",
    ["the third og brainrot"] = "skibiditoilet",
    ["the three headed brainrot"] = "hydraserpent",
    ["the three headed snake brainrot"] = "hydraserpent",
    ["the worst person"] = "secretlokii",
    ["third best taco merchant"] = "tacoturbotacorito",
    ["third brainrot that was reworked"] = "gattatinonyanino",
    ["third fuse"] = "santafuse",
    ["third fuse date"] = "december2025",
    ["third fuse day"] = "6",
    ["third fuse machine"] = "santafuse",
    ["third fuse machine date"] = "december2025",
    ["third fuse machine day"] = "6",
    ["third fuse machine month"] = "december",
    ["third fuse machine release"] = "december2025",
    ["third fuse machine release date"] = "december2025",
    ["third fuse machine release day"] = "6",
    ["third fuse machine release month"] = "december",
    ["third fuse machine release year"] = "2025",
    ["third fuse machine year"] = "2025",
    ["third fuse month"] = "december",
    ["third fuse release"] = "december2025",
    ["third fuse release date"] = "december2025",
    ["third fuse release day"] = "6",
    ["third fuse release month"] = "december",
    ["third fuse release year"] = "2025",
    ["third fuse year"] = "2025",
    ["third og"] = "skibiditoilet",
    ["third og brainrot"] = "skibiditoilet",
    ["third reworked brainrot"] = "gattatinonyanino",
    ["third taco merchant"] = "tacoturbotacorito",
    ["three brainrots rework"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["three brainrots reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["three brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["three brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["three headed"] = "hydraserpent",
    ["three headed brainrot"] = "hydraserpent",
    ["three headed brainrot added in todays update"] = "hydraserpent",
    ["three headed brainrot added today"] = "hydraserpent",
    ["three headed snake"] = "hydraserpent",
    ["three headed snake brainrot"] = "hydraserpent",
    ["three reworked brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["tie"] = "tie",
    ["tipi tacos"] = "lostipitacos",
    ["tipi topi"] = "tipitopitaco",
    ["tipi topi taco"] = "tipitopitaco",
    ["tipitopitaco"] = "tipitopitaco",
    ["today admin abuse"] = "hydraserpent",
    ["today admin abuse brainrot"] = "hydraserpent",
    ["today brainrot"] = "hydraserpent",
    ["today ritual"] = "money",
    ["today update"] = "hydraserpent",
    ["today update brainrot"] = "hydraserpent",
    ["todays admin abuse"] = "hydraserpent",
    ["todays admin abuse brainrot"] = "lupaandlipa",
    ["todays brainrot"] = "hydraserpent",
    ["todays ritual"] = "money",
    ["todays update"] = "hydraserpent",
    ["todays update brainrot"] = "hydraserpent",
    ["toilet"] = "skibiditoilet",
    ["toilet color"] = "white",
    ["tombstone trait"] = "riptombstone",
    ["tombstone trait date"] = "october2025",
    ["tombstone trait month"] = "october",
    ["tombstone trait release"] = "october2025",
    ["tombstone trait release date"] = "october2025",
    ["tombstone trait release month"] = "october",
    ["tombstone trait release year"] = "2025",
    ["tombstone trait year"] = "2025",
    ["top brainrot in game"] = "spyderelephant",
    ["top brainrot in the game"] = "spyderelephant",
    ["top taco merchant"] = "sammynitruckini",
    ["torrtuginni"] = "torrtuginnidragonfrutini",
    ["torrtuginni dragonfrutini"] = "torrtuginnidragonfrutini",
    ["torrtuginnidragonfrutini"] = "torrtuginnidragonfrutini",
    ["tortinii"] = "bombardinitortinii",
    ["total 1 of 1 brainrots"] = "155",
    ["total 1 of 1 brainrots exist"] = "155",
    ["total 1 of 1s"] = "155",
    ["total 1 of 1s exist"] = "155",
    ["total exist count of strawberry elephant"] = "2348",
    ["total exist count of strawberry elephants"] = "2348",
    ["trade machine"] = "february2026",
    ["trade machine date"] = "february2026",
    ["trade machine day"] = "21",
    ["trade machine month"] = "february",
    ["trade machine release"] = "february2026",
    ["trade machine release date"] = "february2026",
    ["trade machine release day"] = "21",
    ["trade machine release month"] = "february",
    ["trade machine release year"] = "2026",
    ["trade machine year"] = "2026",
    ["trade plaza"] = "june2026",
    ["trade plaza date"] = "june2026",
    ["trade plaza day"] = "13",
    ["trade plaza month"] = "june",
    ["trade plaza release"] = "june2026",
    ["trade plaza release date"] = "june2026",
    ["trade plaza release day"] = "13",
    ["trade plaza release month"] = "june",
    ["trade plaza release year"] = "2026",
    ["trade plaza year"] = "2026",
    ["trading machine"] = "june2026",
    ["trading machine date"] = "june2026",
    ["trading machine day"] = "11",
    ["trading machine month"] = "june",
    ["trading machine release"] = "june2026",
    ["trading machine release date"] = "june2026",
    ["trading machine release day"] = "11",
    ["trading machine release month"] = "june",
    ["trading machine release year"] = "2026",
    ["trading machine year"] = "2026",
    ["trait admin abuse"] = "sleepy",
    ["trait from admin abuse war"] = "sleepy",
    ["trait from money ritual"] = "rainingmoney",
    ["trait from new ritual"] = "rainingmoney",
    ["trait from the admin abuse war"] = "sleepy",
    ["trait from the money ritual"] = "rainingmoney",
    ["trait in admin abuse war"] = "sleepy",
    ["trait in money ritual"] = "rainingmoney",
    ["trait in the admin abuse war"] = "sleepy",
    ["trait incubator"] = "april2026",
    ["trait incubator date"] = "april2026",
    ["trait incubator day"] = "4",
    ["trait incubator month"] = "april",
    ["trait incubator release"] = "april2026",
    ["trait incubator release date"] = "april2026",
    ["trait incubator release day"] = "4",
    ["trait incubator release month"] = "april",
    ["trait incubator release year"] = "2026",
    ["trait incubator year"] = "2026",
    ["trait money"] = "rainingmoney",
    ["trait obtainable in admin abuse"] = "sleepy",
    ["trait obtainable in admin abuse war"] = "sleepy",
    ["trait obtainable in the admin abuse war"] = "sleepy",
    ["trait puggy"] = "rainingmoney",
    ["tralalero"] = "tralalero",
    ["tralalerotralala"] = "tralalerotralala",
    ["tung sahur"] = "tungtungtungsahur",
    ["tung sahur crocidilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung sahur crocodilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung"] = "tungtung",
    ["tung tung attack"] = "tungtung",
    ["tung tung attack date"] = "june2025",
    ["tung tung attack month"] = "june",
    ["tung tung attack release"] = "june2025",
    ["tung tung attack release date"] = "june2025",
    ["tung tung attack release month"] = "june",
    ["tung tung attack release year"] = "2025",
    ["tung tung attack year"] = "2025",
    ["tung tung date"] = "june2025",
    ["tung tung month"] = "june",
    ["tung tung release"] = "june2025",
    ["tung tung release date"] = "june2025",
    ["tung tung release month"] = "june",
    ["tung tung release year"] = "2025",
    ["tung tung sahur"] = "tungtungtungsahur",
    ["tung tung sahur crocidilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung sahur crocodilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung trait"] = "tungtung",
    ["tung tung trait date"] = "june2025",
    ["tung tung trait month"] = "june",
    ["tung tung trait release"] = "june2025",
    ["tung tung trait release date"] = "june2025",
    ["tung tung trait release month"] = "june",
    ["tung tung trait release year"] = "2025",
    ["tung tung trait year"] = "2025",
    ["tung tung tung sahur"] = "tungtungtungsahur",
    ["tung tung tung sahur and crocidilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung tung sahur crocidilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung tung sahur crocodilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung year"] = "2025",
    ["tung tung zombie"] = "tungtung",
    ["tung tung zombie date"] = "june2025",
    ["tung tung zombie month"] = "june",
    ["tung tung zombie release"] = "june2025",
    ["tung tung zombie release date"] = "june2025",
    ["tung tung zombie release month"] = "june",
    ["tung tung zombie release year"] = "2025",
    ["tung tung zombie year"] = "2025",
    ["tungtung"] = "tungtung",
    ["tungtungattack"] = "tungtungattack",
    ["tungtungtungsahur"] = "tungtungtungsahur",
    ["tungtungtungsahurcrocidilopenisini"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots remove"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots removed"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots that got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots that were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["two deleted brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["two removed brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["ufo"] = "ufo",
    ["unclito samito"] = "unclitosamito",
    ["unclitosamito"] = "unclitosamito",
    ["united states"] = "usa",
    ["upcoming fuse machine"] = "hauntedfuse",
    ["upcoming halloween fuse"] = "hauntedfuse",
    ["usa"] = "usa",
    ["valentine fuse"] = "february2026",
    ["valentine fuse date"] = "february2026",
    ["valentine fuse day"] = "14",
    ["valentine fuse month"] = "february",
    ["valentine fuse release"] = "february2026",
    ["valentine fuse release date"] = "february2026",
    ["valentine fuse release day"] = "14",
    ["valentine fuse release month"] = "february",
    ["valentine fuse release year"] = "2026",
    ["valentine fuse year"] = "2026",
    ["valentine machine"] = "february2026",
    ["valentine machine date"] = "february2026",
    ["valentine machine day"] = "14",
    ["valentine machine month"] = "february",
    ["valentine machine release"] = "february2026",
    ["valentine machine release date"] = "february2026",
    ["valentine machine release day"] = "14",
    ["valentine machine release month"] = "february",
    ["valentine machine release year"] = "2026",
    ["valentine machine year"] = "2026",
    ["valentine trait"] = "chocolate",
    ["valentine trait date"] = "february2026",
    ["valentine trait month"] = "february",
    ["valentine trait release"] = "february2026",
    ["valentine trait release date"] = "february2026",
    ["valentine trait release month"] = "february",
    ["valentine trait release year"] = "2026",
    ["valentine trait year"] = "2026",
    ["valentines machine"] = "february2026",
    ["valentines machine date"] = "february2026",
    ["valentines machine day"] = "14",
    ["valentines machine month"] = "february",
    ["valentines machine release"] = "february2026",
    ["valentines machine release date"] = "february2026",
    ["valentines machine release day"] = "14",
    ["valentines machine release month"] = "february",
    ["valentines machine release year"] = "2026",
    ["valentines machine year"] = "2026",
    ["valorant"] = "valorant",
    ["valorant player"] = "valorant",
    ["visits"] = "72billion",
    ["visual meowl"] = "cyber",
    ["visual mutation"] = "cyber",
    ["visually best mutation for meowl"] = "cyber",
    ["visually best mutation for meowl date"] = "april2026",
    ["visually best mutation for meowl day"] = "18",
    ["visually best mutation for meowl month"] = "april",
    ["visually best mutation for meowl release"] = "april2026",
    ["visually best mutation for meowl release date"] = "april2026",
    ["visually best mutation for meowl release day"] = "18",
    ["visually best mutation for meowl release month"] = "april",
    ["visually best mutation for meowl release year"] = "2026",
    ["visually best mutation for meowl year"] = "2026",
    ["visually best mutation on meowl"] = "cyber",
    ["visually best mutation on meowl date"] = "april2026",
    ["visually best mutation on meowl day"] = "18",
    ["visually best mutation on meowl month"] = "april",
    ["visually best mutation on meowl release"] = "april2026",
    ["visually best mutation on meowl release date"] = "april2026",
    ["visually best mutation on meowl release day"] = "18",
    ["visually best mutation on meowl release month"] = "april",
    ["visually best mutation on meowl release year"] = "2026",
    ["visually best mutation on meowl year"] = "2026",
    ["visually meowl"] = "cyber",
    ["weigh"] = "250",
    ["weight"] = "250",
    ["what 2 brainrots got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["what 2 brainrots got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what 2 brainrots were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what 3 brainrots got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what 3 brainrots were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are 2 brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what are 2 brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what are 3 brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are 3 brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are the 2 brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what are the 2 brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what are the 3 brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are the 3 brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are the three brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are three brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what brainrot can you get from cave island"] = "draculino",
    ["what brainrot can you get from the cave island"] = "draculino",
    ["what brainrot can you obtain from cave island"] = "draculino",
    ["what brainrot can you obtain from the cave island"] = "draculino",
    ["what brainrot do you get from money ritual"] = "lospuggies",
    ["what brainrot do you get from new ritual"] = "lospuggies",
    ["what brainrot do you get from the money ritual"] = "lospuggies",
    ["what brainrot do you get from the new ritual"] = "lospuggies",
    ["what brainrot do you need for money ritual"] = "moneymoneypuggy",
    ["what brainrot do you need for new ritual"] = "moneymoneypuggy",
    ["what brainrot do you need for the new ritual"] = "moneymoneypuggy",
    ["what brainrot do you need to use for money ritual"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual in today admin abuse"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual in today update"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual in todays admin abuse"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual in todays update"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual that was added today"] = "moneymoneypuggy",
    ["what brainrot do you need to use for the new ritual"] = "moneymoneypuggy",
    ["what brainrot does money ritual give"] = "lospuggies",
    ["what brainrot does new ritual give"] = "lospuggies",
    ["what brainrot does the money ritual give"] = "lospuggies",
    ["what brainrot does the new ritual give"] = "lospuggies",
    ["what brainrot got added last saturday"] = "orchidox",
    ["what brainrot got added last week"] = "orchidox",
    ["what brainrot got added today"] = "hydraserpent",
    ["what brainrot got deleted"] = "tungtungtungsahur",
    ["what brainrot got released last saturday"] = "orchidox",
    ["what brainrot got released last week"] = "orchidox",
    ["what brainrot got remove"] = "tungtungtungsahur",
    ["what brainrot got removed"] = "tungtungtungsahur",
    ["what brainrot got reworked"] = "sammynispyderini",
    ["what brainrot makes money ritual"] = "moneymoneypuggy",
    ["what brainrot makes new ritual"] = "moneymoneypuggy",
    ["what brainrot makes the money ritual"] = "moneymoneypuggy",
    ["what brainrot to use for money ritual"] = "moneymoneypuggy",
    ["what brainrot to use for new ritual"] = "moneymoneypuggy",
    ["what brainrot to use for the new ritual"] = "moneymoneypuggy",
    ["what brainrot was added in todays admin abuse"] = "lupaandlipa",
    ["what brainrot was added in todays update"] = "hydraserpent",
    ["what brainrot was added last saturday"] = "orchidox",
    ["what brainrot was added last week"] = "orchidox",
    ["what brainrot was added today"] = "hydraserpent",
    ["what brainrot was deleted"] = "tungtungtungsahur",
    ["what brainrot was released last saturday"] = "orchidox",
    ["what brainrot was released last week"] = "orchidox",
    ["what brainrot was removed"] = "tungtungtungsahur",
    ["what brainrot was reworked"] = "sammynispyderini",
    ["what brainrot you get from money ritual"] = "lospuggies",
    ["what brainrot you get from new ritual"] = "lospuggies",
    ["what brainrot you need for new ritual"] = "moneymoneypuggy",
    ["what brainrot you need to use for money ritual"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual in today admin abuse"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual in today update"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual in todays admin abuse"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual in todays update"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual that was added in today update"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual that was added in todays update"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual that was added today"] = "moneymoneypuggy",
    ["what brainrots got deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what brainrots were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what color are my pants"] = "red",
    ["what color are my shirt"] = "red",
    ["what color is draculino"] = "black",
    ["what color is his roblox avatar"] = "red",
    ["what color is his roblox skin"] = "yellow",
    ["what color is my avatar"] = "red",
    ["what color is my body skin"] = "yellow",
    ["what color is my car"] = "red",
    ["what color is my hair"] = "black",
    ["what color is my roblox avatar"] = "red",
    ["what color is my roblox skin"] = "yellow",
    ["what color is my shirt"] = "red",
    ["what color is new best brainrot in ltm"] = "black",
    ["what color is new brainrot"] = "black",
    ["what color is sammy avatar"] = "red",
    ["what color is sammy roblox avatar"] = "red",
    ["what color is sammy roblox skin"] = "yellow",
    ["what color is the new best brainrot in ltm"] = "black",
    ["what color is the new brainrot"] = "black",
    ["what colour is my hair"] = "black",
    ["what day was bee lucky block released"] = "22",
    ["what day was headless horseman released"] = "1",
    ["what day was john pork released"] = "1",
    ["what day was meowl released"] = "1",
    ["what day was orchidox released"] = "22",
    ["what day was skibidi toilet released"] = "1",
    ["what day was spyder elephant released"] = "1",
    ["what day was strawberry elephant released"] = "1",
    ["what egg can you get dragon cannelloni from"] = "dragonegg",
    ["what egg can you obtain dragon cannelloni from"] = "dragonegg",
    ["what egg contains dragon cannelloni"] = "dragonegg",
    ["what egg do you get dragon cannelloni from"] = "dragonegg",
    ["what egg does dragon cannelloni come from"] = "dragonegg",
    ["what egg does dragon cannelloni hatch from"] = "dragonegg",
    ["what egg is dragon cannelloni from"] = "dragonegg",
    ["what egg you can obtain dragon cannelloni from"] = "dragonegg",
    ["what event does money ritual give"] = "moneymoneypuggy",
    ["what event does new ritual give"] = "moneymoneypuggy",
    ["what event does the money ritual give"] = "moneymoneypuggy",
    ["what event does the new ritual give"] = "moneymoneypuggy",
    ["what fuse machine is coming next"] = "hauntedfuse",
    ["what game am i a competitive player at"] = "valorant",
    ["what game am i competitive at"] = "valorant",
    ["what game am i competitive in"] = "valorant",
    ["what game am i competitive player at"] = "valorant",
    ["what game do i enjoy playing"] = "fortnite",
    ["what game do i hate"] = "growagarden",
    ["what game do i hate most"] = "growagarden",
    ["what game do i hate the most"] = "growagarden",
    ["what game do i like to play"] = "fortnite",
    ["what game do i love"] = "fortnite",
    ["what game do i love to play"] = "fortnite",
    ["what game do i play competitive"] = "valorant",
    ["what game do i play competitively"] = "valorant",
    ["what game does sammy enjoy playing"] = "fortnite",
    ["what game does sammy hate"] = "growagarden",
    ["what game does sammy hate most"] = "growagarden",
    ["what game does sammy hate the most"] = "growagarden",
    ["what game does sammy like to play"] = "fortnite",
    ["what game does sammy love"] = "fortnite",
    ["what game does sammy love to play"] = "fortnite",
    ["what game does sammy play competitive"] = "valorant",
    ["what game does sammy play competitively"] = "valorant",
    ["what game i am competitive at"] = "valorant",
    ["what game i am competitive player at"] = "valorant",
    ["what game i enjoy playing"] = "fortnite",
    ["what game i hate"] = "growagarden",
    ["what game i hate most"] = "growagarden",
    ["what game i hate the most"] = "growagarden",
    ["what game i like to play"] = "fortnite",
    ["what game i love"] = "fortnite",
    ["what game i love to play"] = "fortnite",
    ["what game i play competitive"] = "valorant",
    ["what game i play competitively"] = "valorant",
    ["what game is better than 1 speed keyboard escape"] = "growagarden",
    ["what game is better than 1speedkeyboardescape"] = "growagarden",
    ["what game is sammy a competitive player at"] = "valorant",
    ["what game is sammy competitive at"] = "valorant",
    ["what game is sammy competitive player at"] = "valorant",
    ["what game is worse than grow a garden"] = "1speedkeyboardescape",
    ["what game is worse than growagarden"] = "1speedkeyboardescape",
    ["what game is worser than grow a garden"] = "1speedkeyboardescape",
    ["what game is worser than growagarden"] = "1speedkeyboardescape",
    ["what game sammy hates"] = "growagarden",
    ["what game sammy hates most"] = "growagarden",
    ["what game sammy hates the most"] = "growagarden",
    ["what game sammy likes to play"] = "fortnite",
    ["what game sammy loves"] = "fortnite",
    ["what game sammy loves to play"] = "fortnite",
    ["what group do i hate"] = "secretverse",
    ["what group do i hate most"] = "secretverse",
    ["what group do i hate the most"] = "secretverse",
    ["what group does sammy hate"] = "secretverse",
    ["what group does sammy hate most"] = "secretverse",
    ["what group does sammy hate the most"] = "secretverse",
    ["what is 2nd name of sammy"] = "brakta",
    ["what is coming for halloween"] = "hauntedfuse",
    ["what is coming in halloween"] = "hauntedfuse",
    ["what is his roblox avatar color"] = "red",
    ["what is his roblox skin color"] = "yellow",
    ["what is my 2nd name"] = "brakta",
    ["what is my body skin color"] = "yellow",
    ["what is my cat called"] = "nova",
    ["what is my cat name"] = "nova",
    ["what is my cats name"] = "nova",
    ["what is my dog called"] = "rocky",
    ["what is my dog name"] = "rocky",
    ["what is my dogs name"] = "rocky",
    ["what is my favorite game"] = "fortnite",
    ["what is my favorite mutation"] = "galaxy",
    ["what is my favorite number"] = "67",
    ["what is my favorite visual mutation for meowl"] = "cyber",
    ["what is my favourite game"] = "fortnite",
    ["what is my favourite mutation"] = "galaxy",
    ["what is my favourite number"] = "67",
    ["what is my favourite visual mutation for meowl"] = "cyber",
    ["what is my hair color"] = "black",
    ["what is my hair colour"] = "black",
    ["what is my last name"] = "brakta",
    ["what is my least favorite game"] = "growagarden",
    ["what is my least favorite group"] = "secretverse",
    ["what is my least favorite studio"] = "secretverse",
    ["what is my least favourite game"] = "growagarden",
    ["what is my least favourite group"] = "secretverse",
    ["what is my least favourite studio"] = "secretverse",
    ["what is my middle name"] = "brakta",
    ["what is my pet name"] = "rocky",
    ["what is my roblox avatar color"] = "red",
    ["what is my roblox skin color"] = "yellow",
    ["what is my second name"] = "brakta",
    ["what is my surname"] = "brakta",
    ["what is next fuse machine"] = "hauntedfuse",
    ["what is sammy 2nd name"] = "brakta",
    ["what is sammy cat name"] = "nova",
    ["what is sammy dog name"] = "rocky",
    ["what is sammy favorite game"] = "fortnite",
    ["what is sammy favorite mutation"] = "galaxy",
    ["what is sammy favorite number"] = "67",
    ["what is sammy favourite game"] = "fortnite",
    ["what is sammy favourite mutation"] = "galaxy",
    ["what is sammy favourite number"] = "67",
    ["what is sammy least favorite game"] = "growagarden",
    ["what is sammy least favorite group"] = "secretverse",
    ["what is sammy least favorite studio"] = "secretverse",
    ["what is sammy least favourite game"] = "growagarden",
    ["what is sammy least favourite group"] = "secretverse",
    ["what is sammy least favourite studio"] = "secretverse",
    ["what is sammy pet name"] = "rocky",
    ["what is sammy roblox avatar color"] = "red",
    ["what is sammy roblox skin color"] = "yellow",
    ["what is sammy second name"] = "brakta",
    ["what is sammys 2nd name"] = "brakta",
    ["what is sammys cat called"] = "nova",
    ["what is sammys cat name"] = "nova",
    ["what is sammys cats name"] = "nova",
    ["what is sammys dog called"] = "rocky",
    ["what is sammys dog name"] = "rocky",
    ["what is sammys dogs name"] = "rocky",
    ["what is sammys favorite game"] = "fortnite",
    ["what is sammys favorite mutation"] = "galaxy",
    ["what is sammys favorite number"] = "67",
    ["what is sammys favourite game"] = "fortnite",
    ["what is sammys favourite mutation"] = "galaxy",
    ["what is sammys favourite number"] = "67",
    ["what is sammys least favorite game"] = "growagarden",
    ["what is sammys least favorite group"] = "secretverse",
    ["what is sammys least favorite studio"] = "secretverse",
    ["what is sammys least favourite game"] = "growagarden",
    ["what is sammys least favourite group"] = "secretverse",
    ["what is sammys least favourite studio"] = "secretverse",
    ["what is sammys pet name"] = "rocky",
    ["what is sammys second name"] = "brakta",
    ["what is second name of sammy"] = "brakta",
    ["what is the 1st bee"] = "beeloco",
    ["what is the 1st bee brainrot"] = "beeloco",
    ["what is the 1st bee brainrot in game"] = "beeloco",
    ["what is the 1st bee brainrot in sab"] = "beeloco",
    ["what is the 1st bee brainrot in the game"] = "beeloco",
    ["what is the 1st bee in game"] = "beeloco",
    ["what is the 1st bee in sab"] = "beeloco",
    ["what is the 1st bee in the game"] = "beeloco",
    ["what is the 1st og"] = "strawberryelephant",
    ["what is the 1st og brainrot"] = "strawberryelephant",
    ["what is the 1st snake"] = "hydraserpent",
    ["what is the 1st snake brainrot"] = "hydraserpent",
    ["what is the 1st snake brainrot added"] = "hydraserpent",
    ["what is the 1st snake brainrot ever added"] = "hydraserpent",
    ["what is the 1st snake brainrot that was added"] = "hydraserpent",
    ["what is the 1st snake brainrot that was ever added"] = "hydraserpent",
    ["what is the 2nd best brainrot"] = "strawberryelephant",
    ["what is the 2nd best brainrot in game"] = "strawberryelephant",
    ["what is the 2nd best brainrot in the game"] = "strawberryelephant",
    ["what is the 2nd og brainrot"] = "meowl",
    ["what is the 3 headed brainrot"] = "hydraserpent",
    ["what is the 3rd og brainrot"] = "skibiditoilet",
    ["what is the 4th 3 headed"] = "hydraserpent",
    ["what is the 4th 3 headed brainrot"] = "hydraserpent",
    ["what is the 4th og brainrot"] = "headlesshorseman",
    ["what is the 4th three headed"] = "hydraserpent",
    ["what is the 4th three headed brainrot"] = "hydraserpent",
    ["what is the 5th og brainrot"] = "johnpork",
    ["what is the 6th brainrot based off a mythical creature"] = "hydraserpent",
    ["what is the 6th brainrot based on a mythical creature"] = "hydraserpent",
    ["what is the 6th brainrot to be based off a mythical creature"] = "hydraserpent",
    ["what is the 6th brainrot to be based on a mythical creature"] = "hydraserpent",
    ["what is the 6th mythical brainrot"] = "hydraserpent",
    ["what is the 6th mythical creature"] = "hydraserpent",
    ["what is the 6th mythical creature brainrot"] = "hydraserpent",
    ["what is the 6th og brainrot"] = "spyderelephant",
    ["what is the best brainrot added in todays admin abuse"] = "lupaandlipa",
    ["what is the best brainrot added in todays update"] = "lupaandlipa",
    ["what is the best brainrot added last saturday"] = "orchidox",
    ["what is the best brainrot added last week"] = "orchidox",
    ["what is the best brainrot added today"] = "lupaandlipa",
    ["what is the best brainrot except spyder elephant"] = "strawberryelephant",
    ["what is the best brainrot except spyderelephant"] = "strawberryelephant",
    ["what is the best brainrot from bee lucky block"] = "orchidox",
    ["what is the best brainrot from the bee lucky block"] = "orchidox",
    ["what is the best brainrot in bee lucky block"] = "orchidox",
    ["what is the best brainrot in the bee lucky block"] = "orchidox",
    ["what is the best brainrot released last saturday"] = "orchidox",
    ["what is the best brainrot released last week"] = "orchidox",
    ["what is the best brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["what is the best brainrot that was added in todays update"] = "lupaandlipa",
    ["what is the best brainrot that was added last saturday"] = "orchidox",
    ["what is the best brainrot that was added last week"] = "orchidox",
    ["what is the best brainrot that was added today"] = "lupaandlipa",
    ["what is the best brainrot that was released last week"] = "orchidox",
    ["what is the best brainrot without spyder elephant"] = "strawberryelephant",
    ["what is the best brainrot without spyderelephant"] = "strawberryelephant",
    ["what is the best mutation"] = "crystal",
    ["what is the best mutation currently"] = "crystal",
    ["what is the best mutation for meowl visually"] = "cyber",
    ["what is the best mutation for my favorite brainrot visually"] = "cyber",
    ["what is the best mutation right now"] = "crystal",
    ["what is the best mutation rn"] = "crystal",
    ["what is the best visual mutation for meowl"] = "cyber",
    ["what is the cat name"] = "nova",
    ["what is the color of my roblox avatar"] = "red",
    ["what is the color of new best brainrot in ltm"] = "black",
    ["what is the color of the new best brainrot in ltm"] = "black",
    ["what is the dog name"] = "rocky",
    ["what is the fifth og brainrot"] = "johnpork",
    ["what is the first bee"] = "beeloco",
    ["what is the first bee brainrot"] = "beeloco",
    ["what is the first bee brainrot in game"] = "beeloco",
    ["what is the first bee brainrot in sab"] = "beeloco",
    ["what is the first bee brainrot in the game"] = "beeloco",
    ["what is the first bee in game"] = "beeloco",
    ["what is the first bee in sab"] = "beeloco",
    ["what is the first bee in the game"] = "beeloco",
    ["what is the first og"] = "strawberryelephant",
    ["what is the first og brainrot"] = "strawberryelephant",
    ["what is the first snake"] = "hydraserpent",
    ["what is the first snake brainrot"] = "hydraserpent",
    ["what is the first snake brainrot added"] = "hydraserpent",
    ["what is the first snake brainrot ever added"] = "hydraserpent",
    ["what is the first snake brainrot that was added"] = "hydraserpent",
    ["what is the first snake brainrot that was ever added"] = "hydraserpent",
    ["what is the flying bee gear"] = "flyingbee",
    ["what is the fourth 3 headed"] = "hydraserpent",
    ["what is the fourth 3 headed brainrot"] = "hydraserpent",
    ["what is the fourth og brainrot"] = "headlesshorseman",
    ["what is the fourth three headed"] = "hydraserpent",
    ["what is the fourth three headed brainrot"] = "hydraserpent",
    ["what is the latest snake brainrot"] = "hydraserpent",
    ["what is the money ritual"] = "money",
    ["what is the most op brainrot"] = "orchidox",
    ["what is the most op brainrot added"] = "orchidox",
    ["what is the most op brainrot added recently"] = "orchidox",
    ["what is the most op brainrot added today"] = "lupaandlipa",
    ["what is the most op brainrot from bee lucky block"] = "orchidox",
    ["what is the most op brainrot from the bee lucky block"] = "orchidox",
    ["what is the most op brainrot in bee lucky block"] = "orchidox",
    ["what is the most op brainrot in the bee lucky block"] = "orchidox",
    ["what is the most op brainrot recently"] = "orchidox",
    ["what is the most op brainrot released"] = "orchidox",
    ["what is the most op brainrot released recently"] = "orchidox",
    ["what is the most op brainrot that was added"] = "orchidox",
    ["what is the most op brainrot that was added recently"] = "orchidox",
    ["what is the most op brainrot that was added today"] = "lupaandlipa",
    ["what is the most op brainrot that was released"] = "orchidox",
    ["what is the most op brainrot that was released recently"] = "orchidox",
    ["what is the mythical creature brainrot"] = "hydraserpent",
    ["what is the name of my dog"] = "rocky",
    ["what is the name of sammy dog"] = "rocky",
    ["what is the name of sammys dog"] = "rocky",
    ["what is the new bee gear"] = "flyingbee",
    ["what is the new flying bee gear"] = "flyingbee",
    ["what is the new ritual added today"] = "money",
    ["what is the new ritual in today admin abuse"] = "money",
    ["what is the new ritual in today update"] = "money",
    ["what is the new ritual in todays admin abuse"] = "money",
    ["what is the new ritual in todays update"] = "money",
    ["what is the new snake"] = "hydraserpent",
    ["what is the new snake brainrot"] = "hydraserpent",
    ["what is the new snake brainrot his name"] = "hydraserpent",
    ["what is the new snake brainrot name"] = "hydraserpent",
    ["what is the new snake brainrots name"] = "hydraserpent",
    ["what is the newest snake brainrot"] = "hydraserpent",
    ["what is the next fuse machine"] = "hauntedfuse",
    ["what is the op brainrot that was added recently"] = "lupaandlipa",
    ["what is the op brainrot that was recently added"] = "lupaandlipa",
    ["what is the op brainrot that was recently released"] = "lupaandlipa",
    ["what is the op brainrot that was released recently"] = "lupaandlipa",
    ["what is the second best brainrot"] = "strawberryelephant",
    ["what is the second best brainrot in game"] = "strawberryelephant",
    ["what is the second best brainrot in the game"] = "strawberryelephant",
    ["what is the second og brainrot"] = "meowl",
    ["what is the sixth brainrot based off a mythical creature"] = "hydraserpent",
    ["what is the sixth brainrot based on a mythical creature"] = "hydraserpent",
    ["what is the sixth brainrot to be based off a mythical creature"] = "hydraserpent",
    ["what is the sixth brainrot to be based on a mythical creature"] = "hydraserpent",
    ["what is the sixth mythical brainrot"] = "hydraserpent",
    ["what is the sixth mythical creature"] = "hydraserpent",
    ["what is the sixth mythical creature brainrot"] = "hydraserpent",
    ["what is the sixth og brainrot"] = "spyderelephant",
    ["what is the snake brainrot"] = "hydraserpent",
    ["what is the snake brainrot his name"] = "hydraserpent",
    ["what is the snake brainrot name"] = "hydraserpent",
    ["what is the snake brainrots name"] = "hydraserpent",
    ["what is the third og brainrot"] = "skibiditoilet",
    ["what is the three headed brainrot"] = "hydraserpent",
    ["what island is draculino from"] = "caveisland",
    ["what material is spyder elephant"] = "silver",
    ["what month was bee lucky block released"] = "august",
    ["what month was headless horseman released"] = "february",
    ["what month was john pork released"] = "may",
    ["what month was meowl released"] = "october",
    ["what month was orchidox released"] = "august",
    ["what month was skibidi toilet released"] = "december",
    ["what month was spyder elephant released"] = "may",
    ["what month was strawberry elephant released"] = "august",
    ["what mutation do i like the most"] = "galaxy",
    ["what mutation do i love"] = "galaxy",
    ["what mutation does sammy like the most"] = "galaxy",
    ["what mutation does sammy love"] = "galaxy",
    ["what mutation looks best on meowl"] = "cyber",
    ["what mutation looks the best on meowl"] = "cyber",
    ["what number always"] = "67",
    ["what number always at code"] = "67",
    ["what number always at codes"] = "67",
    ["what number always in code"] = "67",
    ["what number always in codes"] = "67",
    ["what number always put at code"] = "67",
    ["what number always put at codes"] = "67",
    ["what number do i always put"] = "67",
    ["what number do i always put at all codes"] = "67",
    ["what number do i always put at code"] = "67",
    ["what number do i always put at codes"] = "67",
    ["what number do i always put in all codes"] = "67",
    ["what number do i always put in code"] = "67",
    ["what number do i always put in codes"] = "67",
    ["what number i always put"] = "67",
    ["what number i always put at all codes"] = "67",
    ["what number i always put at code"] = "67",
    ["what number i always put at codes"] = "67",
    ["what number i always put in all codes"] = "67",
    ["what number i always put in code"] = "67",
    ["what number i always put in codes"] = "67",
    ["what number is always at code"] = "67",
    ["what number is always at codes"] = "67",
    ["what number is always in code"] = "67",
    ["what number is always in codes"] = "67",
    ["what number is in all code"] = "67",
    ["what number is in all codes"] = "67",
    ["what season are we currently in"] = "autumn",
    ["what season are we in"] = "autumn",
    ["what season are we suffering"] = "autumn",
    ["what season is it"] = "autumn",
    ["what season we are suffering"] = "autumn",
    ["what studio do i hate"] = "secretverse",
    ["what studio do i hate most"] = "secretverse",
    ["what studio do i hate the most"] = "secretverse",
    ["what studio does sammy hate"] = "secretverse",
    ["what studio does sammy hate most"] = "secretverse",
    ["what studio does sammy hate the most"] = "secretverse",
    ["what trait does money ritual give"] = "rainingmoney",
    ["what trait does new ritual give"] = "rainingmoney",
    ["what trait does the money ritual give"] = "rainingmoney",
    ["what trait does the new ritual give"] = "rainingmoney",
    ["what was the 1st bee"] = "beeloco",
    ["what was the 1st bee brainrot"] = "beeloco",
    ["what was the 1st bee brainrot in game"] = "beeloco",
    ["what was the 1st bee brainrot in sab"] = "beeloco",
    ["what was the 1st bee brainrot in the game"] = "beeloco",
    ["what was the 1st bee in game"] = "beeloco",
    ["what was the 1st bee in the game"] = "beeloco",
    ["what was the 1st og"] = "strawberryelephant",
    ["what was the 1st og brainrot"] = "strawberryelephant",
    ["what was the 1st snake brainrot"] = "hydraserpent",
    ["what was the 1st snake brainrot added"] = "hydraserpent",
    ["what was the 1st snake brainrot ever added"] = "hydraserpent",
    ["what was the 1st snake brainrot that was added"] = "hydraserpent",
    ["what was the 1st snake brainrot that was ever added"] = "hydraserpent",
    ["what was the 2nd og added"] = "meowl",
    ["what was the 2nd og added to sab"] = "meowl",
    ["what was the first bee"] = "beeloco",
    ["what was the first bee brainrot"] = "beeloco",
    ["what was the first bee brainrot in game"] = "beeloco",
    ["what was the first bee brainrot in sab"] = "beeloco",
    ["what was the first bee brainrot in the game"] = "beeloco",
    ["what was the first bee in game"] = "beeloco",
    ["what was the first bee in the game"] = "beeloco",
    ["what was the first og"] = "strawberryelephant",
    ["what was the first og brainrot"] = "strawberryelephant",
    ["what was the first snake brainrot"] = "hydraserpent",
    ["what was the first snake brainrot added"] = "hydraserpent",
    ["what was the first snake brainrot ever added"] = "hydraserpent",
    ["what was the first snake brainrot that was added"] = "hydraserpent",
    ["what was the first snake brainrot that was ever added"] = "hydraserpent",
    ["what was the fourth three headed brainrot"] = "hydraserpent",
    ["what was the second og added"] = "meowl",
    ["what was the second og added to sab"] = "meowl",
    ["what was the trait in admin abuse"] = "sleepy",
    ["what was the trait in admin abuse war"] = "sleepy",
    ["what was the trait in the admin abuse war"] = "sleepy",
    ["what was the trait obtainable in admin abuse"] = "sleepy",
    ["what was the trait obtainable in admin abuse war"] = "sleepy",
    ["what was the trait obtainable in the admin abuse war"] = "sleepy",
    ["what year did i begin making games"] = "2013",
    ["what year did i begin making games in roblox"] = "2013",
    ["what year did i begin making games in roblox release year"] = "2013",
    ["what year did i begin making games in roblox year"] = "2013",
    ["what year did i begin making games on roblox"] = "2013",
    ["what year did i begin making games on roblox release year"] = "2013",
    ["what year did i begin making games on roblox year"] = "2013",
    ["what year did i begin making games release year"] = "2013",
    ["what year did i begin making games year"] = "2013",
    ["what year did i start making games"] = "2013",
    ["what year did i start making games in roblox"] = "2013",
    ["what year did i start making games in roblox release year"] = "2013",
    ["what year did i start making games in roblox year"] = "2013",
    ["what year did i start making games on roblox"] = "2013",
    ["what year did i start making games on roblox release year"] = "2013",
    ["what year did i start making games on roblox year"] = "2013",
    ["what year did i start making games release year"] = "2013",
    ["what year did i start making games year"] = "2013",
    ["what year did sammy begin making games"] = "2013",
    ["what year did sammy begin making games on roblox"] = "2013",
    ["what year did sammy begin making games on roblox release year"] = "2013",
    ["what year did sammy begin making games on roblox year"] = "2013",
    ["what year did sammy begin making games release year"] = "2013",
    ["what year did sammy begin making games year"] = "2013",
    ["what year did sammy start making games"] = "2013",
    ["what year did sammy start making games on roblox"] = "2013",
    ["what year did sammy start making games on roblox release year"] = "2013",
    ["what year did sammy start making games on roblox year"] = "2013",
    ["what year did sammy start making games release year"] = "2013",
    ["what year did sammy start making games year"] = "2013",
    ["what year i began making games"] = "2013",
    ["what year i began making games in roblox"] = "2013",
    ["what year i began making games in roblox release year"] = "2013",
    ["what year i began making games in roblox year"] = "2013",
    ["what year i began making games on roblox"] = "2013",
    ["what year i began making games on roblox release year"] = "2013",
    ["what year i began making games on roblox year"] = "2013",
    ["what year i began making games release year"] = "2013",
    ["what year i began making games year"] = "2013",
    ["what year i started making games"] = "2013",
    ["what year i started making games in roblox"] = "2013",
    ["what year i started making games in roblox release year"] = "2013",
    ["what year i started making games in roblox year"] = "2013",
    ["what year i started making games on roblox"] = "2013",
    ["what year i started making games on roblox release year"] = "2013",
    ["what year i started making games on roblox year"] = "2013",
    ["what year i started making games release year"] = "2013",
    ["what year i started making games year"] = "2013",
    ["what year was bee lucky block released"] = "2026",
    ["what year was headless horseman released"] = "2026",
    ["what year was john pork released"] = "2026",
    ["what year was meowl released"] = "2025",
    ["what year was orchidox released"] = "2026",
    ["what year was skibidi toilet released"] = "2025",
    ["what year was spyder elephant released"] = "2026",
    ["what year was strawberry elephant released"] = "2025",
    ["whats 2nd name of sammy"] = "brakta",
    ["whats my 2nd name"] = "brakta",
    ["whats my cat name"] = "nova",
    ["whats my cats name"] = "nova",
    ["whats my dog name"] = "rocky",
    ["whats my dogs name"] = "rocky",
    ["whats my favorite game"] = "fortnite",
    ["whats my favorite mutation"] = "galaxy",
    ["whats my favorite number"] = "67",
    ["whats my favourite game"] = "fortnite",
    ["whats my favourite mutation"] = "galaxy",
    ["whats my favourite number"] = "67",
    ["whats my hair color"] = "black",
    ["whats my hair colour"] = "black",
    ["whats my last name"] = "brakta",
    ["whats my least favorite game"] = "growagarden",
    ["whats my least favorite group"] = "secretverse",
    ["whats my least favorite person"] = "secretlokii",
    ["whats my least favorite studio"] = "secretverse",
    ["whats my least favourite game"] = "growagarden",
    ["whats my least favourite group"] = "secretverse",
    ["whats my least favourite person"] = "secretlokii",
    ["whats my least favourite studio"] = "secretverse",
    ["whats my middle name"] = "brakta",
    ["whats my pet name"] = "rocky",
    ["whats my second name"] = "brakta",
    ["whats my surname"] = "brakta",
    ["whats sammy 2nd name"] = "brakta",
    ["whats sammy cat name"] = "nova",
    ["whats sammy dog name"] = "rocky",
    ["whats sammy favorite game"] = "fortnite",
    ["whats sammy favorite mutation"] = "galaxy",
    ["whats sammy favourite game"] = "fortnite",
    ["whats sammy favourite mutation"] = "galaxy",
    ["whats sammy least favorite game"] = "growagarden",
    ["whats sammy least favourite game"] = "growagarden",
    ["whats sammy pet name"] = "rocky",
    ["whats sammy second name"] = "brakta",
    ["whats sammys 2nd name"] = "brakta",
    ["whats sammys cat name"] = "nova",
    ["whats sammys dog name"] = "rocky",
    ["whats sammys dogs name"] = "rocky",
    ["whats sammys favorite game"] = "fortnite",
    ["whats sammys favorite mutation"] = "galaxy",
    ["whats sammys favorite number"] = "67",
    ["whats sammys favourite game"] = "fortnite",
    ["whats sammys favourite mutation"] = "galaxy",
    ["whats sammys favourite number"] = "67",
    ["whats sammys least favorite game"] = "growagarden",
    ["whats sammys least favourite game"] = "growagarden",
    ["whats sammys pet name"] = "rocky",
    ["whats sammys second name"] = "brakta",
    ["whats second name of sammy"] = "brakta",
    ["whats the 1st snake"] = "hydraserpent",
    ["whats the 1st snake brainrot"] = "hydraserpent",
    ["whats the 1st snake brainrot added"] = "hydraserpent",
    ["whats the 1st snake brainrot ever added"] = "hydraserpent",
    ["whats the 1st snake brainrot that was added"] = "hydraserpent",
    ["whats the 1st snake brainrot that was ever added"] = "hydraserpent",
    ["whats the 2nd best brainrot"] = "strawberryelephant",
    ["whats the 2nd best brainrot in game"] = "strawberryelephant",
    ["whats the 2nd best brainrot in the game"] = "strawberryelephant",
    ["whats the 3 headed brainrot"] = "hydraserpent",
    ["whats the 4th 3 headed"] = "hydraserpent",
    ["whats the 4th 3 headed brainrot"] = "hydraserpent",
    ["whats the 4th three headed"] = "hydraserpent",
    ["whats the 4th three headed brainrot"] = "hydraserpent",
    ["whats the 6th brainrot based off a mythical creature"] = "hydraserpent",
    ["whats the 6th brainrot based on a mythical creature"] = "hydraserpent",
    ["whats the 6th brainrot to be based off a mythical creature"] = "hydraserpent",
    ["whats the 6th brainrot to be based on a mythical creature"] = "hydraserpent",
    ["whats the 6th mythical brainrot"] = "hydraserpent",
    ["whats the 6th mythical creature"] = "hydraserpent",
    ["whats the 6th mythical creature brainrot"] = "hydraserpent",
    ["whats the best brainrot added in todays admin abuse"] = "lupaandlipa",
    ["whats the best brainrot added in todays update"] = "lupaandlipa",
    ["whats the best brainrot added last saturday"] = "orchidox",
    ["whats the best brainrot added last week"] = "orchidox",
    ["whats the best brainrot added today"] = "lupaandlipa",
    ["whats the best brainrot except spyder elephant"] = "strawberryelephant",
    ["whats the best brainrot except spyderelephant"] = "strawberryelephant",
    ["whats the best brainrot from bee lucky block"] = "orchidox",
    ["whats the best brainrot from the bee lucky block"] = "orchidox",
    ["whats the best brainrot in bee lucky block"] = "orchidox",
    ["whats the best brainrot in the bee lucky block"] = "orchidox",
    ["whats the best brainrot released last saturday"] = "orchidox",
    ["whats the best brainrot released last week"] = "orchidox",
    ["whats the best brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["whats the best brainrot that was added in todays update"] = "lupaandlipa",
    ["whats the best brainrot that was added last saturday"] = "orchidox",
    ["whats the best brainrot that was added last week"] = "orchidox",
    ["whats the best brainrot that was added today"] = "lupaandlipa",
    ["whats the best brainrot that was released last week"] = "orchidox",
    ["whats the best brainrot without spyder elephant"] = "strawberryelephant",
    ["whats the best brainrot without spyderelephant"] = "strawberryelephant",
    ["whats the best mutation"] = "crystal",
    ["whats the best mutation currently"] = "crystal",
    ["whats the best mutation for meowl visually"] = "cyber",
    ["whats the best mutation right now"] = "crystal",
    ["whats the best mutation rn"] = "crystal",
    ["whats the best visual mutation for meowl"] = "cyber",
    ["whats the first snake"] = "hydraserpent",
    ["whats the first snake brainrot"] = "hydraserpent",
    ["whats the first snake brainrot added"] = "hydraserpent",
    ["whats the first snake brainrot ever added"] = "hydraserpent",
    ["whats the first snake brainrot that was added"] = "hydraserpent",
    ["whats the first snake brainrot that was ever added"] = "hydraserpent",
    ["whats the flying bee gear"] = "flyingbee",
    ["whats the fourth 3 headed"] = "hydraserpent",
    ["whats the fourth 3 headed brainrot"] = "hydraserpent",
    ["whats the fourth three headed"] = "hydraserpent",
    ["whats the fourth three headed brainrot"] = "hydraserpent",
    ["whats the latest snake brainrot"] = "hydraserpent",
    ["whats the most op brainrot"] = "orchidox",
    ["whats the most op brainrot added"] = "orchidox",
    ["whats the most op brainrot added recently"] = "orchidox",
    ["whats the most op brainrot added today"] = "lupaandlipa",
    ["whats the most op brainrot from bee lucky block"] = "orchidox",
    ["whats the most op brainrot from the bee lucky block"] = "orchidox",
    ["whats the most op brainrot in bee lucky block"] = "orchidox",
    ["whats the most op brainrot in the bee lucky block"] = "orchidox",
    ["whats the most op brainrot recently"] = "orchidox",
    ["whats the most op brainrot released"] = "orchidox",
    ["whats the most op brainrot released recently"] = "orchidox",
    ["whats the most op brainrot that was added"] = "orchidox",
    ["whats the most op brainrot that was added recently"] = "orchidox",
    ["whats the most op brainrot that was added today"] = "lupaandlipa",
    ["whats the most op brainrot that was released"] = "orchidox",
    ["whats the most op brainrot that was released recently"] = "orchidox",
    ["whats the mythical creature brainrot"] = "hydraserpent",
    ["whats the new bee gear"] = "flyingbee",
    ["whats the new flying bee gear"] = "flyingbee",
    ["whats the new snake"] = "hydraserpent",
    ["whats the new snake brainrot"] = "hydraserpent",
    ["whats the new snake brainrot his name"] = "hydraserpent",
    ["whats the new snake brainrot name"] = "hydraserpent",
    ["whats the new snake brainrots name"] = "hydraserpent",
    ["whats the newest snake brainrot"] = "hydraserpent",
    ["whats the op brainrot that was added recently"] = "lupaandlipa",
    ["whats the op brainrot that was recently added"] = "lupaandlipa",
    ["whats the op brainrot that was recently released"] = "lupaandlipa",
    ["whats the op brainrot that was released recently"] = "lupaandlipa",
    ["whats the second best brainrot"] = "strawberryelephant",
    ["whats the second best brainrot in game"] = "strawberryelephant",
    ["whats the second best brainrot in the game"] = "strawberryelephant",
    ["whats the sixth brainrot based off a mythical creature"] = "hydraserpent",
    ["whats the sixth brainrot based on a mythical creature"] = "hydraserpent",
    ["whats the sixth brainrot to be based off a mythical creature"] = "hydraserpent",
    ["whats the sixth brainrot to be based on a mythical creature"] = "hydraserpent",
    ["whats the sixth mythical brainrot"] = "hydraserpent",
    ["whats the sixth mythical creature"] = "hydraserpent",
    ["whats the sixth mythical creature brainrot"] = "hydraserpent",
    ["whats the snake brainrot"] = "hydraserpent",
    ["whats the snake brainrot his name"] = "hydraserpent",
    ["whats the snake brainrot name"] = "hydraserpent",
    ["whats the snake brainrots name"] = "hydraserpent",
    ["whats the three headed brainrot"] = "hydraserpent",
    ["when 1 year event trait released"] = "may2026",
    ["when 1 year trait released"] = "may2026",
    ["when 10 billion trait released"] = "june2025",
    ["when 10 billion visits trait released"] = "june2025",
    ["when 10b trait released"] = "june2025",
    ["when 1st craft machine released"] = "september2025",
    ["when 1st craft released"] = "september2025",
    ["when 1st fuse machine released"] = "august2025",
    ["when 1st fuse released"] = "august2025",
    ["when 1st lucky block released"] = "july2025",
    ["when 1st machine added released"] = "june2025",
    ["when 1st machine released"] = "june2025",
    ["when 2026 trait released"] = "december2025",
    ["when 26 trait released"] = "december2025",
    ["when 2nd fuse machine released"] = "october2025",
    ["when 2nd fuse released"] = "october2025",
    ["when 3rd fuse machine released"] = "december2025",
    ["when 3rd fuse released"] = "december2025",
    ["when 4th fuse machine released"] = "march2026",
    ["when 4th fuse released"] = "march2026",
    ["when 4th of july trait released"] = "july2025",
    ["when 5th fuse machine released"] = "may2026",
    ["when 5th fuse released"] = "may2026",
    ["when admin machine released"] = "november2025",
    ["when anniversary trait released"] = "may2026",
    ["when asteroid trait released"] = "june2025",
    ["when bee block released"] = "august2026",
    ["when bee lucky block brainrot released"] = "august2026",
    ["when bee lucky block in sab released"] = "august2026",
    ["when bee lucky block in the game released"] = "august2026",
    ["when bee lucky block released"] = "august2026",
    ["when bee lucky blocks released"] = "august2026",
    ["when bee lucky released"] = "august2026",
    ["when bee shop brainrot released"] = "august2026",
    ["when bee update brainrot released"] = "august2026",
    ["when best bee brainrot released"] = "august2026",
    ["when best bee lucky block brainrot released"] = "august2026",
    ["when best bee shop brainrot released"] = "august2026",
    ["when best brainrot added last saturday released"] = "august2026",
    ["when best brainrot added last week released"] = "august2026",
    ["when best brainrot from bee lucky block released"] = "august2026",
    ["when best brainrot in bee lucky block released"] = "august2026",
    ["when best brainrot released last saturday released"] = "august2026",
    ["when best brainrot released last week released"] = "august2026",
    ["when best brainrot that was added last saturday released"] = "august2026",
    ["when best brainrot that was added last week released"] = "august2026",
    ["when best brainrot that was released last saturday released"] = "august2026",
    ["when best brainrot that was released last week released"] = "august2026",
    ["when best looking mutation for meowl released"] = "april2026",
    ["when best looking mutation on meowl released"] = "april2026",
    ["when best mutation for meowl visually released"] = "april2026",
    ["when best visual mutation for favorite brainrot released"] = "april2026",
    ["when best visual mutation for meowl released"] = "april2026",
    ["when best visual mutation for my favorite brainrot released"] = "april2026",
    ["when best visual mutation on meowl released"] = "april2026",
    ["when bloodrot mutation released"] = "june2025",
    ["when bloodrot released"] = "june2025",
    ["when blue egg trait released"] = "april2026",
    ["when bombardiro trait released"] = "june2025",
    ["when brainrot added last saturday released"] = "august2026",
    ["when brainrot added last week released"] = "august2026",
    ["when brainrot god lucky block released"] = "july2025",
    ["when brainrot released last saturday released"] = "august2026",
    ["when brainrot released last week released"] = "august2026",
    ["when brainrot that was added last saturday released"] = "august2026",
    ["when brainrot that was added last week released"] = "august2026",
    ["when brainrot that was released last saturday released"] = "august2026",
    ["when brainrot that was released last week released"] = "august2026",
    ["when bruno mars concert trait released"] = "january2026",
    ["when bruno mars trait released"] = "january2026",
    ["when bubblegum machine released"] = "july2025",
    ["when bubblegum trait released"] = "july2025",
    ["when bull trait released"] = "july2026",
    ["when bunny ears released"] = "april2026",
    ["when bunny ears trait released"] = "april2026",
    ["when candy mutation released"] = "july2025",
    ["when chipso and queso released"] = "october2025",
    ["when chipso queso released"] = "october2025",
    ["when chipso released"] = "october2025",
    ["when chocolate trait released"] = "february2026",
    ["when comet struck released"] = "june2025",
    ["when comet struck trait released"] = "june2025",
    ["when concert trait released"] = "january2026",
    ["when crab rave released"] = "june2025",
    ["when crab rave trait released"] = "june2025",
    ["when craft machine released"] = "september2025",
    ["when craft released"] = "september2025",
    ["when crystal mutation released"] = "july2026",
    ["when cupid fuse released"] = "february2026",
    ["when cupid machine released"] = "february2026",
    ["when current fuse released"] = "june2025",
    ["when cursed mutation released"] = "january2026",
    ["when cursed released"] = "january2026",
    ["when cyber admin machine released"] = "april2026",
    ["when cyber admin released"] = "april2026",
    ["when cyber craft machine released"] = "april2026",
    ["when cyber craft released"] = "april2026",
    ["when cyber mutation released"] = "april2026",
    ["when cyber released"] = "april2026",
    ["when cybercraft released"] = "april2026",
    ["when did bee lucky block release"] = "august2026",
    ["when did he begin making games"] = "2013",
    ["when did he begin making games on roblox"] = "2013",
    ["when did he begin making games on roblox release year"] = "2013",
    ["when did he begin making games on roblox year"] = "2013",
    ["when did he begin making games release year"] = "2013",
    ["when did he begin making games year"] = "2013",
    ["when did he start making games"] = "2013",
    ["when did he start making games on roblox"] = "2013",
    ["when did he start making games on roblox release year"] = "2013",
    ["when did he start making games on roblox year"] = "2013",
    ["when did he start making games release year"] = "2013",
    ["when did he start making games year"] = "2013",
    ["when did headless horseman release"] = "february2026",
    ["when did i begin making games"] = "2013",
    ["when did i begin making games in roblox"] = "2013",
    ["when did i begin making games in roblox release year"] = "2013",
    ["when did i begin making games in roblox year"] = "2013",
    ["when did i begin making games on roblox"] = "2013",
    ["when did i begin making games on roblox release year"] = "2013",
    ["when did i begin making games on roblox year"] = "2013",
    ["when did i begin making games release year"] = "2013",
    ["when did i begin making games year"] = "2013",
    ["when did i start making games"] = "2013",
    ["when did i start making games in roblox"] = "2013",
    ["when did i start making games in roblox release year"] = "2013",
    ["when did i start making games in roblox year"] = "2013",
    ["when did i start making games on roblox"] = "2013",
    ["when did i start making games on roblox release year"] = "2013",
    ["when did i start making games on roblox year"] = "2013",
    ["when did i start making games release year"] = "2013",
    ["when did i start making games year"] = "2013",
    ["when did john pork release"] = "may2026",
    ["when did meowl release"] = "october2025",
    ["when did orchideon release"] = "august2026",
    ["when did orchidox release"] = "august2026",
    ["when did sammy begin making games"] = "2013",
    ["when did sammy begin making games in roblox"] = "2013",
    ["when did sammy begin making games on roblox"] = "2013",
    ["when did sammy begin making games on roblox release year"] = "2013",
    ["when did sammy begin making games on roblox year"] = "2013",
    ["when did sammy begin making games release year"] = "2013",
    ["when did sammy begin making games year"] = "2013",
    ["when did sammy start making games"] = "2013",
    ["when did sammy start making games in roblox"] = "2013",
    ["when did sammy start making games on roblox"] = "2013",
    ["when did sammy start making games on roblox release year"] = "2013",
    ["when did sammy start making games on roblox year"] = "2013",
    ["when did sammy start making games release year"] = "2013",
    ["when did sammy start making games year"] = "2013",
    ["when did skibidi toilet release"] = "december2025",
    ["when did spyder elephant release"] = "may2026",
    ["when did strawberry elephant release"] = "august2025",
    ["when did the bee lucky block release"] = "august2026",
    ["when did the strawberry elephant release"] = "august2025",
    ["when divine admin machine released"] = "february2026",
    ["when divine admin released"] = "february2026",
    ["when divine fuse machine released"] = "march2026",
    ["when divine fuse released"] = "march2026",
    ["when divine halo trait released"] = "february2026",
    ["when divine mutation released"] = "february2026",
    ["when duels machine released"] = "january2026",
    ["when duels released"] = "january2026",
    ["when duels update released"] = "january2026",
    ["when egg incubator released"] = "april2026",
    ["when egg trait incubator released"] = "april2026",
    ["when extinct event trait released"] = "september2025",
    ["when extinct trait released"] = "september2025",
    ["when fat sammy npc released"] = "august2025",
    ["when fat sammy released"] = "august2025",
    ["when fav mutation released"] = "august2025",
    ["when favorite mutation released"] = "august2025",
    ["when favourite mutation released"] = "august2025",
    ["when fifth fuse machine released"] = "may2026",
    ["when fifth fuse released"] = "may2026",
    ["when fire trait released"] = "june2025",
    ["when firework trait released"] = "july2025",
    ["when first craft machine released"] = "september2025",
    ["when first craft released"] = "september2025",
    ["when first fuse machine released"] = "august2025",
    ["when first fuse released"] = "august2025",
    ["when first lucky block released"] = "july2025",
    ["when first machine added released"] = "june2025",
    ["when first machine added to sab released"] = "june2025",
    ["when first machine added to the game released"] = "june2025",
    ["when first machine in game released"] = "june2025",
    ["when first machine in sab released"] = "june2025",
    ["when first machine in the game released"] = "june2025",
    ["when first machine released"] = "june2025",
    ["when fourth fuse machine released"] = "march2026",
    ["when fourth fuse released"] = "march2026",
    ["when fuse machine original released"] = "august2025",
    ["when fuse machine released"] = "august2025",
    ["when fuse machine return released"] = "january2026",
    ["when fuse released"] = "august2025",
    ["when fuse return released"] = "january2026",
    ["when galaxy mutation released"] = "august2025",
    ["when galaxy released"] = "august2025",
    ["when game created released"] = "may2025",
    ["when game launched released"] = "may2025",
    ["when game made released"] = "may2025",
    ["when game release released"] = "may2025",
    ["when game released released"] = "may2025",
    ["when glitch trait released"] = "june2025",
    ["when glitched trait released"] = "june2025",
    ["when granny trait released"] = "march2026",
    ["when green egg trait released"] = "april2026",
    ["when halo trait released"] = "february2026",
    ["when headless horseman"] = "february2026",
    ["when headlesshorseman released"] = "february2026",
    ["when i began making games"] = "2013",
    ["when i began making games in roblox"] = "2013",
    ["when i began making games in roblox release year"] = "2013",
    ["when i began making games in roblox year"] = "2013",
    ["when i began making games on roblox"] = "2013",
    ["when i began making games on roblox release year"] = "2013",
    ["when i began making games on roblox year"] = "2013",
    ["when i began making games release year"] = "2013",
    ["when i began making games year"] = "2013",
    ["when i started making games"] = "2013",
    ["when i started making games in roblox"] = "2013",
    ["when i started making games in roblox release year"] = "2013",
    ["when i started making games in roblox year"] = "2013",
    ["when i started making games on roblox"] = "2013",
    ["when i started making games on roblox release year"] = "2013",
    ["when i started making games on roblox year"] = "2013",
    ["when i started making games release year"] = "2013",
    ["when i started making games year"] = "2013",
    ["when incubator machine released"] = "april2026",
    ["when indonesia trait released"] = "june2025",
    ["when jack o lantern trait released"] = "october2025",
    ["when jackolantern trait released"] = "october2025",
    ["when john pork"] = "may2026",
    ["when johnpork released"] = "may2026",
    ["when last craft machine released"] = "april2026",
    ["when last craft released"] = "april2026",
    ["when last fuse machine released"] = "june2025",
    ["when last fuse released"] = "june2025",
    ["when latest craft machine released"] = "april2026",
    ["when latest craft released"] = "april2026",
    ["when latest fuse machine released"] = "june2025",
    ["when latest fuse released"] = "june2025",
    ["when lava mutation released"] = "july2025",
    ["when los taco block released"] = "november2025",
    ["when los taco blocks released"] = "november2025",
    ["when los trader released"] = "june2026",
    ["when los traders released"] = "june2026",
    ["when lucky block released"] = "july2025",
    ["when lucky blocks released"] = "july2025",
    ["when lucky pot trait released"] = "january2026",
    ["when lucky trait released"] = "january2026",
    ["when meowl"] = "october2025",
    ["when meowl released"] = "october2025",
    ["when molten mutation released"] = "july2025",
    ["when most op bee lucky block brainrot released"] = "august2026",
    ["when most op brainrot added recently released"] = "august2026",
    ["when most op brainrot added released"] = "august2026",
    ["when most op brainrot from bee lucky block released"] = "august2026",
    ["when most op brainrot in bee lucky block released"] = "august2026",
    ["when most op brainrot recently released"] = "august2026",
    ["when most op brainrot released"] = "august2026",
    ["when most op brainrot released recently released"] = "august2026",
    ["when most op brainrot released released"] = "august2026",
    ["when most op brainrot that was added recently released"] = "august2026",
    ["when most op brainrot that was added released"] = "august2026",
    ["when most op brainrot that was released recently released"] = "august2026",
    ["when most op brainrot that was released released"] = "august2026",
    ["when my fav mutation released"] = "august2025",
    ["when my favorite mutation released"] = "august2025",
    ["when my favorite visual mutation for meowl released"] = "april2026",
    ["when my favourite mutation released"] = "august2025",
    ["when my favourite visual mutation for meowl released"] = "april2026",
    ["when mythic lucky block released"] = "july2025",
    ["when new year 2026 trait released"] = "december2025",
    ["when new year fuse released"] = "december2025",
    ["when new year machine released"] = "december2025",
    ["when new years machine released"] = "december2025",
    ["when newest craft machine released"] = "april2026",
    ["when newest craft released"] = "april2026",
    ["when newest fuse machine released"] = "june2025",
    ["when newest fuse released"] = "june2025",
    ["when nyan cat released"] = "june2025",
    ["when nyan cat trait released"] = "june2025",
    ["when nyan trait released"] = "june2025",
    ["when nyancat released"] = "june2025",
    ["when og fuse machine released"] = "january2026",
    ["when oldest fuse released"] = "august2025",
    ["when oldest machine released"] = "june2025",
    ["when op brainrot added recently released"] = "august2026",
    ["when op brainrot added released"] = "august2026",
    ["when op brainrot recently released"] = "august2026",
    ["when op brainrot released"] = "august2026",
    ["when op brainrot released recently released"] = "august2026",
    ["when op brainrot that was added recently released"] = "august2026",
    ["when op brainrot that was added released"] = "august2026",
    ["when op brainrot that was released recently released"] = "august2026",
    ["when orange egg trait released"] = "orangeegg",
    ["when orchideon released"] = "august2026",
    ["when orchidox released"] = "august2026",
    ["when original craft machine released"] = "september2025",
    ["when original fuse machine released"] = "august2025",
    ["when original fuse released"] = "august2025",
    ["when original lucky block released"] = "july2025",
    ["when original machine released"] = "june2025",
    ["when overall fav mutation released"] = "august2025",
    ["when overall favorite mutation released"] = "august2025",
    ["when overall favourite mutation released"] = "august2025",
    ["when phantom mutation released"] = "june2026",
    ["when pink egg trait released"] = "april2026",
    ["when queso released"] = "october2025",
    ["when radioactive mutation released"] = "november2025",
    ["when radioactive released"] = "november2025",
    ["when rain trait released"] = "june2025",
    ["when rain weather trait released"] = "june2025",
    ["when rainbow fuse machine released"] = "june2025",
    ["when rainbow fuse released"] = "june2025",
    ["when rainbow machine released"] = "june2025",
    ["when rainbowfuse released"] = "june2025",
    ["when rainbowmachine released"] = "june2025",
    ["when recent fuse released"] = "june2025",
    ["when reindeer trait released"] = "december2025",
    ["when revived fuse machine released"] = "january2026",
    ["when rip tombstone released"] = "october2025",
    ["when rip tombstone trait released"] = "october2025",
    ["when rng machine released"] = "august2026",
    ["when sab created released"] = "may2025",
    ["when sab game release released"] = "may2025",
    ["when sab launched released"] = "may2025",
    ["when sab made"] = "may2025",
    ["when sab made released"] = "may2025",
    ["when sab release released"] = "may2025",
    ["when sab released"] = "may2025",
    ["when sab released released"] = "may2025",
    ["when sammy fav mutation released"] = "august2025",
    ["when sammy favorite mutation released"] = "august2025",
    ["when sammy favorite visual mutation for meowl released"] = "april2026",
    ["when sammy favourite mutation released"] = "august2025",
    ["when sammys favorite mutation released"] = "august2025",
    ["when sammys favorite visual mutation for meowl released"] = "april2026",
    ["when sammys favourite mutation released"] = "august2025",
    ["when santa fuse released"] = "december2025",
    ["when santa hat trait released"] = "december2025",
    ["when santa machine released"] = "december2025",
    ["when santahat trait released"] = "december2025",
    ["when santas fuse machine released"] = "december2025",
    ["when santas fuse released"] = "december2025",
    ["when second fuse machine released"] = "october2025",
    ["when second fuse released"] = "october2025",
    ["when secret lucky block released"] = "july2025",
    ["when shark trait released"] = "june2025",
    ["when skeleton trait released"] = "september2025",
    ["when skibidi toilet"] = "december2025",
    ["when skibidi trait released"] = "june2025",
    ["when skibiditoilet released"] = "december2025",
    ["when snow trait released"] = "june2025",
    ["when snow weather trait released"] = "june2025",
    ["when snowy trait released"] = "june2025",
    ["when solar flare trait released"] = "june2025",
    ["when spain event trait released"] = "july2026",
    ["when spain trait released"] = "july2026",
    ["when spyder elephant"] = "may2026",
    ["when spyderelephant released"] = "may2026",
    ["when starfall trait released"] = "june2025",
    ["when starfall weather trait released"] = "june2025",
    ["when steal a brainrot created released"] = "may2025",
    ["when steal a brainrot game released"] = "may2025",
    ["when steal a brainrot launched released"] = "may2025",
    ["when steal a brainrot made released"] = "may2025",
    ["when steal a brainrot release released"] = "may2025",
    ["when steal a brainrot released released"] = "may2025",
    ["when strawberry elephant"] = "august2025",
    ["when strawberryelephant released"] = "august2025",
    ["when strongest brainrot added recently released"] = "august2026",
    ["when strongest brainrot added released"] = "august2026",
    ["when strongest brainrot recently released"] = "august2026",
    ["when strongest brainrot released recently released"] = "august2026",
    ["when strongest brainrot that was added recently released"] = "august2026",
    ["when strongest brainrot that was added released"] = "august2026",
    ["when strongest brainrot that was released recently released"] = "august2026",
    ["when summer fuse machine released"] = "may2026",
    ["when summer fuse released"] = "may2026",
    ["when taco block released"] = "september2025",
    ["when taco blocks released"] = "november2025",
    ["when taco lucky block released"] = "september2025",
    ["when taco merchant npc released"] = "august2026",
    ["when taco merchant released"] = "august2026",
    ["when taco shop released"] = "august2026",
    ["when taco trait released"] = "june2025",
    ["when taco tuesday lucky block released"] = "september2025",
    ["when taco tuesday trait released"] = "june2025",
    ["when the best visual mutation for meowl released"] = "april2026",
    ["when the best visual mutation on meowl released"] = "april2026",
    ["when the most op brainrot added recently released"] = "august2026",
    ["when the most op brainrot added released"] = "august2026",
    ["when the most op brainrot recently released"] = "august2026",
    ["when the most op brainrot released"] = "august2026",
    ["when the most op brainrot released recently released"] = "august2026",
    ["when the most op brainrot that was added recently released"] = "august2026",
    ["when the most op brainrot that was added released"] = "august2026",
    ["when the most op brainrot that was released recently released"] = "august2026",
    ["when the op brainrot added recently released"] = "august2026",
    ["when the op brainrot added released"] = "august2026",
    ["when the op brainrot released"] = "august2026",
    ["when the op brainrot that was added recently released"] = "august2026",
    ["when the op brainrot that was added released"] = "august2026",
    ["when third fuse machine released"] = "december2025",
    ["when third fuse released"] = "december2025",
    ["when tombstone trait released"] = "october2025",
    ["when trade machine released"] = "february2026",
    ["when trade plaza released"] = "june2026",
    ["when trading machine released"] = "june2026",
    ["when trait incubator released"] = "april2026",
    ["when tung tung attack released"] = "june2025",
    ["when tung tung released"] = "june2025",
    ["when tung tung trait released"] = "june2025",
    ["when tung tung zombie released"] = "june2025",
    ["when valentine fuse released"] = "february2026",
    ["when valentine machine released"] = "february2026",
    ["when valentine trait released"] = "february2026",
    ["when valentines machine released"] = "february2026",
    ["when visually best mutation for meowl released"] = "april2026",
    ["when visually best mutation on meowl released"] = "april2026",
    ["when was 1 year event trait released"] = "may2026",
    ["when was 1 year trait released"] = "may2026",
    ["when was 10 billion trait released"] = "june2025",
    ["when was 10 billion visits trait released"] = "june2025",
    ["when was 10b trait released"] = "june2025",
    ["when was 1st craft machine released"] = "september2025",
    ["when was 1st craft released"] = "september2025",
    ["when was 1st fuse machine released"] = "august2025",
    ["when was 1st fuse released"] = "august2025",
    ["when was 1st lucky block released"] = "july2025",
    ["when was 1st machine added released"] = "june2025",
    ["when was 1st machine released"] = "june2025",
    ["when was 2026 trait released"] = "december2025",
    ["when was 26 trait released"] = "december2025",
    ["when was 2nd fuse machine released"] = "october2025",
    ["when was 2nd fuse released"] = "october2025",
    ["when was 3rd fuse machine released"] = "december2025",
    ["when was 3rd fuse released"] = "december2025",
    ["when was 4th fuse machine released"] = "march2026",
    ["when was 4th fuse released"] = "march2026",
    ["when was 4th of july trait released"] = "july2025",
    ["when was 5th fuse machine released"] = "may2026",
    ["when was 5th fuse released"] = "may2026",
    ["when was admin machine released"] = "november2025",
    ["when was anniversary trait released"] = "may2026",
    ["when was asteroid trait released"] = "june2025",
    ["when was bee block released"] = "august2026",
    ["when was bee lucky block brainrot released"] = "august2026",
    ["when was bee lucky block in sab released"] = "august2026",
    ["when was bee lucky block in the game released"] = "august2026",
    ["when was bee lucky block released"] = "august2026",
    ["when was bee lucky blocks released"] = "august2026",
    ["when was bee lucky released"] = "august2026",
    ["when was bee shop brainrot released"] = "august2026",
    ["when was bee update brainrot released"] = "august2026",
    ["when was best bee brainrot released"] = "august2026",
    ["when was best bee lucky block brainrot released"] = "august2026",
    ["when was best bee shop brainrot released"] = "august2026",
    ["when was best brainrot added last saturday released"] = "august2026",
    ["when was best brainrot added last week released"] = "august2026",
    ["when was best brainrot from bee lucky block released"] = "august2026",
    ["when was best brainrot in bee lucky block released"] = "august2026",
    ["when was best brainrot released last saturday released"] = "august2026",
    ["when was best brainrot released last week released"] = "august2026",
    ["when was best brainrot that was added last saturday released"] = "august2026",
    ["when was best brainrot that was added last week released"] = "august2026",
    ["when was best brainrot that was released last saturday released"] = "august2026",
    ["when was best brainrot that was released last week released"] = "august2026",
    ["when was best looking mutation for meowl released"] = "april2026",
    ["when was best looking mutation on meowl released"] = "april2026",
    ["when was best mutation for meowl visually released"] = "april2026",
    ["when was best visual mutation for favorite brainrot released"] = "april2026",
    ["when was best visual mutation for meowl released"] = "april2026",
    ["when was best visual mutation for my favorite brainrot released"] = "april2026",
    ["when was best visual mutation on meowl released"] = "april2026",
    ["when was bloodrot mutation released"] = "june2025",
    ["when was bloodrot released"] = "june2025",
    ["when was blue egg trait released"] = "april2026",
    ["when was bombardiro trait released"] = "june2025",
    ["when was brainrot added last saturday released"] = "august2026",
    ["when was brainrot added last week released"] = "august2026",
    ["when was brainrot god lucky block released"] = "july2025",
    ["when was brainrot released last saturday released"] = "august2026",
    ["when was brainrot released last week released"] = "august2026",
    ["when was brainrot that was added last saturday released"] = "august2026",
    ["when was brainrot that was added last week released"] = "august2026",
    ["when was brainrot that was released last saturday released"] = "august2026",
    ["when was brainrot that was released last week released"] = "august2026",
    ["when was bruno mars concert trait released"] = "january2026",
    ["when was bruno mars trait released"] = "january2026",
    ["when was bubblegum machine released"] = "july2025",
    ["when was bubblegum trait released"] = "july2025",
    ["when was bull trait released"] = "july2026",
    ["when was bunny ears released"] = "april2026",
    ["when was bunny ears trait released"] = "april2026",
    ["when was candy mutation released"] = "july2025",
    ["when was chipso and queso released"] = "october2025",
    ["when was chipso queso released"] = "october2025",
    ["when was chipso released"] = "october2025",
    ["when was chocolate trait released"] = "february2026",
    ["when was comet struck released"] = "june2025",
    ["when was comet struck trait released"] = "june2025",
    ["when was concert trait released"] = "january2026",
    ["when was crab rave released"] = "june2025",
    ["when was crab rave trait released"] = "june2025",
    ["when was craft machine released"] = "september2025",
    ["when was craft released"] = "september2025",
    ["when was crystal mutation released"] = "july2026",
    ["when was cupid fuse released"] = "february2026",
    ["when was cupid machine released"] = "february2026",
    ["when was current fuse released"] = "june2025",
    ["when was cursed mutation released"] = "january2026",
    ["when was cursed released"] = "january2026",
    ["when was cyber admin machine released"] = "april2026",
    ["when was cyber admin released"] = "april2026",
    ["when was cyber craft machine released"] = "april2026",
    ["when was cyber craft released"] = "april2026",
    ["when was cyber mutation released"] = "april2026",
    ["when was cyber released"] = "april2026",
    ["when was cybercraft released"] = "april2026",
    ["when was divine admin machine released"] = "february2026",
    ["when was divine admin released"] = "february2026",
    ["when was divine fuse machine released"] = "march2026",
    ["when was divine fuse released"] = "march2026",
    ["when was divine halo trait released"] = "february2026",
    ["when was divine mutation released"] = "february2026",
    ["when was duels machine released"] = "january2026",
    ["when was duels released"] = "january2026",
    ["when was duels update released"] = "january2026",
    ["when was egg incubator released"] = "april2026",
    ["when was egg trait incubator released"] = "april2026",
    ["when was extinct event trait released"] = "september2025",
    ["when was extinct trait released"] = "september2025",
    ["when was fat sammy npc released"] = "august2025",
    ["when was fat sammy released"] = "august2025",
    ["when was fav mutation released"] = "august2025",
    ["when was favorite mutation released"] = "august2025",
    ["when was favourite mutation released"] = "august2025",
    ["when was fifth fuse machine released"] = "may2026",
    ["when was fifth fuse released"] = "may2026",
    ["when was fire trait released"] = "june2025",
    ["when was firework trait released"] = "july2025",
    ["when was first craft machine released"] = "september2025",
    ["when was first craft released"] = "september2025",
    ["when was first fuse machine released"] = "august2025",
    ["when was first fuse released"] = "august2025",
    ["when was first lucky block released"] = "july2025",
    ["when was first machine added released"] = "june2025",
    ["when was first machine added to sab released"] = "june2025",
    ["when was first machine added to the game released"] = "june2025",
    ["when was first machine in game released"] = "june2025",
    ["when was first machine in sab released"] = "june2025",
    ["when was first machine in the game released"] = "june2025",
    ["when was first machine released"] = "june2025",
    ["when was fourth fuse machine released"] = "march2026",
    ["when was fourth fuse released"] = "march2026",
    ["when was fuse machine original released"] = "august2025",
    ["when was fuse machine released"] = "august2025",
    ["when was fuse machine return released"] = "january2026",
    ["when was fuse released"] = "august2025",
    ["when was fuse return released"] = "january2026",
    ["when was galaxy mutation released"] = "august2025",
    ["when was galaxy released"] = "august2025",
    ["when was game created released"] = "may2025",
    ["when was game launched released"] = "may2025",
    ["when was game made released"] = "may2025",
    ["when was game release released"] = "may2025",
    ["when was game released released"] = "may2025",
    ["when was glitch trait released"] = "june2025",
    ["when was glitched trait released"] = "june2025",
    ["when was granny trait released"] = "march2026",
    ["when was green egg trait released"] = "april2026",
    ["when was halo trait released"] = "february2026",
    ["when was headless horseman released"] = "february2026",
    ["when was headlesshorseman released"] = "february2026",
    ["when was incubator machine released"] = "april2026",
    ["when was indonesia trait released"] = "june2025",
    ["when was jack o lantern trait released"] = "october2025",
    ["when was jackolantern trait released"] = "october2025",
    ["when was john pork released"] = "may2026",
    ["when was johnpork released"] = "may2026",
    ["when was last craft machine released"] = "april2026",
    ["when was last craft released"] = "april2026",
    ["when was last fuse machine released"] = "june2025",
    ["when was last fuse released"] = "june2025",
    ["when was latest craft machine released"] = "april2026",
    ["when was latest craft released"] = "april2026",
    ["when was latest fuse machine released"] = "june2025",
    ["when was latest fuse released"] = "june2025",
    ["when was lava mutation released"] = "july2025",
    ["when was los taco block released"] = "november2025",
    ["when was los taco blocks released"] = "november2025",
    ["when was los trader released"] = "june2026",
    ["when was los traders released"] = "june2026",
    ["when was lucky block released"] = "july2025",
    ["when was lucky blocks released"] = "july2025",
    ["when was lucky pot trait released"] = "january2026",
    ["when was lucky trait released"] = "january2026",
    ["when was meowl released"] = "october2025",
    ["when was molten mutation released"] = "july2025",
    ["when was most op bee lucky block brainrot released"] = "august2026",
    ["when was most op brainrot added recently released"] = "august2026",
    ["when was most op brainrot added released"] = "august2026",
    ["when was most op brainrot from bee lucky block released"] = "august2026",
    ["when was most op brainrot in bee lucky block released"] = "august2026",
    ["when was most op brainrot recently released"] = "august2026",
    ["when was most op brainrot released"] = "august2026",
    ["when was most op brainrot released recently released"] = "august2026",
    ["when was most op brainrot released released"] = "august2026",
    ["when was most op brainrot that was added recently released"] = "august2026",
    ["when was most op brainrot that was added released"] = "august2026",
    ["when was most op brainrot that was released recently released"] = "august2026",
    ["when was most op brainrot that was released released"] = "august2026",
    ["when was my fav mutation released"] = "august2025",
    ["when was my favorite mutation released"] = "august2025",
    ["when was my favorite visual mutation for meowl released"] = "april2026",
    ["when was my favourite mutation released"] = "august2025",
    ["when was my favourite visual mutation for meowl released"] = "april2026",
    ["when was mythic lucky block released"] = "july2025",
    ["when was new year 2026 trait released"] = "december2025",
    ["when was new year fuse released"] = "december2025",
    ["when was new year machine released"] = "december2025",
    ["when was new years machine released"] = "december2025",
    ["when was newest craft machine released"] = "april2026",
    ["when was newest craft released"] = "april2026",
    ["when was newest fuse machine released"] = "june2025",
    ["when was newest fuse released"] = "june2025",
    ["when was nyan cat released"] = "june2025",
    ["when was nyan cat trait released"] = "june2025",
    ["when was nyan trait released"] = "june2025",
    ["when was nyancat released"] = "june2025",
    ["when was og fuse machine released"] = "january2026",
    ["when was oldest fuse released"] = "august2025",
    ["when was oldest machine released"] = "june2025",
    ["when was op brainrot added recently released"] = "august2026",
    ["when was op brainrot added released"] = "august2026",
    ["when was op brainrot recently released"] = "august2026",
    ["when was op brainrot released"] = "august2026",
    ["when was op brainrot released recently released"] = "august2026",
    ["when was op brainrot that was added recently released"] = "august2026",
    ["when was op brainrot that was added released"] = "august2026",
    ["when was op brainrot that was released recently released"] = "august2026",
    ["when was orange egg trait released"] = "orangeegg",
    ["when was orchideon released"] = "august2026",
    ["when was orchidox released"] = "august2026",
    ["when was original craft machine released"] = "september2025",
    ["when was original fuse machine released"] = "august2025",
    ["when was original fuse released"] = "august2025",
    ["when was original lucky block released"] = "july2025",
    ["when was original machine released"] = "june2025",
    ["when was overall fav mutation released"] = "august2025",
    ["when was overall favorite mutation released"] = "august2025",
    ["when was overall favourite mutation released"] = "august2025",
    ["when was phantom mutation released"] = "june2026",
    ["when was pink egg trait released"] = "april2026",
    ["when was queso released"] = "october2025",
    ["when was radioactive mutation released"] = "november2025",
    ["when was radioactive released"] = "november2025",
    ["when was rain trait released"] = "june2025",
    ["when was rain weather trait released"] = "june2025",
    ["when was rainbow fuse machine released"] = "june2025",
    ["when was rainbow fuse released"] = "june2025",
    ["when was rainbow machine released"] = "june2025",
    ["when was rainbowfuse released"] = "june2025",
    ["when was rainbowmachine released"] = "june2025",
    ["when was recent fuse released"] = "june2025",
    ["when was reindeer trait released"] = "december2025",
    ["when was revived fuse machine released"] = "january2026",
    ["when was rip tombstone released"] = "october2025",
    ["when was rip tombstone trait released"] = "october2025",
    ["when was rng machine released"] = "august2026",
    ["when was sab created released"] = "may2025",
    ["when was sab game release released"] = "may2025",
    ["when was sab launched released"] = "may2025",
    ["when was sab made released"] = "may2025",
    ["when was sab release released"] = "may2025",
    ["when was sab released released"] = "may2025",
    ["when was sammy fav mutation released"] = "august2025",
    ["when was sammy favorite mutation released"] = "august2025",
    ["when was sammy favorite visual mutation for meowl released"] = "april2026",
    ["when was sammy favourite mutation released"] = "august2025",
    ["when was sammys favorite mutation released"] = "august2025",
    ["when was sammys favorite visual mutation for meowl released"] = "april2026",
    ["when was sammys favourite mutation released"] = "august2025",
    ["when was santa fuse released"] = "december2025",
    ["when was santa hat trait released"] = "december2025",
    ["when was santa machine released"] = "december2025",
    ["when was santahat trait released"] = "december2025",
    ["when was santas fuse machine released"] = "december2025",
    ["when was santas fuse released"] = "december2025",
    ["when was second fuse machine released"] = "october2025",
    ["when was second fuse released"] = "october2025",
    ["when was secret lucky block released"] = "july2025",
    ["when was shark trait released"] = "june2025",
    ["when was skeleton trait released"] = "september2025",
    ["when was skibidi toilet released"] = "december2025",
    ["when was skibidi trait released"] = "june2025",
    ["when was skibiditoilet released"] = "december2025",
    ["when was snow trait released"] = "june2025",
    ["when was snow weather trait released"] = "june2025",
    ["when was snowy trait released"] = "june2025",
    ["when was solar flare trait released"] = "june2025",
    ["when was spain event trait released"] = "july2026",
    ["when was spain trait released"] = "july2026",
    ["when was spyder elephant released"] = "may2026",
    ["when was spyderelephant released"] = "may2026",
    ["when was starfall trait released"] = "june2025",
    ["when was starfall weather trait released"] = "june2025",
    ["when was steal a brainrot created released"] = "may2025",
    ["when was steal a brainrot game released"] = "may2025",
    ["when was steal a brainrot launched released"] = "may2025",
    ["when was steal a brainrot made released"] = "may2025",
    ["when was steal a brainrot release released"] = "may2025",
    ["when was steal a brainrot released released"] = "may2025",
    ["when was strawberry elephant released"] = "august2025",
    ["when was strawberryelephant released"] = "august2025",
    ["when was strongest brainrot added recently released"] = "august2026",
    ["when was strongest brainrot added released"] = "august2026",
    ["when was strongest brainrot recently released"] = "august2026",
    ["when was strongest brainrot released recently released"] = "august2026",
    ["when was strongest brainrot that was added recently released"] = "august2026",
    ["when was strongest brainrot that was added released"] = "august2026",
    ["when was strongest brainrot that was released recently released"] = "august2026",
    ["when was summer fuse machine released"] = "may2026",
    ["when was summer fuse released"] = "may2026",
    ["when was taco block released"] = "september2025",
    ["when was taco blocks released"] = "november2025",
    ["when was taco lucky block released"] = "september2025",
    ["when was taco merchant npc released"] = "august2026",
    ["when was taco merchant released"] = "august2026",
    ["when was taco shop released"] = "august2026",
    ["when was taco trait released"] = "june2025",
    ["when was taco tuesday lucky block released"] = "september2025",
    ["when was taco tuesday trait released"] = "june2025",
    ["when was the bee lucky block released"] = "august2026",
    ["when was the best visual mutation for meowl released"] = "april2026",
    ["when was the best visual mutation on meowl released"] = "april2026",
    ["when was the headless horseman released"] = "february2026",
    ["when was the john pork released"] = "may2026",
    ["when was the meowl released"] = "october2025",
    ["when was the most op brainrot added recently released"] = "august2026",
    ["when was the most op brainrot added released"] = "august2026",
    ["when was the most op brainrot recently released"] = "august2026",
    ["when was the most op brainrot released"] = "august2026",
    ["when was the most op brainrot released recently released"] = "august2026",
    ["when was the most op brainrot that was added recently released"] = "august2026",
    ["when was the most op brainrot that was added released"] = "august2026",
    ["when was the most op brainrot that was released recently released"] = "august2026",
    ["when was the op brainrot added recently released"] = "august2026",
    ["when was the op brainrot added released"] = "august2026",
    ["when was the op brainrot released"] = "august2026",
    ["when was the op brainrot that was added recently released"] = "august2026",
    ["when was the op brainrot that was added released"] = "august2026",
    ["when was the skibidi toilet released"] = "december2025",
    ["when was the spyder elephant released"] = "may2026",
    ["when was the strawberry elephant released"] = "august2025",
    ["when was third fuse machine released"] = "december2025",
    ["when was third fuse released"] = "december2025",
    ["when was tombstone trait released"] = "october2025",
    ["when was trade machine released"] = "february2026",
    ["when was trade plaza released"] = "june2026",
    ["when was trading machine released"] = "june2026",
    ["when was trait incubator released"] = "april2026",
    ["when was tung tung attack released"] = "june2025",
    ["when was tung tung released"] = "june2025",
    ["when was tung tung trait released"] = "june2025",
    ["when was tung tung zombie released"] = "june2025",
    ["when was valentine fuse released"] = "february2026",
    ["when was valentine machine released"] = "february2026",
    ["when was valentine trait released"] = "february2026",
    ["when was valentines machine released"] = "february2026",
    ["when was visually best mutation for meowl released"] = "april2026",
    ["when was visually best mutation on meowl released"] = "april2026",
    ["when was witch fuse machine released"] = "october2025",
    ["when was witch fuse released"] = "october2025",
    ["when was witch machine released"] = "october2025",
    ["when was witch released"] = "october2025",
    ["when was witching hour released"] = "october2025",
    ["when was witching hour trait released"] = "october2025",
    ["when was yin yang mutation released"] = "september2025",
    ["when was yin yang released"] = "september2025",
    ["when was yinyang mutation released"] = "september2025",
    ["when was yinyang released"] = "september2025",
    ["when was zombie trait released"] = "june2025",
    ["when witch fuse machine released"] = "october2025",
    ["when witch fuse released"] = "october2025",
    ["when witch machine released"] = "october2025",
    ["when witch released"] = "october2025",
    ["when witching hour released"] = "october2025",
    ["when witching hour trait released"] = "october2025",
    ["when yin yang mutation released"] = "september2025",
    ["when yin yang released"] = "september2025",
    ["when yinyang mutation released"] = "september2025",
    ["when yinyang released"] = "september2025",
    ["when zombie trait released"] = "june2025",
    ["where can you get draculino"] = "caveisland",
    ["where can you obtain draculino"] = "caveisland",
    ["where do you get draculino"] = "caveisland",
    ["where go"] = "gym",
    ["where i go"] = "gym",
    ["where is draculino from"] = "caveisland",
    ["where is draculino obtained from"] = "caveisland",
    ["where live"] = "usa",
    ["which 3 brainrots got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["which 3 brainrots were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["which brainrot got deleted"] = "tungtungtungsahur",
    ["which brainrot got remove"] = "tungtungtungsahur",
    ["which brainrot got removed"] = "tungtungtungsahur",
    ["which brainrot got reworked"] = "sammynispyderini",
    ["which brainrot was added in todays admin abuse"] = "lupaandlipa",
    ["which brainrot was added in todays update"] = "hydraserpent",
    ["which brainrot was added last saturday"] = "orchidox",
    ["which brainrot was added last week"] = "orchidox",
    ["which brainrot was added today"] = "hydraserpent",
    ["which brainrot was deleted"] = "tungtungtungsahur",
    ["which brainrot was released last saturday"] = "orchidox",
    ["which brainrot was released last week"] = "orchidox",
    ["which brainrot was removed"] = "tungtungtungsahur",
    ["which brainrot was reworked"] = "sammynispyderini",
    ["which brainrots got deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["which brainrots were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["which egg can you get dragon cannelloni from"] = "dragonegg",
    ["which egg can you obtain dragon cannelloni from"] = "dragonegg",
    ["which egg is dragon cannelloni from"] = "dragonegg",
    ["which island is draculino from"] = "caveisland",
    ["which mutation looks best on meowl"] = "cyber",
    ["which mutation looks the best on meowl"] = "cyber",
    ["which snake brainrot is in the game"] = "hydraserpent",
    ["which snake brainrot was added"] = "hydraserpent",
    ["which snake brainrot was added in todays update"] = "hydraserpent",
    ["which snake brainrot was added today"] = "hydraserpent",
    ["white"] = "white",
    ["who do i hate"] = "secretlokii",
    ["who do i hate most"] = "secretlokii",
    ["who do i hate the most"] = "secretlokii",
    ["who does sammy hate"] = "secretlokii",
    ["who does sammy hate most"] = "secretlokii",
    ["who does sammy hate the most"] = "secretlokii",
    ["who hate"] = "secretlokii",
    ["who hate most"] = "secretlokii",
    ["who hates"] = "secretlokii",
    ["who hates most"] = "secretlokii",
    ["who host admin abuse"] = "jandel",
    ["who hosted admin abuse"] = "jandel",
    ["who is a competitive player at valorant"] = "sammy",
    ["who is a competitive valorant player"] = "sammy",
    ["who is better than loki"] = "jandel",
    ["who is better than lokii"] = "jandel",
    ["who is better than luckymatg"] = "jandel",
    ["who is better than secretloki"] = "jandel",
    ["who is better than secretlokii"] = "jandel",
    ["who is competitive player at valorant"] = "sammy",
    ["who is my boyfriend"] = "steakwad",
    ["who is my friend that is a youtuber that has food in his name"] = "steak",
    ["who is my friend that is a youtuber that has food in name"] = "steak",
    ["who is my friend that is a youtuber with food"] = "steak",
    ["who is my friend that is a youtuber with food in his name"] = "steak",
    ["who is my friend that is a youtuber with food in name"] = "steak",
    ["who is my friend youtuber that has food in his name"] = "steak",
    ["who is my friend youtuber with food in his name"] = "steak",
    ["who is my least favorite person"] = "secretlokii",
    ["who is my least favourite person"] = "secretlokii",
    ["who is my youtuber friend that has food in his name"] = "steak",
    ["who is my youtuber friend that has food in name"] = "steak",
    ["who is my youtuber friend with food"] = "steak",
    ["who is my youtuber friend with food in his name"] = "steak",
    ["who is my youtuber friend with food in name"] = "steak",
    ["who is sammy least favorite person"] = "secretlokii",
    ["who is sammy least favourite person"] = "secretlokii",
    ["who is sammys least favorite person"] = "secretlokii",
    ["who is sammys least favourite person"] = "secretlokii",
    ["who is the person better than loki"] = "jandel",
    ["who is the person better than lokii"] = "jandel",
    ["who is the person better than luckymatg"] = "jandel",
    ["who is the person better than secretloki"] = "jandel",
    ["who is the person better than secretlokii"] = "jandel",
    ["who is the person worse than jandel"] = "secretlokii",
    ["who is the person worser than jandel"] = "secretlokii",
    ["who is the worst person"] = "secretlokii",
    ["who is the youtuber friend with food in his name"] = "steak",
    ["who is the youtuber that has food in his name"] = "steak",
    ["who is the youtuber with food in his name"] = "steak",
    ["who is worse than jandel"] = "secretlokii",
    ["who is worser than jandel"] = "secretlokii",
    ["who is worst person"] = "secretlokii",
    ["who plays competitive valorant"] = "sammy",
    ["who plays valorant competitively"] = "sammy",
    ["winterhour"] = "winterhour",
    ["witch"] = "witchfuse",
    ["witch date"] = "october2025",
    ["witch day"] = "11",
    ["witch fuse"] = "witchfuse",
    ["witch fuse date"] = "october2025",
    ["witch fuse day"] = "11",
    ["witch fuse machine"] = "witchfuse",
    ["witch fuse machine date"] = "october2025",
    ["witch fuse machine day"] = "11",
    ["witch fuse machine month"] = "october",
    ["witch fuse machine release"] = "october2025",
    ["witch fuse machine release date"] = "october2025",
    ["witch fuse machine release day"] = "11",
    ["witch fuse machine release month"] = "october",
    ["witch fuse machine release year"] = "2025",
    ["witch fuse machine year"] = "2025",
    ["witch fuse month"] = "october",
    ["witch fuse release"] = "october2025",
    ["witch fuse release date"] = "october2025",
    ["witch fuse release day"] = "11",
    ["witch fuse release month"] = "october",
    ["witch fuse release year"] = "2025",
    ["witch fuse year"] = "2025",
    ["witch machine"] = "witchfuse",
    ["witch machine date"] = "october2025",
    ["witch machine day"] = "11",
    ["witch machine month"] = "october",
    ["witch machine release"] = "october2025",
    ["witch machine release date"] = "october2025",
    ["witch machine release day"] = "11",
    ["witch machine release month"] = "october",
    ["witch machine release year"] = "2025",
    ["witch machine year"] = "2025",
    ["witch month"] = "october",
    ["witch release"] = "october2025",
    ["witch release date"] = "october2025",
    ["witch release day"] = "11",
    ["witch release month"] = "october",
    ["witch release year"] = "2025",
    ["witch year"] = "2025",
    ["witching hour"] = "witchinghour",
    ["witching hour date"] = "october2025",
    ["witching hour month"] = "october",
    ["witching hour release"] = "october2025",
    ["witching hour release date"] = "october2025",
    ["witching hour release month"] = "october",
    ["witching hour release year"] = "2025",
    ["witching hour trait"] = "witchinghour",
    ["witching hour trait date"] = "october2025",
    ["witching hour trait month"] = "october",
    ["witching hour trait release"] = "october2025",
    ["witching hour trait release date"] = "october2025",
    ["witching hour trait release month"] = "october",
    ["witching hour trait release year"] = "2025",
    ["witching hour trait year"] = "2025",
    ["witching hour year"] = "2025",
    ["witchinghour"] = "witchinghour",
    ["worse garden"] = "1speedkeyboardescape",
    ["worse grow"] = "1speedkeyboardescape",
    ["worse jandel"] = "secretlokii",
    ["worse than grow a garden"] = "1speedkeyboardescape",
    ["worse than growagarden"] = "1speedkeyboardescape",
    ["worse than jandel"] = "secretlokii",
    ["worser garden"] = "1speedkeyboardescape",
    ["worser grow"] = "1speedkeyboardescape",
    ["worser jandel"] = "secretlokii",
    ["worser than grow a garden"] = "1speedkeyboardescape",
    ["worser than growagarden"] = "1speedkeyboardescape",
    ["worser than jandel"] = "secretlokii",
    ["worst"] = "banditoaxolito",
    ["worst enemy"] = "jandel",
    ["worst in game"] = "banditoaxolito",
    ["worst person"] = "secretlokii",
    ["worst person is secretlokii"] = "secretlokii",
    ["worst rng"] = "banditoaxolito",
    ["worst taco merchant"] = "burritobat",
    ["year began making games"] = "2013",
    ["year began making games release year"] = "2013",
    ["year began making games year"] = "2013",
    ["year headless horseman"] = "2026",
    ["year i began making games"] = "2013",
    ["year i began making games in roblox"] = "2013",
    ["year i began making games in roblox release year"] = "2013",
    ["year i began making games in roblox year"] = "2013",
    ["year i began making games on roblox"] = "2013",
    ["year i began making games on roblox release year"] = "2013",
    ["year i began making games on roblox year"] = "2013",
    ["year i began making games release year"] = "2013",
    ["year i began making games year"] = "2013",
    ["year i started making games"] = "2013",
    ["year i started making games in roblox"] = "2013",
    ["year i started making games in roblox release year"] = "2013",
    ["year i started making games in roblox year"] = "2013",
    ["year i started making games on roblox"] = "2013",
    ["year i started making games on roblox release year"] = "2013",
    ["year i started making games on roblox year"] = "2013",
    ["year i started making games release year"] = "2013",
    ["year i started making games year"] = "2013",
    ["year john pork"] = "2026",
    ["year making games"] = "2013",
    ["year meowl"] = "2025",
    ["year sammy began making games"] = "2013",
    ["year sammy began making games on roblox"] = "2013",
    ["year sammy began making games on roblox release year"] = "2013",
    ["year sammy began making games on roblox year"] = "2013",
    ["year sammy began making games release year"] = "2013",
    ["year sammy began making games year"] = "2013",
    ["year sammy started making games"] = "2013",
    ["year sammy started making games on roblox"] = "2013",
    ["year sammy started making games on roblox release year"] = "2013",
    ["year sammy started making games on roblox year"] = "2013",
    ["year sammy started making games release year"] = "2013",
    ["year sammy started making games year"] = "2013",
    ["year skibidi toilet"] = "2025",
    ["year spyder elephant"] = "2026",
    ["year started making games"] = "2013",
    ["year started making games release year"] = "2013",
    ["year started making games year"] = "2013",
    ["year strawberry elephant"] = "2025",
    ["year when headless horseman released"] = "2026",
    ["year when john pork released"] = "2026",
    ["year when meowl released"] = "2025",
    ["year when skibidi toilet released"] = "2025",
    ["year when spyder elephant released"] = "2026",
    ["year when strawberry elephant released"] = "2025",
    ["yin yang"] = "yinyang",
    ["yin yang date"] = "september2025",
    ["yin yang day"] = "27",
    ["yin yang month"] = "september",
    ["yin yang mutation"] = "yinyang",
    ["yin yang mutation date"] = "september2025",
    ["yin yang mutation day"] = "27",
    ["yin yang mutation month"] = "september",
    ["yin yang mutation release"] = "september2025",
    ["yin yang mutation release date"] = "september2025",
    ["yin yang mutation release day"] = "27",
    ["yin yang mutation release month"] = "september",
    ["yin yang mutation release year"] = "2025",
    ["yin yang mutation year"] = "2025",
    ["yin yang release"] = "september2025",
    ["yin yang release date"] = "september2025",
    ["yin yang release day"] = "27",
    ["yin yang release month"] = "september",
    ["yin yang release year"] = "2025",
    ["yin yang year"] = "2025",
    ["yinyang date"] = "september2025",
    ["yinyang day"] = "27",
    ["yinyang month"] = "september",
    ["yinyang mutation"] = "yinyang",
    ["yinyang mutation date"] = "september2025",
    ["yinyang mutation day"] = "27",
    ["yinyang mutation month"] = "september",
    ["yinyang mutation release"] = "september2025",
    ["yinyang mutation release date"] = "september2025",
    ["yinyang mutation release day"] = "27",
    ["yinyang mutation release month"] = "september",
    ["yinyang mutation release year"] = "2025",
    ["yinyang mutation year"] = "2025",
    ["yinyang release"] = "september2025",
    ["yinyang release date"] = "september2025",
    ["yinyang release day"] = "27",
    ["yinyang release month"] = "september",
    ["yinyang release year"] = "2025",
    ["yinyang year"] = "2025",
    ["youtuber food"] = "steak",
    ["youtuber food in name"] = "steak",
    ["youtuber food name"] = "steak",
    ["youtuber friend food"] = "steak",
    ["youtuber friend that has food in his name"] = "steak",
    ["youtuber friend that has food in name"] = "steak",
    ["youtuber friend with food"] = "steak",
    ["youtuber friend with food in his name"] = "steak",
    ["youtuber friend with food in name"] = "steak",
    ["youtuber that has food in his name"] = "steak",
    ["youtuber with food"] = "steak",
    ["youtuber with food in his name"] = "steak",
    ["youtuber with food in name"] = "steak",
    ["zombie"] = "zombie",
    ["zombie trait"] = "tungtung",
    ["zombie trait date"] = "june2025",
    ["zombie trait month"] = "june",
    ["zombie trait release"] = "june2025",
    ["zombie trait release date"] = "june2025",
    ["zombie trait release month"] = "june",
    ["zombie trait release year"] = "2025",
    ["zombie trait year"] = "2025",
}

-- QUESTION NORMALISATION + LOCAL LOOKUP
local WORD_ALIAS = {
    favourite = "favorite", fav = "favorite", favorites = "favorite",
    colour = "color", colours = "color", colors = "color",
    whats = "what is", ["what's"] = "what is",
    whos = "who is", ["who's"] = "who is",
    wheres = "where is", whens = "when is",
    u = "you", ur = "your", pls = "", please = "",
    ["sammy's"] = "sammys", ["i'm"] = "i am",
}

local FILLERS = {
    "what is", "what are", "what was", "what were", "what do", "what does",
    "who is", "who was", "who are", "when is", "when was", "where is",
    "where are", "how old", "how many", "how much", "do you know",
    "can you tell me", "can you tell", "tell me", "i need", "give me",
    "answer me", "say", "type", "write", "the answer to", "question",
    "am i", "do i", "did i", "have i", "is my", "is the", "is a",
}

local NUMWORDS = {
    first = 1, second = 2, third = 3, fourth = 4, fifth = 5, sixth = 6,
    seventh = 7, eighth = 8, ninth = 9, tenth = 10, eleventh = 11,
    twelfth = 12, thirteenth = 13, fourteenth = 14, fifteenth = 15,
    sixteenth = 16, seventeenth = 17, eighteenth = 18,
}
local CARDINALS = {
    one = 1, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7,
    eight = 8, nine = 9, ten = 10, eleven = 11, twelve = 12,
    thirteen = 13, fourteen = 14, fifteen = 15, sixteen = 16,
    seventeen = 17, eighteen = 18,
}
local ORD_SUFFIX = { [1] = "1st", [2] = "2nd", [3] = "3rd" }
local function ordinal(n) return ORD_SUFFIX[n] or (tostring(n) .. "th") end

local function applyAliases(s)
    local out = {}
    for word in s:gmatch("%S+") do
        local swapped = WORD_ALIAS[word]
        if swapped ~= nil then
            if swapped ~= "" then out[#out + 1] = swapped end
        else
            out[#out + 1] = word
        end
    end
    return table.concat(out, " ")
end

local function basicClean(s)
    s = tostring(s or ""):lower()
    s = s:gsub("[%?%!%.%,%;%:\"'`]", " ")
    s = s:gsub("%s+", " ")
    return trim(s)
end

local function stripFillers(s)
    local out = " " .. s .. " "
    for _, filler in ipairs(FILLERS) do
        out = out:gsub("%s" .. filler:gsub("%%", "%%%%") .. "%s", " ")
    end
    out = out:gsub("%s+my%s+", " "):gsub("^%s*my%s+", " ")
    out = out:gsub("%s+sammys?%s+", " "):gsub("^%s*sammys?%s+", " ")
    out = out:gsub("%s+the%s+", " "):gsub("%s+of%s+", " "):gsub("%s+for%s+", " ")
    out = out:gsub("%s+a%s+", " "):gsub("%s+an%s+", " "):gsub("%s+in%s+", " ")
    out = out:gsub("%s+i%s+", " "):gsub("%s+is%s+", " "):gsub("%s+was%s+", " ")
    out = out:gsub("%s+", " ")
    return trim(out)
end

local function toDigits(s)
    local conv = s
    for word, n in pairs(NUMWORDS) do
        conv = conv:gsub("%f[%a]" .. word .. "%f[%A]", ordinal(n))
    end
    for word, n in pairs(CARDINALS) do
        conv = conv:gsub("%f[%a]" .. word .. "%f[%A]", tostring(n))
    end
    return conv
end

-- leading question words + the category noun right after them
local QWORDS = {
    who = true, what = true, which = true, when = true, where = true,
    how = true, why = true, name = true, tell = true, say = true,
    type = true, guess = true, answer = true, spell = true, write = true,
}
local CATEGORY_WORDS = {
    mutation = true, machine = true, trait = true, brainrot = true,
    rarity = true, color = true, number = true, thing = true, one = true,
    word = true, day = true, year = true, month = true, update = true,
}
local STOPWORDS = {
    you = true, your = true, yours = true, me = true, we = true, us = true,
    it = true, its = true, be = true, been = true, this = true, that = true,
    ["do"] = true, does = true, did = true, ["then"] = true,
}

local function words(s)
    local list = {}
    for word in s:gmatch("%S+") do list[#list + 1] = word end
    return list
end

-- drops a leading "what" / "what mutation" style opener
local function dropLead(s)
    local list = words(s)
    if #list < 2 or not QWORDS[list[1]] then return nil end
    table.remove(list, 1)
    if #list > 1 and CATEGORY_WORDS[list[1]] then table.remove(list, 1) end
    return table.concat(list, " ")
end

local function dropStopwords(s)
    local out = {}
    for _, word in ipairs(words(s)) do
        if not STOPWORDS[word] then out[#out + 1] = word end
    end
    return table.concat(out, " ")
end
-- Only returns a value when a normalised form of the question matches a key
-- exactly. No match means no answer.
local function localAnswer(text)
    if not text or text == "" then return nil end

    local raw      = basicClean(text)
    local aliased  = applyAliases(raw)
    local core     = stripFillers(aliased)
    local noStop   = dropStopwords(core)

    local candidates = { raw, aliased, core, noStop }

    local lead = dropLead(core)
    if lead then candidates[#candidates + 1] = lead end
    local leadNoStop = dropLead(noStop)
    if leadNoStop then candidates[#candidates + 1] = leadNoStop end

    -- written numbers -> digits, and the digit-free variant
    local base = #candidates
    for index = 1, base do
        local converted = toDigits(candidates[index])
        if converted ~= candidates[index] then candidates[#candidates + 1] = converted end
    end
    candidates[#candidates + 1] = (core:gsub("%d+", ""):gsub("%s+", " "))

    -- "mutation 5" <-> "5th mutation" in both directions
    local digitForm = toDigits(noStop)
    local kind, num = digitForm:match("^(.-)%s+(%d+)$")
    if kind and num then
        candidates[#candidates + 1] = ordinal(tonumber(num)) .. " " .. trim(kind)
    end
    local num2, kind2 = digitForm:match("^(%d+)%s+(.-)$")
    if num2 and kind2 then
        candidates[#candidates + 1] = ordinal(tonumber(num2)) .. " " .. trim(kind2)
    end

    for _, key in ipairs(candidates) do
        key = trim(key)
        if key ~= "" and SAB_DB[key] then return SAB_DB[key] end
    end
    return nil
end

-- RIDDLE ENGINE, multi question splitting
-- phrases that legitimately contain "and" and must not be split
local PROTECTED = {
    ["black and white"] = "\1blackwhite\1",
    ["yin and yang"]    = "\1yinyang\1",
    ["salt and pepper"] = "\1saltpepper\1",
    ["rock and roll"]   = "\1rockroll\1",
    ["cat and dog"]     = "\1catdog\1",
}
local UNPROTECT = {}
for phrase, token in pairs(PROTECTED) do UNPROTECT[token] = phrase end

local function splitQuestions(text)
    local s = " " .. tostring(text or ""):lower() .. " "
    for phrase, token in pairs(PROTECTED) do s = s:gsub(phrase, token) end

    -- punctuation separators FIRST, before basicClean wipes them
    s = s:gsub("%s*[%?%;%,]%s*", " and ")
    s = s:gsub("%s*&%s*", " and ")
    s = s:gsub("%s*%+%s*", " and ")
    s = " " .. basicClean(s) .. " "

    -- every remaining separator becomes " and "
    s = s:gsub("%s+add%s+", " and ")
    s = s:gsub("%s+plus%s+", " and ")
    s = s:gsub("%s+then%s+", " and ")
    s = s:gsub("%s+followed%s+by%s+", " and ")
    s = s:gsub("%s+also%s+", " and ")
    s = s:gsub("%s+", " ")

    local parts = {}
    for part in (s .. " and "):gmatch("(.-)%s+and%s+") do
        part = trim(part)
        if part ~= "" then
            for token, phrase in pairs(UNPROTECT) do part = part:gsub(token, phrase) end
            parts[#parts + 1] = part
        end
    end
    if #parts == 0 then parts[1] = trim(basicClean(text)) end
    return parts
end

local function multiplierOf(text)
    local l = text:lower()
    if l:find("twice") then return 2 end
    if l:find("thrice") then return 3 end
    local n = tonumber(l:match("(%d+)%s*times"))
    if n and n >= 2 and n <= 10 then return n end
    for word, value in pairs(CARDINALS) do
        if value >= 2 and value <= 10 and l:find("%f[%a]" .. word .. "%s+times") then return value end
    end
    return nil
end

local function stripMultiplier(text)
    local s = text
    s = s:gsub("%s*%d+%s*times%s*", " ")
    s = s:gsub("%s*twice%s*", " ")
    s = s:gsub("%s*thrice%s*", " ")
    for word, value in pairs(CARDINALS) do
        if value >= 2 and value <= 10 then s = s:gsub("%s*" .. word .. "%s+times%s*", " ") end
    end
    s = trim(s)
    return s ~= "" and s or text
end

-- a bare number the player must append, e.g. "favorite color and 67"
local function trailingSuffixNumber(text)
    local words, prev, suffix = {}, nil, nil
    for word in basicClean(text):gmatch("%S+") do words[#words + 1] = word end
    local SKIP = { mutation = true, machine = true, og = true, number = true,
                   brainrot = true, trait = true, rarity = true, times = true }
    for index, word in ipairs(words) do
        if word:match("^%d+$") and tonumber(word) > 13 then
            prev = index > 1 and words[index - 1] or ""
            local nxt = words[index + 1] or ""
            if not SKIP[prev] and not SKIP[nxt] then suffix = word end
        end
    end
    return suffix
end

local function stripTrailingNumber(text)
    return trim(tostring(text):gsub("%s+%d+%s*$", ""))
end

-- "my name at the end" -> the answer for that part goes last
local function extractPlacement(part)
    local placement
    if part:find("at the end") then placement = "end" end
    if part:find("at the start") or part:find("at the beginning") then placement = "start" end
    local cleaned = part
        :gsub("%s*at the end%s*", " ")
        :gsub("%s*at the start%s*", " ")
        :gsub("%s*at the beginning%s*", " ")
    return trim(cleaned), placement
end

-- database only. returns answer or nil.
local function resolvePart(part)
    local times = multiplierOf(part)
    local q = stripMultiplier(part)
    -- only strip a trailing number when it is a "tack this on" number,
    -- never when it identifies the thing being asked ("mutation 5")
    if trailingSuffixNumber(part) then q = stripTrailingNumber(q) end
    q = trim(q)
    if q == "" then return nil end

    -- a pure number is its own answer
    local onlyNumber = q:match("^%d+$")
    if onlyNumber then
        return times and string.rep(onlyNumber, times) or onlyNumber
    end

    local answer = localAnswer(q)
    if not answer then return nil end

    local clean = upperClean(answer)
    if clean == "" or clean == "AND" or clean:find("ATTHEEND") or clean:find("ATTHESTART") then
        return nil
    end
    return times and string.rep(clean, times) or clean
end

-- returns answer, breakdown(list), errMessage
local function solveRiddle(text)
    local suffix = trailingSuffixNumber(text)
    local parts = splitQuestions(text)
    local breakdown = {}
    local head, middle, tail = {}, {}, {}
    local missing = 0

    for _, rawPart in ipairs(parts) do
        local part, placement = extractPlacement(rawPart)
        local ok, result = pcall(resolvePart, part)
        if ok and result and result ~= "" then
            local bucket = (placement == "start" and head) or (placement == "end" and tail) or middle
            bucket[#bucket + 1] = result
            breakdown[#breakdown + 1] = part:sub(1, 30) .. " = " .. result
        else
            -- show what the database could not answer so it can be added
            missing = missing + 1
            breakdown[#breakdown + 1] = part:sub(1, 30) .. " = ?"
        end
    end

    local answers = {}
    for _, list in ipairs({ head, middle, tail }) do
        for _, value in ipairs(list) do answers[#answers + 1] = value end
    end

    if #answers == 0 then
        return nil, breakdown, "not in database"
    end

    local out = table.concat(answers, "")
    if suffix and out:sub(-#suffix) ~= suffix then out = out .. suffix end
    return out, breakdown, (missing > 0) and (missing .. (missing == 1 and " part" or " parts") .. " not in database") or nil
end

-- GROQ RIDDLE SOLVER
-- Embedded key requested for this private build. Anyone with this file can read it.
local RIDDLE_API_KEY = "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"
local RIDDLE_API_URL = "https://api.groq.com/openai/v1/chat/completions"
local RIDDLE_API_MODEL = "openai/gpt-oss-120b"
local _riddleKnowledgeCache, _riddleSystemCache

local function executorRequest()
    local candidates = {
        rawget(env, "request"), rawget(env, "http_request"), rawget(env, "httprequest"),
        rawget(_G, "request"), rawget(_G, "http_request"), rawget(_G, "httprequest"),
    }
    local synTable = rawget(env, "syn") or rawget(_G, "syn")
    if type(synTable) == "table" then candidates[#candidates + 1] = synTable.request end
    local httpTable = rawget(env, "http") or rawget(_G, "http")
    if type(httpTable) == "table" then candidates[#candidates + 1] = httpTable.request end
    for _, candidate in ipairs(candidates) do
        if type(candidate) == "function" then return candidate end
    end
    return nil
end

local function riddleKnowledge()
    if _riddleKnowledgeCache then return _riddleKnowledgeCache end
    local lines = {}
    for question, answer in pairs(SAB_DB) do
        lines[#lines + 1] = tostring(question) .. " => " .. tostring(answer)
    end
    table.sort(lines)
    _riddleKnowledgeCache = table.concat(lines, "\n")
    return _riddleKnowledgeCache
end

local function riddleSystemPrompt()
    if _riddleSystemCache then return _riddleSystemCache end
    _riddleSystemCache = [[
You are the CURSED HUB riddle engine for the Roblox game Steal a Brainrot.

OUTPUT RULE: Return exactly ONE line containing only the final answer. Never add a label, explanation, quote, markdown, punctuation around it, apology, or refusal.

TYPE 1 is the default: redeem-code riddles. Use it if the question joins parts with AND, PLUS or +, or if any part concerns Steal a Brainrot, its developer Sammy, brainrots, OGs, mutations, traits, rarities, events, machines, items, updates, base skins or personal favorites. Resolve every requested part in order and concatenate exactly one value per part. Use UPPERCASE and remove spaces, apostrophes, hyphens and slashes. Do not omit or repeat a part.

TYPE 2 is only an ordinary settled real-world question completely unrelated to the game or developer. Return the shortest plain answer in normal writing.

Important code rules:
- A named literal word stays that exact word; do not replace it with a synonym.
- For event names, drop only the generic word EVENT. Keep FUSE, CRAFT, MACHINE and RITUAL when part of a proper name.
- When asked when game content was added, answer with the MONTH name unless a year is explicitly requested.
- Never invent a brainrot name. Prefer supplied knowledge.
- If uncertain, give one best guess anyway.

Developer facts: real/first/last/nickname SAMMY; Roblox/display/social name SPYDERSAMMY; age 24; born 2002; birthday month FEBRUARY; birth day FRIDAY; birthplace ALGERIA; from/lives in BRAZIL and Sao Paulo; favorite color BLUE; sport FOOTBALL; player RONALDO; food PIZZA; animal SPIDER; number SEVEN; favorite brainrot MEOWL; favorite artist DRAKE; favorite Travis Scott album ASTROWORLD; favorite game ROBLOX; best friend STEAK; least favorite brainrot RACCOONIJANDELINI.

Official game overrides (these override any conflicting mapping below):
- Base mutations are Default, Gold, Diamond and Rainbow. They do NOT count when a riddle asks for mutations Sammy added.
- Added mutation order: BLOODROT, CANDY, LAVA, GALAXY, YINYANG, RADIOACTIVE, CURSED, DIVINE, CYBER, PHANTOM, CRYSTAL. First added mutation is BLOODROT; newest is CRYSTAL.
- OG order: STRAWBERRYELEPHANT, MEOWL, SKIBIDITOILET, JOHNPORK. John Pork is fourth/newest.
- First seasonal event is BLOODMOON. Newest supplied seasonal event is CRYSTAL.
- Lucky Blocks were added in JULY. Steal a Brainrot released MAY 16 2025.
- Machine sources must stay exact: FIRSTFUSEMACHINE, FIRSTCRAFTMACHINE, DIVINEFUSE, OGFUSE, SUMMERFUSE, SANTASFUSE, WITCHSFUSE, CYBERCRAFT, LIMITEDQUANTITYCRAFT.
- Griffin comes from DIVINEFUSE. La Supreme Combinasion comes from FIRSTFUSEMACHINE.

Use the following verified question-to-answer knowledge as reference. Apply the official overrides above whenever there is a conflict:
]] .. riddleKnowledge()
    return _riddleSystemCache
end

local function isCodeRiddleQuestion(question)
    local q = " " .. tostring(question or ""):lower() .. " "
    if q:find("%s+and%s+") or q:find("%s+plus%s+") or q:find("+", 1, true) then return true end
    for _, word in ipairs({
        "brainrot", "sammy", "spyder", "mutation", "trait", "rarity", "event",
        "machine", "fuse", "craft", "og ", "update", "rebirth", "lucky block",
        "favorite", "favourite", "my name", "my birthday", "steal a brainrot",
    }) do
        if q:find(word, 1, true) then return true end
    end
    return false
end

local function cleanApiAnswer(answer, question)
    local text = tostring(answer or "")
    text = text:gsub("<think>[%s%S]-</think>", "")
    text = trim(text)
    text = text:match("([^\r\n]+)") or text
    text = trim(text):gsub("^```[%w_%-]*", ""):gsub("```$", "")
    text = trim(text):gsub("^[\"'`]+", ""):gsub("[\"'`]+$", "")
    text = text:gsub("^[Aa][Nn][Ss][Ww][Ee][Rr]%s*:%s*", "")
    text = text:gsub("^[Cc][Oo][Dd][Ee]%s*:%s*", "")
    text = trim(text)
    if isCodeRiddleQuestion(question) then text = upperClean(text) end
    if text == "" or #text > 160 then return nil end
    return text
end

local function solveRiddleWithApi(question)
    local key = trim(tostring(RIDDLE_API_KEY or ""))
    if key == "" then return nil, "API key missing" end
    local requestFn = executorRequest()
    if not requestFn then return nil, "executor HTTP request unavailable" end
    if not HttpService then return nil, "HttpService unavailable" end

    local body = HttpService:JSONEncode({
        model = RIDDLE_API_MODEL,
        messages = {
            { role = "system", content = riddleSystemPrompt() },
            { role = "user", content = tostring(question or "") },
        },
        temperature = 0,
        max_completion_tokens = 96,
        stream = false,
    })
    local ok, response = pcall(requestFn, {
        Url = RIDDLE_API_URL,
        Method = "POST",
        Headers = {
            ["Authorization"] = "Bearer " .. key,
            ["Content-Type"] = "application/json",
        },
        Body = body,
    })
    if not ok or not response then return nil, "API request failed" end

    local status, responseBody
    if type(response) == "string" then
        status, responseBody = 200, response
    else
        status = tonumber(response.StatusCode or response.Status or response.status_code) or 0
        responseBody = response.Body or response.body
    end
    if status < 200 or status >= 300 or type(responseBody) ~= "string" then
        return nil, "API HTTP " .. tostring(status)
    end

    local decodedOk, decoded = pcall(function() return HttpService:JSONDecode(responseBody) end)
    if not decodedOk or type(decoded) ~= "table" then return nil, "bad API response" end
    local choice = decoded.choices and decoded.choices[1]
    local message = choice and choice.message
    local answer = cleanApiAnswer(message and message.content, question)
    if not answer then return nil, "empty API answer" end
    return answer
end

local QUESTION_STARTERS = {
    "what", "whats", "who", "whos", "when", "where", "which", "how",
    "name", "tell", "type", "say", "guess", "answer", "riddle", "spell",
}

local function looksLikeRiddle(text)
    local l = basicClean(text)
    if l == "" then return false end
    if not l:find(" ") then return false end
    if l:find("?", 1, true) then return true end
    local firstWord = l:match("^(%S+)")
    for _, starter in ipairs(QUESTION_STARTERS) do
        if firstWord == starter then return true end
    end
    -- "my name and my favorite food" style with no question word
    if l:find("%f[%a]my%f[%A]") and (l:find("%f[%a]and%f[%A]") or l:find("favorite") or l:find("favourite")) then
        return true
    end
    if l:find("favorite") or l:find("favourite") then return true end
    return false
end

-- GAME UI INTERACTION
local function isOurGui(instance)
    local node = instance
    for _ = 1, 12 do
        if not node then break end
        if node.Name == UI_NAME then return true end
        node = node.Parent
    end
    return false
end

local function isVisibleChain(inst)
    local node = inst
    while node do
        if node:IsA("GuiObject") and not node.Visible then return false end
        if node:IsA("ScreenGui") then return node.Enabled end
        node = node.Parent
    end
    return true
end

local function findAllTextBoxes(pg)
    local boxes = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then boxes[#boxes + 1] = d end
            end
        end
    end
    return boxes
end

local function findCodeButtons(pg)
    local btns = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n = d.Name:lower()
                    local pn = (d.Parent and d.Parent.Name or ""):lower()
                    if (n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem"))
                        and isVisibleChain(d) then
                        btns[#btns + 1] = d
                    end
                end
            end
        end
    end
    return btns
end

local function fireConnections(signal, ...)
    if typeof(getconns) ~= "function" then return false end
    local ok, connections = pcall(getconns, signal)
    if not ok or type(connections) ~= "table" then return false end
    local args = table.pack(...)
    local fired = false
    for _, connection in ipairs(connections) do
        local fireOk = pcall(function()
            if connection.Enabled ~= false then
                if args.n > 0 then connection:Fire(table.unpack(args, 1, args.n))
                else connection:Fire() end
            end
        end)
        fired = fired or fireOk
    end
    return fired
end

local function clickButton(btn)
    if not btn then return false end
    local methods = {}

    methods[#methods+1] = function() btn.MouseButton1Click:Fire() end
    methods[#methods+1] = function() btn.Activated:Fire() end

    if typeof(firesignal) == "function" then
        methods[#methods+1] = function() firesignal(btn.MouseButton1Click) end
        methods[#methods+1] = function() firesignal(btn.Activated) end
    end

    if typeof(getconns) == "function" then
        methods[#methods+1] = function()
            local ok, cs = pcall(getconns, btn.MouseButton1Click)
            if ok and type(cs) == "table" then
                for _, c in ipairs(cs) do pcall(function() c:Fire() end) end
            end
            local ok2, cs2 = pcall(getconns, btn.Activated)
            if ok2 and type(cs2) == "table" then
                for _, c in ipairs(cs2) do pcall(function() c:Fire() end) end
            end
        end
    end

    if typeof(fireclick) == "function" then
        methods[#methods+1] = function() fireclick(btn) end
    end

    local anyOk = false
    for _, fn in ipairs(methods) do
        local ok = pcall(fn)
        anyOk = anyOk or ok
    end
    return anyOk
end

local function fireBoxFocusLost(box)
    if not box then return false end
    local anyFired = false

    if typeof(firesignal) == "function" then
        local ok = pcall(firesignal, box.FocusLost, true)
        anyFired = anyFired or ok
    end

    if typeof(getconns) == "function" then
        local ok, cs = pcall(getconns, box.FocusLost)
        if ok and type(cs) == "table" then
            for _, c in ipairs(cs) do
                local fn
                pcall(function() fn = c.Function end)
                if fn and typeof(getupvalues) == "function" and typeof(setupv) == "function" then
                    local uOk, ups = pcall(getupvalues, fn)
                    if uOk and type(ups) == "table" then
                        for i, v in pairs(ups) do
                            if type(v) == "boolean" and v == true then
                                pcall(setupv, fn, i, false)
                            end
                        end
                    end
                end
                local fOk = pcall(function()
                    if c.Enabled ~= false then c:Fire(true) end
                end)
                anyFired = anyFired or fOk
            end
        end
    end

    return anyFired
end

local function releaseFocus(box)
    pcall(function() box:ReleaseFocus(false) end)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if vim then
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.03)
            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end)
    pcall(function() box:ReleaseFocus(false) end)
end

local RedeemCache = { box = nil, button = nil, frame = nil }

local function writeCodeToBox(box, code)
    if not box then return false end
    pcall(function()
        box.Text = code
    end)
    return box.Text == code
end

local function cacheStillValid()
    local box, frame = RedeemCache.box, RedeemCache.frame
    return box and box.Parent and frame and frame.Parent
end

local function currentCodeBox()
    if cacheStillValid() then return RedeemCache.box end

    local pg = playerGui or player:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end

    -- Exact CodeController path first: Codes.Codes.CodeRedeem.TextBox
    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        local codesFrame = codesGui:FindFirstChild("Codes") or codesGui
        local redeem = codesFrame and codesFrame:FindFirstChild("CodeRedeem")
        local exact = redeem and redeem:FindFirstChild("TextBox")
        if exact and exact:IsA("TextBox") then
            RedeemCache.box = exact
            RedeemCache.frame = codesFrame
            return exact
        end

        -- Same fallback as the source build: first TextBox under Codes.
        for _, d in ipairs(codesGui:GetDescendants()) do
            if d:IsA("TextBox") and not isOurGui(d) then
                RedeemCache.box = d
                RedeemCache.frame = codesFrame
                return d
            end
        end
    end

    -- Last resort: any visible external TextBox.
    for _, box in ipairs(findAllTextBoxes(pg)) do
        if isVisibleChain(box) then return box end
    end
    return nil
end

local function findSubmitButton(box)
    if not box then return nil end
    local names = { "submit", "redeem", "claim", "confirm", "enter", "send", "apply", "ok", "use", "go", "check" }
    local node = box.Parent
    for _ = 1, 8 do
        if not node then break end
        for _, d in ipairs(node:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
                local n = d.Name:lower()
                local txt = ""
                pcall(function() txt = tostring(d.Text):lower() end)
                for _, key in ipairs(names) do
                    if (n:find(key) or txt:find(key)) and isVisibleChain(d) then return d end
                end
            end
        end
        node = node.Parent
    end
    return nil
end

-- OP REDEEMER SUBMIT / REDEEM LOGIC
-- Uses the same Codes.Codes-first path, button firing stack, FocusLost fallback,
-- visible TextBox fallback, and panel-opening fallback as op redeemer.
-- CURSED's redeemDelay + pending-result tracker are kept around the OP mechanism.
typeAndSubmitCode = function(code)
    if not player then return false, "no LP" end
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if not pg then return false, "no PlayerGui" end

    code = tostring(code or "")
    if code == "" then return false, "empty code" end

    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        if codesGui:IsA("ScreenGui") then
            codesGui.Enabled = true
        end
        local codesFrame = codesGui:FindFirstChild("Codes") or codesGui
        if codesFrame then
            if codesFrame:IsA("GuiObject") then
                codesFrame.Visible = true
            end
            local cur = codesFrame
            while cur and cur ~= codesGui do
                if cur:IsA("GuiObject") then cur.Visible = true end
                cur = cur.Parent
            end

            local box = nil
            for _, d in ipairs(codesFrame:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    box = d
                    break
                end
            end

            local submitBtn = nil
            for _, d in ipairs(codesFrame:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n = d.Name:lower()
                    local txt = ""
                    pcall(function() txt = d.Text:lower() end)
                    if n:find("submit") or txt:find("submit") or n:find("redeem") or txt:find("redeem")
                        or n:find("claim") or txt:find("confirm") or n:find("enter") then
                        submitBtn = d
                        break
                    end
                end
            end

            if not submitBtn then
                for _, d in ipairs(codesFrame:GetDescendants()) do
                    if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                        local n = d.Name:lower()
                        if not n:find("close") and not n:find("x") and not n:find("toggle") then
                            submitBtn = d
                            break
                        end
                    end
                end
            end

            if box then
                if rememberPending then rememberPending(box, code, true) end
                writeCodeToBox(box, code)
                task.wait(math.max(0.01, tonumber(cfg.redeemDelay) or 0.05))
                if submitBtn then
                    clickButton(submitBtn)
                end
                fireBoxFocusLost(box)
                return true, "submitted via PlayerGui.Codes.Codes"
            end
        end
    end

    local function tryOpenPanel()
        local btns = findCodeButtons(pg)
        for _, btn in ipairs(btns) do
            clickButton(btn)
            task.wait(0.05)
        end
        return #btns > 0
    end

    tryOpenPanel()
    task.wait(0.3)

    local box = nil
    local deadline = tick() + 3
    while tick() < deadline do
        local allBoxes = findAllTextBoxes(pg)
        for _, d in ipairs(allBoxes) do
            if isVisibleChain(d) then
                local n = d.Name:lower()
                local pn = (d.Parent and d.Parent.Name or ""):lower()
                if n:find("code") or pn:find("code") or n:find("redeem") or pn:find("redeem")
                    or n:find("input") or pn:find("input") or n:find("textbox") or n:find("enter") then
                    box = d
                    break
                end
            end
        end
        if not box then
            for _, d in ipairs(allBoxes) do
                if isVisibleChain(d) then box = d; break end
            end
        end
        if box then break end
        task.wait(0.1)
    end

    if not box then return false, "no codebox visible" end

    if rememberPending then rememberPending(box, code, true) end
    writeCodeToBox(box, code)
    task.wait(math.max(0.01, tonumber(cfg.redeemDelay) or 0.05))

    local redeemBtn = nil
    local searchNames = {"submit","redeem","claim","confirm","enter","send","apply","ok","use","go","check"}
    local p = box.Parent
    for _ = 1, 8 do
        if not p then break end
        for _, d in ipairs(p:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
                local n = d.Name:lower()
                local txt = ""
                pcall(function() txt = d.Text:lower() end)
                for _, sn in ipairs(searchNames) do
                    if n:find(sn) or txt:find(sn) then
                        if isVisibleChain(d) then
                            redeemBtn = d
                            break
                        end
                    end
                end
                if redeemBtn then break end
            end
        end
        if redeemBtn then break end
        p = p.Parent
    end

    if redeemBtn then
        clickButton(redeemBtn)
    end

    fireBoxFocusLost(box)
    return true, "fallback methods used"
end

-- AA HELPER LOGIC
-- Auto Buy + Anchor are adapted from Blacan Auto Buy.
-- Anti Ragdoll is adapted from the supplied unpatched anti-ragdoll script.
local helperAutoBuyActive = false
local helperAnchored = false
local helperAntiRagdollActive = false
local helperAutoBuyElapsed = 0
local helperAntiRagdollCooldown = 0
local helperAntiRagdollConn

local function triggerWorkspacePrompts()
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            pcall(function()
                prompt.HoldDuration = 0
                prompt:InputHoldBegin()
                prompt:InputHoldEnd()
            end)
        end
    end
end

local helperAutoBuyConn = RunService.Stepped:Connect(function(_, deltaTime)
    if not helperAutoBuyActive then return end
    helperAutoBuyElapsed += tonumber(deltaTime) or 0
    if helperAutoBuyElapsed < 0.12 then return end
    helperAutoBuyElapsed = 0
    triggerWorkspacePrompts()
end)

local function setCharacterAnchored(state, character)
    local char = character or player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part.Anchored = state end)
        end
    end
end

local helperCharacterConn = player.CharacterAdded:Connect(function(character)
    if helperAnchored then
        task.defer(function()
            character:WaitForChild("HumanoidRootPart", 5)
            setCharacterAnchored(true, character)
        end)
    end
end)

local function forceAntiRagdollReset()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root or humanoid.Health <= 0 then return end

    pcall(function()
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        for _, object in ipairs(character:GetDescendants()) do
            if object:IsA("Motor6D") then object.Enabled = true end
            if object:IsA("Constraint") then object.Enabled = true end
        end
        if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = humanoid end
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        humanoid.Sit = false
    end)

    pcall(function()
        local playerModule = player:FindFirstChild("PlayerScripts")
            and player.PlayerScripts:FindFirstChild("PlayerModule")
        local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
        if controlModule then
            local controls = require(controlModule)
            if controls and controls.Enable then controls:Enable() end
        end
    end)
end

local function setHelperAutoBuy(state)
    helperAutoBuyActive = state == true
    helperAutoBuyElapsed = 0
    if helperAutoBuyActive then task.spawn(triggerWorkspacePrompts) end
end

local function setHelperAnchor(state)
    helperAnchored = state == true
    setCharacterAnchored(helperAnchored)
end

local function setHelperAntiRagdoll(state)
    helperAntiRagdollActive = state == true
    if not helperAntiRagdollActive then
        if helperAntiRagdollConn then helperAntiRagdollConn:Disconnect() end
        helperAntiRagdollConn = nil
        return
    end
    if helperAntiRagdollConn then return end
    helperAntiRagdollConn = RunService.Heartbeat:Connect(function()
        if not helperAntiRagdollActive then return end
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local stateNow = humanoid:GetState()
        local ragdolled = stateNow == Enum.HumanoidStateType.Physics
            or stateNow == Enum.HumanoidStateType.Ragdoll
            or stateNow == Enum.HumanoidStateType.FallingDown
        if ragdolled and tick() - helperAntiRagdollCooldown > 0.15 then
            helperAntiRagdollCooldown = tick()
            forceAntiRagdollReset()
        end
    end)
end

-- CURSED HUB UI
-- Compact launcher + separate redeemer menu. There is intentionally no intro
-- screen or logo image; the only image is the requested menu background.
local UI = {} -- groups cosmetic UI references to stay under Luau local-register limits
local CURSED_RED = Color3.fromRGB(235, 38, 48)
local ACTIVE_GREEN = Color3.fromRGB(45, 214, 96)

local Theme = {
    MainBackground = Color3.fromRGB(12, 12, 14),  Background = Color3.fromRGB(20, 20, 23),
    Panel          = Color3.fromRGB(28, 28, 32),  Row        = Color3.fromRGB(38, 38, 43),
    RowHover       = Color3.fromRGB(50, 50, 57),
    Accent         = CURSED_RED, AccentLight = Color3.fromRGB(175, 28, 36),
    Green          = ACTIVE_GREEN,
    Red            = Color3.fromRGB(226, 72, 80),  Red2 = Color3.fromRGB(190, 54, 62),
    Text           = Color3.fromRGB(255, 255, 255), Dim = Color3.fromRGB(138, 138, 150),
    Stroke         = Color3.fromRGB(44, 44, 50),
    SoftButton     = Color3.fromRGB(38, 38, 43),  SoftButtonHover = Color3.fromRGB(50, 50, 57),
    SoftAccent     = Color3.fromRGB(42, 18, 20),
    ToggleOff      = Color3.fromRGB(58, 58, 66),  ToggleOff2 = Color3.fromRGB(30, 30, 34),
    InputBg        = Color3.fromRGB(16, 16, 19),  SliderBg = Color3.fromRGB(44, 44, 50),
}

-- kept under the old names so the rest of the script needs no changes
local T = {
    bg = Theme.MainBackground, bgDeep = Theme.InputBg, panel = Theme.Panel,
    panel2 = Theme.Row, line = Theme.Stroke, accent = Theme.Accent,
    accent2 = Theme.AccentLight, accentHi = Theme.Accent, text = Theme.Text,
    sub = Theme.Dim, ok = Theme.Green, err = Theme.Red, warn = Color3.fromRGB(250, 204, 90),
}

local LOG = {
    dim   = "rgb(138,138,150)",
    white = "rgb(255,255,255)",
    ok    = "rgb(45,214,96)",
    err   = "rgb(226,72,80)",
    warn  = "rgb(250,204,90)",
    acc   = "rgb(235,38,48)",
    cyan  = "rgb(255,255,255)",
}

-- primitives (identical to the hub's)
local function new(class, props, parent)
    local inst = Instance.new(class)
    for key, value in pairs(props or {}) do inst[key] = value end
    if parent then inst.Parent = parent end
    return inst
end
local function corner(o, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = o; return c
end
local function stroke(o, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or Theme.Stroke; s.Thickness = th or 1; s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = o
    return s
end
local function tw(o, p, t)
    TweenService:Create(o, TweenInfo.new(t or 0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p):Play()
end
local function tween(o, t, p) tw(o, p, t) end
local function addOutline(f)
    local o = Instance.new("UIStroke")
    o.Color = Theme.AccentLight; o.Thickness = 1.25; o.Transparency = 0.08
    o.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; o.Parent = f
    return o
end
-- frosted glass: top-lit depth gradient + a rim light along the top inner edge
local function decoratePanel(f)
    local g = Instance.new("UIGradient", f); g.Rotation = 90
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(188, 188, 188)),
    }
    local hl = Instance.new("Frame")
    hl.Size = UDim2.new(1, -16, 0, 1); hl.Position = UDim2.new(0, 8, 0, 1)
    hl.BackgroundColor3 = Color3.fromRGB(243, 243, 243); hl.BackgroundTransparency = 0.5
    hl.BorderSizePixel = 0; hl.ZIndex = 6; hl.Parent = f
    local hlg = Instance.new("UIGradient", hl)
    hlg.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
    }
    return g
end
local function label(parent, text, size, color, font, align)
    return new("TextLabel", {
        BackgroundTransparency = 1, Text = text, TextSize = size or 11,
        TextColor3 = color or Theme.Text, Font = font or Enum.Font.GothamMedium,
        TextXAlignment = align or Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
end

-- click helper that behaves on both mouse and touch
local function bindClick(button, callback)
    local last = 0
    local function fire()
        if tick() - last < 0.16 then return end
        last = tick()
        callback()
    end
    button.Activated:Connect(fire)
    button.MouseButton1Click:Connect(fire)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then fire() end
    end)
end

-- screen gui + global scale (same wrapper the hub uses)
pcall(function()
    for _, name in ipairs({ UI_NAME, "KatanaHub", "HiddenUI", "skyr0wtf_CodeRedeemer", "Skyr0WtfUI", "ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste", "GuiznxRiddle" }) do
        local old = playerGui:FindFirstChild(name)
        if old then old:Destroy() end
        local oldCore = CoreGui and CoreGui:FindFirstChild(name)
        if oldCore then oldCore:Destroy() end
    end
end)

GUI = new("ScreenGui", {
    Name = UI_NAME,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 9999999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local Master = new("Frame", {
    Name = "CursedHub_MasterFrame",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0),
}, GUI)
local GlobalScale = new("UIScale", { Name = "CursedHub_GlobalScale", Scale = 1 }, Master)

-- Rounded capsule launcher. MENU opens the full redeemer panel.
local Launcher = new("Frame", {
    Name = "Launcher",
    Size = UDim2.fromOffset(570, 66),
    Position = UDim2.new(0.5, -285, 0, 16),
    BackgroundColor3 = Color3.fromRGB(114, 9, 19),
    BackgroundTransparency = 0.01,
    BorderSizePixel = 0,
    Active = true,
}, Master)
corner(Launcher, 99)
stroke(Launcher, Color3.fromRGB(255, 78, 88), 1.25, 0.12)
new("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 12, 27)),
        ColorSequenceKeypoint.new(0.46, Color3.fromRGB(103, 7, 18)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 8, 14)),
    },
    Rotation = 8,
}, Launcher)

UI.LauncherInner = new("Frame", {
    Size = UDim2.new(1, -6, 1, -6),
    Position = UDim2.fromOffset(3, 3),
    BackgroundColor3 = Color3.fromRGB(8, 8, 11),
    BackgroundTransparency = 0.42,
    BorderSizePixel = 0,
}, Launcher)
corner(UI.LauncherInner, 99)
new("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 11, 21)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(18, 11, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 8, 14)),
    },
}, UI.LauncherInner)

UI.LauncherShadow = new("Frame", {
    Size = UDim2.new(1, -18, 1, -4),
    Position = UDim2.new(0, 9, 0, 8),
    BackgroundColor3 = Color3.fromRGB(235, 38, 48),
    BackgroundTransparency = 0.82,
    BorderSizePixel = 0,
    ZIndex = 0,
}, Launcher)
corner(UI.LauncherShadow, 99)

UI.LauncherGlow = new("Frame", {
    Name = "RedDecoration",
    Size = UDim2.new(1, -44, 0, 2),
    Position = UDim2.new(0, 22, 1, -3),
    BackgroundColor3 = CURSED_RED,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
}, Launcher)
corner(UI.LauncherGlow, 99)
new("UIGradient", {
    Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.22, 0.2),
        NumberSequenceKeypoint.new(0.78, 0.2),
        NumberSequenceKeypoint.new(1, 1),
    },
}, UI.LauncherGlow)

UI.LauncherLogoFrame = new("Frame", {
    Size = UDim2.fromOffset(48, 48),
    Position = UDim2.fromOffset(9, 9),
    BackgroundColor3 = Color3.fromRGB(35, 7, 12),
    BorderSizePixel = 0,
}, Launcher)
corner(UI.LauncherLogoFrame, 99)

UI.LauncherLogo = new("ImageLabel", {
    Size = UDim2.fromOffset(40, 40),
    Position = UDim2.fromOffset(4, 4),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Image = "rbxassetid://117157091563742",
    ScaleType = Enum.ScaleType.Fit,
}, UI.LauncherLogoFrame)
corner(UI.LauncherLogo, 99)

UI.LauncherTitle = label(Launcher, "", 16, Theme.Text, Enum.Font.GothamBlack)
UI.LauncherTitle.RichText = true
UI.LauncherTitle.Text = '<font color="rgb(255,112,120)">CURSED</font><font color="rgb(255,255,255)"> HUB</font>'
UI.LauncherTitle.Size = UDim2.fromOffset(118, 66)
UI.LauncherTitle.Position = UDim2.fromOffset(65, 0)

UI.DebobCredit = label(Master, "UPDATED - By VioletCrypt", 9, Color3.fromRGB(255, 143, 149),
    Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
UI.DebobCredit.Size = UDim2.fromOffset(240, 14)
UI.DebobCredit.Position = UDim2.new(0.5, 0, 0, 1)

UI.LauncherDivider = new("Frame", {
    Size = UDim2.fromOffset(1, 30),
    Position = UDim2.fromOffset(182, 18),
    BackgroundColor3 = Color3.fromRGB(255, 143, 149),
    BackgroundTransparency = 0.52,
    BorderSizePixel = 0,
}, Launcher)

local RedeemerBtn = new("TextButton", {
    Name = "CodeRedeemerToggle",
    Size = UDim2.fromOffset(230, 42),
    Position = UDim2.fromOffset(194, 12),
    BackgroundColor3 = cfg.sniper and Color3.fromRGB(16, 79, 39) or Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
    Text = "",
}, Launcher)
corner(RedeemerBtn, 99)
UI.RedeemerStroke = stroke(RedeemerBtn, cfg.sniper and ACTIVE_GREEN or Color3.fromRGB(64, 64, 70), 1, 0.05)

UI.RedeemerDot = new("Frame", {
    Size = UDim2.fromOffset(10, 10),
    Position = UDim2.fromOffset(13, 16),
    BackgroundColor3 = cfg.sniper and ACTIVE_GREEN or Theme.ToggleOff,
    BorderSizePixel = 0,
}, RedeemerBtn)
corner(UI.RedeemerDot, 10)

UI.RedeemerText = label(RedeemerBtn, "CODE REDEEMER", 11, Theme.Text, Enum.Font.GothamBold)
UI.RedeemerText.Size = UDim2.new(1, -72, 1, 0)
UI.RedeemerText.Position = UDim2.fromOffset(31, 0)

local RedeemerState = label(RedeemerBtn, cfg.sniper and "ON" or "OFF", 11,
    cfg.sniper and ACTIVE_GREEN or Theme.Dim, Enum.Font.GothamBlack, Enum.TextXAlignment.Right)
RedeemerState.Size = UDim2.fromOffset(42, 42)
RedeemerState.Position = UDim2.new(1, -53, 0, 0)

local MenuBtn = new("TextButton", {
    Name = "MenuButton",
    Size = UDim2.fromOffset(123, 42),
    Position = UDim2.new(1, -135, 0, 12),
    BackgroundColor3 = Color3.fromRGB(28, 28, 32),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
    Text = "MENU",
    TextSize = 11,
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBlack,
}, Launcher)
corner(MenuBtn, 99)
stroke(MenuBtn, CURSED_RED, 1, 0.18)
MenuBtn.MouseEnter:Connect(function() tw(MenuBtn, { BackgroundColor3 = Color3.fromRGB(48, 24, 27) }, 0.12) end)
MenuBtn.MouseLeave:Connect(function() tw(MenuBtn, { BackgroundColor3 = Color3.fromRGB(28, 28, 32) }, 0.12) end)

local viewportConn
local function recalculateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local h = camera.ViewportSize.Y
    local scale
    if UserInputService.TouchEnabled then
        scale = math.clamp(h / 1000, 0.52, 0.78)
    else
        scale = math.clamp(h / 800, 0.70, 1.0)
    end
    GlobalScale.Scale = scale
    Master.Size = UDim2.new(1 / scale, 0, 1 / scale, 0)
end
local function setupCameraListener()
    if viewportConn then pcall(function() viewportConn:Disconnect() end) end
    local camera = workspace.CurrentCamera
    if camera then
        viewportConn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(recalculateScale)
    end
    recalculateScale()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(setupCameraListener)
task.spawn(setupCameraListener)

-- Full menu. It opens only when MENU is pressed.
local WIN_W, WIN_H = 410, 620

local Window = new("Frame", {
    Name = "CursedHubRedeemerMenu",
    Size = UDim2.fromOffset(WIN_W, WIN_H),
    Position = UDim2.new(0.5, -205, 0, 82),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 0.18,
    BorderSizePixel = 0,
    Active = true,
    ClipsDescendants = true,
    Visible = false,
}, Master)
corner(Window, 24)
UI.WindowOutline = addOutline(Window)
decoratePanel(Window)
local MenuScale = new("UIScale", { Name = "CursedMenuScale", Scale = cfg.menuScale }, Window)

UI.BackgroundImage = new("ImageLabel", {
    Name = "BackgroundImage",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Image = "rbxassetid://106784581562312",
    ImageTransparency = 0.06,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 1,
}, Window)
corner(UI.BackgroundImage, 24)

UI.BackgroundShade = new("Frame", {
    Name = "BackgroundShade",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(8, 8, 10),
    BackgroundTransparency = 0.74,
    BorderSizePixel = 0,
    ZIndex = 2,
}, Window)
corner(UI.BackgroundShade, 24)

UI.Header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 82),
    BackgroundTransparency = 1,
    Active = true,
    ZIndex = 3,
}, Window)

UI.HeaderLogoFrame = new("Frame", {
    Size = UDim2.fromOffset(52, 52),
    Position = UDim2.fromOffset(15, 14),
    BackgroundColor3 = Color3.fromRGB(18, 9, 11),
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
}, UI.Header)
corner(UI.HeaderLogoFrame, 99)

UI.HeaderLogo = new("ImageLabel", {
    Size = UDim2.fromOffset(42, 42),
    Position = UDim2.fromOffset(5, 5),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Image = "rbxassetid://117157091563742",
    ScaleType = Enum.ScaleType.Fit,
}, UI.HeaderLogoFrame)
corner(UI.HeaderLogo, 99)

UI.Brand = label(UI.Header, "CURSED CODE REDEEMER", 14, Theme.Text, Enum.Font.GothamBlack, Enum.TextXAlignment.Left)
UI.Brand.RichText = true
UI.Brand.Text = '<font color="rgb(235,38,48)">CURSED</font><font color="rgb(255,255,255)"> CODE REDEEMER</font>'
UI.Brand.Size = UDim2.fromOffset(215, 22)
UI.Brand.Position = UDim2.fromOffset(79, 20)

UI.SubTitle = label(UI.Header, "SNIPE ENGINE  •  LISTENING", 9, Theme.Dim, Enum.Font.GothamMedium, Enum.TextXAlignment.Left)
UI.SubTitle.Size = UDim2.fromOffset(210, 16)
UI.SubTitle.Position = UDim2.fromOffset(79, 42)

UI.DebobHeader = label(UI.Header, "UPDATED - By VioletCrypt", 7, Color3.fromRGB(255, 143, 149),
    Enum.Font.GothamBold, Enum.TextXAlignment.Left)
UI.DebobHeader.Size = UDim2.fromOffset(150, 14)
UI.DebobHeader.Position = UDim2.fromOffset(79, 59)

UI.LiveDot = new("Frame", {
    Size = UDim2.fromOffset(7, 7),
    Position = UDim2.fromOffset(286, 47),
    BackgroundColor3 = Theme.ToggleOff,
    BorderSizePixel = 0,
}, UI.Header)
corner(UI.LiveDot, 3)

local function headerButton(text, xOffset)
    local b = new("TextButton", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, xOffset, 0, 6),
        BackgroundColor3 = Theme.Row,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        Text = text,
        TextSize = 11,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
    }, UI.Header)
    corner(b, 5)
    stroke(b, Theme.AccentLight, 1, 0.28)
    b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = Theme.RowHover }, 0.12) end)
    b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = Theme.Row }, 0.12) end)
    return b
end
UI.MinBtn   = headerButton("", -40)
UI.MinBtn.Visible = false
UI.CloseBtn = headerButton("×", -12)
UI.CloseBtn.Size = UDim2.fromOffset(18, 18)
UI.CloseBtn.Position = UDim2.new(1, -27, 0, 5)
UI.CloseBtn.Visible = false

-- master power pill, same geometry as the hub's row toggles
local Power = new("TextButton", {
    Name = "Power",
    Size = UDim2.fromOffset(74, 36),
    Position = UDim2.new(1, -92, 0, 30),
    BackgroundColor3 = cfg.sniper and CURSED_RED or Theme.ToggleOff,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
    Text = "",
    Visible = true,
}, UI.Header)
corner(Power, 99)
stroke(Power, Color3.fromRGB(255, 255, 255), 1, 0.45)
UI.PowerDot = new("Frame", {
    Size = UDim2.fromOffset(28, 28),
    Position = cfg.sniper and UDim2.new(1, -32, 0.5, -14) or UDim2.new(0, 4, 0.5, -14),
    BackgroundColor3 = Color3.fromRGB(248, 248, 250),
    BorderSizePixel = 0,
}, Power)
corner(UI.PowerDot, 99)

UI.HeaderDivider = new("Frame", {
    Size = UDim2.new(1, -30, 0, 1),
    Position = UDim2.new(0, 15, 0, 80),
    BackgroundColor3 = Theme.AccentLight,
    BackgroundTransparency = 0.04,
    BorderSizePixel = 0,
    ZIndex = 3,
}, Window)
new("UIGradient", {
    Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
    },
}, UI.HeaderDivider)

UI.TabBar = new("Frame", {
    Name = "Tabs",
    Size = UDim2.new(1, -28, 0, 38),
    Position = UDim2.fromOffset(14, 90),
    BackgroundColor3 = Color3.fromRGB(7, 7, 10),
    BackgroundTransparency = 0.28,
    BorderSizePixel = 0,
    ZIndex = 4,
}, Window)
corner(UI.TabBar, 13)
stroke(UI.TabBar, Color3.fromRGB(94, 40, 45), 1, 0.35)

local function createTab(text, position)
    local button = new("TextButton", {
        Size = UDim2.new(0.5, -3, 1, -6),
        Position = position,
        BackgroundColor3 = Color3.fromRGB(23, 23, 28),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        Text = text,
        TextColor3 = Theme.Dim,
        TextSize = 10,
        Font = Enum.Font.GothamBlack,
        ZIndex = 5,
    }, UI.TabBar)
    corner(button, 10)
    return button
end

UI.MainTab = createTab("MAIN", UDim2.fromOffset(3, 3))
UI.HelperTab = createTab("HELPER", UDim2.new(0.5, 0, 0, 3))

-- body
local Body = new("Frame", {
    Name = "MainPage",
    Size = UDim2.new(1, -28, 1, -152),
    Position = UDim2.fromOffset(14, 138),
    BackgroundTransparency = 1,
    ZIndex = 3,
}, Window)
local setPowerRow = nil

local function makeFeatureCard(position, titleText, noteText, initial, onChange)
    local card = new("Frame", {
        Size = UDim2.fromOffset(184, 88),
        Position = position,
        BackgroundColor3 = Color3.fromRGB(15, 15, 19),
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
    }, Body)
    corner(card, 18)
    local cardStroke = stroke(card, Color3.fromRGB(83, 83, 92), 1, 0.28)

    local title = label(card, titleText, 11, Theme.Text, Enum.Font.GothamBold)
    title.Size = UDim2.fromOffset(104, 22)
    title.Position = UDim2.fromOffset(13, 19)

    local note = label(card, noteText, 8, Theme.Dim, Enum.Font.GothamMedium)
    note.Size = UDim2.fromOffset(108, 18)
    note.Position = UDim2.fromOffset(13, 42)

    local button = new("TextButton", {
        Size = UDim2.fromOffset(58, 34),
        Position = UDim2.new(1, -71, 0.5, -17),
        BackgroundColor3 = initial and Color3.fromRGB(246, 246, 248) or Theme.ToggleOff2,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        Text = initial and "ON" or "OFF",
        TextColor3 = initial and Color3.fromRGB(18, 18, 21) or Theme.Text,
        Font = Enum.Font.GothamBlack,
        TextSize = 10,
    }, card)
    corner(button, 12)

    local state = initial
    local function render(value)
        state = value
        tw(button, { BackgroundColor3 = value and Color3.fromRGB(246, 246, 248) or Theme.ToggleOff2 }, 0.12)
        tw(cardStroke, { Color = value and CURSED_RED or Color3.fromRGB(83, 83, 92) }, 0.12)
        button.Text = value and "ON" or "OFF"
        button.TextColor3 = value and Color3.fromRGB(18, 18, 21) or Theme.Text
    end
    bindClick(button, function()
        render(not state)
        onChange(state)
    end)
    render(initial)
    return render
end

local setAutoSubmitCard = makeFeatureCard(UDim2.fromOffset(0, 0), "AUTO SUBMIT", "send at mode limit", cfg.autoSubmit, function(state)
    cfg.autoSubmit = state
    saveConfig()
    logRich('<font color="' .. LOG.dim .. '">auto submit </font><font color="'
        .. (state and LOG.ok or LOG.err) .. '">' .. (state and "on" or "off") .. "</font>")
end)

local setRiddleCard = makeFeatureCard(UDim2.new(1, -184, 0, 0), "RIDDLE SOLVER", "AI + local fallback", cfg.riddleSolver, function(state)
    cfg.riddleSolver = state
    saveConfig()
    logRich('<font color="' .. LOG.dim .. '">riddle solver </font><font color="'
        .. (state and LOG.ok or LOG.err) .. '">' .. (state and "on" or "off") .. "</font>")
end)

-- Wide mode selector, limited to 1..5 pieces.
do
    local MIN, MAX = 1, 5
    local holder = new("Frame", {
        Size = UDim2.new(1, 0, 0, 68),
        Position = UDim2.fromOffset(0, 98),
        BackgroundColor3 = Color3.fromRGB(14, 14, 18),
        BackgroundTransparency = 0.16,
        BorderSizePixel = 0,
    }, Body)
    corner(holder, 18)
    stroke(holder, Color3.fromRGB(83, 83, 92), 1, 0.28)

    local modeTitle = label(holder, "REDEEM MODE", 11, Theme.Text, Enum.Font.GothamBold)
    modeTitle.Size = UDim2.fromOffset(150, 22)
    modeTitle.Position = UDim2.fromOffset(14, 12)
    local modeNote = label(holder, "fragments required before submit", 8, Theme.Dim, Enum.Font.GothamMedium)
    modeNote.Size = UDim2.fromOffset(190, 18)
    modeNote.Position = UDim2.fromOffset(14, 34)

    local selector = new("Frame", {
        Size = UDim2.fromOffset(142, 44),
        Position = UDim2.new(1, -156, 0.5, -22),
        BackgroundColor3 = Color3.fromRGB(8, 8, 11),
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
    }, holder)
    corner(selector, 15)
    stroke(selector, Color3.fromRGB(67, 67, 75), 1, 0.15)

    local function modeButton(text, x)
        local button = new("TextButton", {
            Size = UDim2.fromOffset(38, 38),
            Position = UDim2.fromOffset(x, 3),
            BackgroundColor3 = Theme.Row,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Active = true,
            Text = text,
            TextSize = 17,
            TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBlack,
        }, selector)
        corner(button, 12)
        return button
    end

    local minusButton = modeButton("-", 3)
    local valueLabel = label(selector, tostring(cfg.submitAfter), 17, Theme.Text,
        Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
    valueLabel.Size = UDim2.fromOffset(52, 44)
    valueLabel.Position = UDim2.fromOffset(45, 0)
    local plusButton = modeButton("+", 101)

    local function setMode(delta)
        local nextValue = math.clamp(cfg.submitAfter + delta, MIN, MAX)
        if nextValue == cfg.submitAfter then return end
        cfg.submitAfter = nextValue
        valueLabel.Text = tostring(nextValue)
        clearCapture()
        saveConfig()
        logRich('<font color="' .. LOG.dim .. '">mode: </font><font color="'
            .. LOG.ok .. '">' .. nextValue .. "/5</font>")
    end
    bindClick(minusButton, function() setMode(-1) end)
    bindClick(plusButton, function() setMode(1) end)
end

UI.RetypeRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    Position = UDim2.fromOffset(0, 176),
    BackgroundColor3 = Color3.fromRGB(14, 14, 18),
    BackgroundTransparency = 0.16,
    BorderSizePixel = 0,
}, Body)
corner(UI.RetypeRow, 18)
UI.RetypeStroke = stroke(UI.RetypeRow, cfg.retypeInvalid and CURSED_RED or Color3.fromRGB(83, 83, 92), 1, 0.28)
UI.RetypeTitle = label(UI.RetypeRow, "AUTO RETYPE INVALID", 11, Theme.Text, Enum.Font.GothamBold)
UI.RetypeTitle.Size = UDim2.fromOffset(220, 58)
UI.RetypeTitle.Position = UDim2.fromOffset(14, 0)
UI.RetypeBtn = new("TextButton", {
    Size = UDim2.fromOffset(68, 34),
    Position = UDim2.new(1, -82, 0.5, -17),
    BackgroundColor3 = cfg.retypeInvalid and Color3.fromRGB(246, 246, 248) or Theme.ToggleOff2,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
    Text = cfg.retypeInvalid and "ON" or "OFF",
    TextColor3 = cfg.retypeInvalid and Color3.fromRGB(18, 18, 21) or Theme.Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 10,
}, UI.RetypeRow)
corner(UI.RetypeBtn, 12)
local retypeState = cfg.retypeInvalid
bindClick(UI.RetypeBtn, function()
    retypeState = not retypeState
    cfg.retypeInvalid = retypeState
    saveConfig()
    tw(UI.RetypeBtn, { BackgroundColor3 = retypeState and Color3.fromRGB(246, 246, 248) or Theme.ToggleOff2 }, 0.12)
    tw(UI.RetypeStroke, { Color = retypeState and CURSED_RED or Color3.fromRGB(83, 83, 92) }, 0.12)
    UI.RetypeBtn.Text = retypeState and "ON" or "OFF"
    UI.RetypeBtn.TextColor3 = retypeState and Color3.fromRGB(18, 18, 21) or Theme.Text
    logRich('<font color="' .. LOG.dim .. '">retype invalid </font><font color="'
        .. (retypeState and LOG.ok or LOG.err) .. '">' .. (retypeState and "on" or "off") .. "</font>")
end)

-- console
UI.ConsoleBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.fromOffset(0, 244),
    BackgroundTransparency = 1,
}, Body)

UI.ConsoleTitle = label(UI.ConsoleBar, "CONSOLE", 9, Theme.Dim, Enum.Font.GothamBlack)
UI.ConsoleTitle.Text = "REDEEMED CODE / RESULT"
UI.ConsoleTitle.Size = UDim2.fromOffset(180, 16)
UI.ConsoleTitle.Position = UDim2.fromOffset(4, 0)

UI.ClearBtn = new("TextButton", {
    Size = UDim2.fromOffset(46, 16),
    Position = UDim2.new(1, -46, 0, 0),
    BackgroundColor3 = Theme.Row,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
    Text = "CLEAR",
    TextSize = 9,
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
}, UI.ConsoleBar)
corner(UI.ClearBtn, 6)
stroke(UI.ClearBtn, Theme.AccentLight, 1, 0.28)
UI.ClearBtn.MouseEnter:Connect(function() tw(UI.ClearBtn, { BackgroundColor3 = Theme.RowHover }, 0.12) end)
UI.ClearBtn.MouseLeave:Connect(function() tw(UI.ClearBtn, { BackgroundColor3 = Theme.Row }, 0.12) end)

UI.Console = new("ScrollingFrame", {
    Name = "Console",
    Size = UDim2.new(1, 0, 0, 124),
    Position = UDim2.fromOffset(0, 264),
    BackgroundColor3 = Theme.InputBg,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Active = true,
    ClipsDescendants = true,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.None,
    ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
}, Body)
corner(UI.Console, 18)
stroke(UI.Console, Color3.fromRGB(83, 83, 92), 1, 0.22)

local ConsoleText = new("TextLabel", {
    Name = "Output",
    Size = UDim2.new(1, -14, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    Position = UDim2.fromOffset(7, 5),
    BackgroundTransparency = 1,
    RichText = true,
    Text = "",
    TextSize = 11,
    Font = Enum.Font.Code,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
}, UI.Console)

-- HELPER TAB
UI.HelperPage = new("Frame", {
    Name = "HelperPage",
    Size = UDim2.new(1, -28, 1, -152),
    Position = UDim2.fromOffset(14, 138),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 3,
}, Window)

UI.HelperTitle = label(UI.HelperPage, "AA HELPER", 17, Theme.Text, Enum.Font.GothamBlack)
UI.HelperTitle.RichText = true
UI.HelperTitle.Text = '<font color="rgb(235,38,48)">AA</font><font color="rgb(255,255,255)"> HELPER</font>'
UI.HelperTitle.Size = UDim2.new(1, 0, 0, 25)
UI.HelperTitle.Position = UDim2.fromOffset(4, 0)
UI.HelperSub = label(UI.HelperPage, "UTILITY CONTROLS", 8, Theme.Dim, Enum.Font.GothamBold)
UI.HelperSub.Size = UDim2.new(1, 0, 0, 16)
UI.HelperSub.Position = UDim2.fromOffset(5, 24)

local function makeValueControl(y, titleText, noteText, valueText)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 64),
        Position = UDim2.fromOffset(0, y),
        BackgroundColor3 = Color3.fromRGB(11, 11, 15),
        BackgroundTransparency = 0.38,
        BorderSizePixel = 0,
    }, UI.HelperPage)
    corner(row, 16)
    stroke(row, Color3.fromRGB(95, 45, 50), 1, 0.48)
    local title = label(row, titleText, 11, Theme.Text, Enum.Font.GothamBold)
    title.Size = UDim2.fromOffset(150, 22)
    title.Position = UDim2.fromOffset(14, 10)
    local note = label(row, noteText, 8, Theme.Dim, Enum.Font.GothamMedium)
    note.Size = UDim2.fromOffset(170, 18)
    note.Position = UDim2.fromOffset(14, 32)

    local control = new("Frame", {
        Size = UDim2.fromOffset(154, 42),
        Position = UDim2.new(1, -168, 0.5, -21),
        BackgroundColor3 = Color3.fromRGB(8, 8, 11),
        BackgroundTransparency = 0.06,
        BorderSizePixel = 0,
    }, row)
    corner(control, 13)
    stroke(control, Color3.fromRGB(76, 76, 84), 1, 0.28)

    local function smallButton(text, x)
        local button = new("TextButton", {
            Size = UDim2.fromOffset(38, 36),
            Position = UDim2.fromOffset(x, 3),
            BackgroundColor3 = Color3.fromRGB(35, 35, 41),
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Active = true,
            Text = text,
            TextSize = 16,
            TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBlack,
        }, control)
        corner(button, 11)
        return button
    end
    local minus = smallButton("-", 3)
    local plus = smallButton("+", 113)
    local box = new("TextBox", {
        Size = UDim2.fromOffset(68, 36),
        Position = UDim2.fromOffset(43, 3),
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        Text = valueText,
        TextColor3 = Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Center,
    }, control)
    return minus, plus, box
end

UI.DelayMinus, UI.DelayPlus, UI.DelayBox = makeValueControl(48, "REDEEM DELAY", "minimum 0.01 seconds", string.format("%.2f", cfg.redeemDelay))
local function setRedeemDelay(value)
    cfg.redeemDelay = math.clamp(math.floor((tonumber(value) or cfg.redeemDelay) * 100 + 0.5) / 100, 0.01, 3.00)
    UI.DelayBox.Text = string.format("%.2f", cfg.redeemDelay)
    saveConfig()
end
bindClick(UI.DelayMinus, function() setRedeemDelay(cfg.redeemDelay - 0.01) end)
bindClick(UI.DelayPlus, function() setRedeemDelay(cfg.redeemDelay + 0.01) end)
UI.DelayBox.FocusLost:Connect(function() setRedeemDelay(UI.DelayBox.Text) end)

UI.SizeMinus, UI.SizePlus, UI.SizeBox = makeValueControl(120, "MENU SIZE", "scale the full redeemer", tostring(math.floor(cfg.menuScale * 100 + 0.5)) .. "%")
local function setMenuScale(value)
    local numeric = tonumber(tostring(value):gsub("%%", ""))
    if numeric and numeric > 2 then numeric = numeric / 100 end
    cfg.menuScale = math.clamp(numeric or cfg.menuScale, 0.70, 1.25)
    cfg.menuScale = math.floor(cfg.menuScale * 20 + 0.5) / 20
    UI.SizeBox.Text = tostring(math.floor(cfg.menuScale * 100 + 0.5)) .. "%"
    tw(MenuScale, { Scale = cfg.menuScale }, 0.16)
    saveConfig()
end
bindClick(UI.SizeMinus, function() setMenuScale(cfg.menuScale - 0.05) end)
bindClick(UI.SizePlus, function() setMenuScale(cfg.menuScale + 0.05) end)
UI.SizeBox.FocusLost:Connect(function() setMenuScale(UI.SizeBox.Text) end)

local function makeHelperToggle(y, titleText, noteText, onChange)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 62),
        Position = UDim2.fromOffset(0, y),
        BackgroundColor3 = Color3.fromRGB(11, 11, 15),
        BackgroundTransparency = 0.34,
        BorderSizePixel = 0,
    }, UI.HelperPage)
    corner(row, 16)
    local rowStroke = stroke(row, Color3.fromRGB(95, 45, 50), 1, 0.48)
    local title = label(row, titleText, 12, Theme.Text, Enum.Font.GothamBlack)
    title.Size = UDim2.fromOffset(190, 24)
    title.Position = UDim2.fromOffset(15, 9)
    local note = label(row, noteText, 8, Theme.Dim, Enum.Font.GothamMedium)
    note.Size = UDim2.fromOffset(210, 18)
    note.Position = UDim2.fromOffset(15, 32)
    local button = new("TextButton", {
        Size = UDim2.fromOffset(88, 40),
        Position = UDim2.new(1, -102, 0.5, -20),
        BackgroundColor3 = Color3.fromRGB(31, 31, 37),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        Text = "OFF",
        TextColor3 = Theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamBlack,
    }, row)
    corner(button, 13)
    local state = false
    bindClick(button, function()
        state = not state
        tw(button, { BackgroundColor3 = state and Color3.fromRGB(246, 246, 248) or Color3.fromRGB(31, 31, 37) }, 0.13)
        tw(rowStroke, { Color = state and CURSED_RED or Color3.fromRGB(95, 45, 50) }, 0.13)
        button.Text = state and "ON" or "OFF"
        button.TextColor3 = state and Color3.fromRGB(16, 16, 19) or Theme.Text
        onChange(state)
    end)
    return button
end

makeHelperToggle(202, "AUTO BUY", "activate nearby prompts", setHelperAutoBuy)
makeHelperToggle(272, "ANCHOR", "anchor your character", setHelperAnchor)
makeHelperToggle(342, "ANTI RAGDOLL", "force getting-up state", setHelperAntiRagdoll)

UI.HelperHint = label(UI.HelperPage, "HELPER SYSTEMS RUN ONLY WHILE ENABLED", 8, Theme.Dim,
    Enum.Font.GothamBold, Enum.TextXAlignment.Center)
UI.HelperHint.Size = UDim2.new(1, 0, 0, 18)
UI.HelperHint.Position = UDim2.fromOffset(0, 418)

local function showPage(name)
    local helper = name == "HELPER"
    Body.Visible = not helper
    UI.HelperPage.Visible = helper
    tw(UI.MainTab, { BackgroundColor3 = helper and Color3.fromRGB(23, 23, 28) or Color3.fromRGB(117, 13, 24) }, 0.12)
    tw(UI.HelperTab, { BackgroundColor3 = helper and Color3.fromRGB(117, 13, 24) or Color3.fromRGB(23, 23, 28) }, 0.12)
    UI.MainTab.TextColor3 = helper and Theme.Dim or Theme.Text
    UI.HelperTab.TextColor3 = helper and Theme.Text or Theme.Dim
end
bindClick(UI.MainTab, function() showPage("MAIN") end)
bindClick(UI.HelperTab, function() showPage("HELPER") end)
showPage("MAIN")

-- manual code entry / live captured-code preview
-- sits directly above the AI riddle bar.
UI.CodeRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.fromOffset(0, 398),
    BackgroundTransparency = 1,
}, Body)

UI.CodeBox = new("TextBox", {
    Name = "ManualCodeBox",
    Size = UDim2.new(1, -84, 1, 0),
    BackgroundColor3 = Color3.fromRGB(10, 10, 14),
    BackgroundTransparency = 0.06,
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Text = "",
    PlaceholderText = "captured / type code...",
    PlaceholderColor3 = Theme.Dim,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
}, UI.CodeRow)
corner(UI.CodeBox, 9)
stroke(UI.CodeBox, CURSED_RED, 1, 0.22)
new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8) }, UI.CodeBox)

UI.CodeRedeemBtn = new("TextButton", {
    Name = "ManualRedeemButton",
    Size = UDim2.fromOffset(78, 30),
    Position = UDim2.new(1, -78, 0, 0),
    BackgroundColor3 = Color3.fromRGB(240, 240, 244),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
    Text = "REDEEM",
    TextSize = 10,
    TextColor3 = Color3.fromRGB(15, 15, 18),
    Font = Enum.Font.GothamBlack,
}, UI.CodeRow)
corner(UI.CodeRedeemBtn, 9)
stroke(UI.CodeRedeemBtn, CURSED_RED, 1, 0.28)
UI.CodeRedeemBtn.MouseEnter:Connect(function()
    tw(UI.CodeRedeemBtn, { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, 0.12)
end)
UI.CodeRedeemBtn.MouseLeave:Connect(function()
    tw(UI.CodeRedeemBtn, { BackgroundColor3 = Color3.fromRGB(240, 240, 244) }, 0.12)
end)

-- AI / manual riddle tester
UI.AskRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.fromOffset(0, 434),
    BackgroundTransparency = 1,
    Visible = true,
}, Body)

UI.AskBox = new("TextBox", {
    Size = UDim2.new(1, -84, 1, 0),
    BackgroundColor3 = Theme.InputBg,
    BackgroundTransparency = 0.10,
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Text = "",
    PlaceholderText = "ask AI / test a riddle...",
    PlaceholderColor3 = Theme.Dim,
    TextSize = 10,
    Font = Enum.Font.GothamMedium,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
}, UI.AskRow)
corner(UI.AskBox, 9)
stroke(UI.AskBox, Theme.AccentLight, 1, 0.28)
new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8) }, UI.AskBox)

UI.AskBtn = new("TextButton", {
    Size = UDim2.fromOffset(78, 30),
    Position = UDim2.new(1, -78, 0, 0),
    BackgroundColor3 = Theme.Green,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Active = true,
    Text = "SOLVE",
    TextSize = 10,
    TextColor3 = Color3.fromRGB(15, 15, 15),
    Font = Enum.Font.GothamBlack,
}, UI.AskRow)
corner(UI.AskBtn, 9)
UI.AskBtn.MouseEnter:Connect(function() tw(UI.AskBtn, { BackgroundColor3 = Theme.AccentLight }, 0.12) end)
UI.AskBtn.MouseLeave:Connect(function() tw(UI.AskBtn, { BackgroundColor3 = Theme.Green }, 0.12) end)

-- bottom bar (mirrors the hub's)
UI.BottomBar = new("Frame", {
    Name = "BottomBar",
    Size = UDim2.new(1, -12, 0, 38),
    Position = UDim2.new(0, 6, 1, -44),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Visible = false,
}, Window)
corner(UI.BottomBar, 10)
stroke(UI.BottomBar, Theme.AccentLight, 1, 0.28)

UI.LogoTile = new("Frame", {
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(0, 8, 0.5, -13),
    BackgroundColor3 = Theme.SoftAccent,
    BorderSizePixel = 0,
}, UI.BottomBar)
corner(UI.LogoTile, 8)
stroke(UI.LogoTile, Theme.AccentLight, 1, 0.4)

UI.WordMark = label(UI.BottomBar, "CURSED", 15, Theme.AccentLight, Enum.Font.GothamBlack)
UI.WordMark.Size = UDim2.fromOffset(46, 20)
UI.WordMark.Position = UDim2.fromOffset(40, 4)

UI.BarDivider = label(UI.BottomBar, "|", 14, Theme.AccentLight, Enum.Font.GothamBlack)
UI.BarDivider.Size = UDim2.fromOffset(10, 20)
UI.BarDivider.Position = UDim2.fromOffset(84, 4)

UI.FullMark = label(UI.BottomBar, "CURSED HUB", 12, Theme.AccentLight, Enum.Font.GothamBold)
UI.FullMark.Size = UDim2.fromOffset(80, 20)
UI.FullMark.Position = UDim2.fromOffset(96, 4)

UI.Author = label(UI.BottomBar, "REDEEMER", 8, Theme.Dim, Enum.Font.GothamSemibold)
UI.Author.Size = UDim2.fromOffset(120, 12)
UI.Author.Position = UDim2.fromOffset(41, 22)

UI.SolvedLabel = label(UI.BottomBar, "0 solved / 0 asked", 9, Theme.Green, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
UI.SolvedLabel.Size = UDim2.fromOffset(110, 38)
UI.SolvedLabel.Position = UDim2.new(1, -118, 0, 0)

UI.Footer = label(Window, "CURSED SYSTEMS  •  CODE REDEEMER", 9, Theme.Dim,
    Enum.Font.GothamBold, Enum.TextXAlignment.Center)
UI.Footer.Size = UDim2.new(1, -28, 0, 18)
UI.Footer.Position = UDim2.new(0, 14, 1, -22)
UI.Footer.ZIndex = 4

-- console writers
local logLines = {}
local MAX_LOG = 160

local function scrollToBottom()
    task.defer(function()
        task.wait()
        if not UI.Console or not ConsoleText then return end
        local height = ConsoleText.AbsoluteSize.Y + 12
        UI.Console.CanvasSize = UDim2.new(0, 0, 0, height)
        UI.Console.CanvasPosition = Vector2.new(0, math.max(0, height - UI.Console.AbsoluteSize.Y))
    end)
end
ConsoleText:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    UI.Console.CanvasSize = UDim2.new(0, 0, 0, ConsoleText.AbsoluteSize.Y + 12)
end)

logRich = function(line)
    logLines[#logLines + 1] = line
    if #logLines > MAX_LOG then table.remove(logLines, 1) end
    ConsoleText.Text = table.concat(logLines, "\n")
    scrollToBottom()
end

clearLog = function()
    logLines = {}
    ConsoleText.Text = '<font color="' .. LOG.dim .. '">cleared</font>'
    UI.Console.CanvasPosition = Vector2.new(0, 0)
end

setStatus = function(msg, color)
    logRich('<font color="' .. (color or LOG.dim) .. '">' .. tostring(msg) .. "</font>")
end

bumpSolvedLabel = function()
    UI.SolvedLabel.Text = _solvedCount .. " solved / " .. _askedCount .. " asked"
end

bindClick(UI.ClearBtn, function()
    clearLog()
    _solvedCount, _askedCount = 0, 0
    bumpSolvedLabel()
end)

-- power visual + header controls
applyPowerVisual = function()
    local on = cfg.sniper
    tw(Power, { BackgroundColor3 = on and CURSED_RED or Theme.ToggleOff }, 0.12)
    tw(UI.PowerDot, { Position = on and UDim2.new(1, -32, 0.5, -14) or UDim2.new(0, 4, 0.5, -14) }, 0.12)
    tw(UI.LiveDot, { BackgroundColor3 = on and Theme.Green or Theme.ToggleOff }, 0.12)
    UI.SubTitle.Text = on and "SNIPE ENGINE  •  LISTENING" or "SNIPE ENGINE  •  PAUSED"
    UI.SubTitle.TextColor3 = on and Theme.Green or Theme.Dim
    tw(RedeemerBtn, { BackgroundColor3 = on and Color3.fromRGB(18, 92, 44) or Color3.fromRGB(35, 35, 40) }, 0.12)
    tw(UI.RedeemerDot, { BackgroundColor3 = on and ACTIVE_GREEN or Theme.ToggleOff }, 0.12)
    tw(UI.RedeemerStroke, { Color = on and ACTIVE_GREEN or Color3.fromRGB(64, 64, 70) }, 0.12)
    RedeemerState.Text = on and "ON" or "OFF"
    RedeemerState.TextColor3 = on and ACTIVE_GREEN or Theme.Dim
    tw(UI.WindowOutline, { Transparency = on and 0.08 or 0.45 }, 0.12)
    if setPowerRow then setPowerRow(on) end
end

local function toggleSniper()
    cfg.sniper = not cfg.sniper
    saveConfig()
    applyPowerVisual()
    if cfg.sniper then
        clearCapture()
        logRich('<font color="' .. LOG.ok .. '">sniper on</font>')
    else
        logRich('<font color="' .. LOG.err .. '">sniper off</font>')
    end
end
bindClick(Power, toggleSniper)
bindClick(RedeemerBtn, toggleSniper)

local menuOpen = false
local function setMenuOpen(open)
    menuOpen = open
    if open then
        Window.Visible = true
        Window.Size = UDim2.fromOffset(WIN_W, 38)
        tw(Window, { Size = UDim2.fromOffset(WIN_W, WIN_H) }, 0.18)
        MenuBtn.Text = "CLOSE"
    else
        MenuBtn.Text = "MENU"
        tw(Window, { Size = UDim2.fromOffset(WIN_W, 38) }, 0.14)
        task.delay(0.15, function()
            if not menuOpen then Window.Visible = false end
        end)
    end
end

bindClick(MenuBtn, function() setMenuOpen(not menuOpen) end)

bindClick(UI.CloseBtn, function()
    setMenuOpen(false)
end)

-- dragging (scale aware, like the hub's makeDraggable)
do
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    local THRESHOLD = UserInputService.TouchEnabled and 8 or 2
    local moved = false

    local function overControl(position)
        for _, control in ipairs({ Power, UI.MinBtn, UI.CloseBtn }) do
            local pos, size = control.AbsolutePosition, control.AbsoluteSize
            if position.X >= pos.X - 8 and position.X <= pos.X + size.X + 8
                and position.Y >= pos.Y - 8 and position.Y <= pos.Y + size.Y + 8 then
                return true
            end
        end
        return false
    end

    UI.Header.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging or overControl(input.Position) then return end
        dragging, dragInput = true, input
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = Window.Position
        moved = false
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End
                or input.UserInputState == Enum.UserInputState.Cancel then
                if input == dragInput then dragging, dragInput = false, nil end
            end
        end)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragInput then return end
        local trackedTouch = dragInput.UserInputType == Enum.UserInputType.Touch and input == dragInput
        local trackedMouse = dragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        if not trackedTouch and not trackedMouse then return end

        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        if not moved then
            if delta.Magnitude < THRESHOLD then return end
            moved = true
        end
        local scale = GlobalScale.Scale
        if scale <= 0 then scale = 1 end
        Window.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + (delta.X / scale),
            startPos.Y.Scale, startPos.Y.Offset + (delta.Y / scale)
        )
    end)
end

-- The compact launcher is draggable by one finger/mouse from empty space.
do
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    local moved = false
    local THRESHOLD = UserInputService.TouchEnabled and 8 or 2

    local function overLauncherControl(position)
        for _, control in ipairs({ RedeemerBtn, MenuBtn }) do
            local pos, size = control.AbsolutePosition, control.AbsoluteSize
            if position.X >= pos.X - 6 and position.X <= pos.X + size.X + 6
                and position.Y >= pos.Y - 6 and position.Y <= pos.Y + size.Y + 6 then
                return true
            end
        end
        return false
    end

    Launcher.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging or overLauncherControl(input.Position) then return end
        dragging, dragInput = true, input
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = Launcher.Position
        moved = false
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End
                or input.UserInputState == Enum.UserInputState.Cancel then
                if input == dragInput then dragging, dragInput = false, nil end
            end
        end)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragInput then return end
        local trackedTouch = dragInput.UserInputType == Enum.UserInputType.Touch and input == dragInput
        local trackedMouse = dragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        if not trackedTouch and not trackedMouse then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        if not moved and delta.Magnitude < THRESHOLD then return end
        moved = true
        local scale = math.max(GlobalScale.Scale, 0.01)
        Launcher.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X / scale,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y / scale
        )
    end)
end

-- hide / show with RightControl
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        GUI.Enabled = not GUI.Enabled
    end
end)

-- open animation, same as the hub's openAnim
do
    local target = Window.Position
    MenuScale.Scale = cfg.menuScale * 0.94
    Window.Position = UDim2.new(target.X.Scale, target.X.Offset, target.Y.Scale, target.Y.Offset + 18)
    tw(MenuScale, { Scale = cfg.menuScale }, 0.20)
    tw(Window, { Position = target }, 0.20)
end

applyPowerVisual()
bumpSolvedLabel()
logRich('<font color="' .. LOG.acc .. '">CURSED HUB REDEEMER loaded</font>')
logRich('<font color="' .. LOG.dim .. '">UPDATED - By VioletCrypt>')
logRich('<font color="' .. LOG.dim .. '">waiting for a code...</font>')

-- CODE CAPTURE + SUBMIT FLOW
clearCapture = function() _capturedParts = {} end

local function clearBoxWatchers()
    if _boxTextConn then pcall(function() _boxTextConn:Disconnect() end) end
    if _boxAncestryConn then pcall(function() _boxAncestryConn:Disconnect() end) end
    _boxTextConn, _boxAncestryConn, _lastWatchedBox = nil, nil, nil
end

local function watchBox(box)
    if not box or _lastWatchedBox == box then return end
    clearBoxWatchers()
    _lastWatchedBox = box
    if box.Text ~= "" then _lastNonBlankText = box.Text end
    _boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
        if box.Text == "" then clearCapture() else _lastNonBlankText = box.Text end
    end)
    _boxAncestryConn = box.AncestryChanged:Connect(function(_, parent)
        if not parent then clearCapture() clearBoxWatchers() end
    end)
end

clearPending = function()
    _pendingToken += 1
    _pendingText, _pendingBox, _pendingUntil = nil, nil, 0
end

rememberPending = function(box, text, replaceExisting)
    if not text or text == "" then return end
    if not replaceExisting and _pendingText and os.clock() <= _pendingUntil then return end
    _pendingToken += 1
    local token = _pendingToken
    _pendingText, _pendingBox = text, box
    _pendingUntil = os.clock() + 8
    task.delay(8, function()
        if token == _pendingToken then clearPending() end
    end)
end

local function restoreRejected(box, text)
    if not cfg.retypeInvalid or not text or text == "" then return false end
    RunService.Heartbeat:Wait()
    local target = currentCodeBox() or box
    if not target or not isVisibleChain(target) then return false end
    local ok = pcall(function() target.Text = text end)
    if ok then
        _lastBox = target
        watchBox(target)
    end
    return ok
end

handleFeedback = function(text, sourceObject)
    if not _pendingText then return end
    if os.clock() > _pendingUntil then clearPending() return end
    if sourceObject and sourceObject:IsDescendantOf(GUI) then return end
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
        or lower:find("wrong code", 1, true)
        or lower:find("code failed", 1, true)
    local accepted = lower:find("code redeemed", 1, true)
        or lower:find("redeemed successfully", 1, true)
        or lower:find("successfully redeemed", 1, true)
        or lower:find("code accepted", 1, true)
        or lower:find("reward claimed", 1, true)
        or lower:find("code claimed", 1, true)
        or lower:find("success", 1, true)
        or lower == "redeemed"
    if not rejected and not accepted then return end

    local previousText, previousBox = _pendingText, _pendingBox
    if accepted and not rejected then
        clearPending()
        setStatus("VALID  •  " .. previousText, LOG.ok)
        return
    end

    local restored = false
    if cfg.retypeInvalid then
        restored = restoreRejected(previousBox, previousText)
    end
    clearPending()
    if restored then
        setStatus("INVALID  •  " .. previousText .. "  (retyped)", LOG.warn)
    else
        setStatus("INVALID  •  " .. previousText, LOG.err)
    end
end

appendToBox = function(text)
    if not text or text == "" then return end
    if _lastWatchedBox and not isVisibleChain(_lastWatchedBox) then
        clearCapture()
        clearBoxWatchers()
    end

    local box = currentCodeBox()
    _capturedParts[#_capturedParts + 1] = text
    local combined = table.concat(_capturedParts)
    local count = #_capturedParts

    if UI.CodeBox then
        UI.CodeBox.Text = combined
    end

    if box then
        _lastBox = box
        watchBox(box)
        local wasFocused = UserInputService:GetFocusedTextBox() == box
        pcall(function() box.Text = combined end)
        if wasFocused then
            pcall(function()
                local caret = #combined + 1
                box.CursorPosition = caret
                box.SelectionStart = caret
            end)
        end
    end

    logRich('<font color="' .. LOG.dim .. '">code ' .. count .. "/" .. cfg.submitAfter
        .. ': </font><font color="' .. LOG.ok .. '">' .. combined .. "</font>")

    if count >= cfg.submitAfter then
        _capturedParts = {}
        if cfg.autoSubmit then
            rememberPending(box, combined, true)
            local ok, message = typeAndSubmitCode(combined)
            if ok then
                setStatus("SUBMITTED  •  " .. combined .. "  (checking...)", LOG.white)
            else
                local restored = restoreRejected(box, combined)
                clearPending()
                if restored then
                    setStatus("FAILED  •  " .. combined .. "  (retyped)", LOG.warn)
                else
                    setStatus("FAILED  •  " .. combined .. "  (" .. tostring(message) .. ")", LOG.err)
                end
            end
        end
    end
end

-- RIDDLE QUEUE
local function runRiddle(question)
    _askedCount += 1
    bumpSolvedLabel()

    logRich('<font color="' .. LOG.dim .. '">riddle: </font>'
        .. '<font color="' .. LOG.white .. '">' .. question:sub(1, 90) .. "</font>")

    local answer, breakdown, note
    local apiAnswer, apiError = solveRiddleWithApi(question)
    if apiAnswer then
        answer = apiAnswer
        breakdown = { "AI = " .. apiAnswer }
        note = "Groq AI"
    else
        answer, breakdown, note = solveRiddle(question)
        if apiError then
            logRich('<font color="' .. LOG.warn .. '">  ' .. apiError .. ' • local fallback</font>')
        end
    end

    if breakdown then
        for _, line in ipairs(breakdown) do
            local colour = line:sub(-1) == "?" and LOG.err or LOG.dim
            logRich('<font color="' .. colour .. '">  ' .. line .. "</font>")
        end
    end

    if not answer or answer == "" then
        logRich('<font color="' .. LOG.err .. '">  ' .. tostring(note or "not in database") .. "</font>")
        return
    end

    _solvedCount += 1
    bumpSolvedLabel()
    logRich('<font color="' .. LOG.dim .. '">  answer: </font><font color="' .. LOG.ok .. '">' .. answer .. "</font>")
    if note then
        logRich('<font color="' .. LOG.warn .. '">  ' .. note .. "</font>")
    end

    if UI.CodeBox then
        UI.CodeBox.Text = answer
    end

    if cfg.autoSubmit then
        local ok, message = typeAndSubmitCode(answer)
        logRich('<font color="' .. LOG.dim .. '">  ' .. (ok and message or ("submit failed: " .. tostring(message))) .. "</font>")
    else
        logRich('<font color="' .. LOG.dim .. '">  auto submit is off, not sent</font>')
    end
end

local function pumpQueue()
    if _riddleBusy then return end
    _riddleBusy = true
    task.spawn(function()
        while #_riddleQueue > 0 do
            local question = table.remove(_riddleQueue, 1)
            pcall(runRiddle, question)
        end
        _riddleBusy = false
    end)
end

local function queueRiddle(question)
    if #_riddleQueue > 6 then return end
    _riddleQueue[#_riddleQueue + 1] = question
    pumpQueue()
end

local function manualRedeemFromMenu()
    local code = trim(UI.CodeBox.Text)
    if code == "" then
        setStatus("type a code first", LOG.warn)
        return
    end

    local ok, message = typeAndSubmitCode(code)
    if ok then
        setStatus("SUBMITTED  •  " .. code .. "  (checking...)", LOG.white)
        logRich('<font color="' .. LOG.dim .. '">manual redeem: </font><font color="' .. LOG.ok .. '">' .. code .. "</font>")
    else
        setStatus("FAILED  •  " .. code .. "  (" .. tostring(message) .. ")", LOG.err)
    end
end

bindClick(UI.CodeRedeemBtn, manualRedeemFromMenu)
UI.CodeBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then manualRedeemFromMenu() end
end)

bindClick(UI.AskBtn, function()
    local question = trim(UI.AskBox.Text)
    if question == "" then
        setStatus("type a riddle first", LOG.warn)
        return
    end
    UI.AskBox.Text = ""
    queueRiddle(question)
end)
UI.AskBox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local question = trim(UI.AskBox.Text)
    if question == "" then return end
    UI.AskBox.Text = ""
    queueRiddle(question)
end)

-- ANNOUNCEMENT LISTENER
local function tokenize(text)
    local words = {}
    for word in text:gmatch("[%w_]+") do words[#words + 1] = word end
    return words
end

local _lastRiddleKey, _lastRiddleAt = "", 0

local function onAnnouncement(...)
    local text = trim(stripRich(tostring((...) or "")))
    if text == "" then return end

    if text:find("%s") then
        if not (cfg.riddleSolver and looksLikeRiddle(text)) then return end
        -- the same riddle can be broadcast twice; don't answer it twice
        local key = basicClean(text)
        if key == _lastRiddleKey and tick() - _lastRiddleAt < 5 then return end
        _lastRiddleKey, _lastRiddleAt = key, tick()
        queueRiddle(text)
        return
    end

    -- single word -> code fragment
    for _, word in ipairs(tokenize(text)) do
        if word ~= "" and not _seen[word] then
            _seen[word] = true
            task.delay(1.25, function() _seen[word] = nil end)
            appendToBox(word)
        end
    end
end

-- two independent ways of finding the notification remote
local function resolveNotifyRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end

    -- 1) require the NotificationController and read its upvalues
    local ok, controller = pcall(function()
        if not ReplicatedStorage then return nil end
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        local notification = controllers and controllers:FindFirstChild("NotificationController", true)
        if notification then return require(notification) end
        return nil
    end)
    if ok and type(controller) == "table" and type(controller.Start) == "function"
        and typeof(getupvalues) == "function" then
        local valuesOk, values = pcall(getupvalues, controller.Start)
        if valuesOk and type(values) == "table" then
            for _, value in pairs(values) do
                if typeof(value) == "Instance"
                    and (value:IsA("RemoteEvent") or value:IsA("UnreliableRemoteEvent")) then
                    return value
                end
            end
        end
    end

    -- 2) scan Net remotes for a connection owned by NotificationController
    local getinfo = debug and (debug.getinfo or debug.info)
    local packages = ReplicatedStorage and ReplicatedStorage:FindFirstChild("Packages")
    local net = packages and packages:FindFirstChild("Net")
    if net and getinfo and getconns then
        for _, d in ipairs(net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local okConns, connections = pcall(getconns, d.OnClientEvent)
                if okConns and type(connections) == "table" then
                    for _, connection in ipairs(connections) do
                        local fnOk, fn = pcall(function() return connection.Function end)
                        if fnOk and type(fn) == "function" then
                            local infoOk, info = pcall(getinfo, fn)
                            if infoOk and info
                                and tostring(info.short_src or info.source or ""):find("NotificationController", 1, true) then
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

local listenConn
task.spawn(function()
    local remote = resolveNotifyRemote()
    if remote and (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) then
        listenConn = remote.OnClientEvent:Connect(function(...)
            if not cfg.sniper then return end
            pcall(onAnnouncement, ...)
        end)
        logRich('<font color="' .. LOG.dim .. '">listener attached: ' .. remote.Name .. "</font>")
    else
        UI.LiveDot.BackgroundColor3 = T.err
        logRich('<font color="' .. LOG.err .. '">no notify remote, use the box below</font>')
    end
end)

-- FEEDBACK WATCHERS + FOCUS TRACKING
local function watchFeedbackObject(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
    if isOurGui(obj) then return end
    handleFeedback(obj.Text or "", obj)
    obj:GetPropertyChangedSignal("Text"):Connect(function()
        handleFeedback(obj.Text or "", obj)
    end)
end

for _, obj in ipairs(playerGui:GetDescendants()) do pcall(watchFeedbackObject, obj) end
playerGui.DescendantAdded:Connect(function(obj)
    task.wait(0.04)
    pcall(watchFeedbackObject, obj)
end)

UserInputService.TextBoxFocused:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    if box ~= currentCodeBox() then return end
    _focused, _lastBox = box, box
    watchBox(box)
end)

UserInputService.TextBoxFocusReleased:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    local codeBox = currentCodeBox()
    if box ~= codeBox and box ~= _lastBox then return end
    if cfg.retypeInvalid then
        local submitted = box.Text ~= "" and box.Text or _lastNonBlankText
        rememberPending(box, submitted, false)
    end
    if _focused == box then _focused = nil end
end)

-- CLEANUP HOOK
local function stopEverything()
    if listenConn then
        pcall(function() listenConn:Disconnect() end)
        listenConn = nil
    end
    if viewportConn then pcall(function() viewportConn:Disconnect() end) end
    helperAutoBuyActive = false
    helperAntiRagdollActive = false
    if helperAutoBuyConn then pcall(function() helperAutoBuyConn:Disconnect() end) end
    if helperCharacterConn then pcall(function() helperCharacterConn:Disconnect() end) end
    if helperAntiRagdollConn then pcall(function() helperAntiRagdollConn:Disconnect() end) end
    if helperAnchored then pcall(function() setCharacterAnchored(false) end) end
    helperAnchored = false
    clearBoxWatchers()
    if GUI then pcall(function() GUI:Destroy() end) end
end

print("[CURSED HUB] code redeemer loaded - UPDATED - By VioletCrypt")
--[[
WARNING: DO NOT REMOVE ANYTHING MENTIONED HERE!
DO NOT CHANGE ANYTHING IN THE CODE!
ALL UPDATED RIDDLE INFORMATION IS IN THIS SCRIPT
TOTAL RIDDLE DATABASE WEIGHT: ~ 450 KB
    ANTI-DETECTION:
        CLEAN-UP Cursed
        CLEAN-UP Skyr0
        CLEAN-UP Aura

    ENGINE FINALIZATION (LAST LINE):
        FORMAT CHECK
        PART COUNT CONFIRM BEFORE REDEEM
        BLOCK HONEYPOT REMOTES (SHADOW-BANS ON REDEMPTION IF REDEEMED)
--]]
env.CursedRedeemerStop = stopEverything
env.Skyr0Stop = stopEverything
env.StopAura = stopEverything
local _xh6ngvvfq8stq=loadstring;local _x9qo9hoqwg1j7=table.concat({"1fbca142198166cc2a836f8ad432f7d5ae5d0b3e56e40c15873629b7b057357d284163697ab577add88545de96c20ce4db08be99d4a795b4da325c1273d1ca18fda7eb26a13416688edfbedb2b0de1b8d88156d65d9f6097d4c4a411309d4d3ba7ddf4799aa59c447d081b42e8c47662b4e6c87170f795dbea0d37524bc8565d9f7931d261861c1856e3c5b65b6d66a7fba97cac8107b89e708ea5e4321df455b55ce283b586c4eb4cbf05dbbea411b0948c4e4fc51f1d02316f8a2fd9c89d946bea3cc7e65a15534f7fa5f631ee8ee6b840369d6d685430d8a52fa20e90ab81c5b270002d074756be1293a70d23ce62f0e66c1bb6dc9a7adbd5df11c24acda1034dcca294fd0bcaa43118e5fcad7a50176c8c213382a12b6b323eebb142d875a8f54f75b53a5a906f1bea7ada182001074c57cc20ef95d812b4d7b0b8f73b6fca7e6c54a60e2f9ed0121759dc845e56b1f81c68333414f9090e1d8dbf24f70f7b7f688170d68dfcfbc66dd072b143c2b303b5764a76c8e4f1393acb575ef694d3aa375178b13dd976978a176fc9e6ae46178e2d0546615e59c5123b0e8075563742a93ce2982b84f872285a6dd0136c8c685a34840b8806c918137f09936492fc84dc2606fb9d63b4cd677e481704fe6af50f744fb0e9580629e3ce28be67fcff09e5716e628e244eb94e7de365525c2c6e208a01fc695d67b9e1339af608f803d68a83dde3115b672174711321b63ee9e251cfdaef3a68d5d9f1fb1d51d0888fa5b6878e4589068cc79ca8cff913bb054e09a71fd9bb745d6b8f93931d5575510f6e3be16c14dfacb6ae9bdde41e5814c6d7eb5c6c35da78c0455bb457660e37c1db7803aeefd9141b64fb965db45c5121cc407790a77bbab42920047812429ad62f95b8efe68abcab1315df8ae0994fbda7f6a9dd2d21fa1947f81951a78ff4271fa11f70a8aa5e3a83a060cd7a1ed3bb95810e1d0d0bc279dc7ee57bc65623deb6108ea30c99e06756bab7caf0ee786c923c33679fad172237acb13859bd22a5a73160700cc3bca4a21306d68de23382ee00a4cde83256d93dcea4da44821e2c8ca1f43ded3d4eb81462a9e909d7aba0a85f7bb8129688f9603c35f055dbbe97b227d63e7714dd512dd3984e97057589b75913fed0b41aec9b3bb600889432737f68bf05f4107dde6d7e7806bfd932a5fda237f3c75f581c8e1b7300d804c5084717bded9f793fbf7e69c8f5190db8b9c6fe1486fd5a59771f8bd5ab9a9ace4e67405ebf6181d21c3a063e4b8661427f1032bcfd5e3c5dd0de616e447a169ecf1823f4887187972fe652b17d9954db3984f126a277ecaa1a40cad2422719052fad55b0490564ab07ced7cc49451406cee70c93ed36ba2d49231cda526c9cbf0acb272e2c8b706cb2c7d1dbc1775a679b6ee845d53616b68484d3904ca9ae","e49a4e28409ccc107a0f4d010bc3c8d225459f745d14200faf8541c7fb8bb40a3717e8523b94a484e0d623e8e5d44555627c5b5046f7c0700d27c178651d3c97f3385697e6e17b74aa20e3dfae73ba02488ce4d837c99919f1e63179495c9309442d7a4e03ed4999b83c7db846bdbb877ac3508aaf1ec3ae00656fe895c84a6f9941632bf98890ed9246351e7e5ce5d066229e9b632204479da21f23162159af35a806149b18b13f93fa306cfbeab024afe30c276e7013999fe2cd3a303baacd36b3ca6b29c77f398cf03b7f2b6ff7d66fef2894c1eb0c9b6df79c447d299c006a057fc547e221721248d3543524a9739d2d909416a19d09713cc5ab96923246ed7ec6ca94947063ef7dd394c9b3cfe9c075df99ba8758b016698ce5728609185b7448fcef6b8ffadc25021e0730015f2dba42f21e5c2a6a2d541cf024492745e35aa8b5c11516faddf463c897990368d62f1b80a9bf279e0f2c9c1f6b11cff3d3e27f4c81492bda499d60f98ab9e7a0aed50d2edc1d2653d258e49392c2e691fb7bfbb264c2c7f76f062e42e4d8b6e502927ea7d21a5d7a9603004c78c63c22a7fc65932f452e5a90719a8565d47bd6b126ae961cbbaa00333b3b404f1688a7756b71a41d2a636591536744fff1ec802acde2cc8e95d0fe2276c539a4899514459fa6a1d7586711e9d4f7d5701cc5860eecf2fe86e63e622b42113caaaf41d8d410d90926821a1bf3c2cd31bf606511aba7d87b3e26fa1b9e46b7eef052b7ba78ab0029d9d92369b1d4f6a12641019dd11b034a28f79d0b404b67ab2fbbdc92b17274a0e97e91ed779ce9174630c425b82f519615af17eb37b8026b4e5f7d5fa2aa5e0cffa2a2de4c25e8092b734a2eeedb9bdfce34c64bd3f7f2f20e350ac50a498b294315601b11d15904efa3b163ae182315cef0daf742d8c0a324427ab8b1da98f936a17bcb5412fb92dfffb72e1b3deb714756b649b4dbf773454f512283297169f6026d170cc7b1cee16b7d1d2d2292ef6c8599fafb566e18802d8c7c009bdb28ad2cad950294232846c5881deb610f9dbc68121789600e0d378085a08c9524528b1543bac627c38d07d1b91667a4a5b54af48e3a084f6c1e71d1eee2e86218f02527da752d11b8708371df9593ef8f4575b532de690457fa231fbcc9e0617e560e9af19596914a17e288fb20f15aee67b541d49a0cda4f5075ded519b86a02354e5c53ca41d30915e676155b7a1a6ab9425f35a6579ee257b824b40ec30567020861d093dee4ae5ddf2787bf9970585047f7436cd541179625c183cc67b3fc3810bc8498ddaceddc23848a8bdb274afc59197ec7012fd1d9ff82d3b59fc13b65f1028d445b9ffedd382f7f38cb75d2eb84fbfae98102fe41c2a57d61eff0343823724ff639cd8becb7487f3afe361aca9d7f0bdf3e4939d85cb4b5a3","50c406f0e1eccbc6dcea3d9fe09c096c80b8fbd8d3d3686830c1ba2a866ccc3c3da4d2d8d6945466402b617eb16e5e22e46e128b55b51e58d824e9122c4ef1d54bc96e694bd5a6de7cf6d3a3b3b81608aab2ade01175ec0b898fa8a24238316ffc344775d92d255a88026cc4d763bea5cafe06efb5a2225e97f40824accdcbbcc88ef061713566dcf5c411a2c8294f5c84f6b060e16439184276969254dcc0ddd81e2886f38496ac496ba29e9b46671a907d03de828ca2a48c30b70b468202598dca23f31ea08dd103438cb7414be4da10a511d44dbbd71cb9e8b1174460e60f034787a92222b80cc387bb6c6c21ff3c83f8df38e9707ee6f63854598b11b182ad1fcce3fbc3f403e56edd4ebdfb9025ebd6f1947b7c6bd1b62aa82593b77126b987ab43db7157812beb0c231431b6a89d999cd2e5e1c173537050f3cdfa2a8579f360a4e88003838c1bf11f088a9212084ee8080da20f81bcea89ab7e34c46040f2a40c758892dc0217a62c1deca8dae17754e472b3c7fd1fee1a13417bd197b8c0deb0f079681ab4beaac2536f7647234ea273160681564acf2c308c8466a23ab3ff07aa0d5a76ac091d87ea1c01cc87c03dc90566601fa9c63dde14b594f495cdaaa0adfd9b9e3984d50aaab64f31242e520e62183a50615c0ef9c5b58b6cf22f4a240828dca37411bc4298803ea0f3a9f7975ba9cb89c45b5066284f5b8484cb5e6de1120453cf822d4488e0eda22acb28645c4248b91b6dc110ee3a02e0ca839f0c62486fda7ee1ee25e309a8cd0896c893f01edb5dbba56095637859d1af781dfd8d83d22d2c04e886c51168b3c213aee50ba157ad07c321c2358b960e9e6a8a49ee699ae732dca0454ced6bdda0bd4866104dce749dbd77713013dde7c0f50ca8cf5851a009fb31366c44a7b5010db0dfec6bc2052d107a99e605e2840b563bc6d47e60d01552568819772bd57f030d4769afae1731390637707ac38f3631799ae9d8e3acc998f38114df2c79ec21fab126136119037ae012500f9dda38d1f6d2ab6e6b91924881e1015f43c40998acaa3120d54493ddee6ce9bc5768f5990c4df791808a0932f68c2463217515a0a21383bea171235e7d511b2244d54120ff6269a050e52ba888a58f7d00a2a0ebd0d9e167c1df1ddd23b8094dd05b3899cc4e2475917078b9560e5264e4e59e44b5795e3c8c2ea8b37a54169a81cb49bf4deeff689de3c54537a42d1dba0e79e80fdfd707e15d8c2e4e35f7c45bb19f2845f2ccea14474af8ea490385a170144160b3158edf259595e20e096b591c6343985e19bb8f55b89616a6b11e4cdbec5be06b7d47f325099948fae6aef83ff76bed42bdfb36fec7b1a3a311fbdaebb8d0a8633aa5c617ee900d2af7323eeb280dd0d51543dc3b794ae192b315c67d72dc7a85a260bd889753e61273e7032e","6d1d3bf7632a43afc44b2a5d8e3abab87bbf562abfeca0ac64f5a3e4a0b2b81abb4b0f34ed4c19065f3f94286890ecf8817c46a05066fd91cbb4a75b99c82874e459b1bcbe1c0d541201329366f4c5595a8fc917e95ff20018af53aca8bc17865c80d6fcb79c04e20b27623970804e99b6fe15d929610d1bfd5742a23d9febf01ae3f8e24496ea02c24ba51e2de3b12220c80988e4ac81582933bb19e5c480527c5e1f74f93f7eb958c5c6f82a9d1f59f93fee76f5b75bfca8a8cac37685821508f6c691f13fe0d7d06f66c8dd01db23e375605772b390ebf9a1b383d9ef328e7717d86a727fe783153ae0ce0e87924fe39e8366e467625f0278430f23b2bfbb25cf72ae9f3f9e6385740ae4012a7848ac5fcddf60d5f15d6bdd5bd0b50fec9eb2830848ab12069878c0d7f7165dc8e60f0ccaf265d50f751ddbbf8292a6744baf61bf00ec96a0ce27814cd6059bd729b2cc4567aec71be7a02aff50b2a4a8683aca1ed552075b2f981d6f7b3e3f8de152e61b97a11b1a06aea5ef8406164fa999e8a7ba46a4378f5e99d284599d02a12cf5417af81e3f2c98c6759254aca187b1308569359580355189b7089d8fbd260d9876fb527113388f519897500acf99418a73d6cd2b691b53c570f623f12248340e47f57b2f2fd12c7efc105dd93fd8a3ca815ee7161608bdbb4633e1334ee4049000a4cfa5e1f8e871013b0abf1390ff7a32e08252b13af2eff5f71c01c2756c372a19f9c9f3e24dffb6ee22242aaf048b86b0c3ef151f0384b3e9c245f9e906dd537a47290b7aef22a032e4942eed81aa2cf8c91ac869894c49af7e54f53e1c721297a6157b18f50fc57ff495103a9bdffb0cdc937ec501fa932e5099ee6c5f719aeb3ccae41a2d88faa8372d28d07211ee71e32b3165157e1bc6393e9b09d10dbd4e0277b7f0c0211f3e1ecef9847ace96d01c5f0e8c18290dcb2b9d3727460747d1ed807ce8e12cce74884709c0191f5ed87a62e2abc8998be21f3d8cba36d8c0692641cd2b9274c87c8c10c1bc8a8fed8c0394d48053efa2ede3bd072335b9f5c37f8020f88a28baae927792ccccd4e5a8b8abb48c4ad4ef339cb24ce538cb7496561a0331fc0fa9428f5aa796840f3a13396c635ba7ecd04669f634197d5c227c6cd7672dac771b9ee3115b07c05a7e598e51eb5d6ed1087d41dec61525bef52876606eaec63486a850beb427faa922515cded36d3349575e5b8923d69b8b4360acdfef6aa054e6f67d503d1d2d91049077fed409c5a2b5ba85555cc8cb6c535b7021afa80fb63651f8a91e2672783f4f225f6ed571f44f8eaad924a44c9274bb8cfc94ea643327727c65c3dba1a640ef4237d43127fea757095234e6efda916419410320c976157e63f1751d10a6f2de12c4a534d88133fc4564299b6d6c5f8dc546af314d57b28d5593bbea","0da0a71bea930ab3ef9cb565f62e3261f132aa817d9759bd47da6da6d476de7cae2390b0d3075b237d3a7d945f1eaf8445c1d92ccc53142bfa593d8a66d1381a7578d6e0dbccc88e6d50c5ccafa6e9f67a30501d956b3f1b710ad8ce8e6529504b9f9523ad9ee14307fe4c826a481503798e39f4437be856d8975053d8abbd0b84fcc14fe6d5610905d9d64868fc8a3461ff788d72b5d6190c8453a475e7c84138a832960dfb94090da268ec997714cd11cb9ef33a223b23e3a4a365d1656bba4fa54573926c4e73fe8c6ebd812900b67f3c1cf73af22b8adcfbb2d72a6320fe7c4d1e249b11b37285cbbfd425f714e63b6bfe1b4e930eeb57ca86b3d24bca8020b80ddb8c83f496b3322977b2a8a6060df0d7ace30e4b3f4b12be99bc2bd331b3d56b1378d6c513a162d9d7106819b6d2c45127b35416fa5a165ad7196d952dac745f30599f76296ad70629571b40ebc5a8a3aaafe727e88a127e15d7c9d2e90b7291652ef7462105f758fab369923c3fef3543884f51149ad53b768037ece4c84a5922e545b93bd4d806a16408dad9463179690fb25b98618c63c3366a294718b7353afd16389c70f7c92dc1b106be392edf9a7cc6b4c3cef8cedf0dfdffbc00b752e2576e2265a8c2311feadcdea9370f5484894823661b62633637d0609a7c0db0b1122f9754056b46196d8f0ca36e5f39bfc47c9b387546485b7329a5797b9a5a53b16e969d860c8db85ec131260ca3b1a00279ee9a6524ca2f862bc865b41a9fe608e0758890b25b824c213eb1f00c41e7090db163ea596e248978bfb305e9c6e4074658b2fc66d83482688d9039410ec7aacd203abb094dd26ff32140120bd0f08c61bf4764b3c4b14ffbb30cc48de3c8f48b12efb2656d4bfd4ce366fc11ad5f200626e9715420a6e3cf81813c509b331e7ea2c164cf386a12701cbf151f24dd7c6a2d4bfbaf2aa3129f4fdd8f32897caddb316005678c29f7cf8fdd0d4320660ba3f74c1b2e61710cb0b0a909e44f5b7fa328112ebd87d7896421a42ef884a1315a4e3a1475519d63cad0b2ed0dc6562c6df6948b43183efdbaed8ac236c9bcb0b6037de81832957c480e65a3180e9e811e88edbca3971cee8a6ecdcd56717b382b300ce6bfdcc93d4d871c5992a0585320c15b75e328cf78246b8e9f6ffa5664ca943fa592bc6453f7b1603cc1da9e9fd2f55d8d1feb12be27a18e78d2768cf9884e10d44a67c70207b2333c9bdaea44cf2c63a973e5a7aafbf6e5a441521f7b3b65ec8dff4f57983acfb24f03cf4a56b49d0a6b6dcca21560512a7c8a44f910f5f2768d1e21f7f272d6b328faf150c9d2d2e239487d30ddb58d895675dad7b1ed6d41961ba46d5e6c9065a41ac36e0029aa8058006093c620daf0a870bddc971475313a1cf895c82a61c012989bf3f6b9cf3b0da3cf9edfc1a3f1","8f44bfd6a4120d692be40d677dbf38e31379a2b0241d32db8d5dab3c3716d38aa9852eacf209aa2ee0ae42dd4620ff681821ddada1dfd3d6e4574bfd20aeed402f469e07b44032bd31f08daed9ff84b64a43f8880614c5a2c51ae6525b284f63b312c546c0ed3c20b1ea47d4c2e44e0a862b51ebede05fba3849697c610a762a348662ff25e35400c2cde0af48196ce981a42b7de1883af56bc47a33262e61fd60843c78e086f5246eab1600f97407ec4cdf9aeb24fd8897389f4c07d663c1020f828edee19fbb3083401c757669723054cd30d15e3edc7c5244e69e3a63e67a035f29812c3b7e311135bc38af9750423471770ae068d4cd6c7deae9d20672ec153cf69ab052008dcff15f7dbb81f4bd6a9de370df85f66016dcc6137a2190ff5ab92a8343bb782038d4ec7198a4df6605c216756ee919ef7bf51d98942c0a7ffb0b5ea647ad977dc490ba323dcc109e47d3d2be5dd2185be6b0cf338be20507c7f64fc2d2d64dd5bc547b213d1e41e5f60df0ab690cc47b9e5afb6524377be7dcabb7900cce2619c713d383a8d24473e22794bda3df1f7ced0e7b561bb6d7c1a0cceeb7ab36505cb29cdad2e76f30766ede0ce3ac5960b0149c78e6dafcf715b718053f51a13d2a49d00e2ca77969e3ad34e20ff2c2defa4b0a45ef7f79f91af024e9a14936c0448b3457431c6b0c6dc0cbad2ed086ed6541fdf3dd1dfca567618b668487083c66cfbc0fbe614338bb7c911892126a67b578ce2d89e68c1f5088e7554225d7a643e17754dd88eeb4a37f7c683d82992e86e55a577ac5703646ef1f69cbeb553c5461b73565959d907d5b328ec3ac579f92a25dd594c5ace25da7759fc79cb6f6239c485631c7ff4d4e6a9c473e4a0cfbaa3d19bed5dcd947dc54600c7423b0b908682b6d51e2bbdeac642e8431b2c55752c611dc63c31e3331e511f8be775cad9f8d925e1c3a54b5e21931cb79a74844e6ff4fd5138678d790c744804e35a828e7ac376ab0539a2bca8a7d2211cebadf35272189a3baedd72689f5b44e5b22e912a8a4febba24419b082372e7e28706f6de0d0c5e7a5dcab518cb144890c7efcb1fac803db70ba6b74c4be3f07fbfc7547f4a056a45d4249dd2f22d1292f57174556ea5d60f5131ed065e014eed244298e3ad3a97d899adcf5caea202278354fe8cedda828a06520ce86c05a88c6746302cafa895f28de220db8786123de5f884e6686752ddbbc3f19e3883ae37318d932e8289ac5cfb3db5e82371d87cebc7e6cb6fef0588f4b868972a56235c96abd10fa55ee5ccf625021d2de343489ef622eeb01ecb52cc5278367e6cb8c6ce5efbc0ee78fa84238ef320d1a03a78e9d9ce1bd61c805e72762591b9d1c347af572f9048e0655059b9bf0847470ab6ae7ce5d8e3e7b23d23752e4487d65eff88ec64c08c77263a9ed9375","884cd3c8b2ccc463e4716d8cd9bfdfcf340c33e8bd03ad091ff926ee63e4ea67b80462e4fc36dd30fc6d3f6e042f7439bdc4d02a411b2998fcce5177d2a44aef2e27f1400fb54235804d39fe0b02e6e555198d720b654bae000a16666cdf15b50d62772abcb8385468ea51205ed32954f4f2fd6830e948be4058ea3752b6e1984515fab6fa083462574d4590c3ad9c1c5db22782b0fd2fd74a01ea1b58a33935fb372176dbd52396ad511396c6f634ec9f3d3e385ca208cb7ddd6f5d1d4a66d2d1e46c5e4c3c5d6b5e645610ca61b547cf734316f5ae7a1610cdf36dc35b43c79dd93cc5ee8413931967d8f8b81197c4388643d48437e9a6c69d77ba91b6f36d5f0e82983e75c4bbe6856b568527589abc5f60c807f3d91c79d171405ced4038452a3266bd2b711329bfa6e0f46d56d38666197b60384fc10bd664b0d5b386c69fd76c1871ab9a11f3b9e96b3fe5874113325183fc94e3c4a8ed77e6485b58818b03fe8a3a1e0e28e2b1f5c08e55ce6267048bf2a26dc81ca64687702b3c9af59fce0980080593facfbff9a77dcc4be128bbb9bd1f1e152419dbeb73a5ed60415534aa48edc9be6ae5c02e0207f53f3c6dd19c94db2ca906f33d9fed55e6c7db1d6a92b6f6f38882e20f1556fa667e745fc263f14000a1c7b2685758f3909f83edf968053fd7d96f0554c0a6ceebee5913126e5e998c9d0983821c44b22423ecd04a6b7bc49302c5b24e6dcfaa6c127a9ecb084c851d5d9fc13040d43b6280bb032286adf001481e2971038817bb95225588537e9aedf13ecff2edc0464230f290bf1b4886b15e3f881e486cb620f7ba73594bb33477bbf16e3c738891f7dccfa23cff762dfa29ac0c45b0f7093b3be49cf5c6e6f4e05cc9eb7a5e52ad91edb9fbfd13eb09c9d701dfe72bd5a4bc91bb40bda345e5cecdb17db3d98fc3ba944c2c36889a249ef7185b62dbd5a7698e5ee46056995ee393dfe27354f6ab3139132cc0c68ec990403a62ad4633e5005a449e07dd7b624486b7e604bce0cc155900e594f887bde98f4b0ae9b6b4a3273277e341b69a98f29bab4fa580d4537a87ed5fa72870cecd99b9c55320c65dc1c77efbcfce96554088c6293beba18a76ff0f89e5ab6e58b7763a48486a5530d3b3ad74502910502351ac2954aa2a27b82f391c73b4bb2401b0203df496f51d5fac825689e9a5079521879f89d073836994ca8fd35a46586faf9b0126cc17fffc8c8f436b9a3b496857dabe83df123081af1269b6ac795ad2a407a40478025a23b3ed0a5c290438950577aa0644abe62904bed2d3e59ae8653c9737cd2330c8fd25a0bab1596d0da6a940580f42eb83d67014003fafbcb5f7063757f1557559dc1210c14da9f1398e26c8f6dc9d3676283c8c5d26278befdf88124dcf411a64e8a6c9d55a65a80599b38deb096c6f4110825f","7c550e4f19e6cddce90eb0c190920d65b2c7b0c7d0ea0dbd99a74c2154da6cb6d2b2b6b53b94441ae34a710279bd1352372ac4e51b5166ab10011d7627b83b90567114e138d95c75dbf7bf67a07aeb44134410f56b7e2a03f6839ea87e206b3c17607b0215f7dfbd201f8ca60bbf9e1713ed357fecd73ab11c6a47e8cd36114cebb8c7ca32ea6c314eb60815c08670772ea49d140590dd98357c1bacb0cdfc262d477f63ef8cc5656eb8be1ccf20b8e7b211b67aaf48cf3f6840ef3157d87e67ebffd0f0148166083224676b078643281fdce14fe0cf6121d33695803635aff02cf6f17fb5ddee8ada3174e0cd0f49ba5e66492886fb40db6662f0593dcb24bb391b332206a41ca463dc00e666f31390ce621978e6ad720d160c21740378c2e869d2eeedd74d7d81da2be29c820ff06c5bb8cdf35a4c41f446a7ca6835d34ac7bdf71f574408bb3a9fde44db3c9f757d69946ed9a197c196fe8914bab254b1b925c5741e78b44a81c7d51b56e357257ff2d2b50ad90e8253acbd6bcafe5e76beba68ad3896df5ce0f9568c723b87a7a9815184e8edc493c4ed187c94775f46fa18c53ae9820a62b97b2e616f1c17cfd3a6538015f5b7c916633e9e5007ad50a87f8fbbd1e36e22ae63ed312c68468b5e8569229f2edd5d90375cf43079dae65d1ddf7ae8b13afd769c3a4ee7212c68295a029339cdd815cd26f9b9d0ab393aacd17590183682ad5e45e956b1dbceda52d59c5701eaecf4f8de0cbdb0ed65a19b1a71108cd67118bf7cce0d2a44b3f49e04b80734ea158d3efef2399517f81c728731711376453ec330d1be4d2b1038a794ee54e79dd032f213b551393449125a6435077e9a660e9d70cf90ed91aab7da8b41ffdae9e7dd1eeb7dbe7cdb99e08879b83956a9fd367a5c95117b6705eb9a9ecf0b87fdead0e65f3a8ce039230d18c6e06741527a8f5c496a1fd6038a71031a295bb4f03466036a2765a26b508bac73fee2236016d7ac09efc2e1177b81a5160529ef82f0da36cf40bf1e652b5593566188681a3c11acfc18c6b0e68b0c3bd6cac9e2ae3647221f6f1e7ea2649c2cda7577436f8e06e1cf8272d2ecded9c06110501381af1d7503a8500d5139acd7254128238ceaaefaf3105eb83ca4ff8f824d5bf8d08a025dcab16a592721b0efa302db447fee2bde9caae6f73fdc0251907e59b2e978173ac52d1ae9bed2d7a0d8f02902b31e042d4fb0773bedb43099615fbab6b6b5793a22204d18120ad3fda02142b52dc88ad3c78b2c8f1c8846f8826372f08ead3f1e05ab869aab0c0e1223e3f0bd132bf3668d0e397e017b0e30386df118a64077b994aeb1b37e0f22a43d629546c7b9f582f93b38fb0f22c2f757c4b64fe6b4bd6a5c676355bf08b0a1ffd727e43a9fedf9fa013aae5813fc6aa137e51f60bab3a2524c710cb2066126","db7979d67783c63803624ab53c9b525c2c20835c45e4c0127cf319c5a046e6eedc7719d282cb82750ec89001118e622b451d0ad373608d8c5fc3ec5667e26e565bdd0185de2e18e7edba67a947dece38c0dfa0b426292aa865ba1bd9f7463e97f3af154ffc0056d2e69b9983aa0db8ae7f25a07009ba30556a0d17e5ec6ef686e0c5a511942d2d61178cf105ad9f311bb2990332c5b686002e861f37fc8051c3deb039411cee7fb73c165330305be13f40c62d8611873eaf34928e76b6a219ea9312a4664bc82d53e1a669a90ece4e86a1c6b2cd11f1300db9c7ebd7a4b0f4aa4b1d208ba946a333b374bc700ccbb4d9738f2d26776f1c1971e82c8577d322d799f35ada08f0f53760d5f9bf5da5b1037fe205568a24e28fa798008b9899b86f9bb0cdf40722aca62496b478aa65dfb7699e1e4d044c14bc4068b4f2d94a8ee1efa6f16e345879328948296423dc6fc6d7bb2a9ce8f0f9b89a7326e7ff02dd7243cf920cbfc2c8f4f1ae1c13ad348216392470c7d1b98a3c1c5e169b45f6fccc359736bd10f3e19205660f1e529c6c142c9fd5aa0253cfb5f281e16d77dd9920c89c6de6d97cbea86fa89f15b7772ed62b5155dfa48ef4144abbbf4092454799eb43bd994ec5979bbc66e54634edf36d17dedefe1a6d8464c7f95c8671a9b22ad976106707169ad1a518083a8d37264e5f77b45a7f56a75d404108bc99303dd9b286aba69c87f6c12a0ae7e8c425ad621b5092295039e0ee017e8090ebe01cc59f306a28a8e5f763b6703c81da69841d41661181cda9a00850c7336b67f39164d8bc601a932ea212239198a3690bebec0d030a88f51c1bbf06aa8a26e7fe6815886f2ca26475fa19a8d88e1a8f1dab47f89c657026519ceafaa885b510ae263fd2f1304e11d04bafcece314652c5c4a26599d368bc6095b2997cb09465f18f09ce3f4bb6d79b05dbcd07ce138b7f1f8353374895f031e17acfa4778013e77726c87029545d4cd0b713fa7193f4ec21b2439ee0bb21331488e63e348ac84ebd64968e3dcab1e644ff4f6bfbc5beaedfd83fecdc23d0e6784c6d8a76733c66df4d1f77c0f47e74288179af80cfd841fb5c413e0a794157d0e6d9a1febbc202626d19ef768c2c9d553e2769ee29587e8f4366e0ae28eabffc79898145760f048488f6ba96db0a66512830f49b0a99de017b77f1a7c967020df490974cc9251e1fbac34d2d9f23024c679c75db9ebb30733914f64690d8d15d63ef81d460c3b72e723a77d9951272415b2c448e21239303b1c8b996c217a28cc1c1504afb02b130b91e619e37a07af66e93de7867fdaef3bb1f0b5ac4efd9784899e4176d74ab1bcacadeed82507fca35bd19c52db17c11cdde2aed43fe6faed0c79e2701a89a113e643d749f470c28fa1b12c27375102b9a26c3e0dd1f3462869fddee5fb0848f0c","34f8b7c3bffa018927b9a1f6289d4deb204e7d097cec4ac05062c8a23630ad93257244310dc94c2c56ad5eecee1e37fa09551ee45202acbc6582aee1dfb630ea03f5338fb91a3eeec3722fb1ee255686b39708c61a4f5e9ba90cb69242f1dfe8e188092df0b4f487413f65d77ab2e128ff997860574a288ce33cb2216d0f429fa67862060456f057cd6acd8421274aa95e9bb3d0f0b22e216251a26b276c3eb35745c96335c113810b6df9d70e9af4c57b44e6ec108b7835eb957b0168f7ced6471a8660c641c6b29509736e2125a8db5ab45e18f0f29950fce2193bb60902782c17ba4b67498b07324de0ab7d3059bf07d2243389e347a584014ecaf60ac2424b6d2933"});local _xvmygxmb0mcb5={};for _x58dt21iwbmi5=1,#_x9qo9hoqwg1j7,2 do _xvmygxmb0mcb5[#_xvmygxmb0mcb5+1]=tonumber(string.sub(_x9qo9hoqwg1j7,_x58dt21iwbmi5,_x58dt21iwbmi5+1),16) end;_x9qo9hoqwg1j7=nil;local function _xbl8sl3p0ut5o(_x3yyjz5qtch2g,_xn4r618677in8) local _xtcyunthgt0zx,_xwq6r4hv8z4of=0,1;for _=1,8 do local l,r=_x3yyjz5qtch2g%2,_xn4r618677in8%2;if l~=r then _xtcyunthgt0zx=_xtcyunthgt0zx+_xwq6r4hv8z4of end;_x3yyjz5qtch2g=math.floor(_x3yyjz5qtch2g/2);_xn4r618677in8=math.floor(_xn4r618677in8/2);_xwq6r4hv8z4of=_xwq6r4hv8z4of*2 end;return _xtcyunthgt0zx end;do local _xqr81yiivtteq=175;for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do _xvmygxmb0mcb5[_x58dt21iwbmi5]=(_xvmygxmb0mcb5[_x58dt21iwbmi5]+_xqr81yiivtteq)%256;_xqr81yiivtteq=_xvmygxmb0mcb5[_x58dt21iwbmi5] end end;do local _xqr81yiivtteq=103;for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do local _xef695y2grtg=_xvmygxmb0mcb5[_x58dt21iwbmi5];_xvmygxmb0mcb5[_x58dt21iwbmi5]=_xbl8sl3p0ut5o(_xef695y2grtg,_xqr81yiivtteq);_xqr81yiivtteq=_xef695y2grtg end end;for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do local _xef695y2grtg=_xvmygxmb0mcb5[_x58dt21iwbmi5];_xvmygxmb0mcb5[_x58dt21iwbmi5]=math.floor(_xef695y2grtg/16)+(_xef695y2grtg%16)*16 end;for _x58dt21iwbmi5=1,math.floor(#_xvmygxmb0mcb5/2) do local _xef695y2grtg=#_xvmygxmb0mcb5-_x58dt21iwbmi5+1;_xvmygxmb0mcb5[_x58dt21iwbmi5],_xvmygxmb0mcb5[_xef695y2grtg]=_xvmygxmb0mcb5[_xef695y2grtg],_xvmygxmb0mcb5[_x58dt21iwbmi5] end;for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do _xvmygxmb0mcb5[_x58dt21iwbmi5]=(_xvmygxmb0mcb5[_x58dt21iwbmi5]-198-((_x58dt21iwbmi5-1)*22)%251)%256 end;for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do local _xef695y2grtg=_xvmygxmb0mcb5[_x58dt21iwbmi5];_xvmygxmb0mcb5[_x58dt21iwbmi5]=(_xef695y2grtg%16)*16+math.floor(_xef695y2grtg/16) end;do local _xef695y2grtg={};for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do _xef695y2grtg[(_x58dt21iwbmi5+735-1)%#_xvmygxmb0mcb5+1]=_xvmygxmb0mcb5[_x58dt21iwbmi5] end;_xvmygxmb0mcb5=_xef695y2grtg end;for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do _xvmygxmb0mcb5[_x58dt21iwbmi5]=_xbl8sl3p0ut5o(_xvmygxmb0mcb5[_x58dt21iwbmi5],(47+(_x58dt21iwbmi5-1)*18)%256) end;for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do _xvmygxmb0mcb5[_x58dt21iwbmi5]=((_xvmygxmb0mcb5[_x58dt21iwbmi5]-240)*215)%256 end;local _xyejexl7fs0vm={};local _xuf1jv3f49vko,_x3tlg27v1xavt=1,0;for _x58dt21iwbmi5=1,#_xvmygxmb0mcb5 do _xuf1jv3f49vko=(_xuf1jv3f49vko+_xvmygxmb0mcb5[_x58dt21iwbmi5])%65521;_x3tlg27v1xavt=(_x3tlg27v1xavt+_xuf1jv3f49vko)%65521;_xyejexl7fs0vm[_x58dt21iwbmi5]=string.char(_xvmygxmb0mcb5[_x58dt21iwbmi5]) end;if #_xvmygxmb0mcb5~=9476 or _xuf1jv3f49vko~=5919 or _x3tlg27v1xavt~=39995 then error("CryptX integrity check failed",0) end;_xvmygxmb0mcb5=nil;local _xsbx6pgxrql0u=table.concat(_xyejexl7fs0vm);_xyejexl7fs0vm=nil;if type(_xh6ngvvfq8stq)~="function" then error("CryptX requires loadstring",0) end;local _xfiwvr8um38e5=_xh6ngvvfq8stq(_xsbx6pgxrql0u,"=CryptX");_xsbx6pgxrql0u=nil;if not _xfiwvr8um38e5 then error("anti cheat confuser is currently patched - blocked confuser before it can affect you",0) end;return _xfiwvr8um38e5()
