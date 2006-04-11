xml = <<XML
<!--
Description: entry summary base64-encoded
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
<summary type="application/octet-stream">
PHA+SGlzdG9yeSBvZiB0aGUgJmx0O2JsaW5rJmd0OyB0YWc8L3A+
</summary>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal '<p>History of the &lt;blink&gt; tag</p>', feed.entries[0].summary
}
