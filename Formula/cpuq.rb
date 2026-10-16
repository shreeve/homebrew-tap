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
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.2/cpuq-v0.25.2-osx-arm64.tar.gz"
      sha256 "74a43d44daf3675b62c2fadfa75c836cff24b3ad02d2fb1321ccd866303fff80"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.2/cpuq-v0.25.2-osx-amd64.tar.gz"
      sha256 "1f1d6b6fc04c0fef593e36d5b3c5525169715b21be38948d8550f71be36b46b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.2/cpuq-v0.25.2-linux-arm64.tar.gz"
      sha256 "6f2c0f1664314bd08865cc6c39be2f9f3992fefbba080a1d291549a057b0da89"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.2/cpuq-v0.25.2-linux-amd64.tar.gz"
      sha256 "d4efdc71a6ec0fc0f471dcbd3f41c71875244005cbe6286f63905d85746671c2"
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
