require 'fluent_plugin_filter_object_flatten/version'
require 'object_flatten'

module Fluent
  class ObjectFlattenFilter < Filter
    Plugin.register_filter('object_flatten', self)

    config_param :separator, :string, :default => '.'
    config_param :tr,        :array,  :default => nil

    def configure(conf)
      super
      @flatten_option = {:separator => @separator}

      if @tr
        if @tr.length != 2
          raise ConfigError, "tr: wrong length (#{@tr.length} for 2)"
        end

        @flatten_option[:tr] = @tr
      end
    end

    def filter_stream(tag, es)
      result_es = Fluent::MultiEventStream.new

      es.each do |time, record|
        ObjectFlatten.flatten(record, @flatten_option).each do |new_record|
          result_es.add(time, new_record)
        end
      end

      result_es
    rescue => e
      log.warn e.message
      log.warn e.backtrace.join(', ')
    end
  end
end
