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
      url "https://github.com/shreeve/cpuq/releases/download/v0.18.1/cpuq-v0.18.1-osx-arm64.tar.gz"
      sha256 "cb64247b3c9af3f2028e515a0dd12164921821f8e7417700e8bebf693812d5d0"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.18.1/cpuq-v0.18.1-osx-amd64.tar.gz"
      sha256 "f8794c9826b3b20bd0128e866a031a03d52821bdcb06ec581f2776430b30b39e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.18.1/cpuq-v0.18.1-linux-arm64.tar.gz"
      sha256 "beff001f8d1e2baa0f361d1d3228558bb536126ac49e0dc1c595d4eac438d965"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.18.1/cpuq-v0.18.1-linux-amd64.tar.gz"
      sha256 "9a339431f0c71499a0ee180dc00b6cb07264fa6a4181ff4a38a4f09ecfaef717"
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
