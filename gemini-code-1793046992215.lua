-- =================================================================
-- NEROHOLE TACTICAL HUB [PC VERSION: CENTER FOV + AUTO AIM]
-- Authors: Nazik & Jura
-- =================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local PlayerGui = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("NeroHoleTacticalHub") then PlayerGui.NeroHoleTacticalHub:Destroy() end
pcall(function() 
    RunService:UnbindFromRenderStep("NeroHoleLoop") 
end)

local CurrentLanguage = "UA"
local IsDarkMode = true

local Translations = {
    UA = {
        Combat = "Бій",
        Visuals = "Візуали",
        CharTab = "Персонаж",
        Keys = "Клавіші",
        Configs = "Конфіги",
        Service = "Сервіс",
        Radar = "Радар",
        CameraFOV = "FOV Камери (Майнкрафт)",
        LockMenu = "Закріпити Меню",
        StreamProof = "Захист від Демонстрації (StreamProof)",
        Aimbot = "Аімбот (Авто Lock)",
        AutoFire = "Автострільба (Auto Fire)",
        TeamCheck = "Team Check",
        VisibleCheck = "Visible Check",
        FOVRadius = "Радіус FOV",
        HeadChance = "Шанс на Голову (%)",
        BodyChance = "Шанс на Тіло (%)",
        Nicknames = "Індикатор HP",
        Boxes = "Бокси ESP",
        HPBar = "Смужка Здоров'я (HP Bar)",
        Skeleton = "Скелет",
        Lines = "Лінії (Tracers)",
        Distance = "Дистанція (м)",
        RGB_FOV = "RGB Колір FOV",
        RGB_Menu = "Фулл Меню RGB (Full RGB)",
        RGB_ESP = "RGB Підсвітка ESP",
        SpeedHack = "SpeedHack",
        SpeedVal = "Швидкість",
        SuperJump = "Super Jump",
        JumpVal = "Висота Стрибка",
        Noclip = "Noclip",
        InfJump = "Inf Jump",
        KeyToggle = "Відкриття Меню",
        KeyAim = "Гаряча клавіша Aim",
        KeyESP = "Гаряча клавіша ESP",
        SaveCfg = "Зберегти конфіг",
        LoadCfg = "Завантажити конфіг",
        KillSwitch = "🛑 ВИМКНУТИ СКРИПТ"
    }
}

local Features = {
    Aimbot = false, AutoFire = false, TeamCheck = true, VisibleCheck = true,
    AimbotFOV = 250, HeadChance = 80, BodyChance = 20,
    RGB_Menu = false, RGB_FOV = false, RGB_ESP = false,
    ESP_Box = false, ESP_HPBar = true, ESP_Skeleton = false, ESP_Names = true, ESP_Tracers = false, ESP_Distance = true,
    ESP_BoxColor = Color3.fromRGB(255, 50, 80),
    ESP_VisibleColor = Color3.fromRGB(255, 50, 50),
    ESP_HiddenColor = Color3.fromRGB(255, 200, 0),
    Radar_Enabled = false, Radar_Size = 130, Radar_MaxDist = 1000, Radar_Unlocked = false,
    CameraFOVVal = 70, CameraFOVEnabled = false, LockMenu = false, StreamProof = false,
    SpeedHack = false, SpeedValue = 50,
    JumpHack = false, JumpValue = 120,
    Noclip = false, InfJump = false,
    UIScale = 13, UIThemeColor = Color3.fromRGB(255, 50, 80)
}

local Keybinds = {
    ToggleMenu = Enum.KeyCode.Insert,
    AimbotKey = nil,
    ESPKey = nil
}

local DefaultFOV = Camera.FieldOfView

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "NeroHoleTacticalHub"
ScreenGui.ResetOnSpawn = false

local function ApplyTacticalStyle(inst, bg, str, radius)
    inst.BackgroundColor3 = bg or (IsDarkMode and Color3.fromRGB(16, 15, 23) or Color3.fromRGB(240, 240, 246))
    inst.BorderSizePixel = 0
    local corner = inst:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", inst)
    corner.CornerRadius = UDim.new(0, radius or 10)
    local stroke = inst:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", inst)
    stroke.Color = str or (IsDarkMode and Color3.fromRGB(45, 40, 65) or Color3.fromRGB(200, 200, 215))
    stroke.Thickness = 1.2
    return stroke
end

