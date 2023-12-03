-- premake5.lua

workspace "glm"
    configurations { "Release", "Debug" }
    language "C++"
    cppdialect "C++17"
    platforms { "x86", "x64" }

project "glm"
    kind "StaticLib"
    targetdir "bin/%{cfg.buildcfg}"
    files { "glm/**.hpp", "glm/**.inl", "glm/**.cpp" }

    filter "configurations:Debug"
        symbols "On"

    filter "configurations:Release"
        optimize "On"

    filter {}

if os.getcwd() == os.realpath(_WORKING_DIR) then
    include("test/premake5.lua")

    include("cmake/cmake_uninstall.cmake.in")
    project "uninstall"
        kind "Utility"
        prebuildcommands { "{CMAKE_COMMAND} -P cmake_uninstall.cmake" }
end
