class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.10.1/mlr-5.10.1.tar.gz"
  sha256 "ae1aac9b1201455d9321fb3fb19889d1dd96516ee7f295d29961543dc49b0a85"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6549e28916d341df56a77990fdd06aa3120821447d12614e233b60b6019b4343"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b19f1751ba3d39d94c371443583a2fd53b035e93c4ffdd8432e6c978ba43601"
    sha256 cellar: :any_skip_relocation, catalina:      "d806164692bbe7077e28e8deb819c24ab3e7ba0794ffa6073654e54d32538649"
    sha256 cellar: :any_skip_relocation, mojave:        "bceb6b1ff93c9bb4b11a38af1ce4b4c06f3a572e06f0f8132a9b0799a1caa3e3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  def install
    # Profiling build fails with Xcode 11, remove it
    inreplace "c/Makefile.am", /noinst_PROGRAMS=\s*mlrg/, ""
    system "autoreconf", "-fvi"

    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
