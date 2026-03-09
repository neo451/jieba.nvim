-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
add_rules("mode.debug", "mode.release")

add_requires("cppjieba")

target("cppjieba")
do
    add_includedirs("$(curdir)")
    add_rules("lua.module", "lua.native-objects")
    add_files("*.cc", "*.nobj.lua")
    add_links("stdc++")
    add_packages("cppjieba")
    before_install(
        function(target)
            local prefix = target:pkg("cppjieba"):installdir()
            -- https://github.com/xmake-io/luarocks-build-xmake/issues/6
            target:add("installfiles", path.join(prefix, "share/cppjieba/(**)"), { prefixdir = "../lua/cppjieba" })
        end
    )
end
