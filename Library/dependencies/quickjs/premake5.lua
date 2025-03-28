#!lua

if not QuickJS then
	QuickJS = {}
end

function QuickJS.AddProject()
    project "quickjs"
    location "dependencies/quickjs/build"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"

    defines { 
        "_HAS_EXCEPTIONS=0",
        "_GNU_SOURCE" --For environ on linux
    }

    warnings "Off"

    filter "platforms:x64"
        defines { 
            "JS_STRICT_NAN_BOXING"
        }
    filter "system:linux"
        buildoptions { "-fPIC" } 
    filter "platforms:macosx"
        defines { 
            "JS_STRICT_NAN_BOXING"
        }    
    filter "platforms:ios"
        defines { 
            "JS_STRICT_NAN_BOXING"
        }
    filter "platforms:Android"
        staticruntime("On")
    filter {}
	
    files {
        "%{prj.location}/../**.h",
        "%{prj.location}/../**.hpp",
        "%{prj.location}/../src/**.c",
    }

    -- Source directories for this project
    externalincludedirs { 
        "%{prj.location}/../include",
        "%{prj.location}/../src",
    }
end
