-- Install step for MSVC (Windows)
-- Invoked automatically after build, via include in the main Premake script

function ConfigInstallForMSVC()
    
    local topLevelDir = "%{wks.location}/../" -- wks.location will be /build here.

    local copyLibCommand = 'xcopy /E /I /Y /H "%{cfg.buildtarget.directory}" "' .. topLevelDir .. 'install/bin/"'
    local copyHeadersCommand = 'xcopy /E /I /Y /H "' .. topLevelDir .. 'include/CSP" "' .. topLevelDir .. 'install/include/CSP"'

    postbuildcommands {
        'mkdir "' .. topLevelDir .. 'install/bin"',
        'mkdir "' .. topLevelDir .. 'install/include/CSP"',
        copyLibCommand,
        copyHeadersCommand
    }
end