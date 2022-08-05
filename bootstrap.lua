shell.setDir("/")
local startup_handle = fs.open("startup.lua", "w")
startup_handle.writeLine("shell.setPath(shell.path()..\":/pkg\")")

settings.set("branch", "dev")
settings.set("repo", "turtles")
settings.set("user", "Ya-hwon")

settings.save(".settings")

startup_handle.writeLine(
"\
settings.load(\".settings\")\n\
for _,file in ipairs(fs.list(\"/pkg\")) do\n\
    os.loadAPI(\"/pkg/\"..file)\n\
end"
)
startup_handle.writeLine(
"while true do\n\
    print(pcall(loadstring(\"return \"..io.read())))\n\
end"
)
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

os.reboot()