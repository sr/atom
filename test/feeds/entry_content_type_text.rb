xml = <<XML
<!--
Description: entry content type='text'
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
  <content type="text">Example Atom</content>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal 'text/plain', feed.entries[0].content.type
}
