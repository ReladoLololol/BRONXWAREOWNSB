--// 🛡️ SECURITY BLOCK
local BannedUsers = { 4602636062 }
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

for _, id in pairs(BannedUsers) do
    if LP.UserId == id then LP:Kick("BRONXWARE: Access Denied.") return end
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
if CG:FindFirstChild("BronxWare_V19") then CG.BronxWare_V19:Destroy() end
local SG = Instance.new("ScreenGui", CG); SG.Name = "BronxWare_V19"

--// 🔘 OPEN/CLOSE TOGGLE
local ToggleBtn = Instance.new("TextButton", SG)
ToggleBtn.Size = UDim2.new(0, 60, 0, 60); ToggleBtn.Position = UDim2.new(0, 10, 0.5, -30)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0); ToggleBtn.Text = "BW"; ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

--// TABS HOLDER
local TabHolder = Instance.new("Frame", Main); TabHolder.Size = UDim2.new(1, 0, 0, 45); TabHolder.BackgroundTransparency = 1

--// PAGES
local CombatPage = Instance.new("ScrollingFrame", Main); CombatPage.Size = UDim2.new(1, -20, 1, -110); CombatPage.Position = UDim2.new(0, 10, 0, 60); CombatPage.BackgroundTransparency = 1; CombatPage.Visible = true; CombatPage.CanvasSize = UDim2.new(0, 0, 1.5, 0)
local VisualPage = Instance.new("ScrollingFrame", Main); VisualPage.Size = UDim2.new(1, -20, 1, -110); VisualPage.Position = UDim2.new(0, 10, 0, 60); VisualPage.BackgroundTransparency = 1; VisualPage.Visible = false
local WhitelistPage = Instance.new("ScrollingFrame", Main); WhitelistPage.Size = UDim2.new(1, -20, 1, -110); WhitelistPage.Position = UDim2.new(0, 10, 0, 60); WhitelistPage.BackgroundTransparency = 1; WhitelistPage.Visible = false; WhitelistPage.CanvasSize = UDim2.new(0, 0, 4, 0)

Instance.new("UIListLayout", CombatPage).Padding = UDim.new(0, 10); Instance.new("UIListLayout", VisualPage).Padding = UDim.new(0, 10); Instance.new("UIListLayout", WhitelistPage).Padding = UDim.new(0, 5)

local function MakeTab(name, pos, size, page)
    local b = Instance.new("TextButton", TabHolder); b.Size = size; b.Position = pos; b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() CombatPage.Visible = (page == CombatPage); VisualPage.Visible = (page == VisualPage); WhitelistPage.Visible = (page == WhitelistPage) end)
end

MakeTab("COMBAT", UDim2.new(0.02, 0, 0, 5), UDim2.new(0.3, 0, 1, 0), CombatPage)
MakeTab("VISUALS", UDim2.new(0.35, 0, 0, 5), UDim2.new(0.3, 0, 1, 0), VisualPage)
MakeTab("GANG", UDim2.new(0.68, 0, 0, 5), UDim2.new(0.3, 0, 1, 0), WhitelistPage)

--// WHITELIST REFRESHER
local function UpdateWL()
    for _, item in pairs(WhitelistPage:GetChildren()) do if item:IsA("TextButton") then item:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then
            local b = Instance.new("TextButton", WhitelistPage); b.Size = UDim2.new(1, 0, 0, 32); b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.Text = p.Name .. (_G.WL[p.Name] and " [SAFE]" or ""); b.BackgroundColor3 = _G.WL[p.Name] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30); Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() _G.WL[p.Name] = not _G.WL[p.Name] UpdateWL() end)
        end
    end
end
UpdateWL(); Players.PlayerAdded:Connect(UpdateWL); Players.PlayerRemoving:Connect(UpdateWL)

--// 🔘 FIXED ADJUSTER COMPONENT
local function CreateAdjuster(title, startVal, step, min, max, parent, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 40); frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0); label.Text = title .. ": " .. startVal; label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1; label.Font = Enum.Font.GothamBold; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left

    local minus = Instance.new("TextButton", frame)
    minus.Size = UDim2.new(0, 35, 0, 35); minus.Position = UDim2.new(0.6, 0, 0.1, 0); minus.Text = "-"
    minus.BackgroundColor3 = Color3.fromRGB(45, 25, 25); minus.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", minus)
    
    local plus = Instance.new("TextButton", frame)
    plus.Size = UDim2.new(0, 35, 0, 35); plus.Position = UDim2.new(0.85, 0, 0.1, 0); plus.Text = "+"
    plus.BackgroundColor3 = Color3.fromRGB(25, 45, 25); plus.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", plus)
    
    local val = startVal
    minus.MouseButton1Click:Connect(function() val = math.clamp(val - step, min, max) label.Text = title .. ": " .. string.format("%.2f", val) callback(val) end)
    plus.MouseButton1Click:Connect(function() val = math.clamp(val + step, min, max) label.Text = title .. ": " .. string.format("%.2f", val) callback(val) end)
