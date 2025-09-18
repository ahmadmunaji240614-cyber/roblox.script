local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

_G.BigHeadScale = 5

-- fungsi set ukuran kepala
local function setHeadScale(char, scale)
    local head = char:FindFirstChild("Head")
    if head then
        local mesh = head:FindFirstChildOfClass("SpecialMesh")
        if not mesh then
            mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.Head
            mesh.Parent = head
        end
        mesh.Scale = Vector3.new(scale, scale, scale)
    end
end

-- terapkan ke semua player
local function applyAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            setHeadScale(p.Character, _G.BigHeadScale)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        setHeadScale(char, _G.BigHeadScale)
    end)
end)

RunService.Heartbeat:Connect(applyAll)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 80)
Frame.Position = UDim2.new(0.5, -100, 0.8, -40)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local SliderBack = Instance.new("Frame")
SliderBack.Size = UDim2.new(1, -20, 0, 10)
SliderBack.Position = UDim2.new(0, 10, 0, 20)
SliderBack.BackgroundColor3 = Color3.fromRGB(60,60,60)
SliderBack.BorderSizePixel = 0
SliderBack.Parent = Frame

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 16, 0, 16)
SliderButton.Position = UDim2.new((_G.BigHeadScale/50), -8, 0.5, -8)
SliderButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderBack

local ValueText = Instance.new("TextLabel")
ValueText.Size = UDim2.new(1, 0, 0, 20)
ValueText.Position = UDim2.new(0, 0, 0, 45)
ValueText.BackgroundTransparency = 1
ValueText.Text = tostring(_G.BigHeadScale)
ValueText.TextColor3 = Color3.new(1,1,1)
ValueText.TextScaled = true
ValueText.Parent = Frame

-- logic drag slider
local dragging = false

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        SliderButton.Position = UDim2.new(pos, -8, 0.5, -8)
        _G.BigHeadScale = math.max(1, math.floor(pos * 50))
        ValueText.Text = tostring(_G.BigHeadScale)
    end
end)
