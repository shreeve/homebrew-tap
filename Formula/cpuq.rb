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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.7/cpuq-v0.8.7-osx-arm64.tar.gz"
      sha256 "78f4b1100c07e2b87a9948d641e2ecb85e90343bb6ba02e3f6afa2b4ef590f1b"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.7/cpuq-v0.8.7-osx-amd64.tar.gz"
      sha256 "5d587e0f12e61d36f96efc3371f506bc66a7a87367394a727194952fedc169cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.7/cpuq-v0.8.7-linux-arm64.tar.gz"
      sha256 "9a13f3325b241f552043c6a5f641202954043688a63ddd953e694d350152fe74"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.7/cpuq-v0.8.7-linux-amd64.tar.gz"
      sha256 "994bad9429ba8805f90edbb11723fab195211c4b073cb47f8cf04d7907dc6613"
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
