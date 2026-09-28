-- Nama   : RedzHub
-- Versi  : 1.3
-- Author : Redz

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Bersihkan UI lama jika dijalankan ulang
if CoreGui:FindFirstChild("RedzHub_UI") then
    CoreGui.RedzHub_UI:Destroy()
end

-- ==========================================
-- VARIABEL & DATA
-- ==========================================
local SelectedLocations = {}
local SelectedRarities = {}
local AutoStealEnabled = false
local AntiGuardEnabled = false
local AntiTrapEnabled = false
local AntiRagdollEnabled = false

local Rarities = {"Common", "Uncommon", "Rare", "Epik", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine"}
local Locations = {"Lake", "Gurun", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Angel & Demons"}

local Connections = {} -- Untuk menyimpan loop agar bisa dimatikan saat close

-- ==========================================
-- PEMBUATAN UI (MODERN BLACK & WHITE)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzHub_UI"
ScreenGui.Parent = CoreGui

-- BINGKAI UTAMA
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Parent = ScreenGui

-- TOPBAR (Untuk Drag)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RedzHub v1.3 | Steal An Egg"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- TOMBOL MINIMIZE & CLOSE
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TopBar

-- TOMBOL RH (MINIMIZE BULAT)
local RHButton = Instance.new("TextButton")
RHButton.Size = UDim2.new(0, 50, 0, 50)
RHButton.Position = UDim2.new(0.5, -25, 0, 20)
RHButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
RHButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
RHButton.BorderSizePixel = 2
RHButton.Text = "RH"
RHButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RHButton.Font = Enum.Font.GothamBold
RHButton.TextSize = 20
RHButton.Visible = false
RHButton.Parent = ScreenGui
local RHCorner = Instance.new("UICorner")
RHCorner.CornerRadius = UDim.new(1, 0)
RHCorner.Parent = RHButton

-- PANEL CLOSE (CONFIRMATION)
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 250, 0, 120)
ConfirmFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ConfirmFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
ConfirmFrame.BorderSizePixel = 2
ConfirmFrame.Visible = false
ConfirmFrame.Parent = ScreenGui

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0, 50)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "Ready to close?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 16
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 80, 0, 30)
YesBtn.Position = UDim2.new(0, 30, 0, 60)
YesBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
YesBtn.Text = "Yes"
YesBtn.Font = Enum.Font.GothamBold
YesBtn.Parent = ConfirmFrame

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 80, 0, 30)
NoBtn.Position = UDim2.new(1, -110, 0, 60)
NoBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
NoBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Text = "No"
NoBtn.Font = Enum.Font.GothamBold
NoBtn.Parent = ConfirmFrame

-- FUNGSI DRAGGABLE
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

-- LOGIKA TOMBOL UI
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

NoBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)

YesBtn.MouseButton1Click:Connect(function()
    for _, conn in pairs(Connections) do conn:Disconnect() end -- Matikan semua script yg berjalan
    ScreenGui:Destroy()
end)

-- ==========================================
-- TABS & KONTEN (MAIN & TOOLS)
-- ==========================================
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 100, 1, -30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -100, 1, -30)
ContentContainer.Position = UDim2.new(0, 100, 0, 30)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Size = UDim2.new(1, 0, 0, 40)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MainTabBtn.Text = "MAIN"
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.Parent = TabContainer

local ToolsTabBtn = Instance.new("TextButton")
ToolsTabBtn.Size = UDim2.new(1, 0, 0, 40)
ToolsTabBtn.Position = UDim2.new(0, 0, 0, 45)
ToolsTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToolsTabBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
ToolsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolsTabBtn.Text = "TOOLS"
ToolsTabBtn.Font = Enum.Font.GothamBold
ToolsTabBtn.Parent = TabContainer

local MainContent = Instance.new("ScrollingFrame")
MainContent.Size = UDim2.new(1, 0, 1, 0)
MainContent.BackgroundTransparency = 1
MainContent.ScrollBarThickness = 4
MainContent.Parent = ContentContainer

local ToolsContent = Instance.new("Frame")
ToolsContent.Size = UDim2.new(1, 0, 1, 0)
ToolsContent.BackgroundTransparency = 1
ToolsContent.Visible = false
ToolsContent.Parent = ContentContainer

-- Logika Pindah Tab
MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    ToolsContent.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    ToolsTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToolsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

ToolsTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    ToolsContent.Visible = true
    ToolsTabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToolsTabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- HELPER: Buat Tombol Toggle Standar
local function CreateToggle(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "[ OFF ] " .. text
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            btn.Text = "[ ON ] " .. text
        else
            btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = "[ OFF ] " .. text
        end
        callback(state)
    end)
    return btn
end

