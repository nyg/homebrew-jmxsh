class Jmxsh < Formula
  desc "Interactive command-line JMX client (fork of JMXTerm)"
  homepage "https://github.com/nyg/jmxsh"
  url "https://github.com/nyg/jmxsh/releases/download/v1.2.0/jmxsh-1.2.0.jar"
  sha256 "96350783ac873f718ea1fe129cc848ef2855cdc2f4fbd3845ac067f2d70fb7eb"
  license "Apache-2.0"

  # jmxsh requires Java 25 (adjust if the project changes this)
  depends_on "openjdk@25"

  def install
    # Install the JAR to libexec (private location)
    libexec.install "jmxsh-#{version}.jar"

    # Create a wrapper script in bin/ that calls java -jar
    bin.write_jar_script libexec/"jmxsh-#{version}.jar", "jmxsh"
  end

  test do
    # Simple test — adjust command if your JAR has a different help/version flag
    assert_match "jmxsh", shell_output("#{bin}/jmxsh --help", 1)
  end
end
