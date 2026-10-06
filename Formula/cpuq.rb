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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.5/cpuq-v0.7.5-osx-arm64.tar.gz"
      sha256 "3b5e35064a856dc9d53586b33daa76f28708ccb6de2f773d9ff5b0df52c7f46f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.5/cpuq-v0.7.5-osx-amd64.tar.gz"
      sha256 "ef877d69035bd94e6f5d8d1fb468e2b23a435a7004c0a12aac964da2a2968e05"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.5/cpuq-v0.7.5-linux-arm64.tar.gz"
      sha256 "dee58e759421bcd1c1ba0a64bbd2a08e7d3b3d6ec1170184877572c0679b5377"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.5/cpuq-v0.7.5-linux-amd64.tar.gz"
      sha256 "a7ee825fc9fc75b7b3c2e12cf107f246ee5082a829dea9d52ade8eca73114602"
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
