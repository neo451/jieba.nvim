-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global
---@diagnostic disable: undefined-field
add_rules("mode.debug", "mode.release")

target("jieba")
do
    add_includedirs(".", "cppjieba/include", "cppjieba/deps/limonp/include")
    add_rules("luarocks.module", "lua.native-object")
    add_files("*.cpp", "*.nobj.lua")
    add_links("stdc++")
    before_build(
        -- luacheck: ignore 212/target
        ---@diagnostic disable-next-line: unused-local
        function(target)
            ---@diagnostic disable: undefined-field
            -- luacheck: ignore 143
            if not os.isdir("cppjieba") then
                import("devel.git")
                git.clone("https://github.com/yanyiwu/cppjieba", { depth = 1, recursive = true })
            end
            if not os.isdir("lua/jieba/dict") then
                os.mv("cppjieba/dict", "lua/jieba")
            end
        end
    )
end
