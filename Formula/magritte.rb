class Magritte < Formula
  desc "Standalone git client in the spirit of Magit. Ceci n'est pas Magit."
  homepage "https://github.com/lyallcooper/magritte"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lyallcooper/homebrew-magritte/releases/download/v0.2.0/magritte-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "17623485da985977bb200e22c10d2f53a6bc1e903757172c2af25b9d89bd399e"
    else
      odie "Magritte currently ships a macOS Apple Silicon artifact only"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/lyallcooper/homebrew-magritte/releases/download/v0.2.0/magritte-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "63a8acc11466a5a531a24b3fb1e459ac1fae905582de8fe34557f6572fe8167f"
    else
      odie "Magritte currently ships a Linux x86_64 artifact only"
    end
  end

  def install
    if OS.mac?
      app = Pathname.glob("*.app").first
      if app
        prefix.install app
      elsif (buildpath/"Contents").directory?
        (prefix/"Magritte.app").install "Contents"
      else
        prefix.install buildpath => "Magritte.app"
      end
      (bin/"magritte").write <<~SH
        #!/bin/sh
        exec "#{opt_prefix}/Magritte.app/Contents/MacOS/magritte" "$@"
      SH
    else
      bin.install "bin/magritte"
      share.install "share"
    end
  end

  test do
    system "#{bin}/magritte", "--help"
  end
end
