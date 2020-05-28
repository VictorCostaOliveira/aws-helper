module ApplicationHelper

  def active?(page)
    return 'active' if current_page?(page)
  end

end
