#!lua

if not SignalRClient then
	SignalRClient = {}
end

function SignalRClient.AddProject()
    project "signalrclient"
    location "dependencies/signalrclient/build"
    kind "StaticLib"
    language "C++"
    cppdialect "C++14" --std::binary_function was removed in c++17
	warnings "Off"

    files {
        "%{prj.location}/../**.h",
        "%{prj.location}/../**.cpp",
    }
    
    defines { "NO_SIGNALRCLIENT_EXPORTS", "USE_MSGPACK" }

    -- Source directories for this project
    externalincludedirs { 
        "%{prj.location}/../include",
        "%{prj.location}/../src",
        "%{prj.location}/../third_party_code/jsoncpp",
        "%{prj.location}/../third_party_code/cpprestsdk",
        _MAIN_SCRIPT_DIR .. "/dependencies/msgpack/include"
    }
    
    -- Config for platforms
    filter "platforms:Android"
        disablewarnings { "unknown-pragmas" }
        staticruntime("On")
    filter "platforms:wasm"
        --[[
            We need to explicitly enable threading in the WASM build.
            This used to be done for all projects in the RWD project, but was
            removed to prevent confusion when debugging premake issues.
        ]]--
        buildoptions {
            "-pthread",
            "-fwasm-exceptions"
        }

        linkoptions { 
            "-fwasm-exceptions"
        }
    filter "system:linux"
        buildoptions { "-fPIC" } 
    filter {}
end