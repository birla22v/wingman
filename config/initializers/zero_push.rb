if Rails.env.production?
  ZeroPush.auth_token = 'prod_rAUfBRVAD7YxiGxZarBq'
else
  ZeroPush.auth_token = 'dev_u53WzNcQx1vGKHqsk3yU'
end
