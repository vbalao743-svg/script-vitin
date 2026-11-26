--[[
    VITIN MENU 2.0 MAX
    Interface Lua para uso em um LocalScript no Roblox Studio.
    Também tenta usar gethui() quando disponível em ambientes de teste.

    IMPORTANTE:
    - Os interruptores e botões são controles visuais demonstrativos.
    - O painel de status só lê leaderstats/Attributes expostos ao cliente.
    - Não executa auto-farm, ataques, teleporte ou alterações no Blox Fruits.
    - Para mostrar a arte do anime, envie a imagem recortada ao Roblox e
      cole o ID em ANIME_IMAGE_ID abaixo.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then
    warn("Vitin Menu 2.0: execute como script do cliente.")
    return
end

-- Cole aqui o ID da imagem depois de enviá-la aos Decals/Imagens do Roblox.
local ANIME_IMAGE_ID = "rbxassetid://130138821388871"

local function getGuiParent()
    if typeof(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local playerGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
    return playerGui
end

local guiParent = getGuiParent()
local old = guiParent:FindFirstChild("VitinMenu20MAX")
if old then old:Destroy() end

local C = {
    black = Color3.fromRGB(5, 5, 12),
    panel = Color3.fromRGB(12, 10, 23),
    panel2 = Color3.fromRGB(22, 15, 39),
    row = Color3.fromRGB(27, 23, 43),
    purple = Color3.fromRGB(157, 35, 255),
    purple2 = Color3.fromRGB(95, 25, 190),
    pink = Color3.fromRGB(255, 42, 190),
    blue = Color3.fromRGB(33, 145, 255),
    white = Color3.fromRGB(247, 242, 255),
    muted = Color3.fromRGB(181, 169, 203),
    green = Color3.fromRGB(38, 225, 90),
    yellow = Color3.fromRGB(255, 218, 45),
    red = Color3.fromRGB(255, 60, 80),
}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, obj)
end

local function outline(obj, color, thickness, transparency)
    return make("UIStroke", {
        Color = color or C.purple,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, obj)
end

local function gradient(obj, colors, rotation)
    local points = {}
    for i, color in ipairs(colors) do
        points[#points + 1] = ColorSequenceKeypoint.new((i - 1) / (#colors - 1), color)
    end
    return make("UIGradient", {Color = ColorSequence.new(points), Rotation = rotation or 0}, obj)
end

local function tw(obj, duration, props, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local gui = make("ScreenGui", {
    Name = "VitinMenu20MAX",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, guiParent)

-- Botão flutuante V (celular e acesso rápido)
local floating = make("TextButton", {
    Name = "VitinOpenButton",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -22, 1, -24),
    Size = UDim2.fromOffset(54, 54),
    BackgroundColor3 = C.purple,
    Text = "V",
    TextColor3 = C.white,
    TextSize = 25,
    Font = Enum.Font.GothamBlack,
    AutoButtonColor = false,
    Visible = UserInputService.TouchEnabled,
    ZIndex = 100,
}, gui)
round(floating, 18)
gradient(floating, {C.pink, C.purple, C.blue}, 25)
outline(floating, Color3.fromRGB(255, 210, 255), 1.5, 0.12)

-- Janela principal
local main = make("Frame", {
    Name = "MainWindow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.84, 0.78),
    BackgroundColor3 = C.black,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
    ZIndex = 2,
}, gui)
round(main, 17)
outline(main, C.pink, 2, 0.05)
make("UISizeConstraint", {MinSize = Vector2.new(760, 500), MaxSize = Vector2.new(1450, 900)}, main)

local outerGlow = make("Frame", {
    Name = "NeonTopLine",
    Size = UDim2.new(1, 0, 0, 4),
    BackgroundColor3 = C.pink,
    BorderSizePixel = 0,
    ZIndex = 20,
}, main)
gradient(outerGlow, {C.pink, C.purple, C.blue, C.pink}, 0)

-- Cabeçalho largo inspirado na referência
local header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0.235, 0),
    BackgroundColor3 = Color3.fromRGB(13, 5, 27),
    BorderSizePixel = 0,
    ZIndex = 3,
}, main)
gradient(header, {Color3.fromRGB(8, 5, 18), Color3.fromRGB(30, 8, 53), Color3.fromRGB(9, 8, 25)}, 0)

-- Fumaca roxa neon: nuvens em camadas com movimento continuo e suave.
-- Os elementos ficam atras dos textos e da arte do anime.
local smokeLayer = make("Frame", {
    Name = "PurpleSmokeLayer",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 4,
}, header)

local smokeSpecs = {
    {x = 0.43, y = 0.73, w = 0.15, h = 0.30, dx = 0.045, dy = -0.10, duration = 4.8, delay = 0.0},
    {x = 0.57, y = 0.82, w = 0.18, h = 0.34, dx = -0.035, dy = -0.12, duration = 5.7, delay = 0.6},
    {x = 0.70, y = 0.73, w = 0.16, h = 0.32, dx = 0.035, dy = -0.09, duration = 5.2, delay = 1.1},
    {x = 0.84, y = 0.68, w = 0.20, h = 0.38, dx = -0.045, dy = -0.11, duration = 6.1, delay = 0.3},
    {x = 0.94, y = 0.83, w = 0.13, h = 0.28, dx = -0.030, dy = -0.08, duration = 4.6, delay = 1.4},
    {x = 0.34, y = 0.88, w = 0.13, h = 0.25, dx = 0.035, dy = -0.08, duration = 5.5, delay = 0.9},
}

for i, spec in ipairs(smokeSpecs) do
    local puff = make("Frame", {
        Name = "PurpleSmokePuff" .. i,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(spec.x, spec.y),
        Size = UDim2.fromScale(spec.w, spec.h),
        BackgroundColor3 = Color3.fromRGB(157, 55, 255),
        BackgroundTransparency = 0.60,
        BorderSizePixel = 0,
        ZIndex = 4,
    }, smokeLayer)
    round(puff, 999)
    local puffGradient = make("UIGradient", {
        Rotation = 35 + i * 13,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(83, 20, 173)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 105, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 35, 220)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.18),
            NumberSequenceKeypoint.new(0.5, 0.48),
            NumberSequenceKeypoint.new(1, 0.12),
        }),
    }, puff)

    task.delay(spec.delay, function()
        if not puff.Parent then return end
        local drift = TweenInfo.new(
            spec.duration,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        )
        TweenService:Create(puff, drift, {
            Position = UDim2.fromScale(spec.x + spec.dx, spec.y + spec.dy),
            Size = UDim2.fromScale(spec.w * 1.22, spec.h * 1.16),
            BackgroundTransparency = 0.76,
        }):Play()
        TweenService:Create(puffGradient, TweenInfo.new(
            spec.duration * 1.35,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Rotation = puffGradient.Rotation + 95}):Play()
    end)
