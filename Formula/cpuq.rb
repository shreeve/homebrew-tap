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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.0/cpuq-v0.8.0-osx-arm64.tar.gz"
      sha256 "1242f0e0c76a8f1d28b9a258b1c845b8cd4030ccb07a65fcb6fd19633c2ec208"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.0/cpuq-v0.8.0-osx-amd64.tar.gz"
      sha256 "6813d038b175d3025f8314d043186555f18da69cb387066de34f114b27cb99e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.0/cpuq-v0.8.0-linux-arm64.tar.gz"
      sha256 "ba475076fa00ed2b715f1b3d539fc401ae84025daf92c13069c92c79ecb748f2"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.0/cpuq-v0.8.0-linux-amd64.tar.gz"
      sha256 "843f4821c93f4badaa0938d3826db1a65628beaa9b5991271a8c3789df27f795"
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
