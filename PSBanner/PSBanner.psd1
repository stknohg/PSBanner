#
# Module manifest
#
@{
    GUID              = 'f60e6bc5-d535-488f-a246-494c511d59e3'
    ModuleVersion     = '0.4'
    Description       = 'Banner written in PowerShell.'

    Author            = 'stknohg'
    CompanyName       = 'stknohg'
    Copyright         = '(c) 2016 stknohg. All rights reserved.'

    NestedModules     = @('PSBanner.psm1')
    #RequiredAssemblies = @('System.Drawing')

    # TypesToProcess = @()
    # FormatsToProcess = @()
    FunctionsToExport = @('Get-FontFamilies', 'Write-Banner')
    AliasesToExport   = @('psbanner')

    PrivateData       = @{
        PSData = @{
            Tags       = @('Banner')
            ProjectUri = 'https://github.com/stknohg/PSBanner'
            LicenseUri = 'https://github.com/stknohg/PSBanner/blob/master/LICENSE'
            # IconUri = ''
            # ReleaseNotes = ''
        }
    }
}