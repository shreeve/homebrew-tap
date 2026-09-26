cask "lyte" do
  version "0.7.0"
  sha256 "622b3cb727333a4b40bccab80e0029a77625f8aece66da2ceca0fd2c0bb29053"

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
