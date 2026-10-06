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
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.2/cpuq-v0.6.2-osx-arm64.tar.gz"
      sha256 "35d9c473bda8560e691184bc9050799fc0bbf2638fc935779c252e39870a9fd7"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.2/cpuq-v0.6.2-osx-amd64.tar.gz"
      sha256 "7371cf7d1775d5b932e127d4312bececf0fc1d0ecccddcb8d0c4dfc759ed369c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.2/cpuq-v0.6.2-linux-arm64.tar.gz"
      sha256 "337b96368f7163250df6cb15ce6f979b9b550356389610d212e0e35a0f40bc6a"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.2/cpuq-v0.6.2-linux-amd64.tar.gz"
      sha256 "049fba1a473d66d3272babe29641f0b2f48b0d52cb3e44f6ffdf9f6ae36cbcf4"
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
