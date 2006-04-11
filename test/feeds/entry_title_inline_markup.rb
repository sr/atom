xml = <<XML
<!--
Description: entry title inline XHTML
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
  <title type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div></title>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal '<div>Example <b>Atom</b></div>', feed.entries[0].title
}
