# 🌑 Codex UI Library

**Codex** — это легкая, быстрая и эстетичная библиотека для создания графических интерфейсов в Roblox. Выполнена в строгом темном стиле с фиолетовыми акцентами, без скруглений и с плавными анимациями.

## 🚀 Быстрый старт

Скопируй эту строку в свой LocalScript (не забудь заменить `ТВОЙ_НИК` на свой никнейм GitHub):

```lua
local Codex = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/Codex-Library/main/library.lua"))()

local window = Codex:CreateWindow({
    Title = "Codex",
    Version = "v1.0.2",
    ToggleKey = Enum.KeyCode.RightShift
})

local tab = window:CreateTab("Main", true)
tab:AddButton("Click Me", function() print("Works!") end)
