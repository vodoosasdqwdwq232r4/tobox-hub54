-- =================================================================
-- TOBOX AIM + ВХ [ULTIMATE CYBERPUNK + GORILLA EASTER EGG]
-- Authors: Nazik & Jura
-- =================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local PlayerGui = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("ToboxHub") then PlayerGui.ToboxHub:Destroy() end
pcall(function() 
    RunService:UnbindFromRenderStep("ToboxLoop") 
    RunService:UnbindFromRenderStep("ToboxFly")
end)

local Features = {
    Platform = "PC",
    LockMenu = false,
    RGB_Menu = false,
    RGB_FOV = false,
    Aimbot = false, AimAssist = true, InstantLock = true, AimbotFOV = 150, TeamCheck = false, AimTarget = "Head",
    ESP_Box = false, ESP_BoxColor = Color3.fromRGB(170, 0, 255),
    ESP_FOVColor = Color3.fromRGB(170, 0, 255), ESP_Tracers = false, ESP_Names = false,
    SpeedHack = false, SpeedValue = 50, 
    JumpHack = false, JumpValue = 120, 
    Fly = false, FlySpeed = 50,
    Noclip = false, InfJump = false
}

local Keybinds = {
    ToggleMenu = Enum.KeyCode.Insert,
    AimbotKey = Enum.KeyCode.E,
    ESPKey = Enum.KeyCode.R,
    FlyKey = Enum.KeyCode.F
}

local ColorPalette = {
    Color3.fromRGB(170, 0, 255), Color3.fromRGB(255, 0, 128), Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(255, 220, 0), Color3.fromRGB(255, 130, 0), Color3.fromRGB(138, 43, 228),
    Color3.fromRGB(255, 105, 180), Color3.fromRGB(0, 230, 230), Color3.fromRGB(255, 255, 255), Color3.fromRGB(15, 15, 20)
}

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ToboxHub"
ScreenGui.ResetOnSpawn = false

local function ApplyModernStyle(inst, bg, str, radius)
    inst.BackgroundColor3 = bg or Color3.fromRGB(20, 18, 28)
    inst.BorderSizePixel = 0
    local corner = inst:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", inst)
    corner.CornerRadius = UDim.new(0, radius or 8)
    local stroke = inst:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", inst)
    stroke.Color = str or Color3.fromRGB(90, 30, 150)
    stroke.Thickness = 1.5
    return stroke
end

--------------------------------------------------------------------
-- 1. ВІКНО ВИБОРУ ПЛАТФОРМИ
--------------------------------------------------------------------
local ModeFrame = Instance.new("Frame", ScreenGui)
ModeFrame.Size, ModeFrame.Position = UDim2.new(0, 380, 0, 200), UDim2.new(0.5, -190, 0.5, -100)
ModeFrame.ZIndex = 100
ApplyModernStyle(ModeFrame, Color3.fromRGB(25, 22, 35), Color3.fromRGB(150, 0, 255), 12)

local ModeTitle = Instance.new("TextLabel", ModeFrame)
ModeTitle.Size, ModeTitle.Position = UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 10)
ModeTitle.Text = "ОБЕРІТЬ ПРИСТРІЙ / DEVICE"
ModeTitle.TextColor3 = Color3.fromRGB(200, 100, 255)
ModeTitle.Font = Enum.Font.SourceSansBold
ModeTitle.TextSize = 18
ModeTitle.BackgroundTransparency = 1
ModeTitle.ZIndex = 101

local PcBtn = Instance.new("TextButton", ModeFrame)
PcBtn.Size, PcBtn.Position = UDim2.new(0, 160, 0, 80), UDim2.new(0, 20, 0, 75)
PcBtn.Text = "💻 ПК (PC)"
PcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PcBtn.Font = Enum.Font.SourceSansBold
PcBtn.TextSize = 18
PcBtn.ZIndex = 101
ApplyModernStyle(PcBtn, Color3.fromRGB(40, 35, 55), Color3.fromRGB(150, 0, 255), 8)

local MobileBtn = Instance.new("TextButton", ModeFrame)
MobileBtn.Size, MobileBtn.Position = UDim2.new(0, 160, 0, 80), UDim2.new(1, -180, 0, 75)
MobileBtn.Text = "📱 ТЕЛЕФОН"
MobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileBtn.Font = Enum.Font.SourceSansBold
MobileBtn.TextSize = 18
MobileBtn.ZIndex = 101
ApplyModernStyle(MobileBtn, Color3.fromRGB(40, 35, 55), Color3.fromRGB(150, 0, 255), 8)

