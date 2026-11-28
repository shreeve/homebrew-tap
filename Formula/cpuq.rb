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
      url "https://github.com/shreeve/cpuq/releases/download/v0.41.1/cpuq-v0.41.1-osx-arm64.tar.gz"
      sha256 "9fd6c0688ba9f927479aa759a9c0b5347743d3554f79ea5874477ee9d60b24a9"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.41.1/cpuq-v0.41.1-osx-amd64.tar.gz"
      sha256 "be596e16fc4c229b98f5b4c21fa7a1ba1652a3b0d060a6bb47d7ee3c17d003fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.41.1/cpuq-v0.41.1-linux-arm64.tar.gz"
      sha256 "1e30cf78c6b6bc36a61f26c76749c0b57a43f15b0dffb67555d856c36252fa69"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.41.1/cpuq-v0.41.1-linux-amd64.tar.gz"
      sha256 "7702b8b33e195c05ed62069b12bfdfe99e03570caf0147d6c10aa669e0da86f7"
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
