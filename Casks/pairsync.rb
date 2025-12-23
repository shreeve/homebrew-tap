cask "pairsync" do
  version "0.6.1"
  sha256 "a0f2fde3f9236aae0dd843034b3f6ee8ab2b770d4d6d7e42578c2467e46a6277"

  url "https://github.com/shreeve/pairsync/releases/download/v#{version}/PairSync-#{version}.dmg"
  name "PairSync"
  desc "Dual-pane file synchronization app with rsync and SSH support"
  homepage "https://github.com/shreeve/pairsync"

  depends_on macos: ">= :sonoma"

  app "PairSync.app"

  # Remove quarantine attribute since app is not notarized
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-d", "com.apple.quarantine", "#{appdir}/PairSync.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/com.pairsync.app.plist",
    "~/Library/Saved Application State/com.pairsync.app.savedState",
  ]
end
