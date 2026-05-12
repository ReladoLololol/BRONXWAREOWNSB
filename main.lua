--// 🛡️ SECURITY BLOCK
local BannedUsers = { 8492484071 }
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

--// 🎯 FOV Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = _G.Aim_FOV
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(150, 150, 150)
FOVCircle.Transparency = 0.5

--// UI SETUP
if CG:FindFirstChild("BronxWare_V28") then CG.BronxWare_V28:Destroy() end
local SG = Instance.new("ScreenGui", CG); SG.Name = "BronxWare_V28"

--// 🔘 JESUS TOGGLE
local ToggleBtn = Instance.new("TextButton", SG)
ToggleBtn.Size = UDim2.new(0, 70, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0.5, -17)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); ToggleBtn.Text = "JESUS"; ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", ToggleBtn)

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true; Instance.new("UICorner", Main)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

--// TABS & PAGES
local TabHolder = Instance.new("Frame", Main); TabHolder.Size = UDim2.new(1, 0, 0, 45); TabHolder.BackgroundTransparency = 1
local CombatPage = Instance.new("ScrollingFrame", Main); CombatPage.Size = UDim2.new(1, -20, 1, -110); CombatPage.Position = UDim2.new(0, 10, 0, 60); CombatPage.BackgroundTransparency = 1; CombatPage.Visible = true; CombatPage.CanvasSize = UDim2.new(0, 0, 1.5, 0)
local VisualPage = Instance.new("ScrollingFrame", Main); VisualPage.Size = UDim2.new(1, -20, 1, -110); VisualPage.Position = UDim2.new(0, 10, 0, 60); VisualPage.BackgroundTransparency = 1; VisualPage.Visible = false
local WhitelistPage = Instance.new("ScrollingFrame", Main); WhitelistPage.Size = UDim2.new(1, -20, 1, -110); WhitelistPage.Position = UDim2.new(0, 10, 0, 60); WhitelistPage.BackgroundTransparency = 1; WhitelistPage.Visible = false

local layouts = {CombatPage, VisualPage, WhitelistPage}
for _, page in pairs(layouts) do 
    local l = Instance.new("UIListLayout", page); l.Padding = UDim.new(0, 8) 
end

local function MakeTab(name, pos, size, page)
    local b = Instance.new("TextButton", TabHolder); b.Size = size; b.Position = pos; b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() CombatPage.Visible = false; VisualPage.Visible = false; WhitelistPage.Visible = false; page.Visible = true end)
end

MakeTab("CMBT", UDim2.new(0.05, 0, 0, 5), UDim2.new(0.28, 0, 1, 0), CombatPage)
MakeTab("VIS", UDim2.new(0.36, 0, 0, 5), UDim2.new(0.28, 0, 1, 0), VisualPage)
MakeTab("GANG", UDim2.new(0.67, 0, 0, 5), UDim2.new(0.28, 0, 1, 0), WhitelistPage)

--// WHITELIST REFRESH LOGIC
local function RefreshWL()
    for _, item in pairs(WhitelistPage:GetChildren()) do if item:IsA("TextButton") then item:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then
            local b = Instance.new("TextButton", WhitelistPage); b.Size = UDim2.new(1, 0, 0, 32); b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.Text = p.Name .. (_G.WL[p.Name] and " [GANG]" or ""); b.BackgroundColor3 = _G.WL[p.Name] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30); Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() _G.WL[p.Name] = not _G.WL[p.Name] RefreshWL() end)
        end
    end
end
Players.PlayerAdded:Connect(RefreshWL); Players.PlayerRemoving:Connect(RefreshWL); RefreshWL()

--// 🔘 COMPONENTS
local function QuickBtn(txt, parent, callback)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1, 1, 1); b.Text = txt; b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() callback(b) end)
end

local function CreateAdjuster(title, startVal, step, min, max, parent, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 40); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.5, 0, 1, 0); l.Text = title..": "..startVal; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.Font = Enum.Font.GothamBold
    local m = Instance.new("TextButton", f); m.Size = UDim2.new(0, 35, 0, 35); m.Position = UDim2.new(0.6,0,0,0); m.Text = "-"; m.BackgroundColor3 = Color3.fromRGB(45,25,25); m.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", m)
    local p = Instance.new("TextButton", f); p.Size = UDim2.new(0, 35, 0, 35); p.Position = UDim2.new(0.85,0,0,0); p.Text = "+"; p.BackgroundColor3 = Color3.fromRGB(25,45,25); p.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", p)
    local cur = startVal
    m.MouseButton1Click:Connect(function() cur = math.clamp(cur - step, min, max); l.Text = title..": "..string.format("%.2f", cur); callback(cur) end)
    p.MouseButton1Click:Connect(function() cur = math.clamp(cur + step, min, max); l.Text = title..": "..string.format("%.2f", cur); callback(cur) end)
end

--// COMBAT
QuickBtn("Aim Assist: OFF", CombatPage, function(b) _G.Aim_Enabled = not _G.Aim_Enabled; FOVCircle.Visible = _G.Aim_Enabled; b.Text = "Aim Assist: "..( _G.Aim_Enabled and "ON" or "OFF") end)
CreateAdjuster("Smooth", 0.15, 0.05, 0.05, 1.0, CombatPage, function(v) _G.Aim_Smoothness = v end)
QuickBtn("Hitbox: OFF", CombatPage, function(b) _G.HB_Enabled = not _G.HB_Enabled; b.Text = "Hitbox: "..( _G.HB_Enabled and "ON" or "OFF") end)
CreateAdjuster("Size", 10, 2, 2, 35, CombatPage, function(v) _G.HB_Size = v end)

