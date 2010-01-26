# Changed select_year to support DateHash.
# Without this extension, middle_year will be invalid, which is used when you don't specify start_year, so on.
module ActionView
  module Helpers
    class DateTimeSelector
      def select_year_with_flexible_date
        old_datetime = @datetime
        @datetime = nil if @datetime.respond_to?(:year) && !@datetime.year
        ret = select_year_without_flexible_date
        @datetime = old_datetime
        ret
      end
      alias_method_chain :select_year, :flexible_date
    end
  end
end
