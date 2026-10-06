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
      url "https://github.com/shreeve/cpuq/releases/download/v0.3.0/cpuq-v0.3.0-osx-arm64.tar.gz"
      sha256 "641e83806a5988c3136287aa7a5ffd72e4bdab9eeb1ef36c0e43c4c7e88b52aa"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.3.0/cpuq-v0.3.0-osx-amd64.tar.gz"
      sha256 "7cf1897ebfeb737ed30788dad45bd7e1dbadf65e3dfbd50f497eb7438589ed88"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.3.0/cpuq-v0.3.0-linux-arm64.tar.gz"
      sha256 "c334306489980efeba42c96587f9f96a9983a0f2a14c130f5b012c34487d4add"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.3.0/cpuq-v0.3.0-linux-amd64.tar.gz"
      sha256 "a47026a946e8b8f9256cc2c5725a5b40c91376a3b4407ba377a4b3fb1a7851f0"
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
