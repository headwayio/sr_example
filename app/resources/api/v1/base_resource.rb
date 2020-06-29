module Api
  module V1
    class BaseResource < JSONAPI::Resource
      abstract

      def self.records(options = {})
        context = options[:context]
        results = _model_class.accessible_by(Ability.new(context[:current_user]))
        if _model_class.column_names.include?('user_id')
          results = results.where(user_id: context[:current_user].id)
        end

        if options[:includes]
          results.includes(options[:includes])
        end
        results
      end

      def records_for(relation_name, options = {})
        records = _model.public_send(relation_name).accessible_by(Ability.new(context[:current_user]))
        if _model.public_send(relation_name).column_names.include?('user_id')
          records = records.where("#{relation_name}.user_id": context[:current_user].id)
        end
        records
      end
    end
  end
end
