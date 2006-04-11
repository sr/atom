xml = <<XML
<!--
Description: feed link href maps to link if rel="alternate" and type="application/xhtml+xml"
-->
<feed xmlns="http://www.w3.org/2005/Atom">
  <link rel="alternate" type="application/xhtml+xml" href="http://www.example.com/"/>
</feed>
XML

test = lambda { |feed|
	assert_equal 'http://www.example.com/', feed.link
}
