class Account::PasswordsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @minimum_password_length = Devise.password_length.min
  end

  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in current_user
      redirect_to user_root_path, notice: t('defaults.flash_message.updated_successfully', item: User.human_attribute_name(:password))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
