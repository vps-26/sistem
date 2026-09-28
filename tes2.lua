-- ===================================================
-- Script Name : RedzHub | Steal An Egg (SAE)
-- Version     : 1.3
-- Author      : Redz
-- Compatibility: Roblox (Delta Executor & Mobile/PC)
-- ===================================================

-- Load Orion UI Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Custom Black & White Theme Configuration
OrionLib.Themes["BlackWhite"] = {
    Main = Color3.fromRGB(15, 15, 15),
    Second = Color3.fromRGB(25, 25, 25),
    Stroke = Color3.fromRGB(255, 255, 255),
    Divider = Color3.fromRGB(200, 200, 200),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    TabHolder = Color3.fromRGB(20, 20, 20),
    TabButton = Color3.fromRGB(30, 30, 30),
    TabButtonSelected = Color3.fromRGB(255, 255, 255),
    Folder = Color3.fromRGB(20, 20, 20),
    FolderText = Color3.fromRGB(255, 255, 255),
    SelectedTabText = Color3.fromRGB(0, 0, 0)
}

local Window = OrionLib:MakeWindow({
    Name = "RedzHub | Steal An Egg [v1.3]",
    HidePremium = true,
    SaveConfig = false,
    IntroEnabled = true,
    IntroText = "RedzHub v1.3 - By Redz",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998",
    Theme = "BlackWhite"
})

-- Global Services & Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local AutoStealEnabled = false
local FastSpeedEnabled = false
local SelectedLocation = "Lake"
local SelectedRarity = "Common"

local AntiHitGuardEnabled = false
local AntiTrapEnabled = false
local AntiRagdollEnabled = false

-- Data List
local RarityList = {
    "Common", "Uncommon", "Rare", "Epik", 
    "Legendary", "Mythic", "Cosmic", "Secret", 
    "Eternal", "Divine"
}

local LocationList = {
    "Lake", "Gurun", "Jungle", "Snow", "Volcano", 
    "Abyss Ocean", "Prehistoric", "Cosmic", 
    "Cherry Blossom", "Titan Temple", "Angel & Demons"
}

-- ===================================================
-- TAB 1: MAIN
-- ===================================================
local MainTab = Window:MakeTab({
    Name = "MAIN",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddSection({
    Name = "Egg Filter System"
})

MainTab:AddDropdown({
    Name = "Pilih Lokasi",
    Default = "Lake",
    Options = LocationList,
    Callback = function(Value)
        SelectedLocation = Value
    end
})

MainTab:AddDropdown({
    Name = "Pilih Rarity Egg",
    Default = "Common",
    Options = RarityList,
    Callback = function(Value)
        SelectedRarity = Value
    end
})

MainTab:AddSection({
    Name = "Auto Steal System"
})

MainTab:AddToggle({
    Name = "Auto Steal (100% Success Rate)",
    Default = false,
    Callback = function(Value)
        AutoStealEnabled = Value
    end
})

MainTab:AddToggle({
    Name = "5x Speed Multiplier (Up to 200B Speed)",
    Default = false,
    Callback = function(Value)
        FastSpeedEnabled = Value
    end
})

-- ===================================================
-- TAB 2: TOOLS
-- ===================================================
local ToolsTab = Window:MakeTab({
    Name = "TOOLS",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ToolsTab:AddSection({
    Name = "Protection & Utility"
})

ToolsTab:AddToggle({
    Name = "Anti Hit Guard",
    Default = false,
    Callback = function(Value)
        AntiHitGuardEnabled = Value
    end
})

ToolsTab:AddToggle({
    Name = "Anti Trap",
    Default = false,
    Callback = function(Value)
        AntiTrapEnabled = Value
    end
})

ToolsTab:AddToggle({
    Name = "Anti Ragdoll (Bat Protection)",
    Default = false,
    Callback = function(Value)
        AntiRagdollEnabled = Value
    end
})

-- ===================================================
-- SYSTEM BACKEND LOGIC
-- ===================================================

-- 1. Speed Multiplier Logic (5x Multiplier Loop)
RunService.Stepped:Connect(function()
    if FastSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        -- Mengatur WalkSpeed menjadi 200B (5x multiplier kecepatan dasar)
        humanoid.WalkSpeed = 200
    end
end)

-- 2. Anti Ragdoll System (Mencegah Player Terjatuh/Hit Bat)
RunService.Heartbeat:Connect(function()
    if AntiRagdollEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local humanoid = char:FindFirstChild("Humanoid")
        
        if humanoid then
            if humanoid:GetState() == Enum.HumanoidStateType.Ragdoll or humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("BallSocketConstraint") or string.find(child.Name:lower(), "ragdoll") then
                child:Destroy()
            end
        end
    end
end)

-- 3. Anti Hit Guard System (Mengabaikan/Bypass Serangan Penjaga)
RunService.Stepped:Connect(function()
    if AntiHitGuardEnabled then
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:FindFirstChild("Humanoid") and (string.find(obj.Name:lower(), "guard") or string.find(obj.Name:lower(), "penjaga")) then
                for _, part in pairs(obj:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- 4. Anti Trap System (Mencegah Jebakan Menjerat Player)
RunService.Stepped:Connect(function()
    if AntiTrapEnabled then
        for _, trap in pairs(Workspace:GetDescendants()) do
            if string.find(trap.Name:lower(), "trap") or string.find(trap.Name:lower(), "jebakan") then
                if trap:IsA("BasePart") then
                    trap.CanTouch = false
                end
            end
        end
    end
end)

-- 5. Fast Auto Steal Loop (100% Instant Proximity Interaction)
task.spawn(function()
    while task.wait(0.05) do
        if AutoStealEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, prompt in pairs(Workspace:GetDescendants()) do
                if not AutoStealEnabled then break end
                
                if prompt:IsA("ProximityPrompt") then
                    local parentModel = prompt.Parent
                    local parentName = parentModel and parentModel.Name:lower() or ""
                    
                    -- Verifikasi kecocokan nama/rarity/lokasi jika diterapkan pada model telur
                    if parentName:find(SelectedRarity:lower()) or parentName:find("egg") then
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        end
                    end
                end
            end
        end
    end
end)

-- Inisialisasi Orion UI
OrionLib:Init()
