module ApplicationHelper
  ICONS = %w[add arrow-left edit moon more sun trash].freeze

  def icon_tag(name, **options)
    name = name.to_s
    raise ArgumentError, "Unknown icon: #{name}" unless ICONS.include?(name)

    classes = [ "icon", "icon--#{name}", options.delete(:class) ].compact
    options[:style] = "--icon-url: url('#{asset_path("icons/#{name}.svg")}')"
    options["aria-hidden"] = true

    tag.span(class: classes, **options)
  end
end
