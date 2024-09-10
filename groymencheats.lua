local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local highlightEnabled = false
local highlights = {}
local noclipEnabled = false
local infiniteJumpEnabled = false
local flyEnabled = false
local flySpeed = 50

local function obfuscatedCreateHighlight(player)
if player.Character and not highlights[player] then
local hl = Instance.new("Highlight")
hl.Adornee = player.Character
hl.FillColor = Color3.fromRGB(255, 0, 0)
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hl.Parent = player.Character
highlights[player] = hl
end
end

local function obfuscatedRemoveHighlight(player)
if highlights[player] then
highlights[player]:Destroy()
highlights[player] = nil
end
end

local function obfuscatedToggleHighlights(state)
highlightEnabled = state
for _, player in pairs(Players:GetPlayers()) do
if state then
obfuscatedCreateHighlight(player)
else
obfuscatedRemoveHighlight(player)
end
end
end

local function obfuscatedNoclipLoop()
local player = Players.LocalPlayer
local character = player.Character
if character and noclipEnabled then
for _, part in pairs(character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = false
end
end
end
end

RunService.Stepped:Connect(function()
if noclipEnabled then
obfuscatedNoclipLoop()
end
end)

local function obfuscatedToggleNoclip(state)
noclipEnabled = state
local player = Players.LocalPlayer
local character = player.Character
if character and not state then
for _, part in pairs(character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = true
end
end
end
end

UserInputService.JumpRequest:Connect(function()
if infiniteJumpEnabled then
local character = Players.LocalPlayer.Character
if character and character:FindFirstChildOfClass("Humanoid") then
character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)

local function obfuscatedStartFly()
local player = Players.LocalPlayer
local character = player.Character
if not character or not character:FindFirstChild("HumanoidRootPart") then return end

local rootPart = character.HumanoidRootPart

local bg = Instance.new("BodyGyro")
bg.P = 9e4
bg.maxTorque = Vector3.new(9e4, 9e4, 9e4)
bg.cframe = rootPart.CFrame
bg.Parent = rootPart

local bv = Instance.new("BodyVelocity")
bv.velocity = Vector3.new(0, 0, 0)
bv.maxForce = Vector3.new(9e4, 9e4, 9e4)
bv.Parent = rootPart

RunService.Stepped:Connect(function()
if not flyEnabled then
bg:Destroy()
bv:Destroy()
return
end

local moveDir = Vector3.zero
local cam = workspace.CurrentCamera

if UserInputService:IsKeyDown(Enum.KeyCode.W) then
moveDir = moveDir + (cam.CFrame.LookVector * flySpeed)
end
if UserInputService:IsKeyDown(Enum.KeyCode.S) then
moveDir = moveDir - (cam.CFrame.LookVector * flySpeed)
end
if UserInputService:IsKeyDown(Enum.KeyCode.A) then
moveDir = moveDir - (cam.CFrame.RightVector * flySpeed)
end
if UserInputService:IsKeyDown(Enum.KeyCode.D) then
moveDir = moveDir + (cam.CFrame.RightVector * flySpeed)
end
if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
moveDir = moveDir + (cam.CFrame.UpVector * flySpeed)
end
if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
moveDir = moveDir - (cam.CFrame.UpVector * flySpeed)
end

bg.cframe = cam.CFrame
bv.velocity = moveDir
end)
end

local function obfuscatedStopFly()
flyEnabled = false
end

local function obfuscatedToggleFly(state)
flyEnabled = state
if flyEnabled then
obfuscatedStartFly()
else
obfuscatedStopFly()
end
end

Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(character)
if highlightEnabled then
obfuscatedCreateHighlight(player)
end
end)
if player.Character and highlightEnabled then
obfuscatedCreateHighlight(player)
end
end)

Players.PlayerRemoving:Connect(function(player)
obfuscatedRemoveHighlight(player)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = game.CoreGui

local draggableFrame = Instance.new("Frame")
draggableFrame.Size = UDim2.new(0, 300, 0, 350)
draggableFrame.Position = UDim2.new(0, 10, 0, 10)
draggableFrame.BackgroundTransparency = 0
draggableFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
draggableFrame.Active = true
draggableFrame.Draggable = true
draggableFrame.Parent = screenGui

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
}
uiGradient.Rotation = 45
uiGradient.Parent = draggableFrame

local frameHeader = Instance.new("Frame")
frameHeader.Size = UDim2.new(1, 0, 0, 30)
frameHeader.Position = UDim2.new(0, 0, 0, 0)
frameHeader.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frameHeader.BackgroundTransparency = 0.5
frameHeader.BorderSizePixel = 0
frameHeader.Parent = draggableFrame

