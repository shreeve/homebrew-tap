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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.11/cpuq-v0.8.11-osx-arm64.tar.gz"
      sha256 "7c0adfa34966203e438f0f14c6c81cf51e795cfd2cf00d525fdb472f1786634a"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.11/cpuq-v0.8.11-osx-amd64.tar.gz"
      sha256 "c389f382dcdf59b518f890a203ac848a2a567ca30a77f755249f9d034dfaa7b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.11/cpuq-v0.8.11-linux-arm64.tar.gz"
      sha256 "41f25c9f1ff3eef4c97a48cd7e95f60ba7b09855349921efb3f66a107a173167"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.11/cpuq-v0.8.11-linux-amd64.tar.gz"
      sha256 "b73057f2805911076b364faee0202723cba48e0fcfec013026f7c128d8035c1a"
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
