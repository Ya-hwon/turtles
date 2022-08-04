shell.setDir("/")
local startup_handle = fs.open("startup.lua", "w")
startup_handle.writeLine("shell.setPath(shell.path()..\":/pkg\")")

startup_handle.close()
fs.mkDir("pkg")
shell.setDir("/pkg")

local response_handle = http.get("https://raw.githubusercontent.com/Ya-hwon/turtles/master/pkg/pkg.lua")

if response_handle.getResponseCode() == 200 then
    local pkg_handle = fs.open("/pkg/pkg.lua", "w")
    pkg_handle.write(response.readAll())
    pkg_handle.close()
    print("Installed "..pkg_name)
else
    print("Failed to install "..pkg_name)
end

require "pkg"

install("json")