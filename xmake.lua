-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
includes("packages/c/cppjieba")
add_rules("mode.debug", "mode.release")

add_requires("cppjieba")

target("jieba")
do
    add_includedirs("$(curdir)")
    add_rules("lua.module", "lua.native-objects")
    add_files("*.cc", "*.nobj.lua")
    add_links("stdc++")
    add_packages("cppjieba")
    before_build(
    -- luacheck: ignore 212/target
    ---@diagnostic disable-next-line: unused-local
        function(target)
            ---@diagnostic disable: undefined-field
            -- luacheck: ignore 143
            if not os.isdir("lua/jieba/dict") then
                import("net.http")
                import("utils.archive")

                local version = "5.6.0"
                local url = "https://github.com/yanyiwu/cppjieba/archive/v" .. version .. ".zip"
                local zip = path.filename(url)
                os.tryrm(zip)
                http.download(url, zip)
                local sourcedir = "cppjieba-" .. version
                os.tryrm(sourcedir)
                if archive.extract(zip, ".") then
                    os.mv(sourcedir .. "/dict", "lua/jieba")
                end
                os.tryrm(sourcedir)
                os.tryrm(zip)
            end
        end
    )
end
