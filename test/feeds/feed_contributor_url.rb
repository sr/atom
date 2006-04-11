xml = <<XML
<!--
Description: feed contributor url
-->
<feed xmlns="http://www.w3.org/2005/Atom">
  <contributor>
    <name>Example contributor</name>
    <email>me@example.com</email>
    <url>http://example.com/</url>
  </contributor>
</feed>
XML

test = lambda { |feed|
	assert_equal 'http://example.com/', feed.contributors[0].uri
}
