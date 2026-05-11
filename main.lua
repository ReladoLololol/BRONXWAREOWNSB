--// 🛡️ SECURITY BLOCK
local BannedUsers = {
    4602636062, -- Scammer ID added here
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

--// 🦾 MAIN SCRIPT START
local RS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

--// Global State
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
TabHolder.BackgroundTransparency = 1

--// PAGES
local CombatPage = Instance.new("ScrollingFrame", Main)
CombatPage.Size = UDim2.new(1, -20, 1, -110)
CombatPage.Position = UDim2.new(0, 10, 0, 60)
CombatPage.BackgroundTransparency = 1
CombatPage.Visible = true
CombatPage.CanvasSize = UDim2.new(0, 0, 2, 0)
Instance.new("UIListLayout", CombatPage).Padding = UDim.new(0, 8)

local VisualPage = Instance.new("ScrollingFrame", Main)
VisualPage.Size = UDim2.new(1, -20, 1, -110)
VisualPage.Position = UDim2.new(0, 10, 0, 60)
VisualPage.BackgroundTransparency = 1
VisualPage.Visible = false
Instance.new("UIListLayout", VisualPage).Padding = UDim.new(0, 8)

local CreditPage = Instance.new("Frame", Main)
CreditPage.Size = UDim2.new(1, -20, 1, -110)
CreditPage.Position = UDim2.new(0, 10, 0, 60)
CreditPage.BackgroundTransparency = 1
CreditPage.Visible = false

--// TAB CREATOR
local function MakeTab(name, pos, size, page)
    local b = Instance.new("TextButton", TabHolder)
    b.Size = size; b.Position = pos; b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        CombatPage.Visible = (page == CombatPage)
        VisualPage.Visible = (page == VisualPage)
        CreditPage.Visible = (page == CreditPage)
    end)
end

MakeTab("COMBAT", UDim2.new(0, 5, 0, 5), UDim2.new(0.31, 0, 1, 0), CombatPage)
MakeTab("VISUALS", UDim2.new(0.34, 5, 0, 5), UDim2.new(0.31, 0, 1, 0), VisualPage)
MakeTab("CREDITS", UDim2.new(0.67, 5, 0, 5), UDim2.new(0.31, 0, 1, 0), CreditPage)

--// ADJUSTER COMPONENT [-] [+]
local function CreateAdjuster(title, startVal, step, min, max, parent, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 45); frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.4, 0, 1, 0); label.Text = title .. ": " .. startVal
    label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1; label.Font = Enum.Font.GothamBold; label.TextSize = 12
    local minus = Instance.new("TextButton", frame)
    minus.Size = UDim2.new(0.2, -5, 1, 0); minus.Position = UDim2.new(0.4, 0, 0, 0); minus.Text = "-"
    minus.BackgroundColor3 = Color3.fromRGB(45, 25, 25); minus.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", minus)
    local plus = Instance.new("TextButton", frame)
    plus.Size = UDim2.new(0.2, -5, 1, 0); plus.Position = UDim2.new(0.6, 5, 0, 0); plus.Text = "+"
    plus.BackgroundColor3 = Color3.fromRGB(25, 45, 25); plus.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", plus)
    local val = startVal
    minus.MouseButton1Click:Connect(function() val = math.clamp(val - step, min, max) label.Text = title .. ": " .. string.format("%.2f", val) callback(val) end)
    plus.MouseButton1Click:Connect(function() val = math.clamp(val + step, min, max) label.Text = title .. ": " .. string.format("%.2f", val) callback(val) end)
end

local function QuickBtn(txt, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1, 1, 1); b.Text = txt; b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() callback(b) end)
end

--// COMBAT PAGE
QuickBtn("Aim Assist: OFF", CombatPage, function(b) 
    _G.Aim_Enabled = not _G.Aim_Enabled; FOVCircle.Visible = _G.Aim_Enabled; b.Text = "Aim Assist: " .. (_G.Aim_Enabled and "ON" or "OFF") 
end)
CreateAdjuster("Smooth", 0.15, 0.05, 0.05, 1.0, CombatPage, function(v) _G.Aim_Smoothness = v end)
QuickBtn("Hitbox: OFF", CombatPage, function(b) 
    _G.HB_Enabled = not _G.HB_Enabled; b.Text = "Hitbox: " .. (_G.HB_Enabled and "ON" or "OFF") 
end)
CreateAdjuster("Size", 10, 2, 2, 35, CombatPage, function(v) _G.HB_Size = v end)

