class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3160000.zip"
  version "3.16.0"
  sha256 "9aa6c30e350e3f9729ea56a63b5ec7eb7e5cd63ca63b34fa6784b7800ce25ad0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e74310c7ff501dc3c11ae639ff4bd577f514b862a91c95a08ff65158ad7ad25" => :sierra
    sha256 "94ff78f667cc9785f8f1581b6d2dde1c80bcb5ace61e169e227f482a0f97eb50" => :el_capitan
    sha256 "33c557d1f790efa64b5e7428bcbac4748449e7aee37bf0a9d0f4da8218c54b5d" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
