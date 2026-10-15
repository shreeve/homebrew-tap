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
      url "https://github.com/shreeve/cpuq/releases/download/v0.13.0/cpuq-v0.13.0-osx-arm64.tar.gz"
      sha256 "520dcd16be2f84b2eb4ca124dba3340eb99e456e670ad7365e35173be61153ef"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.13.0/cpuq-v0.13.0-osx-amd64.tar.gz"
      sha256 "8440c1f504d6d7b36bff45555ebd142a413f22c2403ec74b83d3406d18622cf7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.13.0/cpuq-v0.13.0-linux-arm64.tar.gz"
      sha256 "440f4aca3888c1e3a9a2804559c72d676f9551eee7ece5cc2356d92a7f579d08"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.13.0/cpuq-v0.13.0-linux-amd64.tar.gz"
      sha256 "c512294d91facb6388d1f1dc9810b78029acc05f22d79516ae7a5de7555eb116"
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
