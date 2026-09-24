cask "transfer-sftp" do
  version "0.1.7"
  sha256 "e09716c4b9aaf0308dc159ffe1623c0867bc38d1906659daa988fb6ebba4574f"

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
