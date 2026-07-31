-- Load Codex Library
local Codex = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Codex-Library/refs/heads/main/library.lua"))()

-- Create window with splash screen
local window = Codex:CreateWindow({
    Title = "Codex",
    Version = "v1.2.0",
    ToggleKey = Enum.KeyCode.RightShift,
    Watermark = true,
    Splash = true, -- Enable splash screen
    SplashDuration = 2 -- Duration in seconds
})

-- Create tabs (Main, Visuals, Config)
local mainTab = window:CreateTab("Main", true)
local visualTab = window:CreateTab("Visuals", false)
local configTab = window:CreateTab("Config", false)

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

-- === CONFIG TAB ===
configTab:AddButton("Save Current Config", function()
    window:SaveConfig("myconfig")
end)

configTab:AddButton("Refresh Config List", function()
    -- Just a placeholder, list will be shown below
    Codex:Notify("Config list refreshed", "info")
end)

-- Add config list display
local configListFrame = Instance.new("Frame")
configListFrame.Size = UDim2.new(1, 0, 0, 200)
configListFrame.BackgroundColor3 = THEME.CONTROL
configListFrame.BorderSizePixel = 0
configListFrame.Parent = configTab._elements and configTab._elements[1] or configTab

-- Function to update config list
local function updateConfigList()
    -- Clear existing list
    for _, child in ipairs(configListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local configs = window:GetConfigList()
    
    if #configs == 0 then
        local noConfigs = Instance.new("TextLabel")
        noConfigs.Size = UDim2.new(1, 0, 0, 30)
        noConfigs.BackgroundTransparency = 1
        noConfigs.Text = "No saved configs"
        noConfigs.TextColor3 = THEME.TEXT_DIM
        noConfigs.TextSize = 13
        noConfigs.Font = Enum.Font.Code
        noConfigs.Parent = configListFrame
        return
    end
    
    for i, configName in ipairs(configs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 34)
        btn.BackgroundColor3 = THEME.CONTROL
        btn.Text = "  " .. configName
        btn.TextColor3 = THEME.TEXT
        btn.TextSize = 13
        btn.Font = Enum.Font.Code
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = configListFrame
        
        -- Load button
        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 60, 0, 26)
        loadBtn.Position = UDim2.new(1, -130, 0.5, -13)
        loadBtn.BackgroundColor3 = THEME.CONTROL
        loadBtn.Text = "Load"
        loadBtn.TextColor3 = THEME.TEXT
        loadBtn.TextSize = 12
        loadBtn.Font = Enum.Font.Code
        loadBtn.BorderSizePixel = 0
        loadBtn.AutoButtonColor = false
        loadBtn.Parent = btn
        
        -- Delete button
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 60, 0, 26)
        deleteBtn.Position = UDim2.new(1, -65, 0.5, -13)
        deleteBtn.BackgroundColor3 = THEME.CONTROL
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

-- Initial update
task.wait(0.5)
updateConfigList()

-- Welcome notification
Codex:Notify("Welcome to Codex v1.2.0!", "success")

print("Codex Library v1.2.0 loaded!")