end

local crown = make("TextLabel", {
    Position = UDim2.new(0.018, 0, 0.10, 0),
    Size = UDim2.new(0.08, 0, 0.70, 0),
    BackgroundTransparency = 1,
    Text = "♛",
    TextColor3 = C.pink,
    TextSize = 58,
    Font = Enum.Font.GothamBlack,
    ZIndex = 5,
}, header)

local title = make("TextLabel", {
    Position = UDim2.new(0.105, 0, 0.12, 0),
    Size = UDim2.new(0.42, 0, 0.48, 0),
    BackgroundTransparency = 1,
    Text = "VITIN MENU 2.0",
    TextColor3 = C.white,
    TextSize = 38,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, header)
gradient(title, {C.white, C.pink, C.purple, C.blue}, 0)

local subtitle = make("TextLabel", {
    Position = UDim2.new(0.29, 0, 0.59, 0),
    Size = UDim2.new(0.23, 0, 0.23, 0),
    BackgroundTransparency = 1,
    Text = "Blox Fruits  •  MAX EDITION",
    TextColor3 = C.white,
    TextSize = 15,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 5,
}, header)

local quote = make("TextLabel", {
    Position = UDim2.new(0.53, 0, 0.16, 0),
    Size = UDim2.new(0.22, 0, 0.65, 0),
    BackgroundTransparency = 1,
    Text = "\"SONHE ALTO, SEJA FORTE\nE NUNCA DESISTA.\"\n— VITIN",
    TextColor3 = Color3.fromRGB(238, 218, 255),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 5,
}, header)

local art = make("ImageLabel", {
    Name = "AnimeArtwork",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -5, 0, 3),
    Size = UDim2.new(0.29, 0, 1.35, 0),
    BackgroundTransparency = 1,
    Image = ANIME_IMAGE_ID,
    ImageTransparency = ANIME_IMAGE_ID == "" and 1 or 0.04,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 4,
}, header)

