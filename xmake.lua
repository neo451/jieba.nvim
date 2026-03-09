-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
add_rules("mode.debug", "mode.release")

local version = "5.6.0"
add_requires(("cppjieba %s"):format(version))

target("cppjieba")
do
    add_includedirs("$(curdir)")
    add_rules("lua.module", "lua.native-objects")
    add_files("*.cc", "*.nobj.lua")
    add_links("stdc++")
    add_packages("cppjieba")
    before_install(
    -- luacheck: ignore 212/target
    ---@diagnostic disable-next-line: unused-local
        function(target)
            ---@diagnostic disable: undefined-field
            -- luacheck: ignore 143
            if not os.isdir("lua/cppjieba/dict") then
                import("net.http")
                import("utils.archive")

                local url = ("https://github.com/yanyiwu/cppjieba/archive/v%s.zip"):format(version)
                local zip = path.filename(url)
                os.tryrm(zip)
                http.download(url, zip)
                local sourcedir = ("cppjieba-%s"):format(version)
                os.tryrm(sourcedir)
                if archive.extract(zip, ".") then
                    os.mv(("%s/dict"):format(sourcedir), "lua/cppjieba")
                end
                os.tryrm(sourcedir)
                os.tryrm(zip)
            end
        end
    )
end