local frameTitle = Instance.new("TextLabel")
frameTitle.Size = UDim2.new(1, 0, 1, 0)
frameTitle.Position = UDim2.new(0, 0, 0, 0)
frameTitle.BackgroundTransparency = 1
frameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
frameTitle.Text = "groy cheat"
frameTitle.Font = Enum.Font.SourceSansBold
frameTitle.TextSize = 18
frameTitle.Parent = frameHeader

local resizer = Instance.new("TextButton")
resizer.Size = UDim2.new(0, 20, 0, 20)
resizer.Position = UDim2.new(1, -20, 1, -20)
resizer.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
resizer.Text = ""
resizer.BorderSizePixel = 0
resizer.Parent = draggableFrame

local resizeEnabled = false
local minSize = Vector2.new(300, 350)
local maxSize = Vector2.new(600, 400)

resizer.MouseButton1Down:Connect(function()
resizeEnabled = true
end)

UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
resizeEnabled = false
end
end)

UserInputService.InputChanged:Connect(function(input)
if resizeEnabled and input.UserInputType == Enum.UserInputType.MouseMovement then
local mousePos = UserInputService:GetMouseLocation()
local framePos = draggableFrame.AbsolutePosition
local newSizeX = math.clamp(mousePos.X - framePos.X, minSize.X, maxSize.X)
local newSizeY = math.clamp(mousePos.Y - framePos.Y, minSize.Y, maxSize.Y)
draggableFrame.Size = UDim2.new(0, newSizeX, 0, newSizeY)
end
end)

local function createStyledButton(text, position)
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 260, 0, 45)
button.Position = position
button.BackgroundTransparency = 0.5
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = text
button.Font = Enum.Font.GothamBold
button.TextSize = 22
button.BorderSizePixel = 0
button.AutoButtonColor = false
button.Parent = draggableFrame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = button

local uiStroke = Instance.new("UIStroke")
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Color = Color3.fromRGB(0, 255, 255)
uiStroke.Thickness = 2
uiStroke.Parent = button

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new(Color3.fromRGB(100, 100, 255), Color3.fromRGB(255, 100, 100))
gradient.Rotation = 90
gradient.Parent = button

button.MouseEnter:Connect(function()
gradient.Color = ColorSequence.new(Color3.fromRGB(255, 100, 100), Color3.fromRGB(100, 255, 100))
end)

button.MouseLeave:Connect(function()
gradient.Color = ColorSequence.new(Color3.fromRGB(100, 100, 255), Color3.fromRGB(255, 100, 100))
end)

return button
end

local toggleHighlightButton = createStyledButton("Включить ВХ", UDim2.new(0, 20, 0, 40))
toggleHighlightButton.MouseButton1Click:Connect(function()
highlightEnabled = not highlightEnabled
obfuscatedToggleHighlights(highlightEnabled)
toggleHighlightButton.Text = highlightEnabled and "Выключить ВХ" or "Включить ВХ"
end)
local toggleNoclipButton = createStyledButton("Enable Noclip", UDim2.new(0, 20, 0, 100))
toggleNoclipButton.MouseButton1Click:Connect(function()
noclipEnabled = not noclipEnabled
obfuscatedToggleNoclip(noclipEnabled)
toggleNoclipButton.Text = noclipEnabled and "Выключить Noclip" or "Включить Noclip"
end)

local toggleInfiniteJumpButton = createStyledButton("Включить Infinite Jump", UDim2.new(0, 20, 0, 160))
toggleInfiniteJumpButton.MouseButton1Click:Connect(function()
infiniteJumpEnabled = not infiniteJumpEnabled
toggleInfiniteJumpButton.Text = infiniteJumpEnabled and "Выключить Infinite Jump" or "Включить Infinite Jump"
end)

local toggleFlyButton = createStyledButton("Включить Fly", UDim2.new(0, 20, 0, 220))
toggleFlyButton.MouseButton1Click:Connect(function()
flyEnabled = not flyEnabled
obfuscatedToggleFly(flyEnabled)
toggleFlyButton.Text = flyEnabled and "Выключить Fly" or "Включить Fly"
end)

local function toggleMenuVisibility()
screenGui.Enabled = not screenGui.Enabled
end

UserInputService.InputBegan:Connect(function(input)
if input.KeyCode == Enum.KeyCode.Insert then
toggleMenuVisibility()
end
end)

obfuscatedToggleHighlights(highlightEnabled)

Players.PlayerAdded:Connect(function(player)
if highlightEnabled then
obfuscatedCreateHighlight(player)
player.CharacterAdded:Connect(function(character)
obfuscatedCreateHighlight(player)
end)
end
end)
