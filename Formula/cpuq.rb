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
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.0/cpuq-v0.19.0-osx-arm64.tar.gz"
      sha256 "c184e356230f7723a861b42cb5794b7aedb6ac098637493dd7736a01e3e7603b"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.0/cpuq-v0.19.0-osx-amd64.tar.gz"
      sha256 "806a97aeb4ea758c3027544b97f0b6806c60dfb49f41c490388fdba8510ff15c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.0/cpuq-v0.19.0-linux-arm64.tar.gz"
      sha256 "51e9a81541f44565d793e2c7f6c05219d29488176cb238a2ee6968d73b01e924"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.19.0/cpuq-v0.19.0-linux-amd64.tar.gz"
      sha256 "a10a181e9baff2730b0fc6534eb6c9d478bc43aea962f844e04c48d188b2776e"
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
