--[[local HookObject = require(script.Parent.Object)

local Export = {}
local Information = {
	HookedEvents = 0,
	Specific = {},
}

local function GetDetour(Name)
	return require(script.Parent.Detours:FindFirstChild(Name))
end

local Detours = {
	["RemoteEvent"] = GetDetour("RemoteEvent"),
	["RemoteFunction"] = GetDetour("RemoteEvent"),
}

for Name, Detour in Detours do
	Information.Specific[Name] = 0
end

local WhitelistedCalls = {
	["FireServer"] = true,
	["InvokeServer"] = true,
}

function Export:GetInfo()
	return Information
end

function Export:Setup()
	for Index, Instance in game:GetDescendants() do
		local Class = Instance.ClassName
		local Detour = Detours[Class]

		if Detour == nil then
			continue
		end

		local Original
		Original = HookObject:Create(Instance, "__namecall", function(...)
			if WhitelistedCalls[getnamecallmethod()] ~= true then
				return Original(...)
			end
			return if Detour(...) == true then Original(...) else nil
		end)

		Information.HookedEvents += 1
		Information.Specific[Class] += 1
	end
end

function Export:Cleanup()
	if not HookObject:Cleanup() then
		warn("HookObject had an issue while cleaning up")
	end
end

return Export]]

--> Most of these are just readability tweaks 
--> How i would've done it renamed some stuff
local HookObject = require(script.Parent.Object)
--> Instead of writing a function i just created a variable for these better then your GetDetour
local DetourRemoteEvent = require(script.Parent.Detours:FindFirstChild("RemoteEvent"))
local DetourRemoteFunction = require(script.Parent.Detours:FindFirstChild("RemoteFunction"))

--> Export just wasnt a good name for a file named Hook.luau
local Hooker = {}
Hooker.__index = Hooker

--> You only had RemoteEvent and RemoteFunction so instead of leaving it empty i initalized them
local Information = {
    HookedEvents = 0,
    Specific = {
        RemoteEvent = 0,
        RemoteFunction = 0,
    },
}

local Detours = {
    RemoteEvent = DetourRemoteEvent,
    RemoteFunction = DetourRemoteFunction
}

--> Whitelisted is a good name but like AllowedCalls is lowkey better this is really just my prefrence on the Tables name.
local AllowedCalls = {
    FireServer = true,
    InvokeServer = true,
}

function Hooker.GetInfo()
    return Information
end

function Hooker.Setup()
--> Index isnt used so u should've used _ well this is generally just a stylistic choice bc most developers like u do use index, value or i, v
    for _, Instance in game:GetDescendants() do
        local Class = Instance.ClassName
        local Detour = Detours[Class]

        if not Detour then --> Not is as just as equivalant to == nil u suppose to use nil when u want the difference between nil from false
            continue
        end

        local Original

        Original = HookObject:Create(Instance, "__namecall", function(...)
            if not AllowedCalls[getnamecallmethod()] then
                return Original(...)
            end

            if Detour(...) == true then --> I know its confusing..
                return Original(...)
            end

            return nil
        end)

        Information.HookedEvents += 1
        Information.Specific[Class] += 1
    end
end

function Hooker.Cleanup()
    HookObject:Cleanup()
end

return Hooker

--> Used dot since thse dont use self aswell 
