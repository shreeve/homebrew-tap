cask "transfer-sftp" do
  version "0.2.0"
  sha256 "26dc1bbdb1fc5db231752535dce2f455d3d858dcccfc7a583c9bd96311b62e0d"

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
