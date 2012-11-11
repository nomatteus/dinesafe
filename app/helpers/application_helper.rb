module ApplicationHelper

  def to_class_name(text)
    return text.downcase.gsub(%r{\s+}, '-')
  end

end
