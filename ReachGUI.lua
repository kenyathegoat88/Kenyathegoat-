local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local currentReach = 1.5
local reachEnabled = true
local minimized = false
local minimizedPosition = UDim2.new(0.9, 0, 0.8, 0)
local expandedPosition = UDim2.new(0.5, -150, 0.5, -75)

-- GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ReachGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = expandedPosition
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.BorderSizePixel = 0
title.Text = "Reach Ajustable (R6)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local label = Instance.new("TextLabel", mainFrame)
label.Position = UDim2.new(0.05, 0, 0.3, 0)
label.Size = UDim2.new(0.9, 0, 0, 20)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.Text = "Reach: " .. currentReach
label.Font = Enum.Font.SourceSans
label.TextSize = 16

local slider = Instance.new("TextBox", mainFrame)
slider.Position = UDim2.new(0.05, 0, 0.5, 0)
slider.Size = UDim2.new(0.9, 0, 0, 30)
slider.Text = tostring(currentReach)
slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
slider.TextColor3 = Color3.new(1, 1, 1)
slider.Font = Enum.Font.SourceSans
slider.TextSize = 18
slider.ClearTextOnFocus = false

local toggle = Instance.new("TextButton", mainFrame)
toggle.Position = UDim2.new(0.05, 0, 0.75, 0)
toggle.Size = UDim2.new(0.4, 0, 0, 30)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Text = "DESACTIVAR"
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 16

local minimize = Instance.new("TextButton", mainFrame)
minimize.Position = UDim2.new(0.55, 0, 0.75, 0)
minimize.Size = UDim2.new(0.4, 0, 0, 30)
minimize.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Text = "MINIMIZAR"
minimize.Font = Enum.Font.SourceSansBold
minimize.TextSize = 16

local minimizedBtn = Instance.new("TextButton", screenGui)
minimizedBtn.Size = UDim2.new(0, 60, 0, 40)
minimizedBtn.Position = minimizedPosition
minimizedBtn.AnchorPoint = Vector2.new(0.5, 0.5)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
minimizedBtn.Text = "R"
minimizedBtn.TextColor3 = Color3.new(1, 1, 1)
minimizedBtn.Font = Enum.Font.SourceSansBold
minimizedBtn.TextSize = 20
minimizedBtn.Visible = false

-- FUNCIONES
local function createHitboxForLeg(leg)
    if not leg then return end

    local existing = leg:FindFirstChild("ReachHitbox")
    if existing then existing:Destroy() end

    local part = Instance.new("Part")
    part.Name = "ReachHitbox"
    part.Size = Vector3.new(1 * currentReach, 1.5 * currentReach, 1 * currentReach)
    part.Transparency = 1
    part.Anchored = false
    part.CanCollide = false
    part.CanTouch = true
    part.Massless = true
    part.Parent = leg

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = leg
    weld.Part1 = part
    weld.Parent = part
    part.CFrame = leg.CFrame

    part.Touched:Connect(function(hit)
        if not hit:IsDescendantOf(Players.LocalPlayer.Character) then
            print("Tocado:", hit.Name)
        end
    end)
end

local function updateHitboxes()
    local char = player.Character
    if not char then return end
    if not reachEnabled then
        for _, limb in ipairs({"Right Leg", "Left Leg"}) do
            local leg = char:FindFirstChild(limb)
            if leg then
                local h = leg:FindFirstChild("ReachHitbox")
                if h then h:Destroy() end
            end
        end
        return
    end

    for _, limb in ipairs({"Right Leg", "Left Leg"}) do
        local leg = char:FindFirstChild(limb)
        if leg then
            createHitboxForLeg(leg)
        end
    end
end

-- EVENTOS GUI
slider.FocusLost:Connect(function()
    local val = tonumber(slider.Text)
    if val and val >= 1 and val <= 3 then
        currentReach = val
        label.Text = "Reach: " .. val
        updateHitboxes()
    else
        slider.Text = tostring(currentReach)
    end
end)

toggle.MouseButton1Click:Connect(function()
    reachEnabled = not reachEnabled
    toggle.Text = reachEnabled and "DESACTIVAR" or "ACTIVAR"
    updateHitboxes()
end)

minimize.MouseButton1Click:Connect(function()
    minimized = true
    minimizedBtn.Visible = true
    mainFrame.Visible = false
end)

minimizedBtn.MouseButton1Click:Connect(function()
    minimized = false
    minimizedBtn.Visible = false
    mainFrame.Visible = true
end)

-- MOBILE SUPPORT
if UserInputService.TouchEnabled then
    mainFrame.Draggable = false
    toggle.Size = UDim2.new(0.4, 0, 0, 40)
    minimize.Size = UDim2.new(0.4, 0, 0, 40)
    minimizedBtn.Size = UDim2.new(0, 70, 0, 50)
end

-- ACTUALIZAR HITBOX CUANDO APARECE
player.CharacterAdded:Connect(updateHitboxes)
if player.Character then updateHitboxes() end
