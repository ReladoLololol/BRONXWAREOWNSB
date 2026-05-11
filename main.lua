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

--// UI SETUP
if CG:FindFirstChild("BronxWare_V18") then CG.BronxWare_V18:Destroy() end

local SG = Instance.new("ScreenGui", CG)
SG.Name = "BronxWare_V18"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Text = "BRONXWARE V18 - BY MEGMEGPEPE"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 18

--// BUTTON: HITBOX
local HBBtn = Instance.new("TextButton", Main)
HBBtn.Text = "Toggle Hitbox (OFF)"
HBBtn.Size = UDim2.new(0.8, 0, 0, 40)
HBBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
HBBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HBBtn.TextColor3 = Color3.new(1, 1, 1)

HBBtn.MouseButton1Click:Connect(function()
    _G.HB_Enabled = not _G.HB_Enabled
    HBBtn.Text = _G.HB_Enabled and "Toggle Hitbox (ON)" or "Toggle Hitbox (OFF)"
end)

--// HITBOX LOOP
RS.RenderStepped:Connect(function()
    if _G.HB_Enabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(_G.HB_Size, _G.HB_Size, _G.HB_Size)
                v.Character.HumanoidRootPart.Transparency = 0.7
                v.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

print("BronxWare V18 Loaded Successfully!")
