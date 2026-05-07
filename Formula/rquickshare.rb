class Rquickshare < Formula
  desc "Nearby Share/Quick Share client for Linux"
  homepage "https://github.com/Martichou/rquickshare"
  url "https://github.com/Martichou/rquickshare/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "6a82d63412703aa42c343619806cc0dec28ffcf164fb04c5b0bfd17b22257af3"
  license "AGPL-3.0-only"

  depends_on :linux
  depends_on arch: :x86_64

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "dbus"
  depends_on "gtk+3"
  depends_on "libayatana-appindicator"
  depends_on "librsvg"
  depends_on "libsoup"
  depends_on "webkitgtk"

  def install
    cd "app/legacy" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "vite:build"
    end

    cd "app/legacy/src-tauri" do
      system "cargo", "install", *std_cargo_args(path: ".")
    end
  end

  test do
    assert_predicate bin/"rquickshare", :executable?
  end
end