--------------------------------------------------------------------
-- 2. ГОЛОВНЕ МЕНЮ
--------------------------------------------------------------------
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 680, 0, 500), UDim2.new(0.5, -340, 0.5, -250)
Main.Active, Main.Draggable, Main.Visible = true, true, false
local MainStroke = ApplyModernStyle(Main, Color3.fromRGB(18, 16, 26), Color3.fromRGB(100, 35, 170), 12)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
local HeaderStroke = ApplyModernStyle(Header, Color3.fromRGB(14, 12, 20), Color3.fromRGB(80, 25, 140), 12)

local Title = Instance.new("TextLabel", Header)
Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(1, -50, 1, 0), UDim2.new(0, 15, 0, 0), 1
Title.Text, Title.TextColor3, Title.TextSize, Title.Font = "Tobox aim + вх", Color3.fromRGB(200, 100, 255), 18, Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 35, 0, 30), UDim2.new(1, -42, 0, 5)
CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize = "-", Color3.fromRGB(220, 220, 220), 22
ApplyModernStyle(CloseBtn, Color3.fromRGB(35, 28, 50), Color3.fromRGB(120, 40, 190), 6)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

local OpenToggle = Instance.new("TextButton", ScreenGui)
OpenToggle.Size, OpenToggle.Position = UDim2.new(0, 90, 0, 40), UDim2.new(0, 10, 0.4, 0)
OpenToggle.Text, OpenToggle.TextColor3, OpenToggle.TextSize = "Tobox UI", Color3.fromRGB(255, 255, 255), 15
OpenToggle.Active, OpenToggle.Draggable, OpenToggle.Visible = true, true, false
ApplyModernStyle(OpenToggle, Color3.fromRGB(140, 0, 255), Color3.fromRGB(190, 60, 255), 8)
OpenToggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if Keybinds.ToggleMenu and input.KeyCode == Keybinds.ToggleMenu then
        Main.Visible = not Main.Visible
    end
end)

local function InitScript(mode)
    Features.Platform = mode
    ModeFrame:Destroy()
    Main.Visible = true
    OpenToggle.Visible = true
end

PcBtn.MouseButton1Click:Connect(function() InitScript("PC") end)
MobileBtn.MouseButton1Click:Connect(function() InitScript("Mobile") end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size, Sidebar.Position = UDim2.new(0, 150, 1, -40), UDim2.new(0, 0, 0, 40)
ApplyModernStyle(Sidebar, Color3.fromRGB(16, 14, 23), Color3.fromRGB(70, 25, 120), 10)

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.SortOrder = Enum.SortOrder.LayoutOrder

local ContentHolder = Instance.new("Frame", Main)
ContentHolder.Size, ContentHolder.Position = UDim2.new(1, -150, 1, -40), UDim2.new(0, 150, 0, 40)
ContentHolder.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name, iconText)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Text = "  " .. iconText .. " " .. name
    btn.TextColor3, btn.TextSize, btn.Font = Color3.fromRGB(180, 170, 200), 14, Enum.Font.SourceSansBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    ApplyModernStyle(btn, Color3.fromRGB(16, 14, 23), Color3.fromRGB(50, 18, 90), 6)

    local page = Instance.new("ScrollingFrame", ContentHolder)
    page.Size, page.Position, page.Visible = UDim2.new(1, -20, 1, -20), UDim2.new(0, 10, 0, 10), false
    page.BackgroundTransparency, page.ScrollBarThickness = 1, 5
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)

    Tabs[name] = {Btn = btn, Page = page}

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.BackgroundColor3 = Color3.fromRGB(16, 14, 23)
            t.Btn.TextColor3 = Color3.fromRGB(180, 170, 200)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(130, 0, 240)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return page
end

local AimPage = CreateTab("Аімбот", "🎯")
local EspPage = CreateTab("ВХ / ESP", "👁️")
local CharPage = CreateTab("Персонаж", "🏃")
local KeyPage = CreateTab("Клавіші", "⌨️")
local SettPage = CreateTab("Налаштування", "⚙️")

