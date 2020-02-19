# Engineer: Brandon Fong
# TODO
# ...

<### MODULES ###>
    using module .\.\Classes\Calendar.psm1;
    using module .\.\Classes\Math.psm1;
    using module .\.\Classes\SQL.psm1;
    using module .\.\Classes\Web.psm1;
    using module .\.\Classes\Windows.psm1;

<### CONFIG ###>
    Push-Location $($PROFILE |Split-Path -Parent);
        [XML]$x = Get-Content Profile.xml;
    Pop-Location
    $ConfigFile = $x.Machine.GitRepoDir + "\Config\" + $x.Machine.ConfigFile;
    [XML]$XMLReader = Get-Content $ConfigFile

<### CHECK UPDATES ###>
    Write-Host "Checking updates...`n";
    Push-Location $($PROFILE |Split-Path -Parent);
        Get-ChildItem .\Microsoft.PowerShell_profile.ps1|
            ForEach-Object {[datetime]$PSProfile = $_.LastWriteTime}   
    Pop-Location;
    Push-Location $x.Machine.GitRepoDir;
        Get-ChildItem .\Profile.ps1|
            foreach-Object {[datetime]$GitProfile = $_.LastWriteTime}   
    Pop-Location;
    if($GitProfile -gt $PSProfile)
    {
        Write-Warning "There is an update to Powershell profile."
        $update = Read-Host -Prompt "Want to update? (y/n)";
        if($update -eq "y")
        {
            Push-Location $x.Machine.GitRepoDir; 
                .\update-profile.ps1;
            Pop-Location;
        }
    }
    else
    {
        Write-Host "`nNo updates to profile`n";
    }
    
<### ALIASES ###> 
    foreach($val in $XMLReader.Machine.Aliases.Alias)
    {
        Set-Alias $val.Name "$($val.InnerXML)" -Verbose;
    }

<### FUNCTIONS ###> 
    foreach($val in $XMLReader.Machine.Functions.Function)
    {
        $FunctionPath = $x.Machine.GitRepoDir + $val.InnerXML;
        Set-Alias $val.Name "$($FunctionPath)" -Verbose;
    }
    
<### OBJECTS ###>
    foreach($val in $XMLReader.Machine.Objects.Object)
    {
        # if($val.HasClass -eq "true")
        # {
            New-Variable -Name "$($val.VarName)" -Value $val.Class -Force -Verbose;
        # }
        # elseif ($val.HasClass -eq "false")
        # {
        #     New-Variable -Name "$($val.VarName)" -Value $val -Force -Verbose;
        # }
        # else
        # {
        #     Write-Warning "Variable $($val.VarName) was not created.  Please check config."
        # }
        
    }
<### CLASSES ###>
    $Web = [Web]::new();
    $Math = [Calculations]::new();
    $Decode = [SQL]::new($Database.Database.DatabaseName, $Database.ServerInstance  , $Database.Database.Tables);
    $Windows = [Windows]::new();

<### START ###>
    Invoke-Expression $($x.Machine.GitRepoDir + $XMLReader.Machine.StartScript)