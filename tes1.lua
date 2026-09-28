-- Nama   : RedzHub
-- Versi  : 1.3
-- Author : Redz
-- Theme  : Black, White & Neon Blue (Optimized for Delta Executor)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Menggunakan gethui() agar optimal di Delta Executor
local ParentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

if ParentGui:FindFirstChild("RedzHub_SAE") then
    ParentGui.RedzHub_SAE:Destroy()
end

-- ==========================================
-- PALET WARNA & VARIABEL
-- ==========================================
local C_DARK   = Color3.fromRGB(15, 15, 20)
local C_TOPBAR = Color3.fromRGB(22, 24, 32)
local C_CARD   = Color3.fromRGB(28, 30, 40)
local C_BLUE   = Color3.fromRGB(0, 162, 255)
local C_WHITE  = Color3.fromRGB(255, 255, 255)
local C_GRAY   = Color3.fromRGB(150, 150, 160)

local SelectedLocations = {}
local SelectedRarities = {}
local AutoStealEnabled = false
local AntiGuardEnabled = false
local AntiTrapEnabled = false
local AntiRagdollEnabled = false

local Rarities = {"Common", "Uncommon", "Rare", "Epik", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine"}
local Locations = {"Lake", "Gurun", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Angel & Demons"}

-- ==========================================
-- TAMPILAN UI UTAMA
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzHub_SAE"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = ParentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 310)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -155)
MainFrame.BackgroundColor3 = C_DARK
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = C_BLUE
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- TOPBAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = C_TOPBAR
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RedzHub v1.3 | Steal An Egg"
Title.TextColor3 = C_BLUE
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 2)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = C_WHITE
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -32, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 15
CloseBtn.Parent = TopBar

-- TOMBOL MINIMIZE (RH)
local RHButton = Instance.new("TextButton")
RHButton.Name = "RH_Button"
RHButton.Size = UDim2.new(0, 50, 0, 50)
RHButton.Position = UDim2.new(0.05, 0, 0.2, 0)
RHButton.BackgroundColor3 = C_DARK
RHButton.BorderColor3 = C_BLUE
RHButton.BorderSizePixel = 2
RHButton.Text = "RH"
RHButton.TextColor3 = C_BLUE
RHButton.Font = Enum.Font.GothamBold
RHButton.TextSize = 18
RHButton.Visible = false
RHButton.ZIndex = 1000
RHButton.Parent = ScreenGui

local RHCorner = Instance.new("UICorner")
RHCorner.CornerRadius = UDim.new(1, 0)
RHCorner.Parent = RHButton

-- PANEL CONFIRMATION (READY TO CLOSE)
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 240, 0, 120)
ConfirmFrame.Position = UDim2.new(0.5, -120, 0.5, -60)
ConfirmFrame.BackgroundColor3 = C_TOPBAR
ConfirmFrame.BorderColor3 = C_BLUE
ConfirmFrame.BorderSizePixel = 2
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 2000
ConfirmFrame.Parent = ScreenGui

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 8)
ConfirmCorner.Parent = ConfirmFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0, 45)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "Ready to close?"
ConfirmText.TextColor3 = C_WHITE
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 15
ConfirmText.ZIndex = 2001
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 85, 0, 32)
YesBtn.Position = UDim2.new(0, 20, 0, 65)
YesBtn.BackgroundColor3 = C_BLUE
YesBtn.TextColor3 = C_WHITE
YesBtn.Text = "Yes"
YesBtn.Font = Enum.Font.GothamBold
YesBtn.TextSize = 13
YesBtn.ZIndex = 2002
YesBtn.Parent = ConfirmFrame
local YCorner = Instance.new("UICorner") YCorner.CornerRadius = UDim.new(0, 6) YCorner.Parent = YesBtn

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 85, 0, 32)
NoBtn.Position = UDim2.new(1, -105, 0, 65)
NoBtn.BackgroundColor3 = C_CARD
NoBtn.BorderColor3 = C_BLUE
NoBtn.BorderSizePixel = 1
NoBtn.TextColor3 = C_WHITE
NoBtn.Text = "No"
NoBtn.Font = Enum.Font.GothamBold
NoBtn.TextSize = 13
NoBtn.ZIndex = 2002
NoBtn.Parent = ConfirmFrame
local NCorner = Instance.new("UICorner") NCorner.CornerRadius = UDim.new(0, 6) NCorner.Parent = NoBtn

-- SYSTEM DRAGGABLE UNTUK MOBILE & PC
local function EnableDrag(dragHandle, moveTarget)
    local dragging, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveTarget.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            moveTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
EnableDrag(TopBar, MainFrame)
EnableDrag(RHButton, RHButton)

