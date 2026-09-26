cask "lyte" do
  version "0.6.0"
  sha256 "66f5bda85e4d78929e43164f4661ca38fcede2539d3d2b163f480480f9a529a9"

  url "https://github.com/shreeve/lyte/releases/download/v#{version}/Lyte-#{version}.zip"
  name "Lyte"
  desc "Low-latency remote desktop for a Linux host"
  homepage "https://github.com/shreeve/lyte"

  livecheck do
    url "https://github.com/shreeve/lyte/releases/latest/download/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Lyte.app"

  zap trash: [
    "~/Library/Application Support/Lyte",
    "~/Library/Caches/dev.shreeve.lyte",
    "~/Library/HTTPStorages/dev.shreeve.lyte",
    "~/Library/Preferences/dev.shreeve.lyte.plist",
  ]
end
