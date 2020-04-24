class Libirecovery < Formula
  desc "Library to communicate with iDevices restore and recovery"
  homepage "https://www.libimobiledevice.org/"

  stable do
    url "https://github.com/libimobiledevice/libirecovery/archive/0.1.1.tar.gz"
    sha256 "81aab17730ebbbe598f91e8dd4249b76c1f0d6782c60061e59d3c52637b5305c"
  end

  head do
    url "https://git.libimobiledevice.org/libirecovery.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libxml2"
  end

  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libtasn1"
  depends_on "libusbmuxd"
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "irecovery", "-h"
  end
end
