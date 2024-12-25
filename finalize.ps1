$toolchains = Get-Content "./toolchains.txt"

$cargo = (Get-Content "./Cargo.toml") -join "
"

$cargo = ConvertFrom-Toml $cargo

$package = $cargo.lib.name
$version = $cargo.package.version
$authors = $cargo.package.authors
$description = $cargo.package.description
$keywords = $cargo.package.keywords

if ($null -eq $authors) {
  $authors = @()
}

$metadata = @{
  package     = $package
  version     = $version
  authors     = $authors
  description = $description
  keywords    = $keywords
  platforms   = @()
}

mkdir dist -ErrorAction SilentlyContinue

"Building Docs..."
cargo run

Copy-Item -Path "./docs" -Destination "./dist/docs" -Recurse

foreach ($target in $toolchains) {
  try {
    Expand-Archive -Path "$target.zip" -DestinationPath "./dist/lib/$target" -Force 

    $metadata.platforms += $target
  }
  catch {
    Remove-Item "./dist/lib/$target" -Recurse -Force
  }
}

ConvertTo-Json $metadata | Out-File "dist/.pkgcache"

Compress-Archive -Path "./dist/*" -DestinationPath "leadpkg.zip" -Force