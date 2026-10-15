cask "cpuq-app" do
  version "0.18.0"
  sha256 "a811ab0eaa6b2002811230b542e410b13409704668aaed82fcc80a7b059a6117"

  url "https://github.com/shreeve/cpuq/releases/download/app-v#{version}/Cpuq-#{version}.zip"
  name "Cpuq"
  desc "Menu-bar meter and graphs for the cpuq machine-wide jobserver"
  homepage "https://github.com/shreeve/cpuq"

  livecheck do
    url "https://github.com/shreeve/cpuq/releases/download/cpuq-app-updates/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on formula: "shreeve/tap/cpuq"
  depends_on macos: :sonoma

  app "Cpuq.app"

  zap trash: [
    "~/Library/Caches/com.github.shreeve.cpuq",
    "~/Library/HTTPStorages/com.github.shreeve.cpuq",
    "~/Library/Preferences/com.github.shreeve.cpuq.plist",
  ]
end
