cask "cpuq-app" do
  version "0.13.2"
  sha256 "701ca81656de332bc5d44c0af7798b82cfc9c1873beb366d36fcada8d846d5b2"

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
