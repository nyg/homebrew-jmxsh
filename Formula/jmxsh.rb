class Jmxsh < Formula
  desc "Command-line JMX client for monitoring and managing Java applications"
  homepage "https://github.com/nyg/jmxsh"
  url "https://github.com/nyg/jmxsh/releases/download/v1.2.2/jmxsh-1.2.2.jar"
  sha256 "64b6b2c359d9081b770871f8274bed0534dc70385c1da97910f7b1b93cf0298a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
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
