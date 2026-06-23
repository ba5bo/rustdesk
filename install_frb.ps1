$env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
$env:HTTP_PROXY = "http://10.33.250.177:8888"
$env:HTTPS_PROXY = "http://10.33.250.177:8888"
cargo install flutter_rust_bridge_codegen --version 1.80.1 --locked 2>&1
