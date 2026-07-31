-- Load Codex Library
local Codex = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Codex-Library/refs/heads/main/library.lua"))()

-- Create window with splash screen
local window = Codex:CreateWindow({
    Title = "Codex",
    Version = "v1.3.0",
    ToggleKey = Enum.KeyCode.RightShift,
    Watermark = true,
    Splash = true,
    SplashDuration = 2,
    Theme = "Dark" -- Default theme
})

-- Create tabs (Main, Visuals, Settings, Config)
local mainTab = window:CreateTab("Main", true)
local visualTab = window:CreateTab("Visuals", false)
local settingsTab = window:CreateTab("Settings", false)
local configTab = window:CreateTab("Configs (" .. window:GetConfigCount() .. ")", false)

-- === MAIN TAB ===
mainTab:AddButton("Execute Script", function()
    Codex:Notify("Script executed successfully!", "success")
    print("Executed!")
end)

mainTab:AddButton("Show Error", function()
    Codex:Notify("Something went wrong!", "error")
end)

local espToggle = mainTab:AddToggle("Enable ESP", false, function(state)
    print("ESP:", state)
end)

mainTab:AddSlider("Walk Speed", 16, 100, 16, function(val)
    print("Speed:", val)
end)

mainTab:AddDropdown("Teleport", {"Spawn", "Bank", "Roof"}, function(val)
    print("TP:", val)
end)

-- === VISUALS TAB ===
visualTab:AddColorPicker("ESP Color", Color3.fromRGB(140, 60, 255), function(color)
    print("Color changed:", color)
end)

visualTab:AddSlider("FOV", 50, 120, 70, function(val)
    print("FOV:", val)
end)

visualTab:AddToggle("Fullbright", false, function(state)
    print("Fullbright:", state)
end)

-- === SETTINGS TAB ===
settingsTab:AddDropdown("Theme", Codex:GetAvailableThemes(), function(theme)
    Codex:SetTheme(theme)
    Codex:Notify("Theme changed to: " .. theme, "success")
    print("Theme:", theme)
end)

settingsTab:AddToggle("Show Watermark", true, function(state)
    Codex:SetWatermark(state, "Codex v1.3.0")
    print("Watermark:", state)
end)

settingsTab:AddButton("Reset All Settings", function()
    Codex:Notify("Settings reset", "warning")
end)

-- === CONFIG TAB ===
local configNameBox = configTab:AddTextBox("Enter config name...", function(text)
    -- Just for display
end)

configTab:AddButton("Save Config", function()
    local name = configNameBox.Text
    if name == "" or name == "Enter config name..." then
        Codex:Notify("Please enter a config name", "error")
        return
    end
    window:SaveConfig(name)
    configNameBox.Text = ""
end)

configTab:AddButton("Refresh List", function()
    Codex:Notify("Config list refreshed", "info")
end)

-- Config list display
local configListFrame = Instance.new("Frame")
configListFrame.Size = UDim2.new(1, 0, 0, 200)
configListFrame.BackgroundColor3 = Codex:GetCurrentTheme() == "Dark" and Color3.fromRGB(15, 15, 18) or Color3.fromRGB(18, 15, 25)
configListFrame.BorderSizePixel = 0
configListFrame.Parent = configTab._elements and configTab._elements[1] or configTab

local function updateConfigList()
    for _, child in ipairs(configListFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local configs = window:GetConfigList()
    
    if #configs == 0 then
        local noConfigs = Instance.new("TextLabel")
        noConfigs.Size = UDim2.new(1, 0, 0, 30)
        noConfigs.BackgroundTransparency = 1
        noConfigs.Text = "No saved configs"
        noConfigs.TextColor3 = Color3.fromRGB(100, 100, 110)
        noConfigs.TextSize = 13
        noConfigs.Font = Enum.Font.Code
        noConfigs.Parent = configListFrame
        return
    end
    
    for i, configName in ipairs(configs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 34)
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        btn.Text = "  " .. configName
        btn.TextColor3 = Color3.fromRGB(240, 240, 245)
        btn.TextSize = 13
        btn.Font = Enum.Font.Code
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = configListFrame
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 60, 0, 26)
        loadBtn.Position = UDim2.new(1, -130, 0.5, -13)
        loadBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        loadBtn.Text = "Load"
        loadBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
        loadBtn.TextSize = 12
        loadBtn.Font = Enum.Font.Code
        loadBtn.BorderSizePixel = 0
        loadBtn.AutoButtonColor = false
        loadBtn.Parent = btn
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 60, 0, 26)
        deleteBtn.Position = UDim2.new(1, -65, 0.5, -13)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        deleteBtn.Text = "Delete"
        deleteBtn.TextColor3 = Color3.fromRGB(220, 60, 60)
        deleteBtn.TextSize = 12
        deleteBtn.Font = Enum.Font.Code
        deleteBtn.BorderSizePixel = 0
        deleteBtn.AutoButtonColor = false
        deleteBtn.Parent = btn
        
        loadBtn.MouseButton1Click:Connect(function()
            window:LoadConfig(configName)
        end)
        
        deleteBtn.MouseButton1Click:Connect(function()
            window:DeleteConfig(configName)
            task.wait(0.5)
            updateConfigList()
        end)
    end
end

task.wait(0.5)
updateConfigList()

Codex:Notify("Welcome to Codex v1.3.0!", "success")

print("Codex Library v1.3.0 loaded!")
