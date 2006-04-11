xml = <<XML
<!--
Description: feed title contains relative URI resolved relative to xml:base inherited from parent element
-->
<feed xmlns="http://www.w3.org/2005/Atom" xml:base="http://example.com/test/">
  <title type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">Example <a href="test.html">test</a></div></title>
</feed>
XML

test = lambda { |feed|
	assert_equal '<div>Example <a href="http://example.com/test/test.html">test</a></div>', feed.title_detail.value
}