-- EVENT KONTROL UI
MinBtn.Activated:Connect(function()
    MainFrame.Visible = false
    RHButton.Visible = true
end)

RHButton.Activated:Connect(function()
    MainFrame.Visible = true
    RHButton.Visible = false
end)

CloseBtn.Activated:Connect(function()
    ConfirmFrame.Visible = true
end)

NoBtn.Activated:Connect(function()
    ConfirmFrame.Visible = false
end)

YesBtn.Activated:Connect(function()
    AutoStealEnabled = false
    AntiGuardEnabled = false
    AntiTrapEnabled = false
    AntiRagdollEnabled = false
    ScreenGui:Destroy()
end)

-- ==========================================
-- NAVIGATION TAB & CONTAINER
-- ==========================================
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 100, 1, -35)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.BackgroundColor3 = C_TOPBAR
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -110, 1, -40)
ContentContainer.Position = UDim2.new(0, 105, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Size = UDim2.new(1, -10, 0, 32)
MainTabBtn.Position = UDim2.new(0, 5, 0, 10)
MainTabBtn.BackgroundColor3 = C_BLUE
MainTabBtn.TextColor3 = C_WHITE
MainTabBtn.Text = "MAIN"
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextSize = 12
MainTabBtn.Parent = TabContainer
local MCorner = Instance.new("UICorner") MCorner.CornerRadius = UDim.new(0, 6) MCorner.Parent = MainTabBtn

local ToolsTabBtn = Instance.new("TextButton")
ToolsTabBtn.Size = UDim2.new(1, -10, 0, 32)
ToolsTabBtn.Position = UDim2.new(0, 5, 0, 48)
ToolsTabBtn.BackgroundColor3 = C_CARD
ToolsTabBtn.TextColor3 = C_WHITE
ToolsTabBtn.Text = "TOOLS"
ToolsTabBtn.Font = Enum.Font.GothamBold
ToolsTabBtn.TextSize = 12
ToolsTabBtn.Parent = TabContainer
local TCorner = Instance.new("UICorner") TCorner.CornerRadius = UDim.new(0, 6) TCorner.Parent = ToolsTabBtn

local MainContent = Instance.new("ScrollingFrame")
MainContent.Size = UDim2.new(1, 0, 1, 0)
MainContent.BackgroundTransparency = 1
MainContent.ScrollBarThickness = 4
MainContent.ScrollBarImageColor3 = C_BLUE
MainContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
MainContent.CanvasSize = UDim2.new(0, 0, 0, 0)
MainContent.Parent = ContentContainer

local ToolsContent = Instance.new("Frame")
ToolsContent.Size = UDim2.new(1, 0, 1, 0)
ToolsContent.BackgroundTransparency = 1
ToolsContent.Visible = false
ToolsContent.Parent = ContentContainer

MainTabBtn.Activated:Connect(function()
    MainContent.Visible = true
    ToolsContent.Visible = false
    MainTabBtn.BackgroundColor3 = C_BLUE
    ToolsTabBtn.BackgroundColor3 = C_CARD
end)

ToolsTabBtn.Activated:Connect(function()
    MainContent.Visible = false
    ToolsContent.Visible = true
    ToolsTabBtn.BackgroundColor3 = C_BLUE
    MainTabBtn.BackgroundColor3 = C_CARD
end)

-- HELPER ELEMEN UI
local function CreateToggle(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.96, 0, 0, 32)
    btn.Position = UDim2.new(0.02, 0, 0, yPos)
    btn.BackgroundColor3 = C_CARD
    btn.BorderColor3 = C_BLUE
    btn.BorderSizePixel = 1
    btn.TextColor3 = C_WHITE
    btn.Text = "[ OFF ]  " .. text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = parent
    
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = btn

    local state = false
    btn.Activated:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = C_BLUE
            btn.Text = "[ ON ]  " .. text
        else
            btn.BackgroundColor3 = C_CARD
            btn.Text = "[ OFF ]  " .. text
        end
        callback(state)
    end)
    return btn
end

