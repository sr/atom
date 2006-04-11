xml = <<XML
<!--
Description: feed rights base64-encoded
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<rights type="application/octet-stream">
PHA+SGlzdG9yeSBvZiB0aGUgJmx0O2JsaW5rJmd0OyB0YWc8L3A+
</rights>
</feed>
XML

test = lambda { |feed|
	assert_equal '<p>History of the &lt;blink&gt; tag</p>', feed.rights
}
