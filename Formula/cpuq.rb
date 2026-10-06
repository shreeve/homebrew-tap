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
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.3/cpuq-v0.4.3-osx-arm64.tar.gz"
      sha256 "f61645b0cee68c3777f270b9dec611f6ac45865ffa06accf90a119b42ce118bc"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.3/cpuq-v0.4.3-osx-amd64.tar.gz"
      sha256 "52e7b7e241df57d5743643443ea876b9422bd941fa9898697c6912b5ed622aa8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.3/cpuq-v0.4.3-linux-arm64.tar.gz"
      sha256 "318d455699611834c5971e52343ae233c4da695d411d048f98d8499f58941212"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.4.3/cpuq-v0.4.3-linux-amd64.tar.gz"
      sha256 "65fed0b251efe8cb83e858e1b33b9cd7755e6dc7fc87843003cbdedcb05e6e1a"
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
