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
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.0/cpuq-v0.25.0-osx-arm64.tar.gz"
      sha256 "2405dd88c7a7ee58f48ca0e9453d8de01fc2f43b08a21ea2afc4a13be46b6aeb"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.0/cpuq-v0.25.0-osx-amd64.tar.gz"
      sha256 "e23a42b06c794401d6f6232e00ebe77fb6b57ab08d8bfacf2d3ff786dda8b605"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.0/cpuq-v0.25.0-linux-arm64.tar.gz"
      sha256 "16d33f9e3d9aca75c0d0edbbc54d9112a019b31e2b2b47ab0e05d38b4506b557"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.25.0/cpuq-v0.25.0-linux-amd64.tar.gz"
      sha256 "7e4278a84facef83b68007ee0f9d7fa38ffac705499019dfdbb66056fd923d07"
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