local function CreateMultiSelect(parent, title, list, stateTable, yOffset)
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, 0, 0, 18)
    TitleLbl.Position = UDim2.new(0, 0, 0, yOffset)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title .. " (Multi-Select)"
    TitleLbl.TextColor3 = C_BLUE
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 12
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = parent

    local GridFrame = Instance.new("Frame")
    GridFrame.Size = UDim2.new(0.98, 0, 0, math.ceil(#list/3)*32)
    GridFrame.Position = UDim2.new(0, 0, 0, yOffset + 22)
    GridFrame.BackgroundTransparency = 1
    GridFrame.Parent = parent

    local Grid = Instance.new("UIGridLayout")
    Grid.CellSize = UDim2.new(0.31, 0, 0, 28)
    Grid.CellPadding = UDim2.new(0.02, 0, 0, 4)
    Grid.Parent = GridFrame

    for _, item in ipairs(list) do
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = C_CARD
        btn.BorderColor3 = C_BLUE
        btn.BorderSizePixel = 1
        btn.TextColor3 = C_GRAY
        btn.Text = item
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = GridFrame
        
        local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = btn

        local isSelected = false
        btn.Activated:Connect(function()
            isSelected = not isSelected
            if isSelected then
                btn.BackgroundColor3 = C_BLUE
                btn.TextColor3 = C_WHITE
                table.insert(stateTable, item)
            else
                btn.BackgroundColor3 = C_CARD
                btn.TextColor3 = C_GRAY
                for i, v in ipairs(stateTable) do
                    if v == item then table.remove(stateTable, i) break end
                end
            end
        end)
    end
    return yOffset + 22 + math.ceil(#list/3)*32 + 10
end

-- RENDER ISI KONTEN
local nextY = CreateMultiSelect(MainContent, "Pilih Lokasi", Locations, SelectedLocations, 5)
nextY = CreateMultiSelect(MainContent, "Pilih Rarity", Rarities, SelectedRarities, nextY)
CreateToggle(MainContent, "Auto Steal (Speed x5)", nextY, function(val) AutoStealEnabled = val end)

CreateToggle(ToolsContent, "Anti Hit Guard", 10, function(val) AntiGuardEnabled = val end)
CreateToggle(ToolsContent, "Anti Trap", 50, function(val) AntiTrapEnabled = val end)
CreateToggle(ToolsContent, "Anti Ragdoll", 90, function(val) AntiRagdollEnabled = val end)


-- ==========================================
-- LOGIKA CHEAT (RINGAN & BEBAS LAG)
-- ==========================================

-- Helper pencarian cepat tanpa membebani CPU
local function GetTargetEggs()
    local foundEggs = {}
    if #SelectedLocations == 0 or #SelectedRarities == 0 then return foundEggs end

    for _, locName in ipairs(SelectedLocations) do
        local locFolder = workspace:FindFirstChild(locName, true) or workspace
        for _, child in ipairs(locFolder:GetChildren()) do
            for _, rarity in ipairs(SelectedRarities) do
                if string.find(child.Name:lower(), rarity:lower()) then
                    table.insert(foundEggs, child)
                end
            end
        end
    end
    return foundEggs
end

-- 1. AUTO STEAL LOOP
task.spawn(function()
    while task.wait(0.2) do
        if AutoStealEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            -- Set Kecepatan Karakter (5x Lipat / 200 Speed)
            if hum then hum.WalkSpeed = 200 end

            local targets = GetTargetEggs()
            for _, eggObj in ipairs(targets) do
                if not AutoStealEnabled then break end
                
                local eggPart = eggObj:IsA("BasePart") and eggObj or (eggObj:IsA("Model") and (eggObj.PrimaryPart or eggObj:FindFirstChildWhichIsA("BasePart")))
                if eggPart then
                    -- Teleportasi langsung tepat ke lokasi telur
                    hrp.CFrame = eggPart.CFrame + Vector3.new(0, 1, 0)
                    
                    -- Memicu pengambilan telur
                    firetouchinterest(hrp, eggPart, 0)
                    task.wait(0.02)
                    firetouchinterest(hrp, eggPart, 1)

                    local prompt = eggObj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then fireproximityprompt(prompt) end
                end
            end
        end
    end
end)

-- 2. ANTI HIT GUARD & ANTI TRAP LOOP
task.spawn(function()
    while task.wait(0.5) do
        if AntiGuardEnabled or AntiTrapEnabled then
            for _, v in ipairs(workspace:GetChildren()) do
                -- Anti Hit Guard
                if AntiGuardEnabled and v:IsA("Model") and (string.find(v.Name:lower(), "guard") or string.find(v.Name:lower(), "npc")) then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanTouch = false
                        elseif part:IsA("TouchTransmitter") then
                            part:Destroy()
                        end
                    end
                end

                -- Anti Trap
                if AntiTrapEnabled and (string.find(v.Name:lower(), "trap") or string.find(v.Name:lower(), "spike")) then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanTouch = false
                        elseif part:IsA("TouchTransmitter") then
                            part:Destroy()
                        end
                    end
                end
            end
        end
    end
end)

-- 3. ANTI RAGDOLL LOOP
RunService.Stepped:Connect(function()
    if AntiRagdollEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Mencegah animasi jatuhnya karakter saat dipukul bat
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            
            if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end)
