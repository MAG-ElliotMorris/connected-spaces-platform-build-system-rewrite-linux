#!lua

if not POCO then
	POCO = {}
end

if not POCO.NETSSL_OpenSSL then
	POCO.NETSSL_OpenSSL = {}
    
    function POCO.NETSSL_OpenSSL.AddProject()
        project "POCONetSSL_OpenSSL"
        location "dependencies/poco/NetSSL_OpenSSL/build"
        kind "StaticLib"
        language "C++"
        cppdialect "C++17"
		warnings "Off"

        files {
            "%{prj.location}/../src/**.cpp",
            "%{prj.location}/../include/**.h"
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
            "%{prj.location}/../../Foundation/include",
            "%{prj.location}/../../Net/include",
            "%{prj.location}/../../Crypto/include",
            "%{prj.location}/../../Util/include",
           -- _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/include"
        }
        
        rtti("On")
        
        filter "platforms:x64"
            externalincludedirs {
                _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/include/platform/win64"
            }

            print(_MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/lib/Win64/VS2015/Release")

            libdirs {
                _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/lib/Win64/VS2015/Release"
            }

            links {
                "crypt32",
                "libcrypto.lib",
                "libssl.lib",
            }
        filter "platforms:Android"
            linkoptions { "-lm" } -- For gcc's math lib
            staticruntime("On")

            externalincludedirs {
                _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/include/platform/android"
            }

            libdirs {
                _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/lib/Android/ARM64"
            }

            links {
                "ssl",            
                "crypto",
            }
        filter "platforms:macosx"
            externalincludedirs {
                _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/include/platform/macos"
            }

            libdirs {
                _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/lib/Mac"
            }

            links {
                "ssl",            
                "crypto",
            }
        filter "platforms:ios"
            externalincludedirs {
                _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/include/platform/ios"
            }

            libdirs {
                _MAIN_SCRIPT_DIR .. "/dependencies/OpenSSL/1.1.1k/lib/IOS"
            }

            links {
                "ssl",            
                "crypto",
            }
        filter "system:linux or system:android or system:macosx or system:ios" 
            excludes { 
                --"**Windows**",
                "**WinRegistry**",
                "**WinService**",
                "**EventLog**" -- Windows-specific logging
            }

            defines {
                "POCO_NO_WINDOWS_H"
            }


            buildoptions { "-fPIC" } 
        filter {}
    end
end
