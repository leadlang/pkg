$target_to_use = $env:BUILD_TARGET

$target = $($target_to_use.Replace("-cross", ""))

$host_target = (rustc -vV | findstr "host: ").Replace("host: ", "")

try {
  rustup target add $target  
}
catch {
  "Continuing without installing $target"
}

if ($env:NO_CROSS -eq "true") {
  "Using cargo"

  cargo build --release --target $target
  
  cargo run --release --target $host_target
  cargo run --release --target $target
}
else {
  "Using cross"

  cross build --release --target $target_to_use

  cargo run --release --target $host_target
  cross run --release --target $target_to_use
}

Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item "$target.zip" -ErrorAction SilentlyContinue

New-Item build -ItemType Directory

if (!(Test-Path -Path docs)) {
  mkdir docs
}

Copy-Item -Path docs -Destination build -Recurse

Copy-Item -Path ".\target\$target\release\*.dll*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue
Copy-Item -Path ".\target\$target\release\*.so*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue
Copy-Item -Path ".\target\$target\release\*.dylib*" -Destination ".\build" -Recurse -ErrorAction SilentlyContinue

Compress-Archive -Path ./build/* -DestinationPath "$target.zip"