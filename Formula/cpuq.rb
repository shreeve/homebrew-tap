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
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.2/cpuq-v0.4.2-osx-arm64.tar.gz"
      sha256 "c22e0d9cbae933e65c9de156c2f8d2d84f03032668f7a0fe0d53358aaaabfc97"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.2/cpuq-v0.4.2-osx-amd64.tar.gz"
      sha256 "ee5ed5ad6bd2762b74d56d2aaebdfaf249090b9cd0829af43837ee485d1d734f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.2/cpuq-v0.4.2-linux-arm64.tar.gz"
      sha256 "eb8db85f554167eced5c151dde0a2b001d61d3896346384400ac110bbc4e561a"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.2/cpuq-v0.4.2-linux-amd64.tar.gz"
      sha256 "4b08198aad0468fb76b9964149e8ed8ab6817431c8546a1b4baebc94cf189503"
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