Tabs["Аімбот"].Page.Visible = true
Tabs["Аімбот"].Btn.BackgroundColor3 = Color3.fromRGB(130, 0, 240)
Tabs["Аімбот"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

--------------------------------------------------------------------
-- КОМПОНЕНТИ ІНТЕРФЕЙСУ
--------------------------------------------------------------------
local function AddToggle(page, name, key)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Font, btn.TextSize = Enum.Font.SourceSansBold, 15
    
    local function update()
        if Features[key] then
            btn.Text = "[ УВІМКНЕНО ] " .. name
            ApplyModernStyle(btn, Color3.fromRGB(140, 0, 255), Color3.fromRGB(200, 90, 255), 8)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = "[ ВИМКНЕНО ] " .. name
            ApplyModernStyle(btn, Color3.fromRGB(30, 26, 42), Color3.fromRGB(70, 45, 105), 8)
            btn.TextColor3 = Color3.fromRGB(170, 160, 190)
        end
    end
    btn.MouseButton1Click:Connect(function() Features[key] = not Features[key] update() end)
    update()
end

local function AddSlider(page, name, key, minVal, maxVal)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, 0, 0, 50)
    ApplyModernStyle(card, Color3.fromRGB(26, 22, 38), Color3.fromRGB(75, 35, 120), 8)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(1, -10, 0, 22), UDim2.new(0, 10, 0, 2), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = name .. ": " .. tostring(Features[key]), Color3.fromRGB(240, 230, 255), Enum.Font.SourceSansBold, 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", card)
    sliderBg.Size, sliderBg.Position = UDim2.new(1, -20, 0, 12), UDim2.new(0, 10, 0, 28)
    ApplyModernStyle(sliderBg, Color3.fromRGB(14, 12, 20), Color3.fromRGB(55, 25, 90), 6)

    local fill = Instance.new("Frame", sliderBg)
    local pct = (Features[key] - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    ApplyModernStyle(fill, Color3.fromRGB(150, 0, 255), Color3.fromRGB(200, 90, 255), 6)

    local dragging = false
    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
        local alpha = posX / sliderBg.AbsoluteSize.X
        local val = math.floor(minVal + (maxVal - minVal) * alpha)
        Features[key] = val
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        lbl.Text = name .. ": " .. tostring(val)
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

local function AddDropdown(page, name, key, opts)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, 0, 0, 42)
    ApplyModernStyle(card, Color3.fromRGB(26, 22, 38), Color3.fromRGB(75, 35, 120), 8)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = name, Color3.fromRGB(240, 230, 255), Enum.Font.SourceSansBold, 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size, btn.Position = UDim2.new(0.45, 0, 0.8, 0), UDim2.new(0.52, 0, 0.1, 0)
    btn.Text, btn.TextColor3, btn.Font, btn.TextSize = tostring(Features[key]), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
    ApplyModernStyle(btn, Color3.fromRGB(140, 0, 255), Color3.fromRGB(200, 90, 255), 6)

    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx % #opts + 1
        Features[key] = opts[idx]
        btn.Text = tostring(Features[key])
    end)
end

local function AddColorPicker(page, name, key)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, 0, 0, 42)
    ApplyModernStyle(card, Color3.fromRGB(26, 22, 38), Color3.fromRGB(75, 35, 120), 8)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = name, Color3.fromRGB(240, 230, 255), Enum.Font.SourceSansBold, 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local colorPreview = Instance.new("TextButton", card)
    colorPreview.Size, colorPreview.Position = UDim2.new(0, 30, 0, 28), UDim2.new(1, -38, 0, 7)
    colorPreview.Text = ""
    ApplyModernStyle(colorPreview, Features[key], Color3.fromRGB(255, 255, 255), 6)

    local pickerFrame = Instance.new("Frame", ScreenGui)
    pickerFrame.Size, pickerFrame.Position, pickerFrame.Visible = UDim2.new(0, 170, 0, 75), UDim2.new(0.5, -85, 0.5, -37), false
    pickerFrame.ZIndex = 50
    ApplyModernStyle(pickerFrame, Color3.fromRGB(16, 14, 24), Color3.fromRGB(150, 0, 255), 10)

    local grid = Instance.new("UIGridLayout", pickerFrame)
    grid.CellSize, grid.CellPadding = UDim2.new(0, 28, 0, 28), UDim2.new(0, 4, 0, 4)

    for _, color in ipairs(ColorPalette) do
        local sq = Instance.new("TextButton", pickerFrame)
        sq.Text, sq.ZIndex = "", 51
        ApplyModernStyle(sq, color, Color3.fromRGB(0, 0, 0), 4)
        sq.MouseButton1Click:Connect(function()
            Features[key] = color
            colorPreview.BackgroundColor3 = color
            pickerFrame.Visible = false
        end)
    end

    colorPreview.MouseButton1Click:Connect(function()
        pickerFrame.Visible = not pickerFrame.Visible
    end)
