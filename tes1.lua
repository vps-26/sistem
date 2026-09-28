-- Nama   : RedzHub
-- Versi  : 1.3
-- Author : Redz
-- Theme  : Black, White & Neon Blue (Kompatibel Roblox & Delta Exec)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Bersihkan UI lama jika dijalankan ulang
if CoreGui:FindFirstChild("RedzHub_SAE") then
    CoreGui.RedzHub_SAE:Destroy()
end

-- ==========================================
-- PALET WARNA (HITAM, PUTIH, BIRU)
-- ==========================================
local C_DARK = Color3.fromRGB(15, 15, 20)      -- Hitam Utama
local C_TOPBAR = Color3.fromRGB(22, 24, 32)    -- Hitam Agak Terang
local C_CARD = Color3.fromRGB(28, 30, 40)      -- Frame Konten
local C_BLUE = Color3.fromRGB(0, 162, 255)     -- Biru Neon Accent
local C_WHITE = Color3.fromRGB(255, 255, 255)  -- Putih Teks/Border
local C_GRAY = Color3.fromRGB(150, 150, 160)   -- Abu-abu Teks Inaktif

-- ==========================================
-- VARIABEL SISTEM
-- ==========================================
local SelectedLocations = {}
local SelectedRarities = {}
local AutoStealEnabled = false
local AntiGuardEnabled = false
local AntiTrapEnabled = false
local AntiRagdollEnabled = false

local Rarities = {"Common", "Uncommon", "Rare", "Epik", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine"}
local Locations = {"Lake", "Gurun", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Angel & Demons"}

local ActiveConnections = {}

-- ==========================================
-- PEMBUATAN UI UTAMA
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzHub_SAE"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- FRAME UTAMA
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 330)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -165)
MainFrame.BackgroundColor3 = C_DARK
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = C_BLUE
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- TOPBAR (HEADER)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = C_TOPBAR
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RedzHub v1.3 | Steal An Egg"
Title.TextColor3 = C_BLUE
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- TOMBOL MINIMIZE & CLOSE TOPBAR
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
CloseBtn.TextSize = 16
CloseBtn.Parent = TopBar

-- TOMBOL MINIMIZE BULAT (RH)
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
RHButton.Active = true
RHButton.ZIndex = 100
RHButton.Parent = ScreenGui

local RHCorner = Instance.new("UICorner")
RHCorner.CornerRadius = UDim.new(1, 0)
RHCorner.Parent = RHButton

-- PANEL CONFIRMATION (READY TO CLOSE)
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Name = "ConfirmFrame"
ConfirmFrame.Size = UDim2.new(0, 260, 0, 130)
ConfirmFrame.Position = UDim2.new(0.5, -130, 0.5, -65)
ConfirmFrame.BackgroundColor3 = C_TOPBAR
ConfirmFrame.BorderColor3 = C_BLUE
ConfirmFrame.BorderSizePixel = 2
ConfirmFrame.Visible = false
ConfirmFrame.Active = true
ConfirmFrame.ZIndex = 200
ConfirmFrame.Parent = ScreenGui

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 8)
ConfirmCorner.Parent = ConfirmFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0, 50)
ConfirmText.Position = UDim2.new(0, 0, 0, 10)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "Ready to close?"
ConfirmText.TextColor3 = C_WHITE
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 16
ConfirmText.ZIndex = 201
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 90, 0, 35)
YesBtn.Position = UDim2.new(0, 25, 0, 70)
YesBtn.BackgroundColor3 = C_BLUE
YesBtn.TextColor3 = C_WHITE
YesBtn.Text = "Yes"
YesBtn.Font = Enum.Font.GothamBold
YesBtn.TextSize = 14
YesBtn.ZIndex = 202
YesBtn.Parent = ConfirmFrame

local YesCorner = Instance.new("UICorner")
YesCorner.CornerRadius = UDim.new(0, 6)
YesCorner.Parent = YesBtn

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 90, 0, 35)
NoBtn.Position = UDim2.new(1, -115, 0, 70)
NoBtn.BackgroundColor3 = C_CARD
NoBtn.BorderColor3 = C_BLUE
NoBtn.BorderSizePixel = 1
NoBtn.TextColor3 = C_WHITE
NoBtn.Text = "No"
NoBtn.Font = Enum.Font.GothamBold
NoBtn.TextSize = 14
NoBtn.ZIndex = 202
NoBtn.Parent = ConfirmFrame

local NoCorner = Instance.new("UICorner")
NoCorner.CornerRadius = UDim.new(0, 6)
NoCorner.Parent = NoBtn

-- ==========================================
-- DRAGGABLE SYSTEM (SUPPORT TOUCH & MOUSE)
-- ==========================================
local function MakeDraggable(dragPart, movePart)
    local dragging, dragInput, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = movePart.Position
        end
    end)
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            movePart.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    dragPart.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
MakeDraggable(TopBar, MainFrame)
MakeDraggable(RHButton, RHButton)

