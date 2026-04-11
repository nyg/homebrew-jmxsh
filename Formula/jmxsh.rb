class Jmxsh < Formula
  desc "Command-line JMX client for monitoring and managing Java applications"
  homepage "https://github.com/nyg/jmxsh"
  url "https://github.com/nyg/jmxsh/releases/download/v1.2.3/jmxsh-1.2.3.jar"
  sha256 "da7a582c06728feb2f01e9efdddcc045da57c22b6c738c07215369ba1fbcb781"
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
    assert_match "[USAGE]", shell_output("#{bin}/jmxsh --help")
  end
end
