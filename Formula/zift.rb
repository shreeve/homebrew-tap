class Zift < Formula
  desc "Small SFTP server for partner file exchange"
  homepage "https://github.com/shreeve/zift"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/shreeve/zift/releases/download/v0.12.1/zift-v0.12.1-osx-arm64.tar.gz"
      sha256 "733ee625c04ce282b607c972d8b77f31d701c30465c5c1e8d6f80acdab4dab17"
    end
    on_intel do
      url "https://github.com/shreeve/zift/releases/download/v0.12.1/zift-v0.12.1-osx-amd64.tar.gz"
      sha256 "36a6f3c6884f92f7914ef7ec04e4a12aad4b2ab8cebc1993d8856b5228869124"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/zift/releases/download/v0.12.1/zift-v0.12.1-linux-arm64.tar.gz"
      sha256 "1b4618ced0a5104cad9c970d59183c822acbf2320f96a1b8cf908c76c4ec2eca"
    end
    on_intel do
      url "https://github.com/shreeve/zift/releases/download/v0.12.1/zift-v0.12.1-linux-amd64.tar.gz"
      sha256 "e2e81368f12624f55da38e70de4249212cb19a30cb3097433473e8657011734b"
    end
  end

  def install
    bin.install "zift"
    doc.install "README.md", "THIRD_PARTY_LICENSES.md"
  end

  def caveats
    if OS.mac?
      <<~EOS
        To run zift as a service, write #{etc}/zift/zift.conf
        (see https://github.com/shreeve/zift/blob/main/docs/configure.md),
        check it, then start it:
          zift validate #{etc}/zift/zift.conf
          brew services start zift
      EOS
    else
      <<~EOS
        This zift is for `zift validate` and `zift hash-password`. To run zift
        as a service on a Linux server, install it with install.sh instead:
        the systemd unit runs /usr/local/bin/zift, and install.sh checks the
        service's config with a new version before replacing the binary.
          https://github.com/shreeve/zift/blob/main/docs/operate.md
      EOS
    end
  end

  # macOS only: a Linux server runs /usr/local/bin/zift under the systemd
  # unit, installed with install.sh.
  service do
    run macos: [opt_bin/"zift", "serve", etc/"zift/zift.conf"]
    keep_alive true
    error_log_path var/"log/zift.log"
  end

  test do
    assert_match "zift #{version}", shell_output("#{bin}/zift version")
    hash = pipe_output("#{bin}/zift hash-password", "secret\n").strip
    assert_match(/\Aa[0-9A-Za-z]{31}\z/, hash)
  end
end
