-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
-- will upload to
-- https://github.com/xmake-io/xmake-repo
package("cppjieba")
do
    set_homepage("https://github.com/yanyiwu/cppjieba")
    set_description("Chinese word segmentation")

    set_urls("https://github.com/yanyiwu/cppjieba/archive/v$(version).tar.gz",
        "https://github.com/yanyiwu/cppjieba.git")
    add_versions("5.6.1", "34eb8a101707427c437d5ad9da2ecc2120e090ba0ed62b4f6ed7429e2efc3150")

    add_deps("cmake", "ninja", "limonp")

    on_install(function(package)
        import("package.tools.cmake").install(package, { '-GNinja', '-DCPPJIEBA_TOP_LEVEL_PROJECT=OFF' })
    end)
end
package_end()
