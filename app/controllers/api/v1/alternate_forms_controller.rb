class Api::V1::AlternateFormsController < ApplicationController
    def index
        @alternate_forms = AlternateForm.all

        ### Do we offset or limit?
        if params[:limit] && params[:offset]
            @alternate_forms = @alternate_forms[params[:offset].to_i..params[:limit].to_i]
        elsif params[:limit]
            @alternate_forms = @alternate_forms[0...params[:limit].to_i]
        elsif params[:offset]
            @alternate_forms = @alternate_forms[params[:offset].to_i..-1]
        end
        @count = @alternate_forms.length

        render json: {
            count: @count, 
            results: @alternate_forms
        }
    end

    def show
        @alternate_forms = find_alternate_forms

        if @alternate_forms
          render json: {
              results: @alternate_forms, 
              status: :accepted} 
        else
          render json: { errors: "Invalid Pokemon" }, status: :unprocessible_entity
        end
    end

    private

    def find_alternate_forms
        if params[:id].to_i != 0
            @alternate_forms = AlternateForm.find(params[:id])
        else 
            @alternate_forms = AlternateForm.find_by(name:params[:id])
        end
    end
end
