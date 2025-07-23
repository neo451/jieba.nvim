-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global, undefined-field
-- will upload to
-- https://github.com/xmake-io/xmake-repo
includes("../../l/limonp")
package("cppjieba")
do
    set_homepage("https://github.com/yanyiwu/cppjieba")
    set_description("Chinese word segmentation")

    set_urls("https://github.com/yanyiwu/cppjieba/archive/v$(version).tar.gz",
        "https://github.com/yanyiwu/cppjieba.git")
    add_versions("5.6.0", "e6e517b778e0f4a99cbed1ee3eaa041616b74bc685e03a6ca08887ad9cedfe49")

    add_deps("cmake", "ninja", "limonp")

    on_install(function(package)
        -- https://github.com/yanyiwu/cppjieba/pull/206
        io.replace("CMakeLists.txt", "INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/deps/limonp/include",
            [[find_package(limonp)
if(limonp_FOUND)
    get_target_property(LIMONP_INCLUDE_DIR limonp::limonp INTERFACE_INCLUDE_DIRECTORIES)
else()
    set(LIMONP_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/deps/limonp/include")
endif()
include(GNUInstallDirs)
install(DIRECTORY include/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(DIRECTORY dict/
        DESTINATION ${CMAKE_INSTALL_DATADIR}/cppjieba/dict)
INCLUDE_DIRECTORIES("${LIMONP_INCLUDE_DIR}"]],
            { plain = true })
        import("package.tools.cmake").install(package, { '-GNinja', '-DCPPJIEBA_TOP_LEVEL_PROJECT=OFF' })
    end)
end
package_end()
