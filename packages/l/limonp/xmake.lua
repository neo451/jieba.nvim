-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
-- will upload to
-- https://github.com/xmake-io/xmake-repo
package("limonp")
do
    set_homepage("https://github.com/yanyiwu/limonp")
    set_description("C++ headers(hpp) library with Python style")

    set_urls("https://github.com/yanyiwu/limonp/archive/8c50bfd6fc05c51e89ba36b02aad6b9531995d73.tar.gz",
        "https://github.com/yanyiwu/limonp.git")
    add_versions("1.0.1", "57f57944ebe0078e64b240f071515b1d2692cb66479aed5de392070b48936d44")

    add_deps("cmake", "ninja")

    on_install(function(package)
        import("package.tools.cmake").install(package, { '-GNinja' })
    end)
end
package_end()
