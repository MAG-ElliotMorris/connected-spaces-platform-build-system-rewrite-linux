workspace "CppPackagingTest"
    configurations { "Debug", "Release" }
    architecture "x86_64"
    language "C++"
    cppdialect "C++17"

project "MyProject"
    kind "ConsoleApp"
    targetdir "bin/%{cfg.buildcfg}"
    objdir "intermediate/%{cfg.buildcfg}"

    files { "src/main.cpp" }

    defines {
        "USING_CSP_SHARED"
    }

    includedirs { "install/include" }
    libdirs { "install/lib" }
    links { "CSP" }

    filter "system:linux"
        links { "dl", "pthread" } 

    filter "configurations:Debug"
        symbols "On"

    filter "configurations:Release"
        optimize "On"
