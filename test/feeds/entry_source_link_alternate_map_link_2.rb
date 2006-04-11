xml = <<XML
<!--
Description: entry source link href maps to link if rel="alternate" and type="application/xhtml+xml"
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
<source>
  <link rel="alternate" type="application/xhtml+xml" href="http://www.example.com/"/>
</source>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal 'http://www.example.com/', feed.entries[0].source.link
}
