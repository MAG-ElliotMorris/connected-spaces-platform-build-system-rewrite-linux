workspace "CppPackagingTest"
    configurations { "Debug", "Release" }
    architecture "x86_64"
    language "C++"
    cppdialect "C++17"

project "CppPackagingTest"
    kind "ConsoleApp"
    targetdir "bin/%{cfg.buildcfg}"
    objdir "intermediate/%{cfg.buildcfg}"

    files { "src/main.cpp" }

    defines {
        "USING_CSP_SHARED"
    }

    includedirs { "install/include" }
    links { "CSP" }

    filter "system:windows"
        toolset "msc"
        libdirs { "install/bin" }

    filter "system:linux"
        toolset "clang"
        links { "dl", "pthread" } 
        libdirs { "install/lib" }

        buildoptions {
            "-stdlib=libc++", --Use the libc++ ABI (clang standard library, as opposed to libstdc++ (GCC))
            "-fPIC"
        }
            
        linkoptions {
            "-stdlib=libc++",
            "-lc++abi" --Use the libc++ ABI (clang standard library, as opposed to libstdc++ (GCC))
        }

    filter "configurations:Debug"
        symbols "On"

    filter "configurations:Release"
        optimize "On"
