-- Babannemator GUI Script | Mobil Uyumlu + ESP + Fly + Yield
-- Roblox'un güncel sürümüne göre optimize edildi

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI Oluştur
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BabannematorGui"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Babannemator Sunar"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local function createButton(text, position, callback)
	local button = Instance.new("TextButton", Frame)
	button.Size = UDim2.new(0.9, 0, 0, 30)
	button.Position = position
	button.Text = text
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 16
	button.MouseButton1Click:Connect(callback)
	return button
end

-- Hız ve Zıplama Butonu
createButton("Hız + Zıplama", UDim2.new(0.05, 0, 0, 50), function()
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 35
		humanoid.JumpPower = 20
	end
end)

-- Fly
local flying = false
createButton("Fly Aç/Kapat", UDim2.new(0.05, 0, 0, 90), function()
	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then return end

	flying = not flying
	local BodyVelocity = HumanoidRootPart:FindFirstChild("BabannematorFly") or Instance.new("BodyVelocity")
	BodyVelocity.Name = "BabannematorFly"
	BodyVelocity.Velocity = Vector3.zero
	BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	BodyVelocity.Parent = HumanoidRootPart

	if flying then
		RunService:BindToRenderStep("BabannematorFlyControl", Enum.RenderPriority.Character.Value, function()
			local camCF = workspace.CurrentCamera.CFrame
			BodyVelocity.Velocity = camCF.LookVector * 50
		end)
	else
		RunService:UnbindFromRenderStep("BabannematorFlyControl")
		BodyVelocity:Destroy()
	end
end)

-- Noclip
local noclip = false
createButton("Noclip Aç/Kapat", UDim2.new(0.05, 0, 0, 130), function()
	noclip = not noclip
	RunService.Stepped:Connect(function()
		if noclip and LocalPlayer.Character then
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide then
					v.CanCollide = false
				end
			end
		end
	end)
end)

-- ESP
createButton("ESP Aç", UDim2.new(0.05, 0, 0, 170), function()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					local box = Instance.new("BoxHandleAdornment", part)
					box.Adornee = part
					box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
					box.Transparency = 0.7
					box.ZIndex = 10
					box.AlwaysOnTop = true
					if player.Team == LocalPlayer.Team then
						box.Color3 = Color3.new(0, 1, 0) -- Yeşil
					else
						box.Color3 = Color3.new(1, 0, 0) -- Kırmızı
					end
				end
			end
		end
	end
end)

-- Infinity Yield
createButton("Yield Aç", UDim2.new(0.05, 0, 0, 210), function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- Kapat
createButton("GUI Kapat", UDim2.new(0.05, 0, 0, 250), function()
	ScreenGui:Destroy()
end)

