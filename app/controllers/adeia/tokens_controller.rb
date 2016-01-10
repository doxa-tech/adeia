require_dependency "adeia/application_controller"

module Adeia
  class TokensController < ApplicationController
    load_and_authorize

    def index
      @table = TokenTable.new(self, @tokens)
      @table.respond
    end

    def new
      @token = Token.new(is_valid: true)
    end

    def create
      @token = Token.new(token_params)
      if @token.save
        redirect_to tokens_path, success: t('adeia.tokens.create.success')
      else
        render 'new'
      end
    end

    def edit
    end

    def update
      if @token.update_attributes(token_params)
        redirect_to tokens_path, success: t("adeia.tokens.update.success")
      else
        render 'edit'
      end
    end

    def destroy
      @token.destroy
      redirect_to tokens_path, success: t('adeia.tokens.destroy.success')
    end

    private

    def token_params
      params.require(:token).permit(:adeia_permission_id, :exp_at, :is_valid)
    end
  end
end
