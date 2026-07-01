class Magritte < Formula
  desc "Standalone macOS git client in the spirit of Magit"
  homepage "https://github.com/lyallcooper/magritte"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lyallcooper/homebrew-magritte/releases/download/v0.3.0/magritte-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "23d91e7276d77e3e7dd3d10d42fc6c27c056cc05aefcfc3e70b752db8c47e814"
    else
      odie "Magritte currently ships a macOS Apple Silicon artifact only"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/lyallcooper/homebrew-magritte/releases/download/v0.3.0/magritte-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "675d218c574397fd0ec5dae0296d061e3b9aedf9733de67333ddad560ce20931"
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
