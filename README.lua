-- TSB Complete Follower (V4 - UNDER MODE ADDED)
-- Criado por Manus

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Esperar o personagem carregar
if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end

-- Remover GUIs antigas
local oldGui = CoreGui:FindFirstChild("TSB_Advanced_GUI")
if oldGui then oldGui:Destroy() end

-- Variáveis
local targetPlayer = nil
local isFollowing = false
local currentMode = "None"
local followDistance = 2.0 -- Usado para Costas, Cabeça e Debaixo
local spinSpeed = 15
local language = "PT"
local followConnection = nil

local texts = {
    PT = { title = "TSB COMPLETE V4", select = "Selecione Alvo", back = "COSTAS", spin = "GIRAR", head = "CABEÇA", under = "DEBAIXO", on = "ON", off = "OFF", dist = "Dist: ", vel = "Vel: " },
    EN = { title = "TSB COMPLETE V4", select = "Select Target", back = "BACK", spin = "SPIN", head = "HEAD", under = "UNDER", on = "ON", off = "OFF", dist = "Dist: ", vel = "Speed: " }
}

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TSB_Advanced_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Seleção de Idioma
local LangFrame = Instance.new("Frame")
LangFrame.Size = UDim2.new(0, 200, 0, 100)
LangFrame.Position = UDim2.new(0.5, -100, 0.4, -50)
LangFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LangFrame.BorderSizePixel = 2
LangFrame.Parent = ScreenGui

local LangTitle = Instance.new("TextLabel")
LangTitle.Size = UDim2.new(1, 0, 0, 30)
LangTitle.Text = "Idioma / Language"
LangTitle.TextColor3 = Color3.new(1,1,1)
LangTitle.BackgroundTransparency = 1
LangTitle.Parent = LangFrame

local PT_Btn = Instance.new("TextButton")
PT_Btn.Size = UDim2.new(0, 80, 0, 40)
PT_Btn.Position = UDim2.new(0, 15, 0, 45)
PT_Btn.Text = "PT"
PT_Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
PT_Btn.Parent = LangFrame

local EN_Btn = Instance.new("TextButton")
EN_Btn.Size = UDim2.new(0, 80, 0, 40)
EN_Btn.Position = UDim2.new(1, -95, 0, 45)
EN_Btn.Text = "EN"
EN_Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
EN_Btn.Parent = LangFrame

-- Main UI
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 420)
Main.Position = UDim2.new(0.5, -130, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

-- Crédito no topo (bem pequeno)
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0, 15)
Credit.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Credit.TextColor3 = Color3.fromRGB(150, 150, 150)
Credit.Font = Enum.Font.GothamBold
Credit.TextSize = 10
Credit.Text = "feito por pedroxxxxeros99 e manus"
Credit.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 15)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -20, 0, 80)
PlayerScroll.Position = UDim2.new(0, 10, 0, 65)
PlayerScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PlayerScroll.CanvasSize = UDim2.new(0,0,0,0)
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.Parent = Main

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = PlayerScroll

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 25)
Status.Position = UDim2.new(0, 10, 0, 150)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Font = Enum.Font.Gotham
Status.Parent = Main

local ControlInfo = Instance.new("TextLabel")
ControlInfo.Size = UDim2.new(1, -20, 0, 25)
ControlInfo.Position = UDim2.new(0, 10, 0, 175)
ControlInfo.BackgroundTransparency = 1
ControlInfo.TextColor3 = Color3.new(1,1,1)
ControlInfo.Parent = Main

local IncBtn = Instance.new("TextButton")
IncBtn.Size = UDim2.new(0, 115, 0, 30)
IncBtn.Position = UDim2.new(0, 10, 0, 200)
IncBtn.Text = "+"
IncBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
IncBtn.TextColor3 = Color3.new(1,1,1)
IncBtn.Parent = Main

local DecBtn = Instance.new("TextButton")
DecBtn.Size = UDim2.new(0, 115, 0, 30)
DecBtn.Position = UDim2.new(1, -125, 0, 200)
DecBtn.Text = "-"
DecBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DecBtn.TextColor3 = Color3.new(1,1,1)
DecBtn.Parent = Main

-- Função para criar linhas de botões
local function createModeRow(yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 0, 30)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Main

    local btnOn = Instance.new("TextButton")
    btnOn.Size = UDim2.new(0, 65, 0, 30)
    btnOn.Position = UDim2.new(0.45, 0, 0, yPos)
    btnOn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    btnOn.TextColor3 = Color3.new(1,1,1)
    btnOn.Parent = Main

    local btnOff = Instance.new("TextButton")
    btnOff.Size = UDim2.new(0, 65, 0, 30)
    btnOff.Position = UDim2.new(1, -75, 0, yPos)
    btnOff.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btnOff.TextColor3 = Color3.new(1,1,1)
    btnOff.Parent = Main

    return label, btnOn, btnOff
end

