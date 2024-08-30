# Create the Windows Form
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$initialDirectory = "C:\\"

$form = New-Object System.Windows.Forms.Form
$form.Text = "RoboCopy Fileshifter"
$form.Size = New-Object System.Drawing.Size(350,600)
$form.StartPosition = "CenterScreen"


$labelTitle = New-Object System.Windows.Forms.Label
$labelTitle.Text = "Single File Copy"
$labelTitle.Location = New-Object System.Drawing.Point(100,40)
$labelTitle.AutoSize = $true
$form.Controls.Add($labelTitle)



# Create Label for File Path
$labelFilePath = New-Object System.Windows.Forms.Label
$labelFilePath.Text = "File: None"
$labelFilePath.Location = New-Object System.Drawing.Point(10,60)
$labelFilePath.AutoSize = $true
$form.Controls.Add($labelFilePath)

# Create Label for Full Path
$labelFullPath = New-Object System.Windows.Forms.Label
$labelFullPath.Text = "Source: None"
$labelFullPath.Location = New-Object System.Drawing.Point(10,90)
$labelFullPath.AutoSize = $true
$form.Controls.Add($labelFullPath)

# Create Label for Destination Folder
$labelDestFolder = New-Object System.Windows.Forms.Label
$labelDestFolder.Text = "Destination: None"
$labelDestFolder.Location = New-Object System.Drawing.Point(10,120)
$labelDestFolder.AutoSize = $true
$form.Controls.Add($labelDestFolder)

# Create a Button for File Selection
$buttonFile = New-Object System.Windows.Forms.Button
$buttonFile.Text = "Select File"
$buttonFile.Location = New-Object System.Drawing.Point(10,160)
$buttonFile.Size = New-Object System.Drawing.Size(300,30)
$form.Controls.Add($buttonFile)

# Button Click Event for File Selection
$buttonFile.Add_Click({
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "All files (*.*)|*.*"
    $OpenFileDialog.ShowDialog() | Out-Null
    $labelFilePath.Text = $OpenFileDialog.FileName
    $labelFullPath.Text = [IO.Path]::GetDirectoryName($OpenFileDialog.FileName)
})

# Create a Button for Destination Folder Selection
$buttonFolder = New-Object System.Windows.Forms.Button
$buttonFolder.Text = "Select Destination Folder"
$buttonFolder.Location = New-Object System.Drawing.Point(10,200)
$buttonFolder.Size = New-Object System.Drawing.Size(300,30)
$form.Controls.Add($buttonFolder)

# Button Click Event for Destination Folder Selection
$buttonFolder.Add_Click({
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.SelectedPath = $initialDirectory
    $FolderBrowserDialog.ShowDialog() | Out-Null
    $labelDestFolder.Text = $FolderBrowserDialog.SelectedPath
})

# Create an Export Button
$buttonExport = New-Object System.Windows.Forms.Button
$buttonExport.Text = "Export"
$buttonExport.Location = New-Object System.Drawing.Point(10,240)
$buttonExport.Size = New-Object System.Drawing.Size(300,30)
$form.Controls.Add($buttonExport)

# Button Click Event for Export
$buttonExport.Add_Click({
    if ($labelFilePath.Text -ne "File: None" -and $labelDestFolder.Text -ne "Destination: None") {
        robocopy $labelFullPath.Text $labelDestFolder.Text ([IO.Path]::GetFileName($labelFilePath.Text))
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select both a file and a destination folder.")
    }
})

$labelTitle2 = New-Object System.Windows.Forms.Label
$labelTitle2.Text = "Folder Contents Copy"
$labelTitle2.Location = New-Object System.Drawing.Point(100,280)
$labelTitle2.AutoSize = $true
$form.Controls.Add($labelTitle2)

# Create Label for Full Path
$labelFullPath2 = New-Object System.Windows.Forms.Label
$labelFullPath2.Text = "Source: None"
$labelFullPath2.Location = New-Object System.Drawing.Point(10,320)
$labelFullPath2.AutoSize = $true
$form.Controls.Add($labelFullPath2)

# Create Label for Destination Folder
$labelDestFolder2 = New-Object System.Windows.Forms.Label
$labelDestFolder2.Text = "Destination: None"
$labelDestFolder2.Location = New-Object System.Drawing.Point(10,360)
$labelDestFolder2.AutoSize = $true
$form.Controls.Add($labelDestFolder2)

# Create a Button for File Selection
$buttonsrc = New-Object System.Windows.Forms.Button
$buttonsrc.Text = "Select Folder"
$buttonsrc.Location = New-Object System.Drawing.Point(10,400)
$buttonsrc.Size = New-Object System.Drawing.Size(300,30)
$form.Controls.Add($buttonsrc)

# Button Click Event for File Selection
$buttonsrc.Add_Click({
    $OpenFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $OpenFolderDialog.SelectedPath = $initialDirectory
    $OpenFolderDialog.ShowDialog() | Out-Null
    $labelFullPath2.Text = $OpenFolderDialog.SelectedPath
})

# Create a Button for Destination Folder Selection
$buttondst = New-Object System.Windows.Forms.Button
$buttondst.Text = "Select Destination Folder"
$buttondst.Location = New-Object System.Drawing.Point(10,440)
$buttondst.Size = New-Object System.Drawing.Size(300,30)
$form.Controls.Add($buttondst)

# Button Click Event for Destination Folder Selection
$buttondst.Add_Click({
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.SelectedPath = $initialDirectory
    $FolderBrowserDialog.ShowDialog() | Out-Null
    $labelDestFolder2.Text = $FolderBrowserDialog.SelectedPath
})

# Create an Export Button
$buttonExport2 = New-Object System.Windows.Forms.Button
$buttonExport2.Text = "Export"
$buttonExport2.Location = New-Object System.Drawing.Point(10,480)
$buttonExport2.Size = New-Object System.Drawing.Size(300,30)
$form.Controls.Add($buttonExport2)

# Button Click Event for Export
$buttonExport2.Add_Click({
    if ($labelFullPath2.Text -ne "Source: None" -and $labelDestFolder2.Text -ne "Destination: None") {
        $sourcePath = $labelFullPath2.Text
        $destinationPath = $labelDestFolder2.Text
        $flags = "/E /COPYALL"
        
        # Combine the robocopy arguments correctly
        $arguments = "$sourcePath $destinationPath $flags"
        
        # Run robocopy with the combined arguments
        Start-Process -FilePath "robocopy.exe" -ArgumentList $arguments -Wait -NoNewWindow
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select both a source and a destination folder.")
    }
})


# Show the Form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