-- HELPER: Buat Grid Multi-Select
local function CreateMultiSelect(parent, title, list, stateTable, yOffset)
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, 0, 0, 20)
    TitleLbl.Position = UDim2.new(0, 0, 0, yOffset)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title .. " (Multi-Select)"
    TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.Parent = parent

    local GridFrame = Instance.new("Frame")
    GridFrame.Size = UDim2.new(0.95, 0, 0, math.ceil(#list/3)*35)
    GridFrame.Position = UDim2.new(0.025, 0, 0, yOffset + 25)
    GridFrame.BackgroundTransparency = 1
    GridFrame.Parent = parent

    local Grid = Instance.new("UIGridLayout")
    Grid.CellSize = UDim2.new(0.3, 0, 0, 30)
    Grid.CellPadding = UDim2.new(0.03, 0, 0, 5)
    Grid.Parent = GridFrame

    for _, item in ipairs(list) do
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = item
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = GridFrame

        local isSelected = false
        btn.MouseButton1Click:Connect(function()
            isSelected = not isSelected
            if isSelected then
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                table.insert(stateTable, item)
            else
                btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                for i, v in ipairs(stateTable) do
                    if v == item then table.remove(stateTable, i) break end
                end
            end
        end)
    end
    return yOffset + 25 + math.ceil(#list/3)*35 + 10
end

-- ISI KONTEN MAIN
local nextY = CreateMultiSelect(MainContent, "Pilih Lokasi", Locations, SelectedLocations, 10)
nextY = CreateMultiSelect(MainContent, "Pilih Rarity", Rarities, SelectedRarities, nextY)

local AutoStealBtn = CreateToggle(MainContent, "Auto Steal (Speed x5)", nextY, function(val)
    AutoStealEnabled = val
end)
MainContent.CanvasSize = UDim2.new(0, 0, 0, nextY + 60)

-- ISI KONTEN TOOLS
CreateToggle(ToolsContent, "Anti Hit Guard", 20, function(val) AntiGuardEnabled = val end)
CreateToggle(ToolsContent, "Anti Trap", 60, function(val) AntiTrapEnabled = val end)
CreateToggle(ToolsContent, "Anti Ragdoll", 100, function(val) AntiRagdollEnabled = val end)


-- ==========================================
-- LOGIKA UTAMA & SISTEM HACK
-- ==========================================

-- 1. Loop Auto Steal (Berjalan tiap 0.2 detik agar tidak lag)
table.insert(Connections, task.spawn(function()
    while task.wait(0.2) do
        if AutoStealEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            -- Speed 5x Lipat (200)
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 200
            end

            pcall(function()
                -- Cari telur di seluruh Workspace
                for _, obj in pairs(workspace:GetDescendants()) do
                    -- Jika nama telur cocok dengan salah satu Rarity yg dipilih
                    if table.find(SelectedRarities, obj.Name) then
                        
                        -- Cek apakah telur ini berada di dalam folder Lokasi yg dipilih
                        local inSelectedLocation = false
                        local parent = obj.Parent
                        while parent and parent ~= workspace do
                            if table.find(SelectedLocations, parent.Name) then
                                inSelectedLocation = true
                                break
                            end
                            parent = parent.Parent
                        end

                        if inSelectedLocation then
                            local targetPart = obj:IsA("Model") and obj.PrimaryPart or (obj:IsA("BasePart") and obj)
                            if targetPart then
                                -- Teleport
                                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame
                                
                                -- Bypass ambil telur (Support ProximityPrompt & Touch)
                                local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then fireproximityprompt(prompt) end
                                
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, targetPart, 0)
                                task.wait(0.05)
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, targetPart, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end))

-- 2. Loop Penghancur Guard & Trap (100% Anti Hit)
table.insert(Connections, task.spawn(function()
    while task.wait(1) do
        if AntiGuardEnabled then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    -- Menghancurkan Guard dari layar kamu, jadi mereka ga bisa mukul
                    if v:IsA("Model") and (v.Name:lower():match("guard") or v.Name:lower():match("npc") or v.Name:lower():match("security")) then
                        if v ~= LocalPlayer.Character then v:Destroy() end
                    end
                end
            end)
        end
        
        if AntiTrapEnabled then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    -- Hapus Trap/Jebakan sebelum kamu menginjaknya
                    if v:IsA("Model") and (v.Name:lower():match("trap") or v.Name:lower():match("spike")) then
                        v:Destroy()
                    end
                end
            end)
        end
        
        if AntiRagdollEnabled then
            pcall(function()
                -- Mematikan efek pukulan Bat dari Player lain
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        for _, tool in pairs(p.Character:GetDescendants()) do
                            if tool:IsA("Tool") or tool.Name:lower():match("bat") then
                                for _, part in pairs(tool:GetDescendants()) do
                                    if part:IsA("TouchTransmitter") then part:Destroy() end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end))

-- 3. Loop Paksa Berdiri (Anti-Ragdoll)
table.insert(Connections, RunService.RenderStepped:Connect(function()
    if AntiRagdollEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        humanoid.PlatformStand = false
        if humanoid:GetState() == Enum.HumanoidStateType.Ragdoll or humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end))