end

local function QuickBtn(txt, parent, callback)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1, 1, 1); b.Text = txt; b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() callback(b) end)
end

--// COMBAT TAB
QuickBtn("Aim Assist: OFF", CombatPage, function(b) _G.Aim_Enabled = not _G.Aim_Enabled FOVCircle.Visible = _G.Aim_Enabled b.Text = "Aim Assist: " .. (_G.Aim_Enabled and "ON" or "OFF") end)
CreateAdjuster("Smoothness", 0.15, 0.05, 0.05, 1.0, CombatPage, function(v) _G.Aim_Smoothness = v end)
QuickBtn("Hitbox: OFF", CombatPage, function(b) _G.HB_Enabled = not _G.HB_Enabled b.Text = "Hitbox: " .. (_G.HB_Enabled and "ON" or "OFF") end)
CreateAdjuster("HB Size", 10, 2, 2, 35, CombatPage, function(v) _G.HB_Size = v end)

--// VISUALS TAB
QuickBtn("Names/Dist: OFF", VisualPage, function(b) _G.ESP_Name = not _G.ESP_Name b.Text = "Names/Dist: " .. (_G.ESP_Name and "ON" or "OFF") end)
QuickBtn("Inventory: OFF", VisualPage, function(b) _G.ESP_Inv = not _G.ESP_Inv b.Text = "Inventory: " .. (_G.ESP_Inv and "ON" or "OFF") end)
QuickBtn("Highlight ESP: OFF", VisualPage, function(b) _G.ESP_Skel = not _G.ESP_Skel b.Text = "Highlight ESP: " .. (_G.ESP_Skel and "ON" or "OFF") end)

--// ⚔️ ENGINE
RS.RenderStepped:Connect(function()
    pcall(function()
        if _G.Aim_Enabled then
            local target = nil; local shortestDist = _G.Aim_FOV; local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            FOVCircle.Position = Center
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
                
                if _G.HB_Enabled and not safe then
                    t.Size = Vector3.new(_G.HB_Size, _G.HB_Size, _G.HB_Size); t.Transparency = 0.6; t.CanCollide = false; t.Massless = true 
                else
                    t.Size = Vector3.new(2, 2, 1); t.Transparency = 0; t.CanCollide = true; t.Massless = false
                end
                
                if _G.ESP_Name then
                    local tag = hrp:FindFirstChild("BW_N") or Instance.new("BillboardGui", hrp)
                    tag.Name = "BW_N"; tag.AlwaysOnTop = true; tag.Size = UDim2.new(0, 100, 0, 20); tag.StudsOffset = Vector3.new(0, 3, 0)
                    local l = tag:FindFirstChild("L") or Instance.new("TextLabel", tag); l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = safe and Color3.new(0,1,0) or Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.Text = v.Name .. " [" .. math.floor((LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) .. "m]"
                elseif hrp:FindFirstChild("BW_N") then hrp.BW_N:Destroy() end

                if _G.ESP_Inv then
                    local itag = hrp:FindFirstChild("BW_I") or Instance.new("BillboardGui", hrp)
                    itag.Name = "BW_I"; itag.AlwaysOnTop = true; itag.Size = UDim2.new(0, 100, 0, 20); itag.StudsOffset = Vector3.new(0, 1.8, 0)
                    local l = itag:FindFirstChild("L") or Instance.new("TextLabel", itag); l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255, 170, 0); l.Font = Enum.Font.GothamBold; l.Text = (char:FindFirstChildOfClass("Tool") or v.Backpack:FindFirstChildOfClass("Tool") or {Name=""}).Name
                elseif hrp:FindFirstChild("BW_I") then hrp.BW_I:Destroy() end

                if _G.ESP_Skel then
                    local h = char:FindFirstChild("BW_H") or Instance.new("Highlight", char)
                    h.Name = "BW_H"; h.FillTransparency = 0.5; h.FillColor = safe and Color3.new(0,1,0) or Color3.fromRGB(200, 0, 0)
                elseif char:FindFirstChild("BW_H") then char.BW_H:Destroy() end
            end
        end
    end)
end)
