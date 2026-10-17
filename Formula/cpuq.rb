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
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.6/cpuq-v0.26.6-osx-arm64.tar.gz"
      sha256 "d575b33043a8a73f071ee56ad0b9b2c8736105e4b15b991106f8ff2baa0b53d4"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.6/cpuq-v0.26.6-osx-amd64.tar.gz"
      sha256 "d9a181de9e636dfd7a2998bc23f008ce72b2e8782956e66f8a8f40d7104f4a1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.6/cpuq-v0.26.6-linux-arm64.tar.gz"
      sha256 "918e7f839d07b77daa753914cef86042b1f5fb3e66e894461fd5bd53bb571abf"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.6/cpuq-v0.26.6-linux-amd64.tar.gz"
      sha256 "4645c13775a84b8efda82cdad7396466678c7a0911a6b2f47700da4ab478cc1e"
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
