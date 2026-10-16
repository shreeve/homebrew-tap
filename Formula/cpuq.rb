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
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.1/cpuq-v0.24.1-osx-arm64.tar.gz"
      sha256 "6b2300cfc9c78e33b71c65a8a1d26fbc2a1f994f77f574a750969eb00b484ec4"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.1/cpuq-v0.24.1-osx-amd64.tar.gz"
      sha256 "576cee4ecf278008f92a1d3dfb76450bc6e4c22448330e298b2980657786f8d7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.1/cpuq-v0.24.1-linux-arm64.tar.gz"
      sha256 "8bbef9d4f36e376d6b8704d210801a9d893e8f7ae45166455e9851bdf3233b0e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.24.1/cpuq-v0.24.1-linux-amd64.tar.gz"
      sha256 "c0fc03cf9cd3ff078ba7a067735fcbf0ba2c26f4595bd5ab779fdbff76a69999"
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
