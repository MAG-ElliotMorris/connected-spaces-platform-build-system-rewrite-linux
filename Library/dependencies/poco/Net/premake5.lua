#!lua

if not POCO then
	POCO = {}
end

if not POCO.Net then
	POCO.Net = {}
    
    function POCO.Net.AddProject()
        project "POCONet"
        location "dependencies/poco/Net/build"
        kind "StaticLib"
        language "C++"
        cppdialect "C++17"
		warnings "Off"

        files {
            "%{prj.location}/../**.h",
            "%{prj.location}/../**.cpp",
            "%{prj.location}/../**.c"
        }
        
        defines {
            "POCO_STATIC",
            "POCO_NO_AUTOMATIC_LIBS",
            "POCO_NO_INOTIFY",
            "POCO_NO_FILECHANNEL",
            "POCO_NO_SPLITTERCHANNEL",
            "POCO_NO_SYSLOGCHANNEL",
            "POCO_UTIL_NO_INIFILECONFIGURATION",
            "POCO_UTIL_NO_JSONCONFIGURATION",
            "POCO_UTIL_NO_XMLCONFIGURATION"
        }
            
        externalincludedirs {
            "%{prj.location}/../include",
            "%{prj.location}/../../Foundation/include"
        }
        
        rtti("On")
        
        filter "platforms:x64"
            disablewarnings {
                "4005" -- 'NOMINMAX': macro redefinition
            }

            links {
                "iphlpapi",
            }
        filter "platforms:Android"
            linkoptions { "-lm" } -- For gcc's math lib
            staticruntime("On")

            links {
                "POCOFoundation",
                "POCOUtil"
            }
        filter "system:linux or system:android or system:macosx or system:ios" 
            excludes { 
                "**wepoll.c**",
            }

            defines {
                "POCO_NO_WINDOWS_H"
            }

                --TODO, try to wrap the stdlib selection based on language:C++
            buildoptions {
                "-stdlib=libc++", --Use the libc++ ABI (clang standard library, as opposed to libstdc++ (GCC))
                "-fPIC",
                "-fvisibility=hidden",
                "-fvisibility-inlines-hidden"
            }

            linkoptions {
                "-stdlib=libc++",
                "-lc++abi" --Use the libc++ ABI (clang standard library, as opposed to libstdc++ (GCC))
            }

            buildoptions { "-fPIC" } 
        filter {}
    end
end