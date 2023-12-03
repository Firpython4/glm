-- premake5.lua

workspace "glm"
    configurations { "Release", "Debug" }
    language "C++"
    cppdialect "C++17"
    platforms { "x86", "x64" }

option("GLM_QUIET" "No CMake Message" OFF)
option("BUILD_SHARED_LIBS" "Build shared library" ON)
option("BUILD_STATIC_LIBS" "Build static library" ON)
option("GLM_TEST_ENABLE_CXX_98" "Enable C++ 98" OFF)
option("GLM_TEST_ENABLE_CXX_11" "Enable C++ 11" OFF)
option("GLM_TEST_ENABLE_CXX_14" "Enable C++ 14" OFF)
option("GLM_TEST_ENABLE_CXX_17" "Enable C++ 17" OFF)
option("GLM_TEST_ENABLE_CXX_20" "Enable C++ 20" OFF)

flags { "C++17" }

if _OPTIONS["GLM_TEST_ENABLE_CXX_20"] then
    flags { "C++20" }
    defines { "GLM_FORCE_CXX2A" }
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Build with C++20 features")
    end

elseif _OPTIONS["GLM_TEST_ENABLE_CXX_17"] then
    flags { "C++17" }
    defines { "GLM_FORCE_CXX17" }
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Build with C++17 features")
    end

elseif _OPTIONS["GLM_TEST_ENABLE_CXX_14"] then
    flags { "C++14" }
    defines { "GLM_FORCE_CXX14" }
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Build with C++14 features")
    end

elseif _OPTIONS["GLM_TEST_ENABLE_CXX_11"] then
    flags { "C++11" }
    defines { "GLM_FORCE_CXX11" }
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Build with C++11 features")
    end

elseif _OPTIONS["GLM_TEST_ENABLE_CXX_98"] then
    flags { "C++98" }
    defines { "GLM_FORCE_CXX98" }
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Build with C++98 features")
    end
end

option("GLM_TEST_ENABLE_LANG_EXTENSIONS" "Enable language extensions" OFF)
option("GLM_DISABLE_AUTO_DETECTION" "Enable language extensions" OFF)

if _OPTIONS["GLM_DISABLE_AUTO_DETECTION"] then
    defines { "GLM_FORCE_PLATFORM_UNKNOWN", "GLM_FORCE_COMPILER_UNKNOWN", "GLM_FORCE_ARCH_UNKNOWN", "GLM_FORCE_CXX_UNKNOWN" }
end

if _OPTIONS["GLM_TEST_ENABLE_LANG_EXTENSIONS"] then
    flags { "EnableC++17" }
    if (string.match(_ACTION, "gmake")) then
        buildoptions { "-fms-extensions" }
    end
    print("GLM: Build with C++ language extensions")
else
    flags { "NoExtensions" }
    if (_OPTIONS["CC"] == "msc") then
        buildoptions { "/Za" }
        if (_OPTIONS["CCVERSION"] >= "19.0") then
            buildoptions { "/permissive-" }
        end
    end
end

option("GLM_TEST_ENABLE_FAST_MATH" "Enable fast math optimizations" OFF)

if _OPTIONS["GLM_TEST_ENABLE_FAST_MATH"] then
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Build with fast math optimizations")
    end

    if (_OPTIONS["CC"] == "clang") or (_OPTIONS["CC"] == "gcc") then
        buildoptions { "-ffast-math" }

    elseif (_OPTIONS["CC"] == "msc") then
        buildoptions { "/fp:fast" }
    end

else
    if (_OPTIONS["CC"] == "msc") then
        buildoptions { "/fp:precise" }
    end
end

