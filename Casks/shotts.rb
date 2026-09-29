cask "shotts" do
  version "0.4.0"
  sha256 "5453bc7c3c75183b329804bebe3efccc37495eeb001d7fcd999d826ed7354a82"

  url "https://github.com/shreeve/shotts/releases/download/v#{version}/Shotts-#{version}.zip"
  name "Shotts"
  desc "Screenshots with annotations: press a key, select, mark up, paste"
  homepage "https://github.com/shreeve/shotts"

  livecheck do
    url "https://github.com/shreeve/shotts/releases/latest/download/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Shotts.app"

  zap trash: [
    "~/Library/Application Support/Shotts",
    "~/Library/Caches/com.github.shreeve.shotts",
    "~/Library/HTTPStorages/com.github.shreeve.shotts",
    "~/Library/Preferences/com.github.shreeve.shotts.plist",
  ]
end
