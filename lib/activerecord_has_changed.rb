
# ActiveRecord's #atr_changed? is frustrating when it comes to nil values, so here's a replacement.
# Plus other slight shortcuts I guess... almost becoming a dsl... :P
#
# These are designed to be used in Activerecord observers, to shorten your code and make it more readable.
#
# Note: any/all versions do the same as their counterparts without that prefix,
# except they check if any one or all of multiple values pass the given test
#
module ActiverecordHasChanged

  module InstanceMethods

    # checks if all of the listed attribute_was values aren't nil
    # only works in #after_update
    def all_did_exist?(atrs)
      atrs.all? { |atr| did_exist?(atr) }
    end

    # checks if all listed attribute_was values aren't the same value as attribute values
    # only works in #after_update
    def all_have_changed?(atrs)
      atrs.all? { |atr| has_changed?(atr) }
    end

    # checks if all attribute_was values aren't the same as attribute, and the attribute_was isn't nil
    # only works in #after_update
    def all_have_changed_from_existing?(atrs)
      atrs.all? { |atr| has_changed_from_existing?(atr) }
    end

    # checks if all attribute_was values aren't the same as attribute, and the attribute isn't nil
    # only works in #after_update
    def all_have_changed_to_exist?(atrs)
      atrs.all? { |atr| has_changed_to_exist?(atr) }
    end

    # checks if all given attribute values aren't nil
    # works in #after_create, #after_update, #after_destroy, etc
    def all_now_exist?(atrs)
      atrs.all? { |atr| now_exists?(atr) }
    end

    # checks if any of the listed attribute_was values aren't nil
    # only works in #after_update
    def any_did_exist?(atrs)
      atrs.any? { |atr| did_exist?(atr) }
    end

    # checks if any listed attribute_was values aren't the same value as attribute values
    # only works in #after_update
    def any_have_changed?(atrs)
      atrs.any? { |atr| has_changed?(atr) }
    end

    # checks if any attribute_was isn't the same as attribute, and the attribute_was isn't nil
    # only works in #after_update
    def any_have_changed_from_existing?(atrs)
      atrs.any? { |atr| has_changed_from_existing?(atr) }
    end

    # checks if any attribute_was isn't the same as attribute, and the attribute isn't nil
    # only works in #after_update
    def any_have_changed_to_exist?(atrs)
      atrs.any? { |atr| has_changed_to_exist?(atr) }
    end

    # checks if any given attribute values aren't nil
    # works in #after_create, #after_update, #after_destroy, etc
    def any_now_exist?(atrs)
      atrs.any? { |atr| now_exists?(atr) }
    end

    # checks if attribute_was isn't nil
    # only works in #after_update
    def did_exist?(atr)
      ! send("#{atr}_was").nil?
    end

    # checks if attribute_was isn't the same value as attribute
    # there is an #attribute_changed? that's supposed to do this too but it doesn't work for nil values! huh?
    # only works in #after_update
    def has_changed?(atr)
      send("#{atr}_was") != send(atr)
    end

    # checks if attribute_was isn't the same value as attribute, and that attribute_was isn't nil
    # really just a shortcut for #has_changed? && #did_exist?
    # only works in #after_update
    def has_changed_from_existing?(atr)
      has_changed?(atr) && did_exist?(atr)
    end

    # checks if attribute_was isn't the same value as attribute, and that attribute isn't nil
    # really just a shortcut for #has_changed? && #now_exists?
    # only works in #after_update
    def has_changed_to_exist?(atr)
      has_changed?(atr) && now_exists?(atr)
    end

    # simply checks if the given attribute value isn't nil
    # this isn't shorter than just checking for nil, but it's nice syntactic sugar that compliments the others
    # works in #after_create, #after_update, #after_destroy, etc
    def now_exists?(atr)
      ! send(atr).nil?
    end

  end # module InstanceMethods

  def self.included(base)
    # base.class_eval    { extend  ClassMethods    }
    base.instance_eval { include InstanceMethods }
  end
  def self.extended(base)
    # base.class_eval    { extend  ClassMethods    }
    base.instance_eval { include InstanceMethods }
  end

end # module ActiverecordHasChanged

# extend activerecord with these
ActiveRecord::Base.extend ActiverecordHasChanged
