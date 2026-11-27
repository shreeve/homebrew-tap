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
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.3/cpuq-v0.30.3-osx-arm64.tar.gz"
      sha256 "1bc2357e2b232b719475634099d9b3f94bf4470fdb96ad3852203469e41017b5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.3/cpuq-v0.30.3-osx-amd64.tar.gz"
      sha256 "4ebb440515aa3db719805abb02284bfb841a6340d7f3f8fc5c6eb46335075486"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.3/cpuq-v0.30.3-linux-arm64.tar.gz"
      sha256 "6ad8513a7d856d00b6561c9de1f84a174544dfca538101b11fe9fb125342f93b"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.30.3/cpuq-v0.30.3-linux-amd64.tar.gz"
      sha256 "23b5291d45024eae636c3bb6fb9f0f5353e5be1c41003f1229d61baed5e850f2"
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
