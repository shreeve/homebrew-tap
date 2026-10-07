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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.1/cpuq-v0.8.1-osx-arm64.tar.gz"
      sha256 "4802b04022b755a65797490ec25dfb2c9a6de745c21fa9109a2a2f17b83cd9fe"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.1/cpuq-v0.8.1-osx-amd64.tar.gz"
      sha256 "1cc699dc37bd1264bf4fcbe40aaab76099fc8ee8e347a6ee7973cc10beb8b377"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.1/cpuq-v0.8.1-linux-arm64.tar.gz"
      sha256 "ea7d151463a6f5d605191e199e5e5432de791f5323fe13b24a299d50f5535f93"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.1/cpuq-v0.8.1-linux-amd64.tar.gz"
      sha256 "fd8a779f9fa8baabead4f4cfb33264644aef94b15804d3f45ccbb7acad314261"
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
