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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.9/cpuq-v0.7.9-osx-arm64.tar.gz"
      sha256 "6df58f8c135700016dbd1917f2a2ee8bbbcc0f2f9bedb542a159c5025bfd2b6e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.9/cpuq-v0.7.9-osx-amd64.tar.gz"
      sha256 "5a2a7bc0b8babd515fd5a1d51090c81cca53efaac3dfec0e2794037394383d2c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.9/cpuq-v0.7.9-linux-arm64.tar.gz"
      sha256 "46aab20f687b9afea10dcfd684919d1d25c662d4fb5d0968ac194abb32fbb5a5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.9/cpuq-v0.7.9-linux-amd64.tar.gz"
      sha256 "67a8c5967be7960c890af6a6a5f75d5447b132ff32c178bdf847e54936a0b12c"
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
