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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.7/cpuq-v0.7.7-osx-arm64.tar.gz"
      sha256 "5e7210bf2657a76510a67344b961199490f6b9c73e37c5312a796830ea4b2d42"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.7/cpuq-v0.7.7-osx-amd64.tar.gz"
      sha256 "963e6953568e36f890a6613752c8cd6905d0a23981d9d22b17589005f81ea3b0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.7/cpuq-v0.7.7-linux-arm64.tar.gz"
      sha256 "fb5a9b68afe97b2c3d3fb70219ea4ae7c508fe7562a3add0e0e1976272a718e9"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.7/cpuq-v0.7.7-linux-amd64.tar.gz"
      sha256 "44b3f2481b954eccf8fa7c2269478c187aa265c4e47f26b206a898210fdc75f7"
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
