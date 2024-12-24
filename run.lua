local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Stamina bar GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local staminaFrame = Instance.new("Frame")
staminaFrame.Size = UDim2.new(0.2, 0, 0.02, 0) -- Made the bar thinner (height is now 0.02)
staminaFrame.Position = UDim2.new(0.8, -100, 0.9, -30) -- Position it at the bottom right corner
staminaFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow color for the background
staminaFrame.Parent = screenGui

local staminaBackground = Instance.new("Frame")
staminaBackground.Size = UDim2.new(1, 0, 1, 0)
staminaBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
staminaBackground.Parent = staminaFrame

local staminaFill = Instance.new("Frame")
staminaFill.Size = UDim2.new(1, 0, 1, 0)
staminaFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow color for the fill
staminaFill.Parent = staminaFrame

-- Stamina variables
local maxStamina = 100
local currentStamina = maxStamina
local staminaRegenRate = 5 -- Stamina regenerated per second
local staminaDrainRate = 10 -- Stamina drained per second while sprinting
local normalSpeed = 16 -- Default walking speed
local sprintSpeed = 32 -- Speed when sprinting
local isSprinting = false

-- Update stamina bar UI
local function updateStaminaBar()
    staminaFill.Size = UDim2.new(currentStamina / maxStamina, 0, 1, 0)
end

-- Monitor stamina and movement
local lastUpdate = tick()

game:GetService("RunService").Heartbeat:Connect(function()
    local currentTime = tick()
    local timeDelta = currentTime - lastUpdate
    lastUpdate = currentTime

    -- Regenerate stamina if not sprinting
    if not isSprinting and currentStamina < maxStamina then
        currentStamina = math.min(currentStamina + staminaRegenRate * timeDelta, maxStamina)
        updateStaminaBar()
    end

    -- If the player is sprinting
    if isSprinting then
        if currentStamina > 0 then
            humanoid.WalkSpeed = sprintSpeed
            currentStamina = math.max(currentStamina - staminaDrainRate * timeDelta, 0)
            updateStaminaBar()
        else
            -- Stop sprinting when stamina runs out
            isSprinting = false
            humanoid.WalkSpeed = normalSpeed
        end
    else
        -- Default speed if not sprinting
        humanoid.WalkSpeed = normalSpeed
    end
end)

-- Sprint button for mobile users
local sprintButton = Instance.new("TextButton")
sprintButton.Size = UDim2.new(0.1, 0, 0.1, 0)
sprintButton.Position = UDim2.new(0.8, 0, 0.8, -40) -- Position it above the stamina bar
sprintButton.Text = "Sprint"
sprintButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
sprintButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sprintButton.Parent = screenGui

-- Mobile Sprint Button Interaction
sprintButton.MouseButton1Down:Connect(function()
    if currentStamina > 0 then
        isSprinting = true
    end
end)

sprintButton.MouseButton1Up:Connect(function()
    isSprinting = false
end)