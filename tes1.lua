--================================================================--
--                   REDZHUB v1.3 - STEAL AN EGG                  --
--                   Author: Redz | Compatible: Delta / All Exec   --
--================================================================--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Parent target (Support Delta Executor)
local TargetParent = (gethui and gethui()) or CoreGui

-- Hapus GUI lama jika ada
if TargetParent:FindFirstChild("RedzHubSAE") then
    TargetParent:FindFirstChild("RedzHubSAE"):Destroy()
end

-- State Management
local Config = {
    AutoSteal = false,
    SpeedMultiplier = false,
    AntiGuard = false,
    AntiTrap = false,
    AntiRagdoll = false,
    SelectedRarities = {},
    SelectedLocations = {}
}

local RaritiesList = {"Common", "Uncommon", "Rare", "Epik", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine"}
local LocationsList = {"Lake", "Gurun", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Angel & Demons"}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzHubSAE"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

-- Color Palette
local BG_COLOR = Color3.fromRGB(18, 18, 24)
local CARD_COLOR = Color3.fromRGB(28, 28, 38)
local ACCENT_BLUE = Color3.fromRGB(0, 136, 255)
local TEXT_WHITE = Color3.fromRGB(245, 245, 245)
local OFF_COLOR = Color3.fromRGB(45, 45, 55)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner", MainFrame)
MainUICorner.CornerRadius = UDim.new(0, 10)

local MainUIStroke = Instance.new("UIStroke", MainFrame)
MainUIStroke.Color = ACCENT_BLUE
MainUIStroke.Thickness = 1.5

-- Top Bar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = CARD_COLOR
TopBar.BorderSizePixel = 0

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 10)

local TitleText = Instance.new("TextLabel", TopBar)
TitleText.Size = UDim2.new(0, 250, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Text = "RedzHub v1.3 | Steal An Egg"
TitleText.TextColor3 = TEXT_WHITE
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1

-- Window Controls (Minimize & Close)
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Text = "-"
MinBtn.TextColor3 = TEXT_WHITE
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BackgroundColor3 = OFF_COLOR
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BackgroundColor3 = OFF_COLOR
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Navigation Tabs Bar
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 130, 1, -50)
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.BackgroundColor3 = CARD_COLOR
Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 8)

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local TabPadding = Instance.new("UIPadding", TabContainer)
TabPadding.PaddingTop = UDim.new(0, 8)

-- Content Area
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -160, 1, -50)
ContentContainer.Position = UDim2.new(0, 150, 0, 45)
ContentContainer.BackgroundTransparency = 1

-- Confirmation Close Modal
local CloseModal = Instance.new("Frame", ScreenGui)
CloseModal.Size = UDim2.new(0, 280, 0, 140)
CloseModal.Position = UDim2.new(0.5, -140, 0.5, -70)
CloseModal.BackgroundColor3 = CARD_COLOR
CloseModal.Visible = false
CloseModal.ZIndex = 10
Instance.new("UICorner", CloseModal).CornerRadius = UDim.new(0, 10)
local ModalStroke = Instance.new("UIStroke", CloseModal)
ModalStroke.Color = ACCENT_BLUE
ModalStroke.Thickness = 1.5

local ModalText = Instance.new("TextLabel", CloseModal)
ModalText.Size = UDim2.new(1, -20, 0, 40)
ModalText.Position = UDim2.new(0, 10, 0, 15)
ModalText.Text = "Ready to close?"
ModalText.TextColor3 = TEXT_WHITE
ModalText.TextSize = 18
ModalText.Font = Enum.Font.GothamBold
ModalText.BackgroundTransparency = 1
ModalText.ZIndex = 11

local YesBtn = Instance.new("TextButton", CloseModal)
YesBtn.Size = UDim2.new(0, 110, 0, 35)
YesBtn.Position = UDim2.new(0, 20, 0, 80)
YesBtn.Text = "Yes"
YesBtn.BackgroundColor3 = ACCENT_BLUE
YesBtn.TextColor3 = TEXT_WHITE
YesBtn.Font = Enum.Font.GothamBold
YesBtn.TextSize = 14
YesBtn.ZIndex = 11
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton", CloseModal)
NoBtn.Size = UDim2.new(0, 110, 0, 35)
NoBtn.Position = UDim2.new(1, -130, 0, 80)
NoBtn.Text = "No"
NoBtn.BackgroundColor3 = OFF_COLOR
NoBtn.TextColor3 = TEXT_WHITE
NoBtn.Font = Enum.Font.GothamBold
NoBtn.TextSize = 14
NoBtn.ZIndex = 11
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

