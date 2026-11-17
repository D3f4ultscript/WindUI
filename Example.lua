local cloneref = cloneref or clonereference or function(instance)
	return instance
end

local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))

local WindUI = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/D3f4ultscript/WindUI/main/dist/main.lua")
)()

local Colors = {
	Purple = Color3.fromHex("#7775F2"),
	Yellow = Color3.fromHex("#ECA201"),
	Green = Color3.fromHex("#10C550"),
	Grey = Color3.fromHex("#83889E"),
	Blue = Color3.fromHex("#257AF7"),
	Red = Color3.fromHex("#EF4F1D"),
}

local CanSaveConfig = not RunService:IsStudio() and writefile ~= nil and isfolder ~= nil

WindUI:Localization({
	Enabled = true,
	Prefix = "loc:",
	DefaultLanguage = "en",
	Translations = {
		en = {
			EXAMPLE_TITLE = "WindUI Full Example",
			LANG_HELLO = "Hello! This text is translated.",
			LANG_DESC = "Switch the language with the dropdown below.",
		},
		de = {
			EXAMPLE_TITLE = "WindUI Komplettes Beispiel",
			LANG_HELLO = "Hallo! Dieser Text ist uebersetzt.",
			LANG_DESC = "Wechsle die Sprache mit dem Dropdown darunter.",
		},
	},
})

WindUI:AddTheme({
	Name = "Ocean",
	Accent = Color3.fromHex("#0b2239"),
	Dialog = Color3.fromHex("#0d2b47"),
	Outline = Color3.fromHex("#9fd4ff"),
	Text = Color3.fromHex("#e8f4ff"),
	Placeholder = Color3.fromHex("#7ea6c7"),
	Background = Color3.fromHex("#07182a"),
	Button = Color3.fromHex("#1c4d7a"),
	Icon = Color3.fromHex("#7cc4ff"),
	Toggle = Color3.fromHex("#2dd4bf"),
	Slider = Color3.fromHex("#38bdf8"),
	Checkbox = Color3.fromHex("#38bdf8"),
	Primary = Color3.fromHex("#38bdf8"),
})

local Window = WindUI:CreateWindow({
	Title = "loc:EXAMPLE_TITLE",
	Author = "by D3f4ultscript",
	Folder = "WindUIExample",
	Icon = "solar:folder-2-bold-duotone",
	Theme = "Dark",
	NewElements = true,
	Size = UDim2.fromOffset(760, 520),
	MinSize = Vector2.new(560, 380),
	MaxSize = Vector2.new(1100, 700),
	Resizable = true,
	SideBarWidth = 200,
	ScrollBarEnabled = true,
	HideSearchBar = false,
	Transparent = true,
	ToggleKey = Enum.KeyCode.RightShift,
	User = {
		Enabled = true,
		Anonymous = false,
		Callback = function()
			WindUI:Notify({
				Title = "User",
				Content = "You clicked your profile.",
				Icon = "user",
			})
		end,
	},
	OpenButton = {
		Title = "Open WindUI",
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		CornerRadius = UDim.new(1, 0),
		StrokeThickness = 3,
		Scale = 0.6,
		Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f")),
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac",
	},
})

Window:Tag({
	Title = "v" .. WindUI.Version,
	Icon = "github",
	Color = Color3.fromHex("#1c1c1c"),
	Border = true,
})

Window:Tag({
	Title = "Beta",
	Color = Colors.Yellow,
})

Window:CreateTopbarButton("Info", "info", function()
	WindUI:Notify({
		Title = "Topbar Button",
		Content = "Custom button in the topbar.",
		Icon = "info",
	})
end, 990)

Window:OnOpen(function()
	print("Window opened")
end)

Window:OnClose(function()
	print("Window closed")
end)

Window:OnDestroy(function()
	print("Window destroyed")
end)

