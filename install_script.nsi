
Name "Anydrop Desktop"

# define name of installer
OutFile "AnyDrop-Windows Setup.exe"
 
# define installation directory
InstallDir $PROGRAMFILES\Anydrop-Desktop

DirText "Choose a directory to install Anydrop-Desktop in your system"

# For removing Start Menu shortcut in Windows 7
RequestExecutionLevel admin
 
# start default section
Section
 
    # set the installation directory as the destination for the following actions
    SetOutPath $INSTDIR

    # Add Program Files

    File Anydrop-Desktop.exe
    File Anydrop-Desktop.iobj
    File Anydrop-Desktop.ipdb
    File Anydrop-Desktop.pdb
    File flutter_windows.dll
    File /r data
    
    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
 
    # create a shortcut named "new shortcut" in the start menu programs directory
    # point the new shortcut at the program uninstaller
    CreateDirectory "$SMPROGRAMS\Anydrop-Desktop"
    CreateShortCut "$SMPROGRAMS\Anydrop-Desktop\Uninstall Anydrop.lnk" "$INSTDIR\uninstall.exe"
    CreateShortCut "$SMPROGRAMS\Anydrop-Desktop\Anydrop-Desktop.lnk" "$INSTDIR\Anydrop-Desktop.exe"
    CreateShortCut "$DESKTOP\Anydrop-Desktop.lnk" "$INSTDIR\Anydrop-Desktop.exe"

SectionEnd


 
# uninstaller section start
Section "uninstall"
 
    # first, delete the uninstaller
    Delete "$INSTDIR\uninstall.exe"
    RMDIR "$INSTDIR"

    # second, remove the link from the start menu
    Delete "$SMPROGRAMS\Anydrop-Desktop\Anydrop-Desktop.lnk"
    RMDIR "$SMPROGRAMS\Anydrop-Desktop"

 
# uninstaller section end
SectionEnd