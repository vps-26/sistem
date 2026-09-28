-- Nama   : RedzHub
-- Versi  : 1.3
-- Author : Redz

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RedzHub v1.3 | Steal An Egg",
   LoadingTitle = "RedzHub by Redz",
   LoadingSubtitle = "Loading Scripts...",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

-- Variabel Global
local SelectedRarity = "Secret"
local SelectedLocation = "Cosmic"
local AutoStealEnabled = false
local AntiGuardEnabled = false
local AntiTrapEnabled = false
local AntiRagdollEnabled = false
local OriginalSpeed = 40 -- Asumsi base speed game 40B

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Data Filter
local Rarities = {"Common", "Uncommon", "Rare", "Epik", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine"}
local Locations = {"Lake", "Gurun", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Angel & Demons"}

-- Membuat Tab
local MainTab = Window:CreateTab("MAIN", 4483362458)
local ToolsTab = Window:CreateTab("TOOLS", 4483362458)

-- ==========================================
-- TAB MAIN: AUTO STEAL & EGG FILTER
-- ==========================================

MainTab:CreateDropdown({
   Name = "Filter Lokasi",
   Options = Locations,
   CurrentOption = {"Cosmic"},
   MultipleOptions = false,
   Flag = "LocationFilter",
   Callback = function(Option)
      SelectedLocation = Option[1]
   end,
})

MainTab:CreateDropdown({
   Name = "Filter Rarity",
   Options = Rarities,
   CurrentOption = {"Secret"},
   MultipleOptions = false,
   Flag = "RarityFilter",
   Callback = function(Option)
      SelectedRarity = Option[1]
   end,
})

MainTab:CreateToggle({
   Name = "Auto Steal",
   CurrentValue = false,
   Flag = "AutoSteal",
   Callback = function(Value)
      AutoStealEnabled = Value
      
      -- Sistem Penggandaan Kecepatan (5x Lipat)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         if Value then
            OriginalSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
            LocalPlayer.Character.Humanoid.WalkSpeed = OriginalSpeed * 5 -- Contoh: 40B -> 200B
         else
            LocalPlayer.Character.Humanoid.WalkSpeed = OriginalSpeed -- Reset ke normal saat dimatikan
         end
      end
   end,
})

-- ==========================================
-- TAB TOOLS: ANTI FITUR
-- ==========================================

ToolsTab:CreateToggle({
   Name = "Anti Hit Guard",
   CurrentValue = false,
   Flag = "AntiGuard",
   Callback = function(Value)
      AntiGuardEnabled = Value
   end,
})

ToolsTab:CreateToggle({
   Name = "Anti Trap",
   CurrentValue = false,
   Flag = "AntiTrap",
   Callback = function(Value)
      AntiTrapEnabled = Value
   end,
})

ToolsTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Flag = "AntiRagdoll",
   Callback = function(Value)
      AntiRagdollEnabled = Value
      
      -- Bypass State Ragdoll pada Humanoid
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not Value)
         LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not Value)
      end
   end,
})

-- ==========================================
-- LOGIKA UTAMA (BACKGROUND LOOP)
-- ==========================================

RunService.RenderStepped:Connect(function()
    -- 1. Logika Auto Steal (Teleportasi & Claim)
    if AutoStealEnabled then
        pcall(function()
            -- Asumsi struktur Workspace game, mencari folder berdasarkan Lokasi
            local locationFolder = workspace:FindFirstChild(SelectedLocation)
            
            if locationFolder then
                for _, egg in pairs(locationFolder:GetDescendants()) do
                    -- Mencari telur dengan nama Rarity yang sesuai
                    if (egg:IsA("Part") or egg:IsA("MeshPart") or egg:IsA("Model")) and egg.Name == SelectedRarity then
                        local targetPart = egg:IsA("Model") and egg.PrimaryPart or egg
                        
                        if targetPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Teleportasi langsung ke telur
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame
                            
                            -- Memicu sistem claim/ambil telur secara instan
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, targetPart, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, targetPart, 1)
                        end
                    end
                end
            end
        end)
    end

    -- 2. Logika Anti Hit Guard
    if AntiGuardEnabled then
        pcall(function()
            -- Mematikan fungsi sentuh (hitbox) pada Guard agar tidak bisa memukul
            for _, guard in pairs(workspace:GetDescendants()) do
                if guard:IsA("Model") and guard.Name:lower():match("guard") then
                    for _, part in pairs(guard:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanTouch == true then
                            part.CanTouch = false
                        end
                    end
                end
            end
        end)
    end

    -- 3. Logika Anti Trap
    if AntiTrapEnabled then
        pcall(function()
            -- Mematikan fungsi sentuh pada Trap pemain lain
            for _, trap in pairs(workspace:GetDescendants()) do
                if trap:IsA("Model") and trap.Name:lower():match("trap") then
                    for _, part in pairs(trap:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanTouch == true then
                            part.CanTouch = false
                        end
                    end
                end
            end
        end)
    end
end)
