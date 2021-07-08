class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEXP = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i.freeze

  def validate_each(record, attribute, value)
    unless value =~ EMAIL_REGEXP
      record.errors.add attribute, (options[:message] || "is not an email")
    end
  end
end
