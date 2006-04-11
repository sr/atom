xml = <<XML
<!--
Description: entry link rel='enclosure'
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
  <link rel="enclosure" type="text/html" href="http://www.example.com/"/>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal 'enclosure', feed.entries[0].links[0].rel
}
