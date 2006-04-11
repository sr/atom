xml = <<XML
<!--
Description: entry link rel='enclosure'
-->
<feed xmlns="http://www.w3.org/2005/Atom">
<entry>
  <link rel="enclosure" type="video/mpeg4" href="http://www.example.com/movie.mp4"/>
</entry>
</feed>
XML

test = lambda { |feed|
	assert_equal 'video/mpeg4', feed.entries[0].enclosures[0].type
}