end

local function AddKeybind(page, name, keyName)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, 0, 0, 42)
    ApplyModernStyle(card, Color3.fromRGB(26, 22, 38), Color3.fromRGB(75, 35, 120), 8)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = name, Color3.fromRGB(240, 230, 255), Enum.Font.SourceSansBold, 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size, btn.Position = UDim2.new(0.35, 0, 0.8, 0), UDim2.new(0.42, 0, 0.1, 0)
    btn.Text = Keybinds[keyName] and tostring(Keybinds[keyName].Name) or "None"
    btn.TextColor3, btn.Font, btn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
    ApplyModernStyle(btn, Color3.fromRGB(140, 0, 255), Color3.fromRGB(200, 90, 255), 6)

    local clearBtn = Instance.new("TextButton", card)
    clearBtn.Size, clearBtn.Position = UDim2.new(0, 35, 0.8, 0), UDim2.new(0.8, -5, 0.1, 0)
    clearBtn.Text, clearBtn.TextColor3, clearBtn.Font, clearBtn.TextSize = "X", Color3.fromRGB(255, 100, 100), Enum.Font.SourceSansBold, 14
    ApplyModernStyle(clearBtn, Color3.fromRGB(50, 20, 50), Color3.fromRGB(180, 50, 50), 6)

    clearBtn.MouseButton1Click:Connect(function()
        Keybinds[keyName] = nil
        btn.Text = "None"
    end)

    local binding = false
    btn.MouseButton1Click:Connect(function()
        btn.Text = "..."
        binding = true
    end)

    UserInputService.InputBegan:Connect(function(input)
        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
            Keybinds[keyName] = input.KeyCode
            btn.Text = tostring(input.KeyCode.Name)
            binding = false
        end
    end)
end

--------------------------------------------------------------------
-- 3. НАПОВНЕННЯ ВКЛАДОК
--------------------------------------------------------------------
AddToggle(AimPage, "Аімбот Увімкнути", "Aimbot")
AddToggle(AimPage, "Аім Асист (Sticky Lock)", "AimAssist")
AddDropdown(AimPage, "Ціль Наведення", "AimTarget", {"Head", "HumanoidRootPart"})
AddToggle(AimPage, "Team Check", "TeamCheck")
AddSlider(AimPage, "Радіус FOV", "AimbotFOV", 30, 400)

AddToggle(EspPage, "ESP Бокси", "ESP_Box")
AddToggle(EspPage, "ESP Лінії (Tracers)", "ESP_Tracers")
AddToggle(EspPage, "ESP Нікнейми", "ESP_Names")
AddColorPicker(EspPage, "Колір Боксів", "ESP_BoxColor")
AddColorPicker(EspPage, "Колір Кола FOV", "ESP_FOVColor")
AddToggle(EspPage, "RGB Колір FOV", "RGB_FOV")

AddToggle(CharPage, "SpeedHack", "SpeedHack")
AddSlider(CharPage, "Значення Швидкості", "SpeedValue", 16, 300)

AddToggle(CharPage, "Super Jump", "JumpHack")
AddSlider(CharPage, "Висота Стрибка", "JumpValue", 50, 400)

AddToggle(CharPage, "Fly (Політ)", "Fly")
AddSlider(CharPage, "Швидкість Польоту", "FlySpeed", 20, 250)

AddToggle(CharPage, "NoClip", "Noclip")
AddToggle(CharPage, "Inf Jump", "InfJump")

AddKeybind(KeyPage, "Відкриття Меню", "ToggleMenu")
AddKeybind(KeyPage, "Гаряча клавіша Aim", "AimbotKey")
AddKeybind(KeyPage, "Гаряча клавіша ESP", "ESPKey")
AddKeybind(KeyPage, "Гаряча клавіша Fly", "FlyKey")

