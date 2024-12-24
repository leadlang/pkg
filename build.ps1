$target = $env:BUILD_TARGET

if ($env:CROSS) {
  cross build --release --target $target
  cross run --release --target $target
}
else {
  cargo build --release --target $target
  cargo run --release --target $target
}

Remove-Item -Recurse -Force build
Remove-Item "$target.zip" -ErrorAction SilentlyContinue

New-Item build -ItemType Directory
Copy-Item -Path docs -Destination build -Recurse

Copy-Item -Path ".\target\$target\release\*.dll*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue
Copy-Item -Path ".\target\$target\release\*.so*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue
Copy-Item -Path ".\target\$target\release\*.dylib*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue

Compress-Archive -Path ./build/* -DestinationPath "$target.zip"