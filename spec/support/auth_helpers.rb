module AuthHelpers
  def authWithUser (user)
    request.headers['X-ACCESS-EMAIL'] = "#{user.email}"
    request.headers['X-ACCESS-TOKEN'] = "#{user.authentication_token}"
  end

  def clearToken
    request.headers['X-ACCESS-EMAIL'] = nil
    request.headers['X-ACCESS-TOKEN'] = nil
  end
end