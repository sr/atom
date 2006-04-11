xml = <<XML
<!--
Description: feed rights base64-encoded
-->
<feed xmlns="http://www.w3.org/2005/Atom">
  <rights type="application/octet-stream">
    RXhhbXBsZSA8Yj5BdG9tPC9iPg==
  </rights>
</feed>
XML

test = lambda { |feed|
	assert_equal 'Example <b>Atom</b>', feed.rights
}