-- Minimize Button Widget (Logo RH)
local RHWidget = Instance.new("TextButton", ScreenGui)
RHWidget.Size = UDim2.new(0, 50, 0, 50)
RHWidget.Position = UDim2.new(0, 20, 0.5, -25)
RHWidget.BackgroundColor3 = BG_COLOR
RHWidget.Text = "RH"
RHWidget.TextColor3 = ACCENT_BLUE
RHWidget.TextSize = 18
RHWidget.Font = Enum.Font.GothamBold
RHWidget.Visible = false
RHWidget.Active = true
RHWidget.Draggable = true
Instance.new("UICorner", RHWidget).CornerRadius = UDim.new(1, 0)
local RHStroke = Instance.new("UIStroke", RHWidget)
RHStroke.Color = ACCENT_BLUE
RHStroke.Thickness = 2

-- Tab Switcher Logic
local Tabs = {}
local function CreateTab(name, order)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0, 115, 0, 35)
    TabBtn.Text = name
    TabBtn.TextColor3 = TEXT_WHITE
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 13
    TabBtn.BackgroundColor3 = OFF_COLOR
    TabBtn.LayoutOrder = order
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", ContentContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = ACCENT_BLUE
    Page.Visible = false

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

    Tabs[name] = {Btn = TabBtn, Page = Page}

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.BackgroundColor3 = OFF_COLOR
            t.Btn.TextColor3 = TEXT_WHITE
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = ACCENT_BLUE
    end)

    return Page
end

local MainPage = CreateTab("MAIN", 1)
local ToolsPage = CreateTab("TOOLS", 2)
Tabs["MAIN"].Page.Visible = true
Tabs["MAIN"].Btn.BackgroundColor3 = ACCENT_BLUE

-- UI Toggle Creator Helper
local function CreateToggle(parent, text, defaultState, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = CARD_COLOR
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = TEXT_WHITE
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Switch = Instance.new("TextButton", ToggleFrame)
    Switch.Size = UDim2.new(0, 40, 0, 22)
    Switch.Position = UDim2.new(1, -50, 0.5, -11)
    Switch.Text = ""
    Switch.BackgroundColor3 = defaultState and ACCENT_BLUE or OFF_COLOR
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Switch)
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Dot.BackgroundColor3 = TEXT_WHITE
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    Switch.MouseButton1Click:Connect(function()
        state = not state
        Switch.BackgroundColor3 = state and ACCENT_BLUE or OFF_COLOR
        Dot.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        callback(state)
    end)
end

