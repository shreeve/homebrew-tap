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
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.3/cpuq-v0.7.3-osx-arm64.tar.gz"
      sha256 "be5f31da5534c161147180ed86175113636869e47a159ded2b8bd96f119c60d0"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.3/cpuq-v0.7.3-osx-amd64.tar.gz"
      sha256 "8c69f522cbb7a1e3dd54d3bffb2d12fe6b4aeae18b5a9ab0d8ca6e23995d2bfa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.3/cpuq-v0.7.3-linux-arm64.tar.gz"
      sha256 "5e9eaaaabbfc213161fd95e7e0640630b81c8bc2b917093d302280d4b6e01bc2"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.7.3/cpuq-v0.7.3-linux-amd64.tar.gz"
      sha256 "205e271ca611ec52e11da4f5cbdc4c060d3e9e3980e13061f974c6303ff3d00e"
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
