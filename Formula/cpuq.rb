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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.2/cpuq-v0.7.2-osx-arm64.tar.gz"
      sha256 "2773939cbc92269f39b6535d224f2343b3fe7da7108442d86efb563b764a2dcb"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.2/cpuq-v0.7.2-osx-amd64.tar.gz"
      sha256 "280d400a982d2ca873d71eb676ec23cc9da690b523488291871d3d69e56ac8b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.2/cpuq-v0.7.2-linux-arm64.tar.gz"
      sha256 "588920aa13ce3738b67983b7b483bf0e29df5ee3d4b196f76bc2ce4f6d2bf958"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.2/cpuq-v0.7.2-linux-amd64.tar.gz"
      sha256 "36be89571f6ba82c88f28370fc461aac89667b1b0e8ba1a08481c5a759ab6d3e"
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