local function buildAboutTab(Tab)
	local Section = Tab:Section({
		Title = "About WindUI",
	})

	Section:Image({
		Image = "https://repository-images.githubusercontent.com/880118829/22c020eb-d1b1-4b34-ac4d-e33fd88db38d",
		AspectRatio = "16:9",
		Radius = 9,
	})

	Section:Space({ Columns = 3 })

	Section:Section({
		Title = "What is WindUI?",
		TextSize = 24,
		FontWeight = Enum.FontWeight.SemiBold,
	})

	Section:Space()

	Section:Section({
		Title = "WindUI is an open-source UI library for Roblox script hubs. This example shows every element and window feature in one place.",
		TextSize = 16,
		TextTransparency = 0.35,
		FontWeight = Enum.FontWeight.Medium,
	})

	Tab:Space({ Columns = 2 })

	Tab:Button({
		Title = "Destroy Window",
		Color = Color3.fromHex("#ff4830"),
		Justify = "Center",
		Icon = "shredder",
		IconAlign = "Left",
		Callback = function()
			Window:Destroy()
		end,
	})
end

local function buildButtonTab(Tab)
	local HighlightButton
	HighlightButton = Tab:Button({
		Title = "Highlight Button",
		Desc = "Flashes itself when clicked",
		Icon = "mouse",
		Callback = function()
			HighlightButton:Highlight()
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Colored Button",
		Desc = "Custom color and centered text",
		Color = Color3.fromHex("#305dff"),
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("colored button clicked")
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Button with Tags",
		Icon = "tag",
		Tags = {
			{ Title = "New", Color = Colors.Green },
			{ Title = "Beta", Color = Colors.Yellow, Border = true },
		},
		Callback = function()
			print("tagged button clicked")
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Notify",
		Icon = "bell",
		Callback = function()
			WindUI:Notify({
				Title = "Hello",
				Content = "This is a notification.",
				Icon = "solar:bell-bold",
				Duration = 5,
				CanClose = true,
			})
		end,
	})

	Tab:Space()

	local LockedButton = Tab:Button({
		Title = "Locked Button",
		Desc = "Cannot be clicked",
		Locked = true,
		LockedTitle = "This element is locked",
	})

	Tab:Space()

	Tab:Button({
		Title = "Unlock / Lock the button above",
		Icon = "lock",
		Callback = function()
			if LockedButton.Locked then
				LockedButton:Unlock()
			else
				LockedButton:Lock()
			end
		end,
	})
end

local function buildToggleTab(Tab)
	Tab:Toggle({
		Title = "Toggle",
		Desc = "Default switch style",
		Value = false,
		Callback = function(state)
			print("toggle:", state)
		end,
	})

	Tab:Space()

	Tab:Toggle({
		Title = "Checkbox",
		Desc = "Checkbox style",
		Type = "Checkbox",
		Value = true,
		Callback = function(state)
			print("checkbox:", state)
		end,
	})

	Tab:Space()

	local SetToggle = Tab:Toggle({
		Title = "Toggle controlled from code",
		Value = false,
	})

	Tab:Button({
		Title = "Switch it on",
		Icon = "",
		Justify = "Center",
		Callback = function()
			SetToggle:Set(true)
		end,
	})

	Tab:Space()

	Tab:Toggle({
		Title = "Locked Toggle",
		Locked = true,
		LockedTitle = "This element is locked",
	})
end

local function buildInputTab(Tab)
	Tab:Input({
		Title = "Input",
		Desc = "Single line text",
		Placeholder = "Type here...",
		Icon = "mouse",
		Callback = function(text)
			print("input:", text)
		end,
	})

	Tab:Space()

	Tab:Input({
		Title = "Textarea",
		Desc = "Multi line text",
		Type = "Textarea",
		Placeholder = "Write more here...",
		Callback = function(text)
			print("textarea:", text)
		end,
	})

	Tab:Space()

	local ControlledInput = Tab:Input({
		Title = "Input controlled from code",
		Value = "Default value",
	})

	Tab:Button({
		Title = "Set text",
		Icon = "",
		Justify = "Center",
		Callback = function()
			ControlledInput:Set("Changed by a button")
		end,
	})

	Tab:Space()

	Tab:Input({
		Title = "Locked Input",
		Locked = true,
		LockedTitle = "This element is locked",
	})
