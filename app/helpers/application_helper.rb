module ApplicationHelper
  def flash_class(key)
    {
      notice: "alert-success",
      alert: "alert-error",
      info: "alert-info",
      warning: "alert-warning"
    }.stringify_keys[key.to_s] || ""
  end
end
