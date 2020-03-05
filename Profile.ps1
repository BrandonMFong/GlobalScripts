# Engineer: Brandon Fong
# TODO
# ...

<### CONFIG ###>
Push-Location $($PROFILE |Split-Path -Parent);
    [XML]$x = Get-Content Profile.xml;
Pop-Location
$ConfigFile = $x.Machine.GitRepoDir + "\Config\" + $x.Machine.ConfigFile;
[XML]$XMLReader = Get-Content $ConfigFile

Push-Location $x.Machine.GitRepoDir; 

    <### CHECK UPDATES ###>
        if(.\update-profile.ps1){.$PROFILE;exit;};
        
    <### ALIASES ###> 
        foreach($val in $XMLReader.Machine.Aliases.Alias)
        {
            Set-Alias $val.Name "$($val.InnerXML)" -Verbose;
        }

    <### FUNCTIONS ###> 
        foreach($val in $XMLReader.Machine.Functions.Function)
        {Set-Alias $val.Name "$($x.Machine.GitRepoDir + $val.InnerXML)" -Verbose;}
        
    <### OBJECTS ###>
        Import-Module $($x.Machine.GitRepoDir + '\Modules\MakeClassObject.psm1');
        foreach($val in $XMLReader.Machine.Objects.Object)
        {
            if($val.HasClass -eq "true"){New-Variable -Name "$($val.VarName)" -Value $(MakeClass -XmlElement $val) -Force -Verbose;}
            else {New-Variable -Name "$($val.VarName)" -Value $val -Force -Verbose;}
        }
    
    <### START ###>
        if($XMLReader.Machine.StartScript.ClearHost -eq "true"){Clear-Host;}
        Invoke-Expression $($x.Machine.GitRepoDir + $XMLReader.Machine.StartScript.InnerXML)

Pop-Location;