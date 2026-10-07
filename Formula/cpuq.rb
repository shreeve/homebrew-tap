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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.11/cpuq-v0.7.11-osx-arm64.tar.gz"
      sha256 "0f832cdc243033620b83441d94cc0582b28822bfe1013a17c507d845d18d6837"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.11/cpuq-v0.7.11-osx-amd64.tar.gz"
      sha256 "0bbac63cccd137aeddb36ed68bce8ba696aa5a3cc68c5b3fdd954e7039a9cfaa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.11/cpuq-v0.7.11-linux-arm64.tar.gz"
      sha256 "a2d982035193fceef8757ddd1d0afb4a6f479ef0db9e0f6285ce947b1afd8525"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.11/cpuq-v0.7.11-linux-amd64.tar.gz"
      sha256 "07821547889f77d0bb8dcdcf47daf481c1ad0164826e1a6ebf68900112b804fe"
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