end

local function buildSliderTab(Tab)
	Tab:Slider({
		Title = "Slider",
		Desc = "With tooltip, without textbox",
		IsTooltip = true,
		IsTextbox = false,
		Step = 1,
		Value = { Min = 0, Max = 200, Default = 100 },
		Callback = function(value)
			print("slider:", value)
		end,
	})

	Tab:Space()

	Tab:Slider({
		Title = "Decimal Slider",
		Step = 0.1,
		Value = { Min = 0, Max = 5, Default = 1.5 },
		Callback = function(value)
			print("decimal slider:", value)
		end,
	})

	Tab:Space()

	Tab:Slider({
		IsTooltip = true,
		Step = 1,
		Value = { Min = 0, Max = 100, Default = 50 },
		Icons = {
			From = "sfsymbols:sunMinFill",
			To = "sfsymbols:sunMaxFill",
		},
		Callback = function(value)
			print("icon slider:", value)
		end,
	})

	Tab:Space()

	local ControlledSlider = Tab:Slider({
		Title = "Slider controlled from code",
		Step = 1,
		Value = { Min = 0, Max = 100, Default = 10 },
	})

	Tab:Button({
		Title = "Set to 75",
		Icon = "",
		Justify = "Center",
		Callback = function()
			ControlledSlider:Set(75)
		end,
	})

	Tab:Space()

	Tab:Slider({
		Title = "Locked Slider",
		Locked = true,
		LockedTitle = "This element is locked",
		Value = { Min = 0, Max = 100, Default = 30 },
	})
end

local function buildDropdownTab(Tab)
	Tab:Dropdown({
		Title = "Single Select",
		Values = { "Apple", "Banana", "Cherry", "Grape" },
		Value = "Apple",
		Callback = function(option)
			print("selected:", option)
		end,
	})

	Tab:Space()

	Tab:Dropdown({
		Title = "Multi Select",
		Desc = "AllowNone lets you deselect everything",
		Values = { "Red", "Green", "Blue", "Yellow" },
		Value = { "Red" },
		Multi = true,
		AllowNone = true,
		Callback = function(options)
			print("selected:", table.concat(options, ", "))
		end,
	})

	Tab:Space()

	Tab:Dropdown({
		Title = "Searchable Dropdown",
		SearchBarEnabled = true,
		MenuWidth = 280,
		Values = (function()
			local list = {}
			for index = 1, 50 do
				table.insert(list, "Item " .. index)
			end
			return list
		end)(),
		Value = "Item 1",
		Callback = function(option)
			print("selected:", option)
		end,
	})

	Tab:Space()

	Tab:Dropdown({
		Title = "Advanced Dropdown",
		Desc = "Entries with icons, descriptions and callbacks",
		Values = {
			{
				Title = "New file",
				Desc = "Create a new file",
				Icon = "file-plus",
				Callback = function()
					print("New file")
				end,
			},
			{
				Title = "Copy link",
				Desc = "Copy the file link",
				Icon = "copy",
				Callback = function()
					print("Copy link")
				end,
			},
			{ Type = "Divider" },
			{
				Title = "Delete file",
				Desc = "Permanently delete the file",
				Icon = "trash",
				Callback = function()
					print("Delete file")
				end,
			},
		},
	})

	Tab:Space()

	Tab:Dropdown({
		Title = "Locked Dropdown",
		Values = { "A", "B" },
		Locked = true,
		LockedTitle = "This element is locked",
	})
end

