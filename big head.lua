local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

_G.BigHeadScale = 5

local function setHeadScale(character, s)
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    local mesh = head:FindFirstChildOfClass("SpecialMesh")
    if not mesh then
        mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Head
        mesh.Parent = head
    end
    mesh.Scale = Vector3.new(s, s, s)
end

local function applyAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            setHeadScale(p.Character, _G.BigHeadScale)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        setHeadScale(char, _G.BigHeadScale)
    end)
end)

RunService.Heartbeat:Connect(applyAll)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 100)
Frame.Position = UDim2.new(0, 20, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "Big Head Size"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = Frame

local SliderBack = Instance.new("Frame")
SliderBack.Size = UDim2.new(1, -20, 0, 10)
SliderBack.Position = UDim2.new(0, 10, 0, 60)
SliderBack.BackgroundColor3 = Color3.fromRGB(100,100,100)
SliderBack.Parent = Frame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((_G.BigHeadScale/50), 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
SliderFill.Parent = SliderBack

local UserInputService = game:GetService("UserInputService")
local dragging = false

SliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local ratio = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X)/SliderBack.AbsoluteSize.X, 0, 1)
        _G.BigHeadScale = math.floor(ratio * 50)
        SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local ratio = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X)/SliderBack.AbsoluteSize.X, 0, 1)
        _G.BigHeadScale = math.floor(ratio * 50)
        SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    end
end)
