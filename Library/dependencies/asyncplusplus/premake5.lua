#!lua

if not AsyncPlusPlus then
	AsyncPlusPlus = {}
end

function AsyncPlusPlus.AddProject()
    project "asyncplusplus"
    location "dependencies/asyncplusplus/build"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"

    warnings "Off"
	
	defines { "LIBASYNC_STATIC" }

    filter "platforms:Android"
        staticruntime("On")
	filter "platforms:wasm"
        buildoptions {
            "-pthread",
            "-fwasm-exceptions"
        }

        linkoptions { 
		    "-pthread",
            "-fwasm-exceptions"
        }
    filter "system:linux"
        buildoptions { "-fPIC" } 
	filter {}
	
    files {
        "%{prj.location}/../include/**.h",
        "%{prj.location}/../include/**.hpp",
        "%{prj.location}/../src/**.c",
		"%{prj.location}/../src/**.cpp",
    }

    -- Source directories for this project
    externalincludedirs { 
        "%{prj.location}/../include",
        "%{prj.location}/../src",
    }
end
