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
      url "https://github.com/shreeve/git-enc/releases/download/v0.2.1/git-enc-v0.2.1-osx-arm64.tar.gz"
      sha256 "b5aaf8b1c5b7c4980d3f442abe5f7d338d0c7aad81c6c831a9394e2ce715c10a"
    end
    on_intel do
      url "https://github.com/shreeve/git-enc/releases/download/v0.2.1/git-enc-v0.2.1-osx-amd64.tar.gz"
      sha256 "df8e0c08e40825e52839dce33f751312a4deb21f9f58f51259c1e3c394f48e3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/git-enc/releases/download/v0.2.1/git-enc-v0.2.1-linux-arm64.tar.gz"
      sha256 "5191aacb9871e2f8ca99ca9a6d241d64e041b8a4c9579e7464c6f00386618437"
    end
    on_intel do
      url "https://github.com/shreeve/git-enc/releases/download/v0.2.1/git-enc-v0.2.1-linux-amd64.tar.gz"
      sha256 "e424b307ff9e8dd2e177cbad6103327fe8740fab40e3b669fdf9651e2909cbf9"
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
