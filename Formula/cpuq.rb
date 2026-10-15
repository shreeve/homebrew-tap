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
      url "https://github.com/shreeve/cpuq/releases/download/v0.16.2/cpuq-v0.16.2-osx-arm64.tar.gz"
      sha256 "7ccb0578848c0dd5b90871fa487e2cea5b05e8df1668b34123d8665a5d6a8f4b"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.16.2/cpuq-v0.16.2-osx-amd64.tar.gz"
      sha256 "e34e2cd7d34d105d857fbb045012a274e63906fb0862b80bba074ec68325613e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.16.2/cpuq-v0.16.2-linux-arm64.tar.gz"
      sha256 "6a25b584804b155d8909eaa04159a636889d39162b37e4d3ed67d9db55916ff2"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.16.2/cpuq-v0.16.2-linux-amd64.tar.gz"
      sha256 "45322c1aac601bf9e612ca6cab480c5bf427dee5a4d19fd21b2081db895bd19d"
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