local artFallback = make("Frame", {
    Name = "AnimeGlowFallback",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.new(0.30, 0, 1, 0),
    BackgroundColor3 = C.purple2,
    BackgroundTransparency = ANIME_IMAGE_ID == "" and 0.25 or 1,
    BorderSizePixel = 0,
    ZIndex = 3,
}, header)
gradient(artFallback, {Color3.fromRGB(20, 5, 40), C.purple, C.pink}, 20)

local close = make("TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -12, 0, 12),
    Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = Color3.fromRGB(30, 10, 46),
    Text = "×",
    TextColor3 = C.white,
    TextSize = 30,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 10,
}, header)
round(close, 12)
outline(close, C.pink, 1.5, 0.1)

-- Linha neon que separa cabeçalho e conteúdo
local separator = make("Frame", {
    Position = UDim2.new(0, 0, 0.235, -2),
    Size = UDim2.new(1, 0, 0, 3),
    BackgroundColor3 = C.purple,
    BorderSizePixel = 0,
    ZIndex = 8,
}, main)
gradient(separator, {C.pink, C.purple, C.blue, C.pink}, 0)

-- Corpo da janela
local body = make("Frame", {
    Name = "Body",
    Position = UDim2.new(0, 0, 0.235, 0),
    Size = UDim2.new(1, 0, 0.765, 0),
    BackgroundTransparency = 1,
    ZIndex = 3,
}, main)

