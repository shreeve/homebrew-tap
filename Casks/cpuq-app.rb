cask "cpuq-app" do
  version "0.13.0"
  sha256 "e83b92e58fc2df600eb96a3c40d4e93ac78a9480a781dcb81fd6f70721af1c6c"

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
