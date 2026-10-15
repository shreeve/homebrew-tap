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
      url "https://github.com/shreeve/cpuq/releases/download/v0.21.1/cpuq-v0.21.1-osx-arm64.tar.gz"
      sha256 "cda3b81b8008a3d2741509fa2a2d21c01d167738053e47aea3acba7d6492ee12"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.21.1/cpuq-v0.21.1-osx-amd64.tar.gz"
      sha256 "513ccbe119b2161d13d58e6323a70a56f317daa3ee5ea9574d74116e641f3d15"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.21.1/cpuq-v0.21.1-linux-arm64.tar.gz"
      sha256 "99e64a24eb78b1478b396bde0f803da644d19a39229ccd3418d20c8e87a280b3"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.21.1/cpuq-v0.21.1-linux-amd64.tar.gz"
      sha256 "b892fd4988ff311fa4780826a8f3a31620964b43c52114a9845228f573c4dd7e"
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
