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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.6/cpuq-v0.7.6-osx-arm64.tar.gz"
      sha256 "c782b52c0a9874bbe8b41cd056a55c5a09f8843515dae6f749c79a7a08adf19f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.6/cpuq-v0.7.6-osx-amd64.tar.gz"
      sha256 "58a2ab61d7a140906b910c1e16fca71f40bd25cea316127169f9249d584d53c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.6/cpuq-v0.7.6-linux-arm64.tar.gz"
      sha256 "251fee2d39751c2b121b56f6d30fb4dfaa7628a51651e7d5598e37153f2f2e36"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.6/cpuq-v0.7.6-linux-amd64.tar.gz"
      sha256 "42484fc3158d88830f2bc1afdbeb16f531e599afdbc05f24260870581e1f92fa"
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
