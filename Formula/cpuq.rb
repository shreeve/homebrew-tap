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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.8/cpuq-v0.7.8-osx-arm64.tar.gz"
      sha256 "ff03796565c92dd2e8f23fc144c9f2e78f3b3393d9559acf9d4feec6b1345a99"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.8/cpuq-v0.7.8-osx-amd64.tar.gz"
      sha256 "f05012670e9fbd8abc3b553d2b92be74304adfebd50c993c1094f4b24efe19ea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.8/cpuq-v0.7.8-linux-arm64.tar.gz"
      sha256 "7850d7062f7222ea3d85fdf99d24989f0f4a540d8f12896d1f14b24c762b7b29"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.8/cpuq-v0.7.8-linux-amd64.tar.gz"
      sha256 "1941420aa8af693fa4540bdc4f6c65eab4f3718a8ede42aadb98537800447ce7"
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