AddToggle(SettPage, "RGB Підсвітка Меню", "RGB_Menu")

local ToggleLock = Instance.new("TextButton", SettPage)
ToggleLock.Size = UDim2.new(1, 0, 0, 42)
ToggleLock.Font, ToggleLock.TextSize = Enum.Font.SourceSansBold, 15

local function updateLockBtn()
    if Features.LockMenu then
        ToggleLock.Text = "[ БЛОКУВАННЯ МЕНЮ: УВІМКНЕНО ]"
        Main.Draggable = false
        ApplyModernStyle(ToggleLock, Color3.fromRGB(150, 0, 255), Color3.fromRGB(200, 90, 255), 8)
    else
        ToggleLock.Text = "[ БЛОКУВАННЯ МЕНЮ: ВИМКНЕНО ]"
        Main.Draggable = true
        ApplyModernStyle(ToggleLock, Color3.fromRGB(30, 26, 42), Color3.fromRGB(70, 45, 105), 8)
    end
end
ToggleLock.MouseButton1Click:Connect(function()
    Features.LockMenu = not Features.LockMenu
    updateLockBtn()
end)
updateLockBtn()

local KillBtn = Instance.new("TextButton", SettPage)
KillBtn.Size = UDim2.new(1, 0, 0, 45)
KillBtn.Text = "🛑 ВИМКНУТИ СКРИПТ (KILL SWITCH)"
KillBtn.TextColor3, KillBtn.Font, KillBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 15
ApplyModernStyle(KillBtn, Color3.fromRGB(180, 30, 70), Color3.fromRGB(230, 60, 110), 8)
KillBtn.MouseButton1Click:Connect(function()
    pcall(function() 
        RunService:UnbindFromRenderStep("ToboxLoop")
        RunService:UnbindFromRenderStep("ToboxFly") 
    end)
    ScreenGui:Destroy()
end)

--------------------------------------------------------------------
-- 4. ЕПІЧНИЙ ПРИКОЛ З ГОРИЛОЮ ТА ФАКСТОМ (EASTER EGG)
--------------------------------------------------------------------
local AuthorLabel = Instance.new("TextButton", Main)
AuthorLabel.Size, AuthorLabel.Position = UDim2.new(0, 180, 0, 25), UDim2.new(1, -185, 1, -25)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Text = "Autor by nazik and jura"
AuthorLabel.Font, AuthorLabel.TextSize = Enum.Font.SourceSansBold, 16
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Right

local GorillaFrame = Instance.new("Frame", ScreenGui)
GorillaFrame.Size, GorillaFrame.Position = UDim2.new(0, 400, 0, 450), UDim2.new(0.5, -200, 0.5, -225)
GorillaFrame.Visible, GorillaFrame.ZIndex = false, 200
ApplyModernStyle(GorillaFrame, Color3.fromRGB(15, 15, 20), Color3.fromRGB(255, 0, 0), 12)

local GorillaImg = Instance.new("ImageLabel", GorillaFrame)
GorillaImg.Size, GorillaImg.Position = UDim2.new(1, -20, 1, -60), UDim2.new(0, 10, 0, 45)
GorillaImg.BackgroundTransparency = 1
-- Автоматично підтягує твою картинку `gorilla.png`, яку ти завантажиш у репозиторій GitHub!
pcall(function()
    local repoBase = game:HttpGet("https://raw.githubusercontent.com/vodoosasdqwdwq232r4/tobox-hub/refs/heads/main/script.lua") -- автоматичне визначення посилання
    -- або пряме посилання на твою картинку у трієчці сховища:
end)
GorillaImg.Image = "https://raw.githubusercontent.com/vodoosasdqwdwq232r4/tobox-hub/refs/heads/main/gorilla.png"
GorillaImg.ScaleType = Enum.ScaleType.Fit
GorillaImg.ZIndex = 201

local GorillaClose = Instance.new("TextButton", GorillaFrame)
GorillaClose.Size, GorillaClose.Position = UDim2.new(0, 40, 0, 35), UDim2.new(1, -45, 0, 5)
GorillaClose.Text, GorillaClose.TextColor3, GorillaClose.TextSize, GorillaClose.ZIndex = "✕", Color3.fromRGB(255, 255, 255), 20, 202
ApplyModernStyle(GorillaClose, Color3.fromRGB(180, 30, 30), Color3.fromRGB(255, 50, 50), 6)

