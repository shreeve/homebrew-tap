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
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.0/cpuq-v0.6.0-osx-arm64.tar.gz"
      sha256 "6367f65987838434df5b269da7a7fa2a127db8adc573ded196795d82feb19866"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.0/cpuq-v0.6.0-osx-amd64.tar.gz"
      sha256 "4d920f7718f34fd70d8ca0941a8d029232a2e0e4c8ab7004fb487f019f905032"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.0/cpuq-v0.6.0-linux-arm64.tar.gz"
      sha256 "720a14d41678047447c7c53ff242c6fc04deca8197842406a1db444e397ce68e"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.0/cpuq-v0.6.0-linux-amd64.tar.gz"
      sha256 "0a7e346e9e37873e9db596abb87b44b2f56fe25fd94581bed811b66f9cd121a3"
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
