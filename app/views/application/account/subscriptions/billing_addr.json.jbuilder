json.(@user, :first_name, :last_name)
if @user.address
  json.(@user.address, :addr_line_1, :addr_line_2, :city, :state,
    :zip_code, :country, :phone, :phone_ext)
end