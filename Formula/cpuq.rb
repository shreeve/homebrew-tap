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
      url "https://github.com/shreeve/cpuq/releases/download/v0.23.0/cpuq-v0.23.0-osx-arm64.tar.gz"
      sha256 "7166cec9d39e131bf20cf0ac5a487fd02bc0bdf5e380d705f409a77d25d2a569"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.23.0/cpuq-v0.23.0-osx-amd64.tar.gz"
      sha256 "6dae529dfee145b0fcb909aa5c2ef8bef5cce5e2f6a51c293feb0a38f70c681b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.23.0/cpuq-v0.23.0-linux-arm64.tar.gz"
      sha256 "17c939f26652d4aa22a465cc140d040f9d8b8ecf4d1d2ffb0dc40a718a5c671e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.23.0/cpuq-v0.23.0-linux-amd64.tar.gz"
      sha256 "1da54396c1bfd714be81c1e07d0626bc2744ef104a42000903d3922b78e5be9c"
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
