cask "ducktable" do
  version "0.22.8"
  sha256 "66526186ec57e62ff9e9068ef18b046b3720bf3c3909fa3064fb4ca787a689ba"

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
