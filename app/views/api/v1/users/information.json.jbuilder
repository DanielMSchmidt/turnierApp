json.(@user, :id, :name, :email, :startclass, :clubs)
json.partner @user.partner.to_builder
json.startclass_goals @startclass_goals