class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed
    
    private
    
    def not_destroyed(e)
        render json: {errors: e.record.errors }, status: :unprocessable_entity
    end

    def limit(max)
        [
          params.fetch(:limit,max).to_i,
          max
        ].min
    end
end
