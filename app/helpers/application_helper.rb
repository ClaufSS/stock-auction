module ApplicationHelper
  def field_errors_msgs(model_instance, attribute)
    throw :abort unless model_instance.is_a? ActiveRecord::Base

    model = model_instance.class
    errors_msgs = model_instance.errors.full_messages_for attribute

    content_tag :div, errors_msgs.reduce(&:+), class: 'errors'
  end
end