-- РАДАР
local RadarFrame = Instance.new("Frame", ScreenGui)
RadarFrame.Size = UDim2.new(0, 130, 0, 130)
RadarFrame.Position = UDim2.new(0.5, -65, 0, 40)
RadarFrame.Visible = false
RadarFrame.Active = true
RadarFrame.Draggable = false
ApplyTacticalStyle(RadarFrame, Color3.fromRGB(15, 14, 22), Color3.fromRGB(0, 255, 120), 65)

local RadarCenter = Instance.new("Frame", RadarFrame)
RadarCenter.Size = UDim2.new(0, 8, 0, 8)
RadarCenter.Position = UDim2.new(0.5, -4, 0.5, -4)
ApplyTacticalStyle(RadarCenter, Color3.fromRGB(0, 255, 120), Color3.fromRGB(255, 255, 255), 4)

local RadarDotsContainer = Instance.new("Folder", RadarFrame)
RadarDotsContainer.Name = "Dots"

local OpenToggle = Instance.new("TextButton", ScreenGui)
OpenToggle.Size, OpenToggle.Position = UDim2.new(0, 110, 0, 36), UDim2.new(0, 15, 0.4, 0)
OpenToggle.Text, OpenToggle.TextColor3, OpenToggle.TextSize = "⚡ NEROHOLE", Color3.fromRGB(255, 255, 255), 13
OpenToggle.Font = Enum.Font.SourceSansBold
OpenToggle.Active, OpenToggle.Draggable = true, true
local OpenStroke = ApplyTacticalStyle(OpenToggle, Color3.fromRGB(20, 18, 28), Color3.fromRGB(0, 255, 120), 8)

local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 760, 0, 490), UDim2.new(0.5, -380, 0.5, -245)
Main.Active, Main.Draggable, Main.Visible = true, true, true
local MainStroke = ApplyTacticalStyle(Main, Color3.fromRGB(14, 13, 20), Color3.fromRGB(55, 45, 75), 12)

local HeaderBar = Instance.new("Frame", Main)
HeaderBar.Size, HeaderBar.Position = UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 8)
ApplyTacticalStyle(HeaderBar, Color3.fromRGB(20, 18, 28), Color3.fromRGB(45, 40, 65), 8)

local TitleHeader = Instance.new("TextLabel", HeaderBar)
TitleHeader.Size, TitleHeader.Position, TitleHeader.BackgroundTransparency = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 12, 0, 0), 1
TitleHeader.Text = "⚡ NEROHOLE Hub (PC)"
TitleHeader.TextColor3, TitleHeader.Font, TitleHeader.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
TitleHeader.TextXAlignment = Enum.TextXAlignment.Left

local ControlBtnsFrame = Instance.new("Frame", HeaderBar)
ControlBtnsFrame.Size, ControlBtnsFrame.Position = UDim2.new(0, 70, 0, 24), UDim2.new(1, -75, 0.5, -12)
ControlBtnsFrame.BackgroundTransparency = 1

local MinimizeBtn = Instance.new("TextButton", ControlBtnsFrame)
MinimizeBtn.Size, MinimizeBtn.Position = UDim2.new(0, 30, 1, 0), UDim2.new(0, 0, 0, 0)
MinimizeBtn.Text, MinimizeBtn.TextColor3, MinimizeBtn.TextSize = "—", Color3.fromRGB(220, 220, 220), 14
MinimizeBtn.Font = Enum.Font.SourceSansBold
ApplyTacticalStyle(MinimizeBtn, Color3.fromRGB(32, 28, 45), Color3.fromRGB(60, 50, 85), 6)

local CloseBtn = Instance.new("TextButton", ControlBtnsFrame)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 30, 1, 0), UDim2.new(1, -30, 0, 0)
CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize = "✕", Color3.fromRGB(255, 90, 90), 13
CloseBtn.Font = Enum.Font.SourceSansBold
ApplyTacticalStyle(CloseBtn, Color3.fromRGB(45, 20, 30), Color3.fromRGB(180, 40, 60), 6)

MinimizeBtn.MouseButton1Click:Connect(function() Main.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() RunService:UnbindFromRenderStep("NeroHoleLoop") end)
    Camera.FieldOfView = DefaultFOV
    ScreenGui:Destroy()
end)

OpenToggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp then
        if Keybinds.ToggleMenu and input.KeyCode == Keybinds.ToggleMenu then Main.Visible = not Main.Visible end
        if Keybinds.AimbotKey and input.KeyCode == Keybinds.AimbotKey then Features.Aimbot = not Features.Aimbot end
        if Keybinds.ESPKey and input.KeyCode == Keybinds.ESPKey then 
            Features.ESP_Box = not Features.ESP_Box 
            Features.ESP_Skeleton = not Features.ESP_Skeleton 
        end
    end
