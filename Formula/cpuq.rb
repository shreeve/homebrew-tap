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
      url "https://github.com/shreeve/cpuq/releases/download/v0.35.0/cpuq-v0.35.0-osx-arm64.tar.gz"
      sha256 "e200125fa623c4c04473a5d1d8117c9c56def4c75aa178109bd1848de98b79dc"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.35.0/cpuq-v0.35.0-osx-amd64.tar.gz"
      sha256 "ff264bca74cd1eb305267030936196bf5e0401a2c898c894d8d9cbaeec99536d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.35.0/cpuq-v0.35.0-linux-arm64.tar.gz"
      sha256 "ac9dfa456ecdd4d6ae46a4def3eab1c5d88adf8a7b52450ac09bdbe8873468fd"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.35.0/cpuq-v0.35.0-linux-amd64.tar.gz"
      sha256 "6591dcb84a2d7755e8d1ec9518156b19494cd4ab81c9bde614c05d8372d5427f"
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
