class Rquickshare < Formula
  desc "Nearby Share/Quick Share client for Linux"
  homepage "https://github.com/Martichou/rquickshare"
  version "0.11.5"
  url "https://github.com/Martichou/rquickshare/releases/download/v#{version}/r-quick-share-legacy_v#{version}_glibc-2.31_amd64.AppImage"
  sha256 "a8d1e63617b270f702b8fdf35deb283b9b1bfbfec3cc1b3cf0370f5a1432b2cb"
  license "AGPL-3.0-only"

  depends_on :linux
  depends_on arch: :x86_64

  def install
    libexec.install "r-quick-share-legacy_v#{version}_glibc-2.31_amd64.AppImage" => "rquickshare.AppImage"
    chmod 0755, libexec/"rquickshare.AppImage"

    (bin/"rquickshare").write <<~SH
      #!/bin/bash
      exec "#{libexec}/rquickshare.AppImage" --appimage-extract-and-run "$@"
    SH
  end

  test do
    assert_match "Version:", shell_output("#{bin}/rquickshare --appimage-version")
  end
end
