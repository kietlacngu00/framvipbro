-- ========================================================================
--                     KIETDEPZAI ULTIMATE STANDALONE HUB
--             PREMIUM UI FRAMEWORK & ADVANCED AUTO-FARM SYSTEM
-- ========================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Khởi tạo hoặc dọn dẹp GUI cũ nếu trùng tên để tránh đè giao diện
if game.CoreGui:FindFirstChild("KietDepZai_PremiumHub") then
    game.CoreGui.KietDepZai_PremiumHub:Destroy()
end

-- Biến cấu hình hệ thống toàn cục
getgenv().Config = {
    AutoFarm = false,
    AutoChest = false,
    AutoFruit = false,
    SelectedWeapon = "Chưa chọn"
}

-- 1. XÂY DỰNG GIAO DIỆN CHUẨN CYBERPUNK (STANDALONE)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "KietDepZai_PremiumHub"
ScreenGui.ResetOnSpawn = false

-- Khung chính của Menu
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.Thickness = 1.5

-- Thanh Header điều hướng (Dùng để kéo thả menu)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "KIETDEPZAI HUB • PREMUM VERSION"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Nút Đóng Giao Diện [X]
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Nút Thu Nhỏ Menu [-]
local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold

-- Sidebar phân chia danh mục Tab bên trái
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 140, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
SideBar.BorderSizePixel = 0

local SideLayout = Instance.new("UIListLayout", SideBar)
SideLayout.Padding = UDim.new(0, 5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local SidePadding = Instance.new("UIPadding", SideBar)
SidePadding.PaddingTop = UDim.new(0, 10)

-- Vùng hiển thị nội dung các Tab bên phải
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -155, 1, -50)
ContentArea.Position = UDim2.new(0, 148, 0, 45)
ContentArea.BackgroundTransparency = 1

-- QUẢN LÝ HỆ THỐNG PHÂN TAB VÀ THÀNH PHẦN (FACTORY UI)
local Tabs = {}
local TabButtons = {}
local FirstTab = true

local function CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame", ContentArea)
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 500)
    TabPage.ScrollBarThickness = 3
    TabPage.Visible = FirstTab
    
    local PageLayout = Instance.new("UIListLayout", TabPage)
    PageLayout.Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton", SideBar)
    TabBtn.Size = UDim2.new(0, 125, 0, 35)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 12
    TabBtn.TextColor3 = FirstTab and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(140, 140, 145)
    TabBtn.BackgroundColor3 = FirstTab and Color3.fromRGB(28, 28, 35) or Color3.fromRGB(22, 22, 26)
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(Tabs) do page.Visible = false end
        for _, btn in pairs(TabButtons) do
            btn.TextColor3 = Color3.fromRGB(140, 140, 145)
            btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        end
        TabPage.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    end)
    
    table.insert(Tabs, TabPage)
    table.insert(TabButtons, TabBtn)
    FirstTab = false
    
    local Elements = {}
    
    -- Thêm Công Tắc Gạt (Animated Toggle Switch)
    function Elements:AddToggle(text, callback)
        local Row = Instance.new("Frame", TabPage)
        Row.Size = UDim2.new(1, -10, 0, 42)
        Row.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)
        
        local Label = Instance.new("TextLabel", Row)
        Label.Size = UDim2.new(1, -65, 1, 0)
        Label.Position = UDim2.new(0, 12)
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(235, 235, 235)
        Label.Font = Enum.Font.GothamMed
        Label.TextSize = 12.5
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        
        local Track = Instance.new("TextButton", Row)
        Track.Size = UDim2.new(0, 44, 0, 22)
        Track.Position = UDim2.new(1, -54, 0.5, -11)
        Track.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        Track.Text = ""
        Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 11)
        
        local Knob = Instance.new("Frame", Track)
        Knob.Size = UDim2.new(0, 16, 0, 16)
        Knob.Position = UDim2.new(0, 3, 0.5, -8)
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Knob).CornerRadius = UDim.new(0, 8)
        
        local Active = false
        Track.MouseButton1Click:Connect(function()
            Active = not Active
            local endPos = Active and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            local endColor = Active and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 50)
            
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = endPos}):Play()
            TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = endColor}):Play()
            
            callback(Active)
        end)
    end
    
    -- Thêm Nút Bấm Thường (Button)
    function Elements:AddButton(text, callback)
        local Btn = Instance.new("TextButton", TabPage)
        Btn.Size = UDim2.new(1, -10, 0, 36)
        Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextSize = 12
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
        
        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Color3.fromRGB(50, 50, 60)
        Stroke.Thickness = 1
        
        Btn.MouseButton1Click:Connect(callback)
        return Btn
    end
    
    return Elements
end

-- Đăng ký hệ thống Tab rõ ràng
local TabFarm = CreateTab("Cày Cấp")
local TabWeapon = CreateTab("Vũ Khí")
local TabMisc = CreateTab("Tiện Ích")

-- 2. ĐIỀU KHIỂN KÉO THẢ & THU GỌN MENU TRƠN TRU
local dragToggle, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragToggle then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local IsMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    local targetSize = IsMinimized and UDim2.new(0, 520, 0, 40) or UDim2.new(0, 520, 0, 360)
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
    SideBar.Visible = not IsMinimized
    ContentArea.Visible = not IsMinimized
