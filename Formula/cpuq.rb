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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.4/cpuq-v0.8.4-osx-arm64.tar.gz"
      sha256 "f1676319ad41dbe5a9f91f57fb9a87914147bc9d1284ebf60c699f7d6cd1ed55"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.4/cpuq-v0.8.4-osx-amd64.tar.gz"
      sha256 "f663621c47567bb17fbc3cbc055f021d174cf8c96326e28fa58b9262708d477a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.4/cpuq-v0.8.4-linux-arm64.tar.gz"
      sha256 "ea007630588e5b64d3f34ca2fb658ad997700915905de554fe38752e24e5ce93"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.4/cpuq-v0.8.4-linux-amd64.tar.gz"
      sha256 "9e88373e7b29bf28a8dcc5326168ebdad8098ee0a86cb2f2284b43488a922bc6"
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
