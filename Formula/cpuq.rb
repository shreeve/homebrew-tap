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
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.5/cpuq-v0.30.5-osx-arm64.tar.gz"
      sha256 "25610513ac607e26abc63becbd4945dcbdcf2fb6b4a207f36939541c67a710ed"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.5/cpuq-v0.30.5-osx-amd64.tar.gz"
      sha256 "885ba817285201a2fae05f0b1db06330697d4cfc3894e9d45e2b888c78433046"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.5/cpuq-v0.30.5-linux-arm64.tar.gz"
      sha256 "d4df9bb17ce3a9e94e5c1a28abe6b04c2f538f8d53db55da3eb133d0bff022c8"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.5/cpuq-v0.30.5-linux-amd64.tar.gz"
      sha256 "64f8f09dd0d3a7419bc8d846e7ab577edf816897a143c6f824b40366118c0a8e"
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
