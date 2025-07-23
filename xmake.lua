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
end