end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size, Sidebar.Position = UDim2.new(0, 190, 1, -60), UDim2.new(0, 10, 0, 50)
ApplyTacticalStyle(Sidebar, Color3.fromRGB(18, 16, 26), Color3.fromRGB(40, 35, 60), 10)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Content = Instance.new("Frame", Main)
Content.Size, Content.Position = UDim2.new(1, -215, 1, -60), UDim2.new(0, 210, 0, 50)
Content.BackgroundTransparency = 1

local Pages = {}
local function CreatePage()
    local p = Instance.new("ScrollingFrame", Content)
    p.Size, p.Position, p.Visible, p.BackgroundTransparency = UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), false, 1
    p.ScrollBarThickness = 4
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return p
end

local pagesData = {
    Combat = CreatePage(),
    Visuals = CreatePage(),
    CharTab = CreatePage(),
    Keys = CreatePage(),
    Configs = CreatePage(),
    Service = CreatePage()
}

local navButtons = {}
local function AddNavButton(nameKey, icon)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Text = "   " .. icon .. "  " .. Translations[CurrentLanguage][nameKey]
    btn.TextColor3, btn.Font, btn.TextSize = Color3.fromRGB(180, 175, 200), Enum.Font.SourceSansBold, 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    ApplyTacticalStyle(btn, Color3.fromRGB(24, 21, 34), Color3.fromRGB(50, 42, 70), 8)

    btn.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        pagesData[nameKey].Visible = true
    end)
    Pages[nameKey] = pagesData[nameKey]
    table.insert(navButtons, {Btn = btn, Key = nameKey})
end

AddNavButton("Combat", "⚔️")
AddNavButton("Visuals", "👁️")
AddNavButton("CharTab", "🏃")
AddNavButton("Keys", "⌨️")
AddNavButton("Configs", "📁")
AddNavButton("Service", "⚙️")

pagesData["Combat"].Visible = true

local BottomBar = Instance.new("Frame", Sidebar)
BottomBar.Size, BottomBar.Position = UDim2.new(1, -10, 0, 40), UDim2.new(0, 5, 1, -45)
ApplyTacticalStyle(BottomBar, Color3.fromRGB(14, 13, 20), Color3.fromRGB(40, 35, 60), 8)

local ThemeToggle = Instance.new("TextButton", BottomBar)
ThemeToggle.Size, ThemeToggle.Position = UDim2.new(0.45, 0, 1, 0), UDim2.new(0, 0, 0, 0)
ThemeToggle.Text = "🌙"
ThemeToggle.TextColor3, ThemeToggle.TextSize = Color3.fromRGB(255, 255, 255), 15
ApplyTacticalStyle(ThemeToggle, Color3.fromRGB(30, 26, 42), Color3.fromRGB(60, 50, 85), 6)

local LangToggle = Instance.new("TextButton", BottomBar)
LangToggle.Size, LangToggle.Position = UDim2.new(0.5, 0, 1, 0), UDim2.new(0.5, 5, 0, 0)
LangToggle.Text = "🇺🇦 UA"
LangToggle.TextColor3, LangToggle.Font, LangToggle.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 12
ApplyTacticalStyle(LangToggle, Color3.fromRGB(30, 26, 42), Color3.fromRGB(60, 50, 85), 6)

local SystemListText

local function UpdateSystemList()
    if not SystemListText then return end
    local spStatus = Features.StreamProof and "Увімкнено" or "Вимкнено"
    local rgbStatus = Features.RGB_Menu and "Увімкнено" or "Вимкнено"
    local radarStatus = Features.Radar_Enabled and "Увімкнено" or "Вимкнено"
    local aimStatus = Features.Aimbot and "Авто-Аім (Вкл)" or "Вимкнено"
    
    SystemListText.Text = string.format(
        "• Статус: NEROHOLE Активний\n• Аімбот: %s\n• Захист екрану: %s\n• RGB Меню: %s\n• Радар: %s",
        aimStatus, spStatus, rgbStatus, radarStatus
    )
end

