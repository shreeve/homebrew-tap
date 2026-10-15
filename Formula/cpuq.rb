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
      url "https://github.com/shreeve/cpuq/releases/download/v0.18.0/cpuq-v0.18.0-osx-arm64.tar.gz"
      sha256 "aa044052fa5025af208ccb698472cd4ca3825bdc76d8cf58c07a06416315123b"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.18.0/cpuq-v0.18.0-osx-amd64.tar.gz"
      sha256 "e87d6ee73ebb3f79075362f4c139a60f073ebaf5252b926c223c62d566728c27"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.18.0/cpuq-v0.18.0-linux-arm64.tar.gz"
      sha256 "ad8822fd22c42d0a79b98de610efff81448251c06cf28bcd8e055b066f33a929"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.18.0/cpuq-v0.18.0-linux-amd64.tar.gz"
      sha256 "618b8f08e15d3e12b3881ac9f0479264a76a99e9a2e48e177d8e110e525a573a"
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