-- Sidebar
local sidebar = make("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0.185, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(7, 7, 14),
    BorderSizePixel = 0,
    ZIndex = 4,
}, body)
outline(sidebar, C.purple, 1, 0.55)
local sideTitle = make("TextLabel", {
    Position = UDim2.new(0.08, 0, 0.025, 0),
    Size = UDim2.new(0.84, 0, 0.065, 0),
    BackgroundTransparency = 1,
    Text = "✦  NAVEGAÇÃO",
    TextColor3 = C.muted,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, sidebar)

local sideList = make("Frame", {
    Position = UDim2.new(0.055, 0, 0.105, 0),
    Size = UDim2.new(0.89, 0, 0.70, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
}, sidebar)
make("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, sideList)

local navItems = {
    {"Principal", "⌂"}, {"Farm", "♟"}, {"Combate", "⚔"}, {"Frutas", "●"},
    {"Visual", "◉"}, {"Teleporte", "➤"}, {"Misc", "☷"}, {"Configurações", "⚙"},
}
local navButtons = {}
local selectedTab = "Principal"

local discord = make("TextButton", {
    Position = UDim2.new(0.055, 0, 0.83, 0),
    Size = UDim2.new(0.89, 0, 0.085, 0),
    BackgroundColor3 = Color3.fromRGB(34, 20, 64),
    Text = "◉  DISCORD\n     comunidade Vitin",
    TextColor3 = C.white,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextWrapped = true,
    AutoButtonColor = false,
    ZIndex = 6,
}, sidebar)
round(discord, 9)
outline(discord, C.purple, 1, 0.4)

local sideFooter = make("TextLabel", {
    Position = UDim2.new(0.06, 0, 0.925, 0),
    Size = UDim2.new(0.88, 0, 0.055, 0),
    BackgroundTransparency = 1,
    Text = "♛  Vitin Menu 2.0  •  MAX",
    TextColor3 = C.muted,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, sidebar)

-- Área central com os cartões em duas colunas
local center = make("Frame", {
    Name = "CenterArea",
    Position = UDim2.new(0.185, 0, 0, 0),
    Size = UDim2.new(0.535, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 4,
}, body)

local centerHeading = make("TextLabel", {
    Position = UDim2.new(0.025, 0, 0.015, 0),
    Size = UDim2.new(0.95, 0, 0.055, 0),
    BackgroundTransparency = 1,
    Text = "✦  PAINEL PRINCIPAL",
    TextColor3 = C.white,
    TextSize = 15,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, center)

local grid = make("Frame", {
    Name = "CardsGrid",
    Position = UDim2.new(0.02, 0, 0.085, 0),
    Size = UDim2.new(0.96, 0, 0.88, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
}, center)

local leftColumn = make("Frame", {
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0.495, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
}, grid)
local rightColumn = make("Frame", {
    Position = UDim2.new(0.505, 0, 0, 0),
    Size = UDim2.new(0.495, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
}, grid)

local function makeCard(parent, titleText, position, size, symbol)
    local card = make("Frame", {
        Position = position,
        Size = size,
        BackgroundColor3 = C.panel,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, parent)
    round(card, 11)
    outline(card, C.purple, 1, 0.38)
    local cap = make("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(45, 15, 75),
        BorderSizePixel = 0,
        ZIndex = 7,
    }, card)
    round(cap, 10)
    gradient(cap, {Color3.fromRGB(54, 20, 95), Color3.fromRGB(24, 13, 47), Color3.fromRGB(48, 14, 74)}, 0)
    make("TextLabel", {
        Position = UDim2.new(0, 11, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = (symbol or "✦") .. "  " .. titleText,
        TextColor3 = Color3.fromRGB(224, 185, 255),
        TextSize = 11,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8,
    }, cap)
    local inner = make("Frame", {
        Position = UDim2.new(0, 8, 0, 39),
        Size = UDim2.new(1, -16, 1, -46),
        BackgroundTransparency = 1,
        ZIndex = 7,
    }, card)
    return card, inner
end

local switchControllers = {}

local function makeSwitch(parent, labelText, order, stateTable, callback)
    local row = make("Frame", {
        Position = UDim2.new(0, 0, 0, (order - 1) * 27),
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        ZIndex = 8,
    }, parent)
    local label = make("TextLabel", {
        Position = UDim2.new(0, 3, 0, 0),
        Size = UDim2.new(1, -63, 1, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = C.white,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9,
    }, row)
    local switch = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -2, 0.5, 0),
        Size = UDim2.fromOffset(40, 21),
        BackgroundColor3 = Color3.fromRGB(62, 58, 74),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 9,
    }, row)
    round(switch, 15)
    local knob = make("Frame", {
        Position = UDim2.new(0, 3, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = C.white,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, switch)
    round(knob, 10)
    local on = stateTable[labelText] == true
    local function paint(instant)
        local bg = on and C.purple or Color3.fromRGB(62, 58, 74)
        local pos = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        if instant then switch.BackgroundColor3 = bg; knob.Position = pos
        else tw(switch, 0.16, {BackgroundColor3 = bg}); tw(knob, 0.16, {Position = pos}, Enum.EasingStyle.Back) end
    end
    paint(true)
    switch.Activated:Connect(function()
        on = not on
        stateTable[labelText] = on
        paint(false)
        if callback then callback(labelText, on) end
    end)
    switchControllers[#switchControllers + 1] = function()
        on = false
        stateTable[labelText] = false
        paint(false)
    end
    return row
end

local toggleStates = {}
local statusLine
local function setStatus(text)
    if statusLine then statusLine.Text = "●  " .. text end
end

-- Cartões iniciais: mesma distribuição visual da imagem de referência
local farmCard, farmInner = makeCard(leftColumn, "Farm Automático", UDim2.new(0, 0, 0, 0), UDim2.new(1, -5, 0.53, 0), "⚙")
for i, name in ipairs({"Auto Farm Level", "Auto Quest", "Auto Boss", "Auto Elite Hunter", "Auto Raid", "Auto Collect Fruits", "Auto Chest"}) do
    makeSwitch(farmInner, name, i, toggleStates, function(n, v) setStatus(n .. (v and " ligado (visual)" or " desligado")) end)
end

local extraCard, extraInner = makeCard(leftColumn, "Outras Funções", UDim2.new(0, 0, 0.55, 0), UDim2.new(1, -5, 0.45, -2), "★")
for i, name in ipairs({"Auto Haki", "Auto Skills", "Fast Attack", "Anti-AFK"}) do
    makeSwitch(extraInner, name, i, toggleStates, function(n, v) setStatus(n .. (v and " ligado (visual)" or " desligado")) end)
end

local configCard, configInner = makeCard(rightColumn, "Configurações de Farm", UDim2.new(0, 5, 0, 0), UDim2.new(1, -5, 0.53, 0), "⚙")
local methodLabel = make("TextLabel", {
    Position = UDim2.new(0, 3, 0, 4), Size = UDim2.new(0.53, 0, 0, 25),
    BackgroundTransparency = 1, Text = "Selecionar Método", TextColor3 = C.white,
    TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 9,
}, configInner)
local methodButton = make("TextButton", {
    Position = UDim2.new(0.56, 0, 0, 2), Size = UDim2.new(0.42, 0, 0, 27),
    BackgroundColor3 = Color3.fromRGB(8, 8, 18), Text = "Normal  ▾", TextColor3 = C.white,
    TextSize = 10, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 9,
}, configInner)
round(methodButton, 6)
local modes = {"Normal", "Rápido", "Seguro"}
local modeIndex = 1
methodButton.Activated:Connect(function()
    modeIndex = modeIndex % #modes + 1
    methodButton.Text = modes[modeIndex] .. "  ▾"
    setStatus("Método visual: " .. modes[modeIndex])
end)

make("TextLabel", {
    Position = UDim2.new(0, 3, 0, 43), Size = UDim2.new(0.55, 0, 0, 25),
    BackgroundTransparency = 1, Text = "Distância do Mob", TextColor3 = C.white,
    TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 9,
}, configInner)
local distance = make("TextBox", {
    Position = UDim2.new(0.56, 0, 0, 42), Size = UDim2.new(0.42, 0, 0, 27),
    BackgroundColor3 = Color3.fromRGB(8, 8, 18), Text = "50", PlaceholderText = "50",
    TextColor3 = C.white, TextSize = 10, Font = Enum.Font.GothamBold,
    ClearTextOnFocus = false, ZIndex = 9,
}, configInner)
round(distance, 6)

local exploreCard, exploreInner = makeCard(rightColumn, "Exploração", UDim2.new(0, 5, 0.55, 0), UDim2.new(1, -5, 0.45, -2), "◉")
for i, name in ipairs({"Auto Próxima Ilha", "Auto Marco", "Auto Desafio", "Auto Gravity"}) do
    makeSwitch(exploreInner, name, i, toggleStates, function(n, v) setStatus(n .. (v and " ligado (visual)" or " desligado")) end)
end

-- Painel de status na direita
