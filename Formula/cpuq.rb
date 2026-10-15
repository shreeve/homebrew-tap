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
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.1/cpuq-v0.19.1-osx-arm64.tar.gz"
      sha256 "d1d5e8ab150ae6dd2ef805d569fadb47c7a4acb6be523bc6e6c27959766cfa21"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.1/cpuq-v0.19.1-osx-amd64.tar.gz"
      sha256 "00176dc6930714e1e60046f705c589ea17163d51b05fe05fdb309bbea9a274de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.1/cpuq-v0.19.1-linux-arm64.tar.gz"
      sha256 "7896395cf53ccab51bd8e67c84a488a85b08089f4e42c28c38e78772afb1d0a8"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.1/cpuq-v0.19.1-linux-amd64.tar.gz"
      sha256 "ef945abfd173d80ccc7e1379e23c556330924bc8a64e942b72e4e054ff6c7f86"
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
