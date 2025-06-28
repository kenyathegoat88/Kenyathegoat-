local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuración inicial
local currentReach = 1.5  -- Valor por defecto
local reachEnabled = true
local guiVisible = true
local minimized = false
local minimizedPosition = UDim2.new(0.8, 0, 0.7, 0)  -- Posición cuando está minimizado
local expandedPosition = UDim2.new(0.5, -150, 0.5, -75)  -- Posición normal centrada

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ReachGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = expandedPosition
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.BorderSizePixel = 0
title.Text = "Ajuste de Reach R6"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local sliderContainer = Instance.new("Frame")
sliderContainer.Name = "SliderContainer"
sliderContainer.Size = UDim2.new(0.9, 0, 0, 40)
sliderContainer.Position = UDim2.new(0.05, 0, 0.3, 0)
sliderContainer.BackgroundTransparency = 1

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Name = "SliderLabel"
sliderLabel.Size = UDim2.new(1, 0, 0, 20)
sliderLabel.Position = UDim2.new(0, 0, 0, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Multiplicador de Reach: "..currentReach
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.TextSize = 16

local slider = Instance.new("SliderGui")
slider.Name = "ReachSlider"
slider.Size = UDim2.new(1, 0, 0, 20)
slider.Position = UDim2.new(0, 0, 0, 20)
slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
slider.BorderSizePixel = 0
slider.MinValue = 1.0
slider.MaxValue = 3.0
slider.Value = currentReach

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new((currentReach - 1) / 2, 0, 1, 0)
sliderFill.Position = UDim2.new(0, 0, 0, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0

sliderFill.Parent = slider
slider.Parent = sliderContainer

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.4, 0, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0.7, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "DESACTIVAR"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0.4, 0, 0, 30)
minimizeButton.Position = UDim2.new(0.55, 0, 0.7, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "MINIMIZAR"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 16

local minimizedButton = Instance.new("TextButton")
minimizedButton.Name = "MinimizedButton"
minimizedButton.Size = UDim2.new(0, 60, 0, 40)
minimizedButton.Position = minimizedPosition
minimizedButton.AnchorPoint = Vector2.new(0.5, 0.5)
minimizedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
minimizedButton.BorderSizePixel = 0
minimizedButton.Text = "R"
minimizedButton.TextColor3 = Color3.new(1, 1, 1)
minimizedButton.Font = Enum.Font.SourceSansBold
minimizedButton.TextSize = 20
minimizedButton.Visible = false

-- Jerarquía de objetos
sliderLabel.Parent = sliderContainer
sliderContainer.Parent = mainFrame
title.Parent = mainFrame
toggleButton.Parent = mainFrame
minimizeButton.Parent = mainFrame
mainFrame.Parent = screenGui
minimizedButton.Parent = screenGui
screenGui.Parent = playerGui

-- Funciones
local function updateCharacterReach(character)
    if reachEnabled and character:FindFirstChild("Humanoid") and character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
        if not character:FindFirstChild("Right Leg") then
            character:WaitForChild("Right Leg")
        end
        
        local rightLeg = character:FindFirstChild("Right Leg")
        
        if rightLeg then
            local hitbox = rightLeg:FindFirstChildOfClass("BoxHandleAdornment")
            
            if not hitbox then
                hitbox = Instance.new("BoxHandleAdornment")
                hitbox.Name = "HitboxAdornment"
                hitbox.Adornee = rightLeg
                hitbox.AlwaysOnTop = true
                hitbox.ZIndex = 1
                hitbox.Transparency = 0.7
                hitbox.Color3 = Color3.new(1, 0, 0)
                hitbox.Parent = rightLeg
            end
            
            hitbox.Size = Vector3.new(
                rightLeg.Size.X * currentReach,
                rightLeg.Size.Y * currentReach,
                rightLeg.Size.Z * currentReach
            )
        end
    else
        -- Limpiar hitbox si existe
        if character and character:FindFirstChild("Right Leg") then
            local rightLeg = character:FindFirstChild("Right Leg")
            local hitbox = rightLeg:FindFirstChildOfClass("BoxHandleAdornment")
            if hitbox then
                hitbox:Destroy()
            end
        end
    end
end

local function toggleMinimize()
    minimized = not minimized
    
    if minimized then
        minimizedButton.Visible = true
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {Position = UDim2.new(2, 0, 0.5, -75)} -- Fuera de pantalla
        )
        tween:Play()
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    else
        mainFrame.Visible = true
        minimizedButton.Visible = false
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {Position = expandedPosition}
        )
        tween:Play()
    end
end

-- Conexión de eventos
slider.Changed:Connect(function(property)
    if property == "Value" then
        currentReach = slider.Value
        sliderLabel.Text = "Multiplicador de Reach: "..string.format("%.1f", currentReach)
        sliderFill.Size = UDim2.new((currentReach - 1) / 2, 0, 1, 0)
        
        if player.Character then
            updateCharacterReach(player.Character)
        end
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    reachEnabled = not reachEnabled
    if reachEnabled then
        toggleButton.Text = "DESACTIVAR"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    else
        toggleButton.Text = "ACTIVAR"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    end
    
    if player.Character then
        updateCharacterReach(player.Character)
    end
end)

minimizeButton.MouseButton1Click:Connect(toggleMinimize)
minimizedButton.MouseButton1Click:Connect(toggleMinimize)

-- Configurar tactil para móviles
if UserInputService.TouchEnabled then
    mainFrame.Draggable = false  -- Deshabilitar arrastre en móvil para mejor experiencia táctil
    
    -- Asegurar que los botones sean lo suficientemente grandes para tocar
    toggleButton.Size = UDim2.new(0.4, 0, 0, 40)
    minimizeButton.Size = UDim2.new(0.4, 0, 0, 40)
    minimizedButton.Size = UDim2.new(0, 70, 0, 50)
end

-- Manejar cambios de personaje
player.CharacterAdded:Connect(function(character)
    updateCharacterReach(character)
end)

if player.Character then
    updateCharacterReach(player.Character)
end
