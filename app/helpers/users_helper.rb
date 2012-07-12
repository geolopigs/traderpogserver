module UsersHelper

  def UsersHelper.validate_secretkey(user_id, key)
    begin
      @user = User.find(user_id)
      @user.secretkey.eql?(key)
    rescue
      false
    end
  end

end
