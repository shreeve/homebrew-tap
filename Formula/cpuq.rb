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
      url "https://github.com/shreeve/cpuq/releases/download/v0.27.1/cpuq-v0.27.1-osx-arm64.tar.gz"
      sha256 "931d91678e790b2dc6788a1ce71f43a7bc48546a0cf0bb4d9ccee171a5b8c7e6"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.27.1/cpuq-v0.27.1-osx-amd64.tar.gz"
      sha256 "c9f1ee2782869e301e55f6998a6b2031c25b26f25bc782cd640f580518bd5d26"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.27.1/cpuq-v0.27.1-linux-arm64.tar.gz"
      sha256 "305069d5e54fd0ab5129c1c67e9db990bbe82352145043b3b6a2185ce5fa35e4"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.27.1/cpuq-v0.27.1-linux-amd64.tar.gz"
      sha256 "42a9eff5617f37b5eaf29eda3dd23ffa9691010ddf754abeb49a7aa5ded9e928"
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
