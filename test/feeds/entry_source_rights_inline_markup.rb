xml = <<XML
<!--
Description: entry source rights inline XHTML
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
<source>
  <rights type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div></rights>
</source>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal '<div>Example <b>Atom</b></div>', feed.entries[0].source.rights
}
