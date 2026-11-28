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
      url "https://github.com/shreeve/cpuq/releases/download/v0.43.0/cpuq-v0.43.0-osx-arm64.tar.gz"
      sha256 "81d0ba387da93450d34afe209a8f946640c7784ff77d72d1b0136fd6c6839fe8"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.43.0/cpuq-v0.43.0-osx-amd64.tar.gz"
      sha256 "5f266821bacd258a52b55d436ad857a9f2a81e3e17f81f47a992f247d0cdaff3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.43.0/cpuq-v0.43.0-linux-arm64.tar.gz"
      sha256 "99e11f0bf1e96e468652b69d325b1632a700ae0ce469ff87a8f564e5f79248bd"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.43.0/cpuq-v0.43.0-linux-amd64.tar.gz"
      sha256 "f3e7553a9f65859b9c1861265982d6237240c3a226385d8e209a5bd33f7ebec7"
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