--// VISUALS PAGE
QuickBtn("Name/Dist ESP: OFF", VisualPage, function(b) 
    _G.ESP_Name = not _G.ESP_Name; b.Text = "Name/Dist ESP: " .. (_G.ESP_Name and "ON" or "OFF") 
end)
QuickBtn("Inventory ESP: OFF", VisualPage, function(b) 
    _G.ESP_Inv = not _G.ESP_Inv; b.Text = "Inventory ESP: " .. (_G.ESP_Inv and "ON" or "OFF") 
end)
QuickBtn("Skeleton ESP: OFF", VisualPage, function(b) 
    _G.ESP_Skel = not _G.ESP_Skel; b.Text = "Skeleton ESP: " .. (_G.ESP_Skel and "ON" or "OFF") 
end)

--// CREDITS & KILL SWITCH
local OwnerLabel = Instance.new("TextLabel", CreditPage)
OwnerLabel.Size = UDim2.new(1, 0, 0, 50); OwnerLabel.Position = UDim2.new(0, 0, 0.3, 0)
OwnerLabel.Text = "- Owner of the script: MegMegpepe -"; OwnerLabel.TextColor3 = Color3.new(1, 1, 1); OwnerLabel.Font = Enum.Font.GothamBold; OwnerLabel.TextSize = 16; OwnerLabel.BackgroundTransparency = 1
local KillBtn = Instance.new("TextButton", CreditPage)
KillBtn.Size = UDim2.new(0.8, 0, 0, 45); KillBtn.Position = UDim2.new(0.1, 0, 0.6, 0); KillBtn.Text = "DESTROY SCRIPT"
KillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); KillBtn.TextColor3 = Color3.new(1,1,1); KillBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", KillBtn)
KillBtn.MouseButton1Click:Connect(function() _G.HB_Enabled = false; _G.Aim_Enabled = false; _G.ESP_Name = false; _G.ESP_Inv = false; _G.ESP_Skel = false; FOVCircle:Remove(); SG:Destroy() end)

--// ENGINE
RS.RenderStepped:Connect(function()
    pcall(function()
        local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        if _G.Aim_Enabled then
            FOVCircle.Position = Center; local target = nil; local shortestDist = _G.Aim_FOV
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 and not _G.WL[v.Name] then
                    local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - Center).Magnitude
                        if dist < shortestDist then target = v.Character.HumanoidRootPart shortestDist = dist end
                    end
                end
            end
            if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), _G.Aim_Smoothness) end
        end
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local char = v.Character; local hrp = char.HumanoidRootPart; local safe = _G.WL[v.Name]
                local t = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or hrp
                if _G.HB_Enabled and not safe then t.Size = Vector3.new(_G.HB_Size, _G.HB_Size, _G.HB_Size); t.Transparency = 0.6; t.CanCollide = false else t.Size = Vector3.new(2, 2, 1); t.Transparency = 0 end
                
                -- ESP Sync Logic
                if _G.ESP_Name then
                    local tag = hrp:FindFirstChild("BW_N") or Instance.new("BillboardGui", hrp)
                    tag.Name = "BW_N"; tag.AlwaysOnTop = true; tag.Size = UDim2.new(0, 100, 0, 20); tag.StudsOffset = Vector3.new(0, 3, 0)
                    local l = tag:FindFirstChild("L") or Instance.new("TextLabel", tag); l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = safe and Color3.new(0,1,0) or Color3.new(1,1,1)
                    l.Text = v.Name .. " [" .. math.floor((LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) .. "m]"
                elseif hrp:FindFirstChild("BW_N") then hrp.BW_N:Destroy() end
                
                if _G.ESP_Inv then
                    local itag = hrp:FindFirstChild("BW_I") or Instance.new("BillboardGui", hrp)
                    itag.Name = "BW_I"; itag.AlwaysOnTop = true; itag.Size = UDim2.new(0, 100, 0, 20); itag.StudsOffset = Vector3.new(0, -3, 0)
                    local l = itag:FindFirstChild("L") or Instance.new("TextLabel", itag); l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1, 0.7, 0)
                    local tool = char:FindFirstChildOfClass("Tool"); l.Text = tool and "[" .. tool.Name .. "]" or "[No Tool]"
                elseif hrp:FindFirstChild("BW_I") then hrp.BW_I:Destroy() end
                
                if _G.ESP_Skel then
                    local h = char:FindFirstChild("BW_S") or Instance.new("Highlight", char)
                    h.Name = "BW_S"; h.FillTransparency = 1; h.OutlineColor = safe and Color3.new(0,1,0) or Color3.new(1,1,1)
                elseif char:FindFirstChild("BW_S") then char.BW_S:Destroy() end
            end
        end
    end)
end)
