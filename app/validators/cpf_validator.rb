
class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    
    if record.cpf.present?
      unless cpf_checker(value)
        record.errors.add(attribute, :invalid, message: 'does not respect rules')
      end

      unless format_checker(value)
        record.errors.add(attribute, :invalid, message: 'must contain only numbers')
      end

      unless value.length
        record.errors.add(attribute, :invalid, message: 'need to have 11 numbers')
      end
    end
  end

  def format_checker(cpf)
    cpf.match? /\A\d{11}\z/
  end

  def cpf_checker(cpf)
    if ((cpf.count(cpf.chr) == 11) | (cpf == '12345678909'))
      return false
    end

    original = cpf.chars.map(&:to_i)
    computed = original[0..-3]

    2.times {|i|
      computed << make_a_digit(computed)
    }

    original[-2..-1] == computed[-2..-1]
  end

  private

  def make_a_digit(base)
    products = base.dup
      .zip((2..base.size + 1).reverse_each)
      .map {|pair_digit_weight| pair_digit_weight.inject(:*)}

    mod = products.sum % 11
    mod < 2 ? 0 : (11 - mod)
  end
end