-- ==========================================
-- LOGIKA TOMBOL UI (CLOSE FIX & MINIMIZE)
-- ==========================================
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    RHButton.Visible = true
end)

RHButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    RHButton.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
end)

local function CloseScript()
    AutoStealEnabled = false
    AntiGuardEnabled = false
    AntiTrapEnabled = false
    AntiRagdollEnabled = false
    
    for _, conn in pairs(ActiveConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    
    if ScreenGui then
        ScreenGui:Destroy()
    end
end

-- Fix support tombol YES & NO (Event Touch & Click)
YesBtn.Activated:Connect(CloseScript)
YesBtn.MouseButton1Click:Connect(CloseScript)

NoBtn.Activated:Connect(function() ConfirmFrame.Visible = false end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

-- ==========================================
-- TAB NAVIGATION & KONTEN
-- ==========================================
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 110, 1, -35)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.BackgroundColor3 = C_TOPBAR
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -115, 1, -40)
ContentContainer.Position = UDim2.new(0, 112, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Size = UDim2.new(1, -10, 0, 35)
MainTabBtn.Position = UDim2.new(0, 5, 0, 10)
MainTabBtn.BackgroundColor3 = C_BLUE
MainTabBtn.TextColor3 = C_WHITE
MainTabBtn.Text = "MAIN"
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextSize = 13
MainTabBtn.Parent = TabContainer
local MTabCorner = Instance.new("UICorner") MTabCorner.CornerRadius = UDim.new(0, 6) MTabCorner.Parent = MainTabBtn

local ToolsTabBtn = Instance.new("TextButton")
ToolsTabBtn.Size = UDim2.new(1, -10, 0, 35)
ToolsTabBtn.Position = UDim2.new(0, 5, 0, 50)
ToolsTabBtn.BackgroundColor3 = C_CARD
ToolsTabBtn.TextColor3 = C_WHITE
ToolsTabBtn.Text = "TOOLS"
ToolsTabBtn.Font = Enum.Font.GothamBold
ToolsTabBtn.TextSize = 13
ToolsTabBtn.Parent = TabContainer
local TTabCorner = Instance.new("UICorner") TTabCorner.CornerRadius = UDim.new(0, 6) TTabCorner.Parent = ToolsTabBtn

local MainContent = Instance.new("ScrollingFrame")
MainContent.Size = UDim2.new(1, 0, 1, 0)
MainContent.BackgroundTransparency = 1
MainContent.ScrollBarThickness = 4
MainContent.ScrollBarImageColor3 = C_BLUE
MainContent.Parent = ContentContainer

local ToolsContent = Instance.new("Frame")
ToolsContent.Size = UDim2.new(1, 0, 1, 0)
ToolsContent.BackgroundTransparency = 1
ToolsContent.Visible = false
ToolsContent.Parent = ContentContainer

MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    ToolsContent.Visible = false
    MainTabBtn.BackgroundColor3 = C_BLUE
    ToolsTabBtn.BackgroundColor3 = C_CARD
end)

ToolsTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    ToolsContent.Visible = true
    ToolsTabBtn.BackgroundColor3 = C_BLUE
    MainTabBtn.BackgroundColor3 = C_CARD
end)

