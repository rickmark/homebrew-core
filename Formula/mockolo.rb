class Mockolo < Formula
  desc "Efficient Mock Generator for Swift"
  homepage "https://github.com/uber/mockolo"
  url "https://github.com/uber/mockolo/archive/1.2.1.tar.gz"
  sha256 "6d954451660ce898fd4478d0c6a9f2abe8ff44d0cf99e459914d95dca098af13"

  bottle do
    cellar :any_skip_relocation
    sha256 "97ec13b016f5323decafb8c8d7e0198a2dbf49d099638f8664306b133b225bb9" => :catalina
    sha256 "d7fa6d2386c4592e212eb26ee674e582e716e82113408a5ecf5335ce3a22fa07" => :mojave
  end

  depends_on :xcode => ["11.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/mockolo"
  end

  test do
    (testpath/"testfile.swift").write("
    /// @mockable
    public protocol Foo {
        var num: Int { get set }
        func bar(arg: Float) -> String
    }")
    system "#{bin}/mockolo", "-srcs", testpath/"testfile.swift", "-d", testpath/"GeneratedMocks.swift"
    assert_predicate testpath/"GeneratedMocks.swift", :exist?
    assert_equal "
    ///
    /// @Generated by Mockolo
    ///
    public class FooMock: Foo {
      public init() { }
      public init(num: Int = 0) {
          self.num = num
      }

      public var numSetCallCount = 0
      public var num: Int = 0 { didSet { numSetCallCount += 1 } }

      public var barCallCount = 0
      public var barHandler: ((Float) -> (String))?
      public func bar(arg: Float) -> String {
          barCallCount += 1
          if let barHandler = barHandler {
              return barHandler(arg)
          }
          return \"\"
      }
    }".gsub(/\s+/, "").strip, shell_output("cat #{testpath/"GeneratedMocks.swift"}").gsub(/\s+/, "").strip
  end
end
