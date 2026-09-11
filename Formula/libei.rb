class Libei < Formula
  include Language::Python::Virtualenv

  desc "Library for Emulated Input (EI/EIS) and the oeffis DBus portal helper"
  homepage "https://gitlab.freedesktop.org/libinput/libei"
  url "https://gitlab.freedesktop.org/libinput/libei/-/archive/1.6.0/libei-1.6.0.tar.gz"
  sha256 "81b4b967f0e5938492434a04f7ea2e6c6d96d3e6c44700bc691821f82281e602"
  license "MIT"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "libxml2" => :build # provides xmllint, used by the protocol build step

  depends_on "dbus"
  depends_on "libevdev"
  depends_on "libxkbcommon"
  depends_on "protobuf"
  depends_on "protobuf-c"
  depends_on "systemd"

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  def install
    # Build-only venv so meson's `python3 (jinja2)` check succeeds. Not
    # installed into the final keg — nothing in the runtime needs Python.
    venv = virtualenv_create(buildpath/"build-venv", "python3.13")
    venv.pip_install resources
    ENV.prepend_path "PATH", buildpath/"build-venv/bin"

    system "meson", "setup", "build",
                     "-Dsd-bus-provider=libsystemd",
                     "-Ddocumentation=[]",
                     "-Dtests=disabled",
                     *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    system "pkgconf", "--exists", "libei-1.0"
    system "pkgconf", "--exists", "liboeffis-1.0"
  end
end
