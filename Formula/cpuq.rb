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
      url "https://github.com/shreeve/cpuq/releases/download/v0.22.1/cpuq-v0.22.1-osx-arm64.tar.gz"
      sha256 "6610aa26a584430baf1f91e019d497f9d5d72b664dea95b7ed130e999ef1e071"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.22.1/cpuq-v0.22.1-osx-amd64.tar.gz"
      sha256 "e76e2d416c02f9c447be2cdbd3137afa0929cd2c941710708424fbdc1c1d3030"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.22.1/cpuq-v0.22.1-linux-arm64.tar.gz"
      sha256 "db2e93e4a54e82c0ef6b1ceebaf7e84a26c51356ad145c750e7d20a4bc435c62"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.22.1/cpuq-v0.22.1-linux-amd64.tar.gz"
      sha256 "68f4fc511a1b77cbebcf9fae2f8eaebc0e35a420ff28f73cbe8732d6d3cd2c91"
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
