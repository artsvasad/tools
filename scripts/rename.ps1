# Get the absolute path of the current directory
$target_dir = $PWD.Path

# 1. Fetch directories using .NET (Extremely Fast)
$directories = [System.IO.Directory]::GetDirectories($target_dir)

Write-Host "Found $($directories.Count) folders. Processing at .NET speeds..."

# 2. PHASE 1: Rapidly rename to temporary names
$temp_paths = [System.Collections.Generic.List[string]]::new()

for ($idx = 0; $idx -lt $directories.Count; $idx++) {
    $old_path = $directories[$idx]
    $temp_name = "temp_reset_$idx"
    $temp_path = [System.IO.Path]::Combine($target_dir, $temp_name)
    
    # .NET Move is much faster than Rename-Item
    [System.IO.Directory]::Move($old_path, $temp_path)
    $temp_paths.Add($temp_path)
}

# 3. PHASE 2: Rapidly rename to clean 1, 2, 3 sequence
$i = 1
foreach ($temp_path in $temp_paths) {
    $final_path = [System.IO.Path]::Combine($target_dir, $i.ToString())
    [System.IO.Directory]::Move($temp_path, $final_path)
    $i++
}

Write-Host "All folders perfectly sequenced!"