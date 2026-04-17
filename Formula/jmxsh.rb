class Jmxsh < Formula
  desc "Command-line JMX client for monitoring and managing Java applications"
  homepage "https://github.com/nyg/jmxsh"
  url "https://github.com/nyg/jmxsh/releases/download/v1.3.0/jmxsh-1.3.0.jar"
  sha256 "ecc488a09a82aa22e7bf6b53d6ae9359db7a1d27987be5d57fc2ae360a399c74"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/nyg/homebrew-jmxsh/releases/download/jmxsh-1.2.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d0de319b83ef5bca41541ecc33705f0199c1fff0317e489c24447c152b9e0c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8eba6ba5db60e9c9d46866888e802bf306bbc8ef7d00feff2ac7cd1b8a5d4d2d"
  end

  depends_on "openjdk@25"

  def install
    libexec.install "jmxsh-#{version}.jar"
    bin.write_jar_script libexec/"jmxsh-#{version}.jar", "jmxsh"
  end

  test do
    assert_match "jmxsh #{version}", shell_output("#{bin}/jmxsh --version")
  end
end
