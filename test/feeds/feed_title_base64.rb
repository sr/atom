xml = <<XML
<!--
Description: feed title base64-encoded
-->
<feed xmlns="http://www.w3.org/2005/Atom">
  <title type="application/octet-stream">
    RXhhbXBsZSA8Yj5BdG9tPC9iPg==
  </title>
</feed>
XML

test = lambda { |feed|
	assert_equal 'Example <b>Atom</b>', feed.title
}
