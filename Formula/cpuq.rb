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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.1/cpuq-v0.7.1-osx-arm64.tar.gz"
      sha256 "0194e23749f09e51d2a75af1e15e589a6e0eaaffe5fcd4c5d6d5d1227433de23"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.1/cpuq-v0.7.1-osx-amd64.tar.gz"
      sha256 "f31c40c333d41caf6c5e97899eb20af7c19ade4563c84831279acd762d61aa6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.1/cpuq-v0.7.1-linux-arm64.tar.gz"
      sha256 "5c5e382023a3dc1ce05b101f0b4ff271619091f0cbebe3d83c1f36669dd4d1e4"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.1/cpuq-v0.7.1-linux-amd64.tar.gz"
      sha256 "eb484b7da2c506b81ae2027c4dea0a78676cd3af732e61b3880e79a01ca4d8e6"
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
