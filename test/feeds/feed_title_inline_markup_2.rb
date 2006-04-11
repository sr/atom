xml = <<XML
<!--
Description: feed title inline XHTML with escaped markup
-->
<feed xmlns="http://www.w3.org/2005/Atom">
  <title type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink&gt; tag</div></title>
</feed>
XML

test = lambda { |feed|
	assert_equal '<div>History of the &lt;blink&gt; tag</div>', feed.title
}
