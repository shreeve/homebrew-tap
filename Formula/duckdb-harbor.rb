class DuckdbHarbor < Formula
  desc "DuckDB served over plain HTTP to many clients, with a REPL of its own"
  homepage "https://github.com/shreeve/duckdb-harbor"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/shreeve/duckdb-harbor/releases/download/v0.45.0/harbor-v0.45.0-osx-arm64.tar.gz"
      sha256 "822956d3012c7748caf47c8efe6fe10cd65ca2679c59152178423fed4a91e35f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shreeve/duckdb-harbor/releases/download/v0.45.0/harbor-v0.45.0-linux-arm64.tar.gz"
      sha256 "f036fbdb30d01fac2ea08190b1e64a580d1f066e9158ad54266c9a4ffa7f1f3f"
    end
    on_intel do
      url "https://github.com/shreeve/duckdb-harbor/releases/download/v0.45.0/harbor-v0.45.0-linux-amd64.tar.gz"
      sha256 "4d88c63298c2ad982938a155bebbe4fc9aadb780eaa3276c27fc6f5da2028275"
    end
  end

  def install
    # install.sh puts its own copy in ~/.local/bin, ahead of Homebrew's on
    # most paths. Two copies answer to two upgrade commands and drift apart,
    # so the one already there is the one to keep or to remove first. HOME is
    # a scratch directory during a build; the password database has the real
    # one.
    script_copy = Pathname(Etc.getpwuid.dir)/".local/bin/harbor"
    if script_copy.exist?
      odie <<~EOS
        harbor is already installed at #{script_copy}, by install.sh.
        Keep that copy, and upgrade it with:
          harbor update
        To use Homebrew's instead, remove that copy first, then install again:
          curl -fsSL https://raw.githubusercontent.com/shreeve/duckdb-harbor/main/install.sh | bash -s -- --uninstall
        Your databases, config and state are untouched either way.
      EOS
    end

    # harbor loads libduckdb at runtime, from ../lib beside its own
    # executable first. The pair goes under libexec so the library never
    # lands in #{HOMEBREW_PREFIX}/lib, where the duckdb formula puts its own.
    libexec.install "bin", "lib"

    # The launcher goes through opt, not the keg. harbor records the path it
    # was started from when it installs a login item, and opt is the path
    # that survives an upgrade.
    (bin/"harbor").write <<~SH
      #!/bin/bash
      exec "#{opt_libexec}/bin/harbor" "$@"
    SH
  end

  def caveats
    <<~EOS
      Upgrade with `brew upgrade duckdb-harbor`. `harbor update` is for a copy
      installed by install.sh and would write over this one.

      A running server keeps the code it started with: after an upgrade,
      `harbor` lists each server's version, and `harbor <db> restart` brings
      one forward.
    EOS
  end

  test do
    assert_match "harbor #{version}", shell_output("#{bin}/harbor --version")
    ENV["HARBOR_HOME"] = testpath/"h"
    db = testpath/"x.duckdb"
    assert_match "42", shell_output("#{bin}/harbor #{db} --mode csv -c 'SELECT 42 AS answer'")
    system bin/"harbor", db, "stop"
  end
end
