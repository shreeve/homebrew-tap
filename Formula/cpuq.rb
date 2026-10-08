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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.6/cpuq-v0.8.6-osx-arm64.tar.gz"
      sha256 "7e2db1b2603e8547f6e8470edd9ec5fb15178205eea30b62e3d1498a30ece0ea"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.6/cpuq-v0.8.6-osx-amd64.tar.gz"
      sha256 "4877c62c6946b763bb2f7f1f229aca639b96e73046702c43fdf51538fcdb0b72"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.6/cpuq-v0.8.6-linux-arm64.tar.gz"
      sha256 "c7bfac6c1baa01a585890cf89ccfe10eae2b8345c5dfe0fc581756e9a0d18ff5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.6/cpuq-v0.8.6-linux-amd64.tar.gz"
      sha256 "b5979647584663e03de1ee630977674425b642336a9664bfedc029c7c84da445"
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
