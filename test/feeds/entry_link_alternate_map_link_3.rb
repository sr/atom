xml = <<XML
<!--
Description: entry link href maps to link if rel="alternate", even if type is not present
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
    <link rel="alternate" href="http://www.example.com/alternate"></link>
    <link rel="related" type="text/html" href="http://www.example.com/related"></link>
    <link rel="via" type="text/html" href="http://www.example.com/via"></link>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal 'http://www.example.com/alternate', feed.entries[0].link
}