option("GLM_TEST_ENABLE" "Build unit tests" ON)
option("GLM_TEST_ENABLE_SIMD_SSE2" "Enable SSE2 optimizations" OFF)
option("GLM_TEST_ENABLE_SIMD_SSE3" "Enable SSE3 optimizations" OFF)
option("GLM_TEST_ENABLE_SIMD_SSSE3" "Enable SSSE3 optimizations" OFF)
option("GLM_TEST_ENABLE_SIMD_SSE4_1" "Enable SSE 4.1 optimizations" OFF)
option("GLM_TEST_ENABLE_SIMD_SSE4_2" "Enable SSE 4.2 optimizations" OFF)
option("GLM_TEST_ENABLE_SIMD_AVX" "Enable AVX optimizations" OFF)
option("GLM_TEST_ENABLE_SIMD_AVX2" "Enable AVX2 optimizations" OFF)
option("GLM_TEST_FORCE_PURE" "Force 'pure' instructions" OFF)

if _OPTIONS["GLM_TEST_FORCE_PURE"] then
    defines { "GLM_FORCE_PURE" }
    if (_OPTIONS["CC"] == "gcc") then
        buildoptions { "-mfpmath=387" }
    end
    print("GLM: No SIMD instruction set")

elseif _OPTIONS["GLM_TEST_ENABLE_SIMD_AVX2"] then
    defines { "GLM_FORCE_INTRINSICS" }
    if (_OPTIONS["CC"] == "gcc") or (_OPTIONS["CC"] == "clang") then
        buildoptions { "-mavx2" }
    elseif (_OPTIONS["CC"] == "icc") then
        buildoptions { "/QxAVX2" }
    elseif (_OPTIONS["CC"] == "msc") then
        buildoptions { "/arch:AVX2" }
    end
    print("GLM: AVX2 instruction set")

elseif _OPTIONS["GLM_TEST_ENABLE_SIMD_AVX"] then
    defines { "GLM_FORCE_INTRINSICS" }
    if (_OPTIONS["CC"] == "gcc") or (_OPTIONS["CC"] == "clang") then
        buildoptions { "-mavx" }
    elseif (_OPTIONS["CC"] == "icc") then
        buildoptions { "/QxAVX" }
    elseif (_OPTIONS["CC"] == "msc") then
        buildoptions { "/arch:AVX" }
    end
    print("GLM: AVX instruction set")

elseif _OPTIONS["GLM_TEST_ENABLE_SIMD_SSE4_2"] then
    defines { "GLM_FORCE_INTRINSICS" }
    if (_OPTIONS["CC"] == "gcc") or (_OPTIONS["CC"] == "clang") then
        buildoptions { "-msse4.2" }
    elseif (_OPTIONS["CC"] == "icc") then
        buildoptions { "/QxSSE4.2" }
    elseif (_OPTIONS["CC"] == "msc") and not os.is64bit() then
        buildoptions { "/arch:SSE2" } -- VC doesn't support SSE4.2
    end
    print("GLM: SSE4.2 instruction set")

elseif _OPTIONS["GLM_TEST_ENABLE_SIMD_SSE4_1"] then
    defines { "GLM_FORCE_INTRINSICS" }
    if (_OPTIONS["CC"] == "gcc") or (_OPTIONS["CC"] == "clang") then
        buildoptions { "-msse4.1" }
    elseif (_OPTIONS["CC"] == "icc") then
        buildoptions { "/QxSSE4.1" }
    elseif (_OPTIONS["CC"] == "msc") and not os.is64bit() then
        buildoptions { "/arch:SSE2" } -- VC doesn't support SSE4.1
    end
    print("GLM: SSE4.1 instruction set")

elseif _OPTIONS["GLM_TEST_ENABLE_SIMD_SSSE3"] then
    defines { "GLM_FORCE_INTRINSICS" }
    if (_OPTIONS["CC"] == "gcc") or (_OPTIONS["CC"] == "clang") then
        buildoptions { "-mssse3" }
    elseif (_OPTIONS["CC"] == "icc") then
        buildoptions { "/QxSSSE3" }
    elseif (_OPTIONS["CC"] == "msc") and not os.is64bit() then
        buildoptions { "/arch:SSE2" } -- VC doesn't support SSSE3
    end
    print("GLM: SSSE3 instruction set")

