require 'helper'

class TestSlimCodeEscaping < TestSlim
  def test_escaping_evil_method
    source = %q{
p = evil_method
}

    assert_html '<p>&lt;script&gt;do_something_evil();&lt;&#47;script&gt;</p>', source
  end

  def test_escape_interpolation
    source = %q{
p \\#{hello_world}
}

    assert_html '<p>#{hello_world}</p>', source
  end

  def test_render_without_html_safe
    source = %q{
p = "<strong>Hello World\\n, meet \\"Slim\\"</strong>."
}

    assert_html "<p>&lt;strong&gt;Hello World\n, meet \&quot;Slim\&quot;&lt;&#47;strong&gt;.</p>", source
  end

  def test_render_with_html_safe_false
    source = %q{
p = HtmlUnsafeString.new("<strong>Hello World\\n, meet \\"Slim\\"</strong>.")
}

    assert_html "<p>&lt;strong&gt;Hello World\n, meet \&quot;Slim\&quot;&lt;&#47;strong&gt;.</p>", source, :use_html_safe => true
  end

  def test_render_with_html_safe_true
    source = %q{
p = HtmlSafeString.new("<strong>Hello World\\n, meet \\"Slim\\"</strong>.")
}

    assert_html "<p><strong>Hello World\n, meet \"Slim\"</strong>.</p>", source, :use_html_safe => true
  end

  def test_render_with_global_html_safe_false
    Temple::Filters::EscapeHTML.default_options[:use_html_safe] = false

    source = %q{
p = HtmlUnsafeString.new("<strong>Hello World\\n, meet \\"Slim\\"</strong>.")
}

    assert_html "<p>&lt;strong&gt;Hello World\n, meet \&quot;Slim\&quot;&lt;&#47;strong&gt;.</p>", source
  end

  def test_render_with_global_html_safe_true
    Temple::Filters::EscapeHTML.default_options[:use_html_safe] = true

    source = %q{
p = HtmlSafeString.new("<strong>Hello World\\n, meet \\"Slim\\"</strong>.")
}

    assert_html "<p><strong>Hello World\n, meet \"Slim\"</strong>.</p>", source
  end
end
