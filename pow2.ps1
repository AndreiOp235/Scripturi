# Define the starting directory
$startPath = "G:\INGLicentiat\PST baiatu"

# Define the path to 7-Zip
$sevenZipPath = "D:\Aplicatii\7-Zip\7z.exe"

# Recursively search for .zip and .rar files
Write-Output "Searching for .zip and .rar files in $startPath..."
$zipRarFiles = Get-ChildItem -Path $startPath -Recurse -Include *.zip, *.rar

# Check if any files were found
if ($zipRarFiles) {
    Write-Output ("Found " + $zipRarFiles.Count + " archives.")
    $jobs = @()

    # Function to extract archive using 7-Zip
    function Extract-Archive {
        param (
            [string]$filePath,
            [string]$sevenZipPath,
            [string]$destinationPath
        )

        Write-Output ("Extracting: {0} to {1}" -f $filePath, $destinationPath)
        # Extract the archive using 7-Zip
        $result = & "$sevenZipPath" x -o"$destinationPath" "$filePath" -y 2>&1
        Write-Output ("7-Zip output for {0}:`n{1}" -f $filePath, $result)
        
        if ($LASTEXITCODE -eq 0) {
            Write-Output ("Successfully extracted: {0}" -f $filePath)
            # Delete the archive file after extraction
            Remove-Item $filePath -Force
            Write-Output ("Deleted archive: {0}" -f $filePath)
        } else {
            Write-Output ("Failed to extract: {0}" -f $filePath)
        }
    }

    # Process each archive file
    foreach ($file in $zipRarFiles) {
        # Define the destination directory
        $destinationPath = $file.DirectoryName
        Write-Output ("Preparing to process file: {0}" -f $file.FullName)

        # Wait if there are already 10 jobs running
        while ($jobs.Count -ge 10) {
            Write-Output ("Waiting for jobs to complete. Current job count: {0}" -f $jobs.Count)
            # Check for completed jobs and remove them from the list
            $jobs | ForEach-Object {
                if ($_.State -eq 'Completed') {
                    $_ | Receive-Job
                    $_ | Remove-Job
                }
            }
            # Remove completed jobs from the list
            $jobs = $jobs | Where-Object { $_.State -ne 'Completed' }

            # Pause briefly before checking again
            Start-Sleep -Seconds 1
        }

        # Start a new job
        Write-Output ("Starting new job for file: {0}" -f $file.FullName)
        $job = Start-Job -ScriptBlock {
            param($filePath, $sevenZipPath, $destinationPath)
            # Define the Extract-Archive function inside the script block for jobs
            function Extract-Archive {
                param (
                    [string]$filePath,
                    [string]$sevenZipPath,
                    [string]$destinationPath
                )
                Write-Output ("Extracting: {0} to {1}" -f $filePath, $destinationPath)
                # Extract the archive using 7-Zip
                $result = & "$sevenZipPath" x -o"$destinationPath" "$filePath" -y 2>&1
                Write-Output ("7-Zip output for {0}:`n{1}" -f $filePath, $result)
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Output ("Successfully extracted: {0}" -f $filePath)
                    # Delete the archive file after extraction
                    Remove-Item $filePath -Force
                    Write-Output ("Deleted archive: {0}" -f $filePath)
                } else {
                    Write-Output ("Failed to extract: {0}" -f $filePath)
                }
            }
            Extract-Archive -filePath $filePath -sevenZipPath $sevenZipPath -destinationPath $destinationPath
        } -ArgumentList $file.FullName, $sevenZipPath, $destinationPath

        # Add the job to the list
        $jobs += $job
    }

    # Wait for remaining jobs to complete
    Write-Output ("Waiting for remaining jobs to complete...")
    $jobs | ForEach-Object {
        $_ | Wait-Job | Receive-Job
        $_ | Remove-Job
    }
    Write-Output ("All jobs completed.")
} else {
    Write-Output "No .zip or .rar files found in the directory."
}
