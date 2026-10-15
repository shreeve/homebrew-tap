class Cpuq < Formula
  desc "Machine-wide jobserver for builds, tests, benchmarks and coding agents"
  homepage "https://github.com/shreeve/cpuq"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.21.0/cpuq-v0.21.0-osx-arm64.tar.gz"
      sha256 "4d873708d354bfbef906f979bc2507696061308c7facef4eb74be0fdb72f794f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.21.0/cpuq-v0.21.0-osx-amd64.tar.gz"
      sha256 "031f9a4298f729eab704c8fe90f2ebe9c56cd51481513aea3e61167c04d99ac4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.21.0/cpuq-v0.21.0-linux-arm64.tar.gz"
      sha256 "f86f668e453f42833da82c3ac04260d76e4d1c25b06afb644dcf56aac6e07e17"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.21.0/cpuq-v0.21.0-linux-amd64.tar.gz"
      sha256 "891b4bca297d51c0b58e8d08a38df7c0fc680420afb958805c8a8f69407315f3"
    end
  end

  def install
    bin.install "cpuq"
    doc.install "README.md", "CHANGELOG.md"
  end

  test do
    assert_match "cpuq #{version}", shell_output("#{bin}/cpuq --version")
    # A private queue with the machine gates off, so the test depends on
    # neither the load nor the size of the machine it runs on.
    (testpath/"config").write "load_check = off\npressure_check = off\nactive_cap = off\n"
    ENV["CPUQ_DIR"] = (testpath/"state").to_s
    ENV["CPUQ_CONFIG"] = (testpath/"config").to_s
    ENV["CPUQ_BUDGET"] = "2"
    ran = shell_output("#{bin}/cpuq run --cores 2 -- sh -c 'echo ran with $CPUQ_CORES cores'")
    assert_equal "ran with 2 cores", ran.strip
    assert_match "\"held\": 0", shell_output("#{bin}/cpuq status --json")
  end
end
