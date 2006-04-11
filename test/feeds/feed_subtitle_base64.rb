xml = <<XML
<!--
Description: feed subtitle base64-encoded
-->
<feed xmlns="http://www.w3.org/2005/Atom">
  <subtitle type="application/octet-stream">
    RXhhbXBsZSA8Yj5BdG9tPC9iPg==
  </subtitle>
</feed>
XML

test = lambda { |feed|
	assert_equal 'Example <b>Atom</b>', feed.subtitle
}
