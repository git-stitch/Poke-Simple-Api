class Api::V1::RegionsController < ApplicationController
    def index 
        @regions = Region.all

        render json: {
            results: @regions
        }
    end

    
end
