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
      url "https://github.com/shreeve/cpuq/releases/download/v0.40.2/cpuq-v0.40.2-osx-arm64.tar.gz"
      sha256 "e4e973f04c32ff5040d1d5ea391d2b09b5731b4dd5324ae710efc590b5d4e01a"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.40.2/cpuq-v0.40.2-osx-amd64.tar.gz"
      sha256 "ec46d4ccc18eadbaa27fe2a1ae24181483c92dcfe051d0130a2aecd831e111af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.40.2/cpuq-v0.40.2-linux-arm64.tar.gz"
      sha256 "819cc964229d556eba4fde07127925a65e8136614e68d798e97306a146003e15"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.40.2/cpuq-v0.40.2-linux-amd64.tar.gz"
      sha256 "45dc9bd83324477e4782f77607d4778813060b57b1310f84a9a0bf15b17dd883"
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
