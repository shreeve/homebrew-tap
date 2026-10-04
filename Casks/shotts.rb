cask "shotts" do
  version "0.6.3"
  sha256 "f676f65ed16973436814cd3d27813ff31b5f10a9bdfb995aebef4c9ebf0772df"

  url "https://github.com/shreeve/shotts/releases/download/v#{version}/Shotts-#{version}.zip"
  name "Shotts"
  desc "Screenshots and screen recordings: press a key, select, mark up, paste"
  homepage "https://github.com/shreeve/shotts"

  livecheck do
    url "https://github.com/shreeve/shotts/releases/latest/download/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Shotts.app"
  binary "#{appdir}/Shotts.app/Contents/Helpers/shotts"

  zap trash: [
    "~/Library/Application Support/Shotts",
    "~/Library/Caches/com.github.shreeve.shotts",
    "~/Library/HTTPStorages/com.github.shreeve.shotts",
    "~/Library/Preferences/com.github.shreeve.shotts.plist",
  ]
end