-- Multi-Select Dropdown Helper
local function CreateMultiSelect(parent, title, optionsTable, targetTable)
    local SectionLabel = Instance.new("TextLabel", parent)
    SectionLabel.Size = UDim2.new(1, -10, 0, 20)
    SectionLabel.Text = title
    SectionLabel.TextColor3 = ACCENT_BLUE
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 13
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.BackgroundTransparency = 1

    local Grid = Instance.new("Frame", parent)
    Grid.Size = UDim2.new(1, -10, 0, math.ceil(#optionsTable / 2) * 32)
    Grid.BackgroundTransparency = 1

    local UIGrid = Instance.new("UIGridLayout", Grid)
    UIGrid.CellSize = UDim2.new(0.48, 0, 0, 28)
    UIGrid.CellPadding = UDim2.new(0.04, 0, 0, 4)

    for _, option in ipairs(optionsTable) do
        local OptBtn = Instance.new("TextButton", Grid)
        OptBtn.Text = option
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 11
        OptBtn.TextColor3 = TEXT_WHITE
        OptBtn.BackgroundColor3 = OFF_COLOR
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

        OptBtn.MouseButton1Click:Connect(function()
            if targetTable[option] then
                targetTable[option] = nil
                OptBtn.BackgroundColor3 = OFF_COLOR
                OptBtn.TextColor3 = TEXT_WHITE
            else
                targetTable[option] = true
                OptBtn.BackgroundColor3 = ACCENT_BLUE
                OptBtn.TextColor3 = TEXT_WHITE
            end
        end)
    end
end

-- Populate TAB 1: MAIN
CreateToggle(MainPage, "Auto Steal Egg", false, function(v)
    Config.AutoSteal = v
end)

CreateToggle(MainPage, "Speed Boost Multiplier (5x)", false, function(v)
    Config.SpeedMultiplier = v
end)

CreateMultiSelect(MainPage, "Filter Rarity (Multi-Select)", RaritiesList, Config.SelectedRarities)
CreateMultiSelect(MainPage, "Filter Lokasi (Multi-Select)", LocationsList, Config.SelectedLocations)

-- Populate TAB 2: TOOLS
CreateToggle(ToolsPage, "Anti Hit Guard", false, function(v)
    Config.AntiGuard = v
end)

CreateToggle(ToolsPage, "Anti Trap", false, function(v)
    Config.AntiTrap = v
end)

CreateToggle(ToolsPage, "Anti Ragdoll", false, function(v)
    Config.AntiRagdoll = v
end)

-- Window Handlers & Fixes
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    RHWidget.Visible = true
end)

RHWidget.MouseButton1Click:Connect(function()
    RHWidget.Visible = false
    MainFrame.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    CloseModal.Visible = true
end)

NoBtn.MouseButton1Click:Connect(function()
    CloseModal.Visible = false
end)

-- FIX YES CLOSE BUTTON
YesBtn.MouseButton1Click:Connect(function()
    -- Clear States
    Config.AutoSteal = false
    Config.AntiGuard = false
    Config.AntiTrap = false
    Config.AntiRagdoll = false
    Config.SpeedMultiplier = false
    
    -- Reset Speed
    if Humanoid then
        Humanoid.WalkSpeed = 16
    end

    -- Destroy UI
    ScreenGui:Destroy()
end)

--================================================================--
--                   SYSTEM LOGIC & FIXES                         --
--================================================================--

-- Auto Steal Functionality
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoSteal then
            pcall(function()
                -- Scan telur di Workspace
                local eggs = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("EggSpawns") or Workspace
                for _, obj in pairs(eggs:GetDescendants()) do
                    if not Config.AutoSteal then break end
                    
                    local rarityMatch = false
                    local locationMatch = false

                    -- Verification Check
                    local rarityVal = obj:FindFirstChild("Rarity") or obj:GetAttribute("Rarity")
                    local locationVal = obj:FindFirstChild("Location") or obj:GetAttribute("Location") or obj.Parent.Name

                    local eggRarity = rarityVal and (type(rarityVal) == "userdata" and rarityVal.Value or tostring(rarityVal)) or obj.Name
                    local eggLoc = locationVal and (type(locationVal) == "userdata" and locationVal.Value or tostring(locationVal)) or obj.Parent.Name

                    -- Filter Match Check
                    for selectedRarity, active in pairs(Config.SelectedRarities) do
                        if active and string.find(string.lower(eggRarity), string.lower(selectedRarity)) then
                            rarityMatch = true
                            break
                        end
                    end

                    for selectedLoc, active in pairs(Config.SelectedLocations) do
                        if active and string.find(string.lower(eggLoc), string.lower(selectedLoc)) then
                            locationMatch = true
                            break
                        end
                    end

                    -- Executing Teleport & Steal
                    if rarityMatch and locationMatch then
                        local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                        if targetPart and RootPart then
                            -- Teleport to Egg
                            RootPart.CFrame = targetPart.CFrame * CFrame.new(0, 2, 0)
                            
                            -- Trigger Prompt / Interaction
                            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end
end)

-- Speed Boost Logic
RunService.Stepped:Connect(function()
    if Config.SpeedMultiplier and Humanoid then
        Humanoid.WalkSpeed = 80 -- 5x standar Speed (16 * 5)
    elseif not Config.SpeedMultiplier and Humanoid and Humanoid.WalkSpeed == 80 then
        Humanoid.WalkSpeed = 16
    end
end)

-- Real Anti Hit Guard System (Physical & Event Override)
task.spawn(function()
    while task.wait(0.3) do
        if Config.AntiGuard then
            pcall(function()
                for _, npc in pairs(Workspace:GetDescendants()) do
                    if npc:IsA("Model") and (string.find(string.lower(npc.Name), "guard") or npc:FindFirstChild("Humanoid")) and npc ~= Character then
                        for _, part in pairs(npc:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanTouch = false
                                for _, touch in pairs(part:GetChildren()) do
                                    if touch:IsA("TouchTransmitter") then
                                        touch:Destroy()
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Real Anti Trap System
task.spawn(function()
    while task.wait(0.3) do
        if Config.AntiTrap then
            pcall(function()
                for _, trap in pairs(Workspace:GetDescendants()) do
                    if string.find(string.lower(trap.Name), "trap") then
                        if trap:IsA("BasePart") then
                            trap.CanTouch = false
                        elseif trap:IsA("Model") then
                            for _, p in pairs(trap:GetChildren()) do
                                if p:IsA("BasePart") then p.CanTouch = false end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Real Anti Ragdoll System
RunService.Heartbeat:Connect(function()
    if Config.AntiRagdoll and Humanoid then
        local state = Humanoid:GetState()
        if state == Enum.HumanoidStateType.Ragdoll or 
           state == Enum.HumanoidStateType.FallingDown or 
           state == Enum.HumanoidStateType.PlatformStanding then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            if RootPart then
                RootPart.Velocity = Vector3.new(0, 0, 0)
                RootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)
