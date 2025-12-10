cask "pairsync" do
  version "0.6.0"
  sha256 "54c5e45b65a845f99d32c9ed00a32d4632482d405ec3c196a25753e0ddbc4122"

  url "https://github.com/shreeve/pairsync/releases/download/v#{version}/PairSync-#{version}.dmg"
  name "PairSync"
  desc "Dual-pane file synchronization app with rsync and SSH support"
  homepage "https://github.com/shreeve/pairsync"

  depends_on macos: ">= :sonoma"

  app "PairSync.app"

  zap trash: [
    "~/Library/Preferences/com.pairsync.app.plist",
    "~/Library/Saved Application State/com.pairsync.app.savedState",
  ]
end

