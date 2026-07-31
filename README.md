# 🌑 Codex UI Library

**Codex** — это легкая, быстрая и эстетичная библиотека для создания графических интерфейсов в Roblox. Выполнена в строгом темном стиле с фиолетовыми акцентами, без скруглений и с плавными анимациями.

---

## 🚀 Быстрый старт

Скопируй эту строку в свой **LocalScript** (не забудь заменить `ТВОЙ_НИК` на свой никнейм GitHub):

```lua
local Codex = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/Codex-Library/main/library.lua"))()

local window = Codex:CreateWindow({
    Title = "Codex",
    Version = "v1.0.2",
    ToggleKey = Enum.KeyCode.RightShift
})
```

---

## 🎨 Возможности (Features)

*   **Brutal Dark Theme** — строгий дизайн, квадратные формы и стильный фиолетовый акцент (`#8C3CFF`).
*   **⚡ Оптимизация** — библиотека написана на чистом Lua, не имеет внешних зависимостей и гарантирует минимальную нагрузку на FPS.
*   **🗂 Система вкладок** — плавное, отзывчивое и быстрое переключение между страницами.
*   **⌨️ Глобальный Toggle** — мгновенное скрытие и показ всего интерфейса по одной клавише (по умолчанию `RightShift`).

### 🎛 Компоненты UI
*   `AddButton` — интерактивная кнопка с эффектами наведения (hover) и нажатия.
*   `AddToggle` — переключатель со встроенным Keybind (привязкой клавиши активации).
*   `AddSlider` — плавный слайдер с поддержкой перетаскивания мышью.
*   `AddDropdown` — выпадающий список с красивой анимацией раздвигания элементов.
*   `AddTextBox` — поле ввода с динамической подсветкой границы при фокусе.

---

## 📖 Документация по API

> [!TIP]
> Все методы вкладок (`tab:`) вызываются только после создания самой вкладки через `window:CreateTab()`.

| Метод | Описание | Пример использования |
| :--- | :--- | :--- |
| **Codex:CreateWindow**`(_config_)` | Создает главное окно библиотеки | `Codex:CreateWindow({Title = "My UI"})` |
| **window:CreateTab**`(_name, isDefault_)` | Создает новую вкладку | `window:CreateTab("Main", true)` |
| **tab:AddButton**`(_text, callback_)` | Добавляет кнопку с действием | `tab:AddButton("Test", function() end)` |
| **tab:AddToggle**`(_text, default, callback_)` | Добавляет тогл с привязкой клавиши | `tab:AddToggle("ESP", false, function(state) end)` |
| **tab:AddSlider**`(_text, min, max, default, callback_)` | Добавляет ползунок (слайдер) | `tab:AddSlider("Speed", 16, 100, 16, function(v) end)` |
| **tab:AddDropdown**`(_text, options, callback_)` | Добавляет выпадающий список | `tab:AddDropdown("Map", {"A", "B"}, function(v) end)` |
| **tab:AddTextBox**`(_placeholder, callback_)` | Добавляет поле для ввода текста | `tab:AddTextBox("Type here...", function(t) end)` |

---

<p align="center">
  Made with 💜 by <b>ТВОЙ_НИК</b>
</p>