end)

-- 3. HỆ THỐNG TRÍ TUỆ NHÂN TẠO CHỌN VŨ KHÍ TỰ ĐỘNG
local WeaponStatusLabel = Instance.new("TextLabel", ContentArea.Parent)
WeaponStatusLabel.Size = UDim2.new(1, -20, 0, 20)
WeaponStatusLabel.BackgroundTransparency = 1
WeaponStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
WeaponStatusLabel.Font = Enum.Font.GothamItalic
WeaponStatusLabel.TextSize = 11

local function RefreshWeapons()
    -- Dọn dẹp nút vũ khí cũ trên trang trước khi vẽ lại
    for _, child in pairs(TabWeapon.Page or {}) do
        if child.Name == "WeaponSelectionItem" then child:Destroy() end
    end
    
    local list = {}
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") then table.insert(list, item.Name) end
    end
    if LocalPlayer.Character then
        for _, item in pairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") then table.insert(list, item.Name) end
        end
    end
    
    for _, name in pairs(list) do
        local wBtn = TabWeapon:AddButton("Trang bị: " .. name, function()
            getgenv().Config.SelectedWeapon = name
        end)
        if wBtn then wBtn.Name = "WeaponSelectionItem" end
    end
end

TabWeapon:AddButton("🔄 Làm Mới Danh Sách Vũ Khí", function()
    RefreshWeapons()
end)

local function EquipWeapon()
    local name = getgenv().Config.SelectedWeapon
    if name == "Chưa chọn" or not LocalPlayer.Character then return end
    if not LocalPlayer.Character:FindFirstChild(name) then
        local tool = LocalPlayer.Backpack:FindFirstChild(name)
        if tool then tool.Parent = LocalPlayer.Character end
    end
end

-- 4. HÀM TẤN CÔNG SIÊU TỐC ĐỘ (FAST ATTACK) VÀ QUÉT QUÁI
local function GetClosestEnemy()
    local target, dist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, e in pairs(enemies:GetChildren()) do
            if e:FindFirstChild("HumanoidRootPart") and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                local m = (e.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if m < dist then target, dist = e, m end
            end
        end
    end
    return target
end

local function DamageRemoteAttack()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local currentTool = char:FindFirstChildOfClass("Tool")
            if currentTool and currentTool:FindFirstChild("LeftClickRemote") then
                currentTool.LeftClickRemote:FireServer(Vector3.new(0, -1, 0), 1)
            else
                -- Hệ thống Fallback dự phòng Combat Framework xịn
                local Combat = require(ReplicatedStorage.PlayerScripts.CombatFramework)
                local Cam = getupvalues(Combat)[2]
                if Cam and Cam.activeController then
                    Cam.activeController.hitboxMagnitude = 55
                    Cam.activeController:attack()
                end
            end
        end
    end)
end

-- 5. VÒNG LẶP HỆ THỐNG XỬ LÝ SỬA LỖI (NEO QUÁI, GOM RƯƠNG, HÚT TRÁI)
task.spawn(function()
    while task.wait() do
        -- A. Chế độ Cày Cấp Không Mất Máu (Neo trên đầu quái 11 studs)
        if getgenv().Config.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local monster = GetClosestEnemy()
            if monster then
                EquipWeapon()
                LocalPlayer.Character.HumanoidRootPart.CFrame = monster.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                DamageRemoteAttack()
            end
        end
        
        -- B. Chế độ Thu Gom Rương Tự Động Toàn Map
        if getgenv().Config.AutoChest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local chest = workspace:FindFirstChild("Chest")
            if not chest then
                for _, obj in pairs(workspace:GetChildren()) do
                    if string.find(obj.Name, "Chest") then chest = obj break end
                end
            end
            if not chest and workspace:FindFirstChild("ChestModels") then
                for _, cModel in pairs(workspace.ChestModels:GetChildren()) do
                    if cModel:IsA("BasePart") or cModel:FindFirstChild("HumanoidRootPart") then chest = cModel break end
                end
            end
            
            if chest then
                local part = chest:IsA("BasePart") and chest or chest:FindFirstChildWhichIsA("BasePart")
                if part then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.12)
                end
            end
        end
        
        -- C. Chế độ Hút Trái Ác Quỷ Tự Động
        if getgenv().Config.AutoFruit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("Tool") and (string.find(item.Name, "Fruit") or item:FindFirstChild("Handle")) then
                    if item:FindFirstChild("Handle") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = item.Handle.CFrame
                        task.wait(0.2)
                    end
                end
            end
        end
    end
end)

-- 6. ÁNH XẠ BIẾN TỪ CÔNG TẮC GẠT VÀO HỆ THỐNG
TabFarm:AddToggle("Kích Hoạt Cày Cấp Tự Động", function(state) getgenv().Config.AutoFarm = state end)
TabMisc:AddToggle("Tự Động Thu Gom Rương Báu", function(state) getgenv().Config.AutoChest = state end)
TabMisc:AddToggle("Tự Động Hút Trái Ác Quỷ Rơi", function(state) getgenv().Config.AutoFruit = state end)
