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
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.0/cpuq-v0.30.0-osx-arm64.tar.gz"
      sha256 "2e263d921cde8df362d4aa142dda4f35c8ed6aa28a8d79288b9cc6dde16ad3d1"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.0/cpuq-v0.30.0-osx-amd64.tar.gz"
      sha256 "5ec228df42f1104d68b798ac73d484732afd4a854f2f7c8dafb8103932dc360c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.0/cpuq-v0.30.0-linux-arm64.tar.gz"
      sha256 "268895901a610b25fcfe14eb47856e66a1999454ecc3c2f551fab90b85674b41"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.0/cpuq-v0.30.0-linux-amd64.tar.gz"
      sha256 "bbbc65163201e8ac31286d5ef5e1b59eaba46632a54bbc5b70f6ee7eb4156108"
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
