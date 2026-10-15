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
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.3/cpuq-v0.19.3-osx-arm64.tar.gz"
      sha256 "36cd529812ee948cdadf6f4fc1bc60dd2aa86f7a5ca1b273b2b290319ceb4b74"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.3/cpuq-v0.19.3-osx-amd64.tar.gz"
      sha256 "c0c0e69e63194ff02c8edc263f0a6eddb945efe0732eb1d5967e2f344df4d70d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.3/cpuq-v0.19.3-linux-arm64.tar.gz"
      sha256 "e8b3378ee2e7a993159aa55bd75781bb0e4daaef34fc33d87880ae400b89f060"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.3/cpuq-v0.19.3-linux-amd64.tar.gz"
      sha256 "54e87b7df0d6cdd0b41d872ce309cd1fd2fde305c784fbb22af389a6db96809a"
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
