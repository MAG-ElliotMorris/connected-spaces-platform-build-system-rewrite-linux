-- premake5.lua


-- Option to choose library type (static or shared)
newoption {
    trigger     = "build-type",
    description = "What library type to build, static or shared",
    default     = "shared",
     allowed = {
          { "static", "Static Library (.a/.lib)" },
          { "shared", "Shared Library (.so/.dll)" }
       }
}

workspace "ConnectedSpacesPlatformLibrary"
    configurations { "Debug", "Release", "RelWithDebInfo" }
    platforms { "x64" }
    location "build"

    -- Output directory based on configuration, system, and architecture
    outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"


    -- Configuration-specific settings
    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"

    filter "configurations:RelWithDebInfo"
        defines { "NDEBUG" }
        optimize "On"
        symbols "On"

    filter {}  -- clear filter


project "CSP"
    location "build"

    print("Main Premake Directory (_MAIN_SCRIPT_DIR): " .. _MAIN_SCRIPT_DIR)

    -- Choose project type, "StaticLib" and "SharedLib" are the premake spellings of these options
    local libraryKinds = {
        static = "StaticLib",
        shared = "SharedLib",
    }
   kind(libraryKinds[_OPTIONS["build-type"]])

    language "C++"
    cppdialect "C++17"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("intermediate/" .. outputdir .. "/%{prj.name}")

    -- Include source and header files
    files { "src/**.h",
            "src/**.cpp",
            "include/**.h",
            "dependencies/csp-services/generated/**.h",
            "dependencies/csp-services/generated/**.cpp"
    }

    -- Include directories for headers
    includedirs { "include", "src", "dependencies/csp-services/generated" }

   -- Forward the link-type through as a define for use in the codebase
   if _OPTIONS["link-type"] == "shared" then
       defines { "CSP_BUILD_SHARED" }
   end

    rtti("On")

    if os.istarget("windows") then
        include "premake_toolchain_config_msvc.lua"
        include "premake_install_msvc.lua"
        ConfigInstallForMSVC()
        ConfigBuildForMSVC()
    elseif os.istarget("linux") then
        include "premake_toolchain_config_clang.lua"
        include "premake_install_clang.lua"
        ConfigInstallForClang()
        ConfigBuildForClang()
    end

-- Define a custom clean action, should be run from the root Library dir.
newaction {
    trigger     = "clean",
    description = "Remove all generated files and directories",
    execute     = function ()

        local files_to_remove = {
            "./**.make"     -- Remove all Makefiles
        }

        for _, file in ipairs(files_to_remove) do
            print("Removing file: " .. file)
            os.remove(file)
        end

        local function remove_directory(dir)
            if os.isdir(dir) then
                print("Removing directory: " .. dir)
                os.rmdir(dir)
            else
                print("Skipping (not found): " .. dir)
            end
        end

        -- Explicitly remove the build directories for dependencies
        local dirs_to_remove = {
            "./bin",
            "./intermediate",
            "./build",
            "./install",
            "./dependencies/signalrclient/build",
            "./dependencies/quickjs/build",
            "./dependencies/tinyspline/build",
            "./dependencies/asyncplusplus/build",
            "./dependencies/mimalloc/build",
            "./dependencies/poco/Crypto/build",
            "./dependencies/poco/Foundation/build",
            "./dependencies/poco/Net/build",
            "./dependencies/poco/NetSLL_OpenSSL/build",
            "./dependencies/poco/Util/build"
        }

        for _, dir in ipairs(dirs_to_remove) do
            remove_directory(dir)
        end

        print("Clean complete.")
    end
}

-- Create a venv, returning a path to the python executable inside that venv
function CreateVenv(venvDir)
    if not os.isdir(venvDir) then
        os.execute("python3 -m venv " .. venvDir)
    end

    local pythonExecutable
    if os.host() == "windows" then
        pythonExecutable = venvDir .. "\\Scripts\\python"
    else
        pythonExecutable = venvDir .. "/bin/python"
    end

    return pythonExecutable
end

-- Generate the Version.h file needed to let CSP have introspection on its own version. A very good idea.
function RunCSPVersionGenerator()   
    -- Create a venv to run the version generator
    local venvDir = "../Tools/VersionGenerator/venv"
    local venvPython = CreateVenv(venvDir)

    -- Generate the CSP version
    if os.execute(venvPython .. " -m pip install -r ../Tools/VersionGenerator/requirements.txt") ~= true then
        error("Failed to install version generator requirements")
    end

    if os.execute(venvPython .. " ../Tools/VersionGenerator/VersionGenerator.py") ~= true then
        error("Failed to run version generator")
    end
end

-- Define a custom build action, should be run from the root Library dir.
-- Depends on the existance of `\build` dir, which should exist if you have run premake5 before this.
newaction {
    trigger     = "build",
    description = "Navigate to the build directory and run 'make'",
    execute     = function ()

        RunCSPVersionGenerator()

        local buildDir = "build"

        if os.isdir(buildDir) then

            os.chdir(buildDir)

            if os.host() == "windows" then
                local vsSolution = "ConnectedSpacesPlatformLibrary.sln"
                if os.execute("msbuild " .. vsSolution .. " /verbosity:d /m") ~= true then
                    error("Build failed")
                end
            else
                if os.execute("make -j$(nproc)") ~= true then
                    error("Build failed")
                end
            end
            os.chdir("../");
        else
            print("Build directory does not exist. Have you ran premake5 gmake? (or premake5 vs2022)")
        end
    end
}

newaction {
    trigger     = "rebuild",
    description = "Navigate to the build directory and run 'make', with the rebuild flag",
    execute     = function ()

        RunCSPVersionGenerator()

        local buildDir = "build"

        if os.isdir(buildDir) then

            os.chdir(buildDir)

            if os.host() == "windows" then
                local vsSolution = "ConnectedSpacesPlatformLibrary.sln"
                if os.execute("msbuild " .. vsSolution .. " /t:Rebuild /verbosity:d /m") ~= true then
                    error("Build failed")
                end
            else
                if os.execute("make -B -j$(nproc)") ~= true then
                    error("Build failed")
                end
            end
            os.chdir("../");
        else
            print("Build directory does not exist. Have you ran premake5 gmake? (or premake5 vs2022)")
        end
    end
}