GorillaClose.MouseButton1Click:Connect(function()
    GorillaFrame.Visible = false
end)

AuthorLabel.MouseButton1Click:Connect(function()
    GorillaFrame.Visible = true
end)

task.spawn(function()
    local hue = 0
    while task.wait(0.03) do
        hue = (hue + 0.01) % 1
        local rgbColor = Color3.fromHSV(hue, 0.9, 1)
        AuthorLabel.TextColor3 = rgbColor
        if Features.RGB_Menu then
            MainStroke.Color = rgbColor
            HeaderStroke.Color = rgbColor
        end
    end
end)

--------------------------------------------------------------------
-- 5. ЛОГІКА СКРИПТА
--------------------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.Filled, FOVCircle.Visible = 1.5, false, false

local ESP_Store = {}
local bodyVelocity, bodyGyro

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if Features.Fly and root then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity", root)
            bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bodyGyro = Instance.new("BodyGyro", root)
            bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        end
        bodyGyro.CFrame = Camera.CFrame
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
        bodyVelocity.Velocity = moveDir * Features.FlySpeed
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    end
end)

RunService:BindToRenderStep("ToboxLoop", Enum.RenderPriority.Camera.Value + 1, function()
    local mPos = UserInputService:GetMouseLocation()
    FOVCircle.Position, FOVCircle.Radius, FOVCircle.Visible = mPos, Features.AimbotFOV, Features.Aimbot
    
    if Features.RGB_FOV then
        FOVCircle.Color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
    else
        FOVCircle.Color = Features.ESP_FOVColor
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESP_Store[p] then
                ESP_Store[p] = {Box = Drawing.new("Square"), Tracer = Drawing.new("Line"), Name = Drawing.new("Text")}
                ESP_Store[p].Box.Thickness, ESP_Store[p].Name.Size, ESP_Store[p].Name.Center = 1.5, 14, true
            end
            local e, ch = ESP_Store[p], p.Character
            local hum, root, head = ch and ch:FindFirstChildOfClass("Humanoid"), ch and ch:FindFirstChild("HumanoidRootPart"), ch and ch:FindFirstChild("Head")
            local valid = ch and root and head and hum and hum.Health > 0 and not (Features.TeamCheck and p.Team == LocalPlayer.Team)

            if valid then
                local v, onS = Camera:WorldToViewportPoint(root.Position)
                local hV, lV = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)), Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                if onS then
                    local h = math.abs(hV.Y - lV.Y) local w = h / 1.8
                    e.Box.Visible, e.Box.Size, e.Box.Position, e.Box.Color = Features.ESP_Box, Vector2.new(w, h), Vector2.new(v.X - w/2, hV.Y), Features.ESP_BoxColor
                    e.Tracer.Visible, e.Tracer.From, e.Tracer.To, e.Tracer.Color = Features.ESP_Tracers, Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), Vector2.new(v.X, lV.Y), Features.ESP_BoxColor
                    e.Name.Visible, e.Name.Text, e.Name.Position = Features.ESP_Names, p.Name, Vector2.new(v.X, hV.Y - 16)
                else e.Box.Visible, e.Tracer.Visible, e.Name.Visible = false, false, false end
            else if e.Box then e.Box.Visible, e.Tracer.Visible, e.Name.Visible = false, false, false end end
        end
    end

    local isPressed = (Features.Platform == "PC") and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or true

    if Features.Aimbot and isPressed then
        local target, minD = nil, Features.AimbotFOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local targetPart = p.Character:FindFirstChild(Features.AimTarget) or p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if targetPart and hum and hum.Health > 0 and not (Features.TeamCheck and p.Team == LocalPlayer.Team) then
                    local pos, onS = Camera:WorldToViewportPoint(targetPart.Position)
                    if onS then
                        local d = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                        if d < minD then minD = d target = targetPart end
                    end
                end
            end
        end
        if target then 
            if Features.AimAssist then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            else
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.25)
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character and Features.Noclip then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if Features.SpeedHack then hum.WalkSpeed = Features.SpeedValue end
        if Features.JumpHack then hum.UseJumpPower = true hum.JumpPower = Features.JumpValue end
    end
end)

UserInputService.JumpRequest:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if Features.InfJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)