local BackLabel, BackOn, BackOff = createModeRow(245)
local SpinLabel, SpinOn, SpinOff = createModeRow(285)
local HeadLabel, HeadOn, HeadOff = createModeRow(325)
local UnderLabel, UnderOn, UnderOff = createModeRow(365)

-- Funções de Lógica
local function updateUI()
    local t = texts[language]
    Title.Text = t.title
    Status.Text = targetPlayer and (targetPlayer.DisplayName or targetPlayer.Name) or t.select
    BackLabel.Text = t.back
    SpinLabel.Text = t.spin
    HeadLabel.Text = t.head
    UnderLabel.Text = t.under
    
    BackOn.Text = t.on; BackOff.Text = t.off
    SpinOn.Text = t.on; SpinOff.Text = t.off
    HeadOn.Text = t.on; HeadOff.Text = t.off
    UnderOn.Text = t.on; UnderOff.Text = t.off
    
    if currentMode == "Back" or currentMode == "Head" or currentMode == "Under" then
        ControlInfo.Text = t.dist .. string.format("%.1f", followDistance)
    elseif currentMode == "Spin" then
        ControlInfo.Text = t.vel .. string.format("%.1f", spinSpeed)
    else
        ControlInfo.Text = "---"
    end
end

local function updateList()
    for _, v in pairs(PlayerScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 25)
            b.Text = p.DisplayName or p.Name
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            b.TextColor3 = Color3.new(1,1,1)
            b.Parent = PlayerScroll
            b.MouseButton1Click:Connect(function() targetPlayer = p updateUI() end)
        end
    end
    PlayerScroll.CanvasSize = UDim2.new(0,0,0, ListLayout.AbsoluteContentSize.Y)
end

local function stop()
    isFollowing = false
    currentMode = "None"
    if followConnection then followConnection:Disconnect() end
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = true end end
    end
    updateUI()
end

local function start(mode)
    if not targetPlayer or not targetPlayer.Character then return end
    stop()
    isFollowing = true
    currentMode = mode
    updateUI()
    
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
    
    local angle = 0
    followConnection = RunService.Heartbeat:Connect(function(dt)
        if not isFollowing or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            stop() return
        end
        local tr = targetPlayer.Character.HumanoidRootPart
        local mr = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not mr then return end
        
        if currentMode == "Back" then
            mr.CFrame = tr.CFrame * CFrame.new(0, 0, followDistance)
        elseif currentMode == "Head" then
            -- ACIMA: Virado para baixo
            mr.CFrame = (tr.CFrame * CFrame.new(0, 3.5 + followDistance, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
        elseif currentMode == "Under" then
            -- DEBAIXO: Virado para cima
            -- Posicionamento: -3.5 (abaixo dos pés) - distância ajustável
            -- Rotação: math.rad(90) no eixo X para olhar para cima
            mr.CFrame = (tr.CFrame * CFrame.new(0, -3.5 - followDistance, 0)) * CFrame.Angles(math.rad(90), 0, 0)
        elseif currentMode == "Spin" then
            angle = angle + (dt * spinSpeed)
            local offset = Vector3.new(math.cos(angle) * 2, math.sin(angle * 0.5) * 3, math.sin(angle) * 2)
            mr.CFrame = CFrame.new(tr.Position + offset, tr.Position)
        end
        mr.Velocity = Vector3.zero
        mr.RotVelocity = Vector3.zero
    end)
end

-- Eventos
PT_Btn.MouseButton1Click:Connect(function() language = "PT" LangFrame:Destroy() Main.Visible = true updateUI() updateList() end)
EN_Btn.MouseButton1Click:Connect(function() language = "EN" LangFrame:Destroy() Main.Visible = true updateUI() updateList() end)

BackOn.MouseButton1Click:Connect(function() start("Back") end)
BackOff.MouseButton1Click:Connect(function() if currentMode == "Back" then stop() end end)
SpinOn.MouseButton1Click:Connect(function() start("Spin") end)
SpinOff.MouseButton1Click:Connect(function() if currentMode == "Spin" then stop() end end)
HeadOn.MouseButton1Click:Connect(function() start("Head") end)
HeadOff.MouseButton1Click:Connect(function() if currentMode == "Head" then stop() end end)
UnderOn.MouseButton1Click:Connect(function() start("Under") end)
UnderOff.MouseButton1Click:Connect(function() if currentMode == "Under" then stop() end end)

IncBtn.MouseButton1Click:Connect(function() 
    if currentMode == "Back" or currentMode == "Head" or currentMode == "Under" then followDistance = followDistance + 0.5 
    elseif currentMode == "Spin" then spinSpeed = spinSpeed + 2 end 
    updateUI() 
end)

DecBtn.MouseButton1Click:Connect(function() 
    if currentMode == "Back" or currentMode == "Head" or currentMode == "Under" then followDistance = math.max(0.5, followDistance - 0.5) 
    elseif currentMode == "Spin" then spinSpeed = math.max(1, spinSpeed - 2) end 
    updateUI() 
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()
