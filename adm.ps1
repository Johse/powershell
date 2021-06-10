<#
# Script: Windows 10 Error Correction Toolset v1.0
# Author: John Sebastian 
# Source available @ https://github.com/Johse/powershell/
# License: MIT License
#>
$Host.UI.RawUI.WindowTitle = "Windows 10 Error Correction Toolset v1.0"
function loadMainMenu() 
{
  param ([string]$Title = "Windows 10 Error Correction Toolset")
  [bool]$loopMainMenu = $true
  while ($loopMainMenu)
  {
    Clear-Host  
    Write-Host "`n======================  $Title  ======================"
    Write-Host "`n`t`System File Checker utility"
    Write-Host "`n`t`t`1: Verify Only"
    Write-Host "`t`t`2: Repair"
    Write-Host "`n`tDeployment Image Servicing and Management tool:"
    Write-Host "`n`t`t3: Health Check"
    Write-Host "`t`t4: Health Scan"    
    Write-Host "`t`t5: Health Restore"
    Write-Host "`t`t6: Clean Up the WinSxS Folder"
    Write-Host "`n`tWindows Update:"
    Write-Host "`n`t`t7: Restart Windows Update Services"
    Write-Host "`n`t`t8: Force Windows Update to re-download folders"
    Write-Host "`n`tWindows Defender:"
    Write-Host "`n`t`t9: Clear  Protection History"
    Write-Host "`n`n`tEnter 'q' to quit."
    $mainMenu = Read-Host “`n Enter selection...” 
    switch ($mainMenu)
    {
      1{
        Clear-Host
        Write-Host "Running SFC /VERIFYONLY ..."
        sfc /verifyonly
        pause
       }
      2{
        Clear-Host
        Write-Host "Running SFC /SCANNOW ..."
        sfc /scannow
        pause
       }
      3{
        Clear-Host
        Write-Host "Running DISM Health Check ..."
        Dism /Online /Cleanup-Image /CheckHealth 
        pause
       } 
      4{
        Clear-Host
        Write-Host "Running DISM Health Scan ..."
        Dism /Online /Cleanup-Image /ScanHealth
        pause
       } 
      5{
        Clear-Host
        Write-Host "Running DISM Health Restoration ..."
        Dism /Online /Cleanup-Image /RestoreHealth
        pause 
       }
      6{
        submenuA
       }
      7{
        Clear-Host
        Write-Host "Stopping Services..."
        net stop wuauserv
        net stop cryptSvc
        net stop bits
        net stop msiserver
        Write-Host "Starting Services..."
        net start wuauserv
        net start cryptSvc
        net start bits
        net start msiserver
        pause
       } 
      8{
        submenuB
       } 
      9{
        subMenuC
       } 
    "q"{
        $loopMainMenu = $false
        $Host.UI.RawUI.WindowTitle = "Windows PowerShell" # Set back to standard.
        Clear-Host
        exit
       }
default{
        Write-Host "`tA valid selection was not made. Pls. enter a valid selection."
        sleep -Seconds 1
       }
    }
  }
  return
}
function subMenuA() 
{
    [bool]$loopSubMenu = $true
    while ($loopSubMenu)
    {
    Clear-Host
    Write-Host "`n`tThis will remove ALL superseded versions of every component in the component store!"
    $subMenu = Read-Host “`n`tDo you want to proceed? (y/n)?”
        switch ($subMenu)
        {
        'y'{
             Clear-Host
             Write-Host "Running Component Cleanup..."
             Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
             pause
             $loopSubMenu = $false
            }
        'n'{
             $loopSubMenu = $false
           }
    default{
            Write-Host "`tA valid selection was not made. Pls. enter a valid selection."
            sleep -Seconds 1
           }
        }
    }
}
function subMenuB() 
{
  [bool]$loopSubMenu = $true
  while ($loopSubMenu)
  {
    Clear-Host
    Write-Host "`n`tThis will rename the following system folders:"
    Write-Host "`t`tC:\Windows\SoftwareDistribution to C:\Windows\SoftwareDistribution.old"
    Write-Host "`t`tC:\Windows\System32\catroot2 to C:\Windows\System32\catroot2.old"
    $subMenu = Read-Host “`n`tDo you want to proceed? (y/n)?”
      switch ($subMenu)
      {
       'y'{
            Clear-Host
            Write-Host "Stopping Services..."
            net stop wuauserv
            net stop cryptSvc
            net stop bits
            net stop msiserver
            Write-Host "Renaming C:\Windows\SoftwareDistribution..."
            ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
            Write-Host "Renaming C:\Windows\System32\catroot2 ..."
            ren C:\Windows\System32\catroot2 catroot2.old
            Write-Host "Starting Services..."
            net start wuauserv
            net start cryptSvc
            net start bits
            net start msiserver
            pause
             $loopSubMenu = $false
          }
       'n'{
             $loopSubMenu = $false
          }
   default{
             Write-Host "`tA valid selection was not made. Pls. enter a valid selection."
             sleep -Seconds 1
          }
      }
  }
}
function subMenuC() 
{
  [bool]$loopSubMenu = $true
  while ($loopSubMenu)
  {
    Clear-Host
    Write-Host "`n`tThis will remove ALL items in the Windows Defender History!"
    $subMenu = Read-Host “`n`tDo you want to proceed? (y/n)?”
      switch ($subMenu)
      {
       'y'{
             Clear-Host
             Write-Host "Removing Windows Defender History items..."
             Remove-Item -Path "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Service\*" -Recurse
             pause
             $loopSubMenu = $false
          }
       'n'{
             $loopSubMenu = $false
          }
   default{
             Write-Host "`tA valid selection was not made. Pls. enter a valid selection."
             sleep -Seconds 1
          }
      }
  }
}
loadMainMenu
