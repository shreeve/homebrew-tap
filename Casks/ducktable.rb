cask "ducktable" do
  version "0.24.0"
  sha256 "5dac02e85b341e678a4be8745465fe9dc81798c2889d2c300ccbee98b67cddc1"

  url "https://github.com/shreeve/duckdb-harbor/releases/download/ducktable-v#{version}/DuckTable-#{version}.zip"
  name "DuckTable"
  desc "Fast, minimal desktop client for DuckDB Harbor servers"
  homepage "https://github.com/shreeve/duckdb-harbor/tree/main/ducktable"

  livecheck do
    url "https://github.com/shreeve/duckdb-harbor/releases/download/ducktable-updates/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :monterey

  app "DuckTable.app"

  zap trash: [
    "~/.config/ducktable",
    "~/Library/Caches/com.shreeve.ducktable",
    "~/Library/HTTPStorages/com.shreeve.ducktable",
    "~/Library/Preferences/com.shreeve.ducktable.plist",
  ]

  caveats <<~EOS
    DuckTable speaks to DuckDB Harbor servers. Install harbor with:
      brew install shreeve/tap/duckdb-harbor
    or with its one-line installer:
      curl -fsSL https://raw.githubusercontent.com/shreeve/duckdb-harbor/main/install.sh | bash
  EOS
end
