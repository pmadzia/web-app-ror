module ApplicationHelper
  def field_class(model, attribute)
    model.errors[attribute].any? ? "form-control is-invalid" : "form-control"
  end
end
