-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
-- will upload to
-- https://github.com/xmake-io/xmake-repo
includes("../../l/limonp")
package("cppjieba")
do
    set_homepage("https://github.com/yanyiwu/cppjieba")
    set_description("Chinese word segmentation")

    set_urls("https://github.com/yanyiwu/cppjieba/archive/9408c1d08facc6e324dc90260e8cb20ecceebf70.tar.gz",
        "https://github.com/yanyiwu/cppjieba.git")
    add_versions("5.6.0", "ccc30d542f1b856a66fbb29bba6c27938c1792a675203c2f83876ab4b5ed933b")

    add_deps("cmake", "ninja", "limonp")

    on_install(function(package)
        import("package.tools.cmake").install(package, { '-GNinja', '-DCPPJIEBA_TOP_LEVEL_PROJECT=OFF' })
    end)
end
package_end()
