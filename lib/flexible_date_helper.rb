module FlexibleDateHelper

  module Builder
    def flexible_date_select(method, options={}, html_options={})
      @template.select_date(object.send(method) , {:prefix => "#{@object_name}[#{method}]"}.merge(options), html_options)
    end
  end

end