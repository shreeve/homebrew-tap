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
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.5/cpuq-v0.4.5-osx-arm64.tar.gz"
      sha256 "83036df7e1433fb4d03e87cfc16839563ee711993d39c345985575c7baeaaaea"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.5/cpuq-v0.4.5-osx-amd64.tar.gz"
      sha256 "e6127cebf1fb4cda3b02119c114632f846f8b9407e911e3686a8171692b2cae3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.5/cpuq-v0.4.5-linux-arm64.tar.gz"
      sha256 "8f337685cc3bada46e0b79b4c8996f11dc245708918aa362b6103fe31171d707"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.5/cpuq-v0.4.5-linux-amd64.tar.gz"
      sha256 "2d27fb11655284de4ec037b230ad4812997b6cc2d89ee4d5de8b814c1e09e56b"
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
