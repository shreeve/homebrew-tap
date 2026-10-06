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
      url "https://github.com/shreeve/cpuq/releases/download/v0.5.1/cpuq-v0.5.1-osx-arm64.tar.gz"
      sha256 "55c4b51c612143ba4658e4ca1cdb02466574da2f37aeda194a14d76aa473d040"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.5.1/cpuq-v0.5.1-osx-amd64.tar.gz"
      sha256 "e271cf02559fbfc86ccffdee58c10e850c8dfcaa98e4717a91548d5cae9bf5ec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.5.1/cpuq-v0.5.1-linux-arm64.tar.gz"
      sha256 "3c0768a1b264e6b517e6160952917ed50af8f9ffd98c2ef68cfd098693582f1f"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.5.1/cpuq-v0.5.1-linux-amd64.tar.gz"
      sha256 "ce2ff982ae17ae66bfea774d7038a3183c0afdbe8f83eb9142d291c567d16d33"
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
