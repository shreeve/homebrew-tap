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
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.0/cpuq-v0.4.0-osx-arm64.tar.gz"
      sha256 "291c50546b5877056139461804e4177e9150736a55347393618b822761bc6fff"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.0/cpuq-v0.4.0-osx-amd64.tar.gz"
      sha256 "4ac76502d9e22bea31e46bcb466b0d811eef21c51fd92a7d90b5387068f1227b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.0/cpuq-v0.4.0-linux-arm64.tar.gz"
      sha256 "25f15dae3bb9bd8f8a5a7b5340fd31332a9ea6a84b3bca40f511d9d5ff096aa5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.0/cpuq-v0.4.0-linux-amd64.tar.gz"
      sha256 "866780258184fecf23d309f7b5c45eae623a27a9fa29d3ce0d8206124d70b8a4"
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
