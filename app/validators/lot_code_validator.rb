class LotCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    presence = record.send(attribute).present?

    unless presence && check_letters(value)
      record.errors.add(attribute, :three_letters)
    end
    unless presence && check_numbers(value)
      record.errors.add(attribute, :three_numbers)
    end
    unless presence && value.length == 6
      record.errors.add(attribute, :wrong_length, size: 6)
    end
  end

  def check_letters(value)
    value.scan(/\d/).count == 3
  end

  def check_numbers(value)
    value.scan(/\p{L}/).count == 3
  end
end
