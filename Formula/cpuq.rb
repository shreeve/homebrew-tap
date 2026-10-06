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
      url "https://github.com/shreeve/cpuq/releases/download/v0.5.0/cpuq-v0.5.0-osx-arm64.tar.gz"
      sha256 "a7b13db97a174dc21f8ae036d5eb86173c01f50723410ae749ae7884e6c1e2cd"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.5.0/cpuq-v0.5.0-osx-amd64.tar.gz"
      sha256 "74838301608cd3bd31dc945f7310bb3ead859898572fae0579a4d93a470778cf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.5.0/cpuq-v0.5.0-linux-arm64.tar.gz"
      sha256 "05db212d7c595826e0f67dc847f14d944b51f8126375e040dbba476f9a9defdd"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.5.0/cpuq-v0.5.0-linux-amd64.tar.gz"
      sha256 "12cc23f0a420906d750093edb0976b4f66d1055cbb30ba9f6fd20858cfcfa77f"
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
