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
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.1/cpuq-v0.31.1-osx-arm64.tar.gz"
      sha256 "647fc17da2d78c2a99ce415aac6ead8d6d3d26c15a03e5fa195937a9a7ef7a82"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.1/cpuq-v0.31.1-osx-amd64.tar.gz"
      sha256 "efb8bb00a7cb2f7f07b280ad8d94565c67a78965d290a3f282d645a58317db63"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.1/cpuq-v0.31.1-linux-arm64.tar.gz"
      sha256 "7b2a70eaad3a20b2609b8d8a97e1a75d452fe1e482dfa8b0014a69a0c6000b5c"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.31.1/cpuq-v0.31.1-linux-amd64.tar.gz"
      sha256 "ab04fd86a41a3b5fbeeaa9ac0827c6daeeb9348a4edca09cf2bfe9f0e9f66567"
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