--// VISUALS
QuickBtn("Name/Dist: OFF", VisualPage, function(b) _G.ESP_Name = not _G.ESP_Name; b.Text = "Name/Dist: "..( _G.ESP_Name and "ON" or "OFF") end)
QuickBtn("Inventory: OFF", VisualPage, function(b) _G.ESP_Inv = not _G.ESP_Inv; b.Text = "Inventory: "..( _G.ESP_Inv and "ON" or "OFF") end)
QuickBtn("Highlight: OFF", VisualPage, function(b) _G.ESP_Skel = not _G.ESP_Skel; b.Text = "Highlight: "..( _G.ESP_Skel and "ON" or "OFF") end)

--// ⚔️ ENGINE
RS.RenderStepped:Connect(function()
    pcall(function()
        local Center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        if _G.Aim_Enabled then
            FOVCircle.Position = Center; local target = nil; local dist = _G.Aim_FOV
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 and not _G.WL[v.Name] then
                    local p, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if vis then
                        local m = (Vector2.new(p.X, p.Y) - Center).Magnitude
                        if m < dist then target = v.Character.HumanoidRootPart; dist = m end
                    end
                end
            end
            if target then 
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), _G.Aim_Smoothness) 
                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LP.Character.HumanoidRootPart
                    hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)), _G.Aim_Smoothness)
                end
            end
        end

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local char = v.Character; local hrp = char.HumanoidRootPart; local isWL = _G.WL[v.Name]
                local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or hrp
                
                -- Hitbox
                if _G.HB_Enabled and not isWL then
                    torso.Size = Vector3.new(_G.HB_Size, _G.HB_Size, _G.HB_Size); torso.Transparency = 0.6; torso.CanCollide = false; torso.Massless = true
                else
                    torso.Size = Vector3.new(2, 2, 1); torso.Transparency = 0; torso.CanCollide = true; torso.Massless = false
                end

                -- ESP Name & Distance
                if _G.ESP_Name then
                    local tag = hrp:FindFirstChild("BW_HUD") or Instance.new("BillboardGui", hrp)
                    tag.Name = "BW_HUD"; tag.AlwaysOnTop = true; tag.Size = UDim2.new(0, 200, 0, 50); tag.StudsOffset = Vector3.new(0, 3, 0)
                    local l = tag:FindFirstChild("Main") or Instance.new("TextLabel", tag)
                    l.Name = "Main"; l.Size = UDim2.new(1,0,0,20); l.BackgroundTransparency = 1; l.TextColor3 = isWL and Color3.new(0,1,0) or Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.TextSize = 13
                    local d = math.floor((LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    l.Text = string.format("%s [%dm]", v.Name, d)
                elseif hrp:FindFirstChild("BW_HUD") then hrp.BW_HUD:Destroy() end

                -- ESP Inventory
                if _G.ESP_Inv then
                    local invTag = hrp:FindFirstChild("BW_INV") or Instance.new("BillboardGui", hrp)
                    invTag.Name = "BW_INV"; invTag.AlwaysOnTop = true; invTag.Size = UDim2.new(0, 200, 0, 100); invTag.StudsOffset = Vector3.new(0, -1.5, 0)
                    local container = invTag:FindFirstChild("List") or Instance.new("Frame", invTag)
                    container.Name = "List"; container.Size = UDim2.new(1,0,1,0); container.BackgroundTransparency = 1
                    local layout = container:FindFirstChild("UIListLayout") or Instance.new("UIListLayout", container)
                    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.SortOrder = Enum.SortOrder.LayoutOrder

                    for _, old in pairs(container:GetChildren()) do if old:IsA("TextLabel") then old:Destroy() end end
                    
                    local equipped = char:FindFirstChildOfClass("Tool")
                    local bp = v:FindFirstChild("Backpack")
                    if bp then
                        for _, item in pairs(bp:GetChildren()) do
                            local il = Instance.new("TextLabel", container)
                            il.Size = UDim2.new(1,0,0,14); il.BackgroundTransparency = 1; il.TextColor3 = Color3.new(0.8, 0.8, 0.8); il.Font = Enum.Font.Gotham; il.TextSize = 11; il.Text = item.Name
                        end
                    end
                    if equipped then
                        local el = Instance.new("TextLabel", container)
                        el.Size = UDim2.new(1,0,0,14); el.BackgroundTransparency = 1; el.TextColor3 = Color3.new(1, 0.2, 0.2); el.Font = Enum.Font.GothamBold; el.TextSize = 11; el.Text = equipped.Name .. " (EQ)"; el.LayoutOrder = -1
                    end
                elseif hrp:FindFirstChild("BW_INV") then hrp.BW_INV:Destroy() end

                -- Highlight
                if _G.ESP_Skel then
                    local h = char:FindFirstChild("BW_H") or Instance.new("Highlight", char)
                    h.Name = "BW_H"; h.FillTransparency = 0.5; h.FillColor = isWL and Color3.new(0,1,0) or Color3.fromRGB(200, 0, 0)
                elseif char:FindFirstChild("BW_H") then char.BW_H:Destroy() end
            end
        end
    end)
end)
