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
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.4/cpuq-v0.25.4-osx-arm64.tar.gz"
      sha256 "902dc399ef44e0902ecbb51e20772ad066c19d056587713a2cf6f8a83e3cab2f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.4/cpuq-v0.25.4-osx-amd64.tar.gz"
      sha256 "df79f91c0fd8f67e3f306dd00a6cd10b0ed187533ef37dbbdcf49a10e5ac0b67"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.4/cpuq-v0.25.4-linux-arm64.tar.gz"
      sha256 "31b2e744542a00bde900bb43933abd822e880777e044cf748dec93e44c6a058f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.4/cpuq-v0.25.4-linux-amd64.tar.gz"
      sha256 "e7a96a1cc97f3a91c3c868322a57dfcb86da6103a63ad78e5adf11f1aaf2333b"
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
