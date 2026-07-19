class Magritte < Formula
  desc "Standalone macOS git client in the spirit of Magit"
  homepage "https://github.com/lyallcooper/magritte"
  version "0.9.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lyallcooper/magritte/releases/download/v0.9.0/magritte-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "b9273048cc464c64d4796ef66e6f7d59ca61421691a39cce2d0b576ddb71849b"
    else
      odie "Magritte currently ships a macOS Apple Silicon artifact only"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/lyallcooper/magritte/releases/download/v0.9.0/magritte-v0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6e59fdb4dee9d7467e535e823fdf1bb31dc1c36dddd6fbebe54f1c45819036e8"
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
