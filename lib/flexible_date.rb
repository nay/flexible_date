module FlexibleDate

  module ClassMethods
    def flexible_date_column(*args)
      options = args.extract_options!
      args.each do |column_name|
        cast_method = :"cast_#{column_name}_if_possible"
        before_validation cast_method

        define_method cast_method do
          casted_date = self.class.flexible_value_to_date(send(column_name), options)
          p "#{cast_method} casted_date = #{casted_date}"
          p "!!!!!!"
          send("#{column_name}=", casted_date) if casted_date
        end

        validation_method = :"validate_#{column_name}_is_casted"
        validate validation_method

        define_method validation_method do
          errors.add(column_name, :invalid) if send(column_name) && !send(column_name).kind_of?(Date)
        end

        define_method "#{column_name}=" do |value|
          self[column_name] = (value.kind_of?(Hash) && !value.values.any?{|t| !t.blank?}) ? nil : value
          if value.kind_of?(Hash) && !value.kind_of?(FlexibleDate::DateHash)
            class << value
              include FlexibleDate::DateHash
            end
          end
          self[column_name]
        end

        private cast_method, validation_method
      end
    end

    # options
    # * :allow_string - If true, it's used to create a Date. You can specify regular expression here.
    def flexible_value_to_date(value, options = {})
      allow_string = options[:allow_string]
      string_condition = allow_string.kind_of?(Regexp) ? allow_string : String
      case value
      when Hash
        if value[:year].blank? || value[:month].blank? || value[:day].blank?
          nil
        else
          begin
            Date.new(value[:year].to_i,value[:month].to_i, value[:day].to_i)
          rescue
            nil
          end
        end
      else
        if allow_string
          case value
          when string_condition
            begin
              Date.parse(value)
            rescue
              nil
            end
          end
        else
          nil
        end
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module DateHash
    def year
      get_integer_of :year
    end
    def month
      get_integer_of :month
    end
    def day
      get_integer_of :day
    end

    private
    def get_integer_of(key)
      self[key].blank? ? nil : self[key].to_i # This plugin also extends select_year that if this method returns nil it goes well.
    end
  end

end