cask "ducktable" do
  version "2.0.2"
  sha256 "0ce861dce9f6d8df77d26b0f2a7a17a8c09119e9fb1c7288d366c0ea0ca5c082"

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
