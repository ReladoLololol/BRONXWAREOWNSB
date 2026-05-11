--// 🛡️ SECURITY BLOCK
local BannedUsers = {
    -- Paste UserIDs here (e.g., 4602636062,)
}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Check UserID against Blacklist
for _, id in pairs(BannedUsers) do
    if LP.UserId == id then
        LP:Kick("BRONXWARE: Access Denied. Blacklisted by MegMegpepe.")
        return
    end
end

--// 💪 MAIN SCRIPT START
local RS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- Global State
_G.HB_Enabled = false
_G.HB_Size = 10
_G.Aim_Enabled = false
_G.Aim_Smoothness = 0.15
_G.Aim_FOV = 150
_G.ESP_Name = false
_G.ESP_Inv = false
_G.ESP_Skel = false
_G.WL = {}

--// FOV Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = _G.Aim_FOV
FOVCircle.Visible = false
FOVCircle.Color = Color3.new(1, 1, 1)

--// UI SETUP
local SG = Instance.new("ScreenGui", CG)
SG.Name = "BronxWare_V18"
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 360, 0, 520)
Main.Position = UDim2.new(0.5, -180, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

--// TABS HOLDER
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(1, 0, 0, 45)
-- [Rest of your UI and Script Logic continues here...]
