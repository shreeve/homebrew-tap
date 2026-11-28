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
      url "https://github.com/shreeve/cpuq/releases/download/v0.42.1/cpuq-v0.42.1-osx-arm64.tar.gz"
      sha256 "502f7f083fd94c58d985350b84306a46d31686e11ae3d109aca325af75502957"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.42.1/cpuq-v0.42.1-osx-amd64.tar.gz"
      sha256 "d54ae17569ad76a94e6ec9a682d3ceb2b904dbcab28ee88186f092696905f331"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.42.1/cpuq-v0.42.1-linux-arm64.tar.gz"
      sha256 "5d8f2d1b4a21b45e30efbc36719e97923659ce893a645ca64bd993b9145b871a"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.42.1/cpuq-v0.42.1-linux-amd64.tar.gz"
      sha256 "87a3b3a3a76852fa90a914ff2cf2737809b8a2bb0d6054325da87eb449a5d8b1"
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
