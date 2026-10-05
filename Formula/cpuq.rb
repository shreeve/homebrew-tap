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
      url "https://github.com/shreeve/cpuq/releases/download/v0.1.0/cpuq-v0.1.0-osx-arm64.tar.gz"
      sha256 "d5ef0f9b8b702dbbd6e1f3dff8dbf1c6c5a53b4910990d70334173ac6146fba2"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.1.0/cpuq-v0.1.0-osx-amd64.tar.gz"
      sha256 "efa8869dcd7784bd8ffd656fd1b3de23409b3510d74645b325913de1e840443e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.1.0/cpuq-v0.1.0-linux-arm64.tar.gz"
      sha256 "e566ea0bef7dad31d0065545d7a75282d7b0b38378b02279eb318b34213dc645"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.1.0/cpuq-v0.1.0-linux-amd64.tar.gz"
      sha256 "82d9d5db266d3a9ea77b39c1b7bcb93cfb976ecc5043001066d4c3c53fe8d007"
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
