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
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.1/cpuq-v0.6.1-osx-arm64.tar.gz"
      sha256 "364abb57cb77da09e1b3be12221223ee83a4577a971154d94d779c9a3aed01fa"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.1/cpuq-v0.6.1-osx-amd64.tar.gz"
      sha256 "f0a19c6134e0854e35fde8417eb7327621823c27340bdb14ec7b82553c52b45b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.1/cpuq-v0.6.1-linux-arm64.tar.gz"
      sha256 "ab87d5a81887f975f615c88e3642cdcfbe177559fb72662627271601d9fe44cf"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.6.1/cpuq-v0.6.1-linux-amd64.tar.gz"
      sha256 "fadf78bfe9684645cea4e0fd1d8645e5424fbddd78f99606e3b9f2882e54449a"
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
