-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
-- will upload to
-- https://github.com/xmake-io/xmake-repo
package("limonp")
do
    set_homepage("https://github.com/yanyiwu/limonp")
    set_description("C++ headers(hpp) library with Python style")

    set_urls("https://github.com/yanyiwu/limonp/archive/v$(version).tar.gz",
        "https://github.com/yanyiwu/limonp.git")
    add_versions("1.0.1", "c7b18794f020dbaa1006229b49a39217a463da0cb3586aee83eb7471f4ae71df")

    add_deps("cmake", "ninja")

    on_install(function(package)
        -- https://github.com/yanyiwu/limonp/pull/37
        io.replace("CMakeLists.txt", "DATADIR}/${PROJECT_NAME}/cmake",
            "LIBDIR}/cmake/${PROJECT_NAME}", { plain = true })
        import("package.tools.cmake").install(package, { '-GNinja' })
    end)
end
package_end()
