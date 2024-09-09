# Define the starting directory
$startPath = "F:\Pirate Bucket\III IS"

# Recursively search for .zip and .rar files
$zipRarFiles = Get-ChildItem -Path $startPath -Recurse -Include *.zip, *.rar

# Check if any files were found
if ($zipRarFiles) {
    # Process each archive file
    foreach ($file in $zipRarFiles) {
        # Define the destination directory (same as archive file's directory)
        $destinationPath = $file.DirectoryName

        try {
            Write-Output ("Extracting: " + $file.FullName)
            $shell = New-Object -ComObject shell.application
            $archive = $shell.NameSpace($file.FullName)
            $destination = $shell.NameSpace($destinationPath)
            $destination.CopyHere($archive.Items(), 16)
            Write-Output ("Successfully extracted: " + $file.FullName)

            # Delete the archive file after extraction
            Remove-Item $file.FullName -Force
            Write-Output ("Deleted archive: " + $file.FullName)
        } catch {
            Write-Output ("Failed to extract: " + $file.FullName)
        }

    }
} else {
    Write-Output "No .zip or .rar files found in the directory."
}