local function AddToggle(page, textKey, key)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, -10, 0, 42)
    ApplyTacticalStyle(card, Color3.fromRGB(22, 20, 32), Color3.fromRGB(48, 42, 68), 8)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 12, 0, 0), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = Translations[CurrentLanguage][textKey] or textKey, Color3.fromRGB(230, 225, 245), Enum.Font.SourceSansBold, Features.UIScale
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local tog = Instance.new("TextButton", card)
    tog.Size, tog.Position = UDim2.new(0, 42, 0, 22), UDim2.new(1, -52, 0.5, -11)
    tog.Text = ""
    ApplyTacticalStyle(tog, Features[key] and Features.UIThemeColor or Color3.fromRGB(40, 35, 55), Color3.fromRGB(75, 65, 100), 11)

    tog.MouseButton1Click:Connect(function()
        Features[key] = not Features[key]
        ApplyTacticalStyle(tog, Features[key] and Features.UIThemeColor or Color3.fromRGB(40, 35, 55), Color3.fromRGB(75, 65, 100), 11)
        
        if key == "Radar_Enabled" then
            RadarFrame.Visible = Features[key]
        elseif key == "Radar_Unlocked" then
            RadarFrame.Draggable = Features[key]
        elseif key == "LockMenu" then
            Main.Draggable = not Features[key]
        elseif key == "StreamProof" then
            pcall(function()
                ScreenGui.DisplayOrder = Features[key] and 999999 or 1
            end)
        elseif key == "CameraFOVEnabled" then
            if not Features[key] then
                Camera.FieldOfView = DefaultFOV
            end
        end
        
        UpdateSystemList()
    end)
end

local function AddSlider(page, nameKey, key, minVal, maxVal)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, -10, 0, 50)
    ApplyTacticalStyle(card, Color3.fromRGB(22, 20, 32), Color3.fromRGB(48, 42, 68), 8)

    local realName = Translations[CurrentLanguage][nameKey] or nameKey
    local lbl = Instance.new("TextLabel", card)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(1, -10, 0, 22), UDim2.new(0, 12, 0, 2), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = realName .. ": " .. tostring(Features[key]), Color3.fromRGB(230, 225, 245), Enum.Font.SourceSansBold, Features.UIScale
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", card)
    sliderBg.Size, sliderBg.Position = UDim2.new(1, -24, 0, 10), UDim2.new(0, 12, 0, 30)
    ApplyTacticalStyle(sliderBg, Color3.fromRGB(14, 13, 20), Color3.fromRGB(40, 35, 55), 5)

    local fill = Instance.new("Frame", sliderBg)
    local pct = math.clamp((Features[key] - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    ApplyTacticalStyle(fill, Features.UIThemeColor, Color3.fromRGB(100, 255, 150), 5)

    local dragging = false
    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
        local alpha = posX / sliderBg.AbsoluteSize.X
        local val = math.floor(minVal + (maxVal - minVal) * alpha)
        Features[key] = val
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        lbl.Text = realName .. ": " .. tostring(val)
        if key == "Radar_Size" then
            RadarFrame.Size = UDim2.new(0, val, 0, val)
        end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function AddKeybind(page, textKey, keyName)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, -10, 0, 42)
    ApplyTacticalStyle(card, Color3.fromRGB(22, 20, 32), Color3.fromRGB(48, 42, 68), 8)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 12, 0, 0), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = Translations[CurrentLanguage][textKey] or textKey, Color3.fromRGB(230, 225, 245), Enum.Font.SourceSansBold, 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size, btn.Position = UDim2.new(0.28, 0, 0.8, 0), UDim2.new(0.42, 0, 0.1, 0)
    btn.Text = Keybinds[keyName] and tostring(Keybinds[keyName].Name) or "None"
    btn.TextColor3, btn.Font, btn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 12
    ApplyTacticalStyle(btn, Color3.fromRGB(40, 35, 55), Color3.fromRGB(75, 65, 100), 6)

    local resetBtn = Instance.new("TextButton", card)
    resetBtn.Size, resetBtn.Position = UDim2.new(0, 34, 0.8, 0), UDim2.new(0.72, 6, 0.1, 0)
    resetBtn.Text = "✕"
    resetBtn.TextColor3, resetBtn.Font, resetBtn.TextSize = Color3.fromRGB(255, 90, 90), Enum.Font.SourceSansBold, 13
    ApplyTacticalStyle(resetBtn, Color3.fromRGB(45, 20, 30), Color3.fromRGB(180, 40, 60), 6)

    local binding = false
    btn.MouseButton1Click:Connect(function() btn.Text = "..." binding = true end)
    resetBtn.MouseButton1Click:Connect(function() binding = false Keybinds[keyName] = nil btn.Text = "None" end)

    UserInputService.InputBegan:Connect(function(input)
        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
            Keybinds[keyName] = input.KeyCode
            btn.Text = tostring(input.KeyCode.Name)
            binding = false
        end
    end)
