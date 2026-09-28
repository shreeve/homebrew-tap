class GitEnc < Formula
  desc "Encrypted secrets in git, declared in .gitignore"
  homepage "https://github.com/shreeve/git-enc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/shreeve/git-enc/releases/download/v0.2.0/git-enc-v0.2.0-osx-arm64.tar.gz"
      sha256 "bdc4024a6fbefdb331e70f0994551d1e284476f21c45e221b8a924176bb9429a"
    end
    on_intel do
      url "https://github.com/shreeve/git-enc/releases/download/v0.2.0/git-enc-v0.2.0-osx-amd64.tar.gz"
      sha256 "8ddadd996685621bed88bdf29cdb631af0f4f22179e6c10076d9c80351d9bd8d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/git-enc/releases/download/v0.2.0/git-enc-v0.2.0-linux-arm64.tar.gz"
      sha256 "840b366f56f6f0bcb0013f64ad3d57800b1f77203d0b2a95efde723f25413591"
    end
    on_intel do
      url "https://github.com/shreeve/git-enc/releases/download/v0.2.0/git-enc-v0.2.0-linux-amd64.tar.gz"
      sha256 "e52f3e982df5af2d372ac5d121782b1cf511a4f0c07982f0a1ddae6040848831"
    end
  end

  def install
    bin.install "git-enc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-enc version")
    system "git", "init", "--quiet"
    assert_match "no git-enc secrets", shell_output("#{bin}/git-enc status")
  end
end
