class Account::ExitsController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def destroy
    current_user.destroy
    redirect_to root_path, notice: t("defaults.flash_message.notice.destroy_successfully", item: t("helpers.label.account")) + t("defaults.flash_message.greeting.hope_to_see_you_again")
  end
end
