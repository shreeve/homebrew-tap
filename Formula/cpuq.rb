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
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.2/cpuq-v0.24.2-osx-arm64.tar.gz"
      sha256 "7987c2dc3547079c10c5180b832db2b170ee6e502525fbfd022fd93c9e28f8d8"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.2/cpuq-v0.24.2-osx-amd64.tar.gz"
      sha256 "933d0d65226f9cf93a9982af390870e2b2b73daefbbfe8090a2b076859e576ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.2/cpuq-v0.24.2-linux-arm64.tar.gz"
      sha256 "6162e729f1786501455a0801295338cecd1c1e86a56fc54eb74b4071d6b2f475"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.2/cpuq-v0.24.2-linux-amd64.tar.gz"
      sha256 "a9c6f9c8acd927163059d1efbdcb59eea3a4f8d43aaf2681f19111bfceb128ee"
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