local function buildPickerTab(Tab)
	Tab:Colorpicker({
		Title = "Colorpicker",
		Desc = "Pick any color",
		Default = Color3.fromHex("#30ff6a"),
		Callback = function(color)
			print("color:", color)
		end,
	})

	Tab:Space()

	Tab:Colorpicker({
		Title = "Colorpicker with transparency",
		Default = Color3.fromRGB(0, 145, 255),
		Transparency = 0.2,
		Callback = function(color, transparency)
			print("color:", color, "transparency:", transparency)
		end,
	})

	Tab:Space()

	Tab:Keybind({
		Title = "Keybind",
		Desc = "Click and press a key",
		Value = "G",
		Callback = function(key)
			print("keybind:", key)
		end,
	})

	Tab:Space()

	Tab:Keybind({
		Title = "Keybind with blacklist",
		Desc = "W, A, S and D cannot be picked",
		Value = "F",
		Blacklist = { "W", "A", "S", "D" },
		Callback = function(key)
			print("keybind:", key)
		end,
	})

	Tab:Space()

	Tab:Keybind({
		Title = "Keybind that toggles this window",
		Value = "RightShift",
		Callback = function(key)
			Window:SetToggleKey(Enum.KeyCode[key])
		end,
	})

	Tab:Space()

	Tab:Keybind({
		Title = "Locked Keybind",
		Locked = true,
		LockedTitle = "This element is locked",
	})
end

local function buildDisplayTab(Tab)
	Tab:Paragraph({
		Title = "Paragraph",
		Desc = "A text block with a title and a description.",
	})

	Tab:Space()

	Tab:Paragraph({
		Title = "Paragraph with image and buttons",
		Desc = "Images can be asset ids, URLs or icon names.",
		Image = "solar:info-circle-bold",
		ImageSize = 32,
		Color = "Blue",
		Buttons = {
			{
				Title = "Notify",
				Icon = "bell",
				Callback = function()
					WindUI:Notify({ Title = "Paragraph", Content = "Button inside a paragraph." })
				end,
			},
			{
				Title = "Print",
				Icon = "terminal",
				Callback = function()
					print("paragraph button")
				end,
			},
		},
	})

	Tab:Space()

	local Progress = Tab:ProgressBar({
		Title = "Progress Bar",
		Desc = "Percent display",
		Value = { Min = 0, Max = 100, Default = 25 },
		Width = 200,
	})

	Tab:Space()

	Tab:ProgressBar({
		Title = "Fraction Display",
		DisplayMode = "Fraction",
		Value = { Min = 0, Max = 20, Default = 7 },
	})

	Tab:Space()

	Tab:ProgressBar({
		Title = "Indeterminate",
		Indeterminate = true,
		IndeterminateText = "Loading...",
	})

	Tab:Space()

	Tab:Button({
		Title = "Add 10 to the first bar",
		Icon = "plus",
		Callback = function()
			Progress:Set(math.min(Progress:Get() + 10, 100))
		end,
	})

	Tab:Space()

	Tab:Code({
		Title = "Code Block",
		Code = 'local message = "Hello from WindUI"\nprint(message)\n\nfor index = 1, 3 do\n\tprint(index)\nend',
		CodeSize = 16,
		CanCopied = true,
		OnCopy = function()
			WindUI:Notify({ Title = "Code", Content = "Copied to clipboard." })
		end,
	})

	Tab:Space()

	Tab:Image({
		Image = "https://repository-images.githubusercontent.com/880118829/22c020eb-d1b1-4b34-ac4d-e33fd88db38d",
		AspectRatio = "16:9",
		Radius = 12,
	})

	Tab:Space()

	local ViewportPart = Instance.new("Part")
	ViewportPart.Size = Vector3.new(4, 4, 4)
	ViewportPart.Color = Colors.Blue
	ViewportPart.Material = Enum.Material.SmoothPlastic

	Tab:Viewport({
		Object = ViewportPart,
		Interactive = true,
		Height = 220,
	})
end

