cask "cpuq-app" do
  version "0.8.2"
  sha256 "e768b01eb9e813f86519596c21ad1fbd23254b28158a1d8251eb8842e418532d"

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
