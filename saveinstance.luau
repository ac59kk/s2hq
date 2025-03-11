--!native
--!optimize 2
--!divine-intellect

local function string_find(s, pattern)
    return string.find(s, pattern, nil, true)
end

local function ArrayToDict(t, hybridMode, valueOverride, typeStrict)
    local tmp = {}
    
    if hybridMode then
        for key, value in t do
            if type(key) == "number" then
                tmp[value] = valueOverride or true
            elseif type(value) == "table" then
                tmp[key] = ArrayToDict(value, hybridMode) -- Recursive call for nested tables
            else
                tmp[key] = value
            end
        end
    else
        for _, key in t do
            if not typeStrict or (typeStrict and type(key) == typeStrict) then
                tmp[key] = true
            end
        end
    end

    return tmp
end

-- Load external script
local global_container
do
    local filename = "UniversalMethodFinder"
    local finder, result = loadstring(
        game:HttpGet("https://raw.githubusercontent.com/luau/SomeHub/main/" .. filename .. ".luau", true),
        filename
    )()
    finder({
        base64encode = 'local a={...}local b=a[1]local function c(a,b)return string.find(a,b,nil,true)end;return c(b,"encode")and(c(b,"base64")or c(string.lower(tostring(a[2])),"base64"))',
        gethiddenproperty = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"prop",nil,true) and string.sub(...,#...) ~= "s"',
        gethui = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"ui",nil,true)',
        getnilinstances = 'string.find(...,"nil",nil,true) and string.find(...,"get",nil,true) and string.sub(...,#...) == "s"',
        getscriptbytecode = 'string.find(...,"get",nil,true) and string.find(...,"bytecode",nil,true)',
        hash = 'local a={...}local b=a[1]local function c(a,b)return string.find(a,b,nil,true)end;return c(b,"hash")and c(string.lower(tostring(a[2])),"crypt")',
        protectgui = 'string.find(...,"protect",nil,true) and string.find(...,"ui",nil,true) and not string.find(...,"un",nil,true)',
        setthreadidentity = 'string.find(...,"identity",nil,true) and string.find(...,"set",nil,true)',
    }, true, 10)
    global_container = result
end

local identify_executor = identifyexecutor or getexecutorname or whatexecutor
local EXECUTOR_NAME = identify_executor and identify_executor() or ""

local gethiddenproperty = global_container.gethiddenproperty
-- Usage of appendfile, readfile, writefile as needed
local appendfile = appendfile
local readfile = readfile
local writefile = writefile

-- Define services with metatable for efficient access
local service = setmetatable({}, {
    __index = function(self, serviceName)
        local success, service = pcall(Instance.new, serviceName)
        local Service = success and service or game:GetService(serviceName)
        self[serviceName] = Service
        return Service
    end,
})

local function isLuaSourceContainer(instance)
    return instance:IsA("LuaSourceContainer")
end

-- Function to save specific instances
local function save_specific(className, properties)
    local Ref = Instance.new(className) -- Create new instance
    local Item = ReturnItem(Ref.ClassName, Ref)

    for propertyName, val in properties do
        local tag, value = processProperty(propertyName, val) -- Abstracted processing
        if tag then
            Item ..= ReturnProperty(tag, propertyName, value)
        end
    end

    Item ..= "</Properties>"
    return Item
end

-- Main function to save game instances
local function synsaveinstance(CustomOptions, CustomOptions2)
    -- Initialization code and settings loading
    local options = initializeOptions(CustomOptions, CustomOptions2)

    -- Saving process
    local function save_game()
        -- Pre-saving logic
        writefile(options.placename, options.header)
        -- Hierarchy saving logic
        save_hierarchy(options.ToSaveList)
        -- Post-saving clean up and GUI updates
    end

    task.spawn(function()
        local success, err = xpcall(save_game, debug.traceback) -- Ensures proper error handling
        if not success then
            warn("Error during saving:", err)
        end
    end)
end

-- Return the main function for usage
return synsaveinstance
