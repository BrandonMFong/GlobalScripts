# Engineer: Brandon Fong
# TODO
# ...

<### CONFIG ###>
Push-Location $($PROFILE |Split-Path -Parent);
    [XML]$AppPointer = Get-Content Profile.xml;
Pop-Location
$ConfigFile = $AppPointer.Machine.GitRepoDir + "\Config\" + $AppPointer.Machine.ConfigFile;
[XML]$XMLReader = Get-Content $ConfigFile

Push-Location $AppPointer.Machine.GitRepoDir; 
    Import-Module .\Modules\FunctionModules.psm1;
    Import-Module .\Modules\Prompt.psm1;

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){throw "Profile was updated, please rerun Profile load.";}
        
    <### PROGRAMS ###> 
        LoadPrograms -XMLReader $XMLReader -AppPointer $AppPointer
    
    <### MODULES ###>
        LoadModules -XMLReader $XMLReader -AppPointer $AppPointer
        
    <### OBJECTS ###>
        LoadObjects -XMLReader $XMLReader -AppPointer $AppPointer
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        Invoke-Expression $($AppPointer.Machine.GitRepoDir + $XMLReader.Machine.StartScript.InnerXML)

    try 
    {
        Write-Host "Version - $(git describe --tags) `n" -ForegroundColor Gray;
    }
    catch 
    {
        Write-Warning "You may not have posh-git installed in powershell"
    }

Pop-Location;