local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))

local UISettings = {}

local function sanitize(text)
	text = tostring(text or ""):gsub("[^%w%-_ ]", "")
	text = text:gsub("^%s+", ""):gsub("%s+$", "")
	return text:sub(1, 40)
end

local function ensureFolders(path)
	if not (isfolder and makefolder) then
		return
	end
	local current = ""
	for part in path:gmatch("[^/]+") do
		current = current == "" and part or current .. "/" .. part
		if not isfolder(current) then
			makefolder(current)
		end
	end
end

function UISettings.Build(Window, WindUI)
	if Window.Destroyed then
		return
	end

	local ConfigManager = Window.ConfigManager
	local previousTab = Window.TabModule and Window.TabModule.SelectedTab

	local tab = Window:Tab({ Title = "UI Settings", Icon = "settings" })
	tab.UIElements.Main.LayoutOrder = 1000000

	if previousTab and Window.TabModule.Tabs[previousTab] then
		Window.TabModule:SelectTab(previousTab)
	end

	local function notify(content)
		WindUI:Notify({ Title = "UI Settings", Content = content, Duration = 3 })
	end

	local interface = tab:Section({ Title = "Interface", Opened = true })
	if not Window.ToggleKey then
		interface:Keybind({
			Title = "Toggle Menu",
			Value = "RightShift",
			Flag = "UISettings_MenuKey",
			Callback = function()
				Window:Toggle()
			end,
		})
	end

	local themeSection = tab:Section({ Title = "Theme", Opened = true })
	local themeNames = {}
	local currentTheme = WindUI:GetCurrentTheme()
	local currentKey
	for key, theme in next, WindUI:GetThemes() do
		table.insert(themeNames, key)
		if theme.Name == currentTheme then
			currentKey = key
		end
	end
	table.sort(themeNames)
	themeSection:Dropdown({
		Title = "Theme",
		Values = themeNames,
		Value = currentKey,
		Flag = "UISettings_Theme",
		Callback = function(value)
			if value and value ~= currentKey then
				currentKey = value
				WindUI:SetTheme(value)
			end
		end,
	})

	if not (ConfigManager and ConfigManager.Path and writefile and readfile and isfile) then
		tab:Paragraph({ Title = "Configs unavailable", Desc = "This executor has no file functions." })
		return
	end

	local gameId = game.GameId ~= 0 and game.GameId or game.PlaceId
	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
	local base = "WindUI/" .. tostring(Window.Folder) .. "/" .. tostring(gameId) .. "/" .. tostring(userId) .. "/config"
	ensureFolders(base)
	ConfigManager:SetPath(base)

	local nameValue, importValue, selected = "", "", nil

	local function configNames()
		local list = ConfigManager:AllConfigs()
		table.sort(list)
		return list
	end

	local function pathOf(name)
		return ConfigManager.Path .. name .. ".json"
	end

	local configSection = tab:Section({ Title = "Configs", Opened = true })
	configSection:Input({
		Title = "Config Name",
		Placeholder = "My Config",
		Callback = function(value)
			nameValue = value
		end,
	})
	local dropdown = configSection:Dropdown({
		Title = "Saved Configs",
		Values = configNames(),
		Callback = function(value)
			selected = value
		end,
	})

	local function refresh(select)
		local list = configNames()
		dropdown:Refresh(list)
		if select then
			selected = select
		elseif not table.find(list, selected) then
			selected = nil
		end
		if selected then
			dropdown:Select(selected)
		end
	end

	local function save(name)
		local config = ConfigManager:CreateConfig(name)
		local ok, err = pcall(config.Save, config)
		if not ok then
			notify("Saving failed: " .. tostring(err):sub(1, 80))
			return false
		end
		return true
	end

	local function requireSelected()
		if not selected then
			notify("Select a config first.")
			return nil
		end
		return selected
	end

	configSection:Button({
		Title = "Create Config",
		Callback = function()
			local name = sanitize(nameValue)
			if name == "" then
				notify("Enter a config name first.")
			elseif isfile(pathOf(name)) then
				notify("'" .. name .. "' already exists. Select it and use Overwrite.")
			elseif save(name) then
				refresh(name)
				notify("Created '" .. name .. "'.")
			end
		end,
	})
	configSection:Button({
		Title = "Load Config",
		Callback = function()
			local name = requireSelected()
			if not name then
				return
			end
			local config = ConfigManager:CreateConfig(name)
			local ok, result, message = pcall(config.Load, config)
			if ok and result ~= false then
				notify("Loaded '" .. name .. "'.")
			else
				notify("Loading failed: " .. tostring(ok and message or result):sub(1, 80))
			end
		end,
	})
	configSection:Button({
		Title = "Overwrite Config",
		Callback = function()
			local name = requireSelected()
			if name and save(name) then
				notify("Overwrote '" .. name .. "'.")
			end
		end,
	})
	configSection:Button({
		Title = "Delete Config",
		Callback = function()
			local name = requireSelected()
			if not name then
				return
			end
			local ok, message = ConfigManager:DeleteConfig(name)
			if ok then
				selected = nil
				refresh()
				notify("Deleted '" .. name .. "'.")
			else
				notify(tostring(message))
			end
		end,
	})

	local transfer = tab:Section({ Title = "Import / Export", Opened = true })
	transfer:Button({
		Title = "Export Config",
		Desc = "Copies the selected config to your clipboard.",
		Callback = function()
			local name = requireSelected()
			if not name then
				return
			end
			if not setclipboard then
				notify("This executor cannot use the clipboard.")
				return
			end
			local ok, content = pcall(readfile, pathOf(name))
			if ok and content then
				setclipboard(content)
				notify("Copied '" .. name .. "' to the clipboard.")
			else
				notify("Config file not found.")
			end
		end,
	})
	transfer:Input({
		Title = "Import Text",
		Type = "Textarea",
		Placeholder = "Paste an exported config here",
		Callback = function(value)
			importValue = value
		end,
	})
	transfer:Button({
		Title = "Import Config",
		Desc = "Uses the name from Config Name, or 'Imported'.",
		Callback = function()
			local ok, data = pcall(function()
				return HttpService:JSONDecode(importValue)
			end)
			if not (ok and type(data) == "table" and type(data.__elements) == "table") then
				notify("This is not a valid config.")
				return
			end
			local name = sanitize(nameValue)
			if name == "" then
				name = "Imported"
			end
			if isfile(pathOf(name)) then
				notify("'" .. name .. "' already exists. Choose another name.")
				return
			end
			data.__autoload = false
			writefile(pathOf(name), HttpService:JSONEncode(data))
			refresh(name)
			notify("Imported as '" .. name .. "'.")
		end,
	})
end

return UISettings
