local decompsrc = game:HttpGet("https://raw.githubusercontent.com/w-a-e/Advanced-Decompiler-V3/main/init.lua", true)
local function loaddecomp(decomptimeout)
    local CONSTANTS = [[
local ENABLED_REMARKS = {
    NATIVE_REMARK = false,
    INLINE_REMARK = false
}
local DECOMPILER_TIMEOUT = ]] .. decomptimeout .. [[
    
local READER_FLOAT_PRECISION = 99
local SHOW_INSTRUCTION_LINES = false
local SHOW_REFERENCES = false
local SHOW_OPERATION_NAMES = false
local SHOW_MISC_OPERATIONS = false
local LIST_USED_GLOBALS = false
local RETURN_ELAPSED_TIME = false
]]
    loadstring(string.gsub(decompsrc, ";;CONSTANTS HERE;;", CONSTANTS), "Advanced-Decompiler-V3")()
end
loaddecomp(1)
loadstring(game:HttpGet('https://raw.githubusercontent.com/t1ware/DexV5/main/dex-v2.lua'))()