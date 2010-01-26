require File.dirname(__FILE__) + "/lib/flexible_date"
require File.dirname(__FILE__) + "/lib/flexible_date_helper"
require File.dirname(__FILE__) + "/lib/extend_select_year"
ActiveRecord::Base.instance_eval{ include FlexibleDate }
# You might need to include FlexibleDateHelper::Builder to your custom form builder.
ActionView::Helpers::FormBuilder.instance_eval { include FlexibleDateHelper::Builder}