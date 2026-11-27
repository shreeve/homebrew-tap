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
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.2/cpuq-v0.31.2-osx-arm64.tar.gz"
      sha256 "56fe1bc39d01932c2b3a6419a542ce6222e69e6ba80a9b90ceff3b2864efcda9"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.2/cpuq-v0.31.2-osx-amd64.tar.gz"
      sha256 "c3669fde7a23f8aec19ac11183368e0fc6ef5e0191edf5028c3039fd11909b0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.2/cpuq-v0.31.2-linux-arm64.tar.gz"
      sha256 "a07ef252278b144f8c06d4ea2178f97a3fbe1b00e0b54ea524c30eee6843dbf0"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.2/cpuq-v0.31.2-linux-amd64.tar.gz"
      sha256 "40d345fb2cd01d65d5c49b90d30032303dd74619858999f6330b3f69dc6108d6"
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
