<#
.Synopsis
   Testing goto function
#>
Write-Host `n -NoNewline;
[Byte]$RETURNVALUE = 0;
<# TEST START #>

# This will fail if you are running locally
Write-Host " - Goto test on ConfigDir config" -NoNewline;

# If we are on my computer
if($PSScriptRoot -eq "B:\XmlPSProfile\Tests\Scripts\Functions")
{
   try{Goto2 ConfigDir2 -push;}
   catch
   {
      Write-Host " [FAILED]" -ForegroundColor Red;
      $RETURNVALUE = 1;
   }
   if((Get-Location).Path -eq 'B:\XmlPSProfile\Config')
   {
       Write-Host " [PASSED]" -ForegroundColor Green;
       Pop-Location;
   }
}
else
{
   try{Goto1 ConfigDir1s -push;}
   catch
   {
      Write-Host " [FAILED]" -ForegroundColor Red;
      $RETURNVALUE = 1;
   }
   if((Get-Location).Path -eq 'D:\a\XmlPSProfile\XmlPSProfile\Config')
   {
       Write-Host " [PASSED]" -ForegroundColor Green;
       Pop-Location;
   }
}

<# TEST END #>
return $RETURNVALUE;