end

-- Вкладка Бій
AddToggle(pagesData["Combat"], "Aimbot", "Aimbot")
AddToggle(pagesData["Combat"], "AutoFire", "AutoFire")
AddSlider(pagesData["Combat"], "FOVRadius", "AimbotFOV", 30, 1500)
AddSlider(pagesData["Combat"], "HeadChance", "HeadChance", 0, 100)
AddSlider(pagesData["Combat"], "BodyChance", "BodyChance", 0, 100)
AddToggle(pagesData["Combat"], "TeamCheck", "TeamCheck")
AddToggle(pagesData["Combat"], "VisibleCheck", "VisibleCheck")
AddToggle(pagesData["Combat"], "RGB_FOV", "RGB_FOV")

-- Вкладка Візуали
AddToggle(pagesData["Visuals"], "Nicknames", "ESP_Names")
AddToggle(pagesData["Visuals"], "Boxes", "ESP_Box")
AddToggle(pagesData["Visuals"], "HPBar", "ESP_HPBar")
AddToggle(pagesData["Visuals"], "Distance", "ESP_Distance")
AddToggle(pagesData["Visuals"], "Skeleton", "ESP_Skeleton")
AddToggle(pagesData["Visuals"], "Lines", "ESP_Tracers")
AddToggle(pagesData["Visuals"], "RGB_ESP", "RGB_ESP")

-- Радар
AddToggle(pagesData["Visuals"], "Radar", "Radar_Enabled")
AddSlider(pagesData["Visuals"], "Розмір Радару", "Radar_Size", 80, 250)
AddSlider(pagesData["Visuals"], "Дистанція Радару (м)", "Radar_MaxDist", 500, 3000)
AddToggle(pagesData["Visuals"], "Переміщення Радару", "Radar_Unlocked")

-- Вкладка Персонаж
AddToggle(pagesData["CharTab"], "SpeedHack", "SpeedHack")
AddSlider(pagesData["CharTab"], "SpeedVal", "SpeedValue", 16, 200)
AddToggle(pagesData["CharTab"], "SuperJump", "JumpHack")
AddSlider(pagesData["CharTab"], "JumpVal", "JumpValue", 50, 300)
AddToggle(pagesData["CharTab"], "Noclip", "Noclip")
AddToggle(pagesData["CharTab"], "InfJump", "InfJump")
AddToggle(pagesData["CharTab"], "CameraFOV", "CameraFOVEnabled")
AddSlider(pagesData["CharTab"], "Ширина Камери (FOV)", "CameraFOVVal", 30, 140)

AddKeybind(pagesData["Keys"], "KeyToggle", "ToggleMenu")
AddKeybind(pagesData["Keys"], "KeyAim", "AimbotKey")
AddKeybind(pagesData["Keys"], "KeyESP", "ESPKey")

-- Вкладка Сервіс
AddToggle(pagesData["Service"], "LockMenu", "LockMenu")
AddToggle(pagesData["Service"], "StreamProof", "StreamProof")
AddToggle(pagesData["Service"], "RGB_Menu", "RGB_Menu")

-- СПИСОК АКТИВНИХ СИСТЕМ
local SystemListCard = Instance.new("Frame", pagesData["Service"])
SystemListCard.Size = UDim2.new(1, -10, 0, 120)
ApplyTacticalStyle(SystemListCard, Color3.fromRGB(22, 20, 32), Color3.fromRGB(48, 42, 68), 8)

local SystemListTitle = Instance.new("TextLabel", SystemListCard)
SystemListTitle.Size, SystemListTitle.Position, SystemListTitle.BackgroundTransparency = UDim2.new(1, -20, 0, 24), UDim2.new(0, 12, 0, 4), 1
SystemListTitle.Text = "📋 Список Активних Систем:"
SystemListTitle.TextColor3, SystemListTitle.Font, SystemListTitle.TextSize = Color3.fromRGB(0, 255, 120), Enum.Font.SourceSansBold, 13
SystemListTitle.TextXAlignment = Enum.TextXAlignment.Left

