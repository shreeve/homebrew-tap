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
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.4/cpuq-v0.4.4-osx-arm64.tar.gz"
      sha256 "370369c0d5d6625e79242b00e2604ef6423a663d29fc87448c8801f26a988b7e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.4/cpuq-v0.4.4-osx-amd64.tar.gz"
      sha256 "96b22e44b6e3eb7adb176111ac9f2f652f2673a977fe9f87dafa0de26377c1ea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.4/cpuq-v0.4.4-linux-arm64.tar.gz"
      sha256 "4a14146e59303ce567377495c300392c0ed97b9cd340a59838eeed2b3eb8fd15"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.4/cpuq-v0.4.4-linux-amd64.tar.gz"
      sha256 "44a852d495da4fba4973c1ea51884d22931d7ca712634d6400017a4e985f416d"
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
