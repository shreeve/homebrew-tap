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
      url "https://github.com/shreeve/cpuq/releases/download/v0.42.0/cpuq-v0.42.0-osx-arm64.tar.gz"
      sha256 "c6270a19467574f803d288ef756700ee24e53b685ae1abe189aafd2e22d2aca5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.42.0/cpuq-v0.42.0-osx-amd64.tar.gz"
      sha256 "3d0c28152b59b80939f4eb3d07a7804c473a3916892592a9dd11f12f569c7740"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.42.0/cpuq-v0.42.0-linux-arm64.tar.gz"
      sha256 "3549dbf34b71587c2031d1a414521bbc175d20ec2d0f6e74c1d9e6cf3ae5bf0a"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.42.0/cpuq-v0.42.0-linux-amd64.tar.gz"
      sha256 "7075a15154c9b3a1010481f0b06dfae9efbbc5b13f7a33f450d9ec01d6dcee41"
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
