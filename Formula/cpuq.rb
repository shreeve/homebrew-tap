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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.2/cpuq-v0.8.2-osx-arm64.tar.gz"
      sha256 "593ba609491e87615ea23f0018a45526ebb0431ff3b5df914d6b101616faf7e7"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.2/cpuq-v0.8.2-osx-amd64.tar.gz"
      sha256 "f705699208d48b74a148145628fd7bb7f41cff74f068fe366e56deeba7e92eaa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.2/cpuq-v0.8.2-linux-arm64.tar.gz"
      sha256 "decb9b19d2ed695d5223a8f66afed4497b7e3bbb7278d05691610071b3f2bb50"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.2/cpuq-v0.8.2-linux-amd64.tar.gz"
      sha256 "269d0e24c9efc0d0d631c4e0e5a6aa277501a633d971805ed328cbb8cf6965a8"
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
