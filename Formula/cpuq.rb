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
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.4/cpuq-v0.26.4-osx-arm64.tar.gz"
      sha256 "9adb9a26808fb545fe40bb81dda5942736c75ddc272020f5eb69aa8178f581e4"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.4/cpuq-v0.26.4-osx-amd64.tar.gz"
      sha256 "50d64c8026b392a3f8298829c1bd2246420d238b3da8b8ab9b1cf34b1ce03529"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.4/cpuq-v0.26.4-linux-arm64.tar.gz"
      sha256 "c832f060115b3c4fb8502d05dd0cae9338b70c184ee2dbf4cbeb556924eca0b5"
    end
    on_intel do
      url "https://github.com/shreeve/cpuq/releases/download/v0.26.4/cpuq-v0.26.4-linux-amd64.tar.gz"
      sha256 "4f4ad40007fe870e01f2ca74b1d2ababff19fa53a801871d8e53750246c26f4f"
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
