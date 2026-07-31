-- Загрузка библиотеки Codex с GitHub
-- ЗАМЕНИ 'ТВОЙ_НИК' НА СВОЙ РЕАЛЬНЫЙ НИКНЕЙМ GITHUB!
local Codex = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/Codex-Library/main/library.lua"))()

-- 1. Создаем главное окно
local window = Codex:CreateWindow({
    Title = "Codex",
    Version = "v1.0.2",
    ToggleKey = Enum.KeyCode.RightShift -- Клавиша для скрытия/показа UI
})

-- 2. Создаем вкладки
local mainTab = window:CreateTab("Main", true)
local miscTab = window:CreateTab("Misc", false)
local settingsTab = window:CreateTab("Settings", false)

-- 3. Добавляем элементы в Main
mainTab:AddButton("Print Hello", function()
    print("Hello from Codex!")
end)

local espToggle = mainTab:AddToggle("Enable ESP", false, function(state)
    print("ESP State:", state)
end)

mainTab:AddSlider("Walk Speed", 16, 100, 16, function(val)
    print("Speed set to:", val)
end)

mainTab:AddDropdown("Teleport", {"Spawn", "Bank", "Roof", "Secret Base"}, function(val)
    print("Teleporting to:", val)
end)

mainTab:AddTextBox("Enter Command", function(text)
    print("Command executed:", text)
end)

-- 4. Добавляем элементы в Misc
miscTab:AddToggle("Anti AFK", false, function(state)
    print("Anti AFK:", state)
end)

miscTab:AddSlider("FOV", 50, 120, 70, function(val)
    print("FOV:", val)
end)

print("✅ Codex Library loaded successfully!")
