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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.4/cpuq-v0.7.4-osx-arm64.tar.gz"
      sha256 "6c65b93ad494fb24b3cfd69e8eadef1a16009ecfc8f27194bb7aaa3ff1c8eb13"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.4/cpuq-v0.7.4-osx-amd64.tar.gz"
      sha256 "b7c5a8180cb2a51412b80d9c2b1457f88058c605cafa18b5ee2ad369f137a32a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.4/cpuq-v0.7.4-linux-arm64.tar.gz"
      sha256 "bff5f920b2ad8c650834d9bcad1c8a846b5fdfefc44a10a12fad9dcada155e05"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.4/cpuq-v0.7.4-linux-amd64.tar.gz"
      sha256 "f216c28f6ed9184ba6b8d11bdd56be6d09d6d79aca8865589287296b7c3ba8fd"
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
