module AuthHelpers
  def authWithUser (user)
    request.env['HTTP_X_ACCESS_EMAIL'] = "#{user.email}"
    request.env['HTTP_X_ACCESS_TOKEN'] = "#{user.authentication_token}"
  end

  def clearToken
    request.env['HTTP_X_ACCESS_EMAIL'] = nil
    request.env['HTTP_X_ACCESS_TOKEN'] = nil
  end
end