SystemListText = Instance.new("TextLabel", SystemListCard)
SystemListText.Size, SystemListText.Position, SystemListText.BackgroundTransparency = UDim2.new(1, -20, 1, -30), UDim2.new(0, 12, 0, 26), 1
SystemListText.TextColor3, SystemListText.Font, SystemListText.TextSize = Color3.fromRGB(200, 195, 220), Enum.Font.SourceSans, 12
SystemListText.TextXAlignment = Enum.TextXAlignment.Left
SystemListText.TextYAlignment = Enum.TextYAlignment.Top

UpdateSystemList()

local SaveCfgBtn = Instance.new("TextButton", pagesData["Configs"])
SaveCfgBtn.Size = UDim2.new(1, -10, 0, 42)
SaveCfgBtn.Text = "💾 Зберегти конфіг"
SaveCfgBtn.TextColor3, SaveCfgBtn.Font, SaveCfgBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
ApplyTacticalStyle(SaveCfgBtn, Color3.fromRGB(0, 160, 80), Color3.fromRGB(0, 220, 110), 8)

local LoadCfgBtn = Instance.new("TextButton", pagesData["Configs"])
LoadCfgBtn.Size = UDim2.new(1, -10, 0, 42)
LoadCfgBtn.Text = "📂 Завантажити конфіг"
LoadCfgBtn.TextColor3, LoadCfgBtn.Font, LoadCfgBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
ApplyTacticalStyle(LoadCfgBtn, Color3.fromRGB(0, 120, 200), Color3.fromRGB(50, 160, 255), 8)

local KillBtn = Instance.new("TextButton", pagesData["Service"])
KillBtn.Size = UDim2.new(1, -10, 0, 42)
KillBtn.Text = "🛑 ВИМКНУТИ СКРИПТ (KILL SWITCH)"
KillBtn.TextColor3, KillBtn.Font, KillBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
ApplyTacticalStyle(KillBtn, Color3.fromRGB(180, 30, 50), Color3.fromRGB(255, 60, 80), 8)
KillBtn.MouseButton1Click:Connect(function()
    pcall(function() RunService:UnbindFromRenderStep("NeroHoleLoop") end)
    Camera.FieldOfView = DefaultFOV
    ScreenGui:Destroy()
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.Filled, FOVCircle.Visible = 1.5, false, false

local ESP_Store = {}
local RadarDots = {}

local function CreateSkeleton()
    local lines = {}
    local joints = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
    }
    for _, j in ipairs(joints) do
        local line = Drawing.new("Line")
        line.Thickness, line.Visible = 1.5, false
        table.insert(lines, {Line = line, A = j[1], B = j[2]})
    end
    return lines
end

local function IsVisible(targetPart)
    if not Features.VisibleCheck then return true end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return true end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {char, targetPart.Parent}
    local result = workspace:Raycast(head.Position, targetPart.Position - head.Position, raycastParams)
    return result == nil
end

local function IsValidTarget(p)
    if p == LocalPlayer then return false end
    local ch = p.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if Features.TeamCheck and LocalPlayer.Team and p.Team and LocalPlayer.Team == p.Team then
        return false
    end
    return true
end

-- ПОШУК ЦІЛІ БІЛЯ ЦЕНТРУ ЕКРАНА (БЕЗ ПОТРЕБИ НАТИСКАТИ ПКМ)
local function GetClosestTarget()
    local target, minD = nil, Features.AimbotFOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, p in pairs(Players:GetPlayers()) do
        if IsValidTarget(p) and p.Character then
            local headPart = p.Character:FindFirstChild("Head")
            local bodyPart = p.Character:FindFirstChild("HumanoidRootPart")
            local chosenTargetPart = nil
            local totalChance = Features.HeadChance + Features.BodyChance
            if totalChance <= 0 then totalChance = 100 end
            local rnd = math.random(1, totalChance)
            if rnd <= Features.HeadChance then
                chosenTargetPart = headPart or bodyPart
            else
                chosenTargetPart = bodyPart or headPart
            end
            if chosenTargetPart and IsVisible(chosenTargetPart) then
                local pos, onS = Camera:WorldToViewportPoint(chosenTargetPart.Position)
                if onS then
                    local d = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if d < minD then minD = d target = chosenTargetPart end
                end
            end
        end
    end
    return target
end

task.spawn(function()
    local hue = 0
    while task.wait(0.03) do
        hue = (hue + 0.01) % 1
        local rgbCol = Color3.fromHSV(hue, 1, 1)
        OpenStroke.Color = rgbCol
        
        if Features.RGB_Menu then
            MainStroke.Color = rgbCol
        else
            MainStroke.Color = Color3.fromRGB(55, 45, 75)
        end
        
        if Features.RGB_FOV then
            FOVCircle.Color = rgbCol
        end
    end
end)

