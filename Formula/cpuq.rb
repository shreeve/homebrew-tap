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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.14/cpuq-v0.7.14-osx-arm64.tar.gz"
      sha256 "e8f43d4ab33afb566751000eb5633ba43a08b812b7d9515fc637153bdd478542"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.14/cpuq-v0.7.14-osx-amd64.tar.gz"
      sha256 "d2490fe657b80fcfa5e4e5be9c4aef91d2b06e25f6fa0b8698eb35dde962d833"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.14/cpuq-v0.7.14-linux-arm64.tar.gz"
      sha256 "47b545c4d31b1b6af1e75f320c2c6abd4b3ad2fa8eb43e93c9ddd71b1623c46e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.14/cpuq-v0.7.14-linux-amd64.tar.gz"
      sha256 "50026f04e06605f613e334eca395969969db9bb3c02de590a1b3006d85e30bc3"
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
