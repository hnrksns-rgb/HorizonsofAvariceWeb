<#
push-to-github.ps1

Usage: run this from the project folder (PowerShell)
PS> .\push-to-github.ps1

What it does:
- checks for git (required) and gh (optional)
- initializes git if needed, stages and commits files
- if gh CLI is available it will create the repository on GitHub and push
- otherwise it asks for a remote URL and pushes the repo

This script is interactive and will prompt for values; sensible defaults are provided.
#>

# -- Helper to write messages
function Info($msg){ Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Error($msg){ Write-Host "[ERROR] $msg" -ForegroundColor Red }

# Ensure running in the intended directory
$cwd = Get-Location
Info "Working directory: $cwd"

# Check git
try{
    git --version > $null 2>&1
}catch{
    Error "Git is not installed or not in PATH. Install Git before running this script."
    exit 1
}

# Defaults (you can press Enter to accept)
$defaultUser = 'hnrksn-rgb'
$defaultRepo = 'HorizonsofAvariceWeb'
$defaultVisibility = 'public'  # 'public' or 'private'

$githubUser = Read-Host "GitHub username" -Prompt "GitHub username (default: $defaultUser)"
if([string]::IsNullOrWhiteSpace($githubUser)){ $githubUser = $defaultUser }
$repoName = Read-Host "Repository name" -Prompt "Repository name (default: $defaultRepo)"
if([string]::IsNullOrWhiteSpace($repoName)){ $repoName = $defaultRepo }
$visibility = Read-Host "Visibility (public/private)" -Prompt "Visibility (default: $defaultVisibility)"
if([string]::IsNullOrWhiteSpace($visibility)){ $visibility = $defaultVisibility }

# Initialize git if needed
if(-not (Test-Path .git)){
    Info "Initializing new git repository..."
    git init
} else {
    Info "Git repository already initialized."
}

# Stage files if there are changes
$status = git status --porcelain
if([string]::IsNullOrWhiteSpace($status)){
    Info "No changes to commit."
} else {
    Info "Staging and committing changes..."
    git add --all
    try{
        git commit -m "Initial commit"
    }catch{
        # commit may fail if nothing to commit; ignore
        Info "Commit step returned: $_"
    }
}

# Check for existing 'origin' remote
$originExists = $false
try{
    git remote get-url origin > $null 2>&1
    if($LASTEXITCODE -eq 0){ $originExists = $true }
}catch{
    $originExists = $false
}

# Use GitHub CLI if available
$ghAvailable = $false
try{
    gh --version > $null 2>&1
    $ghAvailable = $true
}catch{
    $ghAvailable = $false
}

if($ghAvailable){
    Info "GitHub CLI detected. Will attempt to create repo via gh."
    # Ensure authenticated
    try{
        $authCheck = gh auth status 2>&1
        if($LASTEXITCODE -ne 0){
            Write-Host "You are not authenticated with gh. Run 'gh auth login' and re-run this script." -ForegroundColor Yellow
            exit 1
        }
    }catch{
        Write-Host "Unable to detect gh auth status. Please run 'gh auth login' and re-run." -ForegroundColor Yellow
        exit 1
    }

    # Create repo
    $createCmd = "gh repo create $githubUser/$repoName --$visibility --source=. --remote=origin --push"
    Info "Running: $createCmd"
    Invoke-Expression $createCmd
    if($LASTEXITCODE -eq 0){
        Info "Repository created and pushed. Opening repository page..."
        Start-Process "https://github.com/$githubUser/$repoName"
        exit 0
    }else{
        Error "gh repo create failed. If the repository already exists, you can push manually or supply a remote URL."
    }
}

# Fallback: ask for remote URL and push
if(-not $originExists){
    $remoteUrl = Read-Host "Enter remote URL for origin (e.g. https://github.com/$githubUser/$repoName.git)"
    if([string]::IsNullOrWhiteSpace($remoteUrl)){
        Error "No remote URL provided. Exiting."
        exit 1
    }
    git remote add origin $remoteUrl
} else {
    Info "Using existing origin remote."
}

# Push branch
try{
    git branch --show-current > $null 2>&1
    $currentBranch = (git branch --show-current).Trim()
    if([string]::IsNullOrWhiteSpace($currentBranch)){ $currentBranch = 'main' }
}catch{
    $currentBranch = 'main'
}

Info "Pushing branch '$currentBranch' to origin..."
git push -u origin $currentBranch
if($LASTEXITCODE -eq 0){
    Info "Push succeeded. Opening repository page..."
    Start-Process "https://github.com/$githubUser/$repoName"
} else {
    Error "git push failed. Please check remote URL and your credentials."
}

Info "Script finished. If you used the GitHub Actions workflow, check the repository Actions tab to see Pages deployment."