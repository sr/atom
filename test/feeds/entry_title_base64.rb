xml = <<XML
<!--
Description: entry title base64-encoded
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
  <title type="application/octet-stream">
    RXhhbXBsZSA8Yj5BdG9tPC9iPg==
  </title>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal 'Example <b>Atom</b>', feed.entries[0].title
}
