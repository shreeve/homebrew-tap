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
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.9/cpuq-v0.8.9-osx-arm64.tar.gz"
      sha256 "565f1072ce0ff9df4afc6bbb3f02af102ea5146df5571bbd4749d88bf014e848"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.9/cpuq-v0.8.9-osx-amd64.tar.gz"
      sha256 "7f378091e83a67fd6aada5e0f61752ec629b312a22c9c700358b4c6451628fb4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.9/cpuq-v0.8.9-linux-arm64.tar.gz"
      sha256 "666b2f95ec40823412830a56e8e032d1b341f2e11d16c0ad938b9d72c850d2a7"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.8.9/cpuq-v0.8.9-linux-amd64.tar.gz"
      sha256 "98171e9e38e22b934aedaf2755f812f8d8d8737a6c310ac3d5862a480bedf640"
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
