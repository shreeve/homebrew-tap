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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.8/cpuq-v0.8.8-osx-arm64.tar.gz"
      sha256 "27d19a1636c911bbe126a77bdcf1fb32fb0bb6ca79c1ec2832fedf425af94e37"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.8/cpuq-v0.8.8-osx-amd64.tar.gz"
      sha256 "b186656d4693da804f52e8a18b9bbbb1b8a577620dd8ea8bffe338864e0afa37"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.8/cpuq-v0.8.8-linux-arm64.tar.gz"
      sha256 "acd3115b47e3966240136251ec9edc968764825469b1d1e21bb3c822259a6115"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.8/cpuq-v0.8.8-linux-amd64.tar.gz"
      sha256 "b87272a8001346d4ccfb8dbcfa257a466b97b4efd8914637bcfa4234f594197c"
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
