-- Load Codex Library
local Codex = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Codex-Library/refs/heads/main/library.lua"))()

-- Create window with watermark enabled
local window = Codex:CreateWindow({
    Title = "Codex",
    Version = "v1.1.0",
    ToggleKey = Enum.KeyCode.RightShift, -- Press RightShift to hide/show
    Watermark = true -- Watermark in top-left corner
})

-- Create tabs
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

mainTab:AddButton("Show Warning", function()
    Codex:Notify("This is a warning", "warning")
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

-- === CONFIG TAB ===
configTab:AddButton("Save Config", function()
    window:SaveConfig("myconfig")
end)

configTab:AddButton("Load Config", function()
    local data = window:LoadConfig("myconfig")
    if data then
        print("Loaded config data:", data)
    end
end)

-- Initial notification
Codex:Notify("Welcome to Codex v1.1.0!", "success")

print("Codex Library v1.1.0 loaded!")
