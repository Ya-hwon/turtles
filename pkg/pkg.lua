function remove_all()
    fs.delete("/startup.lua")
    fs.delete(".settings")
    fs.delete("/pkg")
end

function install (pkg_name, branch, repo, user)
    branch = branch or settings.get("branch") or "master"
    repo = repo or settings.get("repo") or "turtles"
    user = user or settings.get("user") or "Ya-hwon"

    local content = http.get("https://raw.githubusercontent.com/"..user.."/"..repo.."/"..branch.."/pkg/"..pkg_name..".lua")

    if content.getResponseCode() == 200 then
        local file = fs.open("/pkg/"..pkg_name..".lua", "w")
        file.write(content.readAll())
        file.close()
        print("pkg> installed "..pkg_name)
    else
        error("pkg> failed to install "..pkg_name)
        exit()
    end
end

function req_pkg(pkg_name, ...)
    local status, lib = pcall(require, "/pkg/"..pkg_name)
    if status then 
        return lib 
    end
    print("pkg> missing dependency "..pkg_name.." -> installing")
    install(pkg_name, ...)
end


json = req_pkg("json", settings.get("branch") or "master")


function install_all(branch, repo, user)
    branch = branch or settings.get("branch") or "master"
    repo = repo or settings.get("repo") or "turtles"
    user = user or settings.get("user") or "Ya-hwon"

    local file_list = http.get("https://api.github.com/repos/"..user.."/"..repo.."/git/trees/"..branch.."?recursive=1")
    if file_list.getResponseCode() == 200 then
        local file_tree = json.decode(file_list.readAll()).tree
        
        for _,file in ipairs(file_tree) do 
            if file.path:match "pkg/.*\.lua" then
                local pkg_name = file.path:match "pkg/(.*)\.lua"
                print("pkg> found pkg "..pkg_name.." -> installing")
                install(pkg_name, branch, repo, user)
            end
        end
    else
        error("pkg> failed to get package list ")
        exit()
    end
end