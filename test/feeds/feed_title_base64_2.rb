xml = <<XML
<!--
Description: feed title base64-encoded
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<title type="application/octet-stream">
PHA+SGlzdG9yeSBvZiB0aGUgJmx0O2JsaW5rJmd0OyB0YWc8L3A+
</title>
</feed>
XML

test = lambda { |feed|
	assert_equal '<p>History of the &lt;blink&gt; tag</p>', feed.title
}
