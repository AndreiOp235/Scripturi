# Define the starting directory
$startPath = "G:\INGLicentiat\II HITBOX"

# Function to check if a folder is empty
function Is-FolderEmpty {
    param (
        [string]$folderPath
    )

    # Get all items in the folder
    $items = Get-ChildItem -Path $folderPath -Force -ErrorAction SilentlyContinue
    return $items.Count -eq 0
}

# Function to process directories and collect empty folders
function Process-Directories {
    param (
        [string]$startPath
    )

    # Initialize a queue with the starting directory
    $queue = New-Object System.Collections.Queue
    $queue.Enqueue($startPath)

    # List to store empty folders
    $emptyFolders = @()

    # Process each directory in the queue
    while ($queue.Count -gt 0) {
        $currentDir = $queue.Dequeue()

        # Enqueue subdirectories to process them
        $subDirs = Get-ChildItem -Path $currentDir -Directory -ErrorAction SilentlyContinue
        foreach ($subDir in $subDirs) {
            $queue.Enqueue($subDir.FullName)
        }

        # Check if the current directory is empty
        if (Is-FolderEmpty -folderPath $currentDir) {
            $emptyFolders += $currentDir
        }
    }

    return $emptyFolders
}

# Initial processing
$emptyFolders = Process-Directories -startPath $startPath

# Loop until no new empty folders are found
$maxRetries = 5
$retryCount = 0

while ($emptyFolders.Count -gt 0 -and $retryCount -lt $maxRetries) {
    # Print the results
    Write-Output "Found empty folders:"
    $emptyFolders | ForEach-Object { Write-Output $_ }
    
    # Prompt user for confirmation to delete all empty folders
    $response = Read-Host "Do you want to delete all these empty folders? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') {
        foreach ($folder in $emptyFolders) {
            Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
            Write-Output ("Deleted folder: " + $folder)
        }
        Write-Output "All empty folders have been deleted."
        
        # Reprocess directories to find any new empty folders
        $emptyFolders = Process-Directories -startPath $startPath
        $retryCount++
    } else {
        Write-Output "No folders were deleted."
        break
    }
}

if ($emptyFolders.Count -eq 0) {
    Write-Output "No more empty folders found."
} elseif ($retryCount -ge $maxRetries) {
    Write-Output "Reached maximum retries. Some empty folders may not have been processed."
}
