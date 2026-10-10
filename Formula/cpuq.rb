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
      url "https://github.com/shreeve/cpuq/releases/download/v0.9.1/cpuq-v0.9.1-osx-arm64.tar.gz"
      sha256 "4217e471fe3c81f341eacfac3f9eddc2fe0e72742e832af259cd92bfb4573700"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.9.1/cpuq-v0.9.1-osx-amd64.tar.gz"
      sha256 "de5c35029b78995c947de7d36aaaac0b198d564790d4d2f2cdee80419dfbd353"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.9.1/cpuq-v0.9.1-linux-arm64.tar.gz"
      sha256 "9706eba22c54291fbdc8fc17d8b803131f21763eedd3d55103aabcddb766832c"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.9.1/cpuq-v0.9.1-linux-amd64.tar.gz"
      sha256 "50571a1827b3d4889e74a1b960e7b56b672c8f31f066bd1418246861ac317925"
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
