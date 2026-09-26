cask "lyte" do
  version "0.7.1"
  sha256 "09ecf674191f5e331a6969339f0c28ceffc2d0babe2742ac9790f3fd2919fa77"

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