local function buildLayoutTab(Tab)
	Tab:Section({
		Title = "Group",
		Desc = "Elements side by side",
	})

	local Group = Tab:Group({})
	Group:Button({
		Title = "Button 1",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("group button 1")
		end,
	})
	Group:Space()
	Group:Button({
		Title = "Button 2",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("group button 2")
		end,
	})
	Group:Space()
	Group:Toggle({
		Title = "Toggle",
		Callback = function(state)
			print("group toggle:", state)
		end,
	})

	Tab:Space({ Columns = 2 })

	Tab:Section({
		Title = "HStack",
		Desc = "Horizontal stack with automatic spacing",
	})

	local HStack = Tab:HStack({ AutoSpace = true })
	HStack:Button({ Title = "A", Justify = "Center", Icon = "" })
	HStack:Button({ Title = "B", Justify = "Center", Icon = "" })
	HStack:Button({ Title = "C", Justify = "Center", Icon = "" })

	Tab:Space({ Columns = 2 })

	Tab:Section({
		Title = "VStack",
		Desc = "Vertical stack",
	})

	local VStack = Tab:VStack({})
	VStack:Button({ Title = "Top", Justify = "Center", Icon = "" })
	VStack:Button({ Title = "Bottom", Justify = "Center", Icon = "" })

	Tab:Space({ Columns = 2 })

	Tab:Divider()

	Tab:Space({ Columns = 2 })

	local Boxed = Tab:Section({
		Title = "Collapsible Section",
		Desc = "Click the header to open or close",
		Box = true,
		BoxBorder = true,
		Opened = true,
		Icon = "layers",
	})
	Boxed:Toggle({ Title = "Inside the section" })
	Boxed:Space()
	Boxed:Button({
		Title = "Also inside",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("section button")
		end,
	})
end

local function buildPopupTab(Tab)
	Tab:Button({
		Title = "Notification with buttons",
		Icon = "bell-ring",
		Callback = function()
			WindUI:Notify({
				Title = "Update available",
				Content = "A new version is ready.",
				Icon = "download",
				Duration = 8,
				Buttons = {
					{
						Title = "Later",
						Callback = function()
							print("later")
						end,
					},
					{
						Title = "Update",
						Callback = function()
							print("update")
						end,
					},
				},
			})
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Dialog (inside the window)",
		Icon = "message-square",
		Callback = function()
			Window:Dialog({
				Title = "Are you sure?",
				Content = "This dialog is shown inside the window.",
				Buttons = {
					{
						Title = "Cancel",
						Variant = "Secondary",
						Callback = function()
							print("cancel")
						end,
					},
					{
						Title = "Confirm",
						Icon = "check",
						Variant = "Primary",
						Callback = function()
							print("confirm")
						end,
					},
				},
			})
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Popup (screen wide)",
		Icon = "app-window",
		Callback = function()
			WindUI:Popup({
				Title = "Welcome to WindUI!",
				Icon = "bird",
				Content = "A popup that is not bound to the window.",
				Buttons = {
					{
						Title = "Close",
						Variant = "Tertiary",
					},
					{
						Title = "Nice",
						Icon = "thumbs-up",
						Variant = "Primary",
						Callback = function()
							print("nice")
						end,
					},
				},
			})
		end,
	})
end

