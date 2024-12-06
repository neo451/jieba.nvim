-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global
---@diagnostic disable: undefined-field
add_rules("mode.debug", "mode.release")

rule("lua-native-object")
do
    set_extensions(".nobj.lua")
    before_buildcmd_file(function(target, batchcmds, sourcefile, opt)
        -- get c source file for lua-native-object
        local dirname = path.join(target:autogendir(), "rules", "lua-native-object")
        local sourcefile_c = path.join(dirname, path.basename(sourcefile) .. ".c")

        -- add objectfile
        local objectfile = target:objectfile(sourcefile_c)
        table.insert(target:objectfiles(), objectfile)

        -- add commands
        batchcmds:show_progress(opt.progress, "${color.build.object}compiling.nobj.lua %s", sourcefile)
        batchcmds:mkdir(path.directory(sourcefile_c))
        batchcmds:vrunv("native_objects.lua",
            { "-outpath", dirname, "-gen", "lua", path(sourcefile) })
        batchcmds:compile(sourcefile_c, objectfile)

        -- add deps
        batchcmds:add_depfiles(sourcefile)
        batchcmds:set_depmtime(os.mtime(objectfile))
        batchcmds:set_depcache(target:dependfile(objectfile))
    end)
end

target("jieba")
do
    add_includedirs(".", "cppjieba/include", "cppjieba/deps/limonp/include")
    add_rules("luarocks.module", "lua-native-object")
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