RunService:BindToRenderStep("NeroHoleLoop", Enum.RenderPriority.Camera.Value + 1, function()
    -- FOV коло чітко по центру екрана
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Features.AimbotFOV
    FOVCircle.Visible = Features.Aimbot

    if not Features.RGB_FOV then FOVCircle.Color = Features.ESP_BoxColor end

    local currentEspColor = Features.ESP_BoxColor
    if Features.RGB_ESP then
        currentEspColor = Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end

    -- АІМБОТ ПРАЦЮЄ АВТОМАТИЧНО ЩОЙНО УВІМКНЕНО (БЕЗ ПКМ)
    if Features.Aimbot then
        local target = GetClosestTarget()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.75)
            if Features.AutoFire then
                pcall(function()
                    VirtualUser:Button1Down(Vector2.new(0,0))
                    task.wait(0.05)
                    VirtualUser:Button1Up(Vector2.new(0,0))
                end)
            end
        end
    end

    if Features.CameraFOVEnabled then
        Camera.FieldOfView = Features.CameraFOVVal
    end

    -- Радар
    if Features.Radar_Enabled then
        for _, dot in pairs(RadarDots) do dot.Visible = false end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        
        if myRoot then
            local count = 1
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and IsValidTarget(p) and p.Character then
                    local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    if pRoot then
                        local dist = (pRoot.Position - myRoot.Position).Magnitude
                        if dist <= Features.Radar_MaxDist then
                            local dot = RadarDots[count]
                            if not dot then
                                dot = Instance.new("Frame", RadarDotsContainer)
                                dot.Size = UDim2.new(0, 6, 0, 6)
                                ApplyTacticalStyle(dot, Color3.fromRGB(255, 40, 40), Color3.fromRGB(255, 255, 255), 3)
                                RadarDots[count] = dot
                            end
                            
                            local relPos = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)):PointToObjectSpace(pRoot.Position)
                            local radarSize = RadarFrame.AbsoluteSize.X
                            local scale = (radarSize / 2) / Features.Radar_MaxDist
                            
                            local x = (radarSize / 2) + (relPos.X * scale)
                            local y = (radarSize / 2) + (-relPos.Z * scale)
                            
                            if x > 4 and x < radarSize - 4 and y > 4 and y < radarSize - 4 then
                                dot.Visible = true
                                dot.Position = UDim2.new(0, x - 3, 0, y - 3)
                            else
                                dot.Visible = false
                            end
                            count = count + 1
                        end
                    end
                end
            end
        end
    else
        for _, dot in pairs(RadarDots) do dot.Visible = false end
    end

    for p, e in pairs(ESP_Store) do
        if not p or not p.Parent then
            if e.Box then e.Box:Remove() end
            if e.HPBarBg then e.HPBarBg:Remove() end
            if e.HPBarFill then e.HPBarFill:Remove() end
            if e.NameBg then e.NameBg:Remove() end
            if e.NameText then e.NameText:Remove() end
            if e.Distance then e.Distance:Remove() end
            if e.Tracer then e.Tracer:Remove() end
            if e.Skeleton then for _, sk in ipairs(e.Skeleton) do sk.Line:Remove() end end
            ESP_Store[p] = nil
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESP_Store[p] then
                ESP_Store[p] = {
                    Box = Drawing.new("Square"),
                    HPBarBg = Drawing.new("Square"),
                    HPBarFill = Drawing.new("Square"),
                    NameBg = Drawing.new("Square"),
                    NameText = Drawing.new("Text"),
                    Distance = Drawing.new("Text"),
                    Tracer = Drawing.new("Line"),
                    Skeleton = CreateSkeleton()
                }
                ESP_Store[p].Box.Thickness = 1.5
                ESP_Store[p].HPBarBg.Filled, ESP_Store[p].HPBarFill.Filled = true, true
                ESP_Store[p].HPBarBg.Color = Color3.fromRGB(20, 20, 20)
                ESP_Store[p].NameBg.Filled = true
                ESP_Store[p].NameBg.Color = Color3.fromRGB(0, 0, 0)
                ESP_Store[p].NameText.Size, ESP_Store[p].NameText.Center = 13, true
                ESP_Store[p].NameText.Color = Color3.fromRGB(255, 255, 255)
                ESP_Store[p].Distance.Size, ESP_Store[p].Distance.Center = 12, true
            end

            local e, ch = ESP_Store[p], p.Character
            local root = ch and ch:FindFirstChild("HumanoidRootPart")
            local head = ch and ch:FindFirstChild("Head")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            local valid = root and head and hum and hum.Health > 0

            if valid then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                local headV = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legV = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                local boxColor = currentEspColor
                if not Features.RGB_ESP then
                    local isVis = IsVisible(head)
                    boxColor = isVis and Features.ESP_VisibleColor or Features.ESP_HiddenColor
                end

                if onScreen then
                    local baseH = math.abs(headV.Y - legV.Y)
                    local h = baseH * 1.2
                    local w = (baseH / 2) * 1.2

                    e.Box.Visible = Features.ESP_Box
                    e.Box.Size = Vector2.new(w, h)
                    e.Box.Position = Vector2.new(pos.X - w/2, headV.Y)
                    e.Box.Color = boxColor

                    if Features.ESP_Box and Features.ESP_HPBar then
                        local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        e.HPBarBg.Visible = true
                        e.HPBarBg.Size = Vector2.new(3, h)
                        e.HPBarBg.Position = Vector2.new(pos.X - w/2 - 6, headV.Y)

                        e.HPBarFill.Visible = true
                        e.HPBarFill.Size = Vector2.new(3, h * hpPct)
                        e.HPBarFill.Position = Vector2.new(pos.X - w/2 - 6, headV.Y + (h * (1 - hpPct)))
                        e.HPBarFill.Color = Color3.fromRGB(0, 255, 100)
                    else
                        e.HPBarBg.Visible, e.HPBarFill.Visible = false, false
                    end

                    if Features.ESP_Names then
                        local hpVal = math.floor(hum.Health)
                        e.NameText.Visible = true
                        e.NameText.Text = hpVal .. "hp"
                        e.NameText.Position = Vector2.new(pos.X, headV.Y - 18)

                        e.NameBg.Visible = true
                        e.NameBg.Size = Vector2.new(36, 16)
                        e.NameBg.Position = Vector2.new(pos.X - 18, headV.Y - 20)
                    else
                        e.NameText.Visible = false
                        e.NameBg.Visible = false
                    end

                    if Features.ESP_Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                        e.Distance.Visible = true
                        e.Distance.Text = "[" .. dist .. "m]"
                        e.Distance.Position = Vector2.new(pos.X, legV.Y + 4)
                        e.Distance.Color = Color3.fromRGB(200, 200, 200)
                    else
                        e.Distance.Visible = false
                    end

                    e.Tracer.Visible = Features.ESP_Tracers
                    e.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    e.Tracer.To = Vector2.new(pos.X, legV.Y)
                    e.Tracer.Color = boxColor

                    if Features.ESP_Skeleton then
                        for _, sk in ipairs(e.Skeleton) do
                            local pA = ch:FindFirstChild(sk.A)
                            local pB = ch:FindFirstChild(sk.B)
                            if pA and pB then
                                local vA, sA = Camera:WorldToViewportPoint(pA.Position)
                                local vB, sB = Camera:WorldToViewportPoint(pB.Position)
                                if sA and sB then
                                    sk.Line.Visible = true
                                    sk.Line.From = Vector2.new(vA.X, vA.Y)
                                    sk.Line.To = Vector2.new(vB.X, vB.Y)
                                    sk.Line.Color = boxColor
                                else
                                    sk.Line.Visible = false
                                end
                            else
                                sk.Line.Visible = false
                            end
                        end
                    else
                        for _, sk in ipairs(e.Skeleton) do sk.Line.Visible = false end
                    end
                else
                    e.Box.Visible, e.HPBarBg.Visible, e.HPBarFill.Visible, e.NameBg.Visible, e.NameText.Visible, e.Distance.Visible, e.Tracer.Visible = false, false, false, false, false, false, false
                    for _, sk in ipairs(e.Skeleton) do sk.Line.Visible = false end
                end
            else
                e.Box.Visible, e.HPBarBg.Visible, e.HPBarFill.Visible, e.NameBg.Visible, e.NameText.Visible, e.Distance.Visible, e.Tracer.Visible = false, false, false, false, false, false, false
                for _, sk in ipairs(e.Skeleton) do sk.Line.Visible = false end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if Features.SpeedHack then hum.WalkSpeed = Features.SpeedValue end
            if Features.JumpHack then hum.UseJumpPower = true hum.JumpPower = Features.JumpValue end
        end
        if Features.Noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if Features.InfJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
