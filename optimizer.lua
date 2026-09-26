-- [[ Redz Optimizer - Roblox Performance Script ]] --
-- Author: Redz

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Mencegah duplicate GUI
if CoreGui:FindFirstChild("RedzOptimizerGui") then
    CoreGui.RedzOptimizerGui:Destroy()
end

-- Inisialisasi ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzOptimizerGui"
ScreenGui.ResetOnSpawn = false

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Frame Utama Panel
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 8)
MainUICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ Redz Optimizer | v1.0"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 14
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Tombol Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinimizeBtn

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

-- Content Frame (Isi Fitur)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -45)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Indicator Status FPS & Ping
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, 0, 0, 25)
StatsLabel.Position = UDim2.new(0, 0, 0, 0)
StatsLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatsLabel.Text = "FPS: 0 | Ping: 0 ms"
StatsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
StatsLabel.TextSize = 13
StatsLabel.Font = Enum.Font.Code
StatsLabel.Parent = ContentFrame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 4)
StatsCorner.Parent = StatsLabel

-- Fungsi Pembuat Tombol Toggle
local function createToggle(name, posY, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 13
    btn.Parent = ContentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    local state = defaultState
    local function updateUI()
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(45, 120, 65)
            btn.Text = name .. ": [ ON ]"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            btn.Text = name .. ": [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        updateUI()
        callback(state)
    end)
    
    updateUI()
    return btn
end

-- Daftar Fitur Optimasi
local statsEnabled = true
createToggle("Tampilkan FPS & Ping", 35, true, function(val)
    statsEnabled = val
    StatsLabel.Visible = val
end)

createToggle("Matikan Bayangan (Shadows)", 72, false, function(val)
    Lighting.GlobalShadows = not val
end)

createToggle("Optimalkan Textures / Material", 109, false, function(val)
    if val then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    end
end)

createToggle("Hapus Efek Partikel & Fog", 146, false, function(val)
    if val then
        Lighting.FogEnd = 9e9
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
    end
end)

-- Watermark Author
local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Size = UDim2.new(1, 0, 0, 20)
AuthorLabel.Position = UDim2.new(0, 0, 1, -20)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Text = "Author: Redz | Optimized Performance"
AuthorLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
AuthorLabel.TextSize = 11
AuthorLabel.Font = Enum.Font.SourceSansItalic
AuthorLabel.Parent = ContentFrame

-- Logika Minimize & Maximize
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 320, 0, 35)
        MinimizeBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 320, 0, 260)
        MinimizeBtn.Text = "-"
    end
end)

-- Logika Close
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Logika Perhitungan FPS & Ping Realtime
local frameCount = 0
local lastTime = os.clock()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = os.clock()
    
    if currentTime - lastTime >= 1 then
        local fps = frameCount
        frameCount = 0
        lastTime = currentTime
        
        local ping = 0
        pcall(function()
            ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        
        if statsEnabled then
            StatsLabel.Text = string.format("FPS: %d | Ping: %d ms", fps, ping)
        end
    end
end)