elseif _OPTIONS["GLM_TEST_ENABLE_SIMD_SSE3"] then
    defines { "GLM_FORCE_INTRINSICS" }
    if (_OPTIONS["CC"] == "gcc") or (_OPTIONS["CC"] == "clang") then
        buildoptions { "-msse3" }
    elseif (_OPTIONS["CC"] == "icc") then
        buildoptions { "/QxSSE3" }
    elseif (_OPTIONS["CC"] == "msc") and not os.is64bit() then
        buildoptions { "/arch:SSE2" } -- VC doesn't support SSE3
    end
    print("GLM: SSE3 instruction set")

elseif _OPTIONS["GLM_TEST_ENABLE_SIMD_SSE2"] then
    defines { "GLM_FORCE_INTRINSICS" }
    if (_OPTIONS["CC"] == "gcc") or (_OPTIONS["CC"] == "clang") then
        buildoptions { "-msse2" }
    elseif (_OPTIONS["CC"] == "icc") then
        buildoptions { "/QxSSE2" }
    elseif (_OPTIONS["CC"] == "msc") then
        buildoptions { "/arch:SSE2" }
    end
    print("GLM: SSE2 instruction set")
end

-- Compiler and default options

if (_OPTIONS["CC"] == "clang") then
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Clang - " .. _OPTIONS["CC"] .. " compiler")
    end

    buildoptions { "-Werror", "-Weverything" }
    buildoptions { "-Wno-c++98-compat", "-Wno-c++98-compat-pedantic", "-Wno-c++11-long-long", "-Wno-padded", "-Wno-gnu-anonymous-struct", "-Wno-nested-anon-types" }
    buildoptions { "-Wno-undefined-reinterpret-cast", "-Wno-sign-conversion", "-Wno-unused-variable", "-Wno-missing-prototypes", "-Wno-unreachable-code", "-Wno-missing-variable-declarations" }
    buildoptions { "-Wno-sign-compare", "-Wno-global-constructors", "-Wno-unused-macros", "-Wno-format-nonliteral", "-Wno-float-equal" }

elseif (_OPTIONS["CC"] == "gcc") then
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: GCC - " .. _OPTIONS["CC"] .. " compiler")
    end

    buildoptions { "-O2" }

elseif (_OPTIONS["CC"] == "icc") then
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Intel - " .. _OPTIONS["CC"] .. " compiler")
    end

elseif (_OPTIONS["CC"] == "msc") then
    if not _OPTIONS["GLM_QUIET"] then
        print("GLM: Visual C++ - " .. _OPTIONS["CC"] .. " compiler")
    end

    buildoptions { "/W4", "/WX" }
    buildoptions { "/wd4309", "/wd4324", "/wd4389", "/wd4127", "/wd4267", "/wd4146", "/wd4201", "/wd4464", "/wd4514", "/wd4701", "/wd4820", "/wd4365" }
    defines { "_CRT_SECURE_NO_WARNINGS" }
end

function glmCreateTestGTC(NAME)
    local SAMPLE_NAME = "test-" .. NAME
    project(SAMPLE_NAME)
        kind "ConsoleApp"
        files { NAME .. ".cpp" }
        links { "glm" }
        filter "configurations:Debug"
            symbols "On"
        filter "configurations:Release"
            optimize "On"
        filter {}
        if not _OPTIONS["GLM_TEST_ENABLE"] then
            targetname("DISABLED_" .. SAMPLE_NAME)
        end
    end

    if _OPTIONS["GLM_TEST_ENABLE"] then
        glmCreateTestGTC("bug")
        glmCreateTestGTC("core")
        glmCreateTestGTC("ext")
        glmCreateTestGTC("gtc")
        glmCreateTestGTC("gtx")
        glmCreateTestGTC("perf")
    end
