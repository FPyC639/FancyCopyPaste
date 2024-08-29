# Create the Windows Form
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$initialDirectory = "C:\\"

$form = New-Object System.Windows.Forms.Form
$form.Text = "RoboCopy Fileshifter"
$form.Size = New-Object System.Drawing.Size(350,300)
$form.StartPosition = "CenterScreen"

# Create Label for File Path
$labelFilePath = New-Object System.Windows.Forms.Label
$labelFilePath.Text = "File: None"
$labelFilePath.Location = New-Object System.Drawing.Point(10,20)
$labelFilePath.AutoSize = $true
$form.Controls.Add($labelFilePath)

# Create Label for Full Path
$labelFullPath = New-Object System.Windows.Forms.Label
$labelFullPath.Text = "Source: None"
$labelFullPath.Location = New-Object System.Drawing.Point(10,50)
$labelFullPath.AutoSize = $true
$form.Controls.Add($labelFullPath)

# Create Label for Destination Folder
$labelDestFolder = New-Object System.Windows.Forms.Label
$labelDestFolder.Text = "Destination: None"
$labelDestFolder.Location = New-Object System.Drawing.Point(10,80)
$labelDestFolder.AutoSize = $true
$form.Controls.Add($labelDestFolder)

# Create a Button for File Selection
$buttonFile = New-Object System.Windows.Forms.Button
$buttonFile.Text = "Select File"
$buttonFile.Location = New-Object System.Drawing.Point(10,120)
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
$buttonFolder.Location = New-Object System.Drawing.Point(10,160)
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
$buttonExport.Location = New-Object System.Drawing.Point(10,200)
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

# Show the Form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
