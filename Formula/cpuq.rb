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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.5/cpuq-v0.8.5-osx-arm64.tar.gz"
      sha256 "bf37cede7f0a528f8581ca6817da440b23801cd1c236d23763554073404ac2d7"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.5/cpuq-v0.8.5-osx-amd64.tar.gz"
      sha256 "220e8cca8a928ac500436f34b3e43aa9c782d1c77fc64ba883655d7119a28cac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.5/cpuq-v0.8.5-linux-arm64.tar.gz"
      sha256 "21252024677f7c0bde6e5b9fa56a0dd6587b8a245863048eb8d14e1b6bb02d65"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.5/cpuq-v0.8.5-linux-amd64.tar.gz"
      sha256 "3b198beafff0559002043aa68963cb0b86f528dd9dc2bd85c43bcdb76c9ccc2f"
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
