# Define the source .emacs file in this repository
$RepoEmacs = Join-Path $PSScriptRoot ".emacs"

# Define the target .emacs file in the user's profile directory (Windows "Home")
$HomeEmacs = Join-Path $env:USERPROFILE ".emacs"

Write-Host "Checking for existing $HomeEmacs..."

# Check if the target exists
if (Test-Path $HomeEmacs) {
    $item = Get-Item $HomeEmacs

    # Check if it is a symbolic link
    if ($item.LinkType -eq "SymbolicLink") {
        if ($item.Target -eq $RepoEmacs) {
            Write-Host "$HomeEmacs is already correctly linked."
            exit 0
        } else {
            Write-Error "Error: $HomeEmacs is a symbolic link but points to a different location: $($item.Target)"
            exit 1
        }
    } else {
        # If it's a regular file or a different type of link
        Write-Error "Error: A file or different link already exists at $HomeEmacs."
        Write-Host "Please rename or delete it and run this script again."
        exit 1
    }
}

Write-Host "Creating symbolic link from $RepoEmacs to $HomeEmacs..."

# Create the symbolic link. 
# Note: This might require Administrative privileges or Developer Mode enabled on Windows.
try {
    New-Item -Path $HomeEmacs -ItemType SymbolicLink -Value $RepoEmacs -ErrorAction Stop | Out-Null
    Write-Host "Symbolic link created successfully: $HomeEmacs now points to $RepoEmacs"
} catch {
    Write-Error "Error: Failed to create the symbolic link."
    Write-Host "Ensure you have the necessary permissions (Run as Administrator) or that 'Developer Mode' is enabled in Windows Settings."
    exit 1
}

exit 0
