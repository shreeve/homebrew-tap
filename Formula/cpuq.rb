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
      url "https://github.com/shreeve/cpuq/releases/download/v0.17.0/cpuq-v0.17.0-osx-arm64.tar.gz"
      sha256 "5081a499e043262d913100c0f479b7ad0d8b86d2659821e91460c10def7733a3"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.17.0/cpuq-v0.17.0-osx-amd64.tar.gz"
      sha256 "764a91e7816033ede47e72f4ff71c7ced65c3d3f960aa923947961ab619670c4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.17.0/cpuq-v0.17.0-linux-arm64.tar.gz"
      sha256 "31e3c6d3fd42268ba0cecfb4f918a364b0676ded843d872b9ce370d2544740c3"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.17.0/cpuq-v0.17.0-linux-amd64.tar.gz"
      sha256 "26bf2674bb4097eb04956dd7b0060eb2f8fbc4bd65a058f432b6709fe8eada76"
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
