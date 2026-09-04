require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "renders a known icon as decorative content" do
    icon = icon_tag("add")

    assert_includes icon, 'class="icon icon--add"'
    assert_includes icon, 'aria-hidden="true"'
    assert_includes icon, "icons/add.svg"
  end

  test "rejects unknown icons" do
    assert_raises(ArgumentError) { icon_tag("unknown") }
  end
end
