#!lua

if not POCO then
	POCO = {}
end

if not POCO.Util then
	POCO.Util = {}
    
    function POCO.Util.AddProject()
        project "POCOUtil"
        location "dependencies/poco/Util/build"
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
            "POCO_UTIL_NO_XMLCONFIGURATION",
            "UTF8PROC_STATIC"
        }
            
        externalincludedirs {
            "%{prj.location}/../include",
            "%{prj.location}/../src",
            "%{prj.location}/../../Foundation/include",
            "%{prj.location}/../../JSON/include",
            "%{prj.location}/../../XML/include",
        }
        
        rtti("On")
        
        filter "system:linux or system:android or system:macosx or system:ios" 
            excludes { 
                --"**Windows**",
                "**WinRegistry**",
                "**WinService**",
                "**wepoll.c**",
                "**EventLog**" -- Windows-specific logging
            }

            defines {
                "POCO_NO_WINDOWS_H"
            }

            buildoptions { "-fPIC" } 
        filter "platforms:Android"
            linkoptions { "-lm" } -- For gcc's math lib
            staticruntime("On")
            
            links {
                "POCOFoundation"
            }
        filter {}
    end    
end