module ApplicationHelper
  def classes_for_flash(key)
    case key.to_s
    when "alert"
      "mb-6 bg-red-50 border border-red-200 text-red-800"
    when "notice"
      "mb-6 bg-green-50 border border-green-200 text-green-800"
    else
    end
  end
end
