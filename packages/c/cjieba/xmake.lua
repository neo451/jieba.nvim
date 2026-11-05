-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
-- will upload to
-- https://github.com/xmake-io/xmake-repo
package("cjieba")
do
    set_homepage("https://github.com/yanyiwu/cjieba")
    set_description("Chinese word segmentation")

    set_urls("https://github.com/yanyiwu/cjieba/archive/285df97b913b116c4fee2401902cf1173677813d.tar.gz",
        "https://github.com/yanyiwu/cjieba.git")

    add_deps("cppjieba", { version = "5.6.7" })

    on_install(function(package)
        io.writefile("xmake.lua", ([[
    add_rules("mode.debug", "mode.release")
    add_requires("cppjieba%s")
    target("jieba")
    set_kind("$(kind)")
    add_files("lib/*.cpp")
    add_packages("cppjieba")
    add_headerfiles("lib/*.h")
    set_languages("c++17")
]]):format(package:config("version") and " " .. package:config("version") or ""))
        import("package.tools.xmake").install(package, { kind = package:config("shared") and "shared" or "static" })
    end)
end
package_end()
