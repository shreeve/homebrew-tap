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
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.2/cpuq-v0.26.2-osx-arm64.tar.gz"
      sha256 "7bfbd579073c1296b2f70bf992e35e82fd4c0759eea0ffbb6e8f631015d4f224"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.2/cpuq-v0.26.2-osx-amd64.tar.gz"
      sha256 "50a790fa1cc78477f237b9c68cc0335be8363bfb86e8c08a24c0aca6f59e8c35"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.2/cpuq-v0.26.2-linux-arm64.tar.gz"
      sha256 "82912e9f3edf08f7d79ed5c7b9787ea6bd476ddc5717d03dbc3bf59b8cf1d6e3"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.2/cpuq-v0.26.2-linux-amd64.tar.gz"
      sha256 "7a6abe36dc4d79903933e16fff1dc0bb2cd7c55f8011b8e04cc58768198992bf"
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
