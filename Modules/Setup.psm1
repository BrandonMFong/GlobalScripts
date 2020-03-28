
function MakeXMLFile
{
    [XML]$File = [XML]::new();
    $Node_Machine = $File.CreateElement("Machine");
    $Node_Machine.SetAttribute("MachineName",$env:COMPUTERNAME);
    $Node_GitRepoDir = $File.CreateElement("GitRepoDir");
    $Node_ConfigFile = $File.CreateElement("ConfigFile");
    $File.AppendChild($Node_Machine);
    $File.Machine.AppendChild($Node_GitRepoDir)
    $File.Machine.AppendChild($Node_ConfigFile)
    $File.Machine.GitRepoDir = $($PSScriptRoot | Split-Path -Parent).ToString();
    $File.Machine.ConfigFile = $($env:COMPUTERNAME.ToString() + ".xml");
    return $File;
}

function GetContents # static
{
    Param([xml]$x)
    Write-Host("Machine Name : $($x.Machine.MachineName)");
    Write-Host("Git Repository Directory : $($x.Machine.GitRepoDir)");
    Write-Host("Configuration File : $($x.Machine.GitRepoDir)");
}
function InitPointer
{
    while(($x -ne 'y') -and ($x -ne 'n'))
    {
        $x = Read-Host -Prompt "Do you want to create your own config (y) or use another in the directory(n)?"
    }

    if ($x -eq 'y')
    {
        [XML]$NewXml = MakeXMLFile;
        GetContents($NewXml);
        if($(Read-Host -Prompt "Approve? (y/n)") -eq "y")
        {
            $NewXml.Save($($PRFOILE | Split-Path -Parent).ToString() + "\Profile.xml");
        }
        else {throw "Please restart setup then."} # maybe call this function again
    }
    else 
    {
        [Xml]$NewXml = MakeXMLFile;
        $NewXml.Save($($PRFOILE | Split-Path -Parent).ToString() + "\Profile.xml");
        .\.\update-config.ps1;
    }
}

function InitProfile
{
    if(Test-Path $Profile)
    {
        New-Item –Path $Profile –Type File –Force
    }
}

function InitConfig
{
    [XML]$File = [XML]::new();

    # <Machine>
    $Node_Machine = $File.CreateElement("Machine");
    $Node_Machine.SetAttribute("MachineName",$env:COMPUTERNAME);
    $Node_Machine.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    $Node_Machine.SetAttribute("xsi:noNamespaceSchemaLocation","..\Schema\Powershell.xsd");
    $File.AppendChild($Node_Machine);#Node

    # <StartScript>
    $Node_StartScript = $File.CreateElement("StartScript");
    $Node_StartScript.SetAttribute("ClearHost","false");
    New-Item $($($PSScriptRoot|Split-Path -Parent) + "\StartScripts\" + $env:COMPUTERNAME + "ps1") -Value "Echo Hello World";
    $File.Machine.AppendChild($Node_StartScript); # Append
    $File.Machine.StartScript = $($($PSScriptRoot|Split-Path -Parent) + "\StartScripts\" + $env:COMPUTERNAME + "ps1");
    
    # <Prompt>
    $Node_Prompt = $File.CreateElement("Prompt");
    $File.Machine.AppendChild($Node_Prompt);
    
    # <DateFormat>
    $Node_DateFormat = $File.CreateElement("DateFormat");
    $File.Machine.Prompt.AppendChild($Node_DateFormat);#Node

    # String
    $Node_String = $File.CreateElement("String");
    $Node_String.SetAttribute("Color", "White");
    $File.String.InnerXml = "Default";
    $File.Machine.Prompt.AppendChild($Node_String);#Node

    # Directories
    $Node_Directories = $File.CreateElement("Directories");
    $File.Machine.AppendChild($Node_Directories);#Node

    # Directory
    $Node_Directory = $File.CreateElement("Directory");
    $Node_Directory.SetAttribute("alias", "GitRepo");
    $Node_Directory.SetAttribute("SecurityType", "public");
    $Node_Directories.InnerXml = $PSScriptRoot; # putting this dir in the xml
    $File.Machine.Directories.AppendChild($Node_Directories);#Node

    # Objects
    $Node_Objects =  $File.CreateElement("Objects");
    $Node_Objects.SetAttribute("Database", "");
    $Node_Objects.SetAttribute("ServerInstance", "");
    $File.Machnie.AppendChild($Node_Objects);

    # Object 
    $Node_Object = $File.CreateElement("Object");
    $Node_Object.SetAttribute("Type", "XmlElement");
    $File.Machine.Ojbects.AppendChild($Node_Object)

    # VarName
    $Node_VarName = $File.AppendChild("VarName");
    $Node_VarName.SetAttribute("SecurityType","public");
    $Node_VarName.InnerXml = "User";
    $File.Machine.Objects.Object.AppendChild($Node_VarName);

    # Values
    $Node_Values = $File.CreateElement("Values");
    $File.Machine.Objects.Object.AppendChild($Node_Values);

    # Programs
    $Node_Programs = $File.CreateElement("Programs");
    $File.Machine.AppendChild($Node_Programs);

    # Program
    $Node_Program = $File.CreateElement("Program");
    $Node_Program.SetAttribute("Alias", "");
    $Node_Program.SetAttribute("Type", "");
    $File.Machine.Programs.AppendChild($Node_Program);
    
    # Modules
    $Node_Modules = $File.CreateElement("Modules");
    $File.Machine.AppendChild($Node_Modules);

    # Module
    $Node_Module = $File.CreateElement("Module");
    $File.Machine.Modules.AppendChild($Node_Module);

    # Lists
    $Node_Lists = $File.CreateElement("Lists");
    $File.Machine.AppendChild($Node_Lists);

    # List
    $Node_List = $File.CreateElement("List");
    $Node_List.SetAttribute("Title", "");
    $File.Machine.Lists.AppendChild($Node_List);

    # Item
    $Node_Item = $File.CreateElement("Item");
    $Node_Item.SetAttribute("rank","");
    $Node_Item.SetAttribute("name","");
    $Node_Item.SetAttribute("Completed","");
    $File.Machine.Lists.List.AppendChild($Node_Item);

    # Calendar
    $Node_Calendar = $File.CreateElement("Calendar");
    $File.Machine.AppendChild($Node_Calendar);

    # SpecialDays
    $Node_SpecialDays = $File.CreateElement("SpecialDays");
    $File.Machine.Calendar.AppendChild($Node_SpecialDays);

    # SpecialDay
    $Node_SpecialDay = $File.CreateElement("SpecialDay");
    $Node_Item.SetAttribute("name","New Years");
    $Node_SpecialDay.InnerXml = "1/1/2021";
    $File.Machine.Calendar.SpecialDays.AppendChild($Node_SpecialDays);

    $File.Save("B:\Test.xml");
}