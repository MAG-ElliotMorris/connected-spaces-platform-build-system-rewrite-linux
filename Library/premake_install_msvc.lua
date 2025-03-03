-- Install step for MSVC (Windows)
-- Invoked automatically after build, via include in the main Premake script

function ConfigInstallForMSVC()
    
    local topLevelDir = "%{wks.location}/../" -- wks.location will be /build here.

    local copyLibCommand = 'xcopy /E /I /Y /H "' .. topLevelDir .. 'bin" "' .. topLevelDir .. 'install\\bin'
    local copyHeadersCommand = 'xcopy /E /I /Y /H "' .. topLevelDir .. 'include\\CSP" "' .. topLevelDir .. 'install\\include"'

    postbuildcommands {
        'mkdir "' .. topLevelDir .. 'install\\bin"',
        'mkdir "' .. topLevelDir .. 'install\\include"',
        copyLibCommand,
        copyHeadersCommand
    }
end