-- HELPER UI BUILDERS
local function CreateToggle(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.96, 0, 0, 34)
    btn.Position = UDim2.new(0.02, 0, 0, yPos)
    btn.BackgroundColor3 = C_CARD
    btn.BorderColor3 = C_BLUE
    btn.BorderSizePixel = 1
    btn.TextColor3 = C_WHITE
    btn.Text = "[ OFF ]  " .. text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = parent
    
    local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 6) bCorner.Parent = btn

    local state = false
    local function toggle()
        state = not state
        if state then
            btn.BackgroundColor3 = C_BLUE
            btn.TextColor3 = C_WHITE
            btn.Text = "[ ON ]  " .. text
        else
            btn.BackgroundColor3 = C_CARD
            btn.TextColor3 = C_WHITE
            btn.Text = "[ OFF ]  " .. text
        end
        callback(state)
    end
    btn.MouseButton1Click:Connect(toggle)
    btn.Activated:Connect(toggle)
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
        local function click()
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
        end
        btn.MouseButton1Click:Connect(click)
        btn.Activated:Connect(click)
    end
    return yOffset + 22 + math.ceil(#list/3)*32 + 10
end

-- RENDER ISI TAB
local nextY = CreateMultiSelect(MainContent, "Pilih Lokasi", Locations, SelectedLocations, 5)
nextY = CreateMultiSelect(MainContent, "Pilih Rarity", Rarities, SelectedRarities, nextY)
CreateToggle(MainContent, "Auto Steal (Speed x5)", nextY, function(val) AutoStealEnabled = val end)
MainContent.CanvasSize = UDim2.new(0, 0, 0, nextY + 50)

CreateToggle(ToolsContent, "Anti Hit Guard", 10, function(val) AntiGuardEnabled = val end)
CreateToggle(ToolsContent, "Anti Trap", 55, function(val) AntiTrapEnabled = val end)
CreateToggle(ToolsContent, "Anti Ragdoll", 100, function(val) AntiRagdollEnabled = val end)


-- ==========================================
-- LOGIKA UTAMA SCRIPT & SYSTEM FIXES
-- ==========================================

-- 1. FIX SYSTEM: AUTO STEAL 100% OTOMATIS
table.insert(ActiveConnections, task.spawn(function()
    while task.wait(0.15) do
        if AutoStealEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            -- Terapkan Kecepatan Player x5 (Speed 200)
            if hum then hum.WalkSpeed = 200 end

            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    -- Cek apakah objek sesuai dengan Rarity yang dipilih
                    local nameMatch = false
                    for _, rarity in pairs(SelectedRarities) do
                        if string.find(obj.Name:lower(), rarity:lower()) then
                            nameMatch = true
                            break
                        end
                    end

                    if nameMatch then
                        -- Cek apakah objek berada di dalam Lokasi yang dipilih
                        local locMatch = false
                        local parent = obj.Parent
                        while parent and parent ~= workspace do
                            for _, loc in pairs(SelectedLocations) do
                                if string.find(parent.Name:lower(), loc:lower()) then
                                    locMatch = true
                                    break
                                end
                            end
                            if locMatch then break end
                            parent = parent.Parent
                        end

                        if locMatch then
                            local eggPart = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                            
                            if eggPart then
                                -- Teleportasi presisi ke telur
                                hrp.CFrame = eggPart.CFrame + Vector3.new(0, 1.5, 0)
                                
                                -- Eksekusi Pencurian Telur (Touch & Prompt Bypass)
                                firetouchinterest(hrp, eggPart, 0)
                                task.wait(0.02)
                                firetouchinterest(hrp, eggPart, 1)

                                local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then fireproximityprompt(prompt) end
                            end
                        end
                    end
                end
            end)
        end
    end
end))

-- 2. FIX SYSTEM: ANTI HIT GUARD (Guard Tidak Bisa Meng-Hit)
table.insert(ActiveConnections, task.spawn(function()
    while task.wait(0.3) do
        if AntiGuardEnabled then
            pcall(function()
                for _, npc in pairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and (string.find(npc.Name:lower(), "guard") or string.find(npc.Name:lower(), "penjaga")) then
                        if npc ~= LocalPlayer.Character then
                            -- Matikan fungsi Hitbox/Sentuh pada seluruh bagian tubuh Guard
                            for _, part in pairs(npc:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanTouch = false
                                    part.CanCollide = false
                                end
                                if part:IsA("TouchTransmitter") then
                                    part:Destroy() -- Hapus sensor pemukul Guard
                                end
                            end
                            
                            -- Lumpuhkan pergerakan dan serangan NPC Guard
                            local gHum = npc:FindFirstChildOfClass("Humanoid")
                            if gHum then
                                gHum.WalkSpeed = 0
                                gHum.JumpPower = 0
                            end
                        end
                    end
                end
            end)
        end
    end
end))

-- 3. FIX SYSTEM: ANTI TRAP (Jebakan Tidak Bisa Dipicu)
table.insert(ActiveConnections, task.spawn(function()
    while task.wait(0.3) do
        if AntiTrapEnabled then
            pcall(function()
                for _, item in pairs(workspace:GetDescendants()) do
                    if item:IsA("Model") or item:IsA("BasePart") then
                        if string.find(item.Name:lower(), "trap") or string.find(item.Name:lower(), "jebakan") then
                            -- Matikan kemampuan trap untuk mendeteksi sentuhan pemain
                            if item:IsA("BasePart") then
                                item.CanTouch = false
                                item.CanCollide = false
                            end
                            for _, part in pairs(item:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanTouch = false
                                    part.CanCollide = false
                                end
                                if part:IsA("TouchTransmitter") then
                                    part:Destroy() -- Hapus sensor sentuh trap
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end))

-- 4. FIX SYSTEM: ANTI RAGDOLL (Bypass Pemukul/Bat & Jatuh)
table.insert(ActiveConnections, RunService.RenderStepped:Connect(function()
    if AntiRagdollEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Paksa Player Tetap Berdiri
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true

            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                task.wait()
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end

        -- Hapus Efek Constraint Ragdoll & Stun yang Menempel di Karakter
        for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or (child:IsA("StringValue") and string.find(child.Name:lower(), "ragdoll")) then
                child:Destroy()
            end
        end
    end
end))
