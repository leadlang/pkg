$target = $env:BUILD_TARGET

try {
  rustup target add $target  
}
catch {
  "Continuing without installing $target"
}

if ($env:NO_CROSS -eq "true") {
  cross build --release --target $target
  cross run --release --target $target
}
else {
  cargo build --release --target $target
  cargo run --release --target $target
}

Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item "$target.zip" -ErrorAction SilentlyContinue

New-Item build -ItemType Directory
Copy-Item -Path docs -Destination build -Recurse

Copy-Item -Path ".\target\$target\release\*.dll*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue
Copy-Item -Path ".\target\$target\release\*.so*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue
Copy-Item -Path ".\target\$target\release\*.dylib*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue

Compress-Archive -Path ./build/* -DestinationPath "$target.zip"