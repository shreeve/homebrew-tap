cask "transfer-sftp" do
  version "0.1.6"
  sha256 "c4030d6177f3bdcb164d3c19c73958ceff8881c4014099a78af01a7e0aa36097"

  url "https://github.com/shreeve/transfer/releases/download/v#{version}/Transfer-#{version}.zip"
  name "Transfer"
  desc "SFTP file browser that rides the system's ssh"
  homepage "https://github.com/shreeve/transfer"

  livecheck do
    url "https://github.com/shreeve/transfer/releases/latest/download/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  conflicts_with cask: "transfer"
  depends_on arch: :arm64
  depends_on macos: :golden_gate

  app "Transfer.app"

  zap trash: [
    "~/Library/Application Support/Transfer",
    "~/Library/Caches/com.github.shreeve.transfer",
    "~/Library/Caches/Transfer",
    "~/Library/HTTPStorages/com.github.shreeve.transfer",
    "~/Library/HTTPStorages/com.github.shreeve.transfer.binarycookies",
    "~/Library/Preferences/com.github.shreeve.transfer.plist",
    "~/Library/WebKit/com.github.shreeve.transfer",
  ]
end
