-- =======================================================
-- SCRIPT ESP BẢN VIP V4 - TỔNG HỢP CUỐI CÙNG (NO BUG)
-- =======================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Cleanup cũ
for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "MinimalEspGui" then v:Destroy() end end
if workspace:FindFirstChild("RainbowEspFolderV4") then workspace["RainbowEspFolderV4"]:Destroy() end

local EspFolder = Instance.new("Folder")
EspFolder.Name = "RainbowEspFolderV4"
EspFolder.Parent = workspace

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinimalEspGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local EspBtn = Instance.new("TextButton")
EspBtn.Name = "EspBtn"
EspBtn.Size = UDim2.new(0, 140, 0, 40)
EspBtn.Position = UDim2.new(0, 15, 0, 15)
EspBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
EspBtn.Text = "ESP SKELETON: OFF"
EspBtn.TextColor3 = Color3.fromRGB(255, 75, 75)
EspBtn.Font = Enum.Font.GothamBold
EspBtn.Draggable = true
EspBtn.Parent = ScreenGui
Instance.new("UICorner", EspBtn).CornerRadius = UDim.new(0, 8)

local EspActive = false
local RainbowColor = Color3.fromRGB(255, 255, 255)

local function GetEspStorage(plr)
    local storage = EspFolder:FindFirstChild(plr.Name)
    if not storage then
        storage = Instance.new("Folder", EspFolder)
        storage.Name = plr.Name
    end
    return storage
end

local function UpdateEsp()
    if not EspActive then return end
    RainbowColor = Color3.fromHSV(tick() % 4 / 4, 1, 1)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local storage = GetEspStorage(plr)
            
            -- Vẽ NameTag (Cố định, không bị reset)
            local tag = storage:FindFirstChild("Tag")
            if not tag then
                local b = Instance.new("BillboardGui", storage)
                b.Name = "Tag"
                b.Size = UDim2.new(0, 150, 0, 20)
                b.AlwaysOnTop = true
                b.ExtentsOffset = Vector3.new(0, 2.5, 0)
                local t = Instance.new("TextLabel", b)
                t.Size = UDim2.new(1,0,1,0)
                t.BackgroundTransparency = 1
                t.Text = plr.DisplayName
                t.TextColor3 = Color3.new(1,1,1)
                t.TextStrokeTransparency = 0
                tag = b
            end
            tag.Adornee = char:FindFirstChild("Head")
            
            -- Vẽ Highlight (Tự động bắt theo nhân vật mới)
            local hl = storage:FindFirstChild("HL")
            if not hl then
                hl = Instance.new("Highlight", storage)
                hl.Name = "HL"
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
            hl.Adornee = char
            hl.FillColor = RainbowColor
            hl.OutlineColor = RainbowColor
        end
    end
end

EspBtn.MouseButton1Click:Connect(function()
    EspActive = not EspActive
    EspBtn.Text = EspActive and "ESP SKELETON: ON" or "ESP SKELETON: OFF"
    EspBtn.TextColor3 = EspActive and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 75, 75)
    if not EspActive then EspFolder:ClearAllChildren() end
end)

RunService.Heartbeat:Connect(UpdateEsp)

LocalPlayer.CharacterAdded:Connect(function()
    if EspActive then task.wait(0.5) end
end)

