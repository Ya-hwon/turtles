shell.setDir("/")
local startup_handle = fs.open("startup.lua", "w")
startup_handle.writeLine("shell.setPath(shell.path()..\":/pkg\")")
startup_handle.writeLine("while true do\npcall(loadstring(io.read()))\nend")
startup_handle.close()

fs.makeDir("pkg")
shell.setDir("/pkg")

local response_handle = http.get("https://raw.githubusercontent.com/Ya-hwon/turtles/dev/pkg/pkg.lua")

if response_handle.getResponseCode() == 200 then
    local pkg_handle = fs.open("/pkg/pkg.lua", "w")
    pkg_handle.write(response_handle.readAll())
    pkg_handle.close()
    print("Installed pkg")
else
    print("Failed to install pkg")
end