local function buildThemeTab(Tab)
	local ThemeNames = {}
	for name in pairs(WindUI:GetThemes()) do
		table.insert(ThemeNames, name)
	end
	table.sort(ThemeNames)

	Tab:Dropdown({
		Title = "Theme",
		Desc = "Includes the custom 'Ocean' theme added in this script",
		Values = ThemeNames,
		Value = WindUI:GetCurrentTheme(),
		Callback = function(name)
			WindUI:SetTheme(name)
		end,
	})

	Tab:Space()

	Tab:Toggle({
		Title = "Window transparency",
		Value = true,
		Callback = function(state)
			Window:ToggleTransparency(state)
		end,
	})

	Tab:Slider({
		Title = "Background transparency",
		Step = 0.1,
		Value = { Min = 0, Max = 1, Default = WindUI.TransparencyValue },
		Callback = function(value)
			Window:SetBackgroundTransparency(value)
		end,
	})

	Tab:Slider({
		Title = "UI scale",
		Step = 0.05,
		Value = { Min = 0.6, Max = 1.4, Default = 1 },
		Callback = function(value)
			Window:SetUIScale(value)
		end,
	})

	Tab:Space()

	Tab:Dropdown({
		Title = "Language",
		Desc = "loc:LANG_DESC",
		Values = { "en", "de" },
		Value = "en",
		Callback = function(language)
			WindUI:SetLanguage(language)
		end,
	})

	Tab:Paragraph({
		Title = "loc:LANG_HELLO",
	})

	Tab:Space()

	local GradientPreview = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#30FF6A"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#257AF7"), Transparency = 0 },
	}, { Rotation = 45 })

	Tab:Button({
		Title = "Apply gradient to the open button",
		Icon = "paintbrush",
		Callback = function()
			Window:EditOpenButton({
				Color = ColorSequence.new(GradientPreview.Color.Keypoints[1].Value, GradientPreview.Color.Keypoints[2].Value),
			})
		end,
	})
end

local function buildWindowTab(Tab)
	Tab:Button({
		Title = "Center the window",
		Icon = "align-center",
		Callback = function()
			Window:SetToTheCenter()
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Resize to 900 x 600",
		Icon = "maximize-2",
		Callback = function()
			Window:SetSize(UDim2.fromOffset(900, 600))
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Toggle fullscreen",
		Icon = "maximize",
		Callback = function()
			Window:ToggleFullscreen()
		end,
	})

	Tab:Space()

	Tab:Input({
		Title = "Window title",
		Value = "WindUI Full Example",
		Callback = function(text)
			Window:SetTitle(text)
		end,
	})

	Tab:Input({
		Title = "Window author",
		Value = "by D3f4ultscript",
		Callback = function(text)
			Window:SetAuthor(text)
		end,
	})

	Tab:Space()

	Tab:Toggle({
		Title = "Allow resizing",
		Value = true,
		Callback = function(state)
			Window:IsResizable(state)
		end,
	})

	Tab:Toggle({
		Title = "Panel background",
		Value = not Window.HidePanelBackground,
		Callback = function(state)
			Window:SetPanelBackground(state)
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Lock all elements in this tab",
		Icon = "lock",
		Callback = function()
			Tab:LockAll()
		end,
	})

	Tab:Button({
		Title = "Unlock all elements in this tab",
		Icon = "unlock",
		Callback = function()
			Tab:UnlockAll()
		end,
	})

	Tab:Space()

	Tab:Button({
		Title = "Close window (reopen with the open button)",
		Icon = "x",
		Callback = function()
			Window:Close()
		end,
	})
end

