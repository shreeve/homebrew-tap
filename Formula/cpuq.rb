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
      url "https://github.com/shreeve/cpuq/releases/download/v0.41.0/cpuq-v0.41.0-osx-arm64.tar.gz"
      sha256 "842054fb0e4085a642c81d8849eaa3e2311d2bb66868c8d26026f3d6053b8fce"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.41.0/cpuq-v0.41.0-osx-amd64.tar.gz"
      sha256 "cc7d0562b87337d307cdf8f2e628dce67d630b0084d9054ac10c35e54c76395a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.41.0/cpuq-v0.41.0-linux-arm64.tar.gz"
      sha256 "1553634eb0ea937cb289b55855459f37bf63bf2d54daa67cfc41a27abab56b3d"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.41.0/cpuq-v0.41.0-linux-amd64.tar.gz"
      sha256 "dde9bcef7d94162376bd170942e04cb39b8880b373f742803ad9bdd600c4bb57"
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
