xml = <<XML
<!--
Description: entry summary base64-encoded
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
  <summary type="application/octet-stream">
    RXhhbXBsZSA8Yj5BdG9tPC9iPg==
  </summary>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal 'Example <b>Atom</b>', feed.entries[0].summary
}