local function buildConfigTab(ElementsTab, ManagerTab)
	ElementsTab:Toggle({
		Flag = "ExampleToggle",
		Title = "Saved Toggle",
		Value = false,
	})

	ElementsTab:Slider({
		Flag = "ExampleSlider",
		Title = "Saved Slider",
		Step = 1,
		Value = { Min = 0, Max = 100, Default = 40 },
	})

	ElementsTab:Input({
		Flag = "ExampleInput",
		Title = "Saved Input",
		Value = "Hello",
	})

	ElementsTab:Dropdown({
		Flag = "ExampleDropdown",
		Title = "Saved Dropdown",
		Values = { "One", "Two", "Three" },
		Value = "One",
	})

	ElementsTab:Colorpicker({
		Flag = "ExampleColor",
		Title = "Saved Colorpicker",
		Default = Color3.fromHex("#30ff6a"),
	})

	ElementsTab:Keybind({
		Flag = "ExampleKeybind",
		Title = "Saved Keybind",
		Value = "H",
	})

	local ConfigManager = Window.ConfigManager
	local ConfigName = "default"

	local NameInput = ManagerTab:Input({
		Title = "Config name",
		Icon = "file-cog",
		Value = ConfigName,
		Callback = function(value)
			ConfigName = value
		end,
	})

	local AllConfigsDropdown = ManagerTab:Dropdown({
		Title = "Existing configs",
		Values = ConfigManager:AllConfigs(),
		Callback = function(value)
			ConfigName = value
			NameInput:Set(value)
		end,
	})

	ManagerTab:Space()

	ManagerTab:Button({
		Title = "Save config",
		Icon = "save",
		Justify = "Center",
		Callback = function()
			Window.CurrentConfig = ConfigManager:Config(ConfigName)
			if Window.CurrentConfig:Save() then
				WindUI:Notify({ Title = "Config saved", Content = ConfigName, Icon = "check" })
			end
			AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
		end,
	})

	ManagerTab:Space()

	ManagerTab:Button({
		Title = "Load config",
		Icon = "folder-open",
		Justify = "Center",
		Callback = function()
			Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
			if Window.CurrentConfig:Load() then
				WindUI:Notify({ Title = "Config loaded", Content = ConfigName, Icon = "refresh-cw" })
			end
		end,
	})

	ManagerTab:Space()

	ManagerTab:Button({
		Title = "Delete config",
		Icon = "trash",
		Justify = "Center",
		Color = Color3.fromHex("#ff4830"),
		Callback = function()
			ConfigManager:DeleteConfig(ConfigName)
			AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
		end,
	})

	ManagerTab:Space()

	ManagerTab:Button({
		Title = "Print auto load configs",
		Icon = "terminal",
		Justify = "Center",
		Callback = function()
			print(ConfigManager:GetAutoLoadConfigs())
		end,
	})
end

local function newTab(Parent, Title, Icon, IconColor, Desc)
	return Parent:Tab({
		Title = Title,
		Desc = Desc,
		Icon = Icon,
		IconColor = IconColor,
		IconShape = "Square",
		Border = true,
	})
end

buildAboutTab(newTab(Window, "About", "solar:info-square-bold", Colors.Grey, "What this example shows"))

local ElementsSection = Window:Section({ Title = "Elements" })

buildButtonTab(newTab(ElementsSection, "Button", "solar:cursor-square-bold", Colors.Blue))
buildToggleTab(newTab(ElementsSection, "Toggle", "solar:check-square-bold", Colors.Green))
buildInputTab(newTab(ElementsSection, "Input", "solar:password-minimalistic-input-bold", Colors.Purple))
buildSliderTab(newTab(ElementsSection, "Slider", "solar:square-transfer-horizontal-bold", Colors.Green))
buildDropdownTab(newTab(ElementsSection, "Dropdown", "solar:hamburger-menu-bold", Colors.Yellow))
buildPickerTab(newTab(ElementsSection, "Color and Keybind", "palette", Colors.Red))
buildDisplayTab(newTab(ElementsSection, "Display", "layout-dashboard", Colors.Blue))
buildLayoutTab(newTab(ElementsSection, "Layout", "layout-grid", Colors.Purple))

local FeaturesSection = Window:Section({ Title = "Features" })

buildPopupTab(newTab(FeaturesSection, "Popups", "message-square", Colors.Yellow))
buildThemeTab(newTab(FeaturesSection, "Theme and Language", "paintbrush", Colors.Purple))
buildWindowTab(newTab(FeaturesSection, "Window Controls", "app-window", Colors.Blue))

Window:Divider()

if CanSaveConfig then
	local ConfigSection = Window:Section({ Title = "Config" })
	buildConfigTab(
		newTab(ConfigSection, "Config Elements", "solar:file-text-bold", Colors.Blue),
		newTab(ConfigSection, "Config Manager", "solar:folder-with-files-bold", Colors.Purple)
	)
end

WindUI:Notify({
	Title = "WindUI Example",
	Content = "Loaded. Press RightShift to hide or show the window.",
	Icon = "solar:bell-bold",
	Duration = 6,
})
