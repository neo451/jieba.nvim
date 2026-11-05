-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
includes("packages/c/cjieba")
add_rules("mode.debug", "mode.release")

local version = "5.6.7"
add_requires("cjieba", { version = version })

target("cppjieba")
do
    add_rules("lua.module", "lua.native-objects")
    add_files("*.nobj.lua")
    add_packages("cjieba")
    -- needed for adding cjieba
    set_languages("c++17")
    before_install(
    -- luacheck: ignore 212/target
    ---@diagnostic disable-next-line: unused-local
        function(target)
            ---@diagnostic disable: undefined-field
            -- luacheck: ignore 143
            if not os.isdir("etc/conf") then
                local url = ("https://github.com/yanyiwu/cppjieba/archive/v%s.zip"):format(version)
                local zip = path.filename(url)
                if not os.isfile(zip) then
                    import("net.http")
                    http.download(url, zip)
                end
                local sourcedir = ("cppjieba-%s"):format(version)
                os.tryrm(sourcedir)
                import("utils.archive")
                if archive.extract(zip, ".") then
                    os.mv(sourcedir .. "/dict/*.utf8", "etc/conf/", { rootdir = sourcedir .. "/dict" })
                    os.mv(sourcedir .. "/dict/pos_dict/*.utf8", "etc/conf/pos_dict/", { rootdir = sourcedir .. "/dict/pos_dict" })
                end
            end
        end
    )
end
