cask "transfer-sftp" do
  version "0.1.5"
  sha256 "2f009faaac3e86115b3767374bf823e918461ee257f4ce59015844fc69a7ef08"

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
