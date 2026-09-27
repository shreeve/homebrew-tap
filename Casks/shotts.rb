cask "shotts" do
  version "0.2.5"
  sha256 "7ecebf9a5da0ea9cc8c72caa8c9b0edb42b3c8d832d3c4927f5c8512573bdeac"

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
  depends_on macos: :golden_gate

  app "Shotts.app"

  zap trash: [
    "~/Library/Application Support/Shotts",
    "~/Library/Caches/com.github.shreeve.shotts",
    "~/Library/HTTPStorages/com.github.shreeve.shotts",
    "~/Library/Preferences/com.github.shreeve.shotts.plist",
  ]
end
