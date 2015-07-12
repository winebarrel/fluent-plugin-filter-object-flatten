require 'fluent_plugin_filter_object_flatten/version'
require 'object_flatten'

module Fluent
  class ObjectFlattenFilter < Filter
    Plugin.register_filter('object_flatten', self)

    config_param :separator, :string, :default => '.'
    config_param :tr,        :array,  :default => []

    def filter_stream(tag, es)
      result_es = Fluent::MultiEventStream.new

      es.each do |time, record|
        ObjectFlatten.flatten(record, @separator).each do |new_record|
          unless @tr.empty?
            new_record_with_tr = {}

            new_record.each do |key, value|
              key = key.tr(*@tr)
              new_record_with_tr[key] = value
            end

            new_record = new_record_with_tr
          end

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
