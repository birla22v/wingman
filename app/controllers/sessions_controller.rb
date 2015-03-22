 class SessionsController < Devise::SessionsController

   def create
     self.resource = warden.authenticate(auth_options)
     if self.resource
       sign_in(resource_name, resource, store: false)
       render json: {:user => current_user, :authentication_token => current_user.authentication_token}, status: :ok
     else
       render json: {:error => "Authentication Failure!"}, status: :unauthenticated
     end
   end

 end
